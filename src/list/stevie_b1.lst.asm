XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.1638280
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 201027-1638280
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
0009               * File: equates.equ                 ; Version 201027-1638280
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
0154      A018     tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
0155      A01A     tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
0156      A01C     tv.task.oneshot   equ  tv.top + 28     ; Pointer to one-shot routine
0157      A01E     tv.error.visible  equ  tv.top + 30     ; Error pane visible
0158      A020     tv.error.msg      equ  tv.top + 32     ; Error message (max. 160 characters)
0159      A0C0     tv.free           equ  tv.top + 192    ; End of structure
0160               *--------------------------------------------------------------
0161               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0162               *--------------------------------------------------------------
0163      A100     fb.struct         equ  >a100           ; Structure begin
0164      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0165      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0166      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0167                                                      ; line X in editor buffer).
0168      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0169                                                      ; (offset 0 .. @fb.scrrows)
0170      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0171      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0172      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0173      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0174      A110     fb.free1          equ  fb.struct + 16  ; **** free ****
0175      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0176      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0177      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0178      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0179      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0180      A11C     fb.free           equ  fb.struct + 28  ; End of structure
0181               *--------------------------------------------------------------
0182               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0183               *--------------------------------------------------------------
0184      A200     edb.struct        equ  >a200           ; Begin structure
0185      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0186      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0187      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0188      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0189      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0190      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0191      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0192      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0193                                                      ; with current filename.
0194      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0195                                                      ; with current file type.
0196      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0197      A214     edb.sams.hipage   equ  edb.struct + 20 ; Highest SAMS page in use
0198      A216     edb.free          equ  edb.struct + 22 ; End of structure
0199               *--------------------------------------------------------------
0200               * Command buffer structure            @>a300-a3ff   (256 bytes)
0201               *--------------------------------------------------------------
0202      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0203      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0204      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0205      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0206      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0207      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0208      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0209      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0210      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0211      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0212      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0213      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0214      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0215      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0216      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0217      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
0218      A31E     cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
0219      A320     cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
0220      A322     cmdb.action.ptr   equ  cmdb.struct + 34; Pointer to function to execute
0221      A324     cmdb.cmdlen       equ  cmdb.struct + 36; Length of current command (MSB byte!)
0222      A325     cmdb.cmd          equ  cmdb.struct + 37; Current command (80 bytes max.)
0223      A375     cmdb.free         equ  cmdb.struct +117; End of structure
0224               *--------------------------------------------------------------
0225               * File handle structure               @>a400-a4ff   (256 bytes)
0226               *--------------------------------------------------------------
0227      A400     fh.struct         equ  >a400           ; stevie file handling structures
0228               ;***********************************************************************
0229               ; ATTENTION
0230               ; The dsrlnk variables must form a continuous memory block and keep
0231               ; their order!
0232               ;***********************************************************************
0233      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0234      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0235      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0236      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0237      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0238      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0239      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0240      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0241      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0242      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0243      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0244      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0245      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0246      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0247      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0248      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0249      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0250      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0251      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0252      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0253      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0254      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0255      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0256      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0257      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0258      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0259      A458     fh.kilobytes.prev equ  fh.struct + 88  ; Kilobytes processed (previous)
0260      A45A     fh.membuffer      equ  fh.struct + 90  ; 80 bytes file memory buffer
0261      A4AA     fh.free           equ  fh.struct +170  ; End of structure
0262      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0263      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0264               *--------------------------------------------------------------
0265               * Index structure                     @>a500-a5ff   (256 bytes)
0266               *--------------------------------------------------------------
0267      A500     idx.struct        equ  >a500           ; stevie index structure
0268      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0269      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0270      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0271               *--------------------------------------------------------------
0272               * Frame buffer                        @>a600-afff  (2560 bytes)
0273               *--------------------------------------------------------------
0274      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0275      0960     fb.size           equ  80*30           ; Frame buffer size
0276               *--------------------------------------------------------------
0277               * Index                               @>b000-bfff  (4096 bytes)
0278               *--------------------------------------------------------------
0279      B000     idx.top           equ  >b000           ; Top of index
0280      1000     idx.size          equ  4096            ; Index size
0281               *--------------------------------------------------------------
0282               * Editor buffer                       @>c000-cfff  (4096 bytes)
0283               *--------------------------------------------------------------
0284      C000     edb.top           equ  >c000           ; Editor buffer high memory
0285      1000     edb.size          equ  4096            ; Editor buffer size
0286               *--------------------------------------------------------------
0287               * Command history buffer              @>d000-dfff  (4096 bytes)
0288               *--------------------------------------------------------------
0289      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0290      1000     cmdb.size         equ  4096            ; Command buffer size
0291               *--------------------------------------------------------------
0292               * Heap                                @>e000-efff  (4096 bytes)
0293               *--------------------------------------------------------------
0294      E000     heap.top          equ  >e000           ; Top of heap
**** **** ****     > stevie_b1.asm.1638280
0012               
0013               ***************************************************************
0014               * Spectra2 core configuration
0015               ********|*****|*********************|**************************
0016      3000     sp2.stktop    equ >3000             ; Top of SP2 stack starts at >2fff
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
0036 6015 ....             text  'STEVIE V0.1B'
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
     208E 2E16 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2092 2304 
0078 2094 21F4                   data graph1           ; Equate selected video mode table
0079               
0080 2096 06A0  32         bl    @ldfnt
     2098 236C 
0081 209A 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     209C 000C 
0082               
0083 209E 06A0  32         bl    @filv
     20A0 229A 
0084 20A2 0380                   data >0380,>f0,32*24  ; Load color table
     20A4 00F0 
     20A6 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 20A8 06A0  32         bl    @putat                ; Show crash message
     20AA 244E 
0089 20AC 0000                   data >0000,cpu.crash.msg.crashed
     20AE 2182 
0090               
0091 20B0 06A0  32         bl    @puthex               ; Put hex value on screen
     20B2 299A 
0092 20B4 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20B6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20B8 2F64                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20BA 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20BC 06A0  32         bl    @putat                ; Show caller message
     20BE 244E 
0101 20C0 0100                   data >0100,cpu.crash.msg.caller
     20C2 2198 
0102               
0103 20C4 06A0  32         bl    @puthex               ; Put hex value on screen
     20C6 299A 
0104 20C8 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20CA FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20CC 2F64                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20CE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20D0 06A0  32         bl    @putat
     20D2 244E 
0113 20D4 0300                   byte 3,0
0114 20D6 21B2                   data cpu.crash.msg.wp
0115 20D8 06A0  32         bl    @putat
     20DA 244E 
0116 20DC 0400                   byte 4,0
0117 20DE 21B8                   data cpu.crash.msg.st
0118 20E0 06A0  32         bl    @putat
     20E2 244E 
0119 20E4 1600                   byte 22,0
0120 20E6 21BE                   data cpu.crash.msg.source
0121 20E8 06A0  32         bl    @putat
     20EA 244E 
0122 20EC 1700                   byte 23,0
0123 20EE 21DA                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20F0 06A0  32         bl    @at                   ; Put cursor at YX
     20F2 269E 
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
     2116 29A4 
0154 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 211A 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 211C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 211E 06A0  32         bl    @setx                 ; Set cursor X position
     2120 26B4 
0160 2122 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 2124 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2126 242A 
0164 2128 2F64                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 212A 06A0  32         bl    @setx                 ; Set cursor X position
     212C 26B4 
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
     213C 242A 
0176 213E 21AE                   data cpu.crash.msg.r
0177               
0178 2140 06A0  32         bl    @mknum
     2142 29A4 
0179 2144 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 2146 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 2148 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 214A 06A0  32         bl    @mkhex                ; Convert hex word to string
     214C 2916 
0188 214E 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2150 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2152 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 2154 06A0  32         bl    @setx                 ; Set cursor X position
     2156 26B4 
0194 2158 0006                   data 6                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 215A 06A0  32         bl    @putstr
     215C 242A 
0198 215E 21B0                   data cpu.crash.msg.marker
0199               
0200 2160 06A0  32         bl    @setx                 ; Set cursor X position
     2162 26B4 
0201 2164 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 2166 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2168 242A 
0205 216A 2F64                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 216C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 216E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2170 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2172 06A0  32         bl    @down                 ; y=y+1
     2174 26A4 
0213               
0214 2176 0586  14         inc   tmp2
0215 2178 0286  22         ci    tmp2,17
     217A 0011 
0216 217C 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 217E 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2180 2D14 
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
0259 21DA 1842             byte  24
0260 21DB ....             text  'Build-ID  201027-1638280'
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
0007 21F4 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21F6 000E 
     21F8 0106 
     21FA 0204 
     21FC 0020 
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
0032 21FE 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     2200 000E 
     2202 0106 
     2204 00F4 
     2206 0028 
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
0058 2208 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220A 003F 
     220C 0240 
     220E 03F4 
     2210 0050 
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
0084 2212 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2214 003F 
     2216 0240 
     2218 03F4 
     221A 0050 
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
0013 221C 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 221E 16FD             data  >16fd                 ; |         jne   mcloop
0015 2220 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2222 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2224 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 2226 0201  20         li    r1,mccode             ; Machinecode to patch
     2228 221C 
0037 222A 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     222C 8322 
0038 222E CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2230 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2232 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 2234 045B  20         b     *r11                  ; Return to caller
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
0056 2236 C0F9  30 popr3   mov   *stack+,r3
0057 2238 C0B9  30 popr2   mov   *stack+,r2
0058 223A C079  30 popr1   mov   *stack+,r1
0059 223C C039  30 popr0   mov   *stack+,r0
0060 223E C2F9  30 poprt   mov   *stack+,r11
0061 2240 045B  20         b     *r11
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
0085 2242 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 2244 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 2246 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Sanity check
0090               *--------------------------------------------------------------
0091 2248 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 224A 1604  14         jne   filchk                ; No, continue checking
0093               
0094 224C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     224E FFCE 
0095 2250 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2252 2030 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 2254 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     2256 830B 
     2258 830A 
0100               
0101 225A 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     225C 0001 
0102 225E 1602  14         jne   filchk2
0103 2260 DD05  32         movb  tmp1,*tmp0+
0104 2262 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 2264 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     2266 0002 
0109 2268 1603  14         jne   filchk3
0110 226A DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 226C DD05  32         movb  tmp1,*tmp0+
0112 226E 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2270 C1C4  18 filchk3 mov   tmp0,tmp3
0117 2272 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2274 0001 
0118 2276 1605  14         jne   fil16b
0119 2278 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 227A 0606  14         dec   tmp2
0121 227C 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     227E 0002 
0122 2280 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2282 C1C6  18 fil16b  mov   tmp2,tmp3
0127 2284 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2286 0001 
0128 2288 1301  14         jeq   dofill
0129 228A 0606  14         dec   tmp2                  ; Make TMP2 even
0130 228C CD05  34 dofill  mov   tmp1,*tmp0+
0131 228E 0646  14         dect  tmp2
0132 2290 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2292 C1C7  18         mov   tmp3,tmp3
0137 2294 1301  14         jeq   fil.exit
0138 2296 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 2298 045B  20         b     *r11
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
0159 229A C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 229C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 229E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 22A0 0264  22 xfilv   ori   tmp0,>4000
     22A2 4000 
0166 22A4 06C4  14         swpb  tmp0
0167 22A6 D804  38         movb  tmp0,@vdpa
     22A8 8C02 
0168 22AA 06C4  14         swpb  tmp0
0169 22AC D804  38         movb  tmp0,@vdpa
     22AE 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22B0 020F  20         li    r15,vdpw              ; Set VDP write address
     22B2 8C00 
0174 22B4 06C5  14         swpb  tmp1
0175 22B6 C820  54         mov   @filzz,@mcloop        ; Setup move command
     22B8 22C0 
     22BA 8320 
0176 22BC 0460  28         b     @mcloop               ; Write data to VDP
     22BE 8320 
0177               *--------------------------------------------------------------
0181 22C0 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22C2 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22C4 4000 
0202 22C6 06C4  14 vdra    swpb  tmp0
0203 22C8 D804  38         movb  tmp0,@vdpa
     22CA 8C02 
0204 22CC 06C4  14         swpb  tmp0
0205 22CE D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22D0 8C02 
0206 22D2 045B  20         b     *r11                  ; Exit
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
0217 22D4 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22D6 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22D8 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22DA 4000 
0223 22DC 06C4  14         swpb  tmp0                  ; \
0224 22DE D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22E0 8C02 
0225 22E2 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22E4 D804  38         movb  tmp0,@vdpa            ; /
     22E6 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22E8 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22EA D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22EC 045B  20         b     *r11                  ; Exit
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
0251 22EE C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22F0 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22F2 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22F4 8C02 
0257 22F6 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22F8 D804  38         movb  tmp0,@vdpa            ; /
     22FA 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22FC D120  34         movb  @vdpr,tmp0            ; Read byte
     22FE 8800 
0263 2300 0984  56         srl   tmp0,8                ; Right align
0264 2302 045B  20         b     *r11                  ; Exit
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
0283 2304 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 2306 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 2308 C144  18         mov   tmp0,tmp1
0289 230A 05C5  14         inct  tmp1
0290 230C D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 230E 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2310 FF00 
0292 2312 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 2314 C805  38         mov   tmp1,@wbase           ; Store calculated base
     2316 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 2318 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     231A 8000 
0298 231C 0206  20         li    tmp2,8
     231E 0008 
0299 2320 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2322 830B 
0300 2324 06C5  14         swpb  tmp1
0301 2326 D805  38         movb  tmp1,@vdpa
     2328 8C02 
0302 232A 06C5  14         swpb  tmp1
0303 232C D805  38         movb  tmp1,@vdpa
     232E 8C02 
0304 2330 0225  22         ai    tmp1,>0100
     2332 0100 
0305 2334 0606  14         dec   tmp2
0306 2336 16F4  14         jne   vidta1                ; Next register
0307 2338 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     233A 833A 
0308 233C 045B  20         b     *r11
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
0325 233E C13B  30 putvr   mov   *r11+,tmp0
0326 2340 0264  22 putvrx  ori   tmp0,>8000
     2342 8000 
0327 2344 06C4  14         swpb  tmp0
0328 2346 D804  38         movb  tmp0,@vdpa
     2348 8C02 
0329 234A 06C4  14         swpb  tmp0
0330 234C D804  38         movb  tmp0,@vdpa
     234E 8C02 
0331 2350 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2352 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 2354 C10E  18         mov   r14,tmp0
0341 2356 0984  56         srl   tmp0,8
0342 2358 06A0  32         bl    @putvrx               ; Write VR#0
     235A 2340 
0343 235C 0204  20         li    tmp0,>0100
     235E 0100 
0344 2360 D820  54         movb  @r14lb,@tmp0lb
     2362 831D 
     2364 8309 
0345 2366 06A0  32         bl    @putvrx               ; Write VR#1
     2368 2340 
0346 236A 0458  20         b     *tmp4                 ; Exit
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
0360 236C C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 236E 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2370 C11B  26         mov   *r11,tmp0             ; Get P0
0363 2372 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2374 7FFF 
0364 2376 2120  38         coc   @wbit0,tmp0
     2378 202A 
0365 237A 1604  14         jne   ldfnt1
0366 237C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     237E 8000 
0367 2380 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2382 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 2384 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     2386 23EE 
0372 2388 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     238A 9C02 
0373 238C 06C4  14         swpb  tmp0
0374 238E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2390 9C02 
0375 2392 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2394 9800 
0376 2396 06C5  14         swpb  tmp1
0377 2398 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     239A 9800 
0378 239C 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 239E D805  38         movb  tmp1,@grmwa
     23A0 9C02 
0383 23A2 06C5  14         swpb  tmp1
0384 23A4 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     23A6 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23A8 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23AA 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23AC 22C2 
0390 23AE 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23B0 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23B2 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23B4 7FFF 
0393 23B6 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23B8 23F0 
0394 23BA C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23BC 23F2 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23BE 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23C0 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23C2 D120  34         movb  @grmrd,tmp0
     23C4 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23C6 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23C8 202A 
0405 23CA 1603  14         jne   ldfnt3                ; No, so skip
0406 23CC D1C4  18         movb  tmp0,tmp3
0407 23CE 0917  56         srl   tmp3,1
0408 23D0 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23D2 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23D4 8C00 
0413 23D6 0606  14         dec   tmp2
0414 23D8 16F2  14         jne   ldfnt2
0415 23DA 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23DC 020F  20         li    r15,vdpw              ; Set VDP write address
     23DE 8C00 
0417 23E0 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23E2 7FFF 
0418 23E4 0458  20         b     *tmp4                 ; Exit
0419 23E6 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23E8 200A 
     23EA 8C00 
0420 23EC 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23EE 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23F0 0200 
     23F2 0000 
0425 23F4 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23F6 01C0 
     23F8 0101 
0426 23FA 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23FC 02A0 
     23FE 0101 
0427 2400 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     2402 00E0 
     2404 0101 
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
0445 2406 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 2408 C3A0  34         mov   @wyx,r14              ; Get YX
     240A 832A 
0447 240C 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 240E 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2410 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2412 C3A0  34         mov   @wyx,r14              ; Get YX
     2414 832A 
0454 2416 024E  22         andi  r14,>00ff             ; Remove Y
     2418 00FF 
0455 241A A3CE  18         a     r14,r15               ; pos = pos + X
0456 241C A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     241E 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2420 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2422 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 2424 020F  20         li    r15,vdpw              ; VDP write address
     2426 8C00 
0463 2428 045B  20         b     *r11
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
0478 242A C17B  30 putstr  mov   *r11+,tmp1
0479 242C D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 242E C1CB  18 xutstr  mov   r11,tmp3
0481 2430 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2432 2406 
0482 2434 C2C7  18         mov   tmp3,r11
0483 2436 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 2438 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 243A 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 243C 0286  22         ci    tmp2,255              ; Length > 255 ?
     243E 00FF 
0491 2440 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 2442 0460  28         b     @xpym2v               ; Display string
     2444 245C 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 2446 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2448 FFCE 
0498 244A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     244C 2030 
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
0514 244E C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2450 832A 
0515 2452 0460  28         b     @putstr
     2454 242A 
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
0020 2456 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 2458 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 245A C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Sanity check
0025               *--------------------------------------------------------------
0026 245C C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 245E 1604  14         jne   !                     ; No, continue
0028               
0029 2460 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2462 FFCE 
0030 2464 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2466 2030 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 2468 0264  22 !       ori   tmp0,>4000
     246A 4000 
0035 246C 06C4  14         swpb  tmp0
0036 246E D804  38         movb  tmp0,@vdpa
     2470 8C02 
0037 2472 06C4  14         swpb  tmp0
0038 2474 D804  38         movb  tmp0,@vdpa
     2476 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 2478 020F  20         li    r15,vdpw              ; Set VDP write address
     247A 8C00 
0043 247C C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     247E 2486 
     2480 8320 
0044 2482 0460  28         b     @mcloop               ; Write data to VDP and return
     2484 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 2486 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 2488 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 248A C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 248C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 248E 06C4  14 xpyv2m  swpb  tmp0
0027 2490 D804  38         movb  tmp0,@vdpa
     2492 8C02 
0028 2494 06C4  14         swpb  tmp0
0029 2496 D804  38         movb  tmp0,@vdpa
     2498 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 249A 020F  20         li    r15,vdpr              ; Set VDP read address
     249C 8800 
0034 249E C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24A0 24A8 
     24A2 8320 
0035 24A4 0460  28         b     @mcloop               ; Read data from VDP
     24A6 8320 
0036 24A8 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24AA C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24AC C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24AE C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24B0 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24B2 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24B4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24B6 FFCE 
0034 24B8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24BA 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24BC 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24BE 0001 
0039 24C0 1603  14         jne   cpym0                 ; No, continue checking
0040 24C2 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24C4 04C6  14         clr   tmp2                  ; Reset counter
0042 24C6 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24C8 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24CA 7FFF 
0047 24CC C1C4  18         mov   tmp0,tmp3
0048 24CE 0247  22         andi  tmp3,1
     24D0 0001 
0049 24D2 1618  14         jne   cpyodd                ; Odd source address handling
0050 24D4 C1C5  18 cpym1   mov   tmp1,tmp3
0051 24D6 0247  22         andi  tmp3,1
     24D8 0001 
0052 24DA 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24DC 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24DE 202A 
0057 24E0 1605  14         jne   cpym3
0058 24E2 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24E4 250A 
     24E6 8320 
0059 24E8 0460  28         b     @mcloop               ; Copy memory and exit
     24EA 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24EC C1C6  18 cpym3   mov   tmp2,tmp3
0064 24EE 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24F0 0001 
0065 24F2 1301  14         jeq   cpym4
0066 24F4 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24F6 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24F8 0646  14         dect  tmp2
0069 24FA 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24FC C1C7  18         mov   tmp3,tmp3
0074 24FE 1301  14         jeq   cpymz
0075 2500 D554  38         movb  *tmp0,*tmp1
0076 2502 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2504 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     2506 8000 
0081 2508 10E9  14         jmp   cpym2
0082 250A DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 250C C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 250E 0649  14         dect  stack
0065 2510 C64B  30         mov   r11,*stack            ; Push return address
0066 2512 0649  14         dect  stack
0067 2514 C640  30         mov   r0,*stack             ; Push r0
0068 2516 0649  14         dect  stack
0069 2518 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 251A 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 251C 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 251E 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2520 4000 
0077 2522 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2524 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 2526 020C  20         li    r12,>1e00             ; SAMS CRU address
     2528 1E00 
0082 252A 04C0  14         clr   r0
0083 252C 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 252E D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2530 D100  18         movb  r0,tmp0
0086 2532 0984  56         srl   tmp0,8                ; Right align
0087 2534 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     2536 833C 
0088 2538 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 253A C339  30         mov   *stack+,r12           ; Pop r12
0094 253C C039  30         mov   *stack+,r0            ; Pop r0
0095 253E C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2540 045B  20         b     *r11                  ; Return to caller
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
0131 2542 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2544 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 2546 0649  14         dect  stack
0135 2548 C64B  30         mov   r11,*stack            ; Push return address
0136 254A 0649  14         dect  stack
0137 254C C640  30         mov   r0,*stack             ; Push r0
0138 254E 0649  14         dect  stack
0139 2550 C64C  30         mov   r12,*stack            ; Push r12
0140 2552 0649  14         dect  stack
0141 2554 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 2556 0649  14         dect  stack
0143 2558 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 255A 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 255C 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 255E 0284  22         ci    tmp0,255              ; Crash if page > 255
     2560 00FF 
0153 2562 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 2564 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2566 001E 
0158 2568 150A  14         jgt   !
0159 256A 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     256C 0004 
0160 256E 1107  14         jlt   !
0161 2570 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2572 0012 
0162 2574 1508  14         jgt   sams.page.set.switch_page
0163 2576 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     2578 0006 
0164 257A 1501  14         jgt   !
0165 257C 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 257E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2580 FFCE 
0170 2582 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2584 2030 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 2586 020C  20         li    r12,>1e00             ; SAMS CRU address
     2588 1E00 
0176 258A C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 258C 06C0  14         swpb  r0                    ; LSB to MSB
0178 258E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2590 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2592 4000 
0180 2594 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 2596 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 2598 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 259A C339  30         mov   *stack+,r12           ; Pop r12
0188 259C C039  30         mov   *stack+,r0            ; Pop r0
0189 259E C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25A0 045B  20         b     *r11                  ; Return to caller
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
0204 25A2 020C  20         li    r12,>1e00             ; SAMS CRU address
     25A4 1E00 
0205 25A6 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25A8 045B  20         b     *r11                  ; Return to caller
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
0227 25AA 020C  20         li    r12,>1e00             ; SAMS CRU address
     25AC 1E00 
0228 25AE 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25B0 045B  20         b     *r11                  ; Return to caller
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
0260 25B2 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25B4 0649  14         dect  stack
0263 25B6 C64B  30         mov   r11,*stack            ; Save return address
0264 25B8 0649  14         dect  stack
0265 25BA C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25BC 0649  14         dect  stack
0267 25BE C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25C0 0649  14         dect  stack
0269 25C2 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25C4 0649  14         dect  stack
0271 25C6 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25C8 0206  20         li    tmp2,8                ; Set loop counter
     25CA 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25CC C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 25CE C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25D0 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25D2 2546 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25D4 0606  14         dec   tmp2                  ; Next iteration
0288 25D6 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25D8 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25DA 25A2 
0294                                                   ; / activating changes.
0295               
0296 25DC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25DE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25E0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25E6 045B  20         b     *r11                  ; Return to caller
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
0318 25E8 0649  14         dect  stack
0319 25EA C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25EC 06A0  32         bl    @sams.layout
     25EE 25B2 
0324 25F0 25F6                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25F2 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25F4 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25F6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25F8 0002 
0336 25FA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25FC 0003 
0337 25FE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     2600 000A 
0338 2602 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2604 000B 
0339 2606 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     2608 000C 
0340 260A D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     260C 000D 
0341 260E E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2610 000E 
0342 2612 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2614 000F 
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
0363 2616 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 2618 0649  14         dect  stack
0366 261A C64B  30         mov   r11,*stack            ; Push return address
0367 261C 0649  14         dect  stack
0368 261E C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2620 0649  14         dect  stack
0370 2622 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2624 0649  14         dect  stack
0372 2626 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 2628 0649  14         dect  stack
0374 262A C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 262C 0205  20         li    tmp1,sams.layout.copy.data
     262E 264E 
0379 2630 0206  20         li    tmp2,8                ; Set loop counter
     2632 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2634 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 2636 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     2638 250E 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 263A CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     263C 833C 
0390               
0391 263E 0606  14         dec   tmp2                  ; Next iteration
0392 2640 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2642 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2644 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 2646 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 2648 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 264A C2F9  30         mov   *stack+,r11           ; Pop r11
0402 264C 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 264E 2000             data  >2000                 ; >2000-2fff
0408 2650 3000             data  >3000                 ; >3000-3fff
0409 2652 A000             data  >a000                 ; >a000-afff
0410 2654 B000             data  >b000                 ; >b000-bfff
0411 2656 C000             data  >c000                 ; >c000-cfff
0412 2658 D000             data  >d000                 ; >d000-dfff
0413 265A E000             data  >e000                 ; >e000-efff
0414 265C F000             data  >f000                 ; >f000-ffff
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
0009 265E 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2660 FFBF 
0010 2662 0460  28         b     @putv01
     2664 2352 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2666 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     2668 0040 
0018 266A 0460  28         b     @putv01
     266C 2352 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 266E 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2670 FFDF 
0026 2672 0460  28         b     @putv01
     2674 2352 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2676 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     2678 0020 
0034 267A 0460  28         b     @putv01
     267C 2352 
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
0010 267E 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2680 FFFE 
0011 2682 0460  28         b     @putv01
     2684 2352 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2686 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     2688 0001 
0019 268A 0460  28         b     @putv01
     268C 2352 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 268E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2690 FFFD 
0027 2692 0460  28         b     @putv01
     2694 2352 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2696 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     2698 0002 
0035 269A 0460  28         b     @putv01
     269C 2352 
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
0018 269E C83B  50 at      mov   *r11+,@wyx
     26A0 832A 
0019 26A2 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26A4 B820  54 down    ab    @hb$01,@wyx
     26A6 201C 
     26A8 832A 
0028 26AA 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26AC 7820  54 up      sb    @hb$01,@wyx
     26AE 201C 
     26B0 832A 
0037 26B2 045B  20         b     *r11
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
0049 26B4 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26B6 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26B8 832A 
0051 26BA C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26BC 832A 
0052 26BE 045B  20         b     *r11
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
0021 26C0 C120  34 yx2px   mov   @wyx,tmp0
     26C2 832A 
0022 26C4 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26C6 06C4  14         swpb  tmp0                  ; Y<->X
0024 26C8 04C5  14         clr   tmp1                  ; Clear before copy
0025 26CA D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26CC 20A0  38         coc   @wbit1,config         ; f18a present ?
     26CE 2028 
0030 26D0 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26D2 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26D4 833A 
     26D6 2700 
0032 26D8 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26DA 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26DC B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26DE 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26E0 0500 
0037 26E2 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26E4 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26E6 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26E8 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26EA D105  18         movb  tmp1,tmp0
0051 26EC 06C4  14         swpb  tmp0                  ; X<->Y
0052 26EE 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26F0 202A 
0053 26F2 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26F4 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26F6 201C 
0059 26F8 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26FA 202E 
0060 26FC 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26FE 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 2700 0050            data   80
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
0013 2702 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2704 06A0  32         bl    @putvr                ; Write once
     2706 233E 
0015 2708 391C             data  >391c                 ; VR1/57, value 00011100
0016 270A 06A0  32         bl    @putvr                ; Write twice
     270C 233E 
0017 270E 391C             data  >391c                 ; VR1/57, value 00011100
0018 2710 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2712 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 2714 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2716 233E 
0028 2718 391C             data  >391c
0029 271A 0458  20         b     *tmp4                 ; Exit
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
0040 271C C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 271E 06A0  32         bl    @cpym2v
     2720 2456 
0042 2722 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     2724 2760 
     2726 0006 
0043 2728 06A0  32         bl    @putvr
     272A 233E 
0044 272C 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 272E 06A0  32         bl    @putvr
     2730 233E 
0046 2732 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2734 0204  20         li    tmp0,>3f00
     2736 3F00 
0052 2738 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     273A 22C6 
0053 273C D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     273E 8800 
0054 2740 0984  56         srl   tmp0,8
0055 2742 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2744 8800 
0056 2746 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 2748 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 274A 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     274C BFFF 
0060 274E 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2750 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2752 4000 
0063               f18chk_exit:
0064 2754 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2756 229A 
0065 2758 3F00             data  >3f00,>00,6
     275A 0000 
     275C 0006 
0066 275E 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2760 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2762 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2764 0340             data  >0340                 ; 3f04   0340  idle
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
0092 2766 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 2768 06A0  32         bl    @putvr
     276A 233E 
0097 276C 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 276E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2770 233E 
0100 2772 391C             data  >391c                 ; Lock the F18a
0101 2774 0458  20         b     *tmp4                 ; Exit
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
0120 2776 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 2778 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     277A 2028 
0122 277C 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 277E C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2780 8802 
0127 2782 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2784 233E 
0128 2786 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 2788 04C4  14         clr   tmp0
0130 278A D120  34         movb  @vdps,tmp0
     278C 8802 
0131 278E 0984  56         srl   tmp0,8
0132 2790 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 2792 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2794 832A 
0018 2796 D17B  28         movb  *r11+,tmp1
0019 2798 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 279A D1BB  28         movb  *r11+,tmp2
0021 279C 0986  56         srl   tmp2,8                ; Repeat count
0022 279E C1CB  18         mov   r11,tmp3
0023 27A0 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27A2 2406 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27A4 020B  20         li    r11,hchar1
     27A6 27AC 
0028 27A8 0460  28         b     @xfilv                ; Draw
     27AA 22A0 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27AC 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27AE 202C 
0033 27B0 1302  14         jeq   hchar2                ; Yes, exit
0034 27B2 C2C7  18         mov   tmp3,r11
0035 27B4 10EE  14         jmp   hchar                 ; Next one
0036 27B6 05C7  14 hchar2  inct  tmp3
0037 27B8 0457  20         b     *tmp3                 ; Exit
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
0016 27BA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27BC 202A 
0017 27BE 020C  20         li    r12,>0024
     27C0 0024 
0018 27C2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27C4 2856 
0019 27C6 04C6  14         clr   tmp2
0020 27C8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27CA 04CC  14         clr   r12
0025 27CC 1F08  20         tb    >0008                 ; Shift-key ?
0026 27CE 1302  14         jeq   realk1                ; No
0027 27D0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27D2 2886 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27D4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27D6 1302  14         jeq   realk2                ; No
0033 27D8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27DA 28B6 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27DC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27DE 1302  14         jeq   realk3                ; No
0039 27E0 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27E2 28E6 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27E4 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     27E6 2016 
0044 27E8 1E15  20         sbz   >0015                 ; Set P5
0045 27EA 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 27EC 1302  14         jeq   realk4                ; No
0047 27EE E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     27F0 2016 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 27F2 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 27F4 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27F6 0006 
0053 27F8 0606  14 realk5  dec   tmp2
0054 27FA 020C  20         li    r12,>24               ; CRU address for P2-P4
     27FC 0024 
0055 27FE 06C6  14         swpb  tmp2
0056 2800 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2802 06C6  14         swpb  tmp2
0058 2804 020C  20         li    r12,6                 ; CRU read address
     2806 0006 
0059 2808 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 280A 0547  14         inv   tmp3                  ;
0061 280C 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     280E FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2810 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2812 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2814 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 2816 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 2818 0285  22         ci    tmp1,8
     281A 0008 
0070 281C 1AFA  14         jl    realk6
0071 281E C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2820 1BEB  14         jh    realk5                ; No, next column
0073 2822 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2824 C206  18 realk8  mov   tmp2,tmp4
0078 2826 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 2828 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 282A A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 282C D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 282E 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2830 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2832 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2834 2016 
0089 2836 1608  14         jne   realka                ; No, continue saving key
0090 2838 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     283A 2880 
0091 283C 1A05  14         jl    realka
0092 283E 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2840 287E 
0093 2842 1B02  14         jh    realka                ; No, continue
0094 2844 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     2846 E000 
0095 2848 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     284A 833C 
0096 284C E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     284E 2014 
0097 2850 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2852 8C00 
0098                                                   ; / using R15 as temp storage
0099 2854 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 2856 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2858 0000 
     285A FF0D 
     285C 203D 
0102 285E ....             text  'xws29ol.'
0103 2866 ....             text  'ced38ik,'
0104 286E ....             text  'vrf47ujm'
0105 2876 ....             text  'btg56yhn'
0106 287E ....             text  'zqa10p;/'
0107 2886 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2888 0000 
     288A FF0D 
     288C 202B 
0108 288E ....             text  'XWS@(OL>'
0109 2896 ....             text  'CED#*IK<'
0110 289E ....             text  'VRF$&UJM'
0111 28A6 ....             text  'BTG%^YHN'
0112 28AE ....             text  'ZQA!)P:-'
0113 28B6 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28B8 0000 
     28BA FF0D 
     28BC 2005 
0114 28BE 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28C0 0804 
     28C2 0F27 
     28C4 C2B9 
0115 28C6 600B             data  >600b,>0907,>063f,>c1B8
     28C8 0907 
     28CA 063F 
     28CC C1B8 
0116 28CE 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28D0 7B02 
     28D2 015F 
     28D4 C0C3 
0117 28D6 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28D8 7D0E 
     28DA 0CC6 
     28DC BFC4 
0118 28DE 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28E0 7C03 
     28E2 BC22 
     28E4 BDBA 
0119 28E6 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28E8 0000 
     28EA FF0D 
     28EC 209D 
0120 28EE 9897             data  >9897,>93b2,>9f8f,>8c9B
     28F0 93B2 
     28F2 9F8F 
     28F4 8C9B 
0121 28F6 8385             data  >8385,>84b3,>9e89,>8b80
     28F8 84B3 
     28FA 9E89 
     28FC 8B80 
0122 28FE 9692             data  >9692,>86b4,>b795,>8a8D
     2900 86B4 
     2902 B795 
     2904 8A8D 
0123 2906 8294             data  >8294,>87b5,>b698,>888E
     2908 87B5 
     290A B698 
     290C 888E 
0124 290E 9A91             data  >9a91,>81b1,>b090,>9cBB
     2910 81B1 
     2912 B090 
     2914 9CBB 
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
0023 2916 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2918 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     291A 8340 
0025 291C 04E0  34         clr   @waux1
     291E 833C 
0026 2920 04E0  34         clr   @waux2
     2922 833E 
0027 2924 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2926 833C 
0028 2928 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 292A 0205  20         li    tmp1,4                ; 4 nibbles
     292C 0004 
0033 292E C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2930 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2932 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2934 0286  22         ci    tmp2,>000a
     2936 000A 
0039 2938 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 293A C21B  26         mov   *r11,tmp4
0045 293C 0988  56         srl   tmp4,8                ; Right justify
0046 293E 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2940 FFF6 
0047 2942 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2944 C21B  26         mov   *r11,tmp4
0054 2946 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2948 00FF 
0055               
0056 294A A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 294C 06C6  14         swpb  tmp2
0058 294E DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2950 0944  56         srl   tmp0,4                ; Next nibble
0060 2952 0605  14         dec   tmp1
0061 2954 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2956 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2958 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 295A C160  34         mov   @waux3,tmp1           ; Get pointer
     295C 8340 
0067 295E 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2960 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2962 C120  34         mov   @waux2,tmp0
     2964 833E 
0070 2966 06C4  14         swpb  tmp0
0071 2968 DD44  32         movb  tmp0,*tmp1+
0072 296A 06C4  14         swpb  tmp0
0073 296C DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 296E C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2970 8340 
0078 2972 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2974 2020 
0079 2976 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2978 C120  34         mov   @waux1,tmp0
     297A 833C 
0084 297C 06C4  14         swpb  tmp0
0085 297E DD44  32         movb  tmp0,*tmp1+
0086 2980 06C4  14         swpb  tmp0
0087 2982 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2984 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2986 202A 
0092 2988 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 298A 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 298C 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     298E 7FFF 
0098 2990 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2992 8340 
0099 2994 0460  28         b     @xutst0               ; Display string
     2996 242C 
0100 2998 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 299A C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     299C 832A 
0122 299E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29A0 8000 
0123 29A2 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29A4 0207  20 mknum   li    tmp3,5                ; Digit counter
     29A6 0005 
0020 29A8 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29AA C155  26         mov   *tmp1,tmp1            ; /
0022 29AC C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29AE 0228  22         ai    tmp4,4                ; Get end of buffer
     29B0 0004 
0024 29B2 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29B4 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29B6 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29B8 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29BA 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29BC B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29BE D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29C0 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29C2 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29C4 0607  14         dec   tmp3                  ; Decrease counter
0036 29C6 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29C8 0207  20         li    tmp3,4                ; Check first 4 digits
     29CA 0004 
0041 29CC 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29CE C11B  26         mov   *r11,tmp0
0043 29D0 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29D2 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29D4 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29D6 05CB  14 mknum3  inct  r11
0047 29D8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29DA 202A 
0048 29DC 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29DE 045B  20         b     *r11                  ; Exit
0050 29E0 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29E2 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29E4 13F8  14         jeq   mknum3                ; Yes, exit
0053 29E6 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29E8 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29EA 7FFF 
0058 29EC C10B  18         mov   r11,tmp0
0059 29EE 0224  22         ai    tmp0,-4
     29F0 FFFC 
0060 29F2 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29F4 0206  20         li    tmp2,>0500            ; String length = 5
     29F6 0500 
0062 29F8 0460  28         b     @xutstr               ; Display string
     29FA 242E 
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
0093 29FC C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 29FE C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A00 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A02 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A04 0207  20         li    tmp3,5                ; Set counter
     2A06 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A08 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A0A 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A0C 0584  14         inc   tmp0                  ; Next character
0105 2A0E 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A10 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A12 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A14 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A16 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A18 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill
0119 2A1A DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A1C 0607  14         dec   tmp3                  ; Last character ?
0121 2A1E 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A20 045B  20         b     *r11                  ; Return
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
0139 2A22 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A24 832A 
0140 2A26 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A28 8000 
0141 2A2A 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A2C 0649  14         dect  stack
0023 2A2E C64B  30         mov   r11,*stack            ; Save return address
0024 2A30 0649  14         dect  stack
0025 2A32 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A34 0649  14         dect  stack
0027 2A36 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A38 0649  14         dect  stack
0029 2A3A C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A3C 0649  14         dect  stack
0031 2A3E C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A40 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A42 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A44 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A46 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A48 0649  14         dect  stack
0044 2A4A C64B  30         mov   r11,*stack            ; Save return address
0045 2A4C 0649  14         dect  stack
0046 2A4E C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A50 0649  14         dect  stack
0048 2A52 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A54 0649  14         dect  stack
0050 2A56 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A58 0649  14         dect  stack
0052 2A5A C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A5C C1D4  26 !       mov   *tmp0,tmp3
0057 2A5E 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A60 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A62 00FF 
0059 2A64 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A66 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A68 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A6A 0584  14         inc   tmp0                  ; Next byte
0067 2A6C 0607  14         dec   tmp3                  ; Shorten string length
0068 2A6E 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A70 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A72 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A74 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A76 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A78 C187  18         mov   tmp3,tmp2
0078 2A7A 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A7C DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A7E 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A80 24B0 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A82 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A84 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A86 FFCE 
0090 2A88 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A8A 2030 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A8C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2A8E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2A90 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2A92 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2A94 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2A96 045B  20         b     *r11                  ; Return to caller
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
0123 2A98 0649  14         dect  stack
0124 2A9A C64B  30         mov   r11,*stack            ; Save return address
0125 2A9C 05D9  26         inct  *stack                ; Skip "data P0"
0126 2A9E 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AA0 0649  14         dect  stack
0128 2AA2 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2AA4 0649  14         dect  stack
0130 2AA6 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2AA8 0649  14         dect  stack
0132 2AAA C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AAC C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AAE C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AB0 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AB2 0649  14         dect  stack
0144 2AB4 C64B  30         mov   r11,*stack            ; Save return address
0145 2AB6 0649  14         dect  stack
0146 2AB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2ABA 0649  14         dect  stack
0148 2ABC C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2ABE 0649  14         dect  stack
0150 2AC0 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AC2 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AC4 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AC6 0586  14         inc   tmp2
0161 2AC8 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2ACA 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Sanity check on string length
0165                       ;-----------------------------------------------------------------------
0166 2ACC 0286  22         ci    tmp2,255
     2ACE 00FF 
0167 2AD0 1505  14         jgt   string.getlenc.panic
0168 2AD2 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2AD4 0606  14         dec   tmp2                  ; One time adjustment
0174 2AD6 C806  38         mov   tmp2,@waux1           ; Store length
     2AD8 833C 
0175 2ADA 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2ADC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2ADE FFCE 
0181 2AE0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AE2 2030 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2AE4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2AE6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AE8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AEA C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2AEC 045B  20         b     *r11                  ; Return to caller
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
0056 2AEE A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2AF0 2AF2             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2AF2 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2AF4 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2AF6 A428 
0064 2AF8 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2AFA 2026 
0065 2AFC C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2AFE 8356 
0066 2B00 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B02 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B04 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B06 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B08 A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B0A 06C0  14         swpb  r0                    ;
0075 2B0C D800  38         movb  r0,@vdpa              ; Send low byte
     2B0E 8C02 
0076 2B10 06C0  14         swpb  r0                    ;
0077 2B12 D800  38         movb  r0,@vdpa              ; Send high byte
     2B14 8C02 
0078 2B16 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B18 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B1A 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B1C 0704  14         seto  r4                    ; Init counter
0086 2B1E 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B20 A420 
0087 2B22 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B24 0584  14         inc   r4                    ; Increment char counter
0089 2B26 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B28 0007 
0090 2B2A 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B2C 80C4  18         c     r4,r3                 ; End of name?
0093 2B2E 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B30 06C0  14         swpb  r0                    ;
0098 2B32 D800  38         movb  r0,@vdpa              ; Send low byte
     2B34 8C02 
0099 2B36 06C0  14         swpb  r0                    ;
0100 2B38 D800  38         movb  r0,@vdpa              ; Send high byte
     2B3A 8C02 
0101 2B3C D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B3E 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B40 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B42 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B44 2C5A 
0109 2B46 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B48 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B4A 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B4C 04E0  34         clr   @>83d0
     2B4E 83D0 
0118 2B50 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B52 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B54 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B56 A432 
0121               
0122 2B58 0584  14         inc   r4                    ; Adjust for dot
0123 2B5A A804  38         a     r4,@>8356             ; Point to position after name
     2B5C 8356 
0124 2B5E C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B60 8356 
     2B62 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B64 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B66 83E0 
0130 2B68 04C1  14         clr   r1                    ; Version found of dsr
0131 2B6A 020C  20         li    r12,>0f00             ; Init cru address
     2B6C 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2B6E C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2B70 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2B72 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2B74 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2B76 0100 
0145 2B78 04E0  34         clr   @>83d0                ; Clear in case we are done
     2B7A 83D0 
0146 2B7C 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B7E 2000 
0147 2B80 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2B82 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2B84 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2B86 1D00  20         sbo   0                     ; Turn on ROM
0154 2B88 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2B8A 4000 
0155 2B8C 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2B8E 2C56 
0156 2B90 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2B92 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2B94 A40A 
0166 2B96 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2B98 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B9A 83D2 
0172                                                   ; subprogram
0173               
0174 2B9C 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2B9E C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BA0 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BA2 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BA4 83D2 
0183                                                   ; subprogram
0184               
0185 2BA6 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BA8 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BAA 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BAC D160  34         movb  @>8355,r5             ; Get length as counter
     2BAE 8355 
0195 2BB0 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BB2 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BB4 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BB6 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BB8 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BBA A420 
0206 2BBC 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BBE 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BC0 0605  14         dec   r5                    ; Update loop counter
0211 2BC2 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BC4 0581  14         inc   r1                    ; Next version found
0217 2BC6 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BC8 A42A 
0218 2BCA C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2BCC A42C 
0219 2BCE C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2BD0 A430 
0220               
0221 2BD2 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2BD4 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2BD6 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2BD8 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2BDA 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2BDC 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BDE A400 
0233 2BE0 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2BE2 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BE4 A428 
0239                                                   ; (8 or >a)
0240 2BE6 0281  22         ci    r1,8                  ; was it 8?
     2BE8 0008 
0241 2BEA 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2BEC D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BEE 8350 
0243                                                   ; Get error byte from @>8350
0244 2BF0 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2BF2 06C0  14         swpb  r0                    ;
0252 2BF4 D800  38         movb  r0,@vdpa              ; send low byte
     2BF6 8C02 
0253 2BF8 06C0  14         swpb  r0                    ;
0254 2BFA D800  38         movb  r0,@vdpa              ; send high byte
     2BFC 8C02 
0255 2BFE D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C00 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C02 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C04 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C06 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C08 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C0A 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C0C A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C0E 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C10 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C12 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C14 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C16 2026 
0281                                                   ; / to indicate error
0282 2C18 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C1A A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C1C 2C1E             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C1E 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C20 83E0 
0316               
0317 2C22 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C24 2026 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C26 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C28 A42A 
0322 2C2A C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C2C C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C2E C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C30 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C32 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C34 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C36 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C38 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C3A 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C3C 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C3E 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C40 4000 
     2C42 2C56 
0337 2C44 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C46 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C48 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C4A 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C4C 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C4E A400 
0355 2C50 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C52 A434 
0356               
0357 2C54 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C56 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C58 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C5A ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2C5C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C5E C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C60 0649  14         dect  stack
0052 2C62 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C64 0204  20         li    tmp0,dsrlnk.savcru
     2C66 A42A 
0057 2C68 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2C6A 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2C6C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2C6E 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2C70 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2C72 37D7 
0065 2C74 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2C76 8370 
0066                                                   ; / location
0067 2C78 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2C7A A44C 
0068 2C7C 04C5  14         clr   tmp1                  ; io.op.open
0069 2C7E 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2C80 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2C82 0649  14         dect  stack
0097 2C84 C64B  30         mov   r11,*stack            ; Save return address
0098 2C86 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C88 0001 
0099 2C8A 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2C8C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2C8E 0649  14         dect  stack
0125 2C90 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2C92 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C94 0002 
0128 2C96 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2C98 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2C9A 0649  14         dect  stack
0155 2C9C C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2C9E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CA0 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CA2 0005 
0159               
0160 2CA4 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CA6 A43E 
0161               
0162 2CA8 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CAA 22D8 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CAC 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CAE 0003 
0167 2CB0 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CB2 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CB4 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CB6 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CB8 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CBA 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CBC 1000  14         nop
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
0227 2CBE C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CC0 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CC2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CC4 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CC6 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CC8 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2CCA 22D8 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2CCC C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2CCE 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2CD0 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2CD2 A44C 
0246               
0247 2CD4 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2CD6 22D8 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2CD8 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2CDA 0009 
0254 2CDC C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CDE 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2CE0 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2CE2 8322 
     2CE4 833C 
0259               
0260 2CE6 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2CE8 A42A 
0261 2CEA 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2CEC 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CEE 2AEE 
0268 2CF0 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2CF2 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2CF4 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2CF6 2C1A 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2CF8 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2CFA C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2CFC 833C 
     2CFE 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D00 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D02 A436 
0292 2D04 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D06 0005 
0293 2D08 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D0A 22F0 
0294 2D0C C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D0E C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D10 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D12 045B  20         b     *r11                  ; Return to caller
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
0020 2D14 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D16 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D18 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D1A 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D1C 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D1E 2026 
0029 2D20 1602  14         jne   tmgr1a                ; No, so move on
0030 2D22 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D24 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D26 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D28 202A 
0035 2D2A 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D2C 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D2E 201A 
0048 2D30 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D32 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D34 2018 
0050 2D36 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D38 0460  28         b     @kthread              ; Run kernel thread
     2D3A 2DB2 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D3C 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D3E 201E 
0056 2D40 13EB  14         jeq   tmgr1
0057 2D42 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D44 201C 
0058 2D46 16E8  14         jne   tmgr1
0059 2D48 C120  34         mov   @wtiusr,tmp0
     2D4A 832E 
0060 2D4C 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D4E 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D50 2DB0 
0065 2D52 C10A  18         mov   r10,tmp0
0066 2D54 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D56 00FF 
0067 2D58 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D5A 2026 
0068 2D5C 1303  14         jeq   tmgr5
0069 2D5E 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D60 003C 
0070 2D62 1002  14         jmp   tmgr6
0071 2D64 0284  22 tmgr5   ci    tmp0,50
     2D66 0032 
0072 2D68 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D6A 1001  14         jmp   tmgr8
0074 2D6C 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D6E C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D70 832C 
0079 2D72 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D74 FF00 
0080 2D76 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D78 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D7A 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D7C 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D7E C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D80 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D82 830C 
     2D84 830D 
0089 2D86 1608  14         jne   tmgr10                ; No, get next slot
0090 2D88 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D8A FF00 
0091 2D8C C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D8E C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D90 8330 
0096 2D92 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D94 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D96 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D98 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D9A 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D9C 8315 
     2D9E 8314 
0103 2DA0 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DA2 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DA4 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DA6 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DA8 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DAA 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DAC FF00 
0109 2DAE 10B4  14         jmp   tmgr1
0110 2DB0 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DB2 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DB4 201A 
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
0041 2DB6 06A0  32         bl    @realkb               ; Scan full keyboard
     2DB8 27BA 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DBA 0460  28         b     @tmgr3                ; Exit
     2DBC 2D3C 
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
0017 2DBE C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DC0 832E 
0018 2DC2 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DC4 201C 
0019 2DC6 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D18     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DC8 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DCA 832E 
0029 2DCC 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DCE FEFF 
0030 2DD0 045B  20         b     *r11                  ; Return
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
0017 2DD2 C13B  30 mkslot  mov   *r11+,tmp0
0018 2DD4 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DD6 C184  18         mov   tmp0,tmp2
0023 2DD8 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DDA A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DDC 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DDE CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DE0 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DE2 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DE4 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DE6 202C 
0035 2DE8 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DEA 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DEC 05CB  14 mkslo1  inct  r11
0041 2DEE 045B  20         b     *r11                  ; Exit
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
0052 2DF0 C13B  30 clslot  mov   *r11+,tmp0
0053 2DF2 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DF4 A120  34         a     @wtitab,tmp0          ; Add table base
     2DF6 832C 
0055 2DF8 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2DFA 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2DFC 045B  20         b     *r11                  ; Exit
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
0068 2DFE C13B  30 rsslot  mov   *r11+,tmp0
0069 2E00 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E02 A120  34         a     @wtitab,tmp0          ; Add table base
     2E04 832C 
0071 2E06 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E08 C154  26         mov   *tmp0,tmp1
0073 2E0A 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E0C FF00 
0074 2E0E C505  30         mov   tmp1,*tmp0
0075 2E10 045B  20         b     *r11                  ; Exit
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
0260 2E12 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E14 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E16 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E18 0000 
0266 2E1A 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E1C 8300 
0267 2E1E C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E20 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E22 0202  20 runli2  li    r2,>8308
     2E24 8308 
0272 2E26 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E28 0282  22         ci    r2,>8400
     2E2A 8400 
0274 2E2C 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E2E 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E30 FFFF 
0279 2E32 1602  14         jne   runli4                ; No, continue
0280 2E34 0420  54         blwp  @0                    ; Yes, bye bye
     2E36 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E38 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E3A 833C 
0285 2E3C 04C1  14         clr   r1                    ; Reset counter
0286 2E3E 0202  20         li    r2,10                 ; We test 10 times
     2E40 000A 
0287 2E42 C0E0  34 runli5  mov   @vdps,r3
     2E44 8802 
0288 2E46 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E48 202A 
0289 2E4A 1302  14         jeq   runli6
0290 2E4C 0581  14         inc   r1                    ; Increase counter
0291 2E4E 10F9  14         jmp   runli5
0292 2E50 0602  14 runli6  dec   r2                    ; Next test
0293 2E52 16F7  14         jne   runli5
0294 2E54 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E56 1250 
0295 2E58 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E5A 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E5C 2026 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E5E 06A0  32 runli7  bl    @loadmc
     2E60 2226 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E62 04C1  14 runli9  clr   r1
0305 2E64 04C2  14         clr   r2
0306 2E66 04C3  14         clr   r3
0307 2E68 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2E6A 3000 
0308 2E6C 020F  20         li    r15,vdpw              ; Set VDP write address
     2E6E 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2E70 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E72 4A4A 
0317 2E74 1605  14         jne   runlia
0318 2E76 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E78 229A 
0319 2E7A 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2E7C 0000 
     2E7E 3000 
0324 2E80 06A0  32 runlia  bl    @filv
     2E82 229A 
0325 2E84 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E86 00F4 
     2E88 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2E8A 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E8C 2702 
0333 2E8E 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E90 271C 
0334 2E92 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E94 2712 
0335               
0336 2E96 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E98 233E 
0337 2E9A 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2E9C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E9E 2304 
0351 2EA0 3008             data  spvmod                ; Equate selected video mode table
0352 2EA2 0204  20         li    tmp0,spfont           ; Get font option
     2EA4 000C 
0353 2EA6 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EA8 1304  14         jeq   runlid                ; Yes, skip it
0355 2EAA 06A0  32         bl    @ldfnt
     2EAC 236C 
0356 2EAE 1100             data  fntadr,spfont         ; Load specified font
     2EB0 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EB2 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EB4 4A4A 
0361 2EB6 1602  14         jne   runlie                ; No, continue
0362 2EB8 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EBA 2090 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EBC 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EBE 0040 
0367 2EC0 0460  28         b     @main                 ; Give control to main program
     2EC2 6036 
**** **** ****     > stevie_b1.asm.1638280
0057                                                   ; Relocated spectra2 in low MEMEXP, was
0058                                                   ; copied to >2000 from ROM in bank 0
0059                       ;------------------------------------------------------
0060                       ; End of File marker
0061                       ;------------------------------------------------------
0062 2EC4 DEAD             data >dead,>beef,>dead,>beef
     2EC6 BEEF 
     2EC8 DEAD 
     2ECA BEEF 
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
0076                       copy  "data.constants.asm"  ; Data Constants
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
0040 301E 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     3020 1010 
     3022 1010 
     3024 1000 
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
0046               
0047               patterns.box:
0048 303E 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     3040 0000 
     3042 FF00 
     3044 FF00 
0049 3046 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     3048 0000 
     304A FF80 
     304C BFA0 
0050 304E 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     3050 0000 
     3052 FC04 
     3054 F414 
0051 3056 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     3058 A0A0 
     305A A0A0 
     305C A0A0 
0052 305E 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     3060 1414 
     3062 1414 
     3064 1414 
0053 3066 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     3068 A0A0 
     306A BF80 
     306C FF00 
0054 306E 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     3070 1414 
     3072 F404 
     3074 FC00 
0055 3076 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     3078 C0C0 
     307A C0C0 
     307C 0080 
0056 307E 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     3080 0F0F 
     3082 0F0F 
     3084 0000 
0057               
0058               alphalock:
0059 3086 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 12. down
     3088 00E0 
     308A E0E0 
     308C E0E0 
0060 308E 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 13. up
     3090 E0E0 
     3092 E0E0 
     3094 0000 
0061               
0062               
0063               vertline:
0064 3096 1010             data  >1010,>1010,>1010,>1010 ; 14. Vertical line
     3098 1010 
     309A 1010 
     309C 1010 
0065               
0066               
0067               ***************************************************************
0068               * SAMS page layout table for Stevie (16 words)
0069               *--------------------------------------------------------------
0070               mem.sams.layout.data:
0071 309E 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     30A0 0002 
0072 30A2 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     30A4 0003 
0073 30A6 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     30A8 000A 
0074               
0075 30AA B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     30AC 0010 
0076                                                   ; \ The index can allocate
0077                                                   ; / pages >10 to >2f.
0078               
0079 30AE C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     30B0 0030 
0080                                                   ; \ Editor buffer can allocate
0081                                                   ; / pages >30 to >ff.
0082               
0083 30B2 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     30B4 000D 
0084 30B6 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     30B8 000E 
0085 30BA F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     30BC 000F 
0086               
0087               
0088               
0089               
0090               
0091               ***************************************************************
0092               * Stevie color schemes table
0093               *--------------------------------------------------------------
0094               * Word 1
0095               *    MSB  high-nibble    Foreground color frame buffer
0096               *    MSB  low-nibble     Background color frame buffer
0097               *    LSB  high-nibble    Foreground color bottom line pane
0098               *    LSB  low-nibble     Background color bottom line pane
0099               *
0100               * Word 2
0101               *    MSB  high-nibble    Foreground color cmdb pane
0102               *    MSB  low-nibble     Background color cmdb pane
0103               *    LSB  high-nibble    0
0104               *    LSB  low-nibble     Cursor foreground color
0105               *--------------------------------------------------------------
0106      0009     tv.colorscheme.entries   equ 9      ; Entries in table
0107               
0108               tv.colorscheme.table:
0109                                        ; #  Framebuffer        | Status line        | CMDB
0110                                        ; ----------------------|--------------------|---------
0111 30BE F41F      data  >f41f,>f001       ; 1  White/dark blue    | Black/white        | White
     30C0 F001 
0112 30C2 F41C      data  >f41c,>f00f       ; 2  White/dark blue    | Black/dark green   | White
     30C4 F00F 
0113 30C6 A11A      data  >a11a,>f00f       ; 3  Dark yellow/black  | Black/dark yellow  | White
     30C8 F00F 
0114 30CA 2112      data  >2112,>f00f       ; 4  Medium green/black | Black/medium green | White
     30CC F00F 
0115 30CE E11E      data  >e11e,>f00f       ; 5  Grey/black         | Black/grey         | White
     30D0 F00F 
0116 30D2 1771      data  >1771,>1006       ; 6  Black/cyan         | Cyan/black         | Black
     30D4 1006 
0117 30D6 1FF1      data  >1ff1,>1001       ; 7  Black/white        | White/black        | Black
     30D8 1001 
0118 30DA A1F0      data  >a1f0,>1a0f       ; 8  Dark yellow/black  | White/transparent  | inverse
     30DC 1A0F 
0119 30DE 21F0      data  >21f0,>f20f       ; 9  Medium green/black | White/transparent  | inverse
     30E0 F20F 
0120               
**** **** ****     > stevie_b1.asm.1638280
0077                       copy  "data.strings.asm"    ; Data segment - Strings
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
0012 30E2 0C53             byte  12
0013 30E3 ....             text  'Stevie v0.1b'
0014                       even
0015               
0016               txt.about.purpose
0017 30F0 2350             byte  35
0018 30F1 ....             text  'Programming Editor for the TI-99/4a'
0019                       even
0020               
0021               txt.about.author
0022 3114 1D32             byte  29
0023 3115 ....             text  '2018-2020 by Filip Van Vooren'
0024                       even
0025               
0026               txt.about.website
0027 3132 1B68             byte  27
0028 3133 ....             text  'https://stevie.oratronik.de'
0029                       even
0030               
0031               txt.about.build
0032 314E 1542             byte  21
0033 314F ....             text  'Build: 201027-1638280'
0034                       even
0035               
0036               
0037               txt.about.msg1
0038 3164 2446             byte  36
0039 3165 ....             text  'FCTN-7 (F7)   Help, shortcuts, about'
0040                       even
0041               
0042               txt.about.msg2
0043 318A 2246             byte  34
0044 318B ....             text  'FCTN-9 (F9)   Toggle edit/cmd mode'
0045                       even
0046               
0047               txt.about.msg3
0048 31AE 1946             byte  25
0049 31AF ....             text  'FCTN-+        Quit Stevie'
0050                       even
0051               
0052               txt.about.msg4
0053 31C8 1C43             byte  28
0054 31C9 ....             text  'CTRL-L (^L)   Load DV80 file'
0055                       even
0056               
0057               txt.about.msg5
0058 31E6 1C43             byte  28
0059 31E7 ....             text  'CTRL-K (^K)   Save DV80 file'
0060                       even
0061               
0062               txt.about.msg6
0063 3204 1A43             byte  26
0064 3205 ....             text  'CTRL-Z (^Z)   Cycle colors'
0065                       even
0066               
0067               
0068 3220 380D     txt.about.msg7     byte    56,13
0069 3222 ....                        text    ' ALPHA LOCK up     '
0070                                  byte    12
0071 3236 ....                        text    ' ALPHA LOCK down   '
0072 3249 ....                        text    '  * Text changed'
0073               
0074               
0075               ;--------------------------------------------------------------
0076               ; Strings for status line pane
0077               ;--------------------------------------------------------------
0078               txt.delim
0079                       byte  1
0080 325A ....             text  ','
0081                       even
0082               
0083               txt.marker
0084 325C 052A             byte  5
0085 325D ....             text  '*EOF*'
0086                       even
0087               
0088               txt.bottom
0089 3262 0520             byte  5
0090 3263 ....             text  '  BOT'
0091                       even
0092               
0093               txt.ovrwrite
0094 3268 034F             byte  3
0095 3269 ....             text  'OVR'
0096                       even
0097               
0098               txt.insert
0099 326C 0349             byte  3
0100 326D ....             text  'INS'
0101                       even
0102               
0103               txt.star
0104 3270 012A             byte  1
0105 3271 ....             text  '*'
0106                       even
0107               
0108               txt.loading
0109 3272 0A4C             byte  10
0110 3273 ....             text  'Loading...'
0111                       even
0112               
0113               txt.saving
0114 327E 0953             byte  9
0115 327F ....             text  'Saving...'
0116                       even
0117               
0118               txt.fastmode
0119 3288 0846             byte  8
0120 3289 ....             text  'Fastmode'
0121                       even
0122               
0123               txt.kb
0124 3292 026B             byte  2
0125 3293 ....             text  'kb'
0126                       even
0127               
0128               txt.lines
0129 3296 054C             byte  5
0130 3297 ....             text  'Lines'
0131                       even
0132               
0133               txt.bufnum
0134 329C 0323             byte  3
0135 329D ....             text  '#1 '
0136                       even
0137               
0138               txt.newfile
0139 32A0 0A5B             byte  10
0140 32A1 ....             text  '[New file]'
0141                       even
0142               
0143               txt.filetype.dv80
0144 32AC 0444             byte  4
0145 32AD ....             text  'DV80'
0146                       even
0147               
0148               txt.filetype.none
0149 32B2 0420             byte  4
0150 32B3 ....             text  '    '
0151                       even
0152               
0153               
0154 32B8 010D     txt.alpha.up       data >010d
0155 32BA 010C     txt.alpha.down     data >010c
0156 32BC 010E     txt.vertline       data >010e
0157               
0158               
0159               ;--------------------------------------------------------------
0160               ; Dialog Load DV 80 file
0161               ;--------------------------------------------------------------
0162               txt.head.load
0163 32BE 0F4C             byte  15
0164 32BF ....             text  'Load DV80 file '
0165                       even
0166               
0167               txt.hint.load
0168 32CE 4D48             byte  77
0169 32CF ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0170                       even
0171               
0172               txt.keys.load
0173 331C 3746             byte  55
0174 331D ....             text  'F9=Back    F3=Clear    F5=Fastmode    ^A=Home    ^F=End'
0175                       even
0176               
0177               txt.keys.load2
0178 3354 3746             byte  55
0179 3355 ....             text  'F9=Back    F3=Clear   *F5=Fastmode    ^A=Home    ^F=End'
0180                       even
0181               
0182               
0183               ;--------------------------------------------------------------
0184               ; Dialog Save DV 80 file
0185               ;--------------------------------------------------------------
0186               txt.head.save
0187 338C 0F53             byte  15
0188 338D ....             text  'Save DV80 file '
0189                       even
0190               
0191               txt.hint.save
0192 339C 3F48             byte  63
0193 339D ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer.'
0194                       even
0195               
0196               txt.keys.save
0197 33DC 2846             byte  40
0198 33DD ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End'
0199                       even
0200               
0201               
0202               ;--------------------------------------------------------------
0203               ; Dialog "Unsaved changes"
0204               ;--------------------------------------------------------------
0205               txt.head.unsaved
0206 3406 1055             byte  16
0207 3407 ....             text  'Unsaved changes '
0208                       even
0209               
0210               txt.hint.unsaved
0211 3418 3F48             byte  63
0212 3419 ....             text  'HINT: Press F6 to proceed without saving or ENTER to save file.'
0213                       even
0214               
0215               txt.keys.unsaved
0216 3458 2846             byte  40
0217 3459 ....             text  'F9=Back    F6=Proceed    ENTER=Save file'
0218                       even
0219               
0220               txt.warn.unsaved
0221 3482 3259             byte  50
0222 3483 ....             text  'You are about to lose changes to the current file!'
0223                       even
0224               
0225               
0226               ;--------------------------------------------------------------
0227               ; Dialog "About"
0228               ;--------------------------------------------------------------
0229               txt.head.about
0230 34B6 0D41             byte  13
0231 34B7 ....             text  'About Stevie '
0232                       even
0233               
0234               txt.hint.about
0235 34C4 2C48             byte  44
0236 34C5 ....             text  'HINT: Press F9 or ENTER to return to editor.'
0237                       even
0238               
0239               txt.keys.about
0240 34F2 1546             byte  21
0241 34F3 ....             text  'F9=Back    ENTER=Back'
0242                       even
0243               
0244               
0245               ;--------------------------------------------------------------
0246               ; Strings for error line pane
0247               ;--------------------------------------------------------------
0248               txt.ioerr.load
0249 3508 2049             byte  32
0250 3509 ....             text  'I/O error. Failed loading file: '
0251                       even
0252               
0253               txt.ioerr.save
0254 352A 1F49             byte  31
0255 352B ....             text  'I/O error. Failed saving file: '
0256                       even
0257               
0258               txt.io.nofile
0259 354A 2149             byte  33
0260 354B ....             text  'I/O error. No filename specified.'
0261                       even
0262               
0263               
0264               
0265               ;--------------------------------------------------------------
0266               ; Strings for command buffer
0267               ;--------------------------------------------------------------
0268               txt.cmdb.title
0269 356C 0E43             byte  14
0270 356D ....             text  'Command buffer'
0271                       even
0272               
0273               txt.cmdb.prompt
0274 357C 013E             byte  1
0275 357D ....             text  '>'
0276                       even
0277               
0278               
0279 357E 0C0A     txt.stevie         byte    12
0280                                  byte    10
0281 3580 ....                        text    'stevie v1.00'
0282 358C 0B00                        byte    11
0283                                  even
0284               
0285               txt.colorscheme
0286 358E 0E43             byte  14
0287 358F ....             text  'Color scheme: '
0288                       even
0289               
0290               
**** **** ****     > stevie_b1.asm.1638280
0078                       copy  "data.keymap.asm"     ; Data segment - Keaboard mapping
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
0105 359E 0866             byte  8
0106 359F ....             text  'fctn + 0'
0107                       even
0108               
0109               txt.fctn.1
0110 35A8 0866             byte  8
0111 35A9 ....             text  'fctn + 1'
0112                       even
0113               
0114               txt.fctn.2
0115 35B2 0866             byte  8
0116 35B3 ....             text  'fctn + 2'
0117                       even
0118               
0119               txt.fctn.3
0120 35BC 0866             byte  8
0121 35BD ....             text  'fctn + 3'
0122                       even
0123               
0124               txt.fctn.4
0125 35C6 0866             byte  8
0126 35C7 ....             text  'fctn + 4'
0127                       even
0128               
0129               txt.fctn.5
0130 35D0 0866             byte  8
0131 35D1 ....             text  'fctn + 5'
0132                       even
0133               
0134               txt.fctn.6
0135 35DA 0866             byte  8
0136 35DB ....             text  'fctn + 6'
0137                       even
0138               
0139               txt.fctn.7
0140 35E4 0866             byte  8
0141 35E5 ....             text  'fctn + 7'
0142                       even
0143               
0144               txt.fctn.8
0145 35EE 0866             byte  8
0146 35EF ....             text  'fctn + 8'
0147                       even
0148               
0149               txt.fctn.9
0150 35F8 0866             byte  8
0151 35F9 ....             text  'fctn + 9'
0152                       even
0153               
0154               txt.fctn.a
0155 3602 0866             byte  8
0156 3603 ....             text  'fctn + a'
0157                       even
0158               
0159               txt.fctn.b
0160 360C 0866             byte  8
0161 360D ....             text  'fctn + b'
0162                       even
0163               
0164               txt.fctn.c
0165 3616 0866             byte  8
0166 3617 ....             text  'fctn + c'
0167                       even
0168               
0169               txt.fctn.d
0170 3620 0866             byte  8
0171 3621 ....             text  'fctn + d'
0172                       even
0173               
0174               txt.fctn.e
0175 362A 0866             byte  8
0176 362B ....             text  'fctn + e'
0177                       even
0178               
0179               txt.fctn.f
0180 3634 0866             byte  8
0181 3635 ....             text  'fctn + f'
0182                       even
0183               
0184               txt.fctn.g
0185 363E 0866             byte  8
0186 363F ....             text  'fctn + g'
0187                       even
0188               
0189               txt.fctn.h
0190 3648 0866             byte  8
0191 3649 ....             text  'fctn + h'
0192                       even
0193               
0194               txt.fctn.i
0195 3652 0866             byte  8
0196 3653 ....             text  'fctn + i'
0197                       even
0198               
0199               txt.fctn.j
0200 365C 0866             byte  8
0201 365D ....             text  'fctn + j'
0202                       even
0203               
0204               txt.fctn.k
0205 3666 0866             byte  8
0206 3667 ....             text  'fctn + k'
0207                       even
0208               
0209               txt.fctn.l
0210 3670 0866             byte  8
0211 3671 ....             text  'fctn + l'
0212                       even
0213               
0214               txt.fctn.m
0215 367A 0866             byte  8
0216 367B ....             text  'fctn + m'
0217                       even
0218               
0219               txt.fctn.n
0220 3684 0866             byte  8
0221 3685 ....             text  'fctn + n'
0222                       even
0223               
0224               txt.fctn.o
0225 368E 0866             byte  8
0226 368F ....             text  'fctn + o'
0227                       even
0228               
0229               txt.fctn.p
0230 3698 0866             byte  8
0231 3699 ....             text  'fctn + p'
0232                       even
0233               
0234               txt.fctn.q
0235 36A2 0866             byte  8
0236 36A3 ....             text  'fctn + q'
0237                       even
0238               
0239               txt.fctn.r
0240 36AC 0866             byte  8
0241 36AD ....             text  'fctn + r'
0242                       even
0243               
0244               txt.fctn.s
0245 36B6 0866             byte  8
0246 36B7 ....             text  'fctn + s'
0247                       even
0248               
0249               txt.fctn.t
0250 36C0 0866             byte  8
0251 36C1 ....             text  'fctn + t'
0252                       even
0253               
0254               txt.fctn.u
0255 36CA 0866             byte  8
0256 36CB ....             text  'fctn + u'
0257                       even
0258               
0259               txt.fctn.v
0260 36D4 0866             byte  8
0261 36D5 ....             text  'fctn + v'
0262                       even
0263               
0264               txt.fctn.w
0265 36DE 0866             byte  8
0266 36DF ....             text  'fctn + w'
0267                       even
0268               
0269               txt.fctn.x
0270 36E8 0866             byte  8
0271 36E9 ....             text  'fctn + x'
0272                       even
0273               
0274               txt.fctn.y
0275 36F2 0866             byte  8
0276 36F3 ....             text  'fctn + y'
0277                       even
0278               
0279               txt.fctn.z
0280 36FC 0866             byte  8
0281 36FD ....             text  'fctn + z'
0282                       even
0283               
0284               *---------------------------------------------------------------
0285               * Keyboard labels - Function keys extra
0286               *---------------------------------------------------------------
0287               txt.fctn.dot
0288 3706 0866             byte  8
0289 3707 ....             text  'fctn + .'
0290                       even
0291               
0292               txt.fctn.plus
0293 3710 0866             byte  8
0294 3711 ....             text  'fctn + +'
0295                       even
0296               
0297               
0298               txt.ctrl.dot
0299 371A 0863             byte  8
0300 371B ....             text  'ctrl + .'
0301                       even
0302               
0303               txt.ctrl.comma
0304 3724 0863             byte  8
0305 3725 ....             text  'ctrl + ,'
0306                       even
0307               
0308               *---------------------------------------------------------------
0309               * Keyboard labels - Control keys
0310               *---------------------------------------------------------------
0311               txt.ctrl.0
0312 372E 0863             byte  8
0313 372F ....             text  'ctrl + 0'
0314                       even
0315               
0316               txt.ctrl.1
0317 3738 0863             byte  8
0318 3739 ....             text  'ctrl + 1'
0319                       even
0320               
0321               txt.ctrl.2
0322 3742 0863             byte  8
0323 3743 ....             text  'ctrl + 2'
0324                       even
0325               
0326               txt.ctrl.3
0327 374C 0863             byte  8
0328 374D ....             text  'ctrl + 3'
0329                       even
0330               
0331               txt.ctrl.4
0332 3756 0863             byte  8
0333 3757 ....             text  'ctrl + 4'
0334                       even
0335               
0336               txt.ctrl.5
0337 3760 0863             byte  8
0338 3761 ....             text  'ctrl + 5'
0339                       even
0340               
0341               txt.ctrl.6
0342 376A 0863             byte  8
0343 376B ....             text  'ctrl + 6'
0344                       even
0345               
0346               txt.ctrl.7
0347 3774 0863             byte  8
0348 3775 ....             text  'ctrl + 7'
0349                       even
0350               
0351               txt.ctrl.8
0352 377E 0863             byte  8
0353 377F ....             text  'ctrl + 8'
0354                       even
0355               
0356               txt.ctrl.9
0357 3788 0863             byte  8
0358 3789 ....             text  'ctrl + 9'
0359                       even
0360               
0361               txt.ctrl.a
0362 3792 0863             byte  8
0363 3793 ....             text  'ctrl + a'
0364                       even
0365               
0366               txt.ctrl.b
0367 379C 0863             byte  8
0368 379D ....             text  'ctrl + b'
0369                       even
0370               
0371               txt.ctrl.c
0372 37A6 0863             byte  8
0373 37A7 ....             text  'ctrl + c'
0374                       even
0375               
0376               txt.ctrl.d
0377 37B0 0863             byte  8
0378 37B1 ....             text  'ctrl + d'
0379                       even
0380               
0381               txt.ctrl.e
0382 37BA 0863             byte  8
0383 37BB ....             text  'ctrl + e'
0384                       even
0385               
0386               txt.ctrl.f
0387 37C4 0863             byte  8
0388 37C5 ....             text  'ctrl + f'
0389                       even
0390               
0391               txt.ctrl.g
0392 37CE 0863             byte  8
0393 37CF ....             text  'ctrl + g'
0394                       even
0395               
0396               txt.ctrl.h
0397 37D8 0863             byte  8
0398 37D9 ....             text  'ctrl + h'
0399                       even
0400               
0401               txt.ctrl.i
0402 37E2 0863             byte  8
0403 37E3 ....             text  'ctrl + i'
0404                       even
0405               
0406               txt.ctrl.j
0407 37EC 0863             byte  8
0408 37ED ....             text  'ctrl + j'
0409                       even
0410               
0411               txt.ctrl.k
0412 37F6 0863             byte  8
0413 37F7 ....             text  'ctrl + k'
0414                       even
0415               
0416               txt.ctrl.l
0417 3800 0863             byte  8
0418 3801 ....             text  'ctrl + l'
0419                       even
0420               
0421               txt.ctrl.m
0422 380A 0863             byte  8
0423 380B ....             text  'ctrl + m'
0424                       even
0425               
0426               txt.ctrl.n
0427 3814 0863             byte  8
0428 3815 ....             text  'ctrl + n'
0429                       even
0430               
0431               txt.ctrl.o
0432 381E 0863             byte  8
0433 381F ....             text  'ctrl + o'
0434                       even
0435               
0436               txt.ctrl.p
0437 3828 0863             byte  8
0438 3829 ....             text  'ctrl + p'
0439                       even
0440               
0441               txt.ctrl.q
0442 3832 0863             byte  8
0443 3833 ....             text  'ctrl + q'
0444                       even
0445               
0446               txt.ctrl.r
0447 383C 0863             byte  8
0448 383D ....             text  'ctrl + r'
0449                       even
0450               
0451               txt.ctrl.s
0452 3846 0863             byte  8
0453 3847 ....             text  'ctrl + s'
0454                       even
0455               
0456               txt.ctrl.t
0457 3850 0863             byte  8
0458 3851 ....             text  'ctrl + t'
0459                       even
0460               
0461               txt.ctrl.u
0462 385A 0863             byte  8
0463 385B ....             text  'ctrl + u'
0464                       even
0465               
0466               txt.ctrl.v
0467 3864 0863             byte  8
0468 3865 ....             text  'ctrl + v'
0469                       even
0470               
0471               txt.ctrl.w
0472 386E 0863             byte  8
0473 386F ....             text  'ctrl + w'
0474                       even
0475               
0476               txt.ctrl.x
0477 3878 0863             byte  8
0478 3879 ....             text  'ctrl + x'
0479                       even
0480               
0481               txt.ctrl.y
0482 3882 0863             byte  8
0483 3883 ....             text  'ctrl + y'
0484                       even
0485               
0486               txt.ctrl.z
0487 388C 0863             byte  8
0488 388D ....             text  'ctrl + z'
0489                       even
0490               
0491               *---------------------------------------------------------------
0492               * Keyboard labels - control keys extra
0493               *---------------------------------------------------------------
0494               txt.ctrl.plus
0495 3896 0863             byte  8
0496 3897 ....             text  'ctrl + +'
0497                       even
0498               
0499               *---------------------------------------------------------------
0500               * Special keys
0501               *---------------------------------------------------------------
0502               txt.enter
0503 38A0 0565             byte  5
0504 38A1 ....             text  'enter'
0505                       even
0506               
**** **** ****     > stevie_b1.asm.1638280
0079                       ;------------------------------------------------------
0080                       ; End of File marker
0081                       ;------------------------------------------------------
0082 38A6 DEAD             data  >dead,>beef,>dead,>beef
     38A8 BEEF 
     38AA DEAD 
     38AC BEEF 
0084               ***************************************************************
0085               * Step 4: Include main editor modules
0086               ********|*****|*********************|**************************
0087               main:
0088                       aorg  kickstart.code2       ; >6036
0089 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0090                       ;-----------------------------------------------------------------------
0091                       ; Include files
0092                       ;-----------------------------------------------------------------------
0093                       copy  "main.asm"            ; Main file (entrypoint)
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
     6046 265E 
0042               
0043 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 2702 
0044 604C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     604E 233E 
0045 6050 3140                   data >3140            ; F18a VR49 (>31), bit 40
0046               
0047 6052 06A0  32         bl    @putvr                ; Turn on position based attributes
     6054 233E 
0048 6056 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6058 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     605A 233E 
0051 605C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 605E 06A0  32         bl    @filv
     6060 229A 
0056 6062 0000                   data >0000,32,30*80   ; Clear screen
     6064 0020 
     6066 0960 
0057                       ;------------------------------------------------------
0058                       ; Initialize high memory expansion
0059                       ;------------------------------------------------------
0060 6068 06A0  32         bl    @film
     606A 2242 
0061 606C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     606E 0000 
     6070 6000 
0062                       ;------------------------------------------------------
0063                       ; Setup SAMS windows
0064                       ;------------------------------------------------------
0065 6072 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6074 6888 
0066                       ;------------------------------------------------------
0067                       ; Setup cursor, screen, etc.
0068                       ;------------------------------------------------------
0069 6076 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6078 267E 
0070 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 268E 
0071               
0072 607E 06A0  32         bl    @cpym2m
     6080 24AA 
0073 6082 3012                   data romsat,ramsat,4  ; Load sprite SAT
     6084 2F54 
     6086 0004 
0074               
0075 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 3014 
     608C A014 
0076                                                   ; Save cursor shape & color
0077               
0078 608E 06A0  32         bl    @cpym2v
     6090 2456 
0079 6092 2800                   data sprpdt,cursors,3*8
     6094 3016 
     6096 0018 
0080                                                   ; Load sprite cursor patterns
0081               
0082 6098 06A0  32         bl    @cpym2v
     609A 2456 
0083 609C 1008                   data >1008,patterns,14*8
     609E 302E 
     60A0 0070 
0084                                                   ; Load character patterns
0085               *--------------------------------------------------------------
0086               * Initialize
0087               *--------------------------------------------------------------
0088 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 6852 
0089 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 686C 
0090                       ;------------------------------------------------------
0091                       ; Load colorscheme amd turn on screen
0092                       ;------------------------------------------------------
0093 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 78E4 
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
     60B8 269E 
0102 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0103               
0104 60BC 0204  20         li    tmp0,timers
     60BE 2F44 
0105 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0106               
0107 60C4 06A0  32         bl    @mkslot
     60C6 2DD2 
0108 60C8 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 7668 
0109 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60CE 7726 
0110 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60D2 775A 
0111 60D4 032F                   data >032f,task.oneshot      ; Task 3 - One shot task
     60D6 77A8 
0112 60D8 FFFF                   data eol
0113               
0114 60DA 06A0  32         bl    @mkhook
     60DC 2DBE 
0115 60DE 762A                   data hook.keyscan     ; Setup user hook
0116               
0117 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2D14 
**** **** ****     > stevie_b1.asm.1638280
0094                       ;-----------------------------------------------------------------------
0095                       ; Keyboard actions
0096                       ;-----------------------------------------------------------------------
0097                       copy  "edkey.key.process.asm"    ; Process keyboard actions
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
     6108 7E34 
0033 610A 1003  14         jmp   edkey.key.check.next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 610C 0206  20         li    tmp2,keymap_actions.cmdb
     610E 7ED2 
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
     6124 A01A 
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
     614A A01A 
0089 614C 1602  14         jne   !                     ; No, skip frame buffer
0090 614E 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6150 6650 
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
     6164 6762 
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
     6170 765C 
**** **** ****     > stevie_b1.asm.1638280
0098                       ;-----------------------------------------------------------------------
0099                       ; Keyboard actions - Framebuffer
0100                       ;-----------------------------------------------------------------------
0101                       copy  "edkey.fb.mov.leftright.asm"
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
     6186 765C 
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
     619E 765C 
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
     61B2 6940 
0050 61B4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61B6 765C 
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
     61CC 26B6 
0065 61CE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61D0 6940 
0066 61D2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61D4 765C 
**** **** ****     > stevie_b1.asm.1638280
0102                                                        ; Move left / right / home / end
0103                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
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
     621E 26B6 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.pword.exit:
0068 6220 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6222 6940 
0069 6224 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6226 765C 
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
     627E 26B6 
0147                       ;-------------------------------------------------------
0148                       ; Exit
0149                       ;-------------------------------------------------------
0150               edkey.action.nword.exit:
0151 6280 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6282 6940 
0152 6284 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6286 765C 
0153               
0154               
**** **** ****     > stevie_b1.asm.1638280
0104                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
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
     6292 6CDC 
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
     62AC 69A4 
0032 62AE 1004  14         jmp   edkey.action.up.set_cursorx
0033                       ;-------------------------------------------------------
0034                       ; Move cursor up
0035                       ;-------------------------------------------------------
0036               edkey.action.up.cursor_up:
0037 62B0 0620  34         dec   @fb.row               ; Row-- in screen buffer
     62B2 A106 
0038 62B4 06A0  32         bl    @up                   ; Row-- VDP cursor
     62B6 26AC 
0039                       ;-------------------------------------------------------
0040                       ; Check line length and position cursor
0041                       ;-------------------------------------------------------
0042               edkey.action.up.set_cursorx:
0043 62B8 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     62BA 6EC0 
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
     62D0 26B6 
0055                       ;-------------------------------------------------------
0056                       ; Exit
0057                       ;-------------------------------------------------------
0058               edkey.action.up.exit:
0059 62D2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62D4 6940 
0060 62D6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62D8 765C 
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
     62EC 6CDC 
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
     6318 69A4 
0102 631A 1004  14         jmp   edkey.action.down.set_cursorx
0103                       ;-------------------------------------------------------
0104                       ; Move cursor down a row, there are still rows left
0105                       ;-------------------------------------------------------
0106               edkey.action.down.cursor:
0107 631C 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     631E A106 
0108 6320 06A0  32         bl    @down                 ; Row++ VDP cursor
     6322 26A4 
0109                       ;-------------------------------------------------------
0110                       ; Check line length and position cursor
0111                       ;-------------------------------------------------------
0112               edkey.action.down.set_cursorx:
0113 6324 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6326 6EC0 
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
     633C 26B6 
0126                       ;-------------------------------------------------------
0127                       ; Exit
0128                       ;-------------------------------------------------------
0129               edkey.action.down.exit:
0130 633E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6340 6940 
0131 6342 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6344 765C 
**** **** ****     > stevie_b1.asm.1638280
0105                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
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
0010                       ; Sanity check
0011                       ;-------------------------------------------------------
0012 6346 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6348 A104 
0013 634A 1315  14         jeq   edkey.action.ppage.exit
0014                       ;-------------------------------------------------------
0015                       ; Special treatment top page
0016                       ;-------------------------------------------------------
0017 634C 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     634E A118 
0018 6350 1503  14         jgt   edkey.action.ppage.topline
0019 6352 04E0  34         clr   @fb.topline           ; topline = 0
     6354 A104 
0020 6356 1003  14         jmp   edkey.action.ppage.crunch
0021                       ;-------------------------------------------------------
0022                       ; Adjust topline
0023                       ;-------------------------------------------------------
0024               edkey.action.ppage.topline:
0025 6358 6820  54         s     @fb.scrrows,@fb.topline
     635A A118 
     635C A104 
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029               edkey.action.ppage.crunch:
0030 635E 8820  54         c     @fb.row.dirty,@w$ffff
     6360 A10A 
     6362 202C 
0031 6364 1604  14         jne   edkey.action.ppage.refresh
0032 6366 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6368 6CDC 
0033 636A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     636C A10A 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 636E C820  54         mov   @fb.topline,@parm1
     6370 A104 
     6372 2F20 
0039               
0040 6374 101A  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0041                                                   ; / i  @parm1 = Line in editor buffer
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               edkey.action.ppage.exit:
0046 6376 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6378 765C 
0047               
0048               
0049               
0050               
0051               *---------------------------------------------------------------
0052               * Next page
0053               *---------------------------------------------------------------
0054               edkey.action.npage:
0055                       ;-------------------------------------------------------
0056                       ; Sanity check
0057                       ;-------------------------------------------------------
0058 637A C120  34         mov   @fb.topline,tmp0
     637C A104 
0059 637E A120  34         a     @fb.scrrows,tmp0
     6380 A118 
0060 6382 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6384 A204 
0061 6386 150F  14         jgt   edkey.action.npage.exit
0062                       ;-------------------------------------------------------
0063                       ; Adjust topline
0064                       ;-------------------------------------------------------
0065               edkey.action.npage.topline:
0066 6388 A820  54         a     @fb.scrrows,@fb.topline
     638A A118 
     638C A104 
0067                       ;-------------------------------------------------------
0068                       ; Crunch current row if dirty
0069                       ;-------------------------------------------------------
0070               edkey.action.npage.crunch:
0071 638E 8820  54         c     @fb.row.dirty,@w$ffff
     6390 A10A 
     6392 202C 
0072 6394 1604  14         jne   edkey.action.npage.refresh
0073 6396 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6398 6CDC 
0074 639A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     639C A10A 
0075                       ;-------------------------------------------------------
0076                       ; Refresh page
0077                       ;-------------------------------------------------------
0078               edkey.action.npage.refresh:
0079 639E C820  54         mov   @fb.topline,@parm1
     63A0 A104 
     63A2 2F20 
0080               
0081 63A4 1002  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0082                                                   ; / i  @parm1 = Line in editor buffer
0083                       ;-------------------------------------------------------
0084                       ; Exit
0085                       ;-------------------------------------------------------
0086               edkey.action.npage.exit:
0087 63A6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63A8 765C 
**** **** ****     > stevie_b1.asm.1638280
0106                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
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
0026 63AA 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     63AC 69A4 
0027                                                   ; | i  @parm1 = Line to start with
0028                                                   ; /             (becomes @fb.topline)
0029               
0030 63AE 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63B0 A106 
0031 63B2 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63B4 A10C 
0032 63B6 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     63B8 832A 
0033               
0034 63BA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63BC 6940 
0035               
0036 63BE 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     63C0 6EC0 
0037                                                   ; | i  @fb.row        = Row in frame buffer
0038                                                   ; / o  @fb.row.length = Length of row
0039               
0040 63C2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63C4 765C 
0041               
0042               
0043               *---------------------------------------------------------------
0044               * Goto top of file
0045               *---------------------------------------------------------------
0046               edkey.action.top:
0047                       ;-------------------------------------------------------
0048                       ; Crunch current row if dirty
0049                       ;-------------------------------------------------------
0050 63C6 8820  54         c     @fb.row.dirty,@w$ffff
     63C8 A10A 
     63CA 202C 
0051 63CC 1604  14         jne   edkey.action.top.refresh
0052 63CE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63D0 6CDC 
0053 63D2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63D4 A10A 
0054                       ;-------------------------------------------------------
0055                       ; Refresh page
0056                       ;-------------------------------------------------------
0057               edkey.action.top.refresh:
0058 63D6 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     63D8 2F20 
0059               
0060 63DA 10E7  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
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
0073 63DC 8820  54         c     @fb.row.dirty,@w$ffff
     63DE A10A 
     63E0 202C 
0074 63E2 1604  14         jne   edkey.action.bot.refresh
0075 63E4 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63E6 6CDC 
0076 63E8 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63EA A10A 
0077                       ;-------------------------------------------------------
0078                       ; Refresh page
0079                       ;-------------------------------------------------------
0080               edkey.action.bot.refresh:
0081 63EC 8820  54         c     @edb.lines,@fb.scrrows
     63EE A204 
     63F0 A118 
0082 63F2 1207  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0083               
0084 63F4 C120  34         mov   @edb.lines,tmp0
     63F6 A204 
0085 63F8 6120  34         s     @fb.scrrows,tmp0
     63FA A118 
0086 63FC C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     63FE 2F20 
0087               
0088 6400 10D4  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0089                                                   ; / i  @parm1 = Line in editor buffer
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.bot.exit:
0094 6402 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6404 765C 
**** **** ****     > stevie_b1.asm.1638280
0107                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 6406 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6408 A206 
0010 640A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     640C 6940 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1 - Empty line
0013                       ;-------------------------------------------------------
0014               edkey.action.del_char.sanity1:
0015 640E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6410 A108 
0016 6412 1336  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018               
0019 6414 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6416 A102 
0020                       ;-------------------------------------------------------
0021                       ; Sanity check 2 - Already at EOL
0022                       ;-------------------------------------------------------
0023               edkey.action.del_char.sanity2:
0024 6418 C1C6  18         mov   tmp2,tmp3             ; \
0025 641A 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0026 641C 81E0  34         c     @fb.column,tmp3
     641E A10C 
0027 6420 110A  14         jlt   edkey.action.del_char.sanity3
0028               
0029                       ;------------------------------------------------------
0030                       ; At EOL - clear current character
0031                       ;------------------------------------------------------
0032 6422 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0033 6424 D505  30         movb  tmp1,*tmp0            ; /
0034 6426 C820  54         mov   @fb.column,@fb.row.length
     6428 A10C 
     642A A108 
0035                                                   ; Row length - 1
0036 642C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     642E A10A 
0037 6430 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6432 A116 
0038 6434 1025  14         jmp  edkey.action.del_char.exit
0039                       ;-------------------------------------------------------
0040                       ; Sanity check 3 - Abort if row length > 80
0041                       ;-------------------------------------------------------
0042               edkey.action.del_char.sanity3:
0043 6436 0286  22         ci    tmp2,colrow
     6438 0050 
0044 643A 1204  14         jle   edkey.action.del_char.prep
0045                                                   ; Continue if row length <= 80
0046                       ;-----------------------------------------------------------------------
0047                       ; CPU crash
0048                       ;-----------------------------------------------------------------------
0049 643C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     643E FFCE 
0050 6440 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6442 2030 
0051                       ;-------------------------------------------------------
0052                       ; Calculate number of characters to move
0053                       ;-------------------------------------------------------
0054               edkey.action.del_char.prep:
0055 6444 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0056 6446 61E0  34         s     @fb.column,tmp3
     6448 A10C 
0057 644A 0607  14         dec   tmp3                  ; Remove base 1 offset
0058 644C A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0059 644E C144  18         mov   tmp0,tmp1
0060 6450 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0061 6452 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6454 A10C 
0062                       ;-------------------------------------------------------
0063                       ; Setup pointers
0064                       ;-------------------------------------------------------
0065 6456 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6458 A102 
0066 645A C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0067 645C 0585  14         inc   tmp1                  ; / tmp1 = Next character
0068                       ;-------------------------------------------------------
0069                       ; Loop from current character until end of line
0070                       ;-------------------------------------------------------
0071               edkey.action.del_char.loop:
0072 645E DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0073 6460 0606  14         dec   tmp2
0074 6462 16FD  14         jne   edkey.action.del_char.loop
0075                       ;-------------------------------------------------------
0076                       ; Special treatment if line 80 characters long
0077                       ;-------------------------------------------------------
0078 6464 0206  20         li    tmp2,colrow
     6466 0050 
0079 6468 81A0  34         c     @fb.row.length,tmp2
     646A A108 
0080 646C 1603  14         jne   edkey.action.del_char.save
0081 646E 0604  14         dec   tmp0                  ; One time adjustment
0082 6470 04C5  14         clr   tmp1
0083 6472 D505  30         movb  tmp1,*tmp0            ; Write >00 character
0084                       ;-------------------------------------------------------
0085                       ; Save variables
0086                       ;-------------------------------------------------------
0087               edkey.action.del_char.save:
0088 6474 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6476 A10A 
0089 6478 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     647A A116 
0090 647C 0620  34         dec   @fb.row.length        ; @fb.row.length--
     647E A108 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               edkey.action.del_char.exit:
0095 6480 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6482 765C 
0096               
0097               
0098               *---------------------------------------------------------------
0099               * Delete until end of line
0100               *---------------------------------------------------------------
0101               edkey.action.del_eol:
0102 6484 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6486 A206 
0103 6488 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     648A 6940 
0104 648C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     648E A108 
0105 6490 1311  14         jeq   edkey.action.del_eol.exit
0106                                                   ; Exit if empty line
0107                       ;-------------------------------------------------------
0108                       ; Prepare for erase operation
0109                       ;-------------------------------------------------------
0110 6492 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6494 A102 
0111 6496 C1A0  34         mov   @fb.colsline,tmp2
     6498 A10E 
0112 649A 61A0  34         s     @fb.column,tmp2
     649C A10C 
0113 649E 04C5  14         clr   tmp1
0114                       ;-------------------------------------------------------
0115                       ; Loop until last column in frame buffer
0116                       ;-------------------------------------------------------
0117               edkey.action.del_eol_loop:
0118 64A0 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0119 64A2 0606  14         dec   tmp2
0120 64A4 16FD  14         jne   edkey.action.del_eol_loop
0121                       ;-------------------------------------------------------
0122                       ; Save variables
0123                       ;-------------------------------------------------------
0124 64A6 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64A8 A10A 
0125 64AA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64AC A116 
0126               
0127 64AE C820  54         mov   @fb.column,@fb.row.length
     64B0 A10C 
     64B2 A108 
0128                                                   ; Set new row length
0129                       ;-------------------------------------------------------
0130                       ; Exit
0131                       ;-------------------------------------------------------
0132               edkey.action.del_eol.exit:
0133 64B4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64B6 765C 
0134               
0135               
0136               *---------------------------------------------------------------
0137               * Delete current line
0138               *---------------------------------------------------------------
0139               edkey.action.del_line:
0140 64B8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64BA A206 
0141                       ;-------------------------------------------------------
0142                       ; Special treatment if only 1 line in file
0143                       ;-------------------------------------------------------
0144 64BC C120  34         mov   @edb.lines,tmp0
     64BE A204 
0145 64C0 1606  14         jne   !
0146 64C2 04E0  34         clr   @fb.column            ; Column 0
     64C4 A10C 
0147 64C6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64C8 6940 
0148 64CA 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     64CC 6484 
0149                       ;-------------------------------------------------------
0150                       ; Delete entry in index
0151                       ;-------------------------------------------------------
0152 64CE 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64D0 6940 
0153 64D2 04E0  34         clr   @fb.row.dirty         ; Discard current line
     64D4 A10A 
0154 64D6 C820  54         mov   @fb.topline,@parm1
     64D8 A104 
     64DA 2F20 
0155 64DC A820  54         a     @fb.row,@parm1        ; Line number to remove
     64DE A106 
     64E0 2F20 
0156 64E2 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     64E4 A204 
     64E6 2F22 
0157 64E8 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     64EA 6BC4 
0158 64EC 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64EE A204 
0159                       ;-------------------------------------------------------
0160                       ; Refresh frame buffer and physical screen
0161                       ;-------------------------------------------------------
0162 64F0 C820  54         mov   @fb.topline,@parm1
     64F2 A104 
     64F4 2F20 
0163 64F6 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64F8 69A4 
0164 64FA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64FC A116 
0165                       ;-------------------------------------------------------
0166                       ; Special treatment if current line was last line
0167                       ;-------------------------------------------------------
0168 64FE C120  34         mov   @fb.topline,tmp0
     6500 A104 
0169 6502 A120  34         a     @fb.row,tmp0
     6504 A106 
0170 6506 8804  38         c     tmp0,@edb.lines       ; Was last line?
     6508 A204 
0171 650A 1202  14         jle   edkey.action.del_line.exit
0172 650C 0460  28         b     @edkey.action.up      ; One line up
     650E 6288 
0173                       ;-------------------------------------------------------
0174                       ; Exit
0175                       ;-------------------------------------------------------
0176               edkey.action.del_line.exit:
0177 6510 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6512 61A0 
**** **** ****     > stevie_b1.asm.1638280
0108                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
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
0011 6514 0204  20         li    tmp0,>2000            ; White space
     6516 2000 
0012 6518 C804  38         mov   tmp0,@parm1
     651A 2F20 
0013               edkey.action.ins_char:
0014 651C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     651E A206 
0015 6520 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6522 6940 
0016                       ;-------------------------------------------------------
0017                       ; Sanity check 1 - Empty line
0018                       ;-------------------------------------------------------
0019 6524 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6526 A102 
0020 6528 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     652A A108 
0021 652C 132C  14         jeq   edkey.action.ins_char.append
0022                                                   ; Add character in append mode
0023                       ;-------------------------------------------------------
0024                       ; Sanity check 2 - EOL
0025                       ;-------------------------------------------------------
0026 652E 8820  54         c     @fb.column,@fb.row.length
     6530 A10C 
     6532 A108 
0027 6534 1328  14         jeq   edkey.action.ins_char.append
0028                                                   ; Add character in append mode
0029                       ;-------------------------------------------------------
0030                       ; Sanity check 3 - Overwrite if at column 80
0031                       ;-------------------------------------------------------
0032 6536 C160  34         mov   @fb.column,tmp1
     6538 A10C 
0033 653A 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     653C 004F 
0034 653E 1102  14         jlt   !
0035 6540 0460  28         b     @edkey.action.char.overwrite
     6542 6672 
0036                       ;-------------------------------------------------------
0037                       ; Sanity check 4 - 80 characters maximum
0038                       ;-------------------------------------------------------
0039 6544 C160  34 !       mov   @fb.row.length,tmp1
     6546 A108 
0040 6548 0285  22         ci    tmp1,colrow
     654A 0050 
0041 654C 1101  14         jlt   edkey.action.ins_char.prep
0042 654E 101D  14         jmp   edkey.action.ins_char.exit
0043                       ;-------------------------------------------------------
0044                       ; Calculate number of characters to move
0045                       ;-------------------------------------------------------
0046               edkey.action.ins_char.prep:
0047 6550 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0048 6552 61E0  34         s     @fb.column,tmp3
     6554 A10C 
0049 6556 0607  14         dec   tmp3                  ; Remove base 1 offset
0050 6558 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0051 655A C144  18         mov   tmp0,tmp1
0052 655C 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0053 655E 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6560 A10C 
0054                       ;-------------------------------------------------------
0055                       ; Loop from end of line until current character
0056                       ;-------------------------------------------------------
0057               edkey.action.ins_char.loop:
0058 6562 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0059 6564 0604  14         dec   tmp0
0060 6566 0605  14         dec   tmp1
0061 6568 0606  14         dec   tmp2
0062 656A 16FB  14         jne   edkey.action.ins_char.loop
0063                       ;-------------------------------------------------------
0064                       ; Insert specified character at current position
0065                       ;-------------------------------------------------------
0066 656C D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     656E 2F20 
0067                       ;-------------------------------------------------------
0068                       ; Save variables and exit
0069                       ;-------------------------------------------------------
0070 6570 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6572 A10A 
0071 6574 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6576 A116 
0072 6578 05A0  34         inc   @fb.column
     657A A10C 
0073 657C 05A0  34         inc   @wyx
     657E 832A 
0074 6580 05A0  34         inc   @fb.row.length        ; @fb.row.length
     6582 A108 
0075 6584 1002  14         jmp   edkey.action.ins_char.exit
0076                       ;-------------------------------------------------------
0077                       ; Add character in append mode
0078                       ;-------------------------------------------------------
0079               edkey.action.ins_char.append:
0080 6586 0460  28         b     @edkey.action.char.overwrite
     6588 6672 
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.ins_char.exit:
0085 658A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     658C 765C 
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
0096 658E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6590 A206 
0097                       ;-------------------------------------------------------
0098                       ; Crunch current line if dirty
0099                       ;-------------------------------------------------------
0100 6592 8820  54         c     @fb.row.dirty,@w$ffff
     6594 A10A 
     6596 202C 
0101 6598 1604  14         jne   edkey.action.ins_line.insert
0102 659A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     659C 6CDC 
0103 659E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65A0 A10A 
0104                       ;-------------------------------------------------------
0105                       ; Insert entry in index
0106                       ;-------------------------------------------------------
0107               edkey.action.ins_line.insert:
0108 65A2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65A4 6940 
0109 65A6 C820  54         mov   @fb.topline,@parm1
     65A8 A104 
     65AA 2F20 
0110 65AC A820  54         a     @fb.row,@parm1        ; Line number to insert
     65AE A106 
     65B0 2F20 
0111 65B2 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     65B4 A204 
     65B6 2F22 
0112               
0113 65B8 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     65BA 6C4E 
0114                                                   ; \ i  parm1 = Line for insert
0115                                                   ; / i  parm2 = Last line to reorg
0116               
0117 65BC 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     65BE A204 
0118                       ;-------------------------------------------------------
0119                       ; Refresh frame buffer and physical screen
0120                       ;-------------------------------------------------------
0121 65C0 C820  54         mov   @fb.topline,@parm1
     65C2 A104 
     65C4 2F20 
0122 65C6 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     65C8 69A4 
0123 65CA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65CC A116 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.ins_line.exit:
0128 65CE 0460  28         b     @edkey.action.home    ; Position cursor at home
     65D0 61A0 
0129               
**** **** ****     > stevie_b1.asm.1638280
0109                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
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
0012 65D2 8820  54         c     @fb.row.dirty,@w$ffff
     65D4 A10A 
     65D6 202C 
0013 65D8 1606  14         jne   edkey.action.enter.upd_counter
0014 65DA 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65DC A206 
0015 65DE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     65E0 6CDC 
0016 65E2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65E4 A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 65E6 C120  34         mov   @fb.topline,tmp0
     65E8 A104 
0022 65EA A120  34         a     @fb.row,tmp0
     65EC A106 
0023 65EE 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     65F0 A204 
0024 65F2 1602  14         jne   edkey.action.newline  ; No, continue newline
0025 65F4 05A0  34         inc   @edb.lines            ; Total lines++
     65F6 A204 
0026                       ;-------------------------------------------------------
0027                       ; Process newline
0028                       ;-------------------------------------------------------
0029               edkey.action.newline:
0030                       ;-------------------------------------------------------
0031                       ; Scroll 1 line if cursor at bottom row of screen
0032                       ;-------------------------------------------------------
0033 65F8 C120  34         mov   @fb.scrrows,tmp0
     65FA A118 
0034 65FC 0604  14         dec   tmp0
0035 65FE 8120  34         c     @fb.row,tmp0
     6600 A106 
0036 6602 110A  14         jlt   edkey.action.newline.down
0037                       ;-------------------------------------------------------
0038                       ; Scroll
0039                       ;-------------------------------------------------------
0040 6604 C120  34         mov   @fb.scrrows,tmp0
     6606 A118 
0041 6608 C820  54         mov   @fb.topline,@parm1
     660A A104 
     660C 2F20 
0042 660E 05A0  34         inc   @parm1
     6610 2F20 
0043 6612 06A0  32         bl    @fb.refresh
     6614 69A4 
0044 6616 1004  14         jmp   edkey.action.newline.rest
0045                       ;-------------------------------------------------------
0046                       ; Move cursor down a row, there are still rows left
0047                       ;-------------------------------------------------------
0048               edkey.action.newline.down:
0049 6618 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     661A A106 
0050 661C 06A0  32         bl    @down                 ; Row++ VDP cursor
     661E 26A4 
0051                       ;-------------------------------------------------------
0052                       ; Set VDP cursor and save variables
0053                       ;-------------------------------------------------------
0054               edkey.action.newline.rest:
0055 6620 06A0  32         bl    @fb.get.firstnonblank
     6622 695C 
0056 6624 C120  34         mov   @outparm1,tmp0
     6626 2F30 
0057 6628 C804  38         mov   tmp0,@fb.column
     662A A10C 
0058 662C 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     662E 26B6 
0059 6630 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     6632 6EC0 
0060 6634 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6636 6940 
0061 6638 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     663A A116 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065               edkey.action.newline.exit:
0066 663C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     663E 765C 
0067               
0068               
0069               
0070               
0071               *---------------------------------------------------------------
0072               * Toggle insert/overwrite mode
0073               *---------------------------------------------------------------
0074               edkey.action.ins_onoff:
0075 6640 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     6642 A20A 
0076                       ;-------------------------------------------------------
0077                       ; Delay
0078                       ;-------------------------------------------------------
0079 6644 0204  20         li    tmp0,2000
     6646 07D0 
0080               edkey.action.ins_onoff.loop:
0081 6648 0604  14         dec   tmp0
0082 664A 16FE  14         jne   edkey.action.ins_onoff.loop
0083                       ;-------------------------------------------------------
0084                       ; Exit
0085                       ;-------------------------------------------------------
0086               edkey.action.ins_onoff.exit:
0087 664C 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     664E 775A 
0088               
0089               
0090               
0091               
0092               *---------------------------------------------------------------
0093               * Add character (frame buffer)
0094               *---------------------------------------------------------------
0095               edkey.action.char:
0096                       ;-------------------------------------------------------
0097                       ; Sanity checks
0098                       ;-------------------------------------------------------
0099 6650 D105  18         movb  tmp1,tmp0             ; Get keycode
0100 6652 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 6654 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6656 0020 
0103 6658 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 665A 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     665C 007E 
0107 665E 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 6660 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6662 A206 
0113 6664 D805  38         movb  tmp1,@parm1           ; Store character for insert
     6666 2F20 
0114 6668 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     666A A20A 
0115 666C 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 666E 0460  28         b     @edkey.action.ins_char
     6670 651C 
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 6672 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6674 6940 
0126 6676 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6678 A102 
0127               
0128 667A D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     667C 2F20 
0129 667E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6680 A10A 
0130 6682 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6684 A116 
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 6686 C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6688 A10C 
0135 668A 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     668C 004F 
0136 668E 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 6690 0205  20         li    tmp1,colrow           ; \
     6692 0050 
0140 6694 C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     6696 A108 
0141 6698 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 669A 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     669C A10C 
0147 669E 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     66A0 832A 
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 66A2 8820  54         c     @fb.column,@fb.row.length
     66A4 A10C 
     66A6 A108 
0152                                                   ; column < line length ?
0153 66A8 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 66AA C820  54         mov   @fb.column,@fb.row.length
     66AC A10C 
     66AE A108 
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 66B0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66B2 765C 
**** **** ****     > stevie_b1.asm.1638280
0110                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
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
0012 66B4 C120  34         mov   @edb.dirty,tmp0
     66B6 A206 
0013 66B8 1302  14         jeq   !
0014 66BA 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     66BC 7E0C 
0015                       ;-------------------------------------------------------
0016                       ; Reset and lock F18a
0017                       ;-------------------------------------------------------
0018 66BE 06A0  32 !       bl    @f18rst               ; Reset and lock the F18A
     66C0 2766 
0019 66C2 0420  54         blwp  @0                    ; Exit
     66C4 0000 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * No action at all
0024               *---------------------------------------------------------------
0025               edkey.action.noop:
0026 66C6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66C8 765C 
**** **** ****     > stevie_b1.asm.1638280
0111                       copy  "edkey.fb.file.asm"        ; File related actions
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
0017 66CA C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     66CC A444 
     66CE 2F20 
0018 66D0 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     66D2 2F22 
0019 66D4 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 66D6 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     66D8 A444 
     66DA 2F20 
0023 66DC 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     66DE 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Sanity check
0028                       ;------------------------------------------------------
0029 66E0 C120  34         mov   @parm1,tmp0
     66E2 2F20 
0030 66E4 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 66E6 C120  34         mov   @edb.dirty,tmp0
     66E8 A206 
0036 66EA 1302  14         jeq   !
0037 66EC 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     66EE 7E0C 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 66F0 06A0  32 !       bl    @fm.browse.fname.suffix.incdec
     66F2 75A8 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 66F4 0204  20         li    tmp0,heap.top         ; 1st line in heap
     66F6 E000 
0047 66F8 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     66FA 736A 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 66FC 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66FE 63C6 
**** **** ****     > stevie_b1.asm.1638280
0112                       ;-----------------------------------------------------------------------
0113                       ; Keyboard actions - Command Buffer
0114                       ;-----------------------------------------------------------------------
0115                       copy  "edkey.cmdb.mov.asm"    ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.cmdb.left:
0009 6700 C120  34         mov   @cmdb.column,tmp0
     6702 A312 
0010 6704 1304  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6706 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     6708 A312 
0015 670A 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     670C A30A 
0016                       ;-------------------------------------------------------
0017                       ; Exit
0018                       ;-------------------------------------------------------
0019 670E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6710 765C 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Cursor right
0024               *---------------------------------------------------------------
0025               edkey.action.cmdb.right:
0026 6712 06A0  32         bl    @cmdb.cmd.getlength
     6714 6F9E 
0027 6716 8820  54         c     @cmdb.column,@outparm1
     6718 A312 
     671A 2F30 
0028 671C 1404  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 671E 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     6720 A312 
0033 6722 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     6724 A30A 
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037 6726 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6728 765C 
0038               
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor beginning of line
0043               *---------------------------------------------------------------
0044               edkey.action.cmdb.home:
0045 672A 04C4  14         clr   tmp0
0046 672C C804  38         mov   tmp0,@cmdb.column      ; First column
     672E A312 
0047 6730 0584  14         inc   tmp0
0048 6732 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     6734 A30A 
0049 6736 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     6738 A30A 
0050               
0051 673A 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     673C 765C 
0052               
0053               *---------------------------------------------------------------
0054               * Cursor end of line
0055               *---------------------------------------------------------------
0056               edkey.action.cmdb.end:
0057 673E D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     6740 A324 
0058 6742 0984  56         srl   tmp0,8                 ; Right justify
0059 6744 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     6746 A312 
0060 6748 0584  14         inc   tmp0                   ; One time adjustment command prompt
0061 674A 0224  22         ai    tmp0,>1a00             ; Y=26
     674C 1A00 
0062 674E C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     6750 A30A 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066 6752 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     6754 765C 
**** **** ****     > stevie_b1.asm.1638280
0116                       copy  "edkey.cmdb.mod.asm"    ; Actions for modifier keys
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
0026 6756 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6758 6F6C 
0027 675A 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     675C A318 
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.clear.exit:
0032 675E 0460  28         b     @edkey.action.cmdb.home
     6760 672A 
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
0061 6762 D105  18         movb  tmp1,tmp0             ; Get keycode
0062 6764 0984  56         srl   tmp0,8                ; MSB to LSB
0063               
0064 6766 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6768 0020 
0065 676A 1115  14         jlt   edkey.action.cmdb.char.exit
0066                                                   ; Yes, skip
0067               
0068 676C 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     676E 007E 
0069 6770 1512  14         jgt   edkey.action.cmdb.char.exit
0070                                                   ; Yes, skip
0071                       ;-------------------------------------------------------
0072                       ; Add character
0073                       ;-------------------------------------------------------
0074 6772 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6774 A318 
0075               
0076 6776 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6778 A325 
0077 677A A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     677C A312 
0078 677E D505  30         movb  tmp1,*tmp0            ; Add character
0079 6780 05A0  34         inc   @cmdb.column          ; Next column
     6782 A312 
0080 6784 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     6786 A30A 
0081               
0082 6788 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     678A 6F9E 
0083                                                   ; \ i  @cmdb.cmd = Command string
0084                                                   ; / o  @outparm1 = Length of command
0085                       ;-------------------------------------------------------
0086                       ; Addjust length
0087                       ;-------------------------------------------------------
0088 678C C120  34         mov   @outparm1,tmp0
     678E 2F30 
0089 6790 0A84  56         sla   tmp0,8               ; LSB to MSB
0090 6792 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6794 A324 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               edkey.action.cmdb.char.exit:
0095 6796 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6798 765C 
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
0108 679A 0460  28         b     @edkey.action.cmdb.loadsave
     679C 67BA 
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               edkey.action.cmdb.enter.exit:
0113 679E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67A0 765C 
**** **** ****     > stevie_b1.asm.1638280
0117                       copy  "edkey.cmdb.misc.asm"   ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Show/Hide command buffer pane
0007               ********|*****|*********************|**************************
0008               edkey.action.cmdb.toggle:
0009 67A2 C120  34         mov   @cmdb.visible,tmp0
     67A4 A302 
0010 67A6 1605  14         jne   edkey.action.cmdb.hide
0011                       ;-------------------------------------------------------
0012                       ; Show pane
0013                       ;-------------------------------------------------------
0014               edkey.action.cmdb.show:
0015 67A8 04E0  34         clr   @cmdb.column          ; Column = 0
     67AA A312 
0016 67AC 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     67AE 7A90 
0017 67B0 1002  14         jmp   edkey.action.cmdb.toggle.exit
0018                       ;-------------------------------------------------------
0019                       ; Hide pane
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.hide:
0022 67B2 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     67B4 7AE0 
0023                       ;-------------------------------------------------------
0024                       ; Exit
0025                       ;-------------------------------------------------------
0026               edkey.action.cmdb.toggle.exit:
0027 67B6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67B8 765C 
0028               
0029               
0030               
**** **** ****     > stevie_b1.asm.1638280
0118                       copy  "edkey.cmdb.file.asm"   ; File related actions
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
0012 67BA 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     67BC 7AE0 
0013               
0014 67BE 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     67C0 6F9E 
0015 67C2 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     67C4 2F30 
0016 67C6 1607  14         jne   !                     ; No, prepare for load/save
0017                       ;-------------------------------------------------------
0018                       ; No filename specified
0019                       ;-------------------------------------------------------
0020 67C8 06A0  32         bl    @pane.errline.show    ; Show error line
     67CA 7B22 
0021               
0022 67CC 06A0  32         bl    @pane.show_hint
     67CE 780A 
0023 67D0 1C00                   byte 28,0
0024 67D2 354A                   data txt.io.nofile
0025               
0026 67D4 1019  14         jmp   edkey.action.cmdb.loadsave.exit
0027                       ;-------------------------------------------------------
0028                       ; Prepare for loading or saving file
0029                       ;-------------------------------------------------------
0030 67D6 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0031 67D8 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     67DA A324 
0032               
0033 67DC 06A0  32         bl    @cpym2m
     67DE 24AA 
0034 67E0 A324                   data cmdb.cmdlen,heap.top,80
     67E2 E000 
     67E4 0050 
0035                                                   ; Copy filename from command line to buffer
0036               
0037 67E6 C120  34         mov   @cmdb.dialog,tmp0
     67E8 A31A 
0038 67EA 0284  22         ci    tmp0,id.dialog.load   ; Dialog is "Load DV80 file" ?
     67EC 000A 
0039 67EE 1303  14         jeq   edkey.action.cmdb.load.loadfile
0040               
0041 67F0 0284  22         ci    tmp0,id.dialog.save   ; Dialog is "Save DV80 file" ?
     67F2 000B 
0042 67F4 1305  14         jeq   edkey.action.cmdb.load.savefile
0043                       ;-------------------------------------------------------
0044                       ; Load specified file
0045                       ;-------------------------------------------------------
0046               edkey.action.cmdb.load.loadfile:
0047 67F6 0204  20         li    tmp0,heap.top         ; 1st line in heap
     67F8 E000 
0048 67FA 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     67FC 736A 
0049                                                   ; \ i  tmp0 = Pointer to length-prefixed
0050                                                   ; /           device/filename string
0051 67FE 1004  14         jmp   edkey.action.cmdb.loadsave.exit
0052                       ;-------------------------------------------------------
0053                       ; Save specified file
0054                       ;-------------------------------------------------------
0055               edkey.action.cmdb.load.savefile:
0056 6800 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6802 E000 
0057 6804 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6806 7422 
0058                                                   ; \ i  tmp0 = Pointer to length-prefixed
0059                                                   ; /           device/filename string
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.cmdb.loadsave.exit:
0064 6808 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     680A 63C6 
**** **** ****     > stevie_b1.asm.1638280
0119                       copy  "edkey.cmdb.dialog.asm" ; Dialog specific actions
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
0013 680C 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     680E A206 
0014 6810 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     6812 783C 
0015 6814 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6816 6F6C 
0016 6818 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     681A A322 
0017                       ;-------------------------------------------------------
0018                       ; Sanity checks
0019                       ;-------------------------------------------------------
0020 681C 0284  22         ci    tmp0,>2000
     681E 2000 
0021 6820 1104  14         jlt   !                     ; Invalid address, crash
0022               
0023 6822 0284  22         ci    tmp0,>7fff
     6824 7FFF 
0024 6826 1501  14         jgt   !                     ; Invalid address, crash
0025                       ;------------------------------------------------------
0026                       ; All sanity checks passed
0027                       ;------------------------------------------------------
0028 6828 0454  20         b     *tmp0                 ; Execute action
0029                       ;------------------------------------------------------
0030                       ; Sanity checks failed
0031                       ;------------------------------------------------------
0032 682A C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     682C FFCE 
0033 682E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6830 2030 
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037               edkey.action.cmdb.proceed.exit:
0038 6832 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6834 765C 
0039               
0040               
0041               
0042               
0043               *---------------------------------------------------------------
0044               * Toggle fastmode on/off
0045               *---------------------------------------------------------------
0046               edkey.action.cmdb.fastmode.toggle:
0047 6836 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6838 73F0 
0048 683A 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     683C A318 
0049 683E 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6840 765C 
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
0070 6842 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6844 A31A 
0071 6846 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6848 783C 
0072 684A 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     684C 7AE0 
0073                       ;-------------------------------------------------------
0074                       ; Exit
0075                       ;-------------------------------------------------------
0076               edkey.action.cmdb.close.dialog.exit:
0077 684E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6850 765C 
**** **** ****     > stevie_b1.asm.1638280
0120                       ;-----------------------------------------------------------------------
0121                       ; Logic for Editor configuration and SAMS memory
0122                       ;-----------------------------------------------------------------------
0123                       copy  "tv.asm"              ; Main editor configuration
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
0027 6852 0649  14         dect  stack
0028 6854 C64B  30         mov   r11,*stack            ; Save return address
0029 6856 0649  14         dect  stack
0030 6858 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 685A 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     685C A012 
0035 685E 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     6860 A01C 
0036 6862 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     6864 2016 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 6866 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 6868 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 686A 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               
0047               ***************************************************************
0048               * tv.reset
0049               * Reset editor (clear buffer)
0050               ***************************************************************
0051               * bl @tv.reset
0052               *--------------------------------------------------------------
0053               * INPUT
0054               * none
0055               *--------------------------------------------------------------
0056               * OUTPUT
0057               * none
0058               *--------------------------------------------------------------
0059               * Register usage
0060               * r11
0061               *--------------------------------------------------------------
0062               * Notes
0063               ***************************************************************
0064               tv.reset:
0065 686C 0649  14         dect  stack
0066 686E C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 6870 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     6872 6EDE 
0071 6874 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6876 6CA6 
0072 6878 06A0  32         bl    @idx.init             ; Initialize index
     687A 6A14 
0073 687C 06A0  32         bl    @fb.init              ; Initialize framebuffer
     687E 68EA 
0074 6880 06A0  32         bl    @errline.init         ; Initialize error line
     6882 6FCC 
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               tv.reset.exit:
0079 6884 C2F9  30         mov   *stack+,r11           ; Pop R11
0080 6886 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0124                       copy  "mem.asm"             ; SAMS Memory Management
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
0021 6888 0649  14         dect  stack
0022 688A C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 688C 06A0  32         bl    @sams.layout
     688E 25B2 
0027 6890 309E                   data mem.sams.layout.data
0028               
0029 6892 06A0  32         bl    @sams.layout.copy
     6894 2616 
0030 6896 A000                   data tv.sams.2000     ; Get SAMS windows
0031               
0032 6898 C820  54         mov   @tv.sams.c000,@edb.sams.page
     689A A008 
     689C A212 
0033 689E C820  54         mov   @edb.sams.page,@edb.sams.hipage
     68A0 A212 
     68A2 A214 
0034                                                   ; Track editor buffer SAMS page
0035                       ;------------------------------------------------------
0036                       ; Exit
0037                       ;------------------------------------------------------
0038               mem.sams.layout.exit:
0039 68A4 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 68A6 045B  20         b     *r11                  ; Return to caller
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
0065 68A8 C13B  30         mov   *r11+,tmp0            ; Get p0
0066               xmem.edb.sams.mappage:
0067 68AA 0649  14         dect  stack
0068 68AC C64B  30         mov   r11,*stack            ; Push return address
0069 68AE 0649  14         dect  stack
0070 68B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0071 68B2 0649  14         dect  stack
0072 68B4 C645  30         mov   tmp1,*stack           ; Push tmp1
0073                       ;------------------------------------------------------
0074                       ; Sanity check
0075                       ;------------------------------------------------------
0076 68B6 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     68B8 A204 
0077 68BA 1204  14         jle   mem.edb.sams.mappage.lookup
0078                                                   ; All checks passed, continue
0079                                                   ;--------------------------
0080                                                   ; Sanity check failed
0081                                                   ;--------------------------
0082 68BC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     68BE FFCE 
0083 68C0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     68C2 2030 
0084                       ;------------------------------------------------------
0085                       ; Lookup SAMS page for line in parm1
0086                       ;------------------------------------------------------
0087               mem.edb.sams.mappage.lookup:
0088 68C4 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     68C6 6B68 
0089                                                   ; \ i  parm1    = Line number
0090                                                   ; | o  outparm1 = Pointer to line
0091                                                   ; / o  outparm2 = SAMS page
0092               
0093 68C8 C120  34         mov   @outparm2,tmp0        ; SAMS page
     68CA 2F32 
0094 68CC C160  34         mov   @outparm1,tmp1        ; Pointer to line
     68CE 2F30 
0095 68D0 1308  14         jeq   mem.edb.sams.mappage.exit
0096                                                   ; Nothing to page-in if NULL pointer
0097                                                   ; (=empty line)
0098                       ;------------------------------------------------------
0099                       ; Determine if requested SAMS page is already active
0100                       ;------------------------------------------------------
0101 68D2 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     68D4 A008 
0102 68D6 1305  14         jeq   mem.edb.sams.mappage.exit
0103                                                   ; Request page already active. Exit.
0104                       ;------------------------------------------------------
0105                       ; Activate requested SAMS page
0106                       ;-----------------------------------------------------
0107 68D8 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     68DA 2546 
0108                                                   ; \ i  tmp0 = SAMS page
0109                                                   ; / i  tmp1 = Memory address
0110               
0111 68DC C820  54         mov   @outparm2,@tv.sams.c000
     68DE 2F32 
     68E0 A008 
0112                                                   ; Set page in shadow registers
0113                       ;------------------------------------------------------
0114                       ; Exit
0115                       ;------------------------------------------------------
0116               mem.edb.sams.mappage.exit:
0117 68E2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0118 68E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0119 68E6 C2F9  30         mov   *stack+,r11           ; Pop r11
0120 68E8 045B  20         b     *r11                  ; Return to caller
0121               
0122               
0123               
**** **** ****     > stevie_b1.asm.1638280
0125                       ;-----------------------------------------------------------------------
0126                       ; Logic for Framebuffer
0127                       ;-----------------------------------------------------------------------
0128                       copy  "fb.asm"              ; Framebuffer
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
0024 68EA 0649  14         dect  stack
0025 68EC C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 68EE 0204  20         li    tmp0,fb.top
     68F0 A600 
0030 68F2 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     68F4 A100 
0031 68F6 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     68F8 A104 
0032 68FA 04E0  34         clr   @fb.row               ; Current row=0
     68FC A106 
0033 68FE 04E0  34         clr   @fb.column            ; Current column=0
     6900 A10C 
0034               
0035 6902 0204  20         li    tmp0,colrow
     6904 0050 
0036 6906 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     6908 A10E 
0037               
0038 690A 0204  20         li    tmp0,29
     690C 001D 
0039 690E C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     6910 A118 
0040 6912 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     6914 A11A 
0041               
0042 6916 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     6918 A01A 
0043 691A 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     691C A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 691E 06A0  32         bl    @film
     6920 2242 
0048 6922 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     6924 0000 
     6926 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit:
0053 6928 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 692A 045B  20         b     *r11                  ; Return to caller
0055               
**** **** ****     > stevie_b1.asm.1638280
0129                       copy  "fb.util.asm"         ; Framebuffer utilities
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
0029 692C 0649  14         dect  stack
0030 692E C64B  30         mov   r11,*stack            ; Save return address
0031                       ;------------------------------------------------------
0032                       ; Calculate line in editor buffer
0033                       ;------------------------------------------------------
0034 6930 C120  34         mov   @parm1,tmp0
     6932 2F20 
0035 6934 A120  34         a     @fb.topline,tmp0
     6936 A104 
0036 6938 C804  38         mov   tmp0,@outparm1
     693A 2F30 
0037                       ;------------------------------------------------------
0038                       ; Exit
0039                       ;------------------------------------------------------
0040               fb.row2line.exit:
0041 693C C2F9  30         mov   *stack+,r11           ; Pop r11
0042 693E 045B  20         b     *r11                  ; Return to caller
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
0064               * tmp2,tmp3
0065               *--------------------------------------------------------------
0066               * Formula
0067               * pointer = row * colsline + column + deref(@fb.top.ptr)
0068               ********|*****|*********************|**************************
0069               fb.calc_pointer:
0070 6940 0649  14         dect  stack
0071 6942 C64B  30         mov   r11,*stack            ; Save return address
0072                       ;------------------------------------------------------
0073                       ; Calculate pointer
0074                       ;------------------------------------------------------
0075 6944 C1A0  34         mov   @fb.row,tmp2
     6946 A106 
0076 6948 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     694A A10E 
0077 694C A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     694E A10C 
0078 6950 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     6952 A100 
0079 6954 C807  38         mov   tmp3,@fb.current
     6956 A102 
0080                       ;------------------------------------------------------
0081                       ; Exit
0082                       ;------------------------------------------------------
0083               fb.calc_pointer.exit:
0084 6958 C2F9  30         mov   *stack+,r11           ; Pop r11
0085 695A 045B  20         b     *r11                  ; Return to caller
0086               
0087               
0088               
0089               
0090               
0091               
0092               
0093               ***************************************************************
0094               * fb.get.firstnonblank
0095               * Get column of first non-blank character in specified line
0096               ***************************************************************
0097               * bl @fb.get.firstnonblank
0098               *--------------------------------------------------------------
0099               * OUTPUT
0100               * @outparm1 = Column containing first non-blank character
0101               * @outparm2 = Character
0102               ********|*****|*********************|**************************
0103               fb.get.firstnonblank:
0104 695C 0649  14         dect  stack
0105 695E C64B  30         mov   r11,*stack            ; Save return address
0106                       ;------------------------------------------------------
0107                       ; Prepare for scanning
0108                       ;------------------------------------------------------
0109 6960 04E0  34         clr   @fb.column
     6962 A10C 
0110 6964 06A0  32         bl    @fb.calc_pointer
     6966 6940 
0111 6968 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     696A 6EC0 
0112 696C C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     696E A108 
0113 6970 1313  14         jeq   fb.get.firstnonblank.nomatch
0114                                                   ; Exit if empty line
0115 6972 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6974 A102 
0116 6976 04C5  14         clr   tmp1
0117                       ;------------------------------------------------------
0118                       ; Scan line for non-blank character
0119                       ;------------------------------------------------------
0120               fb.get.firstnonblank.loop:
0121 6978 D174  28         movb  *tmp0+,tmp1           ; Get character
0122 697A 130E  14         jeq   fb.get.firstnonblank.nomatch
0123                                                   ; Exit if empty line
0124 697C 0285  22         ci    tmp1,>2000            ; Whitespace?
     697E 2000 
0125 6980 1503  14         jgt   fb.get.firstnonblank.match
0126 6982 0606  14         dec   tmp2                  ; Counter--
0127 6984 16F9  14         jne   fb.get.firstnonblank.loop
0128 6986 1008  14         jmp   fb.get.firstnonblank.nomatch
0129                       ;------------------------------------------------------
0130                       ; Non-blank character found
0131                       ;------------------------------------------------------
0132               fb.get.firstnonblank.match:
0133 6988 6120  34         s     @fb.current,tmp0      ; Calculate column
     698A A102 
0134 698C 0604  14         dec   tmp0
0135 698E C804  38         mov   tmp0,@outparm1        ; Save column
     6990 2F30 
0136 6992 D805  38         movb  tmp1,@outparm2        ; Save character
     6994 2F32 
0137 6996 1004  14         jmp   fb.get.firstnonblank.exit
0138                       ;------------------------------------------------------
0139                       ; No non-blank character found
0140                       ;------------------------------------------------------
0141               fb.get.firstnonblank.nomatch:
0142 6998 04E0  34         clr   @outparm1             ; X=0
     699A 2F30 
0143 699C 04E0  34         clr   @outparm2             ; Null
     699E 2F32 
0144                       ;------------------------------------------------------
0145                       ; Exit
0146                       ;------------------------------------------------------
0147               fb.get.firstnonblank.exit:
0148 69A0 C2F9  30         mov   *stack+,r11           ; Pop r11
0149 69A2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0130                       copy  "fb.refresh.asm"      ; Framebuffer refresh
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
0025 69A4 0649  14         dect  stack
0026 69A6 C64B  30         mov   r11,*stack            ; Push return address
0027 69A8 0649  14         dect  stack
0028 69AA C644  30         mov   tmp0,*stack           ; Push tmp0
0029 69AC 0649  14         dect  stack
0030 69AE C645  30         mov   tmp1,*stack           ; Push tmp1
0031 69B0 0649  14         dect  stack
0032 69B2 C646  30         mov   tmp2,*stack           ; Push tmp2
0033                       ;------------------------------------------------------
0034                       ; Setup starting position in index
0035                       ;------------------------------------------------------
0036 69B4 C820  54         mov   @parm1,@fb.topline
     69B6 2F20 
     69B8 A104 
0037 69BA 04E0  34         clr   @parm2                ; Target row in frame buffer
     69BC 2F22 
0038                       ;------------------------------------------------------
0039                       ; Check if already at EOF
0040                       ;------------------------------------------------------
0041 69BE 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     69C0 2F20 
     69C2 A204 
0042 69C4 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0043                       ;------------------------------------------------------
0044                       ; Unpack line to frame buffer
0045                       ;------------------------------------------------------
0046               fb.refresh.unpack_line:
0047 69C6 06A0  32         bl    @edb.line.unpack      ; Unpack line
     69C8 6DD6 
0048                                                   ; \ i  parm1    = Line to unpack
0049                                                   ; | i  parm2    = Target row in frame buffer
0050                                                   ; / o  outparm1 = Length of line
0051               
0052 69CA 05A0  34         inc   @parm1                ; Next line in editor buffer
     69CC 2F20 
0053 69CE 05A0  34         inc   @parm2                ; Next row in frame buffer
     69D0 2F22 
0054                       ;------------------------------------------------------
0055                       ; Last row in editor buffer reached ?
0056                       ;------------------------------------------------------
0057 69D2 8820  54         c     @parm1,@edb.lines
     69D4 2F20 
     69D6 A204 
0058 69D8 1212  14         jle   !                     ; no, do next check
0059                                                   ; yes, erase until end of frame buffer
0060                       ;------------------------------------------------------
0061                       ; Erase until end of frame buffer
0062                       ;------------------------------------------------------
0063               fb.refresh.erase_eob:
0064 69DA C120  34         mov   @parm2,tmp0           ; Current row
     69DC 2F22 
0065 69DE C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     69E0 A118 
0066 69E2 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0067 69E4 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     69E6 A10E 
0068               
0069 69E8 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0070 69EA 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0071               
0072 69EC 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     69EE A10E 
0073 69F0 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     69F2 A100 
0074               
0075 69F4 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0076 69F6 04C5  14         clr   tmp1                  ; Clear with >00 character
0077               
0078 69F8 06A0  32         bl    @xfilm                ; \ Fill memory
     69FA 2248 
0079                                                   ; | i  tmp0 = Memory start address
0080                                                   ; | i  tmp1 = Byte to fill
0081                                                   ; / i  tmp2 = Number of bytes to fill
0082 69FC 1004  14         jmp   fb.refresh.exit
0083                       ;------------------------------------------------------
0084                       ; Bottom row in frame buffer reached ?
0085                       ;------------------------------------------------------
0086 69FE 8820  54 !       c     @parm2,@fb.scrrows
     6A00 2F22 
     6A02 A118 
0087 6A04 11E0  14         jlt   fb.refresh.unpack_line
0088                                                   ; No, unpack next line
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               fb.refresh.exit:
0093 6A06 0720  34         seto  @fb.dirty             ; Refresh screen
     6A08 A116 
0094 6A0A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0095 6A0C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0096 6A0E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0097 6A10 C2F9  30         mov   *stack+,r11           ; Pop r11
0098 6A12 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0131                       ;-----------------------------------------------------------------------
0132                       ; Logic for Index management
0133                       ;-----------------------------------------------------------------------
0134                       copy  "idx.asm"             ; Index management
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
0050 6A14 0649  14         dect  stack
0051 6A16 C64B  30         mov   r11,*stack            ; Save return address
0052 6A18 0649  14         dect  stack
0053 6A1A C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 6A1C 0204  20         li    tmp0,idx.top
     6A1E B000 
0058 6A20 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     6A22 A202 
0059               
0060 6A24 C120  34         mov   @tv.sams.b000,tmp0
     6A26 A006 
0061 6A28 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     6A2A A500 
0062 6A2C C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     6A2E A502 
0063 6A30 C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     6A32 A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 6A34 06A0  32         bl    @film
     6A36 2242 
0068 6A38 B000                   data idx.top,>00,idx.size
     6A3A 0000 
     6A3C 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 6A3E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 6A40 C2F9  30         mov   *stack+,r11           ; Pop r11
0076 6A42 045B  20         b     *r11                  ; Return to caller
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
0100 6A44 0649  14         dect  stack
0101 6A46 C64B  30         mov   r11,*stack            ; Push return address
0102 6A48 0649  14         dect  stack
0103 6A4A C644  30         mov   tmp0,*stack           ; Push tmp0
0104 6A4C 0649  14         dect  stack
0105 6A4E C645  30         mov   tmp1,*stack           ; Push tmp1
0106 6A50 0649  14         dect  stack
0107 6A52 C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 6A54 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     6A56 A502 
0112 6A58 0205  20         li    tmp1,idx.top
     6A5A B000 
0113               
0114 6A5C C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     6A5E A504 
0115 6A60 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 6A62 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     6A64 A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 6A66 0286  22         ci    tmp2,5                ; Crash if too many index pages
     6A68 0005 
0121 6A6A 1104  14         jlt   !
0122 6A6C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6A6E FFCE 
0123 6A70 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A72 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 6A74 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     6A76 2546 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 6A78 0584  14         inc   tmp0                  ; Next SAMS index page
0132 6A7A 0225  22         ai    tmp1,>1000            ; Next memory region
     6A7C 1000 
0133 6A7E 0606  14         dec   tmp2                  ; Update loop counter
0134 6A80 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 6A82 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 6A84 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 6A86 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 6A88 C2F9  30         mov   *stack+,r11           ; Pop return address
0143 6A8A 045B  20         b     *r11                  ; Return to caller
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
0159 6A8C 0649  14         dect  stack
0160 6A8E C64B  30         mov   r11,*stack            ; Push return address
0161 6A90 0649  14         dect  stack
0162 6A92 C644  30         mov   tmp0,*stack           ; Push tmp0
0163 6A94 0649  14         dect  stack
0164 6A96 C645  30         mov   tmp1,*stack           ; Push tmp1
0165 6A98 0649  14         dect  stack
0166 6A9A C646  30         mov   tmp2,*stack           ; Push tmp2
0167 6A9C 0649  14         dect  stack
0168 6A9E C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 6AA0 0205  20         li    tmp1,idx.top
     6AA2 B000 
0173 6AA4 0206  20         li    tmp2,5                ; Always 5 pages
     6AA6 0005 
0174 6AA8 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     6AAA A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 6AAC C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 6AAE 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6AB0 2546 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 6AB2 0225  22         ai    tmp1,>1000            ; Next memory region
     6AB4 1000 
0185 6AB6 0606  14         dec   tmp2                  ; Update loop counter
0186 6AB8 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 6ABA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 6ABC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 6ABE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 6AC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 6AC2 C2F9  30         mov   *stack+,r11           ; Pop return address
0196 6AC4 045B  20         b     *r11                  ; Return to caller
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
0220 6AC6 0649  14         dect  stack
0221 6AC8 C64B  30         mov   r11,*stack            ; Save return address
0222 6ACA 0649  14         dect  stack
0223 6ACC C644  30         mov   tmp0,*stack           ; Push tmp0
0224 6ACE 0649  14         dect  stack
0225 6AD0 C645  30         mov   tmp1,*stack           ; Push tmp1
0226 6AD2 0649  14         dect  stack
0227 6AD4 C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 6AD6 C184  18         mov   tmp0,tmp2             ; Line number
0232 6AD8 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 6ADA 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     6ADC 0800 
0234               
0235 6ADE 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 6AE0 0A16  56         sla   tmp2,1                ; line number * 2
0240 6AE2 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     6AE4 2F30 
0241               
0242 6AE6 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     6AE8 A502 
0243 6AEA 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     6AEC A500 
0244               
0245 6AEE 130E  14         jeq   _idx.samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 6AF0 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     6AF2 A500 
0251 6AF4 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     6AF6 A006 
0252               
0253 6AF8 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 6AFA 0205  20         li    tmp1,>b000            ; Memory window for index page
     6AFC B000 
0255               
0256 6AFE 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6B00 2546 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 6B02 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     6B04 A504 
0263 6B06 1202  14         jle   _idx.samspage.get.exit
0264                                                   ; No, exit
0265 6B08 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     6B0A A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               _idx.samspage.get.exit:
0270 6B0C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 6B0E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 6B10 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 6B12 C2F9  30         mov   *stack+,r11           ; Pop r11
0274 6B14 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0135                       copy  "idx.update.asm"      ; Index management - Update entry
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
0027 6B16 0649  14         dect  stack
0028 6B18 C64B  30         mov   r11,*stack            ; Save return address
0029 6B1A 0649  14         dect  stack
0030 6B1C C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6B1E 0649  14         dect  stack
0032 6B20 C645  30         mov   tmp1,*stack           ; Push tmp1
0033                       ;------------------------------------------------------
0034                       ; Get parameters
0035                       ;------------------------------------------------------
0036 6B22 C120  34         mov   @parm1,tmp0           ; Get line number
     6B24 2F20 
0037 6B26 C160  34         mov   @parm2,tmp1           ; Get pointer
     6B28 2F22 
0038 6B2A 1312  14         jeq   idx.entry.update.clear
0039                                                   ; Special handling for "null"-pointer
0040                       ;------------------------------------------------------
0041                       ; Calculate LSB value index slot (pointer offset)
0042                       ;------------------------------------------------------
0043 6B2C 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6B2E 0FFF 
0044 6B30 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0045                       ;------------------------------------------------------
0046                       ; Calculate MSB value index slot (SAMS page editor buffer)
0047                       ;------------------------------------------------------
0048 6B32 06E0  34         swpb  @parm3
     6B34 2F24 
0049 6B36 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6B38 2F24 
0050 6B3A 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6B3C 2F24 
0051                                                   ; / important for messing up caller parm3!
0052                       ;------------------------------------------------------
0053                       ; Update index slot
0054                       ;------------------------------------------------------
0055               idx.entry.update.save:
0056 6B3E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B40 6AC6 
0057                                                   ; \ i  tmp0     = Line number
0058                                                   ; / o  outparm1 = Slot offset in SAMS page
0059               
0060 6B42 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6B44 2F30 
0061 6B46 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6B48 B000 
0062 6B4A C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6B4C 2F30 
0063 6B4E 1008  14         jmp   idx.entry.update.exit
0064                       ;------------------------------------------------------
0065                       ; Special handling for "null"-pointer
0066                       ;------------------------------------------------------
0067               idx.entry.update.clear:
0068 6B50 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B52 6AC6 
0069                                                   ; \ i  tmp0     = Line number
0070                                                   ; / o  outparm1 = Slot offset in SAMS page
0071               
0072 6B54 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6B56 2F30 
0073 6B58 04E4  34         clr   @idx.top(tmp0)        ; /
     6B5A B000 
0074 6B5C C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6B5E 2F30 
0075                       ;------------------------------------------------------
0076                       ; Exit
0077                       ;------------------------------------------------------
0078               idx.entry.update.exit:
0079 6B60 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0080 6B62 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0081 6B64 C2F9  30         mov   *stack+,r11           ; Pop r11
0082 6B66 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0136                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0027 6B68 0649  14         dect  stack
0028 6B6A C64B  30         mov   r11,*stack            ; Save return address
0029 6B6C 0649  14         dect  stack
0030 6B6E C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6B70 0649  14         dect  stack
0032 6B72 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6B74 0649  14         dect  stack
0034 6B76 C646  30         mov   tmp2,*stack           ; Push tmp2
0035                       ;------------------------------------------------------
0036                       ; Get slot entry
0037                       ;------------------------------------------------------
0038 6B78 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6B7A 2F20 
0039               
0040 6B7C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6B7E 6AC6 
0041                                                   ; \ i  tmp0     = Line number
0042                                                   ; / o  outparm1 = Slot offset in SAMS page
0043               
0044 6B80 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6B82 2F30 
0045 6B84 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6B86 B000 
0046               
0047 6B88 130C  14         jeq   idx.pointer.get.parm.null
0048                                                   ; Skip if index slot empty
0049                       ;------------------------------------------------------
0050                       ; Calculate MSB (SAMS page)
0051                       ;------------------------------------------------------
0052 6B8A C185  18         mov   tmp1,tmp2             ; \
0053 6B8C 0986  56         srl   tmp2,8                ; / Right align SAMS page
0054                       ;------------------------------------------------------
0055                       ; Calculate LSB (pointer address)
0056                       ;------------------------------------------------------
0057 6B8E 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6B90 00FF 
0058 6B92 0A45  56         sla   tmp1,4                ; Multiply with 16
0059 6B94 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6B96 C000 
0060                       ;------------------------------------------------------
0061                       ; Return parameters
0062                       ;------------------------------------------------------
0063               idx.pointer.get.parm:
0064 6B98 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6B9A 2F30 
0065 6B9C C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6B9E 2F32 
0066 6BA0 1004  14         jmp   idx.pointer.get.exit
0067                       ;------------------------------------------------------
0068                       ; Special handling for "null"-pointer
0069                       ;------------------------------------------------------
0070               idx.pointer.get.parm.null:
0071 6BA2 04E0  34         clr   @outparm1
     6BA4 2F30 
0072 6BA6 04E0  34         clr   @outparm2
     6BA8 2F32 
0073                       ;------------------------------------------------------
0074                       ; Exit
0075                       ;------------------------------------------------------
0076               idx.pointer.get.exit:
0077 6BAA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0078 6BAC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 6BAE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 6BB0 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 6BB2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0137                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0025 6BB4 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6BB6 B000 
0026 6BB8 C144  18         mov   tmp0,tmp1             ; a = current slot
0027 6BBA 05C5  14         inct  tmp1                  ; b = current slot + 2
0028                       ;------------------------------------------------------
0029                       ; Loop forward until end of index
0030                       ;------------------------------------------------------
0031               _idx.entry.delete.reorg.loop:
0032 6BBC CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0033 6BBE 0606  14         dec   tmp2                  ; tmp2--
0034 6BC0 16FD  14         jne   _idx.entry.delete.reorg.loop
0035                                                   ; Loop unless completed
0036 6BC2 045B  20         b     *r11                  ; Return to caller
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
0054 6BC4 0649  14         dect  stack
0055 6BC6 C64B  30         mov   r11,*stack            ; Save return address
0056 6BC8 0649  14         dect  stack
0057 6BCA C644  30         mov   tmp0,*stack           ; Push tmp0
0058 6BCC 0649  14         dect  stack
0059 6BCE C645  30         mov   tmp1,*stack           ; Push tmp1
0060 6BD0 0649  14         dect  stack
0061 6BD2 C646  30         mov   tmp2,*stack           ; Push tmp2
0062 6BD4 0649  14         dect  stack
0063 6BD6 C647  30         mov   tmp3,*stack           ; Push tmp3
0064                       ;------------------------------------------------------
0065                       ; Get index slot
0066                       ;------------------------------------------------------
0067 6BD8 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6BDA 2F20 
0068               
0069 6BDC 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BDE 6AC6 
0070                                                   ; \ i  tmp0     = Line number
0071                                                   ; / o  outparm1 = Slot offset in SAMS page
0072               
0073 6BE0 C120  34         mov   @outparm1,tmp0        ; Index offset
     6BE2 2F30 
0074                       ;------------------------------------------------------
0075                       ; Prepare for index reorg
0076                       ;------------------------------------------------------
0077 6BE4 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6BE6 2F22 
0078 6BE8 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6BEA 2F20 
0079 6BEC 130E  14         jeq   idx.entry.delete.lastline
0080                                                   ; Special treatment if last line
0081                       ;------------------------------------------------------
0082                       ; Reorganize index entries
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg:
0085 6BEE C1E0  34         mov   @parm2,tmp3
     6BF0 2F22 
0086 6BF2 0287  22         ci    tmp3,2048
     6BF4 0800 
0087 6BF6 1207  14         jle   idx.entry.delete.reorg.simple
0088                                                   ; Do simple reorg only if single
0089                                                   ; SAMS index page, otherwise complex reorg.
0090                       ;------------------------------------------------------
0091                       ; Complex index reorganization (multiple SAMS pages)
0092                       ;------------------------------------------------------
0093               idx.entry.delete.reorg.complex:
0094 6BF8 06A0  32         bl    @_idx.sams.mapcolumn.on
     6BFA 6A44 
0095                                                   ; Index in continious memory region
0096               
0097 6BFC 06A0  32         bl    @_idx.entry.delete.reorg
     6BFE 6BB4 
0098                                                   ; Reorganize index
0099               
0100               
0101 6C00 06A0  32         bl    @_idx.sams.mapcolumn.off
     6C02 6A8C 
0102                                                   ; Restore memory window layout
0103               
0104 6C04 1002  14         jmp   idx.entry.delete.lastline
0105                       ;------------------------------------------------------
0106                       ; Simple index reorganization
0107                       ;------------------------------------------------------
0108               idx.entry.delete.reorg.simple:
0109 6C06 06A0  32         bl    @_idx.entry.delete.reorg
     6C08 6BB4 
0110                       ;------------------------------------------------------
0111                       ; Last line
0112                       ;------------------------------------------------------
0113               idx.entry.delete.lastline:
0114 6C0A 04D4  26         clr   *tmp0
0115                       ;------------------------------------------------------
0116                       ; Exit
0117                       ;------------------------------------------------------
0118               idx.entry.delete.exit:
0119 6C0C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0120 6C0E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6C10 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6C12 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6C14 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6C16 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0138                       copy  "idx.insert.asm"      ; Index management - insert slot
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
     6C78 6A44 
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
     6C86 6A8C 
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
     6C90 6AC6 
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
**** **** ****     > stevie_b1.asm.1638280
0139                       ;-----------------------------------------------------------------------
0140                       ; Logic for Editor Buffer
0141                       ;-----------------------------------------------------------------------
0142                       copy  "edb.asm"             ; Editor Buffer initialisation
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
0026 6CA6 0649  14         dect  stack
0027 6CA8 C64B  30         mov   r11,*stack            ; Save return address
0028 6CAA 0649  14         dect  stack
0029 6CAC C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6CAE 0204  20         li    tmp0,edb.top          ; \
     6CB0 C000 
0034 6CB2 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6CB4 A200 
0035 6CB6 C804  38         mov   tmp0,@edb.next_free.ptr
     6CB8 A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6CBA 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6CBC A20A 
0039 6CBE 04E0  34         clr   @edb.lines            ; Lines=0
     6CC0 A204 
0040 6CC2 04E0  34         clr   @edb.rle              ; RLE compression off
     6CC4 A20C 
0041               
0042 6CC6 0204  20         li    tmp0,txt.newfile      ; "New file"
     6CC8 32A0 
0043 6CCA C804  38         mov   tmp0,@edb.filename.ptr
     6CCC A20E 
0044               
0045 6CCE 0204  20         li    tmp0,txt.filetype.none
     6CD0 32B2 
0046 6CD2 C804  38         mov   tmp0,@edb.filetype.ptr
     6CD4 A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6CD6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6CD8 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6CDA 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
**** **** ****     > stevie_b1.asm.1638280
0143                       copy  "edb.line.pack.asm"   ; Pack line into editor buffer
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
0033 6CDC 0649  14         dect  stack
0034 6CDE C64B  30         mov   r11,*stack            ; Save return address
0035 6CE0 0649  14         dect  stack
0036 6CE2 C644  30         mov   tmp0,*stack           ; Push tmp0
0037 6CE4 0649  14         dect  stack
0038 6CE6 C645  30         mov   tmp1,*stack           ; Push tmp1
0039 6CE8 0649  14         dect  stack
0040 6CEA C646  30         mov   tmp2,*stack           ; Push tmp2
0041                       ;------------------------------------------------------
0042                       ; Get values
0043                       ;------------------------------------------------------
0044 6CEC C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6CEE A10C 
     6CF0 2F64 
0045 6CF2 04E0  34         clr   @fb.column
     6CF4 A10C 
0046 6CF6 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6CF8 6940 
0047                       ;------------------------------------------------------
0048                       ; Prepare scan
0049                       ;------------------------------------------------------
0050 6CFA 04C4  14         clr   tmp0                  ; Counter
0051 6CFC C160  34         mov   @fb.current,tmp1      ; Get position
     6CFE A102 
0052 6D00 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6D02 2F66 
0053                       ;------------------------------------------------------
0054                       ; Scan line for >00 byte termination
0055                       ;------------------------------------------------------
0056               edb.line.pack.scan:
0057 6D04 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0058 6D06 0986  56         srl   tmp2,8                ; Right justify
0059 6D08 1309  14         jeq   edb.line.pack.check_setpage
0060                                                   ; Stop scan if >00 found
0061 6D0A 0584  14         inc   tmp0                  ; Increase string length
0062                       ;------------------------------------------------------
0063                       ; Not more than 80 characters
0064                       ;------------------------------------------------------
0065 6D0C 0284  22         ci    tmp0,colrow
     6D0E 0050 
0066 6D10 1305  14         jeq   edb.line.pack.check_setpage
0067                                                   ; Stop scan if 80 characters processed
0068 6D12 10F8  14         jmp   edb.line.pack.scan    ; Next character
0069                       ;------------------------------------------------------
0070                       ; Check failed, crash CPU!
0071                       ;------------------------------------------------------
0072               edb.line.pack.crash:
0073 6D14 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D16 FFCE 
0074 6D18 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D1A 2030 
0075                       ;------------------------------------------------------
0076                       ; 1a: Check if highest SAMS page needs to be increased
0077                       ;------------------------------------------------------
0078               edb.line.pack.check_setpage:
0079 6D1C C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6D1E 2F68 
0080 6D20 C120  34         mov   @edb.next_free.ptr,tmp0
     6D22 A208 
0081                                                   ;--------------------------
0082                                                   ; Sanity check
0083                                                   ;--------------------------
0084 6D24 0284  22         ci    tmp0,edb.top + edb.size
     6D26 D000 
0085                                                   ; Insane address ?
0086 6D28 15F5  14         jgt   edb.line.pack.crash   ; Yes, crash!
0087                                                   ;--------------------------
0088                                                   ; Check for page overflow
0089                                                   ;--------------------------
0090 6D2A 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6D2C 0FFF 
0091 6D2E 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6D30 0052 
0092 6D32 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6D34 0FF0 
0093 6D36 1105  14         jlt   edb.line.pack.setpage ; Not yet, don't increase SAMS page
0094                       ;------------------------------------------------------
0095                       ; 1b: Increase highest SAMS page (copy-on-write!)
0096                       ;------------------------------------------------------
0097 6D38 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6D3A A214 
0098 6D3C C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6D3E A200 
     6D40 A208 
0099                                                   ; Start at top of SAMS page again
0100                       ;------------------------------------------------------
0101                       ; 1c: Switch to SAMS page
0102                       ;------------------------------------------------------
0103               edb.line.pack.setpage:
0104 6D42 C120  34         mov   @edb.sams.hipage,tmp0
     6D44 A214 
0105 6D46 C160  34         mov   @edb.top.ptr,tmp1
     6D48 A200 
0106 6D4A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D4C 2546 
0107                                                   ; \ i  tmp0 = SAMS page number
0108                                                   ; / i  tmp1 = Memory address
0109                       ;------------------------------------------------------
0110                       ; Step 2: Prepare for storing line
0111                       ;------------------------------------------------------
0112               edb.line.pack.prepare:
0113 6D4E C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6D50 A104 
     6D52 2F20 
0114 6D54 A820  54         a     @fb.row,@parm1        ; /
     6D56 A106 
     6D58 2F20 
0115                       ;------------------------------------------------------
0116                       ; 2a Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6D5A C820  54         mov   @edb.next_free.ptr,@parm2
     6D5C A208 
     6D5E 2F22 
0120                                                   ; Pointer to new line
0121 6D60 C820  54         mov   @edb.sams.hipage,@parm3
     6D62 A214 
     6D64 2F24 
0122                                                   ; SAMS page to use
0123               
0124 6D66 06A0  32         bl    @idx.entry.update     ; Update index
     6D68 6B16 
0125                                                   ; \ i  parm1 = Line number in editor buffer
0126                                                   ; | i  parm2 = pointer to line in
0127                                                   ; |            editor buffer
0128                                                   ; / i  parm3 = SAMS page
0129                       ;------------------------------------------------------
0130                       ; 3. Set line prefix in editor buffer
0131                       ;------------------------------------------------------
0132 6D6A C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6D6C 2F66 
0133 6D6E C160  34         mov   @edb.next_free.ptr,tmp1
     6D70 A208 
0134                                                   ; Address of line in editor buffer
0135               
0136 6D72 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6D74 A208 
0137               
0138 6D76 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6D78 2F68 
0139 6D7A 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0140 6D7C 06C6  14         swpb  tmp2
0141 6D7E DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0142 6D80 06C6  14         swpb  tmp2
0143 6D82 1317  14         jeq   edb.line.pack.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.copyline:
0149 6D84 0286  22         ci    tmp2,2
     6D86 0002 
0150 6D88 1603  14         jne   edb.line.pack.copyline.checkbyte
0151 6D8A DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 6D8C DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 6D8E 1007  14         jmp   !
0154               
0155               edb.line.pack.copyline.checkbyte:
0156 6D90 0286  22         ci    tmp2,1
     6D92 0001 
0157 6D94 1602  14         jne   edb.line.pack.copyline.block
0158 6D96 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 6D98 1002  14         jmp   !
0160               
0161               edb.line.pack.copyline.block:
0162 6D9A 06A0  32         bl    @xpym2m               ; Copy memory block
     6D9C 24B0 
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169 6D9E A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6DA0 2F68 
     6DA2 A208 
0170                                                      ; Add length of line
0171               
0172 6DA4 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6DA6 A208 
0173 6DA8 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0174 6DAA 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6DAC 000F 
0175 6DAE A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6DB0 A208 
0176                       ;------------------------------------------------------
0177                       ; 6: Restore SAMS page and prepare for exit
0178                       ;------------------------------------------------------
0179               edb.line.pack.prepexit:
0180 6DB2 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6DB4 2F64 
     6DB6 A10C 
0181               
0182 6DB8 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6DBA A214 
     6DBC A212 
0183 6DBE 1306  14         jeq   edb.line.pack.exit    ; Exit early if SAMS page already mapped
0184               
0185 6DC0 C120  34         mov   @edb.sams.page,tmp0
     6DC2 A212 
0186 6DC4 C160  34         mov   @edb.top.ptr,tmp1
     6DC6 A200 
0187 6DC8 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6DCA 2546 
0188                                                   ; \ i  tmp0 = SAMS page number
0189                                                   ; / i  tmp1 = Memory address
0190                       ;------------------------------------------------------
0191                       ; Exit
0192                       ;------------------------------------------------------
0193               edb.line.pack.exit:
0194 6DCC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0195 6DCE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0196 6DD0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0197 6DD2 C2F9  30         mov   *stack+,r11           ; Pop R11
0198 6DD4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0144                       copy  "edb.line.unpack.asm" ; Unpack line from editor buffer
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
0033 6DD6 0649  14         dect  stack
0034 6DD8 C64B  30         mov   r11,*stack            ; Save return address
0035 6DDA 0649  14         dect  stack
0036 6DDC C644  30         mov   tmp0,*stack           ; Push tmp0
0037 6DDE 0649  14         dect  stack
0038 6DE0 C645  30         mov   tmp1,*stack           ; Push tmp1
0039 6DE2 0649  14         dect  stack
0040 6DE4 C646  30         mov   tmp2,*stack           ; Push tmp2
0041                       ;------------------------------------------------------
0042                       ; Sanity check
0043                       ;------------------------------------------------------
0044 6DE6 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6DE8 2F20 
     6DEA A204 
0045 6DEC 1204  14         jle   !
0046 6DEE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DF0 FFCE 
0047 6DF2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DF4 2030 
0048                       ;------------------------------------------------------
0049                       ; Save parameters
0050                       ;------------------------------------------------------
0051 6DF6 C820  54 !       mov   @parm1,@rambuf
     6DF8 2F20 
     6DFA 2F64 
0052 6DFC C820  54         mov   @parm2,@rambuf+2
     6DFE 2F22 
     6E00 2F66 
0053                       ;------------------------------------------------------
0054                       ; Calculate offset in frame buffer
0055                       ;------------------------------------------------------
0056 6E02 C120  34         mov   @fb.colsline,tmp0
     6E04 A10E 
0057 6E06 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6E08 2F22 
0058 6E0A C1A0  34         mov   @fb.top.ptr,tmp2
     6E0C A100 
0059 6E0E A146  18         a     tmp2,tmp1             ; Add base to offset
0060 6E10 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6E12 2F6A 
0061                       ;------------------------------------------------------
0062                       ; Get pointer to line & page-in editor buffer page
0063                       ;------------------------------------------------------
0064 6E14 C120  34         mov   @parm1,tmp0
     6E16 2F20 
0065 6E18 06A0  32         bl    @xmem.edb.sams.mappage
     6E1A 68AA 
0066                                                   ; Activate editor buffer SAMS page for line
0067                                                   ; \ i  tmp0     = Line number
0068                                                   ; | o  outparm1 = Pointer to line
0069                                                   ; / o  outparm2 = SAMS page
0070                       ;------------------------------------------------------
0071                       ; Handle empty line
0072                       ;------------------------------------------------------
0073 6E1C C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6E1E 2F30 
0074 6E20 1606  14         jne   !                     ; Check if pointer is set
0075 6E22 04E0  34         clr   @rambuf+8             ; Set length=0
     6E24 2F6C 
0076 6E26 1014  14         jmp   edb.line.unpack.clear
0077                       ;------------------------------------------------------
0078                       ; Get line length
0079                       ;------------------------------------------------------
0080 6E28 C820  54         mov   @outparm2,@edb.sams.page
     6E2A 2F32 
     6E2C A212 
0081                                                   ; Save current SAMS page
0082               
0083 6E2E C154  26 !       mov   *tmp0,tmp1            ; Get line length
0084 6E30 0245  22         andi  tmp1,>00ff            ; Line can never be more than 80 characters
     6E32 00FF 
0085 6E34 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6E36 2F6C 
0086               
0087 6E38 05E0  34         inct  @outparm1             ; Skip line prefix
     6E3A 2F30 
0088 6E3C C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6E3E 2F30 
     6E40 2F68 
0089                       ;------------------------------------------------------
0090                       ; Sanity check on line length
0091                       ;------------------------------------------------------
0092 6E42 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6E44 0050 
0093 6E46 1204  14         jle   edb.line.unpack.clear ; /
0094               
0095 6E48 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E4A FFCE 
0096 6E4C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E4E 2030 
0097                       ;------------------------------------------------------
0098                       ; Erase chars from last column until column 80
0099                       ;------------------------------------------------------
0100               edb.line.unpack.clear:
0101 6E50 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6E52 2F6A 
0102 6E54 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6E56 2F6C 
0103               
0104 6E58 04C5  14         clr   tmp1                  ; Fill with >00
0105 6E5A C1A0  34         mov   @fb.colsline,tmp2
     6E5C A10E 
0106 6E5E 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6E60 2F6C 
0107 6E62 0586  14         inc   tmp2
0108               
0109 6E64 06A0  32         bl    @xfilm                ; Fill CPU memory
     6E66 2248 
0110                                                   ; \ i  tmp0 = Target address
0111                                                   ; | i  tmp1 = Byte to fill
0112                                                   ; / i  tmp2 = Repeat count
0113                       ;------------------------------------------------------
0114                       ; Prepare for unpacking data
0115                       ;------------------------------------------------------
0116               edb.line.unpack.prepare:
0117 6E68 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6E6A 2F6C 
0118 6E6C 130F  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0119 6E6E C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6E70 2F68 
0120 6E72 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6E74 2F6A 
0121                       ;------------------------------------------------------
0122                       ; Check before copy
0123                       ;------------------------------------------------------
0124               edb.line.unpack.copy:
0125 6E76 0286  22         ci    tmp2,80               ; Check line length
     6E78 0050 
0126 6E7A 1204  14         jle   !
0127 6E7C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E7E FFCE 
0128 6E80 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E82 2030 
0129                       ;------------------------------------------------------
0130                       ; Copy memory block
0131                       ;------------------------------------------------------
0132 6E84 C806  38 !       mov   tmp2,@outparm1        ; Length of unpacked line
     6E86 2F30 
0133               
0134 6E88 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6E8A 24B0 
0135                                                   ; \ i  tmp0 = Source address
0136                                                   ; | i  tmp1 = Target address
0137                                                   ; / i  tmp2 = Bytes to copy
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               edb.line.unpack.exit:
0142 6E8C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0143 6E8E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0144 6E90 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0145 6E92 C2F9  30         mov   *stack+,r11           ; Pop r11
0146 6E94 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0145                       copy  "edb.line.getlen.asm" ; Get line length
**** **** ****     > edb.line.getlen.asm
0001               * FILE......: edb.line.getlen.asm
0002               * Purpose...: Stevie Editor - Editor Buffer get line length
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *       Stevie Editor - Editor Buffer get line length
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               
0010               
0011               
0012               ***************************************************************
0013               * edb.line.getlength
0014               * Get length of specified line
0015               ***************************************************************
0016               *  bl   @edb.line.getlength
0017               *--------------------------------------------------------------
0018               * INPUT
0019               * @parm1 = Line number
0020               *--------------------------------------------------------------
0021               * OUTPUT
0022               * @outparm1 = Length of line
0023               * @outparm2 = SAMS page
0024               *--------------------------------------------------------------
0025               * Register usage
0026               * tmp0,tmp1
0027               *--------------------------------------------------------------
0028               * Remarks
0029               * Expects that the affected SAMS page is already paged-in!
0030               ********|*****|*********************|**************************
0031               edb.line.getlength:
0032 6E96 0649  14         dect  stack
0033 6E98 C64B  30         mov   r11,*stack            ; Push return address
0034 6E9A 0649  14         dect  stack
0035 6E9C C644  30         mov   tmp0,*stack           ; Push tmp0
0036 6E9E 0649  14         dect  stack
0037 6EA0 C645  30         mov   tmp1,*stack           ; Push tmp1
0038                       ;------------------------------------------------------
0039                       ; Initialisation
0040                       ;------------------------------------------------------
0041 6EA2 04E0  34         clr   @outparm1             ; Reset length
     6EA4 2F30 
0042 6EA6 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6EA8 2F32 
0043                       ;------------------------------------------------------
0044                       ; Get length
0045                       ;------------------------------------------------------
0046 6EAA 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6EAC 6B68 
0047                                                   ; \ i  parm1    = Line number
0048                                                   ; | o  outparm1 = Pointer to line
0049                                                   ; / o  outparm2 = SAMS page
0050               
0051 6EAE C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6EB0 2F30 
0052 6EB2 1302  14         jeq   edb.line.getlength.exit
0053                                                   ; Exit early if NULL pointer
0054                       ;------------------------------------------------------
0055                       ; Process line prefix
0056                       ;------------------------------------------------------
0057 6EB4 C814  46         mov   *tmp0,@outparm1       ; Save length
     6EB6 2F30 
0058                       ;------------------------------------------------------
0059                       ; Exit
0060                       ;------------------------------------------------------
0061               edb.line.getlength.exit:
0062 6EB8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 6EBA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 6EBC C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6EBE 045B  20         b     *r11                  ; Return to caller
0066               
0067               
0068               
0069               ***************************************************************
0070               * edb.line.getlength2
0071               * Get length of current row (as seen from editor buffer side)
0072               ***************************************************************
0073               *  bl   @edb.line.getlength2
0074               *--------------------------------------------------------------
0075               * INPUT
0076               * @fb.row = Row in frame buffer
0077               *--------------------------------------------------------------
0078               * OUTPUT
0079               * @fb.row.length = Length of row
0080               *--------------------------------------------------------------
0081               * Register usage
0082               * tmp0
0083               ********|*****|*********************|**************************
0084               edb.line.getlength2:
0085 6EC0 0649  14         dect  stack
0086 6EC2 C64B  30         mov   r11,*stack            ; Save return address
0087                       ;------------------------------------------------------
0088                       ; Calculate line in editor buffer
0089                       ;------------------------------------------------------
0090 6EC4 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6EC6 A104 
0091 6EC8 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6ECA A106 
0092                       ;------------------------------------------------------
0093                       ; Get length
0094                       ;------------------------------------------------------
0095 6ECC C804  38         mov   tmp0,@parm1
     6ECE 2F20 
0096 6ED0 06A0  32         bl    @edb.line.getlength
     6ED2 6E96 
0097 6ED4 C820  54         mov   @outparm1,@fb.row.length
     6ED6 2F30 
     6ED8 A108 
0098                                                   ; Save row length
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.getlength2.exit:
0103 6EDA C2F9  30         mov   *stack+,r11           ; Pop R11
0104 6EDC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0146                       ;-----------------------------------------------------------------------
0147                       ; Command buffer handling
0148                       ;-----------------------------------------------------------------------
0149                       copy  "cmdb.asm"            ; Command buffer shared code
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
0027 6EDE 0649  14         dect  stack
0028 6EE0 C64B  30         mov   r11,*stack            ; Save return address
0029 6EE2 0649  14         dect  stack
0030 6EE4 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 6EE6 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6EE8 D000 
0035 6EEA C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6EEC A300 
0036               
0037 6EEE 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6EF0 A302 
0038 6EF2 0204  20         li    tmp0,4
     6EF4 0004 
0039 6EF6 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6EF8 A306 
0040 6EFA C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6EFC A308 
0041               
0042 6EFE 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6F00 A316 
0043 6F02 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6F04 A318 
0044 6F06 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     6F08 A322 
0045                       ;------------------------------------------------------
0046                       ; Clear command buffer
0047                       ;------------------------------------------------------
0048 6F0A 06A0  32         bl    @film
     6F0C 2242 
0049 6F0E D000             data  cmdb.top,>00,cmdb.size
     6F10 0000 
     6F12 1000 
0050                                                   ; Clear it all the way
0051               cmdb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 6F14 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 6F16 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 6F18 045B  20         b     *r11                  ; Return to caller
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
0083 6F1A 0649  14         dect  stack
0084 6F1C C64B  30         mov   r11,*stack            ; Save return address
0085 6F1E 0649  14         dect  stack
0086 6F20 C644  30         mov   tmp0,*stack           ; Push tmp0
0087 6F22 0649  14         dect  stack
0088 6F24 C645  30         mov   tmp1,*stack           ; Push tmp1
0089 6F26 0649  14         dect  stack
0090 6F28 C646  30         mov   tmp2,*stack           ; Push tmp2
0091                       ;------------------------------------------------------
0092                       ; Dump Command buffer content
0093                       ;------------------------------------------------------
0094 6F2A C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6F2C 832A 
     6F2E A30C 
0095 6F30 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6F32 A310 
     6F34 832A 
0096               
0097 6F36 05A0  34         inc   @wyx                  ; X +1 for prompt
     6F38 832A 
0098               
0099 6F3A 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6F3C 2406 
0100                                                   ; \ i  @wyx = Cursor position
0101                                                   ; / o  tmp0 = VDP target address
0102               
0103 6F3E 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6F40 A325 
0104 6F42 0206  20         li    tmp2,1*79             ; Command length
     6F44 004F 
0105               
0106 6F46 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6F48 245C 
0107                                                   ; | i  tmp0 = VDP target address
0108                                                   ; | i  tmp1 = RAM source address
0109                                                   ; / i  tmp2 = Number of bytes to copy
0110                       ;------------------------------------------------------
0111                       ; Show command buffer prompt
0112                       ;------------------------------------------------------
0113 6F4A C820  54         mov   @cmdb.yxprompt,@wyx
     6F4C A310 
     6F4E 832A 
0114 6F50 06A0  32         bl    @putstr
     6F52 242A 
0115 6F54 357C                   data txt.cmdb.prompt
0116               
0117 6F56 C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6F58 A30C 
     6F5A A114 
0118 6F5C C820  54         mov   @cmdb.yxsave,@wyx
     6F5E A30C 
     6F60 832A 
0119                                                   ; Restore YX position
0120                       ;------------------------------------------------------
0121                       ; Exit
0122                       ;------------------------------------------------------
0123               cmdb.refresh.exit:
0124 6F62 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0125 6F64 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0126 6F66 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0127 6F68 C2F9  30         mov   *stack+,r11           ; Pop r11
0128 6F6A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0150                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0026 6F6C 0649  14         dect  stack
0027 6F6E C64B  30         mov   r11,*stack            ; Save return address
0028 6F70 0649  14         dect  stack
0029 6F72 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 6F74 0649  14         dect  stack
0031 6F76 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 6F78 0649  14         dect  stack
0033 6F7A C646  30         mov   tmp2,*stack           ; Push tmp2
0034                       ;------------------------------------------------------
0035                       ; Clear command
0036                       ;------------------------------------------------------
0037 6F7C 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6F7E A324 
0038 6F80 06A0  32         bl    @film                 ; Clear command
     6F82 2242 
0039 6F84 A325                   data  cmdb.cmd,>00,80
     6F86 0000 
     6F88 0050 
0040                       ;------------------------------------------------------
0041                       ; Put cursor at beginning of line
0042                       ;------------------------------------------------------
0043 6F8A C120  34         mov   @cmdb.yxprompt,tmp0
     6F8C A310 
0044 6F8E 0584  14         inc   tmp0
0045 6F90 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6F92 A30A 
0046                       ;------------------------------------------------------
0047                       ; Exit
0048                       ;------------------------------------------------------
0049               cmdb.cmd.clear.exit:
0050 6F94 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0051 6F96 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 6F98 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6F9A C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6F9C 045B  20         b     *r11                  ; Return to caller
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
0079 6F9E 0649  14         dect  stack
0080 6FA0 C64B  30         mov   r11,*stack            ; Save return address
0081                       ;-------------------------------------------------------
0082                       ; Get length of null terminated string
0083                       ;-------------------------------------------------------
0084 6FA2 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6FA4 2A98 
0085 6FA6 A325                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6FA8 0000 
0086                                                  ; | i  p1    = Termination character
0087                                                  ; / o  waux1 = Length of string
0088 6FAA C820  54         mov   @waux1,@outparm1     ; Save length of string
     6FAC 833C 
     6FAE 2F30 
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cmdb.cmd.getlength.exit:
0093 6FB0 C2F9  30         mov   *stack+,r11           ; Pop r11
0094 6FB2 045B  20         b     *r11                  ; Return to caller
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
0119 6FB4 0649  14         dect  stack
0120 6FB6 C64B  30         mov   r11,*stack            ; Save return address
0121 6FB8 0649  14         dect  stack
0122 6FBA C644  30         mov   tmp0,*stack           ; Push tmp0
0123               
0124 6FBC 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     6FBE 6F9E 
0125                                                   ; \ i  @cmdb.cmd
0126                                                   ; / o  @outparm1
0127                       ;------------------------------------------------------
0128                       ; Sanity check
0129                       ;------------------------------------------------------
0130 6FC0 C120  34         mov   @outparm1,tmp0        ; Check length
     6FC2 2F30 
0131 6FC4 1300  14         jeq   cmdb.cmd.history.add.exit
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
0143 6FC6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0144 6FC8 C2F9  30         mov   *stack+,r11           ; Pop r11
0145 6FCA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0151                       copy  "errline.asm"         ; Error line
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
0026 6FCC 0649  14         dect  stack
0027 6FCE C64B  30         mov   r11,*stack            ; Save return address
0028 6FD0 0649  14         dect  stack
0029 6FD2 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6FD4 04E0  34         clr   @tv.error.visible     ; Set to hidden
     6FD6 A01E 
0034               
0035 6FD8 06A0  32         bl    @film
     6FDA 2242 
0036 6FDC A020                   data tv.error.msg,0,160
     6FDE 0000 
     6FE0 00A0 
0037               
0038 6FE2 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     6FE4 A000 
0039 6FE6 D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     6FE8 A020 
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               errline.exit:
0044 6FEA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0045 6FEC C2F9  30         mov   *stack+,r11           ; Pop R11
0046 6FEE 045B  20         b     *r11                  ; Return to caller
0047               
**** **** ****     > stevie_b1.asm.1638280
0152                       ;-----------------------------------------------------------------------
0153                       ; File handling
0154                       ;-----------------------------------------------------------------------
0155                       copy  "fh.read.edb.asm"     ; Read file to editor buffer
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
0028 6FF0 0649  14         dect  stack
0029 6FF2 C64B  30         mov   r11,*stack            ; Save return address
0030 6FF4 0649  14         dect  stack
0031 6FF6 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6FF8 0649  14         dect  stack
0033 6FFA C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6FFC 0649  14         dect  stack
0035 6FFE C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 7000 04E0  34         clr   @fh.records           ; Reset records counter
     7002 A43C 
0040 7004 04E0  34         clr   @fh.counter           ; Clear internal counter
     7006 A442 
0041 7008 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     700A A440 
0042 700C 04E0  34         clr   @fh.kilobytes.prev    ; /
     700E A458 
0043 7010 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     7012 A438 
0044 7014 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     7016 A43A 
0045               
0046 7018 C120  34         mov   @edb.top.ptr,tmp0
     701A A200 
0047 701C 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     701E 250E 
0048                                                   ; \ i  tmp0  = Memory address
0049                                                   ; | o  waux1 = SAMS page number
0050                                                   ; / o  waux2 = Address of SAMS register
0051               
0052 7020 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     7022 833C 
     7024 A446 
0053 7026 C820  54         mov   @waux1,@fh.sams.hipage
     7028 833C 
     702A A448 
0054                                                   ; Set highest SAMS page in use
0055                       ;------------------------------------------------------
0056                       ; Save parameters / callback functions
0057                       ;------------------------------------------------------
0058 702C 0204  20         li    tmp0,fh.fopmode.readfile
     702E 0001 
0059                                                   ; We are going to read a file
0060 7030 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     7032 A44A 
0061               
0062 7034 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     7036 2F20 
     7038 A444 
0063 703A C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     703C 2F22 
     703E A450 
0064 7040 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     7042 2F24 
     7044 A452 
0065 7046 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     7048 2F26 
     704A A454 
0066 704C C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     704E 2F28 
     7050 A456 
0067                       ;------------------------------------------------------
0068                       ; Sanity check
0069                       ;------------------------------------------------------
0070 7052 C120  34         mov   @fh.callback1,tmp0
     7054 A450 
0071 7056 0284  22         ci    tmp0,>6000            ; Insane address ?
     7058 6000 
0072 705A 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0073               
0074 705C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     705E 7FFF 
0075 7060 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0076               
0077 7062 C120  34         mov   @fh.callback2,tmp0
     7064 A452 
0078 7066 0284  22         ci    tmp0,>6000            ; Insane address ?
     7068 6000 
0079 706A 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0080               
0081 706C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     706E 7FFF 
0082 7070 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0083               
0084 7072 C120  34         mov   @fh.callback3,tmp0
     7074 A454 
0085 7076 0284  22         ci    tmp0,>6000            ; Insane address ?
     7078 6000 
0086 707A 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0087               
0088 707C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     707E 7FFF 
0089 7080 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0090               
0091 7082 1004  14         jmp   fh.file.read.edb.load1
0092                                                   ; All checks passed, continue
0093                       ;------------------------------------------------------
0094                       ; Check failed, crash CPU!
0095                       ;------------------------------------------------------
0096               fh.file.read.crash:
0097 7084 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7086 FFCE 
0098 7088 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     708A 2030 
0099                       ;------------------------------------------------------
0100                       ; Callback "Before Open file"
0101                       ;------------------------------------------------------
0102               fh.file.read.edb.load1:
0103 708C C120  34         mov   @fh.callback1,tmp0
     708E A450 
0104 7090 0694  24         bl    *tmp0                 ; Run callback function
0105                       ;------------------------------------------------------
0106                       ; Copy PAB header to VDP
0107                       ;------------------------------------------------------
0108               fh.file.read.edb.pabheader:
0109 7092 06A0  32         bl    @cpym2v
     7094 2456 
0110 7096 0A60                   data fh.vpab,fh.file.pab.header,9
     7098 720A 
     709A 0009 
0111                                                   ; Copy PAB header to VDP
0112                       ;------------------------------------------------------
0113                       ; Append file descriptor to PAB header in VDP
0114                       ;------------------------------------------------------
0115 709C 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     709E 0A69 
0116 70A0 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     70A2 A444 
0117 70A4 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0118 70A6 0986  56         srl   tmp2,8                ; Right justify
0119 70A8 0586  14         inc   tmp2                  ; Include length byte as well
0120               
0121 70AA 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     70AC 245C 
0122                                                   ; \ i  tmp0 = VDP destination
0123                                                   ; | i  tmp1 = CPU source
0124                                                   ; / i  tmp2 = Number of bytes to copy
0125                       ;------------------------------------------------------
0126                       ; Open file
0127                       ;------------------------------------------------------
0128 70AE 06A0  32         bl    @file.open            ; Open file
     70B0 2C5C 
0129 70B2 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0130 70B4 0014                   data io.seq.inp.dis.var
0131                                                   ; / i  p1 = File type/mode
0132               
0133 70B6 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     70B8 2026 
0134 70BA 1602  14         jne   fh.file.read.edb.check_setpage
0135               
0136 70BC 0460  28         b     @fh.file.read.edb.error
     70BE 71C8 
0137                                                   ; Yes, IO error occured
0138                       ;------------------------------------------------------
0139                       ; 1a: Check if SAMS page needs to be increased
0140                       ;------------------------------------------------------
0141               fh.file.read.edb.check_setpage:
0142 70C0 C120  34         mov   @edb.next_free.ptr,tmp0
     70C2 A208 
0143                                                   ;--------------------------
0144                                                   ; Sanity check
0145                                                   ;--------------------------
0146 70C4 0284  22         ci    tmp0,edb.top + edb.size
     70C6 D000 
0147                                                   ; Insane address ?
0148 70C8 15DD  14         jgt   fh.file.read.crash    ; Yes, crash!
0149                                                   ;--------------------------
0150                                                   ; Check for page overflow
0151                                                   ;--------------------------
0152 70CA 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     70CC 0FFF 
0153 70CE 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     70D0 0052 
0154 70D2 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     70D4 0FF0 
0155 70D6 110E  14         jlt   fh.file.read.edb.record
0156                                                   ; Not yet so skip SAMS page switch
0157                       ;------------------------------------------------------
0158                       ; 1b: Increase SAMS page
0159                       ;------------------------------------------------------
0160 70D8 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     70DA A446 
0161 70DC C820  54         mov   @fh.sams.page,@fh.sams.hipage
     70DE A446 
     70E0 A448 
0162                                                   ; Set highest SAMS page
0163 70E2 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     70E4 A200 
     70E6 A208 
0164                                                   ; Start at top of SAMS page again
0165                       ;------------------------------------------------------
0166                       ; 1c: Switch to SAMS page
0167                       ;------------------------------------------------------
0168 70E8 C120  34         mov   @fh.sams.page,tmp0
     70EA A446 
0169 70EC C160  34         mov   @edb.top.ptr,tmp1
     70EE A200 
0170 70F0 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     70F2 2546 
0171                                                   ; \ i  tmp0 = SAMS page number
0172                                                   ; / i  tmp1 = Memory address
0173                       ;------------------------------------------------------
0174                       ; Step 2: Read file record
0175                       ;------------------------------------------------------
0176               fh.file.read.edb.record:
0177 70F4 05A0  34         inc   @fh.records           ; Update counter
     70F6 A43C 
0178 70F8 04E0  34         clr   @fh.reclen            ; Reset record length
     70FA A43E 
0179               
0180 70FC 0760  38         abs   @fh.offsetopcode
     70FE A44E 
0181 7100 1310  14         jeq   !                     ; Skip CPU buffer logic if offset = 0
0182                       ;------------------------------------------------------
0183                       ; 2a: Write address of CPU buffer to VDP PAB bytes 2-3
0184                       ;------------------------------------------------------
0185 7102 C160  34         mov   @edb.next_free.ptr,tmp1
     7104 A208 
0186 7106 05C5  14         inct  tmp1
0187 7108 0204  20         li    tmp0,fh.vpab + 2
     710A 0A62 
0188               
0189 710C 0264  22         ori   tmp0,>4000            ; Prepare VDP address for write
     710E 4000 
0190 7110 06C4  14         swpb  tmp0                  ; \
0191 7112 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     7114 8C02 
0192 7116 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0193 7118 D804  38         movb  tmp0,@vdpa            ; /
     711A 8C02 
0194               
0195 711C D7C5  30         movb  tmp1,*r15             ; Write MSB
0196 711E 06C5  14         swpb  tmp1
0197 7120 D7C5  30         movb  tmp1,*r15             ; Write LSB
0198                       ;------------------------------------------------------
0199                       ; 2b: Read file record
0200                       ;------------------------------------------------------
0201 7122 06A0  32 !       bl    @file.record.read     ; Read file record
     7124 2C8C 
0202 7126 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0203                                                   ; |           (without +9 offset!)
0204                                                   ; | o  tmp0 = Status byte
0205                                                   ; | o  tmp1 = Bytes read
0206                                                   ; | o  tmp2 = Status register contents
0207                                                   ; /           upon DSRLNK return
0208               
0209 7128 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     712A A438 
0210 712C C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     712E A43E 
0211 7130 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     7132 A43A 
0212                       ;------------------------------------------------------
0213                       ; 2c: Calculate kilobytes processed
0214                       ;------------------------------------------------------
0215 7134 A805  38         a     tmp1,@fh.counter      ; Add record length to counter
     7136 A442 
0216 7138 C160  34         mov   @fh.counter,tmp1      ;
     713A A442 
0217 713C 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     713E 0400 
0218 7140 1106  14         jlt   fh.file.read.edb.check_fioerr
0219                                                   ; Not yet, goto (2d)
0220 7142 05A0  34         inc   @fh.kilobytes
     7144 A440 
0221 7146 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     7148 FC00 
0222 714A C805  38         mov   tmp1,@fh.counter      ; Update counter
     714C A442 
0223                       ;------------------------------------------------------
0224                       ; 2d: Check if a file error occured
0225                       ;------------------------------------------------------
0226               fh.file.read.edb.check_fioerr:
0227 714E C1A0  34         mov   @fh.ioresult,tmp2
     7150 A43A 
0228 7152 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7154 2026 
0229 7156 1602  14         jne   fh.file.read.edb.process_line
0230                                                   ; No, goto (3)
0231 7158 0460  28         b     @fh.file.read.edb.error
     715A 71C8 
0232                                                   ; Yes, so handle file error
0233                       ;------------------------------------------------------
0234                       ; Step 3: Process line
0235                       ;------------------------------------------------------
0236               fh.file.read.edb.process_line:
0237 715C 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     715E 0960 
0238 7160 C160  34         mov   @edb.next_free.ptr,tmp1
     7162 A208 
0239                                                   ; RAM target in editor buffer
0240               
0241 7164 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7166 2F22 
0242               
0243 7168 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     716A A43E 
0244 716C 131B  14         jeq   fh.file.read.edb.prepindex.emptyline
0245                                                   ; Handle empty line
0246                       ;------------------------------------------------------
0247                       ; 3a: Set length of line in CPU editor buffer
0248                       ;------------------------------------------------------
0249 716E 04D5  26         clr   *tmp1                 ; Clear word before string
0250 7170 0585  14         inc   tmp1                  ; Adjust position for length byte string
0251 7172 DD60  48         movb  @fh.reclen+1,*tmp1+   ; Put line length byte before string
     7174 A43F 
0252               
0253 7176 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7178 A208 
0254 717A A806  38         a     tmp2,@edb.next_free.ptr
     717C A208 
0255                                                   ; Add line length
0256               
0257 717E 0760  38         abs   @fh.offsetopcode      ; Use CPU buffer if offset > 0
     7180 A44E 
0258 7182 1602  14         jne   fh.file.read.edb.preppointer
0259                       ;------------------------------------------------------
0260                       ; 3b: Copy line from VDP to CPU editor buffer
0261                       ;------------------------------------------------------
0262               fh.file.read.edb.vdp2cpu:
0263                       ;
0264                       ; Executed for devices that need their disk buffer in VDP memory
0265                       ; (TI Disk Controller, tipi, nanopeb, ...).
0266                       ;
0267 7184 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7186 248E 
0268                                                   ; \ i  tmp0 = VDP source address
0269                                                   ; | i  tmp1 = RAM target address
0270                                                   ; / i  tmp2 = Bytes to copy
0271                       ;------------------------------------------------------
0272                       ; 3c: Align pointer for next line
0273                       ;------------------------------------------------------
0274               fh.file.read.edb.preppointer:
0275 7188 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     718A A208 
0276 718C 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0277 718E 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7190 000F 
0278 7192 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     7194 A208 
0279                       ;------------------------------------------------------
0280                       ; Step 4: Update index
0281                       ;------------------------------------------------------
0282               fh.file.read.edb.prepindex:
0283 7196 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7198 A204 
     719A 2F20 
0284                                                   ; parm2 = Must allready be set!
0285 719C C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     719E A446 
     71A0 2F24 
0286               
0287 71A2 1009  14         jmp   fh.file.read.edb.updindex
0288                                                   ; Update index
0289                       ;------------------------------------------------------
0290                       ; 4a: Special handling for empty line
0291                       ;------------------------------------------------------
0292               fh.file.read.edb.prepindex.emptyline:
0293 71A4 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     71A6 A43C 
     71A8 2F20 
0294 71AA 0620  34         dec   @parm1                ;         Adjust for base 0 index
     71AC 2F20 
0295 71AE 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     71B0 2F22 
0296 71B2 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     71B4 2F24 
0297                       ;------------------------------------------------------
0298                       ; 4b: Do actual index update
0299                       ;------------------------------------------------------
0300               fh.file.read.edb.updindex:
0301 71B6 06A0  32         bl    @idx.entry.update     ; Update index
     71B8 6B16 
0302                                                   ; \ i  parm1    = Line num in editor buffer
0303                                                   ; | i  parm2    = Pointer to line in editor
0304                                                   ; |               buffer
0305                                                   ; | i  parm3    = SAMS page
0306                                                   ; | o  outparm1 = Pointer to updated index
0307                                                   ; /               entry
0308               
0309 71BA 05A0  34         inc   @edb.lines            ; lines=lines+1
     71BC A204 
0310                       ;------------------------------------------------------
0311                       ; Step 5: Callback "Read line from file"
0312                       ;------------------------------------------------------
0313               fh.file.read.edb.display:
0314 71BE C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     71C0 A452 
0315 71C2 0694  24         bl    *tmp0                 ; Run callback function
0316                       ;------------------------------------------------------
0317                       ; 5a: Next record
0318                       ;------------------------------------------------------
0319               fh.file.read.edb.next:
0320 71C4 0460  28         b     @fh.file.read.edb.check_setpage
     71C6 70C0 
0321                                                   ; Next record
0322                       ;------------------------------------------------------
0323                       ; Error handler
0324                       ;------------------------------------------------------
0325               fh.file.read.edb.error:
0326 71C8 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     71CA A438 
0327 71CC 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0328 71CE 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     71D0 0005 
0329 71D2 1309  14         jeq   fh.file.read.edb.eof  ; All good. File closed by DSRLNK
0330                       ;------------------------------------------------------
0331                       ; File error occured
0332                       ;------------------------------------------------------
0333 71D4 06A0  32         bl    @file.close           ; Close file
     71D6 2C80 
0334 71D8 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0335               
0336 71DA 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     71DC 6888 
0337                       ;------------------------------------------------------
0338                       ; Callback "File I/O error"
0339                       ;------------------------------------------------------
0340 71DE C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     71E0 A456 
0341 71E2 0694  24         bl    *tmp0                 ; Run callback function
0342 71E4 1008  14         jmp   fh.file.read.edb.exit
0343                       ;------------------------------------------------------
0344                       ; End-Of-File reached
0345                       ;------------------------------------------------------
0346               fh.file.read.edb.eof:
0347 71E6 06A0  32         bl    @file.close           ; Close file
     71E8 2C80 
0348 71EA 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0349               
0350 71EC 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     71EE 6888 
0351                       ;------------------------------------------------------
0352                       ; Callback "Close file"
0353                       ;------------------------------------------------------
0354 71F0 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     71F2 A454 
0355 71F4 0694  24         bl    *tmp0                 ; Run callback function
0356               *--------------------------------------------------------------
0357               * Exit
0358               *--------------------------------------------------------------
0359               fh.file.read.edb.exit:
0360 71F6 C820  54         mov   @fh.sams.hipage,@edb.sams.hipage
     71F8 A448 
     71FA A214 
0361                                                   ; Set highest SAMS page in use
0362               
0363 71FC 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     71FE A44A 
0364 7200 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0365 7202 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0366 7204 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0367 7206 C2F9  30         mov   *stack+,r11           ; Pop R11
0368 7208 045B  20         b     *r11                  ; Return to caller
0369               
0370               
0371               ***************************************************************
0372               * PAB for accessing DV/80 file
0373               ********|*****|*********************|**************************
0374               fh.file.pab.header:
0375 720A 0014             byte  io.op.open            ;  0    - OPEN
0376                       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
0377 720C 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0378 720E 5000             byte  80                    ;  4    - Record length (80 chars max)
0379                       byte  00                    ;  5    - Character count
0380 7210 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0381 7212 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0382                       ;------------------------------------------------------
0383                       ; File descriptor part (variable length)
0384                       ;------------------------------------------------------
0385                       ; byte  12                  ;  9    - File descriptor length
0386                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0387                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.1638280
0156                       copy  "fh.write.edb.asm"    ; Write editor buffer to file
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
0028 7214 0649  14         dect  stack
0029 7216 C64B  30         mov   r11,*stack            ; Save return address
0030 7218 0649  14         dect  stack
0031 721A C644  30         mov   tmp0,*stack           ; Push tmp0
0032 721C 0649  14         dect  stack
0033 721E C645  30         mov   tmp1,*stack           ; Push tmp1
0034 7220 0649  14         dect  stack
0035 7222 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 7224 04E0  34         clr   @fh.records           ; Reset records counter
     7226 A43C 
0040 7228 04E0  34         clr   @fh.counter           ; Clear internal counter
     722A A442 
0041 722C 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     722E A440 
0042 7230 04E0  34         clr   @fh.kilobytes.prev    ; /
     7232 A458 
0043 7234 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     7236 A438 
0044 7238 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     723A A43A 
0045                       ;------------------------------------------------------
0046                       ; Save parameters / callback functions
0047                       ;------------------------------------------------------
0048 723C 0204  20         li    tmp0,fh.fopmode.writefile
     723E 0002 
0049                                                   ; We are going to write to a file
0050 7240 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     7242 A44A 
0051               
0052 7244 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     7246 2F20 
     7248 A444 
0053 724A C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     724C 2F22 
     724E A450 
0054 7250 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Write line to file"
     7252 2F24 
     7254 A452 
0055 7256 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     7258 2F26 
     725A A454 
0056 725C C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     725E 2F28 
     7260 A456 
0057                       ;------------------------------------------------------
0058                       ; Sanity check
0059                       ;------------------------------------------------------
0060 7262 C120  34         mov   @fh.callback1,tmp0
     7264 A450 
0061 7266 0284  22         ci    tmp0,>6000            ; Insane address ?
     7268 6000 
0062 726A 1114  14         jlt   fh.file.write.crash   ; Yes, crash!
0063               
0064 726C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     726E 7FFF 
0065 7270 1511  14         jgt   fh.file.write.crash   ; Yes, crash!
0066               
0067 7272 C120  34         mov   @fh.callback2,tmp0
     7274 A452 
0068 7276 0284  22         ci    tmp0,>6000            ; Insane address ?
     7278 6000 
0069 727A 110C  14         jlt   fh.file.write.crash   ; Yes, crash!
0070               
0071 727C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     727E 7FFF 
0072 7280 1509  14         jgt   fh.file.write.crash   ; Yes, crash!
0073               
0074 7282 C120  34         mov   @fh.callback3,tmp0
     7284 A454 
0075 7286 0284  22         ci    tmp0,>6000            ; Insane address ?
     7288 6000 
0076 728A 1104  14         jlt   fh.file.write.crash   ; Yes, crash!
0077               
0078 728C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     728E 7FFF 
0079 7290 1501  14         jgt   fh.file.write.crash   ; Yes, crash!
0080               
0081 7292 1004  14         jmp   fh.file.write.edb.save1
0082                                                   ; All checks passed, continue.
0083                       ;------------------------------------------------------
0084                       ; Check failed, crash CPU!
0085                       ;------------------------------------------------------
0086               fh.file.write.crash:
0087 7294 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7296 FFCE 
0088 7298 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     729A 2030 
0089                       ;------------------------------------------------------
0090                       ; Callback "Before Open file"
0091                       ;------------------------------------------------------
0092               fh.file.write.edb.save1:
0093 729C C120  34         mov   @fh.callback1,tmp0
     729E A450 
0094 72A0 0694  24         bl    *tmp0                 ; Run callback function
0095                       ;------------------------------------------------------
0096                       ; Copy PAB header to VDP
0097                       ;------------------------------------------------------
0098               fh.file.write.edb.pabheader:
0099 72A2 06A0  32         bl    @cpym2v
     72A4 2456 
0100 72A6 0A60                   data fh.vpab,fh.file.pab.header,9
     72A8 720A 
     72AA 0009 
0101                                                   ; Copy PAB header to VDP
0102                       ;------------------------------------------------------
0103                       ; Append file descriptor to PAB header in VDP
0104                       ;------------------------------------------------------
0105 72AC 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     72AE 0A69 
0106 72B0 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     72B2 A444 
0107 72B4 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0108 72B6 0986  56         srl   tmp2,8                ; Right justify
0109 72B8 0586  14         inc   tmp2                  ; Include length byte as well
0110               
0111 72BA 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     72BC 245C 
0112                                                   ; \ i  tmp0 = VDP destination
0113                                                   ; | i  tmp1 = CPU source
0114                                                   ; / i  tmp2 = Number of bytes to copy
0115                       ;------------------------------------------------------
0116                       ; Open file
0117                       ;------------------------------------------------------
0118 72BE 06A0  32         bl    @file.open            ; Open file
     72C0 2C5C 
0119 72C2 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0120 72C4 0012                   data io.seq.out.dis.var
0121                                                   ; / i  p1 = File type/mode
0122               
0123 72C6 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     72C8 2026 
0124 72CA 1338  14         jeq   fh.file.write.edb.error
0125                                                   ; Yes, IO error occured
0126                       ;------------------------------------------------------
0127                       ; Step 1: Write file record
0128                       ;------------------------------------------------------
0129               fh.file.write.edb.record:
0130 72CC 8820  54         c     @fh.records,@edb.lines
     72CE A43C 
     72D0 A204 
0131 72D2 153E  14         jgt   fh.file.write.edb.done
0132                                                   ; Exit when all records processed
0133                       ;------------------------------------------------------
0134                       ; 1a: Unpack current line to framebuffer
0135                       ;------------------------------------------------------
0136 72D4 C820  54         mov   @fh.records,@parm1    ; Line to unpack
     72D6 A43C 
     72D8 2F20 
0137 72DA 04E0  34         clr   @parm2                ; 1st row in frame buffer
     72DC 2F22 
0138               
0139 72DE 06A0  32         bl    @edb.line.unpack      ; Unpack line
     72E0 6DD6 
0140                                                   ; \ i  parm1    = Line to unpack
0141                                                   ; | i  parm2    = Target row in frame buffer
0142                                                   ; / o  outparm1 = Length of line
0143                       ;------------------------------------------------------
0144                       ; 1b: Copy unpacked line to VDP memory
0145                       ;------------------------------------------------------
0146 72E2 0204  20         li    tmp0,fh.vrecbuf       ; VDP target address
     72E4 0960 
0147 72E6 0205  20         li    tmp1,fb.top           ; Top of frame buffer in CPU memory
     72E8 A600 
0148               
0149 72EA C1A0  34         mov   @outparm1,tmp2        ; Length of line
     72EC 2F30 
0150 72EE C806  38         mov   tmp2,@fh.reclen       ; Set record length
     72F0 A43E 
0151 72F2 1302  14         jeq   !                     ; Skip VDP copy if empty line
0152               
0153 72F4 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     72F6 245C 
0154                                                   ; \ i  tmp0 = VDP target address
0155                                                   ; | i  tmp1 = CPU source address
0156                                                   ; / i  tmp2 = Number of bytes to copy
0157                       ;------------------------------------------------------
0158                       ; 1c: Write file record
0159                       ;------------------------------------------------------
0160 72F8 06A0  32 !       bl    @file.record.write    ; Write file record
     72FA 2C98 
0161 72FC 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0162                                                   ; |           (without +9 offset!)
0163                                                   ; | o  tmp0 = Status byte
0164                                                   ; | o  tmp1 = ?????
0165                                                   ; | o  tmp2 = Status register contents
0166                                                   ; /           upon DSRLNK return
0167               
0168 72FE C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     7300 A438 
0169 7302 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     7304 A43A 
0170                       ;------------------------------------------------------
0171                       ; 1d: Calculate kilobytes processed
0172                       ;------------------------------------------------------
0173 7306 A820  54         a     @fh.reclen,@fh.counter
     7308 A43E 
     730A A442 
0174                                                   ; Add record length to counter
0175 730C C160  34         mov   @fh.counter,tmp1      ;
     730E A442 
0176 7310 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     7312 0400 
0177 7314 1106  14         jlt   fh.file.write.edb.check_fioerr
0178                                                   ; Not yet, goto (1e)
0179 7316 05A0  34         inc   @fh.kilobytes
     7318 A440 
0180 731A 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     731C FC00 
0181 731E C805  38         mov   tmp1,@fh.counter      ; Update counter
     7320 A442 
0182                       ;------------------------------------------------------
0183                       ; 1e: Check if a file error occured
0184                       ;------------------------------------------------------
0185               fh.file.write.edb.check_fioerr:
0186 7322 C1A0  34         mov   @fh.ioresult,tmp2
     7324 A43A 
0187 7326 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7328 2026 
0188 732A 1602  14         jne   fh.file.write.edb.display
0189                                                   ; No, goto (2)
0190 732C 0460  28         b     @fh.file.write.edb.error
     732E 733C 
0191                                                   ; Yes, so handle file error
0192                       ;------------------------------------------------------
0193                       ; Step 2: Callback "Write line to  file"
0194                       ;------------------------------------------------------
0195               fh.file.write.edb.display:
0196 7330 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Saving indicator 2"
     7332 A452 
0197 7334 0694  24         bl    *tmp0                 ; Run callback function
0198                       ;------------------------------------------------------
0199                       ; Step 3: Next record
0200                       ;------------------------------------------------------
0201 7336 05A0  34         inc   @fh.records           ; Update counter
     7338 A43C 
0202 733A 10C8  14         jmp   fh.file.write.edb.record
0203                       ;------------------------------------------------------
0204                       ; Error handler
0205                       ;------------------------------------------------------
0206               fh.file.write.edb.error:
0207 733C C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     733E A438 
0208 7340 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0209                       ;------------------------------------------------------
0210                       ; File error occured
0211                       ;------------------------------------------------------
0212 7342 06A0  32         bl    @file.close           ; Close file
     7344 2C80 
0213 7346 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0214                       ;------------------------------------------------------
0215                       ; Callback "File I/O error"
0216                       ;------------------------------------------------------
0217 7348 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     734A A456 
0218 734C 0694  24         bl    *tmp0                 ; Run callback function
0219 734E 1006  14         jmp   fh.file.write.edb.exit
0220                       ;------------------------------------------------------
0221                       ; All records written. Close file
0222                       ;------------------------------------------------------
0223               fh.file.write.edb.done:
0224 7350 06A0  32         bl    @file.close           ; Close file
     7352 2C80 
0225 7354 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0226                       ;------------------------------------------------------
0227                       ; Callback "Close file"
0228                       ;------------------------------------------------------
0229 7356 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     7358 A454 
0230 735A 0694  24         bl    *tmp0                 ; Run callback function
0231               *--------------------------------------------------------------
0232               * Exit
0233               *--------------------------------------------------------------
0234               fh.file.write.edb.exit:
0235 735C 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     735E A44A 
0236 7360 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0237 7362 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0238 7364 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0239 7366 C2F9  30         mov   *stack+,r11           ; Pop R11
0240 7368 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0157                       copy  "fm.load.asm"         ; Load DV80 file into editor buffer
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
0022 736A 0649  14         dect  stack
0023 736C C64B  30         mov   r11,*stack            ; Save return address
0024 736E 0649  14         dect  stack
0025 7370 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7372 0649  14         dect  stack
0027 7374 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Show dialog "Unsaved changes" and exit if buffer dirty
0030                       ;-------------------------------------------------------
0031 7376 C160  34         mov   @edb.dirty,tmp1
     7378 A206 
0032 737A 1305  14         jeq   !
0033 737C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0034 737E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0035 7380 C2F9  30         mov   *stack+,r11           ; Pop R11
0036 7382 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7384 7E0C 
0037                       ;-------------------------------------------------------
0038                       ; Reset editor
0039                       ;-------------------------------------------------------
0040 7386 C804  38 !       mov   tmp0,@parm1           ; Setup file to load
     7388 2F20 
0041 738A 06A0  32         bl    @tv.reset             ; Reset editor
     738C 686C 
0042 738E C820  54         mov   @parm1,@edb.filename.ptr
     7390 2F20 
     7392 A20E 
0043                                                   ; Set filename
0044                       ;-------------------------------------------------------
0045                       ; Clear VDP screen buffer
0046                       ;-------------------------------------------------------
0047 7394 06A0  32         bl    @filv
     7396 229A 
0048 7398 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     739A 0000 
     739C 0004 
0049               
0050 739E C160  34         mov   @fb.scrrows,tmp1
     73A0 A118 
0051 73A2 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     73A4 A10E 
0052                                                   ; 16 bit part is in tmp2!
0053               
0054 73A6 06A0  32         bl    @scroff               ; Turn off screen
     73A8 265E 
0055               
0056 73AA 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0057 73AC 0205  20         li    tmp1,32               ; Character to fill
     73AE 0020 
0058               
0059 73B0 06A0  32         bl    @xfilv                ; Fill VDP memory
     73B2 22A0 
0060                                                   ; \ i  tmp0 = VDP target address
0061                                                   ; | i  tmp1 = Byte to fill
0062                                                   ; / i  tmp2 = Bytes to copy
0063               
0064 73B4 06A0  32         bl    @pane.action.colorscheme.Load
     73B6 78E4 
0065                                                   ; Load color scheme and turn on screen
0066                       ;-------------------------------------------------------
0067                       ; Read DV80 file and display
0068                       ;-------------------------------------------------------
0069 73B8 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     73BA 747A 
0070 73BC C804  38         mov   tmp0,@parm2           ; Register callback 1
     73BE 2F22 
0071               
0072 73C0 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     73C2 74D8 
0073 73C4 C804  38         mov   tmp0,@parm3           ; Register callback 2
     73C6 2F24 
0074               
0075 73C8 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     73CA 750E 
0076 73CC C804  38         mov   tmp0,@parm4           ; Register callback 3
     73CE 2F26 
0077               
0078 73D0 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     73D2 7540 
0079 73D4 C804  38         mov   tmp0,@parm5           ; Register callback 4
     73D6 2F28 
0080               
0081 73D8 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     73DA 6FF0 
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
0093 73DC 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     73DE A206 
0094                                                   ; longer dirty.
0095               
0096 73E0 0204  20         li    tmp0,txt.filetype.DV80
     73E2 32AC 
0097 73E4 C804  38         mov   tmp0,@edb.filetype.ptr
     73E6 A210 
0098                                                   ; Set filetype display string
0099               *--------------------------------------------------------------
0100               * Exit
0101               *--------------------------------------------------------------
0102               fm.loadfile.exit:
0103 73E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0104 73EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0105 73EC C2F9  30         mov   *stack+,r11           ; Pop R11
0106 73EE 045B  20         b     *r11                  ; Return to caller
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
0125 73F0 0649  14         dect  stack
0126 73F2 C64B  30         mov   r11,*stack            ; Save return address
0127 73F4 0649  14         dect  stack
0128 73F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0129               
0130 73F8 C120  34         mov   @fh.offsetopcode,tmp0
     73FA A44E 
0131 73FC 1307  14         jeq   !
0132                       ;------------------------------------------------------
0133                       ; Turn fast mode off
0134                       ;------------------------------------------------------
0135 73FE 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     7400 A44E 
0136 7402 0204  20         li    tmp0,txt.keys.load
     7404 331C 
0137 7406 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7408 A320 
0138 740A 1008  14         jmp   fm.fastmode.exit
0139                       ;------------------------------------------------------
0140                       ; Turn fast mode on
0141                       ;------------------------------------------------------
0142 740C 0204  20 !       li    tmp0,>40              ; Data buffer in CPU RAM
     740E 0040 
0143 7410 C804  38         mov   tmp0,@fh.offsetopcode
     7412 A44E 
0144 7414 0204  20         li    tmp0,txt.keys.load2
     7416 3354 
0145 7418 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     741A A320 
0146               *--------------------------------------------------------------
0147               * Exit
0148               *--------------------------------------------------------------
0149               fm.fastmode.exit:
0150 741C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 741E C2F9  30         mov   *stack+,r11           ; Pop R11
0152 7420 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0158                       copy  "fm.save.asm"         ; Save DV80 file from editor buffer
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
0022 7422 0649  14         dect  stack
0023 7424 C64B  30         mov   r11,*stack            ; Save return address
0024 7426 0649  14         dect  stack
0025 7428 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 742A 0649  14         dect  stack
0027 742C C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Save DV80 file
0030                       ;-------------------------------------------------------
0031 742E C804  38         mov   tmp0,@parm1           ; Set device and filename
     7430 2F20 
0032               
0033 7432 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     7434 747A 
0034 7436 C804  38         mov   tmp0,@parm2           ; Register callback 1
     7438 2F22 
0035               
0036 743A 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     743C 74D8 
0037 743E C804  38         mov   tmp0,@parm3           ; Register callback 2
     7440 2F24 
0038               
0039 7442 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     7444 750E 
0040 7446 C804  38         mov   tmp0,@parm4           ; Register callback 3
     7448 2F26 
0041               
0042 744A 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     744C 7540 
0043 744E C804  38         mov   tmp0,@parm5           ; Register callback 4
     7450 2F28 
0044               
0045 7452 C820  54         mov   @parm1,@edb.filename.ptr
     7454 2F20 
     7456 A20E 
0046                                                   ; Set current filename
0047               
0048 7458 06A0  32         bl    @filv
     745A 229A 
0049 745C 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     745E 0000 
     7460 0004 
0050               
0051 7462 06A0  32         bl    @fh.file.write.edb    ; Save file from editor buffer
     7464 7214 
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
0063 7466 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     7468 A206 
0064                                                   ; longer dirty.
0065               
0066 746A 0204  20         li    tmp0,txt.filetype.DV80
     746C 32AC 
0067 746E C804  38         mov   tmp0,@edb.filetype.ptr
     7470 A210 
0068                                                   ; Set filetype display string
0069               *--------------------------------------------------------------
0070               * Exit
0071               *--------------------------------------------------------------
0072               fm.savefile.exit:
0073 7472 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0074 7474 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 7476 C2F9  30         mov   *stack+,r11           ; Pop R11
0076 7478 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0159                       copy  "fm.callbacks.asm"    ; Callbacks for file operations
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
0011 747A 0649  14         dect  stack
0012 747C C64B  30         mov   r11,*stack            ; Save return address
0013 747E 0649  14         dect  stack
0014 7480 C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;------------------------------------------------------
0016                       ; Check file operation mode
0017                       ;------------------------------------------------------
0018 7482 06A0  32         bl    @hchar
     7484 2792 
0019 7486 1D00                   byte pane.botrow,0,32,80
     7488 2050 
0020 748A FFFF                   data EOL              ; Clear until end of line
0021               
0022 748C C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     748E A44A 
0023               
0024 7490 0284  22         ci    tmp0,fh.fopmode.writefile
     7492 0002 
0025 7494 1303  14         jeq   fm.loadsave.cb.indicator1.saving
0026                                                   ; Saving file?
0027               
0028 7496 0284  22         ci    tmp0,fh.fopmode.readfile
     7498 0001 
0029 749A 1305  14         jeq   fm.loadsave.cb.indicator1.loading
0030                                                   ; Loading file?
0031                       ;------------------------------------------------------
0032                       ; Display Saving....
0033                       ;------------------------------------------------------
0034               fm.loadsave.cb.indicator1.saving:
0035 749C 06A0  32         bl    @putat
     749E 244E 
0036 74A0 1D00                   byte pane.botrow,0
0037 74A2 327E                   data txt.saving       ; Display "Saving...."
0038 74A4 1004  14         jmp   fm.loadsave.cb.indicator1.filename
0039                       ;------------------------------------------------------
0040                       ; Display Loading....
0041                       ;------------------------------------------------------
0042               fm.loadsave.cb.indicator1.loading:
0043 74A6 06A0  32         bl    @putat
     74A8 244E 
0044 74AA 1D00                   byte pane.botrow,0
0045 74AC 3272                   data txt.loading      ; Display "Loading...."
0046                       ;------------------------------------------------------
0047                       ; Display device/filename
0048                       ;------------------------------------------------------
0049               fm.loadsave.cb.indicator1.filename:
0050 74AE 06A0  32         bl    @at
     74B0 269E 
0051 74B2 1D0B                   byte pane.botrow,11   ; Cursor YX position
0052 74B4 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     74B6 2F20 
0053 74B8 06A0  32         bl    @xutst0               ; Display device/filename
     74BA 242C 
0054                       ;------------------------------------------------------
0055                       ; Display separators
0056                       ;------------------------------------------------------
0057 74BC 06A0  32         bl    @putat
     74BE 244E 
0058 74C0 1D47                   byte pane.botrow,71
0059 74C2 32BC                   data txt.vertline     ; Vertical line
0060                       ;------------------------------------------------------
0061                       ; Display fast mode
0062                       ;------------------------------------------------------
0063 74C4 0760  38         abs   @fh.offsetopcode
     74C6 A44E 
0064 74C8 1304  14         jeq   fm.loadsave.cb.indicator1.exit
0065               
0066 74CA 06A0  32         bl    @putat
     74CC 244E 
0067 74CE 1D26                   byte pane.botrow,38
0068 74D0 3288                   data txt.fastmode     ; Display "FastMode"
0069                       ;------------------------------------------------------
0070                       ; Exit
0071                       ;------------------------------------------------------
0072               fm.loadsave.cb.indicator1.exit:
0073 74D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 74D4 C2F9  30         mov   *stack+,r11           ; Pop R11
0075 74D6 045B  20         b     *r11                  ; Return to caller
0076               
0077               
0078               
0079               
0080               *---------------------------------------------------------------
0081               * Callback function "Show loading indicator 2"
0082               * Read line from file / Write line to file
0083               *---------------------------------------------------------------
0084               * Registered as pointer in @fh.callback2
0085               *---------------------------------------------------------------
0086               fm.loadsave.cb.indicator2:
0087                       ;------------------------------------------------------
0088                       ; Check if updated counters should be displayed
0089                       ;------------------------------------------------------
0090 74D8 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     74DA A440 
     74DC A458 
0091 74DE 1316  14         jeq   !
0092                       ;------------------------------------------------------
0093                       ; Display updated counters
0094                       ;------------------------------------------------------
0095 74E0 0649  14         dect  stack
0096 74E2 C64B  30         mov   r11,*stack            ; Save return address
0097               
0098 74E4 C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     74E6 A440 
     74E8 A458 
0099                                                   ; Save for compare
0100               
0101 74EA 06A0  32         bl    @putnum
     74EC 2A22 
0102 74EE 1D32                   byte pane.botrow,50   ; Show kilobytes processed
0103 74F0 A440                   data fh.kilobytes,rambuf,>3020
     74F2 2F64 
     74F4 3020 
0104               
0105 74F6 06A0  32         bl    @putat
     74F8 244E 
0106 74FA 1D37                   byte pane.botrow,55
0107 74FC 3292                   data txt.kb           ; Show "kb" string
0108               
0109 74FE 06A0  32         bl    @putnum
     7500 2A22 
0110 7502 1D49                   byte pane.botrow,73   ; Show lines processed
0111 7504 A43C                   data fh.records,rambuf,>3020
     7506 2F64 
     7508 3020 
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               fm.loadsave.cb.indicator2.exit:
0116 750A C2F9  30         mov   *stack+,r11           ; Pop R11
0117 750C 045B  20 !       b     *r11                  ; Return to caller
0118               
0119               
0120               
0121               
0122               *---------------------------------------------------------------
0123               * Callback function "Show loading indicator 3"
0124               * Close file
0125               *---------------------------------------------------------------
0126               * Registered as pointer in @fh.callback3
0127               *---------------------------------------------------------------
0128               fm.loadsave.cb.indicator3:
0129 750E 0649  14         dect  stack
0130 7510 C64B  30         mov   r11,*stack            ; Save return address
0131               
0132 7512 06A0  32         bl    @hchar
     7514 2792 
0133 7516 1D03                   byte pane.botrow,3,32,50
     7518 2032 
0134 751A FFFF                   data EOL              ; Erase loading indicator
0135               
0136 751C 06A0  32         bl    @putnum
     751E 2A22 
0137 7520 1D32                   byte pane.botrow,50   ; Show kilobytes processed
0138 7522 A440                   data fh.kilobytes,rambuf,>3020
     7524 2F64 
     7526 3020 
0139               
0140 7528 06A0  32         bl    @putat
     752A 244E 
0141 752C 1D37                   byte pane.botrow,55
0142 752E 3292                   data txt.kb           ; Show "kb" string
0143               
0144 7530 06A0  32         bl    @putnum
     7532 2A22 
0145 7534 1D49                   byte pane.botrow,73   ; Show lines processed
0146 7536 A43C                   data fh.records,rambuf,>3020
     7538 2F64 
     753A 3020 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               fm.loadsave.cb.indicator3.exit:
0151 753C C2F9  30         mov   *stack+,r11           ; Pop R11
0152 753E 045B  20         b     *r11                  ; Return to caller
0153               
0154               
0155               
0156               *---------------------------------------------------------------
0157               * Callback function "File I/O error handler"
0158               * I/O error
0159               *---------------------------------------------------------------
0160               * Registered as pointer in @fh.callback4
0161               *---------------------------------------------------------------
0162               fm.loadsave.cb.fioerr:
0163 7540 0649  14         dect  stack
0164 7542 C64B  30         mov   r11,*stack            ; Save return address
0165 7544 0649  14         dect  stack
0166 7546 C644  30         mov   tmp0,*stack           ; Push tmp0
0167                       ;------------------------------------------------------
0168                       ; Build I/O error message
0169                       ;------------------------------------------------------
0170 7548 06A0  32         bl    @hchar
     754A 2792 
0171 754C 1D00                   byte pane.botrow,0,32,50
     754E 2032 
0172 7550 FFFF                   data EOL              ; Erase loading indicator
0173               
0174 7552 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     7554 A44A 
0175 7556 0284  22         ci    tmp0,fh.fopmode.writefile
     7558 0002 
0176 755A 1306  14         jeq   fm.loadsave.cb.fioerr.mgs2
0177                       ;------------------------------------------------------
0178                       ; Failed loading file
0179                       ;------------------------------------------------------
0180               fm.loadsave.cb.fioerr.mgs1:
0181 755C 06A0  32         bl    @cpym2m
     755E 24AA 
0182 7560 3509                   data txt.ioerr.load+1
0183 7562 A021                   data tv.error.msg+1
0184 7564 0022                   data 34               ; Error message
0185 7566 1005  14         jmp   fm.loadsave.cb.fioerr.mgs3
0186                       ;------------------------------------------------------
0187                       ; Failed saving file
0188                       ;------------------------------------------------------
0189               fm.loadsave.cb.fioerr.mgs2:
0190 7568 06A0  32         bl    @cpym2m
     756A 24AA 
0191 756C 352B                   data txt.ioerr.save+1
0192 756E A021                   data tv.error.msg+1
0193 7570 0022                   data 34               ; Error message
0194                       ;------------------------------------------------------
0195                       ; Add filename to error message
0196                       ;------------------------------------------------------
0197               fm.loadsave.cb.fioerr.mgs3:
0198 7572 C120  34         mov   @edb.filename.ptr,tmp0
     7574 A20E 
0199 7576 D194  26         movb  *tmp0,tmp2            ; Get length byte
0200 7578 0986  56         srl   tmp2,8                ; Right align
0201 757A 0584  14         inc   tmp0                  ; Skip length byte
0202 757C 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     757E A041 
0203               
0204 7580 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     7582 24B0 
0205                                                   ; | i  tmp0 = ROM/RAM source
0206                                                   ; | i  tmp1 = RAM destination
0207                                                   ; / i  tmp2 = Bytes to copy
0208                       ;------------------------------------------------------
0209                       ; Reset filename to "new file"
0210                       ;------------------------------------------------------
0211 7584 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     7586 A44A 
0212               
0213 7588 0284  22         ci    tmp0,fh.fopmode.readfile
     758A 0001 
0214 758C 1608  14         jne   !                     ; Only when reading file
0215               
0216 758E 0204  20         li    tmp0,txt.newfile      ; New file
     7590 32A0 
0217 7592 C804  38         mov   tmp0,@edb.filename.ptr
     7594 A20E 
0218               
0219 7596 0204  20         li    tmp0,txt.filetype.none
     7598 32B2 
0220 759A C804  38         mov   tmp0,@edb.filetype.ptr
     759C A210 
0221                                                   ; Empty filetype string
0222                       ;------------------------------------------------------
0223                       ; Display I/O error message
0224                       ;------------------------------------------------------
0225 759E 06A0  32 !       bl    @pane.errline.show    ; Show error line
     75A0 7B22 
0226                       ;------------------------------------------------------
0227                       ; Exit
0228                       ;------------------------------------------------------
0229               fm.loadsave.cb.fioerr.exit:
0230 75A2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0231 75A4 C2F9  30         mov   *stack+,r11           ; Pop R11
0232 75A6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0160                       copy  "fm.browse.asm"       ; File manager browse support routines
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
0018 75A8 0649  14         dect  stack
0019 75AA C64B  30         mov   r11,*stack            ; Save return address
0020 75AC 0649  14         dect  stack
0021 75AE C644  30         mov   tmp0,*stack           ; Push tmp0
0022 75B0 0649  14         dect  stack
0023 75B2 C645  30         mov   tmp1,*stack           ; Push tmp1
0024                       ;------------------------------------------------------
0025                       ; Sanity check
0026                       ;------------------------------------------------------
0027 75B4 C120  34         mov   @parm1,tmp0           ; Get pointer to filename
     75B6 2F20 
0028 75B8 1334  14         jeq   fm.browse.fname.suffix.exit
0029                                                   ; Exit early if pointer is nill
0030               
0031 75BA 0284  22         ci    tmp0,txt.newfile
     75BC 32A0 
0032 75BE 1331  14         jeq   fm.browse.fname.suffix.exit
0033                                                   ; Exit early if "New file"
0034                       ;------------------------------------------------------
0035                       ; Get last character in filename
0036                       ;------------------------------------------------------
0037 75C0 D154  26         movb  *tmp0,tmp1            ; Get length of current filename
0038 75C2 0985  56         srl   tmp1,8                ; MSB to LSB
0039               
0040 75C4 A105  18         a     tmp1,tmp0             ; Move to last character
0041 75C6 04C5  14         clr   tmp1
0042 75C8 D154  26         movb  *tmp0,tmp1            ; Get character
0043 75CA 0985  56         srl   tmp1,8                ; MSB to LSB
0044 75CC 132A  14         jeq   fm.browse.fname.suffix.exit
0045                                                   ; Exit early if empty filename
0046                       ;------------------------------------------------------
0047                       ; Check mode (increase/decrease) character ASCII value
0048                       ;------------------------------------------------------
0049 75CE C1A0  34         mov   @parm2,tmp2           ; Get mode
     75D0 2F22 
0050 75D2 1314  14         jeq   fm.browse.fname.suffix.dec
0051                                                   ; Decrease ASCII if mode = 0
0052                       ;------------------------------------------------------
0053                       ; Increase ASCII value last character in filename
0054                       ;------------------------------------------------------
0055               fm.browse.fname.suffix.inc:
0056 75D4 0285  22         ci    tmp1,48               ; ASCI  48 (char 0) ?
     75D6 0030 
0057 75D8 1108  14         jlt   fm.browse.fname.suffix.inc.crash
0058 75DA 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     75DC 0039 
0059 75DE 1109  14         jlt   !                     ; Next character
0060 75E0 130A  14         jeq   fm.browse.fname.suffix.inc.alpha
0061                                                   ; Swith to alpha range A..Z
0062 75E2 0285  22         ci    tmp1,90               ; ASCII 132 (char Z) ?
     75E4 005A 
0063 75E6 131D  14         jeq   fm.browse.fname.suffix.exit
0064                                                   ; Already last alpha character, so exit
0065 75E8 1104  14         jlt   !                     ; Next character
0066                       ;------------------------------------------------------
0067                       ; Invalid character, crash and burn
0068                       ;------------------------------------------------------
0069               fm.browse.fname.suffix.inc.crash:
0070 75EA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     75EC FFCE 
0071 75EE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     75F0 2030 
0072                       ;------------------------------------------------------
0073                       ; Increase ASCII value last character in filename
0074                       ;------------------------------------------------------
0075 75F2 0585  14 !       inc   tmp1                  ; Increase ASCII value
0076 75F4 1014  14         jmp   fm.browse.fname.suffix.store
0077               fm.browse.fname.suffix.inc.alpha:
0078 75F6 0205  20         li    tmp1,65               ; Set ASCII 65 (char A)
     75F8 0041 
0079 75FA 1011  14         jmp   fm.browse.fname.suffix.store
0080                       ;------------------------------------------------------
0081                       ; Decrease ASCII value last character in filename
0082                       ;------------------------------------------------------
0083               fm.browse.fname.suffix.dec:
0084 75FC 0285  22         ci    tmp1,48               ; ASCII 48 (char 0) ?
     75FE 0030 
0085 7600 1310  14         jeq   fm.browse.fname.suffix.exit
0086                                                   ; Already first numeric character, so exit
0087 7602 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     7604 0039 
0088 7606 1207  14         jle   !                     ; Previous character
0089 7608 0285  22         ci    tmp1,65               ; ASCII 65 (char A) ?
     760A 0041 
0090 760C 1306  14         jeq   fm.browse.fname.suffix.dec.numeric
0091                                                   ; Switch to numeric range 0..9
0092 760E 11ED  14         jlt   fm.browse.fname.suffix.inc.crash
0093                                                   ; Invalid character
0094 7610 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     7612 0084 
0095 7614 1306  14         jeq   fm.browse.fname.suffix.exit
0096 7616 0605  14 !       dec   tmp1                  ; Decrease ASCII value
0097 7618 1002  14         jmp   fm.browse.fname.suffix.store
0098               fm.browse.fname.suffix.dec.numeric:
0099 761A 0205  20         li    tmp1,57               ; Set ASCII 57 (char 9)
     761C 0039 
0100                       ;------------------------------------------------------
0101                       ; Store updatec character
0102                       ;------------------------------------------------------
0103               fm.browse.fname.suffix.store:
0104 761E 0A85  56         sla   tmp1,8                ; LSB to MSB
0105 7620 D505  30         movb  tmp1,*tmp0            ; Store updated character
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               fm.browse.fname.suffix.exit:
0110 7622 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0111 7624 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0112 7626 C2F9  30         mov   *stack+,r11           ; Pop R11
0113 7628 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0161                       ;-----------------------------------------------------------------------
0162                       ; User hook, background tasks
0163                       ;-----------------------------------------------------------------------
0164                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
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
0012 762A 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     762C 2014 
0013 762E 1612  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015 7630 C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     7632 833C 
     7634 2F40 
0016               *---------------------------------------------------------------
0017               * Identical key pressed ?
0018               *---------------------------------------------------------------
0019 7636 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     7638 2014 
0020 763A 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     763C 2F40 
     763E 2F42 
0021 7640 130D  14         jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
0022               *--------------------------------------------------------------
0023               * New key pressed
0024               *--------------------------------------------------------------
0025 7642 0204  20         li    tmp0,2000             ; \
     7644 07D0 
0026 7646 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0027 7648 16FE  14         jne   -!                    ; /
0028 764A C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     764C 2F40 
     764E 2F42 
0029 7650 0460  28         b     @edkey.key.process    ; Process key
     7652 60E4 
0030               *--------------------------------------------------------------
0031               * Clear keyboard buffer if no key pressed
0032               *--------------------------------------------------------------
0033               hook.keyscan.clear_kbbuffer:
0034 7654 04E0  34         clr   @keycode1
     7656 2F40 
0035 7658 04E0  34         clr   @keycode2
     765A 2F42 
0036               *--------------------------------------------------------------
0037               * Delay to avoid key bouncing
0038               *--------------------------------------------------------------
0039               hook.keyscan.bounce:
0040 765C 0204  20         li    tmp0,2000             ; Avoid key bouncing
     765E 07D0 
0041                       ;------------------------------------------------------
0042                       ; Delay loop
0043                       ;------------------------------------------------------
0044               hook.keyscan.bounce.loop:
0045 7660 0604  14         dec   tmp0
0046 7662 16FE  14         jne   hook.keyscan.bounce.loop
0047 7664 0460  28         b     @hookok               ; Return
     7666 2D18 
0048               
**** **** ****     > stevie_b1.asm.1638280
0165                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
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
0012 7668 C820  54         mov   @wyx,@fb.yxsave       ; Backup cursor
     766A 832A 
     766C A114 
0013                       ;------------------------------------------------------
0014                       ; ALPHA-Lock key down?
0015                       ;------------------------------------------------------
0016               task.vdp.panes.alpha_lock:
0017 766E 20A0  38         coc   @wbit10,config
     7670 2016 
0018 7672 1305  14         jeq   task.vdp.panes.alpha_lock.down
0019                       ;------------------------------------------------------
0020                       ; AlPHA-Lock is up
0021                       ;------------------------------------------------------
0022 7674 06A0  32         bl    @putat
     7676 244E 
0023 7678 1D4F                   byte   pane.botrow,79
0024 767A 32B8                   data   txt.alpha.up
0025 767C 1004  14         jmp   task.vdp.panes.cmdb.check
0026                       ;------------------------------------------------------
0027                       ; AlPHA-Lock is down
0028                       ;------------------------------------------------------
0029               task.vdp.panes.alpha_lock.down:
0030 767E 06A0  32         bl    @putat
     7680 244E 
0031 7682 1D4F                   byte   pane.botrow,79
0032 7684 32BA                   data   txt.alpha.down
0033                       ;------------------------------------------------------
0034                       ; Command buffer visible ?
0035                       ;------------------------------------------------------
0036               task.vdp.panes.cmdb.check
0037 7686 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor
     7688 A114 
     768A 832A 
0038 768C C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     768E A302 
0039 7690 1309  14         jeq   !                     ; No, skip CMDB pane
0040 7692 1000  14         jmp   task.vdp.panes.cmdb.draw
0041                       ;-------------------------------------------------------
0042                       ; Draw command buffer pane if dirty
0043                       ;-------------------------------------------------------
0044               task.vdp.panes.cmdb.draw:
0045 7694 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     7696 A318 
0046 7698 1344  14         jeq   task.vdp.panes.exit   ; No, skip update
0047               
0048 769A 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     769C 79C8 
0049 769E 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     76A0 A318 
0050 76A2 103F  14         jmp   task.vdp.panes.exit   ; Exit early
0051                       ;-------------------------------------------------------
0052                       ; Check if frame buffer dirty
0053                       ;-------------------------------------------------------
0054 76A4 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     76A6 A116 
0055 76A8 133A  14         jeq   task.vdp.panes.botline.draw
0056                                                   ; No, skip update
0057 76AA C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     76AC 832A 
     76AE A114 
0058                       ;------------------------------------------------------
0059                       ; Determine how many rows to copy
0060                       ;------------------------------------------------------
0061 76B0 8820  54         c     @edb.lines,@fb.scrrows
     76B2 A204 
     76B4 A118 
0062 76B6 1103  14         jlt   task.vdp.panes.setrows.small
0063 76B8 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     76BA A118 
0064 76BC 1003  14         jmp   task.vdp.panes.copy.framebuffer
0065                       ;------------------------------------------------------
0066                       ; Less lines in editor buffer as rows in frame buffer
0067                       ;------------------------------------------------------
0068               task.vdp.panes.setrows.small:
0069 76BE C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     76C0 A204 
0070 76C2 0585  14         inc   tmp1
0071                       ;------------------------------------------------------
0072                       ; Determine area to copy
0073                       ;------------------------------------------------------
0074               task.vdp.panes.copy.framebuffer:
0075 76C4 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     76C6 A10E 
0076                                                   ; 16 bit part is in tmp2!
0077 76C8 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0078 76CA C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     76CC A100 
0079                       ;------------------------------------------------------
0080                       ; Copy memory block
0081                       ;------------------------------------------------------
0082 76CE 06A0  32         bl    @xpym2v               ; Copy to VDP
     76D0 245C 
0083                                                   ; \ i  tmp0 = VDP target address
0084                                                   ; | i  tmp1 = RAM source address
0085                                                   ; / i  tmp2 = Bytes to copy
0086 76D2 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     76D4 A116 
0087                       ;-------------------------------------------------------
0088                       ; Draw EOF marker at end-of-file
0089                       ;-------------------------------------------------------
0090 76D6 C120  34         mov   @edb.lines,tmp0
     76D8 A204 
0091 76DA 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     76DC A104 
0092 76DE 0584  14         inc   tmp0                  ; Y = Y + 1
0093 76E0 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     76E2 A118 
0094 76E4 121C  14         jle   task.vdp.panes.botline.draw
0095                                                   ; Skip drawing EOF maker
0096                       ;-------------------------------------------------------
0097                       ; Do actual drawing of EOF marker
0098                       ;-------------------------------------------------------
0099               task.vdp.panes.draw_marker:
0100 76E6 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0101 76E8 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     76EA 832A 
0102               
0103 76EC 06A0  32         bl    @putstr
     76EE 242A 
0104 76F0 325C                   data txt.marker       ; Display *EOF*
0105               
0106 76F2 06A0  32         bl    @setx
     76F4 26B4 
0107 76F6 0005                   data  5               ; Cursor after *EOF* string
0108                       ;-------------------------------------------------------
0109                       ; Clear rest of screen
0110                       ;-------------------------------------------------------
0111               task.vdp.panes.clear_screen:
0112 76F8 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     76FA A10E 
0113               
0114 76FC C160  34         mov   @wyx,tmp1             ;
     76FE 832A 
0115 7700 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0116 7702 0505  16         neg   tmp1                  ; tmp1 = -Y position
0117 7704 A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     7706 A118 
0118               
0119 7708 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0120 770A 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     770C FFFB 
0121               
0122 770E 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7710 2406 
0123                                                   ; \ i  @wyx = Cursor position
0124                                                   ; / o  tmp0 = VDP address
0125               
0126 7712 04C5  14         clr   tmp1                  ; Character to write (null!)
0127 7714 06A0  32         bl    @xfilv                ; Fill VDP memory
     7716 22A0 
0128                                                   ; \ i  tmp0 = VDP destination
0129                                                   ; | i  tmp1 = byte to write
0130                                                   ; / i  tmp2 = Number of bytes to write
0131               
0132 7718 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     771A A114 
     771C 832A 
0133                       ;-------------------------------------------------------
0134                       ; Draw status line
0135                       ;-------------------------------------------------------
0136               task.vdp.panes.botline.draw:
0137 771E 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     7720 7B78 
0138                       ;------------------------------------------------------
0139                       ; Exit task
0140                       ;------------------------------------------------------
0141               task.vdp.panes.exit:
0142 7722 0460  28         b     @slotok
     7724 2D94 
**** **** ****     > stevie_b1.asm.1638280
0166                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
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
0012 7726 C120  34         mov   @tv.pane.focus,tmp0
     7728 A01A 
0013 772A 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 772C 0284  22         ci    tmp0,pane.focus.cmdb
     772E 0001 
0016 7730 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 7732 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7734 FFCE 
0022 7736 06A0  32         bl    @cpu.crash            ; / Halt system.
     7738 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 773A C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     773C A30A 
     773E 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 7740 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     7742 202A 
0032 7744 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7746 26C0 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 7748 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     774A 2F54 
0036               
0037 774C 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     774E 2456 
0038 7750 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     7752 2F54 
     7754 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 7756 0460  28         b     @slotok               ; Exit task
     7758 2D94 
**** **** ****     > stevie_b1.asm.1638280
0167                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
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
0012 775A 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     775C A112 
0013 775E 1303  14         jeq   task.vdp.cursor.visible
0014 7760 04E0  34         clr   @ramsat+2              ; Hide cursor
     7762 2F56 
0015 7764 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 7766 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7768 A20A 
0019 776A 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 776C C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     776E A01A 
0025 7770 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 7772 0284  22         ci    tmp0,pane.focus.cmdb
     7774 0001 
0028 7776 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 7778 04C4  14         clr   tmp0                   ; Cursor FB insert mode
0034 777A 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 777C 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     777E 0100 
0040 7780 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 7782 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     7784 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 7786 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     7788 A014 
0051 778A C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     778C A014 
     778E 2F56 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 7790 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     7792 2456 
0057 7794 2180                   data sprsat,ramsat,4   ; \ i  p0 = VDP destination
     7796 2F54 
     7798 0004 
0058                                                    ; | i  p1 = ROM/RAM source
0059                                                    ; / i  p2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 779A C120  34         mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
     779C A302 
0064 779E 1602  14         jne   task.vdp.cursor.exit   ; Exit, if visible
0065 77A0 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     77A2 7B78 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               task.vdp.cursor.exit:
0070 77A4 0460  28         b     @slotok                ; Exit task
     77A6 2D94 
**** **** ****     > stevie_b1.asm.1638280
0168                       copy  "task.oneshot.asm"    ; Task - One shot
**** **** ****     > task.oneshot.asm
0001               task.oneshot:
0002 77A8 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     77AA A01C 
0003 77AC 1301  14         jeq   task.oneshot.exit
0004               
0005 77AE 0694  24         bl    *tmp0                  ; Execute one-shot task
0006                       ;------------------------------------------------------
0007                       ; Exit
0008                       ;------------------------------------------------------
0009               task.oneshot.exit:
0010 77B0 0460  28         b     @slotok                ; Exit task
     77B2 2D94 
**** **** ****     > stevie_b1.asm.1638280
0169                       ;-----------------------------------------------------------------------
0170                       ; Screen pane utilities
0171                       ;-----------------------------------------------------------------------
0172                       copy  "pane.utils.asm"      ; Pane utility functions
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
0026 77B4 0649  14         dect  stack
0027 77B6 C64B  30         mov   r11,*stack            ; Save return address
0028 77B8 0649  14         dect  stack
0029 77BA C644  30         mov   tmp0,*stack           ; Push tmp0
0030 77BC 0649  14         dect  stack
0031 77BE C645  30         mov   tmp1,*stack           ; Push tmp1
0032 77C0 0649  14         dect  stack
0033 77C2 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 77C4 0649  14         dect  stack
0035 77C6 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;-------------------------------------------------------
0037                       ; Display string
0038                       ;-------------------------------------------------------
0039 77C8 C820  54         mov   @parm1,@wyx           ; Set cursor
     77CA 2F20 
     77CC 832A 
0040 77CE C160  34         mov   @parm2,tmp1           ; Get string to display
     77D0 2F22 
0041 77D2 06A0  32         bl    @xutst0               ; Display string
     77D4 242C 
0042                       ;-------------------------------------------------------
0043                       ; Get number of bytes to fill ...
0044                       ;-------------------------------------------------------
0045 77D6 C120  34         mov   @parm2,tmp0
     77D8 2F22 
0046 77DA D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0047 77DC 0984  56         srl   tmp0,8                ; Right justify
0048 77DE C184  18         mov   tmp0,tmp2
0049 77E0 C1C4  18         mov   tmp0,tmp3             ; Work copy
0050 77E2 0506  16         neg   tmp2
0051 77E4 0226  22         ai    tmp2,80               ; Number of bytes to fill
     77E6 0050 
0052                       ;-------------------------------------------------------
0053                       ; ... and clear until end of line
0054                       ;-------------------------------------------------------
0055 77E8 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     77EA 2F20 
0056 77EC A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0057 77EE C804  38         mov   tmp0,@wyx             ; / Set cursor
     77F0 832A 
0058               
0059 77F2 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     77F4 2406 
0060                                                   ; \ i  @wyx = Cursor position
0061                                                   ; / o  tmp0 = VDP target address
0062               
0063 77F6 0205  20         li    tmp1,32               ; Byte to fill
     77F8 0020 
0064               
0065 77FA 06A0  32         bl    @xfilv                ; Clear line
     77FC 22A0 
0066                                                   ; i \  tmp0 = start address
0067                                                   ; i |  tmp1 = byte to fill
0068                                                   ; i /  tmp2 = number of bytes to fill
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               pane.show_hintx.exit:
0073 77FE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0074 7800 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0075 7802 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0076 7804 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0077 7806 C2F9  30         mov   *stack+,r11           ; Pop R11
0078 7808 045B  20         b     *r11                  ; Return to caller
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
0100 780A C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     780C 2F20 
0101 780E C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     7810 2F22 
0102 7812 0649  14         dect  stack
0103 7814 C64B  30         mov   r11,*stack            ; Save return address
0104                       ;-------------------------------------------------------
0105                       ; Display pane hint
0106                       ;-------------------------------------------------------
0107 7816 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7818 77B4 
0108                       ;-------------------------------------------------------
0109                       ; Exit
0110                       ;-------------------------------------------------------
0111               pane.show_hint.exit:
0112 781A C2F9  30         mov   *stack+,r11           ; Pop R11
0113 781C 045B  20         b     *r11                  ; Return to caller
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
0133 781E 0649  14         dect  stack
0134 7820 C64B  30         mov   r11,*stack            ; Save return address
0135                       ;-------------------------------------------------------
0136                       ; Hide cursor
0137                       ;-------------------------------------------------------
0138 7822 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     7824 229A 
0139 7826 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7828 0000 
     782A 0004 
0140                                                   ; | i  p1 = Byte to write
0141                                                   ; / i  p2 = Number of bytes to write
0142               
0143 782C 06A0  32         bl    @clslot
     782E 2DF0 
0144 7830 0001                   data 1                ; Terminate task.vdp.copy.sat
0145               
0146 7832 06A0  32         bl    @clslot
     7834 2DF0 
0147 7836 0002                   data 2                ; Terminate task.vdp.copy.sat
0148               
0149                       ;-------------------------------------------------------
0150                       ; Exit
0151                       ;-------------------------------------------------------
0152               pane.cursor.hide.exit:
0153 7838 C2F9  30         mov   *stack+,r11           ; Pop R11
0154 783A 045B  20         b     *r11                  ; Return to caller
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
0174 783C 0649  14         dect  stack
0175 783E C64B  30         mov   r11,*stack            ; Save return address
0176                       ;-------------------------------------------------------
0177                       ; Hide cursor
0178                       ;-------------------------------------------------------
0179 7840 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     7842 229A 
0180 7844 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7846 0000 
     7848 0004 
0181                                                   ; | i  p1 = Byte to write
0182                                                   ; / i  p2 = Number of bytes to write
0183               
0184 784A 06A0  32         bl    @mkslot
     784C 2DD2 
0185 784E 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     7850 7726 
0186 7852 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     7854 775A 
0187 7856 FFFF                   data eol
0188                       ;-------------------------------------------------------
0189                       ; Exit
0190                       ;-------------------------------------------------------
0191               pane.cursor.blink.exit:
0192 7858 C2F9  30         mov   *stack+,r11           ; Pop R11
0193 785A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0173                       copy  "pane.utils.colorscheme.asm"
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
0021 785C 0649  14         dect  stack
0022 785E C64B  30         mov   r11,*stack            ; Push return address
0023 7860 0649  14         dect  stack
0024 7862 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 7864 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7866 A012 
0027 7868 0284  22         ci    tmp0,tv.colorscheme.entries - 1
     786A 0008 
0028                                                   ; Last entry reached?
0029 786C 1102  14         jlt   !
0030 786E 04C4  14         clr   tmp0
0031 7870 1001  14         jmp   pane.action.colorscheme.switch
0032 7872 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 7874 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7876 A012 
0038 7878 06A0  32         bl    @pane.action.colorscheme.load
     787A 78E4 
0039                       ;-------------------------------------------------------
0040                       ; Show current color scheme message
0041                       ;-------------------------------------------------------
0042 787C C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     787E 832A 
     7880 833C 
0043               
0044 7882 06A0  32         bl    @filv
     7884 229A 
0045 7886 1840                   data >1840,>1F,16     ; VDP start address (frame buffer area)
     7888 001F 
     788A 0010 
0046               
0047 788C 06A0  32         bl    @putnum
     788E 2A22 
0048 7890 004B                   byte 0,75
0049 7892 A012                   data tv.colorscheme,rambuf,>3020
     7894 2F64 
     7896 3020 
0050               
0051 7898 06A0  32         bl    @putat
     789A 244E 
0052 789C 0040                   byte 0,64
0053 789E 358E                   data txt.colorscheme  ; Show color scheme message
0054               
0055               
0056 78A0 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     78A2 833C 
     78A4 832A 
0057                       ;-------------------------------------------------------
0058                       ; Delay
0059                       ;-------------------------------------------------------
0060 78A6 0204  20         li    tmp0,12000
     78A8 2EE0 
0061 78AA 0604  14 !       dec   tmp0
0062 78AC 16FE  14         jne   -!
0063                       ;-------------------------------------------------------
0064                       ; Setup one shot task for removing message
0065                       ;-------------------------------------------------------
0066 78AE 0204  20         li    tmp0,pane.action.colorscheme.task.callback
     78B0 78C2 
0067 78B2 C804  38         mov   tmp0,@tv.task.oneshot
     78B4 A01C 
0068               
0069 78B6 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     78B8 2DFE 
0070 78BA 0003                   data 3                ; / for getting consistent delay
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               pane.action.colorscheme.cycle.exit:
0075 78BC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 78BE C2F9  30         mov   *stack+,r11           ; Pop R11
0077 78C0 045B  20         b     *r11                  ; Return to caller
0078                       ;-------------------------------------------------------
0079                       ; Remove colorscheme message (triggered by oneshot task)
0080                       ;-------------------------------------------------------
0081               pane.action.colorscheme.task.callback:
0082 78C2 0649  14         dect  stack
0083 78C4 C64B  30         mov   r11,*stack            ; Push return address
0084               
0085 78C6 06A0  32         bl    @filv
     78C8 229A 
0086 78CA 003C                   data >003C,>00,20     ; Remove message
     78CC 0000 
     78CE 0014 
0087               
0088 78D0 0720  34         seto  @parm1
     78D2 2F20 
0089 78D4 06A0  32         bl    @pane.action.colorscheme.load
     78D6 78E4 
0090                                                   ; Reload current colorscheme
0091                                                   ; \ i  parm1 = Do not turn screen off
0092                                                   ; /
0093               
0094 78D8 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     78DA A116 
0095 78DC 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     78DE A01C 
0096               
0097 78E0 C2F9  30         mov   *stack+,r11           ; Pop R11
0098 78E2 045B  20         b     *r11                  ; Return to task
0099               
0100               
0101               
0102               ***************************************************************
0103               * pane.action.colorscheme.load
0104               * Load color scheme
0105               ***************************************************************
0106               * bl  @pane.action.colorscheme.load
0107               *--------------------------------------------------------------
0108               * INPUT
0109               * @tv.colorscheme = Index into color scheme table
0110               * @parm1          = Skip screen off if >FFFF
0111               *--------------------------------------------------------------
0112               * OUTPUT
0113               * none
0114               *--------------------------------------------------------------
0115               * Register usage
0116               * tmp0,tmp1,tmp2,tmp3,tmp4
0117               ********|*****|*********************|**************************
0118               pane.action.colorscheme.load:
0119 78E4 0649  14         dect  stack
0120 78E6 C64B  30         mov   r11,*stack            ; Save return address
0121 78E8 0649  14         dect  stack
0122 78EA C644  30         mov   tmp0,*stack           ; Push tmp0
0123 78EC 0649  14         dect  stack
0124 78EE C645  30         mov   tmp1,*stack           ; Push tmp1
0125 78F0 0649  14         dect  stack
0126 78F2 C646  30         mov   tmp2,*stack           ; Push tmp2
0127 78F4 0649  14         dect  stack
0128 78F6 C647  30         mov   tmp3,*stack           ; Push tmp3
0129 78F8 0649  14         dect  stack
0130 78FA C648  30         mov   tmp4,*stack           ; Push tmp4
0131                       ;-------------------------------------------------------
0132                       ; Turn screen of
0133                       ;-------------------------------------------------------
0134 78FC C120  34         mov   @parm1,tmp0
     78FE 2F20 
0135 7900 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     7902 FFFF 
0136 7904 1302  14         jeq   !                     ; Yes, so skip screen off
0137 7906 06A0  32         bl    @scroff               ; Turn screen off
     7908 265E 
0138                       ;-------------------------------------------------------
0139                       ; Get framebuffer foreground/background color
0140                       ;-------------------------------------------------------
0141 790A C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     790C A012 
0142 790E 0A24  56         sla   tmp0,2                ; Offset into color scheme data table
0143 7910 0224  22         ai    tmp0,tv.colorscheme.table
     7912 30BE 
0144                                                   ; Add base for color scheme data table
0145 7914 C1F4  30         mov   *tmp0+,tmp3           ; Get colors  (fb + status line)
0146 7916 C807  38         mov   tmp3,@tv.color        ; Save colors
     7918 A018 
0147                       ;-------------------------------------------------------
0148                       ; Get and save cursor color
0149                       ;-------------------------------------------------------
0150 791A C214  26         mov   *tmp0,tmp4            ; Get cursor color
0151 791C 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     791E 00FF 
0152 7920 C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     7922 A016 
0153                       ;-------------------------------------------------------
0154                       ; Get CMDB pane foreground/background color
0155                       ;-------------------------------------------------------
0156 7924 C214  26         mov   *tmp0,tmp4            ; Get CMDB pane
0157 7926 0248  22         andi  tmp4,>ff00            ; Only keep MSB
     7928 FF00 
0158 792A 0988  56         srl   tmp4,8                ; MSB to LSB
0159                       ;-------------------------------------------------------
0160                       ; Dump colors to VDP register 7 (text mode)
0161                       ;-------------------------------------------------------
0162 792C C147  18         mov   tmp3,tmp1             ; Get work copy
0163 792E 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0164 7930 0265  22         ori   tmp1,>0700
     7932 0700 
0165 7934 C105  18         mov   tmp1,tmp0
0166 7936 06A0  32         bl    @putvrx               ; Write VDP register
     7938 2340 
0167                       ;-------------------------------------------------------
0168                       ; Dump colors for frame buffer pane (TAT)
0169                       ;-------------------------------------------------------
0170 793A 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     793C 1800 
0171 793E C147  18         mov   tmp3,tmp1             ; Get work copy of colors
0172 7940 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0173 7942 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     7944 0910 
0174 7946 06A0  32         bl    @xfilv                ; Fill colors
     7948 22A0 
0175                                                   ; i \  tmp0 = start address
0176                                                   ; i |  tmp1 = byte to fill
0177                                                   ; i /  tmp2 = number of bytes to fill
0178                       ;-------------------------------------------------------
0179                       ; Dump colors for CMDB pane (TAT)
0180                       ;-------------------------------------------------------
0181               pane.action.colorscheme.cmdbpane:
0182 794A C120  34         mov   @cmdb.visible,tmp0
     794C A302 
0183 794E 1307  14         jeq   pane.action.colorscheme.errpane
0184                                                   ; Skip if CMDB pane is hidden
0185               
0186 7950 0204  20         li    tmp0,>1fd0            ; VDP start address (bottom status line)
     7952 1FD0 
0187 7954 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0188 7956 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     7958 0190 
0189 795A 06A0  32         bl    @xfilv                ; Fill colors
     795C 22A0 
0190                                                   ; i \  tmp0 = start address
0191                                                   ; i |  tmp1 = byte to fill
0192                                                   ; i /  tmp2 = number of bytes to fill
0193                       ;-------------------------------------------------------
0194                       ; Dump colors for error line pane (TAT)
0195                       ;-------------------------------------------------------
0196               pane.action.colorscheme.errpane:
0197 795E C120  34         mov   @tv.error.visible,tmp0
     7960 A01E 
0198 7962 1304  14         jeq   pane.action.colorscheme.statusline
0199                                                   ; Skip if error line pane is hidden
0200               
0201 7964 0205  20         li    tmp1,>00f6            ; White on dark red
     7966 00F6 
0202 7968 06A0  32         bl    @pane.action.colorscheme.errline
     796A 799E 
0203                                                   ; Load color combination for error line
0204                       ;-------------------------------------------------------
0205                       ; Dump colors for bottom status line pane (TAT)
0206                       ;-------------------------------------------------------
0207               pane.action.colorscheme.statusline:
0208 796C 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     796E 2110 
0209 7970 C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0210 7972 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7974 00FF 
0211 7976 0206  20         li    tmp2,80               ; Number of bytes to fill
     7978 0050 
0212 797A 06A0  32         bl    @xfilv                ; Fill colors
     797C 22A0 
0213                                                   ; i \  tmp0 = start address
0214                                                   ; i |  tmp1 = byte to fill
0215                                                   ; i /  tmp2 = number of bytes to fill
0216                       ;-------------------------------------------------------
0217                       ; Dump cursor FG color to sprite table (SAT)
0218                       ;-------------------------------------------------------
0219               pane.action.colorscheme.cursorcolor:
0220 797E C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     7980 A016 
0221 7982 0A88  56         sla   tmp4,8                ; Move to MSB
0222 7984 D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7986 2F57 
0223 7988 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     798A A015 
0224                       ;-------------------------------------------------------
0225                       ; Exit
0226                       ;-------------------------------------------------------
0227               pane.action.colorscheme.load.exit:
0228 798C 06A0  32         bl    @scron                ; Turn screen on
     798E 2666 
0229 7990 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0230 7992 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0231 7994 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0232 7996 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0233 7998 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0234 799A C2F9  30         mov   *stack+,r11           ; Pop R11
0235 799C 045B  20         b     *r11                  ; Return to caller
0236               
0237               
0238               
0239               ***************************************************************
0240               * pane.action.colorscheme.errline
0241               * Load color scheme for error line
0242               ***************************************************************
0243               * bl  @pane.action.colorscheme.errline
0244               *--------------------------------------------------------------
0245               * INPUT
0246               * @parm1 = Foreground / Background color
0247               *--------------------------------------------------------------
0248               * OUTPUT
0249               * none
0250               *--------------------------------------------------------------
0251               * Register usage
0252               * tmp0,tmp1,tmp2
0253               ********|*****|*********************|**************************
0254               pane.action.colorscheme.errline:
0255 799E 0649  14         dect  stack
0256 79A0 C64B  30         mov   r11,*stack            ; Save return address
0257 79A2 0649  14         dect  stack
0258 79A4 C644  30         mov   tmp0,*stack           ; Push tmp0
0259 79A6 0649  14         dect  stack
0260 79A8 C645  30         mov   tmp1,*stack           ; Push tmp1
0261 79AA 0649  14         dect  stack
0262 79AC C646  30         mov   tmp2,*stack           ; Push tmp2
0263                       ;-------------------------------------------------------
0264                       ; Load error line colors
0265                       ;-------------------------------------------------------
0266 79AE C160  34         mov   @parm1,tmp1           ; Get FG/BG color
     79B0 2F20 
0267               
0268 79B2 0204  20         li    tmp0,>20C0            ; VDP start address (error line)
     79B4 20C0 
0269 79B6 0206  20         li    tmp2,80               ; Number of bytes to fill
     79B8 0050 
0270 79BA 06A0  32         bl    @xfilv                ; Fill colors
     79BC 22A0 
0271                                                   ; i \  tmp0 = start address
0272                                                   ; i |  tmp1 = byte to fill
0273                                                   ; i /  tmp2 = number of bytes to fill
0274                       ;-------------------------------------------------------
0275                       ; Exit
0276                       ;-------------------------------------------------------
0277               pane.action.colorscheme.errline.exit:
0278 79BE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0279 79C0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0280 79C2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0281 79C4 C2F9  30         mov   *stack+,r11           ; Pop R11
0282 79C6 045B  20         b     *r11                  ; Return to caller
0283               
**** **** ****     > stevie_b1.asm.1638280
0174                                                   ; Colorscheme handling in panes
0175                       ;-----------------------------------------------------------------------
0176                       ; Screen panes
0177                       ;-----------------------------------------------------------------------
0178                       copy  "pane.cmdb.asm"       ; Command buffer
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
0021 79C8 0649  14         dect  stack
0022 79CA C64B  30         mov   r11,*stack            ; Save return address
0023 79CC 0649  14         dect  stack
0024 79CE C644  30         mov   tmp0,*stack           ; Push tmp0
0025 79D0 0649  14         dect  stack
0026 79D2 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 79D4 0649  14         dect  stack
0028 79D6 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Command buffer header line
0031                       ;------------------------------------------------------
0032 79D8 06A0  32         bl    @hchar
     79DA 2792 
0033 79DC 190F                   byte pane.botrow-4,15,1,65
     79DE 0141 
0034 79E0 FFFF                   data eol
0035               
0036 79E2 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     79E4 A30E 
     79E6 832A 
0037 79E8 C160  34         mov   @cmdb.panhead,tmp1    ; | Display pane header
     79EA A31C 
0038 79EC 06A0  32         bl    @xutst0               ; /
     79EE 242C 
0039               
0040                       ;------------------------------------------------------
0041                       ; Check dialog id
0042                       ;------------------------------------------------------
0043 79F0 04E0  34         clr   @waux1                ; Default is show prompt
     79F2 833C 
0044               
0045 79F4 C120  34         mov   @cmdb.dialog,tmp0
     79F6 A31A 
0046 79F8 0284  22         ci    tmp0,100              ; \ Hide prompt and no keyboard
     79FA 0064 
0047 79FC 120C  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 100
0048 79FE 0720  34         seto  @waux1                ; /
     7A00 833C 
0049                       ;------------------------------------------------------
0050                       ; Show warning message if in "Unsaved changes" dialog
0051                       ;------------------------------------------------------
0052 7A02 0284  22         ci    tmp0,id.dialog.unsaved
     7A04 0065 
0053 7A06 1607  14         jne   pane.cmdb.draw.clear  ; Display normal prompt
0054               
0055 7A08 06A0  32         bl    @putat                ; \ Show warning message
     7A0A 244E 
0056 7A0C 1A00                   byte pane.botrow-3,0  ; |
0057 7A0E 3482                   data txt.warn.unsaved ; /
0058               
0059 7A10 C820  54         mov   @txt.warn.unsaved,@cmdb.cmdlen
     7A12 3482 
     7A14 A324 
0060                       ;------------------------------------------------------
0061                       ; Clear lines after prompt in command buffer
0062                       ;------------------------------------------------------
0063               pane.cmdb.draw.clear:
0064 7A16 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7A18 A324 
0065 7A1A 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0066 7A1C A120  34         a     @cmdb.yxprompt,tmp0   ; |
     7A1E A310 
0067 7A20 C804  38         mov   tmp0,@wyx             ; /
     7A22 832A 
0068               
0069 7A24 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7A26 2406 
0070                                                   ; \ i  @wyx = Cursor position
0071                                                   ; / o  tmp0 = VDP target address
0072               
0073 7A28 0205  20         li    tmp1,32
     7A2A 0020 
0074               
0075 7A2C C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     7A2E A324 
0076 7A30 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0077 7A32 0506  16         neg   tmp2                  ; | Based on command & prompt length
0078 7A34 0226  22         ai    tmp2,2*80 - 1         ; /
     7A36 009F 
0079               
0080 7A38 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     7A3A 22A0 
0081                                                   ; | i  tmp0 = VDP target address
0082                                                   ; | i  tmp1 = Byte to fill
0083                                                   ; / i  tmp2 = Number of bytes to fill
0084                       ;------------------------------------------------------
0085                       ; Display pane hint in command buffer
0086                       ;------------------------------------------------------
0087               pane.cmdb.draw.hint:
0088 7A3C 0204  20         li    tmp0,pane.botrow - 1  ; \
     7A3E 001C 
0089 7A40 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0090 7A42 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A44 2F20 
0091 7A46 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7A48 A31E 
     7A4A 2F22 
0092               
0093 7A4C 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A4E 77B4 
0094                                                   ; \ i  parm1 = Pointer to string with hint
0095                                                   ; / i  parm2 = YX position
0096                       ;------------------------------------------------------
0097                       ; Display keys in status line
0098                       ;------------------------------------------------------
0099 7A50 0204  20         li    tmp0,pane.botrow      ; \
     7A52 001D 
0100 7A54 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0101 7A56 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A58 2F20 
0102 7A5A C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7A5C A320 
     7A5E 2F22 
0103               
0104 7A60 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A62 77B4 
0105                                                   ; \ i  parm1 = Pointer to string with hint
0106                                                   ; / i  parm2 = YX position
0107                       ;------------------------------------------------------
0108                       ; ALPHA-Lock key down?
0109                       ;------------------------------------------------------
0110 7A64 20A0  38         coc   @wbit10,config
     7A66 2016 
0111 7A68 1305  14         jeq   pane.cmdb.draw.alpha.down
0112                       ;------------------------------------------------------
0113                       ; AlPHA-Lock is up
0114                       ;------------------------------------------------------
0115 7A6A 06A0  32         bl    @putat
     7A6C 244E 
0116 7A6E 1D4F                   byte   pane.botrow,79
0117 7A70 32B8                   data   txt.alpha.up
0118               
0119 7A72 1004  14         jmp   pane.cmdb.draw.promptcmd
0120                       ;------------------------------------------------------
0121                       ; AlPHA-Lock is down
0122                       ;------------------------------------------------------
0123               pane.cmdb.draw.alpha.down:
0124 7A74 06A0  32         bl    @putat
     7A76 244E 
0125 7A78 1D4F                   byte   pane.botrow,79
0126 7A7A 32BA                   data   txt.alpha.down
0127                       ;------------------------------------------------------
0128                       ; Command buffer content
0129                       ;------------------------------------------------------
0130               pane.cmdb.draw.promptcmd:
0131 7A7C C120  34         mov   @waux1,tmp0           ; Flag set?
     7A7E 833C 
0132 7A80 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0133 7A82 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7A84 6F1A 
0134                       ;------------------------------------------------------
0135                       ; Exit
0136                       ;------------------------------------------------------
0137               pane.cmdb.draw.exit:
0138 7A86 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0139 7A88 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0140 7A8A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0141 7A8C C2F9  30         mov   *stack+,r11           ; Pop r11
0142 7A8E 045B  20         b     *r11                  ; Return
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
0163 7A90 0649  14         dect  stack
0164 7A92 C64B  30         mov   r11,*stack            ; Save return address
0165 7A94 0649  14         dect  stack
0166 7A96 C644  30         mov   tmp0,*stack           ; Push tmp0
0167                       ;------------------------------------------------------
0168                       ; Show command buffer pane
0169                       ;------------------------------------------------------
0170 7A98 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7A9A 832A 
     7A9C A304 
0171                                                   ; Save YX position in frame buffer
0172               
0173 7A9E C120  34         mov   @fb.scrrows.max,tmp0
     7AA0 A11A 
0174 7AA2 6120  34         s     @cmdb.scrrows,tmp0
     7AA4 A306 
0175 7AA6 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7AA8 A118 
0176               
0177 7AAA 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0178 7AAC C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7AAE A30E 
0179               
0180 7AB0 0224  22         ai    tmp0,>0100
     7AB2 0100 
0181 7AB4 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7AB6 A310 
0182 7AB8 0584  14         inc   tmp0
0183 7ABA C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7ABC A30A 
0184               
0185 7ABE 0720  34         seto  @cmdb.visible         ; Show pane
     7AC0 A302 
0186 7AC2 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     7AC4 A318 
0187               
0188 7AC6 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7AC8 0001 
0189 7ACA C804  38         mov   tmp0,@tv.pane.focus   ; /
     7ACC A01A 
0190               
0191 7ACE 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     7AD0 7B58 
0192               
0193 7AD2 0720  34         seto  @parm1                ; Do not turn screen off while
     7AD4 2F20 
0194                                                   ; reloading color scheme
0195               
0196 7AD6 06A0  32         bl    @pane.action.colorscheme.load
     7AD8 78E4 
0197                                                   ; Reload color scheme
0198                                                   ; i  parm1 = Skip screen off if >FFFF
0199               
0200               pane.cmdb.show.exit:
0201                       ;------------------------------------------------------
0202                       ; Exit
0203                       ;------------------------------------------------------
0204 7ADA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0205 7ADC C2F9  30         mov   *stack+,r11           ; Pop r11
0206 7ADE 045B  20         b     *r11                  ; Return to caller
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
0229 7AE0 0649  14         dect  stack
0230 7AE2 C64B  30         mov   r11,*stack            ; Save return address
0231                       ;------------------------------------------------------
0232                       ; Hide command buffer pane
0233                       ;------------------------------------------------------
0234 7AE4 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7AE6 A11A 
     7AE8 A118 
0235                       ;------------------------------------------------------
0236                       ; Adjust frame buffer size if error pane visible
0237                       ;------------------------------------------------------
0238 7AEA C820  54         mov   @tv.error.visible,@tv.error.visible
     7AEC A01E 
     7AEE A01E 
0239 7AF0 1302  14         jeq   !
0240 7AF2 0620  34         dec   @fb.scrrows
     7AF4 A118 
0241                       ;------------------------------------------------------
0242                       ; Clear error/hint & status line
0243                       ;------------------------------------------------------
0244 7AF6 06A0  32 !       bl    @hchar
     7AF8 2792 
0245 7AFA 1C00                   byte pane.botrow-1,0,32,80*2
     7AFC 20A0 
0246 7AFE FFFF                   data EOL
0247                       ;------------------------------------------------------
0248                       ; Hide command buffer pane (rest)
0249                       ;------------------------------------------------------
0250 7B00 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     7B02 A304 
     7B04 832A 
0251 7B06 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7B08 A302 
0252 7B0A 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7B0C A116 
0253 7B0E 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     7B10 A01A 
0254                       ;------------------------------------------------------
0255                       ; Reload current color scheme
0256                       ;------------------------------------------------------
0257 7B12 0720  34         seto  @parm1                ; Do not turn screen off while
     7B14 2F20 
0258                                                   ; reloading color scheme
0259               
0260 7B16 06A0  32         bl    @pane.action.colorscheme.load
     7B18 78E4 
0261                                                   ; Reload color scheme
0262                                                   ; i  parm1 = Skip screen off if >FFFF
0263                       ;------------------------------------------------------
0264                       ; Show cursor again
0265                       ;------------------------------------------------------
0266 7B1A 06A0  32         bl    @pane.cursor.blink
     7B1C 783C 
0267                       ;------------------------------------------------------
0268                       ; Exit
0269                       ;------------------------------------------------------
0270               pane.cmdb.hide.exit:
0271 7B1E C2F9  30         mov   *stack+,r11           ; Pop r11
0272 7B20 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0179                       copy  "pane.errline.asm"    ; Error line
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
0026 7B22 0649  14         dect  stack
0027 7B24 C64B  30         mov   r11,*stack            ; Save return address
0028 7B26 0649  14         dect  stack
0029 7B28 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 7B2A 0649  14         dect  stack
0031 7B2C C645  30         mov   tmp1,*stack           ; Push tmp1
0032               
0033 7B2E 0205  20         li    tmp1,>00f6            ; White on dark red
     7B30 00F6 
0034 7B32 C805  38         mov   tmp1,@parm1
     7B34 2F20 
0035               
0036 7B36 06A0  32         bl    @pane.action.colorscheme.errline
     7B38 799E 
0037                                                   ; \ Set colors for error line
0038                                                   ; / i  parm1 = FG/BG color
0039               
0040                       ;------------------------------------------------------
0041                       ; Show error line content
0042                       ;------------------------------------------------------
0043 7B3A 06A0  32         bl    @putat                ; Display error message
     7B3C 244E 
0044 7B3E 1C00                   byte pane.botrow-1,0
0045 7B40 A020                   data tv.error.msg
0046               
0047 7B42 C120  34         mov   @fb.scrrows.max,tmp0
     7B44 A11A 
0048 7B46 0604  14         dec   tmp0
0049 7B48 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7B4A A118 
0050               
0051 7B4C 0720  34         seto  @tv.error.visible     ; Error line is visible
     7B4E A01E 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               pane.errline.show.exit:
0056 7B50 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7B52 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7B54 C2F9  30         mov   *stack+,r11           ; Pop r11
0059 7B56 045B  20         b     *r11                  ; Return to caller
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
0081 7B58 0649  14         dect  stack
0082 7B5A C64B  30         mov   r11,*stack            ; Save return address
0083 7B5C 0649  14         dect  stack
0084 7B5E C644  30         mov   tmp0,*stack           ; Push tmp0
0085                       ;------------------------------------------------------
0086                       ; Hide command buffer pane
0087                       ;------------------------------------------------------
0088 7B60 06A0  32 !       bl    @errline.init         ; Clear error line
     7B62 6FCC 
0089               
0090 7B64 C120  34         mov   @tv.color,tmp0        ; Get colors
     7B66 A018 
0091 7B68 0984  56         srl   tmp0,8                ; Right aligns
0092 7B6A C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7B6C 2F20 
0093               
0094 7B6E 06A0  32         bl    @pane.action.colorscheme.errline
     7B70 799E 
0095                                                   ; \ Set colors for error line
0096                                                   ; / i  parm1 LSB = FG/BG color
0097                       ;------------------------------------------------------
0098                       ; Exit
0099                       ;------------------------------------------------------
0100               pane.errline.hide.exit:
0101 7B72 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 7B74 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7B76 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1638280
0180                       copy  "pane.botline.asm"    ; Status line
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
0021 7B78 0649  14         dect  stack
0022 7B7A C64B  30         mov   r11,*stack            ; Save return address
0023 7B7C 0649  14         dect  stack
0024 7B7E C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 7B80 C820  54         mov   @wyx,@fb.yxsave
     7B82 832A 
     7B84 A114 
0027                       ;------------------------------------------------------
0028                       ; Show separators
0029                       ;------------------------------------------------------
0030 7B86 06A0  32         bl    @hchar
     7B88 2792 
0031 7B8A 1D2A                   byte pane.botrow,42,14,1       ; Vertical line 1
     7B8C 0E01 
0032 7B8E 1D32                   byte pane.botrow,50,14,1       ; Vertical line 2
     7B90 0E01 
0033 7B92 1D47                   byte pane.botrow,71,14,1       ; Vertical line 3
     7B94 0E01 
0034 7B96 FFFF                   data eol
0035                       ;------------------------------------------------------
0036                       ; Show buffer number
0037                       ;------------------------------------------------------
0038               pane.botline.bufnum:
0039 7B98 06A0  32         bl    @putat
     7B9A 244E 
0040 7B9C 1D00                   byte  pane.botrow,0
0041 7B9E 329C                   data  txt.bufnum
0042                       ;------------------------------------------------------
0043                       ; Show current file
0044                       ;------------------------------------------------------
0045               pane.botline.show_file:
0046 7BA0 06A0  32         bl    @at
     7BA2 269E 
0047 7BA4 1D03                   byte  pane.botrow,3   ; Position cursor
0048 7BA6 C160  34         mov   @edb.filename.ptr,tmp1
     7BA8 A20E 
0049                                                   ; Get string to display
0050 7BAA 06A0  32         bl    @xutst0               ; Display string
     7BAC 242C 
0051                       ;------------------------------------------------------
0052                       ; Show text editing mode
0053                       ;------------------------------------------------------
0054               pane.botline.show_mode:
0055 7BAE C120  34         mov   @edb.insmode,tmp0
     7BB0 A20A 
0056 7BB2 1605  14         jne   pane.botline.show_mode.insert
0057                       ;------------------------------------------------------
0058                       ; Overwrite mode
0059                       ;------------------------------------------------------
0060               pane.botline.show_mode.overwrite:
0061 7BB4 06A0  32         bl    @putat
     7BB6 244E 
0062 7BB8 1D2C                   byte  pane.botrow,44
0063 7BBA 3268                   data  txt.ovrwrite
0064 7BBC 1004  14         jmp   pane.botline.show_changed
0065                       ;------------------------------------------------------
0066                       ; Insert  mode
0067                       ;------------------------------------------------------
0068               pane.botline.show_mode.insert:
0069 7BBE 06A0  32         bl    @putat
     7BC0 244E 
0070 7BC2 1D2C                   byte  pane.botrow,44
0071 7BC4 326C                   data  txt.insert
0072                       ;------------------------------------------------------
0073                       ; Show if text was changed in editor buffer
0074                       ;------------------------------------------------------
0075               pane.botline.show_changed:
0076 7BC6 C120  34         mov   @edb.dirty,tmp0
     7BC8 A206 
0077 7BCA 1305  14         jeq   pane.botline.show_linecol
0078                       ;------------------------------------------------------
0079                       ; Show "*"
0080                       ;------------------------------------------------------
0081 7BCC 06A0  32         bl    @putat
     7BCE 244E 
0082 7BD0 1D30                   byte pane.botrow,48
0083 7BD2 3270                   data txt.star
0084 7BD4 1000  14         jmp   pane.botline.show_linecol
0085                       ;------------------------------------------------------
0086                       ; Show "line,column"
0087                       ;------------------------------------------------------
0088               pane.botline.show_linecol:
0089 7BD6 C820  54         mov   @fb.row,@parm1
     7BD8 A106 
     7BDA 2F20 
0090 7BDC 06A0  32         bl    @fb.row2line
     7BDE 692C 
0091 7BE0 05A0  34         inc   @outparm1
     7BE2 2F30 
0092                       ;------------------------------------------------------
0093                       ; Show line
0094                       ;------------------------------------------------------
0095 7BE4 06A0  32         bl    @putnum
     7BE6 2A22 
0096 7BE8 1D3B                   byte  pane.botrow,59  ; YX
0097 7BEA 2F30                   data  outparm1,rambuf
     7BEC 2F64 
0098 7BEE 3020                   byte  48              ; ASCII offset
0099                             byte  32              ; Padding character
0100                       ;------------------------------------------------------
0101                       ; Show comma
0102                       ;------------------------------------------------------
0103 7BF0 06A0  32         bl    @putat
     7BF2 244E 
0104 7BF4 1D40                   byte  pane.botrow,64
0105 7BF6 3259                   data  txt.delim
0106                       ;------------------------------------------------------
0107                       ; Show column
0108                       ;------------------------------------------------------
0109 7BF8 06A0  32         bl    @film
     7BFA 2242 
0110 7BFC 2F69                   data rambuf+5,32,12   ; Clear work buffer with space character
     7BFE 0020 
     7C00 000C 
0111               
0112 7C02 C820  54         mov   @fb.column,@waux1
     7C04 A10C 
     7C06 833C 
0113 7C08 05A0  34         inc   @waux1                ; Offset 1
     7C0A 833C 
0114               
0115 7C0C 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7C0E 29A4 
0116 7C10 833C                   data  waux1,rambuf
     7C12 2F64 
0117 7C14 3020                   byte  48              ; ASCII offset
0118                             byte  32              ; Fill character
0119               
0120 7C16 06A0  32         bl    @trimnum              ; Trim number to the left
     7C18 29FC 
0121 7C1A 2F64                   data  rambuf,rambuf+5,32
     7C1C 2F69 
     7C1E 0020 
0122               
0123 7C20 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7C22 0600 
0124 7C24 D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7C26 2F69 
0125               
0126                       ;------------------------------------------------------
0127                       ; Decide if row length is to be shown
0128                       ;------------------------------------------------------
0129 7C28 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7C2A A10C 
0130 7C2C 0584  14         inc   tmp0                  ; /
0131 7C2E 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7C30 A108 
0132 7C32 1101  14         jlt   pane.botline.show_linecol.linelen
0133 7C34 1024  14         jmp   pane.botline.show_linecol.colstring
0134                                                   ; Yes, skip showing row length
0135                       ;------------------------------------------------------
0136                       ; Add '/' delimiter and length of line to string
0137                       ;------------------------------------------------------
0138               pane.botline.show_linecol.linelen:
0139 7C36 C120  34         mov   @fb.column,tmp0       ; \
     7C38 A10C 
0140 7C3A 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7C3C 2F6B 
0141 7C3E 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7C40 0009 
0142 7C42 1101  14         jlt   !                     ; | column.
0143 7C44 0585  14         inc   tmp1                  ; /
0144               
0145 7C46 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7C48 2D00 
0146 7C4A DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0147               
0148 7C4C C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7C4E 833C 
0149               
0150 7C50 06A0  32         bl    @mknum
     7C52 29A4 
0151 7C54 A108                   data  fb.row.length,rambuf
     7C56 2F64 
0152 7C58 3020                   byte  48              ; ASCII offset
0153                             byte  32              ; Padding character
0154               
0155 7C5A C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7C5C 833C 
0156               
0157 7C5E C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7C60 A108 
0158 7C62 0284  22         ci    tmp0,10               ; /
     7C64 000A 
0159 7C66 1104  14         jlt   pane.botline.show_line.1digit
0160                       ;------------------------------------------------------
0161                       ; Show length of line (2 digits)
0162                       ;------------------------------------------------------
0163               pane.botline.show_line.2digits:
0164 7C68 0204  20         li    tmp0,rambuf+3
     7C6A 2F67 
0165 7C6C DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0166 7C6E 1002  14         jmp   pane.botline.show_line.rest
0167                       ;------------------------------------------------------
0168                       ; Show length of line (1 digits)
0169                       ;------------------------------------------------------
0170               pane.botline.show_line.1digit:
0171 7C70 0204  20         li    tmp0,rambuf+4
     7C72 2F68 
0172               pane.botline.show_line.rest:
0173 7C74 DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0174 7C76 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7C78 2F64 
0175 7C7A DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7C7C 2F64 
0176                       ;------------------------------------------------------
0177                       ; Show column string
0178                       ;------------------------------------------------------
0179               pane.botline.show_linecol.colstring:
0180 7C7E 06A0  32         bl    @putat
     7C80 244E 
0181 7C82 1D41                   byte pane.botrow,65
0182 7C84 2F69                   data rambuf+5         ; Show string
0183                       ;------------------------------------------------------
0184                       ; Show lines in buffer unless on last line in file
0185                       ;------------------------------------------------------
0186 7C86 C820  54         mov   @fb.row,@parm1
     7C88 A106 
     7C8A 2F20 
0187 7C8C 06A0  32         bl    @fb.row2line
     7C8E 692C 
0188 7C90 8820  54         c     @edb.lines,@outparm1
     7C92 A204 
     7C94 2F30 
0189 7C96 1605  14         jne   pane.botline.show_lines_in_buffer
0190               
0191 7C98 06A0  32         bl    @putat
     7C9A 244E 
0192 7C9C 1D49                   byte pane.botrow,73
0193 7C9E 3262                   data txt.bottom
0194               
0195 7CA0 100B  14         jmp   pane.botline.exit
0196                       ;------------------------------------------------------
0197                       ; Show lines in buffer
0198                       ;------------------------------------------------------
0199               pane.botline.show_lines_in_buffer:
0200 7CA2 C820  54         mov   @edb.lines,@waux1
     7CA4 A204 
     7CA6 833C 
0201 7CA8 05A0  34         inc   @waux1                ; Offset 1
     7CAA 833C 
0202               
0203 7CAC 06A0  32         bl    @putnum
     7CAE 2A22 
0204 7CB0 1D49                   byte pane.botrow,73   ; YX
0205 7CB2 833C                   data waux1,rambuf
     7CB4 2F64 
0206 7CB6 3020                   byte 48
0207                             byte 32
0208                       ;------------------------------------------------------
0209                       ; Exit
0210                       ;------------------------------------------------------
0211               pane.botline.exit:
0212 7CB8 C820  54         mov   @fb.yxsave,@wyx
     7CBA A114 
     7CBC 832A 
0213 7CBE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0214 7CC0 C2F9  30         mov   *stack+,r11           ; Pop r11
0215 7CC2 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1638280
0181                       ;-----------------------------------------------------------------------
0182                       ; Dialogs
0183                       ;-----------------------------------------------------------------------
0184                       copy  "dialog.about.asm"    ; Dialog "About"
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
0015 7CC4 0204  20         li    tmp0,id.dialog.about
     7CC6 0066 
0016 7CC8 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7CCA A31A 
0017               
0018 7CCC 06A0  32         bl    @dialog.about.content ; display content in modal dialog
     7CCE 7CEC 
0019               
0020 7CD0 0204  20         li    tmp0,txt.head.about
     7CD2 34B6 
0021 7CD4 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7CD6 A31C 
0022               
0023 7CD8 0204  20         li    tmp0,txt.hint.about
     7CDA 34C4 
0024 7CDC C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7CDE A31E 
0025               
0026 7CE0 0204  20         li    tmp0,txt.keys.about
     7CE2 34F2 
0027 7CE4 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7CE6 A320 
0028               
0029 7CE8 0460  28         b     @edkey.action.cmdb.show
     7CEA 67A8 
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
0049 7CEC 0649  14         dect  stack
0050 7CEE C64B  30         mov   r11,*stack            ; Save return address
0051 7CF0 0649  14         dect  stack
0052 7CF2 C644  30         mov   tmp0,*stack           ; Push tmp0
0053 7CF4 0649  14         dect  stack
0054 7CF6 C645  30         mov   tmp1,*stack           ; Push tmp1
0055 7CF8 0649  14         dect  stack
0056 7CFA C646  30         mov   tmp2,*stack           ; Push tmp2
0057               
0058 7CFC C820  54         mov   @wyx,@fb.yxsave       ; Save cursor
     7CFE 832A 
     7D00 A114 
0059                       ;-------------------------------------------------------
0060                       ; Clear VDP screen buffer
0061                       ;-------------------------------------------------------
0062 7D02 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D04 781E 
0063               
0064 7D06 C160  34         mov   @fb.scrrows,tmp1
     7D08 A118 
0065 7D0A 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7D0C A10E 
0066                                                   ; 16 bit part is in tmp2!
0067               
0068 7D0E 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0069 7D10 0205  20         li    tmp1,32               ; Character to fill
     7D12 0020 
0070               
0071 7D14 06A0  32         bl    @xfilv                ; Fill VDP memory
     7D16 22A0 
0072                                                   ; \ i  tmp0 = VDP target address
0073                                                   ; | i  tmp1 = Byte to fill
0074                                                   ; / i  tmp2 = Bytes to copy
0075                       ;------------------------------------------------------
0076                       ; Show About dialog
0077                       ;------------------------------------------------------
0078 7D18 06A0  32 !       bl    @hchar
     7D1A 2792 
0079 7D1C 0214                   byte 2,20,3,40
     7D1E 0328 
0080 7D20 0C14                   byte 12,20,3,40
     7D22 0328 
0081 7D24 FFFF                   data EOL
0082               
0083 7D26 06A0  32         bl    @putat
     7D28 244E 
0084 7D2A 0421                   byte   4,33
0085 7D2C 30E2                   data   txt.about.program
0086 7D2E 06A0  32         bl    @putat
     7D30 244E 
0087 7D32 0616                   byte   6,22
0088 7D34 30F0                   data   txt.about.purpose
0089 7D36 06A0  32         bl    @putat
     7D38 244E 
0090 7D3A 0719                   byte   7,25
0091 7D3C 3114                   data   txt.about.author
0092 7D3E 06A0  32         bl    @putat
     7D40 244E 
0093 7D42 091A                   byte   9,26
0094 7D44 3132                   data   txt.about.website
0095 7D46 06A0  32         bl    @putat
     7D48 244E 
0096 7D4A 0A1E                   byte   10,30
0097 7D4C 314E                   data   txt.about.build
0098               
0099 7D4E 06A0  32         bl    @putat
     7D50 244E 
0100 7D52 0E03                   byte   14,3
0101 7D54 3164                   data   txt.about.msg1
0102 7D56 06A0  32         bl    @putat
     7D58 244E 
0103 7D5A 0F03                   byte   15,3
0104 7D5C 318A                   data   txt.about.msg2
0105 7D5E 06A0  32         bl    @putat
     7D60 244E 
0106 7D62 1003                   byte   16,3
0107 7D64 31AE                   data   txt.about.msg3
0108 7D66 06A0  32         bl    @putat
     7D68 244E 
0109 7D6A 0E32                   byte   14,50
0110 7D6C 31C8                   data   txt.about.msg4
0111 7D6E 06A0  32         bl    @putat
     7D70 244E 
0112 7D72 0F32                   byte   15,50
0113 7D74 31E6                   data   txt.about.msg5
0114 7D76 06A0  32         bl    @putat
     7D78 244E 
0115 7D7A 1032                   byte   16,50
0116 7D7C 3204                   data   txt.about.msg6
0117               
0118 7D7E 06A0  32         bl    @putat
     7D80 244E 
0119 7D82 120A                   byte   18,10
0120 7D84 3220                   data   txt.about.msg7
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               _dialog.about.content.exit:
0125 7D86 C820  54         mov   @fb.yxsave,@wyx
     7D88 A114 
     7D8A 832A 
0126 7D8C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0127 7D8E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0128 7D90 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0129 7D92 C2F9  30         mov   *stack+,r11           ; Pop r11
0130 7D94 045B  20         b     *r11                  ; Return
0131               
**** **** ****     > stevie_b1.asm.1638280
0185                       copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
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
0030 7D96 C120  34         mov   @edb.dirty,tmp0
     7D98 A206 
0031 7D9A 1302  14         jeq   dialog.load.setup
0032 7D9C 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7D9E 7E0C 
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036               dialog.load.setup:
0037 7DA0 0204  20         li    tmp0,id.dialog.load
     7DA2 000A 
0038 7DA4 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7DA6 A31A 
0039               
0040 7DA8 0204  20         li    tmp0,txt.head.load
     7DAA 32BE 
0041 7DAC C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7DAE A31C 
0042               
0043 7DB0 0204  20         li    tmp0,txt.hint.load
     7DB2 32CE 
0044 7DB4 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7DB6 A31E 
0045               
0046 7DB8 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     7DBA A44E 
0047 7DBC 1303  14         jeq   !
0048                       ;-------------------------------------------------------
0049                       ; Show that FastMode is on
0050                       ;-------------------------------------------------------
0051 7DBE 0204  20         li    tmp0,txt.keys.load2   ; Highlight FastMode
     7DC0 3354 
0052 7DC2 1002  14         jmp   dialog.load.keylist
0053                       ;-------------------------------------------------------
0054                       ; Show that FastMode is off
0055                       ;-------------------------------------------------------
0056 7DC4 0204  20 !       li    tmp0,txt.keys.load
     7DC6 331C 
0057                       ;-------------------------------------------------------
0058                       ; Show dialog
0059                       ;-------------------------------------------------------
0060               dialog.load.keylist:
0061 7DC8 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7DCA A320 
0062               
0063 7DCC 0460  28         b     @edkey.action.cmdb.show
     7DCE 67A8 
0064                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.1638280
0186                       copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
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
0030 7DD0 8820  54         c     @fb.row.dirty,@w$ffff
     7DD2 A10A 
     7DD4 202C 
0031 7DD6 1604  14         jne   !                     ; Skip crunching if clean
0032 7DD8 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7DDA 6CDC 
0033 7DDC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7DDE A10A 
0034                       ;-------------------------------------------------------
0035                       ; Setup dialog
0036                       ;-------------------------------------------------------
0037 7DE0 0204  20 !       li    tmp0,id.dialog.save
     7DE2 000B 
0038 7DE4 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7DE6 A31A 
0039               
0040 7DE8 0204  20         li    tmp0,txt.head.save
     7DEA 338C 
0041 7DEC C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7DEE A31C 
0042               
0043 7DF0 0204  20         li    tmp0,txt.hint.save
     7DF2 339C 
0044 7DF4 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7DF6 A31E 
0045               
0046 7DF8 0204  20         li    tmp0,txt.keys.save
     7DFA 33DC 
0047 7DFC C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7DFE A320 
0048               
0049 7E00 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     7E02 A44E 
0050               
0051 7E04 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     7E06 783C 
0052               
0053 7E08 0460  28         b     @edkey.action.cmdb.show
     7E0A 67A8 
0054                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.1638280
0187                       copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"
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
0027 7E0C 0204  20         li    tmp0,id.dialog.unsaved
     7E0E 0065 
0028 7E10 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7E12 A31A 
0029               
0030 7E14 0204  20         li    tmp0,txt.head.unsaved
     7E16 3406 
0031 7E18 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7E1A A31C 
0032               
0033 7E1C 0204  20         li    tmp0,txt.hint.unsaved
     7E1E 3418 
0034 7E20 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7E22 A31E 
0035               
0036 7E24 0204  20         li    tmp0,txt.keys.unsaved
     7E26 3458 
0037 7E28 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7E2A A320 
0038               
0039 7E2C 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E2E 781E 
0040               
0041 7E30 0460  28         b     @edkey.action.cmdb.show
     7E32 67A8 
0042                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.1638280
0188                       ;-----------------------------------------------------------------------
0189                       ; Program data
0190                       ;-----------------------------------------------------------------------
0191                       copy  "data.keymap.actions.asm"
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
0011 7E34 0D00             data  key.enter, pane.focus.fb, edkey.action.enter
     7E36 0000 
     7E38 65D2 
0012 7E3A 0800             data  key.fctn.s, pane.focus.fb, edkey.action.left
     7E3C 0000 
     7E3E 6172 
0013 7E40 0900             data  key.fctn.d, pane.focus.fb, edkey.action.right
     7E42 0000 
     7E44 6188 
0014 7E46 0B00             data  key.fctn.e, pane.focus.fb, edkey.action.up
     7E48 0000 
     7E4A 6288 
0015 7E4C 0A00             data  key.fctn.x, pane.focus.fb, edkey.action.down
     7E4E 0000 
     7E50 62DA 
0016 7E52 8100             data  key.ctrl.a, pane.focus.fb, edkey.action.home
     7E54 0000 
     7E56 61A0 
0017 7E58 8600             data  key.ctrl.f, pane.focus.fb, edkey.action.end
     7E5A 0000 
     7E5C 61B8 
0018 7E5E 9300             data  key.ctrl.s, pane.focus.fb, edkey.action.pword
     7E60 0000 
     7E62 61D6 
0019 7E64 8400             data  key.ctrl.d, pane.focus.fb, edkey.action.nword
     7E66 0000 
     7E68 6228 
0020 7E6A 8500             data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
     7E6C 0000 
     7E6E 6346 
0021 7E70 9800             data  key.ctrl.x, pane.focus.fb, edkey.action.npage
     7E72 0000 
     7E74 637A 
0022 7E76 9400             data  key.ctrl.t, pane.focus.fb, edkey.action.top
     7E78 0000 
     7E7A 63C6 
0023 7E7C 8200             data  key.ctrl.b, pane.focus.fb, edkey.action.bot
     7E7E 0000 
     7E80 63DC 
0024                       ;-------------------------------------------------------
0025                       ; Modifier keys - Delete
0026                       ;-------------------------------------------------------
0027 7E82 0300             data  key.fctn.1, pane.focus.fb, edkey.action.del_char
     7E84 0000 
     7E86 6406 
0028 7E88 0700             data  key.fctn.3, pane.focus.fb, edkey.action.del_line
     7E8A 0000 
     7E8C 64B8 
0029 7E8E 0200             data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
     7E90 0000 
     7E92 6484 
0030               
0031                       ;-------------------------------------------------------
0032                       ; Modifier keys - Insert
0033                       ;-------------------------------------------------------
0034 7E94 0400             data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
     7E96 0000 
     7E98 6514 
0035 7E9A B900             data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
     7E9C 0000 
     7E9E 6640 
0036 7EA0 0E00             data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
     7EA2 0000 
     7EA4 658E 
0037                       ;-------------------------------------------------------
0038                       ; Other action keys
0039                       ;-------------------------------------------------------
0040 7EA6 0500             data  key.fctn.plus, pane.focus.fb, edkey.action.quit
     7EA8 0000 
     7EAA 66B4 
0041 7EAC 9A00             data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
     7EAE 0000 
     7EB0 785C 
0042                       ;-------------------------------------------------------
0043                       ; Dialog keys
0044                       ;-------------------------------------------------------
0045 7EB2 8000             data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
     7EB4 0000 
     7EB6 66CA 
0046 7EB8 9B00             data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
     7EBA 0000 
     7EBC 66D6 
0047 7EBE 0100             data  key.fctn.7, pane.focus.fb, edkey.action.about
     7EC0 0000 
     7EC2 7CC4 
0048 7EC4 8B00             data  key.ctrl.k, pane.focus.fb, dialog.save
     7EC6 0000 
     7EC8 7DD0 
0049 7ECA 8C00             data  key.ctrl.l, pane.focus.fb, dialog.load
     7ECC 0000 
     7ECE 7D96 
0050                       ;-------------------------------------------------------
0051                       ; End of list
0052                       ;-------------------------------------------------------
0053 7ED0 FFFF             data  EOL                           ; EOL
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
0065 7ED2 0E00             data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
     7ED4 000A 
     7ED6 6836 
0066                       ;-------------------------------------------------------
0067                       ; Dialog specific: Unsaved changes
0068                       ;-------------------------------------------------------
0069 7ED8 0C00             data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
     7EDA 0065 
     7EDC 680C 
0070 7EDE 0D00             data  key.enter, id.dialog.unsaved, dialog.save
     7EE0 0065 
     7EE2 7DD0 
0071                       ;-------------------------------------------------------
0072                       ; Dialog specific: About
0073                       ;-------------------------------------------------------
0074 7EE4 0D00             data  key.enter, id.dialog.about, edkey.action.cmdb.close.dialog
     7EE6 0066 
     7EE8 6842 
0075                       ;-------------------------------------------------------
0076                       ; Movement keys
0077                       ;-------------------------------------------------------
0078 7EEA 0800             data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
     7EEC 0001 
     7EEE 6700 
0079 7EF0 0900             data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
     7EF2 0001 
     7EF4 6712 
0080 7EF6 8100             data  key.ctrl.a, pane.focus.cmdb, edkey.action.cmdb.home
     7EF8 0001 
     7EFA 672A 
0081 7EFC 8600             data  key.ctrl.f, pane.focus.cmdb, edkey.action.cmdb.end
     7EFE 0001 
     7F00 673E 
0082                       ;-------------------------------------------------------
0083                       ; Modifier keys
0084                       ;-------------------------------------------------------
0085 7F02 0700             data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
     7F04 0001 
     7F06 6756 
0086 7F08 0D00             data  key.enter, pane.focus.cmdb, edkey.action.cmdb.enter
     7F0A 0001 
     7F0C 679A 
0087                       ;-------------------------------------------------------
0088                       ; Other action keys
0089                       ;-------------------------------------------------------
0090 7F0E 0F00             data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
     7F10 0001 
     7F12 6842 
0091 7F14 0500             data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
     7F16 0001 
     7F18 66B4 
0092 7F1A 9A00             data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
     7F1C 0001 
     7F1E 785C 
0093                       ;------------------------------------------------------
0094                       ; End of list
0095                       ;-------------------------------------------------------
0096 7F20 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.1638280
0192                                                   ; Data segment - Keyboard actions
0196 7F22 7F22                   data $                ; Bank 1 ROM size OK.
0198               
0199               *--------------------------------------------------------------
0200               * Video mode configuration
0201               *--------------------------------------------------------------
0202      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0203      0004     spfbck  equ   >04                   ; Screen background color.
0204      3008     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0205      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0206      0050     colrow  equ   80                    ; Columns per row
0207      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0208      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0209      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0210      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

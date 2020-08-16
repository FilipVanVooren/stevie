XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.24929
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 200816-24929
0010               
0011                       copy  "equates.equ"         ; Equates Stevie configuration
**** **** ****     > equates.equ
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: equates.equ                 ; Version %%build_date%%
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
0090      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0091      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0092      0001     id.dialog.load            equ  1       ; ID for dialog "Load DV 80 file"
0093      0002     id.dialog.save            equ  2       ; ID for dialog "Save DV 80 file"
0094      0003     id.dialog.unsaved         equ  3       ; ID for dialog "Unsaved changes"
0095      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0096      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0097      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0098               *--------------------------------------------------------------
0099               * SPECTRA2 / Stevie startup options
0100               *--------------------------------------------------------------
0101      0001     debug                     equ  1       ; Turn on spectra2 debugging
0102      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0103      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0104      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0105               *--------------------------------------------------------------
0106               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0107               *--------------------------------------------------------------
0108      2F20     parm1             equ  >2f20           ; Function parameter 1
0109      2F22     parm2             equ  >2f22           ; Function parameter 2
0110      2F24     parm3             equ  >2f24           ; Function parameter 3
0111      2F26     parm4             equ  >2f26           ; Function parameter 4
0112      2F28     parm5             equ  >2f28           ; Function parameter 5
0113      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0114      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0115      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0116      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0117      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0118      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0119      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0120      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0121      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0122      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0123      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0124      2F40     timers            equ  >2f40           ; Timer table
0125      2F50     ramsat            equ  >2f50           ; Sprite Attribute Table in RAM
0126      2F60     rambuf            equ  >2f60           ; RAM workbuffer 1
0127               
0128               *--------------------------------------------------------------
0129               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0130               *--------------------------------------------------------------
0131      A000     tv.top            equ  >a000           ; Structure begin
0132      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0133      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0134      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0135      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0136      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0137      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0138      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0139      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0140      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0141      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0142      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0143      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0144      A018     tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
0145      A01A     tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
0146      A01C     tv.task.oneshot   equ  tv.top + 28     ; Pointer to one-shot routine
0147      A01E     tv.error.visible  equ  tv.top + 30     ; Error pane visible
0148      A020     tv.error.msg      equ  tv.top + 32     ; Error message (max. 160 characters)
0149      A0C0     tv.free           equ  tv.top + 192    ; End of structure
0150               *--------------------------------------------------------------
0151               * Frame buffer structure              @>a100-a1ff   (256 bytes)
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
0164      A110     fb.free1          equ  fb.struct + 16  ; **** free ****
0165      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0166      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0167      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0168      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0169      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0170      A11C     fb.free           equ  fb.struct + 28  ; End of structure
0171               *--------------------------------------------------------------
0172               * Editor buffer structure             @>a200-a2ff   (256 bytes)
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
0187      A214     edb.free          equ  edb.struct + 20 ; End of structure
0188               *--------------------------------------------------------------
0189               * Command buffer structure            @>a300-a3ff   (256 bytes)
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
0205      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0206      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
0207      A31E     cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
0208      A320     cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
0209      A322     cmdb.cmdlen       equ  cmdb.struct + 34; Length of current command (MSB byte!)
0210      A323     cmdb.cmd          equ  cmdb.struct + 35; Current command (80 bytes max.)
0211      A373     cmdb.free         equ  cmdb.struct +115; End of structure
0212               *--------------------------------------------------------------
0213               * File handle structure               @>a400-a4ff   (256 bytes)
0214               *--------------------------------------------------------------
0215      A400     fh.struct         equ  >a400           ; stevie file handling structures
0216      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0217      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0218      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0219      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0220      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0221      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0222      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0223      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0224      A434     fh.counter        equ  fh.struct + 52  ; Counter used in stevie file operations
0225      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0226      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0227      A43A     fh.sams.hipage    equ  fh.struct + 58  ; Highest SAMS page in file operatition
0228      A43C     fh.fopmode        equ  fh.struct + 60  ; FOP (File Operation Mode)
0229      A43E     fh.filetype       equ  fh.struct + 62  ; Value for filetype/mode (PAB byte 1)
0230      A440     fh.callback1      equ  fh.struct + 64  ; Pointer to callback function 1
0231      A442     fh.callback2      equ  fh.struct + 66  ; Pointer to callback function 2
0232      A444     fh.callback3      equ  fh.struct + 68  ; Pointer to callback function 3
0233      A446     fh.callback4      equ  fh.struct + 70  ; Pointer to callback function 4
0234      A448     fh.kilobytes.prev equ  fh.struct + 72  ; Kilobytes process (previous)
0235      A44A     fh.membuffer      equ  fh.struct + 74  ; 80 bytes file memory buffer
0236      A49A     fh.free           equ  fh.struct +154  ; End of structure
0237      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0238      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0239               *--------------------------------------------------------------
0240               * Index structure                     @>a500-a5ff   (256 bytes)
0241               *--------------------------------------------------------------
0242      A500     idx.struct        equ  >a500           ; stevie index structure
0243      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0244      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0245      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0246               *--------------------------------------------------------------
0247               * Frame buffer                        @>a600-afff  (2560 bytes)
0248               *--------------------------------------------------------------
0249      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0250      0960     fb.size           equ  80*30           ; Frame buffer size
0251               *--------------------------------------------------------------
0252               * Index                               @>b000-bfff  (4096 bytes)
0253               *--------------------------------------------------------------
0254      B000     idx.top           equ  >b000           ; Top of index
0255      1000     idx.size          equ  4096            ; Index size
0256               *--------------------------------------------------------------
0257               * Editor buffer                       @>c000-cfff  (4096 bytes)
0258               *--------------------------------------------------------------
0259      C000     edb.top           equ  >c000           ; Editor buffer high memory
0260      1000     edb.size          equ  4096            ; Editor buffer size
0261               *--------------------------------------------------------------
0262               * Command history buffer              @>d000-dfff  (4096 bytes)
0263               *--------------------------------------------------------------
0264      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0265      1000     cmdb.size         equ  4096            ; Command buffer size
0266               *--------------------------------------------------------------
0267               * Heap                                @>e000-efff  (4096 bytes)
0268               *--------------------------------------------------------------
0269      E000     heap.top          equ  >e000           ; Top of heap
0270               *--------------------------------------------------------------
0271               * Scratchpad backup 1                 @>f000-f0ff   (256 bytes)
0272               * Scratchpad backup 2                 @>f100-f1ff   (256 bytes)
0273               *--------------------------------------------------------------
0274      F000     cpu.scrpad.tgt    equ  >f000           ; Destination cpu.scrpad.backup/restore
0275      F000     scrpad.backup1    equ  >f000           ; Backup 1 (GPL layout)
0276      F100     scrpad.backup2    equ  >f100           ; Backup 2 (spectra2 layout)
**** **** ****     > stevie_b1.asm.24929
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
0035 6014 1353             byte  19
0036 6015 ....             text  'STEVIE 200816-24929'
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
0066               * skip_file                 equ  1  ; Skip support for file I/O, dsrlnk
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
     208E 2D7E 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2092 2302 
0078 2094 21F2                   data graph1           ; Equate selected video mode table
0079               
0080 2096 06A0  32         bl    @ldfnt
     2098 236A 
0081 209A 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     209C 000C 
0082               
0083 209E 06A0  32         bl    @filv
     20A0 2298 
0084 20A2 0380                   data >0380,>f0,32*24  ; Load color table
     20A4 00F0 
     20A6 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 20A8 06A0  32         bl    @putat                ; Show crash message
     20AA 244C 
0089 20AC 0000                   data >0000,cpu.crash.msg.crashed
     20AE 2182 
0090               
0091 20B0 06A0  32         bl    @puthex               ; Put hex value on screen
     20B2 2988 
0092 20B4 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20B6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20B8 2F60                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20BA 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20BC 06A0  32         bl    @putat                ; Show caller message
     20BE 244C 
0101 20C0 0100                   data >0100,cpu.crash.msg.caller
     20C2 2198 
0102               
0103 20C4 06A0  32         bl    @puthex               ; Put hex value on screen
     20C6 2988 
0104 20C8 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20CA FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20CC 2F60                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20CE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20D0 06A0  32         bl    @putat
     20D2 244C 
0113 20D4 0300                   byte 3,0
0114 20D6 21B2                   data cpu.crash.msg.wp
0115 20D8 06A0  32         bl    @putat
     20DA 244C 
0116 20DC 0400                   byte 4,0
0117 20DE 21B8                   data cpu.crash.msg.st
0118 20E0 06A0  32         bl    @putat
     20E2 244C 
0119 20E4 1600                   byte 22,0
0120 20E6 21BE                   data cpu.crash.msg.source
0121 20E8 06A0  32         bl    @putat
     20EA 244C 
0122 20EC 1700                   byte 23,0
0123 20EE 21DA                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20F0 06A0  32         bl    @at                   ; Put cursor at YX
     20F2 2690 
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
     2116 2992 
0154 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 211A 2F60                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 211C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 211E 06A0  32         bl    @setx                 ; Set cursor X position
     2120 26A6 
0160 2122 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 2124 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2126 2428 
0164 2128 2F60                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 212A 06A0  32         bl    @setx                 ; Set cursor X position
     212C 26A6 
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
     213C 2428 
0176 213E 21AE                   data cpu.crash.msg.r
0177               
0178 2140 06A0  32         bl    @mknum
     2142 2992 
0179 2144 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 2146 2F60                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 2148 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 214A 06A0  32         bl    @mkhex                ; Convert hex word to string
     214C 2904 
0188 214E 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2150 2F60                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2152 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 2154 06A0  32         bl    @setx                 ; Set cursor X position
     2156 26A6 
0194 2158 0006                   data 6                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 215A 06A0  32         bl    @putstr
     215C 2428 
0198 215E 21B0                   data cpu.crash.msg.marker
0199               
0200 2160 06A0  32         bl    @setx                 ; Set cursor X position
     2162 26A6 
0201 2164 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 2166 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2168 2428 
0205 216A 2F60                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 216C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 216E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2170 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2172 06A0  32         bl    @down                 ; y=y+1
     2174 2696 
0213               
0214 2176 0586  14         inc   tmp2
0215 2178 0286  22         ci    tmp2,17
     217A 0011 
0216 217C 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 217E 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2180 2C7C 
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
0260 21DB ....             text  'Build-ID  200816-24929'
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
0036 2224 0201  20         li    r1,mccode             ; Machinecode to patch
     2226 221A 
0037 2228 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     222A 8322 
0038 222C CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 222E CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2230 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 2232 045B  20         b     *r11                  ; Return to caller
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
0056 2234 C0F9  30 popr3   mov   *stack+,r3
0057 2236 C0B9  30 popr2   mov   *stack+,r2
0058 2238 C079  30 popr1   mov   *stack+,r1
0059 223A C039  30 popr0   mov   *stack+,r0
0060 223C C2F9  30 poprt   mov   *stack+,r11
0061 223E 045B  20         b     *r11
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
0085 2240 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 2242 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 2244 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Do some checks first
0090               *--------------------------------------------------------------
0091 2246 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 2248 1604  14         jne   filchk                ; No, continue checking
0093               
0094 224A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     224C FFCE 
0095 224E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2250 2030 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 2252 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     2254 830B 
     2256 830A 
0100               
0101 2258 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     225A 0001 
0102 225C 1602  14         jne   filchk2
0103 225E DD05  32         movb  tmp1,*tmp0+
0104 2260 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 2262 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     2264 0002 
0109 2266 1603  14         jne   filchk3
0110 2268 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 226A DD05  32         movb  tmp1,*tmp0+
0112 226C 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 226E C1C4  18 filchk3 mov   tmp0,tmp3
0117 2270 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2272 0001 
0118 2274 1605  14         jne   fil16b
0119 2276 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 2278 0606  14         dec   tmp2
0121 227A 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     227C 0002 
0122 227E 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2280 C1C6  18 fil16b  mov   tmp2,tmp3
0127 2282 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2284 0001 
0128 2286 1301  14         jeq   dofill
0129 2288 0606  14         dec   tmp2                  ; Make TMP2 even
0130 228A CD05  34 dofill  mov   tmp1,*tmp0+
0131 228C 0646  14         dect  tmp2
0132 228E 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2290 C1C7  18         mov   tmp3,tmp3
0137 2292 1301  14         jeq   fil.exit
0138 2294 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 2296 045B  20         b     *r11
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
0159 2298 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 229A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 229C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 229E 0264  22 xfilv   ori   tmp0,>4000
     22A0 4000 
0166 22A2 06C4  14         swpb  tmp0
0167 22A4 D804  38         movb  tmp0,@vdpa
     22A6 8C02 
0168 22A8 06C4  14         swpb  tmp0
0169 22AA D804  38         movb  tmp0,@vdpa
     22AC 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22AE 020F  20         li    r15,vdpw              ; Set VDP write address
     22B0 8C00 
0174 22B2 06C5  14         swpb  tmp1
0175 22B4 C820  54         mov   @filzz,@mcloop        ; Setup move command
     22B6 22BE 
     22B8 8320 
0176 22BA 0460  28         b     @mcloop               ; Write data to VDP
     22BC 8320 
0177               *--------------------------------------------------------------
0181 22BE D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22C0 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22C2 4000 
0202 22C4 06C4  14 vdra    swpb  tmp0
0203 22C6 D804  38         movb  tmp0,@vdpa
     22C8 8C02 
0204 22CA 06C4  14         swpb  tmp0
0205 22CC D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22CE 8C02 
0206 22D0 045B  20         b     *r11                  ; Exit
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
0217 22D2 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22D4 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22D6 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22D8 4000 
0223 22DA 06C4  14         swpb  tmp0                  ; \
0224 22DC D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22DE 8C02 
0225 22E0 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22E2 D804  38         movb  tmp0,@vdpa            ; /
     22E4 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22E6 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22E8 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22EA 045B  20         b     *r11                  ; Exit
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
0251 22EC C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22EE 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22F0 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22F2 8C02 
0257 22F4 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22F6 D804  38         movb  tmp0,@vdpa            ; /
     22F8 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22FA D120  34         movb  @vdpr,tmp0            ; Read byte
     22FC 8800 
0263 22FE 0984  56         srl   tmp0,8                ; Right align
0264 2300 045B  20         b     *r11                  ; Exit
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
0283 2302 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 2304 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 2306 C144  18         mov   tmp0,tmp1
0289 2308 05C5  14         inct  tmp1
0290 230A D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 230C 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     230E FF00 
0292 2310 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 2312 C805  38         mov   tmp1,@wbase           ; Store calculated base
     2314 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 2316 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2318 8000 
0298 231A 0206  20         li    tmp2,8
     231C 0008 
0299 231E D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2320 830B 
0300 2322 06C5  14         swpb  tmp1
0301 2324 D805  38         movb  tmp1,@vdpa
     2326 8C02 
0302 2328 06C5  14         swpb  tmp1
0303 232A D805  38         movb  tmp1,@vdpa
     232C 8C02 
0304 232E 0225  22         ai    tmp1,>0100
     2330 0100 
0305 2332 0606  14         dec   tmp2
0306 2334 16F4  14         jne   vidta1                ; Next register
0307 2336 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2338 833A 
0308 233A 045B  20         b     *r11
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
0325 233C C13B  30 putvr   mov   *r11+,tmp0
0326 233E 0264  22 putvrx  ori   tmp0,>8000
     2340 8000 
0327 2342 06C4  14         swpb  tmp0
0328 2344 D804  38         movb  tmp0,@vdpa
     2346 8C02 
0329 2348 06C4  14         swpb  tmp0
0330 234A D804  38         movb  tmp0,@vdpa
     234C 8C02 
0331 234E 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2350 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 2352 C10E  18         mov   r14,tmp0
0341 2354 0984  56         srl   tmp0,8
0342 2356 06A0  32         bl    @putvrx               ; Write VR#0
     2358 233E 
0343 235A 0204  20         li    tmp0,>0100
     235C 0100 
0344 235E D820  54         movb  @r14lb,@tmp0lb
     2360 831D 
     2362 8309 
0345 2364 06A0  32         bl    @putvrx               ; Write VR#1
     2366 233E 
0346 2368 0458  20         b     *tmp4                 ; Exit
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
0360 236A C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 236C 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 236E C11B  26         mov   *r11,tmp0             ; Get P0
0363 2370 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2372 7FFF 
0364 2374 2120  38         coc   @wbit0,tmp0
     2376 202A 
0365 2378 1604  14         jne   ldfnt1
0366 237A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     237C 8000 
0367 237E 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2380 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 2382 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     2384 23EC 
0372 2386 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2388 9C02 
0373 238A 06C4  14         swpb  tmp0
0374 238C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     238E 9C02 
0375 2390 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2392 9800 
0376 2394 06C5  14         swpb  tmp1
0377 2396 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     2398 9800 
0378 239A 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 239C D805  38         movb  tmp1,@grmwa
     239E 9C02 
0383 23A0 06C5  14         swpb  tmp1
0384 23A2 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     23A4 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23A6 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23A8 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23AA 22C0 
0390 23AC 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23AE C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23B0 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23B2 7FFF 
0393 23B4 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23B6 23EE 
0394 23B8 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23BA 23F0 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23BC 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23BE 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23C0 D120  34         movb  @grmrd,tmp0
     23C2 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23C4 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23C6 202A 
0405 23C8 1603  14         jne   ldfnt3                ; No, so skip
0406 23CA D1C4  18         movb  tmp0,tmp3
0407 23CC 0917  56         srl   tmp3,1
0408 23CE E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23D0 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23D2 8C00 
0413 23D4 0606  14         dec   tmp2
0414 23D6 16F2  14         jne   ldfnt2
0415 23D8 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23DA 020F  20         li    r15,vdpw              ; Set VDP write address
     23DC 8C00 
0417 23DE 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23E0 7FFF 
0418 23E2 0458  20         b     *tmp4                 ; Exit
0419 23E4 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23E6 200A 
     23E8 8C00 
0420 23EA 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23EC 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23EE 0200 
     23F0 0000 
0425 23F2 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23F4 01C0 
     23F6 0101 
0426 23F8 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23FA 02A0 
     23FC 0101 
0427 23FE 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     2400 00E0 
     2402 0101 
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
0445 2404 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 2406 C3A0  34         mov   @wyx,r14              ; Get YX
     2408 832A 
0447 240A 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 240C 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     240E 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2410 C3A0  34         mov   @wyx,r14              ; Get YX
     2412 832A 
0454 2414 024E  22         andi  r14,>00ff             ; Remove Y
     2416 00FF 
0455 2418 A3CE  18         a     r14,r15               ; pos = pos + X
0456 241A A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     241C 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 241E C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2420 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 2422 020F  20         li    r15,vdpw              ; VDP write address
     2424 8C00 
0463 2426 045B  20         b     *r11
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
0478 2428 C17B  30 putstr  mov   *r11+,tmp1
0479 242A D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 242C C1CB  18 xutstr  mov   r11,tmp3
0481 242E 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2430 2404 
0482 2432 C2C7  18         mov   tmp3,r11
0483 2434 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 2436 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 2438 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 243A 0286  22         ci    tmp2,255              ; Length > 255 ?
     243C 00FF 
0491 243E 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 2440 0460  28         b     @xpym2v               ; Display string
     2442 245A 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 2444 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2446 FFCE 
0498 2448 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     244A 2030 
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
0514 244C C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     244E 832A 
0515 2450 0460  28         b     @putstr
     2452 2428 
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
0020 2454 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 2456 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 2458 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 245A 0264  22 xpym2v  ori   tmp0,>4000
     245C 4000 
0027 245E 06C4  14         swpb  tmp0
0028 2460 D804  38         movb  tmp0,@vdpa
     2462 8C02 
0029 2464 06C4  14         swpb  tmp0
0030 2466 D804  38         movb  tmp0,@vdpa
     2468 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 246A 020F  20         li    r15,vdpw              ; Set VDP write address
     246C 8C00 
0035 246E C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2470 2478 
     2472 8320 
0036 2474 0460  28         b     @mcloop               ; Write data to VDP
     2476 8320 
0037 2478 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 247A C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 247C C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 247E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2480 06C4  14 xpyv2m  swpb  tmp0
0027 2482 D804  38         movb  tmp0,@vdpa
     2484 8C02 
0028 2486 06C4  14         swpb  tmp0
0029 2488 D804  38         movb  tmp0,@vdpa
     248A 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 248C 020F  20         li    r15,vdpr              ; Set VDP read address
     248E 8800 
0034 2490 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2492 249A 
     2494 8320 
0035 2496 0460  28         b     @mcloop               ; Read data from VDP
     2498 8320 
0036 249A DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 249C C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 249E C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24A0 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24A2 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24A4 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24A6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24A8 FFCE 
0034 24AA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24AC 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24AE 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24B0 0001 
0039 24B2 1603  14         jne   cpym0                 ; No, continue checking
0040 24B4 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24B6 04C6  14         clr   tmp2                  ; Reset counter
0042 24B8 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24BA 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24BC 7FFF 
0047 24BE C1C4  18         mov   tmp0,tmp3
0048 24C0 0247  22         andi  tmp3,1
     24C2 0001 
0049 24C4 1618  14         jne   cpyodd                ; Odd source address handling
0050 24C6 C1C5  18 cpym1   mov   tmp1,tmp3
0051 24C8 0247  22         andi  tmp3,1
     24CA 0001 
0052 24CC 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24CE 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24D0 202A 
0057 24D2 1605  14         jne   cpym3
0058 24D4 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24D6 24FC 
     24D8 8320 
0059 24DA 0460  28         b     @mcloop               ; Copy memory and exit
     24DC 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24DE C1C6  18 cpym3   mov   tmp2,tmp3
0064 24E0 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24E2 0001 
0065 24E4 1301  14         jeq   cpym4
0066 24E6 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24E8 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24EA 0646  14         dect  tmp2
0069 24EC 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24EE C1C7  18         mov   tmp3,tmp3
0074 24F0 1301  14         jeq   cpymz
0075 24F2 D554  38         movb  *tmp0,*tmp1
0076 24F4 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24F6 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24F8 8000 
0081 24FA 10E9  14         jmp   cpym2
0082 24FC DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 24FE C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2500 0649  14         dect  stack
0065 2502 C64B  30         mov   r11,*stack            ; Push return address
0066 2504 0649  14         dect  stack
0067 2506 C640  30         mov   r0,*stack             ; Push r0
0068 2508 0649  14         dect  stack
0069 250A C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 250C 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 250E 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2510 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2512 4000 
0077 2514 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2516 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 2518 020C  20         li    r12,>1e00             ; SAMS CRU address
     251A 1E00 
0082 251C 04C0  14         clr   r0
0083 251E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2520 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2522 D100  18         movb  r0,tmp0
0086 2524 0984  56         srl   tmp0,8                ; Right align
0087 2526 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     2528 833C 
0088 252A 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 252C C339  30         mov   *stack+,r12           ; Pop r12
0094 252E C039  30         mov   *stack+,r0            ; Pop r0
0095 2530 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2532 045B  20         b     *r11                  ; Return to caller
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
0131 2534 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2536 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 2538 0649  14         dect  stack
0135 253A C64B  30         mov   r11,*stack            ; Push return address
0136 253C 0649  14         dect  stack
0137 253E C640  30         mov   r0,*stack             ; Push r0
0138 2540 0649  14         dect  stack
0139 2542 C64C  30         mov   r12,*stack            ; Push r12
0140 2544 0649  14         dect  stack
0141 2546 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 2548 0649  14         dect  stack
0143 254A C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 254C 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 254E 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 2550 0284  22         ci    tmp0,255              ; Crash if page > 255
     2552 00FF 
0153 2554 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 2556 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2558 001E 
0158 255A 150A  14         jgt   !
0159 255C 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     255E 0004 
0160 2560 1107  14         jlt   !
0161 2562 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2564 0012 
0162 2566 1508  14         jgt   sams.page.set.switch_page
0163 2568 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     256A 0006 
0164 256C 1501  14         jgt   !
0165 256E 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 2570 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2572 FFCE 
0170 2574 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2576 2030 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 2578 020C  20         li    r12,>1e00             ; SAMS CRU address
     257A 1E00 
0176 257C C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 257E 06C0  14         swpb  r0                    ; LSB to MSB
0178 2580 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2582 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2584 4000 
0180 2586 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 2588 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 258A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 258C C339  30         mov   *stack+,r12           ; Pop r12
0188 258E C039  30         mov   *stack+,r0            ; Pop r0
0189 2590 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 2592 045B  20         b     *r11                  ; Return to caller
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
0204 2594 020C  20         li    r12,>1e00             ; SAMS CRU address
     2596 1E00 
0205 2598 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 259A 045B  20         b     *r11                  ; Return to caller
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
0227 259C 020C  20         li    r12,>1e00             ; SAMS CRU address
     259E 1E00 
0228 25A0 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25A2 045B  20         b     *r11                  ; Return to caller
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
0260 25A4 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25A6 0649  14         dect  stack
0263 25A8 C64B  30         mov   r11,*stack            ; Save return address
0264 25AA 0649  14         dect  stack
0265 25AC C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25AE 0649  14         dect  stack
0267 25B0 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25B2 0649  14         dect  stack
0269 25B4 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25B6 0649  14         dect  stack
0271 25B8 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25BA 0206  20         li    tmp2,8                ; Set loop counter
     25BC 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25BE C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 25C0 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25C2 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25C4 2538 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25C6 0606  14         dec   tmp2                  ; Next iteration
0288 25C8 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25CA 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25CC 2594 
0294                                                   ; / activating changes.
0295               
0296 25CE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25D0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25D2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25D6 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25D8 045B  20         b     *r11                  ; Return to caller
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
0318 25DA 0649  14         dect  stack
0319 25DC C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25DE 06A0  32         bl    @sams.layout
     25E0 25A4 
0324 25E2 25E8                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25E6 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25E8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25EA 0002 
0336 25EC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25EE 0003 
0337 25F0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25F2 000A 
0338 25F4 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25F6 000B 
0339 25F8 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25FA 000C 
0340 25FC D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     25FE 000D 
0341 2600 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2602 000E 
0342 2604 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2606 000F 
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
0363 2608 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 260A 0649  14         dect  stack
0366 260C C64B  30         mov   r11,*stack            ; Push return address
0367 260E 0649  14         dect  stack
0368 2610 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2612 0649  14         dect  stack
0370 2614 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2616 0649  14         dect  stack
0372 2618 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 261A 0649  14         dect  stack
0374 261C C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 261E 0205  20         li    tmp1,sams.layout.copy.data
     2620 2640 
0379 2622 0206  20         li    tmp2,8                ; Set loop counter
     2624 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2626 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 2628 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     262A 2500 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 262C CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     262E 833C 
0390               
0391 2630 0606  14         dec   tmp2                  ; Next iteration
0392 2632 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2634 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2636 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 2638 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 263A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 263C C2F9  30         mov   *stack+,r11           ; Pop r11
0402 263E 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2640 2000             data  >2000                 ; >2000-2fff
0408 2642 3000             data  >3000                 ; >3000-3fff
0409 2644 A000             data  >a000                 ; >a000-afff
0410 2646 B000             data  >b000                 ; >b000-bfff
0411 2648 C000             data  >c000                 ; >c000-cfff
0412 264A D000             data  >d000                 ; >d000-dfff
0413 264C E000             data  >e000                 ; >e000-efff
0414 264E F000             data  >f000                 ; >f000-ffff
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
0009 2650 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2652 FFBF 
0010 2654 0460  28         b     @putv01
     2656 2350 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2658 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     265A 0040 
0018 265C 0460  28         b     @putv01
     265E 2350 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 2660 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2662 FFDF 
0026 2664 0460  28         b     @putv01
     2666 2350 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2668 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     266A 0020 
0034 266C 0460  28         b     @putv01
     266E 2350 
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
0010 2670 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2672 FFFE 
0011 2674 0460  28         b     @putv01
     2676 2350 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2678 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     267A 0001 
0019 267C 0460  28         b     @putv01
     267E 2350 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 2680 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2682 FFFD 
0027 2684 0460  28         b     @putv01
     2686 2350 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2688 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     268A 0002 
0035 268C 0460  28         b     @putv01
     268E 2350 
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
0018 2690 C83B  50 at      mov   *r11+,@wyx
     2692 832A 
0019 2694 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 2696 B820  54 down    ab    @hb$01,@wyx
     2698 201C 
     269A 832A 
0028 269C 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 269E 7820  54 up      sb    @hb$01,@wyx
     26A0 201C 
     26A2 832A 
0037 26A4 045B  20         b     *r11
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
0049 26A6 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26A8 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26AA 832A 
0051 26AC C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26AE 832A 
0052 26B0 045B  20         b     *r11
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
0021 26B2 C120  34 yx2px   mov   @wyx,tmp0
     26B4 832A 
0022 26B6 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26B8 06C4  14         swpb  tmp0                  ; Y<->X
0024 26BA 04C5  14         clr   tmp1                  ; Clear before copy
0025 26BC D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26BE 20A0  38         coc   @wbit1,config         ; f18a present ?
     26C0 2028 
0030 26C2 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26C4 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26C6 833A 
     26C8 26F2 
0032 26CA 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26CC 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26CE B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26D0 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26D2 0500 
0037 26D4 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26D6 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26D8 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26DA 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26DC D105  18         movb  tmp1,tmp0
0051 26DE 06C4  14         swpb  tmp0                  ; X<->Y
0052 26E0 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26E2 202A 
0053 26E4 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26E6 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26E8 201C 
0059 26EA 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26EC 202E 
0060 26EE 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26F0 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26F2 0050            data   80
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
0013 26F4 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26F6 06A0  32         bl    @putvr                ; Write once
     26F8 233C 
0015 26FA 391C             data  >391c                 ; VR1/57, value 00011100
0016 26FC 06A0  32         bl    @putvr                ; Write twice
     26FE 233C 
0017 2700 391C             data  >391c                 ; VR1/57, value 00011100
0018 2702 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2704 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 2706 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2708 233C 
0028 270A 391C             data  >391c
0029 270C 0458  20         b     *tmp4                 ; Exit
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
0040 270E C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2710 06A0  32         bl    @cpym2v
     2712 2454 
0042 2714 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     2716 2752 
     2718 0006 
0043 271A 06A0  32         bl    @putvr
     271C 233C 
0044 271E 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2720 06A0  32         bl    @putvr
     2722 233C 
0046 2724 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2726 0204  20         li    tmp0,>3f00
     2728 3F00 
0052 272A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     272C 22C4 
0053 272E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2730 8800 
0054 2732 0984  56         srl   tmp0,8
0055 2734 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2736 8800 
0056 2738 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 273A 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 273C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     273E BFFF 
0060 2740 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2742 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2744 4000 
0063               f18chk_exit:
0064 2746 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2748 2298 
0065 274A 3F00             data  >3f00,>00,6
     274C 0000 
     274E 0006 
0066 2750 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2752 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2754 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2756 0340             data  >0340                 ; 3f04   0340  idle
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
0092 2758 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 275A 06A0  32         bl    @putvr
     275C 233C 
0097 275E 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 2760 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2762 233C 
0100 2764 391C             data  >391c                 ; Lock the F18a
0101 2766 0458  20         b     *tmp4                 ; Exit
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
0120 2768 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 276A 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     276C 2028 
0122 276E 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 2770 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2772 8802 
0127 2774 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2776 233C 
0128 2778 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 277A 04C4  14         clr   tmp0
0130 277C D120  34         movb  @vdps,tmp0
     277E 8802 
0131 2780 0984  56         srl   tmp0,8
0132 2782 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 2784 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2786 832A 
0018 2788 D17B  28         movb  *r11+,tmp1
0019 278A 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 278C D1BB  28         movb  *r11+,tmp2
0021 278E 0986  56         srl   tmp2,8                ; Repeat count
0022 2790 C1CB  18         mov   r11,tmp3
0023 2792 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2794 2404 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 2796 020B  20         li    r11,hchar1
     2798 279E 
0028 279A 0460  28         b     @xfilv                ; Draw
     279C 229E 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 279E 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27A0 202C 
0033 27A2 1302  14         jeq   hchar2                ; Yes, exit
0034 27A4 C2C7  18         mov   tmp3,r11
0035 27A6 10EE  14         jmp   hchar                 ; Next one
0036 27A8 05C7  14 hchar2  inct  tmp3
0037 27AA 0457  20         b     *tmp3                 ; Exit
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
0016 27AC 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27AE 202A 
0017 27B0 020C  20         li    r12,>0024
     27B2 0024 
0018 27B4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27B6 2844 
0019 27B8 04C6  14         clr   tmp2
0020 27BA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27BC 04CC  14         clr   r12
0025 27BE 1F08  20         tb    >0008                 ; Shift-key ?
0026 27C0 1302  14         jeq   realk1                ; No
0027 27C2 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27C4 2874 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27C6 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27C8 1302  14         jeq   realk2                ; No
0033 27CA 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27CC 28A4 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27CE 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27D0 1302  14         jeq   realk3                ; No
0039 27D2 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27D4 28D4 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27D6 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 27D8 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 27DA 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 27DC E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     27DE 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 27E0 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 27E2 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27E4 0006 
0052 27E6 0606  14 realk5  dec   tmp2
0053 27E8 020C  20         li    r12,>24               ; CRU address for P2-P4
     27EA 0024 
0054 27EC 06C6  14         swpb  tmp2
0055 27EE 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 27F0 06C6  14         swpb  tmp2
0057 27F2 020C  20         li    r12,6                 ; CRU read address
     27F4 0006 
0058 27F6 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 27F8 0547  14         inv   tmp3                  ;
0060 27FA 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     27FC FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 27FE 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 2800 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 2802 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 2804 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 2806 0285  22         ci    tmp1,8
     2808 0008 
0069 280A 1AFA  14         jl    realk6
0070 280C C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 280E 1BEB  14         jh    realk5                ; No, next column
0072 2810 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 2812 C206  18 realk8  mov   tmp2,tmp4
0077 2814 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 2816 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 2818 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 281A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 281C 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 281E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 2820 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     2822 202A 
0087 2824 1608  14         jne   realka                ; No, continue saving key
0088 2826 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2828 286E 
0089 282A 1A05  14         jl    realka
0090 282C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     282E 286C 
0091 2830 1B02  14         jh    realka                ; No, continue
0092 2832 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     2834 E000 
0093 2836 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2838 833C 
0094 283A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     283C 2014 
0095 283E 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     2840 8C00 
0096 2842 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 2844 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2846 0000 
     2848 FF0D 
     284A 203D 
0099 284C ....             text  'xws29ol.'
0100 2854 ....             text  'ced38ik,'
0101 285C ....             text  'vrf47ujm'
0102 2864 ....             text  'btg56yhn'
0103 286C ....             text  'zqa10p;/'
0104 2874 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2876 0000 
     2878 FF0D 
     287A 202B 
0105 287C ....             text  'XWS@(OL>'
0106 2884 ....             text  'CED#*IK<'
0107 288C ....             text  'VRF$&UJM'
0108 2894 ....             text  'BTG%^YHN'
0109 289C ....             text  'ZQA!)P:-'
0110 28A4 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28A6 0000 
     28A8 FF0D 
     28AA 2005 
0111 28AC 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28AE 0804 
     28B0 0F27 
     28B2 C2B9 
0112 28B4 600B             data  >600b,>0907,>063f,>c1B8
     28B6 0907 
     28B8 063F 
     28BA C1B8 
0113 28BC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28BE 7B02 
     28C0 015F 
     28C2 C0C3 
0114 28C4 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28C6 7D0E 
     28C8 0CC6 
     28CA BFC4 
0115 28CC 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28CE 7C03 
     28D0 BC22 
     28D2 BDBA 
0116 28D4 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28D6 0000 
     28D8 FF0D 
     28DA 209D 
0117 28DC 9897             data  >9897,>93b2,>9f8f,>8c9B
     28DE 93B2 
     28E0 9F8F 
     28E2 8C9B 
0118 28E4 8385             data  >8385,>84b3,>9e89,>8b80
     28E6 84B3 
     28E8 9E89 
     28EA 8B80 
0119 28EC 9692             data  >9692,>86b4,>b795,>8a8D
     28EE 86B4 
     28F0 B795 
     28F2 8A8D 
0120 28F4 8294             data  >8294,>87b5,>b698,>888E
     28F6 87B5 
     28F8 B698 
     28FA 888E 
0121 28FC 9A91             data  >9a91,>81b1,>b090,>9cBB
     28FE 81B1 
     2900 B090 
     2902 9CBB 
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
0023 2904 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2906 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2908 8340 
0025 290A 04E0  34         clr   @waux1
     290C 833C 
0026 290E 04E0  34         clr   @waux2
     2910 833E 
0027 2912 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2914 833C 
0028 2916 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2918 0205  20         li    tmp1,4                ; 4 nibbles
     291A 0004 
0033 291C C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 291E 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2920 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2922 0286  22         ci    tmp2,>000a
     2924 000A 
0039 2926 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2928 C21B  26         mov   *r11,tmp4
0045 292A 0988  56         srl   tmp4,8                ; Right justify
0046 292C 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     292E FFF6 
0047 2930 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2932 C21B  26         mov   *r11,tmp4
0054 2934 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2936 00FF 
0055               
0056 2938 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 293A 06C6  14         swpb  tmp2
0058 293C DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 293E 0944  56         srl   tmp0,4                ; Next nibble
0060 2940 0605  14         dec   tmp1
0061 2942 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2944 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2946 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2948 C160  34         mov   @waux3,tmp1           ; Get pointer
     294A 8340 
0067 294C 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 294E 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2950 C120  34         mov   @waux2,tmp0
     2952 833E 
0070 2954 06C4  14         swpb  tmp0
0071 2956 DD44  32         movb  tmp0,*tmp1+
0072 2958 06C4  14         swpb  tmp0
0073 295A DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 295C C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     295E 8340 
0078 2960 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2962 2020 
0079 2964 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2966 C120  34         mov   @waux1,tmp0
     2968 833C 
0084 296A 06C4  14         swpb  tmp0
0085 296C DD44  32         movb  tmp0,*tmp1+
0086 296E 06C4  14         swpb  tmp0
0087 2970 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2972 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2974 202A 
0092 2976 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2978 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 297A 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     297C 7FFF 
0098 297E C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2980 8340 
0099 2982 0460  28         b     @xutst0               ; Display string
     2984 242A 
0100 2986 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2988 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     298A 832A 
0122 298C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     298E 8000 
0123 2990 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 2992 0207  20 mknum   li    tmp3,5                ; Digit counter
     2994 0005 
0020 2996 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 2998 C155  26         mov   *tmp1,tmp1            ; /
0022 299A C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 299C 0228  22         ai    tmp4,4                ; Get end of buffer
     299E 0004 
0024 29A0 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29A2 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29A4 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29A6 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29A8 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29AA B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29AC D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29AE C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29B0 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29B2 0607  14         dec   tmp3                  ; Decrease counter
0036 29B4 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29B6 0207  20         li    tmp3,4                ; Check first 4 digits
     29B8 0004 
0041 29BA 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29BC C11B  26         mov   *r11,tmp0
0043 29BE 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29C0 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29C2 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29C4 05CB  14 mknum3  inct  r11
0047 29C6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29C8 202A 
0048 29CA 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29CC 045B  20         b     *r11                  ; Exit
0050 29CE DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29D0 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29D2 13F8  14         jeq   mknum3                ; Yes, exit
0053 29D4 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29D6 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29D8 7FFF 
0058 29DA C10B  18         mov   r11,tmp0
0059 29DC 0224  22         ai    tmp0,-4
     29DE FFFC 
0060 29E0 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29E2 0206  20         li    tmp2,>0500            ; String length = 5
     29E4 0500 
0062 29E6 0460  28         b     @xutstr               ; Display string
     29E8 242C 
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
0092 29EA C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 29EC C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 29EE C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 29F0 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 29F2 0207  20         li    tmp3,5                ; Set counter
     29F4 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 29F6 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 29F8 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 29FA 0584  14         inc   tmp0                  ; Next character
0104 29FC 0607  14         dec   tmp3                  ; Last digit reached ?
0105 29FE 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 2A00 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 2A02 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 2A04 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 2A06 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 2A08 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 2A0A 0607  14         dec   tmp3                  ; Last character ?
0120 2A0C 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 2A0E 045B  20         b     *r11                  ; Return
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
0138 2A10 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A12 832A 
0139 2A14 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A16 8000 
0140 2A18 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A1A 0649  14         dect  stack
0023 2A1C C64B  30         mov   r11,*stack            ; Save return address
0024 2A1E 0649  14         dect  stack
0025 2A20 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A22 0649  14         dect  stack
0027 2A24 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A26 0649  14         dect  stack
0029 2A28 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A2A 0649  14         dect  stack
0031 2A2C C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A2E C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A30 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A32 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A34 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A36 0649  14         dect  stack
0044 2A38 C64B  30         mov   r11,*stack            ; Save return address
0045 2A3A 0649  14         dect  stack
0046 2A3C C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A3E 0649  14         dect  stack
0048 2A40 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A42 0649  14         dect  stack
0050 2A44 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A46 0649  14         dect  stack
0052 2A48 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A4A C1D4  26 !       mov   *tmp0,tmp3
0057 2A4C 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A4E 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A50 00FF 
0059 2A52 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A54 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A56 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A58 0584  14         inc   tmp0                  ; Next byte
0067 2A5A 0607  14         dec   tmp3                  ; Shorten string length
0068 2A5C 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A5E 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A60 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A62 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A64 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A66 C187  18         mov   tmp3,tmp2
0078 2A68 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A6A DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A6C 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A6E 24A2 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A70 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A72 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A74 FFCE 
0090 2A76 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A78 2030 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A7A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2A7C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2A7E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2A80 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2A82 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2A84 045B  20         b     *r11                  ; Return to caller
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
0123 2A86 0649  14         dect  stack
0124 2A88 C64B  30         mov   r11,*stack            ; Save return address
0125 2A8A 05D9  26         inct  *stack                ; Skip "data P0"
0126 2A8C 05D9  26         inct  *stack                ; Skip "data P1"
0127 2A8E 0649  14         dect  stack
0128 2A90 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2A92 0649  14         dect  stack
0130 2A94 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2A96 0649  14         dect  stack
0132 2A98 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2A9A C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2A9C C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2A9E 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AA0 0649  14         dect  stack
0144 2AA2 C64B  30         mov   r11,*stack            ; Save return address
0145 2AA4 0649  14         dect  stack
0146 2AA6 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AA8 0649  14         dect  stack
0148 2AAA C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AAC 0649  14         dect  stack
0150 2AAE C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AB0 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AB2 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AB4 0586  14         inc   tmp2
0161 2AB6 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2AB8 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Sanity check on string length
0165                       ;-----------------------------------------------------------------------
0166 2ABA 0286  22         ci    tmp2,255
     2ABC 00FF 
0167 2ABE 1505  14         jgt   string.getlenc.panic
0168 2AC0 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2AC2 0606  14         dec   tmp2                  ; One time adjustment
0174 2AC4 C806  38         mov   tmp2,@waux1           ; Store length
     2AC6 833C 
0175 2AC8 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2ACA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2ACC FFCE 
0181 2ACE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AD0 2030 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2AD2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2AD4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AD6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AD8 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2ADA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0207               
0211               
0216               
0218                       copy  "file.equ"                 ; File I/O equates
**** **** ****     > file.equ
0001               * FILE......: file.equ
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
0043               ***************************************************************
0044      0000     io.seq.upd.dis.fix  equ :00000
0045      0001     io.rel.upd.dis.fix  equ :00001
0046      0003     io.rel.out.dis.fix  equ :00011
0047      0002     io.seq.out.dis.fix  equ :00010
0048      0004     io.seq.inp.dis.fix  equ :00100
0049      0005     io.rel.inp.dis.fix  equ :00101
0050      0006     io.seq.app.dis.fix  equ :00110
0051      0007     io.rel.app.dis.fix  equ :00111
0052      0008     io.seq.upd.int.fix  equ :01000
0053      0009     io.rel.upd.int.fix  equ :01001
0054      000A     io.seq.out.int.fix  equ :01010
0055      000B     io.rel.out.int.fix  equ :01011
0056      000C     io.seq.inp.int.fix  equ :01100
0057      000D     io.rel.inp.int.fix  equ :01101
0058      000E     io.seq.app.int.fix  equ :01110
0059      000F     io.rel.app.int.fix  equ :01111
0060      0010     io.seq.upd.dis.var  equ :10000
0061      0011     io.rel.upd.dis.var  equ :10001
0062      0012     io.seq.out.dis.var  equ :10010
0063      0013     io.rel.out.dis.var  equ :10011
0064      0014     io.seq.inp.dis.var  equ :10100
0065      0015     io.rel.inp.dis.var  equ :10101
0066      0016     io.seq.app.dis.var  equ :10110
0067      0017     io.rel.app.dis.var  equ :10111
0068      0018     io.seq.upd.int.var  equ :11000
0069      0019     io.rel.upd.int.var  equ :11001
0070      001A     io.seq.out.int.var  equ :11010
0071      001B     io.rel.out.int.var  equ :11011
0072      001C     io.seq.inp.int.var  equ :11100
0073      001D     io.rel.inp.int.var  equ :11101
0074      001E     io.seq.app.int.var  equ :11110
0075      001F     io.rel.app.int.var  equ :11111
0076               ***************************************************************
0077               * File error codes - Byte 1 in PAB (Bits 5-7)
0078               ************************************@**************************
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
0219                       copy  "file_dsrlnk.asm"          ; DSRLNK for peripheral communication
**** **** ****     > file_dsrlnk.asm
0001               * FILE......: file_dsrlnk.asm
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
0220                       copy  "file_level3.asm"          ; File I/O level 3 support
**** **** ****     > file_level3.asm
0001               * FILE......: file_level3.asm
0002               * Purpose...: File I/O level 3 support
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
0040               *  tmp0 LSB = VDP PAB byte 1 (status)
0041               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0042               *  tmp2     = Status register contents upon DSRLNK return
0043               ********|*****|*********************|**************************
0044               file.open:
0045 2BF2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2BF4 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047 2BF6 C08B  18         mov   r11,r2                ; Save return address
0048               *--------------------------------------------------------------
0049               * Initialisation
0050               *--------------------------------------------------------------
0051               xfile.open:
0052 2BF8 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2BFA A43E 
0053 2BFC 04C5  14         clr   tmp1                  ; io.op.open
0054 2BFE 101C  14         jmp   _file.record.fop      ; Do file operation
0055               
0056               
0057               
0058               ***************************************************************
0059               * file.close - Close currently open file
0060               ***************************************************************
0061               *  bl   @file.close
0062               *       data P0
0063               *--------------------------------------------------------------
0064               *  P0 = Address of PAB in VDP RAM
0065               *--------------------------------------------------------------
0066               *  bl   @xfile.close
0067               *
0068               *  R0 = Address of PAB in VDP RAM
0069               *--------------------------------------------------------------
0070               *  Output:
0071               *  tmp0 LSB = VDP PAB byte 1 (status)
0072               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0073               *  tmp2     = Status register contents upon DSRLNK return
0074               ********|*****|*********************|**************************
0075               file.close:
0076 2C00 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0077 2C02 C08B  18         mov   r11,r2                ; Save return address
0078               *--------------------------------------------------------------
0079               * Initialisation
0080               *--------------------------------------------------------------
0081               xfile.close:
0082 2C04 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C06 0001 
0083 2C08 1017  14         jmp   _file.record.fop      ; Do file operation
0084               
0085               
0086               ***************************************************************
0087               * file.record.read - Read record from file
0088               ***************************************************************
0089               *  bl   @file.record.read
0090               *       data P0
0091               *--------------------------------------------------------------
0092               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0093               *--------------------------------------------------------------
0094               *  bl   @xfile.record.read
0095               *
0096               *  R0 = Address of PAB in VDP RAM
0097               *--------------------------------------------------------------
0098               *  Output:
0099               *  tmp0 LSB = VDP PAB byte 1 (status)
0100               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0101               *  tmp2     = Status register contents upon DSRLNK return
0102               ********|*****|*********************|**************************
0103               file.record.read:
0104 2C0A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0105 2C0C C08B  18         mov   r11,r2                ; Save return address
0106               *--------------------------------------------------------------
0107               * Initialisation
0108               *--------------------------------------------------------------
0109 2C0E 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C10 0002 
0110 2C12 1012  14         jmp   _file.record.fop      ; Do file operation
0111               
0112               
0113               
0114               ***************************************************************
0115               * file.record.write - Write record to file
0116               ***************************************************************
0117               *  bl   @file.record.write
0118               *       data P0
0119               *--------------------------------------------------------------
0120               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0121               *--------------------------------------------------------------
0122               *  bl   @xfile.record.write
0123               *
0124               *  R0 = Address of PAB in VDP RAM
0125               *--------------------------------------------------------------
0126               *  Output:
0127               *  tmp0 LSB = VDP PAB byte 1 (status)
0128               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0129               *  tmp2     = Status register contents upon DSRLNK return
0130               ********|*****|*********************|**************************
0131               file.record.write:
0132 2C14 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0133 2C16 C08B  18         mov   r11,r2                ; Save return address
0134               *--------------------------------------------------------------
0135               * Initialisation
0136               *--------------------------------------------------------------
0137 2C18 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0138 2C1A 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2C1C 0005 
0139               
0140 2C1E C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2C20 A430 
0141               
0142 2C22 06A0  32         bl    @xvputb               ; Write character count to PAB
     2C24 22D6 
0143                                                   ; \ i  tmp0 = VDP target address
0144                                                   ; / i  tmp1 = Byte to write
0145               
0146 2C26 0205  20         li    tmp1,io.op.write      ; io.op.write
     2C28 0003 
0147 2C2A 1006  14         jmp   _file.record.fop      ; Do file operation
0148               
0149               
0150               
0151               file.record.seek:
0152 2C2C 1000  14         nop
0153               
0154               
0155               file.image.load:
0156 2C2E 1000  14         nop
0157               
0158               
0159               file.image.save:
0160 2C30 1000  14         nop
0161               
0162               
0163               file.delete:
0164 2C32 1000  14         nop
0165               
0166               
0167               file.rename:
0168 2C34 1000  14         nop
0169               
0170               
0171               file.status:
0172 2C36 1000  14         nop
0173               
0174               
0175               
0176               ***************************************************************
0177               * file.record.fop - File operation
0178               ***************************************************************
0179               * Called internally via JMP/B by file operations
0180               *--------------------------------------------------------------
0181               *  Input:
0182               *  r0   = Address of PAB in VDP RAM
0183               *  r1   = File type/mode
0184               *  tmp1 = File operation opcode
0185               *--------------------------------------------------------------
0186               *  Output:
0187               *  tmp2 = Saved status register
0188               *--------------------------------------------------------------
0189               *  Register usage:
0190               *  r0, r1, r2, tmp0, tmp1, tmp2
0191               *--------------------------------------------------------------
0192               *  Remarks
0193               *  Private, only to be called from inside fio_level2 module
0194               *  via jump or branch instruction.
0195               *
0196               *  Uses @waux1 for backup/restore of memory word @>8322
0197               ********|*****|*********************|**************************
0198               _file.record.fop:
0199                       ;------------------------------------------------------
0200                       ; Write to PAB required?
0201                       ;------------------------------------------------------
0202 2C38 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C3A A428 
0203                       ;------------------------------------------------------
0204                       ; Set file opcode in VDP PAB
0205                       ;------------------------------------------------------
0206 2C3C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0207               
0208 2C3E 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C40 22D6 
0209                                                   ; \ i  tmp0 = VDP target address
0210                                                   ; / i  tmp1 = Byte to write
0211                       ;------------------------------------------------------
0212                       ; Set file type/mode in VDP PAB
0213                       ;------------------------------------------------------
0214 2C42 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0215 2C44 0584  14         inc   tmp0                  ; Next byte in PAB
0216 2C46 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2C48 A43E 
0217               
0218 2C4A 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2C4C 22D6 
0219                                                   ; \ i  tmp0 = VDP target address
0220                                                   ; / i  tmp1 = Byte to write
0221                       ;------------------------------------------------------
0222                       ; Prepare for DSRLINK
0223                       ;------------------------------------------------------
0224 2C4E 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2C50 0009 
0225 2C52 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C54 8356 
0226               *--------------------------------------------------------------
0227               * Call DSRLINK for doing file operation
0228               *--------------------------------------------------------------
0229 2C56 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2C58 8322 
     2C5A 833C 
0230               
0231 2C5C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C5E 2ADC 
0232 2C60 0008             data  8                     ;
0233               *--------------------------------------------------------------
0234               * Return PAB details to caller
0235               *--------------------------------------------------------------
0236               _file.record.fop.pab:
0237 2C62 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0238                                                   ; Upon DSRLNK return status register EQ bit
0239                                                   ; 1 = No file error
0240                                                   ; 0 = File error occured
0241               
0242 2C64 C820  54         mov   @waux1,@>8322         ; Restore word at @>83223
     2C66 833C 
     2C68 8322 
0243               *--------------------------------------------------------------
0244               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0245               *--------------------------------------------------------------
0246 2C6A C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2C6C A428 
0247 2C6E 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2C70 0005 
0248 2C72 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2C74 22EE 
0249 2C76 C144  18         mov   tmp0,tmp1             ; Move to destination
0250               *--------------------------------------------------------------
0251               * Get PAB byte 1 from VDP ram into tmp0 (status)
0252               *--------------------------------------------------------------
0253 2C78 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0254                                                   ; as returned by DSRLNK
0255               *--------------------------------------------------------------
0256               * Exit
0257               *--------------------------------------------------------------
0258               ; If an error occured during the IO operation, then the
0259               ; equal bit in the saved status register (=tmp2) is set to 1.
0260               ;
0261               ; Upon return from this IO call you should basically test with:
0262               ;       coc   @wbit2,tmp2           ; Equal bit set?
0263               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0264               ;
0265               ; Then look for further details in the copy of VDP PAB byte 1
0266               ; in register tmp0, bits 13-15
0267               ;
0268               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0269               ;                                   ; calls, skip for type >A subprograms!)
0270               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0271               ;       jeq   my_error_handler
0272               *--------------------------------------------------------------
0273               _file.record.fop.exit:
0274 2C7A 0452  20         b     *r2                   ; Return to caller
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
0020 2C7C 0300  24 tmgr    limi  0                     ; No interrupt processing
     2C7E 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2C80 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2C82 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2C84 2360  38         coc   @wbit2,r13            ; C flag on ?
     2C86 2026 
0029 2C88 1602  14         jne   tmgr1a                ; No, so move on
0030 2C8A E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2C8C 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2C8E 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2C90 202A 
0035 2C92 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2C94 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2C96 201A 
0048 2C98 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2C9A 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2C9C 2018 
0050 2C9E 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2CA0 0460  28         b     @kthread              ; Run kernel thread
     2CA2 2D1A 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2CA4 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2CA6 201E 
0056 2CA8 13EB  14         jeq   tmgr1
0057 2CAA 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2CAC 201C 
0058 2CAE 16E8  14         jne   tmgr1
0059 2CB0 C120  34         mov   @wtiusr,tmp0
     2CB2 832E 
0060 2CB4 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2CB6 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2CB8 2D18 
0065 2CBA C10A  18         mov   r10,tmp0
0066 2CBC 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2CBE 00FF 
0067 2CC0 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2CC2 2026 
0068 2CC4 1303  14         jeq   tmgr5
0069 2CC6 0284  22         ci    tmp0,60               ; 1 second reached ?
     2CC8 003C 
0070 2CCA 1002  14         jmp   tmgr6
0071 2CCC 0284  22 tmgr5   ci    tmp0,50
     2CCE 0032 
0072 2CD0 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2CD2 1001  14         jmp   tmgr8
0074 2CD4 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2CD6 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2CD8 832C 
0079 2CDA 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2CDC FF00 
0080 2CDE C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2CE0 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2CE2 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2CE4 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2CE6 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2CE8 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2CEA 830C 
     2CEC 830D 
0089 2CEE 1608  14         jne   tmgr10                ; No, get next slot
0090 2CF0 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2CF2 FF00 
0091 2CF4 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2CF6 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2CF8 8330 
0096 2CFA 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2CFC C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2CFE 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D00 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D02 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D04 8315 
     2D06 8314 
0103 2D08 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D0A 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D0C 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D0E 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2D10 10F7  14         jmp   tmgr10                ; Process next slot
0108 2D12 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2D14 FF00 
0109 2D16 10B4  14         jmp   tmgr1
0110 2D18 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2D1A E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2D1C 201A 
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
0041 2D1E 06A0  32         bl    @realkb               ; Scan full keyboard
     2D20 27AC 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2D22 0460  28         b     @tmgr3                ; Exit
     2D24 2CA4 
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
0017 2D26 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2D28 832E 
0018 2D2A E0A0  34         soc   @wbit7,config         ; Enable user hook
     2D2C 201C 
0019 2D2E 045B  20 mkhoo1  b     *r11                  ; Return
0020      2C80     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2D30 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2D32 832E 
0029 2D34 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2D36 FEFF 
0030 2D38 045B  20         b     *r11                  ; Return
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
0017 2D3A C13B  30 mkslot  mov   *r11+,tmp0
0018 2D3C C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2D3E C184  18         mov   tmp0,tmp2
0023 2D40 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2D42 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2D44 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2D46 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2D48 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2D4A C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2D4C 881B  46         c     *r11,@w$ffff          ; End of list ?
     2D4E 202C 
0035 2D50 1301  14         jeq   mkslo1                ; Yes, exit
0036 2D52 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2D54 05CB  14 mkslo1  inct  r11
0041 2D56 045B  20         b     *r11                  ; Exit
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
0052 2D58 C13B  30 clslot  mov   *r11+,tmp0
0053 2D5A 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2D5C A120  34         a     @wtitab,tmp0          ; Add table base
     2D5E 832C 
0055 2D60 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2D62 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2D64 045B  20         b     *r11                  ; Exit
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
0068 2D66 C13B  30 rsslot  mov   *r11+,tmp0
0069 2D68 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2D6A A120  34         a     @wtitab,tmp0          ; Add table base
     2D6C 832C 
0071 2D6E 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2D70 C154  26         mov   *tmp0,tmp1
0073 2D72 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2D74 FF00 
0074 2D76 C505  30         mov   tmp1,*tmp0
0075 2D78 045B  20         b     *r11                  ; Exit
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
0260 2D7A 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2D7C 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2D7E 0300  24 runli1  limi  0                     ; Turn off interrupts
     2D80 0000 
0266 2D82 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2D84 8300 
0267 2D86 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2D88 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2D8A 0202  20 runli2  li    r2,>8308
     2D8C 8308 
0272 2D8E 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2D90 0282  22         ci    r2,>8400
     2D92 8400 
0274 2D94 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2D96 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2D98 FFFF 
0279 2D9A 1602  14         jne   runli4                ; No, continue
0280 2D9C 0420  54         blwp  @0                    ; Yes, bye bye
     2D9E 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2DA0 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2DA2 833C 
0285 2DA4 04C1  14         clr   r1                    ; Reset counter
0286 2DA6 0202  20         li    r2,10                 ; We test 10 times
     2DA8 000A 
0287 2DAA C0E0  34 runli5  mov   @vdps,r3
     2DAC 8802 
0288 2DAE 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2DB0 202A 
0289 2DB2 1302  14         jeq   runli6
0290 2DB4 0581  14         inc   r1                    ; Increase counter
0291 2DB6 10F9  14         jmp   runli5
0292 2DB8 0602  14 runli6  dec   r2                    ; Next test
0293 2DBA 16F7  14         jne   runli5
0294 2DBC 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2DBE 1250 
0295 2DC0 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2DC2 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2DC4 2026 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2DC6 06A0  32 runli7  bl    @loadmc
     2DC8 2224 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2DCA 04C1  14 runli9  clr   r1
0305 2DCC 04C2  14         clr   r2
0306 2DCE 04C3  14         clr   r3
0307 2DD0 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2DD2 3000 
0308 2DD4 020F  20         li    r15,vdpw              ; Set VDP write address
     2DD6 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2DD8 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2DDA 4A4A 
0317 2DDC 1605  14         jne   runlia
0318 2DDE 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2DE0 2298 
0319 2DE2 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2DE4 0000 
     2DE6 3FFF 
0324 2DE8 06A0  32 runlia  bl    @filv
     2DEA 2298 
0325 2DEC 0FC0             data  pctadr,spfclr,16      ; Load color table
     2DEE 00F4 
     2DF0 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2DF2 06A0  32         bl    @f18unl               ; Unlock the F18A
     2DF4 26F4 
0333 2DF6 06A0  32         bl    @f18chk               ; Check if F18A is there
     2DF8 270E 
0334 2DFA 06A0  32         bl    @f18lck               ; Lock the F18A again
     2DFC 2704 
0335               
0336 2DFE 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E00 233C 
0337 2E02 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2E04 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E06 2302 
0351 2E08 3008             data  spvmod                ; Equate selected video mode table
0352 2E0A 0204  20         li    tmp0,spfont           ; Get font option
     2E0C 000C 
0353 2E0E 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2E10 1304  14         jeq   runlid                ; Yes, skip it
0355 2E12 06A0  32         bl    @ldfnt
     2E14 236A 
0356 2E16 1100             data  fntadr,spfont         ; Load specified font
     2E18 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2E1A 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2E1C 4A4A 
0361 2E1E 1602  14         jne   runlie                ; No, continue
0362 2E20 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2E22 2090 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2E24 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2E26 0040 
0367 2E28 0460  28         b     @main                 ; Give control to main program
     2E2A 6036 
**** **** ****     > stevie_b1.asm.24929
0057                                                   ; Relocated spectra2 in low MEMEXP, was
0058                                                   ; copied to >2000 from ROM in bank 0
0059                       ;------------------------------------------------------
0060                       ; End of File marker
0061                       ;------------------------------------------------------
0062 2E2C DEAD             data >dead,>beef,>dead,>beef
     2E2E BEEF 
     2E30 DEAD 
     2E32 BEEF 
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
**** **** ****     > stevie_b1.asm.24929
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
0081               txt.alpha.up
0082 311E 0241             byte  2
0083 311F ....             text  'AU'
0084                       even
0085               
0086               txt.alpha.down
0087 3122 0241             byte  2
0088 3123 ....             text  'AD'
0089                       even
0090               
0091               
0092               
0093               ;--------------------------------------------------------------
0094               ; Dialog Load DV 80 file
0095               ;--------------------------------------------------------------
0096               txt.head.load
0097 3126 0E4C             byte  14
0098 3127 ....             text  'Load DV80 file'
0099                       even
0100               
0101               txt.hint.load
0102 3136 3448             byte  52
0103 3137 ....             text  'HINT: Specify filename and press ENTER to load file.'
0104                       even
0105               
0106               txt.keys.load
0107 316C 4246             byte  66
0108 316D ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End    ^,=Previous    ^.=Next'
0109                       even
0110               
0111               
0112               ;--------------------------------------------------------------
0113               ; Dialog Save DV 80 file
0114               ;--------------------------------------------------------------
0115               txt.head.save
0116 31B0 0E53             byte  14
0117 31B1 ....             text  'Save DV80 file'
0118                       even
0119               
0120               txt.hint.save
0121 31C0 3448             byte  52
0122 31C1 ....             text  'HINT: Specify filename and press ENTER to save file.'
0123                       even
0124               
0125               txt.keys.save
0126 31F6 2846             byte  40
0127 31F7 ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End'
0128                       even
0129               
0130               
0131               ;--------------------------------------------------------------
0132               ; Dialog "Unsaved changes"
0133               ;--------------------------------------------------------------
0134               txt.head.unsaved
0135 3220 0F55             byte  15
0136 3221 ....             text  'Unsaved changes'
0137                       even
0138               
0139               txt.hint.unsaved
0140 3230 2748             byte  39
0141 3231 ....             text  'HINT: Unsaved changes in editor buffer.'
0142                       even
0143               
0144               txt.keys.unsaved
0145 3258 2B46             byte  43
0146 3259 ....             text  'F9=Back    F6=Proceed anyway   ^K=Save file'
0147                       even
0148               
0149               
0150               
0151               
0152               ;--------------------------------------------------------------
0153               ; Strings for error line pane
0154               ;--------------------------------------------------------------
0155               txt.ioerr.load
0156 3284 2049             byte  32
0157 3285 ....             text  'I/O error. Failed loading file: '
0158                       even
0159               
0160               txt.ioerr.save
0161 32A6 1F49             byte  31
0162 32A7 ....             text  'I/O error. Failed saving file: '
0163                       even
0164               
0165               txt.io.nofile
0166 32C6 2149             byte  33
0167 32C7 ....             text  'I/O error. No filename specified.'
0168                       even
0169               
0170               
0171               
0172               ;--------------------------------------------------------------
0173               ; Strings for command buffer
0174               ;--------------------------------------------------------------
0175               txt.cmdb.title
0176 32E8 0E43             byte  14
0177 32E9 ....             text  'Command buffer'
0178                       even
0179               
0180               txt.cmdb.prompt
0181 32F8 013E             byte  1
0182 32F9 ....             text  '>'
0183                       even
0184               
0185               
0186 32FA 4201     txt.cmdb.hbar      byte    66
0187 32FC 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     32FE 0101 
     3300 0101 
     3302 0101 
     3304 0101 
     3306 0101 
     3308 0101 
     330A 0101 
     330C 0101 
     330E 0101 
0188 3310 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     3312 0101 
     3314 0101 
     3316 0101 
     3318 0101 
     331A 0101 
     331C 0101 
     331E 0101 
     3320 0101 
     3322 0101 
0189 3324 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     3326 0101 
     3328 0101 
     332A 0101 
     332C 0101 
     332E 0101 
     3330 0101 
     3332 0101 
     3334 0101 
     3336 0101 
0190 3338 0101                        byte    1,1,1,1,1,1
     333A 0101 
     333C 0100 
0191                                  even
0192               
0193               
0194               
0195 333E 0C0A     txt.stevie         byte    12
0196                                  byte    10
0197 3340 ....                        text    'stevie v1.00'
0198 334C 0B00                        byte    11
0199                                  even
0200               
0201               txt.colorscheme
0202 334E 0E43             byte  14
0203 334F ....             text  'COLOR SCHEME: '
0204                       even
0205               
0206               
0207               
0208               ;--------------------------------------------------------------
0209               ; Strings for filenames
0210               ;--------------------------------------------------------------
0211               fdname1
0212 335E 0850             byte  8
0213 335F ....             text  'PI.CLOCK'
0214                       even
0215               
0216               fdname2
0217 3368 0E54             byte  14
0218 3369 ....             text  'TIPI.TIVI.NR80'
0219                       even
0220               
0221               fdname3
0222 3378 0C44             byte  12
0223 3379 ....             text  'DSK1.XBEADOC'
0224                       even
0225               
0226               fdname4
0227 3386 1154             byte  17
0228 3387 ....             text  'TIPI.TIVI.C99MAN1'
0229                       even
0230               
0231               fdname5
0232 3398 1154             byte  17
0233 3399 ....             text  'TIPI.TIVI.C99MAN2'
0234                       even
0235               
0236               fdname6
0237 33AA 1154             byte  17
0238 33AB ....             text  'TIPI.TIVI.C99MAN3'
0239                       even
0240               
0241               fdname7
0242 33BC 1254             byte  18
0243 33BD ....             text  'TIPI.TIVI.C99SPECS'
0244                       even
0245               
0246               fdname8
0247 33D0 1254             byte  18
0248 33D1 ....             text  'TIPI.TIVI.RANDOM#C'
0249                       even
0250               
0251               fdname9
0252 33E4 0D44             byte  13
0253 33E5 ....             text  'DSK1.INVADERS'
0254                       even
0255               
0256               fdname0
0257 33F2 0944             byte  9
0258 33F3 ....             text  'DSK1.NR80'
0259                       even
0260               
0261               fdname.clock
0262 33FC 0850             byte  8
0263 33FD ....             text  'PI.CLOCK'
0264                       even
0265               
**** **** ****     > stevie_b1.asm.24929
0078                       ;------------------------------------------------------
0079                       ; End of File marker
0080                       ;------------------------------------------------------
0081 3406 DEAD             data  >dead,>beef,>dead,>beef
     3408 BEEF 
     340A DEAD 
     340C BEEF 
0083               ***************************************************************
0084               * Step 4: Include main editor modules
0085               ********|*****|*********************|**************************
0086               main:
0087                       aorg  kickstart.code2       ; >6036
0088 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0089                       ;-----------------------------------------------------------------------
0090                       ; Include files
0091                       ;-----------------------------------------------------------------------
0092                       copy  "main.asm"            ; Main file (entrypoint)
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
     6046 2650 
0042               
0043 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 26F4 
0044 604C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     604E 233C 
0045 6050 3140                   data >3140            ; F18a VR49 (>31), bit 40
0046               
0047 6052 06A0  32         bl    @putvr                ; Turn on position based attributes
     6054 233C 
0048 6056 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6058 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     605A 233C 
0051 605C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 605E 06A0  32         bl    @filv
     6060 2298 
0056 6062 0000                   data >0000,32,30*80   ; Clear screen
     6064 0020 
     6066 0960 
0057                       ;------------------------------------------------------
0058                       ; Initialize high memory expansion
0059                       ;------------------------------------------------------
0060 6068 06A0  32         bl    @film
     606A 2240 
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
     6078 2670 
0070 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 2680 
0071               
0072 607E 06A0  32         bl    @cpym2m
     6080 249C 
0073 6082 3012                   data romsat,ramsat,4  ; Load sprite SAT
     6084 2F50 
     6086 0004 
0074               
0075 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 3014 
     608C A014 
0076                                                   ; Save cursor shape & color
0077               
0078 608E 06A0  32         bl    @cpym2v
     6090 2454 
0079 6092 2800                   data sprpdt,cursors,3*8
     6094 3016 
     6096 0018 
0080                                                   ; Load sprite cursor patterns
0081               
0082 6098 06A0  32         bl    @cpym2v
     609A 2454 
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
     60AC 76CE 
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
     60B8 2690 
0102 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0103               
0104 60BC 0204  20         li    tmp0,timers
     60BE 2F40 
0105 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0106               
0107 60C4 06A0  32         bl    @mkslot
     60C6 2D3A 
0108 60C8 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 74B6 
0109 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60CE 754E 
0110 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60D2 7582 
0111 60D4 032F                   data >032f,task.oneshot      ; Task 3 - One shot task
     60D6 75D0 
0112 60D8 FFFF                   data eol
0113               
0114 60DA 06A0  32         bl    @mkhook
     60DC 2D26 
0115 60DE 7486                   data hook.keyscan     ; Setup user hook
0116               
0117 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2C7C 
**** **** ****     > stevie_b1.asm.24929
0093               
0094                       ;-----------------------------------------------------------------------
0095                       ; Keyboard actions
0096                       ;-----------------------------------------------------------------------
0097                       copy  "edkey.asm"           ; Keyboard actions
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
     6108 7DB6 
0033 610A 1003  14         jmp   edkey.key.check_next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 610C 0206  20         li    tmp2,keymap_actions.cmdb
     610E 7E84 
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
**** **** ****     > stevie_b1.asm.24929
0098                       copy  "edkey.fb.mov.asm"    ; fb pane   - Actions for movement keys
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
     6158 74AA 
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
     6170 74AA 
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
     6192 2F20 
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
     61A0 269E 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 61A2 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61A4 6DB8 
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
     61BA 26A8 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 61BC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61BE 6880 
0093 61C0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61C2 74AA 
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
     61FA 2F20 
0133 61FC 05A0  34         inc   @parm1
     61FE 2F20 
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
     620C 2696 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 620E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6210 6DB8 
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
     6226 26A8 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6228 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     622A 6880 
0162 622C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     622E 74AA 
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
     6246 74AA 
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
     6252 26A8 
0184 6254 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6256 6880 
0185 6258 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     625A 74AA 
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
     62A4 26A8 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 62A6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62A8 6880 
0253 62AA 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62AC 74AA 
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
     6304 26A8 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 6306 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6308 6880 
0336 630A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     630C 74AA 
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
     633A 2F20 
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
     637A 74AA 
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
     6392 2F20 
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
     63A6 74AA 
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
     63CE 2F20 
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
     63E6 74AA 
**** **** ****     > stevie_b1.asm.24929
0099                       copy  "edkey.fb.mod.asm"    ; fb pane   - Actions for modifier keys
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
     641E 74AA 
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
     6452 74AA 
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
     6472 2F20 
0106 6474 A820  54         a     @fb.row,@parm1        ; Line number to remove
     6476 A106 
     6478 2F20 
0107 647A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     647C A204 
     647E 2F22 
0108 6480 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     6482 6B04 
0109 6484 0620  34         dec   @edb.lines            ; One line less in editor buffer
     6486 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 6488 C820  54         mov   @fb.topline,@parm1
     648A A104 
     648C 2F20 
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
     64B2 2F20 
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
     64EC 2F20 
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
     6500 74AA 
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
     651E 2F20 
0220 6520 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6522 A106 
     6524 2F20 
0221 6526 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6528 A204 
     652A 2F22 
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
     6538 2F20 
0232 653A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     653C 689C 
0233 653E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6540 A116 
0234                       ;-------------------------------------------------------
0235                       ; Exit
0236                       ;-------------------------------------------------------
0237               edkey.action.ins_line.exit:
0238 6542 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6544 74AA 
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
     6580 2F20 
0282 6582 05A0  34         inc   @parm1
     6584 2F20 
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
     6592 2696 
0291                       ;-------------------------------------------------------
0292                       ; Set VDP cursor and save variables
0293                       ;-------------------------------------------------------
0294               edkey.action.newline.rest:
0295 6594 06A0  32         bl    @fb.get.firstnonblank
     6596 690C 
0296 6598 C120  34         mov   @outparm1,tmp0
     659A 2F30 
0297 659C C804  38         mov   tmp0,@fb.column
     659E A10C 
0298 65A0 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65A2 26A8 
0299 65A4 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65A6 6DB8 
0300 65A8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65AA 6880 
0301 65AC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65AE A116 
0302                       ;-------------------------------------------------------
0303                       ; Exit
0304                       ;-------------------------------------------------------
0305               edkey.action.newline.exit:
0306 65B0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65B2 74AA 
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
     65C2 7582 
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
     65DA 2F20 
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
     65F0 2F20 
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
     6612 74AA 
**** **** ****     > stevie_b1.asm.24929
0100                       copy  "edkey.fb.misc.asm"   ; fb pane   - Miscelanneous actions
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
     6616 2758 
0010 6618 0420  54         blwp  @0                    ; Exit
     661A 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 661C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     661E 74AA 
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
**** **** ****     > stevie_b1.asm.24929
0101                       copy  "edkey.fb.file.asm"   ; fb pane   - File related actions
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.fb.buffer0:
0006 662A 0204  20         li   tmp0,fdname0
     662C 33F2 
0007 662E 101B  14         jmp  _edkey.action.rest
0008               edkey.action.fb.buffer1:
0009 6630 0204  20         li   tmp0,fdname1
     6632 335E 
0010 6634 1018  14         jmp  _edkey.action.rest
0011               edkey.action.fb.buffer2:
0012 6636 0204  20         li   tmp0,fdname2
     6638 3368 
0013 663A 1015  14         jmp  _edkey.action.rest
0014               edkey.action.fb.buffer3:
0015 663C 0204  20         li   tmp0,fdname3
     663E 3378 
0016 6640 1012  14         jmp  _edkey.action.rest
0017               edkey.action.fb.buffer4:
0018 6642 0204  20         li   tmp0,fdname4
     6644 3386 
0019 6646 100F  14         jmp  _edkey.action.rest
0020               edkey.action.fb.buffer5:
0021 6648 0204  20         li   tmp0,fdname5
     664A 3398 
0022 664C 100C  14         jmp  _edkey.action.rest
0023               edkey.action.fb.buffer6:
0024 664E 0204  20         li   tmp0,fdname6
     6650 33AA 
0025 6652 1009  14         jmp  _edkey.action.rest
0026               edkey.action.fb.buffer7:
0027 6654 0204  20         li   tmp0,fdname7
     6656 33BC 
0028 6658 1006  14         jmp  _edkey.action.rest
0029               edkey.action.fb.buffer8:
0030 665A 0204  20         li   tmp0,fdname8
     665C 33D0 
0031 665E 1003  14         jmp  _edkey.action.rest
0032               edkey.action.fb.buffer9:
0033 6660 0204  20         li   tmp0,fdname9
     6662 33E4 
0034 6664 1000  14         jmp  _edkey.action.rest
0035               _edkey.action.rest:
0036 6666 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     6668 721A 
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
     6672 2F20 
0063 6674 0720  34         seto  @parm2                 ; Increase ASCII value of char in suffix
     6676 2F22 
0064               
0065               _edkey.action.fb.fname.doit:
0066                       ;------------------------------------------------------
0067                       ; Update suffix and load file
0068                       ;------------------------------------------------------
0069 6678 06A0  32         bl   @fm.browse.fname.suffix.incdec
     667A 740A 
0070                                                    ; Filename suffix adjust
0071                                                    ; i  \ parm1 = Pointer to filename
0072                                                    ; i  / parm2 = >FFFF or >0000
0073               
0074 667C 0204  20         li    tmp0,heap.top         ; 1st line in heap
     667E E000 
0075 6680 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6682 721A 
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
     668C 2F20 
0086 668E 04E0  34         clr  @parm2                 ; Decrease ASCII value of char in suffix
     6690 2F22 
0087 6692 10F2  14         jmp  _edkey.action.fb.fname.doit
0088               
0089               
0090               _edkey.action.fb.fname.loadfile:
**** **** ****     > stevie_b1.asm.24929
0102                       copy  "edkey.cmdb.mov.asm"  ; cmdb pane - Actions for movement keys
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
     66A4 74AA 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Cursor right
0024               *---------------------------------------------------------------
0025               edkey.action.cmdb.right:
0026 66A6 06A0  32         bl    @cmdb.cmd.getlength
     66A8 6E92 
0027 66AA 8820  54         c     @cmdb.column,@outparm1
     66AC A312 
     66AE 2F30 
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
     66BC 74AA 
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
     66D0 74AA 
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
     66E8 74AA 
**** **** ****     > stevie_b1.asm.24929
0103                       copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
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
     66EC 6E60 
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
     671E 6E92 
0083                                                   ; \ i  @cmdb.cmd = Command string
0084                                                   ; / o  @outparm1 = Length of command
0085                       ;-------------------------------------------------------
0086                       ; Addjust length
0087                       ;-------------------------------------------------------
0088 6720 C120  34         mov   @outparm1,tmp0
     6722 2F30 
0089 6724 0A84  56         sla   tmp0,8               ; LSB to MSB
0090 6726 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6728 A322 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               edkey.action.cmdb.char.exit:
0095 672A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     672C 74AA 
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
     6730 74AA 
**** **** ****     > stevie_b1.asm.24929
0104                       copy  "edkey.cmdb.misc.asm" ; cmdb pane - Miscelanneous actions
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
     673E 7866 
0017 6740 1002  14         jmp   edkey.action.cmdb.toggle.exit
0018                       ;-------------------------------------------------------
0019                       ; Hide pane
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.hide:
0022 6742 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6744 78B2 
0023                       ;-------------------------------------------------------
0024                       ; Exit
0025                       ;-------------------------------------------------------
0026               edkey.action.cmdb.toggle.exit:
0027 6746 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6748 74AA 
0028               
0029               
0030               
**** **** ****     > stevie_b1.asm.24929
0105                       copy  "edkey.cmdb.file.asm" ; cmdb pane - File related actions
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
     674C 78B2 
0013               
0014 674E 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6750 6E92 
0015 6752 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6754 2F30 
0016 6756 1607  14         jne   !                     ; No, prepare for load/save
0017                       ;-------------------------------------------------------
0018                       ; No filename specified
0019                       ;-------------------------------------------------------
0020 6758 06A0  32         bl    @pane.errline.show    ; Show error line
     675A 78F0 
0021               
0022 675C 06A0  32         bl    @pane.show_hint
     675E 7632 
0023 6760 1C00                   byte 28,0
0024 6762 32C6                   data txt.io.nofile
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
     676E 249C 
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
     678C 721A 
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
     6796 72A0 
0058                                                   ; \ i  tmp0 = Pointer to length-prefixed
0059                                                   ; /           device/filename string
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.cmdb.loadsave.exit:
0064 6798 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     679A 637C 
**** **** ****     > stevie_b1.asm.24929
0106                       ;-----------------------------------------------------------------------
0107                       ; Logic for Memory, Framebuffer, Index, Editor buffer, Error line
0108                       ;-----------------------------------------------------------------------
0109                       copy  "tv.asm"              ; Main editor configuration
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
     67B8 6DD6 
0070 67BA 06A0  32         bl    @edb.init             ; Initialize editor buffer
     67BC 6BE6 
0071 67BE 06A0  32         bl    @idx.init             ; Initialize index
     67C0 6954 
0072 67C2 06A0  32         bl    @fb.init              ; Initialize framebuffer
     67C4 682A 
0073 67C6 06A0  32         bl    @errline.init         ; Initialize error line
     67C8 6EC0 
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077               tv.reset.exit:
0078 67CA C2F9  30         mov   *stack+,r11           ; Pop R11
0079 67CC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0110                       copy  "mem.asm"             ; Memory Management
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
     67D4 25A4 
0027 67D6 3086                   data mem.sams.layout.data
0028               
0029 67D8 06A0  32         bl    @sams.layout.copy
     67DA 2608 
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
     680A 2F32 
0093 680C C160  34         mov   @outparm1,tmp1        ; Pointer to line
     680E 2F30 
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
     681A 2538 
0107                                                   ; \ i  tmp0 = SAMS page
0108                                                   ; / i  tmp1 = Memory address
0109               
0110 681C C820  54         mov   @outparm2,@tv.sams.c000
     681E 2F32 
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
**** **** ****     > stevie_b1.asm.24929
0111                       copy  "fb.asm"              ; Framebuffer
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
     6860 2240 
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
     6872 2F20 
0085 6874 A120  34         a     @fb.topline,tmp0
     6876 A104 
0086 6878 C804  38         mov   tmp0,@outparm1
     687A 2F30 
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
     68AE 2F20 
     68B0 A104 
0169 68B2 04E0  34         clr   @parm2                ; Target row in frame buffer
     68B4 2F22 
0170                       ;------------------------------------------------------
0171                       ; Check if already at EOF
0172                       ;------------------------------------------------------
0173 68B6 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     68B8 2F20 
     68BA A204 
0174 68BC 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0175                       ;------------------------------------------------------
0176                       ; Unpack line to frame buffer
0177                       ;------------------------------------------------------
0178               fb.refresh.unpack_line:
0179 68BE 06A0  32         bl    @edb.line.unpack      ; Unpack line
     68C0 6CD2 
0180                                                   ; \ i  parm1    = Line to unpack
0181                                                   ; | i  parm2    = Target row in frame buffer
0182                                                   ; / o  outparm1 = Length of line
0183               
0184 68C2 05A0  34         inc   @parm1                ; Next line in editor buffer
     68C4 2F20 
0185 68C6 05A0  34         inc   @parm2                ; Next row in frame buffer
     68C8 2F22 
0186                       ;------------------------------------------------------
0187                       ; Last row in editor buffer reached ?
0188                       ;------------------------------------------------------
0189 68CA 8820  54         c     @parm1,@edb.lines
     68CC 2F20 
     68CE A204 
0190 68D0 1112  14         jlt   !                     ; no, do next check
0191                                                   ; yes, erase until end of frame buffer
0192                       ;------------------------------------------------------
0193                       ; Erase until end of frame buffer
0194                       ;------------------------------------------------------
0195               fb.refresh.erase_eob:
0196 68D2 C120  34         mov   @parm2,tmp0           ; Current row
     68D4 2F22 
0197 68D6 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     68D8 A118 
0198 68DA 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0199 68DC 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     68DE A10E 
0200               
0201 68E0 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0202 68E2 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0203               
0204 68E4 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     68E6 A10E 
0205 68E8 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     68EA A100 
0206               
0207 68EC C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0208 68EE 04C5  14         clr   tmp1                  ; Clear with >00 character
0209               
0210 68F0 06A0  32         bl    @xfilm                ; \ Fill memory
     68F2 2246 
0211                                                   ; | i  tmp0 = Memory start address
0212                                                   ; | i  tmp1 = Byte to fill
0213                                                   ; / i  tmp2 = Number of bytes to fill
0214 68F4 1004  14         jmp   fb.refresh.exit
0215                       ;------------------------------------------------------
0216                       ; Bottom row in frame buffer reached ?
0217                       ;------------------------------------------------------
0218 68F6 8820  54 !       c     @parm2,@fb.scrrows
     68F8 2F22 
     68FA A118 
0219 68FC 11E0  14         jlt   fb.refresh.unpack_line
0220                                                   ; No, unpack next line
0221                       ;------------------------------------------------------
0222                       ; Exit
0223                       ;------------------------------------------------------
0224               fb.refresh.exit:
0225 68FE 0720  34         seto  @fb.dirty             ; Refresh screen
     6900 A116 
0226 6902 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0227 6904 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0228 6906 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0229 6908 C2F9  30         mov   *stack+,r11           ; Pop r11
0230 690A 045B  20         b     *r11                  ; Return to caller
0231               
0232               
0233               ***************************************************************
0234               * fb.get.firstnonblank
0235               * Get column of first non-blank character in specified line
0236               ***************************************************************
0237               * bl @fb.get.firstnonblank
0238               *--------------------------------------------------------------
0239               * OUTPUT
0240               * @outparm1 = Column containing first non-blank character
0241               * @outparm2 = Character
0242               ********|*****|*********************|**************************
0243               fb.get.firstnonblank:
0244 690C 0649  14         dect  stack
0245 690E C64B  30         mov   r11,*stack            ; Save return address
0246                       ;------------------------------------------------------
0247                       ; Prepare for scanning
0248                       ;------------------------------------------------------
0249 6910 04E0  34         clr   @fb.column
     6912 A10C 
0250 6914 06A0  32         bl    @fb.calc_pointer
     6916 6880 
0251 6918 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     691A 6DB8 
0252 691C C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     691E A108 
0253 6920 1313  14         jeq   fb.get.firstnonblank.nomatch
0254                                                   ; Exit if empty line
0255 6922 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6924 A102 
0256 6926 04C5  14         clr   tmp1
0257                       ;------------------------------------------------------
0258                       ; Scan line for non-blank character
0259                       ;------------------------------------------------------
0260               fb.get.firstnonblank.loop:
0261 6928 D174  28         movb  *tmp0+,tmp1           ; Get character
0262 692A 130E  14         jeq   fb.get.firstnonblank.nomatch
0263                                                   ; Exit if empty line
0264 692C 0285  22         ci    tmp1,>2000            ; Whitespace?
     692E 2000 
0265 6930 1503  14         jgt   fb.get.firstnonblank.match
0266 6932 0606  14         dec   tmp2                  ; Counter--
0267 6934 16F9  14         jne   fb.get.firstnonblank.loop
0268 6936 1008  14         jmp   fb.get.firstnonblank.nomatch
0269                       ;------------------------------------------------------
0270                       ; Non-blank character found
0271                       ;------------------------------------------------------
0272               fb.get.firstnonblank.match:
0273 6938 6120  34         s     @fb.current,tmp0      ; Calculate column
     693A A102 
0274 693C 0604  14         dec   tmp0
0275 693E C804  38         mov   tmp0,@outparm1        ; Save column
     6940 2F30 
0276 6942 D805  38         movb  tmp1,@outparm2        ; Save character
     6944 2F32 
0277 6946 1004  14         jmp   fb.get.firstnonblank.exit
0278                       ;------------------------------------------------------
0279                       ; No non-blank character found
0280                       ;------------------------------------------------------
0281               fb.get.firstnonblank.nomatch:
0282 6948 04E0  34         clr   @outparm1             ; X=0
     694A 2F30 
0283 694C 04E0  34         clr   @outparm2             ; Null
     694E 2F32 
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               fb.get.firstnonblank.exit:
0288 6950 C2F9  30         mov   *stack+,r11           ; Pop r11
0289 6952 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0112                       copy  "idx.asm"             ; Index management
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
     6976 2240 
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
     69B6 2538 
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
     69F0 2538 
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
     6A24 2F30 
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
     6A40 2538 
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
     6A64 2F20 
0305 6A66 C160  34         mov   @parm2,tmp1           ; Get pointer
     6A68 2F22 
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
     6A74 2F24 
0317 6A76 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6A78 2F24 
0318 6A7A 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6A7C 2F24 
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
     6A84 2F30 
0329 6A86 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6A88 B000 
0330 6A8A C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A8C 2F30 
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
     6A96 2F30 
0341 6A98 04E4  34         clr   @idx.top(tmp0)        ; /
     6A9A B000 
0342 6A9C C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A9E 2F30 
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
     6ABA 2F20 
0385               
0386 6ABC 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6ABE 6A06 
0387                                                   ; \ i  tmp0     = Line number
0388                                                   ; / o  outparm1 = Slot offset in SAMS page
0389               
0390 6AC0 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6AC2 2F30 
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
     6ADA 2F30 
0411 6ADC C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6ADE 2F32 
0412 6AE0 1004  14         jmp   idx.pointer.get.exit
0413                       ;------------------------------------------------------
0414                       ; Special handling for "null"-pointer
0415                       ;------------------------------------------------------
0416               idx.pointer.get.parm.null:
0417 6AE2 04E0  34         clr   @outparm1
     6AE4 2F30 
0418 6AE6 04E0  34         clr   @outparm2
     6AE8 2F32 
0419                       ;------------------------------------------------------
0420                       ; Exit
0421                       ;------------------------------------------------------
0422               idx.pointer.get.exit:
0423 6AEA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0424 6AEC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0425 6AEE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0426 6AF0 C2F9  30         mov   *stack+,r11           ; Pop r11
0427 6AF2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0113                       copy  "idx.delete.asm"      ; Index management - delete slot
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
     6B1A 2F20 
0068               
0069 6B1C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B1E 6A06 
0070                                                   ; \ i  tmp0     = Line number
0071                                                   ; / o  outparm1 = Slot offset in SAMS page
0072               
0073 6B20 C120  34         mov   @outparm1,tmp0        ; Index offset
     6B22 2F30 
0074                       ;------------------------------------------------------
0075                       ; Prepare for index reorg
0076                       ;------------------------------------------------------
0077 6B24 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6B26 2F22 
0078 6B28 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6B2A 2F20 
0079 6B2C 130E  14         jeq   idx.entry.delete.lastline
0080                                                   ; Special treatment if last line
0081                       ;------------------------------------------------------
0082                       ; Reorganize index entries
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg:
0085 6B2E C1E0  34         mov   @parm2,tmp3
     6B30 2F22 
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
**** **** ****     > stevie_b1.asm.24929
0114                       copy  "idx.insert.asm"      ; Index management - insert slot
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
     6BA4 2F22 
0104 6BA6 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6BA8 2F20 
0105 6BAA 130F  14         jeq   idx.entry.insert.reorg.simple
0106                                                   ; Special treatment if last line
0107                       ;------------------------------------------------------
0108                       ; Reorganize index entries
0109                       ;------------------------------------------------------
0110               idx.entry.insert.reorg:
0111 6BAC C1E0  34         mov   @parm2,tmp3
     6BAE 2F22 
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
     6BBC 2F22 
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
     6BCC 2F22 
0141               
0142 6BCE 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BD0 6A06 
0143                                                   ; \ i  tmp0     = Line number
0144                                                   ; / o  outparm1 = Slot offset in SAMS page
0145               
0146 6BD2 C120  34         mov   @outparm1,tmp0        ; Index offset
     6BD4 2F30 
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
**** **** ****     > stevie_b1.asm.24929
0115                       copy  "edb.asm"             ; Editor Buffer
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
     6C24 2F60 
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
     6C36 2F62 
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
     6C46 2F20 
0111 6C48 A820  54         a     @fb.row,@parm1        ; /
     6C4A A106 
     6C4C 2F20 
0112               
0113 6C4E C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6C50 2F64 
0114               
0115                       ;------------------------------------------------------
0116                       ; 1. Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6C52 C120  34         mov   @edb.next_free.ptr,tmp0
     6C54 A208 
0120 6C56 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6C58 2F22 
0121               
0122 6C5A 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6C5C 2500 
0123                                                   ; \ i  tmp0  = Memory address
0124                                                   ; | o  waux1 = SAMS page number
0125                                                   ; / o  waux2 = Address of SAMS register
0126               
0127 6C5E C820  54         mov   @waux1,@parm3         ; Setup parm3
     6C60 833C 
     6C62 2F24 
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
     6C6C 2F24 
0139 6C6E 1308  14         jeq   !                     ; Yes, skip setting page
0140               
0141 6C70 C120  34         mov   @parm3,tmp0           ; get SAMS page
     6C72 2F24 
0142 6C74 C160  34         mov   @edb.next_free.ptr,tmp1
     6C76 A208 
0143                                                   ; Pointer to line in editor buffer
0144 6C78 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6C7A 2538 
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
     6C82 2F62 
0155 6C84 C160  34         mov   @edb.next_free.ptr,tmp1
     6C86 A208 
0156                                                   ; Address of line in editor buffer
0157               
0158 6C88 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6C8A A208 
0159               
0160 6C8C C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6C8E 2F64 
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
     6CB2 24A2 
0185                                                   ; \ i  tmp0 = source
0186                                                   ; | i  tmp1 = destination
0187                                                   ; / i  tmp2 = bytes to copy
0188                       ;------------------------------------------------------
0189                       ; 5: Align pointer to multiple of 16 memory address
0190                       ;------------------------------------------------------
0191 6CB4 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6CB6 2F64 
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
     6CCA 2F60 
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
0220               * @outparm1 = Length of unpacked line
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
     6CE4 2F20 
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
     6CF4 2F20 
     6CF6 2F60 
0252 6CF8 C820  54         mov   @parm2,@rambuf+2
     6CFA 2F22 
     6CFC 2F62 
0253                       ;------------------------------------------------------
0254                       ; Calculate offset in frame buffer
0255                       ;------------------------------------------------------
0256 6CFE C120  34         mov   @fb.colsline,tmp0
     6D00 A10E 
0257 6D02 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6D04 2F22 
0258 6D06 C1A0  34         mov   @fb.top.ptr,tmp2
     6D08 A100 
0259 6D0A A146  18         a     tmp2,tmp1             ; Add base to offset
0260 6D0C C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6D0E 2F66 
0261                       ;------------------------------------------------------
0262                       ; Get pointer to line & page-in editor buffer page
0263                       ;------------------------------------------------------
0264 6D10 C120  34         mov   @parm1,tmp0
     6D12 2F20 
0265 6D14 06A0  32         bl    @xmem.edb.sams.mappage
     6D16 67EA 
0266                                                   ; Activate editor buffer SAMS page for line
0267                                                   ; \ i  tmp0     = Line number
0268                                                   ; | o  outparm1 = Pointer to line
0269                                                   ; / o  outparm2 = SAMS page
0270               
0271 6D18 C820  54         mov   @outparm2,@edb.sams.page
     6D1A 2F32 
     6D1C A212 
0272                                                   ; Save current SAMS page
0273                       ;------------------------------------------------------
0274                       ; Handle empty line
0275                       ;------------------------------------------------------
0276 6D1E C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6D20 2F30 
0277 6D22 1603  14         jne   !                     ; Check if pointer is set
0278 6D24 04E0  34         clr   @rambuf+8             ; Set length=0
     6D26 2F68 
0279 6D28 100F  14         jmp   edb.line.unpack.clear
0280                       ;------------------------------------------------------
0281                       ; Get line length
0282                       ;------------------------------------------------------
0283 6D2A C154  26 !       mov   *tmp0,tmp1            ; Get line length
0284 6D2C C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6D2E 2F68 
0285               
0286 6D30 05E0  34         inct  @outparm1             ; Skip line prefix
     6D32 2F30 
0287 6D34 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6D36 2F30 
     6D38 2F64 
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
     6D4A 2F66 
0301 6D4C A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6D4E 2F68 
0302               
0303 6D50 04C5  14         clr   tmp1                  ; Fill with >00
0304 6D52 C1A0  34         mov   @fb.colsline,tmp2
     6D54 A10E 
0305 6D56 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6D58 2F68 
0306 6D5A 0586  14         inc   tmp2
0307               
0308 6D5C 06A0  32         bl    @xfilm                ; Fill CPU memory
     6D5E 2246 
0309                                                   ; \ i  tmp0 = Target address
0310                                                   ; | i  tmp1 = Byte to fill
0311                                                   ; / i  tmp2 = Repeat count
0312                       ;------------------------------------------------------
0313                       ; Prepare for unpacking data
0314                       ;------------------------------------------------------
0315               edb.line.unpack.prepare:
0316 6D60 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6D62 2F68 
0317 6D64 130F  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0318 6D66 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6D68 2F64 
0319 6D6A C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6D6C 2F66 
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
0331 6D7C C806  38 !       mov   tmp2,@outparm1        ; Length of unpacked line
     6D7E 2F30 
0332               
0333 6D80 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6D82 24A2 
0334                                                   ; \ i  tmp0 = Source address
0335                                                   ; | i  tmp1 = Target address
0336                                                   ; / i  tmp2 = Bytes to copy
0337                       ;------------------------------------------------------
0338                       ; Exit
0339                       ;------------------------------------------------------
0340               edb.line.unpack.exit:
0341 6D84 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0342 6D86 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0343 6D88 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0344 6D8A C2F9  30         mov   *stack+,r11           ; Pop r11
0345 6D8C 045B  20         b     *r11                  ; Return to caller
0346               
0347               
0348               
0349               ***************************************************************
0350               * edb.line.getlength
0351               * Get length of specified line
0352               ***************************************************************
0353               *  bl   @edb.line.getlength
0354               *--------------------------------------------------------------
0355               * INPUT
0356               * @parm1 = Line number
0357               *--------------------------------------------------------------
0358               * OUTPUT
0359               * @outparm1 = Length of line
0360               * @outparm2 = SAMS page
0361               *--------------------------------------------------------------
0362               * Register usage
0363               * tmp0,tmp1
0364               *--------------------------------------------------------------
0365               * Remarks
0366               * Expects that the affected SAMS page is already paged-in!
0367               ********|*****|*********************|**************************
0368               edb.line.getlength:
0369 6D8E 0649  14         dect  stack
0370 6D90 C64B  30         mov   r11,*stack            ; Push return address
0371 6D92 0649  14         dect  stack
0372 6D94 C644  30         mov   tmp0,*stack           ; Push tmp0
0373 6D96 0649  14         dect  stack
0374 6D98 C645  30         mov   tmp1,*stack           ; Push tmp1
0375                       ;------------------------------------------------------
0376                       ; Initialisation
0377                       ;------------------------------------------------------
0378 6D9A 04E0  34         clr   @outparm1             ; Reset length
     6D9C 2F30 
0379 6D9E 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6DA0 2F32 
0380                       ;------------------------------------------------------
0381                       ; Get length
0382                       ;------------------------------------------------------
0383 6DA2 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6DA4 6AA8 
0384                                                   ; \ i  parm1    = Line number
0385                                                   ; | o  outparm1 = Pointer to line
0386                                                   ; / o  outparm2 = SAMS page
0387               
0388 6DA6 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6DA8 2F30 
0389 6DAA 1302  14         jeq   edb.line.getlength.exit
0390                                                   ; Exit early if NULL pointer
0391                       ;------------------------------------------------------
0392                       ; Process line prefix
0393                       ;------------------------------------------------------
0394 6DAC C814  46         mov   *tmp0,@outparm1       ; Save length
     6DAE 2F30 
0395                       ;------------------------------------------------------
0396                       ; Exit
0397                       ;------------------------------------------------------
0398               edb.line.getlength.exit:
0399 6DB0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 6DB2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 6DB4 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 6DB6 045B  20         b     *r11                  ; Return to caller
0403               
0404               
0405               
0406               ***************************************************************
0407               * edb.line.getlength2
0408               * Get length of current row (as seen from editor buffer side)
0409               ***************************************************************
0410               *  bl   @edb.line.getlength2
0411               *--------------------------------------------------------------
0412               * INPUT
0413               * @fb.row = Row in frame buffer
0414               *--------------------------------------------------------------
0415               * OUTPUT
0416               * @fb.row.length = Length of row
0417               *--------------------------------------------------------------
0418               * Register usage
0419               * tmp0
0420               ********|*****|*********************|**************************
0421               edb.line.getlength2:
0422 6DB8 0649  14         dect  stack
0423 6DBA C64B  30         mov   r11,*stack            ; Save return address
0424                       ;------------------------------------------------------
0425                       ; Calculate line in editor buffer
0426                       ;------------------------------------------------------
0427 6DBC C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6DBE A104 
0428 6DC0 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6DC2 A106 
0429                       ;------------------------------------------------------
0430                       ; Get length
0431                       ;------------------------------------------------------
0432 6DC4 C804  38         mov   tmp0,@parm1
     6DC6 2F20 
0433 6DC8 06A0  32         bl    @edb.line.getlength
     6DCA 6D8E 
0434 6DCC C820  54         mov   @outparm1,@fb.row.length
     6DCE 2F30 
     6DD0 A108 
0435                                                   ; Save row length
0436                       ;------------------------------------------------------
0437                       ; Exit
0438                       ;------------------------------------------------------
0439               edb.line.getlength2.exit:
0440 6DD2 C2F9  30         mov   *stack+,r11           ; Pop R11
0441 6DD4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0116                       ;-----------------------------------------------------------------------
0117                       ; Command buffer handling
0118                       ;-----------------------------------------------------------------------
0119                       copy  "cmdb.asm"            ; Command buffer shared code
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
0027 6DD6 0649  14         dect  stack
0028 6DD8 C64B  30         mov   r11,*stack            ; Save return address
0029 6DDA 0649  14         dect  stack
0030 6DDC C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 6DDE 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6DE0 D000 
0035 6DE2 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6DE4 A300 
0036               
0037 6DE6 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6DE8 A302 
0038 6DEA 0204  20         li    tmp0,4
     6DEC 0004 
0039 6DEE C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6DF0 A306 
0040 6DF2 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6DF4 A308 
0041               
0042 6DF6 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6DF8 A316 
0043 6DFA 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6DFC A318 
0044                       ;------------------------------------------------------
0045                       ; Clear command buffer
0046                       ;------------------------------------------------------
0047 6DFE 06A0  32         bl    @film
     6E00 2240 
0048 6E02 D000             data  cmdb.top,>00,cmdb.size
     6E04 0000 
     6E06 1000 
0049                                                   ; Clear it all the way
0050               cmdb.init.exit:
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054 6E08 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0055 6E0A C2F9  30         mov   *stack+,r11           ; Pop r11
0056 6E0C 045B  20         b     *r11                  ; Return to caller
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
0082 6E0E 0649  14         dect  stack
0083 6E10 C64B  30         mov   r11,*stack            ; Save return address
0084 6E12 0649  14         dect  stack
0085 6E14 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6E16 0649  14         dect  stack
0087 6E18 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6E1A 0649  14         dect  stack
0089 6E1C C646  30         mov   tmp2,*stack           ; Push tmp2
0090                       ;------------------------------------------------------
0091                       ; Dump Command buffer content
0092                       ;------------------------------------------------------
0093 6E1E C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6E20 832A 
     6E22 A30C 
0094 6E24 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6E26 A310 
     6E28 832A 
0095               
0096 6E2A 05A0  34         inc   @wyx                  ; X +1 for prompt
     6E2C 832A 
0097               
0098 6E2E 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6E30 2404 
0099                                                   ; \ i  @wyx = Cursor position
0100                                                   ; / o  tmp0 = VDP target address
0101               
0102 6E32 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6E34 A323 
0103 6E36 0206  20         li    tmp2,1*79             ; Command length
     6E38 004F 
0104               
0105 6E3A 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6E3C 245A 
0106                                                   ; | i  tmp0 = VDP target address
0107                                                   ; | i  tmp1 = RAM source address
0108                                                   ; / i  tmp2 = Number of bytes to copy
0109                       ;------------------------------------------------------
0110                       ; Show command buffer prompt
0111                       ;------------------------------------------------------
0112 6E3E C820  54         mov   @cmdb.yxprompt,@wyx
     6E40 A310 
     6E42 832A 
0113 6E44 06A0  32         bl    @putstr
     6E46 2428 
0114 6E48 32F8                   data txt.cmdb.prompt
0115               
0116 6E4A C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6E4C A30C 
     6E4E A114 
0117 6E50 C820  54         mov   @cmdb.yxsave,@wyx
     6E52 A30C 
     6E54 832A 
0118                                                   ; Restore YX position
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               cmdb.refresh.exit:
0123 6E56 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0124 6E58 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0125 6E5A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0126 6E5C C2F9  30         mov   *stack+,r11           ; Pop r11
0127 6E5E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0120                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0026 6E60 0649  14         dect  stack
0027 6E62 C64B  30         mov   r11,*stack            ; Save return address
0028 6E64 0649  14         dect  stack
0029 6E66 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 6E68 0649  14         dect  stack
0031 6E6A C645  30         mov   tmp1,*stack           ; Push tmp1
0032 6E6C 0649  14         dect  stack
0033 6E6E C646  30         mov   tmp2,*stack           ; Push tmp2
0034                       ;------------------------------------------------------
0035                       ; Clear command
0036                       ;------------------------------------------------------
0037 6E70 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6E72 A322 
0038 6E74 06A0  32         bl    @film                 ; Clear command
     6E76 2240 
0039 6E78 A323                   data  cmdb.cmd,>00,80
     6E7A 0000 
     6E7C 0050 
0040                       ;------------------------------------------------------
0041                       ; Put cursor at beginning of line
0042                       ;------------------------------------------------------
0043 6E7E C120  34         mov   @cmdb.yxprompt,tmp0
     6E80 A310 
0044 6E82 0584  14         inc   tmp0
0045 6E84 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6E86 A30A 
0046                       ;------------------------------------------------------
0047                       ; Exit
0048                       ;------------------------------------------------------
0049               cmdb.cmd.clear.exit:
0050 6E88 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0051 6E8A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 6E8C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6E8E C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6E90 045B  20         b     *r11                  ; Return to caller
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
0079 6E92 0649  14         dect  stack
0080 6E94 C64B  30         mov   r11,*stack            ; Save return address
0081                       ;-------------------------------------------------------
0082                       ; Get length of null terminated string
0083                       ;-------------------------------------------------------
0084 6E96 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6E98 2A86 
0085 6E9A A323                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6E9C 0000 
0086                                                  ; | i  p1    = Termination character
0087                                                  ; / o  waux1 = Length of string
0088 6E9E C820  54         mov   @waux1,@outparm1     ; Save length of string
     6EA0 833C 
     6EA2 2F30 
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cmdb.cmd.getlength.exit:
0093 6EA4 C2F9  30         mov   *stack+,r11           ; Pop r11
0094 6EA6 045B  20         b     *r11                  ; Return to caller
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
0119 6EA8 0649  14         dect  stack
0120 6EAA C64B  30         mov   r11,*stack            ; Save return address
0121 6EAC 0649  14         dect  stack
0122 6EAE C644  30         mov   tmp0,*stack           ; Push tmp0
0123               
0124 6EB0 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     6EB2 6E92 
0125                                                   ; \ i  @cmdb.cmd
0126                                                   ; / o  @outparm1
0127                       ;------------------------------------------------------
0128                       ; Sanity check
0129                       ;------------------------------------------------------
0130 6EB4 C120  34         mov   @outparm1,tmp0        ; Check length
     6EB6 2F30 
0131 6EB8 1300  14         jeq   cmdb.cmd.history.add.exit
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
0143 6EBA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0144 6EBC C2F9  30         mov   *stack+,r11           ; Pop r11
0145 6EBE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0121                       copy  "errline.asm"         ; Error line
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
0026 6EC0 0649  14         dect  stack
0027 6EC2 C64B  30         mov   r11,*stack            ; Save return address
0028 6EC4 0649  14         dect  stack
0029 6EC6 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6EC8 04E0  34         clr   @tv.error.visible     ; Set to hidden
     6ECA A01E 
0034               
0035 6ECC 06A0  32         bl    @film
     6ECE 2240 
0036 6ED0 A020                   data tv.error.msg,0,160
     6ED2 0000 
     6ED4 00A0 
0037               
0038 6ED6 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     6ED8 A000 
0039 6EDA D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     6EDC A020 
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               errline.exit:
0044 6EDE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0045 6EE0 C2F9  30         mov   *stack+,r11           ; Pop R11
0046 6EE2 045B  20         b     *r11                  ; Return to caller
0047               
**** **** ****     > stevie_b1.asm.24929
0122                       ;-----------------------------------------------------------------------
0123                       ; File handling
0124                       ;-----------------------------------------------------------------------
0125                       copy  "fh.read.edb.asm"     ; Read file to editor buffer
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
0028 6EE4 0649  14         dect  stack
0029 6EE6 C64B  30         mov   r11,*stack            ; Save return address
0030 6EE8 0649  14         dect  stack
0031 6EEA C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6EEC 0649  14         dect  stack
0033 6EEE C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6EF0 0649  14         dect  stack
0035 6EF2 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 6EF4 04E0  34         clr   @fh.records           ; Reset records counter
     6EF6 A42E 
0040 6EF8 04E0  34         clr   @fh.counter           ; Clear internal counter
     6EFA A434 
0041 6EFC 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6EFE A432 
0042 6F00 04E0  34         clr   @fh.kilobytes.prev    ; /
     6F02 A448 
0043 6F04 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6F06 A42A 
0044 6F08 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6F0A A42C 
0045               
0046 6F0C C120  34         mov   @edb.top.ptr,tmp0
     6F0E A200 
0047 6F10 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6F12 2500 
0048                                                   ; \ i  tmp0  = Memory address
0049                                                   ; | o  waux1 = SAMS page number
0050                                                   ; / o  waux2 = Address of SAMS register
0051               
0052 6F14 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6F16 833C 
     6F18 A438 
0053 6F1A C820  54         mov   @waux1,@fh.sams.hipage
     6F1C 833C 
     6F1E A43A 
0054                                                   ; Set highest SAMS page in use
0055                       ;------------------------------------------------------
0056                       ; Save parameters / callback functions
0057                       ;------------------------------------------------------
0058 6F20 0204  20         li    tmp0,fh.fopmode.readfile
     6F22 0001 
0059                                                   ; We are going to read a file
0060 6F24 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     6F26 A43C 
0061               
0062 6F28 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6F2A 2F20 
     6F2C A436 
0063 6F2E C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6F30 2F22 
     6F32 A440 
0064 6F34 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     6F36 2F24 
     6F38 A442 
0065 6F3A C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6F3C 2F26 
     6F3E A444 
0066 6F40 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6F42 2F28 
     6F44 A446 
0067                       ;------------------------------------------------------
0068                       ; Sanity check
0069                       ;------------------------------------------------------
0070 6F46 C120  34         mov   @fh.callback1,tmp0
     6F48 A440 
0071 6F4A 0284  22         ci    tmp0,>6000            ; Insane address ?
     6F4C 6000 
0072 6F4E 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0073               
0074 6F50 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6F52 7FFF 
0075 6F54 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0076               
0077 6F56 C120  34         mov   @fh.callback2,tmp0
     6F58 A442 
0078 6F5A 0284  22         ci    tmp0,>6000            ; Insane address ?
     6F5C 6000 
0079 6F5E 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0080               
0081 6F60 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6F62 7FFF 
0082 6F64 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0083               
0084 6F66 C120  34         mov   @fh.callback3,tmp0
     6F68 A444 
0085 6F6A 0284  22         ci    tmp0,>6000            ; Insane address ?
     6F6C 6000 
0086 6F6E 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0087               
0088 6F70 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6F72 7FFF 
0089 6F74 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0090               
0091 6F76 1004  14         jmp   fh.file.read.edb.load1
0092                                                   ; All checks passed, continue
0093                       ;------------------------------------------------------
0094                       ; Check failed, crash CPU!
0095                       ;------------------------------------------------------
0096               fh.file.read.crash:
0097 6F78 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F7A FFCE 
0098 6F7C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F7E 2030 
0099                       ;------------------------------------------------------
0100                       ; Callback "Before Open file"
0101                       ;------------------------------------------------------
0102               fh.file.read.edb.load1:
0103 6F80 C120  34         mov   @fh.callback1,tmp0
     6F82 A440 
0104 6F84 0694  24         bl    *tmp0                 ; Run callback function
0105                       ;------------------------------------------------------
0106                       ; Copy PAB header to VDP
0107                       ;------------------------------------------------------
0108               fh.file.read.edb.pabheader:
0109 6F86 06A0  32         bl    @cpym2v
     6F88 2454 
0110 6F8A 0A60                   data fh.vpab,fh.file.pab.header,9
     6F8C 70C2 
     6F8E 0009 
0111                                                   ; Copy PAB header to VDP
0112                       ;------------------------------------------------------
0113                       ; Append file descriptor to PAB header in VDP
0114                       ;------------------------------------------------------
0115 6F90 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6F92 0A69 
0116 6F94 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6F96 A436 
0117 6F98 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0118 6F9A 0986  56         srl   tmp2,8                ; Right justify
0119 6F9C 0586  14         inc   tmp2                  ; Include length byte as well
0120               
0121 6F9E 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     6FA0 245A 
0122                                                   ; \ i  tmp0 = VDP destination
0123                                                   ; | i  tmp1 = CPU source
0124                                                   ; / i  tmp2 = Number of bytes to copy
0125                       ;------------------------------------------------------
0126                       ; Open file
0127                       ;------------------------------------------------------
0128 6FA2 06A0  32         bl    @file.open            ; Open file
     6FA4 2BF2 
0129 6FA6 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0130 6FA8 0014                   data io.seq.inp.dis.var
0131                                                   ; / i  p1 = File type/mode
0132               
0133 6FAA 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6FAC 2026 
0134 6FAE 1602  14         jne   fh.file.read.edb.record
0135 6FB0 0460  28         b     @fh.file.read.edb.error
     6FB2 7092 
0136                                                   ; Yes, IO error occured
0137                       ;------------------------------------------------------
0138                       ; Step 1: Read file record
0139                       ;------------------------------------------------------
0140               fh.file.read.edb.record:
0141 6FB4 05A0  34         inc   @fh.records           ; Update counter
     6FB6 A42E 
0142 6FB8 04E0  34         clr   @fh.reclen            ; Reset record length
     6FBA A430 
0143               
0144 6FBC 06A0  32         bl    @file.record.read     ; Read file record
     6FBE 2C0A 
0145 6FC0 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0146                                                   ; |           (without +9 offset!)
0147                                                   ; | o  tmp0 = Status byte
0148                                                   ; | o  tmp1 = Bytes read
0149                                                   ; | o  tmp2 = Status register contents
0150                                                   ; /           upon DSRLNK return
0151               
0152 6FC2 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6FC4 A42A 
0153 6FC6 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6FC8 A430 
0154 6FCA C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6FCC A42C 
0155                       ;------------------------------------------------------
0156                       ; 1a: Calculate kilobytes processed
0157                       ;------------------------------------------------------
0158 6FCE A805  38         a     tmp1,@fh.counter      ; Add record length to counter
     6FD0 A434 
0159 6FD2 C160  34         mov   @fh.counter,tmp1      ;
     6FD4 A434 
0160 6FD6 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     6FD8 0400 
0161 6FDA 1106  14         jlt   fh.file.read.edb.check_fioerr
0162                                                   ; Not yet, goto (1b)
0163 6FDC 05A0  34         inc   @fh.kilobytes
     6FDE A432 
0164 6FE0 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     6FE2 FC00 
0165 6FE4 C805  38         mov   tmp1,@fh.counter      ; Update counter
     6FE6 A434 
0166                       ;------------------------------------------------------
0167                       ; 1b: Check if a file error occured
0168                       ;------------------------------------------------------
0169               fh.file.read.edb.check_fioerr:
0170 6FE8 C1A0  34         mov   @fh.ioresult,tmp2
     6FEA A42C 
0171 6FEC 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6FEE 2026 
0172 6FF0 1602  14         jne   fh.file.read.edb.check_setpage
0173                                                   ; No, goto (1c)
0174 6FF2 0460  28         b     @fh.file.read.edb.error
     6FF4 7092 
0175                                                   ; Yes, so handle file error
0176                       ;------------------------------------------------------
0177                       ; 1c: Check if SAMS page needs to be set
0178                       ;------------------------------------------------------
0179               fh.file.read.edb.check_setpage:
0180 6FF6 C120  34         mov   @edb.next_free.ptr,tmp0
     6FF8 A208 
0181                                                   ;--------------------------
0182                                                   ; Sanity check
0183                                                   ;--------------------------
0184 6FFA 0284  22         ci    tmp0,edb.top + edb.size
     6FFC D000 
0185                                                   ; Insane address ?
0186 6FFE 15BC  14         jgt   fh.file.read.crash    ; Yes, crash!
0187                                                   ;--------------------------
0188                                                   ; Check overflow
0189                                                   ;--------------------------
0190 7000 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     7002 0FFF 
0191 7004 A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     7006 A430 
0192 7008 05C4  14         inct  tmp0                  ; +2 for line prefix
0193 700A 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     700C 0FF0 
0194 700E 110E  14         jlt   fh.file.read.edb.process_line
0195                                                   ; Not yet so skip SAMS page switch
0196                       ;------------------------------------------------------
0197                       ; 1d: Increase SAMS page
0198                       ;------------------------------------------------------
0199 7010 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     7012 A438 
0200 7014 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     7016 A438 
     7018 A43A 
0201                                                   ; Set highest SAMS page
0202 701A C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     701C A200 
     701E A208 
0203                                                   ; Start at top of SAMS page again
0204                       ;------------------------------------------------------
0205                       ; 1f: Switch to SAMS page
0206                       ;------------------------------------------------------
0207 7020 C120  34         mov   @fh.sams.page,tmp0
     7022 A438 
0208 7024 C160  34         mov   @edb.top.ptr,tmp1
     7026 A200 
0209 7028 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     702A 2538 
0210                                                   ; \ i  tmp0 = SAMS page number
0211                                                   ; / i  tmp1 = Memory address
0212                       ;------------------------------------------------------
0213                       ; Step 2: Process line
0214                       ;------------------------------------------------------
0215               fh.file.read.edb.process_line:
0216 702C 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     702E 0960 
0217 7030 C160  34         mov   @edb.next_free.ptr,tmp1
     7032 A208 
0218                                                   ; RAM target in editor buffer
0219               
0220 7034 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7036 2F22 
0221               
0222 7038 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     703A A430 
0223 703C 1318  14         jeq   fh.file.read.edb.prepindex.emptyline
0224                                                   ; Handle empty line
0225                       ;------------------------------------------------------
0226                       ; 2a: Copy line from VDP to CPU editor buffer
0227                       ;------------------------------------------------------
0228                                                   ; Put line length word before string
0229 703E DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0230 7040 06C6  14         swpb  tmp2                  ; |
0231 7042 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0232 7044 06C6  14         swpb  tmp2                  ; /
0233               
0234 7046 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7048 A208 
0235 704A A806  38         a     tmp2,@edb.next_free.ptr
     704C A208 
0236                                                   ; Add line length
0237               
0238 704E 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7050 2480 
0239                                                   ; \ i  tmp0 = VDP source address
0240                                                   ; | i  tmp1 = RAM target address
0241                                                   ; / i  tmp2 = Bytes to copy
0242                       ;------------------------------------------------------
0243                       ; 2b: Align pointer to multiple of 16 memory address
0244                       ;------------------------------------------------------
0245 7052 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7054 A208 
0246 7056 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0247 7058 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     705A 000F 
0248 705C A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     705E A208 
0249                       ;------------------------------------------------------
0250                       ; Step 3: Update index
0251                       ;------------------------------------------------------
0252               fh.file.read.edb.prepindex:
0253 7060 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7062 A204 
     7064 2F20 
0254                                                   ; parm2 = Must allready be set!
0255 7066 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     7068 A438 
     706A 2F24 
0256               
0257 706C 1009  14         jmp   fh.file.read.edb.updindex
0258                                                   ; Update index
0259                       ;------------------------------------------------------
0260                       ; 3a: Special handling for empty line
0261                       ;------------------------------------------------------
0262               fh.file.read.edb.prepindex.emptyline:
0263 706E C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     7070 A42E 
     7072 2F20 
0264 7074 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7076 2F20 
0265 7078 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     707A 2F22 
0266 707C 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     707E 2F24 
0267                       ;------------------------------------------------------
0268                       ; 3b: Do actual index update
0269                       ;------------------------------------------------------
0270               fh.file.read.edb.updindex:
0271 7080 06A0  32         bl    @idx.entry.update     ; Update index
     7082 6A56 
0272                                                   ; \ i  parm1    = Line num in editor buffer
0273                                                   ; | i  parm2    = Pointer to line in editor
0274                                                   ; |               buffer
0275                                                   ; | i  parm3    = SAMS page
0276                                                   ; | o  outparm1 = Pointer to updated index
0277                                                   ; /               entry
0278               
0279 7084 05A0  34         inc   @edb.lines            ; lines=lines+1
     7086 A204 
0280                       ;------------------------------------------------------
0281                       ; Step 4: Callback "Read line from file"
0282                       ;------------------------------------------------------
0283               fh.file.read.edb.display:
0284 7088 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     708A A442 
0285 708C 0694  24         bl    *tmp0                 ; Run callback function
0286                       ;------------------------------------------------------
0287                       ; 4a: Next record. Load GPL scratchpad layout.
0288                       ;------------------------------------------------------
0289               fh.file.read.edb.next:
0290 708E 0460  28         b     @fh.file.read.edb.record
     7090 6FB4 
0291                                                   ; Next record
0292                       ;------------------------------------------------------
0293                       ; Error handler
0294                       ;------------------------------------------------------
0295               fh.file.read.edb.error:
0296 7092 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     7094 A42A 
0297 7096 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0298 7098 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     709A 0005 
0299 709C 1306  14         jeq   fh.file.read.edb.eof  ; All good. File closed by DSRLNK
0300                       ;------------------------------------------------------
0301                       ; File error occured
0302                       ;------------------------------------------------------
0303 709E 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     70A0 67CE 
0304                       ;------------------------------------------------------
0305                       ; Callback "File I/O error"
0306                       ;------------------------------------------------------
0307 70A2 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     70A4 A446 
0308 70A6 0694  24         bl    *tmp0                 ; Run callback function
0309 70A8 1005  14         jmp   fh.file.read.edb.exit
0310                       ;------------------------------------------------------
0311                       ; End-Of-File reached
0312                       ;------------------------------------------------------
0313               fh.file.read.edb.eof:
0314 70AA 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     70AC 67CE 
0315                       ;------------------------------------------------------
0316                       ; Callback "Close file"
0317                       ;------------------------------------------------------
0318 70AE C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     70B0 A444 
0319 70B2 0694  24         bl    *tmp0                 ; Run callback function
0320               *--------------------------------------------------------------
0321               * Exit
0322               *--------------------------------------------------------------
0323               fh.file.read.edb.exit:
0324 70B4 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     70B6 A43C 
0325 70B8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0326 70BA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0327 70BC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0328 70BE C2F9  30         mov   *stack+,r11           ; Pop R11
0329 70C0 045B  20         b     *r11                  ; Return to caller
0330               
0331               
0332               ***************************************************************
0333               * PAB for accessing DV/80 file
0334               ********|*****|*********************|**************************
0335               fh.file.pab.header:
0336 70C2 0014             byte  io.op.open            ;  0    - OPEN
0337                       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
0338 70C4 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0339 70C6 5000             byte  80                    ;  4    - Record length (80 chars max)
0340                       byte  00                    ;  5    - Character count
0341 70C8 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0342 70CA 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0343                       ;------------------------------------------------------
0344                       ; File descriptor part (variable length)
0345                       ;------------------------------------------------------
0346                       ; byte  12                  ;  9    - File descriptor length
0347                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0348                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.24929
0126                       copy  "fh.write.edb.asm"    ; Write editor buffer to file
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
0028 70CC 0649  14         dect  stack
0029 70CE C64B  30         mov   r11,*stack            ; Save return address
0030 70D0 0649  14         dect  stack
0031 70D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 70D4 0649  14         dect  stack
0033 70D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 70D8 0649  14         dect  stack
0035 70DA C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 70DC 04E0  34         clr   @fh.records           ; Reset records counter
     70DE A42E 
0040 70E0 04E0  34         clr   @fh.counter           ; Clear internal counter
     70E2 A434 
0041 70E4 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     70E6 A432 
0042 70E8 04E0  34         clr   @fh.kilobytes.prev    ; /
     70EA A448 
0043 70EC 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     70EE A42A 
0044 70F0 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     70F2 A42C 
0045                       ;------------------------------------------------------
0046                       ; Save parameters / callback functions
0047                       ;------------------------------------------------------
0048 70F4 0204  20         li    tmp0,fh.fopmode.writefile
     70F6 0002 
0049                                                   ; We are going to write to a file
0050 70F8 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     70FA A43C 
0051               
0052 70FC C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     70FE 2F20 
     7100 A436 
0053 7102 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     7104 2F22 
     7106 A440 
0054 7108 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Write line to file"
     710A 2F24 
     710C A442 
0055 710E C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     7110 2F26 
     7112 A444 
0056 7114 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     7116 2F28 
     7118 A446 
0057                       ;------------------------------------------------------
0058                       ; Sanity check
0059                       ;------------------------------------------------------
0060 711A C120  34         mov   @fh.callback1,tmp0
     711C A440 
0061 711E 0284  22         ci    tmp0,>6000            ; Insane address ?
     7120 6000 
0062 7122 1114  14         jlt   fh.file.write.crash   ; Yes, crash!
0063               
0064 7124 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7126 7FFF 
0065 7128 1511  14         jgt   fh.file.write.crash   ; Yes, crash!
0066               
0067 712A C120  34         mov   @fh.callback2,tmp0
     712C A442 
0068 712E 0284  22         ci    tmp0,>6000            ; Insane address ?
     7130 6000 
0069 7132 110C  14         jlt   fh.file.write.crash   ; Yes, crash!
0070               
0071 7134 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7136 7FFF 
0072 7138 1509  14         jgt   fh.file.write.crash   ; Yes, crash!
0073               
0074 713A C120  34         mov   @fh.callback3,tmp0
     713C A444 
0075 713E 0284  22         ci    tmp0,>6000            ; Insane address ?
     7140 6000 
0076 7142 1104  14         jlt   fh.file.write.crash   ; Yes, crash!
0077               
0078 7144 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7146 7FFF 
0079 7148 1501  14         jgt   fh.file.write.crash   ; Yes, crash!
0080               
0081 714A 1004  14         jmp   fh.file.write.edb.save1
0082                                                   ; All checks passed, continue.
0083                       ;------------------------------------------------------
0084                       ; Check failed, crash CPU!
0085                       ;------------------------------------------------------
0086               fh.file.write.crash:
0087 714C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     714E FFCE 
0088 7150 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7152 2030 
0089                       ;------------------------------------------------------
0090                       ; Callback "Before Open file"
0091                       ;------------------------------------------------------
0092               fh.file.write.edb.save1:
0093 7154 C120  34         mov   @fh.callback1,tmp0
     7156 A440 
0094 7158 0694  24         bl    *tmp0                 ; Run callback function
0095                       ;------------------------------------------------------
0096                       ; Copy PAB header to VDP
0097                       ;------------------------------------------------------
0098               fh.file.write.edb.pabheader:
0099 715A 06A0  32         bl    @cpym2v
     715C 2454 
0100 715E 0A60                   data fh.vpab,fh.file.pab.header,9
     7160 70C2 
     7162 0009 
0101                                                   ; Copy PAB header to VDP
0102                       ;------------------------------------------------------
0103                       ; Append file descriptor to PAB header in VDP
0104                       ;------------------------------------------------------
0105 7164 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     7166 0A69 
0106 7168 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     716A A436 
0107 716C D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0108 716E 0986  56         srl   tmp2,8                ; Right justify
0109 7170 0586  14         inc   tmp2                  ; Include length byte as well
0110               
0111 7172 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     7174 245A 
0112                                                   ; \ i  tmp0 = VDP destination
0113                                                   ; | i  tmp1 = CPU source
0114                                                   ; / i  tmp2 = Number of bytes to copy
0115                       ;------------------------------------------------------
0116                       ; Open file
0117                       ;------------------------------------------------------
0118 7176 06A0  32         bl    @file.open            ; Open file
     7178 2BF2 
0119 717A 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0120 717C 0012                   data io.seq.out.dis.var
0121                                                   ; / i  p1 = File type/mode
0122               
0123 717E 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7180 2026 
0124 7182 1333  14         jeq   fh.file.write.edb.error
0125                                                   ; Yes, IO error occured
0126                       ;------------------------------------------------------
0127                       ; Step 1: Write file record
0128                       ;------------------------------------------------------
0129               fh.file.write.edb.record:
0130 7184 8820  54         c     @fh.records,@edb.lines
     7186 A42E 
     7188 A204 
0131 718A 153B  14         jgt   fh.file.write.edb.eof ; Exit when all records processed
0132                       ;------------------------------------------------------
0133                       ; 1a: Unpack current line to framebuffer
0134                       ;------------------------------------------------------
0135 718C C820  54         mov   @fh.records,@parm1    ; Line to unpack
     718E A42E 
     7190 2F20 
0136 7192 04E0  34         clr   @parm2                ; First row in frame buffer
     7194 2F22 
0137               
0138 7196 06A0  32         bl    @edb.line.unpack      ; Unpack line
     7198 6CD2 
0139                                                   ; \ i  parm1    = Line to unpack
0140                                                   ; | i  parm2    = Target row in frame buffer
0141                                                   ; / o  outparm1 = Length of line
0142                       ;------------------------------------------------------
0143                       ; 1b: Copy unpacked line to VDP memory
0144                       ;------------------------------------------------------
0145 719A 0204  20         li    tmp0,fh.vrecbuf       ; VDP target address
     719C 0960 
0146 719E 0205  20         li    tmp1,fb.top           ; Top of frame buffer in CPU memory
     71A0 A600 
0147               
0148 71A2 C1A0  34         mov   @outparm1,tmp2        ; Length of line
     71A4 2F30 
0149 71A6 C806  38         mov   tmp2,@fh.reclen       ; Set record length
     71A8 A430 
0150               
0151 71AA 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     71AC 245A 
0152                                                   ; \ i  tmp0 = VDP target address
0153                                                   ; | i  tmp1 = CPU source address
0154                                                   ; / i  tmp2 = Number of bytes to copy
0155                       ;------------------------------------------------------
0156                       ; 1c: Write file record
0157                       ;------------------------------------------------------
0158 71AE 06A0  32         bl    @file.record.write    ; Write file record
     71B0 2C14 
0159 71B2 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0160                                                   ; |           (without +9 offset!)
0161                                                   ; | o  tmp0 = Status byte
0162                                                   ; | o  tmp1 = ?????
0163                                                   ; | o  tmp2 = Status register contents
0164                                                   ; /           upon DSRLNK return
0165                       ;------------------------------------------------------
0166                       ; 1d: Calculate kilobytes processed
0167                       ;------------------------------------------------------
0168 71B4 A820  54         a     @fh.reclen,@fh.counter
     71B6 A430 
     71B8 A434 
0169                                                   ; Add record length to counter
0170 71BA C160  34         mov   @fh.counter,tmp1      ;
     71BC A434 
0171 71BE 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     71C0 0400 
0172 71C2 1106  14         jlt   fh.file.write.edb.check_fioerr
0173                                                   ; Not yet, goto (1e)
0174 71C4 05A0  34         inc   @fh.kilobytes
     71C6 A432 
0175 71C8 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     71CA FC00 
0176 71CC C805  38         mov   tmp1,@fh.counter      ; Update counter
     71CE A434 
0177                       ;------------------------------------------------------
0178                       ; 1e: Check if a file error occured
0179                       ;------------------------------------------------------
0180               fh.file.write.edb.check_fioerr:
0181 71D0 C1A0  34         mov   @fh.ioresult,tmp2
     71D2 A42C 
0182 71D4 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     71D6 2026 
0183 71D8 1602  14         jne   fh.file.write.edb.display
0184                                                   ; No, goto (2)
0185 71DA 0460  28         b     @fh.file.write.edb.error
     71DC 71EA 
0186                                                   ; Yes, so handle file error
0187                       ;------------------------------------------------------
0188                       ; Step 2: Callback "Write line to  file"
0189                       ;------------------------------------------------------
0190               fh.file.write.edb.display:
0191 71DE C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Saving indicator 2"
     71E0 A442 
0192 71E2 0694  24         bl    *tmp0                 ; Run callback function
0193                       ;------------------------------------------------------
0194                       ; Step 3: Next record
0195                       ;------------------------------------------------------
0196 71E4 05A0  34         inc   @fh.records           ; Update counter
     71E6 A42E 
0197 71E8 10CD  14         jmp   fh.file.write.edb.record
0198                       ;------------------------------------------------------
0199                       ; Error handler
0200                       ;------------------------------------------------------
0201               fh.file.write.edb.error:
0202 71EA C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     71EC A42A 
0203 71EE 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0204 71F0 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     71F2 0005 
0205 71F4 1306  14         jeq   fh.file.write.edb.eof ; All good. File closed by DSRLNK
0206                       ;------------------------------------------------------
0207                       ; File error occured
0208                       ;------------------------------------------------------
0209 71F6 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     71F8 67CE 
0210                       ;------------------------------------------------------
0211                       ; Callback "File I/O error"
0212                       ;------------------------------------------------------
0213 71FA C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     71FC A446 
0214 71FE 0694  24         bl    *tmp0                 ; Run callback function
0215 7200 1005  14         jmp   fh.file.write.edb.exit
0216                       ;------------------------------------------------------
0217                       ; End-Of-File reached
0218                       ;------------------------------------------------------
0219               fh.file.write.edb.eof:
0220 7202 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     7204 67CE 
0221                       ;------------------------------------------------------
0222                       ; Callback "Close file"
0223                       ;------------------------------------------------------
0224 7206 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     7208 A444 
0225 720A 0694  24         bl    *tmp0                 ; Run callback function
0226               *--------------------------------------------------------------
0227               * Exit
0228               *--------------------------------------------------------------
0229               fh.file.write.edb.exit:
0230 720C 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     720E A43C 
0231 7210 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0232 7212 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0233 7214 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0234 7216 C2F9  30         mov   *stack+,r11           ; Pop R11
0235 7218 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0127                       copy  "fm.load.asm"         ; Load DV80 file into editor buffer
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
0022 721A 0649  14         dect  stack
0023 721C C64B  30         mov   r11,*stack            ; Save return address
0024 721E 0649  14         dect  stack
0025 7220 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7222 0649  14         dect  stack
0027 7224 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Show dialog "Unsaved changes" if editor buffer dirty
0030                       ;-------------------------------------------------------
0031 7226 C160  34         mov   @edb.dirty,tmp1
     7228 A206 
0032 722A 1305  14         jeq   !
0033 722C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0034 722E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0035 7230 C2F9  30         mov   *stack+,r11           ; Pop R11
0036 7232 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7234 7A8A 
0037                       ;-------------------------------------------------------
0038                       ; Reset editor
0039                       ;-------------------------------------------------------
0040 7236 C804  38 !       mov   tmp0,@parm1           ; Setup file to load
     7238 2F20 
0041 723A 06A0  32         bl    @tv.reset             ; Reset editor
     723C 67B2 
0042 723E C820  54         mov   @parm1,@edb.filename.ptr
     7240 2F20 
     7242 A20E 
0043                                                   ; Set filename
0044                       ;-------------------------------------------------------
0045                       ; Clear VDP screen buffer
0046                       ;-------------------------------------------------------
0047 7244 06A0  32         bl    @filv
     7246 2298 
0048 7248 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     724A 0000 
     724C 0004 
0049               
0050 724E C160  34         mov   @fb.scrrows,tmp1
     7250 A118 
0051 7252 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7254 A10E 
0052                                                   ; 16 bit part is in tmp2!
0053               
0054 7256 06A0  32         bl    @scroff               ; Turn off screen
     7258 2650 
0055               
0056 725A 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0057 725C 0205  20         li    tmp1,32               ; Character to fill
     725E 0020 
0058               
0059 7260 06A0  32         bl    @xfilv                ; Fill VDP memory
     7262 229E 
0060                                                   ; \ i  tmp0 = VDP target address
0061                                                   ; | i  tmp1 = Byte to fill
0062                                                   ; / i  tmp2 = Bytes to copy
0063               
0064 7264 06A0  32         bl    @pane.action.colorscheme.Load
     7266 76CE 
0065                                                   ; Load color scheme and turn on screen
0066                       ;-------------------------------------------------------
0067                       ; Read DV80 file and display
0068                       ;-------------------------------------------------------
0069 7268 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     726A 72F2 
0070 726C C804  38         mov   tmp0,@parm2           ; Register callback 1
     726E 2F22 
0071               
0072 7270 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     7272 733A 
0073 7274 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7276 2F24 
0074               
0075 7278 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     727A 7370 
0076 727C C804  38         mov   tmp0,@parm4           ; Register callback 3
     727E 2F26 
0077               
0078 7280 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     7282 73A2 
0079 7284 C804  38         mov   tmp0,@parm5           ; Register callback 4
     7286 2F28 
0080               
0081 7288 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     728A 6EE4 
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
0093 728C 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     728E A206 
0094                                                   ; longer dirty.
0095               
0096 7290 0204  20         li    tmp0,txt.filetype.DV80
     7292 3112 
0097 7294 C804  38         mov   tmp0,@edb.filetype.ptr
     7296 A210 
0098                                                   ; Set filetype display string
0099               *--------------------------------------------------------------
0100               * Exit
0101               *--------------------------------------------------------------
0102               fm.loadfile.exit:
0103 7298 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0104 729A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0105 729C C2F9  30         mov   *stack+,r11           ; Pop R11
0106 729E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0128                       copy  "fm.save.asm"         ; Save DV80 file from editor buffer
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
0022 72A0 0649  14         dect  stack
0023 72A2 C64B  30         mov   r11,*stack            ; Save return address
0024 72A4 0649  14         dect  stack
0025 72A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 72A8 0649  14         dect  stack
0027 72AA C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Initialisation
0030                       ;-------------------------------------------------------
0031 72AC 06A0  32         bl    @filv
     72AE 2298 
0032 72B0 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     72B2 0000 
     72B4 0004 
0033               
0034                       ;bl    @pane.cmdb.hide       ; Hide CMDB pane
0035                       ;-------------------------------------------------------
0036                       ; Save DV80 file
0037                       ;-------------------------------------------------------
0038 72B6 C804  38         mov   tmp0,@parm1           ; Set device and filename
     72B8 2F20 
0039               
0040 72BA 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     72BC 72F2 
0041 72BE C804  38         mov   tmp0,@parm2           ; Register callback 1
     72C0 2F22 
0042               
0043 72C2 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     72C4 733A 
0044 72C6 C804  38         mov   tmp0,@parm3           ; Register callback 2
     72C8 2F24 
0045               
0046 72CA 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     72CC 7370 
0047 72CE C804  38         mov   tmp0,@parm4           ; Register callback 3
     72D0 2F26 
0048               
0049 72D2 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     72D4 73A2 
0050 72D6 C804  38         mov   tmp0,@parm5           ; Register callback 4
     72D8 2F28 
0051               
0052 72DA 06A0  32         bl    @fh.file.write.edb    ; Save file from editor buffer
     72DC 70CC 
0053                                                   ; \ i  parm1 = Pointer to length prefixed
0054                                                   ; |            file descriptor
0055                                                   ; | i  parm2 = Pointer to callback
0056                                                   ; |            "loading indicator 1"
0057                                                   ; | i  parm3 = Pointer to callback
0058                                                   ; |            "loading indicator 2"
0059                                                   ; | i  parm4 = Pointer to callback
0060                                                   ; |            "loading indicator 3"
0061                                                   ; | i  parm5 = Pointer to callback
0062                                                   ; /            "File I/O error handler"
0063               
0064 72DE 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     72E0 A206 
0065                                                   ; longer dirty.
0066               
0067 72E2 0204  20         li    tmp0,txt.filetype.DV80
     72E4 3112 
0068 72E6 C804  38         mov   tmp0,@edb.filetype.ptr
     72E8 A210 
0069                                                   ; Set filetype display string
0070               *--------------------------------------------------------------
0071               * Exit
0072               *--------------------------------------------------------------
0073               fm.savefile.exit:
0074 72EA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 72EC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 72EE C2F9  30         mov   *stack+,r11           ; Pop R11
0077 72F0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0129                       copy  "fm.callbacks.asm"    ; Callbacks for file operations
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
0011 72F2 0649  14         dect  stack
0012 72F4 C64B  30         mov   r11,*stack            ; Save return address
0013 72F6 0649  14         dect  stack
0014 72F8 C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;------------------------------------------------------
0016                       ; Check file operation m ode
0017                       ;------------------------------------------------------
0018 72FA 06A0  32         bl    @hchar
     72FC 2784 
0019 72FE 1D00                   byte 29,0,32,80
     7300 2050 
0020 7302 FFFF                   data EOL              ; Clear until end of line
0021               
0022 7304 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     7306 A43C 
0023               
0024 7308 0284  22         ci    tmp0,fh.fopmode.writefile
     730A 0002 
0025 730C 1303  14         jeq   fm.loadsave.cb.indicator1.saving
0026                                                   ; Saving file?
0027               
0028 730E 0284  22         ci    tmp0,fh.fopmode.readfile
     7310 0001 
0029 7312 1305  14         jeq   fm.loadsave.cb.indicator1.loading
0030                                                   ; Loading file?
0031                       ;------------------------------------------------------
0032                       ; Display Saving....
0033                       ;------------------------------------------------------
0034               fm.loadsave.cb.indicator1.saving:
0035 7314 06A0  32         bl    @putat
     7316 244C 
0036 7318 1D00                   byte 29,0
0037 731A 30EE                   data txt.saving       ; Display "Saving...."
0038 731C 1004  14         jmp   fm.loadsave.cb.indicator1.filename
0039                       ;------------------------------------------------------
0040                       ; Display Loading....
0041                       ;------------------------------------------------------
0042               fm.loadsave.cb.indicator1.loading:
0043 731E 06A0  32         bl    @putat
     7320 244C 
0044 7322 1D00                   byte 29,0
0045 7324 30E2                   data txt.loading      ; Display "Loading...."
0046                       ;------------------------------------------------------
0047                       ; Display device/filename
0048                       ;------------------------------------------------------
0049               fm.loadsave.cb.indicator1.filename:
0050 7326 06A0  32         bl    @at
     7328 2690 
0051 732A 1D0B                   byte 29,11            ; Cursor YX position
0052 732C C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     732E 2F20 
0053 7330 06A0  32         bl    @xutst0               ; Display device/filename
     7332 242A 
0054                       ;------------------------------------------------------
0055                       ; Exit
0056                       ;------------------------------------------------------
0057               fm.loadsave.cb.indicator1.exit:
0058 7334 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0059 7336 C2F9  30         mov   *stack+,r11           ; Pop R11
0060 7338 045B  20         b     *r11                  ; Return to caller
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
0075 733A 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     733C A432 
     733E A448 
0076 7340 1316  14         jeq   !
0077                       ;------------------------------------------------------
0078                       ; Display updated counters
0079                       ;------------------------------------------------------
0080 7342 0649  14         dect  stack
0081 7344 C64B  30         mov   r11,*stack            ; Save return address
0082               
0083 7346 C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     7348 A432 
     734A A448 
0084                                                   ; Save for compare
0085               
0086 734C 06A0  32         bl    @putnum
     734E 2A10 
0087 7350 1D4B                   byte 29,75            ; Show lines processed
0088 7352 A42E                   data fh.records,rambuf,>3020
     7354 2F60 
     7356 3020 
0089               
0090 7358 06A0  32         bl    @putnum
     735A 2A10 
0091 735C 1D38                   byte 29,56            ; Show kilobytes processed
0092 735E A432                   data fh.kilobytes,rambuf,>3020
     7360 2F60 
     7362 3020 
0093               
0094 7364 06A0  32         bl    @putat
     7366 244C 
0095 7368 1D3D                   byte 29,61
0096 736A 30F8                   data txt.kb           ; Show "kb" string
0097                       ;------------------------------------------------------
0098                       ; Exit
0099                       ;------------------------------------------------------
0100               fm.loadsave.cb.indicator2.exit:
0101 736C C2F9  30         mov   *stack+,r11           ; Pop R11
0102 736E 045B  20 !       b     *r11                  ; Return to caller
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
0114 7370 0649  14         dect  stack
0115 7372 C64B  30         mov   r11,*stack            ; Save return address
0116               
0117 7374 06A0  32         bl    @hchar
     7376 2784 
0118 7378 1D03                   byte 29,3,32,50       ; Erase loading indicator
     737A 2032 
0119 737C FFFF                   data EOL
0120               
0121 737E 06A0  32         bl    @putnum
     7380 2A10 
0122 7382 1D38                   byte 29,56            ; Show kilobytes processed
0123 7384 A432                   data fh.kilobytes,rambuf,>3020
     7386 2F60 
     7388 3020 
0124               
0125 738A 06A0  32         bl    @putat
     738C 244C 
0126 738E 1D3D                   byte 29,61
0127 7390 30F8                   data txt.kb           ; Show "kb" string
0128               
0129 7392 06A0  32         bl    @putnum
     7394 2A10 
0130 7396 1D4B                   byte 29,75            ; Show lines processed
0131 7398 A42E                   data fh.records,rambuf,>3020
     739A 2F60 
     739C 3020 
0132                       ;------------------------------------------------------
0133                       ; Exit
0134                       ;------------------------------------------------------
0135               fm.loadsave.cb.indicator3.exit:
0136 739E C2F9  30         mov   *stack+,r11           ; Pop R11
0137 73A0 045B  20         b     *r11                  ; Return to caller
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
0148 73A2 0649  14         dect  stack
0149 73A4 C64B  30         mov   r11,*stack            ; Save return address
0150 73A6 0649  14         dect  stack
0151 73A8 C644  30         mov   tmp0,*stack           ; Push tmp0
0152                       ;------------------------------------------------------
0153                       ; Build I/O error message
0154                       ;------------------------------------------------------
0155 73AA 06A0  32         bl    @hchar
     73AC 2784 
0156 73AE 1D00                   byte 29,0,32,50       ; Erase loading indicator
     73B0 2032 
0157 73B2 FFFF                   data EOL
0158               
0159 73B4 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     73B6 A43C 
0160 73B8 0284  22         ci    tmp0,fh.fopmode.writefile
     73BA 0002 
0161 73BC 1306  14         jeq   fm.loadsave.cb.fioerr.mgs2
0162                       ;------------------------------------------------------
0163                       ; Failed loading file
0164                       ;------------------------------------------------------
0165               fm.loadsave.cb.fioerr.mgs1:
0166 73BE 06A0  32         bl    @cpym2m
     73C0 249C 
0167 73C2 3285                   data txt.ioerr.load+1
0168 73C4 A021                   data tv.error.msg+1
0169 73C6 0022                   data 34               ; Error message
0170 73C8 1005  14         jmp   fm.loadsave.cb.fioerr.mgs3
0171                       ;------------------------------------------------------
0172                       ; Failed saving file
0173                       ;------------------------------------------------------
0174               fm.loadsave.cb.fioerr.mgs2:
0175 73CA 06A0  32         bl    @cpym2m
     73CC 249C 
0176 73CE 32A7                   data txt.ioerr.save+1
0177 73D0 A021                   data tv.error.msg+1
0178 73D2 0022                   data 34               ; Error message
0179                       ;------------------------------------------------------
0180                       ; Add filename to error message
0181                       ;------------------------------------------------------
0182               fm.loadsave.cb.fioerr.mgs3:
0183 73D4 C120  34         mov   @edb.filename.ptr,tmp0
     73D6 A20E 
0184 73D8 D194  26         movb  *tmp0,tmp2            ; Get length byte
0185 73DA 0986  56         srl   tmp2,8                ; Right align
0186 73DC 0584  14         inc   tmp0                  ; Skip length byte
0187 73DE 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     73E0 A041 
0188               
0189 73E2 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     73E4 24A2 
0190                                                   ; | i  tmp0 = ROM/RAM source
0191                                                   ; | i  tmp1 = RAM destination
0192                                                   ; / i  tmp2 = Bytes to copy
0193                       ;------------------------------------------------------
0194                       ; Reset filename to "new file"
0195                       ;------------------------------------------------------
0196 73E6 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     73E8 A43C 
0197               
0198 73EA 0284  22         ci    tmp0,fh.fopmode.readfile
     73EC 0001 
0199 73EE 1608  14         jne   !                     ; Only when reading file
0200               
0201 73F0 0204  20         li    tmp0,txt.newfile      ; New file
     73F2 3106 
0202 73F4 C804  38         mov   tmp0,@edb.filename.ptr
     73F6 A20E 
0203               
0204 73F8 0204  20         li    tmp0,txt.filetype.none
     73FA 3118 
0205 73FC C804  38         mov   tmp0,@edb.filetype.ptr
     73FE A210 
0206                                                   ; Empty filetype string
0207                       ;------------------------------------------------------
0208                       ; Display I/O error message
0209                       ;------------------------------------------------------
0210 7400 06A0  32 !       bl    @pane.errline.show    ; Show error line
     7402 78F0 
0211                       ;------------------------------------------------------
0212                       ; Exit
0213                       ;------------------------------------------------------
0214               fm.loadsave.cb.fioerr.exit:
0215 7404 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0216 7406 C2F9  30         mov   *stack+,r11           ; Pop R11
0217 7408 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0130                       copy  "fm.browse.asm"       ; File manager browse support routines
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
0018 740A 0649  14         dect  stack
0019 740C C64B  30         mov   r11,*stack            ; Save return address
0020 740E 0649  14         dect  stack
0021 7410 C644  30         mov   tmp0,*stack           ; Push tmp0
0022 7412 0649  14         dect  stack
0023 7414 C645  30         mov   tmp1,*stack           ; Push tmp1
0024                       ;------------------------------------------------------
0025                       ; Get last character in filename
0026                       ;------------------------------------------------------
0027 7416 C120  34         mov   @parm1,tmp0           ; Get pointer to filename
     7418 2F20 
0028 741A 1331  14         jeq   fm.browse.fname.suffix.exit
0029                                                   ; Exit early if pointer is nill
0030               
0031 741C D154  26         movb  *tmp0,tmp1            ; Get length of current filename
0032 741E 0985  56         srl   tmp1,8                ; MSB to LSB
0033               
0034 7420 A105  18         a     tmp1,tmp0             ; Move to last character
0035 7422 04C5  14         clr   tmp1
0036 7424 D154  26         movb  *tmp0,tmp1            ; Get character
0037 7426 0985  56         srl   tmp1,8                ; MSB to LSB
0038 7428 132A  14         jeq   fm.browse.fname.suffix.exit
0039                                                   ; Exit early if empty filename
0040                       ;------------------------------------------------------
0041                       ; Check mode (increase/decrease) character ASCII value
0042                       ;------------------------------------------------------
0043 742A C1A0  34         mov   @parm2,tmp2           ; Get mode
     742C 2F22 
0044 742E 1314  14         jeq   fm.browse.fname.suffix.dec
0045                                                   ; Decrease ASCII if mode = 0
0046                       ;------------------------------------------------------
0047                       ; Increase ASCII value last character in filename
0048                       ;------------------------------------------------------
0049               fm.browse.fname.suffix.inc:
0050 7430 0285  22         ci    tmp1,48               ; ASCI  48 (char 0) ?
     7432 0030 
0051 7434 1108  14         jlt   fm.browse.fname.suffix.inc.crash
0052 7436 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     7438 0039 
0053 743A 1109  14         jlt   !                     ; Next character
0054 743C 130A  14         jeq   fm.browse.fname.suffix.inc.alpha
0055                                                   ; Swith to alpha range A..Z
0056 743E 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     7440 0084 
0057 7442 131D  14         jeq   fm.browse.fname.suffix.exit
0058                                                   ; Already last alpha character, so exit
0059 7444 1104  14         jlt   !                     ; Next character
0060                       ;------------------------------------------------------
0061                       ; Invalid character, crash and burn
0062                       ;------------------------------------------------------
0063               fm.browse.fname.suffix.inc.crash:
0064 7446 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7448 FFCE 
0065 744A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     744C 2030 
0066                       ;------------------------------------------------------
0067                       ; Increase ASCII value last character in filename
0068                       ;------------------------------------------------------
0069 744E 0585  14 !       inc   tmp1                  ; Increase ASCII value
0070 7450 1014  14         jmp   fm.browse.fname.suffix.store
0071               fm.browse.fname.suffix.inc.alpha:
0072 7452 0205  20         li    tmp1,65               ; Set ASCII 65 (char A)
     7454 0041 
0073 7456 1011  14         jmp   fm.browse.fname.suffix.store
0074                       ;------------------------------------------------------
0075                       ; Decrease ASCII value last character in filename
0076                       ;------------------------------------------------------
0077               fm.browse.fname.suffix.dec:
0078 7458 0285  22         ci    tmp1,48               ; ASCII 48 (char 0) ?
     745A 0030 
0079 745C 1310  14         jeq   fm.browse.fname.suffix.exit
0080                                                   ; Already first numeric character, so exit
0081 745E 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     7460 0039 
0082 7462 1207  14         jle   !                     ; Previous character
0083 7464 0285  22         ci    tmp1,65               ; ASCII 65 (char A) ?
     7466 0041 
0084 7468 1306  14         jeq   fm.browse.fname.suffix.dec.numeric
0085                                                   ; Switch to numeric range 0..9
0086 746A 11ED  14         jlt   fm.browse.fname.suffix.inc.crash
0087                                                   ; Invalid character
0088 746C 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     746E 0084 
0089 7470 1306  14         jeq   fm.browse.fname.suffix.exit
0090 7472 0605  14 !       dec   tmp1                  ; Decrease ASCII value
0091 7474 1002  14         jmp   fm.browse.fname.suffix.store
0092               fm.browse.fname.suffix.dec.numeric:
0093 7476 0205  20         li    tmp1,57               ; Set ASCII 57 (char 9)
     7478 0039 
0094                       ;------------------------------------------------------
0095                       ; Store updatec character
0096                       ;------------------------------------------------------
0097               fm.browse.fname.suffix.store:
0098 747A 0A85  56         sla   tmp1,8                ; LSB to MSB
0099 747C D505  30         movb  tmp1,*tmp0            ; Store updated character
0100                       ;------------------------------------------------------
0101                       ; Exit
0102                       ;------------------------------------------------------
0103               fm.browse.fname.suffix.exit:
0104 747E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0105 7480 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0106 7482 C2F9  30         mov   *stack+,r11           ; Pop R11
0107 7484 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0131                       ;-----------------------------------------------------------------------
0132                       ; User hook, background tasks
0133                       ;-----------------------------------------------------------------------
0134                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
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
0012 7486 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     7488 2014 
0013 748A 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 748C 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     748E 2014 
0019 7490 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     7492 833C 
     7494 833E 
0020 7496 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 7498 C820  54         mov   @waux1,@waux2         ; Save as previous key
     749A 833C 
     749C 833E 
0026 749E 0460  28         b     @edkey.key.process    ; Process key
     74A0 60E4 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 74A2 04E0  34         clr   @waux1
     74A4 833C 
0032 74A6 04E0  34         clr   @waux2
     74A8 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 74AA 0204  20         li    tmp0,2000             ; Avoid key bouncing
     74AC 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 74AE 0604  14         dec   tmp0
0043 74B0 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 74B2 0460  28         b     @hookok               ; Return
     74B4 2C80 
**** **** ****     > stevie_b1.asm.24929
0135                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
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
0015 74B6 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     74B8 A302 
0016 74BA 1308  14         jeq   !                     ; No, skip CMDB pane
0017                       ;-------------------------------------------------------
0018                       ; Draw command buffer pane if dirty
0019                       ;-------------------------------------------------------
0020               task.vdp.panes.cmdb.draw:
0021 74BC C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     74BE A318 
0022 74C0 1344  14         jeq   task.vdp.panes.exit   ; No, skip update
0023               
0024 74C2 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     74C4 77E4 
0025 74C6 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     74C8 A318 
0026 74CA 103F  14         jmp   task.vdp.panes.exit   ; Exit early
0027                       ;-------------------------------------------------------
0028                       ; Check if frame buffer dirty
0029                       ;-------------------------------------------------------
0030 74CC C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     74CE A116 
0031 74D0 133C  14         jeq   task.vdp.panes.exit   ; No, skip update
0032 74D2 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     74D4 832A 
     74D6 A114 
0033                       ;------------------------------------------------------
0034                       ; Determine how many rows to copy
0035                       ;------------------------------------------------------
0036 74D8 8820  54         c     @edb.lines,@fb.scrrows
     74DA A204 
     74DC A118 
0037 74DE 1103  14         jlt   task.vdp.panes.setrows.small
0038 74E0 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     74E2 A118 
0039 74E4 1003  14         jmp   task.vdp.panes.copy.framebuffer
0040                       ;------------------------------------------------------
0041                       ; Less lines in editor buffer as rows in frame buffer
0042                       ;------------------------------------------------------
0043               task.vdp.panes.setrows.small:
0044 74E6 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     74E8 A204 
0045 74EA 0585  14         inc   tmp1
0046                       ;------------------------------------------------------
0047                       ; Determine area to copy
0048                       ;------------------------------------------------------
0049               task.vdp.panes.copy.framebuffer:
0050 74EC 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     74EE A10E 
0051                                                   ; 16 bit part is in tmp2!
0052 74F0 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0053 74F2 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     74F4 A100 
0054                       ;------------------------------------------------------
0055                       ; Copy memory block
0056                       ;------------------------------------------------------
0057 74F6 06A0  32         bl    @xpym2v               ; Copy to VDP
     74F8 245A 
0058                                                   ; \ i  tmp0 = VDP target address
0059                                                   ; | i  tmp1 = RAM source address
0060                                                   ; / i  tmp2 = Bytes to copy
0061 74FA 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     74FC A116 
0062                       ;-------------------------------------------------------
0063                       ; Draw EOF marker at end-of-file
0064                       ;-------------------------------------------------------
0065 74FE C120  34         mov   @edb.lines,tmp0
     7500 A204 
0066 7502 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7504 A104 
0067 7506 0584  14         inc   tmp0                  ; Y = Y + 1
0068 7508 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     750A A118 
0069 750C 121C  14         jle   task.vdp.panes.botline.draw
0070                                                   ; Skip drawing EOF maker
0071                       ;-------------------------------------------------------
0072                       ; Do actual drawing of EOF marker
0073                       ;-------------------------------------------------------
0074               task.vdp.panes.draw_marker:
0075 750E 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0076 7510 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7512 832A 
0077               
0078 7514 06A0  32         bl    @putstr
     7516 2428 
0079 7518 30CC                   data txt.marker       ; Display *EOF*
0080               
0081 751A 06A0  32         bl    @setx
     751C 26A6 
0082 751E 0005                   data  5               ; Cursor after *EOF* string
0083                       ;-------------------------------------------------------
0084                       ; Clear rest of screen
0085                       ;-------------------------------------------------------
0086               task.vdp.panes.clear_screen:
0087 7520 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     7522 A10E 
0088               
0089 7524 C160  34         mov   @wyx,tmp1             ;
     7526 832A 
0090 7528 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0091 752A 0505  16         neg   tmp1                  ; tmp1 = -Y position
0092 752C A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     752E A118 
0093               
0094 7530 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0095 7532 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     7534 FFFB 
0096               
0097 7536 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7538 2404 
0098                                                   ; \ i  @wyx = Cursor position
0099                                                   ; / o  tmp0 = VDP address
0100               
0101 753A 04C5  14         clr   tmp1                  ; Character to write (null!)
0102 753C 06A0  32         bl    @xfilv                ; Fill VDP memory
     753E 229E 
0103                                                   ; \ i  tmp0 = VDP destination
0104                                                   ; | i  tmp1 = byte to write
0105                                                   ; / i  tmp2 = Number of bytes to write
0106               
0107 7540 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7542 A114 
     7544 832A 
0108                       ;-------------------------------------------------------
0109                       ; Draw status line
0110                       ;-------------------------------------------------------
0111               task.vdp.panes.botline.draw:
0112 7546 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     7548 7936 
0113                       ;------------------------------------------------------
0114                       ; Exit task
0115                       ;------------------------------------------------------
0116               task.vdp.panes.exit:
0117 754A 0460  28         b     @slotok
     754C 2CFC 
**** **** ****     > stevie_b1.asm.24929
0136                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
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
0012 754E C120  34         mov   @tv.pane.focus,tmp0
     7550 A01A 
0013 7552 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 7554 0284  22         ci    tmp0,pane.focus.cmdb
     7556 0001 
0016 7558 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 755A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     755C FFCE 
0022 755E 06A0  32         bl    @cpu.crash            ; / Halt system.
     7560 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 7562 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7564 A30A 
     7566 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 7568 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     756A 202A 
0032 756C 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     756E 26B2 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 7570 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     7572 2F50 
0036               
0037 7574 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7576 2454 
0038 7578 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     757A 2F50 
     757C 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 757E 0460  28         b     @slotok               ; Exit task
     7580 2CFC 
**** **** ****     > stevie_b1.asm.24929
0137                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
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
0012 7582 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     7584 A112 
0013 7586 1303  14         jeq   task.vdp.cursor.visible
0014 7588 04E0  34         clr   @ramsat+2              ; Hide cursor
     758A 2F52 
0015 758C 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 758E C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7590 A20A 
0019 7592 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 7594 C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     7596 A01A 
0025 7598 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 759A 0284  22         ci    tmp0,pane.focus.cmdb
     759C 0001 
0028 759E 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 75A0 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 75A2 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 75A4 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     75A6 0100 
0040 75A8 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 75AA 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     75AC 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 75AE D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     75B0 A014 
0051 75B2 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     75B4 A014 
     75B6 2F52 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 75B8 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     75BA 2454 
0057 75BC 2180                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     75BE 2F50 
     75C0 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 75C2 C120  34         mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
     75C4 A302 
0064 75C6 1602  14         jne   task.vdp.cursor.exit   ; Exit, if visible
0065 75C8 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     75CA 7936 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               task.vdp.cursor.exit:
0070 75CC 0460  28         b     @slotok                ; Exit task
     75CE 2CFC 
**** **** ****     > stevie_b1.asm.24929
0138                       copy  "task.oneshot.asm"    ; Task - One shot
**** **** ****     > task.oneshot.asm
0001               task.oneshot:
0002 75D0 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     75D2 A01C 
0003 75D4 1301  14         jeq   task.oneshot.exit
0004               
0005 75D6 0694  24         bl    *tmp0                  ; Execute one-shot task
0006                       ;------------------------------------------------------
0007                       ; Exit
0008                       ;------------------------------------------------------
0009               task.oneshot.exit:
0010 75D8 0460  28         b     @slotok                ; Exit task
     75DA 2CFC 
**** **** ****     > stevie_b1.asm.24929
0139                       ;-----------------------------------------------------------------------
0140                       ; Screen pane utilities
0141                       ;-----------------------------------------------------------------------
0142                       copy  "pane.utils.asm"      ; Pane utility functions
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
0026 75DC 0649  14         dect  stack
0027 75DE C64B  30         mov   r11,*stack            ; Save return address
0028 75E0 0649  14         dect  stack
0029 75E2 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 75E4 0649  14         dect  stack
0031 75E6 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 75E8 0649  14         dect  stack
0033 75EA C646  30         mov   tmp2,*stack           ; Push tmp2
0034 75EC 0649  14         dect  stack
0035 75EE C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;-------------------------------------------------------
0037                       ; Display string
0038                       ;-------------------------------------------------------
0039 75F0 C820  54         mov   @parm1,@wyx           ; Set cursor
     75F2 2F20 
     75F4 832A 
0040 75F6 C160  34         mov   @parm2,tmp1           ; Get string to display
     75F8 2F22 
0041 75FA 06A0  32         bl    @xutst0               ; Display string
     75FC 242A 
0042                       ;-------------------------------------------------------
0043                       ; Get number of bytes to fill ...
0044                       ;-------------------------------------------------------
0045 75FE C120  34         mov   @parm2,tmp0
     7600 2F22 
0046 7602 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0047 7604 0984  56         srl   tmp0,8                ; Right justify
0048 7606 C184  18         mov   tmp0,tmp2
0049 7608 C1C4  18         mov   tmp0,tmp3             ; Work copy
0050 760A 0506  16         neg   tmp2
0051 760C 0226  22         ai    tmp2,80               ; Number of bytes to fill
     760E 0050 
0052                       ;-------------------------------------------------------
0053                       ; ... and clear until end of line
0054                       ;-------------------------------------------------------
0055 7610 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     7612 2F20 
0056 7614 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0057 7616 C804  38         mov   tmp0,@wyx             ; / Set cursor
     7618 832A 
0058               
0059 761A 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     761C 2404 
0060                                                   ; \ i  @wyx = Cursor position
0061                                                   ; / o  tmp0 = VDP target address
0062               
0063 761E 0205  20         li    tmp1,32               ; Byte to fill
     7620 0020 
0064               
0065 7622 06A0  32         bl    @xfilv                ; Clear line
     7624 229E 
0066                                                   ; i \  tmp0 = start address
0067                                                   ; i |  tmp1 = byte to fill
0068                                                   ; i /  tmp2 = number of bytes to fill
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               pane.show_hintx.exit:
0073 7626 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0074 7628 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0075 762A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0076 762C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0077 762E C2F9  30         mov   *stack+,r11           ; Pop R11
0078 7630 045B  20         b     *r11                  ; Return to caller
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
0100 7632 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     7634 2F20 
0101 7636 C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     7638 2F22 
0102 763A 0649  14         dect  stack
0103 763C C64B  30         mov   r11,*stack            ; Save return address
0104                       ;-------------------------------------------------------
0105                       ; Display pane hint
0106                       ;-------------------------------------------------------
0107 763E 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7640 75DC 
0108                       ;-------------------------------------------------------
0109                       ; Exit
0110                       ;-------------------------------------------------------
0111               pane.show_hint.exit:
0112 7642 C2F9  30         mov   *stack+,r11           ; Pop R11
0113 7644 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0143                       copy  "pane.utils.colorscheme.asm"
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
0021 7646 0649  14         dect  stack
0022 7648 C64B  30         mov   r11,*stack            ; Push return address
0023 764A 0649  14         dect  stack
0024 764C C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 764E C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7650 A012 
0027 7652 0284  22         ci    tmp0,tv.colorscheme.entries - 1
     7654 0008 
0028                                                   ; Last entry reached?
0029 7656 1102  14         jlt   !
0030 7658 04C4  14         clr   tmp0
0031 765A 1001  14         jmp   pane.action.colorscheme.switch
0032 765C 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 765E C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7660 A012 
0038 7662 06A0  32         bl    @pane.action.colorscheme.load
     7664 76CE 
0039                       ;-------------------------------------------------------
0040                       ; Show current color scheme message
0041                       ;-------------------------------------------------------
0042 7666 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     7668 832A 
     766A 833C 
0043               
0044 766C 06A0  32         bl    @filv
     766E 2298 
0045 7670 183C                   data >183C,>1F,20     ; VDP start address (frame buffer area)
     7672 001F 
     7674 0014 
0046               
0047 7676 06A0  32         bl    @putat
     7678 244C 
0048 767A 003C                   byte 0,60
0049 767C 334E                   data txt.colorscheme  ; Show color scheme message
0050               
0051 767E 06A0  32         bl    @putnum
     7680 2A10 
0052 7682 004B                   byte 0,75
0053 7684 A012                   data tv.colorscheme,rambuf,>3020
     7686 2F60 
     7688 3020 
0054               
0055 768A C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     768C 833C 
     768E 832A 
0056                       ;-------------------------------------------------------
0057                       ; Delay
0058                       ;-------------------------------------------------------
0059 7690 0204  20         li    tmp0,12000
     7692 2EE0 
0060 7694 0604  14 !       dec   tmp0
0061 7696 16FE  14         jne   -!
0062                       ;-------------------------------------------------------
0063                       ; Setup one shot task for removing message
0064                       ;-------------------------------------------------------
0065 7698 0204  20         li    tmp0,pane.action.colorscheme.task.callback
     769A 76AC 
0066 769C C804  38         mov   tmp0,@tv.task.oneshot
     769E A01C 
0067               
0068 76A0 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     76A2 2D66 
0069 76A4 0003                   data 3                ; / for getting consistent delay
0070                       ;-------------------------------------------------------
0071                       ; Exit
0072                       ;-------------------------------------------------------
0073               pane.action.colorscheme.cycle.exit:
0074 76A6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 76A8 C2F9  30         mov   *stack+,r11           ; Pop R11
0076 76AA 045B  20         b     *r11                  ; Return to caller
0077                       ;-------------------------------------------------------
0078                       ; Remove colorscheme message (triggered by oneshot task)
0079                       ;-------------------------------------------------------
0080               pane.action.colorscheme.task.callback:
0081 76AC 0649  14         dect  stack
0082 76AE C64B  30         mov   r11,*stack            ; Push return address
0083               
0084 76B0 06A0  32         bl    @filv
     76B2 2298 
0085 76B4 003C                   data >003C,>00,20     ; Remove message
     76B6 0000 
     76B8 0014 
0086               
0087 76BA 0720  34         seto  @parm1
     76BC 2F20 
0088 76BE 06A0  32         bl    @pane.action.colorscheme.load
     76C0 76CE 
0089                                                   ; Reload current colorscheme
0090                                                   ; \ i  parm1 = Do not turn screen off
0091                                                   ; /
0092               
0093 76C2 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     76C4 A116 
0094 76C6 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     76C8 A01C 
0095               
0096 76CA C2F9  30         mov   *stack+,r11           ; Pop R11
0097 76CC 045B  20         b     *r11                  ; Return to task
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
0118 76CE 0649  14         dect  stack
0119 76D0 C64B  30         mov   r11,*stack            ; Save return address
0120 76D2 0649  14         dect  stack
0121 76D4 C644  30         mov   tmp0,*stack           ; Push tmp0
0122 76D6 0649  14         dect  stack
0123 76D8 C645  30         mov   tmp1,*stack           ; Push tmp1
0124 76DA 0649  14         dect  stack
0125 76DC C646  30         mov   tmp2,*stack           ; Push tmp2
0126 76DE 0649  14         dect  stack
0127 76E0 C647  30         mov   tmp3,*stack           ; Push tmp3
0128 76E2 0649  14         dect  stack
0129 76E4 C648  30         mov   tmp4,*stack           ; Push tmp4
0130                       ;-------------------------------------------------------
0131                       ; Turn screen of
0132                       ;-------------------------------------------------------
0133 76E6 C120  34         mov   @parm1,tmp0
     76E8 2F20 
0134 76EA 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     76EC FFFF 
0135 76EE 1302  14         jeq   !                     ; Yes, so skip screen off
0136 76F0 06A0  32         bl    @scroff               ; Turn screen off
     76F2 2650 
0137                       ;-------------------------------------------------------
0138                       ; Get framebuffer foreground/background color
0139                       ;-------------------------------------------------------
0140 76F4 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     76F6 A012 
0141 76F8 0A24  56         sla   tmp0,2                ; Offset into color scheme data table
0142 76FA 0224  22         ai    tmp0,tv.colorscheme.table
     76FC 30A6 
0143                                                   ; Add base for color scheme data table
0144 76FE C1F4  30         mov   *tmp0+,tmp3           ; Get colors  (fb + status line)
0145 7700 C807  38         mov   tmp3,@tv.color        ; Save colors
     7702 A018 
0146                       ;-------------------------------------------------------
0147                       ; Get and save cursor color
0148                       ;-------------------------------------------------------
0149 7704 C214  26         mov   *tmp0,tmp4            ; Get cursor color
0150 7706 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     7708 00FF 
0151 770A C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     770C A016 
0152                       ;-------------------------------------------------------
0153                       ; Get CMDB pane foreground/background color
0154                       ;-------------------------------------------------------
0155 770E C214  26         mov   *tmp0,tmp4            ; Get CMDB pane
0156 7710 0248  22         andi  tmp4,>ff00            ; Only keep MSB
     7712 FF00 
0157 7714 0988  56         srl   tmp4,8                ; MSB to LSB
0158                       ;-------------------------------------------------------
0159                       ; Dump colors to VDP register 7 (text mode)
0160                       ;-------------------------------------------------------
0161 7716 C147  18         mov   tmp3,tmp1             ; Get work copy
0162 7718 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0163 771A 0265  22         ori   tmp1,>0700
     771C 0700 
0164 771E C105  18         mov   tmp1,tmp0
0165 7720 06A0  32         bl    @putvrx               ; Write VDP register
     7722 233E 
0166                       ;-------------------------------------------------------
0167                       ; Dump colors for frame buffer pane (TAT)
0168                       ;-------------------------------------------------------
0169 7724 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     7726 1800 
0170 7728 C147  18         mov   tmp3,tmp1             ; Get work copy of colors
0171 772A 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0172 772C 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     772E 0910 
0173 7730 06A0  32         bl    @xfilv                ; Fill colors
     7732 229E 
0174                                                   ; i \  tmp0 = start address
0175                                                   ; i |  tmp1 = byte to fill
0176                                                   ; i /  tmp2 = number of bytes to fill
0177                       ;-------------------------------------------------------
0178                       ; Dump colors for CMDB pane (TAT)
0179                       ;-------------------------------------------------------
0180               pane.action.colorscheme.cmdbpane:
0181 7734 C120  34         mov   @cmdb.visible,tmp0
     7736 A302 
0182 7738 1307  14         jeq   pane.action.colorscheme.errpane
0183                                                   ; Skip if CMDB pane is hidden
0184               
0185 773A 0204  20         li    tmp0,>1fd0            ; VDP start address (bottom status line)
     773C 1FD0 
0186 773E C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0187 7740 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     7742 0190 
0188 7744 06A0  32         bl    @xfilv                ; Fill colors
     7746 229E 
0189                                                   ; i \  tmp0 = start address
0190                                                   ; i |  tmp1 = byte to fill
0191                                                   ; i /  tmp2 = number of bytes to fill
0192                       ;-------------------------------------------------------
0193                       ; Dump colors for error line pane (TAT)
0194                       ;-------------------------------------------------------
0195               pane.action.colorscheme.errpane:
0196 7748 C120  34         mov   @tv.error.visible,tmp0
     774A A01E 
0197 774C 1304  14         jeq   pane.action.colorscheme.statusline
0198                                                   ; Skip if error line pane is hidden
0199               
0200 774E 0205  20         li    tmp1,>00f6            ; White on dark red
     7750 00F6 
0201 7752 06A0  32         bl    @pane.action.colorscheme.errline
     7754 7788 
0202                                                   ; Load color combination for error line
0203                       ;-------------------------------------------------------
0204                       ; Dump colors for bottom status line pane (TAT)
0205                       ;-------------------------------------------------------
0206               pane.action.colorscheme.statusline:
0207 7756 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     7758 2110 
0208 775A C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0209 775C 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     775E 00FF 
0210 7760 0206  20         li    tmp2,80               ; Number of bytes to fill
     7762 0050 
0211 7764 06A0  32         bl    @xfilv                ; Fill colors
     7766 229E 
0212                                                   ; i \  tmp0 = start address
0213                                                   ; i |  tmp1 = byte to fill
0214                                                   ; i /  tmp2 = number of bytes to fill
0215                       ;-------------------------------------------------------
0216                       ; Dump cursor FG color to sprite table (SAT)
0217                       ;-------------------------------------------------------
0218               pane.action.colorscheme.cursorcolor:
0219 7768 C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     776A A016 
0220 776C 0A88  56         sla   tmp4,8                ; Move to MSB
0221 776E D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7770 2F53 
0222 7772 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     7774 A015 
0223                       ;-------------------------------------------------------
0224                       ; Exit
0225                       ;-------------------------------------------------------
0226               pane.action.colorscheme.load.exit:
0227 7776 06A0  32         bl    @scron                ; Turn screen on
     7778 2658 
0228 777A C239  30         mov   *stack+,tmp4          ; Pop tmp4
0229 777C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0230 777E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0231 7780 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0232 7782 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0233 7784 C2F9  30         mov   *stack+,r11           ; Pop R11
0234 7786 045B  20         b     *r11                  ; Return to caller
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
0254 7788 0649  14         dect  stack
0255 778A C64B  30         mov   r11,*stack            ; Save return address
0256 778C 0649  14         dect  stack
0257 778E C644  30         mov   tmp0,*stack           ; Push tmp0
0258 7790 0649  14         dect  stack
0259 7792 C645  30         mov   tmp1,*stack           ; Push tmp1
0260 7794 0649  14         dect  stack
0261 7796 C646  30         mov   tmp2,*stack           ; Push tmp2
0262                       ;-------------------------------------------------------
0263                       ; Load error line colors
0264                       ;-------------------------------------------------------
0265 7798 0204  20         li    tmp0,>20C0            ; VDP start address (error line)
     779A 20C0 
0266 779C 0206  20         li    tmp2,80               ; Number of bytes to fill
     779E 0050 
0267 77A0 06A0  32         bl    @xfilv                ; Fill colors
     77A2 229E 
0268                                                   ; i \  tmp0 = start address
0269                                                   ; i |  tmp1 = byte to fill
0270                                                   ; i /  tmp2 = number of bytes to fill
0271                       ;-------------------------------------------------------
0272                       ; Exit
0273                       ;-------------------------------------------------------
0274               pane.action.colorscheme.errline.exit:
0275 77A4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0276 77A6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0277 77A8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0278 77AA C2F9  30         mov   *stack+,r11           ; Pop R11
0279 77AC 045B  20         b     *r11                  ; Return to caller
0280               
**** **** ****     > stevie_b1.asm.24929
0144                                                   ; Colorscheme handling in panes
0145                       copy  "pane.utils.tipiclock.asm"
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
0021 77AE 0649  14         dect  stack
0022 77B0 C64B  30         mov   r11,*stack            ; Push return address
0023 77B2 0649  14         dect  stack
0024 77B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;-------------------------------------------------------
0026                       ; Read DV80 file
0027                       ;-------------------------------------------------------
0028 77B6 0204  20         li    tmp0,fdname.clock
     77B8 33FC 
0029 77BA C804  38         mov   tmp0,@parm1           ; Pointer to length-prefixed 'PI.CLOCK'
     77BC 2F20 
0030               
0031 77BE 0204  20         li    tmp0,_pane.tipi.clock.cb.noop
     77C0 77E0 
0032 77C2 C804  38         mov   tmp0,@parm2           ; Register callback 1
     77C4 2F22 
0033 77C6 C804  38         mov   tmp0,@parm3           ; Register callback 2
     77C8 2F24 
0034 77CA C804  38         mov   tmp0,@parm5           ; Register callback 4 (ignore IO errors)
     77CC 2F28 
0035               
0036 77CE 0204  20         li    tmp0,_pane.tipi.clock.cb.datetime
     77D0 77E2 
0037 77D2 C804  38         mov   tmp0,@parm4           ; Register callback 3
     77D4 2F26 
0038               
0039 77D6 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     77D8 6EE4 
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
0055 77DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 77DC C2F9  30         mov   *stack+,r11           ; Pop R11
0057 77DE 045B  20         b     *r11                  ; Return to caller
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
0070 77E0 069B  24         bl    *r11                  ; Return to caller
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
0083 77E2 069B  24         bl    *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0146                                                   ; TIPI clock
0147                       ;-----------------------------------------------------------------------
0148                       ; Screen panes
0149                       ;-----------------------------------------------------------------------
0150                       copy  "pane.cmdb.asm"       ; Command buffer
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
0021 77E4 0649  14         dect  stack
0022 77E6 C64B  30         mov   r11,*stack            ; Save return address
0023 77E8 0649  14         dect  stack
0024 77EA C644  30         mov   tmp0,*stack           ; Push tmp0
0025 77EC 0649  14         dect  stack
0026 77EE C645  30         mov   tmp1,*stack           ; Push tmp1
0027 77F0 0649  14         dect  stack
0028 77F2 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Command buffer header line
0031                       ;------------------------------------------------------
0032 77F4 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     77F6 A30E 
     77F8 832A 
0033 77FA C160  34         mov   @cmdb.panhead,tmp1    ; | Display pane header
     77FC A31C 
0034 77FE 06A0  32         bl    @xutst0               ; /
     7800 242A 
0035               
0036 7802 06A0  32         bl    @setx
     7804 26A6 
0037 7806 000E                   data 14               ; Position cursor
0038               
0039 7808 06A0  32         bl    @putstr               ; Display horizontal line
     780A 2428 
0040 780C 32FA                   data txt.cmdb.hbar
0041                       ;------------------------------------------------------
0042                       ; Clear lines after prompt in command buffer
0043                       ;------------------------------------------------------
0044 780E C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7810 A322 
0045 7812 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0046 7814 A120  34         a     @cmdb.yxprompt,tmp0   ; |
     7816 A310 
0047 7818 C804  38         mov   tmp0,@wyx             ; /
     781A 832A 
0048               
0049 781C 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     781E 2404 
0050                                                   ; \ i  @wyx = Cursor position
0051                                                   ; / o  tmp0 = VDP target address
0052               
0053 7820 0205  20         li    tmp1,32
     7822 0020 
0054               
0055 7824 C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     7826 A322 
0056 7828 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0057 782A 0506  16         neg   tmp2                  ; | Based on command & prompt length
0058 782C 0226  22         ai    tmp2,2*80 - 1         ; /
     782E 009F 
0059               
0060 7830 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     7832 229E 
0061                                                   ; | i  tmp0 = VDP target address
0062                                                   ; | i  tmp1 = Byte to fill
0063                                                   ; / i  tmp2 = Number of bytes to fill
0064                       ;------------------------------------------------------
0065                       ; Display pane hint in command buffer
0066                       ;------------------------------------------------------
0067 7834 0204  20         li    tmp0,>1c00            ; Y=28, X=0
     7836 1C00 
0068 7838 C804  38         mov   tmp0,@parm1           ; Set parameter
     783A 2F20 
0069 783C C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     783E A31E 
     7840 2F22 
0070               
0071 7842 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7844 75DC 
0072                                                   ; \ i  parm1 = Pointer to string with hint
0073                                                   ; / i  parm2 = YX position
0074                       ;------------------------------------------------------
0075                       ; Display keys in status line
0076                       ;------------------------------------------------------
0077 7846 0204  20         li    tmp0,>1d00            ; Y = 29, X=0
     7848 1D00 
0078 784A C804  38         mov   tmp0,@parm1           ; Set parameter
     784C 2F20 
0079 784E C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7850 A320 
     7852 2F22 
0080               
0081 7854 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7856 75DC 
0082                                                   ; \ i  parm1 = Pointer to string with hint
0083                                                   ; / i  parm2 = YX position
0084                       ;------------------------------------------------------
0085                       ; Command buffer content
0086                       ;------------------------------------------------------
0087 7858 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     785A 6E0E 
0088                       ;------------------------------------------------------
0089                       ; Exit
0090                       ;------------------------------------------------------
0091               pane.cmdb.exit:
0092 785C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0093 785E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0094 7860 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0095 7862 C2F9  30         mov   *stack+,r11           ; Pop r11
0096 7864 045B  20         b     *r11                  ; Return
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
0117 7866 0649  14         dect  stack
0118 7868 C64B  30         mov   r11,*stack            ; Save return address
0119 786A 0649  14         dect  stack
0120 786C C644  30         mov   tmp0,*stack           ; Push tmp0
0121                       ;------------------------------------------------------
0122                       ; Show command buffer pane
0123                       ;------------------------------------------------------
0124 786E C820  54         mov   @wyx,@cmdb.fb.yxsave
     7870 832A 
     7872 A304 
0125                                                   ; Save YX position in frame buffer
0126               
0127 7874 C120  34         mov   @fb.scrrows.max,tmp0
     7876 A11A 
0128 7878 6120  34         s     @cmdb.scrrows,tmp0
     787A A306 
0129 787C C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     787E A118 
0130               
0131 7880 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0132 7882 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7884 A30E 
0133               
0134 7886 0224  22         ai    tmp0,>0100
     7888 0100 
0135 788A C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     788C A310 
0136 788E 0584  14         inc   tmp0
0137 7890 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7892 A30A 
0138               
0139 7894 0720  34         seto  @cmdb.visible         ; Show pane
     7896 A302 
0140 7898 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     789A A318 
0141               
0142 789C 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     789E 0001 
0143 78A0 C804  38         mov   tmp0,@tv.pane.focus   ; /
     78A2 A01A 
0144               
0145                       ;bl    @cmdb.cmd.clear      ; Clear current command
0146               
0147 78A4 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     78A6 7922 
0148               
0149 78A8 06A0  32         bl    @pane.action.colorscheme.load
     78AA 76CE 
0150                                                   ; Reload colorscheme
0151               pane.cmdb.show.exit:
0152                       ;------------------------------------------------------
0153                       ; Exit
0154                       ;------------------------------------------------------
0155 78AC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0156 78AE C2F9  30         mov   *stack+,r11           ; Pop r11
0157 78B0 045B  20         b     *r11                  ; Return to caller
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
0180 78B2 0649  14         dect  stack
0181 78B4 C64B  30         mov   r11,*stack            ; Save return address
0182                       ;------------------------------------------------------
0183                       ; Hide command buffer pane
0184                       ;------------------------------------------------------
0185 78B6 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     78B8 A11A 
     78BA A118 
0186                       ;------------------------------------------------------
0187                       ; Adjust frame buffer size if error pane visible
0188                       ;------------------------------------------------------
0189 78BC C820  54         mov   @tv.error.visible,@tv.error.visible
     78BE A01E 
     78C0 A01E 
0190 78C2 1302  14         jeq   !
0191 78C4 0620  34         dec   @fb.scrrows
     78C6 A118 
0192                       ;------------------------------------------------------
0193                       ; Clear error/hint & status line
0194                       ;------------------------------------------------------
0195 78C8 06A0  32 !       bl    @hchar
     78CA 2784 
0196 78CC 1C00                   byte 28,0,32,80*2
     78CE 20A0 
0197 78D0 FFFF                   data EOL
0198                       ;------------------------------------------------------
0199                       ; Hide command buffer pane (rest)
0200                       ;------------------------------------------------------
0201 78D2 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     78D4 A304 
     78D6 832A 
0202 78D8 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     78DA A302 
0203 78DC 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     78DE A116 
0204 78E0 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     78E2 A01A 
0205                       ;------------------------------------------------------
0206                       ; Reload current color scheme
0207                       ;------------------------------------------------------
0208 78E4 0720  34         seto  @parm1                ; Do not turn screen off while
     78E6 2F20 
0209                                                   ; reloading color scheme
0210               
0211 78E8 06A0  32         bl    @pane.action.colorscheme.load
     78EA 76CE 
0212                                                   ; Reload color scheme
0213                       ;------------------------------------------------------
0214                       ; Exit
0215                       ;------------------------------------------------------
0216               pane.cmdb.hide.exit:
0217 78EC C2F9  30         mov   *stack+,r11           ; Pop r11
0218 78EE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0151                       copy  "pane.errline.asm"    ; Error line
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
0026 78F0 0649  14         dect  stack
0027 78F2 C64B  30         mov   r11,*stack            ; Save return address
0028 78F4 0649  14         dect  stack
0029 78F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 78F8 0649  14         dect  stack
0031 78FA C645  30         mov   tmp1,*stack           ; Push tmp1
0032               
0033 78FC 0205  20         li    tmp1,>00f6            ; White on dark red
     78FE 00F6 
0034 7900 06A0  32         bl    @pane.action.colorscheme.errline
     7902 7788 
0035                       ;------------------------------------------------------
0036                       ; Show error line content
0037                       ;------------------------------------------------------
0038 7904 06A0  32         bl    @putat                ; Display error message
     7906 244C 
0039 7908 1C00                   byte 28,0
0040 790A A020                   data tv.error.msg
0041               
0042 790C C120  34         mov   @fb.scrrows.max,tmp0
     790E A11A 
0043 7910 0604  14         dec   tmp0
0044 7912 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7914 A118 
0045               
0046 7916 0720  34         seto  @tv.error.visible     ; Error line is visible
     7918 A01E 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               pane.errline.show.exit:
0051 791A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 791C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 791E C2F9  30         mov   *stack+,r11           ; Pop r11
0054 7920 045B  20         b     *r11                  ; Return to caller
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
0076 7922 0649  14         dect  stack
0077 7924 C64B  30         mov   r11,*stack            ; Save return address
0078                       ;------------------------------------------------------
0079                       ; Hide command buffer pane
0080                       ;------------------------------------------------------
0081 7926 06A0  32 !       bl    @errline.init         ; Clear error line
     7928 6EC0 
0082 792A C160  34         mov   @tv.color,tmp1        ; Get foreground/background color
     792C A018 
0083 792E 06A0  32         bl    @pane.action.colorscheme.errline
     7930 7788 
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               pane.errline.hide.exit:
0088 7932 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 7934 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.24929
0152                       copy  "pane.botline.asm"    ; Status line
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
0021 7936 0649  14         dect  stack
0022 7938 C64B  30         mov   r11,*stack            ; Save return address
0023 793A 0649  14         dect  stack
0024 793C C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 793E C820  54         mov   @wyx,@fb.yxsave
     7940 832A 
     7942 A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 7944 06A0  32         bl    @putat
     7946 244C 
0032 7948 1D00                   byte  29,0
0033 794A 3102                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 794C 06A0  32         bl    @at
     794E 2690 
0039 7950 1D03                   byte  29,3            ; Position cursor
0040 7952 C160  34         mov   @edb.filename.ptr,tmp1
     7954 A20E 
0041                                                   ; Get string to display
0042 7956 06A0  32         bl    @xutst0               ; Display string
     7958 242A 
0043               
0044 795A 06A0  32         bl    @at
     795C 2690 
0045 795E 1D2C                   byte  29,44           ; Position cursor
0046               
0047 7960 C160  34         mov   @edb.filetype.ptr,tmp1
     7962 A210 
0048                                                   ; Get string to display
0049 7964 06A0  32         bl    @xutst0               ; Display Filetype string
     7966 242A 
0050                       ;------------------------------------------------------
0051                       ; ALPHA-Lock key down?
0052                       ;------------------------------------------------------
0053 7968 20A0  38         coc   @wbit10,config
     796A 2016 
0054 796C 1305  14         jeq   pane.botline.alpha.down
0055                       ;------------------------------------------------------
0056                       ; AlPHA-Lock is up
0057                       ;------------------------------------------------------
0058 796E 06A0  32         bl    @putat
     7970 244C 
0059 7972 1D2A                   byte   29,42
0060 7974 3122                   data   txt.alpha.down
0061               
0062 7976 1004  14         jmp   pane.botline.show_mode
0063                       ;------------------------------------------------------
0064                       ; AlPHA-Lock is down
0065                       ;------------------------------------------------------
0066               pane.botline.alpha.down:
0067 7978 06A0  32         bl    @putat
     797A 244C 
0068 797C 1D2A                   byte   29,42
0069 797E 3122                   data   txt.alpha.down
0070                       ;------------------------------------------------------
0071                       ; Show text editing mode
0072                       ;------------------------------------------------------
0073               pane.botline.show_mode:
0074 7980 C120  34         mov   @edb.insmode,tmp0
     7982 A20A 
0075 7984 1605  14         jne   pane.botline.show_mode.insert
0076                       ;------------------------------------------------------
0077                       ; Overwrite mode
0078                       ;------------------------------------------------------
0079               pane.botline.show_mode.overwrite:
0080 7986 06A0  32         bl    @putat
     7988 244C 
0081 798A 1D32                   byte  29,50
0082 798C 30D8                   data  txt.ovrwrite
0083 798E 1004  14         jmp   pane.botline.show_changed
0084                       ;------------------------------------------------------
0085                       ; Insert  mode
0086                       ;------------------------------------------------------
0087               pane.botline.show_mode.insert:
0088 7990 06A0  32         bl    @putat
     7992 244C 
0089 7994 1D32                   byte  29,50
0090 7996 30DC                   data  txt.insert
0091                       ;------------------------------------------------------
0092                       ; Show if text was changed in editor buffer
0093                       ;------------------------------------------------------
0094               pane.botline.show_changed:
0095 7998 C120  34         mov   @edb.dirty,tmp0
     799A A206 
0096 799C 1305  14         jeq   pane.botline.show_changed.clear
0097                       ;------------------------------------------------------
0098                       ; Show "*"
0099                       ;------------------------------------------------------
0100 799E 06A0  32         bl    @putat
     79A0 244C 
0101 79A2 1D36                   byte 29,54
0102 79A4 30E0                   data txt.star
0103 79A6 1001  14         jmp   pane.botline.show_linecol
0104                       ;------------------------------------------------------
0105                       ; Show "line,column"
0106                       ;------------------------------------------------------
0107               pane.botline.show_changed.clear:
0108 79A8 1000  14         nop
0109               pane.botline.show_linecol:
0110 79AA C820  54         mov   @fb.row,@parm1
     79AC A106 
     79AE 2F20 
0111 79B0 06A0  32         bl    @fb.row2line
     79B2 686C 
0112 79B4 05A0  34         inc   @outparm1
     79B6 2F30 
0113                       ;------------------------------------------------------
0114                       ; Show line
0115                       ;------------------------------------------------------
0116 79B8 06A0  32         bl    @putnum
     79BA 2A10 
0117 79BC 1D40                   byte  29,64           ; YX
0118 79BE 2F30                   data  outparm1,rambuf
     79C0 2F60 
0119 79C2 3020                   byte  48              ; ASCII offset
0120                             byte  32              ; Padding character
0121                       ;------------------------------------------------------
0122                       ; Show comma
0123                       ;------------------------------------------------------
0124 79C4 06A0  32         bl    @putat
     79C6 244C 
0125 79C8 1D45                   byte  29,69
0126 79CA 30CA                   data  txt.delim
0127                       ;------------------------------------------------------
0128                       ; Show column
0129                       ;------------------------------------------------------
0130 79CC 06A0  32         bl    @film
     79CE 2240 
0131 79D0 2F66                   data rambuf+6,32,12   ; Clear work buffer with space character
     79D2 0020 
     79D4 000C 
0132               
0133 79D6 C820  54         mov   @fb.column,@waux1
     79D8 A10C 
     79DA 833C 
0134 79DC 05A0  34         inc   @waux1                ; Offset 1
     79DE 833C 
0135               
0136 79E0 06A0  32         bl    @mknum                ; Convert unsigned number to string
     79E2 2992 
0137 79E4 833C                   data  waux1,rambuf
     79E6 2F60 
0138 79E8 3020                   byte  48              ; ASCII offset
0139                             byte  32              ; Fill character
0140               
0141 79EA 06A0  32         bl    @trimnum              ; Trim number to the left
     79EC 29EA 
0142 79EE 2F60                   data  rambuf,rambuf+6,32
     79F0 2F66 
     79F2 0020 
0143               
0144 79F4 0204  20         li    tmp0,>0200
     79F6 0200 
0145 79F8 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     79FA 2F66 
0146               
0147 79FC 06A0  32         bl    @putat
     79FE 244C 
0148 7A00 1D46                   byte 29,70
0149 7A02 2F66                   data rambuf+6         ; Show column
0150                       ;------------------------------------------------------
0151                       ; Show lines in buffer unless on last line in file
0152                       ;------------------------------------------------------
0153 7A04 C820  54         mov   @fb.row,@parm1
     7A06 A106 
     7A08 2F20 
0154 7A0A 06A0  32         bl    @fb.row2line
     7A0C 686C 
0155 7A0E 8820  54         c     @edb.lines,@outparm1
     7A10 A204 
     7A12 2F30 
0156 7A14 1605  14         jne   pane.botline.show_lines_in_buffer
0157               
0158 7A16 06A0  32         bl    @putat
     7A18 244C 
0159 7A1A 1D4B                   byte 29,75
0160 7A1C 30D2                   data txt.bottom
0161               
0162 7A1E 100B  14         jmp   pane.botline.exit
0163                       ;------------------------------------------------------
0164                       ; Show lines in buffer
0165                       ;------------------------------------------------------
0166               pane.botline.show_lines_in_buffer:
0167 7A20 C820  54         mov   @edb.lines,@waux1
     7A22 A204 
     7A24 833C 
0168 7A26 05A0  34         inc   @waux1                ; Offset 1
     7A28 833C 
0169 7A2A 06A0  32         bl    @putnum
     7A2C 2A10 
0170 7A2E 1D4B                   byte 29,75            ; YX
0171 7A30 833C                   data waux1,rambuf
     7A32 2F60 
0172 7A34 3020                   byte 48
0173                             byte 32
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               pane.botline.exit:
0178 7A36 C820  54         mov   @fb.yxsave,@wyx
     7A38 A114 
     7A3A 832A 
0179 7A3C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0180 7A3E C2F9  30         mov   *stack+,r11           ; Pop r11
0181 7A40 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.24929
0153                       ;-----------------------------------------------------------------------
0154                       ; Dialogs
0155                       ;-----------------------------------------------------------------------
0156                       copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
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
0027 7A42 0204  20         li    tmp0,id.dialog.load
     7A44 0001 
0028 7A46 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7A48 A31A 
0029               
0030 7A4A 0204  20         li    tmp0,txt.head.load
     7A4C 3126 
0031 7A4E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7A50 A31C 
0032               
0033 7A52 0204  20         li    tmp0,txt.hint.load
     7A54 3136 
0034 7A56 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7A58 A31E 
0035               
0036 7A5A 0204  20         li    tmp0,txt.keys.load
     7A5C 316C 
0037 7A5E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7A60 A320 
0038               
0039 7A62 0460  28         b     @edkey.action.cmdb.show
     7A64 6738 
0040                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.24929
0157                       copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
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
0027 7A66 0204  20         li    tmp0,id.dialog.save
     7A68 0002 
0028 7A6A C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7A6C A31A 
0029               
0030 7A6E 0204  20         li    tmp0,txt.head.save
     7A70 31B0 
0031 7A72 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7A74 A31C 
0032               
0033 7A76 0204  20         li    tmp0,txt.hint.save
     7A78 31C0 
0034 7A7A C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7A7C A31E 
0035               
0036 7A7E 0204  20         li    tmp0,txt.keys.save
     7A80 31F6 
0037 7A82 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7A84 A320 
0038               
0039 7A86 0460  28         b     @edkey.action.cmdb.show
     7A88 6738 
0040                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.24929
0158                       copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"
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
0027 7A8A 0204  20         li    tmp0,id.dialog.unsaved
     7A8C 0003 
0028 7A8E C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7A90 A31A 
0029               
0030 7A92 0204  20         li    tmp0,txt.head.unsaved
     7A94 3220 
0031 7A96 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7A98 A31C 
0032               
0033 7A9A 0204  20         li    tmp0,txt.hint.unsaved
     7A9C 3230 
0034 7A9E C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7AA0 A31E 
0035               
0036 7AA2 0204  20         li    tmp0,txt.keys.unsaved
     7AA4 3258 
0037 7AA6 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7AA8 A320 
0038               
0039 7AAA 0460  28         b     @edkey.action.cmdb.show
     7AAC 6738 
0040                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.24929
0159                       ;-----------------------------------------------------------------------
0160                       ; Program data
0161                       ;-----------------------------------------------------------------------
0162                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
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
0105 7AAE 0866             byte  8
0106 7AAF ....             text  'fctn + 0'
0107                       even
0108               
0109               txt.fctn.1
0110 7AB8 0866             byte  8
0111 7AB9 ....             text  'fctn + 1'
0112                       even
0113               
0114               txt.fctn.2
0115 7AC2 0866             byte  8
0116 7AC3 ....             text  'fctn + 2'
0117                       even
0118               
0119               txt.fctn.3
0120 7ACC 0866             byte  8
0121 7ACD ....             text  'fctn + 3'
0122                       even
0123               
0124               txt.fctn.4
0125 7AD6 0866             byte  8
0126 7AD7 ....             text  'fctn + 4'
0127                       even
0128               
0129               txt.fctn.5
0130 7AE0 0866             byte  8
0131 7AE1 ....             text  'fctn + 5'
0132                       even
0133               
0134               txt.fctn.6
0135 7AEA 0866             byte  8
0136 7AEB ....             text  'fctn + 6'
0137                       even
0138               
0139               txt.fctn.7
0140 7AF4 0866             byte  8
0141 7AF5 ....             text  'fctn + 7'
0142                       even
0143               
0144               txt.fctn.8
0145 7AFE 0866             byte  8
0146 7AFF ....             text  'fctn + 8'
0147                       even
0148               
0149               txt.fctn.9
0150 7B08 0866             byte  8
0151 7B09 ....             text  'fctn + 9'
0152                       even
0153               
0154               txt.fctn.a
0155 7B12 0866             byte  8
0156 7B13 ....             text  'fctn + a'
0157                       even
0158               
0159               txt.fctn.b
0160 7B1C 0866             byte  8
0161 7B1D ....             text  'fctn + b'
0162                       even
0163               
0164               txt.fctn.c
0165 7B26 0866             byte  8
0166 7B27 ....             text  'fctn + c'
0167                       even
0168               
0169               txt.fctn.d
0170 7B30 0866             byte  8
0171 7B31 ....             text  'fctn + d'
0172                       even
0173               
0174               txt.fctn.e
0175 7B3A 0866             byte  8
0176 7B3B ....             text  'fctn + e'
0177                       even
0178               
0179               txt.fctn.f
0180 7B44 0866             byte  8
0181 7B45 ....             text  'fctn + f'
0182                       even
0183               
0184               txt.fctn.g
0185 7B4E 0866             byte  8
0186 7B4F ....             text  'fctn + g'
0187                       even
0188               
0189               txt.fctn.h
0190 7B58 0866             byte  8
0191 7B59 ....             text  'fctn + h'
0192                       even
0193               
0194               txt.fctn.i
0195 7B62 0866             byte  8
0196 7B63 ....             text  'fctn + i'
0197                       even
0198               
0199               txt.fctn.j
0200 7B6C 0866             byte  8
0201 7B6D ....             text  'fctn + j'
0202                       even
0203               
0204               txt.fctn.k
0205 7B76 0866             byte  8
0206 7B77 ....             text  'fctn + k'
0207                       even
0208               
0209               txt.fctn.l
0210 7B80 0866             byte  8
0211 7B81 ....             text  'fctn + l'
0212                       even
0213               
0214               txt.fctn.m
0215 7B8A 0866             byte  8
0216 7B8B ....             text  'fctn + m'
0217                       even
0218               
0219               txt.fctn.n
0220 7B94 0866             byte  8
0221 7B95 ....             text  'fctn + n'
0222                       even
0223               
0224               txt.fctn.o
0225 7B9E 0866             byte  8
0226 7B9F ....             text  'fctn + o'
0227                       even
0228               
0229               txt.fctn.p
0230 7BA8 0866             byte  8
0231 7BA9 ....             text  'fctn + p'
0232                       even
0233               
0234               txt.fctn.q
0235 7BB2 0866             byte  8
0236 7BB3 ....             text  'fctn + q'
0237                       even
0238               
0239               txt.fctn.r
0240 7BBC 0866             byte  8
0241 7BBD ....             text  'fctn + r'
0242                       even
0243               
0244               txt.fctn.s
0245 7BC6 0866             byte  8
0246 7BC7 ....             text  'fctn + s'
0247                       even
0248               
0249               txt.fctn.t
0250 7BD0 0866             byte  8
0251 7BD1 ....             text  'fctn + t'
0252                       even
0253               
0254               txt.fctn.u
0255 7BDA 0866             byte  8
0256 7BDB ....             text  'fctn + u'
0257                       even
0258               
0259               txt.fctn.v
0260 7BE4 0866             byte  8
0261 7BE5 ....             text  'fctn + v'
0262                       even
0263               
0264               txt.fctn.w
0265 7BEE 0866             byte  8
0266 7BEF ....             text  'fctn + w'
0267                       even
0268               
0269               txt.fctn.x
0270 7BF8 0866             byte  8
0271 7BF9 ....             text  'fctn + x'
0272                       even
0273               
0274               txt.fctn.y
0275 7C02 0866             byte  8
0276 7C03 ....             text  'fctn + y'
0277                       even
0278               
0279               txt.fctn.z
0280 7C0C 0866             byte  8
0281 7C0D ....             text  'fctn + z'
0282                       even
0283               
0284               *---------------------------------------------------------------
0285               * Keyboard labels - Function keys extra
0286               *---------------------------------------------------------------
0287               txt.fctn.dot
0288 7C16 0866             byte  8
0289 7C17 ....             text  'fctn + .'
0290                       even
0291               
0292               txt.fctn.plus
0293 7C20 0866             byte  8
0294 7C21 ....             text  'fctn + +'
0295                       even
0296               
0297               
0298               txt.ctrl.dot
0299 7C2A 0863             byte  8
0300 7C2B ....             text  'ctrl + .'
0301                       even
0302               
0303               txt.ctrl.comma
0304 7C34 0863             byte  8
0305 7C35 ....             text  'ctrl + ,'
0306                       even
0307               
0308               *---------------------------------------------------------------
0309               * Keyboard labels - Control keys
0310               *---------------------------------------------------------------
0311               txt.ctrl.0
0312 7C3E 0863             byte  8
0313 7C3F ....             text  'ctrl + 0'
0314                       even
0315               
0316               txt.ctrl.1
0317 7C48 0863             byte  8
0318 7C49 ....             text  'ctrl + 1'
0319                       even
0320               
0321               txt.ctrl.2
0322 7C52 0863             byte  8
0323 7C53 ....             text  'ctrl + 2'
0324                       even
0325               
0326               txt.ctrl.3
0327 7C5C 0863             byte  8
0328 7C5D ....             text  'ctrl + 3'
0329                       even
0330               
0331               txt.ctrl.4
0332 7C66 0863             byte  8
0333 7C67 ....             text  'ctrl + 4'
0334                       even
0335               
0336               txt.ctrl.5
0337 7C70 0863             byte  8
0338 7C71 ....             text  'ctrl + 5'
0339                       even
0340               
0341               txt.ctrl.6
0342 7C7A 0863             byte  8
0343 7C7B ....             text  'ctrl + 6'
0344                       even
0345               
0346               txt.ctrl.7
0347 7C84 0863             byte  8
0348 7C85 ....             text  'ctrl + 7'
0349                       even
0350               
0351               txt.ctrl.8
0352 7C8E 0863             byte  8
0353 7C8F ....             text  'ctrl + 8'
0354                       even
0355               
0356               txt.ctrl.9
0357 7C98 0863             byte  8
0358 7C99 ....             text  'ctrl + 9'
0359                       even
0360               
0361               txt.ctrl.a
0362 7CA2 0863             byte  8
0363 7CA3 ....             text  'ctrl + a'
0364                       even
0365               
0366               txt.ctrl.b
0367 7CAC 0863             byte  8
0368 7CAD ....             text  'ctrl + b'
0369                       even
0370               
0371               txt.ctrl.c
0372 7CB6 0863             byte  8
0373 7CB7 ....             text  'ctrl + c'
0374                       even
0375               
0376               txt.ctrl.d
0377 7CC0 0863             byte  8
0378 7CC1 ....             text  'ctrl + d'
0379                       even
0380               
0381               txt.ctrl.e
0382 7CCA 0863             byte  8
0383 7CCB ....             text  'ctrl + e'
0384                       even
0385               
0386               txt.ctrl.f
0387 7CD4 0863             byte  8
0388 7CD5 ....             text  'ctrl + f'
0389                       even
0390               
0391               txt.ctrl.g
0392 7CDE 0863             byte  8
0393 7CDF ....             text  'ctrl + g'
0394                       even
0395               
0396               txt.ctrl.h
0397 7CE8 0863             byte  8
0398 7CE9 ....             text  'ctrl + h'
0399                       even
0400               
0401               txt.ctrl.i
0402 7CF2 0863             byte  8
0403 7CF3 ....             text  'ctrl + i'
0404                       even
0405               
0406               txt.ctrl.j
0407 7CFC 0863             byte  8
0408 7CFD ....             text  'ctrl + j'
0409                       even
0410               
0411               txt.ctrl.k
0412 7D06 0863             byte  8
0413 7D07 ....             text  'ctrl + k'
0414                       even
0415               
0416               txt.ctrl.l
0417 7D10 0863             byte  8
0418 7D11 ....             text  'ctrl + l'
0419                       even
0420               
0421               txt.ctrl.m
0422 7D1A 0863             byte  8
0423 7D1B ....             text  'ctrl + m'
0424                       even
0425               
0426               txt.ctrl.n
0427 7D24 0863             byte  8
0428 7D25 ....             text  'ctrl + n'
0429                       even
0430               
0431               txt.ctrl.o
0432 7D2E 0863             byte  8
0433 7D2F ....             text  'ctrl + o'
0434                       even
0435               
0436               txt.ctrl.p
0437 7D38 0863             byte  8
0438 7D39 ....             text  'ctrl + p'
0439                       even
0440               
0441               txt.ctrl.q
0442 7D42 0863             byte  8
0443 7D43 ....             text  'ctrl + q'
0444                       even
0445               
0446               txt.ctrl.r
0447 7D4C 0863             byte  8
0448 7D4D ....             text  'ctrl + r'
0449                       even
0450               
0451               txt.ctrl.s
0452 7D56 0863             byte  8
0453 7D57 ....             text  'ctrl + s'
0454                       even
0455               
0456               txt.ctrl.t
0457 7D60 0863             byte  8
0458 7D61 ....             text  'ctrl + t'
0459                       even
0460               
0461               txt.ctrl.u
0462 7D6A 0863             byte  8
0463 7D6B ....             text  'ctrl + u'
0464                       even
0465               
0466               txt.ctrl.v
0467 7D74 0863             byte  8
0468 7D75 ....             text  'ctrl + v'
0469                       even
0470               
0471               txt.ctrl.w
0472 7D7E 0863             byte  8
0473 7D7F ....             text  'ctrl + w'
0474                       even
0475               
0476               txt.ctrl.x
0477 7D88 0863             byte  8
0478 7D89 ....             text  'ctrl + x'
0479                       even
0480               
0481               txt.ctrl.y
0482 7D92 0863             byte  8
0483 7D93 ....             text  'ctrl + y'
0484                       even
0485               
0486               txt.ctrl.z
0487 7D9C 0863             byte  8
0488 7D9D ....             text  'ctrl + z'
0489                       even
0490               
0491               *---------------------------------------------------------------
0492               * Keyboard labels - control keys extra
0493               *---------------------------------------------------------------
0494               txt.ctrl.plus
0495 7DA6 0863             byte  8
0496 7DA7 ....             text  'ctrl + +'
0497                       even
0498               
0499               *---------------------------------------------------------------
0500               * Special keys
0501               *---------------------------------------------------------------
0502               txt.enter
0503 7DB0 0565             byte  5
0504 7DB1 ....             text  'enter'
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
0518 7DB6 0D00             data  key.enter, txt.enter, edkey.action.enter
     7DB8 7DB0 
     7DBA 6546 
0519 7DBC 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7DBE 7BC6 
     7DC0 6144 
0520 7DC2 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     7DC4 7B30 
     7DC6 615A 
0521 7DC8 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     7DCA 7B3A 
     7DCC 6172 
0522 7DCE 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     7DD0 7BF8 
     7DD2 61C4 
0523 7DD4 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     7DD6 7CA2 
     7DD8 6230 
0524 7DDA 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     7DDC 7CD4 
     7DDE 6248 
0525 7DE0 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     7DE2 7D56 
     7DE4 625C 
0526 7DE6 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     7DE8 7CC0 
     7DEA 62AE 
0527 7DEC 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     7DEE 7CCA 
     7DF0 630E 
0528 7DF2 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     7DF4 7D88 
     7DF6 6350 
0529 7DF8 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     7DFA 7D60 
     7DFC 637C 
0530 7DFE 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     7E00 7CAC 
     7E02 63A8 
0531                       ;-------------------------------------------------------
0532                       ; Modifier keys - Delete
0533                       ;-------------------------------------------------------
0534 7E04 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     7E06 7AB8 
     7E08 63E8 
0535 7E0A 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     7E0C 7ACC 
     7E0E 6454 
0536 7E10 0200             data  key.fctn.4, txt.fctn.4, edkey.action.del_eol
     7E12 7AD6 
     7E14 6420 
0537               
0538                       ;-------------------------------------------------------
0539                       ; Modifier keys - Insert
0540                       ;-------------------------------------------------------
0541 7E16 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     7E18 7AC2 
     7E1A 64AC 
0542 7E1C B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7E1E 7C16 
     7E20 65B4 
0543 7E22 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     7E24 7AE0 
     7E26 6502 
0544                       ;-------------------------------------------------------
0545                       ; Other action keys
0546                       ;-------------------------------------------------------
0547 7E28 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7E2A 7C20 
     7E2C 6614 
0548 7E2E 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7E30 7D9C 
     7E32 7646 
0549                       ;-------------------------------------------------------
0550                       ; Editor/File buffer keys
0551                       ;-------------------------------------------------------
0552 7E34 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.fb.buffer0
     7E36 7C3E 
     7E38 662A 
0553 7E3A B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.fb.buffer1
     7E3C 7C48 
     7E3E 6630 
0554 7E40 B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.fb.buffer2
     7E42 7C52 
     7E44 6636 
0555 7E46 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.fb.buffer3
     7E48 7C5C 
     7E4A 663C 
0556 7E4C B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.fb.buffer4
     7E4E 7C66 
     7E50 6642 
0557                ;      data  key.ctrl.5, txt.ctrl.5, edkey.action.fb.buffer5
0558 7E52 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.fb.buffer6
     7E54 7C7A 
     7E56 664E 
0559 7E58 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.fb.buffer7
     7E5A 7C84 
     7E5C 6654 
0560 7E5E 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.fb.buffer8
     7E60 7C8E 
     7E62 665A 
0561 7E64 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.fb.buffer9
     7E66 7C98 
     7E68 6660 
0562                       ;-------------------------------------------------------
0563                       ; Dialog keys
0564                       ;-------------------------------------------------------
0565 7E6A 8000             data  key.ctrl.comma, txt.ctrl.comma, edkey.action.fb.fname.dec.load
     7E6C 7C34 
     7E6E 6688 
0566 7E70 9B00             data  key.ctrl.dot, txt.ctrl.dot, edkey.action.fb.fname.inc.load
     7E72 7C2A 
     7E74 666E 
0567 7E76 8B00             data  key.ctrl.k, txt.ctrl.k, dialog.save
     7E78 7D06 
     7E7A 7A66 
0568 7E7C 8C00             data  key.ctrl.l, txt.ctrl.l, dialog.load
     7E7E 7D10 
     7E80 7A42 
0569                       ;-------------------------------------------------------
0570                       ; End of list
0571                       ;-------------------------------------------------------
0572 7E82 FFFF             data  EOL                           ; EOL
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
0584 7E84 0800             data  key.fctn.s, txt.fctn.s, edkey.action.cmdb.left
     7E86 7BC6 
     7E88 6694 
0585 7E8A 0900             data  key.fctn.d, txt.fctn.d, edkey.action.cmdb.right
     7E8C 7B30 
     7E8E 66A6 
0586 7E90 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.cmdb.home
     7E92 7CA2 
     7E94 66BE 
0587 7E96 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.cmdb.end
     7E98 7CD4 
     7E9A 66D2 
0588                       ;-------------------------------------------------------
0589                       ; Modifier keys
0590                       ;-------------------------------------------------------
0591 7E9C 0700             data  key.fctn.3, txt.fctn.3, edkey.action.cmdb.clear
     7E9E 7ACC 
     7EA0 66EA 
0592 7EA2 0D00             data  key.enter, txt.enter, edkey.action.cmdb.loadsave
     7EA4 7DB0 
     7EA6 674A 
0593                       ;-------------------------------------------------------
0594                       ; Other action keys
0595                       ;-------------------------------------------------------
0596 7EA8 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7EAA 7C20 
     7EAC 6614 
0597 7EAE 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7EB0 7D9C 
     7EB2 7646 
0598                       ;-------------------------------------------------------
0599                       ; File load dialog
0600                       ;-------------------------------------------------------
0601 7EB4 8000             data  key.ctrl.comma, txt.ctrl.comma, fm.browse.fname.suffix.dec
     7EB6 7C34 
     7EB8 7458 
0602 7EBA 9B00             data  key.ctrl.dot, txt.ctrl.dot, fm.browse.fname.suffix.inc
     7EBC 7C2A 
     7EBE 7430 
0603                       ;-------------------------------------------------------
0604                       ; Dialog keys
0605                       ;-------------------------------------------------------
0606 7EC0 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.hide
     7EC2 7B08 
     7EC4 6742 
0607                       ;-------------------------------------------------------
0608                       ; End of list
0609                       ;-------------------------------------------------------
0610 7EC6 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.24929
0166 7EC8 7EC8                   data $                ; Bank 1 ROM size OK.
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

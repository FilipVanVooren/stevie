XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b0.asm.503815
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b0.asm               ; Version 200730-503815
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
0009               * File: equates.asm                 ; Version 200730-503815
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
0093      0001     id.dialog.loaddv80        equ  1       ; ID for dialog "Load DV 80 file"
0094      0002     id.dialog.unsaved         equ  2       ; ID for dialog "Unsaved changes"
0095               *--------------------------------------------------------------
0096               * SPECTRA2 / Stevie startup options
0097               *--------------------------------------------------------------
0098      0001     debug                     equ  1       ; Turn on spectra2 debugging
0099      0001     startup_backup_scrpad     equ  1       ; Backup scratchpad 8300-83ff to
0100                                                      ; memory address @cpu.scrpad.tgt
0101      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0102      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0103      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0104               *--------------------------------------------------------------
0105               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0106               *--------------------------------------------------------------
0107               ;                 equ  >8342           ; >8342-834F **free***
0108      8350     parm1             equ  >8350           ; Function parameter 1
0109      8352     parm2             equ  >8352           ; Function parameter 2
0110      8354     parm3             equ  >8354           ; Function parameter 3
0111      8356     parm4             equ  >8356           ; Function parameter 4
0112      8358     parm5             equ  >8358           ; Function parameter 5
0113      835A     parm6             equ  >835a           ; Function parameter 6
0114      835C     parm7             equ  >835c           ; Function parameter 7
0115      835E     parm8             equ  >835e           ; Function parameter 8
0116      8360     outparm1          equ  >8360           ; Function output parameter 1
0117      8362     outparm2          equ  >8362           ; Function output parameter 2
0118      8364     outparm3          equ  >8364           ; Function output parameter 3
0119      8366     outparm4          equ  >8366           ; Function output parameter 4
0120      8368     outparm5          equ  >8368           ; Function output parameter 5
0121      836A     outparm6          equ  >836a           ; Function output parameter 6
0122      836C     outparm7          equ  >836c           ; Function output parameter 7
0123      836E     outparm8          equ  >836e           ; Function output parameter 8
0124      8370     timers            equ  >8370           ; Timer table
0125      8380     ramsat            equ  >8380           ; Sprite Attribute Table in RAM
0126      8390     rambuf            equ  >8390           ; RAM workbuffer 1
0127               *--------------------------------------------------------------
0128               * Stevie Editor shared structures     @>a000-a0ff     (256 bytes)
0129               *--------------------------------------------------------------
0130      A000     tv.top            equ  >a000           ; Structure begin
0131      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0132      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0133      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0134      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0135      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0136      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0137      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0138      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0139      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0140      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0141      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0142      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0143      A018     tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
0144      A01A     tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
0145      A01C     tv.task.oneshot   equ  tv.top + 28     ; Pointer to one-shot routine
0146      A01E     tv.error.visible  equ  tv.top + 30     ; Error pane visible
0147      A020     tv.error.msg      equ  tv.top + 32     ; Error message (max. 160 characters)
0148      A0C0     tv.end            equ  tv.top + 192    ; End of structure
0149               *--------------------------------------------------------------
0150               * Frame buffer structure            @>a100-a1ff     (256 bytes)
0151               *--------------------------------------------------------------
0152      A100     fb.struct         equ  >a100           ; Structure begin
0153      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0154      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0155      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0156                                                      ; line X in editor buffer).
0157      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0158                                                      ; (offset 0 .. @fb.scrrows)
0159      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0160      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0161      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0162      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0163      A110     fb.free           equ  fb.struct + 16  ; **** free ****
0164      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0165      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0166      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0167      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0168      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0169      A11C     fb.end            equ  fb.struct + 28  ; End of structure
0170               *--------------------------------------------------------------
0171               * Editor buffer structure           @>a200-a2ff     (256 bytes)
0172               *--------------------------------------------------------------
0173      A200     edb.struct        equ  >a200           ; Begin structure
0174      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0175      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0176      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0177      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0178      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0179      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0180      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0181      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0182                                                      ; with current filename.
0183      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0184                                                      ; with current file type.
0185      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0186      A214     edb.end           equ  edb.struct + 20 ; End of structure
0187               *--------------------------------------------------------------
0188               * Command buffer structure          @>a300-a3ff     (256 bytes)
0189               *--------------------------------------------------------------
0190      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0191      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0192      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0193      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0194      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0195      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0196      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0197      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0198      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0199      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0200      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0201      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0202      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0203      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0204      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0205      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
0206      A31E     cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
0207      A320     cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
0208      A322     cmdb.cmdlen       equ  cmdb.struct + 34; Length of current command (MSB byte!)
0209      A323     cmdb.cmd          equ  cmdb.struct + 35; Current command (80 bytes max.)
0210      A373     cmdb.end          equ  cmdb.struct +115; End of structure
0211               *--------------------------------------------------------------
0212               * File handle structure             @>a400-a4ff     (256 bytes)
0213               *--------------------------------------------------------------
0214      A400     fh.struct         equ  >a400           ; stevie file handling structures
0215      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0216      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0217      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0218      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0219      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0220      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0221      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0222      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0223      A434     fh.counter        equ  fh.struct + 52  ; Counter used in stevie file operations
0224      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0225      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0226      A43A     fh.sams.hipage    equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0227      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0228      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0229      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0230      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0231      A444     fh.kilobytes.prev equ  fh.struct + 68  ; Kilobytes process (previous)
0232      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0233      A496     fh.end            equ  fh.struct +150  ; End of structure
0234      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0235      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0236               *--------------------------------------------------------------
0237               * Index structure                   @>a500-a5ff     (256 bytes)
0238               *--------------------------------------------------------------
0239      A500     idx.struct        equ  >a500           ; stevie index structure
0240      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0241      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0242      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0243               *--------------------------------------------------------------
0244               * Frame buffer                      @>a600-afff    (2560 bytes)
0245               *--------------------------------------------------------------
0246      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0247      0960     fb.size           equ  80*30           ; Frame buffer size
0248               *--------------------------------------------------------------
0249               * Index                             @>b000-bfff    (4096 bytes)
0250               *--------------------------------------------------------------
0251      B000     idx.top           equ  >b000           ; Top of index
0252      1000     idx.size          equ  4096            ; Index size
0253               *--------------------------------------------------------------
0254               * Editor buffer                     @>c000-cfff    (4096 bytes)
0255               *--------------------------------------------------------------
0256      C000     edb.top           equ  >c000           ; Editor buffer high memory
0257      1000     edb.size          equ  4096            ; Editor buffer size
0258               *--------------------------------------------------------------
0259               * Command history buffer            @>d000-dfff    (4096 bytes)
0260               *--------------------------------------------------------------
0261      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0262      1000     cmdb.size         equ  4096            ; Command buffer size
0263               *--------------------------------------------------------------
0264               * Heap                              @>e000-efff    (4096 bytes)
0265               *--------------------------------------------------------------
0266      E000     heap.top          equ  >e000           ; Top of heap
0267               *--------------------------------------------------------------
0268               * Scratchpad backup 1               @>f000-f0ff     (256 bytes)
0269               * Scratchpad backup 2               @>f100-f1ff     (256 bytes)
0270               *--------------------------------------------------------------
0271      F000     cpu.scrpad.tgt    equ  >f000           ; Destination cpu.scrpad.backup/restore
0272      F000     scrpad.backup1    equ  >f000           ; Backup GPL layout
0273      F100     scrpad.backup2    equ  >f100           ; Backup spectra2 layout
**** **** ****     > stevie_b0.asm.503815
0012               
0013               ***************************************************************
0014               * BANK 0 - Setup environment for Stevie
0015               ********|*****|*********************|**************************
0016                       aorg  >6000
0017                       save  >6000,>7fff           ; Save bank 0 (1st bank)
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
0029 6014 1453             byte  20
0030 6015 ....             text  'STEVIE 200730-503815'
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
0047               ***************************************************************
0048               * Step 2: Copy SP2 library from ROM to >2000 - >2fff
0049               ********|*****|*********************|**************************
0050 6034 0200  20         li    r0,reloc.sp2          ; Start of code to relocate
     6036 6074 
0051 6038 0201  20         li    r1,>2000
     603A 2000 
0052 603C 0202  20         li    r2,512                ; Copy 4K (512 * 8 bytes)
     603E 0200 
0053               kickstart.copy.sp2:
0054 6040 CC70  46         mov   *r0+,*r1+
0055 6042 CC70  46         mov   *r0+,*r1+
0056 6044 CC70  46         mov   *r0+,*r1+
0057 6046 CC70  46         mov   *r0+,*r1+
0058 6048 0602  14         dec   r2
0059 604A 16FA  14         jne   kickstart.copy.sp2
0060               
0061               ***************************************************************
0062               * Step 3: Copy Stevie resident modules from ROM to >3000 - >3fff
0063               ********|*****|*********************|**************************
0064 604C 0200  20         li    r0,reloc.stevie       ; Start of code to relocate
     604E 7052 
0065 6050 0201  20         li    r1,>3000
     6052 3000 
0066 6054 0202  20         li    r2,512                ; Copy 4K (512 * 8 bytes)
     6056 0200 
0067               kickstart.copy.stevie:
0068 6058 CC70  46         mov   *r0+,*r1+
0069 605A CC70  46         mov   *r0+,*r1+
0070 605C CC70  46         mov   *r0+,*r1+
0071 605E CC70  46         mov   *r0+,*r1+
0072 6060 0602  14         dec   r2
0073 6062 16FA  14         jne   kickstart.copy.stevie
0074               
0075               ***************************************************************
0076               * Step 4: Start SP2 kernel (runs in low MEMEXP)
0077               ********|*****|*********************|**************************
0078 6064 0460  28         b     @runlib               ; Start spectra2 library
     6066 2DEA 
0079                       ;------------------------------------------------------
0080                       ; Assert. Should not get here! Crash and burn!
0081                       ;------------------------------------------------------
0082 6068 0200  20         li    r0,$                  ; Current location
     606A 6068 
0083 606C C800  38         mov   r0,@>ffce             ; \ Save caller address
     606E FFCE 
0084 6070 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6072 2030 
0085               
0086               ***************************************************************
0087               * Step 5: Handover from SP2 kernel to Stevie "main" in low MEMEXP
0088               ********|*****|*********************|**************************
0089                       ; "main" in low MEMEXP is automatically called by SP2 runlib.
0090               
0091               
0092               
0093               
0094               ***************************************************************
0095               * Code data: Relocated code SP2 >2000 - >2fff (4K maximum)
0096               ********|*****|*********************|**************************
0097               reloc.sp2:
0098                       xorg >2000                  ; Relocate SP2 code to >2000
0099                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0025 6074 C13B  30 swbnk   mov   *r11+,tmp0
0026 6076 C17B  30         mov   *r11+,tmp1
0027 6078 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0028 607A C155  26         mov   *tmp1,tmp1
0029 607C 0455  20         b     *tmp1                 ; Switch to routine in TMP1
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
0012 607E 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 6080 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 6082 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 6084 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 6086 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 6088 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 608A 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 608C 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 608E 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 6090 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 6092 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 6094 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 6096 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 6098 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 609A 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 609C 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 609E 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 60A0 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 60A2 D000     w$d000  data  >d000                 ; >d000
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
0038 60A4 022B  22         ai    r11,-4                ; Remove opcode offset
     60A6 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 60A8 C800  38         mov   r0,@>ffe0
     60AA FFE0 
0043 60AC C801  38         mov   r1,@>ffe2
     60AE FFE2 
0044 60B0 C802  38         mov   r2,@>ffe4
     60B2 FFE4 
0045 60B4 C803  38         mov   r3,@>ffe6
     60B6 FFE6 
0046 60B8 C804  38         mov   r4,@>ffe8
     60BA FFE8 
0047 60BC C805  38         mov   r5,@>ffea
     60BE FFEA 
0048 60C0 C806  38         mov   r6,@>ffec
     60C2 FFEC 
0049 60C4 C807  38         mov   r7,@>ffee
     60C6 FFEE 
0050 60C8 C808  38         mov   r8,@>fff0
     60CA FFF0 
0051 60CC C809  38         mov   r9,@>fff2
     60CE FFF2 
0052 60D0 C80A  38         mov   r10,@>fff4
     60D2 FFF4 
0053 60D4 C80B  38         mov   r11,@>fff6
     60D6 FFF6 
0054 60D8 C80C  38         mov   r12,@>fff8
     60DA FFF8 
0055 60DC C80D  38         mov   r13,@>fffa
     60DE FFFA 
0056 60E0 C80E  38         mov   r14,@>fffc
     60E2 FFFC 
0057 60E4 C80F  38         mov   r15,@>ffff
     60E6 FFFF 
0058 60E8 02A0  12         stwp  r0
0059 60EA C800  38         mov   r0,@>ffdc
     60EC FFDC 
0060 60EE 02C0  12         stst  r0
0061 60F0 C800  38         mov   r0,@>ffde
     60F2 FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 60F4 02E0  18         lwpi  ws1                   ; Activate workspace 1
     60F6 8300 
0067 60F8 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     60FA 8302 
0068 60FC 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     60FE 4A4A 
0069 6100 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     6102 2DF2 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 6104 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6106 22F2 
0078 6108 21F2                   data graph1           ; Equate selected video mode table
0079               
0080 610A 06A0  32         bl    @ldfnt
     610C 235A 
0081 610E 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     6110 000C 
0082               
0083 6112 06A0  32         bl    @filv
     6114 2288 
0084 6116 0380                   data >0380,>f0,32*24  ; Load color table
     6118 00F0 
     611A 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 611C 06A0  32         bl    @putat                ; Show crash message
     611E 243C 
0089 6120 0000                   data >0000,cpu.crash.msg.crashed
     6122 2182 
0090               
0091 6124 06A0  32         bl    @puthex               ; Put hex value on screen
     6126 2978 
0092 6128 0015                   byte 0,21             ; \ i  p0 = YX position
0093 612A FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 612C 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 612E 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 6130 06A0  32         bl    @putat                ; Show caller message
     6132 243C 
0101 6134 0100                   data >0100,cpu.crash.msg.caller
     6136 2198 
0102               
0103 6138 06A0  32         bl    @puthex               ; Put hex value on screen
     613A 2978 
0104 613C 0115                   byte 1,21             ; \ i  p0 = YX position
0105 613E FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 6140 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 6142 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 6144 06A0  32         bl    @putat
     6146 243C 
0113 6148 0300                   byte 3,0
0114 614A 21B2                   data cpu.crash.msg.wp
0115 614C 06A0  32         bl    @putat
     614E 243C 
0116 6150 0400                   byte 4,0
0117 6152 21B8                   data cpu.crash.msg.st
0118 6154 06A0  32         bl    @putat
     6156 243C 
0119 6158 1600                   byte 22,0
0120 615A 21BE                   data cpu.crash.msg.source
0121 615C 06A0  32         bl    @putat
     615E 243C 
0122 6160 1700                   byte 23,0
0123 6162 21DA                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 6164 06A0  32         bl    @at                   ; Put cursor at YX
     6166 2680 
0128 6168 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 616A 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     616C FFDC 
0132 616E 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 6170 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 6172 0649  14         dect  stack
0138 6174 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 6176 0649  14         dect  stack
0140 6178 C645  30         mov   tmp1,*stack           ; Push tmp1
0141 617A 0649  14         dect  stack
0142 617C C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 617E C046  18         mov   tmp2,r1               ; Save register number
0148 6180 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     6182 0001 
0149 6184 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 6186 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 6188 06A0  32         bl    @mknum
     618A 2982 
0154 618C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 618E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 6190 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 6192 06A0  32         bl    @setx                 ; Set cursor X position
     6194 2696 
0160 6196 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 6198 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     619A 2418 
0164 619C 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 619E 06A0  32         bl    @setx                 ; Set cursor X position
     61A0 2696 
0168 61A2 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 61A4 0281  22         ci    r1,10
     61A6 000A 
0172 61A8 1102  14         jlt   !
0173 61AA 0620  34         dec   @wyx                  ; x=x-1
     61AC 832A 
0174               
0175 61AE 06A0  32 !       bl    @putstr
     61B0 2418 
0176 61B2 21AE                   data cpu.crash.msg.r
0177               
0178 61B4 06A0  32         bl    @mknum
     61B6 2982 
0179 61B8 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 61BA 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 61BC 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 61BE 06A0  32         bl    @mkhex                ; Convert hex word to string
     61C0 28F4 
0188 61C2 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 61C4 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 61C6 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 61C8 06A0  32         bl    @setx                 ; Set cursor X position
     61CA 2696 
0194 61CC 0006                   data 6                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 61CE 06A0  32         bl    @putstr
     61D0 2418 
0198 61D2 21B0                   data cpu.crash.msg.marker
0199               
0200 61D4 06A0  32         bl    @setx                 ; Set cursor X position
     61D6 2696 
0201 61D8 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61DA 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61DC 2418 
0205 61DE 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61E0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61E2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61E6 06A0  32         bl    @down                 ; y=y+1
     61E8 2686 
0213               
0214 61EA 0586  14         inc   tmp2
0215 61EC 0286  22         ci    tmp2,17
     61EE 0011 
0216 61F0 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 61F2 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     61F4 2CEC 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 61F6 1553             byte  21
0225 61F7 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 620C 1543             byte  21
0230 620D ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 6222 0152             byte  1
0235 6223 ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 6224 013E             byte  1
0240 6225 ....             text  '>'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 6226 042A             byte  4
0245 6227 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 622C 042A             byte  4
0250 622D ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 6232 1B53             byte  27
0255 6233 ....             text  'Source    stevie_b0.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 624E 1742             byte  23
0260 624F ....             text  'Build-ID  200730-503815'
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
0007 6266 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6268 000E 
     626A 0106 
     626C 0204 
     626E 0020 
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
0032 6270 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6272 000E 
     6274 0106 
     6276 00F4 
     6278 0028 
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
0058 627A 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     627C 003F 
     627E 0240 
     6280 03F4 
     6282 0050 
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
0084 6284 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6286 003F 
     6288 0240 
     628A 03F4 
     628C 0050 
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
0013 628E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6290 16FD             data  >16fd                 ; |         jne   mcloop
0015 6292 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6294 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6296 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 6298 C0F9  30 popr3   mov   *stack+,r3
0039 629A C0B9  30 popr2   mov   *stack+,r2
0040 629C C079  30 popr1   mov   *stack+,r1
0041 629E C039  30 popr0   mov   *stack+,r0
0042 62A0 C2F9  30 poprt   mov   *stack+,r11
0043 62A2 045B  20         b     *r11
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
0067 62A4 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 62A6 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 62A8 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 62AA C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 62AC 1604  14         jne   filchk                ; No, continue checking
0075               
0076 62AE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     62B0 FFCE 
0077 62B2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     62B4 2030 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 62B6 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     62B8 830B 
     62BA 830A 
0082               
0083 62BC 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62BE 0001 
0084 62C0 1602  14         jne   filchk2
0085 62C2 DD05  32         movb  tmp1,*tmp0+
0086 62C4 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 62C6 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     62C8 0002 
0091 62CA 1603  14         jne   filchk3
0092 62CC DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 62CE DD05  32         movb  tmp1,*tmp0+
0094 62D0 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 62D2 C1C4  18 filchk3 mov   tmp0,tmp3
0099 62D4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62D6 0001 
0100 62D8 1605  14         jne   fil16b
0101 62DA DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 62DC 0606  14         dec   tmp2
0103 62DE 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     62E0 0002 
0104 62E2 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 62E4 C1C6  18 fil16b  mov   tmp2,tmp3
0109 62E6 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62E8 0001 
0110 62EA 1301  14         jeq   dofill
0111 62EC 0606  14         dec   tmp2                  ; Make TMP2 even
0112 62EE CD05  34 dofill  mov   tmp1,*tmp0+
0113 62F0 0646  14         dect  tmp2
0114 62F2 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 62F4 C1C7  18         mov   tmp3,tmp3
0119 62F6 1301  14         jeq   fil.$$
0120 62F8 DD05  32         movb  tmp1,*tmp0+
0121 62FA 045B  20 fil.$$  b     *r11
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
0140 62FC C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 62FE C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 6300 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 6302 0264  22 xfilv   ori   tmp0,>4000
     6304 4000 
0147 6306 06C4  14         swpb  tmp0
0148 6308 D804  38         movb  tmp0,@vdpa
     630A 8C02 
0149 630C 06C4  14         swpb  tmp0
0150 630E D804  38         movb  tmp0,@vdpa
     6310 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 6312 020F  20         li    r15,vdpw              ; Set VDP write address
     6314 8C00 
0155 6316 06C5  14         swpb  tmp1
0156 6318 C820  54         mov   @filzz,@mcloop        ; Setup move command
     631A 22AE 
     631C 8320 
0157 631E 0460  28         b     @mcloop               ; Write data to VDP
     6320 8320 
0158               *--------------------------------------------------------------
0162 6322 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 6324 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     6326 4000 
0183 6328 06C4  14 vdra    swpb  tmp0
0184 632A D804  38         movb  tmp0,@vdpa
     632C 8C02 
0185 632E 06C4  14         swpb  tmp0
0186 6330 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6332 8C02 
0187 6334 045B  20         b     *r11                  ; Exit
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
0198 6336 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 6338 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 633A 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     633C 4000 
0204 633E 06C4  14         swpb  tmp0                  ; \
0205 6340 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6342 8C02 
0206 6344 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 6346 D804  38         movb  tmp0,@vdpa            ; /
     6348 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 634A 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 634C D7C5  30         movb  tmp1,*r15             ; Write byte
0213 634E 045B  20         b     *r11                  ; Exit
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
0232 6350 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 6352 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 6354 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6356 8C02 
0238 6358 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 635A D804  38         movb  tmp0,@vdpa            ; /
     635C 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 635E D120  34         movb  @vdpr,tmp0            ; Read byte
     6360 8800 
0244 6362 0984  56         srl   tmp0,8                ; Right align
0245 6364 045B  20         b     *r11                  ; Exit
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
0264 6366 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 6368 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 636A C144  18         mov   tmp0,tmp1
0270 636C 05C5  14         inct  tmp1
0271 636E D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 6370 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6372 FF00 
0273 6374 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 6376 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6378 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 637A 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     637C 8000 
0279 637E 0206  20         li    tmp2,8
     6380 0008 
0280 6382 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6384 830B 
0281 6386 06C5  14         swpb  tmp1
0282 6388 D805  38         movb  tmp1,@vdpa
     638A 8C02 
0283 638C 06C5  14         swpb  tmp1
0284 638E D805  38         movb  tmp1,@vdpa
     6390 8C02 
0285 6392 0225  22         ai    tmp1,>0100
     6394 0100 
0286 6396 0606  14         dec   tmp2
0287 6398 16F4  14         jne   vidta1                ; Next register
0288 639A C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     639C 833A 
0289 639E 045B  20         b     *r11
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
0306 63A0 C13B  30 putvr   mov   *r11+,tmp0
0307 63A2 0264  22 putvrx  ori   tmp0,>8000
     63A4 8000 
0308 63A6 06C4  14         swpb  tmp0
0309 63A8 D804  38         movb  tmp0,@vdpa
     63AA 8C02 
0310 63AC 06C4  14         swpb  tmp0
0311 63AE D804  38         movb  tmp0,@vdpa
     63B0 8C02 
0312 63B2 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 63B4 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 63B6 C10E  18         mov   r14,tmp0
0322 63B8 0984  56         srl   tmp0,8
0323 63BA 06A0  32         bl    @putvrx               ; Write VR#0
     63BC 232E 
0324 63BE 0204  20         li    tmp0,>0100
     63C0 0100 
0325 63C2 D820  54         movb  @r14lb,@tmp0lb
     63C4 831D 
     63C6 8309 
0326 63C8 06A0  32         bl    @putvrx               ; Write VR#1
     63CA 232E 
0327 63CC 0458  20         b     *tmp4                 ; Exit
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
0341 63CE C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 63D0 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 63D2 C11B  26         mov   *r11,tmp0             ; Get P0
0344 63D4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63D6 7FFF 
0345 63D8 2120  38         coc   @wbit0,tmp0
     63DA 202A 
0346 63DC 1604  14         jne   ldfnt1
0347 63DE 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     63E0 8000 
0348 63E2 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     63E4 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 63E6 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     63E8 23DC 
0353 63EA D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     63EC 9C02 
0354 63EE 06C4  14         swpb  tmp0
0355 63F0 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     63F2 9C02 
0356 63F4 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     63F6 9800 
0357 63F8 06C5  14         swpb  tmp1
0358 63FA D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     63FC 9800 
0359 63FE 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 6400 D805  38         movb  tmp1,@grmwa
     6402 9C02 
0364 6404 06C5  14         swpb  tmp1
0365 6406 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6408 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 640A C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 640C 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     640E 22B0 
0371 6410 05C8  14         inct  tmp4                  ; R11=R11+2
0372 6412 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 6414 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     6416 7FFF 
0374 6418 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     641A 23DE 
0375 641C C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     641E 23E0 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 6420 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 6422 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 6424 D120  34         movb  @grmrd,tmp0
     6426 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 6428 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     642A 202A 
0386 642C 1603  14         jne   ldfnt3                ; No, so skip
0387 642E D1C4  18         movb  tmp0,tmp3
0388 6430 0917  56         srl   tmp3,1
0389 6432 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 6434 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6436 8C00 
0394 6438 0606  14         dec   tmp2
0395 643A 16F2  14         jne   ldfnt2
0396 643C 05C8  14         inct  tmp4                  ; R11=R11+2
0397 643E 020F  20         li    r15,vdpw              ; Set VDP write address
     6440 8C00 
0398 6442 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6444 7FFF 
0399 6446 0458  20         b     *tmp4                 ; Exit
0400 6448 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     644A 200A 
     644C 8C00 
0401 644E 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 6450 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6452 0200 
     6454 0000 
0406 6456 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6458 01C0 
     645A 0101 
0407 645C 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     645E 02A0 
     6460 0101 
0408 6462 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6464 00E0 
     6466 0101 
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
0426 6468 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 646A C3A0  34         mov   @wyx,r14              ; Get YX
     646C 832A 
0428 646E 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 6470 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6472 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 6474 C3A0  34         mov   @wyx,r14              ; Get YX
     6476 832A 
0435 6478 024E  22         andi  r14,>00ff             ; Remove Y
     647A 00FF 
0436 647C A3CE  18         a     r14,r15               ; pos = pos + X
0437 647E A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6480 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 6482 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 6484 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 6486 020F  20         li    r15,vdpw              ; VDP write address
     6488 8C00 
0444 648A 045B  20         b     *r11
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
0459 648C C17B  30 putstr  mov   *r11+,tmp1
0460 648E D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 6490 C1CB  18 xutstr  mov   r11,tmp3
0462 6492 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6494 23F4 
0463 6496 C2C7  18         mov   tmp3,r11
0464 6498 0986  56         srl   tmp2,8                ; Right justify length byte
0465               *--------------------------------------------------------------
0466               * Put string
0467               *--------------------------------------------------------------
0468 649A C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0469 649C 1305  14         jeq   !                     ; Yes, crash and burn
0470               
0471 649E 0286  22         ci    tmp2,255              ; Length > 255 ?
     64A0 00FF 
0472 64A2 1502  14         jgt   !                     ; Yes, crash and burn
0473               
0474 64A4 0460  28         b     @xpym2v               ; Display string
     64A6 244A 
0475               *--------------------------------------------------------------
0476               * Crash handler
0477               *--------------------------------------------------------------
0478 64A8 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     64AA FFCE 
0479 64AC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64AE 2030 
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
0495 64B0 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     64B2 832A 
0496 64B4 0460  28         b     @putstr
     64B6 2418 
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
0020 64B8 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 64BA C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 64BC C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 64BE 0264  22 xpym2v  ori   tmp0,>4000
     64C0 4000 
0027 64C2 06C4  14         swpb  tmp0
0028 64C4 D804  38         movb  tmp0,@vdpa
     64C6 8C02 
0029 64C8 06C4  14         swpb  tmp0
0030 64CA D804  38         movb  tmp0,@vdpa
     64CC 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 64CE 020F  20         li    r15,vdpw              ; Set VDP write address
     64D0 8C00 
0035 64D2 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     64D4 2468 
     64D6 8320 
0036 64D8 0460  28         b     @mcloop               ; Write data to VDP
     64DA 8320 
0037 64DC D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 64DE C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 64E0 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 64E2 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 64E4 06C4  14 xpyv2m  swpb  tmp0
0027 64E6 D804  38         movb  tmp0,@vdpa
     64E8 8C02 
0028 64EA 06C4  14         swpb  tmp0
0029 64EC D804  38         movb  tmp0,@vdpa
     64EE 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 64F0 020F  20         li    r15,vdpr              ; Set VDP read address
     64F2 8800 
0034 64F4 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     64F6 248A 
     64F8 8320 
0035 64FA 0460  28         b     @mcloop               ; Read data from VDP
     64FC 8320 
0036 64FE DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6500 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6502 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6504 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6506 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6508 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 650A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     650C FFCE 
0034 650E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6510 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6512 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6514 0001 
0039 6516 1603  14         jne   cpym0                 ; No, continue checking
0040 6518 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 651A 04C6  14         clr   tmp2                  ; Reset counter
0042 651C 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 651E 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6520 7FFF 
0047 6522 C1C4  18         mov   tmp0,tmp3
0048 6524 0247  22         andi  tmp3,1
     6526 0001 
0049 6528 1618  14         jne   cpyodd                ; Odd source address handling
0050 652A C1C5  18 cpym1   mov   tmp1,tmp3
0051 652C 0247  22         andi  tmp3,1
     652E 0001 
0052 6530 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 6532 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     6534 202A 
0057 6536 1605  14         jne   cpym3
0058 6538 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     653A 24EC 
     653C 8320 
0059 653E 0460  28         b     @mcloop               ; Copy memory and exit
     6540 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 6542 C1C6  18 cpym3   mov   tmp2,tmp3
0064 6544 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6546 0001 
0065 6548 1301  14         jeq   cpym4
0066 654A 0606  14         dec   tmp2                  ; Make TMP2 even
0067 654C CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 654E 0646  14         dect  tmp2
0069 6550 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 6552 C1C7  18         mov   tmp3,tmp3
0074 6554 1301  14         jeq   cpymz
0075 6556 D554  38         movb  *tmp0,*tmp1
0076 6558 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 655A 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     655C 8000 
0081 655E 10E9  14         jmp   cpym2
0082 6560 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 6562 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 6564 0649  14         dect  stack
0065 6566 C64B  30         mov   r11,*stack            ; Push return address
0066 6568 0649  14         dect  stack
0067 656A C640  30         mov   r0,*stack             ; Push r0
0068 656C 0649  14         dect  stack
0069 656E C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 6570 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 6572 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 6574 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     6576 4000 
0077 6578 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     657A 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 657C 020C  20         li    r12,>1e00             ; SAMS CRU address
     657E 1E00 
0082 6580 04C0  14         clr   r0
0083 6582 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 6584 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 6586 D100  18         movb  r0,tmp0
0086 6588 0984  56         srl   tmp0,8                ; Right align
0087 658A C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     658C 833C 
0088 658E 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 6590 C339  30         mov   *stack+,r12           ; Pop r12
0094 6592 C039  30         mov   *stack+,r0            ; Pop r0
0095 6594 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 6596 045B  20         b     *r11                  ; Return to caller
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
0131 6598 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 659A C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 659C 0649  14         dect  stack
0135 659E C64B  30         mov   r11,*stack            ; Push return address
0136 65A0 0649  14         dect  stack
0137 65A2 C640  30         mov   r0,*stack             ; Push r0
0138 65A4 0649  14         dect  stack
0139 65A6 C64C  30         mov   r12,*stack            ; Push r12
0140 65A8 0649  14         dect  stack
0141 65AA C644  30         mov   tmp0,*stack           ; Push tmp0
0142 65AC 0649  14         dect  stack
0143 65AE C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 65B0 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 65B2 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 65B4 0284  22         ci    tmp0,255              ; Crash if page > 255
     65B6 00FF 
0153 65B8 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 65BA 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     65BC 001E 
0158 65BE 150A  14         jgt   !
0159 65C0 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     65C2 0004 
0160 65C4 1107  14         jlt   !
0161 65C6 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     65C8 0012 
0162 65CA 1508  14         jgt   sams.page.set.switch_page
0163 65CC 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     65CE 0006 
0164 65D0 1501  14         jgt   !
0165 65D2 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 65D4 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     65D6 FFCE 
0170 65D8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     65DA 2030 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 65DC 020C  20         li    r12,>1e00             ; SAMS CRU address
     65DE 1E00 
0176 65E0 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 65E2 06C0  14         swpb  r0                    ; LSB to MSB
0178 65E4 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 65E6 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     65E8 4000 
0180 65EA 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 65EC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 65EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 65F0 C339  30         mov   *stack+,r12           ; Pop r12
0188 65F2 C039  30         mov   *stack+,r0            ; Pop r0
0189 65F4 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 65F6 045B  20         b     *r11                  ; Return to caller
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
0204 65F8 020C  20         li    r12,>1e00             ; SAMS CRU address
     65FA 1E00 
0205 65FC 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 65FE 045B  20         b     *r11                  ; Return to caller
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
0227 6600 020C  20         li    r12,>1e00             ; SAMS CRU address
     6602 1E00 
0228 6604 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 6606 045B  20         b     *r11                  ; Return to caller
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
0260 6608 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 660A 0649  14         dect  stack
0263 660C C64B  30         mov   r11,*stack            ; Save return address
0264 660E 0649  14         dect  stack
0265 6610 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 6612 0649  14         dect  stack
0267 6614 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 6616 0649  14         dect  stack
0269 6618 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 661A 0649  14         dect  stack
0271 661C C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 661E 0206  20         li    tmp2,8                ; Set loop counter
     6620 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 6622 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 6624 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 6626 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     6628 2528 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 662A 0606  14         dec   tmp2                  ; Next iteration
0288 662C 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 662E 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6630 2584 
0294                                                   ; / activating changes.
0295               
0296 6632 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 6634 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 6636 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 6638 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 663A C2F9  30         mov   *stack+,r11           ; Pop r11
0301 663C 045B  20         b     *r11                  ; Return to caller
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
0318 663E 0649  14         dect  stack
0319 6640 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 6642 06A0  32         bl    @sams.layout
     6644 2594 
0324 6646 25D8                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 6648 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 664A 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 664C 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     664E 0002 
0336 6650 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     6652 0003 
0337 6654 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     6656 000A 
0338 6658 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     665A 000B 
0339 665C C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     665E 000C 
0340 6660 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     6662 000D 
0341 6664 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     6666 000E 
0342 6668 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     666A 000F 
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
0363 666C C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 666E 0649  14         dect  stack
0366 6670 C64B  30         mov   r11,*stack            ; Push return address
0367 6672 0649  14         dect  stack
0368 6674 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 6676 0649  14         dect  stack
0370 6678 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 667A 0649  14         dect  stack
0372 667C C646  30         mov   tmp2,*stack           ; Push tmp2
0373 667E 0649  14         dect  stack
0374 6680 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 6682 0205  20         li    tmp1,sams.layout.copy.data
     6684 2630 
0379 6686 0206  20         li    tmp2,8                ; Set loop counter
     6688 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 668A C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 668C 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     668E 24F0 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 6690 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     6692 833C 
0390               
0391 6694 0606  14         dec   tmp2                  ; Next iteration
0392 6696 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 6698 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 669A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 669C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 669E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 66A0 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 66A2 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 66A4 2000             data  >2000                 ; >2000-2fff
0408 66A6 3000             data  >3000                 ; >3000-3fff
0409 66A8 A000             data  >a000                 ; >a000-afff
0410 66AA B000             data  >b000                 ; >b000-bfff
0411 66AC C000             data  >c000                 ; >c000-cfff
0412 66AE D000             data  >d000                 ; >d000-dfff
0413 66B0 E000             data  >e000                 ; >e000-efff
0414 66B2 F000             data  >f000                 ; >f000-ffff
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
0009 66B4 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     66B6 FFBF 
0010 66B8 0460  28         b     @putv01
     66BA 2340 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 66BC 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     66BE 0040 
0018 66C0 0460  28         b     @putv01
     66C2 2340 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 66C4 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     66C6 FFDF 
0026 66C8 0460  28         b     @putv01
     66CA 2340 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 66CC 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     66CE 0020 
0034 66D0 0460  28         b     @putv01
     66D2 2340 
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
0010 66D4 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     66D6 FFFE 
0011 66D8 0460  28         b     @putv01
     66DA 2340 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 66DC 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     66DE 0001 
0019 66E0 0460  28         b     @putv01
     66E2 2340 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 66E4 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     66E6 FFFD 
0027 66E8 0460  28         b     @putv01
     66EA 2340 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 66EC 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     66EE 0002 
0035 66F0 0460  28         b     @putv01
     66F2 2340 
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
0018 66F4 C83B  50 at      mov   *r11+,@wyx
     66F6 832A 
0019 66F8 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 66FA B820  54 down    ab    @hb$01,@wyx
     66FC 201C 
     66FE 832A 
0028 6700 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6702 7820  54 up      sb    @hb$01,@wyx
     6704 201C 
     6706 832A 
0037 6708 045B  20         b     *r11
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
0049 670A C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 670C D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     670E 832A 
0051 6710 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6712 832A 
0052 6714 045B  20         b     *r11
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
0021 6716 C120  34 yx2px   mov   @wyx,tmp0
     6718 832A 
0022 671A C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 671C 06C4  14         swpb  tmp0                  ; Y<->X
0024 671E 04C5  14         clr   tmp1                  ; Clear before copy
0025 6720 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6722 20A0  38         coc   @wbit1,config         ; f18a present ?
     6724 2028 
0030 6726 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6728 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     672A 833A 
     672C 26E2 
0032 672E 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6730 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6732 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6734 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6736 0500 
0037 6738 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 673A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 673C 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 673E 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6740 D105  18         movb  tmp1,tmp0
0051 6742 06C4  14         swpb  tmp0                  ; X<->Y
0052 6744 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6746 202A 
0053 6748 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 674A 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     674C 201C 
0059 674E 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6750 202E 
0060 6752 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6754 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6756 0050            data   80
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
0013 6758 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 675A 06A0  32         bl    @putvr                ; Write once
     675C 232C 
0015 675E 391C             data  >391c                 ; VR1/57, value 00011100
0016 6760 06A0  32         bl    @putvr                ; Write twice
     6762 232C 
0017 6764 391C             data  >391c                 ; VR1/57, value 00011100
0018 6766 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 6768 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 676A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     676C 232C 
0028 676E 391C             data  >391c
0029 6770 0458  20         b     *tmp4                 ; Exit
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
0040 6772 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6774 06A0  32         bl    @cpym2v
     6776 2444 
0042 6778 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     677A 2742 
     677C 0006 
0043 677E 06A0  32         bl    @putvr
     6780 232C 
0044 6782 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 6784 06A0  32         bl    @putvr
     6786 232C 
0046 6788 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 678A 0204  20         li    tmp0,>3f00
     678C 3F00 
0052 678E 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6790 22B4 
0053 6792 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6794 8800 
0054 6796 0984  56         srl   tmp0,8
0055 6798 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     679A 8800 
0056 679C C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 679E 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 67A0 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     67A2 BFFF 
0060 67A4 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 67A6 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     67A8 4000 
0063               f18chk_exit:
0064 67AA 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     67AC 2288 
0065 67AE 3F00             data  >3f00,>00,6
     67B0 0000 
     67B2 0006 
0066 67B4 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 67B6 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 67B8 3F00             data  >3f00                 ; 3f02 / 3f00
0073 67BA 0340             data  >0340                 ; 3f04   0340  idle
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
0092 67BC C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 67BE 06A0  32         bl    @putvr
     67C0 232C 
0097 67C2 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 67C4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     67C6 232C 
0100 67C8 391C             data  >391c                 ; Lock the F18a
0101 67CA 0458  20         b     *tmp4                 ; Exit
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
0120 67CC C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 67CE 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     67D0 2028 
0122 67D2 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 67D4 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     67D6 8802 
0127 67D8 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     67DA 232C 
0128 67DC 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 67DE 04C4  14         clr   tmp0
0130 67E0 D120  34         movb  @vdps,tmp0
     67E2 8802 
0131 67E4 0984  56         srl   tmp0,8
0132 67E6 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 67E8 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     67EA 832A 
0018 67EC D17B  28         movb  *r11+,tmp1
0019 67EE 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 67F0 D1BB  28         movb  *r11+,tmp2
0021 67F2 0986  56         srl   tmp2,8                ; Repeat count
0022 67F4 C1CB  18         mov   r11,tmp3
0023 67F6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     67F8 23F4 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 67FA 020B  20         li    r11,hchar1
     67FC 278E 
0028 67FE 0460  28         b     @xfilv                ; Draw
     6800 228E 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6802 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6804 202C 
0033 6806 1302  14         jeq   hchar2                ; Yes, exit
0034 6808 C2C7  18         mov   tmp3,r11
0035 680A 10EE  14         jmp   hchar                 ; Next one
0036 680C 05C7  14 hchar2  inct  tmp3
0037 680E 0457  20         b     *tmp3                 ; Exit
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
0016 6810 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6812 202A 
0017 6814 020C  20         li    r12,>0024
     6816 0024 
0018 6818 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     681A 2834 
0019 681C 04C6  14         clr   tmp2
0020 681E 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6820 04CC  14         clr   r12
0025 6822 1F08  20         tb    >0008                 ; Shift-key ?
0026 6824 1302  14         jeq   realk1                ; No
0027 6826 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6828 2864 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 682A 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 682C 1302  14         jeq   realk2                ; No
0033 682E 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6830 2894 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6832 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6834 1302  14         jeq   realk3                ; No
0039 6836 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6838 28C4 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 683A 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 683C 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 683E 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 6840 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     6842 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6844 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6846 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6848 0006 
0052 684A 0606  14 realk5  dec   tmp2
0053 684C 020C  20         li    r12,>24               ; CRU address for P2-P4
     684E 0024 
0054 6850 06C6  14         swpb  tmp2
0055 6852 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6854 06C6  14         swpb  tmp2
0057 6856 020C  20         li    r12,6                 ; CRU read address
     6858 0006 
0058 685A 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 685C 0547  14         inv   tmp3                  ;
0060 685E 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6860 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6862 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6864 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6866 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6868 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 686A 0285  22         ci    tmp1,8
     686C 0008 
0069 686E 1AFA  14         jl    realk6
0070 6870 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 6872 1BEB  14         jh    realk5                ; No, next column
0072 6874 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6876 C206  18 realk8  mov   tmp2,tmp4
0077 6878 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 687A A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 687C A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 687E D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 6880 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6882 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6884 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6886 202A 
0087 6888 1608  14         jne   realka                ; No, continue saving key
0088 688A 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     688C 285E 
0089 688E 1A05  14         jl    realka
0090 6890 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6892 285C 
0091 6894 1B02  14         jh    realka                ; No, continue
0092 6896 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6898 E000 
0093 689A C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     689C 833C 
0094 689E E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     68A0 2014 
0095 68A2 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     68A4 8C00 
0096 68A6 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 68A8 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     68AA 0000 
     68AC FF0D 
     68AE 203D 
0099 68B0 ....             text  'xws29ol.'
0100 68B8 ....             text  'ced38ik,'
0101 68C0 ....             text  'vrf47ujm'
0102 68C8 ....             text  'btg56yhn'
0103 68D0 ....             text  'zqa10p;/'
0104 68D8 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     68DA 0000 
     68DC FF0D 
     68DE 202B 
0105 68E0 ....             text  'XWS@(OL>'
0106 68E8 ....             text  'CED#*IK<'
0107 68F0 ....             text  'VRF$&UJM'
0108 68F8 ....             text  'BTG%^YHN'
0109 6900 ....             text  'ZQA!)P:-'
0110 6908 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     690A 0000 
     690C FF0D 
     690E 2005 
0111 6910 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6912 0804 
     6914 0F27 
     6916 C2B9 
0112 6918 600B             data  >600b,>0907,>063f,>c1B8
     691A 0907 
     691C 063F 
     691E C1B8 
0113 6920 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6922 7B02 
     6924 015F 
     6926 C0C3 
0114 6928 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     692A 7D0E 
     692C 0CC6 
     692E BFC4 
0115 6930 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6932 7C03 
     6934 BC22 
     6936 BDBA 
0116 6938 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     693A 0000 
     693C FF0D 
     693E 209D 
0117 6940 9897             data  >9897,>93b2,>9f8f,>8c9B
     6942 93B2 
     6944 9F8F 
     6946 8C9B 
0118 6948 8385             data  >8385,>84b3,>9e89,>8b80
     694A 84B3 
     694C 9E89 
     694E 8B80 
0119 6950 9692             data  >9692,>86b4,>b795,>8a8D
     6952 86B4 
     6954 B795 
     6956 8A8D 
0120 6958 8294             data  >8294,>87b5,>b698,>888E
     695A 87B5 
     695C B698 
     695E 888E 
0121 6960 9A91             data  >9a91,>81b1,>b090,>9cBB
     6962 81B1 
     6964 B090 
     6966 9CBB 
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
0023 6968 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 696A C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     696C 8340 
0025 696E 04E0  34         clr   @waux1
     6970 833C 
0026 6972 04E0  34         clr   @waux2
     6974 833E 
0027 6976 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6978 833C 
0028 697A C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 697C 0205  20         li    tmp1,4                ; 4 nibbles
     697E 0004 
0033 6980 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6982 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6984 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6986 0286  22         ci    tmp2,>000a
     6988 000A 
0039 698A 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 698C C21B  26         mov   *r11,tmp4
0045 698E 0988  56         srl   tmp4,8                ; Right justify
0046 6990 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6992 FFF6 
0047 6994 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6996 C21B  26         mov   *r11,tmp4
0054 6998 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     699A 00FF 
0055               
0056 699C A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 699E 06C6  14         swpb  tmp2
0058 69A0 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 69A2 0944  56         srl   tmp0,4                ; Next nibble
0060 69A4 0605  14         dec   tmp1
0061 69A6 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 69A8 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     69AA BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 69AC C160  34         mov   @waux3,tmp1           ; Get pointer
     69AE 8340 
0067 69B0 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 69B2 0585  14         inc   tmp1                  ; Next byte, not word!
0069 69B4 C120  34         mov   @waux2,tmp0
     69B6 833E 
0070 69B8 06C4  14         swpb  tmp0
0071 69BA DD44  32         movb  tmp0,*tmp1+
0072 69BC 06C4  14         swpb  tmp0
0073 69BE DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 69C0 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     69C2 8340 
0078 69C4 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     69C6 2020 
0079 69C8 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 69CA C120  34         mov   @waux1,tmp0
     69CC 833C 
0084 69CE 06C4  14         swpb  tmp0
0085 69D0 DD44  32         movb  tmp0,*tmp1+
0086 69D2 06C4  14         swpb  tmp0
0087 69D4 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 69D6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     69D8 202A 
0092 69DA 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 69DC 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 69DE 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     69E0 7FFF 
0098 69E2 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     69E4 8340 
0099 69E6 0460  28         b     @xutst0               ; Display string
     69E8 241A 
0100 69EA 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 69EC C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     69EE 832A 
0122 69F0 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     69F2 8000 
0123 69F4 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 69F6 0207  20 mknum   li    tmp3,5                ; Digit counter
     69F8 0005 
0020 69FA C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 69FC C155  26         mov   *tmp1,tmp1            ; /
0022 69FE C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6A00 0228  22         ai    tmp4,4                ; Get end of buffer
     6A02 0004 
0024 6A04 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6A06 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6A08 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6A0A 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6A0C 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6A0E B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6A10 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6A12 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6A14 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6A16 0607  14         dec   tmp3                  ; Decrease counter
0036 6A18 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6A1A 0207  20         li    tmp3,4                ; Check first 4 digits
     6A1C 0004 
0041 6A1E 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6A20 C11B  26         mov   *r11,tmp0
0043 6A22 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6A24 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6A26 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6A28 05CB  14 mknum3  inct  r11
0047 6A2A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A2C 202A 
0048 6A2E 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6A30 045B  20         b     *r11                  ; Exit
0050 6A32 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6A34 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6A36 13F8  14         jeq   mknum3                ; Yes, exit
0053 6A38 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6A3A 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6A3C 7FFF 
0058 6A3E C10B  18         mov   r11,tmp0
0059 6A40 0224  22         ai    tmp0,-4
     6A42 FFFC 
0060 6A44 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6A46 0206  20         li    tmp2,>0500            ; String length = 5
     6A48 0500 
0062 6A4A 0460  28         b     @xutstr               ; Display string
     6A4C 241C 
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
0092 6A4E C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6A50 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6A52 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6A54 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6A56 0207  20         li    tmp3,5                ; Set counter
     6A58 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6A5A 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6A5C 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6A5E 0584  14         inc   tmp0                  ; Next character
0104 6A60 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6A62 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6A64 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6A66 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6A68 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6A6A 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6A6C DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6A6E 0607  14         dec   tmp3                  ; Last character ?
0120 6A70 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6A72 045B  20         b     *r11                  ; Return
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
0138 6A74 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6A76 832A 
0139 6A78 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6A7A 8000 
0140 6A7C 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6A7E 0649  14         dect  stack
0023 6A80 C64B  30         mov   r11,*stack            ; Save return address
0024 6A82 0649  14         dect  stack
0025 6A84 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6A86 0649  14         dect  stack
0027 6A88 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6A8A 0649  14         dect  stack
0029 6A8C C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6A8E 0649  14         dect  stack
0031 6A90 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6A92 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6A94 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6A96 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6A98 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6A9A 0649  14         dect  stack
0044 6A9C C64B  30         mov   r11,*stack            ; Save return address
0045 6A9E 0649  14         dect  stack
0046 6AA0 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6AA2 0649  14         dect  stack
0048 6AA4 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6AA6 0649  14         dect  stack
0050 6AA8 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6AAA 0649  14         dect  stack
0052 6AAC C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6AAE C1D4  26 !       mov   *tmp0,tmp3
0057 6AB0 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6AB2 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6AB4 00FF 
0059 6AB6 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6AB8 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6ABA 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6ABC 0584  14         inc   tmp0                  ; Next byte
0067 6ABE 0607  14         dec   tmp3                  ; Shorten string length
0068 6AC0 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6AC2 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6AC4 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6AC6 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6AC8 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6ACA C187  18         mov   tmp3,tmp2
0078 6ACC 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6ACE DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6AD0 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6AD2 2492 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6AD4 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6AD6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6AD8 FFCE 
0090 6ADA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6ADC 2030 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6ADE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6AE0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6AE2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6AE4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6AE6 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6AE8 045B  20         b     *r11                  ; Return to caller
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
0123 6AEA 0649  14         dect  stack
0124 6AEC C64B  30         mov   r11,*stack            ; Save return address
0125 6AEE 05D9  26         inct  *stack                ; Skip "data P0"
0126 6AF0 05D9  26         inct  *stack                ; Skip "data P1"
0127 6AF2 0649  14         dect  stack
0128 6AF4 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6AF6 0649  14         dect  stack
0130 6AF8 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6AFA 0649  14         dect  stack
0132 6AFC C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6AFE C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6B00 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6B02 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6B04 0649  14         dect  stack
0144 6B06 C64B  30         mov   r11,*stack            ; Save return address
0145 6B08 0649  14         dect  stack
0146 6B0A C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6B0C 0649  14         dect  stack
0148 6B0E C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6B10 0649  14         dect  stack
0150 6B12 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6B14 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6B16 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6B18 0586  14         inc   tmp2
0161 6B1A 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6B1C 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Sanity check on string length
0165                       ;-----------------------------------------------------------------------
0166 6B1E 0286  22         ci    tmp2,255
     6B20 00FF 
0167 6B22 1505  14         jgt   string.getlenc.panic
0168 6B24 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6B26 0606  14         dec   tmp2                  ; One time adjustment
0174 6B28 C806  38         mov   tmp2,@waux1           ; Store length
     6B2A 833C 
0175 6B2C 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6B2E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B30 FFCE 
0181 6B32 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B34 2030 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6B36 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6B38 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6B3A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6B3C C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6B3E 045B  20         b     *r11                  ; Return to caller
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
0022 6B40 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     6B42 F000 
0023 6B44 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     6B46 F002 
0024 6B48 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     6B4A F004 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 6B4C 0200  20         li    r0,>8306              ; Scratpad source address
     6B4E 8306 
0029 6B50 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     6B52 F006 
0030 6B54 0202  20         li    r2,62                 ; Loop counter
     6B56 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 6B58 CC70  46         mov   *r0+,*r1+
0036 6B5A CC70  46         mov   *r0+,*r1+
0037 6B5C 0642  14         dect  r2
0038 6B5E 16FC  14         jne   cpu.scrpad.backup.copy
0039 6B60 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     6B62 83FE 
     6B64 F0FE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 6B66 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     6B68 F000 
0045 6B6A C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     6B6C F002 
0046 6B6E C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     6B70 F004 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 6B72 045B  20         b     *r11                  ; Return to caller
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
0070 6B74 C820  54         mov   @cpu.scrpad.tgt,@>8300
     6B76 F000 
     6B78 8300 
0071 6B7A C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     6B7C F002 
     6B7E 8302 
0072 6B80 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     6B82 F004 
     6B84 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 6B86 C800  38         mov   r0,@cpu.scrpad.tgt
     6B88 F000 
0077 6B8A C801  38         mov   r1,@cpu.scrpad.tgt + 2
     6B8C F002 
0078 6B8E C802  38         mov   r2,@cpu.scrpad.tgt + 4
     6B90 F004 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 6B92 0200  20         li    r0,cpu.scrpad.tgt + 6
     6B94 F006 
0083 6B96 0201  20         li    r1,>8306
     6B98 8306 
0084 6B9A 0202  20         li    r2,62
     6B9C 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 6B9E CC70  46         mov   *r0+,*r1+
0090 6BA0 CC70  46         mov   *r0+,*r1+
0091 6BA2 0642  14         dect  r2
0092 6BA4 16FC  14         jne   cpu.scrpad.restore.copy
0093 6BA6 C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     6BA8 F0FE 
     6BAA 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 6BAC C020  34         mov   @cpu.scrpad.tgt,r0
     6BAE F000 
0099 6BB0 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     6BB2 F002 
0100 6BB4 C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     6BB6 F004 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 6BB8 045B  20         b     *r11                  ; Return to caller
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
0025 6BBA C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 6BBC 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6BBE 8300 
0031 6BC0 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 6BC2 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6BC4 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 6BC6 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 6BC8 0606  14         dec   tmp2
0038 6BCA 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 6BCC C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 6BCE 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6BD0 2B62 
0044                                                   ; R14=PC
0045 6BD2 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 6BD4 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 6BD6 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     6BD8 2B00 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 6BDA 045B  20         b     *r11                  ; Return to caller
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
0078 6BDC C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 6BDE 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6BE0 8300 
0084 6BE2 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6BE4 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 6BE6 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 6BE8 0606  14         dec   tmp2
0090 6BEA 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 6BEC 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6BEE 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 6BF0 045B  20         b     *r11                  ; Return to caller
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
0041 6BF2 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6BF4 2B82             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6BF6 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6BF8 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6BFA 8322 
0049 6BFC 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6BFE 2026 
0050 6C00 C020  34         mov   @>8356,r0             ; get ptr to pab
     6C02 8356 
0051 6C04 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6C06 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     6C08 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6C0A 06C0  14         swpb  r0                    ;
0059 6C0C D800  38         movb  r0,@vdpa              ; send low byte
     6C0E 8C02 
0060 6C10 06C0  14         swpb  r0                    ;
0061 6C12 D800  38         movb  r0,@vdpa              ; send high byte
     6C14 8C02 
0062 6C16 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6C18 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6C1A 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6C1C 0704  14         seto  r4                    ; init counter
0070 6C1E 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6C20 A420 
0071 6C22 0580  14 !       inc   r0                    ; point to next char of name
0072 6C24 0584  14         inc   r4                    ; incr char counter
0073 6C26 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6C28 0007 
0074 6C2A 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6C2C 80C4  18         c     r4,r3                 ; end of name?
0077 6C2E 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6C30 06C0  14         swpb  r0                    ;
0082 6C32 D800  38         movb  r0,@vdpa              ; send low byte
     6C34 8C02 
0083 6C36 06C0  14         swpb  r0                    ;
0084 6C38 D800  38         movb  r0,@vdpa              ; send high byte
     6C3A 8C02 
0085 6C3C D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6C3E 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6C40 DC81  32         movb  r1,*r2+               ; move into buffer
0092 6C42 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6C44 2C92 
0093 6C46 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6C48 C104  18         mov   r4,r4                 ; Check if length = 0
0099 6C4A 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6C4C 04E0  34         clr   @>83d0
     6C4E 83D0 
0102 6C50 C804  38         mov   r4,@>8354             ; save name length for search
     6C52 8354 
0103 6C54 0584  14         inc   r4                    ; adjust for dot
0104 6C56 A804  38         a     r4,@>8356             ; point to position after name
     6C58 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6C5A 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6C5C 83E0 
0110 6C5E 04C1  14         clr   r1                    ; version found of dsr
0111 6C60 020C  20         li    r12,>0f00             ; init cru addr
     6C62 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6C64 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6C66 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6C68 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6C6A 022C  22         ai    r12,>0100             ; next rom to turn on
     6C6C 0100 
0125 6C6E 04E0  34         clr   @>83d0                ; clear in case we are done
     6C70 83D0 
0126 6C72 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6C74 2000 
0127 6C76 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6C78 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6C7A 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6C7C 1D00  20         sbo   0                     ; turn on rom
0134 6C7E 0202  20         li    r2,>4000              ; start at beginning of rom
     6C80 4000 
0135 6C82 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6C84 2C8E 
0136 6C86 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6C88 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6C8A A40A 
0146 6C8C 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6C8E C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6C90 83D2 
0152                                                   ; subprogram
0153               
0154 6C92 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 6C94 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 6C96 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 6C98 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6C9A 83D2 
0163                                                   ; subprogram
0164               
0165 6C9C 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 6C9E C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 6CA0 04C5  14         clr   r5                    ; Remove any old stuff
0174 6CA2 D160  34         movb  @>8355,r5             ; get length as counter
     6CA4 8355 
0175 6CA6 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 6CA8 9C85  32         cb    r5,*r2+               ; see if length matches
0180 6CAA 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 6CAC 0985  56         srl   r5,8                  ; yes, move to low byte
0185 6CAE 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6CB0 A420 
0186 6CB2 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 6CB4 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 6CB6 0605  14         dec   r5                    ; loop until full length checked
0191 6CB8 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 6CBA C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6CBC 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 6CBE 0581  14         inc   r1                    ; next version found
0203 6CC0 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 6CC2 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 6CC4 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 6CC6 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6CC8 A400 
0212 6CCA C009  18         mov   r9,r0                 ; point to flag in pab
0213 6CCC C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6CCE 8322 
0214                                                   ; (8 or >a)
0215 6CD0 0281  22         ci    r1,8                  ; was it 8?
     6CD2 0008 
0216 6CD4 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 6CD6 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6CD8 8350 
0218                                                   ; Get error byte from @>8350
0219 6CDA 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 6CDC 06C0  14         swpb  r0                    ;
0227 6CDE D800  38         movb  r0,@vdpa              ; send low byte
     6CE0 8C02 
0228 6CE2 06C0  14         swpb  r0                    ;
0229 6CE4 D800  38         movb  r0,@vdpa              ; send high byte
     6CE6 8C02 
0230 6CE8 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6CEA 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 6CEC 09D1  56         srl   r1,13                 ; just keep error bits
0238 6CEE 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 6CF0 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 6CF2 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6CF4 A400 
0248               dsrlnk.error.devicename_invalid:
0249 6CF6 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 6CF8 06C1  14         swpb  r1                    ; put error in hi byte
0252 6CFA D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 6CFC F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6CFE 2026 
0254 6D00 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 6D02 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 6D04 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 6D06 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6D08 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6D0A 04C5  14         clr   tmp1                  ; io.op.open
0049 6D0C 1012  14         jmp   _file.record.fop      ; Do file operation
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
0071 6D0E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0072               *--------------------------------------------------------------
0073               * Initialisation
0074               *--------------------------------------------------------------
0075               xfile.close:
0076 6D10 0205  20         li    tmp1,io.op.close      ; io.op.close
     6D12 0001 
0077 6D14 100E  14         jmp   _file.record.fop      ; Do file operation
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
0098 6D16 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0099               *--------------------------------------------------------------
0100               * Initialisation
0101               *--------------------------------------------------------------
0102 6D18 0205  20         li    tmp1,io.op.read       ; io.op.read
     6D1A 0002 
0103 6D1C 100A  14         jmp   _file.record.fop      ; Do file operation
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
0125 6D1E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0126               *--------------------------------------------------------------
0127               * Initialisation
0128               *--------------------------------------------------------------
0129 6D20 0205  20         li    tmp1,io.op.write      ; io.op.write
     6D22 0003 
0130 6D24 1006  14         jmp   _file.record.fop      ; Do file operation
0131               
0132               
0133               
0134               file.record.seek:
0135 6D26 1000  14         nop
0136               
0137               
0138               file.image.load:
0139 6D28 1000  14         nop
0140               
0141               
0142               file.image.save:
0143 6D2A 1000  14         nop
0144               
0145               
0146               file.delete:
0147 6D2C 1000  14         nop
0148               
0149               
0150               file.rename:
0151 6D2E 1000  14         nop
0152               
0153               
0154               file.status:
0155 6D30 1000  14         nop
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
0176 6D32 C04B  18         mov   r11,r1                ; Save return address
0177 6D34 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6D36 A428 
0178 6D38 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0179               
0180 6D3A 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6D3C 22C6 
0181                                                   ; \ i  tmp0 = VDP target address
0182                                                   ; / i  tmp1 = Byte to write
0183               
0184 6D3E 0220  22         ai    r0,9                  ; Move to file descriptor length
     6D40 0009 
0185 6D42 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6D44 8356 
0186               *--------------------------------------------------------------
0187               * Call DSRLINK for doing file operation
0188               *--------------------------------------------------------------
0189 6D46 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6D48 2B7E 
0190 6D4A 0008             data  8                     ;
0191               *--------------------------------------------------------------
0192               * Return PAB details to caller
0193               *--------------------------------------------------------------
0194               _file.record.fop.pab:
0195 6D4C 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0196                                                   ; Upon DSRLNK return status register EQ bit
0197                                                   ; 1 = No file error
0198                                                   ; 0 = File error occured
0199               *--------------------------------------------------------------
0200               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0201               *--------------------------------------------------------------
0202 6D4E C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6D50 A428 
0203 6D52 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6D54 0005 
0204 6D56 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6D58 22DE 
0205 6D5A C144  18         mov   tmp0,tmp1             ; Move to destination
0206               *--------------------------------------------------------------
0207               * Get PAB byte 1 from VDP ram into tmp0 (status)
0208               *--------------------------------------------------------------
0209 6D5C C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0230 6D5E 0451  20         b     *r1                   ; Return to caller
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
0020 6D60 0300  24 tmgr    limi  0                     ; No interrupt processing
     6D62 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6D64 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6D66 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6D68 2360  38         coc   @wbit2,r13            ; C flag on ?
     6D6A 2026 
0029 6D6C 1602  14         jne   tmgr1a                ; No, so move on
0030 6D6E E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6D70 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6D72 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6D74 202A 
0035 6D76 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6D78 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6D7A 201A 
0048 6D7C 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6D7E 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6D80 2018 
0050 6D82 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6D84 0460  28         b     @kthread              ; Run kernel thread
     6D86 2D8A 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6D88 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6D8A 201E 
0056 6D8C 13EB  14         jeq   tmgr1
0057 6D8E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6D90 201C 
0058 6D92 16E8  14         jne   tmgr1
0059 6D94 C120  34         mov   @wtiusr,tmp0
     6D96 832E 
0060 6D98 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6D9A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6D9C 2D88 
0065 6D9E C10A  18         mov   r10,tmp0
0066 6DA0 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6DA2 00FF 
0067 6DA4 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6DA6 2026 
0068 6DA8 1303  14         jeq   tmgr5
0069 6DAA 0284  22         ci    tmp0,60               ; 1 second reached ?
     6DAC 003C 
0070 6DAE 1002  14         jmp   tmgr6
0071 6DB0 0284  22 tmgr5   ci    tmp0,50
     6DB2 0032 
0072 6DB4 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6DB6 1001  14         jmp   tmgr8
0074 6DB8 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6DBA C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6DBC 832C 
0079 6DBE 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6DC0 FF00 
0080 6DC2 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6DC4 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6DC6 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6DC8 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6DCA C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6DCC 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6DCE 830C 
     6DD0 830D 
0089 6DD2 1608  14         jne   tmgr10                ; No, get next slot
0090 6DD4 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6DD6 FF00 
0091 6DD8 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6DDA C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6DDC 8330 
0096 6DDE 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6DE0 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6DE2 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6DE4 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6DE6 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6DE8 8315 
     6DEA 8314 
0103 6DEC 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6DEE 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6DF0 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6DF2 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6DF4 10F7  14         jmp   tmgr10                ; Process next slot
0108 6DF6 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6DF8 FF00 
0109 6DFA 10B4  14         jmp   tmgr1
0110 6DFC 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6DFE E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6E00 201A 
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
0041 6E02 06A0  32         bl    @realkb               ; Scan full keyboard
     6E04 279C 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6E06 0460  28         b     @tmgr3                ; Exit
     6E08 2D14 
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
0017 6E0A C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6E0C 832E 
0018 6E0E E0A0  34         soc   @wbit7,config         ; Enable user hook
     6E10 201C 
0019 6E12 045B  20 mkhoo1  b     *r11                  ; Return
0020      2CF0     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6E14 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6E16 832E 
0029 6E18 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6E1A FEFF 
0030 6E1C 045B  20         b     *r11                  ; Return
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
0017 6E1E C13B  30 mkslot  mov   *r11+,tmp0
0018 6E20 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6E22 C184  18         mov   tmp0,tmp2
0023 6E24 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6E26 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6E28 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6E2A CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6E2C 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6E2E C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6E30 881B  46         c     *r11,@w$ffff          ; End of list ?
     6E32 202C 
0035 6E34 1301  14         jeq   mkslo1                ; Yes, exit
0036 6E36 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6E38 05CB  14 mkslo1  inct  r11
0041 6E3A 045B  20         b     *r11                  ; Exit
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
0052 6E3C C13B  30 clslot  mov   *r11+,tmp0
0053 6E3E 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6E40 A120  34         a     @wtitab,tmp0          ; Add table base
     6E42 832C 
0055 6E44 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6E46 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6E48 045B  20         b     *r11                  ; Exit
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
0068 6E4A C13B  30 rsslot  mov   *r11+,tmp0
0069 6E4C 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 6E4E A120  34         a     @wtitab,tmp0          ; Add table base
     6E50 832C 
0071 6E52 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 6E54 C154  26         mov   *tmp0,tmp1
0073 6E56 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     6E58 FF00 
0074 6E5A C505  30         mov   tmp1,*tmp0
0075 6E5C 045B  20         b     *r11                  ; Exit
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
0255 6E5E 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     6E60 2ACC 
0256                                                   ; @cpu.scrpad.tgt (>00..>ff)
0257               
0258 6E62 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6E64 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 6E66 0300  24 runli1  limi  0                     ; Turn off interrupts
     6E68 0000 
0266 6E6A 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6E6C 8300 
0267 6E6E C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6E70 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 6E72 0202  20 runli2  li    r2,>8308
     6E74 8308 
0272 6E76 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 6E78 0282  22         ci    r2,>8400
     6E7A 8400 
0274 6E7C 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 6E7E 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     6E80 FFFF 
0279 6E82 1602  14         jne   runli4                ; No, continue
0280 6E84 0420  54         blwp  @0                    ; Yes, bye bye
     6E86 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 6E88 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6E8A 833C 
0285 6E8C 04C1  14         clr   r1                    ; Reset counter
0286 6E8E 0202  20         li    r2,10                 ; We test 10 times
     6E90 000A 
0287 6E92 C0E0  34 runli5  mov   @vdps,r3
     6E94 8802 
0288 6E96 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6E98 202A 
0289 6E9A 1302  14         jeq   runli6
0290 6E9C 0581  14         inc   r1                    ; Increase counter
0291 6E9E 10F9  14         jmp   runli5
0292 6EA0 0602  14 runli6  dec   r2                    ; Next test
0293 6EA2 16F7  14         jne   runli5
0294 6EA4 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6EA6 1250 
0295 6EA8 1202  14         jle   runli7                ; No, so it must be NTSC
0296 6EAA 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6EAC 2026 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 6EAE 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6EB0 221A 
0301 6EB2 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6EB4 8322 
0302 6EB6 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0303 6EB8 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0304 6EBA CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0305               *--------------------------------------------------------------
0306               * Initialize registers, memory, ...
0307               *--------------------------------------------------------------
0308 6EBC 04C1  14 runli9  clr   r1
0309 6EBE 04C2  14         clr   r2
0310 6EC0 04C3  14         clr   r3
0311 6EC2 0209  20         li    stack,>8400           ; Set stack
     6EC4 8400 
0312 6EC6 020F  20         li    r15,vdpw              ; Set VDP write address
     6EC8 8C00 
0316               *--------------------------------------------------------------
0317               * Setup video memory
0318               *--------------------------------------------------------------
0320 6ECA 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6ECC 4A4A 
0321 6ECE 1605  14         jne   runlia
0322 6ED0 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6ED2 2288 
0323 6ED4 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6ED6 0000 
     6ED8 3FFF 
0328 6EDA 06A0  32 runlia  bl    @filv
     6EDC 2288 
0329 6EDE 0FC0             data  pctadr,spfclr,16      ; Load color table
     6EE0 00F4 
     6EE2 0010 
0330               *--------------------------------------------------------------
0331               * Check if there is a F18A present
0332               *--------------------------------------------------------------
0336 6EE4 06A0  32         bl    @f18unl               ; Unlock the F18A
     6EE6 26E4 
0337 6EE8 06A0  32         bl    @f18chk               ; Check if F18A is there
     6EEA 26FE 
0338 6EEC 06A0  32         bl    @f18lck               ; Lock the F18A again
     6EEE 26F4 
0339               
0340 6EF0 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     6EF2 232C 
0341 6EF4 3201                   data >3201            ; F18a VR50 (>32), bit 1
0343               *--------------------------------------------------------------
0344               * Check if there is a speech synthesizer attached
0345               *--------------------------------------------------------------
0347               *       <<skipped>>
0351               *--------------------------------------------------------------
0352               * Load video mode table & font
0353               *--------------------------------------------------------------
0354 6EF6 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6EF8 22F2 
0355 6EFA 3008             data  spvmod                ; Equate selected video mode table
0356 6EFC 0204  20         li    tmp0,spfont           ; Get font option
     6EFE 000C 
0357 6F00 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0358 6F02 1304  14         jeq   runlid                ; Yes, skip it
0359 6F04 06A0  32         bl    @ldfnt
     6F06 235A 
0360 6F08 1100             data  fntadr,spfont         ; Load specified font
     6F0A 000C 
0361               *--------------------------------------------------------------
0362               * Did a system crash occur before runlib was called?
0363               *--------------------------------------------------------------
0364 6F0C 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6F0E 4A4A 
0365 6F10 1602  14         jne   runlie                ; No, continue
0366 6F12 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6F14 2090 
0367               *--------------------------------------------------------------
0368               * Branch to main program
0369               *--------------------------------------------------------------
0370 6F16 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6F18 0040 
0371 6F1A 0460  28         b     @main                 ; Give control to main program
     6F1C 3000 
**** **** ****     > stevie_b0.asm.503815
0100                                                   ; Spectra 2
0101                       ;------------------------------------------------------
0102                       ; End of File marker
0103                       ;------------------------------------------------------
0104 6F1E DEAD             data  >dead,>beef,>dead,>beef
     6F20 BEEF 
     6F22 DEAD 
     6F24 BEEF 
0106 6F26 ....             bss  300                    ; Fill remaining space with >00
0107               
0108               
0109               
0110               
0111               ***************************************************************
0112               * Code data: Relocated Stevie modules >3000 - >3fff (4K maximum)
0113               ********|*****|*********************|**************************
0114               reloc.stevie:
0115                       xorg  >3000                 ; Relocate Stevie modules to >3000
0116                       ;------------------------------------------------------
0117                       ; Activate bank 1 and branch to >6036
0118                       ;------------------------------------------------------
0119               main:
0120 7052 04E0  34         clr   @>6002                ; Activate bank 1 (2nd bank!)
     7054 6002 
0121 7056 0460  28         b     @kickstart.code2      ; Jump to entry routine
     7058 6036 
0122                       ;------------------------------------------------------
0123                       ; Resident Stevie modules >3000 - >3fff
0124                       ;------------------------------------------------------
0125                       copy  "data.constants.asm"  ; Data Constants
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
0033 705A 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     705C 003F 
     705E 0243 
     7060 05F4 
     7062 0050 
0034               
0035               romsat:
0036 7064 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     7066 0001 
0037               
0038               cursors:
0039 7068 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     706A 0000 
     706C 0000 
     706E 001C 
0040 7070 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 2 - Insert mode
     7072 1C1C 
     7074 1C1C 
     7076 1C00 
0041 7078 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     707A 1C1C 
     707C 1C1C 
     707E 1C00 
0042               
0043               patterns:
0044 7080 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     7082 0000 
     7084 00FF 
     7086 0000 
0045 7088 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     708A 0000 
     708C FF00 
     708E FF00 
0046               patterns.box:
0047 7090 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     7092 0000 
     7094 FF00 
     7096 FF00 
0048 7098 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     709A 0000 
     709C FF80 
     709E BFA0 
0049 70A0 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     70A2 0000 
     70A4 FC04 
     70A6 F414 
0050 70A8 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     70AA A0A0 
     70AC A0A0 
     70AE A0A0 
0051 70B0 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     70B2 1414 
     70B4 1414 
     70B6 1414 
0052 70B8 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     70BA A0A0 
     70BC BF80 
     70BE FF00 
0053 70C0 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     70C2 1414 
     70C4 F404 
     70C6 FC00 
0054 70C8 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     70CA C0C0 
     70CC C0C0 
     70CE 0080 
0055 70D0 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     70D2 0F0F 
     70D4 0F0F 
     70D6 0000 
0056               
0057               
0058               
0059               
0060               ***************************************************************
0061               * SAMS page layout table for Stevie (16 words)
0062               *--------------------------------------------------------------
0063               mem.sams.layout.data:
0064 70D8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     70DA 0002 
0065 70DC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     70DE 0003 
0066 70E0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     70E2 000A 
0067               
0068 70E4 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     70E6 0010 
0069                                                   ; \ The index can allocate
0070                                                   ; / pages >10 to >2f.
0071               
0072 70E8 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     70EA 0030 
0073                                                   ; \ Editor buffer can allocate
0074                                                   ; / pages >30 to >ff.
0075               
0076 70EC D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     70EE 000D 
0077 70F0 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     70F2 000E 
0078 70F4 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     70F6 000F 
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
0104 70F8 F41F      data  >f41f,>f001       ; 1  White/dark blue    | Black/white        | White
     70FA F001 
0105 70FC F41C      data  >f41c,>f00f       ; 2  White/dark blue    | Black/dark green   | White
     70FE F00F 
0106 7100 A11A      data  >a11a,>f00f       ; 3  Dark yellow/black  | Black/dark yellow  | White
     7102 F00F 
0107 7104 2112      data  >2112,>f00f       ; 4  Medium green/black | Black/medium green | White
     7106 F00F 
0108 7108 E11E      data  >e11e,>f00f       ; 5  Grey/black         | Black/grey         | White
     710A F00F 
0109 710C 1771      data  >1771,>1006       ; 6  Black/cyan         | Cyan/black         | Black
     710E 1006 
0110 7110 1FF1      data  >1ff1,>1001       ; 7  Black/white        | White/black        | Black
     7112 1001 
0111 7114 A1F0      data  >a1f0,>1a0f       ; 8  Dark yellow/black  | White/transparent  | inverse
     7116 1A0F 
0112 7118 21F0      data  >21f0,>f20f       ; 9  Medium green/black | White/transparent  | inverse
     711A F20F 
0113               
**** **** ****     > stevie_b0.asm.503815
0126                       copy  "data.strings.asm"    ; Data segment - Strings
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
0012 711C 012C             byte  1
0013 711D ....             text  ','
0014                       even
0015               
0016               txt.marker
0017 711E 052A             byte  5
0018 711F ....             text  '*EOF*'
0019                       even
0020               
0021               txt.bottom
0022 7124 0520             byte  5
0023 7125 ....             text  '  BOT'
0024                       even
0025               
0026               txt.ovrwrite
0027 712A 034F             byte  3
0028 712B ....             text  'OVR'
0029                       even
0030               
0031               txt.insert
0032 712E 0349             byte  3
0033 712F ....             text  'INS'
0034                       even
0035               
0036               txt.star
0037 7132 012A             byte  1
0038 7133 ....             text  '*'
0039                       even
0040               
0041               txt.loading
0042 7134 0A4C             byte  10
0043 7135 ....             text  'Loading...'
0044                       even
0045               
0046               txt.kb
0047 7140 026B             byte  2
0048 7141 ....             text  'kb'
0049                       even
0050               
0051               txt.lines
0052 7144 054C             byte  5
0053 7145 ....             text  'Lines'
0054                       even
0055               
0056               txt.bufnum
0057 714A 0323             byte  3
0058 714B ....             text  '#1 '
0059                       even
0060               
0061               txt.newfile
0062 714E 0A5B             byte  10
0063 714F ....             text  '[New file]'
0064                       even
0065               
0066               txt.filetype.dv80
0067 715A 0444             byte  4
0068 715B ....             text  'DV80'
0069                       even
0070               
0071               txt.filetype.none
0072 7160 0420             byte  4
0073 7161 ....             text  '    '
0074                       even
0075               
0076               
0077               
0078               ;--------------------------------------------------------------
0079               ; Dialog Load DV 80 file
0080               ;--------------------------------------------------------------
0081               txt.head.loaddv80
0082 7166 0E4C             byte  14
0083 7167 ....             text  'Load DV80 file'
0084                       even
0085               
0086               txt.hint.loaddv80
0087 7176 2748             byte  39
0088 7177 ....             text  'HINT: Specify filename and press ENTER.'
0089                       even
0090               
0091               txt.keys.loaddv80
0092 719E 4246             byte  66
0093 719F ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End    ^,=Previous    ^.=Next'
0094                       even
0095               
0096               
0097               ;--------------------------------------------------------------
0098               ; Dialog "Unsaved changes"
0099               ;--------------------------------------------------------------
0100               txt.head.unsaved
0101 71E2 0F55             byte  15
0102 71E3 ....             text  'Unsaved changes'
0103                       even
0104               
0105               txt.hint.unsaved
0106 71F2 2748             byte  39
0107 71F3 ....             text  'HINT: Unsaved changes in editor buffer.'
0108                       even
0109               
0110               txt.keys.unsaved
0111 721A 2B46             byte  43
0112 721B ....             text  'F9=Back    F6=Proceed anyway   ^S=Save file'
0113                       even
0114               
0115               
0116               
0117               
0118               ;--------------------------------------------------------------
0119               ; Strings for error line pane
0120               ;--------------------------------------------------------------
0121               txt.ioerr
0122 7246 2049             byte  32
0123 7247 ....             text  'I/O error. Failed loading file: '
0124                       even
0125               
0126               txt.io.nofile
0127 7268 2149             byte  33
0128 7269 ....             text  'I/O error. No filename specified.'
0129                       even
0130               
0131               
0132               
0133               ;--------------------------------------------------------------
0134               ; Strings for command buffer
0135               ;--------------------------------------------------------------
0136               txt.cmdb.title
0137 728A 0E43             byte  14
0138 728B ....             text  'Command buffer'
0139                       even
0140               
0141               txt.cmdb.prompt
0142 729A 013E             byte  1
0143 729B ....             text  '>'
0144                       even
0145               
0146               
0147               
0148               
0149 729C 4201     txt.cmdb.hbar      byte    66
0150 729E 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     72A0 0101 
     72A2 0101 
     72A4 0101 
     72A6 0101 
     72A8 0101 
     72AA 0101 
     72AC 0101 
     72AE 0101 
     72B0 0101 
0151 72B2 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     72B4 0101 
     72B6 0101 
     72B8 0101 
     72BA 0101 
     72BC 0101 
     72BE 0101 
     72C0 0101 
     72C2 0101 
     72C4 0101 
0152 72C6 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     72C8 0101 
     72CA 0101 
     72CC 0101 
     72CE 0101 
     72D0 0101 
     72D2 0101 
     72D4 0101 
     72D6 0101 
     72D8 0101 
0153 72DA 0101                        byte    1,1,1,1,1,1
     72DC 0101 
     72DE 0100 
0154                                  even
0155               
0156               
0157               
0158 72E0 0C0A     txt.stevie         byte    12
0159                                  byte    10
0160 72E2 ....                        text    'stevie v1.00'
0161 72EE 0B00                        byte    11
0162                                  even
0163               
0164               txt.colorscheme
0165 72F0 0E43             byte  14
0166 72F1 ....             text  'COLOR SCHEME: '
0167                       even
0168               
0169               
0170               
0171               ;--------------------------------------------------------------
0172               ; Strings for filenames
0173               ;--------------------------------------------------------------
0174               fdname1
0175 7300 0850             byte  8
0176 7301 ....             text  'PI.CLOCK'
0177                       even
0178               
0179               fdname2
0180 730A 0E54             byte  14
0181 730B ....             text  'TIPI.TIVI.NR80'
0182                       even
0183               
0184               fdname3
0185 731A 0C44             byte  12
0186 731B ....             text  'DSK1.XBEADOC'
0187                       even
0188               
0189               fdname4
0190 7328 1154             byte  17
0191 7329 ....             text  'TIPI.TIVI.C99MAN1'
0192                       even
0193               
0194               fdname5
0195 733A 1154             byte  17
0196 733B ....             text  'TIPI.TIVI.C99MAN2'
0197                       even
0198               
0199               fdname6
0200 734C 1154             byte  17
0201 734D ....             text  'TIPI.TIVI.C99MAN3'
0202                       even
0203               
0204               fdname7
0205 735E 1254             byte  18
0206 735F ....             text  'TIPI.TIVI.C99SPECS'
0207                       even
0208               
0209               fdname8
0210 7372 1254             byte  18
0211 7373 ....             text  'TIPI.TIVI.RANDOM#C'
0212                       even
0213               
0214               fdname9
0215 7386 0D44             byte  13
0216 7387 ....             text  'DSK1.INVADERS'
0217                       even
0218               
0219               fdname0
0220 7394 0944             byte  9
0221 7395 ....             text  'DSK1.NR80'
0222                       even
0223               
0224               fdname.clock
0225 739E 0850             byte  8
0226 739F ....             text  'PI.CLOCK'
0227                       even
0228               
**** **** ****     > stevie_b0.asm.503815
0127                       ;------------------------------------------------------
0128                       ; End of File marker
0129                       ;------------------------------------------------------
0130 73A8 DEAD             data  >dead,>beef,>dead,>beef
     73AA BEEF 
     73AC DEAD 
     73AE BEEF 
0132               
0136 73B0 335E                   data $                ; Bank 0 ROM size OK.
0138               
0139               
0140               
0141               *--------------------------------------------------------------
0142               * Video mode configuration for SP2
0143               *--------------------------------------------------------------
0144      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0145      0004     spfbck  equ   >04                   ; Screen background color.
0146      3008     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0147      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0148      0050     colrow  equ   80                    ; Columns per row
0149      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0150      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0151      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0152      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

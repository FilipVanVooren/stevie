XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b0.lst.asm.26898
0001               XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
0002               **** **** ****     > stevie_b0.asm.22608
0003               0001               ***************************************************************
0004               0002               *                          Stevie Editor
0005               0003               *
0006               0004               *       A 21th century Programming Editor for the 1981
0007               0005               *         Texas Instruments TI-99/4a Home Computer.
0008               0006               *
0009               0007               *              (c)2018-2020 // Filip van Vooren
0010               0008               ***************************************************************
0011               0009               * File: stevie_b0.asm               ; Version 200803-22608
0012               0010
0013               0011                       copy  "equates.asm"         ; Equates Stevie configuration
0014               **** **** ****     > equates.asm
0015               0001               ***************************************************************
0016               0002               *                          Stevie Editor
0017               0003               *
0018               0004               *       A 21th century Programming Editor for the 1981
0019               0005               *         Texas Instruments TI-99/4a Home Computer.
0020               0006               *
0021               0007               *              (c)2018-2020 // Filip van Vooren
0022               0008               ***************************************************************
0023               0009               * File: equates.asm                 ; Version 200803-22608
0024               0010               *--------------------------------------------------------------
0025               0011               * stevie memory layout
0026               0012               * See file "modules/mem.asm" for further details.
0027               0013               *
0028               0014               *
0029               0015               * LOW MEMORY EXPANSION (2000-2fff)
0030               0016               *
0031               0017               * Mem range   Bytes    SAMS   Purpose
0032               0018               * =========   =====    ====   ==================================
0033               0019               * 2000-2fff    4096           SP2 library
0034               0020               *
0035               0021               * LOW MEMORY EXPANSION (3000-3fff)
0036               0022               *
0037               0023               * Mem range   Bytes    SAMS   Purpose
0038               0024               * =========   =====    ====   ==================================
0039               0025               * 3200-3fff    4096           Resident Stevie Modules
0040               0026               *
0041               0027               *
0042               0028               * CARTRIDGE SPACE (6000-7fff)
0043               0029               *
0044               0030               * Mem range   Bytes    BANK   Purpose
0045               0031               * =========   =====    ====   ==================================
0046               0032               * 6000-7fff    8192       0   SP2 ROM CODE, copy to RAM code, resident modules
0047               0033               * 6000-7fff    8192       1   Stevie program code
0048               0034               *
0049               0035               *
0050               0036               * HIGH MEMORY EXPANSION (a000-ffff)
0051               0037               *
0052               0038               * Mem range   Bytes    SAMS   Purpose
0053               0039               * =========   =====    ====   ==================================
0054               0040               * a000-a0ff     256           Stevie Editor shared structure
0055               0041               * a100-a1ff     256           Framebuffer structure
0056               0042               * a200-a2ff     256           Editor buffer structure
0057               0043               * a300-a3ff     256           Command buffer structure
0058               0044               * a400-a4ff     256           File handle structure
0059               0045               * a500-a5ff     256           Index structure
0060               0046               * a600-af5f    2400           Frame buffer
0061               0047               * af60-afff     ???           *FREE*
0062               0048               *
0063               0049               * b000-bfff    4096           Index buffer page
0064               0050               * c000-cfff    4096           Editor buffer page
0065               0051               * d000-dfff    4096           Command history buffer
0066               0052               * e000-efff    4096           Heap
0067               0053               * f000-f0ff     256           SP2/GPL scratchpad backup 1
0068               0054               * f100-f1ff     256           SP2/GPL scratchpad backup 2
0069               0055               * f200-ffff    3584           *FREE*
0070               0056               *
0071               0057               *
0072               0058               * VDP RAM
0073               0059               *
0074               0060               * Mem range   Bytes    Hex    Purpose
0075               0061               * =========   =====   =====   =================================
0076               0062               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0077               0063               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0078               0064               * 0fc0                        PCT - Pattern Color Table
0079               0065               * 1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
0080               0066               * 1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
0081               0067               * 2180                        SAT - Sprite Attribute List
0082               0068               * 2800                        SPT - Sprite Pattern Table. Must be on 2K boundary
0083               0069               *--------------------------------------------------------------
0084               0070               * Skip unused spectra2 code modules for reduced code size
0085               0071               *--------------------------------------------------------------
0086               0072      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0087               0073      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0088               0074      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0089               0075      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0090               0076      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0091               0077      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0092               0078      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0093               0079      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0094               0080      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0095               0081      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0096               0082      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0097               0083      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0098               0084      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0099               0085      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0100               0086      0001     skip_random_generator     equ  1       ; Skip random functions
0101               0087      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0102               0088               *--------------------------------------------------------------
0103               0089               * Stevie specific equates
0104               0090               *--------------------------------------------------------------
0105               0091      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0106               0092      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0107               0093      0001     id.dialog.loaddv80        equ  1       ; ID for dialog "Load DV 80 file"
0108               0094      0002     id.dialog.unsaved         equ  2       ; ID for dialog "Unsaved changes"
0109               0095      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0110               0096      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0111               0097      0002     fh.fopmode.savefile       equ  2       ; Save file from memory to disk
0112               0098               *--------------------------------------------------------------
0113               0099               * SPECTRA2 / Stevie startup options
0114               0100               *--------------------------------------------------------------
0115               0101      0001     debug                     equ  1       ; Turn on spectra2 debugging
0116               0102      0001     startup_backup_scrpad     equ  1       ; Backup scratchpad 8300-83ff to
0117               0103                                                      ; memory address @cpu.scrpad.tgt
0118               0104      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0119               0105      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0120               0106      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0121               0107               *--------------------------------------------------------------
0122               0108               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0123               0109               *--------------------------------------------------------------
0124               0110               ;                 equ  >8342           ; >8342-834F **free***
0125               0111      8350     parm1             equ  >8350           ; Function parameter 1
0126               0112      8352     parm2             equ  >8352           ; Function parameter 2
0127               0113      8354     parm3             equ  >8354           ; Function parameter 3
0128               0114      8356     parm4             equ  >8356           ; Function parameter 4
0129               0115      8358     parm5             equ  >8358           ; Function parameter 5
0130               0116      835A     parm6             equ  >835a           ; Function parameter 6
0131               0117      835C     parm7             equ  >835c           ; Function parameter 7
0132               0118      835E     parm8             equ  >835e           ; Function parameter 8
0133               0119      8360     outparm1          equ  >8360           ; Function output parameter 1
0134               0120      8362     outparm2          equ  >8362           ; Function output parameter 2
0135               0121      8364     outparm3          equ  >8364           ; Function output parameter 3
0136               0122      8366     outparm4          equ  >8366           ; Function output parameter 4
0137               0123      8368     outparm5          equ  >8368           ; Function output parameter 5
0138               0124      836A     outparm6          equ  >836a           ; Function output parameter 6
0139               0125      836C     outparm7          equ  >836c           ; Function output parameter 7
0140               0126      836E     outparm8          equ  >836e           ; Function output parameter 8
0141               0127      8370     timers            equ  >8370           ; Timer table
0142               0128      8380     ramsat            equ  >8380           ; Sprite Attribute Table in RAM
0143               0129      8390     rambuf            equ  >8390           ; RAM workbuffer 1
0144               0130               *--------------------------------------------------------------
0145               0131               * Stevie Editor shared structures     @>a000-a0ff     (256 bytes)
0146               0132               *--------------------------------------------------------------
0147               0133      A000     tv.top            equ  >a000           ; Structure begin
0148               0134      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0149               0135      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0150               0136      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0151               0137      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0152               0138      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0153               0139      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0154               0140      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0155               0141      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0156               0142      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0157               0143      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0158               0144      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0159               0145      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0160               0146      A018     tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
0161               0147      A01A     tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
0162               0148      A01C     tv.task.oneshot   equ  tv.top + 28     ; Pointer to one-shot routine
0163               0149      A01E     tv.error.visible  equ  tv.top + 30     ; Error pane visible
0164               0150      A020     tv.error.msg      equ  tv.top + 32     ; Error message (max. 160 characters)
0165               0151      A0C0     tv.free           equ  tv.top + 192    ; End of structure
0166               0152               *--------------------------------------------------------------
0167               0153               * Frame buffer structure            @>a100-a1ff     (256 bytes)
0168               0154               *--------------------------------------------------------------
0169               0155      A100     fb.struct         equ  >a100           ; Structure begin
0170               0156      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0171               0157      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0172               0158      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0173               0159                                                      ; line X in editor buffer).
0174               0160      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0175               0161                                                      ; (offset 0 .. @fb.scrrows)
0176               0162      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0177               0163      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0178               0164      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0179               0165      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0180               0166      A110     fb.free1          equ  fb.struct + 16  ; **** free ****
0181               0167      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0182               0168      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0183               0169      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0184               0170      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0185               0171      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0186               0172      A11C     fb.free           equ  fb.struct + 28  ; End of structure
0187               0173               *--------------------------------------------------------------
0188               0174               * Editor buffer structure           @>a200-a2ff     (256 bytes)
0189               0175               *--------------------------------------------------------------
0190               0176      A200     edb.struct        equ  >a200           ; Begin structure
0191               0177      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0192               0178      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0193               0179      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0194               0180      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0195               0181      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0196               0182      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0197               0183      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0198               0184      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0199               0185                                                      ; with current filename.
0200               0186      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0201               0187                                                      ; with current file type.
0202               0188      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0203               0189      A214     edb.free          equ  edb.struct + 20 ; End of structure
0204               0190               *--------------------------------------------------------------
0205               0191               * Command buffer structure          @>a300-a3ff     (256 bytes)
0206               0192               *--------------------------------------------------------------
0207               0193      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0208               0194      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0209               0195      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0210               0196      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0211               0197      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0212               0198      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0213               0199      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0214               0200      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0215               0201      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0216               0202      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0217               0203      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0218               0204      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0219               0205      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0220               0206      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0221               0207      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0222               0208      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
0223               0209      A31E     cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
0224               0210      A320     cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
0225               0211      A322     cmdb.cmdlen       equ  cmdb.struct + 34; Length of current command (MSB byte!)
0226               0212      A323     cmdb.cmd          equ  cmdb.struct + 35; Current command (80 bytes max.)
0227               0213      A373     cmdb.free         equ  cmdb.struct +115; End of structure
0228               0214               *--------------------------------------------------------------
0229               0215               * File handle structure             @>a400-a4ff     (256 bytes)
0230               0216               *--------------------------------------------------------------
0231               0217      A400     fh.struct         equ  >a400           ; stevie file handling structures
0232               0218      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0233               0219      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0234               0220      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0235               0221      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0236               0222      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0237               0223      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0238               0224      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0239               0225      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0240               0226      A434     fh.counter        equ  fh.struct + 52  ; Counter used in stevie file operations
0241               0227      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0242               0228      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0243               0229      A43A     fh.sams.hipage    equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0244               0230      A43C     fh.fopmode        equ  fh.struct + 60  ; FOP (File Operation Mode)
0245               0231      A43E     fh.callback1      equ  fh.struct + 62  ; Pointer to callback function 1
0246               0232      A440     fh.callback2      equ  fh.struct + 64  ; Pointer to callback function 2
0247               0233      A442     fh.callback3      equ  fh.struct + 66  ; Pointer to callback function 3
0248               0234      A444     fh.callback4      equ  fh.struct + 68  ; Pointer to callback function 4
0249               0235      A446     fh.kilobytes.prev equ  fh.struct + 70  ; Kilobytes process (previous)
0250               0236      A448     fh.membuffer      equ  fh.struct + 72  ; 80 bytes file memory buffer
0251               0237      A498     fh.free           equ  fh.struct +152  ; End of structure
0252               0238      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0253               0239      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0254               0240               *--------------------------------------------------------------
0255               0241               * Index structure                   @>a500-a5ff     (256 bytes)
0256               0242               *--------------------------------------------------------------
0257               0243      A500     idx.struct        equ  >a500           ; stevie index structure
0258               0244      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0259               0245      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0260               0246      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0261               0247               *--------------------------------------------------------------
0262               0248               * Frame buffer                      @>a600-afff    (2560 bytes)
0263               0249               *--------------------------------------------------------------
0264               0250      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0265               0251      0960     fb.size           equ  80*30           ; Frame buffer size
0266               0252               *--------------------------------------------------------------
0267               0253               * Index                             @>b000-bfff    (4096 bytes)
0268               0254               *--------------------------------------------------------------
0269               0255      B000     idx.top           equ  >b000           ; Top of index
0270               0256      1000     idx.size          equ  4096            ; Index size
0271               0257               *--------------------------------------------------------------
0272               0258               * Editor buffer                     @>c000-cfff    (4096 bytes)
0273               0259               *--------------------------------------------------------------
0274               0260      C000     edb.top           equ  >c000           ; Editor buffer high memory
0275               0261      1000     edb.size          equ  4096            ; Editor buffer size
0276               0262               *--------------------------------------------------------------
0277               0263               * Command history buffer            @>d000-dfff    (4096 bytes)
0278               0264               *--------------------------------------------------------------
0279               0265      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0280               0266      1000     cmdb.size         equ  4096            ; Command buffer size
0281               0267               *--------------------------------------------------------------
0282               0268               * Heap                              @>e000-efff    (4096 bytes)
0283               0269               *--------------------------------------------------------------
0284               0270      E000     heap.top          equ  >e000           ; Top of heap
0285               0271               *--------------------------------------------------------------
0286               0272               * Scratchpad backup 1               @>f000-f0ff     (256 bytes)
0287               0273               * Scratchpad backup 2               @>f100-f1ff     (256 bytes)
0288               0274               *--------------------------------------------------------------
0289               0275      F000     cpu.scrpad.tgt    equ  >f000           ; Destination cpu.scrpad.backup/restore
0290               0276      F000     scrpad.backup1    equ  >f000           ; Backup GPL layout
0291               0277      F100     scrpad.backup2    equ  >f100           ; Backup spectra2 layout
0292               **** **** ****     > stevie_b0.asm.22608
0293               0012
0294               0013               ***************************************************************
0295               0014               * BANK 0 - Setup environment for Stevie
0296               0015               ********|*****|*********************|**************************
0297               0016                       aorg  >6000
0298               0017                       save  >6000,>7fff           ; Save bank 0 (1st bank)
0299               0018               *--------------------------------------------------------------
0300               0019               * Cartridge header
0301               0020               ********|*****|*********************|**************************
0302               0021 6000 AA01             byte  >aa,1,1,0,0,0
0303                    6002 0100
0304                    6004 0000
0305               0022 6006 6010             data  $+10
0306               0023 6008 0000             byte  0,0,0,0,0,0,0,0
0307                    600A 0000
0308                    600C 0000
0309                    600E 0000
0310               0024 6010 0000             data  0                     ; No more items following
0311               0025 6012 6030             data  kickstart.code1
0312               0026
0313               0028
0314               0029 6014 1353             byte  19
0315               0030 6015 ....             text  'STEVIE 200803-22608'
0316               0031                       even
0317               0032
0318               0040
0319               0041               *--------------------------------------------------------------
0320               0042               * Step 1: Switch to bank 0 (uniform code accross all banks)
0321               0043               ********|*****|*********************|**************************
0322               0044                       aorg  kickstart.code1       ; >6030
0323               0045 6030 04E0  34         clr   @>6000                ; Switch to bank 0
0324                    6032 6000
0325               0046
0326               0047               ***************************************************************
0327               0048               * Step 2: Copy SP2 library from ROM to >2000 - >2fff
0328               0049               ********|*****|*********************|**************************
0329               0050 6034 0200  20         li    r0,reloc.sp2          ; Start of code to relocate
0330                    6036 6074
0331               0051 6038 0201  20         li    r1,>2000
0332                    603A 2000
0333               0052 603C 0202  20         li    r2,512                ; Copy 4K (512 * 8 bytes)
0334                    603E 0200
0335               0053               kickstart.copy.sp2:
0336               0054 6040 CC70  46         mov   *r0+,*r1+
0337               0055 6042 CC70  46         mov   *r0+,*r1+
0338               0056 6044 CC70  46         mov   *r0+,*r1+
0339               0057 6046 CC70  46         mov   *r0+,*r1+
0340               0058 6048 0602  14         dec   r2
0341               0059 604A 16FA  14         jne   kickstart.copy.sp2
0342               0060
0343               0061               ***************************************************************
0344               0062               * Step 3: Copy Stevie resident modules from ROM to >3000 - >3fff
0345               0063               ********|*****|*********************|**************************
0346               0064 604C 0200  20         li    r0,reloc.stevie       ; Start of code to relocate
0347                    604E 7052
0348               0065 6050 0201  20         li    r1,>3000
0349                    6052 3000
0350               0066 6054 0202  20         li    r2,512                ; Copy 4K (512 * 8 bytes)
0351                    6056 0200
0352               0067               kickstart.copy.stevie:
0353               0068 6058 CC70  46         mov   *r0+,*r1+
0354               0069 605A CC70  46         mov   *r0+,*r1+
0355               0070 605C CC70  46         mov   *r0+,*r1+
0356               0071 605E CC70  46         mov   *r0+,*r1+
0357               0072 6060 0602  14         dec   r2
0358               0073 6062 16FA  14         jne   kickstart.copy.stevie
0359               0074
0360               0075               ***************************************************************
0361               0076               * Step 4: Start SP2 kernel (runs in low MEMEXP)
0362               0077               ********|*****|*********************|**************************
0363               0078 6064 0460  28         b     @runlib               ; Start spectra2 library
0364                    6066 2DEA
0365               0079                       ;------------------------------------------------------
0366               0080                       ; Assert. Should not get here! Crash and burn!
0367               0081                       ;------------------------------------------------------
0368               0082 6068 0200  20         li    r0,$                  ; Current location
0369                    606A 6068
0370               0083 606C C800  38         mov   r0,@>ffce             ; \ Save caller address
0371                    606E FFCE
0372               0084 6070 06A0  32         bl    @cpu.crash            ; / Crash and halt system
0373                    6072 2030
0374               0085
0375               0086               ***************************************************************
0376               0087               * Step 5: Handover from SP2 kernel to Stevie "main" in low MEMEXP
0377               0088               ********|*****|*********************|**************************
0378               0089                       ; "main" in low MEMEXP is automatically called by SP2 runlib.
0379               0090
0380               0091
0381               0092
0382               0093
0383               0094               ***************************************************************
0384               0095               * Code data: Relocated code SP2 >2000 - >2fff (4K maximum)
0385               0096               ********|*****|*********************|**************************
0386               0097               reloc.sp2:
0387               0098                       xorg >2000                  ; Relocate SP2 code to >2000
0388               0099                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
0389               **** **** ****     > runlib.asm
0390               0001               *******************************************************************************
0391               0002               *              ___  ____  ____  ___  ____  ____    __    ___
0392               0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \  v.2021
0393               0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0394               0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0395               0006               *
0396               0007               *                TMS9900 Monitor with Arcade Game support
0397               0008               *                                  for
0398               0009               *              the Texas Instruments TI-99/4A Home Computer
0399               0010               *
0400               0011               *                      2010-2020 by Filip Van Vooren
0401               0012               *
0402               0013               *              https://github.com/FilipVanVooren/spectra2.git
0403               0014               *******************************************************************************
0404               0015               * This file: runlib.a99
0405               0016               *******************************************************************************
0406               0017               * Use following equates to skip/exclude support modules and to control startup
0407               0018               * behaviour.
0408               0019               *
0409               0020               * == Memory
0410               0021               * skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
0411               0022               * skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
0412               0023               * skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
0413               0024               * skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
0414               0025               * skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
0415               0026               * skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
0416               0027               * skip_sams                 equ  1  ; Skip CPU support for SAMS memory expansion
0417               0028               *
0418               0029               * == VDP
0419               0030               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0420               0031               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0421               0032               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0422               0033               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0423               0034               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0424               0035               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0425               0036               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0426               0037               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0427               0038               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0428               0039               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0429               0040               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0430               0041               * skip_vdp_sprites          equ  1  ; Skip sprites support
0431               0042               * skip_vdp_cursor           equ  1  ; Skip cursor support
0432               0043               *
0433               0044               * == Sound & speech
0434               0045               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0435               0046               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0436               0047               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0437               0048               *
0438               0049               * ==  Keyboard
0439               0050               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0440               0051               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0441               0052               *
0442               0053               * == Utilities
0443               0054               * skip_random_generator     equ  1  ; Skip random generator functions
0444               0055               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0445               0056               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0446               0057               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0447               0058               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0448               0059               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0449               0060               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0450               0061               * skip_cpu_strings          equ  1  ; Skip string support utilities
0451               0062
0452               0063               * == Kernel/Multitasking
0453               0064               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0454               0065               * skip_mem_paging           equ  1  ; Skip support for memory paging
0455               0066               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0456               0067               *
0457               0068               * == Startup behaviour
0458               0069               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0459               0070               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0460               0071               *******************************************************************************
0461               0072
0462               0073               *//////////////////////////////////////////////////////////////
0463               0074               *                       RUNLIB SETUP
0464               0075               *//////////////////////////////////////////////////////////////
0465               0076
0466               0077                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
0467               **** **** ****     > equ_memsetup.asm
0468               0001               * FILE......: memsetup.asm
0469               0002               * Purpose...: Equates for spectra2 memory layout
0470               0003
0471               0004               ***************************************************************
0472               0005               * >8300 - >8341     Scratchpad memory layout (66 bytes)
0473               0006               ********|*****|*********************|**************************
0474               0007      8300     ws1     equ   >8300                 ; 32 - Primary workspace
0475               0008      8320     mcloop  equ   >8320                 ; 08 - Machine code for loop & speech
0476               0009      8328     wbase   equ   >8328                 ; 02 - PNT base address
0477               0010      832A     wyx     equ   >832a                 ; 02 - Cursor YX position
0478               0011      832C     wtitab  equ   >832c                 ; 02 - Timers: Address of timer table
0479               0012      832E     wtiusr  equ   >832e                 ; 02 - Timers: Address of user hook
0480               0013      8330     wtitmp  equ   >8330                 ; 02 - Timers: Internal use
0481               0014      8332     wvrtkb  equ   >8332                 ; 02 - Virtual keyboard flags
0482               0015      8334     wsdlst  equ   >8334                 ; 02 - Sound player: Tune address
0483               0016      8336     wsdtmp  equ   >8336                 ; 02 - Sound player: Temporary use
0484               0017      8338     wspeak  equ   >8338                 ; 02 - Speech player: Address of LPC data
0485               0018      833A     wcolmn  equ   >833a                 ; 02 - Screen size, columns per row
0486               0019      833C     waux1   equ   >833c                 ; 02 - Temporary storage 1
0487               0020      833E     waux2   equ   >833e                 ; 02 - Temporary storage 2
0488               0021      8340     waux3   equ   >8340                 ; 02 - Temporary storage 3
0489               0022               ***************************************************************
0490               0023      832A     by      equ   wyx                   ;      Cursor Y position
0491               0024      832B     bx      equ   wyx+1                 ;      Cursor X position
0492               0025      8322     mcsprd  equ   mcloop+2              ;      Speech read routine
0493               0026               ***************************************************************
0494               **** **** ****     > runlib.asm
0495               0078                       copy  "equ_registers.asm"        ; Equates runlib registers
0496               **** **** ****     > equ_registers.asm
0497               0001               * FILE......: registers.asm
0498               0002               * Purpose...: Equates for registers
0499               0003
0500               0004               ***************************************************************
0501               0005               * Register usage
0502               0006               * R0      **free not used**
0503               0007               * R1      **free not used**
0504               0008               * R2      Config register
0505               0009               * R3      Extended config register
0506               0010               * R4      Temporary register/variable tmp0
0507               0011               * R5      Temporary register/variable tmp1
0508               0012               * R6      Temporary register/variable tmp2
0509               0013               * R7      Temporary register/variable tmp3
0510               0014               * R8      Temporary register/variable tmp4
0511               0015               * R9      Stack pointer
0512               0016               * R10     Highest slot in use + Timer counter
0513               0017               * R11     Subroutine return address
0514               0018               * R12     CRU
0515               0019               * R13     Copy of VDP status byte and counter for sound player
0516               0020               * R14     Copy of VDP register #0 and VDP register #1 bytes
0517               0021               * R15     VDP read/write address
0518               0022               *--------------------------------------------------------------
0519               0023               * Special purpose registers
0520               0024               * R0      shift count
0521               0025               * R12     CRU
0522               0026               * R13     WS     - when using LWPI, BLWP, RTWP
0523               0027               * R14     PC     - when using LWPI, BLWP, RTWP
0524               0028               * R15     STATUS - when using LWPI, BLWP, RTWP
0525               0029               ***************************************************************
0526               0030               * Define registers
0527               0031               ********|*****|*********************|**************************
0528               0032      0000     r0      equ   0
0529               0033      0001     r1      equ   1
0530               0034      0002     r2      equ   2
0531               0035      0003     r3      equ   3
0532               0036      0004     r4      equ   4
0533               0037      0005     r5      equ   5
0534               0038      0006     r6      equ   6
0535               0039      0007     r7      equ   7
0536               0040      0008     r8      equ   8
0537               0041      0009     r9      equ   9
0538               0042      000A     r10     equ   10
0539               0043      000B     r11     equ   11
0540               0044      000C     r12     equ   12
0541               0045      000D     r13     equ   13
0542               0046      000E     r14     equ   14
0543               0047      000F     r15     equ   15
0544               0048               ***************************************************************
0545               0049               * Define register equates
0546               0050               ********|*****|*********************|**************************
0547               0051      0002     config  equ   r2                    ; Config register
0548               0052      0003     xconfig equ   r3                    ; Extended config register
0549               0053      0004     tmp0    equ   r4                    ; Temp register 0
0550               0054      0005     tmp1    equ   r5                    ; Temp register 1
0551               0055      0006     tmp2    equ   r6                    ; Temp register 2
0552               0056      0007     tmp3    equ   r7                    ; Temp register 3
0553               0057      0008     tmp4    equ   r8                    ; Temp register 4
0554               0058      0009     stack   equ   r9                    ; Stack pointer
0555               0059      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0556               0060      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0557               0061               ***************************************************************
0558               0062               * Define MSB/LSB equates for registers
0559               0063               ********|*****|*********************|**************************
0560               0064      8300     r0hb    equ   ws1                   ; HI byte R0
0561               0065      8301     r0lb    equ   ws1+1                 ; LO byte R0
0562               0066      8302     r1hb    equ   ws1+2                 ; HI byte R1
0563               0067      8303     r1lb    equ   ws1+3                 ; LO byte R1
0564               0068      8304     r2hb    equ   ws1+4                 ; HI byte R2
0565               0069      8305     r2lb    equ   ws1+5                 ; LO byte R2
0566               0070      8306     r3hb    equ   ws1+6                 ; HI byte R3
0567               0071      8307     r3lb    equ   ws1+7                 ; LO byte R3
0568               0072      8308     r4hb    equ   ws1+8                 ; HI byte R4
0569               0073      8309     r4lb    equ   ws1+9                 ; LO byte R4
0570               0074      830A     r5hb    equ   ws1+10                ; HI byte R5
0571               0075      830B     r5lb    equ   ws1+11                ; LO byte R5
0572               0076      830C     r6hb    equ   ws1+12                ; HI byte R6
0573               0077      830D     r6lb    equ   ws1+13                ; LO byte R6
0574               0078      830E     r7hb    equ   ws1+14                ; HI byte R7
0575               0079      830F     r7lb    equ   ws1+15                ; LO byte R7
0576               0080      8310     r8hb    equ   ws1+16                ; HI byte R8
0577               0081      8311     r8lb    equ   ws1+17                ; LO byte R8
0578               0082      8312     r9hb    equ   ws1+18                ; HI byte R9
0579               0083      8313     r9lb    equ   ws1+19                ; LO byte R9
0580               0084      8314     r10hb   equ   ws1+20                ; HI byte R10
0581               0085      8315     r10lb   equ   ws1+21                ; LO byte R10
0582               0086      8316     r11hb   equ   ws1+22                ; HI byte R11
0583               0087      8317     r11lb   equ   ws1+23                ; LO byte R11
0584               0088      8318     r12hb   equ   ws1+24                ; HI byte R12
0585               0089      8319     r12lb   equ   ws1+25                ; LO byte R12
0586               0090      831A     r13hb   equ   ws1+26                ; HI byte R13
0587               0091      831B     r13lb   equ   ws1+27                ; LO byte R13
0588               0092      831C     r14hb   equ   ws1+28                ; HI byte R14
0589               0093      831D     r14lb   equ   ws1+29                ; LO byte R14
0590               0094      831E     r15hb   equ   ws1+30                ; HI byte R15
0591               0095      831F     r15lb   equ   ws1+31                ; LO byte R15
0592               0096               ********|*****|*********************|**************************
0593               0097      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0594               0098      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0595               0099      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0596               0100      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0597               0101      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0598               0102      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0599               0103      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0600               0104      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0601               0105      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0602               0106      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0603               0107               ********|*****|*********************|**************************
0604               0108      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0605               0109      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0606               0110      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0607               0111      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0608               0112               ***************************************************************
0609               **** **** ****     > runlib.asm
0610               0079                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
0611               **** **** ****     > equ_portaddr.asm
0612               0001               * FILE......: portaddr.asm
0613               0002               * Purpose...: Equates for hardware port addresses
0614               0003
0615               0004               ***************************************************************
0616               0005               * Equates for VDP, GROM, SOUND, SPEECH ports
0617               0006               ********|*****|*********************|**************************
0618               0007      8400     sound   equ   >8400                 ; Sound generator address
0619               0008      8800     vdpr    equ   >8800                 ; VDP read data window address
0620               0009      8C00     vdpw    equ   >8c00                 ; VDP write data window address
0621               0010      8802     vdps    equ   >8802                 ; VDP status register
0622               0011      8C02     vdpa    equ   >8c02                 ; VDP address register
0623               0012      9C02     grmwa   equ   >9c02                 ; GROM set write address
0624               0013      9802     grmra   equ   >9802                 ; GROM set read address
0625               0014      9800     grmrd   equ   >9800                 ; GROM read byte
0626               0015      9C00     grmwd   equ   >9c00                 ; GROM write byte
0627               0016      9000     spchrd  equ   >9000                 ; Address of speech synth Read Data Register
0628               0017      9400     spchwt  equ   >9400                 ; Address of speech synth Write Data Register
0629               **** **** ****     > runlib.asm
0630               0080                       copy  "equ_param.asm"            ; Equates runlib parameters
0631               **** **** ****     > equ_param.asm
0632               0001               * FILE......: param.asm
0633               0002               * Purpose...: Equates used for subroutine parameters
0634               0003
0635               0004               ***************************************************************
0636               0005               * Subroutine parameter equates
0637               0006               ***************************************************************
0638               0007      FFFF     eol     equ   >ffff                 ; End-Of-List
0639               0008      FFFF     nofont  equ   >ffff                 ; Skip loading font in RUNLIB
0640               0009      0000     norep   equ   0                     ; PUTBOX > Value for P3. Don't repeat box
0641               0010      3030     num1    equ   >3030                 ; MKNUM  > ASCII 0-9, leading 0's
0642               0011      3020     num2    equ   >3020                 ; MKNUM  > ASCII 0-9, leading spaces
0643               0012      0007     sdopt1  equ   7                     ; SDPLAY > 111 (Player on, repeat, tune in CPU memory)
0644               0013      0005     sdopt2  equ   5                     ; SDPLAY > 101 (Player on, no repeat, tune in CPU memory)
0645               0014      0006     sdopt3  equ   6                     ; SDPLAY > 110 (Player on, repeat, tune in VRAM)
0646               0015      0004     sdopt4  equ   4                     ; SDPLAY > 100 (Player on, no repeat, tune in VRAM)
0647               0016      0000     fnopt1  equ   >0000                 ; LDFNT  > Load TI title screen font
0648               0017      0006     fnopt2  equ   >0006                 ; LDFNT  > Load upper case font
0649               0018      000C     fnopt3  equ   >000c                 ; LDFNT  > Load upper/lower case font
0650               0019      0012     fnopt4  equ   >0012                 ; LDFNT  > Load lower case font
0651               0020      8000     fnopt5  equ   >8000                 ; LDFNT  > Load TI title screen font  & bold
0652               0021      8006     fnopt6  equ   >8006                 ; LDFNT  > Load upper case font       & bold
0653               0022      800C     fnopt7  equ   >800c                 ; LDFNT  > Load upper/lower case font & bold
0654               0023      8012     fnopt8  equ   >8012                 ; LDFNT  > Load lower case font       & bold
0655               0024               *--------------------------------------------------------------
0656               0025               *   Speech player
0657               0026               *--------------------------------------------------------------
0658               0027      0060     talkon  equ   >60                   ; 'start talking' command code for speech synth
0659               0028      00FF     talkof  equ   >ff                   ; 'stop talking' command code for speech synth
0660               0029      6000     spkon   equ   >6000                 ; 'start talking' command code for speech synth
0661               0030      FF00     spkoff  equ   >ff00                 ; 'stop talking' command code for speech synth
0662               **** **** ****     > runlib.asm
0663               0081
0664               0083                       copy  "rom_bankswitch.asm"       ; Bank switch routine
0665               **** **** ****     > rom_bankswitch.asm
0666               0001               * FILE......: rom_bankswitch.asm
0667               0002               * Purpose...: ROM bankswitching Support module
0668               0003
0669               0004               *//////////////////////////////////////////////////////////////
0670               0005               *                   BANKSWITCHING FUNCTIONS
0671               0006               *//////////////////////////////////////////////////////////////
0672               0007
0673               0008               ***************************************************************
0674               0009               * SWBNK - Switch ROM bank
0675               0010               ***************************************************************
0676               0011               *  BL   @SWBNK
0677               0012               *  DATA P0,P1
0678               0013               *--------------------------------------------------------------
0679               0014               *  P0 = Bank selection address (>600X)
0680               0015               *  P1 = Vector address
0681               0016               *--------------------------------------------------------------
0682               0017               *  B    @SWBNKX
0683               0018               *
0684               0019               *  TMP0 = Bank selection address (>600X)
0685               0020               *  TMP1 = Vector address
0686               0021               *--------------------------------------------------------------
0687               0022               *  Important! The bank-switch routine must be at the exact
0688               0023               *  same location accross banks
0689               0024               ********|*****|*********************|**************************
0690               0025 6074 C13B  30 swbnk   mov   *r11+,tmp0
0691               0026 6076 C17B  30         mov   *r11+,tmp1
0692               0027 6078 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0693               0028 607A C155  26         mov   *tmp1,tmp1
0694               0029 607C 0455  20         b     *tmp1                 ; Switch to routine in TMP1
0695               **** **** ****     > runlib.asm
0696               0085
0697               0086                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
0698               **** **** ****     > cpu_constants.asm
0699               0001               * FILE......: cpu_constants.asm
0700               0002               * Purpose...: Constants used by Spectra2 and for own use
0701               0003
0702               0004               ***************************************************************
0703               0005               *                      Some constants
0704               0006               ********|*****|*********************|**************************
0705               0007
0706               0008               ---------------------------------------------------------------
0707               0009               * Word values
0708               0010               *--------------------------------------------------------------
0709               0011               ;                                   ;       0123456789ABCDEF
0710               0012 607E 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0711               0013 6080 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0712               0014 6082 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0713               0015 6084 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0714               0016 6086 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0715               0017 6088 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0716               0018 608A 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0717               0019 608C 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0718               0020 608E 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0719               0021 6090 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0720               0022 6092 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0721               0023 6094 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0722               0024 6096 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0723               0025 6098 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0724               0026 609A 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0725               0027 609C 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0726               0028 609E 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0727               0029 60A0 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0728               0030 60A2 D000     w$d000  data  >d000                 ; >d000
0729               0031               *--------------------------------------------------------------
0730               0032               * Byte values - High byte (=MSB) for byte operations
0731               0033               *--------------------------------------------------------------
0732               0034      200A     hb$00   equ   w$0000                ; >0000
0733               0035      201C     hb$01   equ   w$0100                ; >0100
0734               0036      201E     hb$02   equ   w$0200                ; >0200
0735               0037      2020     hb$04   equ   w$0400                ; >0400
0736               0038      2022     hb$08   equ   w$0800                ; >0800
0737               0039      2024     hb$10   equ   w$1000                ; >1000
0738               0040      2026     hb$20   equ   w$2000                ; >2000
0739               0041      2028     hb$40   equ   w$4000                ; >4000
0740               0042      202A     hb$80   equ   w$8000                ; >8000
0741               0043      202E     hb$d0   equ   w$d000                ; >d000
0742               0044               *--------------------------------------------------------------
0743               0045               * Byte values - Low byte (=LSB) for byte operations
0744               0046               *--------------------------------------------------------------
0745               0047      200A     lb$00   equ   w$0000                ; >0000
0746               0048      200C     lb$01   equ   w$0001                ; >0001
0747               0049      200E     lb$02   equ   w$0002                ; >0002
0748               0050      2010     lb$04   equ   w$0004                ; >0004
0749               0051      2012     lb$08   equ   w$0008                ; >0008
0750               0052      2014     lb$10   equ   w$0010                ; >0010
0751               0053      2016     lb$20   equ   w$0020                ; >0020
0752               0054      2018     lb$40   equ   w$0040                ; >0040
0753               0055      201A     lb$80   equ   w$0080                ; >0080
0754               0056               *--------------------------------------------------------------
0755               0057               * Bit values
0756               0058               *--------------------------------------------------------------
0757               0059               ;                                   ;       0123456789ABCDEF
0758               0060      200C     wbit15  equ   w$0001                ; >0001 0000000000000001
0759               0061      200E     wbit14  equ   w$0002                ; >0002 0000000000000010
0760               0062      2010     wbit13  equ   w$0004                ; >0004 0000000000000100
0761               0063      2012     wbit12  equ   w$0008                ; >0008 0000000000001000
0762               0064      2014     wbit11  equ   w$0010                ; >0010 0000000000010000
0763               0065      2016     wbit10  equ   w$0020                ; >0020 0000000000100000
0764               0066      2018     wbit9   equ   w$0040                ; >0040 0000000001000000
0765               0067      201A     wbit8   equ   w$0080                ; >0080 0000000010000000
0766               0068      201C     wbit7   equ   w$0100                ; >0100 0000000100000000
0767               0069      201E     wbit6   equ   w$0200                ; >0200 0000001000000000
0768               0070      2020     wbit5   equ   w$0400                ; >0400 0000010000000000
0769               0071      2022     wbit4   equ   w$0800                ; >0800 0000100000000000
0770               0072      2024     wbit3   equ   w$1000                ; >1000 0001000000000000
0771               0073      2026     wbit2   equ   w$2000                ; >2000 0010000000000000
0772               0074      2028     wbit1   equ   w$4000                ; >4000 0100000000000000
0773               0075      202A     wbit0   equ   w$8000                ; >8000 1000000000000000
0774               **** **** ****     > runlib.asm
0775               0087                       copy  "equ_config.asm"           ; Equates for bits in config register
0776               **** **** ****     > equ_config.asm
0777               0001               * FILE......: equ_config.asm
0778               0002               * Purpose...: Equates for bits in config register
0779               0003
0780               0004               ***************************************************************
0781               0005               * The config register equates
0782               0006               *--------------------------------------------------------------
0783               0007               * Configuration flags
0784               0008               * ===================
0785               0009               *
0786               0010               * ; 15  Sound player: tune source       1=ROM/RAM      0=VDP MEMORY
0787               0011               * ; 14  Sound player: repeat tune       1=yes          0=no
0788               0012               * ; 13  Sound player: enabled           1=yes          0=no (or pause)
0789               0013               * ; 12  VDP9918 sprite collision?       1=yes          0=no
0790               0014               * ; 11  Keyboard: ANY key pressed       1=yes          0=no
0791               0015               * ; 10  Keyboard: Alpha lock key down   1=yes          0=no
0792               0016               * ; 09  Timer: Kernel thread enabled    1=yes          0=no
0793               0017               * ; 08  Timer: Block kernel thread      1=yes          0=no
0794               0018               * ; 07  Timer: User hook enabled        1=yes          0=no
0795               0019               * ; 06  Timer: Block user hook          1=yes          0=no
0796               0020               * ; 05  Speech synthesizer present      1=yes          0=no
0797               0021               * ; 04  Speech player: busy             1=yes          0=no
0798               0022               * ; 03  Speech player: enabled          1=yes          0=no
0799               0023               * ; 02  VDP9918 PAL version             1=yes(50)      0=no(60)
0800               0024               * ; 01  F18A present                    1=on           0=off
0801               0025               * ; 00  Subroutine state flag           1=on           0=off
0802               0026               ********|*****|*********************|**************************
0803               0027      2026     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0804               0028      201C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0805               0029      2018     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0806               0030      2014     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0807               0031               ***************************************************************
0808               0032
0809               **** **** ****     > runlib.asm
0810               0088                       copy  "cpu_crash.asm"            ; CPU crash handler
0811               **** **** ****     > cpu_crash.asm
0812               0001               * FILE......: cpu_crash.asm
0813               0002               * Purpose...: Custom crash handler module
0814               0003
0815               0004
0816               0005               ***************************************************************
0817               0006               * cpu.crash - CPU program crashed handler
0818               0007               ***************************************************************
0819               0008               *  bl   @cpu.crash
0820               0009               *--------------------------------------------------------------
0821               0010               * Crash and halt system. Upon crash entry register contents are
0822               0011               * copied to the memory region >ffe0 - >fffe and displayed after
0823               0012               * resetting the spectra2 runtime library, video modes, etc.
0824               0013               *
0825               0014               * Diagnostics
0826               0015               * >ffce  caller address
0827               0016               *
0828               0017               * Register contents
0829               0018               * >ffdc  wp
0830               0019               * >ffde  st
0831               0020               * >ffe0  r0
0832               0021               * >ffe2  r1
0833               0022               * >ffe4  r2  (config)
0834               0023               * >ffe6  r3
0835               0024               * >ffe8  r4  (tmp0)
0836               0025               * >ffea  r5  (tmp1)
0837               0026               * >ffec  r6  (tmp2)
0838               0027               * >ffee  r7  (tmp3)
0839               0028               * >fff0  r8  (tmp4)
0840               0029               * >fff2  r9  (stack)
0841               0030               * >fff4  r10
0842               0031               * >fff6  r11
0843               0032               * >fff8  r12
0844               0033               * >fffa  r13
0845               0034               * >fffc  r14
0846               0035               * >fffe  r15
0847               0036               ********|*****|*********************|**************************
0848               0037               cpu.crash:
0849               0038 60A4 022B  22         ai    r11,-4                ; Remove opcode offset
0850                    60A6 FFFC
0851               0039               *--------------------------------------------------------------
0852               0040               *    Save registers to high memory
0853               0041               *--------------------------------------------------------------
0854               0042 60A8 C800  38         mov   r0,@>ffe0
0855                    60AA FFE0
0856               0043 60AC C801  38         mov   r1,@>ffe2
0857                    60AE FFE2
0858               0044 60B0 C802  38         mov   r2,@>ffe4
0859                    60B2 FFE4
0860               0045 60B4 C803  38         mov   r3,@>ffe6
0861                    60B6 FFE6
0862               0046 60B8 C804  38         mov   r4,@>ffe8
0863                    60BA FFE8
0864               0047 60BC C805  38         mov   r5,@>ffea
0865                    60BE FFEA
0866               0048 60C0 C806  38         mov   r6,@>ffec
0867                    60C2 FFEC
0868               0049 60C4 C807  38         mov   r7,@>ffee
0869                    60C6 FFEE
0870               0050 60C8 C808  38         mov   r8,@>fff0
0871                    60CA FFF0
0872               0051 60CC C809  38         mov   r9,@>fff2
0873                    60CE FFF2
0874               0052 60D0 C80A  38         mov   r10,@>fff4
0875                    60D2 FFF4
0876               0053 60D4 C80B  38         mov   r11,@>fff6
0877                    60D6 FFF6
0878               0054 60D8 C80C  38         mov   r12,@>fff8
0879                    60DA FFF8
0880               0055 60DC C80D  38         mov   r13,@>fffa
0881                    60DE FFFA
0882               0056 60E0 C80E  38         mov   r14,@>fffc
0883                    60E2 FFFC
0884               0057 60E4 C80F  38         mov   r15,@>ffff
0885                    60E6 FFFF
0886               0058 60E8 02A0  12         stwp  r0
0887               0059 60EA C800  38         mov   r0,@>ffdc
0888                    60EC FFDC
0889               0060 60EE 02C0  12         stst  r0
0890               0061 60F0 C800  38         mov   r0,@>ffde
0891                    60F2 FFDE
0892               0062               *--------------------------------------------------------------
0893               0063               *    Reset system
0894               0064               *--------------------------------------------------------------
0895               0065               cpu.crash.reset:
0896               0066 60F4 02E0  18         lwpi  ws1                   ; Activate workspace 1
0897                    60F6 8300
0898               0067 60F8 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
0899                    60FA 8302
0900               0068 60FC 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
0901                    60FE 4A4A
0902               0069 6100 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
0903                    6102 2DF2
0904               0070               *--------------------------------------------------------------
0905               0071               *    Show diagnostics after system reset
0906               0072               *--------------------------------------------------------------
0907               0073               cpu.crash.main:
0908               0074                       ;------------------------------------------------------
0909               0075                       ; Load "32x24" video mode & font
0910               0076                       ;------------------------------------------------------
0911               0077 6104 06A0  32         bl    @vidtab               ; Load video mode table into VDP
0912                    6106 22F2
0913               0078 6108 21F2                   data graph1           ; Equate selected video mode table
0914               0079
0915               0080 610A 06A0  32         bl    @ldfnt
0916                    610C 235A
0917               0081 610E 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
0918                    6110 000C
0919               0082
0920               0083 6112 06A0  32         bl    @filv
0921                    6114 2288
0922               0084 6116 0380                   data >0380,>f0,32*24  ; Load color table
0923                    6118 00F0
0924                    611A 0300
0925               0085                       ;------------------------------------------------------
0926               0086                       ; Show crash details
0927               0087                       ;------------------------------------------------------
0928               0088 611C 06A0  32         bl    @putat                ; Show crash message
0929                    611E 243C
0930               0089 6120 0000                   data >0000,cpu.crash.msg.crashed
0931                    6122 2182
0932               0090
0933               0091 6124 06A0  32         bl    @puthex               ; Put hex value on screen
0934                    6126 2978
0935               0092 6128 0015                   byte 0,21             ; \ i  p0 = YX position
0936               0093 612A FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0937               0094 612C 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0938               0095 612E 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0939               0096                                                   ; /         LSB offset for ASCII digit 0-9
0940               0097                       ;------------------------------------------------------
0941               0098                       ; Show caller details
0942               0099                       ;------------------------------------------------------
0943               0100 6130 06A0  32         bl    @putat                ; Show caller message
0944                    6132 243C
0945               0101 6134 0100                   data >0100,cpu.crash.msg.caller
0946                    6136 2198
0947               0102
0948               0103 6138 06A0  32         bl    @puthex               ; Put hex value on screen
0949                    613A 2978
0950               0104 613C 0115                   byte 1,21             ; \ i  p0 = YX position
0951               0105 613E FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0952               0106 6140 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0953               0107 6142 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0954               0108                                                   ; /         LSB offset for ASCII digit 0-9
0955               0109                       ;------------------------------------------------------
0956               0110                       ; Display labels
0957               0111                       ;------------------------------------------------------
0958               0112 6144 06A0  32         bl    @putat
0959                    6146 243C
0960               0113 6148 0300                   byte 3,0
0961               0114 614A 21B2                   data cpu.crash.msg.wp
0962               0115 614C 06A0  32         bl    @putat
0963                    614E 243C
0964               0116 6150 0400                   byte 4,0
0965               0117 6152 21B8                   data cpu.crash.msg.st
0966               0118 6154 06A0  32         bl    @putat
0967                    6156 243C
0968               0119 6158 1600                   byte 22,0
0969               0120 615A 21BE                   data cpu.crash.msg.source
0970               0121 615C 06A0  32         bl    @putat
0971                    615E 243C
0972               0122 6160 1700                   byte 23,0
0973               0123 6162 21DA                   data cpu.crash.msg.id
0974               0124                       ;------------------------------------------------------
0975               0125                       ; Show crash registers WP, ST, R0 - R15
0976               0126                       ;------------------------------------------------------
0977               0127 6164 06A0  32         bl    @at                   ; Put cursor at YX
0978                    6166 2680
0979               0128 6168 0304                   byte 3,4              ; \ i p0 = YX position
0980               0129                                                   ; /
0981               0130
0982               0131 616A 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
0983                    616C FFDC
0984               0132 616E 04C6  14         clr   tmp2                  ; Loop counter
0985               0133
0986               0134               cpu.crash.showreg:
0987               0135 6170 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0988               0136
0989               0137 6172 0649  14         dect  stack
0990               0138 6174 C644  30         mov   tmp0,*stack           ; Push tmp0
0991               0139 6176 0649  14         dect  stack
0992               0140 6178 C645  30         mov   tmp1,*stack           ; Push tmp1
0993               0141 617A 0649  14         dect  stack
0994               0142 617C C646  30         mov   tmp2,*stack           ; Push tmp2
0995               0143                       ;------------------------------------------------------
0996               0144                       ; Display crash register number
0997               0145                       ;------------------------------------------------------
0998               0146               cpu.crash.showreg.label:
0999               0147 617E C046  18         mov   tmp2,r1               ; Save register number
1000               0148 6180 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
1001                    6182 0001
1002               0149 6184 121C  14         jle   cpu.crash.showreg.content
1003               0150                                                   ; Yes, skip
1004               0151
1005               0152 6186 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
1006               0153 6188 06A0  32         bl    @mknum
1007                    618A 2982
1008               0154 618C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
1009               0155 618E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
1010               0156 6190 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
1011               0157                                                   ; /         LSB offset for ASCII digit 0-9
1012               0158
1013               0159 6192 06A0  32         bl    @setx                 ; Set cursor X position
1014                    6194 2696
1015               0160 6196 0000                   data 0                ; \ i  p0 =  Cursor Y position
1016               0161                                                   ; /
1017               0162
1018               0163 6198 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
1019                    619A 2418
1020               0164 619C 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
1021               0165                                                   ; /
1022               0166
1023               0167 619E 06A0  32         bl    @setx                 ; Set cursor X position
1024                    61A0 2696
1025               0168 61A2 0002                   data 2                ; \ i  p0 =  Cursor Y position
1026               0169                                                   ; /
1027               0170
1028               0171 61A4 0281  22         ci    r1,10
1029                    61A6 000A
1030               0172 61A8 1102  14         jlt   !
1031               0173 61AA 0620  34         dec   @wyx                  ; x=x-1
1032                    61AC 832A
1033               0174
1034               0175 61AE 06A0  32 !       bl    @putstr
1035                    61B0 2418
1036               0176 61B2 21AE                   data cpu.crash.msg.r
1037               0177
1038               0178 61B4 06A0  32         bl    @mknum
1039                    61B6 2982
1040               0179 61B8 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
1041               0180 61BA 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
1042               0181 61BC 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
1043               0182                                                   ; /         LSB offset for ASCII digit 0-9
1044               0183                       ;------------------------------------------------------
1045               0184                       ; Display crash register content
1046               0185                       ;------------------------------------------------------
1047               0186               cpu.crash.showreg.content:
1048               0187 61BE 06A0  32         bl    @mkhex                ; Convert hex word to string
1049                    61C0 28F4
1050               0188 61C2 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
1051               0189 61C4 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
1052               0190 61C6 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
1053               0191                                                   ; /         LSB offset for ASCII digit 0-9
1054               0192
1055               0193 61C8 06A0  32         bl    @setx                 ; Set cursor X position
1056                    61CA 2696
1057               0194 61CC 0006                   data 6                ; \ i  p0 =  Cursor Y position
1058               0195                                                   ; /
1059               0196
1060               0197 61CE 06A0  32         bl    @putstr
1061                    61D0 2418
1062               0198 61D2 21B0                   data cpu.crash.msg.marker
1063               0199
1064               0200 61D4 06A0  32         bl    @setx                 ; Set cursor X position
1065                    61D6 2696
1066               0201 61D8 0007                   data 7                ; \ i  p0 =  Cursor Y position
1067               0202                                                   ; /
1068               0203
1069               0204 61DA 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
1070                    61DC 2418
1071               0205 61DE 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
1072               0206                                                   ; /
1073               0207
1074               0208 61E0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
1075               0209 61E2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
1076               0210 61E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
1077               0211
1078               0212 61E6 06A0  32         bl    @down                 ; y=y+1
1079                    61E8 2686
1080               0213
1081               0214 61EA 0586  14         inc   tmp2
1082               0215 61EC 0286  22         ci    tmp2,17
1083                    61EE 0011
1084               0216 61F0 12BF  14         jle   cpu.crash.showreg     ; Show next register
1085               0217                       ;------------------------------------------------------
1086               0218                       ; Kernel takes over
1087               0219                       ;------------------------------------------------------
1088               0220 61F2 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
1089                    61F4 2CEC
1090               0221
1091               0222
1092               0223               cpu.crash.msg.crashed
1093               0224 61F6 1553             byte  21
1094               0225 61F7 ....             text  'System crashed near >'
1095               0226                       even
1096               0227
1097               0228               cpu.crash.msg.caller
1098               0229 620C 1543             byte  21
1099               0230 620D ....             text  'Caller address near >'
1100               0231                       even
1101               0232
1102               0233               cpu.crash.msg.r
1103               0234 6222 0152             byte  1
1104               0235 6223 ....             text  'R'
1105               0236                       even
1106               0237
1107               0238               cpu.crash.msg.marker
1108               0239 6224 013E             byte  1
1109               0240 6225 ....             text  '>'
1110               0241                       even
1111               0242
1112               0243               cpu.crash.msg.wp
1113               0244 6226 042A             byte  4
1114               0245 6227 ....             text  '**WP'
1115               0246                       even
1116               0247
1117               0248               cpu.crash.msg.st
1118               0249 622C 042A             byte  4
1119               0250 622D ....             text  '**ST'
1120               0251                       even
1121               0252
1122               0253               cpu.crash.msg.source
1123               0254 6232 1B53             byte  27
1124               0255 6233 ....             text  'Source    stevie_b0.lst.asm'
1125               0256                       even
1126               0257
1127               0258               cpu.crash.msg.id
1128               0259 624E 1642             byte  22
1129               0260 624F ....             text  'Build-ID  200803-22608'
1130               0261                       even
1131               0262
1132               **** **** ****     > runlib.asm
1133               0089                       copy  "vdp_tables.asm"           ; Data used by runtime library
1134               **** **** ****     > vdp_tables.asm
1135               0001               * FILE......: vdp_tables.a99
1136               0002               * Purpose...: Video mode tables
1137               0003
1138               0004               ***************************************************************
1139               0005               * Graphics mode 1 (32 columns/24 rows)
1140               0006               *--------------------------------------------------------------
1141               0007 6266 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
1142                    6268 000E
1143                    626A 0106
1144                    626C 0204
1145                    626E 0020
1146               0008               *
1147               0009               * ; VDP#0 Control bits
1148               0010               * ;      bit 6=0: M3 | Graphics 1 mode
1149               0011               * ;      bit 7=0: Disable external VDP input
1150               0012               * ; VDP#1 Control bits
1151               0013               * ;      bit 0=1: 16K selection
1152               0014               * ;      bit 1=1: Enable display
1153               0015               * ;      bit 2=1: Enable VDP interrupt
1154               0016               * ;      bit 3=0: M1 \ Graphics 1 mode
1155               0017               * ;      bit 4=0: M2 /
1156               0018               * ;      bit 5=0: reserved
1157               0019               * ;      bit 6=1: 16x16 sprites
1158               0020               * ;      bit 7=0: Sprite magnification (1x)
1159               0021               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1160               0022               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
1161               0023               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
1162               0024               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
1163               0025               * ; VDP#6 SPT (Sprite pattern table)     at >1000  (>02 * >800)
1164               0026               * ; VDP#7 Set screen background color
1165               0027
1166               0028
1167               0029               ***************************************************************
1168               0030               * Textmode (40 columns/24 rows)
1169               0031               *--------------------------------------------------------------
1170               0032 6270 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
1171                    6272 000E
1172                    6274 0106
1173                    6276 00F4
1174                    6278 0028
1175               0033               *
1176               0034               * ; VDP#0 Control bits
1177               0035               * ;      bit 6=0: M3 | Graphics 1 mode
1178               0036               * ;      bit 7=0: Disable external VDP input
1179               0037               * ; VDP#1 Control bits
1180               0038               * ;      bit 0=1: 16K selection
1181               0039               * ;      bit 1=1: Enable display
1182               0040               * ;      bit 2=1: Enable VDP interrupt
1183               0041               * ;      bit 3=1: M1 \ TEXT MODE
1184               0042               * ;      bit 4=0: M2 /
1185               0043               * ;      bit 5=0: reserved
1186               0044               * ;      bit 6=1: 16x16 sprites
1187               0045               * ;      bit 7=0: Sprite magnification (1x)
1188               0046               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1189               0047               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
1190               0048               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
1191               0049               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
1192               0050               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
1193               0051               * ; VDP#7 Set foreground/background color
1194               0052               ***************************************************************
1195               0053
1196               0054
1197               0055               ***************************************************************
1198               0056               * Textmode (80 columns, 24 rows) - F18A
1199               0057               *--------------------------------------------------------------
1200               0058 627A 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
1201                    627C 003F
1202                    627E 0240
1203                    6280 03F4
1204                    6282 0050
1205               0059               *
1206               0060               * ; VDP#0 Control bits
1207               0061               * ;      bit 6=0: M3 | Graphics 1 mode
1208               0062               * ;      bit 7=0: Disable external VDP input
1209               0063               * ; VDP#1 Control bits
1210               0064               * ;      bit 0=1: 16K selection
1211               0065               * ;      bit 1=1: Enable display
1212               0066               * ;      bit 2=1: Enable VDP interrupt
1213               0067               * ;      bit 3=1: M1 \ TEXT MODE
1214               0068               * ;      bit 4=0: M2 /
1215               0069               * ;      bit 5=0: reserved
1216               0070               * ;      bit 6=0: 8x8 sprites
1217               0071               * ;      bit 7=0: Sprite magnification (1x)
1218               0072               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1219               0073               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
1220               0074               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
1221               0075               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
1222               0076               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
1223               0077               * ; VDP#7 Set foreground/background color
1224               0078               ***************************************************************
1225               0079
1226               0080
1227               0081               ***************************************************************
1228               0082               * Textmode (80 columns, 30 rows) - F18A
1229               0083               *--------------------------------------------------------------
1230               0084 6284 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
1231                    6286 003F
1232                    6288 0240
1233                    628A 03F4
1234                    628C 0050
1235               0085               *
1236               0086               * ; VDP#0 Control bits
1237               0087               * ;      bit 6=0: M3 | Graphics 1 mode
1238               0088               * ;      bit 7=0: Disable external VDP input
1239               0089               * ; VDP#1 Control bits
1240               0090               * ;      bit 0=1: 16K selection
1241               0091               * ;      bit 1=1: Enable display
1242               0092               * ;      bit 2=1: Enable VDP interrupt
1243               0093               * ;      bit 3=1: M1 \ TEXT MODE
1244               0094               * ;      bit 4=0: M2 /
1245               0095               * ;      bit 5=0: reserved
1246               0096               * ;      bit 6=0: 8x8 sprites
1247               0097               * ;      bit 7=0: Sprite magnification (1x)
1248               0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
1249               0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
1250               0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
1251               0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
1252               0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
1253               0103               * ; VDP#7 Set foreground/background color
1254               0104               ***************************************************************
1255               **** **** ****     > runlib.asm
1256               0090                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
1257               **** **** ****     > basic_cpu_vdp.asm
1258               0001               * FILE......: basic_cpu_vdp.asm
1259               0002               * Purpose...: Basic CPU & VDP functions used by other modules
1260               0003
1261               0004               *//////////////////////////////////////////////////////////////
1262               0005               *       Support Machine Code for copy & fill functions
1263               0006               *//////////////////////////////////////////////////////////////
1264               0007
1265               0008               *--------------------------------------------------------------
1266               0009               * ; Machine code for tight loop.
1267               0010               * ; The MOV operation at MCLOOP must be injected by the calling routine.
1268               0011               *--------------------------------------------------------------
1269               0012               *       DATA  >????                 ; \ mcloop  mov   ...
1270               0013 628E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
1271               0014 6290 16FD             data  >16fd                 ; |         jne   mcloop
1272               0015 6292 045B             data  >045b                 ; /         b     *r11
1273               0016               *--------------------------------------------------------------
1274               0017               * ; Machine code for reading from the speech synthesizer
1275               0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
1276               0019               * ; Is required for the 12 uS delay. It destroys R5.
1277               0020               *--------------------------------------------------------------
1278               0021 6294 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
1279               0022 6296 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
1280               0023                       even
1281               0024
1282               0025
1283               0026               *//////////////////////////////////////////////////////////////
1284               0027               *                    STACK SUPPORT FUNCTIONS
1285               0028               *//////////////////////////////////////////////////////////////
1286               0029
1287               0030               ***************************************************************
1288               0031               * POPR. - Pop registers & return to caller
1289               0032               ***************************************************************
1290               0033               *  B  @POPRG.
1291               0034               *--------------------------------------------------------------
1292               0035               *  REMARKS
1293               0036               *  R11 must be at stack bottom
1294               0037               ********|*****|*********************|**************************
1295               0038 6298 C0F9  30 popr3   mov   *stack+,r3
1296               0039 629A C0B9  30 popr2   mov   *stack+,r2
1297               0040 629C C079  30 popr1   mov   *stack+,r1
1298               0041 629E C039  30 popr0   mov   *stack+,r0
1299               0042 62A0 C2F9  30 poprt   mov   *stack+,r11
1300               0043 62A2 045B  20         b     *r11
1301               0044
1302               0045
1303               0046
1304               0047               *//////////////////////////////////////////////////////////////
1305               0048               *                   MEMORY FILL FUNCTIONS
1306               0049               *//////////////////////////////////////////////////////////////
1307               0050
1308               0051               ***************************************************************
1309               0052               * FILM - Fill CPU memory with byte
1310               0053               ***************************************************************
1311               0054               *  bl   @film
1312               0055               *  data P0,P1,P2
1313               0056               *--------------------------------------------------------------
1314               0057               *  P0 = Memory start address
1315               0058               *  P1 = Byte to fill
1316               0059               *  P2 = Number of bytes to fill
1317               0060               *--------------------------------------------------------------
1318               0061               *  bl   @xfilm
1319               0062               *
1320               0063               *  TMP0 = Memory start address
1321               0064               *  TMP1 = Byte to fill
1322               0065               *  TMP2 = Number of bytes to fill
1323               0066               ********|*****|*********************|**************************
1324               0067 62A4 C13B  30 film    mov   *r11+,tmp0            ; Memory start
1325               0068 62A6 C17B  30         mov   *r11+,tmp1            ; Byte to fill
1326               0069 62A8 C1BB  30         mov   *r11+,tmp2            ; Repeat count
1327               0070               *--------------------------------------------------------------
1328               0071               * Do some checks first
1329               0072               *--------------------------------------------------------------
1330               0073 62AA C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
1331               0074 62AC 1604  14         jne   filchk                ; No, continue checking
1332               0075
1333               0076 62AE C80B  38         mov   r11,@>ffce            ; \ Save caller address
1334                    62B0 FFCE
1335               0077 62B2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1336                    62B4 2030
1337               0078               *--------------------------------------------------------------
1338               0079               *       Check: 1 byte fill
1339               0080               *--------------------------------------------------------------
1340               0081 62B6 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
1341                    62B8 830B
1342                    62BA 830A
1343               0082
1344               0083 62BC 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
1345                    62BE 0001
1346               0084 62C0 1602  14         jne   filchk2
1347               0085 62C2 DD05  32         movb  tmp1,*tmp0+
1348               0086 62C4 045B  20         b     *r11                  ; Exit
1349               0087               *--------------------------------------------------------------
1350               0088               *       Check: 2 byte fill
1351               0089               *--------------------------------------------------------------
1352               0090 62C6 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
1353                    62C8 0002
1354               0091 62CA 1603  14         jne   filchk3
1355               0092 62CC DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
1356               0093 62CE DD05  32         movb  tmp1,*tmp0+
1357               0094 62D0 045B  20         b     *r11                  ; Exit
1358               0095               *--------------------------------------------------------------
1359               0096               *       Check: Handle uneven start address
1360               0097               *--------------------------------------------------------------
1361               0098 62D2 C1C4  18 filchk3 mov   tmp0,tmp3
1362               0099 62D4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1363                    62D6 0001
1364               0100 62D8 1605  14         jne   fil16b
1365               0101 62DA DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
1366               0102 62DC 0606  14         dec   tmp2
1367               0103 62DE 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
1368                    62E0 0002
1369               0104 62E2 13F1  14         jeq   filchk2               ; Yes, copy word and exit
1370               0105               *--------------------------------------------------------------
1371               0106               *       Fill memory with 16 bit words
1372               0107               *--------------------------------------------------------------
1373               0108 62E4 C1C6  18 fil16b  mov   tmp2,tmp3
1374               0109 62E6 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1375                    62E8 0001
1376               0110 62EA 1301  14         jeq   dofill
1377               0111 62EC 0606  14         dec   tmp2                  ; Make TMP2 even
1378               0112 62EE CD05  34 dofill  mov   tmp1,*tmp0+
1379               0113 62F0 0646  14         dect  tmp2
1380               0114 62F2 16FD  14         jne   dofill
1381               0115               *--------------------------------------------------------------
1382               0116               * Fill last byte if ODD
1383               0117               *--------------------------------------------------------------
1384               0118 62F4 C1C7  18         mov   tmp3,tmp3
1385               0119 62F6 1301  14         jeq   fil.$$
1386               0120 62F8 DD05  32         movb  tmp1,*tmp0+
1387               0121 62FA 045B  20 fil.$$  b     *r11
1388               0122
1389               0123
1390               0124               ***************************************************************
1391               0125               * FILV - Fill VRAM with byte
1392               0126               ***************************************************************
1393               0127               *  BL   @FILV
1394               0128               *  DATA P0,P1,P2
1395               0129               *--------------------------------------------------------------
1396               0130               *  P0 = VDP start address
1397               0131               *  P1 = Byte to fill
1398               0132               *  P2 = Number of bytes to fill
1399               0133               *--------------------------------------------------------------
1400               0134               *  BL   @XFILV
1401               0135               *
1402               0136               *  TMP0 = VDP start address
1403               0137               *  TMP1 = Byte to fill
1404               0138               *  TMP2 = Number of bytes to fill
1405               0139               ********|*****|*********************|**************************
1406               0140 62FC C13B  30 filv    mov   *r11+,tmp0            ; Memory start
1407               0141 62FE C17B  30         mov   *r11+,tmp1            ; Byte to fill
1408               0142 6300 C1BB  30         mov   *r11+,tmp2            ; Repeat count
1409               0143               *--------------------------------------------------------------
1410               0144               *    Setup VDP write address
1411               0145               *--------------------------------------------------------------
1412               0146 6302 0264  22 xfilv   ori   tmp0,>4000
1413                    6304 4000
1414               0147 6306 06C4  14         swpb  tmp0
1415               0148 6308 D804  38         movb  tmp0,@vdpa
1416                    630A 8C02
1417               0149 630C 06C4  14         swpb  tmp0
1418               0150 630E D804  38         movb  tmp0,@vdpa
1419                    6310 8C02
1420               0151               *--------------------------------------------------------------
1421               0152               *    Fill bytes in VDP memory
1422               0153               *--------------------------------------------------------------
1423               0154 6312 020F  20         li    r15,vdpw              ; Set VDP write address
1424                    6314 8C00
1425               0155 6316 06C5  14         swpb  tmp1
1426               0156 6318 C820  54         mov   @filzz,@mcloop        ; Setup move command
1427                    631A 22AE
1428                    631C 8320
1429               0157 631E 0460  28         b     @mcloop               ; Write data to VDP
1430                    6320 8320
1431               0158               *--------------------------------------------------------------
1432               0162 6322 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
1433               0164
1434               0165
1435               0166
1436               0167               *//////////////////////////////////////////////////////////////
1437               0168               *                  VDP LOW LEVEL FUNCTIONS
1438               0169               *//////////////////////////////////////////////////////////////
1439               0170
1440               0171               ***************************************************************
1441               0172               * VDWA / VDRA - Setup VDP write or read address
1442               0173               ***************************************************************
1443               0174               *  BL   @VDWA
1444               0175               *
1445               0176               *  TMP0 = VDP destination address for write
1446               0177               *--------------------------------------------------------------
1447               0178               *  BL   @VDRA
1448               0179               *
1449               0180               *  TMP0 = VDP source address for read
1450               0181               ********|*****|*********************|**************************
1451               0182 6324 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
1452                    6326 4000
1453               0183 6328 06C4  14 vdra    swpb  tmp0
1454               0184 632A D804  38         movb  tmp0,@vdpa
1455                    632C 8C02
1456               0185 632E 06C4  14         swpb  tmp0
1457               0186 6330 D804  38         movb  tmp0,@vdpa            ; Set VDP address
1458                    6332 8C02
1459               0187 6334 045B  20         b     *r11                  ; Exit
1460               0188
1461               0189               ***************************************************************
1462               0190               * VPUTB - VDP put single byte
1463               0191               ***************************************************************
1464               0192               *  BL @VPUTB
1465               0193               *  DATA P0,P1
1466               0194               *--------------------------------------------------------------
1467               0195               *  P0 = VDP target address
1468               0196               *  P1 = Byte to write
1469               0197               ********|*****|*********************|**************************
1470               0198 6336 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
1471               0199 6338 C17B  30         mov   *r11+,tmp1            ; Get byte to write
1472               0200               *--------------------------------------------------------------
1473               0201               * Set VDP write address
1474               0202               *--------------------------------------------------------------
1475               0203 633A 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
1476                    633C 4000
1477               0204 633E 06C4  14         swpb  tmp0                  ; \
1478               0205 6340 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
1479                    6342 8C02
1480               0206 6344 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
1481               0207 6346 D804  38         movb  tmp0,@vdpa            ; /
1482                    6348 8C02
1483               0208               *--------------------------------------------------------------
1484               0209               * Write byte
1485               0210               *--------------------------------------------------------------
1486               0211 634A 06C5  14         swpb  tmp1                  ; LSB to MSB
1487               0212 634C D7C5  30         movb  tmp1,*r15             ; Write byte
1488               0213 634E 045B  20         b     *r11                  ; Exit
1489               0214
1490               0215
1491               0216               ***************************************************************
1492               0217               * VGETB - VDP get single byte
1493               0218               ***************************************************************
1494               0219               *  bl   @vgetb
1495               0220               *  data p0
1496               0221               *--------------------------------------------------------------
1497               0222               *  P0 = VDP source address
1498               0223               *--------------------------------------------------------------
1499               0224               *  bl   @xvgetb
1500               0225               *
1501               0226               *  tmp0 = VDP source address
1502               0227               *--------------------------------------------------------------
1503               0228               *  Output:
1504               0229               *  tmp0 MSB = >00
1505               0230               *  tmp0 LSB = VDP byte read
1506               0231               ********|*****|*********************|**************************
1507               0232 6350 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
1508               0233               *--------------------------------------------------------------
1509               0234               * Set VDP read address
1510               0235               *--------------------------------------------------------------
1511               0236 6352 06C4  14 xvgetb  swpb  tmp0                  ; \
1512               0237 6354 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
1513                    6356 8C02
1514               0238 6358 06C4  14         swpb  tmp0                  ; | inlined @vdra call
1515               0239 635A D804  38         movb  tmp0,@vdpa            ; /
1516                    635C 8C02
1517               0240               *--------------------------------------------------------------
1518               0241               * Read byte
1519               0242               *--------------------------------------------------------------
1520               0243 635E D120  34         movb  @vdpr,tmp0            ; Read byte
1521                    6360 8800
1522               0244 6362 0984  56         srl   tmp0,8                ; Right align
1523               0245 6364 045B  20         b     *r11                  ; Exit
1524               0246
1525               0247
1526               0248               ***************************************************************
1527               0249               * VIDTAB - Dump videomode table
1528               0250               ***************************************************************
1529               0251               *  BL   @VIDTAB
1530               0252               *  DATA P0
1531               0253               *--------------------------------------------------------------
1532               0254               *  P0 = Address of video mode table
1533               0255               *--------------------------------------------------------------
1534               0256               *  BL   @XIDTAB
1535               0257               *
1536               0258               *  TMP0 = Address of video mode table
1537               0259               *--------------------------------------------------------------
1538               0260               *  Remarks
1539               0261               *  TMP1 = MSB is the VDP target register
1540               0262               *         LSB is the value to write
1541               0263               ********|*****|*********************|**************************
1542               0264 6366 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
1543               0265 6368 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
1544               0266               *--------------------------------------------------------------
1545               0267               * Calculate PNT base address
1546               0268               *--------------------------------------------------------------
1547               0269 636A C144  18         mov   tmp0,tmp1
1548               0270 636C 05C5  14         inct  tmp1
1549               0271 636E D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
1550               0272 6370 0245  22         andi  tmp1,>ff00            ; Only keep MSB
1551                    6372 FF00
1552               0273 6374 0A25  56         sla   tmp1,2                ; TMP1 *= 400
1553               0274 6376 C805  38         mov   tmp1,@wbase           ; Store calculated base
1554                    6378 8328
1555               0275               *--------------------------------------------------------------
1556               0276               * Dump VDP shadow registers
1557               0277               *--------------------------------------------------------------
1558               0278 637A 0205  20         li    tmp1,>8000            ; Start with VDP register 0
1559                    637C 8000
1560               0279 637E 0206  20         li    tmp2,8
1561                    6380 0008
1562               0280 6382 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
1563                    6384 830B
1564               0281 6386 06C5  14         swpb  tmp1
1565               0282 6388 D805  38         movb  tmp1,@vdpa
1566                    638A 8C02
1567               0283 638C 06C5  14         swpb  tmp1
1568               0284 638E D805  38         movb  tmp1,@vdpa
1569                    6390 8C02
1570               0285 6392 0225  22         ai    tmp1,>0100
1571                    6394 0100
1572               0286 6396 0606  14         dec   tmp2
1573               0287 6398 16F4  14         jne   vidta1                ; Next register
1574               0288 639A C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
1575                    639C 833A
1576               0289 639E 045B  20         b     *r11
1577               0290
1578               0291
1579               0292               ***************************************************************
1580               0293               * PUTVR  - Put single VDP register
1581               0294               ***************************************************************
1582               0295               *  BL   @PUTVR
1583               0296               *  DATA P0
1584               0297               *--------------------------------------------------------------
1585               0298               *  P0 = MSB is the VDP target register
1586               0299               *       LSB is the value to write
1587               0300               *--------------------------------------------------------------
1588               0301               *  BL   @PUTVRX
1589               0302               *
1590               0303               *  TMP0 = MSB is the VDP target register
1591               0304               *         LSB is the value to write
1592               0305               ********|*****|*********************|**************************
1593               0306 63A0 C13B  30 putvr   mov   *r11+,tmp0
1594               0307 63A2 0264  22 putvrx  ori   tmp0,>8000
1595                    63A4 8000
1596               0308 63A6 06C4  14         swpb  tmp0
1597               0309 63A8 D804  38         movb  tmp0,@vdpa
1598                    63AA 8C02
1599               0310 63AC 06C4  14         swpb  tmp0
1600               0311 63AE D804  38         movb  tmp0,@vdpa
1601                    63B0 8C02
1602               0312 63B2 045B  20         b     *r11
1603               0313
1604               0314
1605               0315               ***************************************************************
1606               0316               * PUTV01  - Put VDP registers #0 and #1
1607               0317               ***************************************************************
1608               0318               *  BL   @PUTV01
1609               0319               ********|*****|*********************|**************************
1610               0320 63B4 C20B  18 putv01  mov   r11,tmp4              ; Save R11
1611               0321 63B6 C10E  18         mov   r14,tmp0
1612               0322 63B8 0984  56         srl   tmp0,8
1613               0323 63BA 06A0  32         bl    @putvrx               ; Write VR#0
1614                    63BC 232E
1615               0324 63BE 0204  20         li    tmp0,>0100
1616                    63C0 0100
1617               0325 63C2 D820  54         movb  @r14lb,@tmp0lb
1618                    63C4 831D
1619                    63C6 8309
1620               0326 63C8 06A0  32         bl    @putvrx               ; Write VR#1
1621                    63CA 232E
1622               0327 63CC 0458  20         b     *tmp4                 ; Exit
1623               0328
1624               0329
1625               0330               ***************************************************************
1626               0331               * LDFNT - Load TI-99/4A font from GROM into VDP
1627               0332               ***************************************************************
1628               0333               *  BL   @LDFNT
1629               0334               *  DATA P0,P1
1630               0335               *--------------------------------------------------------------
1631               0336               *  P0 = VDP Target address
1632               0337               *  P1 = Font options
1633               0338               *--------------------------------------------------------------
1634               0339               * Uses registers tmp0-tmp4
1635               0340               ********|*****|*********************|**************************
1636               0341 63CE C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
1637               0342 63D0 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
1638               0343 63D2 C11B  26         mov   *r11,tmp0             ; Get P0
1639               0344 63D4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
1640                    63D6 7FFF
1641               0345 63D8 2120  38         coc   @wbit0,tmp0
1642                    63DA 202A
1643               0346 63DC 1604  14         jne   ldfnt1
1644               0347 63DE 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
1645                    63E0 8000
1646               0348 63E2 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
1647                    63E4 7FFF
1648               0349               *--------------------------------------------------------------
1649               0350               * Read font table address from GROM into tmp1
1650               0351               *--------------------------------------------------------------
1651               0352 63E6 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
1652                    63E8 23DC
1653               0353 63EA D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
1654                    63EC 9C02
1655               0354 63EE 06C4  14         swpb  tmp0
1656               0355 63F0 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
1657                    63F2 9C02
1658               0356 63F4 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
1659                    63F6 9800
1660               0357 63F8 06C5  14         swpb  tmp1
1661               0358 63FA D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
1662                    63FC 9800
1663               0359 63FE 06C5  14         swpb  tmp1
1664               0360               *--------------------------------------------------------------
1665               0361               * Setup GROM source address from tmp1
1666               0362               *--------------------------------------------------------------
1667               0363 6400 D805  38         movb  tmp1,@grmwa
1668                    6402 9C02
1669               0364 6404 06C5  14         swpb  tmp1
1670               0365 6406 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
1671                    6408 9C02
1672               0366               *--------------------------------------------------------------
1673               0367               * Setup VDP target address
1674               0368               *--------------------------------------------------------------
1675               0369 640A C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
1676               0370 640C 06A0  32         bl    @vdwa                 ; Setup VDP destination address
1677                    640E 22B0
1678               0371 6410 05C8  14         inct  tmp4                  ; R11=R11+2
1679               0372 6412 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
1680               0373 6414 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
1681                    6416 7FFF
1682               0374 6418 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
1683                    641A 23DE
1684               0375 641C C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
1685                    641E 23E0
1686               0376               *--------------------------------------------------------------
1687               0377               * Copy from GROM to VRAM
1688               0378               *--------------------------------------------------------------
1689               0379 6420 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
1690               0380 6422 1812  14         joc   ldfnt4                ; Yes, go insert a >00
1691               0381 6424 D120  34         movb  @grmrd,tmp0
1692                    6426 9800
1693               0382               *--------------------------------------------------------------
1694               0383               *   Make font fat
1695               0384               *--------------------------------------------------------------
1696               0385 6428 20A0  38         coc   @wbit0,config         ; Fat flag set ?
1697                    642A 202A
1698               0386 642C 1603  14         jne   ldfnt3                ; No, so skip
1699               0387 642E D1C4  18         movb  tmp0,tmp3
1700               0388 6430 0917  56         srl   tmp3,1
1701               0389 6432 E107  18         soc   tmp3,tmp0
1702               0390               *--------------------------------------------------------------
1703               0391               *   Dump byte to VDP and do housekeeping
1704               0392               *--------------------------------------------------------------
1705               0393 6434 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
1706                    6436 8C00
1707               0394 6438 0606  14         dec   tmp2
1708               0395 643A 16F2  14         jne   ldfnt2
1709               0396 643C 05C8  14         inct  tmp4                  ; R11=R11+2
1710               0397 643E 020F  20         li    r15,vdpw              ; Set VDP write address
1711                    6440 8C00
1712               0398 6442 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
1713                    6444 7FFF
1714               0399 6446 0458  20         b     *tmp4                 ; Exit
1715               0400 6448 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
1716                    644A 200A
1717                    644C 8C00
1718               0401 644E 10E8  14         jmp   ldfnt2
1719               0402               *--------------------------------------------------------------
1720               0403               * Fonts pointer table
1721               0404               *--------------------------------------------------------------
1722               0405 6450 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
1723                    6452 0200
1724                    6454 0000
1725               0406 6456 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
1726                    6458 01C0
1727                    645A 0101
1728               0407 645C 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
1729                    645E 02A0
1730                    6460 0101
1731               0408 6462 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
1732                    6464 00E0
1733                    6466 0101
1734               0409
1735               0410
1736               0411
1737               0412               ***************************************************************
1738               0413               * YX2PNT - Get VDP PNT address for current YX cursor position
1739               0414               ***************************************************************
1740               0415               *  BL   @YX2PNT
1741               0416               *--------------------------------------------------------------
1742               0417               *  INPUT
1743               0418               *  @WYX = Cursor YX position
1744               0419               *--------------------------------------------------------------
1745               0420               *  OUTPUT
1746               0421               *  TMP0 = VDP address for entry in Pattern Name Table
1747               0422               *--------------------------------------------------------------
1748               0423               *  Register usage
1749               0424               *  TMP0, R14, R15
1750               0425               ********|*****|*********************|**************************
1751               0426 6468 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
1752               0427 646A C3A0  34         mov   @wyx,r14              ; Get YX
1753                    646C 832A
1754               0428 646E 098E  56         srl   r14,8                 ; Right justify (remove X)
1755               0429 6470 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
1756                    6472 833A
1757               0430               *--------------------------------------------------------------
1758               0431               * Do rest of calculation with R15 (16 bit part is there)
1759               0432               * Re-use R14
1760               0433               *--------------------------------------------------------------
1761               0434 6474 C3A0  34         mov   @wyx,r14              ; Get YX
1762                    6476 832A
1763               0435 6478 024E  22         andi  r14,>00ff             ; Remove Y
1764                    647A 00FF
1765               0436 647C A3CE  18         a     r14,r15               ; pos = pos + X
1766               0437 647E A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
1767                    6480 8328
1768               0438               *--------------------------------------------------------------
1769               0439               * Clean up before exit
1770               0440               *--------------------------------------------------------------
1771               0441 6482 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
1772               0442 6484 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
1773               0443 6486 020F  20         li    r15,vdpw              ; VDP write address
1774                    6488 8C00
1775               0444 648A 045B  20         b     *r11
1776               0445
1777               0446
1778               0447
1779               0448               ***************************************************************
1780               0449               * Put length-byte prefixed string at current YX
1781               0450               ***************************************************************
1782               0451               *  BL   @PUTSTR
1783               0452               *  DATA P0
1784               0453               *
1785               0454               *  P0 = Pointer to string
1786               0455               *--------------------------------------------------------------
1787               0456               *  REMARKS
1788               0457               *  First byte of string must contain length
1789               0458               ********|*****|*********************|**************************
1790               0459 648C C17B  30 putstr  mov   *r11+,tmp1
1791               0460 648E D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
1792               0461 6490 C1CB  18 xutstr  mov   r11,tmp3
1793               0462 6492 06A0  32         bl    @yx2pnt               ; Get VDP destination address
1794                    6494 23F4
1795               0463 6496 C2C7  18         mov   tmp3,r11
1796               0464 6498 0986  56         srl   tmp2,8                ; Right justify length byte
1797               0465               *--------------------------------------------------------------
1798               0466               * Put string
1799               0467               *--------------------------------------------------------------
1800               0468 649A C186  18         mov   tmp2,tmp2             ; Length = 0 ?
1801               0469 649C 1305  14         jeq   !                     ; Yes, crash and burn
1802               0470
1803               0471 649E 0286  22         ci    tmp2,255              ; Length > 255 ?
1804                    64A0 00FF
1805               0472 64A2 1502  14         jgt   !                     ; Yes, crash and burn
1806               0473
1807               0474 64A4 0460  28         b     @xpym2v               ; Display string
1808                    64A6 244A
1809               0475               *--------------------------------------------------------------
1810               0476               * Crash handler
1811               0477               *--------------------------------------------------------------
1812               0478 64A8 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
1813                    64AA FFCE
1814               0479 64AC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1815                    64AE 2030
1816               0480
1817               0481
1818               0482
1819               0483               ***************************************************************
1820               0484               * Put length-byte prefixed string at YX
1821               0485               ***************************************************************
1822               0486               *  BL   @PUTAT
1823               0487               *  DATA P0,P1
1824               0488               *
1825               0489               *  P0 = YX position
1826               0490               *  P1 = Pointer to string
1827               0491               *--------------------------------------------------------------
1828               0492               *  REMARKS
1829               0493               *  First byte of string must contain length
1830               0494               ********|*****|*********************|**************************
1831               0495 64B0 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
1832                    64B2 832A
1833               0496 64B4 0460  28         b     @putstr
1834                    64B6 2418
1835               **** **** ****     > runlib.asm
1836               0091
1837               0093                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
1838               **** **** ****     > copy_cpu_vram.asm
1839               0001               * FILE......: copy_cpu_vram.asm
1840               0002               * Purpose...: CPU memory to VRAM copy support module
1841               0003
1842               0004               ***************************************************************
1843               0005               * CPYM2V - Copy CPU memory to VRAM
1844               0006               ***************************************************************
1845               0007               *  BL   @CPYM2V
1846               0008               *  DATA P0,P1,P2
1847               0009               *--------------------------------------------------------------
1848               0010               *  P0 = VDP start address
1849               0011               *  P1 = RAM/ROM start address
1850               0012               *  P2 = Number of bytes to copy
1851               0013               *--------------------------------------------------------------
1852               0014               *  BL @XPYM2V
1853               0015               *
1854               0016               *  TMP0 = VDP start address
1855               0017               *  TMP1 = RAM/ROM start address
1856               0018               *  TMP2 = Number of bytes to copy
1857               0019               ********|*****|*********************|**************************
1858               0020 64B8 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
1859               0021 64BA C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
1860               0022 64BC C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
1861               0023               *--------------------------------------------------------------
1862               0024               *    Setup VDP write address
1863               0025               *--------------------------------------------------------------
1864               0026 64BE 0264  22 xpym2v  ori   tmp0,>4000
1865                    64C0 4000
1866               0027 64C2 06C4  14         swpb  tmp0
1867               0028 64C4 D804  38         movb  tmp0,@vdpa
1868                    64C6 8C02
1869               0029 64C8 06C4  14         swpb  tmp0
1870               0030 64CA D804  38         movb  tmp0,@vdpa
1871                    64CC 8C02
1872               0031               *--------------------------------------------------------------
1873               0032               *    Copy bytes from CPU memory to VRAM
1874               0033               *--------------------------------------------------------------
1875               0034 64CE 020F  20         li    r15,vdpw              ; Set VDP write address
1876                    64D0 8C00
1877               0035 64D2 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
1878                    64D4 2468
1879                    64D6 8320
1880               0036 64D8 0460  28         b     @mcloop               ; Write data to VDP
1881                    64DA 8320
1882               0037 64DC D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
1883               **** **** ****     > runlib.asm
1884               0095
1885               0097                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
1886               **** **** ****     > copy_vram_cpu.asm
1887               0001               * FILE......: copy_vram_cpu.asm
1888               0002               * Purpose...: VRAM to CPU memory copy support module
1889               0003
1890               0004               ***************************************************************
1891               0005               * CPYV2M - Copy VRAM to CPU memory
1892               0006               ***************************************************************
1893               0007               *  BL   @CPYV2M
1894               0008               *  DATA P0,P1,P2
1895               0009               *--------------------------------------------------------------
1896               0010               *  P0 = VDP source address
1897               0011               *  P1 = RAM target address
1898               0012               *  P2 = Number of bytes to copy
1899               0013               *--------------------------------------------------------------
1900               0014               *  BL @XPYV2M
1901               0015               *
1902               0016               *  TMP0 = VDP source address
1903               0017               *  TMP1 = RAM target address
1904               0018               *  TMP2 = Number of bytes to copy
1905               0019               ********|*****|*********************|**************************
1906               0020 64DE C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
1907               0021 64E0 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
1908               0022 64E2 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
1909               0023               *--------------------------------------------------------------
1910               0024               *    Setup VDP read address
1911               0025               *--------------------------------------------------------------
1912               0026 64E4 06C4  14 xpyv2m  swpb  tmp0
1913               0027 64E6 D804  38         movb  tmp0,@vdpa
1914                    64E8 8C02
1915               0028 64EA 06C4  14         swpb  tmp0
1916               0029 64EC D804  38         movb  tmp0,@vdpa
1917                    64EE 8C02
1918               0030               *--------------------------------------------------------------
1919               0031               *    Copy bytes from VDP memory to RAM
1920               0032               *--------------------------------------------------------------
1921               0033 64F0 020F  20         li    r15,vdpr              ; Set VDP read address
1922                    64F2 8800
1923               0034 64F4 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
1924                    64F6 248A
1925                    64F8 8320
1926               0035 64FA 0460  28         b     @mcloop               ; Read data from VDP
1927                    64FC 8320
1928               0036 64FE DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
1929               **** **** ****     > runlib.asm
1930               0099
1931               0101                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
1932               **** **** ****     > copy_cpu_cpu.asm
1933               0001               * FILE......: copy_cpu_cpu.asm
1934               0002               * Purpose...: CPU to CPU memory copy support module
1935               0003
1936               0004               *//////////////////////////////////////////////////////////////
1937               0005               *                       CPU COPY FUNCTIONS
1938               0006               *//////////////////////////////////////////////////////////////
1939               0007
1940               0008               ***************************************************************
1941               0009               * CPYM2M - Copy CPU memory to CPU memory
1942               0010               ***************************************************************
1943               0011               *  BL   @CPYM2M
1944               0012               *  DATA P0,P1,P2
1945               0013               *--------------------------------------------------------------
1946               0014               *  P0 = Memory source address
1947               0015               *  P1 = Memory target address
1948               0016               *  P2 = Number of bytes to copy
1949               0017               *--------------------------------------------------------------
1950               0018               *  BL @XPYM2M
1951               0019               *
1952               0020               *  TMP0 = Memory source address
1953               0021               *  TMP1 = Memory target address
1954               0022               *  TMP2 = Number of bytes to copy
1955               0023               ********|*****|*********************|**************************
1956               0024 6500 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
1957               0025 6502 C17B  30         mov   *r11+,tmp1            ; Memory target address
1958               0026 6504 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
1959               0027               *--------------------------------------------------------------
1960               0028               * Do some checks first
1961               0029               *--------------------------------------------------------------
1962               0030 6506 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
1963               0031 6508 1604  14         jne   cpychk                ; No, continue checking
1964               0032
1965               0033 650A C80B  38         mov   r11,@>ffce            ; \ Save caller address
1966                    650C FFCE
1967               0034 650E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1968                    6510 2030
1969               0035               *--------------------------------------------------------------
1970               0036               *    Check: 1 byte copy
1971               0037               *--------------------------------------------------------------
1972               0038 6512 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
1973                    6514 0001
1974               0039 6516 1603  14         jne   cpym0                 ; No, continue checking
1975               0040 6518 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
1976               0041 651A 04C6  14         clr   tmp2                  ; Reset counter
1977               0042 651C 045B  20         b     *r11                  ; Return to caller
1978               0043               *--------------------------------------------------------------
1979               0044               *    Check: Uneven address handling
1980               0045               *--------------------------------------------------------------
1981               0046 651E 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
1982                    6520 7FFF
1983               0047 6522 C1C4  18         mov   tmp0,tmp3
1984               0048 6524 0247  22         andi  tmp3,1
1985                    6526 0001
1986               0049 6528 1618  14         jne   cpyodd                ; Odd source address handling
1987               0050 652A C1C5  18 cpym1   mov   tmp1,tmp3
1988               0051 652C 0247  22         andi  tmp3,1
1989                    652E 0001
1990               0052 6530 1614  14         jne   cpyodd                ; Odd target address handling
1991               0053               *--------------------------------------------------------------
1992               0054               * 8 bit copy
1993               0055               *--------------------------------------------------------------
1994               0056 6532 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
1995                    6534 202A
1996               0057 6536 1605  14         jne   cpym3
1997               0058 6538 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
1998                    653A 24EC
1999                    653C 8320
2000               0059 653E 0460  28         b     @mcloop               ; Copy memory and exit
2001                    6540 8320
2002               0060               *--------------------------------------------------------------
2003               0061               * 16 bit copy
2004               0062               *--------------------------------------------------------------
2005               0063 6542 C1C6  18 cpym3   mov   tmp2,tmp3
2006               0064 6544 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
2007                    6546 0001
2008               0065 6548 1301  14         jeq   cpym4
2009               0066 654A 0606  14         dec   tmp2                  ; Make TMP2 even
2010               0067 654C CD74  46 cpym4   mov   *tmp0+,*tmp1+
2011               0068 654E 0646  14         dect  tmp2
2012               0069 6550 16FD  14         jne   cpym4
2013               0070               *--------------------------------------------------------------
2014               0071               * Copy last byte if ODD
2015               0072               *--------------------------------------------------------------
2016               0073 6552 C1C7  18         mov   tmp3,tmp3
2017               0074 6554 1301  14         jeq   cpymz
2018               0075 6556 D554  38         movb  *tmp0,*tmp1
2019               0076 6558 045B  20 cpymz   b     *r11                  ; Return to caller
2020               0077               *--------------------------------------------------------------
2021               0078               * Handle odd source/target address
2022               0079               *--------------------------------------------------------------
2023               0080 655A 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
2024                    655C 8000
2025               0081 655E 10E9  14         jmp   cpym2
2026               0082 6560 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
2027               **** **** ****     > runlib.asm
2028               0103
2029               0107
2030               0111
2031               0113                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
2032               **** **** ****     > cpu_sams_support.asm
2033               0001               * FILE......: cpu_sams_support.asm
2034               0002               * Purpose...: Low level support for SAMS memory expansion card
2035               0003
2036               0004               *//////////////////////////////////////////////////////////////
2037               0005               *                SAMS Memory Expansion support
2038               0006               *//////////////////////////////////////////////////////////////
2039               0007
2040               0008               *--------------------------------------------------------------
2041               0009               * ACCESS and MAPPING
2042               0010               * (by the late Bruce Harisson):
2043               0011               *
2044               0012               * To use other than the default setup, you have to do two
2045               0013               * things:
2046               0014               *
2047               0015               * 1. You have to "turn on" the card's memory in the
2048               0016               *    >4000 block and write to the mapping registers there.
2049               0017               *    (bl  @sams.page.set)
2050               0018               *
2051               0019               * 2. You have to "turn on" the mapper function to make what
2052               0020               *    you've written into the >4000 block take effect.
2053               0021               *    (bl  @sams.mapping.on)
2054               0022               *--------------------------------------------------------------
2055               0023               *  SAMS                          Default SAMS page
2056               0024               *  Register     Memory bank      (system startup)
2057               0025               *  =======      ===========      ================
2058               0026               *  >4004        >2000-2fff          >002
2059               0027               *  >4006        >3000-4fff          >003
2060               0028               *  >4014        >a000-afff          >00a
2061               0029               *  >4016        >b000-bfff          >00b
2062               0030               *  >4018        >c000-cfff          >00c
2063               0031               *  >401a        >d000-dfff          >00d
2064               0032               *  >401c        >e000-efff          >00e
2065               0033               *  >401e        >f000-ffff          >00f
2066               0034               *  Others       Inactive
2067               0035               *--------------------------------------------------------------
2068               0036
2069               0037
2070               0038
2071               0039
2072               0040               ***************************************************************
2073               0041               * sams.page.get - Get SAMS page number for memory address
2074               0042               ***************************************************************
2075               0043               * bl   @sams.page.get
2076               0044               *      data P0
2077               0045               *--------------------------------------------------------------
2078               0046               * P0 = Memory address (e.g. address >a100 will map to SAMS
2079               0047               *      register >4014 (bank >a000 - >afff)
2080               0048               *--------------------------------------------------------------
2081               0049               * bl   @xsams.page.get
2082               0050               *
2083               0051               * tmp0 = Memory address (e.g. address >a100 will map to SAMS
2084               0052               *        register >4014 (bank >a000 - >afff)
2085               0053               *--------------------------------------------------------------
2086               0054               * OUTPUT
2087               0055               * waux1 = SAMS page number
2088               0056               * waux2 = Address of affected SAMS register
2089               0057               *--------------------------------------------------------------
2090               0058               * Register usage
2091               0059               * r0, tmp0, r12
2092               0060               ********|*****|*********************|**************************
2093               0061               sams.page.get:
2094               0062 6562 C13B  30         mov   *r11+,tmp0            ; Memory address
2095               0063               xsams.page.get:
2096               0064 6564 0649  14         dect  stack
2097               0065 6566 C64B  30         mov   r11,*stack            ; Push return address
2098               0066 6568 0649  14         dect  stack
2099               0067 656A C640  30         mov   r0,*stack             ; Push r0
2100               0068 656C 0649  14         dect  stack
2101               0069 656E C64C  30         mov   r12,*stack            ; Push r12
2102               0070               *--------------------------------------------------------------
2103               0071               * Determine memory bank
2104               0072               *--------------------------------------------------------------
2105               0073 6570 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
2106               0074 6572 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
2107               0075
2108               0076 6574 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
2109                    6576 4000
2110               0077 6578 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
2111                    657A 833E
2112               0078               *--------------------------------------------------------------
2113               0079               * Get SAMS page number
2114               0080               *--------------------------------------------------------------
2115               0081 657C 020C  20         li    r12,>1e00             ; SAMS CRU address
2116                    657E 1E00
2117               0082 6580 04C0  14         clr   r0
2118               0083 6582 1D00  20         sbo   0                     ; Enable access to SAMS registers
2119               0084 6584 D014  26         movb  *tmp0,r0              ; Get SAMS page number
2120               0085 6586 D100  18         movb  r0,tmp0
2121               0086 6588 0984  56         srl   tmp0,8                ; Right align
2122               0087 658A C804  38         mov   tmp0,@waux1           ; Save SAMS page number
2123                    658C 833C
2124               0088 658E 1E00  20         sbz   0                     ; Disable access to SAMS registers
2125               0089               *--------------------------------------------------------------
2126               0090               * Exit
2127               0091               *--------------------------------------------------------------
2128               0092               sams.page.get.exit:
2129               0093 6590 C339  30         mov   *stack+,r12           ; Pop r12
2130               0094 6592 C039  30         mov   *stack+,r0            ; Pop r0
2131               0095 6594 C2F9  30         mov   *stack+,r11           ; Pop return address
2132               0096 6596 045B  20         b     *r11                  ; Return to caller
2133               0097
2134               0098
2135               0099
2136               0100
2137               0101               ***************************************************************
2138               0102               * sams.page.set - Set SAMS memory page
2139               0103               ***************************************************************
2140               0104               * bl   sams.page.set
2141               0105               *      data P0,P1
2142               0106               *--------------------------------------------------------------
2143               0107               * P0 = SAMS page number
2144               0108               * P1 = Memory address (e.g. address >a100 will map to SAMS
2145               0109               *      register >4014 (bank >a000 - >afff)
2146               0110               *--------------------------------------------------------------
2147               0111               * bl   @xsams.page.set
2148               0112               *
2149               0113               * tmp0 = SAMS page number
2150               0114               * tmp1 = Memory address (e.g. address >a100 will map to SAMS
2151               0115               *        register >4014 (bank >a000 - >afff)
2152               0116               *--------------------------------------------------------------
2153               0117               * Register usage
2154               0118               * r0, tmp0, tmp1, r12
2155               0119               *--------------------------------------------------------------
2156               0120               * SAMS page number should be in range 0-255 (>00 to >ff)
2157               0121               *
2158               0122               *  Page         Memory
2159               0123               *  ====         ======
2160               0124               *  >00             32K
2161               0125               *  >1f            128K
2162               0126               *  >3f            256K
2163               0127               *  >7f            512K
2164               0128               *  >ff           1024K
2165               0129               ********|*****|*********************|**************************
2166               0130               sams.page.set:
2167               0131 6598 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
2168               0132 659A C17B  30         mov   *r11+,tmp1            ; Get memory address
2169               0133               xsams.page.set:
2170               0134 659C 0649  14         dect  stack
2171               0135 659E C64B  30         mov   r11,*stack            ; Push return address
2172               0136 65A0 0649  14         dect  stack
2173               0137 65A2 C640  30         mov   r0,*stack             ; Push r0
2174               0138 65A4 0649  14         dect  stack
2175               0139 65A6 C64C  30         mov   r12,*stack            ; Push r12
2176               0140 65A8 0649  14         dect  stack
2177               0141 65AA C644  30         mov   tmp0,*stack           ; Push tmp0
2178               0142 65AC 0649  14         dect  stack
2179               0143 65AE C645  30         mov   tmp1,*stack           ; Push tmp1
2180               0144               *--------------------------------------------------------------
2181               0145               * Determine memory bank
2182               0146               *--------------------------------------------------------------
2183               0147 65B0 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
2184               0148 65B2 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
2185               0149               *--------------------------------------------------------------
2186               0150               * Sanity check on SAMS page number
2187               0151               *--------------------------------------------------------------
2188               0152 65B4 0284  22         ci    tmp0,255              ; Crash if page > 255
2189                    65B6 00FF
2190               0153 65B8 150D  14         jgt   !
2191               0154               *--------------------------------------------------------------
2192               0155               * Sanity check on SAMS register
2193               0156               *--------------------------------------------------------------
2194               0157 65BA 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
2195                    65BC 001E
2196               0158 65BE 150A  14         jgt   !
2197               0159 65C0 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
2198                    65C2 0004
2199               0160 65C4 1107  14         jlt   !
2200               0161 65C6 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
2201                    65C8 0012
2202               0162 65CA 1508  14         jgt   sams.page.set.switch_page
2203               0163 65CC 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
2204                    65CE 0006
2205               0164 65D0 1501  14         jgt   !
2206               0165 65D2 1004  14         jmp   sams.page.set.switch_page
2207               0166                       ;------------------------------------------------------
2208               0167                       ; Crash the system
2209               0168                       ;------------------------------------------------------
2210               0169 65D4 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
2211                    65D6 FFCE
2212               0170 65D8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
2213                    65DA 2030
2214               0171               *--------------------------------------------------------------
2215               0172               * Switch memory bank to specified SAMS page
2216               0173               *--------------------------------------------------------------
2217               0174               sams.page.set.switch_page
2218               0175 65DC 020C  20         li    r12,>1e00             ; SAMS CRU address
2219                    65DE 1E00
2220               0176 65E0 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
2221               0177 65E2 06C0  14         swpb  r0                    ; LSB to MSB
2222               0178 65E4 1D00  20         sbo   0                     ; Enable access to SAMS registers
2223               0179 65E6 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
2224                    65E8 4000
2225               0180 65EA 1E00  20         sbz   0                     ; Disable access to SAMS registers
2226               0181               *--------------------------------------------------------------
2227               0182               * Exit
2228               0183               *--------------------------------------------------------------
2229               0184               sams.page.set.exit:
2230               0185 65EC C179  30         mov   *stack+,tmp1          ; Pop tmp1
2231               0186 65EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
2232               0187 65F0 C339  30         mov   *stack+,r12           ; Pop r12
2233               0188 65F2 C039  30         mov   *stack+,r0            ; Pop r0
2234               0189 65F4 C2F9  30         mov   *stack+,r11           ; Pop return address
2235               0190 65F6 045B  20         b     *r11                  ; Return to caller
2236               0191
2237               0192
2238               0193
2239               0194
2240               0195               ***************************************************************
2241               0196               * sams.mapping.on - Enable SAMS mapping mode
2242               0197               ***************************************************************
2243               0198               *  bl   @sams.mapping.on
2244               0199               *--------------------------------------------------------------
2245               0200               *  Register usage
2246               0201               *  r12
2247               0202               ********|*****|*********************|**************************
2248               0203               sams.mapping.on:
2249               0204 65F8 020C  20         li    r12,>1e00             ; SAMS CRU address
2250                    65FA 1E00
2251               0205 65FC 1D01  20         sbo   1                     ; Enable SAMS mapper
2252               0206               *--------------------------------------------------------------
2253               0207               * Exit
2254               0208               *--------------------------------------------------------------
2255               0209               sams.mapping.on.exit:
2256               0210 65FE 045B  20         b     *r11                  ; Return to caller
2257               0211
2258               0212
2259               0213
2260               0214
2261               0215               ***************************************************************
2262               0216               * sams.mapping.off - Disable SAMS mapping mode
2263               0217               ***************************************************************
2264               0218               * bl  @sams.mapping.off
2265               0219               *--------------------------------------------------------------
2266               0220               * OUTPUT
2267               0221               * none
2268               0222               *--------------------------------------------------------------
2269               0223               * Register usage
2270               0224               * r12
2271               0225               ********|*****|*********************|**************************
2272               0226               sams.mapping.off:
2273               0227 6600 020C  20         li    r12,>1e00             ; SAMS CRU address
2274                    6602 1E00
2275               0228 6604 1E01  20         sbz   1                     ; Disable SAMS mapper
2276               0229               *--------------------------------------------------------------
2277               0230               * Exit
2278               0231               *--------------------------------------------------------------
2279               0232               sams.mapping.off.exit:
2280               0233 6606 045B  20         b     *r11                  ; Return to caller
2281               0234
2282               0235
2283               0236
2284               0237
2285               0238
2286               0239               ***************************************************************
2287               0240               * sams.layout
2288               0241               * Setup SAMS memory banks
2289               0242               ***************************************************************
2290               0243               * bl  @sams.layout
2291               0244               *     data P0
2292               0245               *--------------------------------------------------------------
2293               0246               * INPUT
2294               0247               * P0 = Pointer to SAMS page layout table (16 words).
2295               0248               *--------------------------------------------------------------
2296               0249               * bl  @xsams.layout
2297               0250               *
2298               0251               * tmp0 = Pointer to SAMS page layout table (16 words).
2299               0252               *--------------------------------------------------------------
2300               0253               * OUTPUT
2301               0254               * none
2302               0255               *--------------------------------------------------------------
2303               0256               * Register usage
2304               0257               * tmp0, tmp1, tmp2, tmp3
2305               0258               ********|*****|*********************|**************************
2306               0259               sams.layout:
2307               0260 6608 C1FB  30         mov   *r11+,tmp3            ; Get P0
2308               0261               xsams.layout:
2309               0262 660A 0649  14         dect  stack
2310               0263 660C C64B  30         mov   r11,*stack            ; Save return address
2311               0264 660E 0649  14         dect  stack
2312               0265 6610 C644  30         mov   tmp0,*stack           ; Save tmp0
2313               0266 6612 0649  14         dect  stack
2314               0267 6614 C645  30         mov   tmp1,*stack           ; Save tmp1
2315               0268 6616 0649  14         dect  stack
2316               0269 6618 C646  30         mov   tmp2,*stack           ; Save tmp2
2317               0270 661A 0649  14         dect  stack
2318               0271 661C C647  30         mov   tmp3,*stack           ; Save tmp3
2319               0272                       ;------------------------------------------------------
2320               0273                       ; Initialize
2321               0274                       ;------------------------------------------------------
2322               0275 661E 0206  20         li    tmp2,8                ; Set loop counter
2323                    6620 0008
2324               0276                       ;------------------------------------------------------
2325               0277                       ; Set SAMS memory pages
2326               0278                       ;------------------------------------------------------
2327               0279               sams.layout.loop:
2328               0280 6622 C177  30         mov   *tmp3+,tmp1           ; Get memory address
2329               0281 6624 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
2330               0282
2331               0283 6626 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
2332                    6628 2528
2333               0284                                                   ; | i  tmp0 = SAMS page
2334               0285                                                   ; / i  tmp1 = Memory address
2335               0286
2336               0287 662A 0606  14         dec   tmp2                  ; Next iteration
2337               0288 662C 16FA  14         jne   sams.layout.loop      ; Loop until done
2338               0289                       ;------------------------------------------------------
2339               0290                       ; Exit
2340               0291                       ;------------------------------------------------------
2341               0292               sams.init.exit:
2342               0293 662E 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
2343                    6630 2584
2344               0294                                                   ; / activating changes.
2345               0295
2346               0296 6632 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
2347               0297 6634 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
2348               0298 6636 C179  30         mov   *stack+,tmp1          ; Pop tmp1
2349               0299 6638 C139  30         mov   *stack+,tmp0          ; Pop tmp0
2350               0300 663A C2F9  30         mov   *stack+,r11           ; Pop r11
2351               0301 663C 045B  20         b     *r11                  ; Return to caller
2352               0302
2353               0303
2354               0304
2355               0305               ***************************************************************
2356               0306               * sams.layout.reset
2357               0307               * Reset SAMS memory banks to standard layout
2358               0308               ***************************************************************
2359               0309               * bl  @sams.layout.reset
2360               0310               *--------------------------------------------------------------
2361               0311               * OUTPUT
2362               0312               * none
2363               0313               *--------------------------------------------------------------
2364               0314               * Register usage
2365               0315               * none
2366               0316               ********|*****|*********************|**************************
2367               0317               sams.layout.reset:
2368               0318 663E 0649  14         dect  stack
2369               0319 6640 C64B  30         mov   r11,*stack            ; Save return address
2370               0320                       ;------------------------------------------------------
2371               0321                       ; Set SAMS standard layout
2372               0322                       ;------------------------------------------------------
2373               0323 6642 06A0  32         bl    @sams.layout
2374                    6644 2594
2375               0324 6646 25D8                   data sams.layout.standard
2376               0325                       ;------------------------------------------------------
2377               0326                       ; Exit
2378               0327                       ;------------------------------------------------------
2379               0328               sams.layout.reset.exit:
2380               0329 6648 C2F9  30         mov   *stack+,r11           ; Pop r11
2381               0330 664A 045B  20         b     *r11                  ; Return to caller
2382               0331               ***************************************************************
2383               0332               * SAMS standard page layout table (16 words)
2384               0333               *--------------------------------------------------------------
2385               0334               sams.layout.standard:
2386               0335 664C 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
2387                    664E 0002
2388               0336 6650 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
2389                    6652 0003
2390               0337 6654 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
2391                    6656 000A
2392               0338 6658 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
2393                    665A 000B
2394               0339 665C C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
2395                    665E 000C
2396               0340 6660 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
2397                    6662 000D
2398               0341 6664 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
2399                    6666 000E
2400               0342 6668 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
2401                    666A 000F
2402               0343
2403               0344
2404               0345
2405               0346               ***************************************************************
2406               0347               * sams.layout.copy
2407               0348               * Copy SAMS memory layout
2408               0349               ***************************************************************
2409               0350               * bl  @sams.layout.copy
2410               0351               *     data P0
2411               0352               *--------------------------------------------------------------
2412               0353               * P0 = Pointer to 8 words RAM buffer for results
2413               0354               *--------------------------------------------------------------
2414               0355               * OUTPUT
2415               0356               * RAM buffer will have the SAMS page number for each range
2416               0357               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
2417               0358               *--------------------------------------------------------------
2418               0359               * Register usage
2419               0360               * tmp0, tmp1, tmp2, tmp3
2420               0361               ***************************************************************
2421               0362               sams.layout.copy:
2422               0363 666C C1FB  30         mov   *r11+,tmp3            ; Get P0
2423               0364
2424               0365 666E 0649  14         dect  stack
2425               0366 6670 C64B  30         mov   r11,*stack            ; Push return address
2426               0367 6672 0649  14         dect  stack
2427               0368 6674 C644  30         mov   tmp0,*stack           ; Push tmp0
2428               0369 6676 0649  14         dect  stack
2429               0370 6678 C645  30         mov   tmp1,*stack           ; Push tmp1
2430               0371 667A 0649  14         dect  stack
2431               0372 667C C646  30         mov   tmp2,*stack           ; Push tmp2
2432               0373 667E 0649  14         dect  stack
2433               0374 6680 C647  30         mov   tmp3,*stack           ; Push tmp3
2434               0375                       ;------------------------------------------------------
2435               0376                       ; Copy SAMS layout
2436               0377                       ;------------------------------------------------------
2437               0378 6682 0205  20         li    tmp1,sams.layout.copy.data
2438                    6684 2630
2439               0379 6686 0206  20         li    tmp2,8                ; Set loop counter
2440                    6688 0008
2441               0380                       ;------------------------------------------------------
2442               0381                       ; Set SAMS memory pages
2443               0382                       ;------------------------------------------------------
2444               0383               sams.layout.copy.loop:
2445               0384 668A C135  30         mov   *tmp1+,tmp0           ; Get memory address
2446               0385 668C 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
2447                    668E 24F0
2448               0386                                                   ; | i  tmp0   = Memory address
2449               0387                                                   ; / o  @waux1 = SAMS page
2450               0388
2451               0389 6690 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
2452                    6692 833C
2453               0390
2454               0391 6694 0606  14         dec   tmp2                  ; Next iteration
2455               0392 6696 16F9  14         jne   sams.layout.copy.loop ; Loop until done
2456               0393                       ;------------------------------------------------------
2457               0394                       ; Exit
2458               0395                       ;------------------------------------------------------
2459               0396               sams.layout.copy.exit:
2460               0397 6698 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
2461               0398 669A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
2462               0399 669C C179  30         mov   *stack+,tmp1          ; Pop tmp1
2463               0400 669E C139  30         mov   *stack+,tmp0          ; Pop tmp0
2464               0401 66A0 C2F9  30         mov   *stack+,r11           ; Pop r11
2465               0402 66A2 045B  20         b     *r11                  ; Return to caller
2466               0403               ***************************************************************
2467               0404               * SAMS memory range table (8 words)
2468               0405               *--------------------------------------------------------------
2469               0406               sams.layout.copy.data:
2470               0407 66A4 2000             data  >2000                 ; >2000-2fff
2471               0408 66A6 3000             data  >3000                 ; >3000-3fff
2472               0409 66A8 A000             data  >a000                 ; >a000-afff
2473               0410 66AA B000             data  >b000                 ; >b000-bfff
2474               0411 66AC C000             data  >c000                 ; >c000-cfff
2475               0412 66AE D000             data  >d000                 ; >d000-dfff
2476               0413 66B0 E000             data  >e000                 ; >e000-efff
2477               0414 66B2 F000             data  >f000                 ; >f000-ffff
2478               0415
2479               **** **** ****     > runlib.asm
2480               0115
2481               0117                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
2482               **** **** ****     > vdp_intscr.asm
2483               0001               * FILE......: vdp_intscr.asm
2484               0002               * Purpose...: VDP interrupt & screen on/off
2485               0003
2486               0004               ***************************************************************
2487               0005               * SCROFF - Disable screen display
2488               0006               ***************************************************************
2489               0007               *  BL @SCROFF
2490               0008               ********|*****|*********************|**************************
2491               0009 66B4 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
2492                    66B6 FFBF
2493               0010 66B8 0460  28         b     @putv01
2494                    66BA 2340
2495               0011
2496               0012               ***************************************************************
2497               0013               * SCRON - Disable screen display
2498               0014               ***************************************************************
2499               0015               *  BL @SCRON
2500               0016               ********|*****|*********************|**************************
2501               0017 66BC 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
2502                    66BE 0040
2503               0018 66C0 0460  28         b     @putv01
2504                    66C2 2340
2505               0019
2506               0020               ***************************************************************
2507               0021               * INTOFF - Disable VDP interrupt
2508               0022               ***************************************************************
2509               0023               *  BL @INTOFF
2510               0024               ********|*****|*********************|**************************
2511               0025 66C4 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
2512                    66C6 FFDF
2513               0026 66C8 0460  28         b     @putv01
2514                    66CA 2340
2515               0027
2516               0028               ***************************************************************
2517               0029               * INTON - Enable VDP interrupt
2518               0030               ***************************************************************
2519               0031               *  BL @INTON
2520               0032               ********|*****|*********************|**************************
2521               0033 66CC 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
2522                    66CE 0020
2523               0034 66D0 0460  28         b     @putv01
2524                    66D2 2340
2525               **** **** ****     > runlib.asm
2526               0119
2527               0121                       copy  "vdp_sprites.asm"          ; VDP sprites
2528               **** **** ****     > vdp_sprites.asm
2529               0001               ***************************************************************
2530               0002               * FILE......: vdp_sprites.asm
2531               0003               * Purpose...: Sprites support
2532               0004
2533               0005               ***************************************************************
2534               0006               * SMAG1X - Set sprite magnification 1x
2535               0007               ***************************************************************
2536               0008               *  BL @SMAG1X
2537               0009               ********|*****|*********************|**************************
2538               0010 66D4 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
2539                    66D6 FFFE
2540               0011 66D8 0460  28         b     @putv01
2541                    66DA 2340
2542               0012
2543               0013               ***************************************************************
2544               0014               * SMAG2X - Set sprite magnification 2x
2545               0015               ***************************************************************
2546               0016               *  BL @SMAG2X
2547               0017               ********|*****|*********************|**************************
2548               0018 66DC 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
2549                    66DE 0001
2550               0019 66E0 0460  28         b     @putv01
2551                    66E2 2340
2552               0020
2553               0021               ***************************************************************
2554               0022               * S8X8 - Set sprite size 8x8 bits
2555               0023               ***************************************************************
2556               0024               *  BL @S8X8
2557               0025               ********|*****|*********************|**************************
2558               0026 66E4 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
2559                    66E6 FFFD
2560               0027 66E8 0460  28         b     @putv01
2561                    66EA 2340
2562               0028
2563               0029               ***************************************************************
2564               0030               * S16X16 - Set sprite size 16x16 bits
2565               0031               ***************************************************************
2566               0032               *  BL @S16X16
2567               0033               ********|*****|*********************|**************************
2568               0034 66EC 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
2569                    66EE 0002
2570               0035 66F0 0460  28         b     @putv01
2571                    66F2 2340
2572               **** **** ****     > runlib.asm
2573               0123
2574               0125                       copy  "vdp_cursor.asm"           ; VDP cursor handling
2575               **** **** ****     > vdp_cursor.asm
2576               0001               * FILE......: vdp_cursor.asm
2577               0002               * Purpose...: VDP cursor handling
2578               0003
2579               0004               *//////////////////////////////////////////////////////////////
2580               0005               *               VDP cursor movement functions
2581               0006               *//////////////////////////////////////////////////////////////
2582               0007
2583               0008
2584               0009               ***************************************************************
2585               0010               * AT - Set cursor YX position
2586               0011               ***************************************************************
2587               0012               *  bl   @yx
2588               0013               *  data p0
2589               0014               *--------------------------------------------------------------
2590               0015               *  INPUT
2591               0016               *  P0 = New Cursor YX position
2592               0017               ********|*****|*********************|**************************
2593               0018 66F4 C83B  50 at      mov   *r11+,@wyx
2594                    66F6 832A
2595               0019 66F8 045B  20         b     *r11
2596               0020
2597               0021
2598               0022               ***************************************************************
2599               0023               * down - Increase cursor Y position
2600               0024               ***************************************************************
2601               0025               *  bl   @down
2602               0026               ********|*****|*********************|**************************
2603               0027 66FA B820  54 down    ab    @hb$01,@wyx
2604                    66FC 201C
2605                    66FE 832A
2606               0028 6700 045B  20         b     *r11
2607               0029
2608               0030
2609               0031               ***************************************************************
2610               0032               * up - Decrease cursor Y position
2611               0033               ***************************************************************
2612               0034               *  bl   @up
2613               0035               ********|*****|*********************|**************************
2614               0036 6702 7820  54 up      sb    @hb$01,@wyx
2615                    6704 201C
2616                    6706 832A
2617               0037 6708 045B  20         b     *r11
2618               0038
2619               0039
2620               0040               ***************************************************************
2621               0041               * setx - Set cursor X position
2622               0042               ***************************************************************
2623               0043               *  bl   @setx
2624               0044               *  data p0
2625               0045               *--------------------------------------------------------------
2626               0046               *  Register usage
2627               0047               *  TMP0
2628               0048               ********|*****|*********************|**************************
2629               0049 670A C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
2630               0050 670C D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
2631                    670E 832A
2632               0051 6710 C804  38         mov   tmp0,@wyx             ; Save as new YX position
2633                    6712 832A
2634               0052 6714 045B  20         b     *r11
2635               **** **** ****     > runlib.asm
2636               0127
2637               0129                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
2638               **** **** ****     > vdp_yx2px_calc.asm
2639               0001               * FILE......: vdp_yx2px_calc.asm
2640               0002               * Purpose...: Calculate pixel position for YX coordinate
2641               0003
2642               0004               ***************************************************************
2643               0005               * YX2PX - Get pixel position for cursor YX position
2644               0006               ***************************************************************
2645               0007               *  BL   @YX2PX
2646               0008               *
2647               0009               *  (CONFIG:0 = 1) = Skip sprite adjustment
2648               0010               *--------------------------------------------------------------
2649               0011               *  INPUT
2650               0012               *  @WYX   = Cursor YX position
2651               0013               *--------------------------------------------------------------
2652               0014               *  OUTPUT
2653               0015               *  TMP0HB = Y pixel position
2654               0016               *  TMP0LB = X pixel position
2655               0017               *--------------------------------------------------------------
2656               0018               *  Remarks
2657               0019               *  This subroutine does not support multicolor mode
2658               0020               ********|*****|*********************|**************************
2659               0021 6716 C120  34 yx2px   mov   @wyx,tmp0
2660                    6718 832A
2661               0022 671A C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
2662               0023 671C 06C4  14         swpb  tmp0                  ; Y<->X
2663               0024 671E 04C5  14         clr   tmp1                  ; Clear before copy
2664               0025 6720 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
2665               0026               *--------------------------------------------------------------
2666               0027               * X pixel - Special F18a 80 colums treatment
2667               0028               *--------------------------------------------------------------
2668               0029 6722 20A0  38         coc   @wbit1,config         ; f18a present ?
2669                    6724 2028
2670               0030 6726 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
2671               0031 6728 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
2672                    672A 833A
2673                    672C 26E2
2674               0032 672E 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
2675               0033
2676               0034 6730 0A15  56         sla   tmp1,1                ; X = X * 2
2677               0035 6732 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
2678               0036 6734 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
2679                    6736 0500
2680               0037 6738 1002  14         jmp   yx2pxx_y_calc
2681               0038               *--------------------------------------------------------------
2682               0039               * X pixel - Normal VDP treatment
2683               0040               *--------------------------------------------------------------
2684               0041               yx2pxx_normal:
2685               0042 673A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
2686               0043               *--------------------------------------------------------------
2687               0044 673C 0A35  56         sla   tmp1,3                ; X=X*8
2688               0045               *--------------------------------------------------------------
2689               0046               * Calculate Y pixel position
2690               0047               *--------------------------------------------------------------
2691               0048               yx2pxx_y_calc:
2692               0049 673E 0A34  56         sla   tmp0,3                ; Y=Y*8
2693               0050 6740 D105  18         movb  tmp1,tmp0
2694               0051 6742 06C4  14         swpb  tmp0                  ; X<->Y
2695               0052 6744 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
2696                    6746 202A
2697               0053 6748 1305  14         jeq   yx2pi3                ; Yes, exit
2698               0054               *--------------------------------------------------------------
2699               0055               * Adjust for Y sprite location
2700               0056               * See VDP Programmers Guide, Section 9.2.1
2701               0057               *--------------------------------------------------------------
2702               0058 674A 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
2703                    674C 201C
2704               0059 674E 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
2705                    6750 202E
2706               0060 6752 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
2707               0061 6754 0456  20 yx2pi3  b     *tmp2                 ; Exit
2708               0062               *--------------------------------------------------------------
2709               0063               * Local constants
2710               0064               *--------------------------------------------------------------
2711               0065               yx2pxx_c80:
2712               0066 6756 0050            data   80
2713               0067
2714               0068
2715               **** **** ****     > runlib.asm
2716               0131
2717               0135
2718               0139
2719               0141                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
2720               **** **** ****     > vdp_f18a_support.asm
2721               0001               * FILE......: vdp_f18a_support.asm
2722               0002               * Purpose...: VDP F18A Support module
2723               0003
2724               0004               *//////////////////////////////////////////////////////////////
2725               0005               *                 VDP F18A LOW-LEVEL FUNCTIONS
2726               0006               *//////////////////////////////////////////////////////////////
2727               0007
2728               0008               ***************************************************************
2729               0009               * f18unl - Unlock F18A VDP
2730               0010               ***************************************************************
2731               0011               *  bl   @f18unl
2732               0012               ********|*****|*********************|**************************
2733               0013 6758 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
2734               0014 675A 06A0  32         bl    @putvr                ; Write once
2735                    675C 232C
2736               0015 675E 391C             data  >391c                 ; VR1/57, value 00011100
2737               0016 6760 06A0  32         bl    @putvr                ; Write twice
2738                    6762 232C
2739               0017 6764 391C             data  >391c                 ; VR1/57, value 00011100
2740               0018 6766 0458  20         b     *tmp4                 ; Exit
2741               0019
2742               0020
2743               0021               ***************************************************************
2744               0022               * f18lck - Lock F18A VDP
2745               0023               ***************************************************************
2746               0024               *  bl   @f18lck
2747               0025               ********|*****|*********************|**************************
2748               0026 6768 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
2749               0027 676A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
2750                    676C 232C
2751               0028 676E 391C             data  >391c
2752               0029 6770 0458  20         b     *tmp4                 ; Exit
2753               0030
2754               0031
2755               0032               ***************************************************************
2756               0033               * f18chk - Check if F18A VDP present
2757               0034               ***************************************************************
2758               0035               *  bl   @f18chk
2759               0036               *--------------------------------------------------------------
2760               0037               *  REMARKS
2761               0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
2762               0039               ********|*****|*********************|**************************
2763               0040 6772 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
2764               0041 6774 06A0  32         bl    @cpym2v
2765                    6776 2444
2766               0042 6778 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
2767                    677A 2742
2768                    677C 0006
2769               0043 677E 06A0  32         bl    @putvr
2770                    6780 232C
2771               0044 6782 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
2772               0045 6784 06A0  32         bl    @putvr
2773                    6786 232C
2774               0046 6788 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
2775               0047                                                   ; GPU code should run now
2776               0048               ***************************************************************
2777               0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
2778               0050               ***************************************************************
2779               0051 678A 0204  20         li    tmp0,>3f00
2780                    678C 3F00
2781               0052 678E 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
2782                    6790 22B4
2783               0053 6792 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
2784                    6794 8800
2785               0054 6796 0984  56         srl   tmp0,8
2786               0055 6798 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
2787                    679A 8800
2788               0056 679C C104  18         mov   tmp0,tmp0             ; For comparing with 0
2789               0057 679E 1303  14         jeq   f18chk_yes
2790               0058               f18chk_no:
2791               0059 67A0 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
2792                    67A2 BFFF
2793               0060 67A4 1002  14         jmp   f18chk_exit
2794               0061               f18chk_yes:
2795               0062 67A6 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
2796                    67A8 4000
2797               0063               f18chk_exit:
2798               0064 67AA 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
2799                    67AC 2288
2800               0065 67AE 3F00             data  >3f00,>00,6
2801                    67B0 0000
2802                    67B2 0006
2803               0066 67B4 0458  20         b     *tmp4                 ; Exit
2804               0067               ***************************************************************
2805               0068               * GPU code
2806               0069               ********|*****|*********************|**************************
2807               0070               f18chk_gpu
2808               0071 67B6 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
2809               0072 67B8 3F00             data  >3f00                 ; 3f02 / 3f00
2810               0073 67BA 0340             data  >0340                 ; 3f04   0340  idle
2811               0074
2812               0075
2813               0076               ***************************************************************
2814               0077               * f18rst - Reset f18a into standard settings
2815               0078               ***************************************************************
2816               0079               *  bl   @f18rst
2817               0080               *--------------------------------------------------------------
2818               0081               *  REMARKS
2819               0082               *  This is used to leave the F18A mode and revert all settings
2820               0083               *  that could lead to corruption when doing BLWP @0
2821               0084               *
2822               0085               *  There are some F18a settings that stay on when doing blwp @0
2823               0086               *  and the TI title screen cannot recover from that.
2824               0087               *
2825               0088               *  It is your responsibility to set video mode tables should
2826               0089               *  you want to continue instead of doing blwp @0 after your
2827               0090               *  program cleanup
2828               0091               ********|*****|*********************|**************************
2829               0092 67BC C20B  18 f18rst  mov   r11,tmp4              ; Save R11
2830               0093                       ;------------------------------------------------------
2831               0094                       ; Reset all F18a VDP registers to power-on defaults
2832               0095                       ;------------------------------------------------------
2833               0096 67BE 06A0  32         bl    @putvr
2834                    67C0 232C
2835               0097 67C2 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
2836               0098
2837               0099 67C4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
2838                    67C6 232C
2839               0100 67C8 391C             data  >391c                 ; Lock the F18a
2840               0101 67CA 0458  20         b     *tmp4                 ; Exit
2841               0102
2842               0103
2843               0104
2844               0105               ***************************************************************
2845               0106               * f18fwv - Get F18A Firmware Version
2846               0107               ***************************************************************
2847               0108               *  bl   @f18fwv
2848               0109               *--------------------------------------------------------------
2849               0110               *  REMARKS
2850               0111               *  Successfully tested with F18A v1.8, note that this does not
2851               0112               *  work with F18 v1.3 but you shouldn't be using such old F18A
2852               0113               *  firmware to begin with.
2853               0114               *--------------------------------------------------------------
2854               0115               *  TMP0 High nibble = major version
2855               0116               *  TMP0 Low nibble  = minor version
2856               0117               *
2857               0118               *  Example: >0018     F18a Firmware v1.8
2858               0119               ********|*****|*********************|**************************
2859               0120 67CC C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
2860               0121 67CE 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
2861                    67D0 2028
2862               0122 67D2 1609  14         jne   f18fw1
2863               0123               ***************************************************************
2864               0124               * Read F18A major/minor version
2865               0125               ***************************************************************
2866               0126 67D4 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
2867                    67D6 8802
2868               0127 67D8 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
2869                    67DA 232C
2870               0128 67DC 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
2871               0129 67DE 04C4  14         clr   tmp0
2872               0130 67E0 D120  34         movb  @vdps,tmp0
2873                    67E2 8802
2874               0131 67E4 0984  56         srl   tmp0,8
2875               0132 67E6 0458  20 f18fw1  b     *tmp4                 ; Exit
2876               **** **** ****     > runlib.asm
2877               0143
2878               0145                       copy  "vdp_hchar.asm"            ; VDP hchar functions
2879               **** **** ****     > vdp_hchar.asm
2880               0001               * FILE......: vdp_hchar.a99
2881               0002               * Purpose...: VDP hchar module
2882               0003
2883               0004               ***************************************************************
2884               0005               * Repeat characters horizontally at YX
2885               0006               ***************************************************************
2886               0007               *  BL    @HCHAR
2887               0008               *  DATA  P0,P1
2888               0009               *  ...
2889               0010               *  DATA  EOL                        ; End-of-list
2890               0011               *--------------------------------------------------------------
2891               0012               *  P0HB = Y position
2892               0013               *  P0LB = X position
2893               0014               *  P1HB = Byte to write
2894               0015               *  P1LB = Number of times to repeat
2895               0016               ********|*****|*********************|**************************
2896               0017 67E8 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
2897                    67EA 832A
2898               0018 67EC D17B  28         movb  *r11+,tmp1
2899               0019 67EE 0985  56 hcharx  srl   tmp1,8                ; Byte to write
2900               0020 67F0 D1BB  28         movb  *r11+,tmp2
2901               0021 67F2 0986  56         srl   tmp2,8                ; Repeat count
2902               0022 67F4 C1CB  18         mov   r11,tmp3
2903               0023 67F6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
2904                    67F8 23F4
2905               0024               *--------------------------------------------------------------
2906               0025               *    Draw line
2907               0026               *--------------------------------------------------------------
2908               0027 67FA 020B  20         li    r11,hchar1
2909                    67FC 278E
2910               0028 67FE 0460  28         b     @xfilv                ; Draw
2911                    6800 228E
2912               0029               *--------------------------------------------------------------
2913               0030               *    Do housekeeping
2914               0031               *--------------------------------------------------------------
2915               0032 6802 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
2916                    6804 202C
2917               0033 6806 1302  14         jeq   hchar2                ; Yes, exit
2918               0034 6808 C2C7  18         mov   tmp3,r11
2919               0035 680A 10EE  14         jmp   hchar                 ; Next one
2920               0036 680C 05C7  14 hchar2  inct  tmp3
2921               0037 680E 0457  20         b     *tmp3                 ; Exit
2922               **** **** ****     > runlib.asm
2923               0147
2924               0151
2925               0155
2926               0159
2927               0163
2928               0167
2929               0171
2930               0175
2931               0177                       copy  "keyb_real.asm"            ; Real Keyboard support
2932               **** **** ****     > keyb_real.asm
2933               0001               * FILE......: keyb_real.asm
2934               0002               * Purpose...: Full (real) keyboard support module
2935               0003
2936               0004               *//////////////////////////////////////////////////////////////
2937               0005               *                     KEYBOARD FUNCTIONS
2938               0006               *//////////////////////////////////////////////////////////////
2939               0007
2940               0008               ***************************************************************
2941               0009               * REALKB - Scan keyboard in real mode
2942               0010               ***************************************************************
2943               0011               *  BL @REALKB
2944               0012               *--------------------------------------------------------------
2945               0013               *  Based on work done by Simon Koppelmann
2946               0014               *  taken from the book "TMS9900 assembler auf dem TI-99/4A"
2947               0015               ********|*****|*********************|**************************
2948               0016 6810 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
2949                    6812 202A
2950               0017 6814 020C  20         li    r12,>0024
2951                    6816 0024
2952               0018 6818 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
2953                    681A 2834
2954               0019 681C 04C6  14         clr   tmp2
2955               0020 681E 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
2956               0021               *--------------------------------------------------------------
2957               0022               * SHIFT key pressed ?
2958               0023               *--------------------------------------------------------------
2959               0024 6820 04CC  14         clr   r12
2960               0025 6822 1F08  20         tb    >0008                 ; Shift-key ?
2961               0026 6824 1302  14         jeq   realk1                ; No
2962               0027 6826 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
2963                    6828 2864
2964               0028               *--------------------------------------------------------------
2965               0029               * FCTN key pressed ?
2966               0030               *--------------------------------------------------------------
2967               0031 682A 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
2968               0032 682C 1302  14         jeq   realk2                ; No
2969               0033 682E 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
2970                    6830 2894
2971               0034               *--------------------------------------------------------------
2972               0035               * CTRL key pressed ?
2973               0036               *--------------------------------------------------------------
2974               0037 6832 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
2975               0038 6834 1302  14         jeq   realk3                ; No
2976               0039 6836 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
2977                    6838 28C4
2978               0040               *--------------------------------------------------------------
2979               0041               * ALPHA LOCK key down ?
2980               0042               *--------------------------------------------------------------
2981               0043 683A 1E15  20 realk3  sbz   >0015                 ; Set P5
2982               0044 683C 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
2983               0045 683E 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
2984               0046 6840 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
2985                    6842 202A
2986               0047               *--------------------------------------------------------------
2987               0048               * Scan keyboard column
2988               0049               *--------------------------------------------------------------
2989               0050 6844 1D15  20 realk4  sbo   >0015                 ; Reset P5
2990               0051 6846 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
2991                    6848 0006
2992               0052 684A 0606  14 realk5  dec   tmp2
2993               0053 684C 020C  20         li    r12,>24               ; CRU address for P2-P4
2994                    684E 0024
2995               0054 6850 06C6  14         swpb  tmp2
2996               0055 6852 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
2997               0056 6854 06C6  14         swpb  tmp2
2998               0057 6856 020C  20         li    r12,6                 ; CRU read address
2999                    6858 0006
3000               0058 685A 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
3001               0059 685C 0547  14         inv   tmp3                  ;
3002               0060 685E 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
3003                    6860 FF00
3004               0061               *--------------------------------------------------------------
3005               0062               * Scan keyboard row
3006               0063               *--------------------------------------------------------------
3007               0064 6862 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
3008               0065 6864 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
3009               0066 6866 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
3010               0067 6868 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
3011               0068 686A 0285  22         ci    tmp1,8
3012                    686C 0008
3013               0069 686E 1AFA  14         jl    realk6
3014               0070 6870 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
3015               0071 6872 1BEB  14         jh    realk5                ; No, next column
3016               0072 6874 1016  14         jmp   realkz                ; Yes, exit
3017               0073               *--------------------------------------------------------------
3018               0074               * Check for match in data table
3019               0075               *--------------------------------------------------------------
3020               0076 6876 C206  18 realk8  mov   tmp2,tmp4
3021               0077 6878 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
3022               0078 687A A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
3023               0079 687C A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
3024               0080 687E D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
3025               0081 6880 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
3026               0082               *--------------------------------------------------------------
3027               0083               * Determine ASCII value of key
3028               0084               *--------------------------------------------------------------
3029               0085 6882 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
3030               0086 6884 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
3031                    6886 202A
3032               0087 6888 1608  14         jne   realka                ; No, continue saving key
3033               0088 688A 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
3034                    688C 285E
3035               0089 688E 1A05  14         jl    realka
3036               0090 6890 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
3037                    6892 285C
3038               0091 6894 1B02  14         jh    realka                ; No, continue
3039               0092 6896 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
3040                    6898 E000
3041               0093 689A C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
3042                    689C 833C
3043               0094 689E E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
3044                    68A0 2014
3045               0095 68A2 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
3046                    68A4 8C00
3047               0096 68A6 045B  20         b     *r11                  ; Exit
3048               0097               ********|*****|*********************|**************************
3049               0098 68A8 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
3050                    68AA 0000
3051                    68AC FF0D
3052                    68AE 203D
3053               0099 68B0 ....             text  'xws29ol.'
3054               0100 68B8 ....             text  'ced38ik,'
3055               0101 68C0 ....             text  'vrf47ujm'
3056               0102 68C8 ....             text  'btg56yhn'
3057               0103 68D0 ....             text  'zqa10p;/'
3058               0104 68D8 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
3059                    68DA 0000
3060                    68DC FF0D
3061                    68DE 202B
3062               0105 68E0 ....             text  'XWS@(OL>'
3063               0106 68E8 ....             text  'CED#*IK<'
3064               0107 68F0 ....             text  'VRF$&UJM'
3065               0108 68F8 ....             text  'BTG%^YHN'
3066               0109 6900 ....             text  'ZQA!)P:-'
3067               0110 6908 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
3068                    690A 0000
3069                    690C FF0D
3070                    690E 2005
3071               0111 6910 0A7E             data  >0a7e,>0804,>0f27,>c2B9
3072                    6912 0804
3073                    6914 0F27
3074                    6916 C2B9
3075               0112 6918 600B             data  >600b,>0907,>063f,>c1B8
3076                    691A 0907
3077                    691C 063F
3078                    691E C1B8
3079               0113 6920 7F5B             data  >7f5b,>7b02,>015f,>c0C3
3080                    6922 7B02
3081                    6924 015F
3082                    6926 C0C3
3083               0114 6928 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
3084                    692A 7D0E
3085                    692C 0CC6
3086                    692E BFC4
3087               0115 6930 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
3088                    6932 7C03
3089                    6934 BC22
3090                    6936 BDBA
3091               0116 6938 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
3092                    693A 0000
3093                    693C FF0D
3094                    693E 209D
3095               0117 6940 9897             data  >9897,>93b2,>9f8f,>8c9B
3096                    6942 93B2
3097                    6944 9F8F
3098                    6946 8C9B
3099               0118 6948 8385             data  >8385,>84b3,>9e89,>8b80
3100                    694A 84B3
3101                    694C 9E89
3102                    694E 8B80
3103               0119 6950 9692             data  >9692,>86b4,>b795,>8a8D
3104                    6952 86B4
3105                    6954 B795
3106                    6956 8A8D
3107               0120 6958 8294             data  >8294,>87b5,>b698,>888E
3108                    695A 87B5
3109                    695C B698
3110                    695E 888E
3111               0121 6960 9A91             data  >9a91,>81b1,>b090,>9cBB
3112                    6962 81B1
3113                    6964 B090
3114                    6966 9CBB
3115               **** **** ****     > runlib.asm
3116               0179
3117               0181                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
3118               **** **** ****     > cpu_hexsupport.asm
3119               0001               * FILE......: cpu_hexsupport.asm
3120               0002               * Purpose...: CPU create, display hex numbers module
3121               0003
3122               0004               ***************************************************************
3123               0005               * mkhex - Convert hex word to string
3124               0006               ***************************************************************
3125               0007               *  bl   @mkhex
3126               0008               *       data P0,P1,P2
3127               0009               *--------------------------------------------------------------
3128               0010               *  P0 = Pointer to 16 bit word
3129               0011               *  P1 = Pointer to string buffer
3130               0012               *  P2 = Offset for ASCII digit
3131               0013               *       MSB determines offset for chars A-F
3132               0014               *       LSB determines offset for chars 0-9
3133               0015               *  (CONFIG#0 = 1) = Display number at cursor YX
3134               0016               *--------------------------------------------------------------
3135               0017               *  Memory usage:
3136               0018               *  tmp0, tmp1, tmp2, tmp3, tmp4
3137               0019               *  waux1, waux2, waux3
3138               0020               *--------------------------------------------------------------
3139               0021               *  Memory variables waux1-waux3 are used as temporary variables
3140               0022               ********|*****|*********************|**************************
3141               0023 6968 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
3142               0024 696A C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
3143                    696C 8340
3144               0025 696E 04E0  34         clr   @waux1
3145                    6970 833C
3146               0026 6972 04E0  34         clr   @waux2
3147                    6974 833E
3148               0027 6976 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
3149                    6978 833C
3150               0028 697A C114  26         mov   *tmp0,tmp0            ; Get word
3151               0029               *--------------------------------------------------------------
3152               0030               *    Convert nibbles to bytes (is in wrong order)
3153               0031               *--------------------------------------------------------------
3154               0032 697C 0205  20         li    tmp1,4                ; 4 nibbles
3155                    697E 0004
3156               0033 6980 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
3157               0034 6982 0246  22         andi  tmp2,>000f            ; Only keep LSN
3158                    6984 000F
3159               0035                       ;------------------------------------------------------
3160               0036                       ; Determine offset for ASCII char
3161               0037                       ;------------------------------------------------------
3162               0038 6986 0286  22         ci    tmp2,>000a
3163                    6988 000A
3164               0039 698A 1105  14         jlt   mkhex1.digit09
3165               0040                       ;------------------------------------------------------
3166               0041                       ; Add ASCII offset for digits A-F
3167               0042                       ;------------------------------------------------------
3168               0043               mkhex1.digitaf:
3169               0044 698C C21B  26         mov   *r11,tmp4
3170               0045 698E 0988  56         srl   tmp4,8                ; Right justify
3171               0046 6990 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
3172                    6992 FFF6
3173               0047 6994 1003  14         jmp   mkhex2
3174               0048
3175               0049               mkhex1.digit09:
3176               0050                       ;------------------------------------------------------
3177               0051                       ; Add ASCII offset for digits 0-9
3178               0052                       ;------------------------------------------------------
3179               0053 6996 C21B  26         mov   *r11,tmp4
3180               0054 6998 0248  22         andi  tmp4,>00ff            ; Only keep LSB
3181                    699A 00FF
3182               0055
3183               0056 699C A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
3184               0057 699E 06C6  14         swpb  tmp2
3185               0058 69A0 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
3186               0059 69A2 0944  56         srl   tmp0,4                ; Next nibble
3187               0060 69A4 0605  14         dec   tmp1
3188               0061 69A6 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
3189               0062 69A8 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
3190                    69AA BFFF
3191               0063               *--------------------------------------------------------------
3192               0064               *    Build first 2 bytes in correct order
3193               0065               *--------------------------------------------------------------
3194               0066 69AC C160  34         mov   @waux3,tmp1           ; Get pointer
3195                    69AE 8340
3196               0067 69B0 04D5  26         clr   *tmp1                 ; Set length byte to 0
3197               0068 69B2 0585  14         inc   tmp1                  ; Next byte, not word!
3198               0069 69B4 C120  34         mov   @waux2,tmp0
3199                    69B6 833E
3200               0070 69B8 06C4  14         swpb  tmp0
3201               0071 69BA DD44  32         movb  tmp0,*tmp1+
3202               0072 69BC 06C4  14         swpb  tmp0
3203               0073 69BE DD44  32         movb  tmp0,*tmp1+
3204               0074               *--------------------------------------------------------------
3205               0075               *    Set length byte
3206               0076               *--------------------------------------------------------------
3207               0077 69C0 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
3208                    69C2 8340
3209               0078 69C4 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
3210                    69C6 2020
3211               0079 69C8 05CB  14         inct  r11                   ; Skip Parameter P2
3212               0080               *--------------------------------------------------------------
3213               0081               *    Build last 2 bytes in correct order
3214               0082               *--------------------------------------------------------------
3215               0083 69CA C120  34         mov   @waux1,tmp0
3216                    69CC 833C
3217               0084 69CE 06C4  14         swpb  tmp0
3218               0085 69D0 DD44  32         movb  tmp0,*tmp1+
3219               0086 69D2 06C4  14         swpb  tmp0
3220               0087 69D4 DD44  32         movb  tmp0,*tmp1+
3221               0088               *--------------------------------------------------------------
3222               0089               *    Display hex number ?
3223               0090               *--------------------------------------------------------------
3224               0091 69D6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
3225                    69D8 202A
3226               0092 69DA 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
3227               0093 69DC 045B  20         b     *r11                  ; Exit
3228               0094               *--------------------------------------------------------------
3229               0095               *  Display hex number on screen at current YX position
3230               0096               *--------------------------------------------------------------
3231               0097 69DE 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
3232                    69E0 7FFF
3233               0098 69E2 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
3234                    69E4 8340
3235               0099 69E6 0460  28         b     @xutst0               ; Display string
3236                    69E8 241A
3237               0100 69EA 0610     prefix  data  >0610                 ; Length byte + blank
3238               0101
3239               0102
3240               0103
3241               0104               ***************************************************************
3242               0105               * puthex - Put 16 bit word on screen
3243               0106               ***************************************************************
3244               0107               *  bl   @mkhex
3245               0108               *       data P0,P1,P2,P3
3246               0109               *--------------------------------------------------------------
3247               0110               *  P0 = YX position
3248               0111               *  P1 = Pointer to 16 bit word
3249               0112               *  P2 = Pointer to string buffer
3250               0113               *  P3 = Offset for ASCII digit
3251               0114               *       MSB determines offset for chars A-F
3252               0115               *       LSB determines offset for chars 0-9
3253               0116               *--------------------------------------------------------------
3254               0117               *  Memory usage:
3255               0118               *  tmp0, tmp1, tmp2, tmp3
3256               0119               *  waux1, waux2, waux3
3257               0120               ********|*****|*********************|**************************
3258               0121 69EC C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
3259                    69EE 832A
3260               0122 69F0 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
3261                    69F2 8000
3262               0123 69F4 10B9  14         jmp   mkhex                 ; Convert number and display
3263               0124
3264               **** **** ****     > runlib.asm
3265               0183
3266               0185                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
3267               **** **** ****     > cpu_numsupport.asm
3268               0001               * FILE......: cpu_numsupport.asm
3269               0002               * Purpose...: CPU create, display numbers module
3270               0003
3271               0004               ***************************************************************
3272               0005               * MKNUM - Convert unsigned number to string
3273               0006               ***************************************************************
3274               0007               *  BL   @MKNUM
3275               0008               *  DATA P0,P1,P2
3276               0009               *
3277               0010               *  P0   = Pointer to 16 bit unsigned number
3278               0011               *  P1   = Pointer to 5 byte string buffer
3279               0012               *  P2HB = Offset for ASCII digit
3280               0013               *  P2LB = Character for replacing leading 0's
3281               0014               *
3282               0015               *  (CONFIG:0 = 1) = Display number at cursor YX
3283               0016               *-------------------------------------------------------------
3284               0017               *  Destroys registers tmp0-tmp4
3285               0018               ********|*****|*********************|**************************
3286               0019 69F6 0207  20 mknum   li    tmp3,5                ; Digit counter
3287                    69F8 0005
3288               0020 69FA C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
3289               0021 69FC C155  26         mov   *tmp1,tmp1            ; /
3290               0022 69FE C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
3291               0023 6A00 0228  22         ai    tmp4,4                ; Get end of buffer
3292                    6A02 0004
3293               0024 6A04 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
3294                    6A06 000A
3295               0025               *--------------------------------------------------------------
3296               0026               *  Do string conversion
3297               0027               *--------------------------------------------------------------
3298               0028 6A08 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
3299               0029 6A0A 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
3300               0030 6A0C 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
3301               0031 6A0E B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
3302               0032 6A10 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
3303               0033 6A12 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
3304               0034 6A14 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
3305               0035 6A16 0607  14         dec   tmp3                  ; Decrease counter
3306               0036 6A18 16F7  14         jne   mknum1                ; Do next digit
3307               0037               *--------------------------------------------------------------
3308               0038               *  Replace leading 0's with fill character
3309               0039               *--------------------------------------------------------------
3310               0040 6A1A 0207  20         li    tmp3,4                ; Check first 4 digits
3311                    6A1C 0004
3312               0041 6A1E 0588  14         inc   tmp4                  ; Too far, back to buffer start
3313               0042 6A20 C11B  26         mov   *r11,tmp0
3314               0043 6A22 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
3315               0044 6A24 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
3316               0045 6A26 1305  14         jeq   mknum4                ; Yes, replace with fill character
3317               0046 6A28 05CB  14 mknum3  inct  r11
3318               0047 6A2A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
3319                    6A2C 202A
3320               0048 6A2E 1305  14         jeq   mknum5                ; Yes, so show at current YX position
3321               0049 6A30 045B  20         b     *r11                  ; Exit
3322               0050 6A32 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
3323               0051 6A34 0607  14         dec   tmp3                  ; 4th digit processed ?
3324               0052 6A36 13F8  14         jeq   mknum3                ; Yes, exit
3325               0053 6A38 10F5  14         jmp   mknum2                ; No, next one
3326               0054               *--------------------------------------------------------------
3327               0055               *  Display integer on screen at current YX position
3328               0056               *--------------------------------------------------------------
3329               0057 6A3A 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
3330                    6A3C 7FFF
3331               0058 6A3E C10B  18         mov   r11,tmp0
3332               0059 6A40 0224  22         ai    tmp0,-4
3333                    6A42 FFFC
3334               0060 6A44 C154  26         mov   *tmp0,tmp1            ; Get buffer address
3335               0061 6A46 0206  20         li    tmp2,>0500            ; String length = 5
3336                    6A48 0500
3337               0062 6A4A 0460  28         b     @xutstr               ; Display string
3338                    6A4C 241C
3339               0063
3340               0064
3341               0065
3342               0066
3343               0067               ***************************************************************
3344               0068               * trimnum - Trim unsigned number string
3345               0069               ***************************************************************
3346               0070               *  bl   @trimnum
3347               0071               *  data p0,p1
3348               0072               *--------------------------------------------------------------
3349               0073               *  p0   = Pointer to 5 byte string buffer (no length byte!)
3350               0074               *  p1   = Pointer to output variable
3351               0075               *  p2   = Padding character to match against
3352               0076               *--------------------------------------------------------------
3353               0077               *  Copy unsigned number string into a length-padded, left
3354               0078               *  justified string for display with putstr, putat, ...
3355               0079               *
3356               0080               *  The new string starts at index 5 in buffer, overwriting
3357               0081               *  anything that is located there !
3358               0082               *
3359               0083               *  Before...:   XXXXX
3360               0084               *  After....:   XXXXX|zY       where length byte z=1
3361               0085               *               XXXXX|zYY      where length byte z=2
3362               0086               *                 ..
3363               0087               *               XXXXX|zYYYYY   where length byte z=5
3364               0088               *--------------------------------------------------------------
3365               0089               *  Destroys registers tmp0-tmp3
3366               0090               ********|*****|*********************|**************************
3367               0091               trimnum:
3368               0092 6A4E C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
3369               0093 6A50 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
3370               0094 6A52 C1BB  30         mov   *r11+,tmp2            ; Get padding character
3371               0095 6A54 06C6  14         swpb  tmp2                  ; LO <-> HI
3372               0096 6A56 0207  20         li    tmp3,5                ; Set counter
3373                    6A58 0005
3374               0097                       ;------------------------------------------------------
3375               0098                       ; Scan for padding character from left to right
3376               0099                       ;------------------------------------------------------:
3377               0100               trimnum_scan:
3378               0101 6A5A 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
3379               0102 6A5C 1604  14         jne   trimnum_setlen        ; No, exit loop
3380               0103 6A5E 0584  14         inc   tmp0                  ; Next character
3381               0104 6A60 0607  14         dec   tmp3                  ; Last digit reached ?
3382               0105 6A62 1301  14         jeq   trimnum_setlen        ; yes, exit loop
3383               0106 6A64 10FA  14         jmp   trimnum_scan
3384               0107                       ;------------------------------------------------------
3385               0108                       ; Scan completed, set length byte new string
3386               0109                       ;------------------------------------------------------
3387               0110               trimnum_setlen:
3388               0111 6A66 06C7  14         swpb  tmp3                  ; LO <-> HI
3389               0112 6A68 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
3390               0113 6A6A 06C7  14         swpb  tmp3                  ; LO <-> HI
3391               0114                       ;------------------------------------------------------
3392               0115                       ; Start filling new string
3393               0116                       ;------------------------------------------------------
3394               0117               trimnum_fill
3395               0118 6A6C DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
3396               0119 6A6E 0607  14         dec   tmp3                  ; Last character ?
3397               0120 6A70 16FD  14         jne   trimnum_fill          ; Not yet, repeat
3398               0121 6A72 045B  20         b     *r11                  ; Return
3399               0122
3400               0123
3401               0124
3402               0125
3403               0126               ***************************************************************
3404               0127               * PUTNUM - Put unsigned number on screen
3405               0128               ***************************************************************
3406               0129               *  BL   @PUTNUM
3407               0130               *  DATA P0,P1,P2,P3
3408               0131               *--------------------------------------------------------------
3409               0132               *  P0   = YX position
3410               0133               *  P1   = Pointer to 16 bit unsigned number
3411               0134               *  P2   = Pointer to 5 byte string buffer
3412               0135               *  P3HB = Offset for ASCII digit
3413               0136               *  P3LB = Character for replacing leading 0's
3414               0137               ********|*****|*********************|**************************
3415               0138 6A74 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
3416                    6A76 832A
3417               0139 6A78 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
3418                    6A7A 8000
3419               0140 6A7C 10BC  14         jmp   mknum                 ; Convert number and display
3420               **** **** ****     > runlib.asm
3421               0187
3422               0191
3423               0195
3424               0199
3425               0203
3426               0205                       copy  "cpu_strings.asm"          ; String utilities support
3427               **** **** ****     > cpu_strings.asm
3428               0001               * FILE......: cpu_strings.asm
3429               0002               * Purpose...: CPU string manipulation library
3430               0003
3431               0004
3432               0005               ***************************************************************
3433               0006               * string.ltrim - Left justify string
3434               0007               ***************************************************************
3435               0008               *  bl   @string.ltrim
3436               0009               *       data p0,p1,p2
3437               0010               *--------------------------------------------------------------
3438               0011               *  P0 = Pointer to length-prefix string
3439               0012               *  P1 = Pointer to RAM work buffer
3440               0013               *  P2 = Fill character
3441               0014               *--------------------------------------------------------------
3442               0015               *  BL   @xstring.ltrim
3443               0016               *
3444               0017               *  TMP0 = Pointer to length-prefix string
3445               0018               *  TMP1 = Pointer to RAM work buffer
3446               0019               *  TMP2 = Fill character
3447               0020               ********|*****|*********************|**************************
3448               0021               string.ltrim:
3449               0022 6A7E 0649  14         dect  stack
3450               0023 6A80 C64B  30         mov   r11,*stack            ; Save return address
3451               0024 6A82 0649  14         dect  stack
3452               0025 6A84 C644  30         mov   tmp0,*stack           ; Push tmp0
3453               0026 6A86 0649  14         dect  stack
3454               0027 6A88 C645  30         mov   tmp1,*stack           ; Push tmp1
3455               0028 6A8A 0649  14         dect  stack
3456               0029 6A8C C646  30         mov   tmp2,*stack           ; Push tmp2
3457               0030 6A8E 0649  14         dect  stack
3458               0031 6A90 C647  30         mov   tmp3,*stack           ; Push tmp3
3459               0032                       ;-----------------------------------------------------------------------
3460               0033                       ; Get parameter values
3461               0034                       ;-----------------------------------------------------------------------
3462               0035 6A92 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
3463               0036 6A94 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
3464               0037 6A96 C1BB  30         mov   *r11+,tmp2            ; Fill character
3465               0038 6A98 100A  14         jmp   !
3466               0039                       ;-----------------------------------------------------------------------
3467               0040                       ; Register version
3468               0041                       ;-----------------------------------------------------------------------
3469               0042               xstring.ltrim:
3470               0043 6A9A 0649  14         dect  stack
3471               0044 6A9C C64B  30         mov   r11,*stack            ; Save return address
3472               0045 6A9E 0649  14         dect  stack
3473               0046 6AA0 C644  30         mov   tmp0,*stack           ; Push tmp0
3474               0047 6AA2 0649  14         dect  stack
3475               0048 6AA4 C645  30         mov   tmp1,*stack           ; Push tmp1
3476               0049 6AA6 0649  14         dect  stack
3477               0050 6AA8 C646  30         mov   tmp2,*stack           ; Push tmp2
3478               0051 6AAA 0649  14         dect  stack
3479               0052 6AAC C647  30         mov   tmp3,*stack           ; Push tmp3
3480               0053                       ;-----------------------------------------------------------------------
3481               0054                       ; Start
3482               0055                       ;-----------------------------------------------------------------------
3483               0056 6AAE C1D4  26 !       mov   *tmp0,tmp3
3484               0057 6AB0 06C7  14         swpb  tmp3                  ; LO <-> HI
3485               0058 6AB2 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
3486                    6AB4 00FF
3487               0059 6AB6 0A86  56         sla   tmp2,8                ; LO -> HI fill character
3488               0060                       ;-----------------------------------------------------------------------
3489               0061                       ; Scan string from left to right and compare with fill character
3490               0062                       ;-----------------------------------------------------------------------
3491               0063               string.ltrim.scan:
3492               0064 6AB8 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
3493               0065 6ABA 1604  14         jne   string.ltrim.move     ; No, now move string left
3494               0066 6ABC 0584  14         inc   tmp0                  ; Next byte
3495               0067 6ABE 0607  14         dec   tmp3                  ; Shorten string length
3496               0068 6AC0 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
3497               0069 6AC2 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
3498               0070                       ;-----------------------------------------------------------------------
3499               0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
3500               0072                       ;-----------------------------------------------------------------------
3501               0073               string.ltrim.move:
3502               0074 6AC4 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
3503               0075 6AC6 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
3504               0076 6AC8 1306  14         jeq   string.ltrim.panic    ; File length assert
3505               0077 6ACA C187  18         mov   tmp3,tmp2
3506               0078 6ACC 06C7  14         swpb  tmp3                  ; HI <-> LO
3507               0079 6ACE DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
3508               0080
3509               0081 6AD0 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
3510                    6AD2 2492
3511               0082                                                   ; tmp1 = Memory target address
3512               0083                                                   ; tmp2 = Number of bytes to copy
3513               0084 6AD4 1004  14         jmp   string.ltrim.exit
3514               0085                       ;-----------------------------------------------------------------------
3515               0086                       ; CPU crash
3516               0087                       ;-----------------------------------------------------------------------
3517               0088               string.ltrim.panic:
3518               0089 6AD6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
3519                    6AD8 FFCE
3520               0090 6ADA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
3521                    6ADC 2030
3522               0091                       ;----------------------------------------------------------------------
3523               0092                       ; Exit
3524               0093                       ;----------------------------------------------------------------------
3525               0094               string.ltrim.exit:
3526               0095 6ADE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
3527               0096 6AE0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
3528               0097 6AE2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
3529               0098 6AE4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
3530               0099 6AE6 C2F9  30         mov   *stack+,r11           ; Pop r11
3531               0100 6AE8 045B  20         b     *r11                  ; Return to caller
3532               0101
3533               0102
3534               0103
3535               0104
3536               0105               ***************************************************************
3537               0106               * string.getlenc - Get length of C-style string
3538               0107               ***************************************************************
3539               0108               *  bl   @string.getlenc
3540               0109               *       data p0,p1
3541               0110               *--------------------------------------------------------------
3542               0111               *  P0 = Pointer to C-style string
3543               0112               *  P1 = String termination character
3544               0113               *--------------------------------------------------------------
3545               0114               *  bl   @xstring.getlenc
3546               0115               *
3547               0116               *  TMP0 = Pointer to C-style string
3548               0117               *  TMP1 = Termination character
3549               0118               *--------------------------------------------------------------
3550               0119               *  OUTPUT:
3551               0120               *  @waux1 = Length of string
3552               0121               ********|*****|*********************|**************************
3553               0122               string.getlenc:
3554               0123 6AEA 0649  14         dect  stack
3555               0124 6AEC C64B  30         mov   r11,*stack            ; Save return address
3556               0125 6AEE 05D9  26         inct  *stack                ; Skip "data P0"
3557               0126 6AF0 05D9  26         inct  *stack                ; Skip "data P1"
3558               0127 6AF2 0649  14         dect  stack
3559               0128 6AF4 C644  30         mov   tmp0,*stack           ; Push tmp0
3560               0129 6AF6 0649  14         dect  stack
3561               0130 6AF8 C645  30         mov   tmp1,*stack           ; Push tmp1
3562               0131 6AFA 0649  14         dect  stack
3563               0132 6AFC C646  30         mov   tmp2,*stack           ; Push tmp2
3564               0133                       ;-----------------------------------------------------------------------
3565               0134                       ; Get parameter values
3566               0135                       ;-----------------------------------------------------------------------
3567               0136 6AFE C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
3568               0137 6B00 C17B  30         mov   *r11+,tmp1            ; String termination character
3569               0138 6B02 1008  14         jmp   !
3570               0139                       ;-----------------------------------------------------------------------
3571               0140                       ; Register version
3572               0141                       ;-----------------------------------------------------------------------
3573               0142               xstring.getlenc:
3574               0143 6B04 0649  14         dect  stack
3575               0144 6B06 C64B  30         mov   r11,*stack            ; Save return address
3576               0145 6B08 0649  14         dect  stack
3577               0146 6B0A C644  30         mov   tmp0,*stack           ; Push tmp0
3578               0147 6B0C 0649  14         dect  stack
3579               0148 6B0E C645  30         mov   tmp1,*stack           ; Push tmp1
3580               0149 6B10 0649  14         dect  stack
3581               0150 6B12 C646  30         mov   tmp2,*stack           ; Push tmp2
3582               0151                       ;-----------------------------------------------------------------------
3583               0152                       ; Start
3584               0153                       ;-----------------------------------------------------------------------
3585               0154 6B14 0A85  56 !       sla   tmp1,8                ; LSB to MSB
3586               0155 6B16 04C6  14         clr   tmp2                  ; Loop counter
3587               0156                       ;-----------------------------------------------------------------------
3588               0157                       ; Scan string for termination character
3589               0158                       ;-----------------------------------------------------------------------
3590               0159               string.getlenc.loop:
3591               0160 6B18 0586  14         inc   tmp2
3592               0161 6B1A 9174  28         cb    *tmp0+,tmp1           ; Compare character
3593               0162 6B1C 1304  14         jeq   string.getlenc.putlength
3594               0163                       ;-----------------------------------------------------------------------
3595               0164                       ; Sanity check on string length
3596               0165                       ;-----------------------------------------------------------------------
3597               0166 6B1E 0286  22         ci    tmp2,255
3598                    6B20 00FF
3599               0167 6B22 1505  14         jgt   string.getlenc.panic
3600               0168 6B24 10F9  14         jmp   string.getlenc.loop
3601               0169                       ;-----------------------------------------------------------------------
3602               0170                       ; Return length
3603               0171                       ;-----------------------------------------------------------------------
3604               0172               string.getlenc.putlength:
3605               0173 6B26 0606  14         dec   tmp2                  ; One time adjustment
3606               0174 6B28 C806  38         mov   tmp2,@waux1           ; Store length
3607                    6B2A 833C
3608               0175 6B2C 1004  14         jmp   string.getlenc.exit   ; Exit
3609               0176                       ;-----------------------------------------------------------------------
3610               0177                       ; CPU crash
3611               0178                       ;-----------------------------------------------------------------------
3612               0179               string.getlenc.panic:
3613               0180 6B2E C80B  38         mov   r11,@>ffce            ; \ Save caller address
3614                    6B30 FFCE
3615               0181 6B32 06A0  32         bl    @cpu.crash            ; / Crash and halt system
3616                    6B34 2030
3617               0182                       ;----------------------------------------------------------------------
3618               0183                       ; Exit
3619               0184                       ;----------------------------------------------------------------------
3620               0185               string.getlenc.exit:
3621               0186 6B36 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
3622               0187 6B38 C179  30         mov   *stack+,tmp1          ; Pop tmp1
3623               0188 6B3A C139  30         mov   *stack+,tmp0          ; Pop tmp0
3624               0189 6B3C C2F9  30         mov   *stack+,r11           ; Pop r11
3625               0190 6B3E 045B  20         b     *r11                  ; Return to caller
3626               **** **** ****     > runlib.asm
3627               0207
3628               0211
3629               0213                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
3630               **** **** ****     > cpu_scrpad_backrest.asm
3631               0001               * FILE......: cpu_scrpad_backrest.asm
3632               0002               * Purpose...: Scratchpad memory backup/restore functions
3633               0003
3634               0004               *//////////////////////////////////////////////////////////////
3635               0005               *                Scratchpad memory backup/restore
3636               0006               *//////////////////////////////////////////////////////////////
3637               0007
3638               0008               ***************************************************************
3639               0009               * cpu.scrpad.backup - Backup scratchpad memory to cpu.scrpad.tgt
3640               0010               ***************************************************************
3641               0011               *  bl   @cpu.scrpad.backup
3642               0012               *--------------------------------------------------------------
3643               0013               *  Register usage
3644               0014               *  r0-r2, but values restored before exit
3645               0015               *--------------------------------------------------------------
3646               0016               *  Backup scratchpad memory to destination range
3647               0017               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
3648               0018               *
3649               0019               *  Expects current workspace to be in scratchpad memory.
3650               0020               ********|*****|*********************|**************************
3651               0021               cpu.scrpad.backup:
3652               0022 6B40 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
3653                    6B42 F000
3654               0023 6B44 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
3655                    6B46 F002
3656               0024 6B48 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
3657                    6B4A F004
3658               0025                       ;------------------------------------------------------
3659               0026                       ; Prepare for copy loop
3660               0027                       ;------------------------------------------------------
3661               0028 6B4C 0200  20         li    r0,>8306              ; Scratpad source address
3662                    6B4E 8306
3663               0029 6B50 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
3664                    6B52 F006
3665               0030 6B54 0202  20         li    r2,62                 ; Loop counter
3666                    6B56 003E
3667               0031                       ;------------------------------------------------------
3668               0032                       ; Copy memory range >8306 - >83ff
3669               0033                       ;------------------------------------------------------
3670               0034               cpu.scrpad.backup.copy:
3671               0035 6B58 CC70  46         mov   *r0+,*r1+
3672               0036 6B5A CC70  46         mov   *r0+,*r1+
3673               0037 6B5C 0642  14         dect  r2
3674               0038 6B5E 16FC  14         jne   cpu.scrpad.backup.copy
3675               0039 6B60 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
3676                    6B62 83FE
3677                    6B64 F0FE
3678               0040                                                   ; Copy last word
3679               0041                       ;------------------------------------------------------
3680               0042                       ; Restore register r0 - r2
3681               0043                       ;------------------------------------------------------
3682               0044 6B66 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
3683                    6B68 F000
3684               0045 6B6A C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
3685                    6B6C F002
3686               0046 6B6E C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
3687                    6B70 F004
3688               0047                       ;------------------------------------------------------
3689               0048                       ; Exit
3690               0049                       ;------------------------------------------------------
3691               0050               cpu.scrpad.backup.exit:
3692               0051 6B72 045B  20         b     *r11                  ; Return to caller
3693               0052
3694               0053
3695               0054               ***************************************************************
3696               0055               * cpu.scrpad.restore - Restore scratchpad memory from cpu.scrpad.tgt
3697               0056               ***************************************************************
3698               0057               *  bl   @cpu.scrpad.restore
3699               0058               *--------------------------------------------------------------
3700               0059               *  Register usage
3701               0060               *  r0-r2, but values restored before exit
3702               0061               *--------------------------------------------------------------
3703               0062               *  Restore scratchpad from memory area
3704               0063               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
3705               0064               *  Current workspace can be outside scratchpad when called.
3706               0065               ********|*****|*********************|**************************
3707               0066               cpu.scrpad.restore:
3708               0067                       ;------------------------------------------------------
3709               0068                       ; Restore scratchpad >8300 - >8304
3710               0069                       ;------------------------------------------------------
3711               0070 6B74 C820  54         mov   @cpu.scrpad.tgt,@>8300
3712                    6B76 F000
3713                    6B78 8300
3714               0071 6B7A C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
3715                    6B7C F002
3716                    6B7E 8302
3717               0072 6B80 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
3718                    6B82 F004
3719                    6B84 8304
3720               0073                       ;------------------------------------------------------
3721               0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
3722               0075                       ;------------------------------------------------------
3723               0076 6B86 C800  38         mov   r0,@cpu.scrpad.tgt
3724                    6B88 F000
3725               0077 6B8A C801  38         mov   r1,@cpu.scrpad.tgt + 2
3726                    6B8C F002
3727               0078 6B8E C802  38         mov   r2,@cpu.scrpad.tgt + 4
3728                    6B90 F004
3729               0079                       ;------------------------------------------------------
3730               0080                       ; Prepare for copy loop, WS
3731               0081                       ;------------------------------------------------------
3732               0082 6B92 0200  20         li    r0,cpu.scrpad.tgt + 6
3733                    6B94 F006
3734               0083 6B96 0201  20         li    r1,>8306
3735                    6B98 8306
3736               0084 6B9A 0202  20         li    r2,62
3737                    6B9C 003E
3738               0085                       ;------------------------------------------------------
3739               0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
3740               0087                       ;------------------------------------------------------
3741               0088               cpu.scrpad.restore.copy:
3742               0089 6B9E CC70  46         mov   *r0+,*r1+
3743               0090 6BA0 CC70  46         mov   *r0+,*r1+
3744               0091 6BA2 0642  14         dect  r2
3745               0092 6BA4 16FC  14         jne   cpu.scrpad.restore.copy
3746               0093 6BA6 C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
3747                    6BA8 F0FE
3748                    6BAA 83FE
3749               0094                                                   ; Copy last word
3750               0095                       ;------------------------------------------------------
3751               0096                       ; Restore register r0 - r2
3752               0097                       ;------------------------------------------------------
3753               0098 6BAC C020  34         mov   @cpu.scrpad.tgt,r0
3754                    6BAE F000
3755               0099 6BB0 C060  34         mov   @cpu.scrpad.tgt + 2,r1
3756                    6BB2 F002
3757               0100 6BB4 C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
3758                    6BB6 F004
3759               0101                       ;------------------------------------------------------
3760               0102                       ; Exit
3761               0103                       ;------------------------------------------------------
3762               0104               cpu.scrpad.restore.exit:
3763               0105 6BB8 045B  20         b     *r11                  ; Return to caller
3764               **** **** ****     > runlib.asm
3765               0214                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
3766               **** **** ****     > cpu_scrpad_paging.asm
3767               0001               * FILE......: cpu_scrpad_paging.asm
3768               0002               * Purpose...: CPU memory paging functions
3769               0003
3770               0004               *//////////////////////////////////////////////////////////////
3771               0005               *                     CPU memory paging
3772               0006               *//////////////////////////////////////////////////////////////
3773               0007
3774               0008
3775               0009               ***************************************************************
3776               0010               * cpu.scrpad.pgout - Page out scratchpad memory
3777               0011               ***************************************************************
3778               0012               *  bl   @cpu.scrpad.pgout
3779               0013               *       DATA p0
3780               0014               *
3781               0015               *  P0 = CPU memory destination
3782               0016               *--------------------------------------------------------------
3783               0017               *  bl   @xcpu.scrpad.pgout
3784               0018               *  TMP1 = CPU memory destination
3785               0019               *--------------------------------------------------------------
3786               0020               *  Register usage
3787               0021               *  tmp0-tmp2 = Used as temporary registers
3788               0022               *  tmp3      = Copy of CPU memory destination
3789               0023               ********|*****|*********************|**************************
3790               0024               cpu.scrpad.pgout:
3791               0025 6BBA C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
3792               0026                       ;------------------------------------------------------
3793               0027                       ; Copy scratchpad memory to destination
3794               0028                       ;------------------------------------------------------
3795               0029               xcpu.scrpad.pgout:
3796               0030 6BBC 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
3797                    6BBE 8300
3798               0031 6BC0 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
3799               0032 6BC2 0206  20         li    tmp2,128              ; tmp2 = Words to copy
3800                    6BC4 0080
3801               0033                       ;------------------------------------------------------
3802               0034                       ; Copy memory
3803               0035                       ;------------------------------------------------------
3804               0036 6BC6 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
3805               0037 6BC8 0606  14         dec   tmp2
3806               0038 6BCA 16FD  14         jne   -!                    ; Loop until done
3807               0039                       ;------------------------------------------------------
3808               0040                       ; Switch to new workspace
3809               0041                       ;------------------------------------------------------
3810               0042 6BCC C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
3811               0043 6BCE 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
3812                    6BD0 2B62
3813               0044                                                   ; R14=PC
3814               0045 6BD2 04CF  14         clr   r15                   ; R15=STATUS
3815               0046                       ;------------------------------------------------------
3816               0047                       ; If we get here, WS was copied to specified
3817               0048                       ; destination.  Also contents of r13,r14,r15
3818               0049                       ; are about to be overwritten by rtwp instruction.
3819               0050                       ;------------------------------------------------------
3820               0051 6BD4 0380  18         rtwp                        ; Activate copied workspace
3821               0052                                                   ; in non-scratchpad memory!
3822               0053
3823               0054               cpu.scrpad.pgout.after.rtwp:
3824               0055 6BD6 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
3825                    6BD8 2B00
3826               0056
3827               0057                       ;------------------------------------------------------
3828               0058                       ; Exit
3829               0059                       ;------------------------------------------------------
3830               0060               cpu.scrpad.pgout.$$:
3831               0061 6BDA 045B  20         b     *r11                  ; Return to caller
3832               0062
3833               0063
3834               0064               ***************************************************************
3835               0065               * cpu.scrpad.pgin - Page in scratchpad memory
3836               0066               ***************************************************************
3837               0067               *  bl   @cpu.scrpad.pgin
3838               0068               *  DATA p0
3839               0069               *  P0 = CPU memory source
3840               0070               *--------------------------------------------------------------
3841               0071               *  bl   @memx.scrpad.pgin
3842               0072               *  TMP1 = CPU memory source
3843               0073               *--------------------------------------------------------------
3844               0074               *  Register usage
3845               0075               *  tmp0-tmp2 = Used as temporary registers
3846               0076               ********|*****|*********************|**************************
3847               0077               cpu.scrpad.pgin:
3848               0078 6BDC C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
3849               0079                       ;------------------------------------------------------
3850               0080                       ; Copy scratchpad memory to destination
3851               0081                       ;------------------------------------------------------
3852               0082               xcpu.scrpad.pgin:
3853               0083 6BDE 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
3854                    6BE0 8300
3855               0084 6BE2 0206  20         li    tmp2,128              ; tmp2 = Words to copy
3856                    6BE4 0080
3857               0085                       ;------------------------------------------------------
3858               0086                       ; Copy memory
3859               0087                       ;------------------------------------------------------
3860               0088 6BE6 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
3861               0089 6BE8 0606  14         dec   tmp2
3862               0090 6BEA 16FD  14         jne   -!                    ; Loop until done
3863               0091                       ;------------------------------------------------------
3864               0092                       ; Switch workspace to scratchpad memory
3865               0093                       ;------------------------------------------------------
3866               0094 6BEC 02E0  18         lwpi  >8300                 ; Activate copied workspace
3867                    6BEE 8300
3868               0095                       ;------------------------------------------------------
3869               0096                       ; Exit
3870               0097                       ;------------------------------------------------------
3871               0098               cpu.scrpad.pgin.$$:
3872               0099 6BF0 045B  20         b     *r11                  ; Return to caller
3873               **** **** ****     > runlib.asm
3874               0216
3875               0218                       copy  "equ_fio.asm"              ; File I/O equates
3876               **** **** ****     > equ_fio.asm
3877               0001               * FILE......: equ_fio.asm
3878               0002               * Purpose...: Equates for file I/O operations
3879               0003
3880               0004               ***************************************************************
3881               0005               * File IO operations
3882               0006               ************************************@**************************
3883               0007      0000     io.op.open       equ >00            ; OPEN
3884               0008      0001     io.op.close      equ >01            ; CLOSE
3885               0009      0002     io.op.read       equ >02            ; READ
3886               0010      0003     io.op.write      equ >03            ; WRITE
3887               0011      0004     io.op.rewind     equ >04            ; RESTORE/REWIND
3888               0012      0005     io.op.load       equ >05            ; LOAD
3889               0013      0006     io.op.save       equ >06            ; SAVE
3890               0014      0007     io.op.delfile    equ >07            ; DELETE FILE
3891               0015      0008     io.op.scratch    equ >08            ; SCRATCH
3892               0016      0009     io.op.status     equ >09            ; STATUS
3893               0017               ***************************************************************
3894               0018               * File types - All relative files are fixed length
3895               0019               ************************************@**************************
3896               0020      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
3897               0021      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
3898               0022      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
3899               0023      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
3900               0024      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
3901               0025      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
3902               0026               ***************************************************************
3903               0027               * File types - Sequential files
3904               0028               ************************************@**************************
3905               0029      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
3906               0030      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
3907               0031      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
3908               0032      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
3909               0033      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
3910               0034      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
3911               0035      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
3912               0036      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
3913               0037      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
3914               0038      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
3915               0039      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
3916               0040      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
3917               0041
3918               0042               ***************************************************************
3919               0043               * File error codes - Bits 13-15 in PAB byte 1
3920               0044               ************************************@**************************
3921               0045      0000     io.err.no_error_occured             equ 0
3922               0046                       ; Error code 0 with condition bit reset, indicates that
3923               0047                       ; no error has occured
3924               0048
3925               0049      0000     io.err.bad_device_name              equ 0
3926               0050                       ; Device indicated not in system
3927               0051                       ; Error code 0 with condition bit set, indicates a
3928               0052                       ; device not present in system
3929               0053
3930               0054      0001     io.err.device_write_prottected      equ 1
3931               0055                       ; Device is write protected
3932               0056
3933               0057      0002     io.err.bad_open_attribute           equ 2
3934               0058                       ; One or more of the OPEN attributes are illegal or do
3935               0059                       ; not match the file's actual characteristics.
3936               0060                       ; This could be:
3937               0061                       ;   * File type
3938               0062                       ;   * Record length
3939               0063                       ;   * I/O mode
3940               0064                       ;   * File organization
3941               0065
3942               0066      0003     io.err.illegal_operation            equ 3
3943               0067                       ; Either an issued I/O command was not supported, or a
3944               0068                       ; conflict with the OPEN mode has occured
3945               0069
3946               0070      0004     io.err.out_of_table_buffer_space    equ 4
3947               0071                       ; The amount of space left on the device is insufficient
3948               0072                       ; for the requested operation
3949               0073
3950               0074      0005     io.err.eof                          equ 5
3951               0075                       ; Attempt to read past end of file.
3952               0076                       ; This error may also be given for non-existing records
3953               0077                       ; in a relative record file
3954               0078
3955               0079      0006     io.err.device_error                 equ 6
3956               0080                       ; Covers all hard device errors, such as parity and
3957               0081                       ; bad medium errors
3958               0082
3959               0083      0007     io.err.file_error                   equ 7
3960               0084                       ; Covers all file-related error like: program/data
3961               0085                       ; file mismatch, non-existing file opened for input mode, etc.
3962               **** **** ****     > runlib.asm
3963               0219                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
3964               **** **** ****     > fio_dsrlnk.asm
3965               0001               * FILE......: fio_dsrlnk.asm
3966               0002               * Purpose...: Custom DSRLNK implementation
3967               0003
3968               0004               *//////////////////////////////////////////////////////////////
3969               0005               *                          DSRLNK
3970               0006               *//////////////////////////////////////////////////////////////
3971               0007
3972               0008
3973               0009               ***************************************************************
3974               0010               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
3975               0011               ***************************************************************
3976               0012               *  blwp @dsrlnk
3977               0013               *  data p0
3978               0014               *--------------------------------------------------------------
3979               0015               *  P0 = 8 or 10 (a)
3980               0016               *--------------------------------------------------------------
3981               0017               *  Output:
3982               0018               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
3983               0019               *--------------------------------------------------------------
3984               0020               ; Spectra2 scratchpad memory needs to be paged out before.
3985               0021               ; You need to specify following equates in main program
3986               0022               ;
3987               0023               ; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
3988               0024               ; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
3989               0025               ;
3990               0026               ; Scratchpad memory usage
3991               0027               ; >8322            Parameter (>08) or (>0A) passed to dsrlnk
3992               0028               ; >8356            Pointer to PAB
3993               0029               ; >83D0            CRU address of current device
3994               0030               ; >83D2            DSR entry address
3995               0031               ; >83e0 - >83ff    GPL / DSRLNK workspace
3996               0032               ;
3997               0033               ; Credits
3998               0034               ; Originally appeared in Miller Graphics The Smart Programmer.
3999               0035               ; This version based on version of Paolo Bagnaresi.
4000               0036               *--------------------------------------------------------------
4001               0037      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
4002               0038                                                   ; dstype is address of R5 of DSRLNK ws
4003               0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
4004               0040               ********|*****|*********************|**************************
4005               0041 6BF2 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
4006               0042 6BF4 2B82             data  dsrlnk.init           ; entry point
4007               0043                       ;------------------------------------------------------
4008               0044                       ; DSRLNK entry point
4009               0045                       ;------------------------------------------------------
4010               0046               dsrlnk.init:
4011               0047 6BF6 C17E  30         mov   *r14+,r5              ; get pgm type for link
4012               0048 6BF8 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
4013                    6BFA 8322
4014               0049 6BFC 53E0  34         szcb  @hb$20,r15            ; reset equal bit
4015                    6BFE 2026
4016               0050 6C00 C020  34         mov   @>8356,r0             ; get ptr to pab
4017                    6C02 8356
4018               0051 6C04 C240  18         mov   r0,r9                 ; save ptr
4019               0052                       ;------------------------------------------------------
4020               0053                       ; Fetch file descriptor length from PAB
4021               0054                       ;------------------------------------------------------
4022               0055 6C06 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
4023                    6C08 FFF8
4024               0056
4025               0057                       ;---------------------------; Inline VSBR start
4026               0058 6C0A 06C0  14         swpb  r0                    ;
4027               0059 6C0C D800  38         movb  r0,@vdpa              ; send low byte
4028                    6C0E 8C02
4029               0060 6C10 06C0  14         swpb  r0                    ;
4030               0061 6C12 D800  38         movb  r0,@vdpa              ; send high byte
4031                    6C14 8C02
4032               0062 6C16 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
4033                    6C18 8800
4034               0063                       ;---------------------------; Inline VSBR end
4035               0064 6C1A 0983  56         srl   r3,8                  ; Move to low byte
4036               0065
4037               0066                       ;------------------------------------------------------
4038               0067                       ; Fetch file descriptor device name from PAB
4039               0068                       ;------------------------------------------------------
4040               0069 6C1C 0704  14         seto  r4                    ; init counter
4041               0070 6C1E 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
4042                    6C20 A420
4043               0071 6C22 0580  14 !       inc   r0                    ; point to next char of name
4044               0072 6C24 0584  14         inc   r4                    ; incr char counter
4045               0073 6C26 0284  22         ci    r4,>0007              ; see if length more than 7 chars
4046                    6C28 0007
4047               0074 6C2A 1565  14         jgt   dsrlnk.error.devicename_invalid
4048               0075                                                   ; yes, error
4049               0076 6C2C 80C4  18         c     r4,r3                 ; end of name?
4050               0077 6C2E 130C  14         jeq   dsrlnk.device_name.get_length
4051               0078                                                   ; yes
4052               0079
4053               0080                       ;---------------------------; Inline VSBR start
4054               0081 6C30 06C0  14         swpb  r0                    ;
4055               0082 6C32 D800  38         movb  r0,@vdpa              ; send low byte
4056                    6C34 8C02
4057               0083 6C36 06C0  14         swpb  r0                    ;
4058               0084 6C38 D800  38         movb  r0,@vdpa              ; send high byte
4059                    6C3A 8C02
4060               0085 6C3C D060  34         movb  @vdpr,r1              ; read byte from VDP ram
4061                    6C3E 8800
4062               0086                       ;---------------------------; Inline VSBR end
4063               0087
4064               0088                       ;------------------------------------------------------
4065               0089                       ; Look for end of device name, for example "DSK1."
4066               0090                       ;------------------------------------------------------
4067               0091 6C40 DC81  32         movb  r1,*r2+               ; move into buffer
4068               0092 6C42 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
4069                    6C44 2C92
4070               0093 6C46 16ED  14         jne   -!                    ; no, loop next char
4071               0094                       ;------------------------------------------------------
4072               0095                       ; Determine device name length
4073               0096                       ;------------------------------------------------------
4074               0097               dsrlnk.device_name.get_length:
4075               0098 6C48 C104  18         mov   r4,r4                 ; Check if length = 0
4076               0099 6C4A 1355  14         jeq   dsrlnk.error.devicename_invalid
4077               0100                                                   ; yes, error
4078               0101 6C4C 04E0  34         clr   @>83d0
4079                    6C4E 83D0
4080               0102 6C50 C804  38         mov   r4,@>8354             ; save name length for search
4081                    6C52 8354
4082               0103 6C54 0584  14         inc   r4                    ; adjust for dot
4083               0104 6C56 A804  38         a     r4,@>8356             ; point to position after name
4084                    6C58 8356
4085               0105                       ;------------------------------------------------------
4086               0106                       ; Prepare for DSR scan >1000 - >1f00
4087               0107                       ;------------------------------------------------------
4088               0108               dsrlnk.dsrscan.start:
4089               0109 6C5A 02E0  18         lwpi  >83e0                 ; Use GPL WS
4090                    6C5C 83E0
4091               0110 6C5E 04C1  14         clr   r1                    ; version found of dsr
4092               0111 6C60 020C  20         li    r12,>0f00             ; init cru addr
4093                    6C62 0F00
4094               0112                       ;------------------------------------------------------
4095               0113                       ; Turn off ROM on current card
4096               0114                       ;------------------------------------------------------
4097               0115               dsrlnk.dsrscan.cardoff:
4098               0116 6C64 C30C  18         mov   r12,r12               ; anything to turn off?
4099               0117 6C66 1301  14         jeq   dsrlnk.dsrscan.cardloop
4100               0118                                                   ; no, loop over cards
4101               0119 6C68 1E00  20         sbz   0                     ; yes, turn off
4102               0120                       ;------------------------------------------------------
4103               0121                       ; Loop over cards and look if DSR present
4104               0122                       ;------------------------------------------------------
4105               0123               dsrlnk.dsrscan.cardloop:
4106               0124 6C6A 022C  22         ai    r12,>0100             ; next rom to turn on
4107                    6C6C 0100
4108               0125 6C6E 04E0  34         clr   @>83d0                ; clear in case we are done
4109                    6C70 83D0
4110               0126 6C72 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
4111                    6C74 2000
4112               0127 6C76 133D  14         jeq   dsrlnk.error.nodsr_found
4113               0128                                                   ; yes, no matching DSR found
4114               0129 6C78 C80C  38         mov   r12,@>83d0            ; save addr of next cru
4115                    6C7A 83D0
4116               0130                       ;------------------------------------------------------
4117               0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
4118               0132                       ;------------------------------------------------------
4119               0133 6C7C 1D00  20         sbo   0                     ; turn on rom
4120               0134 6C7E 0202  20         li    r2,>4000              ; start at beginning of rom
4121                    6C80 4000
4122               0135 6C82 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
4123                    6C84 2C8E
4124               0136 6C86 16EE  14         jne   dsrlnk.dsrscan.cardoff
4125               0137                                                   ; no rom found on card
4126               0138                       ;------------------------------------------------------
4127               0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
4128               0140                       ;------------------------------------------------------
4129               0141                       ; dstype is the address of R5 of the DSRLNK workspace,
4130               0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
4131               0143                       ; is stored before the DSR ROM is searched.
4132               0144                       ;------------------------------------------------------
4133               0145 6C88 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
4134                    6C8A A40A
4135               0146 6C8C 1003  14         jmp   dsrlnk.dsrscan.getentry
4136               0147                       ;------------------------------------------------------
4137               0148                       ; Next DSR entry
4138               0149                       ;------------------------------------------------------
4139               0150               dsrlnk.dsrscan.nextentry:
4140               0151 6C8E C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
4141                    6C90 83D2
4142               0152                                                   ; subprogram
4143               0153
4144               0154 6C92 1D00  20         sbo   0                     ; turn rom back on
4145               0155                       ;------------------------------------------------------
4146               0156                       ; Get DSR entry
4147               0157                       ;------------------------------------------------------
4148               0158               dsrlnk.dsrscan.getentry:
4149               0159 6C94 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
4150               0160 6C96 13E6  14         jeq   dsrlnk.dsrscan.cardoff
4151               0161                                                   ; yes, no more DSRs or programs to check
4152               0162 6C98 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
4153                    6C9A 83D2
4154               0163                                                   ; subprogram
4155               0164
4156               0165 6C9C 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
4157               0166                                                   ; DSR/subprogram code
4158               0167
4159               0168 6C9E C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
4160               0169                                                   ; offset 4 (DSR/subprogram name)
4161               0170                       ;------------------------------------------------------
4162               0171                       ; Check file descriptor in DSR
4163               0172                       ;------------------------------------------------------
4164               0173 6CA0 04C5  14         clr   r5                    ; Remove any old stuff
4165               0174 6CA2 D160  34         movb  @>8355,r5             ; get length as counter
4166                    6CA4 8355
4167               0175 6CA6 130B  14         jeq   dsrlnk.dsrscan.call_dsr
4168               0176                                                   ; if zero, do not further check, call DSR
4169               0177                                                   ; program
4170               0178
4171               0179 6CA8 9C85  32         cb    r5,*r2+               ; see if length matches
4172               0180 6CAA 16F1  14         jne   dsrlnk.dsrscan.nextentry
4173               0181                                                   ; no, length does not match. Go process next
4174               0182                                                   ; DSR entry
4175               0183
4176               0184 6CAC 0985  56         srl   r5,8                  ; yes, move to low byte
4177               0185 6CAE 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
4178                    6CB0 A420
4179               0186 6CB2 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
4180               0187                                                   ; DSR ROM
4181               0188 6CB4 16EC  14         jne   dsrlnk.dsrscan.nextentry
4182               0189                                                   ; try next DSR entry if no match
4183               0190 6CB6 0605  14         dec   r5                    ; loop until full length checked
4184               0191 6CB8 16FC  14         jne   -!
4185               0192                       ;------------------------------------------------------
4186               0193                       ; Device name/Subprogram match
4187               0194                       ;------------------------------------------------------
4188               0195               dsrlnk.dsrscan.match:
4189               0196 6CBA C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
4190                    6CBC 83D2
4191               0197
4192               0198                       ;------------------------------------------------------
4193               0199                       ; Call DSR program in device card
4194               0200                       ;------------------------------------------------------
4195               0201               dsrlnk.dsrscan.call_dsr:
4196               0202 6CBE 0581  14         inc   r1                    ; next version found
4197               0203 6CC0 0699  24         bl    *r9                   ; go run routine
4198               0204                       ;
4199               0205                       ; Depending on IO result the DSR in card ROM does RET
4200               0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
4201               0207                       ;
4202               0208 6CC2 10E5  14         jmp   dsrlnk.dsrscan.nextentry
4203               0209                                                   ; (1) error return
4204               0210 6CC4 1E00  20         sbz   0                     ; (2) turn off rom if good return
4205               0211 6CC6 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
4206                    6CC8 A400
4207               0212 6CCA C009  18         mov   r9,r0                 ; point to flag in pab
4208               0213 6CCC C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
4209                    6CCE 8322
4210               0214                                                   ; (8 or >a)
4211               0215 6CD0 0281  22         ci    r1,8                  ; was it 8?
4212                    6CD2 0008
4213               0216 6CD4 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
4214               0217 6CD6 D060  34         movb  @>8350,r1             ; no, we have a data >a.
4215                    6CD8 8350
4216               0218                                                   ; Get error byte from @>8350
4217               0219 6CDA 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
4218               0220
4219               0221                       ;------------------------------------------------------
4220               0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
4221               0223                       ;------------------------------------------------------
4222               0224               dsrlnk.dsrscan.dsr.8:
4223               0225                       ;---------------------------; Inline VSBR start
4224               0226 6CDC 06C0  14         swpb  r0                    ;
4225               0227 6CDE D800  38         movb  r0,@vdpa              ; send low byte
4226                    6CE0 8C02
4227               0228 6CE2 06C0  14         swpb  r0                    ;
4228               0229 6CE4 D800  38         movb  r0,@vdpa              ; send high byte
4229                    6CE6 8C02
4230               0230 6CE8 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
4231                    6CEA 8800
4232               0231                       ;---------------------------; Inline VSBR end
4233               0232
4234               0233                       ;------------------------------------------------------
4235               0234                       ; Return DSR error to caller
4236               0235                       ;------------------------------------------------------
4237               0236               dsrlnk.dsrscan.dsr.a:
4238               0237 6CEC 09D1  56         srl   r1,13                 ; just keep error bits
4239               0238 6CEE 1604  14         jne   dsrlnk.error.io_error
4240               0239                                                   ; handle IO error
4241               0240 6CF0 0380  18         rtwp                        ; Return from DSR workspace to caller
4242               0241                                                   ; workspace
4243               0242
4244               0243                       ;------------------------------------------------------
4245               0244                       ; IO-error handler
4246               0245                       ;------------------------------------------------------
4247               0246               dsrlnk.error.nodsr_found:
4248               0247 6CF2 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
4249                    6CF4 A400
4250               0248               dsrlnk.error.devicename_invalid:
4251               0249 6CF6 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
4252               0250               dsrlnk.error.io_error:
4253               0251 6CF8 06C1  14         swpb  r1                    ; put error in hi byte
4254               0252 6CFA D741  30         movb  r1,*r13               ; store error flags in callers r0
4255               0253 6CFC F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
4256                    6CFE 2026
4257               0254 6D00 0380  18         rtwp                        ; Return from DSR workspace to caller
4258               0255                                                   ; workspace
4259               0256
4260               0257               ********************************************************************************
4261               0258
4262               0259 6D02 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
4263               0260 6D04 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
4264               0261                                                   ; a @blwp @dsrlnk
4265               0262 6D06 ....     dsrlnk.period     text  '.'         ; For finding end of device name
4266               0263
4267               0264                       even
4268               **** **** ****     > runlib.asm
4269               0220                       copy  "fio_level2.asm"           ; File I/O level 2 support
4270               **** **** ****     > fio_level2.asm
4271               0001               * FILE......: fio_level2.asm
4272               0002               * Purpose...: File I/O level 2 support
4273               0003
4274               0004
4275               0005               ***************************************************************
4276               0006               * PAB  - Peripheral Access Block
4277               0007               ********|*****|*********************|**************************
4278               0008               ; my_pab:
4279               0009               ;       byte  io.op.open            ;  0    - OPEN
4280               0010               ;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
4281               0011               ;                                   ;         Bit 13-15 used by DSR for returning
4282               0012               ;                                   ;         file error details to DSRLNK
4283               0013               ;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
4284               0014               ;       byte  80                    ;  4    - Record length (80 characters maximum)
4285               0015               ;       byte  0                     ;  5    - Character count (bytes read)
4286               0016               ;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
4287               0017               ;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
4288               0018               ; -------------------------------------------------------------
4289               0019               ;       byte  11                    ;  9    - File descriptor length
4290               0020               ;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
4291               0021               ;       even
4292               0022               ***************************************************************
4293               0023
4294               0024
4295               0025               ***************************************************************
4296               0026               * file.open - Open File for procesing
4297               0027               ***************************************************************
4298               0028               *  bl   @file.open
4299               0029               *       data P0
4300               0030               *--------------------------------------------------------------
4301               0031               *  P0 = Address of PAB in VDP RAM
4302               0032               *--------------------------------------------------------------
4303               0033               *  bl   @xfile.open
4304               0034               *
4305               0035               *  R0 = Address of PAB in VDP RAM
4306               0036               *--------------------------------------------------------------
4307               0037               *  Output:
4308               0038               *  tmp0 LSB = VDP PAB byte 1 (status)
4309               0039               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4310               0040               *  tmp2     = Status register contents upon DSRLNK return
4311               0041               ********|*****|*********************|**************************
4312               0042               file.open:
4313               0043 6D08 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4314               0044               *--------------------------------------------------------------
4315               0045               * Initialisation
4316               0046               *--------------------------------------------------------------
4317               0047               xfile.open:
4318               0048 6D0A 04C5  14         clr   tmp1                  ; io.op.open
4319               0049 6D0C 1012  14         jmp   _file.record.fop      ; Do file operation
4320               0050
4321               0051
4322               0052
4323               0053               ***************************************************************
4324               0054               * file.close - Close currently open file
4325               0055               ***************************************************************
4326               0056               *  bl   @file.close
4327               0057               *       data P0
4328               0058               *--------------------------------------------------------------
4329               0059               *  P0 = Address of PAB in VDP RAM
4330               0060               *--------------------------------------------------------------
4331               0061               *  bl   @xfile.close
4332               0062               *
4333               0063               *  R0 = Address of PAB in VDP RAM
4334               0064               *--------------------------------------------------------------
4335               0065               *  Output:
4336               0066               *  tmp0 LSB = VDP PAB byte 1 (status)
4337               0067               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4338               0068               *  tmp2     = Status register contents upon DSRLNK return
4339               0069               ********|*****|*********************|**************************
4340               0070               file.close:
4341               0071 6D0E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4342               0072               *--------------------------------------------------------------
4343               0073               * Initialisation
4344               0074               *--------------------------------------------------------------
4345               0075               xfile.close:
4346               0076 6D10 0205  20         li    tmp1,io.op.close      ; io.op.close
4347                    6D12 0001
4348               0077 6D14 100E  14         jmp   _file.record.fop      ; Do file operation
4349               0078
4350               0079
4351               0080               ***************************************************************
4352               0081               * file.record.read - Read record from file
4353               0082               ***************************************************************
4354               0083               *  bl   @file.record.read
4355               0084               *       data P0
4356               0085               *--------------------------------------------------------------
4357               0086               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
4358               0087               *--------------------------------------------------------------
4359               0088               *  bl   @xfile.record.read
4360               0089               *
4361               0090               *  R0 = Address of PAB in VDP RAM
4362               0091               *--------------------------------------------------------------
4363               0092               *  Output:
4364               0093               *  tmp0 LSB = VDP PAB byte 1 (status)
4365               0094               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4366               0095               *  tmp2     = Status register contents upon DSRLNK return
4367               0096               ********|*****|*********************|**************************
4368               0097               file.record.read:
4369               0098 6D16 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4370               0099               *--------------------------------------------------------------
4371               0100               * Initialisation
4372               0101               *--------------------------------------------------------------
4373               0102 6D18 0205  20         li    tmp1,io.op.read       ; io.op.read
4374                    6D1A 0002
4375               0103 6D1C 100A  14         jmp   _file.record.fop      ; Do file operation
4376               0104
4377               0105
4378               0106
4379               0107               ***************************************************************
4380               0108               * file.record.write - Write record to file
4381               0109               ***************************************************************
4382               0110               *  bl   @file.record.write
4383               0111               *       data P0
4384               0112               *--------------------------------------------------------------
4385               0113               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
4386               0114               *--------------------------------------------------------------
4387               0115               *  bl   @xfile.record.read
4388               0116               *
4389               0117               *  R0 = Address of PAB in VDP RAM
4390               0118               *--------------------------------------------------------------
4391               0119               *  Output:
4392               0120               *  tmp0 LSB = VDP PAB byte 1 (status)
4393               0121               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4394               0122               *  tmp2     = Status register contents upon DSRLNK return
4395               0123               ********|*****|*********************|**************************
4396               0124               file.record.write:
4397               0125 6D1E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4398               0126               *--------------------------------------------------------------
4399               0127               * Initialisation
4400               0128               *--------------------------------------------------------------
4401               0129 6D20 0205  20         li    tmp1,io.op.write      ; io.op.write
4402                    6D22 0003
4403               0130 6D24 1006  14         jmp   _file.record.fop      ; Do file operation
4404               0131
4405               0132
4406               0133
4407               0134               file.record.seek:
4408               0135 6D26 1000  14         nop
4409               0136
4410               0137
4411               0138               file.image.load:
4412               0139 6D28 1000  14         nop
4413               0140
4414               0141
4415               0142               file.image.save:
4416               0143 6D2A 1000  14         nop
4417               0144
4418               0145
4419               0146               file.delete:
4420               0147 6D2C 1000  14         nop
4421               0148
4422               0149
4423               0150               file.rename:
4424               0151 6D2E 1000  14         nop
4425               0152
4426               0153
4427               0154               file.status:
4428               0155 6D30 1000  14         nop
4429               0156
4430               0157
4431               0158
4432               0159               ***************************************************************
4433               0160               * file.record.fop - File operation
4434               0161               ***************************************************************
4435               0162               * Called internally via JMP/B by file operations
4436               0163               *--------------------------------------------------------------
4437               0164               *  Input:
4438               0165               *  r0   = Address of PAB in VDP RAM
4439               0166               *  tmp1 = File operation opcode
4440               0167               *--------------------------------------------------------------
4441               0168               *  Register usage:
4442               0169               *  r0, r1, tmp0, tmp1, tmp2
4443               0170               *--------------------------------------------------------------
4444               0171               *  Remarks
4445               0172               *  Private, only to be called from inside fio_level2 module
4446               0173               *  via jump or branch instruction
4447               0174               ********|*****|*********************|**************************
4448               0175               _file.record.fop:
4449               0176 6D32 C04B  18         mov   r11,r1                ; Save return address
4450               0177 6D34 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
4451                    6D36 A428
4452               0178 6D38 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
4453               0179
4454               0180 6D3A 06A0  32         bl    @xvputb               ; Write file opcode to VDP
4455                    6D3C 22C6
4456               0181                                                   ; \ i  tmp0 = VDP target address
4457               0182                                                   ; / i  tmp1 = Byte to write
4458               0183
4459               0184 6D3E 0220  22         ai    r0,9                  ; Move to file descriptor length
4460                    6D40 0009
4461               0185 6D42 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
4462                    6D44 8356
4463               0186               *--------------------------------------------------------------
4464               0187               * Call DSRLINK for doing file operation
4465               0188               *--------------------------------------------------------------
4466               0189 6D46 0420  54         blwp  @dsrlnk               ; Call DSRLNK
4467                    6D48 2B7E
4468               0190 6D4A 0008             data  8                     ;
4469               0191               *--------------------------------------------------------------
4470               0192               * Return PAB details to caller
4471               0193               *--------------------------------------------------------------
4472               0194               _file.record.fop.pab:
4473               0195 6D4C 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
4474               0196                                                   ; Upon DSRLNK return status register EQ bit
4475               0197                                                   ; 1 = No file error
4476               0198                                                   ; 0 = File error occured
4477               0199               *--------------------------------------------------------------
4478               0200               * Get PAB byte 5 from VDP ram into tmp1 (character count)
4479               0201               *--------------------------------------------------------------
4480               0202 6D4E C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
4481                    6D50 A428
4482               0203 6D52 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
4483                    6D54 0005
4484               0204 6D56 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
4485                    6D58 22DE
4486               0205 6D5A C144  18         mov   tmp0,tmp1             ; Move to destination
4487               0206               *--------------------------------------------------------------
4488               0207               * Get PAB byte 1 from VDP ram into tmp0 (status)
4489               0208               *--------------------------------------------------------------
4490               0209 6D5C C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
4491               0210                                                   ; as returned by DSRLNK
4492               0211               *--------------------------------------------------------------
4493               0212               * Exit
4494               0213               *--------------------------------------------------------------
4495               0214               ; If an error occured during the IO operation, then the
4496               0215               ; equal bit in the saved status register (=tmp2) is set to 1.
4497               0216               ;
4498               0217               ; Upon return from this IO call you should basically test with:
4499               0218               ;       coc   @wbit2,tmp2           ; Equal bit set?
4500               0219               ;       jeq   my_file_io_handler    ; Yes, IO error occured
4501               0220               ;
4502               0221               ; Then look for further details in the copy of VDP PAB byte 1
4503               0222               ; in register tmp0, bits 13-15
4504               0223               ;
4505               0224               ;       srl   tmp0,8                ; Right align (only for DSR type >8
4506               0225               ;                                   ; calls, skip for type >A subprograms!)
4507               0226               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
4508               0227               ;       jeq   my_error_handler
4509               0228               *--------------------------------------------------------------
4510               0229               _file.record.fop.exit:
4511               0230 6D5E 0451  20         b     *r1                   ; Return to caller
4512               **** **** ****     > runlib.asm
4513               0222
4514               0223               *//////////////////////////////////////////////////////////////
4515               0224               *                            TIMERS
4516               0225               *//////////////////////////////////////////////////////////////
4517               0226
4518               0227                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
4519               **** **** ****     > timers_tmgr.asm
4520               0001               * FILE......: timers_tmgr.asm
4521               0002               * Purpose...: Timers / Thread scheduler
4522               0003
4523               0004               ***************************************************************
4524               0005               * TMGR - X - Start Timers/Thread scheduler
4525               0006               ***************************************************************
4526               0007               *  B @TMGR
4527               0008               *--------------------------------------------------------------
4528               0009               *  REMARKS
4529               0010               *  Timer/Thread scheduler. Normally called from MAIN.
4530               0011               *  This is basically the kernel keeping everything togehter.
4531               0012               *  Do not forget to set BTIHI to highest slot in use.
4532               0013               *
4533               0014               *  Register usage in TMGR8 - TMGR11
4534               0015               *  TMP0  = Pointer to timer table
4535               0016               *  R10LB = Use as slot counter
4536               0017               *  TMP2  = 2nd word of slot data
4537               0018               *  TMP3  = Address of routine to call
4538               0019               ********|*****|*********************|**************************
4539               0020 6D60 0300  24 tmgr    limi  0                     ; No interrupt processing
4540                    6D62 0000
4541               0021               *--------------------------------------------------------------
4542               0022               * Read VDP status register
4543               0023               *--------------------------------------------------------------
4544               0024 6D64 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
4545                    6D66 8802
4546               0025               *--------------------------------------------------------------
4547               0026               * Latch sprite collision flag
4548               0027               *--------------------------------------------------------------
4549               0028 6D68 2360  38         coc   @wbit2,r13            ; C flag on ?
4550                    6D6A 2026
4551               0029 6D6C 1602  14         jne   tmgr1a                ; No, so move on
4552               0030 6D6E E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
4553                    6D70 2012
4554               0031               *--------------------------------------------------------------
4555               0032               * Interrupt flag
4556               0033               *--------------------------------------------------------------
4557               0034 6D72 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
4558                    6D74 202A
4559               0035 6D76 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
4560               0036               *--------------------------------------------------------------
4561               0037               * Run speech player
4562               0038               *--------------------------------------------------------------
4563               0044               *--------------------------------------------------------------
4564               0045               * Run kernel thread
4565               0046               *--------------------------------------------------------------
4566               0047 6D78 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
4567                    6D7A 201A
4568               0048 6D7C 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
4569               0049 6D7E 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
4570                    6D80 2018
4571               0050 6D82 1602  14         jne   tmgr3                 ; No, skip to user hook
4572               0051 6D84 0460  28         b     @kthread              ; Run kernel thread
4573                    6D86 2D8A
4574               0052               *--------------------------------------------------------------
4575               0053               * Run user hook
4576               0054               *--------------------------------------------------------------
4577               0055 6D88 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
4578                    6D8A 201E
4579               0056 6D8C 13EB  14         jeq   tmgr1
4580               0057 6D8E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
4581                    6D90 201C
4582               0058 6D92 16E8  14         jne   tmgr1
4583               0059 6D94 C120  34         mov   @wtiusr,tmp0
4584                    6D96 832E
4585               0060 6D98 0454  20         b     *tmp0                 ; Run user hook
4586               0061               *--------------------------------------------------------------
4587               0062               * Do internal housekeeping
4588               0063               *--------------------------------------------------------------
4589               0064 6D9A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
4590                    6D9C 2D88
4591               0065 6D9E C10A  18         mov   r10,tmp0
4592               0066 6DA0 0244  22         andi  tmp0,>00ff            ; Clear HI byte
4593                    6DA2 00FF
4594               0067 6DA4 20A0  38         coc   @wbit2,config         ; PAL flag set ?
4595                    6DA6 2026
4596               0068 6DA8 1303  14         jeq   tmgr5
4597               0069 6DAA 0284  22         ci    tmp0,60               ; 1 second reached ?
4598                    6DAC 003C
4599               0070 6DAE 1002  14         jmp   tmgr6
4600               0071 6DB0 0284  22 tmgr5   ci    tmp0,50
4601                    6DB2 0032
4602               0072 6DB4 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
4603               0073 6DB6 1001  14         jmp   tmgr8
4604               0074 6DB8 058A  14 tmgr7   inc   r10                   ; Increase tick counter
4605               0075               *--------------------------------------------------------------
4606               0076               * Loop over slots
4607               0077               *--------------------------------------------------------------
4608               0078 6DBA C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
4609                    6DBC 832C
4610               0079 6DBE 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
4611                    6DC0 FF00
4612               0080 6DC2 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
4613               0081 6DC4 1316  14         jeq   tmgr11                ; Yes, get next slot
4614               0082               *--------------------------------------------------------------
4615               0083               *  Check if slot should be executed
4616               0084               *--------------------------------------------------------------
4617               0085 6DC6 05C4  14         inct  tmp0                  ; Second word of slot data
4618               0086 6DC8 0594  26         inc   *tmp0                 ; Update tick count in slot
4619               0087 6DCA C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
4620               0088 6DCC 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
4621                    6DCE 830C
4622                    6DD0 830D
4623               0089 6DD2 1608  14         jne   tmgr10                ; No, get next slot
4624               0090 6DD4 0246  22         andi  tmp2,>ff00            ; Clear internal counter
4625                    6DD6 FF00
4626               0091 6DD8 C506  30         mov   tmp2,*tmp0            ; Update timer table
4627               0092               *--------------------------------------------------------------
4628               0093               *  Run slot, we only need TMP0 to survive
4629               0094               *--------------------------------------------------------------
4630               0095 6DDA C804  38         mov   tmp0,@wtitmp          ; Save TMP0
4631                    6DDC 8330
4632               0096 6DDE 0697  24         bl    *tmp3                 ; Call routine in slot
4633               0097 6DE0 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
4634                    6DE2 8330
4635               0098               *--------------------------------------------------------------
4636               0099               *  Prepare for next slot
4637               0100               *--------------------------------------------------------------
4638               0101 6DE4 058A  14 tmgr10  inc   r10                   ; Next slot
4639               0102 6DE6 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
4640                    6DE8 8315
4641                    6DEA 8314
4642               0103 6DEC 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
4643               0104 6DEE 05C4  14         inct  tmp0                  ; Offset for next slot
4644               0105 6DF0 10E8  14         jmp   tmgr9                 ; Process next slot
4645               0106 6DF2 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
4646               0107 6DF4 10F7  14         jmp   tmgr10                ; Process next slot
4647               0108 6DF6 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
4648                    6DF8 FF00
4649               0109 6DFA 10B4  14         jmp   tmgr1
4650               0110 6DFC 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
4651               0111
4652               **** **** ****     > runlib.asm
4653               0228                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
4654               **** **** ****     > timers_kthread.asm
4655               0001               * FILE......: timers_kthread.asm
4656               0002               * Purpose...: Timers / The kernel thread
4657               0003
4658               0004
4659               0005               ***************************************************************
4660               0006               * KTHREAD - The kernel thread
4661               0007               *--------------------------------------------------------------
4662               0008               *  REMARKS
4663               0009               *  You should not call the kernel thread manually.
4664               0010               *  Instead control it via the CONFIG register.
4665               0011               *
4666               0012               *  The kernel thread is responsible for running the sound
4667               0013               *  player and doing keyboard scan.
4668               0014               ********|*****|*********************|**************************
4669               0015 6DFE E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
4670                    6E00 201A
4671               0016               *--------------------------------------------------------------
4672               0017               * Run sound player
4673               0018               *--------------------------------------------------------------
4674               0020               *       <<skipped>>
4675               0026               *--------------------------------------------------------------
4676               0027               * Scan virtual keyboard
4677               0028               *--------------------------------------------------------------
4678               0029               kthread_kb
4679               0031               *       <<skipped>>
4680               0035               *--------------------------------------------------------------
4681               0036               * Scan real keyboard
4682               0037               *--------------------------------------------------------------
4683               0041 6E02 06A0  32         bl    @realkb               ; Scan full keyboard
4684                    6E04 279C
4685               0043               *--------------------------------------------------------------
4686               0044               kthread_exit
4687               0045 6E06 0460  28         b     @tmgr3                ; Exit
4688                    6E08 2D14
4689               **** **** ****     > runlib.asm
4690               0229                       copy  "timers_hooks.asm"         ; Timers / User hooks
4691               **** **** ****     > timers_hooks.asm
4692               0001               * FILE......: timers_kthread.asm
4693               0002               * Purpose...: Timers / User hooks
4694               0003
4695               0004
4696               0005               ***************************************************************
4697               0006               * MKHOOK - Allocate user hook
4698               0007               ***************************************************************
4699               0008               *  BL    @MKHOOK
4700               0009               *  DATA  P0
4701               0010               *--------------------------------------------------------------
4702               0011               *  P0 = Address of user hook
4703               0012               *--------------------------------------------------------------
4704               0013               *  REMARKS
4705               0014               *  The user hook gets executed after the kernel thread.
4706               0015               *  The user hook must always exit with "B @HOOKOK"
4707               0016               ********|*****|*********************|**************************
4708               0017 6E0A C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
4709                    6E0C 832E
4710               0018 6E0E E0A0  34         soc   @wbit7,config         ; Enable user hook
4711                    6E10 201C
4712               0019 6E12 045B  20 mkhoo1  b     *r11                  ; Return
4713               0020      2CF0     hookok  equ   tmgr1                 ; Exit point for user hook
4714               0021
4715               0022
4716               0023               ***************************************************************
4717               0024               * CLHOOK - Clear user hook
4718               0025               ***************************************************************
4719               0026               *  BL    @CLHOOK
4720               0027               ********|*****|*********************|**************************
4721               0028 6E14 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
4722                    6E16 832E
4723               0029 6E18 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
4724                    6E1A FEFF
4725               0030 6E1C 045B  20         b     *r11                  ; Return
4726               **** **** ****     > runlib.asm
4727               0230
4728               0232                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
4729               **** **** ****     > timers_alloc.asm
4730               0001               * FILE......: timer_alloc.asm
4731               0002               * Purpose...: Timers / Timer allocation
4732               0003
4733               0004
4734               0005               ***************************************************************
4735               0006               * MKSLOT - Allocate timer slot(s)
4736               0007               ***************************************************************
4737               0008               *  BL    @MKSLOT
4738               0009               *  BYTE  P0HB,P0LB
4739               0010               *  DATA  P1
4740               0011               *  ....
4741               0012               *  DATA  EOL                        ; End-of-list
4742               0013               *--------------------------------------------------------------
4743               0014               *  P0 = Slot number, target count
4744               0015               *  P1 = Subroutine to call via BL @xxxx if slot is fired
4745               0016               ********|*****|*********************|**************************
4746               0017 6E1E C13B  30 mkslot  mov   *r11+,tmp0
4747               0018 6E20 C17B  30         mov   *r11+,tmp1
4748               0019               *--------------------------------------------------------------
4749               0020               *  Calculate address of slot
4750               0021               *--------------------------------------------------------------
4751               0022 6E22 C184  18         mov   tmp0,tmp2
4752               0023 6E24 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
4753               0024 6E26 A1A0  34         a     @wtitab,tmp2          ; Add table base
4754                    6E28 832C
4755               0025               *--------------------------------------------------------------
4756               0026               *  Add slot to table
4757               0027               *--------------------------------------------------------------
4758               0028 6E2A CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
4759               0029 6E2C 0A84  56         sla   tmp0,8                ; Get rid of slot number
4760               0030 6E2E C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
4761               0031               *--------------------------------------------------------------
4762               0032               *  Check for end of list
4763               0033               *--------------------------------------------------------------
4764               0034 6E30 881B  46         c     *r11,@w$ffff          ; End of list ?
4765                    6E32 202C
4766               0035 6E34 1301  14         jeq   mkslo1                ; Yes, exit
4767               0036 6E36 10F3  14         jmp   mkslot                ; Process next entry
4768               0037               *--------------------------------------------------------------
4769               0038               *  Exit
4770               0039               *--------------------------------------------------------------
4771               0040 6E38 05CB  14 mkslo1  inct  r11
4772               0041 6E3A 045B  20         b     *r11                  ; Exit
4773               0042
4774               0043
4775               0044               ***************************************************************
4776               0045               * CLSLOT - Clear single timer slot
4777               0046               ***************************************************************
4778               0047               *  BL    @CLSLOT
4779               0048               *  DATA  P0
4780               0049               *--------------------------------------------------------------
4781               0050               *  P0 = Slot number
4782               0051               ********|*****|*********************|**************************
4783               0052 6E3C C13B  30 clslot  mov   *r11+,tmp0
4784               0053 6E3E 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
4785               0054 6E40 A120  34         a     @wtitab,tmp0          ; Add table base
4786                    6E42 832C
4787               0055 6E44 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
4788               0056 6E46 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
4789               0057 6E48 045B  20         b     *r11                  ; Exit
4790               0058
4791               0059
4792               0060               ***************************************************************
4793               0061               * RSSLOT - Reset single timer slot loop counter
4794               0062               ***************************************************************
4795               0063               *  BL    @RSSLOT
4796               0064               *  DATA  P0
4797               0065               *--------------------------------------------------------------
4798               0066               *  P0 = Slot number
4799               0067               ********|*****|*********************|**************************
4800               0068 6E4A C13B  30 rsslot  mov   *r11+,tmp0
4801               0069 6E4C 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
4802               0070 6E4E A120  34         a     @wtitab,tmp0          ; Add table base
4803                    6E50 832C
4804               0071 6E52 05C4  14         inct  tmp0                  ; Skip 1st word of slot
4805               0072 6E54 C154  26         mov   *tmp0,tmp1
4806               0073 6E56 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
4807                    6E58 FF00
4808               0074 6E5A C505  30         mov   tmp1,*tmp0
4809               0075 6E5C 045B  20         b     *r11                  ; Exit
4810               **** **** ****     > runlib.asm
4811               0234
4812               0235
4813               0236
4814               0237               *//////////////////////////////////////////////////////////////
4815               0238               *                    RUNLIB INITIALISATION
4816               0239               *//////////////////////////////////////////////////////////////
4817               0240
4818               0241               ***************************************************************
4819               0242               *  RUNLIB - Runtime library initalisation
4820               0243               ***************************************************************
4821               0244               *  B  @RUNLIB
4822               0245               *--------------------------------------------------------------
4823               0246               *  REMARKS
4824               0247               *  if R0 in WS1 equals >4a4a we were called from the system
4825               0248               *  crash handler so we return there after initialisation.
4826               0249
4827               0250               *  If R1 in WS1 equals >FFFF we return to the TI title screen
4828               0251               *  after clearing scratchpad memory. This has higher priority
4829               0252               *  as crash handler flag R0.
4830               0253               ********|*****|*********************|**************************
4831               0255 6E5E 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
4832                    6E60 2ACC
4833               0256                                                   ; @cpu.scrpad.tgt (>00..>ff)
4834               0257
4835               0258 6E62 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
4836                    6E64 8302
4837               0262               *--------------------------------------------------------------
4838               0263               * Alternative entry point
4839               0264               *--------------------------------------------------------------
4840               0265 6E66 0300  24 runli1  limi  0                     ; Turn off interrupts
4841                    6E68 0000
4842               0266 6E6A 02E0  18         lwpi  ws1                   ; Activate workspace 1
4843                    6E6C 8300
4844               0267 6E6E C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
4845                    6E70 83C0
4846               0268               *--------------------------------------------------------------
4847               0269               * Clear scratch-pad memory from R4 upwards
4848               0270               *--------------------------------------------------------------
4849               0271 6E72 0202  20 runli2  li    r2,>8308
4850                    6E74 8308
4851               0272 6E76 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
4852               0273 6E78 0282  22         ci    r2,>8400
4853                    6E7A 8400
4854               0274 6E7C 16FC  14         jne   runli3
4855               0275               *--------------------------------------------------------------
4856               0276               * Exit to TI-99/4A title screen ?
4857               0277               *--------------------------------------------------------------
4858               0278 6E7E 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
4859                    6E80 FFFF
4860               0279 6E82 1602  14         jne   runli4                ; No, continue
4861               0280 6E84 0420  54         blwp  @0                    ; Yes, bye bye
4862                    6E86 0000
4863               0281               *--------------------------------------------------------------
4864               0282               * Determine if VDP is PAL or NTSC
4865               0283               *--------------------------------------------------------------
4866               0284 6E88 C803  38 runli4  mov   r3,@waux1             ; Store random seed
4867                    6E8A 833C
4868               0285 6E8C 04C1  14         clr   r1                    ; Reset counter
4869               0286 6E8E 0202  20         li    r2,10                 ; We test 10 times
4870                    6E90 000A
4871               0287 6E92 C0E0  34 runli5  mov   @vdps,r3
4872                    6E94 8802
4873               0288 6E96 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
4874                    6E98 202A
4875               0289 6E9A 1302  14         jeq   runli6
4876               0290 6E9C 0581  14         inc   r1                    ; Increase counter
4877               0291 6E9E 10F9  14         jmp   runli5
4878               0292 6EA0 0602  14 runli6  dec   r2                    ; Next test
4879               0293 6EA2 16F7  14         jne   runli5
4880               0294 6EA4 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
4881                    6EA6 1250
4882               0295 6EA8 1202  14         jle   runli7                ; No, so it must be NTSC
4883               0296 6EAA 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
4884                    6EAC 2026
4885               0297               *--------------------------------------------------------------
4886               0298               * Copy machine code to scratchpad (prepare tight loop)
4887               0299               *--------------------------------------------------------------
4888               0300 6EAE 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
4889                    6EB0 221A
4890               0301 6EB2 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
4891                    6EB4 8322
4892               0302 6EB6 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
4893               0303 6EB8 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
4894               0304 6EBA CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
4895               0305               *--------------------------------------------------------------
4896               0306               * Initialize registers, memory, ...
4897               0307               *--------------------------------------------------------------
4898               0308 6EBC 04C1  14 runli9  clr   r1
4899               0309 6EBE 04C2  14         clr   r2
4900               0310 6EC0 04C3  14         clr   r3
4901               0311 6EC2 0209  20         li    stack,>8400           ; Set stack
4902                    6EC4 8400
4903               0312 6EC6 020F  20         li    r15,vdpw              ; Set VDP write address
4904                    6EC8 8C00
4905               0316               *--------------------------------------------------------------
4906               0317               * Setup video memory
4907               0318               *--------------------------------------------------------------
4908               0320 6ECA 0280  22         ci    r0,>4a4a              ; Crash flag set?
4909                    6ECC 4A4A
4910               0321 6ECE 1605  14         jne   runlia
4911               0322 6ED0 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
4912                    6ED2 2288
4913               0323 6ED4 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
4914                    6ED6 0000
4915                    6ED8 3FFF
4916               0328 6EDA 06A0  32 runlia  bl    @filv
4917                    6EDC 2288
4918               0329 6EDE 0FC0             data  pctadr,spfclr,16      ; Load color table
4919                    6EE0 00F4
4920                    6EE2 0010
4921               0330               *--------------------------------------------------------------
4922               0331               * Check if there is a F18A present
4923               0332               *--------------------------------------------------------------
4924               0336 6EE4 06A0  32         bl    @f18unl               ; Unlock the F18A
4925                    6EE6 26E4
4926               0337 6EE8 06A0  32         bl    @f18chk               ; Check if F18A is there
4927                    6EEA 26FE
4928               0338 6EEC 06A0  32         bl    @f18lck               ; Lock the F18A again
4929                    6EEE 26F4
4930               0339
4931               0340 6EF0 06A0  32         bl    @putvr                ; Reset all F18a extended registers
4932                    6EF2 232C
4933               0341 6EF4 3201                   data >3201            ; F18a VR50 (>32), bit 1
4934               0343               *--------------------------------------------------------------
4935               0344               * Check if there is a speech synthesizer attached
4936               0345               *--------------------------------------------------------------
4937               0347               *       <<skipped>>
4938               0351               *--------------------------------------------------------------
4939               0352               * Load video mode table & font
4940               0353               *--------------------------------------------------------------
4941               0354 6EF6 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
4942                    6EF8 22F2
4943               0355 6EFA 3008             data  spvmod                ; Equate selected video mode table
4944               0356 6EFC 0204  20         li    tmp0,spfont           ; Get font option
4945                    6EFE 000C
4946               0357 6F00 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
4947               0358 6F02 1304  14         jeq   runlid                ; Yes, skip it
4948               0359 6F04 06A0  32         bl    @ldfnt
4949                    6F06 235A
4950               0360 6F08 1100             data  fntadr,spfont         ; Load specified font
4951                    6F0A 000C
4952               0361               *--------------------------------------------------------------
4953               0362               * Did a system crash occur before runlib was called?
4954               0363               *--------------------------------------------------------------
4955               0364 6F0C 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
4956                    6F0E 4A4A
4957               0365 6F10 1602  14         jne   runlie                ; No, continue
4958               0366 6F12 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
4959                    6F14 2090
4960               0367               *--------------------------------------------------------------
4961               0368               * Branch to main program
4962               0369               *--------------------------------------------------------------
4963               0370 6F16 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
4964                    6F18 0040
4965               0371 6F1A 0460  28         b     @main                 ; Give control to main program
4966                    6F1C 3000
4967               **** **** ****     > stevie_b0.asm.22608
4968               0100                                                   ; Spectra 2
4969               0101                       ;------------------------------------------------------
4970               0102                       ; End of File marker
4971               0103                       ;------------------------------------------------------
4972               0104 6F1E DEAD             data  >dead,>beef,>dead,>beef
4973                    6F20 BEEF
4974                    6F22 DEAD
4975                    6F24 BEEF
4976               0106 6F26 ....             bss  300                    ; Fill remaining space with >00
4977               0107
4978               0108
4979               0109
4980               0110
4981               0111               ***************************************************************
4982               0112               * Code data: Relocated Stevie modules >3000 - >3fff (4K maximum)
4983               0113               ********|*****|*********************|**************************
4984               0114               reloc.stevie:
4985               0115                       xorg  >3000                 ; Relocate Stevie modules to >3000
4986               0116                       ;------------------------------------------------------
4987               0117                       ; Activate bank 1 and branch to >6036
4988               0118                       ;------------------------------------------------------
4989               0119               main:
4990               0120 7052 04E0  34         clr   @>6002                ; Activate bank 1 (2nd bank!)
4991                    7054 6002
4992               0121 7056 0460  28         b     @kickstart.code2      ; Jump to entry routine
4993                    7058 6036
4994               0122                       ;------------------------------------------------------
4995               0123                       ; Resident Stevie modules >3000 - >3fff
4996               0124                       ;------------------------------------------------------
4997               0125                       copy  "data.constants.asm"  ; Data Constants
4998               **** **** ****     > data.constants.asm
4999               0001               * FILE......: data.constants.asm
5000               0002               * Purpose...: Stevie Editor - data segment (constants)
5001               0003
5002               0004               ***************************************************************
5003               0005               *                      Constants
5004               0006               ********|*****|*********************|**************************
5005               0007
5006               0008
5007               0009               ***************************************************************
5008               0010               * Textmode (80 columns, 30 rows) - F18A
5009               0011               *--------------------------------------------------------------
5010               0012               *
5011               0013               * ; VDP#0 Control bits
5012               0014               * ;      bit 6=0: M3 | Graphics 1 mode
5013               0015               * ;      bit 7=0: Disable external VDP input
5014               0016               * ; VDP#1 Control bits
5015               0017               * ;      bit 0=1: 16K selection
5016               0018               * ;      bit 1=1: Enable display
5017               0019               * ;      bit 2=1: Enable VDP interrupt
5018               0020               * ;      bit 3=1: M1 \ TEXT MODE
5019               0021               * ;      bit 4=0: M2 /
5020               0022               * ;      bit 5=0: reserved
5021               0023               * ;      bit 6=0: 8x8 sprites
5022               0024               * ;      bit 7=0: Sprite magnification (1x)
5023               0025               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
5024               0026               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
5025               0027               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
5026               0028               * ; VDP#5 SAT (sprite attribute list)    at >2180  (>43 * >080)
5027               0029               * ; VDP#6 SPT (Sprite pattern table)     at >2800  (>05 * >800)
5028               0030               * ; VDP#7 Set foreground/background color
5029               0031               ***************************************************************
5030               0032               stevie.tx8030:
5031               0033 705A 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
5032                    705C 003F
5033                    705E 0243
5034                    7060 05F4
5035                    7062 0050
5036               0034
5037               0035               romsat:
5038               0036 7064 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
5039                    7066 0001
5040               0037
5041               0038               cursors:
5042               0039 7068 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
5043                    706A 0000
5044                    706C 0000
5045                    706E 001C
5046               0040 7070 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 2 - Insert mode
5047                    7072 1C1C
5048                    7074 1C1C
5049                    7076 1C00
5050               0041 7078 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
5051                    707A 1C1C
5052                    707C 1C1C
5053                    707E 1C00
5054               0042
5055               0043               patterns:
5056               0044 7080 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
5057                    7082 0000
5058                    7084 00FF
5059                    7086 0000
5060               0045 7088 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
5061                    708A 0000
5062                    708C FF00
5063                    708E FF00
5064               0046               patterns.box:
5065               0047 7090 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
5066                    7092 0000
5067                    7094 FF00
5068                    7096 FF00
5069               0048 7098 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
5070                    709A 0000
5071                    709C FF80
5072                    709E BFA0
5073               0049 70A0 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
5074                    70A2 0000
5075                    70A4 FC04
5076                    70A6 F414
5077               0050 70A8 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
5078                    70AA A0A0
5079                    70AC A0A0
5080                    70AE A0A0
5081               0051 70B0 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
5082                    70B2 1414
5083                    70B4 1414
5084                    70B6 1414
5085               0052 70B8 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
5086                    70BA A0A0
5087                    70BC BF80
5088                    70BE FF00
5089               0053 70C0 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
5090                    70C2 1414
5091                    70C4 F404
5092                    70C6 FC00
5093               0054 70C8 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
5094                    70CA C0C0
5095                    70CC C0C0
5096                    70CE 0080
5097               0055 70D0 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
5098                    70D2 0F0F
5099                    70D4 0F0F
5100                    70D6 0000
5101               0056
5102               0057
5103               0058
5104               0059
5105               0060               ***************************************************************
5106               0061               * SAMS page layout table for Stevie (16 words)
5107               0062               *--------------------------------------------------------------
5108               0063               mem.sams.layout.data:
5109               0064 70D8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
5110                    70DA 0002
5111               0065 70DC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
5112                    70DE 0003
5113               0066 70E0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
5114                    70E2 000A
5115               0067
5116               0068 70E4 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
5117                    70E6 0010
5118               0069                                                   ; \ The index can allocate
5119               0070                                                   ; / pages >10 to >2f.
5120               0071
5121               0072 70E8 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
5122                    70EA 0030
5123               0073                                                   ; \ Editor buffer can allocate
5124               0074                                                   ; / pages >30 to >ff.
5125               0075
5126               0076 70EC D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
5127                    70EE 000D
5128               0077 70F0 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
5129                    70F2 000E
5130               0078 70F4 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
5131                    70F6 000F
5132               0079
5133               0080
5134               0081
5135               0082
5136               0083
5137               0084               ***************************************************************
5138               0085               * Stevie color schemes table
5139               0086               *--------------------------------------------------------------
5140               0087               * Word 1
5141               0088               *    MSB  high-nibble    Foreground color frame buffer
5142               0089               *    MSB  low-nibble     Background color frame buffer
5143               0090               *    LSB  high-nibble    Foreground color bottom line pane
5144               0091               *    LSB  low-nibble     Background color bottom line pane
5145               0092               *
5146               0093               * Word 2
5147               0094               *    MSB  high-nibble    Foreground color cmdb pane
5148               0095               *    MSB  low-nibble     Background color cmdb pane
5149               0096               *    LSB  high-nibble    0
5150               0097               *    LSB  low-nibble     Cursor foreground color
5151               0098               *--------------------------------------------------------------
5152               0099      0009     tv.colorscheme.entries   equ 9      ; Entries in table
5153               0100
5154               0101               tv.colorscheme.table:
5155               0102                                        ; #  Framebuffer        | Status line        | CMDB
5156               0103                                        ; ----------------------|--------------------|---------
5157               0104 70F8 F41F      data  >f41f,>f001       ; 1  White/dark blue    | Black/white        | White
5158                    70FA F001
5159               0105 70FC F41C      data  >f41c,>f00f       ; 2  White/dark blue    | Black/dark green   | White
5160                    70FE F00F
5161               0106 7100 A11A      data  >a11a,>f00f       ; 3  Dark yellow/black  | Black/dark yellow  | White
5162                    7102 F00F
5163               0107 7104 2112      data  >2112,>f00f       ; 4  Medium green/black | Black/medium green | White
5164                    7106 F00F
5165               0108 7108 E11E      data  >e11e,>f00f       ; 5  Grey/black         | Black/grey         | White
5166                    710A F00F
5167               0109 710C 1771      data  >1771,>1006       ; 6  Black/cyan         | Cyan/black         | Black
5168                    710E 1006
5169               0110 7110 1FF1      data  >1ff1,>1001       ; 7  Black/white        | White/black        | Black
5170                    7112 1001
5171               0111 7114 A1F0      data  >a1f0,>1a0f       ; 8  Dark yellow/black  | White/transparent  | inverse
5172                    7116 1A0F
5173               0112 7118 21F0      data  >21f0,>f20f       ; 9  Medium green/black | White/transparent  | inverse
5174                    711A F20F
5175               0113
5176               **** **** ****     > stevie_b0.asm.22608
5177               0126                       copy  "data.strings.asm"    ; Data segment - Strings
5178               **** **** ****     > data.strings.asm
5179               0001               * FILE......: data.strings.asm
5180               0002               * Purpose...: Stevie Editor - data segment (strings)
5181               0003
5182               0004               ***************************************************************
5183               0005               *                       Strings
5184               0006               ***************************************************************
5185               0007
5186               0008               ;--------------------------------------------------------------
5187               0009               ; Strings for status line pane
5188               0010               ;--------------------------------------------------------------
5189               0011               txt.delim
5190               0012 711C 012C             byte  1
5191               0013 711D ....             text  ','
5192               0014                       even
5193               0015
5194               0016               txt.marker
5195               0017 711E 052A             byte  5
5196               0018 711F ....             text  '*EOF*'
5197               0019                       even
5198               0020
5199               0021               txt.bottom
5200               0022 7124 0520             byte  5
5201               0023 7125 ....             text  '  BOT'
5202               0024                       even
5203               0025
5204               0026               txt.ovrwrite
5205               0027 712A 034F             byte  3
5206               0028 712B ....             text  'OVR'
5207               0029                       even
5208               0030
5209               0031               txt.insert
5210               0032 712E 0349             byte  3
5211               0033 712F ....             text  'INS'
5212               0034                       even
5213               0035
5214               0036               txt.star
5215               0037 7132 012A             byte  1
5216               0038 7133 ....             text  '*'
5217               0039                       even
5218               0040
5219               0041               txt.loading
5220               0042 7134 0A4C             byte  10
5221               0043 7135 ....             text  'Loading...'
5222               0044                       even
5223               0045
5224               0046               txt.saving
5225               0047 7140 0953             byte  9
5226               0048 7141 ....             text  'Saving...'
5227               0049                       even
5228               0050
5229               0051               txt.kb
5230               0052 714A 026B             byte  2
5231               0053 714B ....             text  'kb'
5232               0054                       even
5233               0055
5234               0056               txt.lines
5235               0057 714E 054C             byte  5
5236               0058 714F ....             text  'Lines'
5237               0059                       even
5238               0060
5239               0061               txt.bufnum
5240               0062 7154 0323             byte  3
5241               0063 7155 ....             text  '#1 '
5242               0064                       even
5243               0065
5244               0066               txt.newfile
5245               0067 7158 0A5B             byte  10
5246               0068 7159 ....             text  '[New file]'
5247               0069                       even
5248               0070
5249               0071               txt.filetype.dv80
5250               0072 7164 0444             byte  4
5251               0073 7165 ....             text  'DV80'
5252               0074                       even
5253               0075
5254               0076               txt.filetype.none
5255               0077 716A 0420             byte  4
5256               0078 716B ....             text  '    '
5257               0079                       even
5258               0080
5259               0081
5260               0082
5261               0083               ;--------------------------------------------------------------
5262               0084               ; Dialog Load DV 80 file
5263               0085               ;--------------------------------------------------------------
5264               0086               txt.head.loaddv80
5265               0087 7170 0E4C             byte  14
5266               0088 7171 ....             text  'Load DV80 file'
5267               0089                       even
5268               0090
5269               0091               txt.hint.loaddv80
5270               0092 7180 2748             byte  39
5271               0093 7181 ....             text  'HINT: Specify filename and press ENTER.'
5272               0094                       even
5273               0095
5274               0096               txt.keys.loaddv80
5275               0097 71A8 4246             byte  66
5276               0098 71A9 ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End    ^,=Previous    ^.=Next'
5277               0099                       even
5278               0100
5279               0101
5280               0102               ;--------------------------------------------------------------
5281               0103               ; Dialog "Unsaved changes"
5282               0104               ;--------------------------------------------------------------
5283               0105               txt.head.unsaved
5284               0106 71EC 0F55             byte  15
5285               0107 71ED ....             text  'Unsaved changes'
5286               0108                       even
5287               0109
5288               0110               txt.hint.unsaved
5289               0111 71FC 2748             byte  39
5290               0112 71FD ....             text  'HINT: Unsaved changes in editor buffer.'
5291               0113                       even
5292               0114
5293               0115               txt.keys.unsaved
5294               0116 7224 2B46             byte  43
5295               0117 7225 ....             text  'F9=Back    F6=Proceed anyway   ^S=Save file'
5296               0118                       even
5297               0119
5298               0120
5299               0121
5300               0122
5301               0123               ;--------------------------------------------------------------
5302               0124               ; Strings for error line pane
5303               0125               ;--------------------------------------------------------------
5304               0126               txt.ioerr
5305               0127 7250 2049             byte  32
5306               0128 7251 ....             text  'I/O error. Failed loading file: '
5307               0129                       even
5308               0130
5309               0131               txt.io.nofile
5310               0132 7272 2149             byte  33
5311               0133 7273 ....             text  'I/O error. No filename specified.'
5312               0134                       even
5313               0135
5314               0136
5315               0137
5316               0138               ;--------------------------------------------------------------
5317               0139               ; Strings for command buffer
5318               0140               ;--------------------------------------------------------------
5319               0141               txt.cmdb.title
5320               0142 7294 0E43             byte  14
5321               0143 7295 ....             text  'Command buffer'
5322               0144                       even
5323               0145
5324               0146               txt.cmdb.prompt
5325               0147 72A4 013E             byte  1
5326               0148 72A5 ....             text  '>'
5327               0149                       even
5328               0150
5329               0151
5330               0152
5331               0153
5332               0154 72A6 4201     txt.cmdb.hbar      byte    66
5333               0155 72A8 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
5334                    72AA 0101
5335                    72AC 0101
5336                    72AE 0101
5337                    72B0 0101
5338                    72B2 0101
5339                    72B4 0101
5340                    72B6 0101
5341                    72B8 0101
5342                    72BA 0101
5343               0156 72BC 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
5344                    72BE 0101
5345                    72C0 0101
5346                    72C2 0101
5347                    72C4 0101
5348                    72C6 0101
5349                    72C8 0101
5350                    72CA 0101
5351                    72CC 0101
5352                    72CE 0101
5353               0157 72D0 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
5354                    72D2 0101
5355                    72D4 0101
5356                    72D6 0101
5357                    72D8 0101
5358                    72DA 0101
5359                    72DC 0101
5360                    72DE 0101
5361                    72E0 0101
5362                    72E2 0101
5363               0158 72E4 0101                        byte    1,1,1,1,1,1
5364                    72E6 0101
5365                    72E8 0100
5366               0159                                  even
5367               0160
5368               0161
5369               0162
5370               0163 72EA 0C0A     txt.stevie         byte    12
5371 6000 0A00     0164                                  byte    10
5372               0165 72EC ....                        text    'stevie v1.00'
5373               0166 72F8 0B00                        byte    11
5374               0167                                  even
5375               0168
5376               0169               txt.colorscheme
5377               0170 72FA 0E43             byte  14
5378               0171 72FB ....             text  'COLOR SCHEME: '
5379               0172                       even
5380               0173
5381               0174
5382               0175
5383               0176               ;--------------------------------------------------------------
5384               0177               ; Strings for filenames
5385               0178               ;--------------------------------------------------------------
5386               0179               fdname1
5387               0180 730A 0850             byte  8
5388               0181 730B ....             text  'PI.CLOCK'
5389               0182                       even
5390               0183
5391               0184               fdname2
5392               0185 7314 0E54             byte  14
5393               0186 7315 ....             text  'TIPI.TIVI.NR80'
5394               0187                       even
5395               0188
5396               0189               fdname3
5397               0190 7324 0C44             byte  12
5398               0191 7325 ....             text  'DSK1.XBEADOC'
5399               0192                       even
5400               0193
5401               0194               fdname4
5402               0195 7332 1154             byte  17
5403               0196 7333 ....             text  'TIPI.TIVI.C99MAN1'
5404               0197                       even
5405               0198
5406               0199               fdname5
5407               0200 7344 1154             byte  17
5408               0201 7345 ....             text  'TIPI.TIVI.C99MAN2'
5409               0202                       even
5410               0203
5411               0204               fdname6
5412               0205 7356 1154             byte  17
5413               0206 7357 ....             text  'TIPI.TIVI.C99MAN3'
5414               0207                       even
5415               0208
5416               0209               fdname7
5417               0210 7368 1254             byte  18
5418               0211 7369 ....             text  'TIPI.TIVI.C99SPECS'
5419               0212                       even
5420               0213
5421               0214               fdname8
5422               0215 737C 1254             byte  18
5423               0216 737D ....             text  'TIPI.TIVI.RANDOM#C'
5424               0217                       even
5425               0218
5426               0219               fdname9
5427               0220 7390 0D44             byte  13
5428               0221 7391 ....             text  'DSK1.INVADERS'
5429               0222                       even
5430               0223
5431               0224               fdname0
5432               0225 739E 0944             byte  9
5433               0226 739F ....             text  'DSK1.NR80'
5434               0227                       even
5435               0228
5436               0229               fdname.clock
5437               0230 73A8 0850             byte  8
5438               0231 73A9 ....             text  'PI.CLOCK'
5439               0232                       even
5440               0233
5441               **** **** ****     > stevie_b0.asm.22608
5442               0127                       ;------------------------------------------------------
5443               0128                       ; End of File marker
5444               0129                       ;------------------------------------------------------
5445               0130 73B2 DEAD             data  >dead,>beef,>dead,>beef
5446                    73B4 BEEF
5447                    73B6 DEAD
5448                    73B8 BEEF
5449               0132
5450               0136 73BA 3368                   data $                ; Bank 0 ROM size OK.
5451               0138
5452               0139
5453               0140
5454               0141               *--------------------------------------------------------------
5455               0142               * Video mode configuration for SP2
5456               0143               *--------------------------------------------------------------
5457               0144      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
5458               0145      0004     spfbck  equ   >04                   ; Screen background color.
5459               0146      3008     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
5460               0147      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
5461               0148      0050     colrow  equ   80                    ; Columns per row
5462               0149      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
5463               0150      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
5464               0151      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
5465               0152      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
0014               **** **** ****     > equates.asm
0015               0001               ***************************************************************
0016               0002               *                          Stevie Editor
0017               0003               *
0018               0004               *       A 21th century Programming Editor for the 1981
0019               0005               *         Texas Instruments TI-99/4a Home Computer.
0020               0006               *
0021               0007               *              (c)2018-2020 // Filip van Vooren
0022               0008               ***************************************************************
0023               0009               * File: equates.asm                 ; Version 200803-22608
0024               0010               *--------------------------------------------------------------
0025               0011               * stevie memory layout
0026               0012               * See file "modules/mem.asm" for further details.
0027               0013               *
0028               0014               *
0029               0015               * LOW MEMORY EXPANSION (2000-2fff)
0030               0016               *
0031               0017               * Mem range   Bytes    SAMS   Purpose
0032               0018               * =========   =====    ====   ==================================
0033               0019               * 2000-2fff    4096           SP2 library
0034               0020               *
0035               0021               * LOW MEMORY EXPANSION (3000-3fff)
0036               0022               *
0037               0023               * Mem range   Bytes    SAMS   Purpose
0038               0024               * =========   =====    ====   ==================================
0039               0025               * 3200-3fff    4096           Resident Stevie Modules
0040               0026               *
0041               0027               *
0042               0028               * CARTRIDGE SPACE (6000-7fff)
0043               0029               *
0044               0030               * Mem range   Bytes    BANK   Purpose
0045               0031               * =========   =====    ====   ==================================
0046               0032               * 6000-7fff    8192       0   SP2 ROM CODE, copy to RAM code, resident modules
0047               0033               * 6000-7fff    8192       1   Stevie program code
0048               0034               *
0049               0035               *
0050               0036               * HIGH MEMORY EXPANSION (a000-ffff)
0051               0037               *
0052               0038               * Mem range   Bytes    SAMS   Purpose
0053               0039               * =========   =====    ====   ==================================
0054               0040               * a000-a0ff     256           Stevie Editor shared structure
0055               0041               * a100-a1ff     256           Framebuffer structure
0056               0042               * a200-a2ff     256           Editor buffer structure
0057               0043               * a300-a3ff     256           Command buffer structure
0058               0044               * a400-a4ff     256           File handle structure
0059               0045               * a500-a5ff     256           Index structure
0060               0046               * a600-af5f    2400           Frame buffer
0061               0047               * af60-afff     ???           *FREE*
0062               0048               *
0063               0049               * b000-bfff    4096           Index buffer page
0064               0050               * c000-cfff    4096           Editor buffer page
0065               0051               * d000-dfff    4096           Command history buffer
0066               0052               * e000-efff    4096           Heap
0067               0053               * f000-f0ff     256           SP2/GPL scratchpad backup 1
0068               0054               * f100-f1ff     256           SP2/GPL scratchpad backup 2
0069               0055               * f200-ffff    3584           *FREE*
0070               0056               *
0071               0057               *
0072               0058               * VDP RAM
0073               0059               *
0074               0060               * Mem range   Bytes    Hex    Purpose
0075               0061               * =========   =====   =====   =================================
0076               0062               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0077               0063               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0078               0064               * 0fc0                        PCT - Pattern Color Table
0079               0065               * 1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
0080               0066               * 1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
0081               0067               * 2180                        SAT - Sprite Attribute List
0082               0068               * 2800                        SPT - Sprite Pattern Table. Must be on 2K boundary
0083               0069               *--------------------------------------------------------------
0084               0070               * Skip unused spectra2 code modules for reduced code size
0085               0071               *--------------------------------------------------------------
0086               0072      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0087               0073      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0088               0074      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0089               0075      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0090               0076      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0091               0077      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0092               0078      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0093               0079      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0094               0080      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0095               0081      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0096               0082      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0097               0083      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0098               0084      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0099               0085      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0100               0086      0001     skip_random_generator     equ  1       ; Skip random functions
0101               0087      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0102               0088               *--------------------------------------------------------------
0103               0089               * Stevie specific equates
0104               0090               *--------------------------------------------------------------
0105               0091      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0106               0092      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0107               0093      0001     id.dialog.loaddv80        equ  1       ; ID for dialog "Load DV 80 file"
0108               0094      0002     id.dialog.unsaved         equ  2       ; ID for dialog "Unsaved changes"
0109               0095      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0110               0096      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0111               0097      0002     fh.fopmode.savefile       equ  2       ; Save file from memory to disk
0112               0098               *--------------------------------------------------------------
0113               0099               * SPECTRA2 / Stevie startup options
0114               0100               *--------------------------------------------------------------
0115               0101      0001     debug                     equ  1       ; Turn on spectra2 debugging
0116               0102      0001     startup_backup_scrpad     equ  1       ; Backup scratchpad 8300-83ff to
0117               0103                                                      ; memory address @cpu.scrpad.tgt
0118               0104      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0119               0105      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0120               0106      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0121               0107               *--------------------------------------------------------------
0122               0108               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0123               0109               *--------------------------------------------------------------
0124               0110               ;                 equ  >8342           ; >8342-834F **free***
0125               0111      8350     parm1             equ  >8350           ; Function parameter 1
0126               0112      8352     parm2             equ  >8352           ; Function parameter 2
0127               0113      8354     parm3             equ  >8354           ; Function parameter 3
0128               0114      8356     parm4             equ  >8356           ; Function parameter 4
0129               0115      8358     parm5             equ  >8358           ; Function parameter 5
0130               0116      835A     parm6             equ  >835a           ; Function parameter 6
0131               0117      835C     parm7             equ  >835c           ; Function parameter 7
0132               0118      835E     parm8             equ  >835e           ; Function parameter 8
0133               0119      8360     outparm1          equ  >8360           ; Function output parameter 1
0134               0120      8362     outparm2          equ  >8362           ; Function output parameter 2
0135               0121      8364     outparm3          equ  >8364           ; Function output parameter 3
0136               0122      8366     outparm4          equ  >8366           ; Function output parameter 4
0137               0123      8368     outparm5          equ  >8368           ; Function output parameter 5
0138               0124      836A     outparm6          equ  >836a           ; Function output parameter 6
0139               0125      836C     outparm7          equ  >836c           ; Function output parameter 7
0140               0126      836E     outparm8          equ  >836e           ; Function output parameter 8
0141               0127      8370     timers            equ  >8370           ; Timer table
0142               0128      8380     ramsat            equ  >8380           ; Sprite Attribute Table in RAM
0143               0129      8390     rambuf            equ  >8390           ; RAM workbuffer 1
0144               0130               *--------------------------------------------------------------
0145               0131               * Stevie Editor shared structures     @>a000-a0ff     (256 bytes)
0146               0132               *--------------------------------------------------------------
0147               0133      A000     tv.top            equ  >a000           ; Structure begin
0148               0134      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0149               0135      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0150               0136      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0151               0137      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0152               0138      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0153               0139      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0154               0140      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0155               0141      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0156               0142      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0157               0143      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0158               0144      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0159               0145      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0160               0146      A018     tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
0161               0147      A01A     tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
0162               0148      A01C     tv.task.oneshot   equ  tv.top + 28     ; Pointer to one-shot routine
0163               0149      A01E     tv.error.visible  equ  tv.top + 30     ; Error pane visible
0164               0150      A020     tv.error.msg      equ  tv.top + 32     ; Error message (max. 160 characters)
0165               0151      A0C0     tv.free           equ  tv.top + 192    ; End of structure
0166               0152               *--------------------------------------------------------------
0167               0153               * Frame buffer structure            @>a100-a1ff     (256 bytes)
0168               0154               *--------------------------------------------------------------
0169               0155      A100     fb.struct         equ  >a100           ; Structure begin
0170               0156      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0171               0157      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0172               0158      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0173               0159                                                      ; line X in editor buffer).
0174               0160      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0175               0161                                                      ; (offset 0 .. @fb.scrrows)
0176               0162      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0177               0163      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0178               0164      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0179               0165      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0180               0166      A110     fb.free1          equ  fb.struct + 16  ; **** free ****
0181               0167      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0182               0168      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0183               0169      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0184               0170      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0185               0171      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0186               0172      A11C     fb.free           equ  fb.struct + 28  ; End of structure
0187               0173               *--------------------------------------------------------------
0188               0174               * Editor buffer structure           @>a200-a2ff     (256 bytes)
0189               0175               *--------------------------------------------------------------
0190               0176      A200     edb.struct        equ  >a200           ; Begin structure
0191               0177      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0192               0178      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0193               0179      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0194               0180      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0195               0181      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0196               0182      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0197               0183      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0198               0184      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0199               0185                                                      ; with current filename.
0200               0186      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0201               0187                                                      ; with current file type.
0202               0188      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0203               0189      A214     edb.free          equ  edb.struct + 20 ; End of structure
0204               0190               *--------------------------------------------------------------
0205               0191               * Command buffer structure          @>a300-a3ff     (256 bytes)
0206               0192               *--------------------------------------------------------------
0207               0193      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0208               0194      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0209               0195      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0210               0196      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0211               0197      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0212               0198      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0213               0199      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0214               0200      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0215               0201      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0216               0202      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0217               0203      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0218               0204      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0219               0205      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0220               0206      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0221               0207      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0222               0208      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
0223               0209      A31E     cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
0224               0210      A320     cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
0225               0211      A322     cmdb.cmdlen       equ  cmdb.struct + 34; Length of current command (MSB byte!)
0226               0212      A323     cmdb.cmd          equ  cmdb.struct + 35; Current command (80 bytes max.)
0227               0213      A373     cmdb.free         equ  cmdb.struct +115; End of structure
0228               0214               *--------------------------------------------------------------
0229               0215               * File handle structure             @>a400-a4ff     (256 bytes)
0230               0216               *--------------------------------------------------------------
0231               0217      A400     fh.struct         equ  >a400           ; stevie file handling structures
0232               0218      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0233               0219      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0234               0220      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0235               0221      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0236               0222      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0237               0223      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0238               0224      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0239               0225      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0240               0226      A434     fh.counter        equ  fh.struct + 52  ; Counter used in stevie file operations
0241               0227      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0242               0228      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0243               0229      A43A     fh.sams.hipage    equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0244               0230      A43C     fh.fopmode        equ  fh.struct + 60  ; FOP (File Operation Mode)
0245               0231      A43E     fh.callback1      equ  fh.struct + 62  ; Pointer to callback function 1
0246               0232      A440     fh.callback2      equ  fh.struct + 64  ; Pointer to callback function 2
0247               0233      A442     fh.callback3      equ  fh.struct + 66  ; Pointer to callback function 3
0248               0234      A444     fh.callback4      equ  fh.struct + 68  ; Pointer to callback function 4
0249               0235      A446     fh.kilobytes.prev equ  fh.struct + 70  ; Kilobytes process (previous)
0250               0236      A448     fh.membuffer      equ  fh.struct + 72  ; 80 bytes file memory buffer
0251               0237      A498     fh.free           equ  fh.struct +152  ; End of structure
0252               0238      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0253               0239      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0254               0240               *--------------------------------------------------------------
0255               0241               * Index structure                   @>a500-a5ff     (256 bytes)
0256               0242               *--------------------------------------------------------------
0257               0243      A500     idx.struct        equ  >a500           ; stevie index structure
0258               0244      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0259               0245      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0260               0246      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0261               0247               *--------------------------------------------------------------
0262               0248               * Frame buffer                      @>a600-afff    (2560 bytes)
0263               0249               *--------------------------------------------------------------
0264               0250      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0265               0251      0960     fb.size           equ  80*30           ; Frame buffer size
0266               0252               *--------------------------------------------------------------
0267               0253               * Index                             @>b000-bfff    (4096 bytes)
0268               0254               *--------------------------------------------------------------
0269               0255      B000     idx.top           equ  >b000           ; Top of index
0270               0256      1000     idx.size          equ  4096            ; Index size
0271               0257               *--------------------------------------------------------------
0272               0258               * Editor buffer                     @>c000-cfff    (4096 bytes)
0273               0259               *--------------------------------------------------------------
0274               0260      C000     edb.top           equ  >c000           ; Editor buffer high memory
0275               0261      1000     edb.size          equ  4096            ; Editor buffer size
0276               0262               *--------------------------------------------------------------
0277               0263               * Command history buffer            @>d000-dfff    (4096 bytes)
0278               0264               *--------------------------------------------------------------
0279               0265      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0280               0266      1000     cmdb.size         equ  4096            ; Command buffer size
0281               0267               *--------------------------------------------------------------
0282               0268               * Heap                              @>e000-efff    (4096 bytes)
0283               0269               *--------------------------------------------------------------
0284               0270      E000     heap.top          equ  >e000           ; Top of heap
0285               0271               *--------------------------------------------------------------
0286               0272               * Scratchpad backup 1               @>f000-f0ff     (256 bytes)
0287               0273               * Scratchpad backup 2               @>f100-f1ff     (256 bytes)
0288               0274               *--------------------------------------------------------------
0289               0275      F000     cpu.scrpad.tgt    equ  >f000           ; Destination cpu.scrpad.backup/restore
0290               0276      F000     scrpad.backup1    equ  >f000           ; Backup GPL layout
0291               0277      F100     scrpad.backup2    equ  >f100           ; Backup spectra2 layout
0292               **** **** ****     > stevie_b0.asm.22608
0293               0012
0294               0013               ***************************************************************
0295               0014               * BANK 0 - Setup environment for Stevie
0296               0015               ********|*****|*********************|**************************
0297               0016                       aorg  >6000
0298               0017                       save  >6000,>7fff           ; Save bank 0 (1st bank)
0299               0018               *--------------------------------------------------------------
0300               0019               * Cartridge header
0301               0020               ********|*****|*********************|**************************
0302               0021 6000 AA01             byte  >aa,1,1,0,0,0
0303                    6002 0100
0304                    6004 0000
0305               0022 6006 6010             data  $+10
0306               0023 6008 0000             byte  0,0,0,0,0,0,0,0
0307                    600A 0000
0308                    600C 0000
0309                    600E 0000
0310               0024 6010 0000             data  0                     ; No more items following
0311               0025 6012 6030             data  kickstart.code1
0312               0026
0313               0028
0314               0029 6014 1353             byte  19
0315               0030 6015 ....             text  'STEVIE 200803-22608'
0316               0031                       even
0317               0032
0318               0040
0319               0041               *--------------------------------------------------------------
0320               0042               * Step 1: Switch to bank 0 (uniform code accross all banks)
0321               0043               ********|*****|*********************|**************************
0322               0044                       aorg  kickstart.code1       ; >6030
0323               0045 6030 04E0  34         clr   @>6000                ; Switch to bank 0
0324                    6032 6000
0325               0046
0326               0047               ***************************************************************
0327               0048               * Step 2: Copy SP2 library from ROM to >2000 - >2fff
0328               0049               ********|*****|*********************|**************************
0329               0050 6034 0200  20         li    r0,reloc.sp2          ; Start of code to relocate
0330                    6036 6074
0331               0051 6038 0201  20         li    r1,>2000
0332                    603A 2000
0333               0052 603C 0202  20         li    r2,512                ; Copy 4K (512 * 8 bytes)
0334                    603E 0200
0335               0053               kickstart.copy.sp2:
0336               0054 6040 CC70  46         mov   *r0+,*r1+
0337               0055 6042 CC70  46         mov   *r0+,*r1+
0338               0056 6044 CC70  46         mov   *r0+,*r1+
0339               0057 6046 CC70  46         mov   *r0+,*r1+
0340               0058 6048 0602  14         dec   r2
0341               0059 604A 16FA  14         jne   kickstart.copy.sp2
0342               0060
0343               0061               ***************************************************************
0344               0062               * Step 3: Copy Stevie resident modules from ROM to >3000 - >3fff
0345               0063               ********|*****|*********************|**************************
0346               0064 604C 0200  20         li    r0,reloc.stevie       ; Start of code to relocate
0347                    604E 7052
0348               0065 6050 0201  20         li    r1,>3000
0349                    6052 3000
0350               0066 6054 0202  20         li    r2,512                ; Copy 4K (512 * 8 bytes)
0351                    6056 0200
0352               0067               kickstart.copy.stevie:
0353               0068 6058 CC70  46         mov   *r0+,*r1+
0354               0069 605A CC70  46         mov   *r0+,*r1+
0355               0070 605C CC70  46         mov   *r0+,*r1+
0356               0071 605E CC70  46         mov   *r0+,*r1+
0357               0072 6060 0602  14         dec   r2
0358               0073 6062 16FA  14         jne   kickstart.copy.stevie
0359               0074
0360               0075               ***************************************************************
0361               0076               * Step 4: Start SP2 kernel (runs in low MEMEXP)
0362               0077               ********|*****|*********************|**************************
0363               0078 6064 0460  28         b     @runlib               ; Start spectra2 library
0364                    6066 2DEA
0365               0079                       ;------------------------------------------------------
0366               0080                       ; Assert. Should not get here! Crash and burn!
0367               0081                       ;------------------------------------------------------
0368               0082 6068 0200  20         li    r0,$                  ; Current location
0369                    606A 6068
0370               0083 606C C800  38         mov   r0,@>ffce             ; \ Save caller address
0371                    606E FFCE
0372               0084 6070 06A0  32         bl    @cpu.crash            ; / Crash and halt system
0373                    6072 2030
0374               0085
0375               0086               ***************************************************************
0376               0087               * Step 5: Handover from SP2 kernel to Stevie "main" in low MEMEXP
0377               0088               ********|*****|*********************|**************************
0378               0089                       ; "main" in low MEMEXP is automatically called by SP2 runlib.
0379               0090
0380               0091
0381               0092
0382               0093
0383               0094               ***************************************************************
0384               0095               * Code data: Relocated code SP2 >2000 - >2fff (4K maximum)
0385               0096               ********|*****|*********************|**************************
0386               0097               reloc.sp2:
0387               0098                       xorg >2000                  ; Relocate SP2 code to >2000
0388               0099                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
0389               **** **** ****     > runlib.asm
0390               0001               *******************************************************************************
0391               0002               *              ___  ____  ____  ___  ____  ____    __    ___
0392               0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \  v.2021
0393               0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0394               0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0395               0006               *
0396               0007               *                TMS9900 Monitor with Arcade Game support
0397               0008               *                                  for
0398               0009               *              the Texas Instruments TI-99/4A Home Computer
0399               0010               *
0400               0011               *                      2010-2020 by Filip Van Vooren
0401               0012               *
0402               0013               *              https://github.com/FilipVanVooren/spectra2.git
0403               0014               *******************************************************************************
0404               0015               * This file: runlib.a99
0405               0016               *******************************************************************************
0406               0017               * Use following equates to skip/exclude support modules and to control startup
0407               0018               * behaviour.
0408               0019               *
0409               0020               * == Memory
0410               0021               * skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
0411               0022               * skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
0412               0023               * skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
0413               0024               * skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
0414               0025               * skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
0415               0026               * skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
0416               0027               * skip_sams                 equ  1  ; Skip CPU support for SAMS memory expansion
0417               0028               *
0418               0029               * == VDP
0419               0030               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0420               0031               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0421               0032               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0422               0033               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0423               0034               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0424               0035               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0425               0036               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0426               0037               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0427               0038               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0428               0039               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0429               0040               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0430               0041               * skip_vdp_sprites          equ  1  ; Skip sprites support
0431               0042               * skip_vdp_cursor           equ  1  ; Skip cursor support
0432               0043               *
0433               0044               * == Sound & speech
0434               0045               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0435               0046               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0436               0047               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0437               0048               *
0438               0049               * ==  Keyboard
0439               0050               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0440               0051               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0441               0052               *
0442               0053               * == Utilities
0443               0054               * skip_random_generator     equ  1  ; Skip random generator functions
0444               0055               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0445               0056               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0446               0057               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0447               0058               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0448               0059               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0449               0060               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0450               0061               * skip_cpu_strings          equ  1  ; Skip string support utilities
0451               0062
0452               0063               * == Kernel/Multitasking
0453               0064               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0454               0065               * skip_mem_paging           equ  1  ; Skip support for memory paging
0455               0066               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0456               0067               *
0457               0068               * == Startup behaviour
0458               0069               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0459               0070               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0460               0071               *******************************************************************************
0461               0072
0462               0073               *//////////////////////////////////////////////////////////////
0463               0074               *                       RUNLIB SETUP
0464               0075               *//////////////////////////////////////////////////////////////
0465               0076
0466               0077                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
0467               **** **** ****     > equ_memsetup.asm
0468               0001               * FILE......: memsetup.asm
0469               0002               * Purpose...: Equates for spectra2 memory layout
0470               0003
0471               0004               ***************************************************************
0472               0005               * >8300 - >8341     Scratchpad memory layout (66 bytes)
0473               0006               ********|*****|*********************|**************************
0474               0007      8300     ws1     equ   >8300                 ; 32 - Primary workspace
0475               0008      8320     mcloop  equ   >8320                 ; 08 - Machine code for loop & speech
0476               0009      8328     wbase   equ   >8328                 ; 02 - PNT base address
0477               0010      832A     wyx     equ   >832a                 ; 02 - Cursor YX position
0478               0011      832C     wtitab  equ   >832c                 ; 02 - Timers: Address of timer table
0479               0012      832E     wtiusr  equ   >832e                 ; 02 - Timers: Address of user hook
0480               0013      8330     wtitmp  equ   >8330                 ; 02 - Timers: Internal use
0481               0014      8332     wvrtkb  equ   >8332                 ; 02 - Virtual keyboard flags
0482               0015      8334     wsdlst  equ   >8334                 ; 02 - Sound player: Tune address
0483               0016      8336     wsdtmp  equ   >8336                 ; 02 - Sound player: Temporary use
0484               0017      8338     wspeak  equ   >8338                 ; 02 - Speech player: Address of LPC data
0485               0018      833A     wcolmn  equ   >833a                 ; 02 - Screen size, columns per row
0486               0019      833C     waux1   equ   >833c                 ; 02 - Temporary storage 1
0487               0020      833E     waux2   equ   >833e                 ; 02 - Temporary storage 2
0488               0021      8340     waux3   equ   >8340                 ; 02 - Temporary storage 3
0489               0022               ***************************************************************
0490               0023      832A     by      equ   wyx                   ;      Cursor Y position
0491               0024      832B     bx      equ   wyx+1                 ;      Cursor X position
0492               0025      8322     mcsprd  equ   mcloop+2              ;      Speech read routine
0493               0026               ***************************************************************
0494               **** **** ****     > runlib.asm
0495               0078                       copy  "equ_registers.asm"        ; Equates runlib registers
0496               **** **** ****     > equ_registers.asm
0497               0001               * FILE......: registers.asm
0498               0002               * Purpose...: Equates for registers
0499               0003
0500               0004               ***************************************************************
0501               0005               * Register usage
0502               0006               * R0      **free not used**
0503               0007               * R1      **free not used**
0504               0008               * R2      Config register
0505               0009               * R3      Extended config register
0506               0010               * R4      Temporary register/variable tmp0
0507               0011               * R5      Temporary register/variable tmp1
0508               0012               * R6      Temporary register/variable tmp2
0509               0013               * R7      Temporary register/variable tmp3
0510               0014               * R8      Temporary register/variable tmp4
0511               0015               * R9      Stack pointer
0512               0016               * R10     Highest slot in use + Timer counter
0513               0017               * R11     Subroutine return address
0514               0018               * R12     CRU
0515               0019               * R13     Copy of VDP status byte and counter for sound player
0516               0020               * R14     Copy of VDP register #0 and VDP register #1 bytes
0517               0021               * R15     VDP read/write address
0518               0022               *--------------------------------------------------------------
0519               0023               * Special purpose registers
0520               0024               * R0      shift count
0521               0025               * R12     CRU
0522               0026               * R13     WS     - when using LWPI, BLWP, RTWP
0523               0027               * R14     PC     - when using LWPI, BLWP, RTWP
0524               0028               * R15     STATUS - when using LWPI, BLWP, RTWP
0525               0029               ***************************************************************
0526               0030               * Define registers
0527               0031               ********|*****|*********************|**************************
0528               0032      0000     r0      equ   0
0529               0033      0001     r1      equ   1
0530               0034      0002     r2      equ   2
0531               0035      0003     r3      equ   3
0532               0036      0004     r4      equ   4
0533               0037      0005     r5      equ   5
0534               0038      0006     r6      equ   6
0535               0039      0007     r7      equ   7
0536               0040      0008     r8      equ   8
0537               0041      0009     r9      equ   9
0538               0042      000A     r10     equ   10
0539               0043      000B     r11     equ   11
0540               0044      000C     r12     equ   12
0541               0045      000D     r13     equ   13
0542               0046      000E     r14     equ   14
0543               0047      000F     r15     equ   15
0544               0048               ***************************************************************
0545               0049               * Define register equates
0546               0050               ********|*****|*********************|**************************
0547               0051      0002     config  equ   r2                    ; Config register
0548               0052      0003     xconfig equ   r3                    ; Extended config register
0549               0053      0004     tmp0    equ   r4                    ; Temp register 0
0550               0054      0005     tmp1    equ   r5                    ; Temp register 1
0551               0055      0006     tmp2    equ   r6                    ; Temp register 2
0552               0056      0007     tmp3    equ   r7                    ; Temp register 3
0553               0057      0008     tmp4    equ   r8                    ; Temp register 4
0554               0058      0009     stack   equ   r9                    ; Stack pointer
0555               0059      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0556               0060      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0557               0061               ***************************************************************
0558               0062               * Define MSB/LSB equates for registers
0559               0063               ********|*****|*********************|**************************
0560               0064      8300     r0hb    equ   ws1                   ; HI byte R0
0561               0065      8301     r0lb    equ   ws1+1                 ; LO byte R0
0562               0066      8302     r1hb    equ   ws1+2                 ; HI byte R1
0563               0067      8303     r1lb    equ   ws1+3                 ; LO byte R1
0564               0068      8304     r2hb    equ   ws1+4                 ; HI byte R2
0565               0069      8305     r2lb    equ   ws1+5                 ; LO byte R2
0566               0070      8306     r3hb    equ   ws1+6                 ; HI byte R3
0567               0071      8307     r3lb    equ   ws1+7                 ; LO byte R3
0568               0072      8308     r4hb    equ   ws1+8                 ; HI byte R4
0569               0073      8309     r4lb    equ   ws1+9                 ; LO byte R4
0570               0074      830A     r5hb    equ   ws1+10                ; HI byte R5
0571               0075      830B     r5lb    equ   ws1+11                ; LO byte R5
0572               0076      830C     r6hb    equ   ws1+12                ; HI byte R6
0573               0077      830D     r6lb    equ   ws1+13                ; LO byte R6
0574               0078      830E     r7hb    equ   ws1+14                ; HI byte R7
0575               0079      830F     r7lb    equ   ws1+15                ; LO byte R7
0576               0080      8310     r8hb    equ   ws1+16                ; HI byte R8
0577               0081      8311     r8lb    equ   ws1+17                ; LO byte R8
0578               0082      8312     r9hb    equ   ws1+18                ; HI byte R9
0579               0083      8313     r9lb    equ   ws1+19                ; LO byte R9
0580               0084      8314     r10hb   equ   ws1+20                ; HI byte R10
0581               0085      8315     r10lb   equ   ws1+21                ; LO byte R10
0582               0086      8316     r11hb   equ   ws1+22                ; HI byte R11
0583               0087      8317     r11lb   equ   ws1+23                ; LO byte R11
0584               0088      8318     r12hb   equ   ws1+24                ; HI byte R12
0585               0089      8319     r12lb   equ   ws1+25                ; LO byte R12
0586               0090      831A     r13hb   equ   ws1+26                ; HI byte R13
0587               0091      831B     r13lb   equ   ws1+27                ; LO byte R13
0588               0092      831C     r14hb   equ   ws1+28                ; HI byte R14
0589               0093      831D     r14lb   equ   ws1+29                ; LO byte R14
0590               0094      831E     r15hb   equ   ws1+30                ; HI byte R15
0591               0095      831F     r15lb   equ   ws1+31                ; LO byte R15
0592               0096               ********|*****|*********************|**************************
0593               0097      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0594               0098      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0595               0099      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0596               0100      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0597               0101      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0598               0102      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0599               0103      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0600               0104      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0601               0105      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0602               0106      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0603               0107               ********|*****|*********************|**************************
0604               0108      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0605               0109      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0606               0110      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0607               0111      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0608               0112               ***************************************************************
0609               **** **** ****     > runlib.asm
0610               0079                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
0611               **** **** ****     > equ_portaddr.asm
0612               0001               * FILE......: portaddr.asm
0613               0002               * Purpose...: Equates for hardware port addresses
0614               0003
0615               0004               ***************************************************************
0616               0005               * Equates for VDP, GROM, SOUND, SPEECH ports
0617               0006               ********|*****|*********************|**************************
0618               0007      8400     sound   equ   >8400                 ; Sound generator address
0619               0008      8800     vdpr    equ   >8800                 ; VDP read data window address
0620               0009      8C00     vdpw    equ   >8c00                 ; VDP write data window address
0621               0010      8802     vdps    equ   >8802                 ; VDP status register
0622               0011      8C02     vdpa    equ   >8c02                 ; VDP address register
0623               0012      9C02     grmwa   equ   >9c02                 ; GROM set write address
0624               0013      9802     grmra   equ   >9802                 ; GROM set read address
0625               0014      9800     grmrd   equ   >9800                 ; GROM read byte
0626               0015      9C00     grmwd   equ   >9c00                 ; GROM write byte
0627               0016      9000     spchrd  equ   >9000                 ; Address of speech synth Read Data Register
0628               0017      9400     spchwt  equ   >9400                 ; Address of speech synth Write Data Register
0629               **** **** ****     > runlib.asm
0630               0080                       copy  "equ_param.asm"            ; Equates runlib parameters
0631               **** **** ****     > equ_param.asm
0632               0001               * FILE......: param.asm
0633               0002               * Purpose...: Equates used for subroutine parameters
0634               0003
0635               0004               ***************************************************************
0636               0005               * Subroutine parameter equates
0637               0006               ***************************************************************
0638               0007      FFFF     eol     equ   >ffff                 ; End-Of-List
0639               0008      FFFF     nofont  equ   >ffff                 ; Skip loading font in RUNLIB
0640               0009      0000     norep   equ   0                     ; PUTBOX > Value for P3. Don't repeat box
0641               0010      3030     num1    equ   >3030                 ; MKNUM  > ASCII 0-9, leading 0's
0642               0011      3020     num2    equ   >3020                 ; MKNUM  > ASCII 0-9, leading spaces
0643               0012      0007     sdopt1  equ   7                     ; SDPLAY > 111 (Player on, repeat, tune in CPU memory)
0644               0013      0005     sdopt2  equ   5                     ; SDPLAY > 101 (Player on, no repeat, tune in CPU memory)
0645               0014      0006     sdopt3  equ   6                     ; SDPLAY > 110 (Player on, repeat, tune in VRAM)
0646               0015      0004     sdopt4  equ   4                     ; SDPLAY > 100 (Player on, no repeat, tune in VRAM)
0647               0016      0000     fnopt1  equ   >0000                 ; LDFNT  > Load TI title screen font
0648               0017      0006     fnopt2  equ   >0006                 ; LDFNT  > Load upper case font
0649               0018      000C     fnopt3  equ   >000c                 ; LDFNT  > Load upper/lower case font
0650               0019      0012     fnopt4  equ   >0012                 ; LDFNT  > Load lower case font
0651               0020      8000     fnopt5  equ   >8000                 ; LDFNT  > Load TI title screen font  & bold
0652               0021      8006     fnopt6  equ   >8006                 ; LDFNT  > Load upper case font       & bold
0653               0022      800C     fnopt7  equ   >800c                 ; LDFNT  > Load upper/lower case font & bold
0654               0023      8012     fnopt8  equ   >8012                 ; LDFNT  > Load lower case font       & bold
0655               0024               *--------------------------------------------------------------
0656               0025               *   Speech player
0657               0026               *--------------------------------------------------------------
0658               0027      0060     talkon  equ   >60                   ; 'start talking' command code for speech synth
0659               0028      00FF     talkof  equ   >ff                   ; 'stop talking' command code for speech synth
0660               0029      6000     spkon   equ   >6000                 ; 'start talking' command code for speech synth
0661               0030      FF00     spkoff  equ   >ff00                 ; 'stop talking' command code for speech synth
0662               **** **** ****     > runlib.asm
0663               0081
0664               0083                       copy  "rom_bankswitch.asm"       ; Bank switch routine
0665               **** **** ****     > rom_bankswitch.asm
0666               0001               * FILE......: rom_bankswitch.asm
0667               0002               * Purpose...: ROM bankswitching Support module
0668               0003
0669               0004               *//////////////////////////////////////////////////////////////
0670               0005               *                   BANKSWITCHING FUNCTIONS
0671               0006               *//////////////////////////////////////////////////////////////
0672               0007
0673               0008               ***************************************************************
0674               0009               * SWBNK - Switch ROM bank
0675               0010               ***************************************************************
0676               0011               *  BL   @SWBNK
0677               0012               *  DATA P0,P1
0678               0013               *--------------------------------------------------------------
0679               0014               *  P0 = Bank selection address (>600X)
0680               0015               *  P1 = Vector address
0681               0016               *--------------------------------------------------------------
0682               0017               *  B    @SWBNKX
0683               0018               *
0684               0019               *  TMP0 = Bank selection address (>600X)
0685               0020               *  TMP1 = Vector address
0686               0021               *--------------------------------------------------------------
0687               0022               *  Important! The bank-switch routine must be at the exact
0688               0023               *  same location accross banks
0689               0024               ********|*****|*********************|**************************
0690               0025 6074 C13B  30 swbnk   mov   *r11+,tmp0
0691               0026 6076 C17B  30         mov   *r11+,tmp1
0692               0027 6078 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0693               0028 607A C155  26         mov   *tmp1,tmp1
0694               0029 607C 0455  20         b     *tmp1                 ; Switch to routine in TMP1
0695               **** **** ****     > runlib.asm
0696               0085
0697               0086                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
0698               **** **** ****     > cpu_constants.asm
0699               0001               * FILE......: cpu_constants.asm
0700               0002               * Purpose...: Constants used by Spectra2 and for own use
0701               0003
0702               0004               ***************************************************************
0703               0005               *                      Some constants
0704               0006               ********|*****|*********************|**************************
0705               0007
0706               0008               ---------------------------------------------------------------
0707               0009               * Word values
0708               0010               *--------------------------------------------------------------
0709               0011               ;                                   ;       0123456789ABCDEF
0710               0012 607E 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0711               0013 6080 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0712               0014 6082 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0713               0015 6084 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0714               0016 6086 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0715               0017 6088 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0716               0018 608A 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0717               0019 608C 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0718               0020 608E 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0719               0021 6090 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0720               0022 6092 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0721               0023 6094 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0722               0024 6096 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0723               0025 6098 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0724               0026 609A 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0725               0027 609C 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0726               0028 609E 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0727               0029 60A0 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0728               0030 60A2 D000     w$d000  data  >d000                 ; >d000
0729               0031               *--------------------------------------------------------------
0730               0032               * Byte values - High byte (=MSB) for byte operations
0731               0033               *--------------------------------------------------------------
0732               0034      200A     hb$00   equ   w$0000                ; >0000
0733               0035      201C     hb$01   equ   w$0100                ; >0100
0734               0036      201E     hb$02   equ   w$0200                ; >0200
0735               0037      2020     hb$04   equ   w$0400                ; >0400
0736               0038      2022     hb$08   equ   w$0800                ; >0800
0737               0039      2024     hb$10   equ   w$1000                ; >1000
0738               0040      2026     hb$20   equ   w$2000                ; >2000
0739               0041      2028     hb$40   equ   w$4000                ; >4000
0740               0042      202A     hb$80   equ   w$8000                ; >8000
0741               0043      202E     hb$d0   equ   w$d000                ; >d000
0742               0044               *--------------------------------------------------------------
0743               0045               * Byte values - Low byte (=LSB) for byte operations
0744               0046               *--------------------------------------------------------------
0745               0047      200A     lb$00   equ   w$0000                ; >0000
0746               0048      200C     lb$01   equ   w$0001                ; >0001
0747               0049      200E     lb$02   equ   w$0002                ; >0002
0748               0050      2010     lb$04   equ   w$0004                ; >0004
0749               0051      2012     lb$08   equ   w$0008                ; >0008
0750               0052      2014     lb$10   equ   w$0010                ; >0010
0751               0053      2016     lb$20   equ   w$0020                ; >0020
0752               0054      2018     lb$40   equ   w$0040                ; >0040
0753               0055      201A     lb$80   equ   w$0080                ; >0080
0754               0056               *--------------------------------------------------------------
0755               0057               * Bit values
0756               0058               *--------------------------------------------------------------
0757               0059               ;                                   ;       0123456789ABCDEF
0758               0060      200C     wbit15  equ   w$0001                ; >0001 0000000000000001
0759               0061      200E     wbit14  equ   w$0002                ; >0002 0000000000000010
0760               0062      2010     wbit13  equ   w$0004                ; >0004 0000000000000100
0761               0063      2012     wbit12  equ   w$0008                ; >0008 0000000000001000
0762               0064      2014     wbit11  equ   w$0010                ; >0010 0000000000010000
0763               0065      2016     wbit10  equ   w$0020                ; >0020 0000000000100000
0764               0066      2018     wbit9   equ   w$0040                ; >0040 0000000001000000
0765               0067      201A     wbit8   equ   w$0080                ; >0080 0000000010000000
0766               0068      201C     wbit7   equ   w$0100                ; >0100 0000000100000000
0767               0069      201E     wbit6   equ   w$0200                ; >0200 0000001000000000
0768               0070      2020     wbit5   equ   w$0400                ; >0400 0000010000000000
0769               0071      2022     wbit4   equ   w$0800                ; >0800 0000100000000000
0770               0072      2024     wbit3   equ   w$1000                ; >1000 0001000000000000
0771               0073      2026     wbit2   equ   w$2000                ; >2000 0010000000000000
0772               0074      2028     wbit1   equ   w$4000                ; >4000 0100000000000000
0773               0075      202A     wbit0   equ   w$8000                ; >8000 1000000000000000
0774               **** **** ****     > runlib.asm
0775               0087                       copy  "equ_config.asm"           ; Equates for bits in config register
0776               **** **** ****     > equ_config.asm
0777               0001               * FILE......: equ_config.asm
0778               0002               * Purpose...: Equates for bits in config register
0779               0003
0780               0004               ***************************************************************
0781               0005               * The config register equates
0782               0006               *--------------------------------------------------------------
0783               0007               * Configuration flags
0784               0008               * ===================
0785               0009               *
0786               0010               * ; 15  Sound player: tune source       1=ROM/RAM      0=VDP MEMORY
0787               0011               * ; 14  Sound player: repeat tune       1=yes          0=no
0788               0012               * ; 13  Sound player: enabled           1=yes          0=no (or pause)
0789               0013               * ; 12  VDP9918 sprite collision?       1=yes          0=no
0790               0014               * ; 11  Keyboard: ANY key pressed       1=yes          0=no
0791               0015               * ; 10  Keyboard: Alpha lock key down   1=yes          0=no
0792               0016               * ; 09  Timer: Kernel thread enabled    1=yes          0=no
0793               0017               * ; 08  Timer: Block kernel thread      1=yes          0=no
0794               0018               * ; 07  Timer: User hook enabled        1=yes          0=no
0795               0019               * ; 06  Timer: Block user hook          1=yes          0=no
0796               0020               * ; 05  Speech synthesizer present      1=yes          0=no
0797               0021               * ; 04  Speech player: busy             1=yes          0=no
0798               0022               * ; 03  Speech player: enabled          1=yes          0=no
0799               0023               * ; 02  VDP9918 PAL version             1=yes(50)      0=no(60)
0800               0024               * ; 01  F18A present                    1=on           0=off
0801               0025               * ; 00  Subroutine state flag           1=on           0=off
0802               0026               ********|*****|*********************|**************************
0803               0027      2026     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0804               0028      201C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0805               0029      2018     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0806               0030      2014     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0807               0031               ***************************************************************
0808               0032
0809               **** **** ****     > runlib.asm
0810               0088                       copy  "cpu_crash.asm"            ; CPU crash handler
0811               **** **** ****     > cpu_crash.asm
0812               0001               * FILE......: cpu_crash.asm
0813               0002               * Purpose...: Custom crash handler module
0814               0003
0815               0004
0816               0005               ***************************************************************
0817               0006               * cpu.crash - CPU program crashed handler
0818               0007               ***************************************************************
0819               0008               *  bl   @cpu.crash
0820               0009               *--------------------------------------------------------------
0821               0010               * Crash and halt system. Upon crash entry register contents are
0822               0011               * copied to the memory region >ffe0 - >fffe and displayed after
0823               0012               * resetting the spectra2 runtime library, video modes, etc.
0824               0013               *
0825               0014               * Diagnostics
0826               0015               * >ffce  caller address
0827               0016               *
0828               0017               * Register contents
0829               0018               * >ffdc  wp
0830               0019               * >ffde  st
0831               0020               * >ffe0  r0
0832               0021               * >ffe2  r1
0833               0022               * >ffe4  r2  (config)
0834               0023               * >ffe6  r3
0835               0024               * >ffe8  r4  (tmp0)
0836               0025               * >ffea  r5  (tmp1)
0837               0026               * >ffec  r6  (tmp2)
0838               0027               * >ffee  r7  (tmp3)
0839               0028               * >fff0  r8  (tmp4)
0840               0029               * >fff2  r9  (stack)
0841               0030               * >fff4  r10
0842               0031               * >fff6  r11
0843               0032               * >fff8  r12
0844               0033               * >fffa  r13
0845               0034               * >fffc  r14
0846               0035               * >fffe  r15
0847               0036               ********|*****|*********************|**************************
0848               0037               cpu.crash:
0849               0038 60A4 022B  22         ai    r11,-4                ; Remove opcode offset
0850                    60A6 FFFC
0851               0039               *--------------------------------------------------------------
0852               0040               *    Save registers to high memory
0853               0041               *--------------------------------------------------------------
0854               0042 60A8 C800  38         mov   r0,@>ffe0
0855                    60AA FFE0
0856               0043 60AC C801  38         mov   r1,@>ffe2
0857                    60AE FFE2
0858               0044 60B0 C802  38         mov   r2,@>ffe4
0859                    60B2 FFE4
0860               0045 60B4 C803  38         mov   r3,@>ffe6
0861                    60B6 FFE6
0862               0046 60B8 C804  38         mov   r4,@>ffe8
0863                    60BA FFE8
0864               0047 60BC C805  38         mov   r5,@>ffea
0865                    60BE FFEA
0866               0048 60C0 C806  38         mov   r6,@>ffec
0867                    60C2 FFEC
0868               0049 60C4 C807  38         mov   r7,@>ffee
0869                    60C6 FFEE
0870               0050 60C8 C808  38         mov   r8,@>fff0
0871                    60CA FFF0
0872               0051 60CC C809  38         mov   r9,@>fff2
0873                    60CE FFF2
0874               0052 60D0 C80A  38         mov   r10,@>fff4
0875                    60D2 FFF4
0876               0053 60D4 C80B  38         mov   r11,@>fff6
0877                    60D6 FFF6
0878               0054 60D8 C80C  38         mov   r12,@>fff8
0879                    60DA FFF8
0880               0055 60DC C80D  38         mov   r13,@>fffa
0881                    60DE FFFA
0882               0056 60E0 C80E  38         mov   r14,@>fffc
0883                    60E2 FFFC
0884               0057 60E4 C80F  38         mov   r15,@>ffff
0885                    60E6 FFFF
0886               0058 60E8 02A0  12         stwp  r0
0887               0059 60EA C800  38         mov   r0,@>ffdc
0888                    60EC FFDC
0889               0060 60EE 02C0  12         stst  r0
0890               0061 60F0 C800  38         mov   r0,@>ffde
0891                    60F2 FFDE
0892               0062               *--------------------------------------------------------------
0893               0063               *    Reset system
0894               0064               *--------------------------------------------------------------
0895               0065               cpu.crash.reset:
0896               0066 60F4 02E0  18         lwpi  ws1                   ; Activate workspace 1
0897                    60F6 8300
0898               0067 60F8 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
0899                    60FA 8302
0900               0068 60FC 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
0901                    60FE 4A4A
0902               0069 6100 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
0903                    6102 2DF2
0904               0070               *--------------------------------------------------------------
0905               0071               *    Show diagnostics after system reset
0906               0072               *--------------------------------------------------------------
0907               0073               cpu.crash.main:
0908               0074                       ;------------------------------------------------------
0909               0075                       ; Load "32x24" video mode & font
0910               0076                       ;------------------------------------------------------
0911               0077 6104 06A0  32         bl    @vidtab               ; Load video mode table into VDP
0912                    6106 22F2
0913               0078 6108 21F2                   data graph1           ; Equate selected video mode table
0914               0079
0915               0080 610A 06A0  32         bl    @ldfnt
0916                    610C 235A
0917               0081 610E 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
0918                    6110 000C
0919               0082
0920               0083 6112 06A0  32         bl    @filv
0921                    6114 2288
0922               0084 6116 0380                   data >0380,>f0,32*24  ; Load color table
0923                    6118 00F0
0924                    611A 0300
0925               0085                       ;------------------------------------------------------
0926               0086                       ; Show crash details
0927               0087                       ;------------------------------------------------------
0928               0088 611C 06A0  32         bl    @putat                ; Show crash message
0929                    611E 243C
0930               0089 6120 0000                   data >0000,cpu.crash.msg.crashed
0931                    6122 2182
0932               0090
0933               0091 6124 06A0  32         bl    @puthex               ; Put hex value on screen
0934                    6126 2978
0935               0092 6128 0015                   byte 0,21             ; \ i  p0 = YX position
0936               0093 612A FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0937               0094 612C 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0938               0095 612E 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0939               0096                                                   ; /         LSB offset for ASCII digit 0-9
0940               0097                       ;------------------------------------------------------
0941               0098                       ; Show caller details
0942               0099                       ;------------------------------------------------------
0943               0100 6130 06A0  32         bl    @putat                ; Show caller message
0944                    6132 243C
0945               0101 6134 0100                   data >0100,cpu.crash.msg.caller
0946                    6136 2198
0947               0102
0948               0103 6138 06A0  32         bl    @puthex               ; Put hex value on screen
0949                    613A 2978
0950               0104 613C 0115                   byte 1,21             ; \ i  p0 = YX position
0951               0105 613E FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0952               0106 6140 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0953               0107 6142 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0954               0108                                                   ; /         LSB offset for ASCII digit 0-9
0955               0109                       ;------------------------------------------------------
0956               0110                       ; Display labels
0957               0111                       ;------------------------------------------------------
0958               0112 6144 06A0  32         bl    @putat
0959                    6146 243C
0960               0113 6148 0300                   byte 3,0
0961               0114 614A 21B2                   data cpu.crash.msg.wp
0962               0115 614C 06A0  32         bl    @putat
0963                    614E 243C
0964               0116 6150 0400                   byte 4,0
0965               0117 6152 21B8                   data cpu.crash.msg.st
0966               0118 6154 06A0  32         bl    @putat
0967                    6156 243C
0968               0119 6158 1600                   byte 22,0
0969               0120 615A 21BE                   data cpu.crash.msg.source
0970               0121 615C 06A0  32         bl    @putat
0971                    615E 243C
0972               0122 6160 1700                   byte 23,0
0973               0123 6162 21DA                   data cpu.crash.msg.id
0974               0124                       ;------------------------------------------------------
0975               0125                       ; Show crash registers WP, ST, R0 - R15
0976               0126                       ;------------------------------------------------------
0977               0127 6164 06A0  32         bl    @at                   ; Put cursor at YX
0978                    6166 2680
0979               0128 6168 0304                   byte 3,4              ; \ i p0 = YX position
0980               0129                                                   ; /
0981               0130
0982               0131 616A 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
0983                    616C FFDC
0984               0132 616E 04C6  14         clr   tmp2                  ; Loop counter
0985               0133
0986               0134               cpu.crash.showreg:
0987               0135 6170 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0988               0136
0989               0137 6172 0649  14         dect  stack
0990               0138 6174 C644  30         mov   tmp0,*stack           ; Push tmp0
0991               0139 6176 0649  14         dect  stack
0992               0140 6178 C645  30         mov   tmp1,*stack           ; Push tmp1
0993               0141 617A 0649  14         dect  stack
0994               0142 617C C646  30         mov   tmp2,*stack           ; Push tmp2
0995               0143                       ;------------------------------------------------------
0996               0144                       ; Display crash register number
0997               0145                       ;------------------------------------------------------
0998               0146               cpu.crash.showreg.label:
0999               0147 617E C046  18         mov   tmp2,r1               ; Save register number
1000               0148 6180 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
1001                    6182 0001
1002               0149 6184 121C  14         jle   cpu.crash.showreg.content
1003               0150                                                   ; Yes, skip
1004               0151
1005               0152 6186 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
1006               0153 6188 06A0  32         bl    @mknum
1007                    618A 2982
1008               0154 618C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
1009               0155 618E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
1010               0156 6190 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
1011               0157                                                   ; /         LSB offset for ASCII digit 0-9
1012               0158
1013               0159 6192 06A0  32         bl    @setx                 ; Set cursor X position
1014                    6194 2696
1015               0160 6196 0000                   data 0                ; \ i  p0 =  Cursor Y position
1016               0161                                                   ; /
1017               0162
1018               0163 6198 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
1019                    619A 2418
1020               0164 619C 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
1021               0165                                                   ; /
1022               0166
1023               0167 619E 06A0  32         bl    @setx                 ; Set cursor X position
1024                    61A0 2696
1025               0168 61A2 0002                   data 2                ; \ i  p0 =  Cursor Y position
1026               0169                                                   ; /
1027               0170
1028               0171 61A4 0281  22         ci    r1,10
1029                    61A6 000A
1030               0172 61A8 1102  14         jlt   !
1031               0173 61AA 0620  34         dec   @wyx                  ; x=x-1
1032                    61AC 832A
1033               0174
1034               0175 61AE 06A0  32 !       bl    @putstr
1035                    61B0 2418
1036               0176 61B2 21AE                   data cpu.crash.msg.r
1037               0177
1038               0178 61B4 06A0  32         bl    @mknum
1039                    61B6 2982
1040               0179 61B8 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
1041               0180 61BA 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
1042               0181 61BC 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
1043               0182                                                   ; /         LSB offset for ASCII digit 0-9
1044               0183                       ;------------------------------------------------------
1045               0184                       ; Display crash register content
1046               0185                       ;------------------------------------------------------
1047               0186               cpu.crash.showreg.content:
1048               0187 61BE 06A0  32         bl    @mkhex                ; Convert hex word to string
1049                    61C0 28F4
1050               0188 61C2 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
1051               0189 61C4 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
1052               0190 61C6 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
1053               0191                                                   ; /         LSB offset for ASCII digit 0-9
1054               0192
1055               0193 61C8 06A0  32         bl    @setx                 ; Set cursor X position
1056                    61CA 2696
1057               0194 61CC 0006                   data 6                ; \ i  p0 =  Cursor Y position
1058               0195                                                   ; /
1059               0196
1060               0197 61CE 06A0  32         bl    @putstr
1061                    61D0 2418
1062               0198 61D2 21B0                   data cpu.crash.msg.marker
1063               0199
1064               0200 61D4 06A0  32         bl    @setx                 ; Set cursor X position
1065                    61D6 2696
1066               0201 61D8 0007                   data 7                ; \ i  p0 =  Cursor Y position
1067               0202                                                   ; /
1068               0203
1069               0204 61DA 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
1070                    61DC 2418
1071               0205 61DE 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
1072               0206                                                   ; /
1073               0207
1074               0208 61E0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
1075               0209 61E2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
1076               0210 61E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
1077               0211
1078               0212 61E6 06A0  32         bl    @down                 ; y=y+1
1079                    61E8 2686
1080               0213
1081               0214 61EA 0586  14         inc   tmp2
1082               0215 61EC 0286  22         ci    tmp2,17
1083                    61EE 0011
1084               0216 61F0 12BF  14         jle   cpu.crash.showreg     ; Show next register
1085               0217                       ;------------------------------------------------------
1086               0218                       ; Kernel takes over
1087               0219                       ;------------------------------------------------------
1088               0220 61F2 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
1089                    61F4 2CEC
1090               0221
1091               0222
1092               0223               cpu.crash.msg.crashed
1093               0224 61F6 1553             byte  21
1094               0225 61F7 ....             text  'System crashed near >'
1095               0226                       even
1096               0227
1097               0228               cpu.crash.msg.caller
1098               0229 620C 1543             byte  21
1099               0230 620D ....             text  'Caller address near >'
1100               0231                       even
1101               0232
1102               0233               cpu.crash.msg.r
1103               0234 6222 0152             byte  1
1104               0235 6223 ....             text  'R'
1105               0236                       even
1106               0237
1107               0238               cpu.crash.msg.marker
1108               0239 6224 013E             byte  1
1109               0240 6225 ....             text  '>'
1110               0241                       even
1111               0242
1112               0243               cpu.crash.msg.wp
1113               0244 6226 042A             byte  4
1114               0245 6227 ....             text  '**WP'
1115               0246                       even
1116               0247
1117               0248               cpu.crash.msg.st
1118               0249 622C 042A             byte  4
1119               0250 622D ....             text  '**ST'
1120               0251                       even
1121               0252
1122               0253               cpu.crash.msg.source
1123               0254 6232 1B53             byte  27
1124               0255 6233 ....             text  'Source    stevie_b0.lst.asm'
1125               0256                       even
1126               0257
1127               0258               cpu.crash.msg.id
1128               0259 624E 1642             byte  22
1129               0260 624F ....             text  'Build-ID  200803-22608'
1130               0261                       even
1131               0262
1132               **** **** ****     > runlib.asm
1133               0089                       copy  "vdp_tables.asm"           ; Data used by runtime library
1134               **** **** ****     > vdp_tables.asm
1135               0001               * FILE......: vdp_tables.a99
1136               0002               * Purpose...: Video mode tables
1137               0003
1138               0004               ***************************************************************
1139               0005               * Graphics mode 1 (32 columns/24 rows)
1140               0006               *--------------------------------------------------------------
1141               0007 6266 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
1142                    6268 000E
1143                    626A 0106
1144                    626C 0204
1145                    626E 0020
1146               0008               *
1147               0009               * ; VDP#0 Control bits
1148               0010               * ;      bit 6=0: M3 | Graphics 1 mode
1149               0011               * ;      bit 7=0: Disable external VDP input
1150               0012               * ; VDP#1 Control bits
1151               0013               * ;      bit 0=1: 16K selection
1152               0014               * ;      bit 1=1: Enable display
1153               0015               * ;      bit 2=1: Enable VDP interrupt
1154               0016               * ;      bit 3=0: M1 \ Graphics 1 mode
1155               0017               * ;      bit 4=0: M2 /
1156               0018               * ;      bit 5=0: reserved
1157               0019               * ;      bit 6=1: 16x16 sprites
1158               0020               * ;      bit 7=0: Sprite magnification (1x)
1159               0021               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1160               0022               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
1161               0023               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
1162               0024               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
1163               0025               * ; VDP#6 SPT (Sprite pattern table)     at >1000  (>02 * >800)
1164               0026               * ; VDP#7 Set screen background color
1165               0027
1166               0028
1167               0029               ***************************************************************
1168               0030               * Textmode (40 columns/24 rows)
1169               0031               *--------------------------------------------------------------
1170               0032 6270 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
1171                    6272 000E
1172                    6274 0106
1173                    6276 00F4
1174                    6278 0028
1175               0033               *
1176               0034               * ; VDP#0 Control bits
1177               0035               * ;      bit 6=0: M3 | Graphics 1 mode
1178               0036               * ;      bit 7=0: Disable external VDP input
1179               0037               * ; VDP#1 Control bits
1180               0038               * ;      bit 0=1: 16K selection
1181               0039               * ;      bit 1=1: Enable display
1182               0040               * ;      bit 2=1: Enable VDP interrupt
1183               0041               * ;      bit 3=1: M1 \ TEXT MODE
1184               0042               * ;      bit 4=0: M2 /
1185               0043               * ;      bit 5=0: reserved
1186               0044               * ;      bit 6=1: 16x16 sprites
1187               0045               * ;      bit 7=0: Sprite magnification (1x)
1188               0046               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1189               0047               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
1190               0048               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
1191               0049               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
1192               0050               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
1193               0051               * ; VDP#7 Set foreground/background color
1194               0052               ***************************************************************
1195               0053
1196               0054
1197               0055               ***************************************************************
1198               0056               * Textmode (80 columns, 24 rows) - F18A
1199               0057               *--------------------------------------------------------------
1200               0058 627A 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
1201                    627C 003F
1202                    627E 0240
1203                    6280 03F4
1204                    6282 0050
1205               0059               *
1206               0060               * ; VDP#0 Control bits
1207               0061               * ;      bit 6=0: M3 | Graphics 1 mode
1208               0062               * ;      bit 7=0: Disable external VDP input
1209               0063               * ; VDP#1 Control bits
1210               0064               * ;      bit 0=1: 16K selection
1211               0065               * ;      bit 1=1: Enable display
1212               0066               * ;      bit 2=1: Enable VDP interrupt
1213               0067               * ;      bit 3=1: M1 \ TEXT MODE
1214               0068               * ;      bit 4=0: M2 /
1215               0069               * ;      bit 5=0: reserved
1216               0070               * ;      bit 6=0: 8x8 sprites
1217               0071               * ;      bit 7=0: Sprite magnification (1x)
1218               0072               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1219               0073               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
1220               0074               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
1221               0075               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
1222               0076               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
1223               0077               * ; VDP#7 Set foreground/background color
1224               0078               ***************************************************************
1225               0079
1226               0080
1227               0081               ***************************************************************
1228               0082               * Textmode (80 columns, 30 rows) - F18A
1229               0083               *--------------------------------------------------------------
1230               0084 6284 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
1231                    6286 003F
1232                    6288 0240
1233                    628A 03F4
1234                    628C 0050
1235               0085               *
1236               0086               * ; VDP#0 Control bits
1237               0087               * ;      bit 6=0: M3 | Graphics 1 mode
1238               0088               * ;      bit 7=0: Disable external VDP input
1239               0089               * ; VDP#1 Control bits
1240               0090               * ;      bit 0=1: 16K selection
1241               0091               * ;      bit 1=1: Enable display
1242               0092               * ;      bit 2=1: Enable VDP interrupt
1243               0093               * ;      bit 3=1: M1 \ TEXT MODE
1244               0094               * ;      bit 4=0: M2 /
1245               0095               * ;      bit 5=0: reserved
1246               0096               * ;      bit 6=0: 8x8 sprites
1247               0097               * ;      bit 7=0: Sprite magnification (1x)
1248               0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
1249               0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
1250               0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
1251               0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
1252               0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
1253               0103               * ; VDP#7 Set foreground/background color
1254               0104               ***************************************************************
1255               **** **** ****     > runlib.asm
1256               0090                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
1257               **** **** ****     > basic_cpu_vdp.asm
1258               0001               * FILE......: basic_cpu_vdp.asm
1259               0002               * Purpose...: Basic CPU & VDP functions used by other modules
1260               0003
1261               0004               *//////////////////////////////////////////////////////////////
1262               0005               *       Support Machine Code for copy & fill functions
1263               0006               *//////////////////////////////////////////////////////////////
1264               0007
1265               0008               *--------------------------------------------------------------
1266               0009               * ; Machine code for tight loop.
1267               0010               * ; The MOV operation at MCLOOP must be injected by the calling routine.
1268               0011               *--------------------------------------------------------------
1269               0012               *       DATA  >????                 ; \ mcloop  mov   ...
1270               0013 628E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
1271               0014 6290 16FD             data  >16fd                 ; |         jne   mcloop
1272               0015 6292 045B             data  >045b                 ; /         b     *r11
1273               0016               *--------------------------------------------------------------
1274               0017               * ; Machine code for reading from the speech synthesizer
1275               0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
1276               0019               * ; Is required for the 12 uS delay. It destroys R5.
1277               0020               *--------------------------------------------------------------
1278               0021 6294 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
1279               0022 6296 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
1280               0023                       even
1281               0024
1282               0025
1283               0026               *//////////////////////////////////////////////////////////////
1284               0027               *                    STACK SUPPORT FUNCTIONS
1285               0028               *//////////////////////////////////////////////////////////////
1286               0029
1287               0030               ***************************************************************
1288               0031               * POPR. - Pop registers & return to caller
1289               0032               ***************************************************************
1290               0033               *  B  @POPRG.
1291               0034               *--------------------------------------------------------------
1292               0035               *  REMARKS
1293               0036               *  R11 must be at stack bottom
1294               0037               ********|*****|*********************|**************************
1295               0038 6298 C0F9  30 popr3   mov   *stack+,r3
1296               0039 629A C0B9  30 popr2   mov   *stack+,r2
1297               0040 629C C079  30 popr1   mov   *stack+,r1
1298               0041 629E C039  30 popr0   mov   *stack+,r0
1299               0042 62A0 C2F9  30 poprt   mov   *stack+,r11
1300               0043 62A2 045B  20         b     *r11
1301               0044
1302               0045
1303               0046
1304               0047               *//////////////////////////////////////////////////////////////
1305               0048               *                   MEMORY FILL FUNCTIONS
1306               0049               *//////////////////////////////////////////////////////////////
1307               0050
1308               0051               ***************************************************************
1309               0052               * FILM - Fill CPU memory with byte
1310               0053               ***************************************************************
1311               0054               *  bl   @film
1312               0055               *  data P0,P1,P2
1313               0056               *--------------------------------------------------------------
1314               0057               *  P0 = Memory start address
1315               0058               *  P1 = Byte to fill
1316               0059               *  P2 = Number of bytes to fill
1317               0060               *--------------------------------------------------------------
1318               0061               *  bl   @xfilm
1319               0062               *
1320               0063               *  TMP0 = Memory start address
1321               0064               *  TMP1 = Byte to fill
1322               0065               *  TMP2 = Number of bytes to fill
1323               0066               ********|*****|*********************|**************************
1324               0067 62A4 C13B  30 film    mov   *r11+,tmp0            ; Memory start
1325               0068 62A6 C17B  30         mov   *r11+,tmp1            ; Byte to fill
1326               0069 62A8 C1BB  30         mov   *r11+,tmp2            ; Repeat count
1327               0070               *--------------------------------------------------------------
1328               0071               * Do some checks first
1329               0072               *--------------------------------------------------------------
1330               0073 62AA C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
1331               0074 62AC 1604  14         jne   filchk                ; No, continue checking
1332               0075
1333               0076 62AE C80B  38         mov   r11,@>ffce            ; \ Save caller address
1334                    62B0 FFCE
1335               0077 62B2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1336                    62B4 2030
1337               0078               *--------------------------------------------------------------
1338               0079               *       Check: 1 byte fill
1339               0080               *--------------------------------------------------------------
1340               0081 62B6 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
1341                    62B8 830B
1342                    62BA 830A
1343               0082
1344               0083 62BC 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
1345                    62BE 0001
1346               0084 62C0 1602  14         jne   filchk2
1347               0085 62C2 DD05  32         movb  tmp1,*tmp0+
1348               0086 62C4 045B  20         b     *r11                  ; Exit
1349               0087               *--------------------------------------------------------------
1350               0088               *       Check: 2 byte fill
1351               0089               *--------------------------------------------------------------
1352               0090 62C6 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
1353                    62C8 0002
1354               0091 62CA 1603  14         jne   filchk3
1355               0092 62CC DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
1356               0093 62CE DD05  32         movb  tmp1,*tmp0+
1357               0094 62D0 045B  20         b     *r11                  ; Exit
1358               0095               *--------------------------------------------------------------
1359               0096               *       Check: Handle uneven start address
1360               0097               *--------------------------------------------------------------
1361               0098 62D2 C1C4  18 filchk3 mov   tmp0,tmp3
1362               0099 62D4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1363                    62D6 0001
1364               0100 62D8 1605  14         jne   fil16b
1365               0101 62DA DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
1366               0102 62DC 0606  14         dec   tmp2
1367               0103 62DE 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
1368                    62E0 0002
1369               0104 62E2 13F1  14         jeq   filchk2               ; Yes, copy word and exit
1370               0105               *--------------------------------------------------------------
1371               0106               *       Fill memory with 16 bit words
1372               0107               *--------------------------------------------------------------
1373               0108 62E4 C1C6  18 fil16b  mov   tmp2,tmp3
1374               0109 62E6 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1375                    62E8 0001
1376               0110 62EA 1301  14         jeq   dofill
1377               0111 62EC 0606  14         dec   tmp2                  ; Make TMP2 even
1378               0112 62EE CD05  34 dofill  mov   tmp1,*tmp0+
1379               0113 62F0 0646  14         dect  tmp2
1380               0114 62F2 16FD  14         jne   dofill
1381               0115               *--------------------------------------------------------------
1382               0116               * Fill last byte if ODD
1383               0117               *--------------------------------------------------------------
1384               0118 62F4 C1C7  18         mov   tmp3,tmp3
1385               0119 62F6 1301  14         jeq   fil.$$
1386               0120 62F8 DD05  32         movb  tmp1,*tmp0+
1387               0121 62FA 045B  20 fil.$$  b     *r11
1388               0122
1389               0123
1390               0124               ***************************************************************
1391               0125               * FILV - Fill VRAM with byte
1392               0126               ***************************************************************
1393               0127               *  BL   @FILV
1394               0128               *  DATA P0,P1,P2
1395               0129               *--------------------------------------------------------------
1396               0130               *  P0 = VDP start address
1397               0131               *  P1 = Byte to fill
1398               0132               *  P2 = Number of bytes to fill
1399               0133               *--------------------------------------------------------------
1400               0134               *  BL   @XFILV
1401               0135               *
1402               0136               *  TMP0 = VDP start address
1403               0137               *  TMP1 = Byte to fill
1404               0138               *  TMP2 = Number of bytes to fill
1405               0139               ********|*****|*********************|**************************
1406               0140 62FC C13B  30 filv    mov   *r11+,tmp0            ; Memory start
1407               0141 62FE C17B  30         mov   *r11+,tmp1            ; Byte to fill
1408               0142 6300 C1BB  30         mov   *r11+,tmp2            ; Repeat count
1409               0143               *--------------------------------------------------------------
1410               0144               *    Setup VDP write address
1411               0145               *--------------------------------------------------------------
1412               0146 6302 0264  22 xfilv   ori   tmp0,>4000
1413                    6304 4000
1414               0147 6306 06C4  14         swpb  tmp0
1415               0148 6308 D804  38         movb  tmp0,@vdpa
1416                    630A 8C02
1417               0149 630C 06C4  14         swpb  tmp0
1418               0150 630E D804  38         movb  tmp0,@vdpa
1419                    6310 8C02
1420               0151               *--------------------------------------------------------------
1421               0152               *    Fill bytes in VDP memory
1422               0153               *--------------------------------------------------------------
1423               0154 6312 020F  20         li    r15,vdpw              ; Set VDP write address
1424                    6314 8C00
1425               0155 6316 06C5  14         swpb  tmp1
1426               0156 6318 C820  54         mov   @filzz,@mcloop        ; Setup move command
1427                    631A 22AE
1428                    631C 8320
1429               0157 631E 0460  28         b     @mcloop               ; Write data to VDP
1430                    6320 8320
1431               0158               *--------------------------------------------------------------
1432               0162 6322 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
1433               0164
1434               0165
1435               0166
1436               0167               *//////////////////////////////////////////////////////////////
1437               0168               *                  VDP LOW LEVEL FUNCTIONS
1438               0169               *//////////////////////////////////////////////////////////////
1439               0170
1440               0171               ***************************************************************
1441               0172               * VDWA / VDRA - Setup VDP write or read address
1442               0173               ***************************************************************
1443               0174               *  BL   @VDWA
1444               0175               *
1445               0176               *  TMP0 = VDP destination address for write
1446               0177               *--------------------------------------------------------------
1447               0178               *  BL   @VDRA
1448               0179               *
1449               0180               *  TMP0 = VDP source address for read
1450               0181               ********|*****|*********************|**************************
1451               0182 6324 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
1452                    6326 4000
1453               0183 6328 06C4  14 vdra    swpb  tmp0
1454               0184 632A D804  38         movb  tmp0,@vdpa
1455                    632C 8C02
1456               0185 632E 06C4  14         swpb  tmp0
1457               0186 6330 D804  38         movb  tmp0,@vdpa            ; Set VDP address
1458                    6332 8C02
1459               0187 6334 045B  20         b     *r11                  ; Exit
1460               0188
1461               0189               ***************************************************************
1462               0190               * VPUTB - VDP put single byte
1463               0191               ***************************************************************
1464               0192               *  BL @VPUTB
1465               0193               *  DATA P0,P1
1466               0194               *--------------------------------------------------------------
1467               0195               *  P0 = VDP target address
1468               0196               *  P1 = Byte to write
1469               0197               ********|*****|*********************|**************************
1470               0198 6336 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
1471               0199 6338 C17B  30         mov   *r11+,tmp1            ; Get byte to write
1472               0200               *--------------------------------------------------------------
1473               0201               * Set VDP write address
1474               0202               *--------------------------------------------------------------
1475               0203 633A 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
1476                    633C 4000
1477               0204 633E 06C4  14         swpb  tmp0                  ; \
1478               0205 6340 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
1479                    6342 8C02
1480               0206 6344 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
1481               0207 6346 D804  38         movb  tmp0,@vdpa            ; /
1482                    6348 8C02
1483               0208               *--------------------------------------------------------------
1484               0209               * Write byte
1485               0210               *--------------------------------------------------------------
1486               0211 634A 06C5  14         swpb  tmp1                  ; LSB to MSB
1487               0212 634C D7C5  30         movb  tmp1,*r15             ; Write byte
1488               0213 634E 045B  20         b     *r11                  ; Exit
1489               0214
1490               0215
1491               0216               ***************************************************************
1492               0217               * VGETB - VDP get single byte
1493               0218               ***************************************************************
1494               0219               *  bl   @vgetb
1495               0220               *  data p0
1496               0221               *--------------------------------------------------------------
1497               0222               *  P0 = VDP source address
1498               0223               *--------------------------------------------------------------
1499               0224               *  bl   @xvgetb
1500               0225               *
1501               0226               *  tmp0 = VDP source address
1502               0227               *--------------------------------------------------------------
1503               0228               *  Output:
1504               0229               *  tmp0 MSB = >00
1505               0230               *  tmp0 LSB = VDP byte read
1506               0231               ********|*****|*********************|**************************
1507               0232 6350 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
1508               0233               *--------------------------------------------------------------
1509               0234               * Set VDP read address
1510               0235               *--------------------------------------------------------------
1511               0236 6352 06C4  14 xvgetb  swpb  tmp0                  ; \
1512               0237 6354 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
1513                    6356 8C02
1514               0238 6358 06C4  14         swpb  tmp0                  ; | inlined @vdra call
1515               0239 635A D804  38         movb  tmp0,@vdpa            ; /
1516                    635C 8C02
1517               0240               *--------------------------------------------------------------
1518               0241               * Read byte
1519               0242               *--------------------------------------------------------------
1520               0243 635E D120  34         movb  @vdpr,tmp0            ; Read byte
1521                    6360 8800
1522               0244 6362 0984  56         srl   tmp0,8                ; Right align
1523               0245 6364 045B  20         b     *r11                  ; Exit
1524               0246
1525               0247
1526               0248               ***************************************************************
1527               0249               * VIDTAB - Dump videomode table
1528               0250               ***************************************************************
1529               0251               *  BL   @VIDTAB
1530               0252               *  DATA P0
1531               0253               *--------------------------------------------------------------
1532               0254               *  P0 = Address of video mode table
1533               0255               *--------------------------------------------------------------
1534               0256               *  BL   @XIDTAB
1535               0257               *
1536               0258               *  TMP0 = Address of video mode table
1537               0259               *--------------------------------------------------------------
1538               0260               *  Remarks
1539               0261               *  TMP1 = MSB is the VDP target register
1540               0262               *         LSB is the value to write
1541               0263               ********|*****|*********************|**************************
1542               0264 6366 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
1543               0265 6368 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
1544               0266               *--------------------------------------------------------------
1545               0267               * Calculate PNT base address
1546               0268               *--------------------------------------------------------------
1547               0269 636A C144  18         mov   tmp0,tmp1
1548               0270 636C 05C5  14         inct  tmp1
1549               0271 636E D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
1550               0272 6370 0245  22         andi  tmp1,>ff00            ; Only keep MSB
1551                    6372 FF00
1552               0273 6374 0A25  56         sla   tmp1,2                ; TMP1 *= 400
1553               0274 6376 C805  38         mov   tmp1,@wbase           ; Store calculated base
1554                    6378 8328
1555               0275               *--------------------------------------------------------------
1556               0276               * Dump VDP shadow registers
1557               0277               *--------------------------------------------------------------
1558               0278 637A 0205  20         li    tmp1,>8000            ; Start with VDP register 0
1559                    637C 8000
1560               0279 637E 0206  20         li    tmp2,8
1561                    6380 0008
1562               0280 6382 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
1563                    6384 830B
1564               0281 6386 06C5  14         swpb  tmp1
1565               0282 6388 D805  38         movb  tmp1,@vdpa
1566                    638A 8C02
1567               0283 638C 06C5  14         swpb  tmp1
1568               0284 638E D805  38         movb  tmp1,@vdpa
1569                    6390 8C02
1570               0285 6392 0225  22         ai    tmp1,>0100
1571                    6394 0100
1572               0286 6396 0606  14         dec   tmp2
1573               0287 6398 16F4  14         jne   vidta1                ; Next register
1574               0288 639A C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
1575                    639C 833A
1576               0289 639E 045B  20         b     *r11
1577               0290
1578               0291
1579               0292               ***************************************************************
1580               0293               * PUTVR  - Put single VDP register
1581               0294               ***************************************************************
1582               0295               *  BL   @PUTVR
1583               0296               *  DATA P0
1584               0297               *--------------------------------------------------------------
1585               0298               *  P0 = MSB is the VDP target register
1586               0299               *       LSB is the value to write
1587               0300               *--------------------------------------------------------------
1588               0301               *  BL   @PUTVRX
1589               0302               *
1590               0303               *  TMP0 = MSB is the VDP target register
1591               0304               *         LSB is the value to write
1592               0305               ********|*****|*********************|**************************
1593               0306 63A0 C13B  30 putvr   mov   *r11+,tmp0
1594               0307 63A2 0264  22 putvrx  ori   tmp0,>8000
1595                    63A4 8000
1596               0308 63A6 06C4  14         swpb  tmp0
1597               0309 63A8 D804  38         movb  tmp0,@vdpa
1598                    63AA 8C02
1599               0310 63AC 06C4  14         swpb  tmp0
1600               0311 63AE D804  38         movb  tmp0,@vdpa
1601                    63B0 8C02
1602               0312 63B2 045B  20         b     *r11
1603               0313
1604               0314
1605               0315               ***************************************************************
1606               0316               * PUTV01  - Put VDP registers #0 and #1
1607               0317               ***************************************************************
1608               0318               *  BL   @PUTV01
1609               0319               ********|*****|*********************|**************************
1610               0320 63B4 C20B  18 putv01  mov   r11,tmp4              ; Save R11
1611               0321 63B6 C10E  18         mov   r14,tmp0
1612               0322 63B8 0984  56         srl   tmp0,8
1613               0323 63BA 06A0  32         bl    @putvrx               ; Write VR#0
1614                    63BC 232E
1615               0324 63BE 0204  20         li    tmp0,>0100
1616                    63C0 0100
1617               0325 63C2 D820  54         movb  @r14lb,@tmp0lb
1618                    63C4 831D
1619                    63C6 8309
1620               0326 63C8 06A0  32         bl    @putvrx               ; Write VR#1
1621                    63CA 232E
1622               0327 63CC 0458  20         b     *tmp4                 ; Exit
1623               0328
1624               0329
1625               0330               ***************************************************************
1626               0331               * LDFNT - Load TI-99/4A font from GROM into VDP
1627               0332               ***************************************************************
1628               0333               *  BL   @LDFNT
1629               0334               *  DATA P0,P1
1630               0335               *--------------------------------------------------------------
1631               0336               *  P0 = VDP Target address
1632               0337               *  P1 = Font options
1633               0338               *--------------------------------------------------------------
1634               0339               * Uses registers tmp0-tmp4
1635               0340               ********|*****|*********************|**************************
1636               0341 63CE C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
1637               0342 63D0 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
1638               0343 63D2 C11B  26         mov   *r11,tmp0             ; Get P0
1639               0344 63D4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
1640                    63D6 7FFF
1641               0345 63D8 2120  38         coc   @wbit0,tmp0
1642                    63DA 202A
1643               0346 63DC 1604  14         jne   ldfnt1
1644               0347 63DE 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
1645                    63E0 8000
1646               0348 63E2 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
1647                    63E4 7FFF
1648               0349               *--------------------------------------------------------------
1649               0350               * Read font table address from GROM into tmp1
1650               0351               *--------------------------------------------------------------
1651               0352 63E6 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
1652                    63E8 23DC
1653               0353 63EA D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
1654                    63EC 9C02
1655               0354 63EE 06C4  14         swpb  tmp0
1656               0355 63F0 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
1657                    63F2 9C02
1658               0356 63F4 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
1659                    63F6 9800
1660               0357 63F8 06C5  14         swpb  tmp1
1661               0358 63FA D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
1662                    63FC 9800
1663               0359 63FE 06C5  14         swpb  tmp1
1664               0360               *--------------------------------------------------------------
1665               0361               * Setup GROM source address from tmp1
1666               0362               *--------------------------------------------------------------
1667               0363 6400 D805  38         movb  tmp1,@grmwa
1668                    6402 9C02
1669               0364 6404 06C5  14         swpb  tmp1
1670               0365 6406 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
1671                    6408 9C02
1672               0366               *--------------------------------------------------------------
1673               0367               * Setup VDP target address
1674               0368               *--------------------------------------------------------------
1675               0369 640A C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
1676               0370 640C 06A0  32         bl    @vdwa                 ; Setup VDP destination address
1677                    640E 22B0
1678               0371 6410 05C8  14         inct  tmp4                  ; R11=R11+2
1679               0372 6412 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
1680               0373 6414 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
1681                    6416 7FFF
1682               0374 6418 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
1683                    641A 23DE
1684               0375 641C C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
1685                    641E 23E0
1686               0376               *--------------------------------------------------------------
1687               0377               * Copy from GROM to VRAM
1688               0378               *--------------------------------------------------------------
1689               0379 6420 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
1690               0380 6422 1812  14         joc   ldfnt4                ; Yes, go insert a >00
1691               0381 6424 D120  34         movb  @grmrd,tmp0
1692                    6426 9800
1693               0382               *--------------------------------------------------------------
1694               0383               *   Make font fat
1695               0384               *--------------------------------------------------------------
1696               0385 6428 20A0  38         coc   @wbit0,config         ; Fat flag set ?
1697                    642A 202A
1698               0386 642C 1603  14         jne   ldfnt3                ; No, so skip
1699               0387 642E D1C4  18         movb  tmp0,tmp3
1700               0388 6430 0917  56         srl   tmp3,1
1701               0389 6432 E107  18         soc   tmp3,tmp0
1702               0390               *--------------------------------------------------------------
1703               0391               *   Dump byte to VDP and do housekeeping
1704               0392               *--------------------------------------------------------------
1705               0393 6434 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
1706                    6436 8C00
1707               0394 6438 0606  14         dec   tmp2
1708               0395 643A 16F2  14         jne   ldfnt2
1709               0396 643C 05C8  14         inct  tmp4                  ; R11=R11+2
1710               0397 643E 020F  20         li    r15,vdpw              ; Set VDP write address
1711                    6440 8C00
1712               0398 6442 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
1713                    6444 7FFF
1714               0399 6446 0458  20         b     *tmp4                 ; Exit
1715               0400 6448 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
1716                    644A 200A
1717                    644C 8C00
1718               0401 644E 10E8  14         jmp   ldfnt2
1719               0402               *--------------------------------------------------------------
1720               0403               * Fonts pointer table
1721               0404               *--------------------------------------------------------------
1722               0405 6450 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
1723                    6452 0200
1724                    6454 0000
1725               0406 6456 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
1726                    6458 01C0
1727                    645A 0101
1728               0407 645C 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
1729                    645E 02A0
1730                    6460 0101
1731               0408 6462 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
1732                    6464 00E0
1733                    6466 0101
1734               0409
1735               0410
1736               0411
1737               0412               ***************************************************************
1738               0413               * YX2PNT - Get VDP PNT address for current YX cursor position
1739               0414               ***************************************************************
1740               0415               *  BL   @YX2PNT
1741               0416               *--------------------------------------------------------------
1742               0417               *  INPUT
1743               0418               *  @WYX = Cursor YX position
1744               0419               *--------------------------------------------------------------
1745               0420               *  OUTPUT
1746               0421               *  TMP0 = VDP address for entry in Pattern Name Table
1747               0422               *--------------------------------------------------------------
1748               0423               *  Register usage
1749               0424               *  TMP0, R14, R15
1750               0425               ********|*****|*********************|**************************
1751               0426 6468 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
1752               0427 646A C3A0  34         mov   @wyx,r14              ; Get YX
1753                    646C 832A
1754               0428 646E 098E  56         srl   r14,8                 ; Right justify (remove X)
1755               0429 6470 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
1756                    6472 833A
1757               0430               *--------------------------------------------------------------
1758               0431               * Do rest of calculation with R15 (16 bit part is there)
1759               0432               * Re-use R14
1760               0433               *--------------------------------------------------------------
1761               0434 6474 C3A0  34         mov   @wyx,r14              ; Get YX
1762                    6476 832A
1763               0435 6478 024E  22         andi  r14,>00ff             ; Remove Y
1764                    647A 00FF
1765               0436 647C A3CE  18         a     r14,r15               ; pos = pos + X
1766               0437 647E A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
1767                    6480 8328
1768               0438               *--------------------------------------------------------------
1769               0439               * Clean up before exit
1770               0440               *--------------------------------------------------------------
1771               0441 6482 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
1772               0442 6484 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
1773               0443 6486 020F  20         li    r15,vdpw              ; VDP write address
1774                    6488 8C00
1775               0444 648A 045B  20         b     *r11
1776               0445
1777               0446
1778               0447
1779               0448               ***************************************************************
1780               0449               * Put length-byte prefixed string at current YX
1781               0450               ***************************************************************
1782               0451               *  BL   @PUTSTR
1783               0452               *  DATA P0
1784               0453               *
1785               0454               *  P0 = Pointer to string
1786               0455               *--------------------------------------------------------------
1787               0456               *  REMARKS
1788               0457               *  First byte of string must contain length
1789               0458               ********|*****|*********************|**************************
1790               0459 648C C17B  30 putstr  mov   *r11+,tmp1
1791               0460 648E D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
1792               0461 6490 C1CB  18 xutstr  mov   r11,tmp3
1793               0462 6492 06A0  32         bl    @yx2pnt               ; Get VDP destination address
1794                    6494 23F4
1795               0463 6496 C2C7  18         mov   tmp3,r11
1796               0464 6498 0986  56         srl   tmp2,8                ; Right justify length byte
1797               0465               *--------------------------------------------------------------
1798               0466               * Put string
1799               0467               *--------------------------------------------------------------
1800               0468 649A C186  18         mov   tmp2,tmp2             ; Length = 0 ?
1801               0469 649C 1305  14         jeq   !                     ; Yes, crash and burn
1802               0470
1803               0471 649E 0286  22         ci    tmp2,255              ; Length > 255 ?
1804                    64A0 00FF
1805               0472 64A2 1502  14         jgt   !                     ; Yes, crash and burn
1806               0473
1807               0474 64A4 0460  28         b     @xpym2v               ; Display string
1808                    64A6 244A
1809               0475               *--------------------------------------------------------------
1810               0476               * Crash handler
1811               0477               *--------------------------------------------------------------
1812               0478 64A8 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
1813                    64AA FFCE
1814               0479 64AC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1815                    64AE 2030
1816               0480
1817               0481
1818               0482
1819               0483               ***************************************************************
1820               0484               * Put length-byte prefixed string at YX
1821               0485               ***************************************************************
1822               0486               *  BL   @PUTAT
1823               0487               *  DATA P0,P1
1824               0488               *
1825               0489               *  P0 = YX position
1826               0490               *  P1 = Pointer to string
1827               0491               *--------------------------------------------------------------
1828               0492               *  REMARKS
1829               0493               *  First byte of string must contain length
1830               0494               ********|*****|*********************|**************************
1831               0495 64B0 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
1832                    64B2 832A
1833               0496 64B4 0460  28         b     @putstr
1834                    64B6 2418
1835               **** **** ****     > runlib.asm
1836               0091
1837               0093                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
1838               **** **** ****     > copy_cpu_vram.asm
1839               0001               * FILE......: copy_cpu_vram.asm
1840               0002               * Purpose...: CPU memory to VRAM copy support module
1841               0003
1842               0004               ***************************************************************
1843               0005               * CPYM2V - Copy CPU memory to VRAM
1844               0006               ***************************************************************
1845               0007               *  BL   @CPYM2V
1846               0008               *  DATA P0,P1,P2
1847               0009               *--------------------------------------------------------------
1848               0010               *  P0 = VDP start address
1849               0011               *  P1 = RAM/ROM start address
1850               0012               *  P2 = Number of bytes to copy
1851               0013               *--------------------------------------------------------------
1852               0014               *  BL @XPYM2V
1853               0015               *
1854               0016               *  TMP0 = VDP start address
1855               0017               *  TMP1 = RAM/ROM start address
1856               0018               *  TMP2 = Number of bytes to copy
1857               0019               ********|*****|*********************|**************************
1858               0020 64B8 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
1859               0021 64BA C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
1860               0022 64BC C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
1861               0023               *--------------------------------------------------------------
1862               0024               *    Setup VDP write address
1863               0025               *--------------------------------------------------------------
1864               0026 64BE 0264  22 xpym2v  ori   tmp0,>4000
1865                    64C0 4000
1866               0027 64C2 06C4  14         swpb  tmp0
1867               0028 64C4 D804  38         movb  tmp0,@vdpa
1868                    64C6 8C02
1869               0029 64C8 06C4  14         swpb  tmp0
1870               0030 64CA D804  38         movb  tmp0,@vdpa
1871                    64CC 8C02
1872               0031               *--------------------------------------------------------------
1873               0032               *    Copy bytes from CPU memory to VRAM
1874               0033               *--------------------------------------------------------------
1875               0034 64CE 020F  20         li    r15,vdpw              ; Set VDP write address
1876                    64D0 8C00
1877               0035 64D2 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
1878                    64D4 2468
1879                    64D6 8320
1880               0036 64D8 0460  28         b     @mcloop               ; Write data to VDP
1881                    64DA 8320
1882               0037 64DC D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
1883               **** **** ****     > runlib.asm
1884               0095
1885               0097                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
1886               **** **** ****     > copy_vram_cpu.asm
1887               0001               * FILE......: copy_vram_cpu.asm
1888               0002               * Purpose...: VRAM to CPU memory copy support module
1889               0003
1890               0004               ***************************************************************
1891               0005               * CPYV2M - Copy VRAM to CPU memory
1892               0006               ***************************************************************
1893               0007               *  BL   @CPYV2M
1894               0008               *  DATA P0,P1,P2
1895               0009               *--------------------------------------------------------------
1896               0010               *  P0 = VDP source address
1897               0011               *  P1 = RAM target address
1898               0012               *  P2 = Number of bytes to copy
1899               0013               *--------------------------------------------------------------
1900               0014               *  BL @XPYV2M
1901               0015               *
1902               0016               *  TMP0 = VDP source address
1903               0017               *  TMP1 = RAM target address
1904               0018               *  TMP2 = Number of bytes to copy
1905               0019               ********|*****|*********************|**************************
1906               0020 64DE C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
1907               0021 64E0 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
1908               0022 64E2 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
1909               0023               *--------------------------------------------------------------
1910               0024               *    Setup VDP read address
1911               0025               *--------------------------------------------------------------
1912               0026 64E4 06C4  14 xpyv2m  swpb  tmp0
1913               0027 64E6 D804  38         movb  tmp0,@vdpa
1914                    64E8 8C02
1915               0028 64EA 06C4  14         swpb  tmp0
1916               0029 64EC D804  38         movb  tmp0,@vdpa
1917                    64EE 8C02
1918               0030               *--------------------------------------------------------------
1919               0031               *    Copy bytes from VDP memory to RAM
1920               0032               *--------------------------------------------------------------
1921               0033 64F0 020F  20         li    r15,vdpr              ; Set VDP read address
1922                    64F2 8800
1923               0034 64F4 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
1924                    64F6 248A
1925                    64F8 8320
1926               0035 64FA 0460  28         b     @mcloop               ; Read data from VDP
1927                    64FC 8320
1928               0036 64FE DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
1929               **** **** ****     > runlib.asm
1930               0099
1931               0101                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
1932               **** **** ****     > copy_cpu_cpu.asm
1933               0001               * FILE......: copy_cpu_cpu.asm
1934               0002               * Purpose...: CPU to CPU memory copy support module
1935               0003
1936               0004               *//////////////////////////////////////////////////////////////
1937               0005               *                       CPU COPY FUNCTIONS
1938               0006               *//////////////////////////////////////////////////////////////
1939               0007
1940               0008               ***************************************************************
1941               0009               * CPYM2M - Copy CPU memory to CPU memory
1942               0010               ***************************************************************
1943               0011               *  BL   @CPYM2M
1944               0012               *  DATA P0,P1,P2
1945               0013               *--------------------------------------------------------------
1946               0014               *  P0 = Memory source address
1947               0015               *  P1 = Memory target address
1948               0016               *  P2 = Number of bytes to copy
1949               0017               *--------------------------------------------------------------
1950               0018               *  BL @XPYM2M
1951               0019               *
1952               0020               *  TMP0 = Memory source address
1953               0021               *  TMP1 = Memory target address
1954               0022               *  TMP2 = Number of bytes to copy
1955               0023               ********|*****|*********************|**************************
1956               0024 6500 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
1957               0025 6502 C17B  30         mov   *r11+,tmp1            ; Memory target address
1958               0026 6504 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
1959               0027               *--------------------------------------------------------------
1960               0028               * Do some checks first
1961               0029               *--------------------------------------------------------------
1962               0030 6506 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
1963               0031 6508 1604  14         jne   cpychk                ; No, continue checking
1964               0032
1965               0033 650A C80B  38         mov   r11,@>ffce            ; \ Save caller address
1966                    650C FFCE
1967               0034 650E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1968                    6510 2030
1969               0035               *--------------------------------------------------------------
1970               0036               *    Check: 1 byte copy
1971               0037               *--------------------------------------------------------------
1972               0038 6512 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
1973                    6514 0001
1974               0039 6516 1603  14         jne   cpym0                 ; No, continue checking
1975               0040 6518 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
1976               0041 651A 04C6  14         clr   tmp2                  ; Reset counter
1977               0042 651C 045B  20         b     *r11                  ; Return to caller
1978               0043               *--------------------------------------------------------------
1979               0044               *    Check: Uneven address handling
1980               0045               *--------------------------------------------------------------
1981               0046 651E 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
1982                    6520 7FFF
1983               0047 6522 C1C4  18         mov   tmp0,tmp3
1984               0048 6524 0247  22         andi  tmp3,1
1985                    6526 0001
1986               0049 6528 1618  14         jne   cpyodd                ; Odd source address handling
1987               0050 652A C1C5  18 cpym1   mov   tmp1,tmp3
1988               0051 652C 0247  22         andi  tmp3,1
1989                    652E 0001
1990               0052 6530 1614  14         jne   cpyodd                ; Odd target address handling
1991               0053               *--------------------------------------------------------------
1992               0054               * 8 bit copy
1993               0055               *--------------------------------------------------------------
1994               0056 6532 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
1995                    6534 202A
1996               0057 6536 1605  14         jne   cpym3
1997               0058 6538 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
1998                    653A 24EC
1999                    653C 8320
2000               0059 653E 0460  28         b     @mcloop               ; Copy memory and exit
2001                    6540 8320
2002               0060               *--------------------------------------------------------------
2003               0061               * 16 bit copy
2004               0062               *--------------------------------------------------------------
2005               0063 6542 C1C6  18 cpym3   mov   tmp2,tmp3
2006               0064 6544 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
2007                    6546 0001
2008               0065 6548 1301  14         jeq   cpym4
2009               0066 654A 0606  14         dec   tmp2                  ; Make TMP2 even
2010               0067 654C CD74  46 cpym4   mov   *tmp0+,*tmp1+
2011               0068 654E 0646  14         dect  tmp2
2012               0069 6550 16FD  14         jne   cpym4
2013               0070               *--------------------------------------------------------------
2014               0071               * Copy last byte if ODD
2015               0072               *--------------------------------------------------------------
2016               0073 6552 C1C7  18         mov   tmp3,tmp3
2017               0074 6554 1301  14         jeq   cpymz
2018               0075 6556 D554  38         movb  *tmp0,*tmp1
2019               0076 6558 045B  20 cpymz   b     *r11                  ; Return to caller
2020               0077               *--------------------------------------------------------------
2021               0078               * Handle odd source/target address
2022               0079               *--------------------------------------------------------------
2023               0080 655A 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
2024                    655C 8000
2025               0081 655E 10E9  14         jmp   cpym2
2026               0082 6560 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
2027               **** **** ****     > runlib.asm
2028               0103
2029               0107
2030               0111
2031               0113                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
2032               **** **** ****     > cpu_sams_support.asm
2033               0001               * FILE......: cpu_sams_support.asm
2034               0002               * Purpose...: Low level support for SAMS memory expansion card
2035               0003
2036               0004               *//////////////////////////////////////////////////////////////
2037               0005               *                SAMS Memory Expansion support
2038               0006               *//////////////////////////////////////////////////////////////
2039               0007
2040               0008               *--------------------------------------------------------------
2041               0009               * ACCESS and MAPPING
2042               0010               * (by the late Bruce Harisson):
2043               0011               *
2044               0012               * To use other than the default setup, you have to do two
2045               0013               * things:
2046               0014               *
2047               0015               * 1. You have to "turn on" the card's memory in the
2048               0016               *    >4000 block and write to the mapping registers there.
2049               0017               *    (bl  @sams.page.set)
2050               0018               *
2051               0019               * 2. You have to "turn on" the mapper function to make what
2052               0020               *    you've written into the >4000 block take effect.
2053               0021               *    (bl  @sams.mapping.on)
2054               0022               *--------------------------------------------------------------
2055               0023               *  SAMS                          Default SAMS page
2056               0024               *  Register     Memory bank      (system startup)
2057               0025               *  =======      ===========      ================
2058               0026               *  >4004        >2000-2fff          >002
2059               0027               *  >4006        >3000-4fff          >003
2060               0028               *  >4014        >a000-afff          >00a
2061               0029               *  >4016        >b000-bfff          >00b
2062               0030               *  >4018        >c000-cfff          >00c
2063               0031               *  >401a        >d000-dfff          >00d
2064               0032               *  >401c        >e000-efff          >00e
2065               0033               *  >401e        >f000-ffff          >00f
2066               0034               *  Others       Inactive
2067               0035               *--------------------------------------------------------------
2068               0036
2069               0037
2070               0038
2071               0039
2072               0040               ***************************************************************
2073               0041               * sams.page.get - Get SAMS page number for memory address
2074               0042               ***************************************************************
2075               0043               * bl   @sams.page.get
2076               0044               *      data P0
2077               0045               *--------------------------------------------------------------
2078               0046               * P0 = Memory address (e.g. address >a100 will map to SAMS
2079               0047               *      register >4014 (bank >a000 - >afff)
2080               0048               *--------------------------------------------------------------
2081               0049               * bl   @xsams.page.get
2082               0050               *
2083               0051               * tmp0 = Memory address (e.g. address >a100 will map to SAMS
2084               0052               *        register >4014 (bank >a000 - >afff)
2085               0053               *--------------------------------------------------------------
2086               0054               * OUTPUT
2087               0055               * waux1 = SAMS page number
2088               0056               * waux2 = Address of affected SAMS register
2089               0057               *--------------------------------------------------------------
2090               0058               * Register usage
2091               0059               * r0, tmp0, r12
2092               0060               ********|*****|*********************|**************************
2093               0061               sams.page.get:
2094               0062 6562 C13B  30         mov   *r11+,tmp0            ; Memory address
2095               0063               xsams.page.get:
2096               0064 6564 0649  14         dect  stack
2097               0065 6566 C64B  30         mov   r11,*stack            ; Push return address
2098               0066 6568 0649  14         dect  stack
2099               0067 656A C640  30         mov   r0,*stack             ; Push r0
2100               0068 656C 0649  14         dect  stack
2101               0069 656E C64C  30         mov   r12,*stack            ; Push r12
2102               0070               *--------------------------------------------------------------
2103               0071               * Determine memory bank
2104               0072               *--------------------------------------------------------------
2105               0073 6570 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
2106               0074 6572 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
2107               0075
2108               0076 6574 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
2109                    6576 4000
2110               0077 6578 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
2111                    657A 833E
2112               0078               *--------------------------------------------------------------
2113               0079               * Get SAMS page number
2114               0080               *--------------------------------------------------------------
2115               0081 657C 020C  20         li    r12,>1e00             ; SAMS CRU address
2116                    657E 1E00
2117               0082 6580 04C0  14         clr   r0
2118               0083 6582 1D00  20         sbo   0                     ; Enable access to SAMS registers
2119               0084 6584 D014  26         movb  *tmp0,r0              ; Get SAMS page number
2120               0085 6586 D100  18         movb  r0,tmp0
2121               0086 6588 0984  56         srl   tmp0,8                ; Right align
2122               0087 658A C804  38         mov   tmp0,@waux1           ; Save SAMS page number
2123                    658C 833C
2124               0088 658E 1E00  20         sbz   0                     ; Disable access to SAMS registers
2125               0089               *--------------------------------------------------------------
2126               0090               * Exit
2127               0091               *--------------------------------------------------------------
2128               0092               sams.page.get.exit:
2129               0093 6590 C339  30         mov   *stack+,r12           ; Pop r12
2130               0094 6592 C039  30         mov   *stack+,r0            ; Pop r0
2131               0095 6594 C2F9  30         mov   *stack+,r11           ; Pop return address
2132               0096 6596 045B  20         b     *r11                  ; Return to caller
2133               0097
2134               0098
2135               0099
2136               0100
2137               0101               ***************************************************************
2138               0102               * sams.page.set - Set SAMS memory page
2139               0103               ***************************************************************
2140               0104               * bl   sams.page.set
2141               0105               *      data P0,P1
2142               0106               *--------------------------------------------------------------
2143               0107               * P0 = SAMS page number
2144               0108               * P1 = Memory address (e.g. address >a100 will map to SAMS
2145               0109               *      register >4014 (bank >a000 - >afff)
2146               0110               *--------------------------------------------------------------
2147               0111               * bl   @xsams.page.set
2148               0112               *
2149               0113               * tmp0 = SAMS page number
2150               0114               * tmp1 = Memory address (e.g. address >a100 will map to SAMS
2151               0115               *        register >4014 (bank >a000 - >afff)
2152               0116               *--------------------------------------------------------------
2153               0117               * Register usage
2154               0118               * r0, tmp0, tmp1, r12
2155               0119               *--------------------------------------------------------------
2156               0120               * SAMS page number should be in range 0-255 (>00 to >ff)
2157               0121               *
2158               0122               *  Page         Memory
2159               0123               *  ====         ======
2160               0124               *  >00             32K
2161               0125               *  >1f            128K
2162               0126               *  >3f            256K
2163               0127               *  >7f            512K
2164               0128               *  >ff           1024K
2165               0129               ********|*****|*********************|**************************
2166               0130               sams.page.set:
2167               0131 6598 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
2168               0132 659A C17B  30         mov   *r11+,tmp1            ; Get memory address
2169               0133               xsams.page.set:
2170               0134 659C 0649  14         dect  stack
2171               0135 659E C64B  30         mov   r11,*stack            ; Push return address
2172               0136 65A0 0649  14         dect  stack
2173               0137 65A2 C640  30         mov   r0,*stack             ; Push r0
2174               0138 65A4 0649  14         dect  stack
2175               0139 65A6 C64C  30         mov   r12,*stack            ; Push r12
2176               0140 65A8 0649  14         dect  stack
2177               0141 65AA C644  30         mov   tmp0,*stack           ; Push tmp0
2178               0142 65AC 0649  14         dect  stack
2179               0143 65AE C645  30         mov   tmp1,*stack           ; Push tmp1
2180               0144               *--------------------------------------------------------------
2181               0145               * Determine memory bank
2182               0146               *--------------------------------------------------------------
2183               0147 65B0 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
2184               0148 65B2 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
2185               0149               *--------------------------------------------------------------
2186               0150               * Sanity check on SAMS page number
2187               0151               *--------------------------------------------------------------
2188               0152 65B4 0284  22         ci    tmp0,255              ; Crash if page > 255
2189                    65B6 00FF
2190               0153 65B8 150D  14         jgt   !
2191               0154               *--------------------------------------------------------------
2192               0155               * Sanity check on SAMS register
2193               0156               *--------------------------------------------------------------
2194               0157 65BA 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
2195                    65BC 001E
2196               0158 65BE 150A  14         jgt   !
2197               0159 65C0 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
2198                    65C2 0004
2199               0160 65C4 1107  14         jlt   !
2200               0161 65C6 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
2201                    65C8 0012
2202               0162 65CA 1508  14         jgt   sams.page.set.switch_page
2203               0163 65CC 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
2204                    65CE 0006
2205               0164 65D0 1501  14         jgt   !
2206               0165 65D2 1004  14         jmp   sams.page.set.switch_page
2207               0166                       ;------------------------------------------------------
2208               0167                       ; Crash the system
2209               0168                       ;------------------------------------------------------
2210               0169 65D4 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
2211                    65D6 FFCE
2212               0170 65D8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
2213                    65DA 2030
2214               0171               *--------------------------------------------------------------
2215               0172               * Switch memory bank to specified SAMS page
2216               0173               *--------------------------------------------------------------
2217               0174               sams.page.set.switch_page
2218               0175 65DC 020C  20         li    r12,>1e00             ; SAMS CRU address
2219                    65DE 1E00
2220               0176 65E0 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
2221               0177 65E2 06C0  14         swpb  r0                    ; LSB to MSB
2222               0178 65E4 1D00  20         sbo   0                     ; Enable access to SAMS registers
2223               0179 65E6 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
2224                    65E8 4000
2225               0180 65EA 1E00  20         sbz   0                     ; Disable access to SAMS registers
2226               0181               *--------------------------------------------------------------
2227               0182               * Exit
2228               0183               *--------------------------------------------------------------
2229               0184               sams.page.set.exit:
2230               0185 65EC C179  30         mov   *stack+,tmp1          ; Pop tmp1
2231               0186 65EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
2232               0187 65F0 C339  30         mov   *stack+,r12           ; Pop r12
2233               0188 65F2 C039  30         mov   *stack+,r0            ; Pop r0
2234               0189 65F4 C2F9  30         mov   *stack+,r11           ; Pop return address
2235               0190 65F6 045B  20         b     *r11                  ; Return to caller
2236               0191
2237               0192
2238               0193
2239               0194
2240               0195               ***************************************************************
2241               0196               * sams.mapping.on - Enable SAMS mapping mode
2242               0197               ***************************************************************
2243               0198               *  bl   @sams.mapping.on
2244               0199               *--------------------------------------------------------------
2245               0200               *  Register usage
2246               0201               *  r12
2247               0202               ********|*****|*********************|**************************
2248               0203               sams.mapping.on:
2249               0204 65F8 020C  20         li    r12,>1e00             ; SAMS CRU address
2250                    65FA 1E00
2251               0205 65FC 1D01  20         sbo   1                     ; Enable SAMS mapper
2252               0206               *--------------------------------------------------------------
2253               0207               * Exit
2254               0208               *--------------------------------------------------------------
2255               0209               sams.mapping.on.exit:
2256               0210 65FE 045B  20         b     *r11                  ; Return to caller
2257               0211
2258               0212
2259               0213
2260               0214
2261               0215               ***************************************************************
2262               0216               * sams.mapping.off - Disable SAMS mapping mode
2263               0217               ***************************************************************
2264               0218               * bl  @sams.mapping.off
2265               0219               *--------------------------------------------------------------
2266               0220               * OUTPUT
2267               0221               * none
2268               0222               *--------------------------------------------------------------
2269               0223               * Register usage
2270               0224               * r12
2271               0225               ********|*****|*********************|**************************
2272               0226               sams.mapping.off:
2273               0227 6600 020C  20         li    r12,>1e00             ; SAMS CRU address
2274                    6602 1E00
2275               0228 6604 1E01  20         sbz   1                     ; Disable SAMS mapper
2276               0229               *--------------------------------------------------------------
2277               0230               * Exit
2278               0231               *--------------------------------------------------------------
2279               0232               sams.mapping.off.exit:
2280               0233 6606 045B  20         b     *r11                  ; Return to caller
2281               0234
2282               0235
2283               0236
2284               0237
2285               0238
2286               0239               ***************************************************************
2287               0240               * sams.layout
2288               0241               * Setup SAMS memory banks
2289               0242               ***************************************************************
2290               0243               * bl  @sams.layout
2291               0244               *     data P0
2292               0245               *--------------------------------------------------------------
2293               0246               * INPUT
2294               0247               * P0 = Pointer to SAMS page layout table (16 words).
2295               0248               *--------------------------------------------------------------
2296               0249               * bl  @xsams.layout
2297               0250               *
2298               0251               * tmp0 = Pointer to SAMS page layout table (16 words).
2299               0252               *--------------------------------------------------------------
2300               0253               * OUTPUT
2301               0254               * none
2302               0255               *--------------------------------------------------------------
2303               0256               * Register usage
2304               0257               * tmp0, tmp1, tmp2, tmp3
2305               0258               ********|*****|*********************|**************************
2306               0259               sams.layout:
2307               0260 6608 C1FB  30         mov   *r11+,tmp3            ; Get P0
2308               0261               xsams.layout:
2309               0262 660A 0649  14         dect  stack
2310               0263 660C C64B  30         mov   r11,*stack            ; Save return address
2311               0264 660E 0649  14         dect  stack
2312               0265 6610 C644  30         mov   tmp0,*stack           ; Save tmp0
2313               0266 6612 0649  14         dect  stack
2314               0267 6614 C645  30         mov   tmp1,*stack           ; Save tmp1
2315               0268 6616 0649  14         dect  stack
2316               0269 6618 C646  30         mov   tmp2,*stack           ; Save tmp2
2317               0270 661A 0649  14         dect  stack
2318               0271 661C C647  30         mov   tmp3,*stack           ; Save tmp3
2319               0272                       ;------------------------------------------------------
2320               0273                       ; Initialize
2321               0274                       ;------------------------------------------------------
2322               0275 661E 0206  20         li    tmp2,8                ; Set loop counter
2323                    6620 0008
2324               0276                       ;------------------------------------------------------
2325               0277                       ; Set SAMS memory pages
2326               0278                       ;------------------------------------------------------
2327               0279               sams.layout.loop:
2328               0280 6622 C177  30         mov   *tmp3+,tmp1           ; Get memory address
2329               0281 6624 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
2330               0282
2331               0283 6626 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
2332                    6628 2528
2333               0284                                                   ; | i  tmp0 = SAMS page
2334               0285                                                   ; / i  tmp1 = Memory address
2335               0286
2336               0287 662A 0606  14         dec   tmp2                  ; Next iteration
2337               0288 662C 16FA  14         jne   sams.layout.loop      ; Loop until done
2338               0289                       ;------------------------------------------------------
2339               0290                       ; Exit
2340               0291                       ;------------------------------------------------------
2341               0292               sams.init.exit:
2342               0293 662E 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
2343                    6630 2584
2344               0294                                                   ; / activating changes.
2345               0295
2346               0296 6632 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
2347               0297 6634 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
2348               0298 6636 C179  30         mov   *stack+,tmp1          ; Pop tmp1
2349               0299 6638 C139  30         mov   *stack+,tmp0          ; Pop tmp0
2350               0300 663A C2F9  30         mov   *stack+,r11           ; Pop r11
2351               0301 663C 045B  20         b     *r11                  ; Return to caller
2352               0302
2353               0303
2354               0304
2355               0305               ***************************************************************
2356               0306               * sams.layout.reset
2357               0307               * Reset SAMS memory banks to standard layout
2358               0308               ***************************************************************
2359               0309               * bl  @sams.layout.reset
2360               0310               *--------------------------------------------------------------
2361               0311               * OUTPUT
2362               0312               * none
2363               0313               *--------------------------------------------------------------
2364               0314               * Register usage
2365               0315               * none
2366               0316               ********|*****|*********************|**************************
2367               0317               sams.layout.reset:
2368               0318 663E 0649  14         dect  stack
2369               0319 6640 C64B  30         mov   r11,*stack            ; Save return address
2370               0320                       ;------------------------------------------------------
2371               0321                       ; Set SAMS standard layout
2372               0322                       ;------------------------------------------------------
2373               0323 6642 06A0  32         bl    @sams.layout
2374                    6644 2594
2375               0324 6646 25D8                   data sams.layout.standard
2376               0325                       ;------------------------------------------------------
2377               0326                       ; Exit
2378               0327                       ;------------------------------------------------------
2379               0328               sams.layout.reset.exit:
2380               0329 6648 C2F9  30         mov   *stack+,r11           ; Pop r11
2381               0330 664A 045B  20         b     *r11                  ; Return to caller
2382               0331               ***************************************************************
2383               0332               * SAMS standard page layout table (16 words)
2384               0333               *--------------------------------------------------------------
2385               0334               sams.layout.standard:
2386               0335 664C 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
2387                    664E 0002
2388               0336 6650 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
2389                    6652 0003
2390               0337 6654 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
2391                    6656 000A
2392               0338 6658 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
2393                    665A 000B
2394               0339 665C C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
2395                    665E 000C
2396               0340 6660 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
2397                    6662 000D
2398               0341 6664 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
2399                    6666 000E
2400               0342 6668 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
2401                    666A 000F
2402               0343
2403               0344
2404               0345
2405               0346               ***************************************************************
2406               0347               * sams.layout.copy
2407               0348               * Copy SAMS memory layout
2408               0349               ***************************************************************
2409               0350               * bl  @sams.layout.copy
2410               0351               *     data P0
2411               0352               *--------------------------------------------------------------
2412               0353               * P0 = Pointer to 8 words RAM buffer for results
2413               0354               *--------------------------------------------------------------
2414               0355               * OUTPUT
2415               0356               * RAM buffer will have the SAMS page number for each range
2416               0357               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
2417               0358               *--------------------------------------------------------------
2418               0359               * Register usage
2419               0360               * tmp0, tmp1, tmp2, tmp3
2420               0361               ***************************************************************
2421               0362               sams.layout.copy:
2422               0363 666C C1FB  30         mov   *r11+,tmp3            ; Get P0
2423               0364
2424               0365 666E 0649  14         dect  stack
2425               0366 6670 C64B  30         mov   r11,*stack            ; Push return address
2426               0367 6672 0649  14         dect  stack
2427               0368 6674 C644  30         mov   tmp0,*stack           ; Push tmp0
2428               0369 6676 0649  14         dect  stack
2429               0370 6678 C645  30         mov   tmp1,*stack           ; Push tmp1
2430               0371 667A 0649  14         dect  stack
2431               0372 667C C646  30         mov   tmp2,*stack           ; Push tmp2
2432               0373 667E 0649  14         dect  stack
2433               0374 6680 C647  30         mov   tmp3,*stack           ; Push tmp3
2434               0375                       ;------------------------------------------------------
2435               0376                       ; Copy SAMS layout
2436               0377                       ;------------------------------------------------------
2437               0378 6682 0205  20         li    tmp1,sams.layout.copy.data
2438                    6684 2630
2439               0379 6686 0206  20         li    tmp2,8                ; Set loop counter
2440                    6688 0008
2441               0380                       ;------------------------------------------------------
2442               0381                       ; Set SAMS memory pages
2443               0382                       ;------------------------------------------------------
2444               0383               sams.layout.copy.loop:
2445               0384 668A C135  30         mov   *tmp1+,tmp0           ; Get memory address
2446               0385 668C 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
2447                    668E 24F0
2448               0386                                                   ; | i  tmp0   = Memory address
2449               0387                                                   ; / o  @waux1 = SAMS page
2450               0388
2451               0389 6690 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
2452                    6692 833C
2453               0390
2454               0391 6694 0606  14         dec   tmp2                  ; Next iteration
2455               0392 6696 16F9  14         jne   sams.layout.copy.loop ; Loop until done
2456               0393                       ;------------------------------------------------------
2457               0394                       ; Exit
2458               0395                       ;------------------------------------------------------
2459               0396               sams.layout.copy.exit:
2460               0397 6698 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
2461               0398 669A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
2462               0399 669C C179  30         mov   *stack+,tmp1          ; Pop tmp1
2463               0400 669E C139  30         mov   *stack+,tmp0          ; Pop tmp0
2464               0401 66A0 C2F9  30         mov   *stack+,r11           ; Pop r11
2465               0402 66A2 045B  20         b     *r11                  ; Return to caller
2466               0403               ***************************************************************
2467               0404               * SAMS memory range table (8 words)
2468               0405               *--------------------------------------------------------------
2469               0406               sams.layout.copy.data:
2470               0407 66A4 2000             data  >2000                 ; >2000-2fff
2471               0408 66A6 3000             data  >3000                 ; >3000-3fff
2472               0409 66A8 A000             data  >a000                 ; >a000-afff
2473               0410 66AA B000             data  >b000                 ; >b000-bfff
2474               0411 66AC C000             data  >c000                 ; >c000-cfff
2475               0412 66AE D000             data  >d000                 ; >d000-dfff
2476               0413 66B0 E000             data  >e000                 ; >e000-efff
2477               0414 66B2 F000             data  >f000                 ; >f000-ffff
2478               0415
2479               **** **** ****     > runlib.asm
2480               0115
2481               0117                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
2482               **** **** ****     > vdp_intscr.asm
2483               0001               * FILE......: vdp_intscr.asm
2484               0002               * Purpose...: VDP interrupt & screen on/off
2485               0003
2486               0004               ***************************************************************
2487               0005               * SCROFF - Disable screen display
2488               0006               ***************************************************************
2489               0007               *  BL @SCROFF
2490               0008               ********|*****|*********************|**************************
2491               0009 66B4 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
2492                    66B6 FFBF
2493               0010 66B8 0460  28         b     @putv01
2494                    66BA 2340
2495               0011
2496               0012               ***************************************************************
2497               0013               * SCRON - Disable screen display
2498               0014               ***************************************************************
2499               0015               *  BL @SCRON
2500               0016               ********|*****|*********************|**************************
2501               0017 66BC 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
2502                    66BE 0040
2503               0018 66C0 0460  28         b     @putv01
2504                    66C2 2340
2505               0019
2506               0020               ***************************************************************
2507               0021               * INTOFF - Disable VDP interrupt
2508               0022               ***************************************************************
2509               0023               *  BL @INTOFF
2510               0024               ********|*****|*********************|**************************
2511               0025 66C4 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
2512                    66C6 FFDF
2513               0026 66C8 0460  28         b     @putv01
2514                    66CA 2340
2515               0027
2516               0028               ***************************************************************
2517               0029               * INTON - Enable VDP interrupt
2518               0030               ***************************************************************
2519               0031               *  BL @INTON
2520               0032               ********|*****|*********************|**************************
2521               0033 66CC 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
2522                    66CE 0020
2523               0034 66D0 0460  28         b     @putv01
2524                    66D2 2340
2525               **** **** ****     > runlib.asm
2526               0119
2527               0121                       copy  "vdp_sprites.asm"          ; VDP sprites
2528               **** **** ****     > vdp_sprites.asm
2529               0001               ***************************************************************
2530               0002               * FILE......: vdp_sprites.asm
2531               0003               * Purpose...: Sprites support
2532               0004
2533               0005               ***************************************************************
2534               0006               * SMAG1X - Set sprite magnification 1x
2535               0007               ***************************************************************
2536               0008               *  BL @SMAG1X
2537               0009               ********|*****|*********************|**************************
2538               0010 66D4 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
2539                    66D6 FFFE
2540               0011 66D8 0460  28         b     @putv01
2541                    66DA 2340
2542               0012
2543               0013               ***************************************************************
2544               0014               * SMAG2X - Set sprite magnification 2x
2545               0015               ***************************************************************
2546               0016               *  BL @SMAG2X
2547               0017               ********|*****|*********************|**************************
2548               0018 66DC 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
2549                    66DE 0001
2550               0019 66E0 0460  28         b     @putv01
2551                    66E2 2340
2552               0020
2553               0021               ***************************************************************
2554               0022               * S8X8 - Set sprite size 8x8 bits
2555               0023               ***************************************************************
2556               0024               *  BL @S8X8
2557               0025               ********|*****|*********************|**************************
2558               0026 66E4 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
2559                    66E6 FFFD
2560               0027 66E8 0460  28         b     @putv01
2561                    66EA 2340
2562               0028
2563               0029               ***************************************************************
2564               0030               * S16X16 - Set sprite size 16x16 bits
2565               0031               ***************************************************************
2566               0032               *  BL @S16X16
2567               0033               ********|*****|*********************|**************************
2568               0034 66EC 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
2569                    66EE 0002
2570               0035 66F0 0460  28         b     @putv01
2571                    66F2 2340
2572               **** **** ****     > runlib.asm
2573               0123
2574               0125                       copy  "vdp_cursor.asm"           ; VDP cursor handling
2575               **** **** ****     > vdp_cursor.asm
2576               0001               * FILE......: vdp_cursor.asm
2577               0002               * Purpose...: VDP cursor handling
2578               0003
2579               0004               *//////////////////////////////////////////////////////////////
2580               0005               *               VDP cursor movement functions
2581               0006               *//////////////////////////////////////////////////////////////
2582               0007
2583               0008
2584               0009               ***************************************************************
2585               0010               * AT - Set cursor YX position
2586               0011               ***************************************************************
2587               0012               *  bl   @yx
2588               0013               *  data p0
2589               0014               *--------------------------------------------------------------
2590               0015               *  INPUT
2591               0016               *  P0 = New Cursor YX position
2592               0017               ********|*****|*********************|**************************
2593               0018 66F4 C83B  50 at      mov   *r11+,@wyx
2594                    66F6 832A
2595               0019 66F8 045B  20         b     *r11
2596               0020
2597               0021
2598               0022               ***************************************************************
2599               0023               * down - Increase cursor Y position
2600               0024               ***************************************************************
2601               0025               *  bl   @down
2602               0026               ********|*****|*********************|**************************
2603               0027 66FA B820  54 down    ab    @hb$01,@wyx
2604                    66FC 201C
2605                    66FE 832A
2606               0028 6700 045B  20         b     *r11
2607               0029
2608               0030
2609               0031               ***************************************************************
2610               0032               * up - Decrease cursor Y position
2611               0033               ***************************************************************
2612               0034               *  bl   @up
2613               0035               ********|*****|*********************|**************************
2614               0036 6702 7820  54 up      sb    @hb$01,@wyx
2615                    6704 201C
2616                    6706 832A
2617               0037 6708 045B  20         b     *r11
2618               0038
2619               0039
2620               0040               ***************************************************************
2621               0041               * setx - Set cursor X position
2622               0042               ***************************************************************
2623               0043               *  bl   @setx
2624               0044               *  data p0
2625               0045               *--------------------------------------------------------------
2626               0046               *  Register usage
2627               0047               *  TMP0
2628               0048               ********|*****|*********************|**************************
2629               0049 670A C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
2630               0050 670C D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
2631                    670E 832A
2632               0051 6710 C804  38         mov   tmp0,@wyx             ; Save as new YX position
2633                    6712 832A
2634               0052 6714 045B  20         b     *r11
2635               **** **** ****     > runlib.asm
2636               0127
2637               0129                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
2638               **** **** ****     > vdp_yx2px_calc.asm
2639               0001               * FILE......: vdp_yx2px_calc.asm
2640               0002               * Purpose...: Calculate pixel position for YX coordinate
2641               0003
2642               0004               ***************************************************************
2643               0005               * YX2PX - Get pixel position for cursor YX position
2644               0006               ***************************************************************
2645               0007               *  BL   @YX2PX
2646               0008               *
2647               0009               *  (CONFIG:0 = 1) = Skip sprite adjustment
2648               0010               *--------------------------------------------------------------
2649               0011               *  INPUT
2650               0012               *  @WYX   = Cursor YX position
2651               0013               *--------------------------------------------------------------
2652               0014               *  OUTPUT
2653               0015               *  TMP0HB = Y pixel position
2654               0016               *  TMP0LB = X pixel position
2655               0017               *--------------------------------------------------------------
2656               0018               *  Remarks
2657               0019               *  This subroutine does not support multicolor mode
2658               0020               ********|*****|*********************|**************************
2659               0021 6716 C120  34 yx2px   mov   @wyx,tmp0
2660                    6718 832A
2661               0022 671A C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
2662               0023 671C 06C4  14         swpb  tmp0                  ; Y<->X
2663               0024 671E 04C5  14         clr   tmp1                  ; Clear before copy
2664               0025 6720 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
2665               0026               *--------------------------------------------------------------
2666               0027               * X pixel - Special F18a 80 colums treatment
2667               0028               *--------------------------------------------------------------
2668               0029 6722 20A0  38         coc   @wbit1,config         ; f18a present ?
2669                    6724 2028
2670               0030 6726 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
2671               0031 6728 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
2672                    672A 833A
2673                    672C 26E2
2674               0032 672E 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
2675               0033
2676               0034 6730 0A15  56         sla   tmp1,1                ; X = X * 2
2677               0035 6732 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
2678               0036 6734 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
2679                    6736 0500
2680               0037 6738 1002  14         jmp   yx2pxx_y_calc
2681               0038               *--------------------------------------------------------------
2682               0039               * X pixel - Normal VDP treatment
2683               0040               *--------------------------------------------------------------
2684               0041               yx2pxx_normal:
2685               0042 673A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
2686               0043               *--------------------------------------------------------------
2687               0044 673C 0A35  56         sla   tmp1,3                ; X=X*8
2688               0045               *--------------------------------------------------------------
2689               0046               * Calculate Y pixel position
2690               0047               *--------------------------------------------------------------
2691               0048               yx2pxx_y_calc:
2692               0049 673E 0A34  56         sla   tmp0,3                ; Y=Y*8
2693               0050 6740 D105  18         movb  tmp1,tmp0
2694               0051 6742 06C4  14         swpb  tmp0                  ; X<->Y
2695               0052 6744 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
2696                    6746 202A
2697               0053 6748 1305  14         jeq   yx2pi3                ; Yes, exit
2698               0054               *--------------------------------------------------------------
2699               0055               * Adjust for Y sprite location
2700               0056               * See VDP Programmers Guide, Section 9.2.1
2701               0057               *--------------------------------------------------------------
2702               0058 674A 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
2703                    674C 201C
2704               0059 674E 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
2705                    6750 202E
2706               0060 6752 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
2707               0061 6754 0456  20 yx2pi3  b     *tmp2                 ; Exit
2708               0062               *--------------------------------------------------------------
2709               0063               * Local constants
2710               0064               *--------------------------------------------------------------
2711               0065               yx2pxx_c80:
2712               0066 6756 0050            data   80
2713               0067
2714               0068
2715               **** **** ****     > runlib.asm
2716               0131
2717               0135
2718               0139
2719               0141                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
2720               **** **** ****     > vdp_f18a_support.asm
2721               0001               * FILE......: vdp_f18a_support.asm
2722               0002               * Purpose...: VDP F18A Support module
2723               0003
2724               0004               *//////////////////////////////////////////////////////////////
2725               0005               *                 VDP F18A LOW-LEVEL FUNCTIONS
2726               0006               *//////////////////////////////////////////////////////////////
2727               0007
2728               0008               ***************************************************************
2729               0009               * f18unl - Unlock F18A VDP
2730               0010               ***************************************************************
2731               0011               *  bl   @f18unl
2732               0012               ********|*****|*********************|**************************
2733               0013 6758 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
2734               0014 675A 06A0  32         bl    @putvr                ; Write once
2735                    675C 232C
2736               0015 675E 391C             data  >391c                 ; VR1/57, value 00011100
2737               0016 6760 06A0  32         bl    @putvr                ; Write twice
2738                    6762 232C
2739               0017 6764 391C             data  >391c                 ; VR1/57, value 00011100
2740               0018 6766 0458  20         b     *tmp4                 ; Exit
2741               0019
2742               0020
2743               0021               ***************************************************************
2744               0022               * f18lck - Lock F18A VDP
2745               0023               ***************************************************************
2746               0024               *  bl   @f18lck
2747               0025               ********|*****|*********************|**************************
2748               0026 6768 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
2749               0027 676A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
2750                    676C 232C
2751               0028 676E 391C             data  >391c
2752               0029 6770 0458  20         b     *tmp4                 ; Exit
2753               0030
2754               0031
2755               0032               ***************************************************************
2756               0033               * f18chk - Check if F18A VDP present
2757               0034               ***************************************************************
2758               0035               *  bl   @f18chk
2759               0036               *--------------------------------------------------------------
2760               0037               *  REMARKS
2761               0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
2762               0039               ********|*****|*********************|**************************
2763               0040 6772 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
2764               0041 6774 06A0  32         bl    @cpym2v
2765                    6776 2444
2766               0042 6778 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
2767                    677A 2742
2768                    677C 0006
2769               0043 677E 06A0  32         bl    @putvr
2770                    6780 232C
2771               0044 6782 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
2772               0045 6784 06A0  32         bl    @putvr
2773                    6786 232C
2774               0046 6788 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
2775               0047                                                   ; GPU code should run now
2776               0048               ***************************************************************
2777               0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
2778               0050               ***************************************************************
2779               0051 678A 0204  20         li    tmp0,>3f00
2780                    678C 3F00
2781               0052 678E 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
2782                    6790 22B4
2783               0053 6792 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
2784                    6794 8800
2785               0054 6796 0984  56         srl   tmp0,8
2786               0055 6798 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
2787                    679A 8800
2788               0056 679C C104  18         mov   tmp0,tmp0             ; For comparing with 0
2789               0057 679E 1303  14         jeq   f18chk_yes
2790               0058               f18chk_no:
2791               0059 67A0 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
2792                    67A2 BFFF
2793               0060 67A4 1002  14         jmp   f18chk_exit
2794               0061               f18chk_yes:
2795               0062 67A6 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
2796                    67A8 4000
2797               0063               f18chk_exit:
2798               0064 67AA 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
2799                    67AC 2288
2800               0065 67AE 3F00             data  >3f00,>00,6
2801                    67B0 0000
2802                    67B2 0006
2803               0066 67B4 0458  20         b     *tmp4                 ; Exit
2804               0067               ***************************************************************
2805               0068               * GPU code
2806               0069               ********|*****|*********************|**************************
2807               0070               f18chk_gpu
2808               0071 67B6 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
2809               0072 67B8 3F00             data  >3f00                 ; 3f02 / 3f00
2810               0073 67BA 0340             data  >0340                 ; 3f04   0340  idle
2811               0074
2812               0075
2813               0076               ***************************************************************
2814               0077               * f18rst - Reset f18a into standard settings
2815               0078               ***************************************************************
2816               0079               *  bl   @f18rst
2817               0080               *--------------------------------------------------------------
2818               0081               *  REMARKS
2819               0082               *  This is used to leave the F18A mode and revert all settings
2820               0083               *  that could lead to corruption when doing BLWP @0
2821               0084               *
2822               0085               *  There are some F18a settings that stay on when doing blwp @0
2823               0086               *  and the TI title screen cannot recover from that.
2824               0087               *
2825               0088               *  It is your responsibility to set video mode tables should
2826               0089               *  you want to continue instead of doing blwp @0 after your
2827               0090               *  program cleanup
2828               0091               ********|*****|*********************|**************************
2829               0092 67BC C20B  18 f18rst  mov   r11,tmp4              ; Save R11
2830               0093                       ;------------------------------------------------------
2831               0094                       ; Reset all F18a VDP registers to power-on defaults
2832               0095                       ;------------------------------------------------------
2833               0096 67BE 06A0  32         bl    @putvr
2834                    67C0 232C
2835               0097 67C2 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
2836               0098
2837               0099 67C4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
2838                    67C6 232C
2839               0100 67C8 391C             data  >391c                 ; Lock the F18a
2840               0101 67CA 0458  20         b     *tmp4                 ; Exit
2841               0102
2842               0103
2843               0104
2844               0105               ***************************************************************
2845               0106               * f18fwv - Get F18A Firmware Version
2846               0107               ***************************************************************
2847               0108               *  bl   @f18fwv
2848               0109               *--------------------------------------------------------------
2849               0110               *  REMARKS
2850               0111               *  Successfully tested with F18A v1.8, note that this does not
2851               0112               *  work with F18 v1.3 but you shouldn't be using such old F18A
2852               0113               *  firmware to begin with.
2853               0114               *--------------------------------------------------------------
2854               0115               *  TMP0 High nibble = major version
2855               0116               *  TMP0 Low nibble  = minor version
2856               0117               *
2857               0118               *  Example: >0018     F18a Firmware v1.8
2858               0119               ********|*****|*********************|**************************
2859               0120 67CC C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
2860               0121 67CE 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
2861                    67D0 2028
2862               0122 67D2 1609  14         jne   f18fw1
2863               0123               ***************************************************************
2864               0124               * Read F18A major/minor version
2865               0125               ***************************************************************
2866               0126 67D4 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
2867                    67D6 8802
2868               0127 67D8 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
2869                    67DA 232C
2870               0128 67DC 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
2871               0129 67DE 04C4  14         clr   tmp0
2872               0130 67E0 D120  34         movb  @vdps,tmp0
2873                    67E2 8802
2874               0131 67E4 0984  56         srl   tmp0,8
2875               0132 67E6 0458  20 f18fw1  b     *tmp4                 ; Exit
2876               **** **** ****     > runlib.asm
2877               0143
2878               0145                       copy  "vdp_hchar.asm"            ; VDP hchar functions
2879               **** **** ****     > vdp_hchar.asm
2880               0001               * FILE......: vdp_hchar.a99
2881               0002               * Purpose...: VDP hchar module
2882               0003
2883               0004               ***************************************************************
2884               0005               * Repeat characters horizontally at YX
2885               0006               ***************************************************************
2886               0007               *  BL    @HCHAR
2887               0008               *  DATA  P0,P1
2888               0009               *  ...
2889               0010               *  DATA  EOL                        ; End-of-list
2890               0011               *--------------------------------------------------------------
2891               0012               *  P0HB = Y position
2892               0013               *  P0LB = X position
2893               0014               *  P1HB = Byte to write
2894               0015               *  P1LB = Number of times to repeat
2895               0016               ********|*****|*********************|**************************
2896               0017 67E8 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
2897                    67EA 832A
2898               0018 67EC D17B  28         movb  *r11+,tmp1
2899               0019 67EE 0985  56 hcharx  srl   tmp1,8                ; Byte to write
2900               0020 67F0 D1BB  28         movb  *r11+,tmp2
2901               0021 67F2 0986  56         srl   tmp2,8                ; Repeat count
2902               0022 67F4 C1CB  18         mov   r11,tmp3
2903               0023 67F6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
2904                    67F8 23F4
2905               0024               *--------------------------------------------------------------
2906               0025               *    Draw line
2907               0026               *--------------------------------------------------------------
2908               0027 67FA 020B  20         li    r11,hchar1
2909                    67FC 278E
2910               0028 67FE 0460  28         b     @xfilv                ; Draw
2911                    6800 228E
2912               0029               *--------------------------------------------------------------
2913               0030               *    Do housekeeping
2914               0031               *--------------------------------------------------------------
2915               0032 6802 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
2916                    6804 202C
2917               0033 6806 1302  14         jeq   hchar2                ; Yes, exit
2918               0034 6808 C2C7  18         mov   tmp3,r11
2919               0035 680A 10EE  14         jmp   hchar                 ; Next one
2920               0036 680C 05C7  14 hchar2  inct  tmp3
2921               0037 680E 0457  20         b     *tmp3                 ; Exit
2922               **** **** ****     > runlib.asm
2923               0147
2924               0151
2925               0155
2926               0159
2927               0163
2928               0167
2929               0171
2930               0175
2931               0177                       copy  "keyb_real.asm"            ; Real Keyboard support
2932               **** **** ****     > keyb_real.asm
2933               0001               * FILE......: keyb_real.asm
2934               0002               * Purpose...: Full (real) keyboard support module
2935               0003
2936               0004               *//////////////////////////////////////////////////////////////
2937               0005               *                     KEYBOARD FUNCTIONS
2938               0006               *//////////////////////////////////////////////////////////////
2939               0007
2940               0008               ***************************************************************
2941               0009               * REALKB - Scan keyboard in real mode
2942               0010               ***************************************************************
2943               0011               *  BL @REALKB
2944               0012               *--------------------------------------------------------------
2945               0013               *  Based on work done by Simon Koppelmann
2946               0014               *  taken from the book "TMS9900 assembler auf dem TI-99/4A"
2947               0015               ********|*****|*********************|**************************
2948               0016 6810 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
2949                    6812 202A
2950               0017 6814 020C  20         li    r12,>0024
2951                    6816 0024
2952               0018 6818 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
2953                    681A 2834
2954               0019 681C 04C6  14         clr   tmp2
2955               0020 681E 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
2956               0021               *--------------------------------------------------------------
2957               0022               * SHIFT key pressed ?
2958               0023               *--------------------------------------------------------------
2959               0024 6820 04CC  14         clr   r12
2960               0025 6822 1F08  20         tb    >0008                 ; Shift-key ?
2961               0026 6824 1302  14         jeq   realk1                ; No
2962               0027 6826 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
2963                    6828 2864
2964               0028               *--------------------------------------------------------------
2965               0029               * FCTN key pressed ?
2966               0030               *--------------------------------------------------------------
2967               0031 682A 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
2968               0032 682C 1302  14         jeq   realk2                ; No
2969               0033 682E 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
2970                    6830 2894
2971               0034               *--------------------------------------------------------------
2972               0035               * CTRL key pressed ?
2973               0036               *--------------------------------------------------------------
2974               0037 6832 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
2975               0038 6834 1302  14         jeq   realk3                ; No
2976               0039 6836 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
2977                    6838 28C4
2978               0040               *--------------------------------------------------------------
2979               0041               * ALPHA LOCK key down ?
2980               0042               *--------------------------------------------------------------
2981               0043 683A 1E15  20 realk3  sbz   >0015                 ; Set P5
2982               0044 683C 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
2983               0045 683E 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
2984               0046 6840 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
2985                    6842 202A
2986               0047               *--------------------------------------------------------------
2987               0048               * Scan keyboard column
2988               0049               *--------------------------------------------------------------
2989               0050 6844 1D15  20 realk4  sbo   >0015                 ; Reset P5
2990               0051 6846 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
2991                    6848 0006
2992               0052 684A 0606  14 realk5  dec   tmp2
2993               0053 684C 020C  20         li    r12,>24               ; CRU address for P2-P4
2994                    684E 0024
2995               0054 6850 06C6  14         swpb  tmp2
2996               0055 6852 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
2997               0056 6854 06C6  14         swpb  tmp2
2998               0057 6856 020C  20         li    r12,6                 ; CRU read address
2999                    6858 0006
3000               0058 685A 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
3001               0059 685C 0547  14         inv   tmp3                  ;
3002               0060 685E 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
3003                    6860 FF00
3004               0061               *--------------------------------------------------------------
3005               0062               * Scan keyboard row
3006               0063               *--------------------------------------------------------------
3007               0064 6862 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
3008               0065 6864 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
3009               0066 6866 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
3010               0067 6868 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
3011               0068 686A 0285  22         ci    tmp1,8
3012                    686C 0008
3013               0069 686E 1AFA  14         jl    realk6
3014               0070 6870 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
3015               0071 6872 1BEB  14         jh    realk5                ; No, next column
3016               0072 6874 1016  14         jmp   realkz                ; Yes, exit
3017               0073               *--------------------------------------------------------------
3018               0074               * Check for match in data table
3019               0075               *--------------------------------------------------------------
3020               0076 6876 C206  18 realk8  mov   tmp2,tmp4
3021               0077 6878 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
3022               0078 687A A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
3023               0079 687C A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
3024               0080 687E D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
3025               0081 6880 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
3026               0082               *--------------------------------------------------------------
3027               0083               * Determine ASCII value of key
3028               0084               *--------------------------------------------------------------
3029               0085 6882 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
3030               0086 6884 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
3031                    6886 202A
3032               0087 6888 1608  14         jne   realka                ; No, continue saving key
3033               0088 688A 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
3034                    688C 285E
3035               0089 688E 1A05  14         jl    realka
3036               0090 6890 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
3037                    6892 285C
3038               0091 6894 1B02  14         jh    realka                ; No, continue
3039               0092 6896 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
3040                    6898 E000
3041               0093 689A C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
3042                    689C 833C
3043               0094 689E E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
3044                    68A0 2014
3045               0095 68A2 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
3046                    68A4 8C00
3047               0096 68A6 045B  20         b     *r11                  ; Exit
3048               0097               ********|*****|*********************|**************************
3049               0098 68A8 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
3050                    68AA 0000
3051                    68AC FF0D
3052                    68AE 203D
3053               0099 68B0 ....             text  'xws29ol.'
3054               0100 68B8 ....             text  'ced38ik,'
3055               0101 68C0 ....             text  'vrf47ujm'
3056               0102 68C8 ....             text  'btg56yhn'
3057               0103 68D0 ....             text  'zqa10p;/'
3058               0104 68D8 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
3059                    68DA 0000
3060                    68DC FF0D
3061                    68DE 202B
3062               0105 68E0 ....             text  'XWS@(OL>'
3063               0106 68E8 ....             text  'CED#*IK<'
3064               0107 68F0 ....             text  'VRF$&UJM'
3065               0108 68F8 ....             text  'BTG%^YHN'
3066               0109 6900 ....             text  'ZQA!)P:-'
3067               0110 6908 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
3068                    690A 0000
3069                    690C FF0D
3070                    690E 2005
3071               0111 6910 0A7E             data  >0a7e,>0804,>0f27,>c2B9
3072                    6912 0804
3073                    6914 0F27
3074                    6916 C2B9
3075               0112 6918 600B             data  >600b,>0907,>063f,>c1B8
3076                    691A 0907
3077                    691C 063F
3078                    691E C1B8
3079               0113 6920 7F5B             data  >7f5b,>7b02,>015f,>c0C3
3080                    6922 7B02
3081                    6924 015F
3082                    6926 C0C3
3083               0114 6928 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
3084                    692A 7D0E
3085                    692C 0CC6
3086                    692E BFC4
3087               0115 6930 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
3088                    6932 7C03
3089                    6934 BC22
3090                    6936 BDBA
3091               0116 6938 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
3092                    693A 0000
3093                    693C FF0D
3094                    693E 209D
3095               0117 6940 9897             data  >9897,>93b2,>9f8f,>8c9B
3096                    6942 93B2
3097                    6944 9F8F
3098                    6946 8C9B
3099               0118 6948 8385             data  >8385,>84b3,>9e89,>8b80
3100                    694A 84B3
3101                    694C 9E89
3102                    694E 8B80
3103               0119 6950 9692             data  >9692,>86b4,>b795,>8a8D
3104                    6952 86B4
3105                    6954 B795
3106                    6956 8A8D
3107               0120 6958 8294             data  >8294,>87b5,>b698,>888E
3108                    695A 87B5
3109                    695C B698
3110                    695E 888E
3111               0121 6960 9A91             data  >9a91,>81b1,>b090,>9cBB
3112                    6962 81B1
3113                    6964 B090
3114                    6966 9CBB
3115               **** **** ****     > runlib.asm
3116               0179
3117               0181                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
3118               **** **** ****     > cpu_hexsupport.asm
3119               0001               * FILE......: cpu_hexsupport.asm
3120               0002               * Purpose...: CPU create, display hex numbers module
3121               0003
3122               0004               ***************************************************************
3123               0005               * mkhex - Convert hex word to string
3124               0006               ***************************************************************
3125               0007               *  bl   @mkhex
3126               0008               *       data P0,P1,P2
3127               0009               *--------------------------------------------------------------
3128               0010               *  P0 = Pointer to 16 bit word
3129               0011               *  P1 = Pointer to string buffer
3130               0012               *  P2 = Offset for ASCII digit
3131               0013               *       MSB determines offset for chars A-F
3132               0014               *       LSB determines offset for chars 0-9
3133               0015               *  (CONFIG#0 = 1) = Display number at cursor YX
3134               0016               *--------------------------------------------------------------
3135               0017               *  Memory usage:
3136               0018               *  tmp0, tmp1, tmp2, tmp3, tmp4
3137               0019               *  waux1, waux2, waux3
3138               0020               *--------------------------------------------------------------
3139               0021               *  Memory variables waux1-waux3 are used as temporary variables
3140               0022               ********|*****|*********************|**************************
3141               0023 6968 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
3142               0024 696A C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
3143                    696C 8340
3144               0025 696E 04E0  34         clr   @waux1
3145                    6970 833C
3146               0026 6972 04E0  34         clr   @waux2
3147                    6974 833E
3148               0027 6976 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
3149                    6978 833C
3150               0028 697A C114  26         mov   *tmp0,tmp0            ; Get word
3151               0029               *--------------------------------------------------------------
3152               0030               *    Convert nibbles to bytes (is in wrong order)
3153               0031               *--------------------------------------------------------------
3154               0032 697C 0205  20         li    tmp1,4                ; 4 nibbles
3155                    697E 0004
3156               0033 6980 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
3157               0034 6982 0246  22         andi  tmp2,>000f            ; Only keep LSN
3158                    6984 000F
3159               0035                       ;------------------------------------------------------
3160               0036                       ; Determine offset for ASCII char
3161               0037                       ;------------------------------------------------------
3162               0038 6986 0286  22         ci    tmp2,>000a
3163                    6988 000A
3164               0039 698A 1105  14         jlt   mkhex1.digit09
3165               0040                       ;------------------------------------------------------
3166               0041                       ; Add ASCII offset for digits A-F
3167               0042                       ;------------------------------------------------------
3168               0043               mkhex1.digitaf:
3169               0044 698C C21B  26         mov   *r11,tmp4
3170               0045 698E 0988  56         srl   tmp4,8                ; Right justify
3171               0046 6990 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
3172                    6992 FFF6
3173               0047 6994 1003  14         jmp   mkhex2
3174               0048
3175               0049               mkhex1.digit09:
3176               0050                       ;------------------------------------------------------
3177               0051                       ; Add ASCII offset for digits 0-9
3178               0052                       ;------------------------------------------------------
3179               0053 6996 C21B  26         mov   *r11,tmp4
3180               0054 6998 0248  22         andi  tmp4,>00ff            ; Only keep LSB
3181                    699A 00FF
3182               0055
3183               0056 699C A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
3184               0057 699E 06C6  14         swpb  tmp2
3185               0058 69A0 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
3186               0059 69A2 0944  56         srl   tmp0,4                ; Next nibble
3187               0060 69A4 0605  14         dec   tmp1
3188               0061 69A6 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
3189               0062 69A8 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
3190                    69AA BFFF
3191               0063               *--------------------------------------------------------------
3192               0064               *    Build first 2 bytes in correct order
3193               0065               *--------------------------------------------------------------
3194               0066 69AC C160  34         mov   @waux3,tmp1           ; Get pointer
3195                    69AE 8340
3196               0067 69B0 04D5  26         clr   *tmp1                 ; Set length byte to 0
3197               0068 69B2 0585  14         inc   tmp1                  ; Next byte, not word!
3198               0069 69B4 C120  34         mov   @waux2,tmp0
3199                    69B6 833E
3200               0070 69B8 06C4  14         swpb  tmp0
3201               0071 69BA DD44  32         movb  tmp0,*tmp1+
3202               0072 69BC 06C4  14         swpb  tmp0
3203               0073 69BE DD44  32         movb  tmp0,*tmp1+
3204               0074               *--------------------------------------------------------------
3205               0075               *    Set length byte
3206               0076               *--------------------------------------------------------------
3207               0077 69C0 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
3208                    69C2 8340
3209               0078 69C4 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
3210                    69C6 2020
3211               0079 69C8 05CB  14         inct  r11                   ; Skip Parameter P2
3212               0080               *--------------------------------------------------------------
3213               0081               *    Build last 2 bytes in correct order
3214               0082               *--------------------------------------------------------------
3215               0083 69CA C120  34         mov   @waux1,tmp0
3216                    69CC 833C
3217               0084 69CE 06C4  14         swpb  tmp0
3218               0085 69D0 DD44  32         movb  tmp0,*tmp1+
3219               0086 69D2 06C4  14         swpb  tmp0
3220               0087 69D4 DD44  32         movb  tmp0,*tmp1+
3221               0088               *--------------------------------------------------------------
3222               0089               *    Display hex number ?
3223               0090               *--------------------------------------------------------------
3224               0091 69D6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
3225                    69D8 202A
3226               0092 69DA 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
3227               0093 69DC 045B  20         b     *r11                  ; Exit
3228               0094               *--------------------------------------------------------------
3229               0095               *  Display hex number on screen at current YX position
3230               0096               *--------------------------------------------------------------
3231               0097 69DE 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
3232                    69E0 7FFF
3233               0098 69E2 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
3234                    69E4 8340
3235               0099 69E6 0460  28         b     @xutst0               ; Display string
3236                    69E8 241A
3237               0100 69EA 0610     prefix  data  >0610                 ; Length byte + blank
3238               0101
3239               0102
3240               0103
3241               0104               ***************************************************************
3242               0105               * puthex - Put 16 bit word on screen
3243               0106               ***************************************************************
3244               0107               *  bl   @mkhex
3245               0108               *       data P0,P1,P2,P3
3246               0109               *--------------------------------------------------------------
3247               0110               *  P0 = YX position
3248               0111               *  P1 = Pointer to 16 bit word
3249               0112               *  P2 = Pointer to string buffer
3250               0113               *  P3 = Offset for ASCII digit
3251               0114               *       MSB determines offset for chars A-F
3252               0115               *       LSB determines offset for chars 0-9
3253               0116               *--------------------------------------------------------------
3254               0117               *  Memory usage:
3255               0118               *  tmp0, tmp1, tmp2, tmp3
3256               0119               *  waux1, waux2, waux3
3257               0120               ********|*****|*********************|**************************
3258               0121 69EC C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
3259                    69EE 832A
3260               0122 69F0 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
3261                    69F2 8000
3262               0123 69F4 10B9  14         jmp   mkhex                 ; Convert number and display
3263               0124
3264               **** **** ****     > runlib.asm
3265               0183
3266               0185                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
3267               **** **** ****     > cpu_numsupport.asm
3268               0001               * FILE......: cpu_numsupport.asm
3269               0002               * Purpose...: CPU create, display numbers module
3270               0003
3271               0004               ***************************************************************
3272               0005               * MKNUM - Convert unsigned number to string
3273               0006               ***************************************************************
3274               0007               *  BL   @MKNUM
3275               0008               *  DATA P0,P1,P2
3276               0009               *
3277               0010               *  P0   = Pointer to 16 bit unsigned number
3278               0011               *  P1   = Pointer to 5 byte string buffer
3279               0012               *  P2HB = Offset for ASCII digit
3280               0013               *  P2LB = Character for replacing leading 0's
3281               0014               *
3282               0015               *  (CONFIG:0 = 1) = Display number at cursor YX
3283               0016               *-------------------------------------------------------------
3284               0017               *  Destroys registers tmp0-tmp4
3285               0018               ********|*****|*********************|**************************
3286               0019 69F6 0207  20 mknum   li    tmp3,5                ; Digit counter
3287                    69F8 0005
3288               0020 69FA C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
3289               0021 69FC C155  26         mov   *tmp1,tmp1            ; /
3290               0022 69FE C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
3291               0023 6A00 0228  22         ai    tmp4,4                ; Get end of buffer
3292                    6A02 0004
3293               0024 6A04 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
3294                    6A06 000A
3295               0025               *--------------------------------------------------------------
3296               0026               *  Do string conversion
3297               0027               *--------------------------------------------------------------
3298               0028 6A08 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
3299               0029 6A0A 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
3300               0030 6A0C 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
3301               0031 6A0E B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
3302               0032 6A10 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
3303               0033 6A12 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
3304               0034 6A14 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
3305               0035 6A16 0607  14         dec   tmp3                  ; Decrease counter
3306               0036 6A18 16F7  14         jne   mknum1                ; Do next digit
3307               0037               *--------------------------------------------------------------
3308               0038               *  Replace leading 0's with fill character
3309               0039               *--------------------------------------------------------------
3310               0040 6A1A 0207  20         li    tmp3,4                ; Check first 4 digits
3311                    6A1C 0004
3312               0041 6A1E 0588  14         inc   tmp4                  ; Too far, back to buffer start
3313               0042 6A20 C11B  26         mov   *r11,tmp0
3314               0043 6A22 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
3315               0044 6A24 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
3316               0045 6A26 1305  14         jeq   mknum4                ; Yes, replace with fill character
3317               0046 6A28 05CB  14 mknum3  inct  r11
3318               0047 6A2A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
3319                    6A2C 202A
3320               0048 6A2E 1305  14         jeq   mknum5                ; Yes, so show at current YX position
3321               0049 6A30 045B  20         b     *r11                  ; Exit
3322               0050 6A32 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
3323               0051 6A34 0607  14         dec   tmp3                  ; 4th digit processed ?
3324               0052 6A36 13F8  14         jeq   mknum3                ; Yes, exit
3325               0053 6A38 10F5  14         jmp   mknum2                ; No, next one
3326               0054               *--------------------------------------------------------------
3327               0055               *  Display integer on screen at current YX position
3328               0056               *--------------------------------------------------------------
3329               0057 6A3A 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
3330                    6A3C 7FFF
3331               0058 6A3E C10B  18         mov   r11,tmp0
3332               0059 6A40 0224  22         ai    tmp0,-4
3333                    6A42 FFFC
3334               0060 6A44 C154  26         mov   *tmp0,tmp1            ; Get buffer address
3335               0061 6A46 0206  20         li    tmp2,>0500            ; String length = 5
3336                    6A48 0500
3337               0062 6A4A 0460  28         b     @xutstr               ; Display string
3338                    6A4C 241C
3339               0063
3340               0064
3341               0065
3342               0066
3343               0067               ***************************************************************
3344               0068               * trimnum - Trim unsigned number string
3345               0069               ***************************************************************
3346               0070               *  bl   @trimnum
3347               0071               *  data p0,p1
3348               0072               *--------------------------------------------------------------
3349               0073               *  p0   = Pointer to 5 byte string buffer (no length byte!)
3350               0074               *  p1   = Pointer to output variable
3351               0075               *  p2   = Padding character to match against
3352               0076               *--------------------------------------------------------------
3353               0077               *  Copy unsigned number string into a length-padded, left
3354               0078               *  justified string for display with putstr, putat, ...
3355               0079               *
3356               0080               *  The new string starts at index 5 in buffer, overwriting
3357               0081               *  anything that is located there !
3358               0082               *
3359               0083               *  Before...:   XXXXX
3360               0084               *  After....:   XXXXX|zY       where length byte z=1
3361               0085               *               XXXXX|zYY      where length byte z=2
3362               0086               *                 ..
3363               0087               *               XXXXX|zYYYYY   where length byte z=5
3364               0088               *--------------------------------------------------------------
3365               0089               *  Destroys registers tmp0-tmp3
3366               0090               ********|*****|*********************|**************************
3367               0091               trimnum:
3368               0092 6A4E C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
3369               0093 6A50 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
3370               0094 6A52 C1BB  30         mov   *r11+,tmp2            ; Get padding character
3371               0095 6A54 06C6  14         swpb  tmp2                  ; LO <-> HI
3372               0096 6A56 0207  20         li    tmp3,5                ; Set counter
3373                    6A58 0005
3374               0097                       ;------------------------------------------------------
3375               0098                       ; Scan for padding character from left to right
3376               0099                       ;------------------------------------------------------:
3377               0100               trimnum_scan:
3378               0101 6A5A 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
3379               0102 6A5C 1604  14         jne   trimnum_setlen        ; No, exit loop
3380               0103 6A5E 0584  14         inc   tmp0                  ; Next character
3381               0104 6A60 0607  14         dec   tmp3                  ; Last digit reached ?
3382               0105 6A62 1301  14         jeq   trimnum_setlen        ; yes, exit loop
3383               0106 6A64 10FA  14         jmp   trimnum_scan
3384               0107                       ;------------------------------------------------------
3385               0108                       ; Scan completed, set length byte new string
3386               0109                       ;------------------------------------------------------
3387               0110               trimnum_setlen:
3388               0111 6A66 06C7  14         swpb  tmp3                  ; LO <-> HI
3389               0112 6A68 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
3390               0113 6A6A 06C7  14         swpb  tmp3                  ; LO <-> HI
3391               0114                       ;------------------------------------------------------
3392               0115                       ; Start filling new string
3393               0116                       ;------------------------------------------------------
3394               0117               trimnum_fill
3395               0118 6A6C DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
3396               0119 6A6E 0607  14         dec   tmp3                  ; Last character ?
3397               0120 6A70 16FD  14         jne   trimnum_fill          ; Not yet, repeat
3398               0121 6A72 045B  20         b     *r11                  ; Return
3399               0122
3400               0123
3401               0124
3402               0125
3403               0126               ***************************************************************
3404               0127               * PUTNUM - Put unsigned number on screen
3405               0128               ***************************************************************
3406               0129               *  BL   @PUTNUM
3407               0130               *  DATA P0,P1,P2,P3
3408               0131               *--------------------------------------------------------------
3409               0132               *  P0   = YX position
3410               0133               *  P1   = Pointer to 16 bit unsigned number
3411               0134               *  P2   = Pointer to 5 byte string buffer
3412               0135               *  P3HB = Offset for ASCII digit
3413               0136               *  P3LB = Character for replacing leading 0's
3414               0137               ********|*****|*********************|**************************
3415               0138 6A74 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
3416                    6A76 832A
3417               0139 6A78 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
3418                    6A7A 8000
3419               0140 6A7C 10BC  14         jmp   mknum                 ; Convert number and display
3420               **** **** ****     > runlib.asm
3421               0187
3422               0191
3423               0195
3424               0199
3425               0203
3426               0205                       copy  "cpu_strings.asm"          ; String utilities support
3427               **** **** ****     > cpu_strings.asm
3428               0001               * FILE......: cpu_strings.asm
3429               0002               * Purpose...: CPU string manipulation library
3430               0003
3431               0004
3432               0005               ***************************************************************
3433               0006               * string.ltrim - Left justify string
3434               0007               ***************************************************************
3435               0008               *  bl   @string.ltrim
3436               0009               *       data p0,p1,p2
3437               0010               *--------------------------------------------------------------
3438               0011               *  P0 = Pointer to length-prefix string
3439               0012               *  P1 = Pointer to RAM work buffer
3440               0013               *  P2 = Fill character
3441               0014               *--------------------------------------------------------------
3442               0015               *  BL   @xstring.ltrim
3443               0016               *
3444               0017               *  TMP0 = Pointer to length-prefix string
3445               0018               *  TMP1 = Pointer to RAM work buffer
3446               0019               *  TMP2 = Fill character
3447               0020               ********|*****|*********************|**************************
3448               0021               string.ltrim:
3449               0022 6A7E 0649  14         dect  stack
3450               0023 6A80 C64B  30         mov   r11,*stack            ; Save return address
3451               0024 6A82 0649  14         dect  stack
3452               0025 6A84 C644  30         mov   tmp0,*stack           ; Push tmp0
3453               0026 6A86 0649  14         dect  stack
3454               0027 6A88 C645  30         mov   tmp1,*stack           ; Push tmp1
3455               0028 6A8A 0649  14         dect  stack
3456               0029 6A8C C646  30         mov   tmp2,*stack           ; Push tmp2
3457               0030 6A8E 0649  14         dect  stack
3458               0031 6A90 C647  30         mov   tmp3,*stack           ; Push tmp3
3459               0032                       ;-----------------------------------------------------------------------
3460               0033                       ; Get parameter values
3461               0034                       ;-----------------------------------------------------------------------
3462               0035 6A92 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
3463               0036 6A94 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
3464               0037 6A96 C1BB  30         mov   *r11+,tmp2            ; Fill character
3465               0038 6A98 100A  14         jmp   !
3466               0039                       ;-----------------------------------------------------------------------
3467               0040                       ; Register version
3468               0041                       ;-----------------------------------------------------------------------
3469               0042               xstring.ltrim:
3470               0043 6A9A 0649  14         dect  stack
3471               0044 6A9C C64B  30         mov   r11,*stack            ; Save return address
3472               0045 6A9E 0649  14         dect  stack
3473               0046 6AA0 C644  30         mov   tmp0,*stack           ; Push tmp0
3474               0047 6AA2 0649  14         dect  stack
3475               0048 6AA4 C645  30         mov   tmp1,*stack           ; Push tmp1
3476               0049 6AA6 0649  14         dect  stack
3477               0050 6AA8 C646  30         mov   tmp2,*stack           ; Push tmp2
3478               0051 6AAA 0649  14         dect  stack
3479               0052 6AAC C647  30         mov   tmp3,*stack           ; Push tmp3
3480               0053                       ;-----------------------------------------------------------------------
3481               0054                       ; Start
3482               0055                       ;-----------------------------------------------------------------------
3483               0056 6AAE C1D4  26 !       mov   *tmp0,tmp3
3484               0057 6AB0 06C7  14         swpb  tmp3                  ; LO <-> HI
3485               0058 6AB2 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
3486                    6AB4 00FF
3487               0059 6AB6 0A86  56         sla   tmp2,8                ; LO -> HI fill character
3488               0060                       ;-----------------------------------------------------------------------
3489               0061                       ; Scan string from left to right and compare with fill character
3490               0062                       ;-----------------------------------------------------------------------
3491               0063               string.ltrim.scan:
3492               0064 6AB8 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
3493               0065 6ABA 1604  14         jne   string.ltrim.move     ; No, now move string left
3494               0066 6ABC 0584  14         inc   tmp0                  ; Next byte
3495               0067 6ABE 0607  14         dec   tmp3                  ; Shorten string length
3496               0068 6AC0 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
3497               0069 6AC2 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
3498               0070                       ;-----------------------------------------------------------------------
3499               0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
3500               0072                       ;-----------------------------------------------------------------------
3501               0073               string.ltrim.move:
3502               0074 6AC4 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
3503               0075 6AC6 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
3504               0076 6AC8 1306  14         jeq   string.ltrim.panic    ; File length assert
3505               0077 6ACA C187  18         mov   tmp3,tmp2
3506               0078 6ACC 06C7  14         swpb  tmp3                  ; HI <-> LO
3507               0079 6ACE DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
3508               0080
3509               0081 6AD0 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
3510                    6AD2 2492
3511               0082                                                   ; tmp1 = Memory target address
3512               0083                                                   ; tmp2 = Number of bytes to copy
3513               0084 6AD4 1004  14         jmp   string.ltrim.exit
3514               0085                       ;-----------------------------------------------------------------------
3515               0086                       ; CPU crash
3516               0087                       ;-----------------------------------------------------------------------
3517               0088               string.ltrim.panic:
3518               0089 6AD6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
3519                    6AD8 FFCE
3520               0090 6ADA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
3521                    6ADC 2030
3522               0091                       ;----------------------------------------------------------------------
3523               0092                       ; Exit
3524               0093                       ;----------------------------------------------------------------------
3525               0094               string.ltrim.exit:
3526               0095 6ADE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
3527               0096 6AE0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
3528               0097 6AE2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
3529               0098 6AE4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
3530               0099 6AE6 C2F9  30         mov   *stack+,r11           ; Pop r11
3531               0100 6AE8 045B  20         b     *r11                  ; Return to caller
3532               0101
3533               0102
3534               0103
3535               0104
3536               0105               ***************************************************************
3537               0106               * string.getlenc - Get length of C-style string
3538               0107               ***************************************************************
3539               0108               *  bl   @string.getlenc
3540               0109               *       data p0,p1
3541               0110               *--------------------------------------------------------------
3542               0111               *  P0 = Pointer to C-style string
3543               0112               *  P1 = String termination character
3544               0113               *--------------------------------------------------------------
3545               0114               *  bl   @xstring.getlenc
3546               0115               *
3547               0116               *  TMP0 = Pointer to C-style string
3548               0117               *  TMP1 = Termination character
3549               0118               *--------------------------------------------------------------
3550               0119               *  OUTPUT:
3551               0120               *  @waux1 = Length of string
3552               0121               ********|*****|*********************|**************************
3553               0122               string.getlenc:
3554               0123 6AEA 0649  14         dect  stack
3555               0124 6AEC C64B  30         mov   r11,*stack            ; Save return address
3556               0125 6AEE 05D9  26         inct  *stack                ; Skip "data P0"
3557               0126 6AF0 05D9  26         inct  *stack                ; Skip "data P1"
3558               0127 6AF2 0649  14         dect  stack
3559               0128 6AF4 C644  30         mov   tmp0,*stack           ; Push tmp0
3560               0129 6AF6 0649  14         dect  stack
3561               0130 6AF8 C645  30         mov   tmp1,*stack           ; Push tmp1
3562               0131 6AFA 0649  14         dect  stack
3563               0132 6AFC C646  30         mov   tmp2,*stack           ; Push tmp2
3564               0133                       ;-----------------------------------------------------------------------
3565               0134                       ; Get parameter values
3566               0135                       ;-----------------------------------------------------------------------
3567               0136 6AFE C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
3568               0137 6B00 C17B  30         mov   *r11+,tmp1            ; String termination character
3569               0138 6B02 1008  14         jmp   !
3570               0139                       ;-----------------------------------------------------------------------
3571               0140                       ; Register version
3572               0141                       ;-----------------------------------------------------------------------
3573               0142               xstring.getlenc:
3574               0143 6B04 0649  14         dect  stack
3575               0144 6B06 C64B  30         mov   r11,*stack            ; Save return address
3576               0145 6B08 0649  14         dect  stack
3577               0146 6B0A C644  30         mov   tmp0,*stack           ; Push tmp0
3578               0147 6B0C 0649  14         dect  stack
3579               0148 6B0E C645  30         mov   tmp1,*stack           ; Push tmp1
3580               0149 6B10 0649  14         dect  stack
3581               0150 6B12 C646  30         mov   tmp2,*stack           ; Push tmp2
3582               0151                       ;-----------------------------------------------------------------------
3583               0152                       ; Start
3584               0153                       ;-----------------------------------------------------------------------
3585               0154 6B14 0A85  56 !       sla   tmp1,8                ; LSB to MSB
3586               0155 6B16 04C6  14         clr   tmp2                  ; Loop counter
3587               0156                       ;-----------------------------------------------------------------------
3588               0157                       ; Scan string for termination character
3589               0158                       ;-----------------------------------------------------------------------
3590               0159               string.getlenc.loop:
3591               0160 6B18 0586  14         inc   tmp2
3592               0161 6B1A 9174  28         cb    *tmp0+,tmp1           ; Compare character
3593               0162 6B1C 1304  14         jeq   string.getlenc.putlength
3594               0163                       ;-----------------------------------------------------------------------
3595               0164                       ; Sanity check on string length
3596               0165                       ;-----------------------------------------------------------------------
3597               0166 6B1E 0286  22         ci    tmp2,255
3598                    6B20 00FF
3599               0167 6B22 1505  14         jgt   string.getlenc.panic
3600               0168 6B24 10F9  14         jmp   string.getlenc.loop
3601               0169                       ;-----------------------------------------------------------------------
3602               0170                       ; Return length
3603               0171                       ;-----------------------------------------------------------------------
3604               0172               string.getlenc.putlength:
3605               0173 6B26 0606  14         dec   tmp2                  ; One time adjustment
3606               0174 6B28 C806  38         mov   tmp2,@waux1           ; Store length
3607                    6B2A 833C
3608               0175 6B2C 1004  14         jmp   string.getlenc.exit   ; Exit
3609               0176                       ;-----------------------------------------------------------------------
3610               0177                       ; CPU crash
3611               0178                       ;-----------------------------------------------------------------------
3612               0179               string.getlenc.panic:
3613               0180 6B2E C80B  38         mov   r11,@>ffce            ; \ Save caller address
3614                    6B30 FFCE
3615               0181 6B32 06A0  32         bl    @cpu.crash            ; / Crash and halt system
3616                    6B34 2030
3617               0182                       ;----------------------------------------------------------------------
3618               0183                       ; Exit
3619               0184                       ;----------------------------------------------------------------------
3620               0185               string.getlenc.exit:
3621               0186 6B36 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
3622               0187 6B38 C179  30         mov   *stack+,tmp1          ; Pop tmp1
3623               0188 6B3A C139  30         mov   *stack+,tmp0          ; Pop tmp0
3624               0189 6B3C C2F9  30         mov   *stack+,r11           ; Pop r11
3625               0190 6B3E 045B  20         b     *r11                  ; Return to caller
3626               **** **** ****     > runlib.asm
3627               0207
3628               0211
3629               0213                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
3630               **** **** ****     > cpu_scrpad_backrest.asm
3631               0001               * FILE......: cpu_scrpad_backrest.asm
3632               0002               * Purpose...: Scratchpad memory backup/restore functions
3633               0003
3634               0004               *//////////////////////////////////////////////////////////////
3635               0005               *                Scratchpad memory backup/restore
3636               0006               *//////////////////////////////////////////////////////////////
3637               0007
3638               0008               ***************************************************************
3639               0009               * cpu.scrpad.backup - Backup scratchpad memory to cpu.scrpad.tgt
3640               0010               ***************************************************************
3641               0011               *  bl   @cpu.scrpad.backup
3642               0012               *--------------------------------------------------------------
3643               0013               *  Register usage
3644               0014               *  r0-r2, but values restored before exit
3645               0015               *--------------------------------------------------------------
3646               0016               *  Backup scratchpad memory to destination range
3647               0017               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
3648               0018               *
3649               0019               *  Expects current workspace to be in scratchpad memory.
3650               0020               ********|*****|*********************|**************************
3651               0021               cpu.scrpad.backup:
3652               0022 6B40 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
3653                    6B42 F000
3654               0023 6B44 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
3655                    6B46 F002
3656               0024 6B48 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
3657                    6B4A F004
3658               0025                       ;------------------------------------------------------
3659               0026                       ; Prepare for copy loop
3660               0027                       ;------------------------------------------------------
3661               0028 6B4C 0200  20         li    r0,>8306              ; Scratpad source address
3662                    6B4E 8306
3663               0029 6B50 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
3664                    6B52 F006
3665               0030 6B54 0202  20         li    r2,62                 ; Loop counter
3666                    6B56 003E
3667               0031                       ;------------------------------------------------------
3668               0032                       ; Copy memory range >8306 - >83ff
3669               0033                       ;------------------------------------------------------
3670               0034               cpu.scrpad.backup.copy:
3671               0035 6B58 CC70  46         mov   *r0+,*r1+
3672               0036 6B5A CC70  46         mov   *r0+,*r1+
3673               0037 6B5C 0642  14         dect  r2
3674               0038 6B5E 16FC  14         jne   cpu.scrpad.backup.copy
3675               0039 6B60 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
3676                    6B62 83FE
3677                    6B64 F0FE
3678               0040                                                   ; Copy last word
3679               0041                       ;------------------------------------------------------
3680               0042                       ; Restore register r0 - r2
3681               0043                       ;------------------------------------------------------
3682               0044 6B66 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
3683                    6B68 F000
3684               0045 6B6A C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
3685                    6B6C F002
3686               0046 6B6E C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
3687                    6B70 F004
3688               0047                       ;------------------------------------------------------
3689               0048                       ; Exit
3690               0049                       ;------------------------------------------------------
3691               0050               cpu.scrpad.backup.exit:
3692               0051 6B72 045B  20         b     *r11                  ; Return to caller
3693               0052
3694               0053
3695               0054               ***************************************************************
3696               0055               * cpu.scrpad.restore - Restore scratchpad memory from cpu.scrpad.tgt
3697               0056               ***************************************************************
3698               0057               *  bl   @cpu.scrpad.restore
3699               0058               *--------------------------------------------------------------
3700               0059               *  Register usage
3701               0060               *  r0-r2, but values restored before exit
3702               0061               *--------------------------------------------------------------
3703               0062               *  Restore scratchpad from memory area
3704               0063               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
3705               0064               *  Current workspace can be outside scratchpad when called.
3706               0065               ********|*****|*********************|**************************
3707               0066               cpu.scrpad.restore:
3708               0067                       ;------------------------------------------------------
3709               0068                       ; Restore scratchpad >8300 - >8304
3710               0069                       ;------------------------------------------------------
3711               0070 6B74 C820  54         mov   @cpu.scrpad.tgt,@>8300
3712                    6B76 F000
3713                    6B78 8300
3714               0071 6B7A C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
3715                    6B7C F002
3716                    6B7E 8302
3717               0072 6B80 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
3718                    6B82 F004
3719                    6B84 8304
3720               0073                       ;------------------------------------------------------
3721               0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
3722               0075                       ;------------------------------------------------------
3723               0076 6B86 C800  38         mov   r0,@cpu.scrpad.tgt
3724                    6B88 F000
3725               0077 6B8A C801  38         mov   r1,@cpu.scrpad.tgt + 2
3726                    6B8C F002
3727               0078 6B8E C802  38         mov   r2,@cpu.scrpad.tgt + 4
3728                    6B90 F004
3729               0079                       ;------------------------------------------------------
3730               0080                       ; Prepare for copy loop, WS
3731               0081                       ;------------------------------------------------------
3732               0082 6B92 0200  20         li    r0,cpu.scrpad.tgt + 6
3733                    6B94 F006
3734               0083 6B96 0201  20         li    r1,>8306
3735                    6B98 8306
3736               0084 6B9A 0202  20         li    r2,62
3737                    6B9C 003E
3738               0085                       ;------------------------------------------------------
3739               0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
3740               0087                       ;------------------------------------------------------
3741               0088               cpu.scrpad.restore.copy:
3742               0089 6B9E CC70  46         mov   *r0+,*r1+
3743               0090 6BA0 CC70  46         mov   *r0+,*r1+
3744               0091 6BA2 0642  14         dect  r2
3745               0092 6BA4 16FC  14         jne   cpu.scrpad.restore.copy
3746               0093 6BA6 C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
3747                    6BA8 F0FE
3748                    6BAA 83FE
3749               0094                                                   ; Copy last word
3750               0095                       ;------------------------------------------------------
3751               0096                       ; Restore register r0 - r2
3752               0097                       ;------------------------------------------------------
3753               0098 6BAC C020  34         mov   @cpu.scrpad.tgt,r0
3754                    6BAE F000
3755               0099 6BB0 C060  34         mov   @cpu.scrpad.tgt + 2,r1
3756                    6BB2 F002
3757               0100 6BB4 C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
3758                    6BB6 F004
3759               0101                       ;------------------------------------------------------
3760               0102                       ; Exit
3761               0103                       ;------------------------------------------------------
3762               0104               cpu.scrpad.restore.exit:
3763               0105 6BB8 045B  20         b     *r11                  ; Return to caller
3764               **** **** ****     > runlib.asm
3765               0214                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
3766               **** **** ****     > cpu_scrpad_paging.asm
3767               0001               * FILE......: cpu_scrpad_paging.asm
3768               0002               * Purpose...: CPU memory paging functions
3769               0003
3770               0004               *//////////////////////////////////////////////////////////////
3771               0005               *                     CPU memory paging
3772               0006               *//////////////////////////////////////////////////////////////
3773               0007
3774               0008
3775               0009               ***************************************************************
3776               0010               * cpu.scrpad.pgout - Page out scratchpad memory
3777               0011               ***************************************************************
3778               0012               *  bl   @cpu.scrpad.pgout
3779               0013               *       DATA p0
3780               0014               *
3781               0015               *  P0 = CPU memory destination
3782               0016               *--------------------------------------------------------------
3783               0017               *  bl   @xcpu.scrpad.pgout
3784               0018               *  TMP1 = CPU memory destination
3785               0019               *--------------------------------------------------------------
3786               0020               *  Register usage
3787               0021               *  tmp0-tmp2 = Used as temporary registers
3788               0022               *  tmp3      = Copy of CPU memory destination
3789               0023               ********|*****|*********************|**************************
3790               0024               cpu.scrpad.pgout:
3791               0025 6BBA C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
3792               0026                       ;------------------------------------------------------
3793               0027                       ; Copy scratchpad memory to destination
3794               0028                       ;------------------------------------------------------
3795               0029               xcpu.scrpad.pgout:
3796               0030 6BBC 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
3797                    6BBE 8300
3798               0031 6BC0 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
3799               0032 6BC2 0206  20         li    tmp2,128              ; tmp2 = Words to copy
3800                    6BC4 0080
3801               0033                       ;------------------------------------------------------
3802               0034                       ; Copy memory
3803               0035                       ;------------------------------------------------------
3804               0036 6BC6 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
3805               0037 6BC8 0606  14         dec   tmp2
3806               0038 6BCA 16FD  14         jne   -!                    ; Loop until done
3807               0039                       ;------------------------------------------------------
3808               0040                       ; Switch to new workspace
3809               0041                       ;------------------------------------------------------
3810               0042 6BCC C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
3811               0043 6BCE 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
3812                    6BD0 2B62
3813               0044                                                   ; R14=PC
3814               0045 6BD2 04CF  14         clr   r15                   ; R15=STATUS
3815               0046                       ;------------------------------------------------------
3816               0047                       ; If we get here, WS was copied to specified
3817               0048                       ; destination.  Also contents of r13,r14,r15
3818               0049                       ; are about to be overwritten by rtwp instruction.
3819               0050                       ;------------------------------------------------------
3820               0051 6BD4 0380  18         rtwp                        ; Activate copied workspace
3821               0052                                                   ; in non-scratchpad memory!
3822               0053
3823               0054               cpu.scrpad.pgout.after.rtwp:
3824               0055 6BD6 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
3825                    6BD8 2B00
3826               0056
3827               0057                       ;------------------------------------------------------
3828               0058                       ; Exit
3829               0059                       ;------------------------------------------------------
3830               0060               cpu.scrpad.pgout.$$:
3831               0061 6BDA 045B  20         b     *r11                  ; Return to caller
3832               0062
3833               0063
3834               0064               ***************************************************************
3835               0065               * cpu.scrpad.pgin - Page in scratchpad memory
3836               0066               ***************************************************************
3837               0067               *  bl   @cpu.scrpad.pgin
3838               0068               *  DATA p0
3839               0069               *  P0 = CPU memory source
3840               0070               *--------------------------------------------------------------
3841               0071               *  bl   @memx.scrpad.pgin
3842               0072               *  TMP1 = CPU memory source
3843               0073               *--------------------------------------------------------------
3844               0074               *  Register usage
3845               0075               *  tmp0-tmp2 = Used as temporary registers
3846               0076               ********|*****|*********************|**************************
3847               0077               cpu.scrpad.pgin:
3848               0078 6BDC C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
3849               0079                       ;------------------------------------------------------
3850               0080                       ; Copy scratchpad memory to destination
3851               0081                       ;------------------------------------------------------
3852               0082               xcpu.scrpad.pgin:
3853               0083 6BDE 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
3854                    6BE0 8300
3855               0084 6BE2 0206  20         li    tmp2,128              ; tmp2 = Words to copy
3856                    6BE4 0080
3857               0085                       ;------------------------------------------------------
3858               0086                       ; Copy memory
3859               0087                       ;------------------------------------------------------
3860               0088 6BE6 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
3861               0089 6BE8 0606  14         dec   tmp2
3862               0090 6BEA 16FD  14         jne   -!                    ; Loop until done
3863               0091                       ;------------------------------------------------------
3864               0092                       ; Switch workspace to scratchpad memory
3865               0093                       ;------------------------------------------------------
3866               0094 6BEC 02E0  18         lwpi  >8300                 ; Activate copied workspace
3867                    6BEE 8300
3868               0095                       ;------------------------------------------------------
3869               0096                       ; Exit
3870               0097                       ;------------------------------------------------------
3871               0098               cpu.scrpad.pgin.$$:
3872               0099 6BF0 045B  20         b     *r11                  ; Return to caller
3873               **** **** ****     > runlib.asm
3874               0216
3875               0218                       copy  "equ_fio.asm"              ; File I/O equates
3876               **** **** ****     > equ_fio.asm
3877               0001               * FILE......: equ_fio.asm
3878               0002               * Purpose...: Equates for file I/O operations
3879               0003
3880               0004               ***************************************************************
3881               0005               * File IO operations
3882               0006               ************************************@**************************
3883               0007      0000     io.op.open       equ >00            ; OPEN
3884               0008      0001     io.op.close      equ >01            ; CLOSE
3885               0009      0002     io.op.read       equ >02            ; READ
3886               0010      0003     io.op.write      equ >03            ; WRITE
3887               0011      0004     io.op.rewind     equ >04            ; RESTORE/REWIND
3888               0012      0005     io.op.load       equ >05            ; LOAD
3889               0013      0006     io.op.save       equ >06            ; SAVE
3890               0014      0007     io.op.delfile    equ >07            ; DELETE FILE
3891               0015      0008     io.op.scratch    equ >08            ; SCRATCH
3892               0016      0009     io.op.status     equ >09            ; STATUS
3893               0017               ***************************************************************
3894               0018               * File types - All relative files are fixed length
3895               0019               ************************************@**************************
3896               0020      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
3897               0021      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
3898               0022      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
3899               0023      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
3900               0024      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
3901               0025      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
3902               0026               ***************************************************************
3903               0027               * File types - Sequential files
3904               0028               ************************************@**************************
3905               0029      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
3906               0030      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
3907               0031      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
3908               0032      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
3909               0033      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
3910               0034      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
3911               0035      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
3912               0036      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
3913               0037      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
3914               0038      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
3915               0039      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
3916               0040      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
3917               0041
3918               0042               ***************************************************************
3919               0043               * File error codes - Bits 13-15 in PAB byte 1
3920               0044               ************************************@**************************
3921               0045      0000     io.err.no_error_occured             equ 0
3922               0046                       ; Error code 0 with condition bit reset, indicates that
3923               0047                       ; no error has occured
3924               0048
3925               0049      0000     io.err.bad_device_name              equ 0
3926               0050                       ; Device indicated not in system
3927               0051                       ; Error code 0 with condition bit set, indicates a
3928               0052                       ; device not present in system
3929               0053
3930               0054      0001     io.err.device_write_prottected      equ 1
3931               0055                       ; Device is write protected
3932               0056
3933               0057      0002     io.err.bad_open_attribute           equ 2
3934               0058                       ; One or more of the OPEN attributes are illegal or do
3935               0059                       ; not match the file's actual characteristics.
3936               0060                       ; This could be:
3937               0061                       ;   * File type
3938               0062                       ;   * Record length
3939               0063                       ;   * I/O mode
3940               0064                       ;   * File organization
3941               0065
3942               0066      0003     io.err.illegal_operation            equ 3
3943               0067                       ; Either an issued I/O command was not supported, or a
3944               0068                       ; conflict with the OPEN mode has occured
3945               0069
3946               0070      0004     io.err.out_of_table_buffer_space    equ 4
3947               0071                       ; The amount of space left on the device is insufficient
3948               0072                       ; for the requested operation
3949               0073
3950               0074      0005     io.err.eof                          equ 5
3951               0075                       ; Attempt to read past end of file.
3952               0076                       ; This error may also be given for non-existing records
3953               0077                       ; in a relative record file
3954               0078
3955               0079      0006     io.err.device_error                 equ 6
3956               0080                       ; Covers all hard device errors, such as parity and
3957               0081                       ; bad medium errors
3958               0082
3959               0083      0007     io.err.file_error                   equ 7
3960               0084                       ; Covers all file-related error like: program/data
3961               0085                       ; file mismatch, non-existing file opened for input mode, etc.
3962               **** **** ****     > runlib.asm
3963               0219                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
3964               **** **** ****     > fio_dsrlnk.asm
3965               0001               * FILE......: fio_dsrlnk.asm
3966               0002               * Purpose...: Custom DSRLNK implementation
3967               0003
3968               0004               *//////////////////////////////////////////////////////////////
3969               0005               *                          DSRLNK
3970               0006               *//////////////////////////////////////////////////////////////
3971               0007
3972               0008
3973               0009               ***************************************************************
3974               0010               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
3975               0011               ***************************************************************
3976               0012               *  blwp @dsrlnk
3977               0013               *  data p0
3978               0014               *--------------------------------------------------------------
3979               0015               *  P0 = 8 or 10 (a)
3980               0016               *--------------------------------------------------------------
3981               0017               *  Output:
3982               0018               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
3983               0019               *--------------------------------------------------------------
3984               0020               ; Spectra2 scratchpad memory needs to be paged out before.
3985               0021               ; You need to specify following equates in main program
3986               0022               ;
3987               0023               ; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
3988               0024               ; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
3989               0025               ;
3990               0026               ; Scratchpad memory usage
3991               0027               ; >8322            Parameter (>08) or (>0A) passed to dsrlnk
3992               0028               ; >8356            Pointer to PAB
3993               0029               ; >83D0            CRU address of current device
3994               0030               ; >83D2            DSR entry address
3995               0031               ; >83e0 - >83ff    GPL / DSRLNK workspace
3996               0032               ;
3997               0033               ; Credits
3998               0034               ; Originally appeared in Miller Graphics The Smart Programmer.
3999               0035               ; This version based on version of Paolo Bagnaresi.
4000               0036               *--------------------------------------------------------------
4001               0037      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
4002               0038                                                   ; dstype is address of R5 of DSRLNK ws
4003               0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
4004               0040               ********|*****|*********************|**************************
4005               0041 6BF2 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
4006               0042 6BF4 2B82             data  dsrlnk.init           ; entry point
4007               0043                       ;------------------------------------------------------
4008               0044                       ; DSRLNK entry point
4009               0045                       ;------------------------------------------------------
4010               0046               dsrlnk.init:
4011               0047 6BF6 C17E  30         mov   *r14+,r5              ; get pgm type for link
4012               0048 6BF8 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
4013                    6BFA 8322
4014               0049 6BFC 53E0  34         szcb  @hb$20,r15            ; reset equal bit
4015                    6BFE 2026
4016               0050 6C00 C020  34         mov   @>8356,r0             ; get ptr to pab
4017                    6C02 8356
4018               0051 6C04 C240  18         mov   r0,r9                 ; save ptr
4019               0052                       ;------------------------------------------------------
4020               0053                       ; Fetch file descriptor length from PAB
4021               0054                       ;------------------------------------------------------
4022               0055 6C06 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
4023                    6C08 FFF8
4024               0056
4025               0057                       ;---------------------------; Inline VSBR start
4026               0058 6C0A 06C0  14         swpb  r0                    ;
4027               0059 6C0C D800  38         movb  r0,@vdpa              ; send low byte
4028                    6C0E 8C02
4029               0060 6C10 06C0  14         swpb  r0                    ;
4030               0061 6C12 D800  38         movb  r0,@vdpa              ; send high byte
4031                    6C14 8C02
4032               0062 6C16 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
4033                    6C18 8800
4034               0063                       ;---------------------------; Inline VSBR end
4035               0064 6C1A 0983  56         srl   r3,8                  ; Move to low byte
4036               0065
4037               0066                       ;------------------------------------------------------
4038               0067                       ; Fetch file descriptor device name from PAB
4039               0068                       ;------------------------------------------------------
4040               0069 6C1C 0704  14         seto  r4                    ; init counter
4041               0070 6C1E 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
4042                    6C20 A420
4043               0071 6C22 0580  14 !       inc   r0                    ; point to next char of name
4044               0072 6C24 0584  14         inc   r4                    ; incr char counter
4045               0073 6C26 0284  22         ci    r4,>0007              ; see if length more than 7 chars
4046                    6C28 0007
4047               0074 6C2A 1565  14         jgt   dsrlnk.error.devicename_invalid
4048               0075                                                   ; yes, error
4049               0076 6C2C 80C4  18         c     r4,r3                 ; end of name?
4050               0077 6C2E 130C  14         jeq   dsrlnk.device_name.get_length
4051               0078                                                   ; yes
4052               0079
4053               0080                       ;---------------------------; Inline VSBR start
4054               0081 6C30 06C0  14         swpb  r0                    ;
4055               0082 6C32 D800  38         movb  r0,@vdpa              ; send low byte
4056                    6C34 8C02
4057               0083 6C36 06C0  14         swpb  r0                    ;
4058               0084 6C38 D800  38         movb  r0,@vdpa              ; send high byte
4059                    6C3A 8C02
4060               0085 6C3C D060  34         movb  @vdpr,r1              ; read byte from VDP ram
4061                    6C3E 8800
4062               0086                       ;---------------------------; Inline VSBR end
4063               0087
4064               0088                       ;------------------------------------------------------
4065               0089                       ; Look for end of device name, for example "DSK1."
4066               0090                       ;------------------------------------------------------
4067               0091 6C40 DC81  32         movb  r1,*r2+               ; move into buffer
4068               0092 6C42 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
4069                    6C44 2C92
4070               0093 6C46 16ED  14         jne   -!                    ; no, loop next char
4071               0094                       ;------------------------------------------------------
4072               0095                       ; Determine device name length
4073               0096                       ;------------------------------------------------------
4074               0097               dsrlnk.device_name.get_length:
4075               0098 6C48 C104  18         mov   r4,r4                 ; Check if length = 0
4076               0099 6C4A 1355  14         jeq   dsrlnk.error.devicename_invalid
4077               0100                                                   ; yes, error
4078               0101 6C4C 04E0  34         clr   @>83d0
4079                    6C4E 83D0
4080               0102 6C50 C804  38         mov   r4,@>8354             ; save name length for search
4081                    6C52 8354
4082               0103 6C54 0584  14         inc   r4                    ; adjust for dot
4083               0104 6C56 A804  38         a     r4,@>8356             ; point to position after name
4084                    6C58 8356
4085               0105                       ;------------------------------------------------------
4086               0106                       ; Prepare for DSR scan >1000 - >1f00
4087               0107                       ;------------------------------------------------------
4088               0108               dsrlnk.dsrscan.start:
4089               0109 6C5A 02E0  18         lwpi  >83e0                 ; Use GPL WS
4090                    6C5C 83E0
4091               0110 6C5E 04C1  14         clr   r1                    ; version found of dsr
4092               0111 6C60 020C  20         li    r12,>0f00             ; init cru addr
4093                    6C62 0F00
4094               0112                       ;------------------------------------------------------
4095               0113                       ; Turn off ROM on current card
4096               0114                       ;------------------------------------------------------
4097               0115               dsrlnk.dsrscan.cardoff:
4098               0116 6C64 C30C  18         mov   r12,r12               ; anything to turn off?
4099               0117 6C66 1301  14         jeq   dsrlnk.dsrscan.cardloop
4100               0118                                                   ; no, loop over cards
4101               0119 6C68 1E00  20         sbz   0                     ; yes, turn off
4102               0120                       ;------------------------------------------------------
4103               0121                       ; Loop over cards and look if DSR present
4104               0122                       ;------------------------------------------------------
4105               0123               dsrlnk.dsrscan.cardloop:
4106               0124 6C6A 022C  22         ai    r12,>0100             ; next rom to turn on
4107                    6C6C 0100
4108               0125 6C6E 04E0  34         clr   @>83d0                ; clear in case we are done
4109                    6C70 83D0
4110               0126 6C72 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
4111                    6C74 2000
4112               0127 6C76 133D  14         jeq   dsrlnk.error.nodsr_found
4113               0128                                                   ; yes, no matching DSR found
4114               0129 6C78 C80C  38         mov   r12,@>83d0            ; save addr of next cru
4115                    6C7A 83D0
4116               0130                       ;------------------------------------------------------
4117               0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
4118               0132                       ;------------------------------------------------------
4119               0133 6C7C 1D00  20         sbo   0                     ; turn on rom
4120               0134 6C7E 0202  20         li    r2,>4000              ; start at beginning of rom
4121                    6C80 4000
4122               0135 6C82 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
4123                    6C84 2C8E
4124               0136 6C86 16EE  14         jne   dsrlnk.dsrscan.cardoff
4125               0137                                                   ; no rom found on card
4126               0138                       ;------------------------------------------------------
4127               0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
4128               0140                       ;------------------------------------------------------
4129               0141                       ; dstype is the address of R5 of the DSRLNK workspace,
4130               0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
4131               0143                       ; is stored before the DSR ROM is searched.
4132               0144                       ;------------------------------------------------------
4133               0145 6C88 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
4134                    6C8A A40A
4135               0146 6C8C 1003  14         jmp   dsrlnk.dsrscan.getentry
4136               0147                       ;------------------------------------------------------
4137               0148                       ; Next DSR entry
4138               0149                       ;------------------------------------------------------
4139               0150               dsrlnk.dsrscan.nextentry:
4140               0151 6C8E C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
4141                    6C90 83D2
4142               0152                                                   ; subprogram
4143               0153
4144               0154 6C92 1D00  20         sbo   0                     ; turn rom back on
4145               0155                       ;------------------------------------------------------
4146               0156                       ; Get DSR entry
4147               0157                       ;------------------------------------------------------
4148               0158               dsrlnk.dsrscan.getentry:
4149               0159 6C94 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
4150               0160 6C96 13E6  14         jeq   dsrlnk.dsrscan.cardoff
4151               0161                                                   ; yes, no more DSRs or programs to check
4152               0162 6C98 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
4153                    6C9A 83D2
4154               0163                                                   ; subprogram
4155               0164
4156               0165 6C9C 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
4157               0166                                                   ; DSR/subprogram code
4158               0167
4159               0168 6C9E C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
4160               0169                                                   ; offset 4 (DSR/subprogram name)
4161               0170                       ;------------------------------------------------------
4162               0171                       ; Check file descriptor in DSR
4163               0172                       ;------------------------------------------------------
4164               0173 6CA0 04C5  14         clr   r5                    ; Remove any old stuff
4165               0174 6CA2 D160  34         movb  @>8355,r5             ; get length as counter
4166                    6CA4 8355
4167               0175 6CA6 130B  14         jeq   dsrlnk.dsrscan.call_dsr
4168               0176                                                   ; if zero, do not further check, call DSR
4169               0177                                                   ; program
4170               0178
4171               0179 6CA8 9C85  32         cb    r5,*r2+               ; see if length matches
4172               0180 6CAA 16F1  14         jne   dsrlnk.dsrscan.nextentry
4173               0181                                                   ; no, length does not match. Go process next
4174               0182                                                   ; DSR entry
4175               0183
4176               0184 6CAC 0985  56         srl   r5,8                  ; yes, move to low byte
4177               0185 6CAE 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
4178                    6CB0 A420
4179               0186 6CB2 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
4180               0187                                                   ; DSR ROM
4181               0188 6CB4 16EC  14         jne   dsrlnk.dsrscan.nextentry
4182               0189                                                   ; try next DSR entry if no match
4183               0190 6CB6 0605  14         dec   r5                    ; loop until full length checked
4184               0191 6CB8 16FC  14         jne   -!
4185               0192                       ;------------------------------------------------------
4186               0193                       ; Device name/Subprogram match
4187               0194                       ;------------------------------------------------------
4188               0195               dsrlnk.dsrscan.match:
4189               0196 6CBA C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
4190                    6CBC 83D2
4191               0197
4192               0198                       ;------------------------------------------------------
4193               0199                       ; Call DSR program in device card
4194               0200                       ;------------------------------------------------------
4195               0201               dsrlnk.dsrscan.call_dsr:
4196               0202 6CBE 0581  14         inc   r1                    ; next version found
4197               0203 6CC0 0699  24         bl    *r9                   ; go run routine
4198               0204                       ;
4199               0205                       ; Depending on IO result the DSR in card ROM does RET
4200               0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
4201               0207                       ;
4202               0208 6CC2 10E5  14         jmp   dsrlnk.dsrscan.nextentry
4203               0209                                                   ; (1) error return
4204               0210 6CC4 1E00  20         sbz   0                     ; (2) turn off rom if good return
4205               0211 6CC6 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
4206                    6CC8 A400
4207               0212 6CCA C009  18         mov   r9,r0                 ; point to flag in pab
4208               0213 6CCC C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
4209                    6CCE 8322
4210               0214                                                   ; (8 or >a)
4211               0215 6CD0 0281  22         ci    r1,8                  ; was it 8?
4212                    6CD2 0008
4213               0216 6CD4 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
4214               0217 6CD6 D060  34         movb  @>8350,r1             ; no, we have a data >a.
4215                    6CD8 8350
4216               0218                                                   ; Get error byte from @>8350
4217               0219 6CDA 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
4218               0220
4219               0221                       ;------------------------------------------------------
4220               0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
4221               0223                       ;------------------------------------------------------
4222               0224               dsrlnk.dsrscan.dsr.8:
4223               0225                       ;---------------------------; Inline VSBR start
4224               0226 6CDC 06C0  14         swpb  r0                    ;
4225               0227 6CDE D800  38         movb  r0,@vdpa              ; send low byte
4226                    6CE0 8C02
4227               0228 6CE2 06C0  14         swpb  r0                    ;
4228               0229 6CE4 D800  38         movb  r0,@vdpa              ; send high byte
4229                    6CE6 8C02
4230               0230 6CE8 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
4231                    6CEA 8800
4232               0231                       ;---------------------------; Inline VSBR end
4233               0232
4234               0233                       ;------------------------------------------------------
4235               0234                       ; Return DSR error to caller
4236               0235                       ;------------------------------------------------------
4237               0236               dsrlnk.dsrscan.dsr.a:
4238               0237 6CEC 09D1  56         srl   r1,13                 ; just keep error bits
4239               0238 6CEE 1604  14         jne   dsrlnk.error.io_error
4240               0239                                                   ; handle IO error
4241               0240 6CF0 0380  18         rtwp                        ; Return from DSR workspace to caller
4242               0241                                                   ; workspace
4243               0242
4244               0243                       ;------------------------------------------------------
4245               0244                       ; IO-error handler
4246               0245                       ;------------------------------------------------------
4247               0246               dsrlnk.error.nodsr_found:
4248               0247 6CF2 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
4249                    6CF4 A400
4250               0248               dsrlnk.error.devicename_invalid:
4251               0249 6CF6 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
4252               0250               dsrlnk.error.io_error:
4253               0251 6CF8 06C1  14         swpb  r1                    ; put error in hi byte
4254               0252 6CFA D741  30         movb  r1,*r13               ; store error flags in callers r0
4255               0253 6CFC F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
4256                    6CFE 2026
4257               0254 6D00 0380  18         rtwp                        ; Return from DSR workspace to caller
4258               0255                                                   ; workspace
4259               0256
4260               0257               ********************************************************************************
4261               0258
4262               0259 6D02 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
4263               0260 6D04 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
4264               0261                                                   ; a @blwp @dsrlnk
4265               0262 6D06 ....     dsrlnk.period     text  '.'         ; For finding end of device name
4266               0263
4267               0264                       even
4268               **** **** ****     > runlib.asm
4269               0220                       copy  "fio_level2.asm"           ; File I/O level 2 support
4270               **** **** ****     > fio_level2.asm
4271               0001               * FILE......: fio_level2.asm
4272               0002               * Purpose...: File I/O level 2 support
4273               0003
4274               0004
4275               0005               ***************************************************************
4276               0006               * PAB  - Peripheral Access Block
4277               0007               ********|*****|*********************|**************************
4278               0008               ; my_pab:
4279               0009               ;       byte  io.op.open            ;  0    - OPEN
4280               0010               ;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
4281               0011               ;                                   ;         Bit 13-15 used by DSR for returning
4282               0012               ;                                   ;         file error details to DSRLNK
4283               0013               ;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
4284               0014               ;       byte  80                    ;  4    - Record length (80 characters maximum)
4285               0015               ;       byte  0                     ;  5    - Character count (bytes read)
4286               0016               ;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
4287               0017               ;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
4288               0018               ; -------------------------------------------------------------
4289               0019               ;       byte  11                    ;  9    - File descriptor length
4290               0020               ;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
4291               0021               ;       even
4292               0022               ***************************************************************
4293               0023
4294               0024
4295               0025               ***************************************************************
4296               0026               * file.open - Open File for procesing
4297               0027               ***************************************************************
4298               0028               *  bl   @file.open
4299               0029               *       data P0
4300               0030               *--------------------------------------------------------------
4301               0031               *  P0 = Address of PAB in VDP RAM
4302               0032               *--------------------------------------------------------------
4303               0033               *  bl   @xfile.open
4304               0034               *
4305               0035               *  R0 = Address of PAB in VDP RAM
4306               0036               *--------------------------------------------------------------
4307               0037               *  Output:
4308               0038               *  tmp0 LSB = VDP PAB byte 1 (status)
4309               0039               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4310               0040               *  tmp2     = Status register contents upon DSRLNK return
4311               0041               ********|*****|*********************|**************************
4312               0042               file.open:
4313               0043 6D08 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4314               0044               *--------------------------------------------------------------
4315               0045               * Initialisation
4316               0046               *--------------------------------------------------------------
4317               0047               xfile.open:
4318               0048 6D0A 04C5  14         clr   tmp1                  ; io.op.open
4319               0049 6D0C 1012  14         jmp   _file.record.fop      ; Do file operation
4320               0050
4321               0051
4322               0052
4323               0053               ***************************************************************
4324               0054               * file.close - Close currently open file
4325               0055               ***************************************************************
4326               0056               *  bl   @file.close
4327               0057               *       data P0
4328               0058               *--------------------------------------------------------------
4329               0059               *  P0 = Address of PAB in VDP RAM
4330               0060               *--------------------------------------------------------------
4331               0061               *  bl   @xfile.close
4332               0062               *
4333               0063               *  R0 = Address of PAB in VDP RAM
4334               0064               *--------------------------------------------------------------
4335               0065               *  Output:
4336               0066               *  tmp0 LSB = VDP PAB byte 1 (status)
4337               0067               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4338               0068               *  tmp2     = Status register contents upon DSRLNK return
4339               0069               ********|*****|*********************|**************************
4340               0070               file.close:
4341               0071 6D0E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4342               0072               *--------------------------------------------------------------
4343               0073               * Initialisation
4344               0074               *--------------------------------------------------------------
4345               0075               xfile.close:
4346               0076 6D10 0205  20         li    tmp1,io.op.close      ; io.op.close
4347                    6D12 0001
4348               0077 6D14 100E  14         jmp   _file.record.fop      ; Do file operation
4349               0078
4350               0079
4351               0080               ***************************************************************
4352               0081               * file.record.read - Read record from file
4353               0082               ***************************************************************
4354               0083               *  bl   @file.record.read
4355               0084               *       data P0
4356               0085               *--------------------------------------------------------------
4357               0086               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
4358               0087               *--------------------------------------------------------------
4359               0088               *  bl   @xfile.record.read
4360               0089               *
4361               0090               *  R0 = Address of PAB in VDP RAM
4362               0091               *--------------------------------------------------------------
4363               0092               *  Output:
4364               0093               *  tmp0 LSB = VDP PAB byte 1 (status)
4365               0094               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4366               0095               *  tmp2     = Status register contents upon DSRLNK return
4367               0096               ********|*****|*********************|**************************
4368               0097               file.record.read:
4369               0098 6D16 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4370               0099               *--------------------------------------------------------------
4371               0100               * Initialisation
4372               0101               *--------------------------------------------------------------
4373               0102 6D18 0205  20         li    tmp1,io.op.read       ; io.op.read
4374                    6D1A 0002
4375               0103 6D1C 100A  14         jmp   _file.record.fop      ; Do file operation
4376               0104
4377               0105
4378               0106
4379               0107               ***************************************************************
4380               0108               * file.record.write - Write record to file
4381               0109               ***************************************************************
4382               0110               *  bl   @file.record.write
4383               0111               *       data P0
4384               0112               *--------------------------------------------------------------
4385               0113               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
4386               0114               *--------------------------------------------------------------
4387               0115               *  bl   @xfile.record.read
4388               0116               *
4389               0117               *  R0 = Address of PAB in VDP RAM
4390               0118               *--------------------------------------------------------------
4391               0119               *  Output:
4392               0120               *  tmp0 LSB = VDP PAB byte 1 (status)
4393               0121               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4394               0122               *  tmp2     = Status register contents upon DSRLNK return
4395               0123               ********|*****|*********************|**************************
4396               0124               file.record.write:
4397               0125 6D1E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4398               0126               *--------------------------------------------------------------
4399               0127               * Initialisation
4400               0128               *--------------------------------------------------------------
4401               0129 6D20 0205  20         li    tmp1,io.op.write      ; io.op.write
4402                    6D22 0003
4403               0130 6D24 1006  14         jmp   _file.record.fop      ; Do file operation
4404               0131
4405               0132
4406               0133
4407               0134               file.record.seek:
4408               0135 6D26 1000  14         nop
4409               0136
4410               0137
4411               0138               file.image.load:
4412               0139 6D28 1000  14         nop
4413               0140
4414               0141
4415               0142               file.image.save:
4416               0143 6D2A 1000  14         nop
4417               0144
4418               0145
4419               0146               file.delete:
4420               0147 6D2C 1000  14         nop
4421               0148
4422               0149
4423               0150               file.rename:
4424               0151 6D2E 1000  14         nop
4425               0152
4426               0153
4427               0154               file.status:
4428               0155 6D30 1000  14         nop
4429               0156
4430               0157
4431               0158
4432               0159               ***************************************************************
4433               0160               * file.record.fop - File operation
4434               0161               ***************************************************************
4435               0162               * Called internally via JMP/B by file operations
4436               0163               *--------------------------------------------------------------
4437               0164               *  Input:
4438               0165               *  r0   = Address of PAB in VDP RAM
4439               0166               *  tmp1 = File operation opcode
4440               0167               *--------------------------------------------------------------
4441               0168               *  Register usage:
4442               0169               *  r0, r1, tmp0, tmp1, tmp2
4443               0170               *--------------------------------------------------------------
4444               0171               *  Remarks
4445               0172               *  Private, only to be called from inside fio_level2 module
4446               0173               *  via jump or branch instruction
4447               0174               ********|*****|*********************|**************************
4448               0175               _file.record.fop:
4449               0176 6D32 C04B  18         mov   r11,r1                ; Save return address
4450               0177 6D34 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
4451                    6D36 A428
4452               0178 6D38 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
4453               0179
4454               0180 6D3A 06A0  32         bl    @xvputb               ; Write file opcode to VDP
4455                    6D3C 22C6
4456               0181                                                   ; \ i  tmp0 = VDP target address
4457               0182                                                   ; / i  tmp1 = Byte to write
4458               0183
4459               0184 6D3E 0220  22         ai    r0,9                  ; Move to file descriptor length
4460                    6D40 0009
4461               0185 6D42 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
4462                    6D44 8356
4463               0186               *--------------------------------------------------------------
4464               0187               * Call DSRLINK for doing file operation
4465               0188               *--------------------------------------------------------------
4466               0189 6D46 0420  54         blwp  @dsrlnk               ; Call DSRLNK
4467                    6D48 2B7E
4468               0190 6D4A 0008             data  8                     ;
4469               0191               *--------------------------------------------------------------
4470               0192               * Return PAB details to caller
4471               0193               *--------------------------------------------------------------
4472               0194               _file.record.fop.pab:
4473               0195 6D4C 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
4474               0196                                                   ; Upon DSRLNK return status register EQ bit
4475               0197                                                   ; 1 = No file error
4476               0198                                                   ; 0 = File error occured
4477               0199               *--------------------------------------------------------------
4478               0200               * Get PAB byte 5 from VDP ram into tmp1 (character count)
4479               0201               *--------------------------------------------------------------
4480               0202 6D4E C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
4481                    6D50 A428
4482               0203 6D52 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
4483                    6D54 0005
4484               0204 6D56 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
4485                    6D58 22DE
4486               0205 6D5A C144  18         mov   tmp0,tmp1             ; Move to destination
4487               0206               *--------------------------------------------------------------
4488               0207               * Get PAB byte 1 from VDP ram into tmp0 (status)
4489               0208               *--------------------------------------------------------------
4490               0209 6D5C C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
4491               0210                                                   ; as returned by DSRLNK
4492               0211               *--------------------------------------------------------------
4493               0212               * Exit
4494               0213               *--------------------------------------------------------------
4495               0214               ; If an error occured during the IO operation, then the
4496               0215               ; equal bit in the saved status register (=tmp2) is set to 1.
4497               0216               ;
4498               0217               ; Upon return from this IO call you should basically test with:
4499               0218               ;       coc   @wbit2,tmp2           ; Equal bit set?
4500               0219               ;       jeq   my_file_io_handler    ; Yes, IO error occured
4501               0220               ;
4502               0221               ; Then look for further details in the copy of VDP PAB byte 1
4503               0222               ; in register tmp0, bits 13-15
4504               0223               ;
4505               0224               ;       srl   tmp0,8                ; Right align (only for DSR type >8
4506               0225               ;                                   ; calls, skip for type >A subprograms!)
4507               0226               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
4508               0227               ;       jeq   my_error_handler
4509               0228               *--------------------------------------------------------------
4510               0229               _file.record.fop.exit:
4511               0230 6D5E 0451  20         b     *r1                   ; Return to caller
4512               **** **** ****     > runlib.asm
4513               0222
4514               0223               *//////////////////////////////////////////////////////////////
4515               0224               *                            TIMERS
4516               0225               *//////////////////////////////////////////////////////////////
4517               0226
4518               0227                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
4519               **** **** ****     > timers_tmgr.asm
4520               0001               * FILE......: timers_tmgr.asm
4521               0002               * Purpose...: Timers / Thread scheduler
4522               0003
4523               0004               ***************************************************************
4524               0005               * TMGR - X - Start Timers/Thread scheduler
4525               0006               ***************************************************************
4526               0007               *  B @TMGR
4527               0008               *--------------------------------------------------------------
4528               0009               *  REMARKS
4529               0010               *  Timer/Thread scheduler. Normally called from MAIN.
4530               0011               *  This is basically the kernel keeping everything togehter.
4531               0012               *  Do not forget to set BTIHI to highest slot in use.
4532               0013               *
4533               0014               *  Register usage in TMGR8 - TMGR11
4534               0015               *  TMP0  = Pointer to timer table
4535               0016               *  R10LB = Use as slot counter
4536               0017               *  TMP2  = 2nd word of slot data
4537               0018               *  TMP3  = Address of routine to call
4538               0019               ********|*****|*********************|**************************
4539               0020 6D60 0300  24 tmgr    limi  0                     ; No interrupt processing
4540                    6D62 0000
4541               0021               *--------------------------------------------------------------
4542               0022               * Read VDP status register
4543               0023               *--------------------------------------------------------------
4544               0024 6D64 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
4545                    6D66 8802
4546               0025               *--------------------------------------------------------------
4547               0026               * Latch sprite collision flag
4548               0027               *--------------------------------------------------------------
4549               0028 6D68 2360  38         coc   @wbit2,r13            ; C flag on ?
4550                    6D6A 2026
4551               0029 6D6C 1602  14         jne   tmgr1a                ; No, so move on
4552               0030 6D6E E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
4553                    6D70 2012
4554               0031               *--------------------------------------------------------------
4555               0032               * Interrupt flag
4556               0033               *--------------------------------------------------------------
4557               0034 6D72 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
4558                    6D74 202A
4559               0035 6D76 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
4560               0036               *--------------------------------------------------------------
4561               0037               * Run speech player
4562               0038               *--------------------------------------------------------------
4563               0044               *--------------------------------------------------------------
4564               0045               * Run kernel thread
4565               0046               *--------------------------------------------------------------
4566               0047 6D78 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
4567                    6D7A 201A
4568               0048 6D7C 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
4569               0049 6D7E 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
4570                    6D80 2018
4571               0050 6D82 1602  14         jne   tmgr3                 ; No, skip to user hook
4572               0051 6D84 0460  28         b     @kthread              ; Run kernel thread
4573                    6D86 2D8A
4574               0052               *--------------------------------------------------------------
4575               0053               * Run user hook
4576               0054               *--------------------------------------------------------------
4577               0055 6D88 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
4578                    6D8A 201E
4579               0056 6D8C 13EB  14         jeq   tmgr1
4580               0057 6D8E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
4581                    6D90 201C
4582               0058 6D92 16E8  14         jne   tmgr1
4583               0059 6D94 C120  34         mov   @wtiusr,tmp0
4584                    6D96 832E
4585               0060 6D98 0454  20         b     *tmp0                 ; Run user hook
4586               0061               *--------------------------------------------------------------
4587               0062               * Do internal housekeeping
4588               0063               *--------------------------------------------------------------
4589               0064 6D9A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
4590                    6D9C 2D88
4591               0065 6D9E C10A  18         mov   r10,tmp0
4592               0066 6DA0 0244  22         andi  tmp0,>00ff            ; Clear HI byte
4593                    6DA2 00FF
4594               0067 6DA4 20A0  38         coc   @wbit2,config         ; PAL flag set ?
4595                    6DA6 2026
4596               0068 6DA8 1303  14         jeq   tmgr5
4597               0069 6DAA 0284  22         ci    tmp0,60               ; 1 second reached ?
4598                    6DAC 003C
4599               0070 6DAE 1002  14         jmp   tmgr6
4600               0071 6DB0 0284  22 tmgr5   ci    tmp0,50
4601                    6DB2 0032
4602               0072 6DB4 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
4603               0073 6DB6 1001  14         jmp   tmgr8
4604               0074 6DB8 058A  14 tmgr7   inc   r10                   ; Increase tick counter
4605               0075               *--------------------------------------------------------------
4606               0076               * Loop over slots
4607               0077               *--------------------------------------------------------------
4608               0078 6DBA C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
4609                    6DBC 832C
4610               0079 6DBE 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
4611                    6DC0 FF00
4612               0080 6DC2 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
4613               0081 6DC4 1316  14         jeq   tmgr11                ; Yes, get next slot
4614               0082               *--------------------------------------------------------------
4615               0083               *  Check if slot should be executed
4616               0084               *--------------------------------------------------------------
4617               0085 6DC6 05C4  14         inct  tmp0                  ; Second word of slot data
4618               0086 6DC8 0594  26         inc   *tmp0                 ; Update tick count in slot
4619               0087 6DCA C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
4620               0088 6DCC 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
4621                    6DCE 830C
4622                    6DD0 830D
4623               0089 6DD2 1608  14         jne   tmgr10                ; No, get next slot
4624               0090 6DD4 0246  22         andi  tmp2,>ff00            ; Clear internal counter
4625                    6DD6 FF00
4626               0091 6DD8 C506  30         mov   tmp2,*tmp0            ; Update timer table
4627               0092               *--------------------------------------------------------------
4628               0093               *  Run slot, we only need TMP0 to survive
4629               0094               *--------------------------------------------------------------
4630               0095 6DDA C804  38         mov   tmp0,@wtitmp          ; Save TMP0
4631                    6DDC 8330
4632               0096 6DDE 0697  24         bl    *tmp3                 ; Call routine in slot
4633               0097 6DE0 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
4634                    6DE2 8330
4635               0098               *--------------------------------------------------------------
4636               0099               *  Prepare for next slot
4637               0100               *--------------------------------------------------------------
4638               0101 6DE4 058A  14 tmgr10  inc   r10                   ; Next slot
4639               0102 6DE6 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
4640                    6DE8 8315
4641                    6DEA 8314
4642               0103 6DEC 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
4643               0104 6DEE 05C4  14         inct  tmp0                  ; Offset for next slot
4644               0105 6DF0 10E8  14         jmp   tmgr9                 ; Process next slot
4645               0106 6DF2 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
4646               0107 6DF4 10F7  14         jmp   tmgr10                ; Process next slot
4647               0108 6DF6 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
4648                    6DF8 FF00
4649               0109 6DFA 10B4  14         jmp   tmgr1
4650               0110 6DFC 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
4651               0111
4652               **** **** ****     > runlib.asm
4653               0228                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
4654               **** **** ****     > timers_kthread.asm
4655               0001               * FILE......: timers_kthread.asm
4656               0002               * Purpose...: Timers / The kernel thread
4657               0003
4658               0004
4659               0005               ***************************************************************
4660               0006               * KTHREAD - The kernel thread
4661               0007               *--------------------------------------------------------------
4662               0008               *  REMARKS
4663               0009               *  You should not call the kernel thread manually.
4664               0010               *  Instead control it via the CONFIG register.
4665               0011               *
4666               0012               *  The kernel thread is responsible for running the sound
4667               0013               *  player and doing keyboard scan.
4668               0014               ********|*****|*********************|**************************
4669               0015 6DFE E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
4670                    6E00 201A
4671               0016               *--------------------------------------------------------------
4672               0017               * Run sound player
4673               0018               *--------------------------------------------------------------
4674               0020               *       <<skipped>>
4675               0026               *--------------------------------------------------------------
4676               0027               * Scan virtual keyboard
4677               0028               *--------------------------------------------------------------
4678               0029               kthread_kb
4679               0031               *       <<skipped>>
4680               0035               *--------------------------------------------------------------
4681               0036               * Scan real keyboard
4682               0037               *--------------------------------------------------------------
4683               0041 6E02 06A0  32         bl    @realkb               ; Scan full keyboard
4684                    6E04 279C
4685               0043               *--------------------------------------------------------------
4686               0044               kthread_exit
4687               0045 6E06 0460  28         b     @tmgr3                ; Exit
4688                    6E08 2D14
4689               **** **** ****     > runlib.asm
4690               0229                       copy  "timers_hooks.asm"         ; Timers / User hooks
4691               **** **** ****     > timers_hooks.asm
4692               0001               * FILE......: timers_kthread.asm
4693               0002               * Purpose...: Timers / User hooks
4694               0003
4695               0004
4696               0005               ***************************************************************
4697               0006               * MKHOOK - Allocate user hook
4698               0007               ***************************************************************
4699               0008               *  BL    @MKHOOK
4700               0009               *  DATA  P0
4701               0010               *--------------------------------------------------------------
4702               0011               *  P0 = Address of user hook
4703               0012               *--------------------------------------------------------------
4704               0013               *  REMARKS
4705               0014               *  The user hook gets executed after the kernel thread.
4706               0015               *  The user hook must always exit with "B @HOOKOK"
4707               0016               ********|*****|*********************|**************************
4708               0017 6E0A C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
4709                    6E0C 832E
4710               0018 6E0E E0A0  34         soc   @wbit7,config         ; Enable user hook
4711                    6E10 201C
4712               0019 6E12 045B  20 mkhoo1  b     *r11                  ; Return
4713               0020      2CF0     hookok  equ   tmgr1                 ; Exit point for user hook
4714               0021
4715               0022
4716               0023               ***************************************************************
4717               0024               * CLHOOK - Clear user hook
4718               0025               ***************************************************************
4719               0026               *  BL    @CLHOOK
4720               0027               ********|*****|*********************|**************************
4721               0028 6E14 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
4722                    6E16 832E
4723               0029 6E18 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
4724                    6E1A FEFF
4725               0030 6E1C 045B  20         b     *r11                  ; Return
4726               **** **** ****     > runlib.asm
4727               0230
4728               0232                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
4729               **** **** ****     > timers_alloc.asm
4730               0001               * FILE......: timer_alloc.asm
4731               0002               * Purpose...: Timers / Timer allocation
4732               0003
4733               0004
4734               0005               ***************************************************************
4735               0006               * MKSLOT - Allocate timer slot(s)
4736               0007               ***************************************************************
4737               0008               *  BL    @MKSLOT
4738               0009               *  BYTE  P0HB,P0LB
4739               0010               *  DATA  P1
4740               0011               *  ....
4741               0012               *  DATA  EOL                        ; End-of-list
4742               0013               *--------------------------------------------------------------
4743               0014               *  P0 = Slot number, target count
4744               0015               *  P1 = Subroutine to call via BL @xxxx if slot is fired
4745               0016               ********|*****|*********************|**************************
4746               0017 6E1E C13B  30 mkslot  mov   *r11+,tmp0
4747               0018 6E20 C17B  30         mov   *r11+,tmp1
4748               0019               *--------------------------------------------------------------
4749               0020               *  Calculate address of slot
4750               0021               *--------------------------------------------------------------
4751               0022 6E22 C184  18         mov   tmp0,tmp2
4752               0023 6E24 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
4753               0024 6E26 A1A0  34         a     @wtitab,tmp2          ; Add table base
4754                    6E28 832C
4755               0025               *--------------------------------------------------------------
4756               0026               *  Add slot to table
4757               0027               *--------------------------------------------------------------
4758               0028 6E2A CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
4759               0029 6E2C 0A84  56         sla   tmp0,8                ; Get rid of slot number
4760               0030 6E2E C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
4761               0031               *--------------------------------------------------------------
4762               0032               *  Check for end of list
4763               0033               *--------------------------------------------------------------
4764               0034 6E30 881B  46         c     *r11,@w$ffff          ; End of list ?
4765                    6E32 202C
4766               0035 6E34 1301  14         jeq   mkslo1                ; Yes, exit
4767               0036 6E36 10F3  14         jmp   mkslot                ; Process next entry
4768               0037               *--------------------------------------------------------------
4769               0038               *  Exit
4770               0039               *--------------------------------------------------------------
4771               0040 6E38 05CB  14 mkslo1  inct  r11
4772               0041 6E3A 045B  20         b     *r11                  ; Exit
4773               0042
4774               0043
4775               0044               ***************************************************************
4776               0045               * CLSLOT - Clear single timer slot
4777               0046               ***************************************************************
4778               0047               *  BL    @CLSLOT
4779               0048               *  DATA  P0
4780               0049               *--------------------------------------------------------------
4781               0050               *  P0 = Slot number
4782               0051               ********|*****|*********************|**************************
4783               0052 6E3C C13B  30 clslot  mov   *r11+,tmp0
4784               0053 6E3E 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
4785               0054 6E40 A120  34         a     @wtitab,tmp0          ; Add table base
4786                    6E42 832C
4787               0055 6E44 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
4788               0056 6E46 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
4789               0057 6E48 045B  20         b     *r11                  ; Exit
4790               0058
4791               0059
4792               0060               ***************************************************************
4793               0061               * RSSLOT - Reset single timer slot loop counter
4794               0062               ***************************************************************
4795               0063               *  BL    @RSSLOT
4796               0064               *  DATA  P0
4797               0065               *--------------------------------------------------------------
4798               0066               *  P0 = Slot number
4799               0067               ********|*****|*********************|**************************
4800               0068 6E4A C13B  30 rsslot  mov   *r11+,tmp0
4801               0069 6E4C 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
4802               0070 6E4E A120  34         a     @wtitab,tmp0          ; Add table base
4803                    6E50 832C
4804               0071 6E52 05C4  14         inct  tmp0                  ; Skip 1st word of slot
4805               0072 6E54 C154  26         mov   *tmp0,tmp1
4806               0073 6E56 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
4807                    6E58 FF00
4808               0074 6E5A C505  30         mov   tmp1,*tmp0
4809               0075 6E5C 045B  20         b     *r11                  ; Exit
4810               **** **** ****     > runlib.asm
4811               0234
4812               0235
4813               0236
4814               0237               *//////////////////////////////////////////////////////////////
4815               0238               *                    RUNLIB INITIALISATION
4816               0239               *//////////////////////////////////////////////////////////////
4817               0240
4818               0241               ***************************************************************
4819               0242               *  RUNLIB - Runtime library initalisation
4820               0243               ***************************************************************
4821               0244               *  B  @RUNLIB
4822               0245               *--------------------------------------------------------------
4823               0246               *  REMARKS
4824               0247               *  if R0 in WS1 equals >4a4a we were called from the system
4825               0248               *  crash handler so we return there after initialisation.
4826               0249
4827               0250               *  If R1 in WS1 equals >FFFF we return to the TI title screen
4828               0251               *  after clearing scratchpad memory. This has higher priority
4829               0252               *  as crash handler flag R0.
4830               0253               ********|*****|*********************|**************************
4831               0255 6E5E 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
4832                    6E60 2ACC
4833               0256                                                   ; @cpu.scrpad.tgt (>00..>ff)
4834               0257
4835               0258 6E62 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
4836                    6E64 8302
4837               0262               *--------------------------------------------------------------
4838               0263               * Alternative entry point
4839               0264               *--------------------------------------------------------------
4840               0265 6E66 0300  24 runli1  limi  0                     ; Turn off interrupts
4841                    6E68 0000
4842               0266 6E6A 02E0  18         lwpi  ws1                   ; Activate workspace 1
4843                    6E6C 8300
4844               0267 6E6E C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
4845                    6E70 83C0
4846               0268               *--------------------------------------------------------------
4847               0269               * Clear scratch-pad memory from R4 upwards
4848               0270               *--------------------------------------------------------------
4849               0271 6E72 0202  20 runli2  li    r2,>8308
4850                    6E74 8308
4851               0272 6E76 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
4852               0273 6E78 0282  22         ci    r2,>8400
4853                    6E7A 8400
4854               0274 6E7C 16FC  14         jne   runli3
4855               0275               *--------------------------------------------------------------
4856               0276               * Exit to TI-99/4A title screen ?
4857               0277               *--------------------------------------------------------------
4858               0278 6E7E 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
4859                    6E80 FFFF
4860               0279 6E82 1602  14         jne   runli4                ; No, continue
4861               0280 6E84 0420  54         blwp  @0                    ; Yes, bye bye
4862                    6E86 0000
4863               0281               *--------------------------------------------------------------
4864               0282               * Determine if VDP is PAL or NTSC
4865               0283               *--------------------------------------------------------------
4866               0284 6E88 C803  38 runli4  mov   r3,@waux1             ; Store random seed
4867                    6E8A 833C
4868               0285 6E8C 04C1  14         clr   r1                    ; Reset counter
4869               0286 6E8E 0202  20         li    r2,10                 ; We test 10 times
4870                    6E90 000A
4871               0287 6E92 C0E0  34 runli5  mov   @vdps,r3
4872                    6E94 8802
4873               0288 6E96 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
4874                    6E98 202A
4875               0289 6E9A 1302  14         jeq   runli6
4876               0290 6E9C 0581  14         inc   r1                    ; Increase counter
4877               0291 6E9E 10F9  14         jmp   runli5
4878               0292 6EA0 0602  14 runli6  dec   r2                    ; Next test
4879               0293 6EA2 16F7  14         jne   runli5
4880               0294 6EA4 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
4881                    6EA6 1250
4882               0295 6EA8 1202  14         jle   runli7                ; No, so it must be NTSC
4883               0296 6EAA 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
4884                    6EAC 2026
4885               0297               *--------------------------------------------------------------
4886               0298               * Copy machine code to scratchpad (prepare tight loop)
4887               0299               *--------------------------------------------------------------
4888               0300 6EAE 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
4889                    6EB0 221A
4890               0301 6EB2 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
4891                    6EB4 8322
4892               0302 6EB6 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
4893               0303 6EB8 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
4894               0304 6EBA CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
4895               0305               *--------------------------------------------------------------
4896               0306               * Initialize registers, memory, ...
4897               0307               *--------------------------------------------------------------
4898               0308 6EBC 04C1  14 runli9  clr   r1
4899               0309 6EBE 04C2  14         clr   r2
4900               0310 6EC0 04C3  14         clr   r3
4901               0311 6EC2 0209  20         li    stack,>8400           ; Set stack
4902                    6EC4 8400
4903               0312 6EC6 020F  20         li    r15,vdpw              ; Set VDP write address
4904                    6EC8 8C00
4905               0316               *--------------------------------------------------------------
4906               0317               * Setup video memory
4907               0318               *--------------------------------------------------------------
4908               0320 6ECA 0280  22         ci    r0,>4a4a              ; Crash flag set?
4909                    6ECC 4A4A
4910               0321 6ECE 1605  14         jne   runlia
4911               0322 6ED0 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
4912                    6ED2 2288
4913               0323 6ED4 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
4914                    6ED6 0000
4915                    6ED8 3FFF
4916               0328 6EDA 06A0  32 runlia  bl    @filv
4917                    6EDC 2288
4918               0329 6EDE 0FC0             data  pctadr,spfclr,16      ; Load color table
4919                    6EE0 00F4
4920                    6EE2 0010
4921               0330               *--------------------------------------------------------------
4922               0331               * Check if there is a F18A present
4923               0332               *--------------------------------------------------------------
4924               0336 6EE4 06A0  32         bl    @f18unl               ; Unlock the F18A
4925                    6EE6 26E4
4926               0337 6EE8 06A0  32         bl    @f18chk               ; Check if F18A is there
4927                    6EEA 26FE
4928               0338 6EEC 06A0  32         bl    @f18lck               ; Lock the F18A again
4929                    6EEE 26F4
4930               0339
4931               0340 6EF0 06A0  32         bl    @putvr                ; Reset all F18a extended registers
4932                    6EF2 232C
4933               0341 6EF4 3201                   data >3201            ; F18a VR50 (>32), bit 1
4934               0343               *--------------------------------------------------------------
4935               0344               * Check if there is a speech synthesizer attached
4936               0345               *--------------------------------------------------------------
4937               0347               *       <<skipped>>
4938               0351               *--------------------------------------------------------------
4939               0352               * Load video mode table & font
4940               0353               *--------------------------------------------------------------
4941               0354 6EF6 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
4942                    6EF8 22F2
4943               0355 6EFA 3008             data  spvmod                ; Equate selected video mode table
4944               0356 6EFC 0204  20         li    tmp0,spfont           ; Get font option
4945                    6EFE 000C
4946               0357 6F00 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
4947               0358 6F02 1304  14         jeq   runlid                ; Yes, skip it
4948               0359 6F04 06A0  32         bl    @ldfnt
4949                    6F06 235A
4950               0360 6F08 1100             data  fntadr,spfont         ; Load specified font
4951                    6F0A 000C
4952               0361               *--------------------------------------------------------------
4953               0362               * Did a system crash occur before runlib was called?
4954               0363               *--------------------------------------------------------------
4955               0364 6F0C 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
4956                    6F0E 4A4A
4957               0365 6F10 1602  14         jne   runlie                ; No, continue
4958               0366 6F12 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
4959                    6F14 2090
4960               0367               *--------------------------------------------------------------
4961               0368               * Branch to main program
4962               0369               *--------------------------------------------------------------
4963               0370 6F16 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
4964                    6F18 0040
4965               0371 6F1A 0460  28         b     @main                 ; Give control to main program
4966                    6F1C 3000
4967               **** **** ****     > stevie_b0.asm.22608
4968               0100                                                   ; Spectra 2
4969               0101                       ;------------------------------------------------------
4970               0102                       ; End of File marker
4971               0103                       ;------------------------------------------------------
4972               0104 6F1E DEAD             data  >dead,>beef,>dead,>beef
4973                    6F20 BEEF
4974                    6F22 DEAD
4975                    6F24 BEEF
4976               0106 6F26 ....             bss  300                    ; Fill remaining space with >00
4977               0107
4978               0108
4979               0109
4980               0110
4981               0111               ***************************************************************
4982               0112               * Code data: Relocated Stevie modules >3000 - >3fff (4K maximum)
4983               0113               ********|*****|*********************|**************************
4984               0114               reloc.stevie:
4985               0115                       xorg  >3000                 ; Relocate Stevie modules to >3000

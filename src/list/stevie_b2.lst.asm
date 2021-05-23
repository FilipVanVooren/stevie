XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b2.asm.3164438
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b2.asm               ; Version 210523-3164438
0010               *
0011               * Bank 2 "Jacky"
0012               *
0013               ***************************************************************
0014                       copy  "rom.build.asm"       ; Cartridge build options
**** **** ****     > rom.build.asm
0001               * FILE......: rom.build.asm
0002               * Purpose...: Equates with cartridge build options
0003               
0004               *--------------------------------------------------------------
0005               * Skip unused spectra2 code modules for reduced code size
0006               *--------------------------------------------------------------
0007      0001     skip_rom_bankswitch       equ  1       ; Skip support for ROM bankswitching
0008      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0009      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0010      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0011      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0012      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0013      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0014      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0015      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0016      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0017      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0018      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0019      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0020      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0021      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0022      0001     skip_random_generator     equ  1       ; Skip random functions
0023      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0024      0001     skip_mem_paging           equ  1       ; Skip support for memory paging
0025               *--------------------------------------------------------------
0026               * Assembly (compile) options for Stevie
0027               *--------------------------------------------------------------
0028      0000     device.f18a.mode.30x80    equ  0       ; F18a 30 rows mode on
0029      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode on
**** **** ****     > stevie_b2.asm.3164438
0015                       copy  "rom.order.asm"       ; ROM bank order "non-inverted"
**** **** ****     > rom.order.asm
0001               * FILE......: rom.order.asm
0002               * Purpose...: Equates with CPU write addresses for switching banks
0003               
0004               *--------------------------------------------------------------
0005               * ROM 8K/4K banks. Bank order (non-inverted)
0006               *--------------------------------------------------------------
0007      6000     bank0.rom                 equ  >6000   ; Jill
0008      6002     bank1.rom                 equ  >6002   ; James
0009      6004     bank2.rom                 equ  >6004   ; Jacky
0010      6006     bank3.rom                 equ  >6006   ; John
0011      6008     bank4.rom                 equ  >6008   ; Janine
0012               *--------------------------------------------------------------
0013               * RAM 4K banks (Only valid in advance mode FG99)
0014               *--------------------------------------------------------------
0015      6800     bank0.ram                 equ  >6800   ; Jill
0016      6802     bank1.ram                 equ  >6802   ; James
0017      6804     bank2.ram                 equ  >6804   ; Jacky
0018      6806     bank3.ram                 equ  >6806   ; John
0019      6808     bank4.ram                 equ  >6808   ; Janine
**** **** ****     > stevie_b2.asm.3164438
0016                       copy  "equates.asm"         ; Equates Stevie configuration
**** **** ****     > equates.asm
0001               * FILE......: equates.asm
0002               * Purpose...: The main equates file for Stevie editor
0003               
0004               
0005               *===============================================================================
0006               * Memory map
0007               * ==========
0008               *
0009               * LOW MEMORY EXPANSION (2000-2fff)
0010               *
0011               *     Mem range   Bytes    SAMS   Purpose
0012               *     =========   =====    ====   ==================================
0013               *     2000-2f1f    3872           SP2 library
0014               *     2f20-2f3f      32           Function input/output parameters
0015               *     2f40-2f43       4           Keyboard
0016               *     2f4a-2f59      16           Timer tasks table
0017               *     2f5a-2f69      16           Sprite attribute table in RAM
0018               *     2f6a-2f9f      54           RAM buffer
0019               *     2fa0-2fff      96           Value/Return stack (grows downwards from 2fff)
0020               *
0021               *
0022               * LOW MEMORY EXPANSION (3000-3fff)
0023               *
0024               *     Mem range   Bytes    SAMS   Purpose
0025               *     =========   =====    ====   ==================================
0026               *     3000-3fff    4096           Resident Stevie Modules
0027               *
0028               *
0029               * HIGH MEMORY EXPANSION (a000-ffff)
0030               *
0031               *     Mem range   Bytes    SAMS   Purpose
0032               *     =========   =====    ====   ==================================
0033               *     a000-a0ff     256           Stevie Editor shared structure
0034               *     a100-a1ff     256           Framebuffer structure
0035               *     a200-a2ff     256           Editor buffer structure
0036               *     a300-a3ff     256           Command buffer structure
0037               *     a400-a4ff     256           File handle structure
0038               *     a500-a5ff     256           Index structure
0039               *     a600-af5f    2400           Frame buffer
0040               *     af60-afff     ???           *FREE*
0041               *
0042               *     b000-bfff    4096           Index buffer page
0043               *     c000-cfff    4096           Editor buffer page
0044               *     d000-dfff    4096           CMDB history / Editor buffer page (temporary)
0045               *     e000-ebff    3072           Heap
0046               *     ec00-efff    1024           Farjump return stack (trampolines)
0047               *     f000-ffff    4096           *FREE*
0048               *
0049               *
0050               * CARTRIDGE SPACE (6000-7fff)
0051               *
0052               *     Mem range   Bytes    BANK   Purpose
0053               *     =========   =====    ====   ==================================
0054               *     6000-7f9b    8128       0   SP2 library, code to RAM, resident modules
0055               *     7f9c-7fff      64       0   Vector table (32 vectors)
0056               *     ..............................................................
0057               *     6000-7f9b    8128       1   Stevie program code
0058               *     7f9c-7fff      64       1   Vector table (32 vectors)
0059               *     ..............................................................
0060               *     6000-7f9b    8128       2   Stevie program code
0061               *     7f9c-7fff      64       2   Vector table (32 vectors)
0062               *     ..............................................................
0063               *     6000-7f9b    8128       3   Stevie program code
0064               *     7f9c-7fff      64       3   Vector table (32 vectors)
0065               *
0066               *
0067               * VDP RAM F18a (0000-47ff)
0068               *
0069               *     Mem range   Bytes    Hex    Purpose
0070               *     =========   =====   =====   =================================
0071               *     0000-095f    2400   >0960   PNT: Pattern Name Table
0072               *     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
0073               *     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
0074               *     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
0075               *     1800-215f    2400   >0960   TAT: Tile Attribute Table
0076               *                                      (Position based colors F18a, 80 colums)
0077               *     2180                        SAT: Sprite Attribute Table
0078               *                                      (Cursor in F18a, 80 cols mode)
0079               *     2800                        SPT: Sprite Pattern Table
0080               *                                      (Cursor in F18a, 80 columns, 2K boundary)
0081               *===============================================================================
0082               
0083               *--------------------------------------------------------------
0084               * Graphics mode selection
0085               *--------------------------------------------------------------
0091               
0092      0017     pane.botrow               equ  23      ; Bottom row on screen
0093               
0095               *--------------------------------------------------------------
0096               * Stevie Dialog / Pane specific equates
0097               *--------------------------------------------------------------
0098      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0099      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0100               *--------------------------------------------------------------
0101               * Stevie specific equates
0102               *--------------------------------------------------------------
0103      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0104      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0105      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0106      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0107      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0108      1DF0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0109                                                      ; VDP TAT address of 1st CMDB row
0110      0780     vdp.sit.size              equ  (pane.botrow + 1) * 80
0111                                                      ; VDP SIT size 80 columns, 24/30 rows
0112      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0113      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0114               ;-----------------------------------------------------------------
0115               ;   Dialog ID's >= 100 indicate that command prompt should be
0116               ;   hidden and no characters added to CMDB keyboard buffer
0117               ;-----------------------------------------------------------------
0118      000A     id.dialog.load            equ  10      ; ID dialog "Load DV80 file"
0119      000B     id.dialog.save            equ  11      ; ID dialog "Save DV80 file"
0120      000C     id.dialog.saveblock       equ  12      ; ID dialog "Save codeblock to DV80 file"
0121      0065     id.dialog.unsaved         equ  101     ; ID dialog "Unsaved changes"
0122      0066     id.dialog.block           equ  102     ; ID dialog "Block move/copy/delete"
0123      0067     id.dialog.about           equ  103     ; ID dialog "About"
0124               *--------------------------------------------------------------
0125               * SPECTRA2 / Stevie startup options
0126               *--------------------------------------------------------------
0127      0001     debug                     equ  1       ; Turn on spectra2 debugging
0128      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0129      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0130      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0131               *--------------------------------------------------------------
0132               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0133               *--------------------------------------------------------------
0134      2F20     parm1             equ  >2f20           ; Function parameter 1
0135      2F22     parm2             equ  >2f22           ; Function parameter 2
0136      2F24     parm3             equ  >2f24           ; Function parameter 3
0137      2F26     parm4             equ  >2f26           ; Function parameter 4
0138      2F28     parm5             equ  >2f28           ; Function parameter 5
0139      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0140      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0141      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0142      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0143      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0144      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0145      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0146      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0147      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0148      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0149      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0150      2F40     keycode1          equ  >2f40           ; Current key scanned
0151      2F42     keycode2          equ  >2f42           ; Previous key scanned
0152      2F44     unpacked.string   equ  >2f44           ; 6 char string with unpacked uin16
0153      2F4A     timers            equ  >2f4a           ; Timer table
0154      2F5A     ramsat            equ  >2f5a           ; Sprite Attribute Table in RAM
0155      2F6A     rambuf            equ  >2f6a           ; RAM workbuffer 1
0156               *--------------------------------------------------------------
0157               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0158               *--------------------------------------------------------------
0159      A000     tv.top            equ  >a000           ; Structure begin
0160      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0161      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0162      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0163      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0164      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0165      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0166      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0167      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0168      A010     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0169      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0170      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0171      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0172      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0173      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0174      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0175      A01E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0176      A020     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0177      A022     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0178      A024     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0179      A026     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0180      A028     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0181      A02A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0182      A0CA     tv.free           equ  tv.top + 202    ; End of structure
0183               *--------------------------------------------------------------
0184               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0185               *--------------------------------------------------------------
0186      A100     fb.struct         equ  >a100           ; Structure begin
0187      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0188      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0189      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0190                                                      ; line X in editor buffer).
0191      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0192                                                      ; (offset 0 .. @fb.scrrows)
0193      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0194      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0195      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0196      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0197      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0198      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0199      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0200      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0201      A118     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0202      A11A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0203      A11C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0204      A11E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0205      A16E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0206      A1BE     fb.free           equ  fb.struct + 190 ; End of structure
0207               *--------------------------------------------------------------
0208               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0209               *--------------------------------------------------------------
0210      A200     edb.struct        equ  >a200           ; Begin structure
0211      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0212      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0213      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0214      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0215      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0216      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0217      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0218      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0219      A210     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0220      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0221                                                      ; with current filename.
0222      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0223                                                      ; with current file type.
0224      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0225      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0226      A21A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0227                                                      ; for filename, but not always used.
0228      A269     edb.free          equ  edb.struct + 105; End of structure
0229               *--------------------------------------------------------------
0230               * Command buffer structure            @>a300-a3ff   (256 bytes)
0231               *--------------------------------------------------------------
0232      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0233      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0234      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0235      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0236      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0237      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0238      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0239      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0240      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0241      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0242      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0243      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0244      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0245      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0246      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0247      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0248      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0249      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0250      A322     cmdb.pankeys      equ  cmdb.struct + 34; Pointer to string pane keys (stat line)
0251      A324     cmdb.action.ptr   equ  cmdb.struct + 36; Pointer to function to execute
0252      A326     cmdb.cmdlen       equ  cmdb.struct + 38; Length of current command (MSB byte!)
0253      A327     cmdb.cmd          equ  cmdb.struct + 39; Current command (80 bytes max.)
0254      A378     cmdb.free         equ  cmdb.struct +120; End of structure
0255               *--------------------------------------------------------------
0256               * File handle structure               @>a400-a4ff   (256 bytes)
0257               *--------------------------------------------------------------
0258      A400     fh.struct         equ  >a400           ; stevie file handling structures
0259               ;***********************************************************************
0260               ; ATTENTION
0261               ; The dsrlnk variables must form a continuous memory block and keep
0262               ; their order!
0263               ;***********************************************************************
0264      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0265      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0266      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0267      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0268      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0269      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0270      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0271      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0272      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0273      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0274      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0275      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0276      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0277      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0278      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0279      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0280      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0281      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0282      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0283      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0284      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0285      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0286      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0287      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0288      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0289      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0290      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0291      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0292      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0293      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0294      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0295      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0296               *--------------------------------------------------------------
0297               * Index structure                     @>a500-a5ff   (256 bytes)
0298               *--------------------------------------------------------------
0299      A500     idx.struct        equ  >a500           ; stevie index structure
0300      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0301      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0302      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0303               *--------------------------------------------------------------
0304               * Frame buffer                        @>a600-afff  (2560 bytes)
0305               *--------------------------------------------------------------
0306      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0307      0960     fb.size           equ  80*30           ; Frame buffer size
0308               *--------------------------------------------------------------
0309               * Index                               @>b000-bfff  (4096 bytes)
0310               *--------------------------------------------------------------
0311      B000     idx.top           equ  >b000           ; Top of index
0312      1000     idx.size          equ  4096            ; Index size
0313               *--------------------------------------------------------------
0314               * Editor buffer                       @>c000-cfff  (4096 bytes)
0315               *--------------------------------------------------------------
0316      C000     edb.top           equ  >c000           ; Editor buffer high memory
0317      1000     edb.size          equ  4096            ; Editor buffer size
0318               *--------------------------------------------------------------
0319               * Command history buffer              @>d000-dfff  (4096 bytes)
0320               *--------------------------------------------------------------
0321      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0322      1000     cmdb.size         equ  4096            ; Command buffer size
0323               *--------------------------------------------------------------
0324               * Heap                                @>e000-ebff  (3072 bytes)
0325               *--------------------------------------------------------------
0326      E000     heap.top          equ  >e000           ; Top of heap
0327               *--------------------------------------------------------------
0328               * Farjump return stack                @>ec00-efff  (1024 bytes)
0329               *--------------------------------------------------------------
0330      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b2.asm.3164438
0017               
0018               ***************************************************************
0019               * Spectra2 core configuration
0020               ********|*****|*********************|**************************
0021      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0022                                                   ; grows downwards to >2000
0023               ***************************************************************
0024               * BANK 2
0025               ********|*****|*********************|**************************
0026      6004     bankid  equ   bank2.rom             ; Set bank identifier to current bank
0027                       aorg  >6000
0028                       save  >6000,>7fff           ; Save bank
0029                       copy  "rom.header.asm"      ; Include cartridge header
**** **** ****     > rom.header.asm
0001               * FILE......: rom.header.asm
0002               * Purpose...: Cartridge header
0003               
0004               *--------------------------------------------------------------
0005               * Cartridge header
0006               ********|*****|*********************|**************************
0007 6000 AA01             byte  >aa                   ; 0  Standard header                   >6000
0008                       byte  >01                   ; 1  Version number
0009 6002 0100             byte  >01                   ; 2  Number of programs (optional)     >6002
0010                       byte  0                     ; 3  Reserved ('R' = adv. mode FG99)
0011               
0012 6004 0000             data  >0000                 ; 4  \ Pointer to power-up list        >6004
0013                                                   ; 5  /
0014               
0015 6006 600C             data  rom.program1          ; 6  \ Pointer to program list         >6006
0016                                                   ; 7  /
0017               
0018 6008 0000             data  >0000                 ; 8  \ Pointer to DSR list             >6008
0019                                                   ; 9  /
0020               
0021 600A 0000             data  >0000                 ; 10 \ Pointer to subprogram list      >600a
0022                                                   ; 11 /
0023               
0024                       ;-----------------------------------------------------------------------
0025                       ; Program list entry
0026                       ;-----------------------------------------------------------------------
0027               rom.program1:
0028 600C 0000             data  >0000                 ; 12 \ Next program list entry         >600c
0029                                                   ; 13 / (no more items following)
0030               
0031 600E 6030             data  kickstart.code1       ; 14 \ Program address                 >600e
0032                                                   ; 15 /
0033               
0051               
0059               
0060 6010 1353             byte  19
0061 6011 ....             text  'STEVIE 1.1H (24X80)'
0062                       even
0063               
0065               
**** **** ****     > stevie_b2.asm.3164438
0030               
0031               ***************************************************************
0032               * Step 1: Switch to bank 0 (uniform code accross all banks)
0033               ********|*****|*********************|**************************
0034                       aorg  kickstart.code1       ; >6030
0035 6030 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6032 6000 
0036               ***************************************************************
0037               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0038               ********|*****|*********************|**************************
0039                       aorg  >2000
0040                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0012 2000 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 2002 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 2004 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 2006 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 2008 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 200A 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 200C 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 200E 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 2010 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 2012 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 2014 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 2016 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 2018 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 201A 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 201C 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 201E 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 2020 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 2022 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 2024 D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      2000     hb$00   equ   w$0000                ; >0000
0035      2012     hb$01   equ   w$0100                ; >0100
0036      2014     hb$02   equ   w$0200                ; >0200
0037      2016     hb$04   equ   w$0400                ; >0400
0038      2018     hb$08   equ   w$0800                ; >0800
0039      201A     hb$10   equ   w$1000                ; >1000
0040      201C     hb$20   equ   w$2000                ; >2000
0041      201E     hb$40   equ   w$4000                ; >4000
0042      2020     hb$80   equ   w$8000                ; >8000
0043      2024     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      2000     lb$00   equ   w$0000                ; >0000
0048      2002     lb$01   equ   w$0001                ; >0001
0049      2004     lb$02   equ   w$0002                ; >0002
0050      2006     lb$04   equ   w$0004                ; >0004
0051      2008     lb$08   equ   w$0008                ; >0008
0052      200A     lb$10   equ   w$0010                ; >0010
0053      200C     lb$20   equ   w$0020                ; >0020
0054      200E     lb$40   equ   w$0040                ; >0040
0055      2010     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      2002     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      2004     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      2006     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      2008     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      200A     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      200C     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      200E     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      2010     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      2012     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      2014     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      2016     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      2018     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      201A     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      201C     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      201E     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      2020     wbit0   equ   w$8000                ; >8000 1000000000000000
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
0027      201C     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      2012     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      200E     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      200A     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
0038 2026 022B  22         ai    r11,-4                ; Remove opcode offset
     2028 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 202A C800  38         mov   r0,@>ffe0
     202C FFE0 
0043 202E C801  38         mov   r1,@>ffe2
     2030 FFE2 
0044 2032 C802  38         mov   r2,@>ffe4
     2034 FFE4 
0045 2036 C803  38         mov   r3,@>ffe6
     2038 FFE6 
0046 203A C804  38         mov   r4,@>ffe8
     203C FFE8 
0047 203E C805  38         mov   r5,@>ffea
     2040 FFEA 
0048 2042 C806  38         mov   r6,@>ffec
     2044 FFEC 
0049 2046 C807  38         mov   r7,@>ffee
     2048 FFEE 
0050 204A C808  38         mov   r8,@>fff0
     204C FFF0 
0051 204E C809  38         mov   r9,@>fff2
     2050 FFF2 
0052 2052 C80A  38         mov   r10,@>fff4
     2054 FFF4 
0053 2056 C80B  38         mov   r11,@>fff6
     2058 FFF6 
0054 205A C80C  38         mov   r12,@>fff8
     205C FFF8 
0055 205E C80D  38         mov   r13,@>fffa
     2060 FFFA 
0056 2062 C80E  38         mov   r14,@>fffc
     2064 FFFC 
0057 2066 C80F  38         mov   r15,@>ffff
     2068 FFFF 
0058 206A 02A0  12         stwp  r0
0059 206C C800  38         mov   r0,@>ffdc
     206E FFDC 
0060 2070 02C0  12         stst  r0
0061 2072 C800  38         mov   r0,@>ffde
     2074 FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 2076 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2078 8300 
0067 207A 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     207C 8302 
0068 207E 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     2080 4A4A 
0069 2082 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     2084 2E4C 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 22FC 
0078 208A 21EC                   data graph1           ; Equate selected video mode table
0079               
0080 208C 06A0  32         bl    @ldfnt
     208E 2364 
0081 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C 
0082               
0083 2094 06A0  32         bl    @filv
     2096 2292 
0084 2098 0380                   data >0380,>f0,32*24  ; Load color table
     209A 00F0 
     209C 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 209E 06A0  32         bl    @putat                ; Show crash message
     20A0 2446 
0089 20A2 0000                   data >0000,cpu.crash.msg.crashed
     20A4 2178 
0090               
0091 20A6 06A0  32         bl    @puthex               ; Put hex value on screen
     20A8 29D0 
0092 20AA 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20AC FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20AE 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20B0 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20B2 06A0  32         bl    @putat                ; Show caller message
     20B4 2446 
0101 20B6 0100                   data >0100,cpu.crash.msg.caller
     20B8 218E 
0102               
0103 20BA 06A0  32         bl    @puthex               ; Put hex value on screen
     20BC 29D0 
0104 20BE 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20C0 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20C2 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20C4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20C6 06A0  32         bl    @putat
     20C8 2446 
0113 20CA 0300                   byte 3,0
0114 20CC 21AA                   data cpu.crash.msg.wp
0115 20CE 06A0  32         bl    @putat
     20D0 2446 
0116 20D2 0400                   byte 4,0
0117 20D4 21B0                   data cpu.crash.msg.st
0118 20D6 06A0  32         bl    @putat
     20D8 2446 
0119 20DA 1600                   byte 22,0
0120 20DC 21B6                   data cpu.crash.msg.source
0121 20DE 06A0  32         bl    @putat
     20E0 2446 
0122 20E2 1700                   byte 23,0
0123 20E4 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20E6 06A0  32         bl    @at                   ; Put cursor at YX
     20E8 26D2 
0128 20EA 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 20EC 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20EE FFDC 
0132 20F0 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 20F2 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 20F4 0649  14         dect  stack
0138 20F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 20F8 0649  14         dect  stack
0140 20FA C645  30         mov   tmp1,*stack           ; Push tmp1
0141 20FC 0649  14         dect  stack
0142 20FE C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 2100 C046  18         mov   tmp2,r1               ; Save register number
0148 2102 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     2104 0001 
0149 2106 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 2108 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 210A 06A0  32         bl    @mknum
     210C 29DA 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2112 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2114 06A0  32         bl    @setx                 ; Set cursor X position
     2116 26E8 
0160 2118 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 211A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     211C 2422 
0164 211E 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 2120 06A0  32         bl    @setx                 ; Set cursor X position
     2122 26E8 
0168 2124 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 2126 0281  22         ci    r1,10
     2128 000A 
0172 212A 1102  14         jlt   !
0173 212C 0620  34         dec   @wyx                  ; x=x-1
     212E 832A 
0174               
0175 2130 06A0  32 !       bl    @putstr
     2132 2422 
0176 2134 21A4                   data cpu.crash.msg.r
0177               
0178 2136 06A0  32         bl    @mknum
     2138 29DA 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 294C 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2148 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 214A 06A0  32         bl    @setx                 ; Set cursor X position
     214C 26E8 
0194 214E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 2150 06A0  32         bl    @putstr               ; Put '  >'
     2152 2422 
0198 2154 21A6                   data cpu.crash.msg.marker
0199               
0200 2156 06A0  32         bl    @setx                 ; Set cursor X position
     2158 26E8 
0201 215A 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 215C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     215E 2422 
0205 2160 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 2162 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 2164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2168 06A0  32         bl    @down                 ; y=y+1
     216A 26D8 
0213               
0214 216C 0586  14         inc   tmp2
0215 216E 0286  22         ci    tmp2,17
     2170 0011 
0216 2172 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2174 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2176 2D4A 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 2178 1553             byte  21
0225 2179 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 218E 1543             byte  21
0230 218F ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 21A4 0152             byte  1
0235 21A5 ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 21A6 0320             byte  3
0240 21A7 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 21AA 042A             byte  4
0245 21AB ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 21B0 042A             byte  4
0250 21B1 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 21B6 1B53             byte  27
0255 21B7 ....             text  'Source    stevie_b2.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21D2 1842             byte  24
0260 21D3 ....             text  'Build-ID  210523-3164438'
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
0007 21EC 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21EE 000E 
     21F0 0106 
     21F2 0204 
     21F4 0020 
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
0032 21F6 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21F8 000E 
     21FA 0106 
     21FC 00F4 
     21FE 0028 
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
0058 2200 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2202 003F 
     2204 0240 
     2206 03F4 
     2208 0050 
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
0084 220A 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220C 003F 
     220E 0240 
     2210 03F4 
     2212 0050 
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
0013 2214 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2216 16FD             data  >16fd                 ; |         jne   mcloop
0015 2218 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 221A D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 221C 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 221E 0201  20         li    r1,mccode             ; Machinecode to patch
     2220 2214 
0037 2222 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2224 8322 
0038 2226 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2228 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 222A CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 222C 045B  20         b     *r11                  ; Return to caller
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
0056 222E C0F9  30 popr3   mov   *stack+,r3
0057 2230 C0B9  30 popr2   mov   *stack+,r2
0058 2232 C079  30 popr1   mov   *stack+,r1
0059 2234 C039  30 popr0   mov   *stack+,r0
0060 2236 C2F9  30 poprt   mov   *stack+,r11
0061 2238 045B  20         b     *r11
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
0085 223A C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 223C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 223E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 2240 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 2242 1604  14         jne   filchk                ; No, continue checking
0093               
0094 2244 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2246 FFCE 
0095 2248 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     224A 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 224C D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     224E 830B 
     2250 830A 
0100               
0101 2252 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2254 0001 
0102 2256 1602  14         jne   filchk2
0103 2258 DD05  32         movb  tmp1,*tmp0+
0104 225A 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 225C 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     225E 0002 
0109 2260 1603  14         jne   filchk3
0110 2262 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 2264 DD05  32         movb  tmp1,*tmp0+
0112 2266 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2268 C1C4  18 filchk3 mov   tmp0,tmp3
0117 226A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     226C 0001 
0118 226E 1305  14         jeq   fil16b
0119 2270 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 2272 0606  14         dec   tmp2
0121 2274 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2276 0002 
0122 2278 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 227A C1C6  18 fil16b  mov   tmp2,tmp3
0127 227C 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     227E 0001 
0128 2280 1301  14         jeq   dofill
0129 2282 0606  14         dec   tmp2                  ; Make TMP2 even
0130 2284 CD05  34 dofill  mov   tmp1,*tmp0+
0131 2286 0646  14         dect  tmp2
0132 2288 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 228A C1C7  18         mov   tmp3,tmp3
0137 228C 1301  14         jeq   fil.exit
0138 228E DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 2290 045B  20         b     *r11
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
0159 2292 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 2294 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 2296 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 2298 0264  22 xfilv   ori   tmp0,>4000
     229A 4000 
0166 229C 06C4  14         swpb  tmp0
0167 229E D804  38         movb  tmp0,@vdpa
     22A0 8C02 
0168 22A2 06C4  14         swpb  tmp0
0169 22A4 D804  38         movb  tmp0,@vdpa
     22A6 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22A8 020F  20         li    r15,vdpw              ; Set VDP write address
     22AA 8C00 
0174 22AC 06C5  14         swpb  tmp1
0175 22AE C820  54         mov   @filzz,@mcloop        ; Setup move command
     22B0 22B8 
     22B2 8320 
0176 22B4 0460  28         b     @mcloop               ; Write data to VDP
     22B6 8320 
0177               *--------------------------------------------------------------
0181 22B8 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22BA 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22BC 4000 
0202 22BE 06C4  14 vdra    swpb  tmp0
0203 22C0 D804  38         movb  tmp0,@vdpa
     22C2 8C02 
0204 22C4 06C4  14         swpb  tmp0
0205 22C6 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22C8 8C02 
0206 22CA 045B  20         b     *r11                  ; Exit
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
0217 22CC C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22CE C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22D0 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22D2 4000 
0223 22D4 06C4  14         swpb  tmp0                  ; \
0224 22D6 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22D8 8C02 
0225 22DA 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22DC D804  38         movb  tmp0,@vdpa            ; /
     22DE 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22E0 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22E2 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22E4 045B  20         b     *r11                  ; Exit
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
0251 22E6 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22E8 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22EA D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22EC 8C02 
0257 22EE 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22F0 D804  38         movb  tmp0,@vdpa            ; /
     22F2 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22F4 D120  34         movb  @vdpr,tmp0            ; Read byte
     22F6 8800 
0263 22F8 0984  56         srl   tmp0,8                ; Right align
0264 22FA 045B  20         b     *r11                  ; Exit
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
0283 22FC C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 22FE C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 2300 C144  18         mov   tmp0,tmp1
0289 2302 05C5  14         inct  tmp1
0290 2304 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2306 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2308 FF00 
0292 230A 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 230C C805  38         mov   tmp1,@wbase           ; Store calculated base
     230E 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 2310 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2312 8000 
0298 2314 0206  20         li    tmp2,8
     2316 0008 
0299 2318 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     231A 830B 
0300 231C 06C5  14         swpb  tmp1
0301 231E D805  38         movb  tmp1,@vdpa
     2320 8C02 
0302 2322 06C5  14         swpb  tmp1
0303 2324 D805  38         movb  tmp1,@vdpa
     2326 8C02 
0304 2328 0225  22         ai    tmp1,>0100
     232A 0100 
0305 232C 0606  14         dec   tmp2
0306 232E 16F4  14         jne   vidta1                ; Next register
0307 2330 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2332 833A 
0308 2334 045B  20         b     *r11
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
0325 2336 C13B  30 putvr   mov   *r11+,tmp0
0326 2338 0264  22 putvrx  ori   tmp0,>8000
     233A 8000 
0327 233C 06C4  14         swpb  tmp0
0328 233E D804  38         movb  tmp0,@vdpa
     2340 8C02 
0329 2342 06C4  14         swpb  tmp0
0330 2344 D804  38         movb  tmp0,@vdpa
     2346 8C02 
0331 2348 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 234A C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 234C C10E  18         mov   r14,tmp0
0341 234E 0984  56         srl   tmp0,8
0342 2350 06A0  32         bl    @putvrx               ; Write VR#0
     2352 2338 
0343 2354 0204  20         li    tmp0,>0100
     2356 0100 
0344 2358 D820  54         movb  @r14lb,@tmp0lb
     235A 831D 
     235C 8309 
0345 235E 06A0  32         bl    @putvrx               ; Write VR#1
     2360 2338 
0346 2362 0458  20         b     *tmp4                 ; Exit
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
0360 2364 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2366 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2368 C11B  26         mov   *r11,tmp0             ; Get P0
0363 236A 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     236C 7FFF 
0364 236E 2120  38         coc   @wbit0,tmp0
     2370 2020 
0365 2372 1604  14         jne   ldfnt1
0366 2374 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2376 8000 
0367 2378 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     237A 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 237C C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     237E 23E6 
0372 2380 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2382 9C02 
0373 2384 06C4  14         swpb  tmp0
0374 2386 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2388 9C02 
0375 238A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     238C 9800 
0376 238E 06C5  14         swpb  tmp1
0377 2390 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     2392 9800 
0378 2394 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 2396 D805  38         movb  tmp1,@grmwa
     2398 9C02 
0383 239A 06C5  14         swpb  tmp1
0384 239C D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     239E 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23A0 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23A2 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23A4 22BA 
0390 23A6 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23A8 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23AA 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23AC 7FFF 
0393 23AE C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23B0 23E8 
0394 23B2 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23B4 23EA 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23B6 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23B8 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23BA D120  34         movb  @grmrd,tmp0
     23BC 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23BE 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23C0 2020 
0405 23C2 1603  14         jne   ldfnt3                ; No, so skip
0406 23C4 D1C4  18         movb  tmp0,tmp3
0407 23C6 0917  56         srl   tmp3,1
0408 23C8 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23CA D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23CC 8C00 
0413 23CE 0606  14         dec   tmp2
0414 23D0 16F2  14         jne   ldfnt2
0415 23D2 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23D4 020F  20         li    r15,vdpw              ; Set VDP write address
     23D6 8C00 
0417 23D8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23DA 7FFF 
0418 23DC 0458  20         b     *tmp4                 ; Exit
0419 23DE D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23E0 2000 
     23E2 8C00 
0420 23E4 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23E6 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23E8 0200 
     23EA 0000 
0425 23EC 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23EE 01C0 
     23F0 0101 
0426 23F2 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23F4 02A0 
     23F6 0101 
0427 23F8 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23FA 00E0 
     23FC 0101 
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
0445 23FE C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 2400 C3A0  34         mov   @wyx,r14              ; Get YX
     2402 832A 
0447 2404 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2406 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2408 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 240A C3A0  34         mov   @wyx,r14              ; Get YX
     240C 832A 
0454 240E 024E  22         andi  r14,>00ff             ; Remove Y
     2410 00FF 
0455 2412 A3CE  18         a     r14,r15               ; pos = pos + X
0456 2414 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2416 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2418 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 241A C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 241C 020F  20         li    r15,vdpw              ; VDP write address
     241E 8C00 
0463 2420 045B  20         b     *r11
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
0477               *--------------------------------------------------------------
0478               *  Register usage
0479               *  tmp1, tmp2, tmp3
0480               ********|*****|*********************|**************************
0481 2422 C17B  30 putstr  mov   *r11+,tmp1
0482 2424 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 2426 C1CB  18 xutstr  mov   r11,tmp3
0484 2428 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     242A 23FE 
0485 242C C2C7  18         mov   tmp3,r11
0486 242E 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 2430 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 2432 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 2434 0286  22         ci    tmp2,255              ; Length > 255 ?
     2436 00FF 
0494 2438 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 243A 0460  28         b     @xpym2v               ; Display string
     243C 2490 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 243E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2440 FFCE 
0501 2442 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2444 2026 
0502               
0503               
0504               
0505               ***************************************************************
0506               * Put length-byte prefixed string at YX
0507               ***************************************************************
0508               *  BL   @PUTAT
0509               *  DATA P0,P1
0510               *
0511               *  P0 = YX position
0512               *  P1 = Pointer to string
0513               *--------------------------------------------------------------
0514               *  REMARKS
0515               *  First byte of string must contain length
0516               ********|*****|*********************|**************************
0517 2446 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2448 832A 
0518 244A 0460  28         b     @putstr
     244C 2422 
0519               
0520               
0521               ***************************************************************
0522               * putlst
0523               * Loop over string list and display
0524               ***************************************************************
0525               * bl  @_put.strings
0526               *--------------------------------------------------------------
0527               * INPUT
0528               * @wyx = Cursor position
0529               * tmp1 = Pointer to first length-prefixed string in list
0530               * tmp2 = Number of strings to display
0531               *--------------------------------------------------------------
0532               * OUTPUT
0533               * none
0534               *--------------------------------------------------------------
0535               * Register usage
0536               * tmp0, tmp1, tmp2, tmp3
0537               ********|*****|*********************|**************************
0538               putlst:
0539 244E 0649  14         dect  stack
0540 2450 C64B  30         mov   r11,*stack            ; Save return address
0541 2452 0649  14         dect  stack
0542 2454 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 2456 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 2458 0987  56         srl   tmp3,8                ; Right align
0549               
0550 245A 0649  14         dect  stack
0551 245C C645  30         mov   tmp1,*stack           ; Push tmp1
0552 245E 0649  14         dect  stack
0553 2460 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 2462 0649  14         dect  stack
0555 2464 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 2466 06A0  32         bl    @xutst0               ; Display string
     2468 2424 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 246A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 246C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 246E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 2470 06A0  32         bl    @down                 ; Move cursor down
     2472 26D8 
0566               
0567 2474 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 2476 0585  14         inc   tmp1                  ; Consider length byte
0569 2478 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     247A 2002 
0570 247C 1301  14         jeq   !                     ; Yes, skip adjustment
0571 247E 0585  14         inc   tmp1                  ; Make address even
0572 2480 0606  14 !       dec   tmp2
0573 2482 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 2484 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 2486 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 2488 045B  20         b     *r11                  ; Return
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
0020 248A C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 248C C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 248E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 2490 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 2492 1604  14         jne   !                     ; No, continue
0028               
0029 2494 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2496 FFCE 
0030 2498 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     249A 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 249C 0264  22 !       ori   tmp0,>4000
     249E 4000 
0035 24A0 06C4  14         swpb  tmp0
0036 24A2 D804  38         movb  tmp0,@vdpa
     24A4 8C02 
0037 24A6 06C4  14         swpb  tmp0
0038 24A8 D804  38         movb  tmp0,@vdpa
     24AA 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 24AC 020F  20         li    r15,vdpw              ; Set VDP write address
     24AE 8C00 
0043 24B0 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     24B2 24BA 
     24B4 8320 
0044 24B6 0460  28         b     @mcloop               ; Write data to VDP and return
     24B8 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 24BA D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 24BC C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 24BE C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 24C0 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 24C2 06C4  14 xpyv2m  swpb  tmp0
0027 24C4 D804  38         movb  tmp0,@vdpa
     24C6 8C02 
0028 24C8 06C4  14         swpb  tmp0
0029 24CA D804  38         movb  tmp0,@vdpa
     24CC 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 24CE 020F  20         li    r15,vdpr              ; Set VDP read address
     24D0 8800 
0034 24D2 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24D4 24DC 
     24D6 8320 
0035 24D8 0460  28         b     @mcloop               ; Read data from VDP
     24DA 8320 
0036 24DC DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24DE C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24E0 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24E2 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24E4 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24E6 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24E8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24EA FFCE 
0034 24EC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24EE 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24F0 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24F2 0001 
0039 24F4 1603  14         jne   cpym0                 ; No, continue checking
0040 24F6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24F8 04C6  14         clr   tmp2                  ; Reset counter
0042 24FA 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24FC 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24FE 7FFF 
0047 2500 C1C4  18         mov   tmp0,tmp3
0048 2502 0247  22         andi  tmp3,1
     2504 0001 
0049 2506 1618  14         jne   cpyodd                ; Odd source address handling
0050 2508 C1C5  18 cpym1   mov   tmp1,tmp3
0051 250A 0247  22         andi  tmp3,1
     250C 0001 
0052 250E 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2510 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2512 2020 
0057 2514 1605  14         jne   cpym3
0058 2516 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     2518 253E 
     251A 8320 
0059 251C 0460  28         b     @mcloop               ; Copy memory and exit
     251E 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 2520 C1C6  18 cpym3   mov   tmp2,tmp3
0064 2522 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2524 0001 
0065 2526 1301  14         jeq   cpym4
0066 2528 0606  14         dec   tmp2                  ; Make TMP2 even
0067 252A CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 252C 0646  14         dect  tmp2
0069 252E 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 2530 C1C7  18         mov   tmp3,tmp3
0074 2532 1301  14         jeq   cpymz
0075 2534 D554  38         movb  *tmp0,*tmp1
0076 2536 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2538 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     253A 8000 
0081 253C 10E9  14         jmp   cpym2
0082 253E DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 2540 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2542 0649  14         dect  stack
0065 2544 C64B  30         mov   r11,*stack            ; Push return address
0066 2546 0649  14         dect  stack
0067 2548 C640  30         mov   r0,*stack             ; Push r0
0068 254A 0649  14         dect  stack
0069 254C C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 254E 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2550 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2552 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2554 4000 
0077 2556 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2558 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 255A 020C  20         li    r12,>1e00             ; SAMS CRU address
     255C 1E00 
0082 255E 04C0  14         clr   r0
0083 2560 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2562 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2564 D100  18         movb  r0,tmp0
0086 2566 0984  56         srl   tmp0,8                ; Right align
0087 2568 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     256A 833C 
0088 256C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 256E C339  30         mov   *stack+,r12           ; Pop r12
0094 2570 C039  30         mov   *stack+,r0            ; Pop r0
0095 2572 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2574 045B  20         b     *r11                  ; Return to caller
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
0131 2576 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2578 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 257A 0649  14         dect  stack
0135 257C C64B  30         mov   r11,*stack            ; Push return address
0136 257E 0649  14         dect  stack
0137 2580 C640  30         mov   r0,*stack             ; Push r0
0138 2582 0649  14         dect  stack
0139 2584 C64C  30         mov   r12,*stack            ; Push r12
0140 2586 0649  14         dect  stack
0141 2588 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 258A 0649  14         dect  stack
0143 258C C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 258E 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2590 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 2592 0284  22         ci    tmp0,255              ; Crash if page > 255
     2594 00FF 
0153 2596 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 2598 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     259A 001E 
0158 259C 150A  14         jgt   !
0159 259E 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     25A0 0004 
0160 25A2 1107  14         jlt   !
0161 25A4 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     25A6 0012 
0162 25A8 1508  14         jgt   sams.page.set.switch_page
0163 25AA 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     25AC 0006 
0164 25AE 1501  14         jgt   !
0165 25B0 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 25B2 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     25B4 FFCE 
0170 25B6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     25B8 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 25BA 020C  20         li    r12,>1e00             ; SAMS CRU address
     25BC 1E00 
0176 25BE C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 25C0 06C0  14         swpb  r0                    ; LSB to MSB
0178 25C2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 25C4 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     25C6 4000 
0180 25C8 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 25CA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 25CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 25CE C339  30         mov   *stack+,r12           ; Pop r12
0188 25D0 C039  30         mov   *stack+,r0            ; Pop r0
0189 25D2 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25D4 045B  20         b     *r11                  ; Return to caller
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
0204 25D6 020C  20         li    r12,>1e00             ; SAMS CRU address
     25D8 1E00 
0205 25DA 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25DC 045B  20         b     *r11                  ; Return to caller
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
0227 25DE 020C  20         li    r12,>1e00             ; SAMS CRU address
     25E0 1E00 
0228 25E2 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25E4 045B  20         b     *r11                  ; Return to caller
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
0260 25E6 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25E8 0649  14         dect  stack
0263 25EA C64B  30         mov   r11,*stack            ; Save return address
0264 25EC 0649  14         dect  stack
0265 25EE C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25F0 0649  14         dect  stack
0267 25F2 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25F4 0649  14         dect  stack
0269 25F6 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25F8 0649  14         dect  stack
0271 25FA C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25FC 0206  20         li    tmp2,8                ; Set loop counter
     25FE 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 2600 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 2602 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 2604 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2606 257A 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 2608 0606  14         dec   tmp2                  ; Next iteration
0288 260A 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 260C 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     260E 25D6 
0294                                                   ; / activating changes.
0295               
0296 2610 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 2612 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 2614 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 2616 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 2618 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 261A 045B  20         b     *r11                  ; Return to caller
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
0318 261C 0649  14         dect  stack
0319 261E C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 2620 06A0  32         bl    @sams.layout
     2622 25E6 
0324 2624 262A                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 2626 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 2628 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 262A 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     262C 0002 
0336 262E 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     2630 0003 
0337 2632 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     2634 000A 
0338 2636 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2638 000B 
0339 263A C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     263C 000C 
0340 263E D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     2640 000D 
0341 2642 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2644 000E 
0342 2646 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2648 000F 
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
0363 264A C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 264C 0649  14         dect  stack
0366 264E C64B  30         mov   r11,*stack            ; Push return address
0367 2650 0649  14         dect  stack
0368 2652 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2654 0649  14         dect  stack
0370 2656 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2658 0649  14         dect  stack
0372 265A C646  30         mov   tmp2,*stack           ; Push tmp2
0373 265C 0649  14         dect  stack
0374 265E C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 2660 0205  20         li    tmp1,sams.layout.copy.data
     2662 2682 
0379 2664 0206  20         li    tmp2,8                ; Set loop counter
     2666 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2668 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 266A 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     266C 2542 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 266E CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2670 833C 
0390               
0391 2672 0606  14         dec   tmp2                  ; Next iteration
0392 2674 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2676 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2678 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 267A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 267C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 267E C2F9  30         mov   *stack+,r11           ; Pop r11
0402 2680 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2682 2000             data  >2000                 ; >2000-2fff
0408 2684 3000             data  >3000                 ; >3000-3fff
0409 2686 A000             data  >a000                 ; >a000-afff
0410 2688 B000             data  >b000                 ; >b000-bfff
0411 268A C000             data  >c000                 ; >c000-cfff
0412 268C D000             data  >d000                 ; >d000-dfff
0413 268E E000             data  >e000                 ; >e000-efff
0414 2690 F000             data  >f000                 ; >f000-ffff
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
0009 2692 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2694 FFBF 
0010 2696 0460  28         b     @putv01
     2698 234A 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 269A 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     269C 0040 
0018 269E 0460  28         b     @putv01
     26A0 234A 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 26A2 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     26A4 FFDF 
0026 26A6 0460  28         b     @putv01
     26A8 234A 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 26AA 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     26AC 0020 
0034 26AE 0460  28         b     @putv01
     26B0 234A 
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
0010 26B2 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     26B4 FFFE 
0011 26B6 0460  28         b     @putv01
     26B8 234A 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 26BA 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     26BC 0001 
0019 26BE 0460  28         b     @putv01
     26C0 234A 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 26C2 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     26C4 FFFD 
0027 26C6 0460  28         b     @putv01
     26C8 234A 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 26CA 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     26CC 0002 
0035 26CE 0460  28         b     @putv01
     26D0 234A 
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
0018 26D2 C83B  50 at      mov   *r11+,@wyx
     26D4 832A 
0019 26D6 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26D8 B820  54 down    ab    @hb$01,@wyx
     26DA 2012 
     26DC 832A 
0028 26DE 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26E0 7820  54 up      sb    @hb$01,@wyx
     26E2 2012 
     26E4 832A 
0037 26E6 045B  20         b     *r11
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
0049 26E8 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26EA D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26EC 832A 
0051 26EE C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26F0 832A 
0052 26F2 045B  20         b     *r11
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
0021 26F4 C120  34 yx2px   mov   @wyx,tmp0
     26F6 832A 
0022 26F8 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26FA 06C4  14         swpb  tmp0                  ; Y<->X
0024 26FC 04C5  14         clr   tmp1                  ; Clear before copy
0025 26FE D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 2700 20A0  38         coc   @wbit1,config         ; f18a present ?
     2702 201E 
0030 2704 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2706 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2708 833A 
     270A 2734 
0032 270C 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 270E 0A15  56         sla   tmp1,1                ; X = X * 2
0035 2710 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 2712 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     2714 0500 
0037 2716 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2718 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 271A 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 271C 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 271E D105  18         movb  tmp1,tmp0
0051 2720 06C4  14         swpb  tmp0                  ; X<->Y
0052 2722 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     2724 2020 
0053 2726 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 2728 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     272A 2012 
0059 272C 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     272E 2024 
0060 2730 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 2732 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 2734 0050            data   80
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
0013 2736 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2738 06A0  32         bl    @putvr                ; Write once
     273A 2336 
0015 273C 391C             data  >391c                 ; VR1/57, value 00011100
0016 273E 06A0  32         bl    @putvr                ; Write twice
     2740 2336 
0017 2742 391C             data  >391c                 ; VR1/57, value 00011100
0018 2744 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2746 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 2748 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     274A 2336 
0028 274C 391C             data  >391c
0029 274E 0458  20         b     *tmp4                 ; Exit
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
0040 2750 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2752 06A0  32         bl    @cpym2v
     2754 248A 
0042 2756 3F00             data  >3f00,f18chk_gpu,8    ; Copy F18A GPU code to VRAM
     2758 2794 
     275A 0008 
0043 275C 06A0  32         bl    @putvr
     275E 2336 
0044 2760 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2762 06A0  32         bl    @putvr
     2764 2336 
0046 2766 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2768 0204  20         li    tmp0,>3f00
     276A 3F00 
0052 276C 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     276E 22BE 
0053 2770 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2772 8800 
0054 2774 0984  56         srl   tmp0,8
0055 2776 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2778 8800 
0056 277A C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 277C 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 277E 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2780 BFFF 
0060 2782 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2784 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2786 4000 
0063               f18chk_exit:
0064 2788 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     278A 2292 
0065 278C 3F00             data  >3f00,>00,6
     278E 0000 
     2790 0006 
0066 2792 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2794 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2796 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2798 0340             data  >0340                 ; 3f04   0340  idle
0074 279A 10FF             data  >10ff                 ; 3f06   10ff  jmp $
0075               
0076               
0077               ***************************************************************
0078               * f18rst - Reset f18a into standard settings
0079               ***************************************************************
0080               *  bl   @f18rst
0081               *--------------------------------------------------------------
0082               *  REMARKS
0083               *  This is used to leave the F18A mode and revert all settings
0084               *  that could lead to corruption when doing BLWP @0
0085               *
0086               *  There are some F18a settings that stay on when doing blwp @0
0087               *  and the TI title screen cannot recover from that.
0088               *
0089               *  It is your responsibility to set video mode tables should
0090               *  you want to continue instead of doing blwp @0 after your
0091               *  program cleanup
0092               ********|*****|*********************|**************************
0093 279C C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0094                       ;------------------------------------------------------
0095                       ; Reset all F18a VDP registers to power-on defaults
0096                       ;------------------------------------------------------
0097 279E 06A0  32         bl    @putvr
     27A0 2336 
0098 27A2 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0099               
0100 27A4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     27A6 2336 
0101 27A8 391C             data  >391c                 ; Lock the F18a
0102 27AA 0458  20         b     *tmp4                 ; Exit
0103               
0104               
0105               
0106               ***************************************************************
0107               * f18fwv - Get F18A Firmware Version
0108               ***************************************************************
0109               *  bl   @f18fwv
0110               *--------------------------------------------------------------
0111               *  REMARKS
0112               *  Successfully tested with F18A v1.8, note that this does not
0113               *  work with F18 v1.3 but you shouldn't be using such old F18A
0114               *  firmware to begin with.
0115               *--------------------------------------------------------------
0116               *  TMP0 High nibble = major version
0117               *  TMP0 Low nibble  = minor version
0118               *
0119               *  Example: >0018     F18a Firmware v1.8
0120               ********|*****|*********************|**************************
0121 27AC C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0122 27AE 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27B0 201E 
0123 27B2 1609  14         jne   f18fw1
0124               ***************************************************************
0125               * Read F18A major/minor version
0126               ***************************************************************
0127 27B4 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27B6 8802 
0128 27B8 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27BA 2336 
0129 27BC 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0130 27BE 04C4  14         clr   tmp0
0131 27C0 D120  34         movb  @vdps,tmp0
     27C2 8802 
0132 27C4 0984  56         srl   tmp0,8
0133 27C6 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 27C8 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27CA 832A 
0018 27CC D17B  28         movb  *r11+,tmp1
0019 27CE 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27D0 D1BB  28         movb  *r11+,tmp2
0021 27D2 0986  56         srl   tmp2,8                ; Repeat count
0022 27D4 C1CB  18         mov   r11,tmp3
0023 27D6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27D8 23FE 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27DA 020B  20         li    r11,hchar1
     27DC 27E2 
0028 27DE 0460  28         b     @xfilv                ; Draw
     27E0 2298 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27E2 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27E4 2022 
0033 27E6 1302  14         jeq   hchar2                ; Yes, exit
0034 27E8 C2C7  18         mov   tmp3,r11
0035 27EA 10EE  14         jmp   hchar                 ; Next one
0036 27EC 05C7  14 hchar2  inct  tmp3
0037 27EE 0457  20         b     *tmp3                 ; Exit
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
0016 27F0 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27F2 2020 
0017 27F4 020C  20         li    r12,>0024
     27F6 0024 
0018 27F8 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27FA 288C 
0019 27FC 04C6  14         clr   tmp2
0020 27FE 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 2800 04CC  14         clr   r12
0025 2802 1F08  20         tb    >0008                 ; Shift-key ?
0026 2804 1302  14         jeq   realk1                ; No
0027 2806 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     2808 28BC 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 280A 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 280C 1302  14         jeq   realk2                ; No
0033 280E 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     2810 28EC 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 2812 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 2814 1302  14         jeq   realk3                ; No
0039 2816 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     2818 291C 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 281A 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     281C 200C 
0044 281E 1E15  20         sbz   >0015                 ; Set P5
0045 2820 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 2822 1302  14         jeq   realk4                ; No
0047 2824 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     2826 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 2828 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 282A 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     282C 0006 
0053 282E 0606  14 realk5  dec   tmp2
0054 2830 020C  20         li    r12,>24               ; CRU address for P2-P4
     2832 0024 
0055 2834 06C6  14         swpb  tmp2
0056 2836 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2838 06C6  14         swpb  tmp2
0058 283A 020C  20         li    r12,6                 ; CRU read address
     283C 0006 
0059 283E 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 2840 0547  14         inv   tmp3                  ;
0061 2842 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2844 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2846 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2848 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 284A 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 284C 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 284E 0285  22         ci    tmp1,8
     2850 0008 
0070 2852 1AFA  14         jl    realk6
0071 2854 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2856 1BEB  14         jh    realk5                ; No, next column
0073 2858 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 285A C206  18 realk8  mov   tmp2,tmp4
0078 285C 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 285E A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 2860 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2862 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2864 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2866 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2868 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     286A 200C 
0089 286C 1608  14         jne   realka                ; No, continue saving key
0090 286E 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2870 28B6 
0091 2872 1A05  14         jl    realka
0092 2874 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2876 28B4 
0093 2878 1B02  14         jh    realka                ; No, continue
0094 287A 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     287C E000 
0095 287E C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2880 833C 
0096 2882 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2884 200A 
0097 2886 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2888 8C00 
0098                                                   ; / using R15 as temp storage
0099 288A 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 288C FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     288E 0000 
     2890 FF0D 
     2892 203D 
0102 2894 ....             text  'xws29ol.'
0103 289C ....             text  'ced38ik,'
0104 28A4 ....             text  'vrf47ujm'
0105 28AC ....             text  'btg56yhn'
0106 28B4 ....             text  'zqa10p;/'
0107 28BC FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     28BE 0000 
     28C0 FF0D 
     28C2 202B 
0108 28C4 ....             text  'XWS@(OL>'
0109 28CC ....             text  'CED#*IK<'
0110 28D4 ....             text  'VRF$&UJM'
0111 28DC ....             text  'BTG%^YHN'
0112 28E4 ....             text  'ZQA!)P:-'
0113 28EC FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28EE 0000 
     28F0 FF0D 
     28F2 2005 
0114 28F4 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28F6 0804 
     28F8 0F27 
     28FA C2B9 
0115 28FC 600B             data  >600b,>0907,>063f,>c1B8
     28FE 0907 
     2900 063F 
     2902 C1B8 
0116 2904 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     2906 7B02 
     2908 015F 
     290A C0C3 
0117 290C BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     290E 7D0E 
     2910 0CC6 
     2912 BFC4 
0118 2914 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     2916 7C03 
     2918 BC22 
     291A BDBA 
0119 291C FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     291E 0000 
     2920 FF0D 
     2922 209D 
0120 2924 9897             data  >9897,>93b2,>9f8f,>8c9B
     2926 93B2 
     2928 9F8F 
     292A 8C9B 
0121 292C 8385             data  >8385,>84b3,>9e89,>8b80
     292E 84B3 
     2930 9E89 
     2932 8B80 
0122 2934 9692             data  >9692,>86b4,>b795,>8a8D
     2936 86B4 
     2938 B795 
     293A 8A8D 
0123 293C 8294             data  >8294,>87b5,>b698,>888E
     293E 87B5 
     2940 B698 
     2942 888E 
0124 2944 9A91             data  >9a91,>81b1,>b090,>9cBB
     2946 81B1 
     2948 B090 
     294A 9CBB 
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
0023 294C C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 294E C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2950 8340 
0025 2952 04E0  34         clr   @waux1
     2954 833C 
0026 2956 04E0  34         clr   @waux2
     2958 833E 
0027 295A 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     295C 833C 
0028 295E C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2960 0205  20         li    tmp1,4                ; 4 nibbles
     2962 0004 
0033 2964 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2966 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2968 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 296A 0286  22         ci    tmp2,>000a
     296C 000A 
0039 296E 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2970 C21B  26         mov   *r11,tmp4
0045 2972 0988  56         srl   tmp4,8                ; Right justify
0046 2974 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2976 FFF6 
0047 2978 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 297A C21B  26         mov   *r11,tmp4
0054 297C 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     297E 00FF 
0055               
0056 2980 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2982 06C6  14         swpb  tmp2
0058 2984 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2986 0944  56         srl   tmp0,4                ; Next nibble
0060 2988 0605  14         dec   tmp1
0061 298A 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 298C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     298E BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2990 C160  34         mov   @waux3,tmp1           ; Get pointer
     2992 8340 
0067 2994 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2996 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2998 C120  34         mov   @waux2,tmp0
     299A 833E 
0070 299C 06C4  14         swpb  tmp0
0071 299E DD44  32         movb  tmp0,*tmp1+
0072 29A0 06C4  14         swpb  tmp0
0073 29A2 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 29A4 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     29A6 8340 
0078 29A8 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     29AA 2016 
0079 29AC 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 29AE C120  34         mov   @waux1,tmp0
     29B0 833C 
0084 29B2 06C4  14         swpb  tmp0
0085 29B4 DD44  32         movb  tmp0,*tmp1+
0086 29B6 06C4  14         swpb  tmp0
0087 29B8 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 29BA 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29BC 2020 
0092 29BE 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29C0 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29C2 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29C4 7FFF 
0098 29C6 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29C8 8340 
0099 29CA 0460  28         b     @xutst0               ; Display string
     29CC 2424 
0100 29CE 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29D0 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29D2 832A 
0122 29D4 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29D6 8000 
0123 29D8 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29DA 0207  20 mknum   li    tmp3,5                ; Digit counter
     29DC 0005 
0020 29DE C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29E0 C155  26         mov   *tmp1,tmp1            ; /
0022 29E2 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29E4 0228  22         ai    tmp4,4                ; Get end of buffer
     29E6 0004 
0024 29E8 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29EA 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29EC 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29EE 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29F0 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29F2 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29F4 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29F6 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29F8 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29FA 0607  14         dec   tmp3                  ; Decrease counter
0036 29FC 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29FE 0207  20         li    tmp3,4                ; Check first 4 digits
     2A00 0004 
0041 2A02 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2A04 C11B  26         mov   *r11,tmp0
0043 2A06 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2A08 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2A0A 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2A0C 05CB  14 mknum3  inct  r11
0047 2A0E 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A10 2020 
0048 2A12 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2A14 045B  20         b     *r11                  ; Exit
0050 2A16 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2A18 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2A1A 13F8  14         jeq   mknum3                ; Yes, exit
0053 2A1C 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2A1E 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A20 7FFF 
0058 2A22 C10B  18         mov   r11,tmp0
0059 2A24 0224  22         ai    tmp0,-4
     2A26 FFFC 
0060 2A28 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A2A 0206  20         li    tmp2,>0500            ; String length = 5
     2A2C 0500 
0062 2A2E 0460  28         b     @xutstr               ; Display string
     2A30 2426 
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * trimnum - Trim unsigned number string
0069               ***************************************************************
0070               *  bl   @trimnum
0071               *  data p0,p1,p2
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
0093 2A32 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A34 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A36 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A38 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A3A 0207  20         li    tmp3,5                ; Set counter
     2A3C 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A3E 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A40 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A42 0584  14         inc   tmp0                  ; Next character
0105 2A44 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A46 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A48 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A4A 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A4C DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A4E 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A50 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A52 0607  14         dec   tmp3                  ; Last character ?
0121 2A54 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A56 045B  20         b     *r11                  ; Return
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
0139 2A58 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A5A 832A 
0140 2A5C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A5E 8000 
0141 2A60 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A62 0649  14         dect  stack
0023 2A64 C64B  30         mov   r11,*stack            ; Save return address
0024 2A66 0649  14         dect  stack
0025 2A68 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A6A 0649  14         dect  stack
0027 2A6C C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A6E 0649  14         dect  stack
0029 2A70 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A72 0649  14         dect  stack
0031 2A74 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A76 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A78 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A7A C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A7C 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A7E 0649  14         dect  stack
0044 2A80 C64B  30         mov   r11,*stack            ; Save return address
0045 2A82 0649  14         dect  stack
0046 2A84 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A86 0649  14         dect  stack
0048 2A88 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A8A 0649  14         dect  stack
0050 2A8C C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A8E 0649  14         dect  stack
0052 2A90 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A92 C1D4  26 !       mov   *tmp0,tmp3
0057 2A94 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A96 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A98 00FF 
0059 2A9A 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A9C 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A9E 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2AA0 0584  14         inc   tmp0                  ; Next byte
0067 2AA2 0607  14         dec   tmp3                  ; Shorten string length
0068 2AA4 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2AA6 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2AA8 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2AAA C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2AAC 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2AAE C187  18         mov   tmp3,tmp2
0078 2AB0 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2AB2 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2AB4 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2AB6 24E4 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2AB8 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2ABA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2ABC FFCE 
0090 2ABE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AC0 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2AC2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AC4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2AC6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2AC8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2ACA C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2ACC 045B  20         b     *r11                  ; Return to caller
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
0123 2ACE 0649  14         dect  stack
0124 2AD0 C64B  30         mov   r11,*stack            ; Save return address
0125 2AD2 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AD4 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AD6 0649  14         dect  stack
0128 2AD8 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2ADA 0649  14         dect  stack
0130 2ADC C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2ADE 0649  14         dect  stack
0132 2AE0 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AE2 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AE4 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AE6 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AE8 0649  14         dect  stack
0144 2AEA C64B  30         mov   r11,*stack            ; Save return address
0145 2AEC 0649  14         dect  stack
0146 2AEE C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AF0 0649  14         dect  stack
0148 2AF2 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AF4 0649  14         dect  stack
0150 2AF6 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AF8 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AFA 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AFC 0586  14         inc   tmp2
0161 2AFE 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2B00 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2B02 0286  22         ci    tmp2,255
     2B04 00FF 
0167 2B06 1505  14         jgt   string.getlenc.panic
0168 2B08 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2B0A 0606  14         dec   tmp2                  ; One time adjustment
0174 2B0C C806  38         mov   tmp2,@waux1           ; Store length
     2B0E 833C 
0175 2B10 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2B12 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B14 FFCE 
0181 2B16 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B18 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2B1A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2B1C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2B1E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2B20 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2B22 045B  20         b     *r11                  ; Return to caller
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
0056 2B24 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2B26 2B28             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2B28 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2B2A C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2B2C A428 
0064 2B2E 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2B30 201C 
0065 2B32 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2B34 8356 
0066 2B36 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B38 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B3A FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B3C C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B3E A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B40 06C0  14         swpb  r0                    ;
0075 2B42 D800  38         movb  r0,@vdpa              ; Send low byte
     2B44 8C02 
0076 2B46 06C0  14         swpb  r0                    ;
0077 2B48 D800  38         movb  r0,@vdpa              ; Send high byte
     2B4A 8C02 
0078 2B4C D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B4E 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B50 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B52 0704  14         seto  r4                    ; Init counter
0086 2B54 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B56 A420 
0087 2B58 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B5A 0584  14         inc   r4                    ; Increment char counter
0089 2B5C 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B5E 0007 
0090 2B60 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B62 80C4  18         c     r4,r3                 ; End of name?
0093 2B64 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B66 06C0  14         swpb  r0                    ;
0098 2B68 D800  38         movb  r0,@vdpa              ; Send low byte
     2B6A 8C02 
0099 2B6C 06C0  14         swpb  r0                    ;
0100 2B6E D800  38         movb  r0,@vdpa              ; Send high byte
     2B70 8C02 
0101 2B72 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B74 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B76 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B78 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B7A 2C90 
0109 2B7C 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B7E C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B80 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B82 04E0  34         clr   @>83d0
     2B84 83D0 
0118 2B86 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B88 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B8A C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B8C A432 
0121               
0122 2B8E 0584  14         inc   r4                    ; Adjust for dot
0123 2B90 A804  38         a     r4,@>8356             ; Point to position after name
     2B92 8356 
0124 2B94 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B96 8356 
     2B98 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B9A 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B9C 83E0 
0130 2B9E 04C1  14         clr   r1                    ; Version found of dsr
0131 2BA0 020C  20         li    r12,>0f00             ; Init cru address
     2BA2 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2BA4 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2BA6 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2BA8 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2BAA 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2BAC 0100 
0145 2BAE 04E0  34         clr   @>83d0                ; Clear in case we are done
     2BB0 83D0 
0146 2BB2 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2BB4 2000 
0147 2BB6 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2BB8 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2BBA 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2BBC 1D00  20         sbo   0                     ; Turn on ROM
0154 2BBE 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2BC0 4000 
0155 2BC2 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2BC4 2C8C 
0156 2BC6 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2BC8 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2BCA A40A 
0166 2BCC 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2BCE C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2BD0 83D2 
0172                                                   ; subprogram
0173               
0174 2BD2 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2BD4 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BD6 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BD8 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BDA 83D2 
0183                                                   ; subprogram
0184               
0185 2BDC 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BDE C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BE0 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BE2 D160  34         movb  @>8355,r5             ; Get length as counter
     2BE4 8355 
0195 2BE6 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BE8 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BEA 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BEC 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BEE 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BF0 A420 
0206 2BF2 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BF4 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BF6 0605  14         dec   r5                    ; Update loop counter
0211 2BF8 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BFA 0581  14         inc   r1                    ; Next version found
0217 2BFC C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BFE A42A 
0218 2C00 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C02 A42C 
0219 2C04 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C06 A430 
0220               
0221 2C08 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C0A 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C0C 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2C0E 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2C10 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2C12 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C14 A400 
0233 2C16 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2C18 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2C1A A428 
0239                                                   ; (8 or >a)
0240 2C1C 0281  22         ci    r1,8                  ; was it 8?
     2C1E 0008 
0241 2C20 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2C22 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2C24 8350 
0243                                                   ; Get error byte from @>8350
0244 2C26 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2C28 06C0  14         swpb  r0                    ;
0252 2C2A D800  38         movb  r0,@vdpa              ; send low byte
     2C2C 8C02 
0253 2C2E 06C0  14         swpb  r0                    ;
0254 2C30 D800  38         movb  r0,@vdpa              ; send high byte
     2C32 8C02 
0255 2C34 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C36 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C38 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C3A 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C3C 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C3E 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C40 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C42 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C44 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C46 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C48 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C4A F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C4C 201C 
0281                                                   ; / to indicate error
0282 2C4E 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C50 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C52 2C54             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C54 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C56 83E0 
0316               
0317 2C58 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C5A 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C5C 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C5E A42A 
0322 2C60 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C62 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C64 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C66 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C68 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C6A C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C6C 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C6E 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C70 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C72 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C74 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C76 4000 
     2C78 2C8C 
0337 2C7A 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C7C 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C7E 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C80 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C82 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C84 A400 
0355 2C86 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C88 A434 
0356               
0357 2C8A 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C8C AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C8E 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C90 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2C92 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C94 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C96 0649  14         dect  stack
0052 2C98 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C9A 0204  20         li    tmp0,dsrlnk.savcru
     2C9C A42A 
0057 2C9E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2CA0 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2CA2 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2CA4 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2CA6 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2CA8 37D7 
0065 2CAA C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2CAC 8370 
0066                                                   ; / location
0067 2CAE C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2CB0 A44C 
0068 2CB2 04C5  14         clr   tmp1                  ; io.op.open
0069 2CB4 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2CB6 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2CB8 0649  14         dect  stack
0097 2CBA C64B  30         mov   r11,*stack            ; Save return address
0098 2CBC 0205  20         li    tmp1,io.op.close      ; io.op.close
     2CBE 0001 
0099 2CC0 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2CC2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2CC4 0649  14         dect  stack
0125 2CC6 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2CC8 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CCA 0002 
0128 2CCC 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2CCE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2CD0 0649  14         dect  stack
0155 2CD2 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2CD4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CD6 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CD8 0005 
0159               
0160 2CDA C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CDC A43E 
0161               
0162 2CDE 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CE0 22D0 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CE2 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CE4 0003 
0167 2CE6 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CE8 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CEA 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CEC 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CEE 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CF0 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CF2 1000  14         nop
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
0227 2CF4 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CF6 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CF8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CFA A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CFC A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CFE 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2D00 22D0 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D02 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D04 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D06 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D08 A44C 
0246               
0247 2D0A 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D0C 22D0 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D0E 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D10 0009 
0254 2D12 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2D14 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2D16 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2D18 8322 
     2D1A 833C 
0259               
0260 2D1C C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2D1E A42A 
0261 2D20 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2D22 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2D24 2B24 
0268 2D26 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2D28 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2D2A 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2D2C 2C50 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2D2E 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2D30 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2D32 833C 
     2D34 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D36 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D38 A436 
0292 2D3A 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D3C 0005 
0293 2D3E 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D40 22E8 
0294 2D42 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D44 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D46 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D48 045B  20         b     *r11                  ; Return to caller
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
0020 2D4A 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D4C 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D4E D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D50 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D52 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D54 201C 
0029 2D56 1602  14         jne   tmgr1a                ; No, so move on
0030 2D58 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D5A 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D5C 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D5E 2020 
0035 2D60 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D62 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D64 2010 
0048 2D66 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D68 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D6A 200E 
0050 2D6C 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D6E 0460  28         b     @kthread              ; Run kernel thread
     2D70 2DE8 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D72 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D74 2014 
0056 2D76 13EB  14         jeq   tmgr1
0057 2D78 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D7A 2012 
0058 2D7C 16E8  14         jne   tmgr1
0059 2D7E C120  34         mov   @wtiusr,tmp0
     2D80 832E 
0060 2D82 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D84 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D86 2DE6 
0065 2D88 C10A  18         mov   r10,tmp0
0066 2D8A 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D8C 00FF 
0067 2D8E 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D90 201C 
0068 2D92 1303  14         jeq   tmgr5
0069 2D94 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D96 003C 
0070 2D98 1002  14         jmp   tmgr6
0071 2D9A 0284  22 tmgr5   ci    tmp0,50
     2D9C 0032 
0072 2D9E 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2DA0 1001  14         jmp   tmgr8
0074 2DA2 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2DA4 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2DA6 832C 
0079 2DA8 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2DAA FF00 
0080 2DAC C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2DAE 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2DB0 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2DB2 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2DB4 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2DB6 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2DB8 830C 
     2DBA 830D 
0089 2DBC 1608  14         jne   tmgr10                ; No, get next slot
0090 2DBE 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2DC0 FF00 
0091 2DC2 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2DC4 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2DC6 8330 
0096 2DC8 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2DCA C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2DCC 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2DCE 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2DD0 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2DD2 8315 
     2DD4 8314 
0103 2DD6 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DD8 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DDA 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DDC 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DDE 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DE0 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DE2 FF00 
0109 2DE4 10B4  14         jmp   tmgr1
0110 2DE6 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DE8 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DEA 2010 
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
0041 2DEC 06A0  32         bl    @realkb               ; Scan full keyboard
     2DEE 27F0 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DF0 0460  28         b     @tmgr3                ; Exit
     2DF2 2D72 
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
0017 2DF4 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DF6 832E 
0018 2DF8 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DFA 2012 
0019 2DFC 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D4E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DFE 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2E00 832E 
0029 2E02 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E04 FEFF 
0030 2E06 045B  20         b     *r11                  ; Return
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
0017 2E08 C13B  30 mkslot  mov   *r11+,tmp0
0018 2E0A C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2E0C C184  18         mov   tmp0,tmp2
0023 2E0E 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2E10 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2E12 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2E14 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2E16 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2E18 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2E1A 881B  46         c     *r11,@w$ffff          ; End of list ?
     2E1C 2022 
0035 2E1E 1301  14         jeq   mkslo1                ; Yes, exit
0036 2E20 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2E22 05CB  14 mkslo1  inct  r11
0041 2E24 045B  20         b     *r11                  ; Exit
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
0052 2E26 C13B  30 clslot  mov   *r11+,tmp0
0053 2E28 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2E2A A120  34         a     @wtitab,tmp0          ; Add table base
     2E2C 832C 
0055 2E2E 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2E30 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2E32 045B  20         b     *r11                  ; Exit
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
0068 2E34 C13B  30 rsslot  mov   *r11+,tmp0
0069 2E36 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E38 A120  34         a     @wtitab,tmp0          ; Add table base
     2E3A 832C 
0071 2E3C 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E3E C154  26         mov   *tmp0,tmp1
0073 2E40 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E42 FF00 
0074 2E44 C505  30         mov   tmp1,*tmp0
0075 2E46 045B  20         b     *r11                  ; Exit
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
0260 2E48 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E4A 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E4C 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E4E 0000 
0266 2E50 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E52 8300 
0267 2E54 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E56 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E58 0202  20 runli2  li    r2,>8308
     2E5A 8308 
0272 2E5C 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E5E 0282  22         ci    r2,>8400
     2E60 8400 
0274 2E62 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E64 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E66 FFFF 
0279 2E68 1602  14         jne   runli4                ; No, continue
0280 2E6A 0420  54         blwp  @0                    ; Yes, bye bye
     2E6C 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E6E C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E70 833C 
0285 2E72 04C1  14         clr   r1                    ; Reset counter
0286 2E74 0202  20         li    r2,10                 ; We test 10 times
     2E76 000A 
0287 2E78 C0E0  34 runli5  mov   @vdps,r3
     2E7A 8802 
0288 2E7C 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E7E 2020 
0289 2E80 1302  14         jeq   runli6
0290 2E82 0581  14         inc   r1                    ; Increase counter
0291 2E84 10F9  14         jmp   runli5
0292 2E86 0602  14 runli6  dec   r2                    ; Next test
0293 2E88 16F7  14         jne   runli5
0294 2E8A 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E8C 1250 
0295 2E8E 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E90 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E92 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E94 06A0  32 runli7  bl    @loadmc
     2E96 221E 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E98 04C1  14 runli9  clr   r1
0305 2E9A 04C2  14         clr   r2
0306 2E9C 04C3  14         clr   r3
0307 2E9E 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2EA0 3000 
0308 2EA2 020F  20         li    r15,vdpw              ; Set VDP write address
     2EA4 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2EA6 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2EA8 4A4A 
0317 2EAA 1605  14         jne   runlia
0318 2EAC 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2EAE 2292 
0319 2EB0 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2EB2 0000 
     2EB4 3000 
0324 2EB6 06A0  32 runlia  bl    @filv
     2EB8 2292 
0325 2EBA 0FC0             data  pctadr,spfclr,16      ; Load color table
     2EBC 00F4 
     2EBE 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2EC0 06A0  32         bl    @f18unl               ; Unlock the F18A
     2EC2 2736 
0333 2EC4 06A0  32         bl    @f18chk               ; Check if F18A is there
     2EC6 2750 
0334 2EC8 06A0  32         bl    @f18lck               ; Lock the F18A again
     2ECA 2746 
0335               
0336 2ECC 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2ECE 2336 
0337 2ED0 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2ED2 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2ED4 22FC 
0351 2ED6 339A             data  spvmod                ; Equate selected video mode table
0352 2ED8 0204  20         li    tmp0,spfont           ; Get font option
     2EDA 000C 
0353 2EDC 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EDE 1304  14         jeq   runlid                ; Yes, skip it
0355 2EE0 06A0  32         bl    @ldfnt
     2EE2 2364 
0356 2EE4 1100             data  fntadr,spfont         ; Load specified font
     2EE6 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EE8 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EEA 4A4A 
0361 2EEC 1602  14         jne   runlie                ; No, continue
0362 2EEE 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EF0 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EF2 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EF4 0040 
0367 2EF6 0460  28         b     @main                 ; Give control to main program
     2EF8 6036 
**** **** ****     > stevie_b2.asm.3164438
0041                                                   ; Relocated spectra2 in low MEMEXP, was
0042                                                   ; copied to >2000 from ROM in bank 0
0043                       ;------------------------------------------------------
0044                       ; End of File marker
0045                       ;------------------------------------------------------
0046 2EFA DEAD             data >dead,>beef,>dead,>beef
     2EFC BEEF 
     2EFE DEAD 
     2F00 BEEF 
0048               ***************************************************************
0049               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0050               ********|*****|*********************|**************************
0051                       aorg  >3000
0052                       ;------------------------------------------------------
0053                       ; Activate bank 1 and branch to >6036
0054                       ;------------------------------------------------------
0055 3000 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3002 6002 
0056               
0060               
0061 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6036 
0062                       ;------------------------------------------------------
0063                       ; Resident Stevie modules: >3000 - >3fff
0064                       ;------------------------------------------------------
0065                       copy  "ram.resident.3000.asm"
**** **** ****     > ram.resident.3000.asm
0001               * FILE......: ram.resident.3000.asm
0002               * Purpose...: Resident modules at RAM >3000 callable from all ROM banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Resident Stevie modules >3000 - >3fff
0006                       ;------------------------------------------------------
0007                       copy  "rom.farjump.asm"        ; ROM bankswitch trampoline
**** **** ****     > rom.farjump.asm
0001               * FILE......: rom.farjump.asm
0002               * Purpose...: Trampoline to routine in other ROM bank
0003               
0004               ***************************************************************
0005               * rom.farjump - Jump to routine in specified bank
0006               ***************************************************************
0007               *  bl   @rom.farjump
0008               *       data p0,p1
0009               *--------------------------------------------------------------
0010               *  p0 = Write address of target ROM bank
0011               *  p1 = Vector address with target address to jump to
0012               *  p2 = Write address of source ROM bank
0013               *--------------------------------------------------------------
0014               *  bl @xrom.farjump
0015               *
0016               *  tmp0 = Write address of target ROM bank
0017               *  tmp1 = Vector address with target address to jump to
0018               *  tmp2 = Write address of source ROM bank
0019               ********|*****|*********************|**************************
0020               rom.farjump:
0021 3008 C13B  30         mov   *r11+,tmp0            ; P0
0022 300A C17B  30         mov   *r11+,tmp1            ; P1
0023 300C C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 300E 0649  14         dect  stack
0029 3010 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 3012 0649  14         dect  stack
0031 3014 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 3016 0649  14         dect  stack
0033 3018 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 301A 0649  14         dect  stack
0035 301C C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 301E 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     3020 6000 
0040 3022 1111  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 3024 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     3026 A026 
0044 3028 0647  14         dect  tmp3
0045 302A C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 302C 0647  14         dect  tmp3
0047 302E C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 3030 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     3032 A026 
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 3034 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 3036 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 3038 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 303A 0224  22         ai    tmp0,>0800
     303C 0800 
0066 303E 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071 3040 C115  26         mov   *tmp1,tmp0            ; Deref value in vector address
0072 3042 1301  14         jeq   rom.farjump.bankswitch.failed1
0073                                                   ; Crash if null-pointer in vector
0074 3044 1004  14         jmp   rom.farjump.bankswitch.call
0075                                                   ; Call function in target bank
0076                       ;------------------------------------------------------
0077                       ; Assert 1 failed before bank-switch
0078                       ;------------------------------------------------------
0079               rom.farjump.bankswitch.failed1:
0080 3046 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3048 FFCE 
0081 304A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     304C 2026 
0082                       ;------------------------------------------------------
0083                       ; Call function in target bank
0084                       ;------------------------------------------------------
0085               rom.farjump.bankswitch.call:
0086 304E 0694  24         bl    *tmp0                 ; Call function
0087                       ;------------------------------------------------------
0088                       ; Bankswitch back to source bank
0089                       ;------------------------------------------------------
0090               rom.farjump.return:
0091 3050 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     3052 A026 
0092 3054 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0093 3056 1312  14         jeq   rom.farjump.bankswitch.failed2
0094                                                   ; Crash if null-pointer in address
0095               
0096 3058 04F4  30         clr   *tmp0+                ; Remove bank write address from
0097                                                   ; farjump stack
0098               
0099 305A C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0100               
0101 305C 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0102                                                   ; farjump stack
0103               
0104 305E 028B  22         ci    r11,>6000
     3060 6000 
0105 3062 110C  14         jlt   rom.farjump.bankswitch.failed2
0106 3064 028B  22         ci    r11,>7fff
     3066 7FFF 
0107 3068 1509  14         jgt   rom.farjump.bankswitch.failed2
0108               
0109 306A C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     306C A026 
0110               
0114               
0115                       ;------------------------------------------------------
0116                       ; Bankswitch to source 8K ROM bank
0117                       ;------------------------------------------------------
0118               rom.farjump.bankswitch.src.rom8k:
0119 306E 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0120 3070 1009  14         jmp   rom.farjump.exit
0121                       ;------------------------------------------------------
0122                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0123                       ;------------------------------------------------------
0124               rom.farjump.bankswitch.src.advfg99:
0125 3072 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0126 3074 0225  22         ai    tmp1,>0800
     3076 0800 
0127 3078 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0128 307A 1004  14         jmp   rom.farjump.exit
0129                       ;------------------------------------------------------
0130                       ; Assert 2 failed after bank-switch
0131                       ;------------------------------------------------------
0132               rom.farjump.bankswitch.failed2:
0133 307C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     307E FFCE 
0134 3080 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3082 2026 
0135                       ;-------------------------------------------------------
0136                       ; Exit
0137                       ;-------------------------------------------------------
0138               rom.farjump.exit:
0139 3084 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0140 3086 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0141 3088 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0142 308A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0143 308C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0008                       copy  "fb.asm"                 ; Framebuffer
**** **** ****     > fb.asm
0001               * FILE......: fb.asm
0002               * Purpose...: Stevie Editor - Framebuffer module
0003               
0004               ***************************************************************
0005               * fb.init
0006               * Initialize framebuffer
0007               ***************************************************************
0008               *  bl   @fb.init
0009               *--------------------------------------------------------------
0010               *  INPUT
0011               *  none
0012               *--------------------------------------------------------------
0013               *  OUTPUT
0014               *  none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               ********|*****|*********************|**************************
0019               fb.init:
0020 308E 0649  14         dect  stack
0021 3090 C64B  30         mov   r11,*stack            ; Save return address
0022 3092 0649  14         dect  stack
0023 3094 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 3096 0649  14         dect  stack
0025 3098 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 309A 0204  20         li    tmp0,fb.top
     309C A600 
0030 309E C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     30A0 A100 
0031 30A2 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     30A4 A104 
0032 30A6 04E0  34         clr   @fb.row               ; Current row=0
     30A8 A106 
0033 30AA 04E0  34         clr   @fb.column            ; Current column=0
     30AC A10C 
0034               
0035 30AE 0204  20         li    tmp0,colrow
     30B0 0050 
0036 30B2 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     30B4 A10E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 30B6 C160  34         mov   @tv.ruler.visible,tmp1
     30B8 A010 
0041 30BA 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 30BC 0204  20         li    tmp0,pane.botrow-2
     30BE 0015 
0043 30C0 1002  14         jmp   fb.init.cont
0044 30C2 0204  20 !       li    tmp0,pane.botrow-1
     30C4 0016 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 30C6 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     30C8 A11A 
0050 30CA C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     30CC A11C 
0051               
0052 30CE 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     30D0 A022 
0053 30D2 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     30D4 A110 
0054 30D6 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     30D8 A116 
0055 30DA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     30DC A118 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 30DE 06A0  32         bl    @film
     30E0 223A 
0060 30E2 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     30E4 0000 
     30E6 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 30E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 30EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 30EC C2F9  30         mov   *stack+,r11           ; Pop r11
0068 30EE 045B  20         b     *r11                  ; Return to caller
0069               
**** **** ****     > ram.resident.3000.asm
0009                       copy  "idx.asm"                ; Index management
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: Index management
0003               
0004               ***************************************************************
0005               *  Size of index page is 4K and allows indexing of 2048 lines
0006               *  per page.
0007               *
0008               *  Each index slot (word) has the format:
0009               *    +-----+-----+
0010               *    | MSB | LSB |
0011               *    +-----|-----+   LSB = Pointer offset 00-ff.
0012               *
0013               *  MSB = SAMS Page 00-ff
0014               *        Allows addressing of up to 256 4K SAMS pages (1024 KB)
0015               *
0016               *  LSB = Pointer offset in range 00-ff
0017               *
0018               *        To calculate pointer to line in Editor buffer:
0019               *        Pointer address = edb.top + (LSB * 16)
0020               *
0021               *        Note that the editor buffer itself resides in own 4K memory range
0022               *        starting at edb.top
0023               *
0024               *        All support routines must assure that length-prefixed string in
0025               *        Editor buffer always start on a 16 byte boundary for being
0026               *        accessible via index.
0027               ***************************************************************
0028               
0029               
0030               ***************************************************************
0031               * idx.init
0032               * Initialize index
0033               ***************************************************************
0034               * bl @idx.init
0035               *--------------------------------------------------------------
0036               * INPUT
0037               * none
0038               *--------------------------------------------------------------
0039               * OUTPUT
0040               * none
0041               *--------------------------------------------------------------
0042               * Register usage
0043               * tmp0
0044               ********|*****|*********************|**************************
0045               idx.init:
0046 30F0 0649  14         dect  stack
0047 30F2 C64B  30         mov   r11,*stack            ; Save return address
0048 30F4 0649  14         dect  stack
0049 30F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 30F8 0204  20         li    tmp0,idx.top
     30FA B000 
0054 30FC C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     30FE A202 
0055               
0056 3100 C120  34         mov   @tv.sams.b000,tmp0
     3102 A006 
0057 3104 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     3106 A500 
0058 3108 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     310A A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 310C 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     310E 0004 
0063 3110 C804  38         mov   tmp0,@idx.sams.hipage ; /
     3112 A504 
0064               
0065 3114 06A0  32         bl    @_idx.sams.mapcolumn.on
     3116 3132 
0066                                                   ; Index in continuous memory region
0067               
0068 3118 06A0  32         bl    @film
     311A 223A 
0069 311C B000                   data idx.top,>00,idx.size * 5
     311E 0000 
     3120 5000 
0070                                                   ; Clear index
0071               
0072 3122 06A0  32         bl    @_idx.sams.mapcolumn.off
     3124 3166 
0073                                                   ; Restore memory window layout
0074               
0075 3126 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     3128 A502 
     312A A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 312C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 312E C2F9  30         mov   *stack+,r11           ; Pop r11
0083 3130 045B  20         b     *r11                  ; Return to caller
0084               
0085               
0086               ***************************************************************
0087               * bl @_idx.sams.mapcolumn.on
0088               *--------------------------------------------------------------
0089               * Register usage
0090               * tmp0, tmp1, tmp2
0091               *--------------------------------------------------------------
0092               *  Remarks
0093               *  Private, only to be called from inside idx module
0094               ********|*****|*********************|**************************
0095               _idx.sams.mapcolumn.on:
0096 3132 0649  14         dect  stack
0097 3134 C64B  30         mov   r11,*stack            ; Push return address
0098 3136 0649  14         dect  stack
0099 3138 C644  30         mov   tmp0,*stack           ; Push tmp0
0100 313A 0649  14         dect  stack
0101 313C C645  30         mov   tmp1,*stack           ; Push tmp1
0102 313E 0649  14         dect  stack
0103 3140 C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 3142 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3144 A502 
0108 3146 0205  20         li    tmp1,idx.top
     3148 B000 
0109 314A 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     314C 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 314E 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     3150 257A 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 3152 0584  14         inc   tmp0                  ; Next SAMS index page
0118 3154 0225  22         ai    tmp1,>1000            ; Next memory region
     3156 1000 
0119 3158 0606  14         dec   tmp2                  ; Update loop counter
0120 315A 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 315C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 315E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 3160 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 3162 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 3164 045B  20         b     *r11                  ; Return to caller
0130               
0131               
0132               ***************************************************************
0133               * _idx.sams.mapcolumn.off
0134               * Restore normal SAMS layout again (single index page)
0135               ***************************************************************
0136               * bl @_idx.sams.mapcolumn.off
0137               *--------------------------------------------------------------
0138               * Register usage
0139               * tmp0, tmp1, tmp2, tmp3
0140               *--------------------------------------------------------------
0141               *  Remarks
0142               *  Private, only to be called from inside idx module
0143               ********|*****|*********************|**************************
0144               _idx.sams.mapcolumn.off:
0145 3166 0649  14         dect  stack
0146 3168 C64B  30         mov   r11,*stack            ; Push return address
0147 316A 0649  14         dect  stack
0148 316C C644  30         mov   tmp0,*stack           ; Push tmp0
0149 316E 0649  14         dect  stack
0150 3170 C645  30         mov   tmp1,*stack           ; Push tmp1
0151 3172 0649  14         dect  stack
0152 3174 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 3176 0649  14         dect  stack
0154 3178 C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 317A 0205  20         li    tmp1,idx.top
     317C B000 
0159 317E 0206  20         li    tmp2,5                ; Always 5 pages
     3180 0005 
0160 3182 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     3184 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 3186 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 3188 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     318A 257A 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 318C 0225  22         ai    tmp1,>1000            ; Next memory region
     318E 1000 
0171 3190 0606  14         dec   tmp2                  ; Update loop counter
0172 3192 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 3194 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 3196 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 3198 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 319A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 319C C2F9  30         mov   *stack+,r11           ; Pop return address
0182 319E 045B  20         b     *r11                  ; Return to caller
0183               
0184               
0185               
0186               ***************************************************************
0187               * _idx.samspage.get
0188               * Get SAMS page for index
0189               ***************************************************************
0190               * bl @_idx.samspage.get
0191               *--------------------------------------------------------------
0192               * INPUT
0193               * tmp0 = Line number
0194               *--------------------------------------------------------------
0195               * OUTPUT
0196               * @outparm1 = Offset for index entry in index SAMS page
0197               *--------------------------------------------------------------
0198               * Register usage
0199               * tmp0, tmp1, tmp2
0200               *--------------------------------------------------------------
0201               *  Remarks
0202               *  Private, only to be called from inside idx module.
0203               *  Activates SAMS page containing required index slot entry.
0204               ********|*****|*********************|**************************
0205               _idx.samspage.get:
0206 31A0 0649  14         dect  stack
0207 31A2 C64B  30         mov   r11,*stack            ; Save return address
0208 31A4 0649  14         dect  stack
0209 31A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 31A8 0649  14         dect  stack
0211 31AA C645  30         mov   tmp1,*stack           ; Push tmp1
0212 31AC 0649  14         dect  stack
0213 31AE C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 31B0 C184  18         mov   tmp0,tmp2             ; Line number
0218 31B2 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 31B4 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     31B6 0800 
0220               
0221 31B8 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 31BA 0A16  56         sla   tmp2,1                ; line number * 2
0226 31BC C806  38         mov   tmp2,@outparm1        ; Offset index entry
     31BE 2F30 
0227               
0228 31C0 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     31C2 A502 
0229 31C4 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     31C6 A500 
0230               
0231 31C8 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 31CA C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     31CC A500 
0237 31CE C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     31D0 A006 
0238               
0239 31D2 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 31D4 0205  20         li    tmp1,>b000            ; Memory window for index page
     31D6 B000 
0241               
0242 31D8 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31DA 257A 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 31DC 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31DE A504 
0249 31E0 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 31E2 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31E4 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 31E6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 31E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 31EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 31EC C2F9  30         mov   *stack+,r11           ; Pop r11
0260 31EE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0010                       copy  "edb.asm"                ; Editor Buffer
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: Stevie Editor - Editor Buffer module
0003               
0004               ***************************************************************
0005               * edb.init
0006               * Initialize Editor buffer
0007               ***************************************************************
0008               * bl @edb.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               edb.init:
0022 31F0 0649  14         dect  stack
0023 31F2 C64B  30         mov   r11,*stack            ; Save return address
0024 31F4 0649  14         dect  stack
0025 31F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31F8 0204  20         li    tmp0,edb.top          ; \
     31FA C000 
0030 31FC C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     31FE A200 
0031 3200 C804  38         mov   tmp0,@edb.next_free.ptr
     3202 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 3204 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     3206 A20A 
0035               
0036 3208 0204  20         li    tmp0,1
     320A 0001 
0037 320C C804  38         mov   tmp0,@edb.lines       ; Lines=1
     320E A204 
0038               
0039 3210 0720  34         seto  @edb.block.m1         ; Reset block start line
     3212 A20C 
0040 3214 0720  34         seto  @edb.block.m2         ; Reset block end line
     3216 A20E 
0041               
0042 3218 0204  20         li    tmp0,txt.newfile      ; "New file"
     321A 3528 
0043 321C C804  38         mov   tmp0,@edb.filename.ptr
     321E A212 
0044               
0045 3220 0204  20         li    tmp0,txt.filetype.none
     3222 35E2 
0046 3224 C804  38         mov   tmp0,@edb.filetype.ptr
     3226 A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 3228 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 322A C2F9  30         mov   *stack+,r11           ; Pop r11
0054 322C 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
**** **** ****     > ram.resident.3000.asm
0011                       copy  "cmdb.asm"               ; Command buffer
**** **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer module
0003               
0004               ***************************************************************
0005               * cmdb.init
0006               * Initialize Command Buffer
0007               ***************************************************************
0008               * bl @cmdb.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               cmdb.init:
0022 322E 0649  14         dect  stack
0023 3230 C64B  30         mov   r11,*stack            ; Save return address
0024 3232 0649  14         dect  stack
0025 3234 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3236 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     3238 D000 
0030 323A C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     323C A300 
0031               
0032 323E 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     3240 A302 
0033 3242 0204  20         li    tmp0,4
     3244 0004 
0034 3246 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     3248 A306 
0035 324A C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     324C A308 
0036               
0037 324E 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3250 A316 
0038 3252 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3254 A318 
0039 3256 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     3258 A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 325A 06A0  32         bl    @film
     325C 223A 
0044 325E D000             data  cmdb.top,>00,cmdb.size
     3260 0000 
     3262 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3264 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3266 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 3268 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0012                       copy  "errline.asm"            ; Error line
**** **** ****     > errline.asm
0001               * FILE......: errline.asm
0002               * Purpose...: Stevie Editor - Error line utilities
0003               
0004               ***************************************************************
0005               * errline.init
0006               * Initialize error line
0007               ***************************************************************
0008               * bl @errline.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               errline.init:
0022 326A 0649  14         dect  stack
0023 326C C64B  30         mov   r11,*stack            ; Save return address
0024 326E 0649  14         dect  stack
0025 3270 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3272 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3274 A028 
0030               
0031 3276 06A0  32         bl    @film
     3278 223A 
0032 327A A02A                   data tv.error.msg,0,160
     327C 0000 
     327E 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 3280 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 3282 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3284 045B  20         b     *r11                  ; Return to caller
0040               
**** **** ****     > ram.resident.3000.asm
0013                       copy  "tv.asm"                 ; Main editor configuration
**** **** ****     > tv.asm
0001               * FILE......: tv.asm
0002               * Purpose...: Stevie Editor - Main editor configuration
0003               
0004               ***************************************************************
0005               * tv.init
0006               * Initialize editor settings
0007               ***************************************************************
0008               * bl @tv.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               tv.init:
0022 3286 0649  14         dect  stack
0023 3288 C64B  30         mov   r11,*stack            ; Save return address
0024 328A 0649  14         dect  stack
0025 328C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 328E 0204  20         li    tmp0,1                ; \ Set default color scheme
     3290 0001 
0030 3292 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3294 A012 
0031               
0032 3296 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3298 A024 
0033 329A E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     329C 200C 
0034               
0035 329E 0204  20         li    tmp0,fj.bottom
     32A0 F000 
0036 32A2 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     32A4 A026 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 32A6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 32A8 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 32AA 045B  20         b     *r11                  ; Return to caller
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
0065 32AC 0649  14         dect  stack
0066 32AE C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 32B0 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     32B2 322E 
0071 32B4 06A0  32         bl    @edb.init             ; Initialize editor buffer
     32B6 31F0 
0072 32B8 06A0  32         bl    @idx.init             ; Initialize index
     32BA 30F0 
0073 32BC 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32BE 308E 
0074 32C0 06A0  32         bl    @errline.init         ; Initialize error line
     32C2 326A 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 32C4 06A0  32         bl    @hchar
     32C6 27C8 
0079 32C8 0034                   byte 0,52,32,18           ; Remove markers
     32CA 2012 
0080 32CC 1700                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     32CE 2032 
0081 32D0 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 32D2 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 32D4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0014                       copy  "tv.utils.asm"           ; General purpose utility functions
**** **** ****     > tv.utils.asm
0001               * FILE......: tv.utils.asm
0002               * Purpose...: General purpose utility functions
0003               
0004               ***************************************************************
0005               * tv.unpack.uint16
0006               * Unpack 16bit unsigned integer to string
0007               ***************************************************************
0008               * bl @tv.unpack.uint16
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = 16bit unsigned integer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @unpacked.string = Length-prefixed string with unpacked uint16
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ***************************************************************
0019               tv.unpack.uint16:
0020 32D6 0649  14         dect  stack
0021 32D8 C64B  30         mov   r11,*stack            ; Save return address
0022 32DA 0649  14         dect  stack
0023 32DC C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32DE 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32E0 29DA 
0028 32E2 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32E4 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32E6 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32E8 0204  20         li    tmp0,unpacked.string
     32EA 2F44 
0034 32EC 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32EE 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32F0 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32F2 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32F4 2A32 
0039 32F6 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32F8 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32FA 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 32FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 32FE C2F9  30         mov   *stack+,r11           ; Pop r11
0048 3300 045B  20         b     *r11                  ; Return to caller
0049               
0050               
0051               
0052               
0053               
0054               ***************************************************************
0055               * tv.pad.string
0056               * pad string to specified length
0057               ***************************************************************
0058               * bl @tv.pad.string
0059               *--------------------------------------------------------------
0060               * INPUT
0061               * @parm1 = Pointer to length-prefixed string
0062               * @parm2 = Requested length
0063               * @parm3 = Fill character
0064               * @parm4 = Pointer to string buffer
0065               *--------------------------------------------------------------
0066               * OUTPUT
0067               * @outparm1 = Pointer to padded string
0068               *--------------------------------------------------------------
0069               * Register usage
0070               * none
0071               ***************************************************************
0072               tv.pad.string:
0073 3302 0649  14         dect  stack
0074 3304 C64B  30         mov   r11,*stack            ; Push return address
0075 3306 0649  14         dect  stack
0076 3308 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 330A 0649  14         dect  stack
0078 330C C645  30         mov   tmp1,*stack           ; Push tmp1
0079 330E 0649  14         dect  stack
0080 3310 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 3312 0649  14         dect  stack
0082 3314 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 3316 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     3318 2F20 
0087 331A D194  26         movb  *tmp0,tmp2            ; /
0088 331C 0986  56         srl   tmp2,8                ; Right align
0089 331E C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 3320 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3322 2F22 
0092 3324 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 3326 C120  34         mov   @parm1,tmp0           ; Get source address
     3328 2F20 
0097 332A C160  34         mov   @parm4,tmp1           ; Get destination address
     332C 2F26 
0098 332E 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 3330 0649  14         dect  stack
0101 3332 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 3334 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     3336 24E4 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 3338 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 333A C120  34         mov   @parm2,tmp0           ; Get requested length
     333C 2F22 
0113 333E 0A84  56         sla   tmp0,8                ; Left align
0114 3340 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3342 2F26 
0115 3344 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 3346 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 3348 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 334A C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     334C 2F22 
0122 334E 6187  18         s     tmp3,tmp2             ; |
0123 3350 0586  14         inc   tmp2                  ; /
0124               
0125 3352 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3354 2F24 
0126 3356 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 3358 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 335A 0606  14         dec   tmp2                  ; Update loop counter
0133 335C 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 335E C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3360 2F26 
     3362 2F30 
0136 3364 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 3366 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3368 FFCE 
0142 336A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     336C 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 336E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 3370 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 3372 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 3374 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 3376 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 3378 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0015                       copy  "mem.asm"                ; Memory Management (SAMS)
**** **** ****     > mem.asm
0001               * FILE......: mem.asm
0002               * Purpose...: Stevie Editor - Memory management (SAMS)
0003               
0004               ***************************************************************
0005               * mem.sams.layout
0006               * Setup SAMS memory pages for Stevie
0007               ***************************************************************
0008               * bl  @mem.sams.layout
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ***************************************************************
0016               mem.sams.layout:
0017 337A 0649  14         dect  stack
0018 337C C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 337E 06A0  32         bl    @sams.layout
     3380 25E6 
0023 3382 33B2                   data mem.sams.layout.data
0024               
0025 3384 06A0  32         bl    @sams.layout.copy
     3386 264A 
0026 3388 A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 338A C820  54         mov   @tv.sams.c000,@edb.sams.page
     338C A008 
     338E A216 
0029 3390 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     3392 A216 
     3394 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 3396 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 3398 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0016                       copy  "data.constants.asm"     ; Data Constants
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
0033 339A 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     339C 003F 
     339E 0243 
     33A0 05F4 
     33A2 0050 
0034               
0035               romsat:
0036 33A4 0000             data  >0000,>0001             ; Cursor YX, initial shape and colour
     33A6 0001 
0037 33A8 0000             data  >0000,>0301             ; Current line indicator
     33AA 0301 
0038 33AC 0820             data  >0820,>0401             ; Current line indicator
     33AE 0401 
0039               nosprite:
0040 33B0 D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 33B2 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     33B4 0002 
0048 33B6 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     33B8 0003 
0049 33BA A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     33BC 000A 
0050               
0051 33BE B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     33C0 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 33C2 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     33C4 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 33C6 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     33C8 000D 
0060 33CA E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     33CC 000E 
0061 33CE F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     33D0 000F 
0062               
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * Stevie color schemes table
0069               *--------------------------------------------------------------
0070               * Word 1
0071               * A  MSB  high-nibble    Foreground color text line in frame buffer
0072               * B  MSB  low-nibble     Background color text line in frame buffer
0073               * C  LSB  high-nibble    Foreground color top/bottom line
0074               * D  LSB  low-nibble     Background color top/bottom line
0075               *
0076               * Word 2
0077               * E  MSB  high-nibble    Foreground color cmdb pane
0078               * F  MSB  low-nibble     Background color cmdb pane
0079               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0080               * H  LSB  low-nibble     Cursor foreground color frame buffer
0081               *
0082               * Word 3
0083               * I  MSB  high-nibble    Foreground color busy top/bottom line
0084               * J  MSB  low-nibble     Background color busy top/bottom line
0085               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0086               * L  LSB  low-nibble     Background color marked line in frame buffer
0087               *
0088               * Word 4
0089               * M  MSB  high-nibble    Foreground color command buffer header line
0090               * N  MSB  low-nibble     Background color command buffer header line
0091               * O  LSB  high-nibble    Foreground color line+column indicator frame buffer
0092               * P  LSB  low-nibble     Foreground color ruler frame buffer
0093               *
0094               * Colors
0095               * 0  Transparant
0096               * 1  black
0097               * 2  Green
0098               * 3  Light Green
0099               * 4  Blue
0100               * 5  Light Blue
0101               * 6  Dark Red
0102               * 7  Cyan
0103               * 8  Red
0104               * 9  Light Red
0105               * A  Yellow
0106               * B  Light Yellow
0107               * C  Dark Green
0108               * D  Magenta
0109               * E  Grey
0110               * F  White
0111               *--------------------------------------------------------------
0112      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0113               
0114               tv.colorscheme.table:
0115                       ;                             ; #
0116                       ;      ABCD  EFGH  IJKL  MNOP ; -
0117 33D2 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     33D4 F171 
     33D6 1B1F 
     33D8 71B1 
0118 33DA A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     33DC F0FF 
     33DE 1F1A 
     33E0 F1FF 
0119 33E2 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     33E4 F0FF 
     33E6 1F12 
     33E8 F1F6 
0120 33EA F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     33EC 1E11 
     33EE 1A17 
     33F0 1E11 
0121 33F2 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     33F4 E1FF 
     33F6 1F1E 
     33F8 E1FF 
0122 33FA 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     33FC 1016 
     33FE 1B71 
     3400 1711 
0123 3402 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3404 1011 
     3406 F1F1 
     3408 1F11 
0124 340A 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     340C A1FF 
     340E 1F1F 
     3410 F11F 
0125 3412 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     3414 12FF 
     3416 1B12 
     3418 12FF 
0126 341A F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     341C E1FF 
     341E 1B1F 
     3420 F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 3422 0007             byte  0,7,12,25               ; \   Default tab positions as used
     3424 0C19 
0131 3426 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     3428 3B4F 
0132 342A FF00             byte  >ff,0,0,0               ; |
     342C 0000 
0133 342E 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     3430 0000 
0134 3432 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     3434 0000 
0135                       even
**** **** ****     > ram.resident.3000.asm
0017                       copy  "data.strings.asm"       ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               ;--------------------------------------------------------------
0009               ; Strings for about pane
0010               ;--------------------------------------------------------------
0011               txt.stevie
0012 3436 0B53             byte  11
0013 3437 ....             text  'STEVIE 1.1H'
0014                       even
0015               
0016               txt.about.build
0017 3442 4C42             byte  76
0018 3443 ....             text  'Build: 210523-3164438 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 3490 012C             byte  1
0024 3491 ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 3492 0520             byte  5
0029 3493 ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 3498 034F             byte  3
0034 3499 ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 349C 0349             byte  3
0039 349D ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 34A0 012A             byte  1
0044 34A1 ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 34A2 0A4C             byte  10
0049 34A3 ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 34AE 0A53             byte  10
0054 34AF ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 34BA 1244             byte  18
0059 34BB ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 34CE 1143             byte  17
0064 34CF ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 34E0 104D             byte  16
0069 34E1 ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 34F2 1D53             byte  29
0074 34F3 ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 3510 0846             byte  8
0079 3511 ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 351A 026B             byte  2
0084 351B ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 351E 054C             byte  5
0089 351F ....             text  'Lines'
0090                       even
0091               
0092               txt.bufnum
0093 3524 0323             byte  3
0094 3525 ....             text  '#1 '
0095                       even
0096               
0097               txt.newfile
0098 3528 0A5B             byte  10
0099 3529 ....             text  '[New file]'
0100                       even
0101               
0102               txt.filetype.dv80
0103 3534 0444             byte  4
0104 3535 ....             text  'DV80'
0105                       even
0106               
0107               txt.m1
0108 353A 034D             byte  3
0109 353B ....             text  'M1='
0110                       even
0111               
0112               txt.m2
0113 353E 034D             byte  3
0114 353F ....             text  'M2='
0115                       even
0116               
0117               txt.keys.default
0118 3542 135E             byte  19
0119 3543 ....             text  '^Help, ^Open, ^Save'
0120                       even
0121               
0122               txt.keys.block
0123 3556 2B5E             byte  43
0124 3557 ....             text  '^Del, ^Copy, ^Move, ^Goto M1, ^Reset, ^Save'
0125                       even
0126               
0127 3582 ....     txt.ruler          text    '.........'
0128                                  byte    18
0129 358C ....                        text    '.........'
0130                                  byte    19
0131 3596 ....                        text    '.........'
0132                                  byte    20
0133 35A0 ....                        text    '.........'
0134                                  byte    21
0135 35AA ....                        text    '.........'
0136                                  byte    22
0137 35B4 ....                        text    '.........'
0138                                  byte    23
0139 35BE ....                        text    '.........'
0140                                  byte    24
0141 35C8 ....                        text    '.........'
0142                                  byte    25
0143                                  even
0144               
0145 35D2 020E     txt.alpha.down     data >020e,>0f00
     35D4 0F00 
0146 35D6 0110     txt.vertline       data >0110
0147               
0148               txt.ws1
0149 35D8 0120             byte  1
0150 35D9 ....             text  ' '
0151                       even
0152               
0153               txt.ws2
0154 35DA 0220             byte  2
0155 35DB ....             text  '  '
0156                       even
0157               
0158               txt.ws3
0159 35DE 0320             byte  3
0160 35DF ....             text  '   '
0161                       even
0162               
0163               txt.ws4
0164 35E2 0420             byte  4
0165 35E3 ....             text  '    '
0166                       even
0167               
0168               txt.ws5
0169 35E8 0520             byte  5
0170 35E9 ....             text  '     '
0171                       even
0172               
0173      35E2     txt.filetype.none  equ txt.ws4
0174               
0175               
0176               ;--------------------------------------------------------------
0177               ; Dialog Load DV 80 file
0178               ;--------------------------------------------------------------
0179 35EE 1301     txt.head.load      byte 19,1,3,32
     35F0 0320 
0180 35F2 ....                        text 'Open DV80 file '
0181                                  byte 2
0182               txt.hint.load
0183 3602 4746             byte  71
0184 3603 ....             text  'Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0185                       even
0186               
0187               txt.keys.load
0188 364A 3246             byte  50
0189 364B ....             text  'F9=Back, F3=Clear, F5=Fastmode, F-H=Home, F-L=End '
0190                       even
0191               
0192               txt.keys.load2
0193 367E 3246             byte  50
0194 367F ....             text  'F9=Back, F3=Clear, *F5=Fastmode, F-H=Home, F-L=End'
0195                       even
0196               
0197               
0198               ;--------------------------------------------------------------
0199               ; Dialog Save DV 80 file
0200               ;--------------------------------------------------------------
0201 36B2 1301     txt.head.save      byte 19,1,3,32
     36B4 0320 
0202 36B6 ....                        text 'Save DV80 file '
0203                                  byte 2
0204 36C6 2301     txt.head.save2     byte 35,1,3,32
     36C8 0320 
0205 36CA ....                        text 'Save marked block to DV80 file '
0206                                  byte 2
0207               txt.hint.save
0208 36EA 0120             byte  1
0209 36EB ....             text  ' '
0210                       even
0211               
0212               txt.keys.save
0213 36EC 2446             byte  36
0214 36ED ....             text  'F9=Back, F3=Clear, F-H=Home, F-L=End'
0215                       even
0216               
0217               
0218               ;--------------------------------------------------------------
0219               ; Dialog "Unsaved changes"
0220               ;--------------------------------------------------------------
0221 3712 1401     txt.head.unsaved   byte 20,1,3,32
     3714 0320 
0222 3716 ....                        text 'Unsaved changes '
0223 3726 0221                        byte 2
0224               txt.info.unsaved
0225                       byte  33
0226 3728 ....             text  'Warning! Unsaved changes in file.'
0227                       even
0228               
0229               txt.hint.unsaved
0230 374A 2A50             byte  42
0231 374B ....             text  'Press F6 to proceed or ENTER to save file.'
0232                       even
0233               
0234               txt.keys.unsaved
0235 3776 2446             byte  36
0236 3777 ....             text  'F9=Back, F6=Proceed, ENTER=Save file'
0237                       even
0238               
0239               
0240               ;--------------------------------------------------------------
0241               ; Dialog "About"
0242               ;--------------------------------------------------------------
0243 379C 0A01     txt.head.about     byte 10,1,3,32
     379E 0320 
0244 37A0 ....                        text 'About '
0245 37A6 0200                        byte 2
0246               
0247               txt.info.about
0248                       byte  0
0249 37A8 ....             text
0250                       even
0251               
0252               txt.hint.about
0253 37A8 2650             byte  38
0254 37A9 ....             text  'Press F9 or ENTER to return to editor.'
0255                       even
0256               
0257 37D0 2746     txt.keys.about     byte 39
0258 37D1 ....                        text 'F9=Back, ENTER=Back, '
0259 37E6 0E0F                        byte 14,15
0260 37E8 ....                        text '=Alpha Lock down'
0261               
0262               ;--------------------------------------------------------------
0263               ; Strings for error line pane
0264               ;--------------------------------------------------------------
0265               txt.ioerr.load
0266 37F8 2049             byte  32
0267 37F9 ....             text  'I/O error. Failed loading file: '
0268                       even
0269               
0270               txt.ioerr.save
0271 381A 2049             byte  32
0272 381B ....             text  'I/O error. Failed saving file:  '
0273                       even
0274               
0275               txt.memfull.load
0276 383C 4049             byte  64
0277 383D ....             text  'Index memory full. Could not fully load file into editor buffer.'
0278                       even
0279               
0280               txt.io.nofile
0281 387E 2149             byte  33
0282 387F ....             text  'I/O error. No filename specified.'
0283                       even
0284               
0285               txt.block.inside
0286 38A0 3445             byte  52
0287 38A1 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0288                       even
0289               
0290               
0291               ;--------------------------------------------------------------
0292               ; Strings for command buffer
0293               ;--------------------------------------------------------------
0294               txt.cmdb.prompt
0295 38D6 013E             byte  1
0296 38D7 ....             text  '>'
0297                       even
0298               
0299               txt.colorscheme
0300 38D8 0D43             byte  13
0301 38D9 ....             text  'Color scheme:'
0302                       even
0303               
**** **** ****     > ram.resident.3000.asm
0018                       copy  "data.keymap.keys.asm"   ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.keys.asm
0001               * FILE......: data.keymap.keys.asm
0002               * Purpose...: Keyboard mapping
0003               
0004               *---------------------------------------------------------------
0005               * Keyboard scancodes - Function keys
0006               *-------------|---------------------|---------------------------
0007      BC00     key.fctn.0    equ >bc00             ; fctn + 0
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
0018      BE00     key.fctn.b    equ >be00             ; fctn + b
0019      0000     key.fctn.c    equ >0000             ; fctn + c
0020      0900     key.fctn.d    equ >0900             ; fctn + d
0021      0B00     key.fctn.e    equ >0b00             ; fctn + e
0022      0000     key.fctn.f    equ >0000             ; fctn + f
0023      0000     key.fctn.g    equ >0000             ; fctn + g
0024      BF00     key.fctn.h    equ >bf00             ; fctn + h
0025      0000     key.fctn.i    equ >0000             ; fctn + i
0026      C000     key.fctn.j    equ >c000             ; fctn + j
0027      C100     key.fctn.k    equ >c100             ; fctn + k
0028      C200     key.fctn.l    equ >c200             ; fctn + l
0029      C300     key.fctn.m    equ >c300             ; fctn + m
0030      C400     key.fctn.n    equ >c400             ; fctn + n
0031      0000     key.fctn.o    equ >0000             ; fctn + o
0032      0000     key.fctn.p    equ >0000             ; fctn + p
0033      C500     key.fctn.q    equ >c500             ; fctn + q
0034      0000     key.fctn.r    equ >0000             ; fctn + r
0035      0800     key.fctn.s    equ >0800             ; fctn + s
0036      0000     key.fctn.t    equ >0000             ; fctn + t
0037      0000     key.fctn.u    equ >0000             ; fctn + u
0038      7F00     key.fctn.v    equ >7f00             ; fctn + v
0039      7E00     key.fctn.w    equ >7e00             ; fctn + w
0040      0A00     key.fctn.x    equ >0a00             ; fctn + x
0041      C600     key.fctn.y    equ >c600             ; fctn + y
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
0064      8300     key.ctrl.c    equ >8300             ; ctrl + c
0065      8400     key.ctrl.d    equ >8400             ; ctrl + d
0066      8500     key.ctrl.e    equ >8500             ; ctrl + e
0067      8600     key.ctrl.f    equ >8600             ; ctrl + f
0068      8700     key.ctrl.g    equ >8700             ; ctrl + g
0069      8800     key.ctrl.h    equ >8800             ; ctrl + h
0070      8900     key.ctrl.i    equ >8900             ; ctrl + i
0071      8A00     key.ctrl.j    equ >8a00             ; ctrl + j
0072      8B00     key.ctrl.k    equ >8b00             ; ctrl + k
0073      8C00     key.ctrl.l    equ >8c00             ; ctrl + l
0074      8D00     key.ctrl.m    equ >8d00             ; ctrl + m
0075      8E00     key.ctrl.n    equ >8e00             ; ctrl + n
0076      8F00     key.ctrl.o    equ >8f00             ; ctrl + o
0077      9000     key.ctrl.p    equ >9000             ; ctrl + p
0078      9100     key.ctrl.q    equ >9100             ; ctrl + q
0079      9200     key.ctrl.r    equ >9200             ; ctrl + r
0080      9300     key.ctrl.s    equ >9300             ; ctrl + s
0081      9400     key.ctrl.t    equ >9400             ; ctrl + t
0082      9500     key.ctrl.u    equ >9500             ; ctrl + u
0083      9600     key.ctrl.v    equ >9600             ; ctrl + v
0084      9700     key.ctrl.w    equ >9700             ; ctrl + w
0085      9800     key.ctrl.x    equ >9800             ; ctrl + x
0086      9900     key.ctrl.y    equ >9900             ; ctrl + y
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
**** **** ****     > ram.resident.3000.asm
0019                       ;------------------------------------------------------
0020                       ; End of File marker
0021                       ;------------------------------------------------------
0022 38E6 DEAD             data  >dead,>beef,>dead,>beef
     38E8 BEEF 
     38EA DEAD 
     38EC BEEF 
**** **** ****     > stevie_b2.asm.3164438
0066               ***************************************************************
0067               * Step 4: Include modules
0068               ********|*****|*********************|**************************
0069               main:
0070                       aorg  kickstart.code2       ; >6036
0071 6036 06A0  32         bl    @cpu.crash            ; Should never get here
     6038 2026 
0072                       ;-----------------------------------------------------------------------
0073                       ; Include files - Utility functions
0074                       ;-----------------------------------------------------------------------
0075                       copy  "colors.line.set.asm" ; Set color combination for line
**** **** ****     > colors.line.set.asm
0001               * FILE......: colors.line.set
0002               * Purpose...: Set color combination for line
0003               
0004               ***************************************************************
0005               * colors.line.set
0006               * Set color combination for line in VDP TAT
0007               ***************************************************************
0008               * bl  @colors.line.set
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Foreground / Background color
0012               * @parm2 = Row on physical screen
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               ********|*****|*********************|**************************
0020               colors.line.set:
0021 603A 0649  14         dect  stack
0022 603C C64B  30         mov   r11,*stack            ; Save return address
0023 603E 0649  14         dect  stack
0024 6040 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6042 0649  14         dect  stack
0026 6044 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6046 0649  14         dect  stack
0028 6048 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 604A 0649  14         dect  stack
0030 604C C660  46         mov   @parm1,*stack         ; Push parm1
     604E 2F20 
0031 6050 0649  14         dect  stack
0032 6052 C660  46         mov   @parm2,*stack         ; Push parm2
     6054 2F22 
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 6056 C120  34         mov   @parm2,tmp0           ; Get target line
     6058 2F22 
0037 605A 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     605C 0050 
0038 605E 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 6060 C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 6062 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     6064 1800 
0042 6066 C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     6068 2F20 
0043 606A 0206  20         li    tmp2,80               ; Number of bytes to fill
     606C 0050 
0044               
0045 606E 06A0  32         bl    @xfilv                ; Fill colors
     6070 2298 
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 6072 C839  50         mov   *stack+,@parm2        ; Pop @parm2
     6074 2F22 
0054 6076 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6078 2F20 
0055 607A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 607C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 607E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 6080 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6082 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.3164438
0076                       ;-----------------------------------------------------------------------
0077                       ; File handling
0078                       ;-----------------------------------------------------------------------
0079                       copy  "fh.read.edb.asm"     ; Read file to editor buffer
**** **** ****     > fh.read.edb.asm
0001               * FILE......: fh.read.edb.asm
0002               * Purpose...: File reader module
0003               
0004               ***************************************************************
0005               * fh.file.read.edb
0006               * Read file into editor buffer
0007               ***************************************************************
0008               *  bl   @fh.file.read.edb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1 = Pointer to length-prefixed file descriptor
0012               * parm2 = Pointer to callback function "Before Open file"
0013               * parm3 = Pointer to callback function "Read line from file"
0014               * parm4 = Pointer to callback function "Close file"
0015               * parm5 = Pointer to callback function "File I/O error"
0016               * parm6 = Pointer to callback function "Memory full"
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0, tmp1, tmp2
0022               ********|*****|*********************|**************************
0023               fh.file.read.edb:
0024 6084 0649  14         dect  stack
0025 6086 C64B  30         mov   r11,*stack            ; Save return address
0026 6088 0649  14         dect  stack
0027 608A C644  30         mov   tmp0,*stack           ; Push tmp0
0028 608C 0649  14         dect  stack
0029 608E C645  30         mov   tmp1,*stack           ; Push tmp1
0030 6090 0649  14         dect  stack
0031 6092 C646  30         mov   tmp2,*stack           ; Push tmp2
0032                       ;------------------------------------------------------
0033                       ; Initialisation
0034                       ;------------------------------------------------------
0035 6094 04E0  34         clr   @fh.records           ; Reset records counter
     6096 A43C 
0036 6098 04E0  34         clr   @fh.counter           ; Clear internal counter
     609A A442 
0037 609C 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     609E A440 
0038 60A0 04E0  34         clr   @fh.kilobytes.prev    ; /
     60A2 A45A 
0039 60A4 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     60A6 A438 
0040 60A8 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     60AA A43A 
0041               
0042 60AC C120  34         mov   @edb.top.ptr,tmp0
     60AE A200 
0043 60B0 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     60B2 2542 
0044                                                   ; \ i  tmp0  = Memory address
0045                                                   ; | o  waux1 = SAMS page number
0046                                                   ; / o  waux2 = Address of SAMS register
0047               
0048 60B4 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     60B6 833C 
     60B8 A446 
0049 60BA C820  54         mov   @waux1,@fh.sams.hipage
     60BC 833C 
     60BE A448 
0050                                                   ; Set highest SAMS page in use
0051                       ;------------------------------------------------------
0052                       ; Save parameters / callback functions
0053                       ;------------------------------------------------------
0054 60C0 0204  20         li    tmp0,fh.fopmode.readfile
     60C2 0001 
0055                                                   ; We are going to read a file
0056 60C4 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     60C6 A44A 
0057               
0058 60C8 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     60CA 2F20 
     60CC A444 
0059 60CE C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     60D0 2F22 
     60D2 A450 
0060 60D4 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     60D6 2F24 
     60D8 A452 
0061 60DA C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     60DC 2F26 
     60DE A454 
0062 60E0 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     60E2 2F28 
     60E4 A456 
0063 60E6 C820  54         mov   @parm6,@fh.callback5  ; Callback function "Memory full error"
     60E8 2F2A 
     60EA A458 
0064                       ;------------------------------------------------------
0065                       ; Asserts
0066                       ;------------------------------------------------------
0067 60EC C120  34         mov   @fh.callback1,tmp0
     60EE A450 
0068 60F0 0284  22         ci    tmp0,>6000            ; Insane address ?
     60F2 6000 
0069 60F4 1124  14         jlt   fh.file.read.crash    ; Yes, crash!
0070 60F6 0284  22         ci    tmp0,>7fff            ; Insane address ?
     60F8 7FFF 
0071 60FA 1521  14         jgt   fh.file.read.crash    ; Yes, crash!
0072               
0073 60FC C120  34         mov   @fh.callback2,tmp0
     60FE A452 
0074 6100 0284  22         ci    tmp0,>6000            ; Insane address ?
     6102 6000 
0075 6104 111C  14         jlt   fh.file.read.crash    ; Yes, crash!
0076 6106 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6108 7FFF 
0077 610A 1519  14         jgt   fh.file.read.crash    ; Yes, crash!
0078               
0079 610C C120  34         mov   @fh.callback3,tmp0
     610E A454 
0080 6110 0284  22         ci    tmp0,>6000            ; Insane address ?
     6112 6000 
0081 6114 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0082 6116 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6118 7FFF 
0083 611A 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0084               
0085 611C C120  34         mov   @fh.callback4,tmp0
     611E A456 
0086 6120 0284  22         ci    tmp0,>6000            ; Insane address ?
     6122 6000 
0087 6124 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0088 6126 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6128 7FFF 
0089 612A 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0090               
0091 612C C120  34         mov   @fh.callback5,tmp0
     612E A458 
0092 6130 0284  22         ci    tmp0,>6000            ; Insane address ?
     6132 6000 
0093 6134 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0094 6136 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6138 7FFF 
0095 613A 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0096               
0097 613C 1004  14         jmp   fh.file.read.edb.load1
0098                                                   ; All checks passed, continue
0099                       ;------------------------------------------------------
0100                       ; Check failed, crash CPU!
0101                       ;------------------------------------------------------
0102               fh.file.read.crash:
0103 613E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6140 FFCE 
0104 6142 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6144 2026 
0105                       ;------------------------------------------------------
0106                       ; Callback "Before Open file"
0107                       ;------------------------------------------------------
0108               fh.file.read.edb.load1:
0109 6146 C120  34         mov   @fh.callback1,tmp0
     6148 A450 
0110 614A 0694  24         bl    *tmp0                 ; Run callback function
0111                       ;------------------------------------------------------
0112                       ; Copy PAB header to VDP
0113                       ;------------------------------------------------------
0114               fh.file.read.edb.pabheader:
0115 614C 06A0  32         bl    @cpym2v
     614E 248A 
0116 6150 0A60                   data fh.vpab,fh.file.pab.header,9
     6152 62E8 
     6154 0009 
0117                                                   ; Copy PAB header to VDP
0118                       ;------------------------------------------------------
0119                       ; Append file descriptor to PAB header in VDP
0120                       ;------------------------------------------------------
0121 6156 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6158 0A69 
0122 615A C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     615C A444 
0123 615E D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0124 6160 0986  56         srl   tmp2,8                ; Right justify
0125 6162 0586  14         inc   tmp2                  ; Include length byte as well
0126               
0127 6164 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     6166 2490 
0128                                                   ; \ i  tmp0 = VDP destination
0129                                                   ; | i  tmp1 = CPU source
0130                                                   ; / i  tmp2 = Number of bytes to copy
0131                       ;------------------------------------------------------
0132                       ; Open file
0133                       ;------------------------------------------------------
0134 6168 06A0  32         bl    @file.open            ; Open file
     616A 2C92 
0135 616C 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0136 616E 0014                   data io.seq.inp.dis.var
0137                                                   ; / i  p1 = File type/mode
0138               
0139 6170 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6172 201C 
0140 6174 1602  14         jne   fh.file.read.edb.check_setpage
0141               
0142 6176 0460  28         b     @fh.file.read.edb.error
     6178 62A2 
0143                                                   ; Yes, IO error occured
0144                       ;------------------------------------------------------
0145                       ; 1a: Check if SAMS page needs to be increased
0146                       ;------------------------------------------------------
0147               fh.file.read.edb.check_setpage:
0148 617A C120  34         mov   @edb.next_free.ptr,tmp0
     617C A208 
0149                                                   ;--------------------------
0150                                                   ; Assert
0151                                                   ;--------------------------
0152 617E 0284  22         ci    tmp0,edb.top + edb.size
     6180 D000 
0153                                                   ; Insane address ?
0154 6182 15DD  14         jgt   fh.file.read.crash    ; Yes, crash!
0155                                                   ;--------------------------
0156                                                   ; Check for page overflow
0157                                                   ;--------------------------
0158 6184 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6186 0FFF 
0159 6188 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     618A 0052 
0160 618C 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     618E 0FF0 
0161 6190 110E  14         jlt   fh.file.read.edb.record
0162                                                   ; Not yet so skip SAMS page switch
0163                       ;------------------------------------------------------
0164                       ; 1b: Increase SAMS page
0165                       ;------------------------------------------------------
0166 6192 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     6194 A446 
0167 6196 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     6198 A446 
     619A A448 
0168                                                   ; Set highest SAMS page
0169 619C C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     619E A200 
     61A0 A208 
0170                                                   ; Start at top of SAMS page again
0171                       ;------------------------------------------------------
0172                       ; 1c: Switch to SAMS page
0173                       ;------------------------------------------------------
0174 61A2 C120  34         mov   @fh.sams.page,tmp0
     61A4 A446 
0175 61A6 C160  34         mov   @edb.top.ptr,tmp1
     61A8 A200 
0176 61AA 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     61AC 257A 
0177                                                   ; \ i  tmp0 = SAMS page number
0178                                                   ; / i  tmp1 = Memory address
0179                       ;------------------------------------------------------
0180                       ; 1d: Fill new SAMS page with garbage (debug only)
0181                       ;------------------------------------------------------
0182                       ; bl  @film
0183                       ;     data >c000,>99,4092
0184                       ;------------------------------------------------------
0185                       ; Step 2: Read file record
0186                       ;------------------------------------------------------
0187               fh.file.read.edb.record:
0188 61AE 05A0  34         inc   @fh.records           ; Update counter
     61B0 A43C 
0189 61B2 04E0  34         clr   @fh.reclen            ; Reset record length
     61B4 A43E 
0190               
0191 61B6 0760  38         abs   @fh.offsetopcode
     61B8 A44E 
0192 61BA 1310  14         jeq   !                     ; Skip CPU buffer logic if offset = 0
0193                       ;------------------------------------------------------
0194                       ; 2a: Write address of CPU buffer to VDP PAB bytes 2-3
0195                       ;------------------------------------------------------
0196 61BC C160  34         mov   @edb.next_free.ptr,tmp1
     61BE A208 
0197 61C0 05C5  14         inct  tmp1
0198 61C2 0204  20         li    tmp0,fh.vpab + 2
     61C4 0A62 
0199               
0200 61C6 0264  22         ori   tmp0,>4000            ; Prepare VDP address for write
     61C8 4000 
0201 61CA 06C4  14         swpb  tmp0                  ; \
0202 61CC D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     61CE 8C02 
0203 61D0 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0204 61D2 D804  38         movb  tmp0,@vdpa            ; /
     61D4 8C02 
0205               
0206 61D6 D7C5  30         movb  tmp1,*r15             ; Write MSB
0207 61D8 06C5  14         swpb  tmp1
0208 61DA D7C5  30         movb  tmp1,*r15             ; Write LSB
0209                       ;------------------------------------------------------
0210                       ; 2b: Read file record
0211                       ;------------------------------------------------------
0212 61DC 06A0  32 !       bl    @file.record.read     ; Read file record
     61DE 2CC2 
0213 61E0 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0214                                                   ; |           (without +9 offset!)
0215                                                   ; | o  tmp0 = Status byte
0216                                                   ; | o  tmp1 = Bytes read
0217                                                   ; | o  tmp2 = Status register contents
0218                                                   ; /           upon DSRLNK return
0219               
0220 61E2 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     61E4 A438 
0221 61E6 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     61E8 A43E 
0222 61EA C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     61EC A43A 
0223                       ;------------------------------------------------------
0224                       ; 2c: Calculate kilobytes processed
0225                       ;------------------------------------------------------
0226 61EE A805  38         a     tmp1,@fh.counter      ; Add record length to counter
     61F0 A442 
0227 61F2 C160  34         mov   @fh.counter,tmp1      ;
     61F4 A442 
0228 61F6 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     61F8 0400 
0229 61FA 1106  14         jlt   fh.file.read.edb.check_fioerr
0230                                                   ; Not yet, goto (2d)
0231 61FC 05A0  34         inc   @fh.kilobytes
     61FE A440 
0232 6200 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     6202 FC00 
0233 6204 C805  38         mov   tmp1,@fh.counter      ; Update counter
     6206 A442 
0234                       ;------------------------------------------------------
0235                       ; 2d: Check if a file error occured
0236                       ;------------------------------------------------------
0237               fh.file.read.edb.check_fioerr:
0238 6208 C1A0  34         mov   @fh.ioresult,tmp2
     620A A43A 
0239 620C 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     620E 201C 
0240 6210 1602  14         jne   fh.file.read.edb.process_line
0241                                                   ; No, goto (3)
0242 6212 0460  28         b     @fh.file.read.edb.error
     6214 62A2 
0243                                                   ; Yes, so handle file error
0244                       ;------------------------------------------------------
0245                       ; Step 3: Process line
0246                       ;------------------------------------------------------
0247               fh.file.read.edb.process_line:
0248 6216 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6218 0960 
0249 621A C160  34         mov   @edb.next_free.ptr,tmp1
     621C A208 
0250                                                   ; RAM target in editor buffer
0251               
0252 621E C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6220 2F22 
0253               
0254 6222 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6224 A43E 
0255 6226 131D  14         jeq   fh.file.read.edb.prepindex.emptyline
0256                                                   ; Handle empty line
0257                       ;------------------------------------------------------
0258                       ; 3a: Set length of line in CPU editor buffer
0259                       ;------------------------------------------------------
0260 6228 04D5  26         clr   *tmp1                 ; Clear word before string
0261 622A 0585  14         inc   tmp1                  ; Adjust position for length byte string
0262 622C DD60  48         movb  @fh.reclen+1,*tmp1+   ; Put line length byte before string
     622E A43F 
0263               
0264 6230 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6232 A208 
0265 6234 A806  38         a     tmp2,@edb.next_free.ptr
     6236 A208 
0266                                                   ; Add line length
0267               
0268 6238 0760  38         abs   @fh.offsetopcode      ; Use CPU buffer if offset > 0
     623A A44E 
0269 623C 1602  14         jne   fh.file.read.edb.preppointer
0270                       ;------------------------------------------------------
0271                       ; 3b: Copy line from VDP to CPU editor buffer
0272                       ;------------------------------------------------------
0273               fh.file.read.edb.vdp2cpu:
0274                       ;
0275                       ; Executed for devices that need their disk buffer in VDP memory
0276                       ; (TI Disk Controller, tipi, nanopeb, ...).
0277                       ;
0278 623E 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6240 24C2 
0279                                                   ; \ i  tmp0 = VDP source address
0280                                                   ; | i  tmp1 = RAM target address
0281                                                   ; / i  tmp2 = Bytes to copy
0282                       ;------------------------------------------------------
0283                       ; 3c: Align pointer for next line
0284                       ;------------------------------------------------------
0285               fh.file.read.edb.preppointer:
0286 6242 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6244 A208 
0287 6246 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0288 6248 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     624A 000F 
0289 624C A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     624E A208 
0290                       ;------------------------------------------------------
0291                       ; Step 4: Update index
0292                       ;------------------------------------------------------
0293               fh.file.read.edb.prepindex:
0294 6250 C820  54         mov   @edb.lines,@parm1     ; \ parm1 = Line number - 1
     6252 A204 
     6254 2F20 
0295 6256 0620  34         dec   @parm1                ; /
     6258 2F20 
0296               
0297                                                   ; parm2 = Must allready be set!
0298 625A C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     625C A446 
     625E 2F24 
0299               
0300 6260 1009  14         jmp   fh.file.read.edb.updindex
0301                                                   ; Update index
0302                       ;------------------------------------------------------
0303                       ; 4a: Special handling for empty line
0304                       ;------------------------------------------------------
0305               fh.file.read.edb.prepindex.emptyline:
0306 6262 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     6264 A43C 
     6266 2F20 
0307 6268 0620  34         dec   @parm1                ;         Adjust for base 0 index
     626A 2F20 
0308 626C 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     626E 2F22 
0309 6270 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     6272 2F24 
0310                       ;------------------------------------------------------
0311                       ; 4b: Do actual index update
0312                       ;------------------------------------------------------
0313               fh.file.read.edb.updindex:
0314 6274 06A0  32         bl    @idx.entry.update     ; Update index
     6276 683A 
0315                                                   ; \ i  parm1    = Line num in editor buffer
0316                                                   ; | i  parm2    = Pointer to line in EB
0317                                                   ; | i  parm3    = SAMS page
0318                                                   ; | o  outparm1 = Pointer to updated index
0319                                                   ; /               entry
0320                       ;------------------------------------------------------
0321                       ; Step 5: Callback "Read line from file"
0322                       ;------------------------------------------------------
0323               fh.file.read.edb.display:
0324 6278 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     627A A452 
0325 627C 0694  24         bl    *tmp0                 ; Run callback function
0326                       ;------------------------------------------------------
0327                       ; 5a: Prepare for next record
0328                       ;------------------------------------------------------
0329               fh.file.read.edb.next:
0330 627E 05A0  34         inc   @edb.lines            ; lines=lines+1
     6280 A204 
0331               
0332 6282 C120  34         mov   @edb.lines,tmp0
     6284 A204 
0333 6286 0284  22         ci    tmp0,10200            ; Maximum line in index reached?
     6288 27D8 
0334 628A 1209  14         jle   fh.file.read.edb.next.do_it
0335                                                   ; Not yet, next record
0336                       ;------------------------------------------------------
0337                       ; 5b: Index memory full. Close file and exit
0338                       ;------------------------------------------------------
0339 628C 06A0  32         bl    @file.close           ; Close file
     628E 2CB6 
0340 6290 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0341                                                   ; /
0342               
0343 6292 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6294 337A 
0344                       ;------------------------------------------------------
0345                       ; Callback "Memory full error"
0346                       ;------------------------------------------------------
0347 6296 C120  34         mov   @fh.callback5,tmp0    ; Get pointer to Callback "File I/O error"
     6298 A458 
0348 629A 0694  24         bl    *tmp0                 ; Run callback function
0349 629C 101B  14         jmp   fh.file.read.edb.exit
0350                       ;------------------------------------------------------
0351                       ; 5c: Next record
0352                       ;------------------------------------------------------
0353               fh.file.read.edb.next.do_it:
0354 629E 0460  28         b     @fh.file.read.edb.check_setpage
     62A0 617A 
0355                                                   ; Next record
0356                       ;------------------------------------------------------
0357                       ; Error handler
0358                       ;------------------------------------------------------
0359               fh.file.read.edb.error:
0360 62A2 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     62A4 A438 
0361 62A6 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0362 62A8 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     62AA 0005 
0363 62AC 1309  14         jeq   fh.file.read.edb.eof  ; All good. File closed by DSRLNK
0364                       ;------------------------------------------------------
0365                       ; File error occured
0366                       ;------------------------------------------------------
0367 62AE 06A0  32         bl    @file.close           ; Close file
     62B0 2CB6 
0368 62B2 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0369                                                   ; /
0370               
0371 62B4 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     62B6 337A 
0372                       ;------------------------------------------------------
0373                       ; Callback "File I/O error"
0374                       ;------------------------------------------------------
0375 62B8 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     62BA A456 
0376 62BC 0694  24         bl    *tmp0                 ; Run callback function
0377 62BE 100A  14         jmp   fh.file.read.edb.exit
0378                       ;------------------------------------------------------
0379                       ; End-Of-File reached
0380                       ;------------------------------------------------------
0381               fh.file.read.edb.eof:
0382 62C0 06A0  32         bl    @file.close           ; Close file
     62C2 2CB6 
0383 62C4 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0384                                                   ; /
0385               
0386 62C6 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     62C8 337A 
0387                       ;------------------------------------------------------
0388                       ; Callback "Close file"
0389                       ;------------------------------------------------------
0390 62CA 0620  34         dec   @edb.lines
     62CC A204 
0391 62CE C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     62D0 A454 
0392 62D2 0694  24         bl    *tmp0                 ; Run callback function
0393               *--------------------------------------------------------------
0394               * Exit
0395               *--------------------------------------------------------------
0396               fh.file.read.edb.exit:
0397 62D4 C820  54         mov   @fh.sams.hipage,@edb.sams.hipage
     62D6 A448 
     62D8 A218 
0398                                                   ; Set highest SAMS page in use
0399 62DA 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     62DC A44A 
0400               
0401 62DE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0402 62E0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0403 62E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0404 62E4 C2F9  30         mov   *stack+,r11           ; Pop R11
0405 62E6 045B  20         b     *r11                  ; Return to caller
0406               
0407               
0408               ***************************************************************
0409               * PAB for accessing DV/80 file
0410               ********|*****|*********************|**************************
0411               fh.file.pab.header:
0412 62E8 0014             byte  io.op.open            ;  0    - OPEN
0413                       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
0414 62EA 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0415 62EC 5000             byte  80                    ;  4    - Record length (80 chars max)
0416                       byte  00                    ;  5    - Character count
0417 62EE 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0418 62F0 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0419                       ;------------------------------------------------------
0420                       ; File descriptor part (variable length)
0421                       ;------------------------------------------------------
0422                       ; byte  12                  ;  9    - File descriptor length
0423                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0424                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b2.asm.3164438
0080                       copy  "fh.write.edb.asm"    ; Write editor buffer to file
**** **** ****     > fh.write.edb.asm
0001               * FILE......: fh.write.edb.asm
0002               * Purpose...: File write module
0003               
0004               ***************************************************************
0005               * fh.file.write.edb
0006               * Write editor buffer to file
0007               ***************************************************************
0008               *  bl   @fh.file.write.edb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1 = Pointer to length-prefixed file descriptor
0012               * parm2 = Pointer to callback function "Before Open file"
0013               * parm3 = Pointer to callback function "Write line to file"
0014               * parm4 = Pointer to callback function "Close file"
0015               * parm5 = Pointer to callback function "File I/O error"
0016               * parm6 = First line to save (base 0)
0017               * parm7 = Last line to save  (base 0)
0018               *--------------------------------------------------------------
0019               * OUTPUT
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0, tmp1, tmp2
0023               ********|*****|*********************|**************************
0024               fh.file.write.edb:
0025 62F2 0649  14         dect  stack
0026 62F4 C64B  30         mov   r11,*stack            ; Save return address
0027 62F6 0649  14         dect  stack
0028 62F8 C644  30         mov   tmp0,*stack           ; Push tmp0
0029 62FA 0649  14         dect  stack
0030 62FC C645  30         mov   tmp1,*stack           ; Push tmp1
0031 62FE 0649  14         dect  stack
0032 6300 C646  30         mov   tmp2,*stack           ; Push tmp2
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 6302 04E0  34         clr   @fh.counter           ; Clear internal counter
     6304 A442 
0037 6306 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6308 A440 
0038 630A 04E0  34         clr   @fh.kilobytes.prev    ; /
     630C A45A 
0039 630E 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6310 A438 
0040 6312 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6314 A43A 
0041                       ;------------------------------------------------------
0042                       ; Save parameters / callback functions
0043                       ;------------------------------------------------------
0044 6316 0204  20         li    tmp0,fh.fopmode.writefile
     6318 0002 
0045                                                   ; We are going to write to a file
0046 631A C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     631C A44A 
0047               
0048 631E C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6320 2F20 
     6322 A444 
0049 6324 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6326 2F22 
     6328 A450 
0050 632A C820  54         mov   @parm3,@fh.callback2  ; Callback function "Write line to file"
     632C 2F24 
     632E A452 
0051 6330 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6332 2F26 
     6334 A454 
0052 6336 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6338 2F28 
     633A A456 
0053 633C C820  54         mov   @parm6,@fh.records    ; Set records counter
     633E 2F2A 
     6340 A43C 
0054                       ;------------------------------------------------------
0055                       ; Assert
0056                       ;------------------------------------------------------
0057 6342 C120  34         mov   @fh.callback1,tmp0
     6344 A450 
0058 6346 0284  22         ci    tmp0,>6000            ; Insane address ?
     6348 6000 
0059 634A 111C  14         jlt   fh.file.write.crash   ; Yes, crash!
0060               
0061 634C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     634E 7FFF 
0062 6350 1519  14         jgt   fh.file.write.crash   ; Yes, crash!
0063               
0064 6352 C120  34         mov   @fh.callback2,tmp0
     6354 A452 
0065 6356 0284  22         ci    tmp0,>6000            ; Insane address ?
     6358 6000 
0066 635A 1114  14         jlt   fh.file.write.crash   ; Yes, crash!
0067               
0068 635C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     635E 7FFF 
0069 6360 1511  14         jgt   fh.file.write.crash   ; Yes, crash!
0070               
0071 6362 C120  34         mov   @fh.callback3,tmp0
     6364 A454 
0072 6366 0284  22         ci    tmp0,>6000            ; Insane address ?
     6368 6000 
0073 636A 110C  14         jlt   fh.file.write.crash   ; Yes, crash!
0074               
0075 636C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     636E 7FFF 
0076 6370 1509  14         jgt   fh.file.write.crash   ; Yes, crash!
0077               
0078 6372 8820  54         c     @parm6,@edb.lines     ; First line to save beyond last line in EB?
     6374 2F2A 
     6376 A204 
0079 6378 1505  14         jgt   fh.file.write.crash   ; Yes, crash!
0080               
0081 637A 8820  54         c     @parm7,@edb.lines     ; Last line to save beyond last line in EB?
     637C 2F2C 
     637E A204 
0082 6380 1501  14         jgt   fh.file.write.crash   ; Yes, crash!
0083               
0084 6382 1004  14         jmp   fh.file.write.edb.save1
0085                                                   ; All checks passed, continue.
0086                       ;------------------------------------------------------
0087                       ; Check failed, crash CPU!
0088                       ;------------------------------------------------------
0089               fh.file.write.crash:
0090 6384 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6386 FFCE 
0091 6388 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     638A 2026 
0092                       ;------------------------------------------------------
0093                       ; Callback "Before Open file"
0094                       ;------------------------------------------------------
0095               fh.file.write.edb.save1:
0096 638C C120  34         mov   @fh.callback1,tmp0
     638E A450 
0097 6390 0694  24         bl    *tmp0                 ; Run callback function
0098                       ;------------------------------------------------------
0099                       ; Copy PAB header to VDP
0100                       ;------------------------------------------------------
0101               fh.file.write.edb.pabheader:
0102 6392 06A0  32         bl    @cpym2v
     6394 248A 
0103 6396 0A60                   data fh.vpab,fh.file.pab.header,9
     6398 62E8 
     639A 0009 
0104                                                   ; Copy PAB header to VDP
0105                       ;------------------------------------------------------
0106                       ; Append file descriptor to PAB header in VDP
0107                       ;------------------------------------------------------
0108 639C 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     639E 0A69 
0109 63A0 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     63A2 A444 
0110 63A4 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0111 63A6 0986  56         srl   tmp2,8                ; Right justify
0112 63A8 0586  14         inc   tmp2                  ; Include length byte as well
0113               
0114 63AA 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     63AC 2490 
0115                                                   ; \ i  tmp0 = VDP destination
0116                                                   ; | i  tmp1 = CPU source
0117                                                   ; / i  tmp2 = Number of bytes to copy
0118                       ;------------------------------------------------------
0119                       ; Open file
0120                       ;------------------------------------------------------
0121 63AE 06A0  32         bl    @file.open            ; Open file
     63B0 2C92 
0122 63B2 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0123 63B4 0012                   data io.seq.out.dis.var
0124                                                   ; / i  p1 = File type/mode
0125               
0126 63B6 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     63B8 201C 
0127 63BA 1338  14         jeq   fh.file.write.edb.error
0128                                                   ; Yes, IO error occured
0129                       ;------------------------------------------------------
0130                       ; Step 1: Write file record
0131                       ;------------------------------------------------------
0132               fh.file.write.edb.record:
0133 63BC 8820  54         c     @fh.records,@parm7
     63BE A43C 
     63C0 2F2C 
0134 63C2 133E  14         jeq   fh.file.write.edb.done
0135                                                   ; Exit when all records processed
0136                       ;------------------------------------------------------
0137                       ; 1a: Unpack current line to framebuffer
0138                       ;------------------------------------------------------
0139 63C4 C820  54         mov   @fh.records,@parm1    ; Line to unpack
     63C6 A43C 
     63C8 2F20 
0140 63CA 04E0  34         clr   @parm2                ; 1st row in frame buffer
     63CC 2F22 
0141               
0142 63CE 06A0  32         bl    @edb.line.unpack      ; Unpack line
     63D0 685E 
0143                                                   ; \ i  parm1    = Line to unpack
0144                                                   ; | i  parm2    = Target row in frame buffer
0145                                                   ; / o  outparm1 = Length of line
0146                       ;------------------------------------------------------
0147                       ; 1b: Copy unpacked line to VDP memory
0148                       ;------------------------------------------------------
0149 63D2 0204  20         li    tmp0,fh.vrecbuf       ; VDP target address
     63D4 0960 
0150 63D6 0205  20         li    tmp1,fb.top           ; Top of frame buffer in CPU memory
     63D8 A600 
0151               
0152 63DA C1A0  34         mov   @outparm1,tmp2        ; Length of line
     63DC 2F30 
0153 63DE C806  38         mov   tmp2,@fh.reclen       ; Set record length
     63E0 A43E 
0154 63E2 1302  14         jeq   !                     ; Skip VDP copy if empty line
0155               
0156 63E4 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     63E6 2490 
0157                                                   ; \ i  tmp0 = VDP target address
0158                                                   ; | i  tmp1 = CPU source address
0159                                                   ; / i  tmp2 = Number of bytes to copy
0160                       ;------------------------------------------------------
0161                       ; 1c: Write file record
0162                       ;------------------------------------------------------
0163 63E8 06A0  32 !       bl    @file.record.write    ; Write file record
     63EA 2CCE 
0164 63EC 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0165                                                   ; |           (without +9 offset!)
0166                                                   ; | o  tmp0 = Status byte
0167                                                   ; | o  tmp1 = ?????
0168                                                   ; | o  tmp2 = Status register contents
0169                                                   ; /           upon DSRLNK return
0170               
0171 63EE C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     63F0 A438 
0172 63F2 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     63F4 A43A 
0173                       ;------------------------------------------------------
0174                       ; 1d: Calculate kilobytes processed
0175                       ;------------------------------------------------------
0176 63F6 A820  54         a     @fh.reclen,@fh.counter
     63F8 A43E 
     63FA A442 
0177                                                   ; Add record length to counter
0178 63FC C160  34         mov   @fh.counter,tmp1      ;
     63FE A442 
0179 6400 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     6402 0400 
0180 6404 1106  14         jlt   fh.file.write.edb.check_fioerr
0181                                                   ; Not yet, goto (1e)
0182 6406 05A0  34         inc   @fh.kilobytes
     6408 A440 
0183 640A 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     640C FC00 
0184 640E C805  38         mov   tmp1,@fh.counter      ; Update counter
     6410 A442 
0185                       ;------------------------------------------------------
0186                       ; 1e: Check if a file error occured
0187                       ;------------------------------------------------------
0188               fh.file.write.edb.check_fioerr:
0189 6412 C1A0  34         mov   @fh.ioresult,tmp2
     6414 A43A 
0190 6416 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6418 201C 
0191 641A 1602  14         jne   fh.file.write.edb.display
0192                                                   ; No, goto (2)
0193 641C 0460  28         b     @fh.file.write.edb.error
     641E 642C 
0194                                                   ; Yes, so handle file error
0195                       ;------------------------------------------------------
0196                       ; Step 2: Callback "Write line to  file"
0197                       ;------------------------------------------------------
0198               fh.file.write.edb.display:
0199 6420 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Saving indicator 2"
     6422 A452 
0200 6424 0694  24         bl    *tmp0                 ; Run callback function
0201                       ;------------------------------------------------------
0202                       ; Step 3: Next record
0203                       ;------------------------------------------------------
0204 6426 05A0  34         inc   @fh.records           ; Update counter
     6428 A43C 
0205 642A 10C8  14         jmp   fh.file.write.edb.record
0206                       ;------------------------------------------------------
0207                       ; Error handler
0208                       ;------------------------------------------------------
0209               fh.file.write.edb.error:
0210 642C C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     642E A438 
0211 6430 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0212                       ;------------------------------------------------------
0213                       ; File error occured
0214                       ;------------------------------------------------------
0215 6432 06A0  32         bl    @file.close           ; Close file
     6434 2CB6 
0216 6436 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0217                       ;------------------------------------------------------
0218                       ; Callback "File I/O error"
0219                       ;------------------------------------------------------
0220 6438 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     643A A456 
0221 643C 0694  24         bl    *tmp0                 ; Run callback function
0222 643E 1006  14         jmp   fh.file.write.edb.exit
0223                       ;------------------------------------------------------
0224                       ; All records written. Close file
0225                       ;------------------------------------------------------
0226               fh.file.write.edb.done:
0227 6440 06A0  32         bl    @file.close           ; Close file
     6442 2CB6 
0228 6444 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0229                       ;------------------------------------------------------
0230                       ; Callback "Close file"
0231                       ;------------------------------------------------------
0232 6446 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     6448 A454 
0233 644A 0694  24         bl    *tmp0                 ; Run callback function
0234               *--------------------------------------------------------------
0235               * Exit
0236               *--------------------------------------------------------------
0237               fh.file.write.edb.exit:
0238 644C 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     644E A44A 
0239 6450 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0240 6452 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0241 6454 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0242 6456 C2F9  30         mov   *stack+,r11           ; Pop R11
0243 6458 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.3164438
0081                       copy  "fm.load.asm"         ; Load DV80 file into editor buffer
**** **** ****     > fm.load.asm
0001               * FILE......: fm.load.asm
0002               * Purpose...: File Manager - Load file into editor buffer
0003               
0004               ***************************************************************
0005               * fm.loadfile
0006               * Load file into editor buffer
0007               ***************************************************************
0008               * bl  @fm.loadfile
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1  = Pointer to length-prefixed string containing both
0012               *          device and filename
0013               *---------------------------------------------------------------
0014               * OUTPUT
0015               * outparm1 = >FFFF if editor bufer dirty (does not load file)
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1
0019               ********|*****|*********************|**************************
0020               fm.loadfile:
0021 645A 0649  14         dect  stack
0022 645C C64B  30         mov   r11,*stack            ; Save return address
0023 645E 0649  14         dect  stack
0024 6460 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6462 0649  14         dect  stack
0026 6464 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6466 0649  14         dect  stack
0028 6468 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;-------------------------------------------------------
0030                       ; Exit early if editor buffer is dirty
0031                       ;-------------------------------------------------------
0032 646A C160  34         mov   @edb.dirty,tmp1       ; Get dirty flag
     646C A206 
0033 646E 1303  14         jeq   !                     ; Load file if not dirty
0034               
0035 6470 0720  34         seto  @outparm1             ; \
     6472 2F30 
0036 6474 104E  14         jmp   fm.loadfile.exit      ; / Editor buffer dirty, exit early
0037               
0038                       ;-------------------------------------------------------
0039                       ; Clear VDP screen buffer
0040                       ;-------------------------------------------------------
0041 6476 06A0  32 !       bl    @filv
     6478 2292 
0042 647A 2180                   data sprsat,>0000,16  ; Turn off sprites (cursor)
     647C 0000 
     647E 0010 
0043               
0044 6480 C160  34         mov   @fb.scrrows.max,tmp1
     6482 A11C 
0045 6484 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6486 A10E 
0046                                                   ; 16 bit part is in tmp2!
0047               
0048 6488 06A0  32         bl    @scroff               ; Turn off screen
     648A 2692 
0049               
0050 648C 0204  20         li    tmp0,vdp.fb.toprow.sit
     648E 0050 
0051                                                   ; VDP target address (2nd row on screen!)
0052 6490 C160  34         mov   @tv.ruler.visible,tmp1
     6492 A010 
0053 6494 1302  14         jeq   fm.loadfile.clear     ; Skip if ruler is currently not shown
0054 6496 0224  22         ai    tmp0,80               ; Skip ruler line
     6498 0050 
0055               
0056               fm.loadfile.clear:
0057 649A 0205  20         li    tmp1,32               ; Character to fill
     649C 0020 
0058 649E 06A0  32         bl    @xfilv                ; Fill VDP memory
     64A0 2298 
0059                                                   ; \ i  tmp0 = VDP target address
0060                                                   ; | i  tmp1 = Byte to fill
0061                                                   ; / i  tmp2 = Bytes to copy
0062                       ;-------------------------------------------------------
0063                       ; Reload colorscheme
0064                       ;-------------------------------------------------------
0065 64A2 0649  14         dect  stack
0066 64A4 C660  46         mov   @parm1,*stack         ; Push @parm1
     64A6 2F20 
0067 64A8 0649  14         dect  stack
0068 64AA C660  46         mov   @parm2,*stack         ; Push @parm2
     64AC 2F22 
0069               
0070               
0071 64AE 0720  34         seto  @parm2                ; Skip marked lines colorization
     64B0 2F22 
0072 64B2 06A0  32         bl    @pane.action.colorscheme.load
     64B4 68A6 
0073                                                   ; Load color scheme and turn on screen
0074               
0075 64B6 C839  50         mov   *stack+,@parm2        ; Pop @parm2
     64B8 2F22 
0076 64BA C839  50         mov   *stack+,@parm1        ; Pop @parm1
     64BC 2F20 
0077                       ;-------------------------------------------------------
0078                       ; Reset editor
0079                       ;-------------------------------------------------------
0080 64BE 06A0  32         bl    @tv.reset             ; Reset editor
     64C0 32AC 
0081                       ;-------------------------------------------------------
0082                       ; Change filename
0083                       ;-------------------------------------------------------
0084 64C2 C120  34         mov   @parm1,tmp0           ; Source address
     64C4 2F20 
0085 64C6 0205  20         li    tmp1,edb.filename     ; Target address
     64C8 A21A 
0086 64CA 0206  20         li    tmp2,80               ; Number of bytes to copy
     64CC 0050 
0087 64CE C805  38         mov   tmp1,@edb.filename.ptr
     64D0 A212 
0088                                                   ; Set filename
0089               
0090 64D2 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     64D4 24E4 
0091                                                   ; tmp1 = Memory target address
0092                                                   ; tmp2 = Number of bytes to copy
0093                       ;-------------------------------------------------------
0094                       ; Read DV80 file and display
0095                       ;-------------------------------------------------------
0096 64D6 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     64D8 6594 
0097 64DA C804  38         mov   tmp0,@parm2           ; Register callback 1
     64DC 2F22 
0098               
0099 64DE 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     64E0 6622 
0100 64E2 C804  38         mov   tmp0,@parm3           ; Register callback 2
     64E4 2F24 
0101               
0102 64E6 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     64E8 6672 
0103 64EA C804  38         mov   tmp0,@parm4           ; Register callback 3
     64EC 2F26 
0104               
0105 64EE 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     64F0 66B8 
0106 64F2 C804  38         mov   tmp0,@parm5           ; Register callback 4
     64F4 2F28 
0107               
0108 64F6 0204  20         li    tmp0,fm.load.cb.memfull
     64F8 6752 
0109 64FA C804  38         mov   tmp0,@parm6           ; Register callback 5
     64FC 2F2A 
0110               
0111 64FE 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     6500 6084 
0112                                                   ; \ i  @parm1 = Pointer to length prefixed
0113                                                   ; |             file descriptor
0114                                                   ; | i  @parm2 = Pointer to callback
0115                                                   ; |             "Before Open file"
0116                                                   ; | i  @parm3 = Pointer to callback
0117                                                   ; |             "Read line from file"
0118                                                   ; | i  @parm4 = Pointer to callback
0119                                                   ; |             "Close file"
0120                                                   ; | i  @parm5 = Pointer to callback
0121                                                   ; |             "File I/O error"
0122                                                   ; | i  @parm6 = Pointer to callback
0123                                                   ; /             "Memory full error"
0124               
0125 6502 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6504 A206 
0126                                                   ; longer dirty.
0127               
0128 6506 0204  20         li    tmp0,txt.filetype.DV80
     6508 3534 
0129 650A C804  38         mov   tmp0,@edb.filetype.ptr
     650C A214 
0130                                                   ; Set filetype display string
0131               
0132 650E 04E0  34         clr   @outparm1             ; Reset
     6510 2F30 
0133               *--------------------------------------------------------------
0134               * Exit
0135               *--------------------------------------------------------------
0136               fm.loadfile.exit:
0137 6512 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0138 6514 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0139 6516 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0140 6518 C2F9  30         mov   *stack+,r11           ; Pop R11
0141 651A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.3164438
0082                       copy  "fm.save.asm"         ; Save DV80 file from editor buffer
**** **** ****     > fm.save.asm
0001               * FILE......: fm.save.asm
0002               * Purpose...: File Manager - Save file from editor buffer
0003               
0004               ***************************************************************
0005               * fm.savefile
0006               * Save file from editor buffer
0007               ***************************************************************
0008               * bl  @fm.savefile
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1  = Pointer to length-prefixed string containing both
0012               *          device and filename
0013               * parm2  = First line to save (base 0)
0014               * parm3  = Last line to save  (base 0)
0015               *---------------------------------------------------------------
0016               * OUTPUT
0017               * none
0018               *--------------------------------------------------------------
0019               * Register usage
0020               * tmp0, tmp1
0021               ********|*****|*********************|**************************
0022               fm.savefile:
0023 651C 0649  14         dect  stack
0024 651E C64B  30         mov   r11,*stack            ; Save return address
0025 6520 0649  14         dect  stack
0026 6522 C644  30         mov   tmp0,*stack           ; Push tmp0
0027 6524 0649  14         dect  stack
0028 6526 C645  30         mov   tmp1,*stack           ; Push tmp1
0029                       ;-------------------------------------------------------
0030                       ; Check if filename must be changed in editor buffer
0031                       ;-------------------------------------------------------
0032 6528 0204  20         li    tmp0,id.dialog.saveblock
     652A 000C 
0033 652C 8120  34         c     @cmdb.dialog,tmp0     ; Saving code block M1-M2 ?
     652E A31A 
0034 6530 130A  14         jeq   !                     ; Yes, skip changing current filename
0035                       ;-------------------------------------------------------
0036                       ; Change filename
0037                       ;-------------------------------------------------------
0038 6532 C120  34         mov   @parm1,tmp0           ; Source address
     6534 2F20 
0039 6536 0205  20         li    tmp1,edb.filename     ; Target address
     6538 A21A 
0040 653A 0206  20         li    tmp2,80               ; Number of bytes to copy
     653C 0050 
0041 653E C805  38         mov   tmp1,@edb.filename.ptr
     6540 A212 
0042                                                   ; Set filename
0043               
0044 6542 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6544 24E4 
0045                                                   ; tmp1 = Memory target address
0046                                                   ; tmp2 = Number of bytes to copy
0047               
0048                       ;-------------------------------------------------------
0049                       ; Save DV80 file
0050                       ;-------------------------------------------------------
0051 6546 C820  54 !       mov   @parm2,@parm6         ; First line to save
     6548 2F22 
     654A 2F2A 
0052 654C C820  54         mov   @parm3,@parm7         ; Last line to save
     654E 2F24 
     6550 2F2C 
0053               
0054 6552 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     6554 6594 
0055 6556 C804  38         mov   tmp0,@parm2           ; Register callback 1
     6558 2F22 
0056               
0057 655A 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     655C 6622 
0058 655E C804  38         mov   tmp0,@parm3           ; Register callback 2
     6560 2F24 
0059               
0060 6562 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     6564 6672 
0061 6566 C804  38         mov   tmp0,@parm4           ; Register callback 3
     6568 2F26 
0062               
0063 656A 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     656C 66B8 
0064 656E C804  38         mov   tmp0,@parm5           ; Register callback 4
     6570 2F28 
0065               
0066 6572 06A0  32         bl    @filv
     6574 2292 
0067 6576 2180                   data sprsat,>0000,16  ; Turn off sprites
     6578 0000 
     657A 0010 
0068               
0069 657C 06A0  32         bl    @fh.file.write.edb    ; Save file from editor buffer
     657E 62F2 
0070                                                   ; \ i  @parm1 = Pointer to length prefixed
0071                                                   ; |             file descriptor
0072                                                   ; | i  @parm2 = Pointer to callback
0073                                                   ; |             "Before Open file"
0074                                                   ; | i  @parm3 = Pointer to callback
0075                                                   ; |             "Write line to file"
0076                                                   ; | i  @parm4 = Pointer to callback
0077                                                   ; |             "Close file"
0078                                                   ; | i  @parm5 = Pointer to callback
0079                                                   ; |             "File I/O error"
0080                                                   ; | i  @parm6 = First line to save (base 0)
0081                                                   ; | i  @parm7 = Last line to save  (base 0)
0082                                                   ; /
0083               
0084 6580 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6582 A206 
0085                                                   ; longer dirty.
0086               
0087 6584 0204  20         li    tmp0,txt.filetype.DV80
     6586 3534 
0088 6588 C804  38         mov   tmp0,@edb.filetype.ptr
     658A A214 
0089                                                   ; Set filetype display string
0090               *--------------------------------------------------------------
0091               * Exit
0092               *--------------------------------------------------------------
0093               fm.savefile.exit:
0094 658C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0095 658E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0096 6590 C2F9  30         mov   *stack+,r11           ; Pop R11
0097 6592 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.3164438
0083                       copy  "fm.callbacks.asm"    ; Callbacks for file operations
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
0011 6594 0649  14         dect  stack
0012 6596 C64B  30         mov   r11,*stack            ; Save return address
0013 6598 0649  14         dect  stack
0014 659A C644  30         mov   tmp0,*stack           ; Push tmp0
0015 659C 0649  14         dect  stack
0016 659E C645  30         mov   tmp1,*stack           ; Push tmp1
0017 65A0 0649  14         dect  stack
0018 65A2 C660  46         mov   @parm1,*stack         ; Push @parm1
     65A4 2F20 
0019                       ;------------------------------------------------------
0020                       ; Check file operation mode
0021                       ;------------------------------------------------------
0022 65A6 06A0  32         bl    @hchar
     65A8 27C8 
0023 65AA 1700                   byte pane.botrow,0,32,50
     65AC 2032 
0024 65AE FFFF                   data EOL              ; Clear hint on bottom row
0025               
0026 65B0 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     65B2 A01C 
     65B4 2F20 
0027 65B6 06A0  32         bl    @pane.action.colorscheme.statlines
     65B8 68B8 
0028                                                   ; Set color combination for status line
0029                                                   ; \ i  @parm1 = Color combination
0030                                                   ; /
0031               
0032 65BA C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     65BC A44A 
0033               
0034 65BE 0284  22         ci    tmp0,fh.fopmode.writefile
     65C0 0002 
0035 65C2 1303  14         jeq   fm.loadsave.cb.indicator1.saving
0036                                                   ; Saving file?
0037               
0038 65C4 0284  22         ci    tmp0,fh.fopmode.readfile
     65C6 0001 
0039 65C8 130F  14         jeq   fm.loadsave.cb.indicator1.loading
0040                                                   ; Loading file?
0041                       ;------------------------------------------------------
0042                       ; Display Saving....
0043                       ;------------------------------------------------------
0044               fm.loadsave.cb.indicator1.saving:
0045 65CA 0204  20         li    tmp0,id.dialog.saveblock
     65CC 000C 
0046 65CE 8120  34         c     @cmdb.dialog,tmp0     ; Saving code block M1-M2 ?
     65D0 A31A 
0047 65D2 1305  14         jeq   fm.loadsave.cb.indicator1.saveblock
0048               
0049 65D4 06A0  32         bl    @putat
     65D6 2446 
0050 65D8 1700                   byte pane.botrow,0
0051 65DA 34AE                   data txt.saving       ; Display "Saving...."
0052 65DC 100E  14         jmp   fm.loadsave.cb.indicator1.filename
0053                       ;------------------------------------------------------
0054                       ; Display Saving block to DV80 file....
0055                       ;------------------------------------------------------
0056               fm.loadsave.cb.indicator1.saveblock:
0057 65DE 06A0  32         bl    @putat
     65E0 2446 
0058 65E2 1700                   byte pane.botrow,0
0059 65E4 34F2                   data txt.block.save   ; Display "Saving block...."
0060               
0061 65E6 1009  14         jmp   fm.loadsave.cb.indicator1.filename
0062                       ;------------------------------------------------------
0063                       ; Display Loading....
0064                       ;------------------------------------------------------
0065               fm.loadsave.cb.indicator1.loading:
0066 65E8 06A0  32         bl    @hchar
     65EA 27C8 
0067 65EC 0000                   byte 0,0,32,50
     65EE 2032 
0068 65F0 FFFF                   data EOL              ; Clear filename
0069               
0070 65F2 06A0  32         bl    @putat
     65F4 2446 
0071 65F6 1700                   byte pane.botrow,0
0072 65F8 34A2                   data txt.loading      ; Display "Loading file...."
0073                       ;------------------------------------------------------
0074                       ; Display device/filename
0075                       ;------------------------------------------------------
0076               fm.loadsave.cb.indicator1.filename:
0077 65FA 06A0  32         bl    @at
     65FC 26D2 
0078 65FE 170B                   byte pane.botrow,11   ; Cursor YX position
0079 6600 C160  34         mov   @edb.filename.ptr,tmp1
     6602 A212 
0080                                                   ; Get pointer to file descriptor
0081 6604 06A0  32         bl    @xutst0               ; Display device/filename
     6606 2424 
0082                       ;------------------------------------------------------
0083                       ; Display fast mode
0084                       ;------------------------------------------------------
0085 6608 0760  38         abs   @fh.offsetopcode
     660A A44E 
0086 660C 1304  14         jeq   fm.loadsave.cb.indicator1.exit
0087               
0088 660E 06A0  32         bl    @putat
     6610 2446 
0089 6612 1726                   byte pane.botrow,38
0090 6614 3510                   data txt.fastmode     ; Display "FastMode"
0091                       ;------------------------------------------------------
0092                       ; Exit
0093                       ;------------------------------------------------------
0094               fm.loadsave.cb.indicator1.exit:
0095 6616 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6618 2F20 
0096 661A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0097 661C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0098 661E C2F9  30         mov   *stack+,r11           ; Pop R11
0099 6620 045B  20         b     *r11                  ; Return to caller
0100               
0101               
0102               
0103               
0104               *---------------------------------------------------------------
0105               * Callback function "Show loading indicator 2"
0106               * Read line from file / Write line to file
0107               *---------------------------------------------------------------
0108               * Registered as pointer in @fh.callback2
0109               *---------------------------------------------------------------
0110               fm.loadsave.cb.indicator2:
0111 6622 0649  14         dect  stack
0112 6624 C64B  30         mov   r11,*stack            ; Push return address
0113                       ;------------------------------------------------------
0114                       ; Check if first page processed (speedup impression)
0115                       ;------------------------------------------------------
0116 6626 8820  54         c     @fh.records,@fb.scrrows.max
     6628 A43C 
     662A A11C 
0117 662C 1609  14         jne   fm.loadsave.cb.indicator2.kb
0118                                                   ; Skip framebuffer refresh
0119                       ;------------------------------------------------------
0120                       ; Refresh framebuffer if first page processed
0121                       ;------------------------------------------------------
0122 662E 04E0  34         clr   @parm1
     6630 2F20 
0123 6632 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6634 6870 
0124                                                   ; \ i  @parm1 = Line to start with
0125                                                   ; /
0126               
0127 6636 C820  54         mov   @fb.scrrows,@parm1
     6638 A11A 
     663A 2F20 
0128 663C 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     663E 6882 
0129                                                   ; \ i  @parm1 = number of lines to dump
0130                                                   ; /
0131               
0132                       ;------------------------------------------------------
0133                       ; Check if updated counters should be displayed
0134                       ;------------------------------------------------------
0135               fm.loadsave.cb.indicator2.kb:
0136 6640 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     6642 A440 
     6644 A45A 
0137 6646 1313  14         jeq   fm.loadsave.cb.indicator2.exit
0138                       ;------------------------------------------------------
0139                       ; Display updated counters
0140                       ;------------------------------------------------------
0141 6648 C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     664A A440 
     664C A45A 
0142                                                   ; Save for compare
0143               
0144 664E 06A0  32         bl    @putnum
     6650 2A58 
0145 6652 0047                   byte 0,71             ; Show kilobytes processed
0146 6654 A440                   data fh.kilobytes,rambuf,>3020
     6656 2F6A 
     6658 3020 
0147               
0148 665A 06A0  32         bl    @putat
     665C 2446 
0149 665E 004C                   byte 0,76
0150 6660 351A                   data txt.kb           ; Show "kb" string
0151               
0152 6662 06A0  32         bl    @putnum
     6664 2A58 
0153 6666 1748                   byte pane.botrow,72   ; Show lines processed
0154 6668 A43C                   data fh.records,rambuf,>3020
     666A 2F6A 
     666C 3020 
0155                       ;------------------------------------------------------
0156                       ; Exit
0157                       ;------------------------------------------------------
0158               fm.loadsave.cb.indicator2.exit:
0159 666E C2F9  30         mov   *stack+,r11           ; Pop R11
0160 6670 045B  20         b     *r11                  ; Return to caller
0161               
0162               
0163               
0164               
0165               *---------------------------------------------------------------
0166               * Callback function "Show loading indicator 3"
0167               * Close file
0168               *---------------------------------------------------------------
0169               * Registered as pointer in @fh.callback3
0170               *---------------------------------------------------------------
0171               fm.loadsave.cb.indicator3:
0172 6672 0649  14         dect  stack
0173 6674 C64B  30         mov   r11,*stack            ; Save return address
0174 6676 0649  14         dect  stack
0175 6678 C660  46         mov   @parm1,*stack         ; Push @parm1
     667A 2F20 
0176               
0177 667C 06A0  32         bl    @hchar
     667E 27C8 
0178 6680 1700                   byte pane.botrow,0,32,50
     6682 2032 
0179 6684 FFFF                   data EOL              ; Erase loading indicator
0180               
0181 6686 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6688 A018 
     668A 2F20 
0182 668C 06A0  32         bl    @pane.action.colorscheme.statlines
     668E 68B8 
0183                                                   ; Set color combination for status lines
0184                                                   ; \ i  @parm1 = Color combination
0185                                                   ; /
0186               
0187 6690 06A0  32         bl    @putnum
     6692 2A58 
0188 6694 0047                   byte 0,71             ; Show kilobytes processed
0189 6696 A440                   data fh.kilobytes,rambuf,>3020
     6698 2F6A 
     669A 3020 
0190               
0191 669C 06A0  32         bl    @putat
     669E 2446 
0192 66A0 004C                   byte 0,76
0193 66A2 351A                   data txt.kb           ; Show "kb" string
0194               
0195 66A4 06A0  32         bl    @putnum
     66A6 2A58 
0196 66A8 1748                   byte pane.botrow,72   ; Show lines processed
0197 66AA A204                   data edb.lines,rambuf,>3020
     66AC 2F6A 
     66AE 3020 
0198                       ;------------------------------------------------------
0199                       ; Exit
0200                       ;------------------------------------------------------
0201               fm.loadsave.cb.indicator3.exit:
0202 66B0 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     66B2 2F20 
0203 66B4 C2F9  30         mov   *stack+,r11           ; Pop R11
0204 66B6 045B  20         b     *r11                  ; Return to caller
0205               
0206               
0207               
0208               *---------------------------------------------------------------
0209               * Callback function "File I/O error handler"
0210               * I/O error
0211               *---------------------------------------------------------------
0212               * Registered as pointer in @fh.callback4
0213               *---------------------------------------------------------------
0214               fm.loadsave.cb.fioerr:
0215 66B8 0649  14         dect  stack
0216 66BA C64B  30         mov   r11,*stack            ; Save return address
0217 66BC 0649  14         dect  stack
0218 66BE C644  30         mov   tmp0,*stack           ; Push tmp0
0219 66C0 0649  14         dect  stack
0220 66C2 C645  30         mov   tmp1,*stack           ; Push tmp1
0221 66C4 0649  14         dect  stack
0222 66C6 C646  30         mov   tmp2,*stack           ; Push tmp2
0223 66C8 0649  14         dect  stack
0224 66CA C647  30         mov   tmp3,*stack           ; Push tmp3
0225 66CC 0649  14         dect  stack
0226 66CE C660  46         mov   @parm1,*stack         ; Push @parm1
     66D0 2F20 
0227                       ;------------------------------------------------------
0228                       ; Build I/O error message
0229                       ;------------------------------------------------------
0230 66D2 06A0  32         bl    @hchar
     66D4 27C8 
0231 66D6 1700                   byte pane.botrow,0,32,50
     66D8 2032 
0232 66DA FFFF                   data EOL              ; Erase loading/saving indicator
0233               
0234 66DC C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     66DE A44A 
0235 66E0 0284  22         ci    tmp0,fh.fopmode.writefile
     66E2 0002 
0236 66E4 1306  14         jeq   fm.loadsave.cb.fioerr.mgs2
0237                       ;------------------------------------------------------
0238                       ; Failed loading file
0239                       ;------------------------------------------------------
0240               fm.loadsave.cb.fioerr.mgs1:
0241 66E6 06A0  32         bl    @cpym2m
     66E8 24DE 
0242 66EA 37F9                   data txt.ioerr.load+1
0243 66EC A02B                   data tv.error.msg+1
0244 66EE 0022                   data 34               ; Error message
0245 66F0 1005  14         jmp   fm.loadsave.cb.fioerr.mgs3
0246                       ;------------------------------------------------------
0247                       ; Failed saving file
0248                       ;------------------------------------------------------
0249               fm.loadsave.cb.fioerr.mgs2:
0250 66F2 06A0  32         bl    @cpym2m
     66F4 24DE 
0251 66F6 381B                   data txt.ioerr.save+1
0252 66F8 A02B                   data tv.error.msg+1
0253 66FA 0022                   data 34               ; Error message
0254                       ;------------------------------------------------------
0255                       ; Add filename to error message
0256                       ;------------------------------------------------------
0257               fm.loadsave.cb.fioerr.mgs3:
0258 66FC C120  34         mov   @fh.fname.ptr,tmp0
     66FE A444 
0259 6700 D194  26         movb  *tmp0,tmp2            ; Get length byte
0260 6702 0986  56         srl   tmp2,8                ; Right align
0261               
0262 6704 C1C6  18         mov   tmp2,tmp3             ; \
0263 6706 0227  22         ai    tmp3,33               ; |  Calculate length byte of error message
     6708 0021 
0264 670A 0A87  56         sla   tmp3,8                ; |  and write to string prefix
0265 670C D807  38         movb  tmp3,@tv.error.msg    ; /
     670E A02A 
0266               
0267 6710 0584  14         inc   tmp0                  ; Skip length byte
0268 6712 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     6714 A04B 
0269               
0270 6716 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     6718 24E4 
0271                                                   ; | i  tmp0 = ROM/RAM source
0272                                                   ; | i  tmp1 = RAM destination
0273                                                   ; / i  tmp2 = Bytes to copy
0274                       ;------------------------------------------------------
0275                       ; Reset filename to "new file"
0276                       ;------------------------------------------------------
0277 671A C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     671C A44A 
0278               
0279 671E 0284  22         ci    tmp0,fh.fopmode.readfile
     6720 0001 
0280 6722 1608  14         jne   !                     ; Only when reading file
0281               
0282 6724 0204  20         li    tmp0,txt.newfile      ; New file
     6726 3528 
0283 6728 C804  38         mov   tmp0,@edb.filename.ptr
     672A A212 
0284               
0285 672C 0204  20         li    tmp0,txt.filetype.none
     672E 35E2 
0286 6730 C804  38         mov   tmp0,@edb.filetype.ptr
     6732 A214 
0287                                                   ; Empty filetype string
0288                       ;------------------------------------------------------
0289                       ; Display I/O error message
0290                       ;------------------------------------------------------
0291 6734 06A0  32 !       bl    @pane.errline.show    ; Show error line
     6736 6894 
0292               
0293 6738 C820  54         mov   @tv.color,@parm1      ; Set normal color
     673A A018 
     673C 2F20 
0294 673E 06A0  32         bl    @pane.action.colorscheme.statlines
     6740 68B8 
0295                                                   ; Set color combination for status lines
0296                                                   ; \ i  @parm1 = Color combination
0297                                                   ; /
0298                       ;------------------------------------------------------
0299                       ; Exit
0300                       ;------------------------------------------------------
0301               fm.loadsave.cb.fioerr.exit:
0302 6742 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6744 2F20 
0303 6746 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0304 6748 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0305 674A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0306 674C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0307 674E C2F9  30         mov   *stack+,r11           ; Pop R11
0308 6750 045B  20         b     *r11                  ; Return to caller
0309               
0310               
0311               
0312               
0313               *---------------------------------------------------------------
0314               * Callback function "Memory full" error handler
0315               * Memory full error
0316               *---------------------------------------------------------------
0317               * Registered as pointer in @fh.callback5
0318               *---------------------------------------------------------------
0319               fm.load.cb.memfull:
0320 6752 0649  14         dect  stack
0321 6754 C64B  30         mov   r11,*stack            ; Save return address
0322 6756 0649  14         dect  stack
0323 6758 C660  46         mov   @parm1,*stack         ; Push @parm1
     675A 2F20 
0324                       ;------------------------------------------------------
0325                       ; Prepare for error message
0326                       ;------------------------------------------------------
0327 675C 06A0  32         bl    @hchar
     675E 27C8 
0328 6760 1700                   byte pane.botrow,0,32,50
     6762 2032 
0329 6764 FFFF                   data EOL              ; Erase loading indicator
0330                       ;------------------------------------------------------
0331                       ; Failed loading file
0332                       ;------------------------------------------------------
0333 6766 06A0  32         bl    @cpym2m
     6768 24DE 
0334 676A 383C                   data txt.memfull.load
0335 676C A02A                   data tv.error.msg
0336 676E 0042                   data 66               ; Error message
0337                       ;------------------------------------------------------
0338                       ; Display memory full error message
0339                       ;------------------------------------------------------
0340 6770 06A0  32         bl    @pane.errline.show    ; Show error line
     6772 6894 
0341               
0342 6774 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6776 A018 
     6778 2F20 
0343 677A 06A0  32         bl    @pane.action.colorscheme.statlines
     677C 68B8 
0344                                                   ; Set color combination for status lines
0345                                                   ; \ i  @parm1 = Color combination
0346                                                   ; /
0347                       ;------------------------------------------------------
0348                       ; Exit
0349                       ;------------------------------------------------------
0350               fm.load.cb.memfull.exit:
0351 677E C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6780 2F20 
0352 6782 C2F9  30         mov   *stack+,r11           ; Pop R11
0353 6784 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.3164438
0084                       copy  "fm.browse.asm"       ; File manager browse support routines
**** **** ****     > fm.browse.asm
0001               * FILE......: fm.browse.asm
0002               * Purpose...: File Manager - File browse support routines
0003               
0004               *---------------------------------------------------------------
0005               * Increase/Decrease last-character of current filename
0006               *---------------------------------------------------------------
0007               * bl   @fm.browse.fname.suffix
0008               *---------------------------------------------------------------
0009               * INPUT
0010               * parm1        = Pointer to device and filename
0011               * parm2        = Increase (>FFFF) or Decrease (>0000) ASCII
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0, tmp1
0015               ********|*****|*********************|**************************
0016               fm.browse.fname.suffix:
0017 6786 0649  14         dect  stack
0018 6788 C64B  30         mov   r11,*stack            ; Save return address
0019 678A 0649  14         dect  stack
0020 678C C644  30         mov   tmp0,*stack           ; Push tmp0
0021 678E 0649  14         dect  stack
0022 6790 C645  30         mov   tmp1,*stack           ; Push tmp1
0023                       ;------------------------------------------------------
0024                       ; Assert
0025                       ;------------------------------------------------------
0026 6792 C120  34         mov   @parm1,tmp0           ; Get pointer to filename
     6794 2F20 
0027 6796 1334  14         jeq   fm.browse.fname.suffix.exit
0028                                                   ; Exit early if pointer is nill
0029               
0030 6798 0284  22         ci    tmp0,txt.newfile
     679A 3528 
0031 679C 1331  14         jeq   fm.browse.fname.suffix.exit
0032                                                   ; Exit early if "New file"
0033                       ;------------------------------------------------------
0034                       ; Get last character in filename
0035                       ;------------------------------------------------------
0036 679E D154  26         movb  *tmp0,tmp1            ; Get length of current filename
0037 67A0 0985  56         srl   tmp1,8                ; MSB to LSB
0038               
0039 67A2 A105  18         a     tmp1,tmp0             ; Move to last character
0040 67A4 04C5  14         clr   tmp1
0041 67A6 D154  26         movb  *tmp0,tmp1            ; Get character
0042 67A8 0985  56         srl   tmp1,8                ; MSB to LSB
0043 67AA 132A  14         jeq   fm.browse.fname.suffix.exit
0044                                                   ; Exit early if empty filename
0045                       ;------------------------------------------------------
0046                       ; Check mode (increase/decrease) character ASCII value
0047                       ;------------------------------------------------------
0048 67AC C1A0  34         mov   @parm2,tmp2           ; Get mode
     67AE 2F22 
0049 67B0 1314  14         jeq   fm.browse.fname.suffix.dec
0050                                                   ; Decrease ASCII if mode = 0
0051                       ;------------------------------------------------------
0052                       ; Increase ASCII value last character in filename
0053                       ;------------------------------------------------------
0054               fm.browse.fname.suffix.inc:
0055 67B2 0285  22         ci    tmp1,48               ; ASCI  48 (char 0) ?
     67B4 0030 
0056 67B6 1108  14         jlt   fm.browse.fname.suffix.inc.crash
0057 67B8 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     67BA 0039 
0058 67BC 1109  14         jlt   !                     ; Next character
0059 67BE 130A  14         jeq   fm.browse.fname.suffix.inc.alpha
0060                                                   ; Swith to alpha range A..Z
0061 67C0 0285  22         ci    tmp1,90               ; ASCII 132 (char Z) ?
     67C2 005A 
0062 67C4 131D  14         jeq   fm.browse.fname.suffix.exit
0063                                                   ; Already last alpha character, so exit
0064 67C6 1104  14         jlt   !                     ; Next character
0065                       ;------------------------------------------------------
0066                       ; Invalid character, crash and burn
0067                       ;------------------------------------------------------
0068               fm.browse.fname.suffix.inc.crash:
0069 67C8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     67CA FFCE 
0070 67CC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     67CE 2026 
0071                       ;------------------------------------------------------
0072                       ; Increase ASCII value last character in filename
0073                       ;------------------------------------------------------
0074 67D0 0585  14 !       inc   tmp1                  ; Increase ASCII value
0075 67D2 1014  14         jmp   fm.browse.fname.suffix.store
0076               fm.browse.fname.suffix.inc.alpha:
0077 67D4 0205  20         li    tmp1,65               ; Set ASCII 65 (char A)
     67D6 0041 
0078 67D8 1011  14         jmp   fm.browse.fname.suffix.store
0079                       ;------------------------------------------------------
0080                       ; Decrease ASCII value last character in filename
0081                       ;------------------------------------------------------
0082               fm.browse.fname.suffix.dec:
0083 67DA 0285  22         ci    tmp1,48               ; ASCII 48 (char 0) ?
     67DC 0030 
0084 67DE 1310  14         jeq   fm.browse.fname.suffix.exit
0085                                                   ; Already first numeric character, so exit
0086 67E0 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     67E2 0039 
0087 67E4 1207  14         jle   !                     ; Previous character
0088 67E6 0285  22         ci    tmp1,65               ; ASCII 65 (char A) ?
     67E8 0041 
0089 67EA 1306  14         jeq   fm.browse.fname.suffix.dec.numeric
0090                                                   ; Switch to numeric range 0..9
0091 67EC 11ED  14         jlt   fm.browse.fname.suffix.inc.crash
0092                                                   ; Invalid character
0093 67EE 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     67F0 0084 
0094 67F2 1306  14         jeq   fm.browse.fname.suffix.exit
0095 67F4 0605  14 !       dec   tmp1                  ; Decrease ASCII value
0096 67F6 1002  14         jmp   fm.browse.fname.suffix.store
0097               fm.browse.fname.suffix.dec.numeric:
0098 67F8 0205  20         li    tmp1,57               ; Set ASCII 57 (char 9)
     67FA 0039 
0099                       ;------------------------------------------------------
0100                       ; Store updatec character
0101                       ;------------------------------------------------------
0102               fm.browse.fname.suffix.store:
0103 67FC 0A85  56         sla   tmp1,8                ; LSB to MSB
0104 67FE D505  30         movb  tmp1,*tmp0            ; Store updated character
0105                       ;------------------------------------------------------
0106                       ; Exit
0107                       ;------------------------------------------------------
0108               fm.browse.fname.suffix.exit:
0109 6800 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0110 6802 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0111 6804 C2F9  30         mov   *stack+,r11           ; Pop R11
0112 6806 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.3164438
0085                       copy  "fm.fastmode.asm"     ; Turn fastmode on/off for file operation
**** **** ****     > fm.fastmode.asm
0001               * FILE......: fm.fastmode.asm
0002               * Purpose...: Turn fastmode on/off for file operation
0003               
0004               ***************************************************************
0005               * fm.fastmode
0006               * Turn on fast mode for supported devices
0007               ***************************************************************
0008               * bl  @fm.fastmode
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *---------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0, tmp1
0018               ********|*****|*********************|**************************
0019               fm.fastmode:
0020 6808 0649  14         dect  stack
0021 680A C64B  30         mov   r11,*stack            ; Save return address
0022 680C 0649  14         dect  stack
0023 680E C644  30         mov   tmp0,*stack           ; Push tmp0
0024               
0025 6810 C120  34         mov   @fh.offsetopcode,tmp0
     6812 A44E 
0026 6814 1307  14         jeq   !
0027                       ;------------------------------------------------------
0028                       ; Turn fast mode off
0029                       ;------------------------------------------------------
0030 6816 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     6818 A44E 
0031 681A 0204  20         li    tmp0,txt.keys.load
     681C 364A 
0032 681E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6820 A322 
0033 6822 1008  14         jmp   fm.fastmode.exit
0034                       ;------------------------------------------------------
0035                       ; Turn fast mode on
0036                       ;------------------------------------------------------
0037 6824 0204  20 !       li    tmp0,>40              ; Data buffer in CPU RAM
     6826 0040 
0038 6828 C804  38         mov   tmp0,@fh.offsetopcode
     682A A44E 
0039 682C 0204  20         li    tmp0,txt.keys.load2
     682E 367E 
0040 6830 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6832 A322 
0041               *--------------------------------------------------------------
0042               * Exit
0043               *--------------------------------------------------------------
0044               fm.fastmode.exit:
0045 6834 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 6836 C2F9  30         mov   *stack+,r11           ; Pop R11
0047 6838 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.3164438
0086                       ;-----------------------------------------------------------------------
0087                       ; Stubs using trampoline
0088                       ;-----------------------------------------------------------------------
0089                       copy  "rom.stubs.bank2.asm" ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank2.asm
0001               * FILE......: rom.stubs.bank2.asm
0002               * Purpose...: Bank 2 stubs for functions in other banks
0003               
0004               ***************************************************************
0005               * Stub for "idx.entry.update"
0006               * bank1 vec.2
0007               ********|*****|*********************|**************************
0008               idx.entry.update:
0009 683A 0649  14         dect  stack
0010 683C C64B  30         mov   r11,*stack            ; Save return address
0011                       ;------------------------------------------------------
0012                       ; Call function in bank 1
0013                       ;------------------------------------------------------
0014 683E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6840 3008 
0015 6842 6002                   data bank1.rom        ; | i  p0 = bank address
0016 6844 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0017 6846 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0018                       ;------------------------------------------------------
0019                       ; Exit
0020                       ;------------------------------------------------------
0021 6848 C2F9  30         mov   *stack+,r11           ; Pop r11
0022 684A 045B  20         b     *r11                  ; Return to caller
0023               
0024               
0025               ***************************************************************
0026               * Stub for "idx.pointer.get"
0027               * bank1 vec.4
0028               ********|*****|*********************|**************************
0029               idx.pointer.get:
0030 684C 0649  14         dect  stack
0031 684E C64B  30         mov   r11,*stack            ; Save return address
0032                       ;------------------------------------------------------
0033                       ; Call function in bank 1
0034                       ;------------------------------------------------------
0035 6850 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6852 3008 
0036 6854 6002                   data bank1.rom        ; | i  p0 = bank address
0037 6856 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0038 6858 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042 685A C2F9  30         mov   *stack+,r11           ; Pop r11
0043 685C 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               
0047               ***************************************************************
0048               * Stub for "edb.line.unpack"
0049               * bank1 vec.11
0050               ********|*****|*********************|**************************
0051               edb.line.unpack:
0052 685E 0649  14         dect  stack
0053 6860 C64B  30         mov   r11,*stack            ; Save return address
0054                       ;------------------------------------------------------
0055                       ; Call function in bank 1
0056                       ;------------------------------------------------------
0057 6862 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6864 3008 
0058 6866 6002                   data bank1.rom        ; | i  p0 = bank address
0059 6868 7FB0                   data vec.11           ; | i  p1 = Vector with target address
0060 686A 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064 686C C2F9  30         mov   *stack+,r11           ; Pop r11
0065 686E 045B  20         b     *r11                  ; Return to caller
0066               
0067               
0068               ***************************************************************
0069               * Stub for "fb.refresh"
0070               * bank1 vec.20
0071               ********|*****|*********************|**************************
0072               fb.refresh:
0073 6870 0649  14         dect  stack
0074 6872 C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Call function in bank 1
0077                       ;------------------------------------------------------
0078 6874 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6876 3008 
0079 6878 6002                   data bank1.rom        ; | i  p0 = bank address
0080 687A 7FC2                   data vec.20           ; | i  p1 = Vector with target address
0081 687C 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085 687E C2F9  30         mov   *stack+,r11           ; Pop r11
0086 6880 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               
0090               ***************************************************************
0091               * Stub for "fb.vdpdump"
0092               * bank1 vec.21
0093               ********|*****|*********************|**************************
0094               fb.vdpdump:
0095 6882 0649  14         dect  stack
0096 6884 C64B  30         mov   r11,*stack            ; Save return address
0097                       ;------------------------------------------------------
0098                       ; Call function in bank 1
0099                       ;------------------------------------------------------
0100 6886 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6888 3008 
0101 688A 6002                   data bank1.rom        ; | i  p0 = bank address
0102 688C 7FC4                   data vec.21           ; | i  p1 = Vector with target address
0103 688E 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0104                       ;------------------------------------------------------
0105                       ; Exit
0106                       ;------------------------------------------------------
0107 6890 C2F9  30         mov   *stack+,r11           ; Pop r11
0108 6892 045B  20         b     *r11                  ; Return to caller
0109               
0110               
0111               
0112               
0113               ***************************************************************
0114               * Stub for "pane.errline.show"
0115               * bank1 vec.30
0116               ********|*****|*********************|**************************
0117               pane.errline.show:
0118 6894 0649  14         dect  stack
0119 6896 C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Call function in bank 1
0122                       ;------------------------------------------------------
0123 6898 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     689A 3008 
0124 689C 6002                   data bank1.rom        ; | i  p0 = bank address
0125 689E 7FD6                   data vec.30           ; | i  p1 = Vector with target address
0126 68A0 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130 68A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0131 68A4 045B  20         b     *r11                  ; Return to caller
0132               
0133               
0134               ***************************************************************
0135               * Stub for "pane.action.colorscheme.load"
0136               * bank1 vec.31
0137               ********|*****|*********************|**************************
0138               pane.action.colorscheme.load
0139 68A6 0649  14         dect  stack
0140 68A8 C64B  30         mov   r11,*stack            ; Save return address
0141                       ;------------------------------------------------------
0142                       ; Call function in bank 1
0143                       ;------------------------------------------------------
0144 68AA 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     68AC 3008 
0145 68AE 6002                   data bank1.rom        ; | i  p0 = bank address
0146 68B0 7FD8                   data vec.31           ; | i  p1 = Vector with target address
0147 68B2 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0148                       ;------------------------------------------------------
0149                       ; Exit
0150                       ;------------------------------------------------------
0151 68B4 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 68B6 045B  20         b     *r11                  ; Return to caller
0153               
0154               
0155               ***************************************************************
0156               * Stub for "pane.action.colorscheme.statuslines"
0157               * bank1 vec.32
0158               ********|*****|*********************|**************************
0159               pane.action.colorscheme.statlines
0160 68B8 0649  14         dect  stack
0161 68BA C64B  30         mov   r11,*stack            ; Save return address
0162                       ;------------------------------------------------------
0163                       ; Call function in bank 1
0164                       ;------------------------------------------------------
0165 68BC 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     68BE 3008 
0166 68C0 6002                   data bank1.rom        ; | i  p0 = bank address
0167 68C2 7FDA                   data vec.32           ; | i  p1 = Vector with target address
0168 68C4 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0169                       ;------------------------------------------------------
0170                       ; Exit
0171                       ;------------------------------------------------------
0172 68C6 C2F9  30         mov   *stack+,r11           ; Pop r11
0173 68C8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.3164438
0090                       ;-----------------------------------------------------------------------
0091                       ; Bank specific vector table
0092                       ;-----------------------------------------------------------------------
0096 68CA 68CA                   data $                ; Bank 1 ROM size OK.
0098                       ;-------------------------------------------------------
0099                       ; Vector table bank 2: >7f9c - >7fff
0100                       ;-------------------------------------------------------
0101                       copy  "rom.vectors.bank2.asm"
**** **** ****     > rom.vectors.bank2.asm
0001               * FILE......: rom.vectors.bank2.asm
0002               * Purpose...: Bank 2 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 645A     vec.1   data  fm.loadfile           ;
0010 7F9E 651C     vec.2   data  fm.savefile           ;
0011 7FA0 6786     vec.3   data  fm.browse.fname.suffix
0012 7FA2 6808     vec.4   data  fm.fastmode           ;
0013 7FA4 2026     vec.5   data  cpu.crash             ;
0014 7FA6 2026     vec.6   data  cpu.crash             ;
0015 7FA8 2026     vec.7   data  cpu.crash             ;
0016 7FAA 2026     vec.8   data  cpu.crash             ;
0017 7FAC 2026     vec.9   data  cpu.crash             ;
0018 7FAE 2026     vec.10  data  cpu.crash             ;
0019 7FB0 2026     vec.11  data  cpu.crash             ;
0020 7FB2 2026     vec.12  data  cpu.crash             ;
0021 7FB4 2026     vec.13  data  cpu.crash             ;
0022 7FB6 2026     vec.14  data  cpu.crash             ;
0023 7FB8 2026     vec.15  data  cpu.crash             ;
0024 7FBA 2026     vec.16  data  cpu.crash             ;
0025 7FBC 2026     vec.17  data  cpu.crash             ;
0026 7FBE 2026     vec.18  data  cpu.crash             ;
0027 7FC0 2026     vec.19  data  cpu.crash             ;
0028 7FC2 2026     vec.20  data  cpu.crash             ;
0029 7FC4 2026     vec.21  data  cpu.crash             ;
0030 7FC6 2026     vec.22  data  cpu.crash             ;
0031 7FC8 2026     vec.23  data  cpu.crash             ;
0032 7FCA 2026     vec.24  data  cpu.crash             ;
0033 7FCC 2026     vec.25  data  cpu.crash             ;
0034 7FCE 2026     vec.26  data  cpu.crash             ;
0035 7FD0 2026     vec.27  data  cpu.crash             ;
0036 7FD2 2026     vec.28  data  cpu.crash             ;
0037 7FD4 2026     vec.29  data  cpu.crash             ;
0038 7FD6 2026     vec.30  data  cpu.crash             ;
0039 7FD8 2026     vec.31  data  cpu.crash             ;
0040 7FDA 2026     vec.32  data  cpu.crash             ;
**** **** ****     > stevie_b2.asm.3164438
0102               
0103               *--------------------------------------------------------------
0104               * Video mode configuration
0105               *--------------------------------------------------------------
0106      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0107      0004     spfbck  equ   >04                   ; Screen background color.
0108      339A     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0109      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0110      0050     colrow  equ   80                    ; Columns per row
0111      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0112      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0113      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0114      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.393026
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 210531-393026
0010               *
0011               * Bank 1 "James"
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
0025               
0026               *--------------------------------------------------------------
0027               * Classic99 F18a 24x80, no FG99 advanced mode
0028               *--------------------------------------------------------------
0029      0000     device.f18a.mode.30x80    equ  0       ; F18a 30 rows mode on
0030      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode on
0031               
0032               
0033               *--------------------------------------------------------------
0034               * JS99er F18a 30x80, FG99 advanced mode
0035               *--------------------------------------------------------------
0036               ;device.f18a.mode.30x80    equ  1       ; F18a 30 rows mode on
0037               ;device.fg99.mode.adv      equ  1       ; FG99 advanced mode on
**** **** ****     > stevie_b1.asm.393026
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
**** **** ****     > stevie_b1.asm.393026
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
**** **** ****     > stevie_b1.asm.393026
0017               
0018               ***************************************************************
0019               * Spectra2 core configuration
0020               ********|*****|*********************|**************************
0021      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0022                                                   ; grows downwards to >2000
0023               ***************************************************************
0024               * BANK 1
0025               ********|*****|*********************|**************************
0026      6002     bankid  equ   bank1.rom             ; Set bank identifier to current bank
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
0060 6010 1253             byte  18
0061 6011 ....             text  'STEVIE 1.1H (9938)'
0062                       even
0063               
0065               
**** **** ****     > stevie_b1.asm.393026
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
     2084 2E4A 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 22FA 
0078 208A 21EA                   data graph1           ; Equate selected video mode table
0079               
0080 208C 06A0  32         bl    @ldfnt
     208E 2362 
0081 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C 
0082               
0083 2094 06A0  32         bl    @filv
     2096 2290 
0084 2098 0380                   data >0380,>f0,32*24  ; Load color table
     209A 00F0 
     209C 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 209E 06A0  32         bl    @putat                ; Show crash message
     20A0 2444 
0089 20A2 0000                   data >0000,cpu.crash.msg.crashed
     20A4 2178 
0090               
0091 20A6 06A0  32         bl    @puthex               ; Put hex value on screen
     20A8 29CE 
0092 20AA 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20AC FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20AE 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20B0 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20B2 06A0  32         bl    @putat                ; Show caller message
     20B4 2444 
0101 20B6 0100                   data >0100,cpu.crash.msg.caller
     20B8 218E 
0102               
0103 20BA 06A0  32         bl    @puthex               ; Put hex value on screen
     20BC 29CE 
0104 20BE 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20C0 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20C2 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20C4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20C6 06A0  32         bl    @putat
     20C8 2444 
0113 20CA 0300                   byte 3,0
0114 20CC 21AA                   data cpu.crash.msg.wp
0115 20CE 06A0  32         bl    @putat
     20D0 2444 
0116 20D2 0400                   byte 4,0
0117 20D4 21B0                   data cpu.crash.msg.st
0118 20D6 06A0  32         bl    @putat
     20D8 2444 
0119 20DA 1600                   byte 22,0
0120 20DC 21B6                   data cpu.crash.msg.source
0121 20DE 06A0  32         bl    @putat
     20E0 2444 
0122 20E2 1700                   byte 23,0
0123 20E4 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20E6 06A0  32         bl    @at                   ; Put cursor at YX
     20E8 26D0 
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
     210C 29D8 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2112 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2114 06A0  32         bl    @setx                 ; Set cursor X position
     2116 26E6 
0160 2118 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 211A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     211C 2420 
0164 211E 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 2120 06A0  32         bl    @setx                 ; Set cursor X position
     2122 26E6 
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
     2132 2420 
0176 2134 21A4                   data cpu.crash.msg.r
0177               
0178 2136 06A0  32         bl    @mknum
     2138 29D8 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 294A 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2148 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 214A 06A0  32         bl    @setx                 ; Set cursor X position
     214C 26E6 
0194 214E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 2150 06A0  32         bl    @putstr               ; Put '  >'
     2152 2420 
0198 2154 21A6                   data cpu.crash.msg.marker
0199               
0200 2156 06A0  32         bl    @setx                 ; Set cursor X position
     2158 26E6 
0201 215A 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 215C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     215E 2420 
0205 2160 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 2162 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 2164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2168 06A0  32         bl    @down                 ; y=y+1
     216A 26D6 
0213               
0214 216C 0586  14         inc   tmp2
0215 216E 0286  22         ci    tmp2,17
     2170 0011 
0216 2172 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2174 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2176 2D48 
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
0255 21B7 ....             text  'Source    stevie_b1.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21D2 1742             byte  23
0260 21D3 ....             text  'Build-ID  210531-393026'
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
0007 21EA 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21EC 000E 
     21EE 0106 
     21F0 0204 
     21F2 0020 
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
0032 21F4 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21F6 000E 
     21F8 0106 
     21FA 00F4 
     21FC 0028 
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
0058 21FE 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2200 003F 
     2202 0240 
     2204 03F4 
     2206 0050 
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
0084 2208 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220A 003F 
     220C 0240 
     220E 03F4 
     2210 0050 
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
0013 2212 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2214 16FD             data  >16fd                 ; |         jne   mcloop
0015 2216 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2218 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 221A 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 221C 0201  20         li    r1,mccode             ; Machinecode to patch
     221E 2212 
0037 2220 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2222 8322 
0038 2224 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2226 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2228 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 222A 045B  20         b     *r11                  ; Return to caller
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
0056 222C C0F9  30 popr3   mov   *stack+,r3
0057 222E C0B9  30 popr2   mov   *stack+,r2
0058 2230 C079  30 popr1   mov   *stack+,r1
0059 2232 C039  30 popr0   mov   *stack+,r0
0060 2234 C2F9  30 poprt   mov   *stack+,r11
0061 2236 045B  20         b     *r11
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
0085 2238 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 223A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 223C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 223E C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 2240 1604  14         jne   filchk                ; No, continue checking
0093               
0094 2242 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2244 FFCE 
0095 2246 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2248 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 224A D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     224C 830B 
     224E 830A 
0100               
0101 2250 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2252 0001 
0102 2254 1602  14         jne   filchk2
0103 2256 DD05  32         movb  tmp1,*tmp0+
0104 2258 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 225A 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     225C 0002 
0109 225E 1603  14         jne   filchk3
0110 2260 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 2262 DD05  32         movb  tmp1,*tmp0+
0112 2264 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2266 C1C4  18 filchk3 mov   tmp0,tmp3
0117 2268 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     226A 0001 
0118 226C 1305  14         jeq   fil16b
0119 226E DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 2270 0606  14         dec   tmp2
0121 2272 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2274 0002 
0122 2276 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2278 C1C6  18 fil16b  mov   tmp2,tmp3
0127 227A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     227C 0001 
0128 227E 1301  14         jeq   dofill
0129 2280 0606  14         dec   tmp2                  ; Make TMP2 even
0130 2282 CD05  34 dofill  mov   tmp1,*tmp0+
0131 2284 0646  14         dect  tmp2
0132 2286 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2288 C1C7  18         mov   tmp3,tmp3
0137 228A 1301  14         jeq   fil.exit
0138 228C DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 228E 045B  20         b     *r11
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
0159 2290 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 2292 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 2294 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 2296 0264  22 xfilv   ori   tmp0,>4000
     2298 4000 
0166 229A 06C4  14         swpb  tmp0
0167 229C D804  38         movb  tmp0,@vdpa
     229E 8C02 
0168 22A0 06C4  14         swpb  tmp0
0169 22A2 D804  38         movb  tmp0,@vdpa
     22A4 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22A6 020F  20         li    r15,vdpw              ; Set VDP write address
     22A8 8C00 
0174 22AA 06C5  14         swpb  tmp1
0175 22AC C820  54         mov   @filzz,@mcloop        ; Setup move command
     22AE 22B6 
     22B0 8320 
0176 22B2 0460  28         b     @mcloop               ; Write data to VDP
     22B4 8320 
0177               *--------------------------------------------------------------
0181 22B6 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22B8 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22BA 4000 
0202 22BC 06C4  14 vdra    swpb  tmp0
0203 22BE D804  38         movb  tmp0,@vdpa
     22C0 8C02 
0204 22C2 06C4  14         swpb  tmp0
0205 22C4 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22C6 8C02 
0206 22C8 045B  20         b     *r11                  ; Exit
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
0217 22CA C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22CC C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22CE 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22D0 4000 
0223 22D2 06C4  14         swpb  tmp0                  ; \
0224 22D4 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22D6 8C02 
0225 22D8 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22DA D804  38         movb  tmp0,@vdpa            ; /
     22DC 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22DE 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22E0 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22E2 045B  20         b     *r11                  ; Exit
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
0251 22E4 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22E6 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22E8 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22EA 8C02 
0257 22EC 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22EE D804  38         movb  tmp0,@vdpa            ; /
     22F0 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22F2 D120  34         movb  @vdpr,tmp0            ; Read byte
     22F4 8800 
0263 22F6 0984  56         srl   tmp0,8                ; Right align
0264 22F8 045B  20         b     *r11                  ; Exit
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
0283 22FA C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 22FC C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 22FE C144  18         mov   tmp0,tmp1
0289 2300 05C5  14         inct  tmp1
0290 2302 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2304 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2306 FF00 
0292 2308 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 230A C805  38         mov   tmp1,@wbase           ; Store calculated base
     230C 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 230E 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2310 8000 
0298 2312 0206  20         li    tmp2,8
     2314 0008 
0299 2316 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2318 830B 
0300 231A 06C5  14         swpb  tmp1
0301 231C D805  38         movb  tmp1,@vdpa
     231E 8C02 
0302 2320 06C5  14         swpb  tmp1
0303 2322 D805  38         movb  tmp1,@vdpa
     2324 8C02 
0304 2326 0225  22         ai    tmp1,>0100
     2328 0100 
0305 232A 0606  14         dec   tmp2
0306 232C 16F4  14         jne   vidta1                ; Next register
0307 232E C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2330 833A 
0308 2332 045B  20         b     *r11
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
0325 2334 C13B  30 putvr   mov   *r11+,tmp0
0326 2336 0264  22 putvrx  ori   tmp0,>8000
     2338 8000 
0327 233A 06C4  14         swpb  tmp0
0328 233C D804  38         movb  tmp0,@vdpa
     233E 8C02 
0329 2340 06C4  14         swpb  tmp0
0330 2342 D804  38         movb  tmp0,@vdpa
     2344 8C02 
0331 2346 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2348 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 234A C10E  18         mov   r14,tmp0
0341 234C 0984  56         srl   tmp0,8
0342 234E 06A0  32         bl    @putvrx               ; Write VR#0
     2350 2336 
0343 2352 0204  20         li    tmp0,>0100
     2354 0100 
0344 2356 D820  54         movb  @r14lb,@tmp0lb
     2358 831D 
     235A 8309 
0345 235C 06A0  32         bl    @putvrx               ; Write VR#1
     235E 2336 
0346 2360 0458  20         b     *tmp4                 ; Exit
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
0360 2362 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2364 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2366 C11B  26         mov   *r11,tmp0             ; Get P0
0363 2368 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     236A 7FFF 
0364 236C 2120  38         coc   @wbit0,tmp0
     236E 2020 
0365 2370 1604  14         jne   ldfnt1
0366 2372 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2374 8000 
0367 2376 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2378 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 237A C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     237C 23E4 
0372 237E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2380 9C02 
0373 2382 06C4  14         swpb  tmp0
0374 2384 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2386 9C02 
0375 2388 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     238A 9800 
0376 238C 06C5  14         swpb  tmp1
0377 238E D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     2390 9800 
0378 2392 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 2394 D805  38         movb  tmp1,@grmwa
     2396 9C02 
0383 2398 06C5  14         swpb  tmp1
0384 239A D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     239C 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 239E C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23A0 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23A2 22B8 
0390 23A4 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23A6 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23A8 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23AA 7FFF 
0393 23AC C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23AE 23E6 
0394 23B0 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23B2 23E8 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23B4 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23B6 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23B8 D120  34         movb  @grmrd,tmp0
     23BA 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23BC 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23BE 2020 
0405 23C0 1603  14         jne   ldfnt3                ; No, so skip
0406 23C2 D1C4  18         movb  tmp0,tmp3
0407 23C4 0917  56         srl   tmp3,1
0408 23C6 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23C8 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23CA 8C00 
0413 23CC 0606  14         dec   tmp2
0414 23CE 16F2  14         jne   ldfnt2
0415 23D0 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23D2 020F  20         li    r15,vdpw              ; Set VDP write address
     23D4 8C00 
0417 23D6 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23D8 7FFF 
0418 23DA 0458  20         b     *tmp4                 ; Exit
0419 23DC D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23DE 2000 
     23E0 8C00 
0420 23E2 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23E4 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23E6 0200 
     23E8 0000 
0425 23EA 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23EC 01C0 
     23EE 0101 
0426 23F0 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23F2 02A0 
     23F4 0101 
0427 23F6 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23F8 00E0 
     23FA 0101 
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
0445 23FC C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 23FE C3A0  34         mov   @wyx,r14              ; Get YX
     2400 832A 
0447 2402 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2404 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2406 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2408 C3A0  34         mov   @wyx,r14              ; Get YX
     240A 832A 
0454 240C 024E  22         andi  r14,>00ff             ; Remove Y
     240E 00FF 
0455 2410 A3CE  18         a     r14,r15               ; pos = pos + X
0456 2412 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2414 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2416 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2418 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 241A 020F  20         li    r15,vdpw              ; VDP write address
     241C 8C00 
0463 241E 045B  20         b     *r11
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
0481 2420 C17B  30 putstr  mov   *r11+,tmp1
0482 2422 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 2424 C1CB  18 xutstr  mov   r11,tmp3
0484 2426 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2428 23FC 
0485 242A C2C7  18         mov   tmp3,r11
0486 242C 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 242E C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 2430 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 2432 0286  22         ci    tmp2,255              ; Length > 255 ?
     2434 00FF 
0494 2436 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 2438 0460  28         b     @xpym2v               ; Display string
     243A 248E 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 243C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     243E FFCE 
0501 2440 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2442 2026 
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
0517 2444 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2446 832A 
0518 2448 0460  28         b     @putstr
     244A 2420 
0519               
0520               
0521               ***************************************************************
0522               * putlst
0523               * Loop over string list and display
0524               ***************************************************************
0525               * bl  @putlst
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
0539 244C 0649  14         dect  stack
0540 244E C64B  30         mov   r11,*stack            ; Save return address
0541 2450 0649  14         dect  stack
0542 2452 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 2454 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 2456 0987  56         srl   tmp3,8                ; Right align
0549               
0550 2458 0649  14         dect  stack
0551 245A C645  30         mov   tmp1,*stack           ; Push tmp1
0552 245C 0649  14         dect  stack
0553 245E C646  30         mov   tmp2,*stack           ; Push tmp2
0554 2460 0649  14         dect  stack
0555 2462 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 2464 06A0  32         bl    @xutst0               ; Display string
     2466 2422 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 2468 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 246A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 246C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 246E 06A0  32         bl    @down                 ; Move cursor down
     2470 26D6 
0566               
0567 2472 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 2474 0585  14         inc   tmp1                  ; Consider length byte
0569 2476 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     2478 2002 
0570 247A 1301  14         jeq   !                     ; Yes, skip adjustment
0571 247C 0585  14         inc   tmp1                  ; Make address even
0572 247E 0606  14 !       dec   tmp2
0573 2480 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 2482 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 2484 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 2486 045B  20         b     *r11                  ; Return
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
0020 2488 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 248A C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 248C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 248E C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 2490 1604  14         jne   !                     ; No, continue
0028               
0029 2492 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2494 FFCE 
0030 2496 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2498 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 249A 0264  22 !       ori   tmp0,>4000
     249C 4000 
0035 249E 06C4  14         swpb  tmp0
0036 24A0 D804  38         movb  tmp0,@vdpa
     24A2 8C02 
0037 24A4 06C4  14         swpb  tmp0
0038 24A6 D804  38         movb  tmp0,@vdpa
     24A8 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 24AA 020F  20         li    r15,vdpw              ; Set VDP write address
     24AC 8C00 
0043 24AE C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     24B0 24B8 
     24B2 8320 
0044 24B4 0460  28         b     @mcloop               ; Write data to VDP and return
     24B6 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 24B8 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 24BA C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 24BC C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 24BE C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 24C0 06C4  14 xpyv2m  swpb  tmp0
0027 24C2 D804  38         movb  tmp0,@vdpa
     24C4 8C02 
0028 24C6 06C4  14         swpb  tmp0
0029 24C8 D804  38         movb  tmp0,@vdpa
     24CA 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 24CC 020F  20         li    r15,vdpr              ; Set VDP read address
     24CE 8800 
0034 24D0 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24D2 24DA 
     24D4 8320 
0035 24D6 0460  28         b     @mcloop               ; Read data from VDP
     24D8 8320 
0036 24DA DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24DC C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24DE C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24E0 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24E2 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24E4 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24E6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24E8 FFCE 
0034 24EA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24EC 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24EE 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24F0 0001 
0039 24F2 1603  14         jne   cpym0                 ; No, continue checking
0040 24F4 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24F6 04C6  14         clr   tmp2                  ; Reset counter
0042 24F8 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24FA 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24FC 7FFF 
0047 24FE C1C4  18         mov   tmp0,tmp3
0048 2500 0247  22         andi  tmp3,1
     2502 0001 
0049 2504 1618  14         jne   cpyodd                ; Odd source address handling
0050 2506 C1C5  18 cpym1   mov   tmp1,tmp3
0051 2508 0247  22         andi  tmp3,1
     250A 0001 
0052 250C 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 250E 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2510 2020 
0057 2512 1605  14         jne   cpym3
0058 2514 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     2516 253C 
     2518 8320 
0059 251A 0460  28         b     @mcloop               ; Copy memory and exit
     251C 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 251E C1C6  18 cpym3   mov   tmp2,tmp3
0064 2520 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2522 0001 
0065 2524 1301  14         jeq   cpym4
0066 2526 0606  14         dec   tmp2                  ; Make TMP2 even
0067 2528 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 252A 0646  14         dect  tmp2
0069 252C 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 252E C1C7  18         mov   tmp3,tmp3
0074 2530 1301  14         jeq   cpymz
0075 2532 D554  38         movb  *tmp0,*tmp1
0076 2534 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2536 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     2538 8000 
0081 253A 10E9  14         jmp   cpym2
0082 253C DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 253E C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2540 0649  14         dect  stack
0065 2542 C64B  30         mov   r11,*stack            ; Push return address
0066 2544 0649  14         dect  stack
0067 2546 C640  30         mov   r0,*stack             ; Push r0
0068 2548 0649  14         dect  stack
0069 254A C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 254C 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 254E 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2550 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2552 4000 
0077 2554 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2556 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 2558 020C  20         li    r12,>1e00             ; SAMS CRU address
     255A 1E00 
0082 255C 04C0  14         clr   r0
0083 255E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2560 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2562 D100  18         movb  r0,tmp0
0086 2564 0984  56         srl   tmp0,8                ; Right align
0087 2566 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     2568 833C 
0088 256A 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 256C C339  30         mov   *stack+,r12           ; Pop r12
0094 256E C039  30         mov   *stack+,r0            ; Pop r0
0095 2570 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2572 045B  20         b     *r11                  ; Return to caller
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
0131 2574 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2576 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 2578 0649  14         dect  stack
0135 257A C64B  30         mov   r11,*stack            ; Push return address
0136 257C 0649  14         dect  stack
0137 257E C640  30         mov   r0,*stack             ; Push r0
0138 2580 0649  14         dect  stack
0139 2582 C64C  30         mov   r12,*stack            ; Push r12
0140 2584 0649  14         dect  stack
0141 2586 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 2588 0649  14         dect  stack
0143 258A C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 258C 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 258E 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 2590 0284  22         ci    tmp0,255              ; Crash if page > 255
     2592 00FF 
0153 2594 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 2596 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2598 001E 
0158 259A 150A  14         jgt   !
0159 259C 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     259E 0004 
0160 25A0 1107  14         jlt   !
0161 25A2 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     25A4 0012 
0162 25A6 1508  14         jgt   sams.page.set.switch_page
0163 25A8 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     25AA 0006 
0164 25AC 1501  14         jgt   !
0165 25AE 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 25B0 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     25B2 FFCE 
0170 25B4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     25B6 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 25B8 020C  20         li    r12,>1e00             ; SAMS CRU address
     25BA 1E00 
0176 25BC C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 25BE 06C0  14         swpb  r0                    ; LSB to MSB
0178 25C0 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 25C2 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     25C4 4000 
0180 25C6 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 25C8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 25CA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 25CC C339  30         mov   *stack+,r12           ; Pop r12
0188 25CE C039  30         mov   *stack+,r0            ; Pop r0
0189 25D0 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25D2 045B  20         b     *r11                  ; Return to caller
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
0204 25D4 020C  20         li    r12,>1e00             ; SAMS CRU address
     25D6 1E00 
0205 25D8 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25DA 045B  20         b     *r11                  ; Return to caller
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
0227 25DC 020C  20         li    r12,>1e00             ; SAMS CRU address
     25DE 1E00 
0228 25E0 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25E2 045B  20         b     *r11                  ; Return to caller
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
0260 25E4 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25E6 0649  14         dect  stack
0263 25E8 C64B  30         mov   r11,*stack            ; Save return address
0264 25EA 0649  14         dect  stack
0265 25EC C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25EE 0649  14         dect  stack
0267 25F0 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25F2 0649  14         dect  stack
0269 25F4 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25F6 0649  14         dect  stack
0271 25F8 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25FA 0206  20         li    tmp2,8                ; Set loop counter
     25FC 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25FE C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 2600 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 2602 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2604 2578 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 2606 0606  14         dec   tmp2                  ; Next iteration
0288 2608 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 260A 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     260C 25D4 
0294                                                   ; / activating changes.
0295               
0296 260E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 2610 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 2612 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 2614 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 2616 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 2618 045B  20         b     *r11                  ; Return to caller
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
0318 261A 0649  14         dect  stack
0319 261C C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 261E 06A0  32         bl    @sams.layout
     2620 25E4 
0324 2622 2628                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 2624 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 2626 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 2628 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     262A 0002 
0336 262C 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     262E 0003 
0337 2630 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     2632 000A 
0338 2634 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2636 000B 
0339 2638 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     263A 000C 
0340 263C D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     263E 000D 
0341 2640 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2642 000E 
0342 2644 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2646 000F 
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
0363 2648 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 264A 0649  14         dect  stack
0366 264C C64B  30         mov   r11,*stack            ; Push return address
0367 264E 0649  14         dect  stack
0368 2650 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2652 0649  14         dect  stack
0370 2654 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2656 0649  14         dect  stack
0372 2658 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 265A 0649  14         dect  stack
0374 265C C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 265E 0205  20         li    tmp1,sams.layout.copy.data
     2660 2680 
0379 2662 0206  20         li    tmp2,8                ; Set loop counter
     2664 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2666 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 2668 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     266A 2540 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 266C CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     266E 833C 
0390               
0391 2670 0606  14         dec   tmp2                  ; Next iteration
0392 2672 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2674 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2676 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 2678 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 267A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 267C C2F9  30         mov   *stack+,r11           ; Pop r11
0402 267E 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2680 2000             data  >2000                 ; >2000-2fff
0408 2682 3000             data  >3000                 ; >3000-3fff
0409 2684 A000             data  >a000                 ; >a000-afff
0410 2686 B000             data  >b000                 ; >b000-bfff
0411 2688 C000             data  >c000                 ; >c000-cfff
0412 268A D000             data  >d000                 ; >d000-dfff
0413 268C E000             data  >e000                 ; >e000-efff
0414 268E F000             data  >f000                 ; >f000-ffff
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
0009 2690 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2692 FFBF 
0010 2694 0460  28         b     @putv01
     2696 2348 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2698 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     269A 0040 
0018 269C 0460  28         b     @putv01
     269E 2348 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 26A0 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     26A2 FFDF 
0026 26A4 0460  28         b     @putv01
     26A6 2348 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 26A8 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     26AA 0020 
0034 26AC 0460  28         b     @putv01
     26AE 2348 
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
0010 26B0 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     26B2 FFFE 
0011 26B4 0460  28         b     @putv01
     26B6 2348 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 26B8 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     26BA 0001 
0019 26BC 0460  28         b     @putv01
     26BE 2348 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 26C0 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     26C2 FFFD 
0027 26C4 0460  28         b     @putv01
     26C6 2348 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 26C8 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     26CA 0002 
0035 26CC 0460  28         b     @putv01
     26CE 2348 
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
0018 26D0 C83B  50 at      mov   *r11+,@wyx
     26D2 832A 
0019 26D4 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26D6 B820  54 down    ab    @hb$01,@wyx
     26D8 2012 
     26DA 832A 
0028 26DC 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26DE 7820  54 up      sb    @hb$01,@wyx
     26E0 2012 
     26E2 832A 
0037 26E4 045B  20         b     *r11
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
0049 26E6 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26E8 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26EA 832A 
0051 26EC C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26EE 832A 
0052 26F0 045B  20         b     *r11
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
0021 26F2 C120  34 yx2px   mov   @wyx,tmp0
     26F4 832A 
0022 26F6 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26F8 06C4  14         swpb  tmp0                  ; Y<->X
0024 26FA 04C5  14         clr   tmp1                  ; Clear before copy
0025 26FC D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26FE 20A0  38         coc   @wbit1,config         ; f18a present ?
     2700 201E 
0030 2702 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2704 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2706 833A 
     2708 2732 
0032 270A 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 270C 0A15  56         sla   tmp1,1                ; X = X * 2
0035 270E B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 2710 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     2712 0500 
0037 2714 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2716 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 2718 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 271A 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 271C D105  18         movb  tmp1,tmp0
0051 271E 06C4  14         swpb  tmp0                  ; X<->Y
0052 2720 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     2722 2020 
0053 2724 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 2726 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     2728 2012 
0059 272A 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     272C 2024 
0060 272E 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 2730 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 2732 0050            data   80
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
0013 2734 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2736 06A0  32         bl    @putvr                ; Write once
     2738 2334 
0015 273A 391C             data  >391c                 ; VR1/57, value 00011100
0016 273C 06A0  32         bl    @putvr                ; Write twice
     273E 2334 
0017 2740 391C             data  >391c                 ; VR1/57, value 00011100
0018 2742 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2744 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 2746 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2748 2334 
0028 274A 391C             data  >391c
0029 274C 0458  20         b     *tmp4                 ; Exit
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
0040 274E C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2750 06A0  32         bl    @cpym2v
     2752 2488 
0042 2754 3F00             data  >3f00,f18chk_gpu,8    ; Copy F18A GPU code to VRAM
     2756 2792 
     2758 0008 
0043 275A 06A0  32         bl    @putvr
     275C 2334 
0044 275E 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2760 06A0  32         bl    @putvr
     2762 2334 
0046 2764 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2766 0204  20         li    tmp0,>3f00
     2768 3F00 
0052 276A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     276C 22BC 
0053 276E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2770 8800 
0054 2772 0984  56         srl   tmp0,8
0055 2774 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2776 8800 
0056 2778 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 277A 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 277C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     277E BFFF 
0060 2780 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2782 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2784 4000 
0063               f18chk_exit:
0064 2786 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2788 2290 
0065 278A 3F00             data  >3f00,>00,6
     278C 0000 
     278E 0006 
0066 2790 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2792 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2794 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2796 0340             data  >0340                 ; 3f04   0340  idle
0074 2798 10FF             data  >10ff                 ; 3f06   10ff  jmp $
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
0093 279A C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0094                       ;------------------------------------------------------
0095                       ; Reset all F18a VDP registers to power-on defaults
0096                       ;------------------------------------------------------
0097 279C 06A0  32         bl    @putvr
     279E 2334 
0098 27A0 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0099               
0100 27A2 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     27A4 2334 
0101 27A6 391C             data  >391c                 ; Lock the F18a
0102 27A8 0458  20         b     *tmp4                 ; Exit
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
0121 27AA C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0122 27AC 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27AE 201E 
0123 27B0 1609  14         jne   f18fw1
0124               ***************************************************************
0125               * Read F18A major/minor version
0126               ***************************************************************
0127 27B2 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27B4 8802 
0128 27B6 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27B8 2334 
0129 27BA 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0130 27BC 04C4  14         clr   tmp0
0131 27BE D120  34         movb  @vdps,tmp0
     27C0 8802 
0132 27C2 0984  56         srl   tmp0,8
0133 27C4 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 27C6 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27C8 832A 
0018 27CA D17B  28         movb  *r11+,tmp1
0019 27CC 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27CE D1BB  28         movb  *r11+,tmp2
0021 27D0 0986  56         srl   tmp2,8                ; Repeat count
0022 27D2 C1CB  18         mov   r11,tmp3
0023 27D4 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27D6 23FC 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27D8 020B  20         li    r11,hchar1
     27DA 27E0 
0028 27DC 0460  28         b     @xfilv                ; Draw
     27DE 2296 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27E0 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27E2 2022 
0033 27E4 1302  14         jeq   hchar2                ; Yes, exit
0034 27E6 C2C7  18         mov   tmp3,r11
0035 27E8 10EE  14         jmp   hchar                 ; Next one
0036 27EA 05C7  14 hchar2  inct  tmp3
0037 27EC 0457  20         b     *tmp3                 ; Exit
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
0016 27EE 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27F0 2020 
0017 27F2 020C  20         li    r12,>0024
     27F4 0024 
0018 27F6 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27F8 288A 
0019 27FA 04C6  14         clr   tmp2
0020 27FC 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27FE 04CC  14         clr   r12
0025 2800 1F08  20         tb    >0008                 ; Shift-key ?
0026 2802 1302  14         jeq   realk1                ; No
0027 2804 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     2806 28BA 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 2808 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 280A 1302  14         jeq   realk2                ; No
0033 280C 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     280E 28EA 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 2810 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 2812 1302  14         jeq   realk3                ; No
0039 2814 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     2816 291A 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 2818 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     281A 200C 
0044 281C 1E15  20         sbz   >0015                 ; Set P5
0045 281E 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 2820 1302  14         jeq   realk4                ; No
0047 2822 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     2824 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 2826 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 2828 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     282A 0006 
0053 282C 0606  14 realk5  dec   tmp2
0054 282E 020C  20         li    r12,>24               ; CRU address for P2-P4
     2830 0024 
0055 2832 06C6  14         swpb  tmp2
0056 2834 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2836 06C6  14         swpb  tmp2
0058 2838 020C  20         li    r12,6                 ; CRU read address
     283A 0006 
0059 283C 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 283E 0547  14         inv   tmp3                  ;
0061 2840 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2842 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2844 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2846 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2848 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 284A 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 284C 0285  22         ci    tmp1,8
     284E 0008 
0070 2850 1AFA  14         jl    realk6
0071 2852 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2854 1BEB  14         jh    realk5                ; No, next column
0073 2856 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2858 C206  18 realk8  mov   tmp2,tmp4
0078 285A 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 285C A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 285E A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2860 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2862 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2864 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2866 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2868 200C 
0089 286A 1608  14         jne   realka                ; No, continue saving key
0090 286C 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     286E 28B4 
0091 2870 1A05  14         jl    realka
0092 2872 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2874 28B2 
0093 2876 1B02  14         jh    realka                ; No, continue
0094 2878 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     287A E000 
0095 287C C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     287E 833C 
0096 2880 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2882 200A 
0097 2884 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2886 8C00 
0098                                                   ; / using R15 as temp storage
0099 2888 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 288A FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     288C 0000 
     288E FF0D 
     2890 203D 
0102 2892 ....             text  'xws29ol.'
0103 289A ....             text  'ced38ik,'
0104 28A2 ....             text  'vrf47ujm'
0105 28AA ....             text  'btg56yhn'
0106 28B2 ....             text  'zqa10p;/'
0107 28BA FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     28BC 0000 
     28BE FF0D 
     28C0 202B 
0108 28C2 ....             text  'XWS@(OL>'
0109 28CA ....             text  'CED#*IK<'
0110 28D2 ....             text  'VRF$&UJM'
0111 28DA ....             text  'BTG%^YHN'
0112 28E2 ....             text  'ZQA!)P:-'
0113 28EA FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28EC 0000 
     28EE FF0D 
     28F0 2005 
0114 28F2 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28F4 0804 
     28F6 0F27 
     28F8 C2B9 
0115 28FA 600B             data  >600b,>0907,>063f,>c1B8
     28FC 0907 
     28FE 063F 
     2900 C1B8 
0116 2902 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     2904 7B02 
     2906 015F 
     2908 C0C3 
0117 290A BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     290C 7D0E 
     290E 0CC6 
     2910 BFC4 
0118 2912 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     2914 7C03 
     2916 BC22 
     2918 BDBA 
0119 291A FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     291C 0000 
     291E FF0D 
     2920 209D 
0120 2922 9897             data  >9897,>93b2,>9f8f,>8c9B
     2924 93B2 
     2926 9F8F 
     2928 8C9B 
0121 292A 8385             data  >8385,>84b3,>9e89,>8b80
     292C 84B3 
     292E 9E89 
     2930 8B80 
0122 2932 9692             data  >9692,>86b4,>b795,>8a8D
     2934 86B4 
     2936 B795 
     2938 8A8D 
0123 293A 8294             data  >8294,>87b5,>b698,>888E
     293C 87B5 
     293E B698 
     2940 888E 
0124 2942 9A91             data  >9a91,>81b1,>b090,>9cBB
     2944 81B1 
     2946 B090 
     2948 9CBB 
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
0023 294A C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 294C C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     294E 8340 
0025 2950 04E0  34         clr   @waux1
     2952 833C 
0026 2954 04E0  34         clr   @waux2
     2956 833E 
0027 2958 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     295A 833C 
0028 295C C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 295E 0205  20         li    tmp1,4                ; 4 nibbles
     2960 0004 
0033 2962 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2964 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2966 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2968 0286  22         ci    tmp2,>000a
     296A 000A 
0039 296C 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 296E C21B  26         mov   *r11,tmp4
0045 2970 0988  56         srl   tmp4,8                ; Right justify
0046 2972 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2974 FFF6 
0047 2976 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2978 C21B  26         mov   *r11,tmp4
0054 297A 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     297C 00FF 
0055               
0056 297E A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2980 06C6  14         swpb  tmp2
0058 2982 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2984 0944  56         srl   tmp0,4                ; Next nibble
0060 2986 0605  14         dec   tmp1
0061 2988 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 298A 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     298C BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 298E C160  34         mov   @waux3,tmp1           ; Get pointer
     2990 8340 
0067 2992 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2994 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2996 C120  34         mov   @waux2,tmp0
     2998 833E 
0070 299A 06C4  14         swpb  tmp0
0071 299C DD44  32         movb  tmp0,*tmp1+
0072 299E 06C4  14         swpb  tmp0
0073 29A0 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 29A2 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     29A4 8340 
0078 29A6 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     29A8 2016 
0079 29AA 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 29AC C120  34         mov   @waux1,tmp0
     29AE 833C 
0084 29B0 06C4  14         swpb  tmp0
0085 29B2 DD44  32         movb  tmp0,*tmp1+
0086 29B4 06C4  14         swpb  tmp0
0087 29B6 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 29B8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29BA 2020 
0092 29BC 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29BE 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29C0 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29C2 7FFF 
0098 29C4 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29C6 8340 
0099 29C8 0460  28         b     @xutst0               ; Display string
     29CA 2422 
0100 29CC 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29CE C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29D0 832A 
0122 29D2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29D4 8000 
0123 29D6 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29D8 0207  20 mknum   li    tmp3,5                ; Digit counter
     29DA 0005 
0020 29DC C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29DE C155  26         mov   *tmp1,tmp1            ; /
0022 29E0 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29E2 0228  22         ai    tmp4,4                ; Get end of buffer
     29E4 0004 
0024 29E6 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29E8 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29EA 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29EC 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29EE 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29F0 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29F2 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29F4 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29F6 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29F8 0607  14         dec   tmp3                  ; Decrease counter
0036 29FA 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29FC 0207  20         li    tmp3,4                ; Check first 4 digits
     29FE 0004 
0041 2A00 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2A02 C11B  26         mov   *r11,tmp0
0043 2A04 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2A06 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2A08 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2A0A 05CB  14 mknum3  inct  r11
0047 2A0C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A0E 2020 
0048 2A10 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2A12 045B  20         b     *r11                  ; Exit
0050 2A14 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2A16 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2A18 13F8  14         jeq   mknum3                ; Yes, exit
0053 2A1A 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2A1C 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A1E 7FFF 
0058 2A20 C10B  18         mov   r11,tmp0
0059 2A22 0224  22         ai    tmp0,-4
     2A24 FFFC 
0060 2A26 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A28 0206  20         li    tmp2,>0500            ; String length = 5
     2A2A 0500 
0062 2A2C 0460  28         b     @xutstr               ; Display string
     2A2E 2424 
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
0093 2A30 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A32 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A34 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A36 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A38 0207  20         li    tmp3,5                ; Set counter
     2A3A 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A3C 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A3E 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A40 0584  14         inc   tmp0                  ; Next character
0105 2A42 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A44 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A46 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A48 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A4A DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A4C 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A4E DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A50 0607  14         dec   tmp3                  ; Last character ?
0121 2A52 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A54 045B  20         b     *r11                  ; Return
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
0139 2A56 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A58 832A 
0140 2A5A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A5C 8000 
0141 2A5E 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A60 0649  14         dect  stack
0023 2A62 C64B  30         mov   r11,*stack            ; Save return address
0024 2A64 0649  14         dect  stack
0025 2A66 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A68 0649  14         dect  stack
0027 2A6A C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A6C 0649  14         dect  stack
0029 2A6E C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A70 0649  14         dect  stack
0031 2A72 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A74 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A76 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A78 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A7A 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A7C 0649  14         dect  stack
0044 2A7E C64B  30         mov   r11,*stack            ; Save return address
0045 2A80 0649  14         dect  stack
0046 2A82 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A84 0649  14         dect  stack
0048 2A86 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A88 0649  14         dect  stack
0050 2A8A C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A8C 0649  14         dect  stack
0052 2A8E C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A90 C1D4  26 !       mov   *tmp0,tmp3
0057 2A92 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A94 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A96 00FF 
0059 2A98 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A9A 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A9C 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A9E 0584  14         inc   tmp0                  ; Next byte
0067 2AA0 0607  14         dec   tmp3                  ; Shorten string length
0068 2AA2 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2AA4 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2AA6 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2AA8 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2AAA 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2AAC C187  18         mov   tmp3,tmp2
0078 2AAE 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2AB0 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2AB2 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2AB4 24E2 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2AB6 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2AB8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2ABA FFCE 
0090 2ABC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2ABE 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2AC0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AC2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2AC4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2AC6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2AC8 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2ACA 045B  20         b     *r11                  ; Return to caller
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
0123 2ACC 0649  14         dect  stack
0124 2ACE C64B  30         mov   r11,*stack            ; Save return address
0125 2AD0 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AD2 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AD4 0649  14         dect  stack
0128 2AD6 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2AD8 0649  14         dect  stack
0130 2ADA C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2ADC 0649  14         dect  stack
0132 2ADE C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AE0 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AE2 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AE4 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AE6 0649  14         dect  stack
0144 2AE8 C64B  30         mov   r11,*stack            ; Save return address
0145 2AEA 0649  14         dect  stack
0146 2AEC C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AEE 0649  14         dect  stack
0148 2AF0 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AF2 0649  14         dect  stack
0150 2AF4 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AF6 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AF8 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AFA 0586  14         inc   tmp2
0161 2AFC 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2AFE 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2B00 0286  22         ci    tmp2,255
     2B02 00FF 
0167 2B04 1505  14         jgt   string.getlenc.panic
0168 2B06 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2B08 0606  14         dec   tmp2                  ; One time adjustment
0174 2B0A C806  38         mov   tmp2,@waux1           ; Store length
     2B0C 833C 
0175 2B0E 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2B10 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B12 FFCE 
0181 2B14 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B16 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2B18 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2B1A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2B1C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2B1E C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2B20 045B  20         b     *r11                  ; Return to caller
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
0056 2B22 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2B24 2B26             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2B26 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2B28 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2B2A A428 
0064 2B2C 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2B2E 201C 
0065 2B30 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2B32 8356 
0066 2B34 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B36 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B38 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B3A C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B3C A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B3E 06C0  14         swpb  r0                    ;
0075 2B40 D800  38         movb  r0,@vdpa              ; Send low byte
     2B42 8C02 
0076 2B44 06C0  14         swpb  r0                    ;
0077 2B46 D800  38         movb  r0,@vdpa              ; Send high byte
     2B48 8C02 
0078 2B4A D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B4C 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B4E 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B50 0704  14         seto  r4                    ; Init counter
0086 2B52 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B54 A420 
0087 2B56 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B58 0584  14         inc   r4                    ; Increment char counter
0089 2B5A 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B5C 0007 
0090 2B5E 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B60 80C4  18         c     r4,r3                 ; End of name?
0093 2B62 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B64 06C0  14         swpb  r0                    ;
0098 2B66 D800  38         movb  r0,@vdpa              ; Send low byte
     2B68 8C02 
0099 2B6A 06C0  14         swpb  r0                    ;
0100 2B6C D800  38         movb  r0,@vdpa              ; Send high byte
     2B6E 8C02 
0101 2B70 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B72 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B74 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B76 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B78 2C8E 
0109 2B7A 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B7C C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B7E 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B80 04E0  34         clr   @>83d0
     2B82 83D0 
0118 2B84 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B86 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B88 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B8A A432 
0121               
0122 2B8C 0584  14         inc   r4                    ; Adjust for dot
0123 2B8E A804  38         a     r4,@>8356             ; Point to position after name
     2B90 8356 
0124 2B92 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B94 8356 
     2B96 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B98 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B9A 83E0 
0130 2B9C 04C1  14         clr   r1                    ; Version found of dsr
0131 2B9E 020C  20         li    r12,>0f00             ; Init cru address
     2BA0 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2BA2 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2BA4 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2BA6 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2BA8 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2BAA 0100 
0145 2BAC 04E0  34         clr   @>83d0                ; Clear in case we are done
     2BAE 83D0 
0146 2BB0 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2BB2 2000 
0147 2BB4 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2BB6 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2BB8 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2BBA 1D00  20         sbo   0                     ; Turn on ROM
0154 2BBC 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2BBE 4000 
0155 2BC0 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2BC2 2C8A 
0156 2BC4 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2BC6 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2BC8 A40A 
0166 2BCA 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2BCC C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2BCE 83D2 
0172                                                   ; subprogram
0173               
0174 2BD0 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2BD2 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BD4 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BD6 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BD8 83D2 
0183                                                   ; subprogram
0184               
0185 2BDA 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BDC C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BDE 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BE0 D160  34         movb  @>8355,r5             ; Get length as counter
     2BE2 8355 
0195 2BE4 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BE6 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BE8 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BEA 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BEC 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BEE A420 
0206 2BF0 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BF2 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BF4 0605  14         dec   r5                    ; Update loop counter
0211 2BF6 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BF8 0581  14         inc   r1                    ; Next version found
0217 2BFA C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BFC A42A 
0218 2BFE C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C00 A42C 
0219 2C02 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C04 A430 
0220               
0221 2C06 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C08 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C0A 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2C0C 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2C0E 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2C10 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C12 A400 
0233 2C14 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2C16 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2C18 A428 
0239                                                   ; (8 or >a)
0240 2C1A 0281  22         ci    r1,8                  ; was it 8?
     2C1C 0008 
0241 2C1E 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2C20 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2C22 8350 
0243                                                   ; Get error byte from @>8350
0244 2C24 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2C26 06C0  14         swpb  r0                    ;
0252 2C28 D800  38         movb  r0,@vdpa              ; send low byte
     2C2A 8C02 
0253 2C2C 06C0  14         swpb  r0                    ;
0254 2C2E D800  38         movb  r0,@vdpa              ; send high byte
     2C30 8C02 
0255 2C32 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C34 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C36 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C38 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C3A 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C3C 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C3E 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C40 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C42 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C44 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C46 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C48 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C4A 201C 
0281                                                   ; / to indicate error
0282 2C4C 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C4E A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C50 2C52             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C52 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C54 83E0 
0316               
0317 2C56 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C58 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C5A 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C5C A42A 
0322 2C5E C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C60 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C62 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C64 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C66 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C68 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C6A 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C6C 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C6E 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C70 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C72 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C74 4000 
     2C76 2C8A 
0337 2C78 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C7A 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C7C 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C7E 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C80 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C82 A400 
0355 2C84 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C86 A434 
0356               
0357 2C88 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C8A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C8C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C8E ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2C90 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C92 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C94 0649  14         dect  stack
0052 2C96 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C98 0204  20         li    tmp0,dsrlnk.savcru
     2C9A A42A 
0057 2C9C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2C9E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2CA0 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2CA2 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2CA4 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2CA6 37D7 
0065 2CA8 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2CAA 8370 
0066                                                   ; / location
0067 2CAC C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2CAE A44C 
0068 2CB0 04C5  14         clr   tmp1                  ; io.op.open
0069 2CB2 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2CB4 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2CB6 0649  14         dect  stack
0097 2CB8 C64B  30         mov   r11,*stack            ; Save return address
0098 2CBA 0205  20         li    tmp1,io.op.close      ; io.op.close
     2CBC 0001 
0099 2CBE 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2CC0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2CC2 0649  14         dect  stack
0125 2CC4 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2CC6 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CC8 0002 
0128 2CCA 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2CCC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2CCE 0649  14         dect  stack
0155 2CD0 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2CD2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CD4 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CD6 0005 
0159               
0160 2CD8 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CDA A43E 
0161               
0162 2CDC 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CDE 22CE 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CE0 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CE2 0003 
0167 2CE4 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CE6 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CE8 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CEA 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CEC 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CEE 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CF0 1000  14         nop
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
0227 2CF2 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CF4 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CF6 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CF8 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CFA A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CFC 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2CFE 22CE 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D00 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D02 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D04 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D06 A44C 
0246               
0247 2D08 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D0A 22CE 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D0C 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D0E 0009 
0254 2D10 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2D12 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2D14 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2D16 8322 
     2D18 833C 
0259               
0260 2D1A C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2D1C A42A 
0261 2D1E 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2D20 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2D22 2B22 
0268 2D24 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2D26 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2D28 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2D2A 2C4E 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2D2C 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2D2E C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2D30 833C 
     2D32 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D34 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D36 A436 
0292 2D38 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D3A 0005 
0293 2D3C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D3E 22E6 
0294 2D40 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D42 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D44 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D46 045B  20         b     *r11                  ; Return to caller
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
0020 2D48 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D4A 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D4C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D4E 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D50 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D52 201C 
0029 2D54 1602  14         jne   tmgr1a                ; No, so move on
0030 2D56 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D58 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D5A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D5C 2020 
0035 2D5E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D60 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D62 2010 
0048 2D64 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D66 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D68 200E 
0050 2D6A 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D6C 0460  28         b     @kthread              ; Run kernel thread
     2D6E 2DE6 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D70 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D72 2014 
0056 2D74 13EB  14         jeq   tmgr1
0057 2D76 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D78 2012 
0058 2D7A 16E8  14         jne   tmgr1
0059 2D7C C120  34         mov   @wtiusr,tmp0
     2D7E 832E 
0060 2D80 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D82 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D84 2DE4 
0065 2D86 C10A  18         mov   r10,tmp0
0066 2D88 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D8A 00FF 
0067 2D8C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D8E 201C 
0068 2D90 1303  14         jeq   tmgr5
0069 2D92 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D94 003C 
0070 2D96 1002  14         jmp   tmgr6
0071 2D98 0284  22 tmgr5   ci    tmp0,50
     2D9A 0032 
0072 2D9C 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D9E 1001  14         jmp   tmgr8
0074 2DA0 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2DA2 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2DA4 832C 
0079 2DA6 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2DA8 FF00 
0080 2DAA C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2DAC 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2DAE 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2DB0 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2DB2 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2DB4 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2DB6 830C 
     2DB8 830D 
0089 2DBA 1608  14         jne   tmgr10                ; No, get next slot
0090 2DBC 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2DBE FF00 
0091 2DC0 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2DC2 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2DC4 8330 
0096 2DC6 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2DC8 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2DCA 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2DCC 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2DCE 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2DD0 8315 
     2DD2 8314 
0103 2DD4 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DD6 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DD8 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DDA 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DDC 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DDE 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DE0 FF00 
0109 2DE2 10B4  14         jmp   tmgr1
0110 2DE4 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DE6 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DE8 2010 
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
0041 2DEA 06A0  32         bl    @realkb               ; Scan full keyboard
     2DEC 27EE 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DEE 0460  28         b     @tmgr3                ; Exit
     2DF0 2D70 
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
0017 2DF2 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DF4 832E 
0018 2DF6 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DF8 2012 
0019 2DFA 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D4C     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DFC 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DFE 832E 
0029 2E00 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E02 FEFF 
0030 2E04 045B  20         b     *r11                  ; Return
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
0017 2E06 C13B  30 mkslot  mov   *r11+,tmp0
0018 2E08 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2E0A C184  18         mov   tmp0,tmp2
0023 2E0C 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2E0E A1A0  34         a     @wtitab,tmp2          ; Add table base
     2E10 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2E12 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2E14 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2E16 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2E18 881B  46         c     *r11,@w$ffff          ; End of list ?
     2E1A 2022 
0035 2E1C 1301  14         jeq   mkslo1                ; Yes, exit
0036 2E1E 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2E20 05CB  14 mkslo1  inct  r11
0041 2E22 045B  20         b     *r11                  ; Exit
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
0052 2E24 C13B  30 clslot  mov   *r11+,tmp0
0053 2E26 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2E28 A120  34         a     @wtitab,tmp0          ; Add table base
     2E2A 832C 
0055 2E2C 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2E2E 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2E30 045B  20         b     *r11                  ; Exit
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
0068 2E32 C13B  30 rsslot  mov   *r11+,tmp0
0069 2E34 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E36 A120  34         a     @wtitab,tmp0          ; Add table base
     2E38 832C 
0071 2E3A 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E3C C154  26         mov   *tmp0,tmp1
0073 2E3E 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E40 FF00 
0074 2E42 C505  30         mov   tmp1,*tmp0
0075 2E44 045B  20         b     *r11                  ; Exit
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
0260 2E46 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E48 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E4A 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E4C 0000 
0266 2E4E 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E50 8300 
0267 2E52 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E54 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E56 0202  20 runli2  li    r2,>8308
     2E58 8308 
0272 2E5A 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E5C 0282  22         ci    r2,>8400
     2E5E 8400 
0274 2E60 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E62 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E64 FFFF 
0279 2E66 1602  14         jne   runli4                ; No, continue
0280 2E68 0420  54         blwp  @0                    ; Yes, bye bye
     2E6A 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E6C C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E6E 833C 
0285 2E70 04C1  14         clr   r1                    ; Reset counter
0286 2E72 0202  20         li    r2,10                 ; We test 10 times
     2E74 000A 
0287 2E76 C0E0  34 runli5  mov   @vdps,r3
     2E78 8802 
0288 2E7A 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E7C 2020 
0289 2E7E 1302  14         jeq   runli6
0290 2E80 0581  14         inc   r1                    ; Increase counter
0291 2E82 10F9  14         jmp   runli5
0292 2E84 0602  14 runli6  dec   r2                    ; Next test
0293 2E86 16F7  14         jne   runli5
0294 2E88 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E8A 1250 
0295 2E8C 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E8E 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E90 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E92 06A0  32 runli7  bl    @loadmc
     2E94 221C 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E96 04C1  14 runli9  clr   r1
0305 2E98 04C2  14         clr   r2
0306 2E9A 04C3  14         clr   r3
0307 2E9C 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2E9E 3000 
0308 2EA0 020F  20         li    r15,vdpw              ; Set VDP write address
     2EA2 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2EA4 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2EA6 4A4A 
0317 2EA8 1605  14         jne   runlia
0318 2EAA 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2EAC 2290 
0319 2EAE 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2EB0 0000 
     2EB2 3000 
0324 2EB4 06A0  32 runlia  bl    @filv
     2EB6 2290 
0325 2EB8 0FC0             data  pctadr,spfclr,16      ; Load color table
     2EBA 00F4 
     2EBC 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2EBE 06A0  32         bl    @f18unl               ; Unlock the F18A
     2EC0 2734 
0333 2EC2 06A0  32         bl    @f18chk               ; Check if F18A is there
     2EC4 274E 
0334 2EC6 06A0  32         bl    @f18lck               ; Lock the F18A again
     2EC8 2744 
0335               
0336 2ECA 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2ECC 2334 
0337 2ECE 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2ED0 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2ED2 22FA 
0351 2ED4 339A             data  spvmod                ; Equate selected video mode table
0352 2ED6 0204  20         li    tmp0,spfont           ; Get font option
     2ED8 000C 
0353 2EDA 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EDC 1304  14         jeq   runlid                ; Yes, skip it
0355 2EDE 06A0  32         bl    @ldfnt
     2EE0 2362 
0356 2EE2 1100             data  fntadr,spfont         ; Load specified font
     2EE4 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EE6 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EE8 4A4A 
0361 2EEA 1602  14         jne   runlie                ; No, continue
0362 2EEC 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EEE 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EF0 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EF2 0040 
0367 2EF4 0460  28         b     @main                 ; Give control to main program
     2EF6 6036 
**** **** ****     > stevie_b1.asm.393026
0041                                                   ; Relocated spectra2 in low MEMEXP, was
0042                                                   ; copied to >2000 from ROM in bank 0
0043                       ;------------------------------------------------------
0044                       ; End of File marker
0045                       ;------------------------------------------------------
0046 2EF8 DEAD             data >dead,>beef,>dead,>beef
     2EFA BEEF 
     2EFC DEAD 
     2EFE BEEF 
0048               ***************************************************************
0049               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0050               ********|*****|*********************|**************************
0051                       aorg  >3000
0052                       ;------------------------------------------------------
0053                       ; Activate bank 1 and branch to  >6036
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
     30E0 2238 
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
     311A 2238 
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
     3150 2578 
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
     318A 2578 
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
     31DA 2578 
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
     321A 3526 
0043 321C C804  38         mov   tmp0,@edb.filename.ptr
     321E A212 
0044               
0045 3220 0204  20         li    tmp0,txt.filetype.none
     3222 35E0 
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
     325C 2238 
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
     3278 2238 
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
     32C6 27C6 
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
     32E0 29D8 
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
     32F4 2A30 
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
     3336 24E2 
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
     3380 25E4 
0023 3382 33B2                   data mem.sams.layout.data
0024               
0025 3384 06A0  32         bl    @sams.layout.copy
     3386 2648 
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
0017 3442 4B42             byte  75
0018 3443 ....             text  'Build: 210531-393026 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 348E 012C             byte  1
0024 348F ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 3490 0520             byte  5
0029 3491 ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 3496 034F             byte  3
0034 3497 ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 349A 0349             byte  3
0039 349B ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 349E 012A             byte  1
0044 349F ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 34A0 0A4C             byte  10
0049 34A1 ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 34AC 0A53             byte  10
0054 34AD ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 34B8 1244             byte  18
0059 34B9 ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 34CC 1143             byte  17
0064 34CD ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 34DE 104D             byte  16
0069 34DF ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 34F0 1D53             byte  29
0074 34F1 ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 350E 0846             byte  8
0079 350F ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 3518 026B             byte  2
0084 3519 ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 351C 054C             byte  5
0089 351D ....             text  'Lines'
0090                       even
0091               
0092               txt.bufnum
0093 3522 0323             byte  3
0094 3523 ....             text  '#1 '
0095                       even
0096               
0097               txt.newfile
0098 3526 0A5B             byte  10
0099 3527 ....             text  '[New file]'
0100                       even
0101               
0102               txt.filetype.dv80
0103 3532 0444             byte  4
0104 3533 ....             text  'DV80'
0105                       even
0106               
0107               txt.m1
0108 3538 034D             byte  3
0109 3539 ....             text  'M1='
0110                       even
0111               
0112               txt.m2
0113 353C 034D             byte  3
0114 353D ....             text  'M2='
0115                       even
0116               
0117               txt.keys.default
0118 3540 135E             byte  19
0119 3541 ....             text  '^Help, ^Open, ^Save'
0120                       even
0121               
0122               txt.keys.block
0123 3554 2B5E             byte  43
0124 3555 ....             text  '^Del, ^Copy, ^Move, ^Goto M1, ^Reset, ^Save'
0125                       even
0126               
0127 3580 ....     txt.ruler          text    '.........'
0128                                  byte    18
0129 358A ....                        text    '.........'
0130                                  byte    19
0131 3594 ....                        text    '.........'
0132                                  byte    20
0133 359E ....                        text    '.........'
0134                                  byte    21
0135 35A8 ....                        text    '.........'
0136                                  byte    22
0137 35B2 ....                        text    '.........'
0138                                  byte    23
0139 35BC ....                        text    '.........'
0140                                  byte    24
0141 35C6 ....                        text    '.........'
0142                                  byte    25
0143                                  even
0144               
0145 35D0 020E     txt.alpha.down     data >020e,>0f00
     35D2 0F00 
0146 35D4 0110     txt.vertline       data >0110
0147               
0148               txt.ws1
0149 35D6 0120             byte  1
0150 35D7 ....             text  ' '
0151                       even
0152               
0153               txt.ws2
0154 35D8 0220             byte  2
0155 35D9 ....             text  '  '
0156                       even
0157               
0158               txt.ws3
0159 35DC 0320             byte  3
0160 35DD ....             text  '   '
0161                       even
0162               
0163               txt.ws4
0164 35E0 0420             byte  4
0165 35E1 ....             text  '    '
0166                       even
0167               
0168               txt.ws5
0169 35E6 0520             byte  5
0170 35E7 ....             text  '     '
0171                       even
0172               
0173      35E0     txt.filetype.none  equ txt.ws4
0174               
0175               
0176               ;--------------------------------------------------------------
0177               ; Dialog Load DV 80 file
0178               ;--------------------------------------------------------------
0179 35EC 1301     txt.head.load      byte 19,1,3,32
     35EE 0320 
0180 35F0 ....                        text 'Open DV80 file '
0181                                  byte 2
0182               txt.hint.load
0183 3600 4746             byte  71
0184 3601 ....             text  'Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0185                       even
0186               
0187               txt.keys.load
0188 3648 3246             byte  50
0189 3649 ....             text  'F9=Back, F3=Clear, F5=Fastmode, F-H=Home, F-L=End '
0190                       even
0191               
0192               txt.keys.load2
0193 367C 3246             byte  50
0194 367D ....             text  'F9=Back, F3=Clear, *F5=Fastmode, F-H=Home, F-L=End'
0195                       even
0196               
0197               
0198               ;--------------------------------------------------------------
0199               ; Dialog Save DV 80 file
0200               ;--------------------------------------------------------------
0201 36B0 1301     txt.head.save      byte 19,1,3,32
     36B2 0320 
0202 36B4 ....                        text 'Save DV80 file '
0203                                  byte 2
0204 36C4 2301     txt.head.save2     byte 35,1,3,32
     36C6 0320 
0205 36C8 ....                        text 'Save marked block to DV80 file '
0206                                  byte 2
0207               txt.hint.save
0208 36E8 0120             byte  1
0209 36E9 ....             text  ' '
0210                       even
0211               
0212               txt.keys.save
0213 36EA 2446             byte  36
0214 36EB ....             text  'F9=Back, F3=Clear, F-H=Home, F-L=End'
0215                       even
0216               
0217               
0218               ;--------------------------------------------------------------
0219               ; Dialog "Unsaved changes"
0220               ;--------------------------------------------------------------
0221 3710 1401     txt.head.unsaved   byte 20,1,3,32
     3712 0320 
0222 3714 ....                        text 'Unsaved changes '
0223 3724 0221                        byte 2
0224               txt.info.unsaved
0225                       byte  33
0226 3726 ....             text  'Warning! Unsaved changes in file.'
0227                       even
0228               
0229               txt.hint.unsaved
0230 3748 2A50             byte  42
0231 3749 ....             text  'Press F6 to proceed or ENTER to save file.'
0232                       even
0233               
0234               txt.keys.unsaved
0235 3774 2446             byte  36
0236 3775 ....             text  'F9=Back, F6=Proceed, ENTER=Save file'
0237                       even
0238               
0239               
0240               ;--------------------------------------------------------------
0241               ; Dialog "About"
0242               ;--------------------------------------------------------------
0243 379A 0A01     txt.head.about     byte 10,1,3,32
     379C 0320 
0244 379E ....                        text 'About '
0245 37A4 0200                        byte 2
0246               
0247               txt.info.about
0248                       byte  0
0249 37A6 ....             text
0250                       even
0251               
0252               txt.hint.about
0253 37A6 2650             byte  38
0254 37A7 ....             text  'Press F9 or ENTER to return to editor.'
0255                       even
0256               
0257 37CE 2746     txt.keys.about     byte 39
0258 37CF ....                        text 'F9=Back, ENTER=Back, '
0259 37E4 0E0F                        byte 14,15
0260 37E6 ....                        text '=Alpha Lock down'
0261               
0262               ;--------------------------------------------------------------
0263               ; Strings for error line pane
0264               ;--------------------------------------------------------------
0265               txt.ioerr.load
0266 37F6 2049             byte  32
0267 37F7 ....             text  'I/O error. Failed loading file: '
0268                       even
0269               
0270               txt.ioerr.save
0271 3818 2049             byte  32
0272 3819 ....             text  'I/O error. Failed saving file:  '
0273                       even
0274               
0275               txt.memfull.load
0276 383A 4049             byte  64
0277 383B ....             text  'Index memory full. Could not fully load file into editor buffer.'
0278                       even
0279               
0280               txt.io.nofile
0281 387C 2149             byte  33
0282 387D ....             text  'I/O error. No filename specified.'
0283                       even
0284               
0285               txt.block.inside
0286 389E 3445             byte  52
0287 389F ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0288                       even
0289               
0290               
0291               ;--------------------------------------------------------------
0292               ; Strings for command buffer
0293               ;--------------------------------------------------------------
0294               txt.cmdb.prompt
0295 38D4 013E             byte  1
0296 38D5 ....             text  '>'
0297                       even
0298               
0299               txt.colorscheme
0300 38D6 0D43             byte  13
0301 38D7 ....             text  'Color scheme:'
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
0022 38E4 DEAD             data  >dead,>beef,>dead,>beef
     38E6 BEEF 
     38E8 DEAD 
     38EA BEEF 
**** **** ****     > stevie_b1.asm.393026
0066               ***************************************************************
0067               * Step 4: Include main editor modules
0068               ********|*****|*********************|**************************
0069               main:
0070                       aorg  kickstart.code2       ; >6036
0071 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0072                       ;-----------------------------------------------------------------------
0073                       ; Include files
0074                       ;-----------------------------------------------------------------------
0075                       copy  "main.asm"            ; Main file (entrypoint)
**** **** ****     > main.asm
0001               * FILE......: main.asm
0002               * Purpose...: Stevie Editor - Main editor module
0003               
0004               ***************************************************************
0005               * main
0006               * Initialize editor
0007               ***************************************************************
0008               * b   @main.stevie
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * -
0018               *--------------------------------------------------------------
0019               * Notes
0020               * Main entry point for stevie editor
0021               ***************************************************************
0022               
0023               
0024               ***************************************************************
0025               * Main
0026               ********|*****|*********************|**************************
0027               main.stevie:
0028 603A 20A0  38         coc   @wbit1,config         ; F18a detected?
     603C 201E 
0029 603E 1302  14         jeq   main.continue
0030 6040 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6042 0000 
0031               
0032               main.continue:
0033                       ;------------------------------------------------------
0034                       ; Setup F18A VDP
0035                       ;------------------------------------------------------
0036 6044 06A0  32         bl    @scroff               ; Turn screen off
     6046 2690 
0037               
0038 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 2734 
0039               
0046               
0047 604C 06A0  32         bl    @putvr                ; Turn on position based attributes
     604E 2334 
0048 6050 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6052 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     6054 2334 
0051 6056 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 6058 06A0  32         bl    @filv
     605A 2290 
0056 605C 0000                   data >0000,32,vdp.sit.size
     605E 0020 
     6060 0780 
0057                                                   ; Clear screen
0058                       ;------------------------------------------------------
0059                       ; Initialize high memory expansion
0060                       ;------------------------------------------------------
0061 6062 06A0  32         bl    @film
     6064 2238 
0062 6066 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6068 0000 
     606A 6000 
0063                       ;------------------------------------------------------
0064                       ; Setup SAMS windows
0065                       ;------------------------------------------------------
0066 606C 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     606E 337A 
0067                       ;------------------------------------------------------
0068                       ; Setup cursor, screen, etc.
0069                       ;------------------------------------------------------
0070 6070 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6072 26B0 
0071 6074 06A0  32         bl    @s8x8                 ; Small sprite
     6076 26C0 
0072               
0073 6078 06A0  32         bl    @cpym2m
     607A 24DC 
0074 607C 33A4                   data romsat,ramsat,14 ; Load sprite SAT
     607E 2F5A 
     6080 000E 
0075               
0076 6082 C820  54         mov   @romsat+2,@tv.curshape
     6084 33A6 
     6086 A014 
0077                                                   ; Save cursor shape & color
0078               
0079 6088 06A0  32         bl    @vdp.patterns.dump    ; Load sprite and character patterns
     608A 7C74 
0080               *--------------------------------------------------------------
0081               * Initialize
0082               *--------------------------------------------------------------
0083 608C 06A0  32         bl    @tv.init              ; Initialize editor configuration
     608E 3286 
0084 6090 06A0  32         bl    @tv.reset             ; Reset editor
     6092 32AC 
0085                       ;------------------------------------------------------
0086                       ; Load colorscheme amd turn on screen
0087                       ;------------------------------------------------------
0088 6094 06A0  32         bl    @pane.action.colorscheme.Load
     6096 765C 
0089                                                   ; Load color scheme and turn on screen
0090                       ;-------------------------------------------------------
0091                       ; Setup editor tasks & hook
0092                       ;-------------------------------------------------------
0093 6098 0204  20         li    tmp0,>0300
     609A 0300 
0094 609C C804  38         mov   tmp0,@btihi           ; Highest slot in use
     609E 8314 
0095               
0096 60A0 06A0  32         bl    @at
     60A2 26D0 
0097 60A4 0000                   data  >0000           ; Cursor YX position = >0000
0098               
0099 60A6 0204  20         li    tmp0,timers
     60A8 2F4A 
0100 60AA C804  38         mov   tmp0,@wtitab
     60AC 832C 
0101               
0112               
0113 60AE 06A0  32         bl    @mkslot
     60B0 2E06 
0114 60B2 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60B4 748A 
0115 60B6 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60B8 7516 
0116 60BA 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60BC 7568 
0117 60BE FFFF                   data eol
0118               
0120               
0121               
0122 60C0 06A0  32         bl    @mkhook
     60C2 2DF2 
0123 60C4 744C                   data hook.keyscan     ; Setup user hook
0124               
0125 60C6 0460  28         b     @tmgr                 ; Start timers and kthread
     60C8 2D48 
**** **** ****     > stevie_b1.asm.393026
0076                       ;-----------------------------------------------------------------------
0077                       ; Keyboard actions
0078                       ;-----------------------------------------------------------------------
0079                       copy  "edkey.key.process.asm"    ; Process keyboard actions
**** **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               ****************************************************************
0005               * Editor - Process action keys
0006               ****************************************************************
0007               edkey.key.process:
0008 60CA C160  34         mov   @waux1,tmp1           ; Get key value
     60CC 833C 
0009 60CE 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     60D0 FF00 
0010 60D2 0707  14         seto  tmp3                  ; EOL marker
0011                       ;-------------------------------------------------------
0012                       ; Process key depending on pane with focus
0013                       ;-------------------------------------------------------
0014 60D4 C1A0  34         mov   @tv.pane.focus,tmp2
     60D6 A022 
0015 60D8 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     60DA 0000 
0016 60DC 1307  14         jeq   edkey.key.process.loadmap.editor
0017                                                   ; Yes, so load editor keymap
0018               
0019 60DE 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     60E0 0001 
0020 60E2 1307  14         jeq   edkey.key.process.loadmap.cmdb
0021                                                   ; Yes, so load CMDB keymap
0022                       ;-------------------------------------------------------
0023                       ; Pane without focus, crash
0024                       ;-------------------------------------------------------
0025 60E4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     60E6 FFCE 
0026 60E8 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     60EA 2026 
0027                       ;-------------------------------------------------------
0028                       ; Load Editor keyboard map
0029                       ;-------------------------------------------------------
0030               edkey.key.process.loadmap.editor:
0031 60EC 0206  20         li    tmp2,keymap_actions.editor
     60EE 7D84 
0032 60F0 1003  14         jmp   edkey.key.check.next
0033                       ;-------------------------------------------------------
0034                       ; Load CMDB keyboard map
0035                       ;-------------------------------------------------------
0036               edkey.key.process.loadmap.cmdb:
0037 60F2 0206  20         li    tmp2,keymap_actions.cmdb
     60F4 7E52 
0038 60F6 1600  14         jne   edkey.key.check.next
0039                       ;-------------------------------------------------------
0040                       ; Iterate over keyboard map for matching action key
0041                       ;-------------------------------------------------------
0042               edkey.key.check.next:
0043 60F8 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0044 60FA 1319  14         jeq   edkey.key.process.addbuffer
0045                                                   ; Yes, means no action key pressed, so
0046                                                   ; add character to buffer
0047                       ;-------------------------------------------------------
0048                       ; Check for action key match
0049                       ;-------------------------------------------------------
0050 60FC 8585  30         c     tmp1,*tmp2            ; Action key matched?
0051 60FE 1303  14         jeq   edkey.key.check.scope
0052                                                   ; Yes, check scope
0053 6100 0226  22         ai    tmp2,6                ; Skip current entry
     6102 0006 
0054 6104 10F9  14         jmp   edkey.key.check.next  ; Check next entry
0055                       ;-------------------------------------------------------
0056                       ; Check scope of key
0057                       ;-------------------------------------------------------
0058               edkey.key.check.scope:
0059 6106 05C6  14         inct  tmp2                  ; Move to scope
0060 6108 8816  46         c     *tmp2,@tv.pane.focus  ; (1) Process key if scope matches pane
     610A A022 
0061 610C 1306  14         jeq   edkey.key.process.action
0062               
0063 610E 8816  46         c     *tmp2,@cmdb.dialog    ; (2) Process key if scope matches dialog
     6110 A31A 
0064 6112 1303  14         jeq   edkey.key.process.action
0065                       ;-------------------------------------------------------
0066                       ; Key pressed outside valid scope, ignore action entry
0067                       ;-------------------------------------------------------
0068 6114 0226  22         ai    tmp2,4                ; Skip current entry
     6116 0004 
0069 6118 10EF  14         jmp   edkey.key.check.next  ; Process next action entry
0070                       ;-------------------------------------------------------
0071                       ; Trigger keyboard action
0072                       ;-------------------------------------------------------
0073               edkey.key.process.action:
0074 611A 05C6  14         inct  tmp2                  ; Move to action address
0075 611C C196  26         mov   *tmp2,tmp2            ; Get action address
0076               
0077 611E 0204  20         li    tmp0,id.dialog.unsaved
     6120 0065 
0078 6122 8120  34         c     @cmdb.dialog,tmp0
     6124 A31A 
0079 6126 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0080               
0081 6128 C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     612A A324 
0082 612C 0456  20 !       b     *tmp2                 ; Process key action
0083                       ;-------------------------------------------------------
0084                       ; Add character to editor or cmdb buffer
0085                       ;-------------------------------------------------------
0086               edkey.key.process.addbuffer:
0087 612E C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     6130 A022 
0088 6132 1602  14         jne   !                     ; No, skip frame buffer
0089 6134 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6136 66E0 
0090                       ;-------------------------------------------------------
0091                       ; CMDB buffer
0092                       ;-------------------------------------------------------
0093 6138 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     613A 0001 
0094 613C 1607  14         jne   edkey.key.process.crash
0095                                                   ; No, crash
0096                       ;-------------------------------------------------------
0097                       ; Don't add character if dialog has ID > 100
0098                       ;-------------------------------------------------------
0099 613E C120  34         mov   @cmdb.dialog,tmp0
     6140 A31A 
0100 6142 0284  22         ci    tmp0,100
     6144 0064 
0101 6146 1506  14         jgt   edkey.key.process.exit
0102                       ;-------------------------------------------------------
0103                       ; Add character to CMDB
0104                       ;-------------------------------------------------------
0105 6148 0460  28         b     @edkey.action.cmdb.char
     614A 68FC 
0106                                                   ; Add character to CMDB buffer
0107                       ;-------------------------------------------------------
0108                       ; Crash
0109                       ;-------------------------------------------------------
0110               edkey.key.process.crash:
0111 614C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     614E FFCE 
0112 6150 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     6152 2026 
0113                       ;-------------------------------------------------------
0114                       ; Exit
0115                       ;-------------------------------------------------------
0116               edkey.key.process.exit:
0117 6154 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6156 747E 
**** **** ****     > stevie_b1.asm.393026
0080                       ;-----------------------------------------------------------------------
0081                       ; Keyboard actions - Framebuffer (1)
0082                       ;-----------------------------------------------------------------------
0083                       copy  "edkey.fb.mov.leftright.asm"
**** **** ****     > edkey.fb.mov.leftright.asm
0001               * FILE......: edkey.fb.mov.leftright.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.left:
0008 6158 C120  34         mov   @fb.column,tmp0
     615A A10C 
0009 615C 1308  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 615E 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6160 A10C 
0014 6162 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6164 832A 
0015 6166 0620  34         dec   @fb.current
     6168 A102 
0016 616A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     616C A118 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 616E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6170 747E 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6172 8820  54         c     @fb.column,@fb.row.length
     6174 A10C 
     6176 A108 
0028 6178 1408  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 617A 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     617C A10C 
0033 617E 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6180 832A 
0034 6182 05A0  34         inc   @fb.current
     6184 A102 
0035 6186 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6188 A118 
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039 618A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     618C 747E 
0040               
0041               
0042               *---------------------------------------------------------------
0043               * Cursor beginning of line
0044               *---------------------------------------------------------------
0045               edkey.action.home:
0046 618E 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6190 A118 
0047 6192 C120  34         mov   @wyx,tmp0
     6194 832A 
0048 6196 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     6198 FF00 
0049 619A C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     619C 832A 
0050 619E 04E0  34         clr   @fb.column
     61A0 A10C 
0051 61A2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61A4 6A60 
0052 61A6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61A8 A118 
0053                       ;-------------------------------------------------------
0054                       ; Exit
0055                       ;-------------------------------------------------------
0056 61AA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61AC 747E 
0057               
0058               
0059               *---------------------------------------------------------------
0060               * Cursor end of line
0061               *---------------------------------------------------------------
0062               edkey.action.end:
0063 61AE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61B0 A118 
0064 61B2 C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     61B4 A108 
0065 61B6 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     61B8 0050 
0066 61BA 1102  14         jlt   !                     ; | is right of last character on line,
0067 61BC 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     61BE 004F 
0068                       ;-------------------------------------------------------
0069                       ; Set cursor X position
0070                       ;-------------------------------------------------------
0071 61C0 C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     61C2 A10C 
0072 61C4 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     61C6 26E8 
0073 61C8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61CA 6A60 
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077 61CC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61CE 747E 
**** **** ****     > stevie_b1.asm.393026
0084                                                        ; Move left / right / home / end
0085                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
**** **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 61D0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61D2 A118 
0009 61D4 C120  34         mov   @fb.column,tmp0
     61D6 A10C 
0010 61D8 1322  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 61DA C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     61DC A102 
0015 61DE 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 61E0 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 61E2 0605  14         dec   tmp1
0022 61E4 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 61E6 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 61E8 D195  26         movb  *tmp1,tmp2            ; Get character
0030 61EA 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 61EC D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 61EE 0986  56         srl   tmp2,8                ; Right justify
0033 61F0 0286  22         ci    tmp2,32               ; Space character found?
     61F2 0020 
0034 61F4 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 61F6 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     61F8 2020 
0040 61FA 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 61FC 0287  22         ci    tmp3,>20ff            ; First character is space
     61FE 20FF 
0043 6200 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 6202 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6204 A10C 
0048 6206 61C4  18         s     tmp0,tmp3
0049 6208 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     620A 0002 
0050 620C 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 620E 0585  14         inc   tmp1
0056 6210 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 6212 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6214 A10C 
0062 6216 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6218 26E8 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 621A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     621C 6A60 
0068 621E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6220 747E 
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 6222 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6224 A118 
0077 6226 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 6228 C120  34         mov   @fb.column,tmp0
     622A A10C 
0079 622C 8804  38         c     tmp0,@fb.row.length
     622E A108 
0080 6230 1426  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 6232 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6234 A102 
0085 6236 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 6238 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 623A 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 623C 0585  14         inc   tmp1
0097 623E 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 6240 8804  38         c     tmp0,@fb.row.length
     6242 A108 
0099 6244 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 6246 D195  26         movb  *tmp1,tmp2            ; Get character
0106 6248 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 624A D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 624C 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 624E 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6250 FFFF 
0111 6252 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 6254 0286  22         ci    tmp2,32
     6256 0020 
0117 6258 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 625A 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 625C 0286  22         ci    tmp2,32               ; Space character found?
     625E 0020 
0125 6260 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 6262 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6264 2020 
0131 6266 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 6268 0287  22         ci    tmp3,>20ff            ; First characer is space?
     626A 20FF 
0134 626C 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 626E 0585  14         inc   tmp1
0139 6270 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 6272 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6274 A10C 
0145 6276 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6278 26E8 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 627A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     627C 6A60 
0151 627E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6280 747E 
0152               
0153               
**** **** ****     > stevie_b1.asm.393026
0086                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
**** **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 6282 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6284 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 6286 8820  54         c     @fb.row.dirty,@w$ffff
     6288 A10A 
     628A 2022 
0013 628C 1604  14         jne   edkey.action.up.cursor
0014 628E 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6290 6DAC 
0015 6292 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6294 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Move cursor
0018                       ;-------------------------------------------------------
0019               edkey.action.up.cursor:
0020 6296 C120  34         mov   @fb.row,tmp0
     6298 A106 
0021 629A 150B  14         jgt   edkey.action.up.cursor_up
0022                                                   ; Move cursor up if fb.row > 0
0023 629C C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     629E A104 
0024 62A0 130C  14         jeq   edkey.action.up.set_cursorx
0025                                                   ; At top, only position cursor X
0026                       ;-------------------------------------------------------
0027                       ; Scroll 1 line
0028                       ;-------------------------------------------------------
0029 62A2 0604  14         dec   tmp0                  ; fb.topline--
0030 62A4 C804  38         mov   tmp0,@parm1           ; Scroll one line up
     62A6 2F20 
0031               
0032 62A8 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     62AA 6AD0 
0033                                                   ; | i  @parm1 = Line to start with
0034                                                   ; /             (becomes @fb.topline)
0035               
0036 62AC 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     62AE A110 
0037 62B0 1004  14         jmp   edkey.action.up.set_cursorx
0038                       ;-------------------------------------------------------
0039                       ; Move cursor up
0040                       ;-------------------------------------------------------
0041               edkey.action.up.cursor_up:
0042 62B2 0620  34         dec   @fb.row               ; Row-- in screen buffer
     62B4 A106 
0043 62B6 06A0  32         bl    @up                   ; Row-- VDP cursor
     62B8 26DE 
0044                       ;-------------------------------------------------------
0045                       ; Check line length and position cursor
0046                       ;-------------------------------------------------------
0047               edkey.action.up.set_cursorx:
0048 62BA 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     62BC 6FA2 
0049                                                   ; | i  @fb.row        = Row in frame buffer
0050                                                   ; / o  @fb.row.length = Length of row
0051               
0052 62BE 8820  54         c     @fb.column,@fb.row.length
     62C0 A10C 
     62C2 A108 
0053 62C4 1207  14         jle   edkey.action.up.exit
0054                       ;-------------------------------------------------------
0055                       ; Adjust cursor column position
0056                       ;-------------------------------------------------------
0057 62C6 C820  54         mov   @fb.row.length,@fb.column
     62C8 A108 
     62CA A10C 
0058 62CC C120  34         mov   @fb.column,tmp0
     62CE A10C 
0059 62D0 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62D2 26E8 
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.up.exit:
0064 62D4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62D6 6A60 
0065 62D8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62DA 747E 
0066               
0067               
0068               
0069               *---------------------------------------------------------------
0070               * Cursor down
0071               *---------------------------------------------------------------
0072               edkey.action.down:
0073 62DC 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     62DE A106 
     62E0 A204 
0074 62E2 1332  14         jeq   edkey.action.down.exit
0075                                                   ; Yes, skip further processing
0076 62E4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62E6 A118 
0077                       ;-------------------------------------------------------
0078                       ; Crunch current row if dirty
0079                       ;-------------------------------------------------------
0080 62E8 8820  54         c     @fb.row.dirty,@w$ffff
     62EA A10A 
     62EC 2022 
0081 62EE 1604  14         jne   edkey.action.down.move
0082 62F0 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62F2 6DAC 
0083 62F4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62F6 A10A 
0084                       ;-------------------------------------------------------
0085                       ; Move cursor
0086                       ;-------------------------------------------------------
0087               edkey.action.down.move:
0088                       ;-------------------------------------------------------
0089                       ; EOF reached?
0090                       ;-------------------------------------------------------
0091 62F8 C120  34         mov   @fb.topline,tmp0
     62FA A104 
0092 62FC A120  34         a     @fb.row,tmp0
     62FE A106 
0093 6300 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6302 A204 
0094 6304 1314  14         jeq   edkey.action.down.set_cursorx
0095                                                   ; Yes, only position cursor X
0096                       ;-------------------------------------------------------
0097                       ; Check if scrolling required
0098                       ;-------------------------------------------------------
0099 6306 C120  34         mov   @fb.scrrows,tmp0
     6308 A11A 
0100 630A 0604  14         dec   tmp0
0101 630C 8120  34         c     @fb.row,tmp0
     630E A106 
0102 6310 110A  14         jlt   edkey.action.down.cursor
0103                       ;-------------------------------------------------------
0104                       ; Scroll 1 line
0105                       ;-------------------------------------------------------
0106 6312 C820  54         mov   @fb.topline,@parm1
     6314 A104 
     6316 2F20 
0107 6318 05A0  34         inc   @parm1
     631A 2F20 
0108               
0109 631C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     631E 6AD0 
0110                                                   ; | i  @parm1 = Line to start with
0111                                                   ; /             (becomes @fb.topline)
0112               
0113 6320 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6322 A110 
0114 6324 1004  14         jmp   edkey.action.down.set_cursorx
0115                       ;-------------------------------------------------------
0116                       ; Move cursor down a row, there are still rows left
0117                       ;-------------------------------------------------------
0118               edkey.action.down.cursor:
0119 6326 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6328 A106 
0120 632A 06A0  32         bl    @down                 ; Row++ VDP cursor
     632C 26D6 
0121                       ;-------------------------------------------------------
0122                       ; Check line length and position cursor
0123                       ;-------------------------------------------------------
0124               edkey.action.down.set_cursorx:
0125 632E 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6330 6FA2 
0126                                                   ; | i  @fb.row        = Row in frame buffer
0127                                                   ; / o  @fb.row.length = Length of row
0128               
0129 6332 8820  54         c     @fb.column,@fb.row.length
     6334 A10C 
     6336 A108 
0130 6338 1207  14         jle   edkey.action.down.exit
0131                                                   ; Exit
0132                       ;-------------------------------------------------------
0133                       ; Adjust cursor column position
0134                       ;-------------------------------------------------------
0135 633A C820  54         mov   @fb.row.length,@fb.column
     633C A108 
     633E A10C 
0136 6340 C120  34         mov   @fb.column,tmp0
     6342 A10C 
0137 6344 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6346 26E8 
0138                       ;-------------------------------------------------------
0139                       ; Exit
0140                       ;-------------------------------------------------------
0141               edkey.action.down.exit:
0142 6348 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     634A 6A60 
0143 634C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     634E 747E 
**** **** ****     > stevie_b1.asm.393026
0087                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 6350 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6352 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 6354 8820  54         c     @fb.row.dirty,@w$ffff
     6356 A10A 
     6358 2022 
0013 635A 1604  14         jne   edkey.action.ppage.sanity
0014 635C 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     635E 6DAC 
0015 6360 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6362 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 6364 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6366 A104 
0021 6368 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 636A 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     636C A11A 
0026 636E 1503  14         jgt   edkey.action.ppage.topline
0027 6370 04E0  34         clr   @fb.topline           ; topline = 0
     6372 A104 
0028 6374 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 6376 6820  54         s     @fb.scrrows,@fb.topline
     6378 A11A 
     637A A104 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 637C C820  54         mov   @fb.topline,@parm1
     637E A104 
     6380 2F20 
0039 6382 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6384 A110 
0040               
0041 6386 1045  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 6388 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     638A 747E 
0048               
0049               
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Next page
0054               *---------------------------------------------------------------
0055               edkey.action.npage:
0056 638C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     638E A118 
0057                       ;-------------------------------------------------------
0058                       ; Crunch current row if dirty
0059                       ;-------------------------------------------------------
0060 6390 8820  54         c     @fb.row.dirty,@w$ffff
     6392 A10A 
     6394 2022 
0061 6396 1604  14         jne   edkey.action.npage.sanity
0062 6398 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     639A 6DAC 
0063 639C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     639E A10A 
0064                       ;-------------------------------------------------------
0065                       ; Assert
0066                       ;-------------------------------------------------------
0067               edkey.action.npage.sanity:
0068 63A0 C120  34         mov   @fb.topline,tmp0
     63A2 A104 
0069 63A4 A120  34         a     @fb.scrrows,tmp0
     63A6 A11A 
0070 63A8 0584  14         inc   tmp0                  ; Base 1 offset !
0071 63AA 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     63AC A204 
0072 63AE 1509  14         jgt   edkey.action.npage.exit
0073                       ;-------------------------------------------------------
0074                       ; Adjust topline
0075                       ;-------------------------------------------------------
0076               edkey.action.npage.topline:
0077 63B0 A820  54         a     @fb.scrrows,@fb.topline
     63B2 A11A 
     63B4 A104 
0078                       ;-------------------------------------------------------
0079                       ; Refresh page
0080                       ;-------------------------------------------------------
0081               edkey.action.npage.refresh:
0082 63B6 C820  54         mov   @fb.topline,@parm1
     63B8 A104 
     63BA 2F20 
0083 63BC 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63BE A110 
0084               
0085 63C0 1028  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 63C2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63C4 747E 
**** **** ****     > stevie_b1.asm.393026
0088                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
**** **** ****     > edkey.fb.mov.topbot.asm
0001               * FILE......: edkey.fb.mov.topbot.asm
0002               * Purpose...: Move to top / bottom in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Goto top of file
0006               *---------------------------------------------------------------
0007               edkey.action.top:
0008                       ;-------------------------------------------------------
0009                       ; Crunch current row if dirty
0010                       ;-------------------------------------------------------
0011 63C6 8820  54         c     @fb.row.dirty,@w$ffff
     63C8 A10A 
     63CA 2022 
0012 63CC 1604  14         jne   edkey.action.top.refresh
0013 63CE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63D0 6DAC 
0014 63D2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63D4 A10A 
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 63D6 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     63D8 2F20 
0020 63DA 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63DC A110 
0021               
0022 63DE 0460  28         b     @ _edkey.goto.fb.toprow
     63E0 6412 
0023                                                   ; \ Position cursor and exit
0024                                                   ; / i  @parm1 = Line in editor buffer
0025               
0026               
0027               
0028               *---------------------------------------------------------------
0029               * Goto bottom of file
0030               *---------------------------------------------------------------
0031               edkey.action.bot:
0032                       ;-------------------------------------------------------
0033                       ; Crunch current row if dirty
0034                       ;-------------------------------------------------------
0035 63E2 8820  54         c     @fb.row.dirty,@w$ffff
     63E4 A10A 
     63E6 2022 
0036 63E8 1604  14         jne   edkey.action.bot.refresh
0037 63EA 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63EC 6DAC 
0038 63EE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63F0 A10A 
0039                       ;-------------------------------------------------------
0040                       ; Refresh page
0041                       ;-------------------------------------------------------
0042               edkey.action.bot.refresh:
0043 63F2 8820  54         c     @edb.lines,@fb.scrrows
     63F4 A204 
     63F6 A11A 
0044 63F8 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0045               
0046 63FA C120  34         mov   @edb.lines,tmp0
     63FC A204 
0047 63FE 6120  34         s     @fb.scrrows,tmp0
     6400 A11A 
0048 6402 C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     6404 2F20 
0049 6406 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6408 A110 
0050               
0051 640A 0460  28         b     @ _edkey.goto.fb.toprow
     640C 6412 
0052                                                   ; \ Position cursor and exit
0053                                                   ; / i  @parm1 = Line in editor buffer
0054                       ;-------------------------------------------------------
0055                       ; Exit
0056                       ;-------------------------------------------------------
0057               edkey.action.bot.exit:
0058 640E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6410 747E 
**** **** ****     > stevie_b1.asm.393026
0089                       copy  "edkey.fb.mov.goto.asm"    ; Goto line in editor buffer
**** **** ****     > edkey.fb.mov.goto.asm
0001               * FILE......: edkey.fb.mov.goto.asm
0002               * Purpose...: Goto specified line in editor buffer
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
0026 6412 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6414 A118 
0027               
0028 6416 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6418 6AD0 
0029                                                   ; | i  @parm1 = Line to start with
0030                                                   ; /             (becomes @fb.topline)
0031               
0032 641A 04E0  34         clr   @fb.row               ; Frame buffer line 0
     641C A106 
0033 641E 04E0  34         clr   @fb.column            ; Frame buffer column 0
     6420 A10C 
0034 6422 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     6424 832A 
0035               
0036 6426 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6428 6A60 
0037               
0038 642A 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     642C 6FA2 
0039                                                   ; | i  @fb.row        = Row in frame buffer
0040                                                   ; / o  @fb.row.length = Length of row
0041               
0042 642E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6430 747E 
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Goto specified line (@parm1) in editor buffer
0047               *---------------------------------------------------------------
0048               edkey.action.goto:
0049                       ;-------------------------------------------------------
0050                       ; Crunch current row if dirty
0051                       ;-------------------------------------------------------
0052 6432 8820  54         c     @fb.row.dirty,@w$ffff
     6434 A10A 
     6436 2022 
0053 6438 1609  14         jne   edkey.action.goto.refresh
0054               
0055 643A 0649  14         dect  stack
0056 643C C660  46         mov   @parm1,*stack         ; Push parm1
     643E 2F20 
0057 6440 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6442 6DAC 
0058 6444 C839  50         mov   *stack+,@parm1        ; Pop parm1
     6446 2F20 
0059               
0060 6448 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     644A A10A 
0061                       ;-------------------------------------------------------
0062                       ; Refresh page
0063                       ;-------------------------------------------------------
0064               edkey.action.goto.refresh:
0065 644C 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     644E A110 
0066               
0067 6450 0460  28         b     @_edkey.goto.fb.toprow ; Position cursor and exit
     6452 6412 
0068                                                    ; \ i  @parm1 = Line in editor buffer
0069                                                    ; /
**** **** ****     > stevie_b1.asm.393026
0090                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 6454 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6456 A206 
0009 6458 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     645A 6A60 
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 645C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     645E A108 
0015 6460 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 6462 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6464 A102 
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 6466 C1C6  18         mov   tmp2,tmp3             ; \
0024 6468 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 646A 81E0  34         c     @fb.column,tmp3
     646C A10C 
0026 646E 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 6470 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 6472 D505  30         movb  tmp1,*tmp0            ; /
0033 6474 C820  54         mov   @fb.column,@fb.row.length
     6476 A10C 
     6478 A108 
0034                                                   ; Row length - 1
0035 647A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     647C A10A 
0036 647E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6480 A116 
0037 6482 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 6484 0286  22         ci    tmp2,colrow
     6486 0050 
0043 6488 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 648A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     648C FFCE 
0049 648E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6490 2026 
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 6492 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 6494 61E0  34         s     @fb.column,tmp3
     6496 A10C 
0056 6498 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 649A A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 649C C144  18         mov   tmp0,tmp1
0059 649E 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 64A0 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     64A2 A10C 
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 64A4 C120  34         mov   @fb.current,tmp0      ; Get pointer
     64A6 A102 
0065 64A8 C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 64AA 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 64AC DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 64AE 0606  14         dec   tmp2
0073 64B0 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 64B2 0206  20         li    tmp2,colrow
     64B4 0050 
0078 64B6 81A0  34         c     @fb.row.length,tmp2
     64B8 A108 
0079 64BA 1603  14         jne   edkey.action.del_char.save
0080 64BC 0604  14         dec   tmp0                  ; One time adjustment
0081 64BE 04C5  14         clr   tmp1
0082 64C0 D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 64C2 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64C4 A10A 
0088 64C6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64C8 A116 
0089 64CA 0620  34         dec   @fb.row.length        ; @fb.row.length--
     64CC A108 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 64CE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64D0 747E 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 64D2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64D4 A206 
0102 64D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64D8 6A60 
0103 64DA C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64DC A108 
0104 64DE 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 64E0 C120  34         mov   @fb.current,tmp0      ; Get pointer
     64E2 A102 
0110 64E4 C1A0  34         mov   @fb.colsline,tmp2
     64E6 A10E 
0111 64E8 61A0  34         s     @fb.column,tmp2
     64EA A10C 
0112 64EC 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 64EE DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 64F0 0606  14         dec   tmp2
0119 64F2 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 64F4 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64F6 A10A 
0124 64F8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64FA A116 
0125               
0126 64FC C820  54         mov   @fb.column,@fb.row.length
     64FE A10C 
     6500 A108 
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 6502 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6504 747E 
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 6506 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6508 6A60 
0143 650A 04E0  34         clr   @fb.row.dirty         ; Discard current line
     650C A10A 
0144               
0145 650E C820  54         mov   @fb.topline,@parm1    ; \
     6510 A104 
     6512 2F20 
0146 6514 A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     6516 A106 
     6518 2F20 
0147 651A 05A0  34         inc   @parm1                ; /
     651C 2F20 
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 651E 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     6520 2F20 
     6522 A204 
0153 6524 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 6526 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     6528 A104 
     652A 2F20 
0157 652C 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     652E 6AD0 
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 6530 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6532 6282 
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 6534 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     6536 70A8 
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 6538 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     653A 2F20 
     653C A204 
0170 653E 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 6540 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     6542 6FA2 
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 6544 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     6546 A104 
     6548 2F20 
0183               
0184 654A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     654C 6AD0 
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 654E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6550 A206 
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 6552 C120  34         mov   @fb.topline,tmp0
     6554 A104 
0193 6556 A120  34         a     @fb.row,tmp0
     6558 A106 
0194               
0195 655A 8804  38         c     tmp0,@edb.lines       ; Was last line?
     655C A204 
0196 655E 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 6560 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6562 6282 
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 6564 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6566 618E 
**** **** ****     > stevie_b1.asm.393026
0091                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
**** **** ****     > edkey.fb.ins.asm
0001               * FILE......: edkey.fb.ins.asm
0002               * Purpose...: Insert related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Insert character
0006               *
0007               * @parm1 = high byte has character to insert
0008               *---------------------------------------------------------------
0009               edkey.action.ins_char.ws:
0010 6568 0204  20         li    tmp0,>2000            ; White space
     656A 2000 
0011 656C C804  38         mov   tmp0,@parm1
     656E 2F20 
0012               edkey.action.ins_char:
0013 6570 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6572 A206 
0014 6574 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6576 6A60 
0015                       ;-------------------------------------------------------
0016                       ; Assert 1 - Empty line
0017                       ;-------------------------------------------------------
0018 6578 C120  34         mov   @fb.current,tmp0      ; Get pointer
     657A A102 
0019 657C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     657E A108 
0020 6580 132C  14         jeq   edkey.action.ins_char.append
0021                                                   ; Add character in append mode
0022                       ;-------------------------------------------------------
0023                       ; Assert 2 - EOL
0024                       ;-------------------------------------------------------
0025 6582 8820  54         c     @fb.column,@fb.row.length
     6584 A10C 
     6586 A108 
0026 6588 1328  14         jeq   edkey.action.ins_char.append
0027                                                   ; Add character in append mode
0028                       ;-------------------------------------------------------
0029                       ; Assert 3 - Overwrite if at column 80
0030                       ;-------------------------------------------------------
0031 658A C160  34         mov   @fb.column,tmp1
     658C A10C 
0032 658E 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     6590 004F 
0033 6592 1102  14         jlt   !
0034 6594 0460  28         b     @edkey.action.char.overwrite
     6596 6706 
0035                       ;-------------------------------------------------------
0036                       ; Assert 4 - 80 characters maximum
0037                       ;-------------------------------------------------------
0038 6598 C160  34 !       mov   @fb.row.length,tmp1
     659A A108 
0039 659C 0285  22         ci    tmp1,colrow
     659E 0050 
0040 65A0 1101  14         jlt   edkey.action.ins_char.prep
0041 65A2 101D  14         jmp   edkey.action.ins_char.exit
0042                       ;-------------------------------------------------------
0043                       ; Calculate number of characters to move
0044                       ;-------------------------------------------------------
0045               edkey.action.ins_char.prep:
0046 65A4 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0047 65A6 61E0  34         s     @fb.column,tmp3
     65A8 A10C 
0048 65AA 0607  14         dec   tmp3                  ; Remove base 1 offset
0049 65AC A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0050 65AE C144  18         mov   tmp0,tmp1
0051 65B0 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0052 65B2 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     65B4 A10C 
0053                       ;-------------------------------------------------------
0054                       ; Loop from end of line until current character
0055                       ;-------------------------------------------------------
0056               edkey.action.ins_char.loop:
0057 65B6 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0058 65B8 0604  14         dec   tmp0
0059 65BA 0605  14         dec   tmp1
0060 65BC 0606  14         dec   tmp2
0061 65BE 16FB  14         jne   edkey.action.ins_char.loop
0062                       ;-------------------------------------------------------
0063                       ; Insert specified character at current position
0064                       ;-------------------------------------------------------
0065 65C0 D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     65C2 2F20 
0066                       ;-------------------------------------------------------
0067                       ; Save variables and exit
0068                       ;-------------------------------------------------------
0069 65C4 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65C6 A10A 
0070 65C8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65CA A116 
0071 65CC 05A0  34         inc   @fb.column
     65CE A10C 
0072 65D0 05A0  34         inc   @wyx
     65D2 832A 
0073 65D4 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65D6 A108 
0074 65D8 1002  14         jmp   edkey.action.ins_char.exit
0075                       ;-------------------------------------------------------
0076                       ; Add character in append mode
0077                       ;-------------------------------------------------------
0078               edkey.action.ins_char.append:
0079 65DA 0460  28         b     @edkey.action.char.overwrite
     65DC 6706 
0080                       ;-------------------------------------------------------
0081                       ; Exit
0082                       ;-------------------------------------------------------
0083               edkey.action.ins_char.exit:
0084 65DE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65E0 747E 
0085               
0086               
0087               
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Insert new line
0093               *---------------------------------------------------------------
0094               edkey.action.ins_line:
0095 65E2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65E4 A206 
0096                       ;-------------------------------------------------------
0097                       ; Crunch current line if dirty
0098                       ;-------------------------------------------------------
0099 65E6 8820  54         c     @fb.row.dirty,@w$ffff
     65E8 A10A 
     65EA 2022 
0100 65EC 1604  14         jne   edkey.action.ins_line.insert
0101 65EE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     65F0 6DAC 
0102 65F2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65F4 A10A 
0103                       ;-------------------------------------------------------
0104                       ; Insert entry in index
0105                       ;-------------------------------------------------------
0106               edkey.action.ins_line.insert:
0107 65F6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65F8 6A60 
0108 65FA C820  54         mov   @fb.topline,@parm1
     65FC A104 
     65FE 2F20 
0109 6600 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6602 A106 
     6604 2F20 
0110 6606 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6608 A204 
     660A 2F22 
0111               
0112 660C 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     660E 6CC4 
0113                                                   ; \ i  parm1 = Line for insert
0114                                                   ; / i  parm2 = Last line to reorg
0115               
0116 6610 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6612 A204 
0117                       ;-------------------------------------------------------
0118                       ; Check/Adjust marker M1
0119                       ;-------------------------------------------------------
0120               edkey.action.ins_line.m1:
0121 6614 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6616 A20C 
     6618 2022 
0122 661A 1308  14         jeq   edkey.action.ins_line.m2
0123                                                   ; Yes, skip to M2 check
0124               
0125 661C 8820  54         c     @parm1,@edb.block.m1
     661E 2F20 
     6620 A20C 
0126 6622 1504  14         jgt   edkey.action.ins_line.m2
0127 6624 05A0  34         inc   @edb.block.m1         ; M1++
     6626 A20C 
0128 6628 0720  34         seto  @fb.colorize          ; Set colorize flag
     662A A110 
0129                       ;-------------------------------------------------------
0130                       ; Check/Adjust marker M2
0131                       ;-------------------------------------------------------
0132               edkey.action.ins_line.m2:
0133 662C 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     662E A20E 
     6630 2022 
0134 6632 1308  14         jeq   edkey.action.ins_line.refresh
0135                                                   ; Yes, skip to refresh frame buffer
0136               
0137 6634 8820  54         c     @parm1,@edb.block.m2
     6636 2F20 
     6638 A20E 
0138 663A 1504  14         jgt   edkey.action.ins_line.refresh
0139 663C 05A0  34         inc   @edb.block.m2         ; M2++
     663E A20E 
0140 6640 0720  34         seto  @fb.colorize          ; Set colorize flag
     6642 A110 
0141                       ;-------------------------------------------------------
0142                       ; Refresh frame buffer and physical screen
0143                       ;-------------------------------------------------------
0144               edkey.action.ins_line.refresh:
0145 6644 C820  54         mov   @fb.topline,@parm1
     6646 A104 
     6648 2F20 
0146               
0147 664A 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     664C 6AD0 
0148                                                   ; | i  @parm1 = Line to start with
0149                                                   ; /             (becomes @fb.topline)
0150               
0151 664E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6650 A116 
0152                       ;-------------------------------------------------------
0153                       ; Exit
0154                       ;-------------------------------------------------------
0155               edkey.action.ins_line.exit:
0156 6652 0460  28         b     @edkey.action.home    ; Position cursor at home
     6654 618E 
0157               
**** **** ****     > stevie_b1.asm.393026
0092                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 6656 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6658 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 665A 8820  54         c     @fb.row.dirty,@w$ffff
     665C A10A 
     665E 2022 
0013 6660 1606  14         jne   edkey.action.enter.upd_counter
0014 6662 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6664 A206 
0015 6666 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6668 6DAC 
0016 666A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     666C A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 666E C120  34         mov   @fb.topline,tmp0
     6670 A104 
0022 6672 A120  34         a     @fb.row,tmp0
     6674 A106 
0023 6676 0584  14         inc   tmp0
0024 6678 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     667A A204 
0025 667C 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 667E 05A0  34         inc   @edb.lines            ; Total lines++
     6680 A204 
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 6682 C120  34         mov   @fb.scrrows,tmp0
     6684 A11A 
0035 6686 0604  14         dec   tmp0
0036 6688 8120  34         c     @fb.row,tmp0
     668A A106 
0037 668C 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 668E C120  34         mov   @fb.scrrows,tmp0
     6690 A11A 
0042 6692 C820  54         mov   @fb.topline,@parm1
     6694 A104 
     6696 2F20 
0043 6698 05A0  34         inc   @parm1
     669A 2F20 
0044 669C 06A0  32         bl    @fb.refresh
     669E 6AD0 
0045 66A0 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     66A2 A110 
0046 66A4 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 66A6 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     66A8 A106 
0052 66AA 06A0  32         bl    @down                 ; Row++ VDP cursor
     66AC 26D6 
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 66AE 06A0  32         bl    @fb.get.firstnonblank
     66B0 6A88 
0058 66B2 C120  34         mov   @outparm1,tmp0
     66B4 2F30 
0059 66B6 C804  38         mov   tmp0,@fb.column
     66B8 A10C 
0060 66BA 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     66BC 26E8 
0061 66BE 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     66C0 6FA2 
0062 66C2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     66C4 6A60 
0063 66C6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66C8 A116 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 66CA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66CC 747E 
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 66CE 0649  14         dect  stack
0078 66D0 C64B  30         mov   r11,*stack            ; Save return address
0079               
0080 66D2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66D4 A118 
0081 66D6 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     66D8 A20A 
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_onoff.exit:
0086 66DA C2F9  30         mov   *stack+,r11           ; Pop r11
0087 66DC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66DE 747E 
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Add character (frame buffer)
0093               *---------------------------------------------------------------
0094               edkey.action.char:
0095 66E0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66E2 A118 
0096                       ;-------------------------------------------------------
0097                       ; Asserts
0098                       ;-------------------------------------------------------
0099 66E4 D105  18         movb  tmp1,tmp0             ; Get keycode
0100 66E6 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 66E8 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     66EA 0020 
0103 66EC 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 66EE 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     66F0 007E 
0107 66F2 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 66F4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     66F6 A206 
0113 66F8 D805  38         movb  tmp1,@parm1           ; Store character for insert
     66FA 2F20 
0114 66FC C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     66FE A20A 
0115 6700 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 6702 0460  28         b     @edkey.action.ins_char
     6704 6570 
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 6706 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6708 6A60 
0126 670A C120  34         mov   @fb.current,tmp0      ; Get pointer
     670C A102 
0127               
0128 670E D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     6710 2F20 
0129 6712 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6714 A10A 
0130 6716 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6718 A116 
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 671A C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     671C A10C 
0135 671E 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     6720 004F 
0136 6722 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 6724 0205  20         li    tmp1,colrow           ; \
     6726 0050 
0140 6728 C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     672A A108 
0141 672C 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 672E 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6730 A10C 
0147 6732 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6734 832A 
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 6736 8820  54         c     @fb.column,@fb.row.length
     6738 A10C 
     673A A108 
0152                                                   ; column < line length ?
0153 673C 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 673E C820  54         mov   @fb.column,@fb.row.length
     6740 A10C 
     6742 A108 
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 6744 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6746 747E 
**** **** ****     > stevie_b1.asm.393026
0093                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
**** **** ****     > edkey.fb.misc.asm
0001               * FILE......: edkey.fb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Quit stevie
0006               *---------------------------------------------------------------
0007               edkey.action.quit:
0008                       ;-------------------------------------------------------
0009                       ; Show dialog "unsaved changes" if editor buffer dirty
0010                       ;-------------------------------------------------------
0011 6748 C120  34         mov   @edb.dirty,tmp0
     674A A206 
0012 674C 1302  14         jeq   !
0013 674E 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6750 7D18 
0014                       ;-------------------------------------------------------
0015                       ; Reset and lock F18a
0016                       ;-------------------------------------------------------
0017 6752 06A0  32 !       bl    @f18rst               ; Reset and lock the F18A
     6754 279A 
0018 6756 0420  54         blwp  @0                    ; Exit
     6758 0000 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Toggle ruler on/off
0023               ********|*****|*********************|**************************
0024               edkey.action.toggle.ruler:
0025 675A 0649  14         dect  stack
0026 675C C644  30         mov   tmp0,*stack           ; Push tmp0
0027 675E 0649  14         dect  stack
0028 6760 C660  46         mov   @wyx,*stack           ; Push cursor YX
     6762 832A 
0029                       ;-------------------------------------------------------
0030                       ; Toggle ruler visibility
0031                       ;-------------------------------------------------------
0032 6764 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     6766 A116 
0033 6768 0560  34         inv   @tv.ruler.visible     ; Toggle ruler visibility
     676A A010 
0034 676C 1302  14         jeq   edkey.action.toggle.ruler.fb
0035 676E 06A0  32         bl    @fb.ruler.init        ; Setup ruler in ram
     6770 7D4E 
0036                       ;-------------------------------------------------------
0037                       ; Update framebuffer pane
0038                       ;-------------------------------------------------------
0039               edkey.action.toggle.ruler.fb:
0040 6772 06A0  32         bl    @pane.cmdb.hide       ; Actions are the same as when hiding CMDB
     6774 78BC 
0041 6776 C839  50         mov   *stack+,@wyx          ; Pop cursor YX
     6778 832A 
0042 677A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.toggle.ruler.exit:
0047 677C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     677E 747E 
**** **** ****     > stevie_b1.asm.393026
0094                       copy  "edkey.fb.file.asm"        ; File related actions
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
0017 6780 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6782 A444 
     6784 2F20 
0018 6786 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6788 2F22 
0019 678A 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 678C C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     678E A444 
     6790 2F20 
0023 6792 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     6794 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Assert
0028                       ;------------------------------------------------------
0029 6796 C120  34         mov   @parm1,tmp0
     6798 2F20 
0030 679A 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 679C C120  34         mov   @edb.dirty,tmp0
     679E A206 
0036 67A0 1302  14         jeq   !
0037 67A2 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     67A4 7D18 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 67A6 06A0  32 !       bl    @fm.browse.fname.suffix
     67A8 7CBE 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 67AA 0204  20         li    tmp0,heap.top         ; 1st line in heap
     67AC E000 
0047 67AE 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     67B0 7C86 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 67B2 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     67B4 63C6 
**** **** ****     > stevie_b1.asm.393026
0095                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
**** **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 67B6 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     67B8 7138 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 67BA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67BC 747E 
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 67BE 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     67C0 7160 
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 67C2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67C4 747E 
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 67C6 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     67C8 7188 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 67CA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67CC 747E 
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 67CE 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67D0 7AFC 
0043 67D2 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     67D4 71C4 
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 67D6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67D8 747E 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054 67DA 0649  14         dect  stack
0055 67DC C644  30         mov   tmp0,*stack           ; Push tmp0
0056                       ;-------------------------------------------------------
0057                       ; Exit early if nothing to do
0058                       ;-------------------------------------------------------
0059 67DE 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67E0 A20E 
     67E2 2022 
0060 67E4 1315  14         jeq   edkey.action.block.copy.exit
0061                                                   ; Yes, exit early
0062                       ;-------------------------------------------------------
0063                       ; Init
0064                       ;-------------------------------------------------------
0065 67E6 C120  34         mov   @wyx,tmp0             ; Get cursor position
     67E8 832A 
0066 67EA 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     67EC FF00 
0067 67EE C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     67F0 A114 
0068                       ;-------------------------------------------------------
0069                       ; Copy
0070                       ;-------------------------------------------------------
0071 67F2 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67F4 7AFC 
0072               
0073 67F6 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     67F8 2F20 
0074 67FA 06A0  32         bl    @edb.block.copy       ; Copy code block
     67FC 720A 
0075                                                   ; \ i  @parm1    = Message flag
0076                                                   ; / o  @outparm1 = >ffff if success
0077               
0078 67FE 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     6800 2F30 
     6802 2000 
0079 6804 1305  14         jeq   edkey.action.block.copy.exit
0080                                                   ; If yes, exit early
0081               
0082 6806 C820  54         mov   @fb.yxsave,@parm1
     6808 A114 
     680A 2F20 
0083 680C 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     680E 6B40 
0084                                                   ; \ i  @parm1 = cursor YX position
0085                                                   ; /
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.block.copy.exit:
0090 6810 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 6812 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6814 747E 
0092               
0093               
0094               
0095               
0096               *---------------------------------------------------------------
0097               * Delete code block
0098               ********|*****|*********************|**************************
0099               edkey.action.block.delete:
0100                       ;-------------------------------------------------------
0101                       ; Exit early if nothing to do
0102                       ;-------------------------------------------------------
0103 6816 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6818 A20E 
     681A 2022 
0104 681C 130F  14         jeq   edkey.action.block.delete.exit
0105                                                   ; Yes, exit early
0106                       ;-------------------------------------------------------
0107                       ; Delete
0108                       ;-------------------------------------------------------
0109 681E 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     6820 7AFC 
0110               
0111 6822 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     6824 2F20 
0112 6826 06A0  32         bl    @edb.block.delete     ; Delete code block
     6828 7300 
0113                                                   ; \ i  @parm1    = Display message Yes/No
0114                                                   ; / o  @outparm1 = >ffff if success
0115                       ;-------------------------------------------------------
0116                       ; Reposition in frame buffer
0117                       ;-------------------------------------------------------
0118 682A 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     682C 2F30 
     682E 2000 
0119 6830 1305  14         jeq   edkey.action.block.delete.exit
0120                                                   ; If yes, exit early
0121               
0122 6832 C820  54         mov   @fb.topline,@parm1
     6834 A104 
     6836 2F20 
0123 6838 0460  28         b     @_edkey.goto.fb.toprow
     683A 6412 
0124                                                   ; Position on top row in frame buffer
0125                                                   ; \ i  @parm1 = Line to display as top row
0126                                                   ; /
0127                       ;-------------------------------------------------------
0128                       ; Exit
0129                       ;-------------------------------------------------------
0130               edkey.action.block.delete.exit:
0131 683C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     683E 747E 
0132               
0133               
0134               *---------------------------------------------------------------
0135               * Move code block
0136               ********|*****|*********************|**************************
0137               edkey.action.block.move:
0138                       ;-------------------------------------------------------
0139                       ; Exit early if nothing to do
0140                       ;-------------------------------------------------------
0141 6840 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6842 A20E 
     6844 2022 
0142 6846 1313  14         jeq   edkey.action.block.move.exit
0143                                                   ; Yes, exit early
0144                       ;-------------------------------------------------------
0145                       ; Delete
0146                       ;-------------------------------------------------------
0147 6848 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     684A 7AFC 
0148               
0149 684C 0720  34         seto  @parm1                ; Set message to "Moving block..."
     684E 2F20 
0150 6850 06A0  32         bl    @edb.block.copy       ; Copy code block
     6852 720A 
0151                                                   ; \ i  @parm1    = Message flag
0152                                                   ; / o  @outparm1 = >ffff if success
0153               
0154 6854 0720  34         seto  @parm1                ; Don't display delete message
     6856 2F20 
0155 6858 06A0  32         bl    @edb.block.delete     ; Delete code block
     685A 7300 
0156                                                   ; \ i  @parm1    = Display message Yes/No
0157                                                   ; / o  @outparm1 = >ffff if success
0158                       ;-------------------------------------------------------
0159                       ; Reposition in frame buffer
0160                       ;-------------------------------------------------------
0161 685C 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     685E 2F30 
     6860 2000 
0162 6862 13EC  14         jeq   edkey.action.block.delete.exit
0163                                                   ; If yes, exit early
0164               
0165 6864 C820  54         mov   @fb.topline,@parm1
     6866 A104 
     6868 2F20 
0166 686A 0460  28         b     @_edkey.goto.fb.toprow
     686C 6412 
0167                                                   ; Position on top row in frame buffer
0168                                                   ; \ i  @parm1 = Line to display as top row
0169                                                   ; /
0170                       ;-------------------------------------------------------
0171                       ; Exit
0172                       ;-------------------------------------------------------
0173               edkey.action.block.move.exit:
0174 686E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6870 747E 
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Goto marker M1
0179               ********|*****|*********************|**************************
0180               edkey.action.block.goto.m1:
0181 6872 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6874 A20C 
     6876 2022 
0182 6878 1307  14         jeq   edkey.action.block.goto.m1.exit
0183                                                   ; Yes, exit early
0184                       ;-------------------------------------------------------
0185                       ; Goto marker M1
0186                       ;-------------------------------------------------------
0187 687A C820  54         mov   @edb.block.m1,@parm1
     687C A20C 
     687E 2F20 
0188 6880 0620  34         dec   @parm1                ; Base 0 offset
     6882 2F20 
0189               
0190 6884 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     6886 6432 
0191                                                   ; \ i @parm1 = Target line in EB
0192                                                   ; /
0193                       ;-------------------------------------------------------
0194                       ; Exit
0195                       ;-------------------------------------------------------
0196               edkey.action.block.goto.m1.exit:
0197 6888 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     688A 747E 
**** **** ****     > stevie_b1.asm.393026
0096                       copy  "edkey.fb.tabs.asm"        ; tab-key related actions
**** **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 688C 0649  14         dect  stack
0009 688E C64B  30         mov   r11,*stack            ; Save return address
0010 6890 06A0  32         bl  @fb.tab.next            ; Jump to next tab position on line
     6892 7D3C 
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 6894 C2F9  30         mov   *stack+,r11           ; Pop r11
0016 6896 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6898 747E 
**** **** ****     > stevie_b1.asm.393026
0097                       ;-----------------------------------------------------------------------
0098                       ; Keyboard actions - Command Buffer
0099                       ;-----------------------------------------------------------------------
0100                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 689A C120  34         mov   @cmdb.column,tmp0
     689C A312 
0009 689E 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 68A0 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     68A2 A312 
0014 68A4 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     68A6 A30A 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 68A8 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     68AA 747E 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 68AC 06A0  32         bl    @cmdb.cmd.getlength
     68AE 741E 
0026 68B0 8820  54         c     @cmdb.column,@outparm1
     68B2 A312 
     68B4 2F30 
0027 68B6 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 68B8 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     68BA A312 
0032 68BC 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     68BE A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 68C0 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     68C2 747E 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 68C4 04C4  14         clr   tmp0
0045 68C6 C804  38         mov   tmp0,@cmdb.column      ; First column
     68C8 A312 
0046 68CA 0584  14         inc   tmp0
0047 68CC D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     68CE A30A 
0048 68D0 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     68D2 A30A 
0049               
0050 68D4 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68D6 747E 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 68D8 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     68DA A326 
0057 68DC 0984  56         srl   tmp0,8                 ; Right justify
0058 68DE C804  38         mov   tmp0,@cmdb.column      ; Save column position
     68E0 A312 
0059 68E2 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 68E4 0224  22         ai    tmp0,>1a00             ; Y=26
     68E6 1A00 
0061 68E8 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     68EA A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 68EC 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68EE 747E 
**** **** ****     > stevie_b1.asm.393026
0101                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
**** **** ****     > edkey.cmdb.mod.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for modifier keys in command buffer pane.
0003               
0004               ***************************************************************
0005               * edkey.action.cmdb.clear
0006               * Clear current command
0007               ***************************************************************
0008               * b  @edkey.action.cmdb.clear
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
0021               edkey.action.cmdb.clear:
0022                       ;-------------------------------------------------------
0023                       ; Clear current command
0024                       ;-------------------------------------------------------
0025 68F0 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     68F2 73EC 
0026 68F4 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     68F6 A318 
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 68F8 0460  28         b     @edkey.action.cmdb.home
     68FA 68C4 
0032                                                   ; Reposition cursor
0033               
0034               
0035               
0036               
0037               
0038               
0039               ***************************************************************
0040               * edkey.action.cmdb.char
0041               * Add character to command line
0042               ***************************************************************
0043               * b  @edkey.action.cmdb.char
0044               *--------------------------------------------------------------
0045               * INPUT
0046               * tmp1
0047               *--------------------------------------------------------------
0048               * OUTPUT
0049               * none
0050               *--------------------------------------------------------------
0051               * Register usage
0052               * tmp0
0053               *--------------------------------------------------------------
0054               * Notes
0055               ********|*****|*********************|**************************
0056               edkey.action.cmdb.char:
0057                       ;-------------------------------------------------------
0058                       ; Asserts
0059                       ;-------------------------------------------------------
0060 68FC D105  18         movb  tmp1,tmp0             ; Get keycode
0061 68FE 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 6900 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6902 0020 
0064 6904 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 6906 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6908 007E 
0068 690A 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 690C 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     690E A318 
0074               
0075 6910 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6912 A327 
0076 6914 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6916 A312 
0077 6918 D505  30         movb  tmp1,*tmp0            ; Add character
0078 691A 05A0  34         inc   @cmdb.column          ; Next column
     691C A312 
0079 691E 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     6920 A30A 
0080               
0081 6922 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6924 741E 
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 6926 C120  34         mov   @outparm1,tmp0
     6928 2F30 
0088 692A 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 692C D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     692E A326 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 6930 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6932 747E 
**** **** ****     > stevie_b1.asm.393026
0102                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 6934 C120  34         mov   @cmdb.visible,tmp0
     6936 A302 
0009 6938 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 693A 04E0  34         clr   @cmdb.column          ; Column = 0
     693C A312 
0015 693E 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6940 786C 
0016 6942 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 6944 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6946 78BC 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 6948 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     694A 747E 
**** **** ****     > stevie_b1.asm.393026
0103                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
**** **** ****     > edkey.cmdb.file.load.asm
0001               * FILE......: edkey.cmdb.fíle.load.asm
0002               * Purpose...: Load file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.load:
0008                       ;-------------------------------------------------------
0009                       ; Load file
0010                       ;-------------------------------------------------------
0011 694C 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     694E 78BC 
0012               
0013 6950 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6952 741E 
0014 6954 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6956 2F30 
0015 6958 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 695A 06A0  32         bl    @pane.errline.show    ; Show error line
     695C 7A94 
0020               
0021 695E 06A0  32         bl    @pane.show_hint
     6960 75EA 
0022 6962 1600                   byte pane.botrow-1,0
0023 6964 387C                   data txt.io.nofile
0024               
0025 6966 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 6968 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 696A D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     696C A326 
0031               
0032 696E 06A0  32         bl    @cpym2m
     6970 24DC 
0033 6972 A326                   data cmdb.cmdlen,heap.top,80
     6974 E000 
     6976 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 6978 0204  20         li    tmp0,heap.top         ; 1st line in heap
     697A E000 
0039 697C C804  38         mov   tmp0,@parm1
     697E 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Load file
0042                       ;-------------------------------------------------------
0043               edkey.action.cmdb.load.file:
0044 6980 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6982 E000 
0045 6984 C804  38         mov   tmp0,@parm1
     6986 2F20 
0046               
0047 6988 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     698A 7C86 
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 698C 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     698E 63C6 
**** **** ****     > stevie_b1.asm.393026
0104                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
**** **** ****     > edkey.cmdb.file.save.asm
0001               * FILE......: edkey.cmdb.fíle.save.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Save DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.save:
0008                       ;-------------------------------------------------------
0009                       ; Save file
0010                       ;-------------------------------------------------------
0011 6990 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6992 78BC 
0012               
0013 6994 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6996 741E 
0014 6998 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     699A 2F30 
0015 699C 1607  14         jne   !                     ; No, prepare for save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 699E 06A0  32         bl    @pane.errline.show    ; Show error line
     69A0 7A94 
0020               
0021 69A2 06A0  32         bl    @pane.show_hint
     69A4 75EA 
0022 69A6 1600                   byte pane.botrow-1,0
0023 69A8 387C                   data txt.io.nofile
0024               
0025 69AA 1020  14         jmp   edkey.action.cmdb.save.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 69AC 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 69AE D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     69B0 A326 
0031               
0032 69B2 06A0  32         bl    @cpym2m
     69B4 24DC 
0033 69B6 A326                   data cmdb.cmdlen,heap.top,80
     69B8 E000 
     69BA 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 69BC 0204  20         li    tmp0,heap.top         ; 1st line in heap
     69BE E000 
0039 69C0 C804  38         mov   tmp0,@parm1
     69C2 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Save all lines in editor buffer?
0042                       ;-------------------------------------------------------
0043 69C4 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     69C6 A20E 
     69C8 2022 
0044 69CA 1309  14         jeq   edkey.action.cmdb.save.all
0045                                                   ; Yes, so save all lines in editor buffer
0046                       ;-------------------------------------------------------
0047                       ; Only save code block M1-M2
0048                       ;-------------------------------------------------------
0049 69CC C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     69CE A20C 
     69D0 2F22 
0050 69D2 0620  34         dec   @parm2                ; /
     69D4 2F22 
0051               
0052 69D6 C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     69D8 A20E 
     69DA 2F24 
0053               
0054 69DC 1005  14         jmp   edkey.action.cmdb.save.file
0055                       ;-------------------------------------------------------
0056                       ; Save all lines in editor buffer
0057                       ;-------------------------------------------------------
0058               edkey.action.cmdb.save.all:
0059 69DE 04E0  34         clr   @parm2                ; First line to save
     69E0 2F22 
0060 69E2 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     69E4 A204 
     69E6 2F24 
0061                       ;-------------------------------------------------------
0062                       ; Save file
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.file:
0065 69E8 06A0  32         bl    @fm.savefile          ; Save DV80 file
     69EA 7CAC 
0066                                                   ; \ i  parm1 = Pointer to length-prefixed
0067                                                   ; |            device/filename string
0068                                                   ; | i  parm2 = First line to save (base 0)
0069                                                   ; | i  parm3 = Last line to save  (base 0)
0070                                                   ; /
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               edkey.action.cmdb.save.exit:
0075 69EC 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     69EE 63C6 
**** **** ****     > stevie_b1.asm.393026
0105                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
**** **** ****     > edkey.cmdb.dialog.asm
0001               * FILE......: edkey.cmdb.dialog.asm
0002               * Purpose...: Dialog specific actions in command buffer pane.
0003               
0004               ***************************************************************
0005               * edkey.action.cmdb.proceed
0006               * Proceed with action
0007               ***************************************************************
0008               * b   @edkey.action.cmdb.proceed
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @cmdb.action.ptr = Pointer to keyboard action
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.cmdb.proceed:
0017                       ;-------------------------------------------------------
0018                       ; Intialisation
0019                       ;-------------------------------------------------------
0020 69F0 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     69F2 A206 
0021 69F4 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     69F6 7806 
0022 69F8 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     69FA 73EC 
0023 69FC C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     69FE A324 
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 6A00 0284  22         ci    tmp0,>2000
     6A02 2000 
0028 6A04 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 6A06 0284  22         ci    tmp0,>7fff
     6A08 7FFF 
0031 6A0A 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 6A0C 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 6A0E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6A10 FFCE 
0040 6A12 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A14 2026 
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 6A16 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A18 747E 
0046               
0047               
0048               
0049               
0050               ***************************************************************
0051               * edkey.action.cmdb.fastmode.toggle
0052               * Toggle fastmode on/off
0053               ***************************************************************
0054               * b   @edkey.action.cmdb.fastmode.toggle
0055               *--------------------------------------------------------------
0056               * INPUT
0057               * none
0058               *--------------------------------------------------------------
0059               * Register usage
0060               * none
0061               ********|*****|*********************|**************************
0062               edkey.action.cmdb.fastmode.toggle:
0063 6A1A 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6A1C 7CD0 
0064 6A1E 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6A20 A318 
0065 6A22 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6A24 747E 
0066               
0067               
0068               
0069               
0070               ***************************************************************
0071               * dialog.close
0072               * Close dialog "About"
0073               ***************************************************************
0074               * b   @edkey.action.cmdb.close.about
0075               *--------------------------------------------------------------
0076               * OUTPUT
0077               * none
0078               *--------------------------------------------------------------
0079               * Register usage
0080               * none
0081               ********|*****|*********************|**************************
0082               edkey.action.cmdb.close.about:
0083                       ;------------------------------------------------------
0084                       ; Erase header line
0085                       ;------------------------------------------------------
0086 6A26 06A0  32         bl    @hchar
     6A28 27C6 
0087 6A2A 0000                   byte 0,0,32,80*2
     6A2C 20A0 
0088 6A2E FFFF                   data EOL
0089 6A30 1000  14         jmp   edkey.action.cmdb.close.dialog
0090               
0091               
0092               ***************************************************************
0093               * dialog.close
0094               * Close dialog
0095               ***************************************************************
0096               * b   @edkey.action.cmdb.close.dialog
0097               *--------------------------------------------------------------
0098               * OUTPUT
0099               * none
0100               *--------------------------------------------------------------
0101               * Register usage
0102               * none
0103               ********|*****|*********************|**************************
0104               edkey.action.cmdb.close.dialog:
0105                       ;------------------------------------------------------
0106                       ; Close dialog
0107                       ;------------------------------------------------------
0108 6A32 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6A34 A31A 
0109 6A36 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6A38 7806 
0110 6A3A 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6A3C 78BC 
0111 6A3E 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6A40 A118 
0112                       ;-------------------------------------------------------
0113                       ; Exit
0114                       ;-------------------------------------------------------
0115               edkey.action.cmdb.close.dialog.exit:
0116 6A42 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A44 747E 
**** **** ****     > stevie_b1.asm.393026
0106                       ;-----------------------------------------------------------------------
0107                       ; Logic for Framebuffer (1)
0108                       ;-----------------------------------------------------------------------
0109                       copy  "fb.utils.asm"        ; Framebuffer utilities
**** **** ****     > fb.utils.asm
0001               * FILE......: fb.utils.asm
0002               * Purpose...: Stevie Editor - Framebuffer utilities
0003               
0004               ***************************************************************
0005               * fb.row2line
0006               * Calculate line in editor buffer
0007               ***************************************************************
0008               * bl @fb.row2line
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @fb.topline = Top line in frame buffer
0012               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * @outparm1 = Matching line in editor buffer
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               *--------------------------------------------------------------
0020               * Formula
0021               * outparm1 = @fb.topline + @parm1
0022               ********|*****|*********************|**************************
0023               fb.row2line:
0024 6A46 0649  14         dect  stack
0025 6A48 C64B  30         mov   r11,*stack            ; Save return address
0026 6A4A 0649  14         dect  stack
0027 6A4C C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6A4E C120  34         mov   @parm1,tmp0
     6A50 2F20 
0032 6A52 A120  34         a     @fb.topline,tmp0
     6A54 A104 
0033 6A56 C804  38         mov   tmp0,@outparm1
     6A58 2F30 
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 6A5A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6A5C C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6A5E 045B  20         b     *r11                  ; Return to caller
0041               
0042               
0043               
0044               
0045               ***************************************************************
0046               * fb.calc_pointer
0047               * Calculate pointer address in frame buffer
0048               ***************************************************************
0049               * bl @fb.calc_pointer
0050               *--------------------------------------------------------------
0051               * INPUT
0052               * @fb.top       = Address of top row in frame buffer
0053               * @fb.topline   = Top line in frame buffer
0054               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0055               * @fb.column    = Current column in frame buffer
0056               * @fb.colsline  = Columns per line in frame buffer
0057               *--------------------------------------------------------------
0058               * OUTPUT
0059               * @fb.current   = Updated pointer
0060               *--------------------------------------------------------------
0061               * Register usage
0062               * tmp0,tmp1
0063               *--------------------------------------------------------------
0064               * Formula
0065               * pointer = row * colsline + column + deref(@fb.top.ptr)
0066               ********|*****|*********************|**************************
0067               fb.calc_pointer:
0068 6A60 0649  14         dect  stack
0069 6A62 C64B  30         mov   r11,*stack            ; Save return address
0070 6A64 0649  14         dect  stack
0071 6A66 C644  30         mov   tmp0,*stack           ; Push tmp0
0072 6A68 0649  14         dect  stack
0073 6A6A C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 6A6C C120  34         mov   @fb.row,tmp0
     6A6E A106 
0078 6A70 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6A72 A10E 
0079 6A74 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     6A76 A10C 
0080 6A78 A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     6A7A A100 
0081 6A7C C805  38         mov   tmp1,@fb.current
     6A7E A102 
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 6A80 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 6A82 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6A84 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6A86 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0110                       copy  "fb.get.firstnonblank.asm"
**** **** ****     > fb.get.firstnonblank.asm
0001               * FILE......: fb.get.firstnonblank.asm
0002               * Purpose...: Get column of first non-blank character
0003               
0004               ***************************************************************
0005               * fb.get.firstnonblank
0006               * Get column of first non-blank character in specified line
0007               ***************************************************************
0008               * bl @fb.get.firstnonblank
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * @outparm1 = Column containing first non-blank character
0012               * @outparm2 = Character
0013               ********|*****|*********************|**************************
0014               fb.get.firstnonblank:
0015 6A88 0649  14         dect  stack
0016 6A8A C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6A8C 04E0  34         clr   @fb.column
     6A8E A10C 
0021 6A90 06A0  32         bl    @fb.calc_pointer
     6A92 6A60 
0022 6A94 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6A96 6FA2 
0023 6A98 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6A9A A108 
0024 6A9C 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6A9E C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6AA0 A102 
0027 6AA2 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6AA4 D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6AA6 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6AA8 0285  22         ci    tmp1,>2000            ; Whitespace?
     6AAA 2000 
0036 6AAC 1503  14         jgt   fb.get.firstnonblank.match
0037 6AAE 0606  14         dec   tmp2                  ; Counter--
0038 6AB0 16F9  14         jne   fb.get.firstnonblank.loop
0039 6AB2 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6AB4 6120  34         s     @fb.current,tmp0      ; Calculate column
     6AB6 A102 
0045 6AB8 0604  14         dec   tmp0
0046 6ABA C804  38         mov   tmp0,@outparm1        ; Save column
     6ABC 2F30 
0047 6ABE D805  38         movb  tmp1,@outparm2        ; Save character
     6AC0 2F32 
0048 6AC2 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6AC4 04E0  34         clr   @outparm1             ; X=0
     6AC6 2F30 
0054 6AC8 04E0  34         clr   @outparm2             ; Null
     6ACA 2F32 
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6ACC C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6ACE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0111                                                   ; Get column of first non-blank character
0112                       copy  "fb.refresh.asm"      ; Refresh framebuffer
**** **** ****     > fb.refresh.asm
0001               * FILE......: fb.refresh.asm
0002               * Purpose...: Refresh frame buffer with editor buffer content
0003               
0004               ***************************************************************
0005               * fb.refresh
0006               * Refresh frame buffer with editor buffer content
0007               ***************************************************************
0008               * bl @fb.refresh
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line to start with (becomes @fb.topline)
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               ********|*****|*********************|**************************
0019               fb.refresh:
0020 6AD0 0649  14         dect  stack
0021 6AD2 C64B  30         mov   r11,*stack            ; Push return address
0022 6AD4 0649  14         dect  stack
0023 6AD6 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6AD8 0649  14         dect  stack
0025 6ADA C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6ADC 0649  14         dect  stack
0027 6ADE C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6AE0 C820  54         mov   @parm1,@fb.topline
     6AE2 2F20 
     6AE4 A104 
0032 6AE6 04E0  34         clr   @parm2                ; Target row in frame buffer
     6AE8 2F22 
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6AEA 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6AEC 2F20 
     6AEE A204 
0037 6AF0 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6AF2 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6AF4 6EA4 
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6AF6 05A0  34         inc   @parm1                ; Next line in editor buffer
     6AF8 2F20 
0048 6AFA 05A0  34         inc   @parm2                ; Next row in frame buffer
     6AFC 2F22 
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6AFE 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6B00 2F20 
     6B02 A204 
0053 6B04 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6B06 8820  54         c     @parm2,@fb.scrrows
     6B08 2F22 
     6B0A A11A 
0056 6B0C 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6B0E 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6B10 C120  34         mov   @parm2,tmp0           ; Current row
     6B12 2F22 
0064 6B14 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6B16 A11A 
0065 6B18 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6B1A 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6B1C A10E 
0067               
0068 6B1E C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6B20 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6B22 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6B24 A10E 
0072 6B26 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6B28 A100 
0073               
0074 6B2A C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6B2C 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6B2E 06A0  32         bl    @xfilm                ; \ Fill memory
     6B30 223E 
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6B32 0720  34         seto  @fb.dirty             ; Refresh screen
     6B34 A116 
0086 6B36 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0087 6B38 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0088 6B3A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 6B3C C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6B3E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0113                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
**** **** ****     > fb.restore.asm
0001               * FILE......: fb.restore.asm
0002               * Purpose...: Restore frame buffer to normal operation
0003               
0004               ***************************************************************
0005               * fb.restore
0006               * Restore frame buffer to normal operation
0007               * (e.g. after command has completed)
0008               ***************************************************************
0009               *  bl   @fb.restore
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @parm1 = cursor YX position
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * NONE
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * NONE
0019               ********|*****|*********************|**************************
0020               fb.restore:
0021 6B40 0649  14         dect  stack
0022 6B42 C64B  30         mov   r11,*stack            ; Save return address
0023 6B44 0649  14         dect  stack
0024 6B46 C660  46         mov   @parm1,*stack         ; Push @parm1
     6B48 2F20 
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6B4A C820  54         mov   @fb.topline,@parm1
     6B4C A104 
     6B4E 2F20 
0029 6B50 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6B52 6AD0 
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6B54 0720  34         seto  @parm1                ; Skip Asserts
     6B56 2F20 
0035 6B58 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6B5A 7D60 
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6B5C C820  54         mov   @tv.color,@parm1      ; Set normal color
     6B5E A018 
     6B60 2F20 
0042 6B62 06A0  32         bl    @pane.action.colorscheme.statlines
     6B64 77CE 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6B66 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6B68 A118 
0050               
0051 6B6A 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6B6C 7806 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6B6E C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6B70 2F20 
0057 6B72 C820  54         mov   @parm1,@wyx           ; Set cursor position
     6B74 2F20 
     6B76 832A 
0058 6B78 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6B7A 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.393026
0114                       ;-----------------------------------------------------------------------
0115                       ; Logic for Index management
0116                       ;-----------------------------------------------------------------------
0117                       copy  "idx.update.asm"      ; Index management - Update entry
**** **** ****     > idx.update.asm
0001               * FILE......: idx.update.asm
0002               * Purpose...: Update index entry
0003               
0004               ***************************************************************
0005               * idx.entry.update
0006               * Update index entry - Each entry corresponds to a line
0007               ***************************************************************
0008               * bl @idx.entry.update
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1    = Line number in editor buffer
0012               * @parm2    = Pointer to line in editor buffer
0013               * @parm3    = SAMS page
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = Pointer to updated index entry
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               ********|*****|*********************|**************************
0021               idx.entry.update:
0022 6B7C 0649  14         dect  stack
0023 6B7E C64B  30         mov   r11,*stack            ; Save return address
0024 6B80 0649  14         dect  stack
0025 6B82 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6B84 0649  14         dect  stack
0027 6B86 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6B88 C120  34         mov   @parm1,tmp0           ; Get line number
     6B8A 2F20 
0032 6B8C C160  34         mov   @parm2,tmp1           ; Get pointer
     6B8E 2F22 
0033 6B90 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6B92 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6B94 0FFF 
0039 6B96 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6B98 06E0  34         swpb  @parm3
     6B9A 2F24 
0044 6B9C D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6B9E 2F24 
0045 6BA0 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6BA2 2F24 
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6BA4 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BA6 31A0 
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6BA8 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6BAA 2F30 
0056 6BAC C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6BAE B000 
0057 6BB0 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6BB2 2F30 
0058 6BB4 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6BB6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BB8 31A0 
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6BBA C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6BBC 2F30 
0068 6BBE 04E4  34         clr   @idx.top(tmp0)        ; /
     6BC0 B000 
0069 6BC2 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6BC4 2F30 
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6BC6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6BC8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6BCA C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6BCC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0118                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
**** **** ****     > idx.pointer.asm
0001               * FILE......: idx.pointer.asm
0002               * Purpose...: Get pointer to line in editor buffer
0003               
0004               ***************************************************************
0005               * idx.pointer.get
0006               * Get pointer to editor buffer line content
0007               ***************************************************************
0008               * bl @idx.pointer.get
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line number in editor buffer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @outparm1 = Pointer to editor buffer line content
0015               * @outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               ********|*****|*********************|**************************
0020               idx.pointer.get:
0021 6BCE 0649  14         dect  stack
0022 6BD0 C64B  30         mov   r11,*stack            ; Save return address
0023 6BD2 0649  14         dect  stack
0024 6BD4 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6BD6 0649  14         dect  stack
0026 6BD8 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6BDA 0649  14         dect  stack
0028 6BDC C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6BDE C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6BE0 2F20 
0033               
0034 6BE2 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6BE4 31A0 
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6BE6 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6BE8 2F30 
0039 6BEA C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6BEC B000 
0040               
0041 6BEE 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6BF0 C185  18         mov   tmp1,tmp2             ; \
0047 6BF2 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6BF4 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6BF6 00FF 
0052 6BF8 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6BFA 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6BFC C000 
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6BFE C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6C00 2F30 
0059 6C02 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6C04 2F32 
0060 6C06 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6C08 04E0  34         clr   @outparm1
     6C0A 2F30 
0066 6C0C 04E0  34         clr   @outparm2
     6C0E 2F32 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6C10 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6C12 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6C14 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6C16 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6C18 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0119                       copy  "idx.delete.asm"      ; Index management - delete slot
**** **** ****     > idx.delete.asm
0001               * FILE......: idx_delete.asm
0002               * Purpose...: Delete index entry
0003               
0004               ***************************************************************
0005               * _idx.entry.delete.reorg
0006               * Reorganize index slot entries
0007               ***************************************************************
0008               * bl @_idx.entry.delete.reorg
0009               *--------------------------------------------------------------
0010               *  Remarks
0011               *  Private, only to be called from idx_entry_delete
0012               ********|*****|*********************|**************************
0013               _idx.entry.delete.reorg:
0014                       ;------------------------------------------------------
0015                       ; Reorganize index entries
0016                       ;------------------------------------------------------
0017 6C1A 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6C1C B000 
0018 6C1E C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6C20 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6C22 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6C24 0606  14         dec   tmp2                  ; tmp2--
0026 6C26 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6C28 045B  20         b     *r11                  ; Return to caller
0029               
0030               
0031               
0032               ***************************************************************
0033               * idx.entry.delete
0034               * Delete index entry - Close gap created by delete
0035               ***************************************************************
0036               * bl @idx.entry.delete
0037               *--------------------------------------------------------------
0038               * INPUT
0039               * @parm1    = Line number in editor buffer to delete
0040               * @parm2    = Line number of last line to check for reorg
0041               *--------------------------------------------------------------
0042               * Register usage
0043               * tmp0,tmp1,tmp2,tmp3
0044               ********|*****|*********************|**************************
0045               idx.entry.delete:
0046 6C2A 0649  14         dect  stack
0047 6C2C C64B  30         mov   r11,*stack            ; Save return address
0048 6C2E 0649  14         dect  stack
0049 6C30 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6C32 0649  14         dect  stack
0051 6C34 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6C36 0649  14         dect  stack
0053 6C38 C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6C3A 0649  14         dect  stack
0055 6C3C C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6C3E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C40 2F20 
0060               
0061 6C42 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C44 31A0 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6C46 C120  34         mov   @outparm1,tmp0        ; Index offset
     6C48 2F30 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6C4A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6C4C 2F22 
0070 6C4E 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6C50 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6C52 2F20 
0074 6C54 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6C56 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6C58 B000 
0081 6C5A 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6C5C 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6C5E C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6C60 2F22 
0088 6C62 0287  22         ci    tmp3,2048
     6C64 0800 
0089 6C66 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6C68 06A0  32         bl    @_idx.sams.mapcolumn.on
     6C6A 3132 
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6C6C C120  34         mov   @parm1,tmp0           ; Restore line number
     6C6E 2F20 
0103 6C70 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6C72 06A0  32         bl    @_idx.entry.delete.reorg
     6C74 6C1A 
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6C76 06A0  32         bl    @_idx.sams.mapcolumn.off
     6C78 3166 
0111                                                   ; Restore memory window layout
0112               
0113 6C7A 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6C7C 06A0  32         bl    @_idx.entry.delete.reorg
     6C7E 6C1A 
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6C80 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6C82 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6C84 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6C86 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6C88 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6C8A C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6C8C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0120                       copy  "idx.insert.asm"      ; Index management - insert slot
**** **** ****     > idx.insert.asm
0001               * FILE......: idx.insert.asm
0002               * Purpose...: Insert index entry
0003               
0004               ***************************************************************
0005               * _idx.entry.insert.reorg
0006               * Reorganize index slot entries
0007               ***************************************************************
0008               * bl @_idx.entry.insert.reorg
0009               *--------------------------------------------------------------
0010               *  Remarks
0011               *  Private, only to be called from idx_entry_insert
0012               ********|*****|*********************|**************************
0013               _idx.entry.insert.reorg:
0014                       ;------------------------------------------------------
0015                       ; Assert 1
0016                       ;------------------------------------------------------
0017 6C8E 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6C90 2800 
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6C92 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6C94 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C96 FFCE 
0026 6C98 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C9A 2026 
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6C9C 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6C9E B000 
0031 6CA0 C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6CA2 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6CA4 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Assert 2
0036                       ;------------------------------------------------------
0037 6CA6 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6CA8 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6CAA 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6CAC A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6CAE 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6CB0 AFFE 
0042 6CB2 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6CB4 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6CB6 0644  14         dect  tmp0                  ; Move pointer up
0050 6CB8 0645  14         dect  tmp1                  ; Move pointer up
0051 6CBA 0606  14         dec   tmp2                  ; Next index entry
0052 6CBC 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6CBE 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6CC0 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6CC2 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               
0064               
0065               ***************************************************************
0066               * idx.entry.insert
0067               * Insert index entry
0068               ***************************************************************
0069               * bl @idx.entry.insert
0070               *--------------------------------------------------------------
0071               * INPUT
0072               * @parm1    = Line number in editor buffer to insert
0073               * @parm2    = Line number of last line to check for reorg
0074               *--------------------------------------------------------------
0075               * OUTPUT
0076               * NONE
0077               *--------------------------------------------------------------
0078               * Register usage
0079               * tmp0,tmp2
0080               ********|*****|*********************|**************************
0081               idx.entry.insert:
0082 6CC4 0649  14         dect  stack
0083 6CC6 C64B  30         mov   r11,*stack            ; Save return address
0084 6CC8 0649  14         dect  stack
0085 6CCA C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6CCC 0649  14         dect  stack
0087 6CCE C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6CD0 0649  14         dect  stack
0089 6CD2 C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6CD4 0649  14         dect  stack
0091 6CD6 C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6CD8 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6CDA 2F22 
0096 6CDC 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6CDE 2F20 
0097 6CE0 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6CE2 C1E0  34         mov   @parm2,tmp3
     6CE4 2F22 
0104 6CE6 0287  22         ci    tmp3,2048
     6CE8 0800 
0105 6CEA 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6CEC 06A0  32         bl    @_idx.sams.mapcolumn.on
     6CEE 3132 
0113                                                   ; Index in continious memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6CF0 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6CF2 2F22 
0117 6CF4 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6CF6 06A0  32         bl    @_idx.entry.insert.reorg
     6CF8 6C8E 
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6CFA 06A0  32         bl    @_idx.sams.mapcolumn.off
     6CFC 3166 
0125                                                   ; Restore memory window layout
0126               
0127 6CFE 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6D00 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D02 2F22 
0133               
0134 6D04 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6D06 31A0 
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6D08 C120  34         mov   @outparm1,tmp0        ; Index offset
     6D0A 2F30 
0139               
0140 6D0C 06A0  32         bl    @_idx.entry.insert.reorg
     6D0E 6C8E 
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6D10 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6D12 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6D14 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6D16 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6D18 C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6D1A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0121                       ;-----------------------------------------------------------------------
0122                       ; Logic for Editor Buffer
0123                       ;-----------------------------------------------------------------------
0124                       copy  "edb.utils.asm"          ; Editor buffer utilities
**** **** ****     > edb.utils.asm
0001               * FILE......: edb.utils.asm
0002               * Purpose...: Editor buffer utilities
0003               
0004               
0005               ***************************************************************
0006               * edb.adjust.hipage
0007               * Check and increase highest SAMS page of editor buffer
0008               ***************************************************************
0009               *  bl   @edb.adjust.hipage
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @edb.next_free.ptr = Pointer to next free line
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1
0018               ********|*****|*********************|**************************
0019               edb.adjust.hipage:
0020 6D1C 0649  14         dect  stack
0021 6D1E C64B  30         mov   r11,*stack            ; Save return address
0022 6D20 0649  14         dect  stack
0023 6D22 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6D24 0649  14         dect  stack
0025 6D26 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.adjust.hipage.check_setpage:
0030 6D28 C120  34         mov   @edb.next_free.ptr,tmp0
     6D2A A208 
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6D2C 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6D2E 0FFF 
0035 6D30 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6D32 0052 
0036 6D34 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6D36 0FF0 
0037 6D38 1105  14         jlt   edb.adjust.hipage.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6D3A 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6D3C A218 
0043 6D3E C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6D40 A200 
     6D42 A208 
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.adjust.hipage.setpage:
0049 6D44 C120  34         mov   @edb.sams.hipage,tmp0
     6D46 A218 
0050 6D48 C160  34         mov   @edb.top.ptr,tmp1
     6D4A A200 
0051 6D4C 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D4E 2578 
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6D50 1004  14         jmp   edb.adjust.hipage.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.adjust.hipage.crash:
0060 6D52 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D54 FFCE 
0061 6D56 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D58 2026 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.adjust.hipage.exit:
0066 6D5A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6D5C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6D5E C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6D60 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0125                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
**** **** ****     > edb.line.mappage.asm
0001               * FILE......: edb.line.mappage.asm
0002               * Purpose...: Editor buffer SAMS setup
0003               
0004               
0005               ***************************************************************
0006               * edb.line.mappage
0007               * Activate editor buffer SAMS page for line
0008               ***************************************************************
0009               * bl  @edb.line.mappage
0010               *
0011               * tmp0 = Line number in editor buffer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * outparm1 = Pointer to line in editor buffer
0015               * outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1
0019               ***************************************************************
0020               edb.line.mappage:
0021 6D62 0649  14         dect  stack
0022 6D64 C64B  30         mov   r11,*stack            ; Push return address
0023 6D66 0649  14         dect  stack
0024 6D68 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6D6A 0649  14         dect  stack
0026 6D6C C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 6D6E 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6D70 A204 
0031 6D72 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 6D74 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D76 FFCE 
0037 6D78 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D7A 2026 
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6D7C C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6D7E 2F20 
0043               
0044 6D80 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6D82 6BCE 
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6D84 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6D86 2F32 
0050 6D88 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6D8A 2F30 
0051 6D8C 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6D8E 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6D90 A008 
0057 6D92 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6D94 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6D96 2578 
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6D98 C820  54         mov   @outparm2,@tv.sams.c000
     6D9A 2F32 
     6D9C A008 
0066                                                   ; Set page in shadow registers
0067               
0068 6D9E C820  54         mov   @outparm2,@edb.sams.page
     6DA0 2F32 
     6DA2 A216 
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6DA4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6DA6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6DA8 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6DAA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0126                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
**** **** ****     > edb.line.pack.fb.asm
0001               * FILE......: edb.line.pack.fb.asm
0002               * Purpose...: Pack current line in framebuffer to editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.pack.fb
0006               * Pack current line in framebuffer
0007               ***************************************************************
0008               *  bl   @edb.line.pack.fb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @fb.top       = Address of top row in frame buffer
0012               * @fb.row       = Current row in frame buffer
0013               * @fb.column    = Current column in frame buffer
0014               * @fb.colsline  = Columns per line in frame buffer
0015               *--------------------------------------------------------------
0016               * OUTPUT
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               *--------------------------------------------------------------
0021               * Memory usage
0022               * rambuf   = Saved @fb.column
0023               * rambuf+2 = Saved beginning of row
0024               * rambuf+4 = Saved length of row
0025               ********|*****|*********************|**************************
0026               edb.line.pack.fb:
0027 6DAC 0649  14         dect  stack
0028 6DAE C64B  30         mov   r11,*stack            ; Save return address
0029 6DB0 0649  14         dect  stack
0030 6DB2 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6DB4 0649  14         dect  stack
0032 6DB6 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6DB8 0649  14         dect  stack
0034 6DBA C646  30         mov   tmp2,*stack           ; Push tmp2
0035 6DBC 0649  14         dect  stack
0036 6DBE C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 6DC0 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6DC2 A10C 
     6DC4 2F6A 
0041 6DC6 04E0  34         clr   @fb.column
     6DC8 A10C 
0042 6DCA 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6DCC 6A60 
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 6DCE 04C4  14         clr   tmp0                  ; Counter
0047 6DD0 04C7  14         clr   tmp3                  ; Counter for whitespace
0048 6DD2 C160  34         mov   @fb.current,tmp1      ; Get position
     6DD4 A102 
0049 6DD6 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6DD8 2F6C 
0050                       ;------------------------------------------------------
0051                       ; Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 6DDA D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 6DDC 0986  56         srl   tmp2,8                ; Right justify
0056 6DDE 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 6DE0 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 6DE2 0286  22         ci    tmp2,32               ; Was it a space character?
     6DE4 0020 
0063 6DE6 1301  14         jeq   edb.line.pack.fb.check80
0064 6DE8 C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 6DEA 0284  22         ci    tmp0,colrow
     6DEC 0050 
0070 6DEE 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 6DF0 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 6DF2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DF4 FFCE 
0078 6DF6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DF8 2026 
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 6DFA 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 6DFC 1103  14         jlt   edb.line.pack.fb.rtrim
0085 6DFE C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     6E00 2F6E 
0086 6E02 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 6E04 C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     6E06 2F6E 
0092               
0093 6E08 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 6E0A C184  18         mov   tmp0,tmp2             ; \
0096 6E0C 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 6E0E 0586  14         inc   tmp2                  ; /
0098               
0099 6E10 C107  18         mov   tmp3,tmp0             ; \
0100 6E12 A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     6E14 2F6C 
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 6E16 DD05  32         movb  tmp1,*tmp0+
0104 6E18 0606  14         dec   tmp2
0105 6E1A 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 6E1C 06A0  32 !       bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     6E1E 6D1C 
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; Step 2: Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 6E20 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6E22 A104 
     6E24 2F20 
0117 6E26 A820  54         a     @fb.row,@parm1        ; /
     6E28 A106 
     6E2A 2F20 
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 6E2C C820  54         mov   @edb.next_free.ptr,@parm2
     6E2E A208 
     6E30 2F22 
0123                                                   ; Pointer to new line
0124 6E32 C820  54         mov   @edb.sams.hipage,@parm3
     6E34 A218 
     6E36 2F24 
0125                                                   ; SAMS page to use
0126               
0127 6E38 06A0  32         bl    @idx.entry.update     ; Update index
     6E3A 6B7C 
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 6E3C C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6E3E 2F6C 
0136 6E40 C160  34         mov   @edb.next_free.ptr,tmp1
     6E42 A208 
0137                                                   ; Address of line in editor buffer
0138               
0139 6E44 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6E46 A208 
0140               
0141 6E48 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6E4A 2F6E 
0142 6E4C CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 6E4E 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 6E50 0286  22         ci    tmp2,2
     6E52 0002 
0150 6E54 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 6E56 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 6E58 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 6E5A 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 6E5C 0286  22         ci    tmp2,1
     6E5E 0001 
0157 6E60 1602  14         jne   edb.line.pack.fb.copyline.block
0158 6E62 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 6E64 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 6E66 06A0  32         bl    @xpym2m               ; Copy memory block
     6E68 24E2 
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 6E6A A820  54         a     @rambuf+4,@edb.next_free.ptr
     6E6C 2F6E 
     6E6E A208 
0171                                                      ; Add length of line
0172               
0173 6E70 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6E72 A208 
0174 6E74 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 6E76 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6E78 000F 
0176 6E7A A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6E7C A208 
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 6E7E C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6E80 2F6A 
     6E82 A10C 
0182               
0183 6E84 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6E86 A218 
     6E88 A216 
0184 6E8A 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 6E8C C120  34         mov   @edb.sams.page,tmp0
     6E8E A216 
0187 6E90 C160  34         mov   @edb.top.ptr,tmp1
     6E92 A200 
0188 6E94 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6E96 2578 
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 6E98 C1B9  30         mov   *stack+,tmp2          ; Pop tmp3
0196 6E9A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 6E9C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 6E9E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 6EA0 C2F9  30         mov   *stack+,r11           ; Pop R11
0200 6EA2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0127                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
**** **** ****     > edb.line.unpack.fb.asm
0001               * FILE......: edb.line.unpack.fb.asm
0002               * Purpose...: Unpack line from editor buffer to frame buffer
0003               
0004               ***************************************************************
0005               * edb.line.unpack.fb
0006               * Unpack specified line to framebuffer
0007               ***************************************************************
0008               *  bl   @edb.line.unpack.fb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line to unpack in editor buffer (base 0)
0012               * @parm2 = Target row in frame buffer
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * @outparm1 = Length of unpacked line
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               *--------------------------------------------------------------
0020               * Memory usage
0021               * rambuf    = Saved @parm1 of edb.line.unpack.fb
0022               * rambuf+2  = Saved @parm2 of edb.line.unpack.fb
0023               * rambuf+4  = Source memory address in editor buffer
0024               * rambuf+6  = Destination memory address in frame buffer
0025               * rambuf+8  = Length of line
0026               ********|*****|*********************|**************************
0027               edb.line.unpack.fb:
0028 6EA4 0649  14         dect  stack
0029 6EA6 C64B  30         mov   r11,*stack            ; Save return address
0030 6EA8 0649  14         dect  stack
0031 6EAA C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6EAC 0649  14         dect  stack
0033 6EAE C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6EB0 0649  14         dect  stack
0035 6EB2 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 6EB4 C820  54         mov   @parm1,@rambuf
     6EB6 2F20 
     6EB8 2F6A 
0040 6EBA C820  54         mov   @parm2,@rambuf+2
     6EBC 2F22 
     6EBE 2F6C 
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 6EC0 C120  34         mov   @fb.colsline,tmp0
     6EC2 A10E 
0045 6EC4 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6EC6 2F22 
0046 6EC8 C1A0  34         mov   @fb.top.ptr,tmp2
     6ECA A100 
0047 6ECC A146  18         a     tmp2,tmp1             ; Add base to offset
0048 6ECE C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6ED0 2F70 
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 6ED2 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     6ED4 2F20 
     6ED6 A204 
0053 6ED8 1103  14         jlt   !                     ; No, continue processing
0054               
0055 6EDA 04E0  34         clr   @rambuf+8             ; Set length=0
     6EDC 2F72 
0056 6EDE 1016  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 6EE0 C120  34 !       mov   @parm1,tmp0
     6EE2 2F20 
0061 6EE4 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6EE6 6D62 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 6EE8 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6EEA 2F30 
0069 6EEC 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 6EEE 04E0  34         clr   @rambuf+8             ; Set length=0
     6EF0 2F72 
0073 6EF2 100C  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 6EF4 C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 6EF6 C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6EF8 2F6E 
0080 6EFA C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6EFC 2F72 
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 6EFE 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6F00 0050 
0085                                                   ; /
0086 6F02 1204  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 6F04 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F06 FFCE 
0091 6F08 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F0A 2026 
0092                       ;------------------------------------------------------
0093                       ; Erase chars from last column until column 80
0094                       ;------------------------------------------------------
0095               edb.line.unpack.fb.clear:
0096 6F0C C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6F0E 2F70 
0097 6F10 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6F12 2F72 
0098               
0099 6F14 04C5  14         clr   tmp1                  ; Fill with >00
0100 6F16 C1A0  34         mov   @fb.colsline,tmp2
     6F18 A10E 
0101 6F1A 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6F1C 2F72 
0102 6F1E 0586  14         inc   tmp2
0103               
0104 6F20 06A0  32         bl    @xfilm                ; Fill CPU memory
     6F22 223E 
0105                                                   ; \ i  tmp0 = Target address
0106                                                   ; | i  tmp1 = Byte to fill
0107                                                   ; / i  tmp2 = Repeat count
0108                       ;------------------------------------------------------
0109                       ; Prepare for unpacking data
0110                       ;------------------------------------------------------
0111               edb.line.unpack.fb.prepare:
0112 6F24 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6F26 2F72 
0113 6F28 130F  14         jeq   edb.line.unpack.fb.exit
0114                                                   ; Exit if length = 0
0115 6F2A C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6F2C 2F6E 
0116 6F2E C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6F30 2F70 
0117                       ;------------------------------------------------------
0118                       ; Assert on line length
0119                       ;------------------------------------------------------
0120               edb.line.unpack.fb.copy:
0121 6F32 0286  22         ci    tmp2,80               ; Check line length
     6F34 0050 
0122 6F36 1204  14         jle   edb.line.unpack.fb.copy.doit
0123                       ;------------------------------------------------------
0124                       ; Crash the system
0125                       ;------------------------------------------------------
0126 6F38 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F3A FFCE 
0127 6F3C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F3E 2026 
0128                       ;------------------------------------------------------
0129                       ; Copy memory block
0130                       ;------------------------------------------------------
0131               edb.line.unpack.fb.copy.doit:
0132 6F40 C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     6F42 2F30 
0133               
0134 6F44 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6F46 24E2 
0135                                                   ; \ i  tmp0 = Source address
0136                                                   ; | i  tmp1 = Target address
0137                                                   ; / i  tmp2 = Bytes to copy
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               edb.line.unpack.fb.exit:
0142 6F48 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0143 6F4A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0144 6F4C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0145 6F4E C2F9  30         mov   *stack+,r11           ; Pop r11
0146 6F50 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0128                       copy  "edb.line.getlen.asm"    ; Get line length
**** **** ****     > edb.line.getlen.asm
0001               * FILE......: edb.line.getlen.asm
0002               * Purpose...: Get length of specified line in editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.getlength
0006               * Get length of specified line
0007               ***************************************************************
0008               *  bl   @edb.line.getlength
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line number (base 0)
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @outparm1 = Length of line
0015               * @outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1
0019               ********|*****|*********************|**************************
0020               edb.line.getlength:
0021 6F52 0649  14         dect  stack
0022 6F54 C64B  30         mov   r11,*stack            ; Push return address
0023 6F56 0649  14         dect  stack
0024 6F58 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6F5A 0649  14         dect  stack
0026 6F5C C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 6F5E 04E0  34         clr   @outparm1             ; Reset length
     6F60 2F30 
0031 6F62 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6F64 2F32 
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 6F66 C120  34         mov   @parm1,tmp0           ; \
     6F68 2F20 
0036 6F6A 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 6F6C 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     6F6E A204 
0039 6F70 1101  14         jlt   !                     ; No, continue processing
0040 6F72 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 6F74 C120  34 !       mov   @parm1,tmp0           ; Get line
     6F76 2F20 
0046               
0047 6F78 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F7A 6D62 
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 6F7C C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     6F7E 2F30 
0053 6F80 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 6F82 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 6F84 C805  38         mov   tmp1,@outparm1        ; Save length
     6F86 2F30 
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 6F88 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     6F8A 0050 
0064 6F8C 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 6F8E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F90 FFCE 
0070 6F92 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F94 2026 
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 6F96 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     6F98 2F30 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 6F9A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 6F9C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 6F9E C2F9  30         mov   *stack+,r11           ; Pop r11
0083 6FA0 045B  20         b     *r11                  ; Return to caller
0084               
0085               
0086               
0087               ***************************************************************
0088               * edb.line.getlength2
0089               * Get length of current row (as seen from editor buffer side)
0090               ***************************************************************
0091               *  bl   @edb.line.getlength2
0092               *--------------------------------------------------------------
0093               * INPUT
0094               * @fb.row = Row in frame buffer
0095               *--------------------------------------------------------------
0096               * OUTPUT
0097               * @fb.row.length = Length of row
0098               *--------------------------------------------------------------
0099               * Register usage
0100               * tmp0
0101               ********|*****|*********************|**************************
0102               edb.line.getlength2:
0103 6FA2 0649  14         dect  stack
0104 6FA4 C64B  30         mov   r11,*stack            ; Save return address
0105 6FA6 0649  14         dect  stack
0106 6FA8 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 6FAA C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6FAC A104 
0111 6FAE A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6FB0 A106 
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 6FB2 C804  38         mov   tmp0,@parm1
     6FB4 2F20 
0116 6FB6 06A0  32         bl    @edb.line.getlength
     6FB8 6F52 
0117 6FBA C820  54         mov   @outparm1,@fb.row.length
     6FBC 2F30 
     6FBE A108 
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 6FC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 6FC2 C2F9  30         mov   *stack+,r11           ; Pop R11
0125 6FC4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0129                       copy  "edb.line.copy.asm"      ; Copy line
**** **** ****     > edb.line.copy.asm
0001               * FILE......: edb.line.copy.asm
0002               * Purpose...: Copy line in editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.copy
0006               * Copy line in editor buffer
0007               ***************************************************************
0008               *  bl   @edb.line.copy
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Source line number in editor buffer
0012               * @parm2 = Target line number in editor buffer
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * NONE
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               *--------------------------------------------------------------
0020               * Memory usage
0021               * rambuf    = Length of source line
0022               * rambuf+2  = line number of target line
0023               * rambuf+4  = Pointer to source line in editor buffer
0024               * rambuf+6  = Pointer to target line in editor buffer
0025               *--------------------------------------------------------------
0026               * Remarks
0027               * @parm1 and @parm2 must be provided in base 1, but internally
0028               * we work with base 0!
0029               ********|*****|*********************|**************************
0030               edb.line.copy:
0031 6FC6 0649  14         dect  stack
0032 6FC8 C64B  30         mov   r11,*stack            ; Save return address
0033 6FCA 0649  14         dect  stack
0034 6FCC C644  30         mov   tmp0,*stack           ; Push tmp0
0035 6FCE 0649  14         dect  stack
0036 6FD0 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 6FD2 0649  14         dect  stack
0038 6FD4 C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 6FD6 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     6FD8 2F20 
     6FDA A204 
0043 6FDC 1204  14         jle   !
0044 6FDE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FE0 FFCE 
0045 6FE2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FE4 2026 
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 6FE6 C120  34 !       mov   @parm2,tmp0           ; Get target line number
     6FE8 2F22 
0050 6FEA 0604  14         dec   tmp0                  ; Base 0
0051 6FEC C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     6FEE 2F6C 
0052 6FF0 04E0  34         clr   @rambuf               ; Set source line length=0
     6FF2 2F6A 
0053 6FF4 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     6FF6 2F6E 
0054 6FF8 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     6FFA 2F70 
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 6FFC C120  34         mov   @parm1,tmp0           ; Get source line number
     6FFE 2F20 
0059 7000 0604  14         dec   tmp0                  ; Base 0
0060               
0061 7002 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     7004 6D62 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 7006 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     7008 2F30 
0069 700A 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 700C 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 700E C154  26         mov   *tmp0,tmp1            ; Get line length
0076 7010 C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     7012 2F6A 
0077 7014 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     7016 2F6A 
0078 7018 C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     701A 2F6E 
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 701C 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     701E 0050 
0083 7020 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 7022 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7024 FFCE 
0088 7026 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7028 2026 
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 702A A820  54         a     @w$1000,@edb.top.ptr
     702C 201A 
     702E A200 
0094 7030 A820  54         a     @w$1000,@edb.next_free.ptr
     7032 201A 
     7034 A208 
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 7036 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     7038 6D1C 
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 703A C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     703C 2F6E 
0111 703E C160  34         mov   @edb.next_free.ptr,tmp1
     7040 A208 
0112                                                   ; Pointer to space for new target line
0113               
0114 7042 C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     7044 2F6A 
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 7046 06A0  32         bl    @xpym2m               ; Copy memory block
     7048 24E2 
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 704A 6820  54         s     @w$1000,@edb.top.ptr
     704C 201A 
     704E A200 
0127 7050 6820  54         s     @w$1000,@edb.next_free.ptr
     7052 201A 
     7054 A208 
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 7056 C820  54         mov   @edb.next_free.ptr,@rambuf+6
     7058 A208 
     705A 2F70 
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 705C C120  34         mov   @edb.sams.page,tmp0
     705E A216 
0138 7060 C160  34         mov   @edb.top.ptr,tmp1
     7062 A200 
0139 7064 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7066 2578 
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 7068 C120  34         mov   @tv.sams.d000,tmp0
     706A A00A 
0146 706C 0205  20         li    tmp1,>d000
     706E D000 
0147 7070 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7072 2578 
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 7074 A820  54         a     @rambuf,@edb.next_free.ptr
     7076 2F6A 
     7078 A208 
0154                                                      ; Add length of line
0155               
0156 707A C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     707C A208 
0157 707E 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 7080 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7082 000F 
0159 7084 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     7086 A208 
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 7088 C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     708A 2F6C 
     708C 2F20 
0165 708E C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     7090 2F70 
     7092 2F22 
0166 7094 C820  54         mov   @edb.sams.hipage,@parm3
     7096 A218 
     7098 2F24 
0167                                                   ; SAMS page to use
0168               
0169 709A 06A0  32         bl    @idx.entry.update     ; Update index
     709C 6B7C 
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 709E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 70A0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 70A2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 70A4 C2F9  30         mov   *stack+,r11           ; Pop r11
0182 70A6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0130                       copy  "edb.line.del.asm"       ; Delete line
**** **** ****     > edb.line.del.asm
0001               * FILE......: edb.line.del.asm
0002               * Purpose...: Delete line in editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.del
0006               * Delete line in editor buffer
0007               ***************************************************************
0008               *  bl   @edb.line.del
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = line number in editor buffer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * NONE
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               *--------------------------------------------------------------
0019               * Remarks
0020               * @parm1 must be provided in base 1, but internally we work
0021               * with base 0!
0022               ********|*****|*********************|**************************
0023               edb.line.del:
0024 70A8 0649  14         dect  stack
0025 70AA C64B  30         mov   r11,*stack            ; Save return address
0026 70AC 0649  14         dect  stack
0027 70AE C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 70B0 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     70B2 2F20 
     70B4 A204 
0032 70B6 1204  14         jle   !
0033 70B8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70BA FFCE 
0034 70BC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70BE 2026 
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 70C0 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     70C2 A206 
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 70C4 C120  34          mov   @edb.lines,tmp0      ; \
     70C6 A204 
0043 70C8 0284  22          ci    tmp0,1               ; | Only single line?
     70CA 0001 
0044 70CC 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 70CE 0620  34         dec   @parm1                ; Base 0
     70D0 2F20 
0049 70D2 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     70D4 A204 
     70D6 2F22 
0050               
0051 70D8 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     70DA 6C2A 
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 70DC 0620  34         dec   @edb.lines            ; One line less in editor buffer
     70DE A204 
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 70E0 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     70E2 A20C 
     70E4 2022 
0061 70E6 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 70E8 8820  54         c     @parm1,@edb.block.m1  ; \
     70EA 2F20 
     70EC A20C 
0064 70EE 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 70F0 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 70F2 8820  54         c     @edb.block.m1,@w$0001 ; \
     70F4 A20C 
     70F6 2002 
0068 70F8 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 70FA 0620  34         dec   @edb.block.m1         ; M1--
     70FC A20C 
0071 70FE 0720  34         seto  @fb.colorize          ; Set colorize flag
     7100 A110 
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 7102 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     7104 A20E 
     7106 2022 
0077 7108 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 710A 8820  54         c     @parm1,@edb.block.m2  ; \
     710C 2F20 
     710E A20E 
0080 7110 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 7112 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 7114 8820  54         c     @edb.block.m2,@w$0001 ; \
     7116 A20E 
     7118 2002 
0084 711A 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 711C 0620  34         dec   @edb.block.m2         ; M2--
     711E A20E 
0087 7120 0720  34         seto  @fb.colorize          ; Set colorize flag
     7122 A110 
0088 7124 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 7126 04E0  34         clr   @parm1                ; 1st line
     7128 2F20 
0094 712A 04E0  34         clr   @parm2                ; 1st line
     712C 2F22 
0095               
0096 712E 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     7130 6C2A 
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 7132 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 7134 C2F9  30         mov   *stack+,r11           ; Pop r11
0105 7136 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0131                       copy  "edb.block.mark.asm"     ; Mark code block
**** **** ****     > edb.block.mark.asm
0001               * FILE......: edb.block.mark.asm
0002               * Purpose...: Mark line for block operation
0003               
0004               ***************************************************************
0005               * edb.block.mark.m1
0006               * Mark M1 line for block operation
0007               ***************************************************************
0008               *  bl   @edb.block.mark.m1
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * NONE
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * NONE
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * NONE
0018               ********|*****|*********************|**************************
0019               edb.block.mark.m1:
0020 7138 0649  14         dect  stack
0021 713A C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 713C C820  54         mov   @fb.row,@parm1
     713E A106 
     7140 2F20 
0026 7142 06A0  32         bl    @fb.row2line          ; Row to editor line
     7144 6A46 
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 7146 05A0  34         inc   @outparm1             ; Add base 1
     7148 2F30 
0032               
0033 714A C820  54         mov   @outparm1,@edb.block.m1
     714C 2F30 
     714E A20C 
0034                                                   ; Set block marker M1
0035 7150 0720  34         seto  @fb.colorize          ; Set colorize flag
     7152 A110 
0036 7154 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     7156 A116 
0037 7158 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     715A A118 
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 715C C2F9  30         mov   *stack+,r11           ; Pop r11
0043 715E 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               ***************************************************************
0047               * edb.block.mark.m2
0048               * Mark M2 line for block operation
0049               ***************************************************************
0050               *  bl   @edb.block.mark.m2
0051               *--------------------------------------------------------------
0052               * INPUT
0053               * NONE
0054               *--------------------------------------------------------------
0055               * OUTPUT
0056               * NONE
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * NONE
0060               ********|*****|*********************|**************************
0061               edb.block.mark.m2:
0062 7160 0649  14         dect  stack
0063 7162 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 7164 C820  54         mov   @fb.row,@parm1
     7166 A106 
     7168 2F20 
0068 716A 06A0  32         bl    @fb.row2line          ; Row to editor line
     716C 6A46 
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 716E 05A0  34         inc   @outparm1             ; Add base 1
     7170 2F30 
0074               
0075 7172 C820  54         mov   @outparm1,@edb.block.m2
     7174 2F30 
     7176 A20E 
0076                                                   ; Set block marker M2
0077               
0078 7178 0720  34         seto  @fb.colorize          ; Set colorize flag
     717A A110 
0079 717C 0720  34         seto  @fb.dirty             ; Trigger refresh
     717E A116 
0080 7180 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7182 A118 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 7184 C2F9  30         mov   *stack+,r11           ; Pop r11
0086 7186 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               
0090               ***************************************************************
0091               * edb.block.mark
0092               * Mark either M1 or M2 line for block operation
0093               ***************************************************************
0094               *  bl   @edb.block.mark
0095               *--------------------------------------------------------------
0096               * INPUT
0097               * NONE
0098               *--------------------------------------------------------------
0099               * OUTPUT
0100               * NONE
0101               *--------------------------------------------------------------
0102               * Register usage
0103               * tmp0, tmp1
0104               ********|*****|*********************|**************************
0105               edb.block.mark:
0106 7188 0649  14         dect  stack
0107 718A C64B  30         mov   r11,*stack            ; Push return address
0108 718C 0649  14         dect  stack
0109 718E C644  30         mov   tmp0,*stack           ; Push tmp0
0110 7190 0649  14         dect  stack
0111 7192 C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 7194 C820  54         mov   @fb.row,@parm1
     7196 A106 
     7198 2F20 
0116 719A 06A0  32         bl    @fb.row2line          ; Row to editor line
     719C 6A46 
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 719E C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     71A0 2F30 
0122 71A2 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 is set
0125                       ;------------------------------------------------------
0126 71A4 C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     71A6 A20C 
0127 71A8 0584  14         inc   tmp0                  ; /
0128 71AA 1603  14         jne   edb.block.mark.is_line_m1
0129                                                   ; No, skip to update M1
0130                       ;------------------------------------------------------
0131                       ; Set M1 and exit
0132                       ;------------------------------------------------------
0133               _edb.block.mark.m1.set:
0134 71AC 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     71AE 7138 
0135 71B0 1005  14         jmp   edb.block.mark.exit   ; Exit now
0136                       ;------------------------------------------------------
0137                       ; Update M1 if current line < M1
0138                       ;------------------------------------------------------
0139               edb.block.mark.is_line_m1:
0140 71B2 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     71B4 A20C 
0141 71B6 15FA  14         jgt   _edb.block.mark.m1.set
0142                                                   ; Set M1 to current line and exit
0143                       ;------------------------------------------------------
0144                       ; Set M2 and exit
0145                       ;------------------------------------------------------
0146 71B8 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     71BA 7160 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               edb.block.mark.exit:
0151 71BC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 71BE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 71C0 C2F9  30         mov   *stack+,r11           ; Pop r11
0154 71C2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0132                       copy  "edb.block.reset.asm"    ; Reset markers
**** **** ****     > edb.block.reset.asm
0001               ***************************************************************
0002               * edb.block.mark.reset
0003               * Reset block markers M1/M2
0004               ***************************************************************
0005               *  bl   @edb.block.mark.reset
0006               *--------------------------------------------------------------
0007               * INPUT
0008               * NONE
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * NONE
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * NONE
0015               ********|*****|*********************|**************************
0016               edb.block.reset:
0017 71C4 0649  14         dect  stack
0018 71C6 C64B  30         mov   r11,*stack            ; Push return address
0019 71C8 0649  14         dect  stack
0020 71CA C660  46         mov   @wyx,*stack           ; Push cursor position
     71CC 832A 
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 71CE 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     71D0 A20C 
0025 71D2 0720  34         seto  @edb.block.m2         ; /
     71D4 A20E 
0026               
0027 71D6 0720  34         seto  @fb.colorize          ; Set colorize flag
     71D8 A110 
0028 71DA 0720  34         seto  @fb.dirty             ; Trigger refresh
     71DC A116 
0029 71DE 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     71E0 A118 
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 71E2 0720  34         seto  @parm1
     71E4 2F20 
0034 71E6 06A0  32         bl    @pane.action.colorscheme.load
     71E8 765C 
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 71EA C820  54         mov   @tv.color,@parm1      ; Set normal color
     71EC A018 
     71EE 2F20 
0042 71F0 06A0  32         bl    @pane.action.colorscheme.statlines
     71F2 77CE 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 71F4 06A0  32         bl    @hchar
     71F6 27C6 
0048 71F8 0034                   byte 0,52,32,18           ; Remove markers
     71FA 2012 
0049 71FC 1700                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     71FE 2032 
0050 7200 FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 7202 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7204 832A 
0056 7206 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7208 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0133                       copy  "edb.block.copy.asm"     ; Copy code block
**** **** ****     > edb.block.copy.asm
0001               * FILE......: edb.block.copy.asm
0002               * Purpose...: Copy code block
0003               
0004               ***************************************************************
0005               * edb.block.copy
0006               * Copy code block
0007               ***************************************************************
0008               *  bl   @edb.block.copy
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Message flag
0012               *          (>0000 = Display message "Copying block...")
0013               *          (>ffff = Display message "Moving block....")
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = success (>ffff), no action (>0000)
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               *--------------------------------------------------------------
0021               * Remarks
0022               * For simplicity reasons we're assuming base 1 during copy
0023               * (first line starts at 1 instead of 0).
0024               * Makes it easier when comparing values.
0025               ********|*****|*********************|**************************
0026               edb.block.copy:
0027 720A 0649  14         dect  stack
0028 720C C64B  30         mov   r11,*stack            ; Save return address
0029 720E 0649  14         dect  stack
0030 7210 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 7212 0649  14         dect  stack
0032 7214 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 7216 0649  14         dect  stack
0034 7218 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 721A 0649  14         dect  stack
0036 721C C660  46         mov   @parm1,*stack         ; Push parm1
     721E 2F20 
0037 7220 04E0  34         clr   @outparm1             ; No action (>0000)
     7222 2F30 
0038                       ;------------------------------------------------------
0039                       ; Asserts
0040                       ;------------------------------------------------------
0041 7224 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     7226 A20C 
     7228 2022 
0042 722A 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 722C 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     722E A20E 
     7230 2022 
0045 7232 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 7234 8820  54         c     @edb.block.m1,@edb.block.m2
     7236 A20C 
     7238 A20E 
0048                                                   ; M1 > M2 ?
0049 723A 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Get current line position in editor buffer
0052                       ;------------------------------------------------------
0053 723C C820  54         mov   @fb.row,@parm1
     723E A106 
     7240 2F20 
0054 7242 06A0  32         bl    @fb.row2line          ; Row to editor line
     7244 6A46 
0055                                                   ; \ i @fb.topline = Top line in frame buffer
0056                                                   ; | i @parm1      = Row in frame buffer
0057                                                   ; / o @outparm1   = Matching line in EB
0058               
0059 7246 C120  34         mov   @outparm1,tmp0        ; \
     7248 2F30 
0060 724A 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0061 724C C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     724E A210 
0062                       ;------------------------------------------------------
0063                       ; Show error and exit if M1 < current line < M2
0064                       ;------------------------------------------------------
0065 7250 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     7252 2F30 
0066 7254 110D  14         jlt   !                     ; Yes, skip check
0067               
0068 7256 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     7258 2F30 
0069 725A 150A  14         jgt   !                     ; Yes, skip check
0070               
0071 725C 06A0  32         bl    @cpym2m
     725E 24DC 
0072 7260 389E                   data txt.block.inside,tv.error.msg,53
     7262 A02A 
     7264 0035 
0073               
0074 7266 06A0  32         bl    @pane.errline.show    ; Show error line
     7268 7A94 
0075               
0076 726A 04E0  34         clr   @outparm1             ; No action (>0000)
     726C 2F30 
0077 726E 1041  14         jmp   edb.block.copy.exit   ; Exit early
0078                       ;------------------------------------------------------
0079                       ; Display message Copy/Move
0080                       ;------------------------------------------------------
0081 7270 C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     7272 A01C 
     7274 2F20 
0082 7276 06A0  32         bl    @pane.action.colorscheme.statlines
     7278 77CE 
0083                                                   ; Set color combination for status lines
0084                                                   ; \ i  @parm1 = Color combination
0085                                                   ; /
0086               
0087 727A 06A0  32         bl    @hchar
     727C 27C6 
0088 727E 1700                   byte pane.botrow,0,32,50
     7280 2032 
0089 7282 FFFF                   data eol              ; Remove markers and block shortcuts
0090                       ;------------------------------------------------------
0091                       ; Check message to display
0092                       ;------------------------------------------------------
0093 7284 C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0094                                                   ; / @parm1 = >0000 ?
0095 7286 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0096               
0097 7288 06A0  32         bl    @putat
     728A 2444 
0098 728C 1700                   byte pane.botrow,0
0099 728E 34CC                   data txt.block.copy   ; Display "Copying block...."
0100 7290 1004  14         jmp   edb.block.copy.prep
0101               
0102               edb.block.copy.msg2:
0103 7292 06A0  32         bl    @putat
     7294 2444 
0104 7296 1700                   byte pane.botrow,0
0105 7298 34DE                   data txt.block.move   ; Display "Moving block...."
0106                       ;------------------------------------------------------
0107                       ; Prepare for copy
0108                       ;------------------------------------------------------
0109               edb.block.copy.prep:
0110 729A C120  34         mov   @edb.block.m1,tmp0    ; M1
     729C A20C 
0111 729E C1A0  34         mov   @edb.block.m2,tmp2    ; \
     72A0 A20E 
0112 72A2 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0113 72A4 0586  14         inc   tmp2                  ; /
0114               
0115 72A6 C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     72A8 A210 
0116                       ;------------------------------------------------------
0117                       ; Copy code block
0118                       ;------------------------------------------------------
0119               edb.block.copy.loop:
0120 72AA C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     72AC 2F20 
0121 72AE 0620  34         dec   @parm1                ; Base 0 offset for index required
     72B0 2F20 
0122 72B2 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     72B4 A204 
     72B6 2F22 
0123               
0124 72B8 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     72BA 6CC4 
0125                                                   ; \ i  @parm1 = Line for insert
0126                                                   ; / i  @parm2 = Last line to reorg
0127                       ;------------------------------------------------------
0128                       ; Increase M1-M2 block if target line before M1
0129                       ;------------------------------------------------------
0130 72BC 8805  38         c     tmp1,@edb.block.m1
     72BE A20C 
0131 72C0 1506  14         jgt   edb.block.copy.loop.docopy
0132 72C2 1305  14         jeq   edb.block.copy.loop.docopy
0133               
0134 72C4 05A0  34         inc   @edb.block.m1         ; M1++
     72C6 A20C 
0135 72C8 05A0  34         inc   @edb.block.m2         ; M2++
     72CA A20E 
0136 72CC 0584  14         inc   tmp0                  ; Increase source line number too!
0137                       ;------------------------------------------------------
0138                       ; Copy line
0139                       ;------------------------------------------------------
0140               edb.block.copy.loop.docopy:
0141 72CE C804  38         mov   tmp0,@parm1           ; Source line for copy
     72D0 2F20 
0142 72D2 C805  38         mov   tmp1,@parm2           ; Target line for copy
     72D4 2F22 
0143               
0144 72D6 06A0  32         bl    @edb.line.copy        ; Copy line
     72D8 6FC6 
0145                                                   ; \ i  @parm1 = Source line in editor buffer
0146                                                   ; / i  @parm2 = Target line in editor buffer
0147                       ;------------------------------------------------------
0148                       ; Housekeeping for next copy
0149                       ;------------------------------------------------------
0150 72DA 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     72DC A204 
0151 72DE 0584  14         inc   tmp0                  ; Next source line
0152 72E0 0585  14         inc   tmp1                  ; Next target line
0153 72E2 0606  14         dec   tmp2                  ; Update ĺoop counter
0154 72E4 15E2  14         jgt   edb.block.copy.loop   ; Next line
0155                       ;------------------------------------------------------
0156                       ; Copy loop completed
0157                       ;------------------------------------------------------
0158 72E6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     72E8 A206 
0159 72EA 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     72EC A116 
0160 72EE 0720  34         seto  @outparm1             ; Copy completed
     72F0 2F30 
0161                       ;------------------------------------------------------
0162                       ; Exit
0163                       ;------------------------------------------------------
0164               edb.block.copy.exit:
0165 72F2 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     72F4 2F20 
0166 72F6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0167 72F8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0168 72FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0169 72FC C2F9  30         mov   *stack+,r11           ; Pop R11
0170 72FE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0134                       copy  "edb.block.del.asm"      ; Delete code block
**** **** ****     > edb.block.del.asm
0001               * FILE......: edb.block.del.asm
0002               * Purpose...: Delete code block
0003               
0004               ***************************************************************
0005               * edb.block.delete
0006               * Delete code block
0007               ***************************************************************
0008               *  bl   @edb.block.delete
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Message flag
0012               *          (>0000 = Display message "Deleting block")
0013               *          (>ffff = Skip message display)
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = success (>ffff), no action (>0000)
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               *--------------------------------------------------------------
0021               * Remarks
0022               * For simplicity reasons we're assuming base 1 during copy
0023               * (first line starts at 1 instead of 0).
0024               * Makes it easier when comparing values.
0025               ********|*****|*********************|**************************
0026               edb.block.delete:
0027 7300 0649  14         dect  stack
0028 7302 C64B  30         mov   r11,*stack            ; Save return address
0029 7304 0649  14         dect  stack
0030 7306 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 7308 0649  14         dect  stack
0032 730A C645  30         mov   tmp1,*stack           ; Push tmp1
0033 730C 0649  14         dect  stack
0034 730E C646  30         mov   tmp2,*stack           ; Push tmp2
0035               
0036 7310 04E0  34         clr   @outparm1             ; No action (>0000)
     7312 2F30 
0037                       ;------------------------------------------------------
0038                       ; Asserts
0039                       ;------------------------------------------------------
0040 7314 C120  34         mov   @edb.block.m1,tmp0    ; \
     7316 A20C 
0041 7318 0584  14         inc   tmp0                  ; | M1 unset?
0042 731A 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043               
0044 731C C160  34         mov   @edb.block.m2,tmp1    ; \
     731E A20E 
0045 7320 0584  14         inc   tmp0                  ; | M2 unset?
0046 7322 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0047                       ;------------------------------------------------------
0048                       ; Check message to display
0049                       ;------------------------------------------------------
0050 7324 C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     7326 2F20 
0051 7328 160E  14         jne   edb.block.delete.prep ; No, skip message display
0052                       ;------------------------------------------------------
0053                       ; Display "Deleting...."
0054                       ;------------------------------------------------------
0055 732A C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     732C A01C 
     732E 2F20 
0056               
0057 7330 06A0  32         bl    @pane.action.colorscheme.statlines
     7332 77CE 
0058                                                   ; Set color combination for status lines
0059                                                   ; \ i  @parm1 = Color combination
0060                                                   ; /
0061               
0062 7334 06A0  32         bl    @hchar
     7336 27C6 
0063 7338 1700                   byte pane.botrow,0,32,50
     733A 2032 
0064 733C FFFF                   data eol              ; Remove markers and block shortcuts
0065               
0066 733E 06A0  32         bl    @putat
     7340 2444 
0067 7342 1700                   byte pane.botrow,0
0068 7344 34B8                   data txt.block.del    ; Display "Deleting block...."
0069                       ;------------------------------------------------------
0070                       ; Prepare for delete
0071                       ;------------------------------------------------------
0072               edb.block.delete.prep:
0073 7346 C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     7348 A20C 
0074 734A 0604  14         dec   tmp0                  ; Base 0
0075               
0076 734C C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     734E A20E 
0077 7350 0605  14         dec   tmp1                  ; Base 0
0078               
0079 7352 C804  38         mov   tmp0,@parm1           ; Delete line on M1
     7354 2F20 
0080 7356 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7358 A204 
     735A 2F22 
0081 735C 0620  34         dec   @parm2                ; Base 0
     735E 2F22 
0082               
0083 7360 C185  18         mov   tmp1,tmp2             ; \
0084 7362 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0085 7364 0586  14         inc   tmp2                  ; /
0086                       ;------------------------------------------------------
0087                       ; Delete block
0088                       ;------------------------------------------------------
0089               edb.block.delete.loop:
0090 7366 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7368 6C2A 
0091                                                   ; \ i  @parm1 = Line in editor buffer
0092                                                   ; / i  @parm2 = Last line for index reorg
0093               
0094 736A 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     736C A204 
0095 736E 0620  34         dec   @parm2                ; /
     7370 2F22 
0096               
0097 7372 0606  14         dec   tmp2
0098 7374 15F8  14         jgt   edb.block.delete.loop ; Next line
0099 7376 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7378 A206 
0100                       ;------------------------------------------------------
0101                       ; Set topline for framebuffer refresh
0102                       ;------------------------------------------------------
0103 737A 8820  54         c     @fb.topline,@edb.lines
     737C A104 
     737E A204 
0104                                                   ; Beyond editor buffer?
0105 7380 1504  14         jgt   !                     ; Yes, goto line 1
0106               
0107 7382 C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     7384 A104 
     7386 2F20 
0108 7388 1002  14         jmp   edb.block.delete.fb.refresh
0109 738A 04E0  34 !       clr   @parm1                ; Set line to start with
     738C 2F20 
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer and reset block markers
0112                       ;------------------------------------------------------
0113               edb.block.delete.fb.refresh:
0114 738E 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     7390 6AD0 
0115                                                   ; | i  @parm1 = Line to start with
0116                                                   ; /             (becomes @fb.topline)
0117               
0118 7392 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     7394 71C4 
0119               
0120 7396 0720  34         seto  @outparm1             ; Delete completed
     7398 2F30 
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               edb.block.delete.exit:
0125 739A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 739C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 739E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 73A0 C2F9  30         mov   *stack+,r11           ; Pop R11
**** **** ****     > stevie_b1.asm.393026
0135                       ;-----------------------------------------------------------------------
0136                       ; Command buffer handling
0137                       ;-----------------------------------------------------------------------
0138                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
**** **** ****     > cmdb.refresh.asm
0001               * FILE......: cmdb.refresh.asm
0002               * Purpose...: Stevie Editor - Command buffer
0003               
0004               ***************************************************************
0005               * cmdb.refresh
0006               * Refresh command buffer content
0007               ***************************************************************
0008               * bl @cmdb.refresh
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
0021               cmdb.refresh:
0022 73A2 0649  14         dect  stack
0023 73A4 C64B  30         mov   r11,*stack            ; Save return address
0024 73A6 0649  14         dect  stack
0025 73A8 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 73AA 0649  14         dect  stack
0027 73AC C645  30         mov   tmp1,*stack           ; Push tmp1
0028 73AE 0649  14         dect  stack
0029 73B0 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 73B2 0649  14         dect  stack
0031 73B4 C660  46         mov   @wyx,*stack           ; Push cursor position
     73B6 832A 
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 73B8 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     73BA A310 
     73BC 832A 
0036               
0037 73BE 05A0  34         inc   @wyx                  ; X +1 for prompt
     73C0 832A 
0038               
0039 73C2 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     73C4 23FC 
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 73C6 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     73C8 A327 
0044 73CA 0206  20         li    tmp2,1*79             ; Command length
     73CC 004F 
0045               
0046 73CE 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     73D0 248E 
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 73D2 C820  54         mov   @cmdb.yxprompt,@wyx
     73D4 A310 
     73D6 832A 
0054 73D8 06A0  32         bl    @putstr
     73DA 2420 
0055 73DC 38D4                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 73DE C839  50         mov   *stack+,@wyx          ; Pop cursor position
     73E0 832A 
0061 73E2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 73E4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 73E6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 73E8 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 73EA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0139                       copy  "cmdb.cmd.asm"        ; Command line handling
**** **** ****     > cmdb.cmd.asm
0001               * FILE......: cmdb.cmd.asm
0002               * Purpose...: Stevie Editor - Command line
0003               
0004               ***************************************************************
0005               * cmdb.cmd.clear
0006               * Clear current command
0007               ***************************************************************
0008               * bl @cmdb.cmd.clear
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               cmdb.cmd.clear:
0022 73EC 0649  14         dect  stack
0023 73EE C64B  30         mov   r11,*stack            ; Save return address
0024 73F0 0649  14         dect  stack
0025 73F2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 73F4 0649  14         dect  stack
0027 73F6 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 73F8 0649  14         dect  stack
0029 73FA C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 73FC 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     73FE A326 
0034 7400 06A0  32         bl    @film                 ; Clear command
     7402 2238 
0035 7404 A327                   data  cmdb.cmd,>00,80
     7406 0000 
     7408 0050 
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 740A C120  34         mov   @cmdb.yxprompt,tmp0
     740C A310 
0040 740E 0584  14         inc   tmp0
0041 7410 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     7412 A30A 
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 7414 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 7416 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 7418 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 741A C2F9  30         mov   *stack+,r11           ; Pop r11
0050 741C 045B  20         b     *r11                  ; Return to caller
0051               
0052               
0053               
0054               
0055               
0056               
0057               ***************************************************************
0058               * cmdb.cmdb.getlength
0059               * Get length of current command
0060               ***************************************************************
0061               * bl @cmdb.cmd.getlength
0062               *--------------------------------------------------------------
0063               * INPUT
0064               * @cmdb.cmd
0065               *--------------------------------------------------------------
0066               * OUTPUT
0067               * @outparm1
0068               *--------------------------------------------------------------
0069               * Register usage
0070               * none
0071               *--------------------------------------------------------------
0072               * Notes
0073               ********|*****|*********************|**************************
0074               cmdb.cmd.getlength:
0075 741E 0649  14         dect  stack
0076 7420 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 7422 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     7424 2ACC 
0081 7426 A327                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     7428 0000 
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 742A C820  54         mov   @waux1,@outparm1     ; Save length of string
     742C 833C 
     742E 2F30 
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 7430 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 7432 045B  20         b     *r11                  ; Return to caller
0091               
0092               
0093               
0094               
0095               
0096               ***************************************************************
0097               * cmdb.cmd.addhist
0098               * Add command to history
0099               ***************************************************************
0100               * bl @cmdb.cmd.addhist
0101               *--------------------------------------------------------------
0102               * INPUT
0103               *
0104               * @cmdb.cmd
0105               *--------------------------------------------------------------
0106               * OUTPUT
0107               * @outparm1     (Length in LSB)
0108               *--------------------------------------------------------------
0109               * Register usage
0110               * tmp0
0111               *--------------------------------------------------------------
0112               * Notes
0113               ********|*****|*********************|**************************
0114               cmdb.cmd.history.add:
0115 7434 0649  14         dect  stack
0116 7436 C64B  30         mov   r11,*stack            ; Save return address
0117 7438 0649  14         dect  stack
0118 743A C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 743C 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     743E 741E 
0121                                                   ; \ i  @cmdb.cmd
0122                                                   ; / o  @outparm1
0123                       ;------------------------------------------------------
0124                       ; Assert
0125                       ;------------------------------------------------------
0126 7440 C120  34         mov   @outparm1,tmp0        ; Check length
     7442 2F30 
0127 7444 1300  14         jeq   cmdb.cmd.history.add.exit
0128                                                   ; Exit early if length = 0
0129                       ;------------------------------------------------------
0130                       ; Add command to history
0131                       ;------------------------------------------------------
0132               
0133               
0134               
0135                       ;------------------------------------------------------
0136                       ; Exit
0137                       ;------------------------------------------------------
0138               cmdb.cmd.history.add.exit:
0139 7446 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0140 7448 C2F9  30         mov   *stack+,r11           ; Pop r11
0141 744A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0140                       ;-----------------------------------------------------------------------
0141                       ; User hook, background tasks
0142                       ;-----------------------------------------------------------------------
0143                       copy  "hook.keyscan.asm"           ; spectra2 user hook: keyboard scan
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 744C 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     744E 200A 
0009 7450 1612  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 7452 C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     7454 833C 
     7456 2F40 
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 7458 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     745A 200A 
0016 745C 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     745E 2F40 
     7460 2F42 
0017 7462 130D  14         jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
0018               *--------------------------------------------------------------
0019               * New key pressed
0020               *--------------------------------------------------------------
0021 7464 0204  20         li    tmp0,250              ; \
     7466 00FA 
0022 7468 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0023 746A 16FE  14         jne   -!                    ; /
0024 746C C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     746E 2F40 
     7470 2F42 
0025 7472 0460  28         b     @edkey.key.process    ; Process key
     7474 60CA 
0026               *--------------------------------------------------------------
0027               * Clear keyboard buffer if no key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.clear_kbbuffer:
0030 7476 04E0  34         clr   @keycode1
     7478 2F40 
0031 747A 04E0  34         clr   @keycode2
     747C 2F42 
0032               *--------------------------------------------------------------
0033               * Delay to avoid key bouncing
0034               *--------------------------------------------------------------
0035               hook.keyscan.bounce:
0036 747E 0204  20         li    tmp0,2000             ; Avoid key bouncing
     7480 07D0 
0037                       ;------------------------------------------------------
0038                       ; Delay loop
0039                       ;------------------------------------------------------
0040               hook.keyscan.bounce.loop:
0041 7482 0604  14         dec   tmp0
0042 7484 16FE  14         jne   hook.keyscan.bounce.loop
0043 7486 0460  28         b     @hookok               ; Return
     7488 2D4C 
0044               
**** **** ****     > stevie_b1.asm.393026
0144                       copy  "task.vdp.panes.asm"         ; Draw editor panes in VDP
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 748A 0649  14         dect  stack
0009 748C C64B  30         mov   r11,*stack            ; Save return address
0010 748E 0649  14         dect  stack
0011 7490 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7492 0649  14         dect  stack
0013 7494 C660  46         mov   @wyx,*stack           ; Push cursor position
     7496 832A 
0014                       ;------------------------------------------------------
0015                       ; ALPHA-Lock key down?
0016                       ;------------------------------------------------------
0017               task.vdp.panes.alpha_lock:
0018 7498 20A0  38         coc   @wbit10,config
     749A 200C 
0019 749C 1305  14         jeq   task.vdp.panes.alpha_lock.down
0020                       ;------------------------------------------------------
0021                       ; AlPHA-Lock is up
0022                       ;------------------------------------------------------
0023 749E 06A0  32         bl    @putat
     74A0 2444 
0024 74A2 174E                   byte pane.botrow,78
0025 74A4 35E0                   data txt.ws4
0026 74A6 1004  14         jmp   task.vdp.panes.cmdb.check
0027                       ;------------------------------------------------------
0028                       ; AlPHA-Lock is down
0029                       ;------------------------------------------------------
0030               task.vdp.panes.alpha_lock.down:
0031 74A8 06A0  32         bl    @putat
     74AA 2444 
0032 74AC 174E                   byte pane.botrow,78
0033 74AE 35D0                   data txt.alpha.down
0034                       ;------------------------------------------------------
0035                       ; Command buffer visible ?
0036                       ;------------------------------------------------------
0037               task.vdp.panes.cmdb.check
0038 74B0 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     74B2 A302 
0039 74B4 1308  14         jeq   !                     ; No, skip CMDB pane
0040                       ;-------------------------------------------------------
0041                       ; Draw command buffer pane if dirty
0042                       ;-------------------------------------------------------
0043               task.vdp.panes.cmdb.draw:
0044 74B6 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     74B8 A318 
0045 74BA 1327  14         jeq   task.vdp.panes.exit   ; No, skip update
0046               
0047 74BC 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     74BE 790A 
0048 74C0 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     74C2 A318 
0049 74C4 1022  14         jmp   task.vdp.panes.exit   ; Exit early
0050                       ;-------------------------------------------------------
0051                       ; Check if frame buffer dirty
0052                       ;-------------------------------------------------------
0053 74C6 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     74C8 A116 
0054 74CA 130E  14         jeq   task.vdp.panes.statlines
0055                                                   ; No, skip update
0056 74CC C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     74CE A11A 
     74D0 2F20 
0057               
0058               task.vdp.panes.dump:
0059 74D2 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     74D4 7D72 
0060                                                   ; \ i  @parm1 = number of lines to dump
0061                                                   ; /
0062                       ;------------------------------------------------------
0063                       ; Color the lines in the framebuffer (TAT)
0064                       ;------------------------------------------------------
0065 74D6 C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     74D8 A110 
0066 74DA 1302  14         jeq   task.vdp.panes.dumped ; Skip if flag reset
0067               
0068 74DC 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     74DE 7D60 
0069                       ;-------------------------------------------------------
0070                       ; Finished with frame buffer
0071                       ;-------------------------------------------------------
0072               task.vdp.panes.dumped:
0073 74E0 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     74E2 A116 
0074 74E4 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     74E6 A118 
0075                       ;-------------------------------------------------------
0076                       ; Refresh top and bottom line
0077                       ;-------------------------------------------------------
0078               task.vdp.panes.statlines:
0079 74E8 C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     74EA A118 
0080 74EC 130E  14         jeq   task.vdp.panes.exit   ; No, skip update
0081               
0082 74EE 06A0  32         bl    @pane.topline         ; Draw top line
     74F0 79F0 
0083 74F2 06A0  32         bl    @pane.botline         ; Draw bottom line
     74F4 7B2E 
0084 74F6 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     74F8 A118 
0085                       ;------------------------------------------------------
0086                       ; Show ruler with tab positions
0087                       ;------------------------------------------------------
0088 74FA C120  34         mov   @tv.ruler.visible,tmp0
     74FC A010 
0089                                                   ; Should ruler be visible?
0090 74FE 1305  14         jeq   task.vdp.panes.exit   ; No, so exit
0091               
0092 7500 06A0  32         bl    @cpym2v
     7502 2488 
0093 7504 0050                   data vdp.fb.toprow.sit
0094 7506 A11E                   data fb.ruler.sit
0095 7508 0050                   data 80               ; Show ruler
0096                       ;------------------------------------------------------
0097                       ; Exit task
0098                       ;------------------------------------------------------
0099               task.vdp.panes.exit:
0100 750A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     750C 832A 
0101 750E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 7510 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7512 0460  28         b     @slotok
     7514 2DC8 
**** **** ****     > stevie_b1.asm.393026
0145               
0152               
0153                       copy  "task.vdp.cursor.9938.asm"   ; Set cursor shape in VDP (blink)
**** **** ****     > task.vdp.cursor.9938.asm
0001               * FILE......: task.vdp.cursor.9938.asm
0002               * Purpose...: VDP cursor shape (9938 version)
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 7516 0649  14         dect  stack
0009 7518 C64B  30         mov   r11,*stack            ; Save return address
0010 751A 0649  14         dect  stack
0011 751C C644  30         mov   tmp0,*stack           ; Push tmp0
0012 751E 0649  14         dect  stack
0013 7520 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 7522 0649  14         dect  stack
0015 7524 C660  46         mov   @wyx,*stack           ; Push cursor position
     7526 832A 
0016               
0017 7528 C120  34         mov   @wyx,tmp0
     752A 832A 
0018 752C 0224  22         ai    tmp0,>0100
     752E 0100 
0019 7530 C804  38         mov   tmp0,@wyx
     7532 832A 
0020                       ;------------------------------------------------------
0021                       ; Toggle cursor
0022                       ;------------------------------------------------------
0023 7534 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     7536 A112 
0024 7538 130A  14         jeq   task.vdp.cursor.visible
0025                       ;------------------------------------------------------
0026                       ; Hide cursor (show character behind cursor)
0027                       ;------------------------------------------------------
0028 753A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     753C 6A60 
0029                                                   ; \ i  @fb.top      = Address top row in fb
0030                                                   ; | i  @fb.topline  = Top line in fb
0031                                                   ; | i  @fb.row      = Current row in fb
0032                                                   ; | i  @fb.column   = Current column in fb
0033                                                   ; | i  @fb.colsline = Columns per line in fb
0034                                                   ; / o  @fb.current  = Updated pointer
0035               
0036 753E C160  34         mov   @fb.current,tmp1      ; \
     7540 A102 
0037 7542 D155  26         movb  *tmp1,tmp1            ; | Get character in Frame Buffer
0038 7544 0985  56         srl   tmp1,8                ; /
0039               
0040 7546 0720  34         seto  @fb.dirty
     7548 A116 
0041 754A 1007  14         jmp   task.vdp.cursor.exit
0042               
0043 754C 1002  14         jmp   task.vdp.cursor.dump  ; Dump to vdp
0044                       ;------------------------------------------------------
0045                       ; Show cursor
0046                       ;------------------------------------------------------
0047               task.vdp.cursor.visible:
0048 754E 0205  20         li    tmp1,26               ; Cursor
     7550 001A 
0049                       ;------------------------------------------------------
0050                       ; Dump byte to VDP
0051                       ;------------------------------------------------------
0052               task.vdp.cursor.dump:
0053 7552 06A0  32         bl    @yx2pnt               ; Calculate VDP address from @WYX
     7554 23FC 
0054                                                   ; \ i  @wyx = Cursor position
0055                                                   ; / o  tmp0 = VDP write address
0056               
0057 7556 06A0  32         bl    @xvputb               ; VDP put single byte
     7558 22CE 
0058                                                   ; \ i  tmp0 = VDP write address
0059                                                   ; / i  tmp1 = Byte to write
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063               task.vdp.cursor.exit:
0064 755A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     755C 832A 
0065 755E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 7560 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 7562 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 7564 0460  28         b     @slotok               ; Exit task
     7566 2DC8 
**** **** ****     > stevie_b1.asm.393026
0154               
0156               
0157                       copy  "task.oneshot.asm"           ; Run "one shot" task
**** **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 7568 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     756A A024 
0010 756C 1301  14         jeq   task.oneshot.exit
0011               
0012 756E 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 7570 0460  28         b     @slotok                ; Exit task
     7572 2DC8 
**** **** ****     > stevie_b1.asm.393026
0158                       ;-----------------------------------------------------------------------
0159                       ; Screen pane utilities
0160                       ;-----------------------------------------------------------------------
0161                       copy  "pane.utils.asm"             ; Pane utility functions
**** **** ****     > pane.utils.asm
0001               * FILE......: pane.utils.asm
0002               * Purpose...: Some utility functions. Shared code for all panes
0003               
0004               ***************************************************************
0005               * pane.clearmsg.task.callback
0006               * Remove message
0007               ***************************************************************
0008               * Called from one-shot task
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ********|*****|*********************|**************************
0019               pane.clearmsg.task.callback:
0020 7574 0649  14         dect  stack
0021 7576 C64B  30         mov   r11,*stack            ; Push return address
0022 7578 0649  14         dect  stack
0023 757A C660  46         mov   @wyx,*stack           ; Push cursor position
     757C 832A 
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 757E 06A0  32         bl    @hchar
     7580 27C6 
0028 7582 0034                   byte 0,52,32,18
     7584 2012 
0029 7586 FFFF                   data EOL              ; Clear message
0030               
0031 7588 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     758A A024 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 758C C839  50         mov   *stack+,@wyx          ; Pop cursor position
     758E 832A 
0037 7590 C2F9  30         mov   *stack+,r11           ; Pop R11
0038 7592 045B  20         b     *r11                  ; Return to task
**** **** ****     > stevie_b1.asm.393026
0162                       copy  "pane.utils.hint.asm"        ; Show hint in pane
**** **** ****     > pane.utils.hint.asm
0001               * FILE......: pane.utils.asm
0002               * Purpose...: Show hint message in pane
0003               
0004               ***************************************************************
0005               * pane.show_hintx
0006               * Show hint message
0007               ***************************************************************
0008               * bl  @pane.show_hintx
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Cursor YX position
0012               * @parm2 = Pointer to Length-prefixed string
0013               *--------------------------------------------------------------
0014               * OUTPUT test
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1, tmp2
0019               ********|*****|*********************|**************************
0020               pane.show_hintx:
0021 7594 0649  14         dect  stack
0022 7596 C64B  30         mov   r11,*stack            ; Save return address
0023 7598 0649  14         dect  stack
0024 759A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 759C 0649  14         dect  stack
0026 759E C645  30         mov   tmp1,*stack           ; Push tmp1
0027 75A0 0649  14         dect  stack
0028 75A2 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 75A4 0649  14         dect  stack
0030 75A6 C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 75A8 C820  54         mov   @parm1,@wyx           ; Set cursor
     75AA 2F20 
     75AC 832A 
0035 75AE C160  34         mov   @parm2,tmp1           ; Get string to display
     75B0 2F22 
0036 75B2 06A0  32         bl    @xutst0               ; Display string
     75B4 2422 
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 75B6 C120  34         mov   @parm2,tmp0
     75B8 2F22 
0041 75BA D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 75BC 0984  56         srl   tmp0,8                ; Right justify
0043 75BE C184  18         mov   tmp0,tmp2
0044 75C0 C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 75C2 0506  16         neg   tmp2
0046 75C4 0226  22         ai    tmp2,80               ; Number of bytes to fill
     75C6 0050 
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 75C8 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     75CA 2F20 
0051 75CC A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 75CE C804  38         mov   tmp0,@wyx             ; / Set cursor
     75D0 832A 
0053               
0054 75D2 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     75D4 23FC 
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 75D6 0205  20         li    tmp1,32               ; Byte to fill
     75D8 0020 
0059               
0060 75DA 06A0  32         bl    @xfilv                ; Clear line
     75DC 2296 
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 75DE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 75E0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 75E2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 75E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 75E6 C2F9  30         mov   *stack+,r11           ; Pop R11
0073 75E8 045B  20         b     *r11                  ; Return to caller
0074               
0075               
0076               
0077               ***************************************************************
0078               * pane.show_hint
0079               * Show hint message (data parameter version)
0080               ***************************************************************
0081               * bl  @pane.show_hint
0082               *     data p1,p2
0083               *--------------------------------------------------------------
0084               * INPUT
0085               * p1 = Cursor YX position
0086               * p2 = Pointer to Length-prefixed string
0087               *--------------------------------------------------------------
0088               * OUTPUT
0089               * none
0090               *--------------------------------------------------------------
0091               * Register usage
0092               * none
0093               ********|*****|*********************|**************************
0094               pane.show_hint:
0095 75EA C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     75EC 2F20 
0096 75EE C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     75F0 2F22 
0097 75F2 0649  14         dect  stack
0098 75F4 C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 75F6 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     75F8 7594 
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 75FA C2F9  30         mov   *stack+,r11           ; Pop R11
0108 75FC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0163                       copy  "pane.utils.colorscheme.asm" ; Colorscheme handling in panes
**** **** ****     > pane.utils.colorscheme.asm
0001               * FILE......: pane.utils.colorscheme.asm
0002               * Purpose...: Stevie Editor - Color scheme for panes
0003               
0004               ***************************************************************
0005               * pane.action.colorschene.cycle
0006               * Cycle through available color scheme
0007               ***************************************************************
0008               * bl  @pane.action.colorscheme.cycle
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.action.colorscheme.cycle:
0017 75FE 0649  14         dect  stack
0018 7600 C64B  30         mov   r11,*stack            ; Push return address
0019 7602 0649  14         dect  stack
0020 7604 C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 7606 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7608 A012 
0023 760A 0284  22         ci    tmp0,tv.colorscheme.entries
     760C 000A 
0024                                                   ; Last entry reached?
0025 760E 1103  14         jlt   !
0026 7610 0204  20         li    tmp0,1                ; Reset color scheme index
     7612 0001 
0027 7614 1001  14         jmp   pane.action.colorscheme.switch
0028 7616 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 7618 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     761A A012 
0034               
0035 761C 06A0  32         bl    @pane.action.colorscheme.load
     761E 765C 
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 7620 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     7622 832A 
     7624 833C 
0041               
0042 7626 06A0  32         bl    @putnum
     7628 2A56 
0043 762A 003E                   byte 0,62
0044 762C A012                   data tv.colorscheme,rambuf,>3020
     762E 2F6A 
     7630 3020 
0045               
0046 7632 06A0  32         bl    @putat
     7634 2444 
0047 7636 0034                   byte 0,52
0048 7638 38D6                   data txt.colorscheme  ; Show color palette message
0049               
0050 763A C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     763C 833C 
     763E 832A 
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 7640 0204  20         li    tmp0,12000
     7642 2EE0 
0055 7644 0604  14 !       dec   tmp0
0056 7646 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 7648 0204  20         li    tmp0,pane.clearmsg.task.callback
     764A 7574 
0061 764C C804  38         mov   tmp0,@tv.task.oneshot
     764E A024 
0062               
0063 7650 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     7652 2E32 
0064 7654 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 7656 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 7658 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 765A 045B  20         b     *r11                  ; Return to caller
0072               
0073               
0074               
0075               ***************************************************************
0076               * pane.action.colorscheme.load
0077               * Load color scheme
0078               ***************************************************************
0079               * bl  @pane.action.colorscheme.load
0080               *--------------------------------------------------------------
0081               * INPUT
0082               * @tv.colorscheme = Index into color scheme table
0083               * @parm1          = Skip screen off if >FFFF
0084               * @parm2          = Skip colorizing marked lines if >FFFF
0085               *--------------------------------------------------------------
0086               * OUTPUT
0087               * none
0088               *--------------------------------------------------------------
0089               * Register usage
0090               * tmp0,tmp1,tmp2,tmp3,tmp4
0091               ********|*****|*********************|**************************
0092               pane.action.colorscheme.load:
0093 765C 0649  14         dect  stack
0094 765E C64B  30         mov   r11,*stack            ; Save return address
0095 7660 0649  14         dect  stack
0096 7662 C644  30         mov   tmp0,*stack           ; Push tmp0
0097 7664 0649  14         dect  stack
0098 7666 C645  30         mov   tmp1,*stack           ; Push tmp1
0099 7668 0649  14         dect  stack
0100 766A C646  30         mov   tmp2,*stack           ; Push tmp2
0101 766C 0649  14         dect  stack
0102 766E C647  30         mov   tmp3,*stack           ; Push tmp3
0103 7670 0649  14         dect  stack
0104 7672 C648  30         mov   tmp4,*stack           ; Push tmp4
0105 7674 0649  14         dect  stack
0106 7676 C660  46         mov   @parm1,*stack         ; Push parm1
     7678 2F20 
0107                       ;-------------------------------------------------------
0108                       ; Turn screen of
0109                       ;-------------------------------------------------------
0110 767A C120  34         mov   @parm1,tmp0
     767C 2F20 
0111 767E 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     7680 FFFF 
0112 7682 1302  14         jeq   !                     ; Yes, so skip screen off
0113 7684 06A0  32         bl    @scroff               ; Turn screen off
     7686 2690 
0114                       ;-------------------------------------------------------
0115                       ; Get FG/BG colors framebuffer text
0116                       ;-------------------------------------------------------
0117 7688 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     768A A012 
0118 768C 0604  14         dec   tmp0                  ; Internally work with base 0
0119               
0120 768E 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0121 7690 0224  22         ai    tmp0,tv.colorscheme.table
     7692 33D2 
0122                                                   ; Add base for color scheme data table
0123 7694 C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0124 7696 C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     7698 A018 
0125                       ;-------------------------------------------------------
0126                       ; Get and save cursor color
0127                       ;-------------------------------------------------------
0128 769A C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0129 769C 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     769E 00FF 
0130 76A0 C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     76A2 A016 
0131                       ;-------------------------------------------------------
0132                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0133                       ;-------------------------------------------------------
0134 76A4 C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0135 76A6 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     76A8 FF00 
0136 76AA 0988  56         srl   tmp4,8                ; MSB to LSB
0137               
0138 76AC C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0139 76AE C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0140 76B0 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0141 76B2 C806  38         mov   tmp2,@tv.busycolor    ; /
     76B4 A01C 
0142               
0143 76B6 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     76B8 00FF 
0144 76BA C805  38         mov   tmp1,@tv.markcolor    ; /
     76BC A01A 
0145               
0146 76BE C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0147 76C0 0985  56         srl   tmp1,8                ; \ Right align MN and
0148 76C2 C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     76C4 A020 
0149                       ;-------------------------------------------------------
0150                       ; Get FG color for ruler
0151                       ;-------------------------------------------------------
0152 76C6 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0153 76C8 0245  22         andi  tmp1,>000f            ; Only keep P
     76CA 000F 
0154 76CC 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0155 76CE C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     76D0 A01E 
0156                       ;-------------------------------------------------------
0157                       ; Write sprite color of line and column indicators to SAT
0158                       ;-------------------------------------------------------
0159 76D2 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0160 76D4 0245  22         andi  tmp1,>00f0            ; Only keep O
     76D6 00F0 
0161 76D8 0A45  56         sla   tmp1,4                ; Move O to MSB
0162 76DA D805  38         movb  tmp1,@ramsat+7        ; Line indicator FG color to SAT
     76DC 2F61 
0163 76DE D805  38         movb  tmp1,@ramsat+11       ; Column indicator FG color to SAT
     76E0 2F65 
0164                       ;-------------------------------------------------------
0165                       ; Dump colors to VDP register 7 (text mode)
0166                       ;-------------------------------------------------------
0167 76E2 C147  18         mov   tmp3,tmp1             ; Get work copy
0168 76E4 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0169 76E6 0265  22         ori   tmp1,>0700
     76E8 0700 
0170 76EA C105  18         mov   tmp1,tmp0
0171 76EC 06A0  32         bl    @putvrx               ; Write VDP register
     76EE 2336 
0172                       ;-------------------------------------------------------
0173                       ; Dump colors for frame buffer pane (TAT)
0174                       ;-------------------------------------------------------
0175 76F0 C120  34         mov   @tv.ruler.visible,tmp0
     76F2 A010 
0176 76F4 1305  14         jeq   pane.action.colorscheme.fbdump.noruler
0177 76F6 0204  20         li    tmp0,vdp.fb.toprow.tat+80
     76F8 18A0 
0178                                                   ; VDP start address (frame buffer area)
0179 76FA 0206  20         li    tmp2,(pane.botrow-2)*80
     76FC 0690 
0180                                                   ; Number of bytes to fill
0181 76FE 1004  14         jmp   pane.action.colorscheme.fbdump
0182               pane.action.colorscheme.fbdump.noruler:
0183 7700 0204  20         li    tmp0,vdp.fb.toprow.tat
     7702 1850 
0184                                                   ; VDP start address (frame buffer area)
0185 7704 0206  20         li    tmp2,(pane.botrow-1)*80
     7706 06E0 
0186                                                   ; Number of bytes to fill
0187               pane.action.colorscheme.fbdump:
0188 7708 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0189 770A 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0190               
0191 770C 06A0  32         bl    @xfilv                ; Fill colors
     770E 2296 
0192                                                   ; i \  tmp0 = start address
0193                                                   ; i |  tmp1 = byte to fill
0194                                                   ; i /  tmp2 = number of bytes to fill
0195                       ;-------------------------------------------------------
0196                       ; Colorize marked lines
0197                       ;-------------------------------------------------------
0198 7710 C120  34         mov   @parm2,tmp0
     7712 2F22 
0199 7714 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     7716 FFFF 
0200 7718 1304  14         jeq   pane.action.colorscheme.cmdbpane
0201               
0202 771A 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     771C A110 
0203 771E 06A0  32         bl    @fb.colorlines
     7720 7D60 
0204                       ;-------------------------------------------------------
0205                       ; Dump colors for CMDB pane (TAT)
0206                       ;-------------------------------------------------------
0207               pane.action.colorscheme.cmdbpane:
0208 7722 C120  34         mov   @cmdb.visible,tmp0
     7724 A302 
0209 7726 130F  14         jeq   pane.action.colorscheme.errpane
0210                                                   ; Skip if CMDB pane is hidden
0211               
0212 7728 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     772A 1DF0 
0213                                                   ; VDP start address (CMDB top line)
0214               
0215 772C C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     772E A020 
0216 7730 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     7732 0050 
0217 7734 06A0  32         bl    @xfilv                ; Fill colors
     7736 2296 
0218                                                   ; i \  tmp0 = start address
0219                                                   ; i |  tmp1 = byte to fill
0220                                                   ; i /  tmp2 = number of bytes to fill
0221                       ;-------------------------------------------------------
0222                       ; Dump colors for CMDB pane content (TAT)
0223                       ;-------------------------------------------------------
0224 7738 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     773A 1E40 
0225                                                   ; VDP start address (CMDB top line + 1)
0226 773C C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0227 773E 0206  20         li    tmp2,3*80             ; Number of bytes to fill
     7740 00F0 
0228 7742 06A0  32         bl    @xfilv                ; Fill colors
     7744 2296 
0229                                                   ; i \  tmp0 = start address
0230                                                   ; i |  tmp1 = byte to fill
0231                                                   ; i /  tmp2 = number of bytes to fill
0232                       ;-------------------------------------------------------
0233                       ; Dump colors for error line (TAT)
0234                       ;-------------------------------------------------------
0235               pane.action.colorscheme.errpane:
0236 7746 C120  34         mov   @tv.error.visible,tmp0
     7748 A028 
0237 774A 130A  14         jeq   pane.action.colorscheme.statline
0238                                                   ; Skip if error line pane is hidden
0239               
0240 774C 0205  20         li    tmp1,>00f6            ; White on dark red
     774E 00F6 
0241 7750 C805  38         mov   tmp1,@parm1           ; Pass color combination
     7752 2F20 
0242               
0243 7754 0205  20         li    tmp1,pane.botrow-1    ;
     7756 0016 
0244 7758 C805  38         mov   tmp1,@parm2           ; Error line on screen
     775A 2F22 
0245               
0246 775C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     775E 7822 
0247                                                   ; \ i  @parm1 = Color combination
0248                                                   ; / i  @parm2 = Row on physical screen
0249                       ;-------------------------------------------------------
0250                       ; Dump colors for top line and bottom line (TAT)
0251                       ;-------------------------------------------------------
0252               pane.action.colorscheme.statline:
0253 7760 C160  34         mov   @tv.color,tmp1
     7762 A018 
0254 7764 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7766 00FF 
0255 7768 C805  38         mov   tmp1,@parm1           ; Set color combination
     776A 2F20 
0256               
0257               
0258 776C 04E0  34         clr   @parm2                ; Top row on screen
     776E 2F22 
0259 7770 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7772 7822 
0260                                                   ; \ i  @parm1 = Color combination
0261                                                   ; / i  @parm2 = Row on physical screen
0262               
0263 7774 0205  20         li    tmp1,pane.botrow
     7776 0017 
0264 7778 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     777A 2F22 
0265 777C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     777E 7822 
0266                                                   ; \ i  @parm1 = Color combination
0267                                                   ; / i  @parm2 = Row on physical screen
0268                       ;-------------------------------------------------------
0269                       ; Dump colors for ruler if visible (TAT)
0270                       ;-------------------------------------------------------
0271 7780 C160  34         mov   @tv.ruler.visible,tmp1
     7782 A010 
0272 7784 1307  14         jeq   pane.action.colorscheme.cursorcolor
0273               
0274 7786 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     7788 7D4E 
0275 778A 06A0  32         bl    @cpym2v
     778C 2488 
0276 778E 1850                   data vdp.fb.toprow.tat
0277 7790 A16E                   data fb.ruler.tat
0278 7792 0050                   data 80               ; Show ruler colors
0279                       ;-------------------------------------------------------
0280                       ; Dump cursor FG color to sprite table (SAT)
0281                       ;-------------------------------------------------------
0282               pane.action.colorscheme.cursorcolor:
0283 7794 C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     7796 A016 
0284               
0285 7798 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     779A A022 
0286 779C 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     779E 0000 
0287 77A0 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0288                                                   ; Yes, set cursor color
0289               
0290               pane.action.colorscheme.cursorcolor.cmdb:
0291 77A2 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     77A4 00F0 
0292 77A6 0A48  56         sla   tmp4,4                ; Move to MSB
0293 77A8 1003  14         jmp   !
0294               
0295               pane.action.colorscheme.cursorcolor.fb:
0296 77AA 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     77AC 000F 
0297 77AE 0A88  56         sla   tmp4,8                ; Move to MSB
0298               
0299 77B0 D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     77B2 2F5D 
0300 77B4 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     77B6 A015 
0301                       ;-------------------------------------------------------
0302                       ; Exit
0303                       ;-------------------------------------------------------
0304               pane.action.colorscheme.load.exit:
0305 77B8 06A0  32         bl    @scron                ; Turn screen on
     77BA 2698 
0306 77BC C839  50         mov   *stack+,@parm1        ; Pop @parm1
     77BE 2F20 
0307 77C0 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0308 77C2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0309 77C4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0310 77C6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0311 77C8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0312 77CA C2F9  30         mov   *stack+,r11           ; Pop R11
0313 77CC 045B  20         b     *r11                  ; Return to caller
0314               
0315               
0316               
0317               ***************************************************************
0318               * pane.action.colorscheme.statline
0319               * Set color combination for bottom status line
0320               ***************************************************************
0321               * bl @pane.action.colorscheme.statlines
0322               *--------------------------------------------------------------
0323               * INPUT
0324               * @parm1 = Color combination to set
0325               *--------------------------------------------------------------
0326               * OUTPUT
0327               * none
0328               *--------------------------------------------------------------
0329               * Register usage
0330               * tmp0, tmp1, tmp2
0331               ********|*****|*********************|**************************
0332               pane.action.colorscheme.statlines:
0333 77CE 0649  14         dect  stack
0334 77D0 C64B  30         mov   r11,*stack            ; Save return address
0335 77D2 0649  14         dect  stack
0336 77D4 C644  30         mov   tmp0,*stack           ; Push tmp0
0337                       ;------------------------------------------------------
0338                       ; Bottom line
0339                       ;------------------------------------------------------
0340 77D6 0204  20         li    tmp0,pane.botrow
     77D8 0017 
0341 77DA C804  38         mov   tmp0,@parm2           ; Last row on screen
     77DC 2F22 
0342 77DE 06A0  32         bl    @colors.line.set      ; Load color combination for line
     77E0 7822 
0343                                                   ; \ i  @parm1 = Color combination
0344                                                   ; / i  @parm2 = Row on physical screen
0345                       ;------------------------------------------------------
0346                       ; Exit
0347                       ;------------------------------------------------------
0348               pane.action.colorscheme.statlines.exit:
0349 77E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0350 77E4 C2F9  30         mov   *stack+,r11           ; Pop R11
0351 77E6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0164                       copy  "pane.cursor.asm"            ; Cursor utility functions
**** **** ****     > pane.cursor.asm
0001               * FILE......: pane.cursor.asm
0002               * Purpose...: Cursor utility functions for panes
0003               
0004               ***************************************************************
0005               * pane.cursor.hide
0006               * Hide cursor
0007               ***************************************************************
0008               * bl  @pane.cursor.hide
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ********|*****|*********************|**************************
0019               pane.cursor.hide:
0020 77E8 0649  14         dect  stack
0021 77EA C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 77EC 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     77EE 2290 
0026 77F0 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     77F2 0000 
     77F4 0008 
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 77F6 06A0  32         bl    @clslot
     77F8 2E24 
0031 77FA 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 77FC 06A0  32         bl    @clslot
     77FE 2E24 
0034 7800 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 7802 C2F9  30         mov   *stack+,r11           ; Pop R11
0040 7804 045B  20         b     *r11                  ; Return to caller
0041               
0042               
0043               
0044               ***************************************************************
0045               * pane.cursor.blink
0046               * Blink cursor
0047               ***************************************************************
0048               * bl  @pane.cursor.blink
0049               *--------------------------------------------------------------
0050               * INPUT
0051               * none
0052               *--------------------------------------------------------------
0053               * OUTPUT
0054               * none
0055               *--------------------------------------------------------------
0056               * Register usage
0057               * none
0058               ********|*****|*********************|**************************
0059               pane.cursor.blink:
0060 7806 0649  14         dect  stack
0061 7808 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 780A 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     780C 2290 
0066 780E 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7810 0000 
     7812 0004 
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0078               
0079 7814 06A0  32         bl    @mkslot
     7816 2E06 
0080 7818 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     781A 7516 
0081 781C FFFF                   data eol
0082               
0084               
0085                       ;-------------------------------------------------------
0086                       ; Exit
0087                       ;-------------------------------------------------------
0088               pane.cursor.blink.exit:
0089 781E C2F9  30         mov   *stack+,r11           ; Pop R11
0090 7820 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0165                       ;-----------------------------------------------------------------------
0166                       ; Screen panes
0167                       ;-----------------------------------------------------------------------
0168                       copy  "colors.line.set.asm"        ; Set color combination for line
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
0021 7822 0649  14         dect  stack
0022 7824 C64B  30         mov   r11,*stack            ; Save return address
0023 7826 0649  14         dect  stack
0024 7828 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 782A 0649  14         dect  stack
0026 782C C645  30         mov   tmp1,*stack           ; Push tmp1
0027 782E 0649  14         dect  stack
0028 7830 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 7832 0649  14         dect  stack
0030 7834 C660  46         mov   @parm1,*stack         ; Push parm1
     7836 2F20 
0031 7838 0649  14         dect  stack
0032 783A C660  46         mov   @parm2,*stack         ; Push parm2
     783C 2F22 
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 783E C120  34         mov   @parm2,tmp0           ; Get target line
     7840 2F22 
0037 7842 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     7844 0050 
0038 7846 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 7848 C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 784A 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     784C 1800 
0042 784E C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     7850 2F20 
0043 7852 0206  20         li    tmp2,80               ; Number of bytes to fill
     7854 0050 
0044               
0045 7856 06A0  32         bl    @xfilv                ; Fill colors
     7858 2296 
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 785A C839  50         mov   *stack+,@parm2        ; Pop @parm2
     785C 2F22 
0054 785E C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7860 2F20 
0055 7862 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 7864 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7866 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7868 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 786A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0169                       copy  "pane.cmdb.asm"              ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
**** **** ****     > stevie_b1.asm.393026
0170                       copy  "pane.cmdb.show.asm"         ; Show command buffer pane
**** **** ****     > pane.cmdb.show.asm
0001               * FILE......: pane.cmdb.show.asm
0002               * Purpose...: Show command buffer pane
0003               
0004               ***************************************************************
0005               * pane.cmdb.show
0006               * Show command buffer pane
0007               ***************************************************************
0008               * bl @pane.cmdb.show
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
0021               pane.cmdb.show:
0022 786C 0649  14         dect  stack
0023 786E C64B  30         mov   r11,*stack            ; Save return address
0024 7870 0649  14         dect  stack
0025 7872 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 7874 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7876 832A 
     7878 A304 
0030                                                   ; Save YX position in frame buffer
0031               
0032 787A 0204  20         li    tmp0,pane.botrow
     787C 0017 
0033 787E 6120  34         s     @cmdb.scrrows,tmp0
     7880 A306 
0034 7882 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7884 A11A 
0035               
0036 7886 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 7888 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     788A A30E 
0038               
0039 788C 0224  22         ai    tmp0,>0100
     788E 0100 
0040 7890 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7892 A310 
0041 7894 0584  14         inc   tmp0
0042 7896 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7898 A30A 
0043               
0044 789A 0720  34         seto  @cmdb.visible         ; Show pane
     789C A302 
0045 789E 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     78A0 A318 
0046               
0047 78A2 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     78A4 0001 
0048 78A6 C804  38         mov   tmp0,@tv.pane.focus   ; /
     78A8 A022 
0049               
0050 78AA 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     78AC 7AFC 
0051               
0052 78AE 0720  34         seto  @parm1                ; Do not turn screen off while
     78B0 2F20 
0053                                                   ; reloading color scheme
0054               
0055 78B2 06A0  32         bl    @pane.action.colorscheme.load
     78B4 765C 
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 78B6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 78B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 78BA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0171                       copy  "pane.cmdb.hide.asm"         ; Hide command buffer pane
**** **** ****     > pane.cmdb.hide.asm
0001               * FILE......: pane.cmdb.hide.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
0003               
0004               ***************************************************************
0005               * pane.cmdb.hide
0006               * Hide command buffer pane
0007               ***************************************************************
0008               * bl @pane.cmdb.hide
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
0019               * Hiding the command buffer automatically passes pane focus
0020               * to frame buffer.
0021               ********|*****|*********************|**************************
0022               pane.cmdb.hide:
0023 78BC 0649  14         dect  stack
0024 78BE C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Hide command buffer pane
0027                       ;------------------------------------------------------
0028 78C0 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     78C2 A11C 
     78C4 A11A 
0029                       ;------------------------------------------------------
0030                       ; Adjust frame buffer size if error pane visible
0031                       ;------------------------------------------------------
0032 78C6 C820  54         mov   @tv.error.visible,@tv.error.visible
     78C8 A028 
     78CA A028 
0033 78CC 1302  14         jeq   !
0034 78CE 0620  34         dec   @fb.scrrows
     78D0 A11A 
0035                       ;------------------------------------------------------
0036                       ; Clear error/hint & status line
0037                       ;------------------------------------------------------
0038 78D2 06A0  32 !       bl    @hchar
     78D4 27C6 
0039 78D6 1600                   byte pane.botrow-1,0,32,80*2
     78D8 20A0 
0040 78DA FFFF                   data EOL
0041                       ;------------------------------------------------------
0042                       ; Adjust frame buffer size if ruler visible
0043                       ;------------------------------------------------------
0044 78DC C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     78DE A010 
     78E0 A010 
0045 78E2 1302  14         jeq   pane.cmdb.hide.rest
0046 78E4 0620  34         dec   @fb.scrrows
     78E6 A11A 
0047                       ;------------------------------------------------------
0048                       ; Hide command buffer pane (rest)
0049                       ;------------------------------------------------------
0050               pane.cmdb.hide.rest:
0051 78E8 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     78EA A304 
     78EC 832A 
0052 78EE 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     78F0 A302 
0053 78F2 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     78F4 A116 
0054 78F6 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     78F8 A022 
0055                       ;------------------------------------------------------
0056                       ; Reload current color scheme
0057                       ;------------------------------------------------------
0058 78FA 0720  34         seto  @parm1                ; Do not turn screen off while
     78FC 2F20 
0059                                                   ; reloading color scheme
0060               
0061 78FE 06A0  32         bl    @pane.action.colorscheme.load
     7900 765C 
0062                                                   ; Reload color scheme
0063                                                   ; i  parm1 = Skip screen off if >FFFF
0064                       ;------------------------------------------------------
0065                       ; Show cursor again
0066                       ;------------------------------------------------------
0067 7902 06A0  32         bl    @pane.cursor.blink
     7904 7806 
0068                       ;------------------------------------------------------
0069                       ; Exit
0070                       ;------------------------------------------------------
0071               pane.cmdb.hide.exit:
0072 7906 C2F9  30         mov   *stack+,r11           ; Pop r11
0073 7908 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0172                       copy  "pane.cmdb.draw.asm"         ; Draw command buffer pane contents
**** **** ****     > pane.cmdb.draw.asm
0001               * FILE......: pane.cmdb.draw.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
0003               
0004               ***************************************************************
0005               * pane.cmdb.draw
0006               * Draw Stevie Command Buffer in pane
0007               ***************************************************************
0008               * bl  @pane.cmdb.draw
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0, tmp1, tmp2
0015               ********|*****|*********************|**************************
0016               pane.cmdb.draw:
0017 790A 0649  14         dect  stack
0018 790C C64B  30         mov   r11,*stack            ; Save return address
0019 790E 0649  14         dect  stack
0020 7910 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7912 0649  14         dect  stack
0022 7914 C645  30         mov   tmp1,*stack           ; Push tmp1
0023 7916 0649  14         dect  stack
0024 7918 C646  30         mov   tmp2,*stack           ; Push tmp2
0025                       ;------------------------------------------------------
0026                       ; Command buffer header line
0027                       ;------------------------------------------------------
0028 791A C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     791C A31C 
     791E 2F20 
0029 7920 0204  20         li    tmp0,80
     7922 0050 
0030 7924 C804  38         mov   tmp0,@parm2           ; Set requested length
     7926 2F22 
0031 7928 0204  20         li    tmp0,1
     792A 0001 
0032 792C C804  38         mov   tmp0,@parm3           ; Set character to fill
     792E 2F24 
0033 7930 0204  20         li    tmp0,rambuf
     7932 2F6A 
0034 7934 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7936 2F26 
0035               
0036               
0037 7938 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     793A 3302 
0038                                                   ; \ i  @parm1 = Pointer to string
0039                                                   ; | i  @parm2 = Requested length
0040                                                   ; | i  @parm3 = Fill character
0041                                                   ; | i  @parm4 = Pointer to buffer with
0042                                                   ; /             output string
0043               
0044 793C C820  54         mov   @cmdb.yxtop,@wyx      ; \
     793E A30E 
     7940 832A 
0045 7942 C160  34         mov   @outparm1,tmp1        ; | Display pane header
     7944 2F30 
0046 7946 06A0  32         bl    @xutst0               ; /
     7948 2422 
0047                       ;------------------------------------------------------
0048                       ; Check dialog id
0049                       ;------------------------------------------------------
0050 794A 04E0  34         clr   @waux1                ; Default is show prompt
     794C 833C 
0051               
0052 794E C120  34         mov   @cmdb.dialog,tmp0
     7950 A31A 
0053 7952 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     7954 0063 
0054 7956 120E  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0055 7958 0720  34         seto  @waux1                ; /
     795A 833C 
0056                       ;------------------------------------------------------
0057                       ; Show info message instead of prompt
0058                       ;------------------------------------------------------
0059 795C C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     795E A31E 
0060 7960 1309  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0061               
0062 7962 06A0  32         bl    @at
     7964 26D0 
0063 7966 1400                   byte pane.botrow-3,0  ; Position cursor
0064               
0065 7968 D815  46         movb  *tmp1,@cmdb.cmdlen    ; \  Deref & set length of message
     796A A326 
0066 796C D195  26         movb  *tmp1,tmp2            ; |
0067 796E 0986  56         srl   tmp2,8                ; |
0068 7970 06A0  32         bl    @xutst0               ; /  Display info message
     7972 2422 
0069                       ;------------------------------------------------------
0070                       ; Clear lines after prompt in command buffer
0071                       ;------------------------------------------------------
0072               pane.cmdb.draw.clear:
0073 7974 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7976 A326 
0074 7978 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0075 797A A120  34         a     @cmdb.yxprompt,tmp0   ; |
     797C A310 
0076 797E C804  38         mov   tmp0,@wyx             ; /
     7980 832A 
0077               
0078 7982 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7984 23FC 
0079                                                   ; \ i  @wyx = Cursor position
0080                                                   ; / o  tmp0 = VDP target address
0081               
0082 7986 0205  20         li    tmp1,32
     7988 0020 
0083               
0084 798A C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     798C A326 
0085 798E 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0086 7990 0506  16         neg   tmp2                  ; | Based on command & prompt length
0087 7992 0226  22         ai    tmp2,2*80 - 1         ; /
     7994 009F 
0088               
0089 7996 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     7998 2296 
0090                                                   ; | i  tmp0 = VDP target address
0091                                                   ; | i  tmp1 = Byte to fill
0092                                                   ; / i  tmp2 = Number of bytes to fill
0093                       ;------------------------------------------------------
0094                       ; Display pane hint in command buffer
0095                       ;------------------------------------------------------
0096               pane.cmdb.draw.hint:
0097 799A 0204  20         li    tmp0,pane.botrow - 1  ; \
     799C 0016 
0098 799E 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0099 79A0 C804  38         mov   tmp0,@parm1           ; Set parameter
     79A2 2F20 
0100 79A4 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     79A6 A320 
     79A8 2F22 
0101               
0102 79AA 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     79AC 7594 
0103                                                   ; \ i  parm1 = Pointer to string with hint
0104                                                   ; / i  parm2 = YX position
0105                       ;------------------------------------------------------
0106                       ; Display keys in status line
0107                       ;------------------------------------------------------
0108 79AE 0204  20         li    tmp0,pane.botrow      ; \
     79B0 0017 
0109 79B2 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0110 79B4 C804  38         mov   tmp0,@parm1           ; Set parameter
     79B6 2F20 
0111 79B8 C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     79BA A322 
     79BC 2F22 
0112               
0113 79BE 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     79C0 7594 
0114                                                   ; \ i  parm1 = Pointer to string with hint
0115                                                   ; / i  parm2 = YX position
0116                       ;------------------------------------------------------
0117                       ; ALPHA-Lock key down?
0118                       ;------------------------------------------------------
0119 79C2 20A0  38         coc   @wbit10,config
     79C4 200C 
0120 79C6 1306  14         jeq   pane.cmdb.draw.alpha.down
0121                       ;------------------------------------------------------
0122                       ; AlPHA-Lock is up
0123                       ;------------------------------------------------------
0124 79C8 06A0  32         bl    @hchar
     79CA 27C6 
0125 79CC 174E                   byte pane.botrow,78,32,2
     79CE 2002 
0126 79D0 FFFF                   data eol
0127               
0128 79D2 1004  14         jmp   pane.cmdb.draw.promptcmd
0129                       ;------------------------------------------------------
0130                       ; AlPHA-Lock is down
0131                       ;------------------------------------------------------
0132               pane.cmdb.draw.alpha.down:
0133 79D4 06A0  32         bl    @putat
     79D6 2444 
0134 79D8 174E                   byte   pane.botrow,78
0135 79DA 35D0                   data   txt.alpha.down
0136                       ;------------------------------------------------------
0137                       ; Command buffer content
0138                       ;------------------------------------------------------
0139               pane.cmdb.draw.promptcmd:
0140 79DC C120  34         mov   @waux1,tmp0           ; Flag set?
     79DE 833C 
0141 79E0 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0142 79E2 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     79E4 73A2 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               pane.cmdb.draw.exit:
0147 79E6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0148 79E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0149 79EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0150 79EC C2F9  30         mov   *stack+,r11           ; Pop r11
0151 79EE 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.393026
0173               
0174                       copy  "pane.topline.asm"           ; Top line
**** **** ****     > pane.topline.asm
0001               * FILE......: pane.topline.asm
0002               * Purpose...: Pane "status top line"
0003               
0004               ***************************************************************
0005               * pane.topline
0006               * Draw top line
0007               ***************************************************************
0008               * bl  @pane.topline
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.topline:
0017 79F0 0649  14         dect  stack
0018 79F2 C64B  30         mov   r11,*stack            ; Save return address
0019 79F4 0649  14         dect  stack
0020 79F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 79F8 0649  14         dect  stack
0022 79FA C660  46         mov   @wyx,*stack           ; Push cursor position
     79FC 832A 
0023                       ;------------------------------------------------------
0024                       ; Show buffer number
0025                       ;------------------------------------------------------
0026 79FE 06A0  32         bl    @putat
     7A00 2444 
0027 7A02 0000                   byte  0,0
0028 7A04 3522                   data  txt.bufnum
0029                       ;------------------------------------------------------
0030                       ; Show current file
0031                       ;------------------------------------------------------
0032 7A06 C820  54         mov   @edb.filename.ptr,@parm1
     7A08 A212 
     7A0A 2F20 
0033                                                   ; Get string to display
0034 7A0C 0204  20         li    tmp0,47
     7A0E 002F 
0035 7A10 C804  38         mov   tmp0,@parm2           ; Set requested length
     7A12 2F22 
0036 7A14 0204  20         li    tmp0,32
     7A16 0020 
0037 7A18 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7A1A 2F24 
0038 7A1C 0204  20         li    tmp0,rambuf
     7A1E 2F6A 
0039 7A20 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7A22 2F26 
0040               
0041               
0042 7A24 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7A26 3302 
0043                                                   ; \ i  @parm1 = Pointer to string
0044                                                   ; | i  @parm2 = Requested length
0045                                                   ; | i  @parm3 = Fill characgter
0046                                                   ; | i  @parm4 = Pointer to buffer with
0047                                                   ; /             output string
0048               
0049 7A28 06A0  32         bl    @setx
     7A2A 26E6 
0050 7A2C 0003                   data 3                ; Position cursor
0051               
0052 7A2E C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7A30 2F30 
0053 7A32 06A0  32         bl    @xutst0               ; /
     7A34 2422 
0054                       ;------------------------------------------------------
0055                       ; Show M1 marker
0056                       ;------------------------------------------------------
0057 7A36 C120  34         mov   @edb.block.m1,tmp0    ; \
     7A38 A20C 
0058 7A3A 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0059 7A3C 1326  14         jeq   pane.topline.exit     ; /
0060               
0061 7A3E 06A0  32         bl    @putat
     7A40 2444 
0062 7A42 0034                   byte 0,52
0063 7A44 3538                   data txt.m1           ; Show M1 marker message
0064               
0065 7A46 C820  54         mov   @edb.block.m1,@parm1
     7A48 A20C 
     7A4A 2F20 
0066 7A4C 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7A4E 32D6 
0067                                                   ; \ i @parm1           = uint16
0068                                                   ; / o @unpacked.string = Output string
0069               
0070 7A50 0204  20         li    tmp0,>0500
     7A52 0500 
0071 7A54 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7A56 2F44 
0072               
0073 7A58 06A0  32         bl    @putat
     7A5A 2444 
0074 7A5C 0037                   byte 0,55
0075 7A5E 2F44                   data unpacked.string  ; Show M1 value
0076                       ;------------------------------------------------------
0077                       ; Show M2 marker
0078                       ;------------------------------------------------------
0079 7A60 C120  34         mov   @edb.block.m2,tmp0    ; \
     7A62 A20E 
0080 7A64 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0081 7A66 1311  14         jeq   pane.topline.exit     ; /
0082               
0083 7A68 06A0  32         bl    @putat
     7A6A 2444 
0084 7A6C 003E                   byte 0,62
0085 7A6E 353C                   data txt.m2           ; Show M2 marker message
0086               
0087 7A70 C820  54         mov   @edb.block.m2,@parm1
     7A72 A20E 
     7A74 2F20 
0088 7A76 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7A78 32D6 
0089                                                   ; \ i @parm1           = uint16
0090                                                   ; / o @unpacked.string = Output string
0091               
0092 7A7A 0204  20         li    tmp0,>0500
     7A7C 0500 
0093 7A7E D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7A80 2F44 
0094               
0095 7A82 06A0  32         bl    @putat
     7A84 2444 
0096 7A86 0041                   byte 0,65
0097 7A88 2F44                   data unpacked.string  ; Show M2 value
0098                       ;------------------------------------------------------
0099                       ; Exit
0100                       ;------------------------------------------------------
0101               pane.topline.exit:
0102 7A8A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7A8C 832A 
0103 7A8E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 7A90 C2F9  30         mov   *stack+,r11           ; Pop r11
0105 7A92 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.393026
0175                       copy  "pane.errline.asm"           ; Error line
**** **** ****     > pane.errline.asm
0001               * FILE......: pane.errline.asm
0002               * Purpose...: Stevie Editor - Error line pane
0003               
0004               ***************************************************************
0005               * pane.errline.show
0006               * Show command buffer pane
0007               ***************************************************************
0008               * bl @pane.errline.show
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               pane.errline.show:
0022 7A94 0649  14         dect  stack
0023 7A96 C64B  30         mov   r11,*stack            ; Save return address
0024 7A98 0649  14         dect  stack
0025 7A9A C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7A9C 0649  14         dect  stack
0027 7A9E C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7AA0 0205  20         li    tmp1,>00f6            ; White on dark red
     7AA2 00F6 
0030 7AA4 C805  38         mov   tmp1,@parm1
     7AA6 2F20 
0031               
0032 7AA8 0205  20         li    tmp1,pane.botrow-1    ;
     7AAA 0016 
0033 7AAC C805  38         mov   tmp1,@parm2           ; Error line on screen
     7AAE 2F22 
0034               
0035 7AB0 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7AB2 7822 
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7AB4 0204  20         li    tmp0,tv.error.msg
     7AB6 A02A 
0043 7AB8 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7ABA 2F20 
0044               
0045 7ABC 0204  20         li    tmp0,80
     7ABE 0050 
0046 7AC0 C804  38         mov   tmp0,@parm2           ; Set requested length
     7AC2 2F22 
0047               
0048 7AC4 0204  20         li    tmp0,32
     7AC6 0020 
0049 7AC8 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7ACA 2F24 
0050               
0051 7ACC 0204  20         li    tmp0,rambuf
     7ACE 2F6A 
0052 7AD0 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7AD2 2F26 
0053               
0054 7AD4 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7AD6 3302 
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 7AD8 06A0  32         bl    @at
     7ADA 26D0 
0064 7ADC 1600                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 7ADE C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7AE0 2F30 
0067 7AE2 06A0  32         bl    @xutst0               ; /
     7AE4 2422 
0068               
0069 7AE6 C120  34         mov   @fb.scrrows.max,tmp0
     7AE8 A11C 
0070 7AEA 0604  14         dec   tmp0
0071 7AEC C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7AEE A11A 
0072               
0073 7AF0 0720  34         seto  @tv.error.visible     ; Error line is visible
     7AF2 A028 
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 7AF4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 7AF6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 7AF8 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7AFA 045B  20         b     *r11                  ; Return to caller
0082               
0083               
0084               
0085               ***************************************************************
0086               * pane.errline.hide
0087               * Hide error line
0088               ***************************************************************
0089               * bl @pane.errline.hide
0090               *--------------------------------------------------------------
0091               * INPUT
0092               * none
0093               *--------------------------------------------------------------
0094               * OUTPUT
0095               * none
0096               *--------------------------------------------------------------
0097               * Register usage
0098               * none
0099               *--------------------------------------------------------------
0100               * Hiding the error line passes pane focus to frame buffer.
0101               ********|*****|*********************|**************************
0102               pane.errline.hide:
0103 7AFC 0649  14         dect  stack
0104 7AFE C64B  30         mov   r11,*stack            ; Save return address
0105 7B00 0649  14         dect  stack
0106 7B02 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Hide command buffer pane
0109                       ;------------------------------------------------------
0110 7B04 06A0  32         bl    @errline.init         ; Clear error line
     7B06 326A 
0111               
0112 7B08 C120  34         mov   @tv.color,tmp0        ; Get colors
     7B0A A018 
0113 7B0C 0984  56         srl   tmp0,8                ; Right aligns
0114 7B0E C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7B10 2F20 
0115               
0116               
0117 7B12 0205  20         li    tmp1,pane.botrow-1    ;
     7B14 0016 
0118 7B16 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7B18 2F22 
0119               
0120 7B1A 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7B1C 7822 
0121                                                   ; \ i  @parm1 = Color combination
0122                                                   ; / i  @parm2 = Row on physical screen
0123               
0124 7B1E 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     7B20 A028 
0125 7B22 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7B24 A11C 
     7B26 A11A 
0126                                                   ; Set frame buffer to full size again
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               pane.errline.hide.exit:
0131 7B28 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0132 7B2A C2F9  30         mov   *stack+,r11           ; Pop r11
0133 7B2C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0176                       copy  "pane.botline.asm"           ; Bottom line
**** **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: Pane "status bottom line"
0003               
0004               ***************************************************************
0005               * pane.botline
0006               * Draw Stevie bottom line
0007               ***************************************************************
0008               * bl  @pane.botline
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.botline:
0017 7B2E 0649  14         dect  stack
0018 7B30 C64B  30         mov   r11,*stack            ; Save return address
0019 7B32 0649  14         dect  stack
0020 7B34 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7B36 0649  14         dect  stack
0022 7B38 C660  46         mov   @wyx,*stack           ; Push cursor position
     7B3A 832A 
0023               
0024                       ;------------------------------------------------------
0025                       ; Show block shortcuts if set
0026                       ;------------------------------------------------------
0027 7B3C C120  34         mov   @edb.block.m2,tmp0    ; \
     7B3E A20E 
0028 7B40 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0029                                                   ; /
0030 7B42 1305  14         jeq   pane.botline.show_keys
0031               
0032 7B44 06A0  32         bl    @putat
     7B46 2444 
0033 7B48 1700                   byte pane.botrow,0
0034 7B4A 3554                   data txt.keys.block   ; Show block shortcuts
0035               
0036 7B4C 1004  14         jmp   pane.botline.show_mode
0037                       ;------------------------------------------------------
0038                       ; Show default message
0039                       ;------------------------------------------------------
0040               pane.botline.show_keys:
0041 7B4E 06A0  32         bl    @putat
     7B50 2444 
0042 7B52 1700                   byte pane.botrow,0
0043 7B54 3540                   data txt.keys.default ; Show default shortcuts
0044                       ;------------------------------------------------------
0045                       ; Show text editing mode
0046                       ;------------------------------------------------------
0047               pane.botline.show_mode:
0048 7B56 C120  34         mov   @edb.insmode,tmp0
     7B58 A20A 
0049 7B5A 1605  14         jne   pane.botline.show_mode.insert
0050                       ;------------------------------------------------------
0051                       ; Overwrite mode
0052                       ;------------------------------------------------------
0053 7B5C 06A0  32         bl    @putat
     7B5E 2444 
0054 7B60 1734                   byte  pane.botrow,52
0055 7B62 3496                   data  txt.ovrwrite
0056 7B64 1004  14         jmp   pane.botline.show_changed
0057                       ;------------------------------------------------------
0058                       ; Insert mode
0059                       ;------------------------------------------------------
0060               pane.botline.show_mode.insert:
0061 7B66 06A0  32         bl    @putat
     7B68 2444 
0062 7B6A 1734                   byte  pane.botrow,52
0063 7B6C 349A                   data  txt.insert
0064                       ;------------------------------------------------------
0065                       ; Show if text was changed in editor buffer
0066                       ;------------------------------------------------------
0067               pane.botline.show_changed:
0068 7B6E C120  34         mov   @edb.dirty,tmp0
     7B70 A206 
0069 7B72 1305  14         jeq   pane.botline.show_linecol
0070                       ;------------------------------------------------------
0071                       ; Show "*"
0072                       ;------------------------------------------------------
0073 7B74 06A0  32         bl    @putat
     7B76 2444 
0074 7B78 1738                   byte pane.botrow,56
0075 7B7A 349E                   data txt.star
0076 7B7C 1000  14         jmp   pane.botline.show_linecol
0077                       ;------------------------------------------------------
0078                       ; Show "line,column"
0079                       ;------------------------------------------------------
0080               pane.botline.show_linecol:
0081 7B7E C820  54         mov   @fb.row,@parm1
     7B80 A106 
     7B82 2F20 
0082 7B84 06A0  32         bl    @fb.row2line          ; Row to editor line
     7B86 6A46 
0083                                                   ; \ i @fb.topline = Top line in frame buffer
0084                                                   ; | i @parm1      = Row in frame buffer
0085                                                   ; / o @outparm1   = Matching line in EB
0086               
0087 7B88 05A0  34         inc   @outparm1             ; Add base 1
     7B8A 2F30 
0088                       ;------------------------------------------------------
0089                       ; Show line
0090                       ;------------------------------------------------------
0091 7B8C 06A0  32         bl    @putnum
     7B8E 2A56 
0092 7B90 173B                   byte  pane.botrow,59  ; YX
0093 7B92 2F30                   data  outparm1,rambuf
     7B94 2F6A 
0094 7B96 3020                   byte  48              ; ASCII offset
0095                             byte  32              ; Padding character
0096                       ;------------------------------------------------------
0097                       ; Show comma
0098                       ;------------------------------------------------------
0099 7B98 06A0  32         bl    @putat
     7B9A 2444 
0100 7B9C 1740                   byte  pane.botrow,64
0101 7B9E 348E                   data  txt.delim
0102                       ;------------------------------------------------------
0103                       ; Show column
0104                       ;------------------------------------------------------
0105 7BA0 06A0  32         bl    @film
     7BA2 2238 
0106 7BA4 2F6F                   data rambuf+5,32,12   ; Clear work buffer with space character
     7BA6 0020 
     7BA8 000C 
0107               
0108 7BAA C820  54         mov   @fb.column,@waux1
     7BAC A10C 
     7BAE 833C 
0109 7BB0 05A0  34         inc   @waux1                ; Offset 1
     7BB2 833C 
0110               
0111 7BB4 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7BB6 29D8 
0112 7BB8 833C                   data  waux1,rambuf
     7BBA 2F6A 
0113 7BBC 3020                   byte  48              ; ASCII offset
0114                             byte  32              ; Fill character
0115               
0116 7BBE 06A0  32         bl    @trimnum              ; Trim number to the left
     7BC0 2A30 
0117 7BC2 2F6A                   data  rambuf,rambuf+5,32
     7BC4 2F6F 
     7BC6 0020 
0118               
0119 7BC8 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7BCA 0600 
0120 7BCC D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7BCE 2F6F 
0121               
0122                       ;------------------------------------------------------
0123                       ; Decide if row length is to be shown
0124                       ;------------------------------------------------------
0125 7BD0 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7BD2 A10C 
0126 7BD4 0584  14         inc   tmp0                  ; /
0127 7BD6 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7BD8 A108 
0128 7BDA 1101  14         jlt   pane.botline.show_linecol.linelen
0129 7BDC 102B  14         jmp   pane.botline.show_linecol.colstring
0130                                                   ; Yes, skip showing row length
0131                       ;------------------------------------------------------
0132                       ; Add ',' delimiter and length of line to string
0133                       ;------------------------------------------------------
0134               pane.botline.show_linecol.linelen:
0135 7BDE C120  34         mov   @fb.column,tmp0       ; \
     7BE0 A10C 
0136 7BE2 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7BE4 2F71 
0137 7BE6 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7BE8 0009 
0138 7BEA 1101  14         jlt   !                     ; | column.
0139 7BEC 0585  14         inc   tmp1                  ; /
0140               
0141 7BEE 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7BF0 2D00 
0142 7BF2 DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0143               
0144 7BF4 C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7BF6 833C 
0145               
0146 7BF8 06A0  32         bl    @mknum
     7BFA 29D8 
0147 7BFC A108                   data  fb.row.length,rambuf
     7BFE 2F6A 
0148 7C00 3020                   byte  48              ; ASCII offset
0149                             byte  32              ; Padding character
0150               
0151 7C02 C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7C04 833C 
0152               
0153 7C06 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7C08 A108 
0154 7C0A 0284  22         ci    tmp0,10               ; /
     7C0C 000A 
0155 7C0E 110B  14         jlt   pane.botline.show_line.1digit
0156                       ;------------------------------------------------------
0157                       ; Assert
0158                       ;------------------------------------------------------
0159 7C10 0284  22         ci    tmp0,80
     7C12 0050 
0160 7C14 1204  14         jle   pane.botline.show_line.2digits
0161                       ;------------------------------------------------------
0162                       ; Asserts failed
0163                       ;------------------------------------------------------
0164 7C16 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7C18 FFCE 
0165 7C1A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7C1C 2026 
0166                       ;------------------------------------------------------
0167                       ; Show length of line (2 digits)
0168                       ;------------------------------------------------------
0169               pane.botline.show_line.2digits:
0170 7C1E 0204  20         li    tmp0,rambuf+3
     7C20 2F6D 
0171 7C22 DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0172 7C24 1002  14         jmp   pane.botline.show_line.rest
0173                       ;------------------------------------------------------
0174                       ; Show length of line (1 digits)
0175                       ;------------------------------------------------------
0176               pane.botline.show_line.1digit:
0177 7C26 0204  20         li    tmp0,rambuf+4
     7C28 2F6E 
0178               pane.botline.show_line.rest:
0179 7C2A DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0180 7C2C DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7C2E 2F6A 
0181 7C30 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7C32 2F6A 
0182                       ;------------------------------------------------------
0183                       ; Show column string
0184                       ;------------------------------------------------------
0185               pane.botline.show_linecol.colstring:
0186 7C34 06A0  32         bl    @putat
     7C36 2444 
0187 7C38 1741                   byte pane.botrow,65
0188 7C3A 2F6F                   data rambuf+5         ; Show string
0189                       ;------------------------------------------------------
0190                       ; Show lines in buffer unless on last line in file
0191                       ;------------------------------------------------------
0192 7C3C C820  54         mov   @fb.row,@parm1
     7C3E A106 
     7C40 2F20 
0193 7C42 06A0  32         bl    @fb.row2line
     7C44 6A46 
0194 7C46 8820  54         c     @edb.lines,@outparm1
     7C48 A204 
     7C4A 2F30 
0195 7C4C 1605  14         jne   pane.botline.show_lines_in_buffer
0196               
0197 7C4E 06A0  32         bl    @putat
     7C50 2444 
0198 7C52 1748                   byte pane.botrow,72
0199 7C54 3490                   data txt.bottom
0200               
0201 7C56 1009  14         jmp   pane.botline.exit
0202                       ;------------------------------------------------------
0203                       ; Show lines in buffer
0204                       ;------------------------------------------------------
0205               pane.botline.show_lines_in_buffer:
0206 7C58 C820  54         mov   @edb.lines,@waux1
     7C5A A204 
     7C5C 833C 
0207               
0208 7C5E 06A0  32         bl    @putnum
     7C60 2A56 
0209 7C62 1748                   byte pane.botrow,72   ; YX
0210 7C64 833C                   data waux1,rambuf
     7C66 2F6A 
0211 7C68 3020                   byte 48
0212                             byte 32
0213                       ;------------------------------------------------------
0214                       ; Exit
0215                       ;------------------------------------------------------
0216               pane.botline.exit:
0217 7C6A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7C6C 832A 
0218 7C6E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0219 7C70 C2F9  30         mov   *stack+,r11           ; Pop r11
0220 7C72 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.393026
0177                       ;-----------------------------------------------------------------------
0178                       ; Stubs using trampoline
0179                       ;-----------------------------------------------------------------------
0180                       copy  "rom.stubs.bank1.asm"        ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               
0005               ***************************************************************
0006               * Stub for "vdp.patterns.dump"
0007               * bank0 vec.1
0008               ********|*****|*********************|**************************
0009               vdp.patterns.dump:
0010 7C74 0649  14         dect  stack
0011 7C76 C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Dump VDP patterns
0014                       ;------------------------------------------------------
0015 7C78 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C7A 3008 
0016 7C7C 6000                   data bank0.rom        ; | i  p0 = bank address
0017 7C7E 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0018 7C80 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 7C82 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 7C84 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "fm.loadfile"
0028               * bank2 vec.1
0029               ********|*****|*********************|**************************
0030               fm.loadfile:
0031 7C86 0649  14         dect  stack
0032 7C88 C64B  30         mov   r11,*stack            ; Save return address
0033 7C8A 0649  14         dect  stack
0034 7C8C C644  30         mov   tmp0,*stack           ; Push tmp0
0035                       ;------------------------------------------------------
0036                       ; Call function in bank 2
0037                       ;------------------------------------------------------
0038 7C8E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C90 3008 
0039 7C92 6004                   data bank2.rom        ; | i  p0 = bank address
0040 7C94 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0041 7C96 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0042                       ;------------------------------------------------------
0043                       ; Show "Unsaved changes" dialog if editor buffer dirty
0044                       ;------------------------------------------------------
0045 7C98 C120  34         mov   @outparm1,tmp0
     7C9A 2F30 
0046 7C9C 1304  14         jeq   fm.loadfile.exit
0047               
0048 7C9E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7CA0 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7CA2 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7CA4 7D18 
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               fm.loadfile.exit:
0055 7CA6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 7CA8 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7CAA 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               ***************************************************************
0061               * Stub for "fm.savefile"
0062               * bank2 vec.2
0063               ********|*****|*********************|**************************
0064               fm.savefile:
0065 7CAC 0649  14         dect  stack
0066 7CAE C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Call function in bank 2
0069                       ;------------------------------------------------------
0070 7CB0 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CB2 3008 
0071 7CB4 6004                   data bank2.rom        ; | i  p0 = bank address
0072 7CB6 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0073 7CB8 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077 7CBA C2F9  30         mov   *stack+,r11           ; Pop r11
0078 7CBC 045B  20         b     *r11                  ; Return to caller
0079               
0080               
0081               **************************************************************
0082               * Stub for "fm.browse.fname.suffix"
0083               * bank2 vec.3
0084               ********|*****|*********************|**************************
0085               fm.browse.fname.suffix:
0086 7CBE 0649  14         dect  stack
0087 7CC0 C64B  30         mov   r11,*stack            ; Save return address
0088                       ;------------------------------------------------------
0089                       ; Call function in bank 2
0090                       ;------------------------------------------------------
0091 7CC2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CC4 3008 
0092 7CC6 6004                   data bank2.rom        ; | i  p0 = bank address
0093 7CC8 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0094 7CCA 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098 7CCC C2F9  30         mov   *stack+,r11           ; Pop r11
0099 7CCE 045B  20         b     *r11                  ; Return to caller
0100               
0101               
0102               **************************************************************
0103               * Stub for "fm.fastmode"
0104               * bank2 vec.4
0105               ********|*****|*********************|**************************
0106               fm.fastmode:
0107 7CD0 0649  14         dect  stack
0108 7CD2 C64B  30         mov   r11,*stack            ; Save return address
0109                       ;------------------------------------------------------
0110                       ; Call function in bank 2
0111                       ;------------------------------------------------------
0112 7CD4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CD6 3008 
0113 7CD8 6004                   data bank2.rom        ; | i  p0 = bank address
0114 7CDA 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0115 7CDC 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0116                       ;------------------------------------------------------
0117                       ; Exit
0118                       ;------------------------------------------------------
0119 7CDE C2F9  30         mov   *stack+,r11           ; Pop r11
0120 7CE0 045B  20         b     *r11                  ; Return to caller
0121               
0122               
0123               
0124               
0125               
0126               ***************************************************************
0127               * Stub for "About dialog"
0128               * bank3 vec.1
0129               ********|*****|*********************|**************************
0130               edkey.action.about:
0131 7CE2 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7CE4 77E8 
0132                       ;------------------------------------------------------
0133                       ; Show dialog
0134                       ;------------------------------------------------------
0135 7CE6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CE8 3008 
0136 7CEA 6006                   data bank3.rom        ; | i  p0 = bank address
0137 7CEC 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0138 7CEE 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0139                       ;------------------------------------------------------
0140                       ; Exit
0141                       ;------------------------------------------------------
0142 7CF0 0460  28         b     @edkey.action.cmdb.show
     7CF2 693A 
0143                                                   ; Show dialog in CMDB pane
0144               
0145               
0146               ***************************************************************
0147               * Stub for "Load DV80 file"
0148               * bank3 vec.2
0149               ********|*****|*********************|**************************
0150               dialog.load:
0151 7CF4 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7CF6 77E8 
0152                       ;------------------------------------------------------
0153                       ; Show dialog
0154                       ;------------------------------------------------------
0155 7CF8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CFA 3008 
0156 7CFC 6006                   data bank3.rom        ; | i  p0 = bank address
0157 7CFE 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0158 7D00 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0159                       ;------------------------------------------------------
0160                       ; Exit
0161                       ;------------------------------------------------------
0162 7D02 0460  28         b     @edkey.action.cmdb.show
     7D04 693A 
0163                                                   ; Show dialog in CMDB pane
0164               
0165               
0166               ***************************************************************
0167               * Stub for "Save DV80 file"
0168               * bank3 vec.3
0169               ********|*****|*********************|**************************
0170               dialog.save:
0171 7D06 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D08 77E8 
0172                       ;------------------------------------------------------
0173                       ; Show dialog
0174                       ;------------------------------------------------------
0175 7D0A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D0C 3008 
0176 7D0E 6006                   data bank3.rom        ; | i  p0 = bank address
0177 7D10 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0178 7D12 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0179                       ;------------------------------------------------------
0180                       ; Exit
0181                       ;------------------------------------------------------
0182 7D14 0460  28         b     @edkey.action.cmdb.show
     7D16 693A 
0183                                                   ; Show dialog in CMDB pane
0184               
0185               
0186               ***************************************************************
0187               * Stub for "Unsaved Changes"
0188               * bank3 vec.4
0189               ********|*****|*********************|**************************
0190               dialog.unsaved:
0191 7D18 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D1A 77E8 
0192                       ;------------------------------------------------------
0193                       ; Show dialog
0194                       ;------------------------------------------------------
0195 7D1C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D1E 3008 
0196 7D20 6006                   data bank3.rom        ; | i  p0 = bank address
0197 7D22 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0198 7D24 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0199                       ;------------------------------------------------------
0200                       ; Exit
0201                       ;------------------------------------------------------
0202 7D26 0460  28         b     @edkey.action.cmdb.show
     7D28 693A 
0203                                                   ; Show dialog in CMDB pane
0204               
0205               
0206               
0207               
0208               ***************************************************************
0209               * Stub for Dialog "Move/Copy/Delete block"
0210               * bank3 vec.5
0211               ********|*****|*********************|**************************
0212               dialog.block:
0213 7D2A 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D2C 77E8 
0214                       ;------------------------------------------------------
0215                       ; Show dialog
0216                       ;------------------------------------------------------
0217 7D2E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D30 3008 
0218 7D32 6006                   data bank3.rom        ; | i  p0 = bank address
0219 7D34 7FA4                   data vec.5            ; | i  p1 = Vector with target address
0220 7D36 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0221                       ;------------------------------------------------------
0222                       ; Exit
0223                       ;------------------------------------------------------
0224 7D38 0460  28         b     @edkey.action.cmdb.show
     7D3A 693A 
0225                                                   ; Show dialog in CMDB pane
0226               
0227               
0228               ***************************************************************
0229               * Stub for "fb.tab.next"
0230               * bank4 vec.1
0231               ********|*****|*********************|**************************
0232               fb.tab.next:
0233 7D3C 0649  14         dect  stack
0234 7D3E C64B  30         mov   r11,*stack            ; Save return address
0235                       ;------------------------------------------------------
0236                       ; Put cursor on next tab position
0237                       ;------------------------------------------------------
0238 7D40 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D42 3008 
0239 7D44 6008                   data bank4.rom        ; | i  p0 = bank address
0240 7D46 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0241 7D48 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0242                       ;------------------------------------------------------
0243                       ; Exit
0244                       ;------------------------------------------------------
0245 7D4A C2F9  30         mov   *stack+,r11           ; Pop r11
0246 7D4C 045B  20         b     *r11                  ; Return to caller
0247               
0248               
0249               ***************************************************************
0250               * Stub for "fb.ruler.init"
0251               * bank4 vec.2
0252               ********|*****|*********************|**************************
0253               fb.ruler.init:
0254 7D4E 0649  14         dect  stack
0255 7D50 C64B  30         mov   r11,*stack            ; Save return address
0256                       ;------------------------------------------------------
0257                       ; Setup ruler in memory
0258                       ;------------------------------------------------------
0259 7D52 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D54 3008 
0260 7D56 6008                   data bank4.rom        ; | i  p0 = bank address
0261 7D58 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0262 7D5A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0263                       ;------------------------------------------------------
0264                       ; Exit
0265                       ;------------------------------------------------------
0266 7D5C C2F9  30         mov   *stack+,r11           ; Pop r11
0267 7D5E 045B  20         b     *r11                  ; Return to caller
0268               
0269               
0270               ***************************************************************
0271               * Stub for "fb.colorlines"
0272               * bank4 vec.3
0273               ********|*****|*********************|**************************
0274               fb.colorlines:
0275 7D60 0649  14         dect  stack
0276 7D62 C64B  30         mov   r11,*stack            ; Save return address
0277                       ;------------------------------------------------------
0278                       ; Colorize frame buffer content
0279                       ;------------------------------------------------------
0280 7D64 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D66 3008 
0281 7D68 6008                   data bank4.rom        ; | i  p0 = bank address
0282 7D6A 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0283 7D6C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287 7D6E C2F9  30         mov   *stack+,r11           ; Pop r11
0288 7D70 045B  20         b     *r11                  ; Return to caller
0289               
0290               
0291               ***************************************************************
0292               * Stub for "fb.vdpdump"
0293               * bank4 vec.4
0294               ********|*****|*********************|**************************
0295               fb.vdpdump:
0296 7D72 0649  14         dect  stack
0297 7D74 C64B  30         mov   r11,*stack            ; Save return address
0298                       ;------------------------------------------------------
0299                       ; Colorize frame buffer content
0300                       ;------------------------------------------------------
0301 7D76 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D78 3008 
0302 7D7A 6008                   data bank4.rom        ; | i  p0 = bank address
0303 7D7C 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0304 7D7E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0305                       ;------------------------------------------------------
0306                       ; Exit
0307                       ;------------------------------------------------------
0308 7D80 C2F9  30         mov   *stack+,r11           ; Pop r11
0309 7D82 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.393026
0181                       ;-----------------------------------------------------------------------
0182                       ; Program data
0183                       ;-----------------------------------------------------------------------
0184                       copy  "data.keymap.actions.asm"    ; Data segment - Keyboard actions
**** **** ****     > data.keymap.actions.asm
0001               * FILE......: data.keymap.actions.asm
0002               * Purpose...: Keyboard actions
0003               
0004               *---------------------------------------------------------------
0005               * Action keys mapping table: Editor
0006               *---------------------------------------------------------------
0007               keymap_actions.editor:
0008                       ;-------------------------------------------------------
0009                       ; Movement keys
0010                       ;-------------------------------------------------------
0011 7D84 0D00             data  key.enter, pane.focus.fb, edkey.action.enter
     7D86 0000 
     7D88 6656 
0012 7D8A 0800             data  key.fctn.s, pane.focus.fb, edkey.action.left
     7D8C 0000 
     7D8E 6158 
0013 7D90 0900             data  key.fctn.d, pane.focus.fb, edkey.action.right
     7D92 0000 
     7D94 6172 
0014 7D96 0B00             data  key.fctn.e, pane.focus.fb, edkey.action.up
     7D98 0000 
     7D9A 6282 
0015 7D9C 0A00             data  key.fctn.x, pane.focus.fb, edkey.action.down
     7D9E 0000 
     7DA0 62DC 
0016 7DA2 BF00             data  key.fctn.h, pane.focus.fb, edkey.action.home
     7DA4 0000 
     7DA6 618E 
0017 7DA8 C000             data  key.fctn.j, pane.focus.fb, edkey.action.pword
     7DAA 0000 
     7DAC 61D0 
0018 7DAE C100             data  key.fctn.k, pane.focus.fb, edkey.action.nword
     7DB0 0000 
     7DB2 6222 
0019 7DB4 C200             data  key.fctn.l, pane.focus.fb, edkey.action.end
     7DB6 0000 
     7DB8 61AE 
0020 7DBA 8500             data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
     7DBC 0000 
     7DBE 6350 
0021 7DC0 9800             data  key.ctrl.x, pane.focus.fb, edkey.action.npage
     7DC2 0000 
     7DC4 638C 
0022 7DC6 9400             data  key.ctrl.t, pane.focus.fb, edkey.action.top
     7DC8 0000 
     7DCA 63C6 
0023 7DCC 8200             data  key.ctrl.b, pane.focus.fb, edkey.action.bot
     7DCE 0000 
     7DD0 63E2 
0024                       ;-------------------------------------------------------
0025                       ; Modifier keys - Delete
0026                       ;-------------------------------------------------------
0027 7DD2 0300             data  key.fctn.1, pane.focus.fb, edkey.action.del_char
     7DD4 0000 
     7DD6 6454 
0028 7DD8 0700             data  key.fctn.3, pane.focus.fb, edkey.action.del_line
     7DDA 0000 
     7DDC 6506 
0029 7DDE 0200             data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
     7DE0 0000 
     7DE2 64D2 
0030                       ;-------------------------------------------------------
0031                       ; Modifier keys - Insert
0032                       ;-------------------------------------------------------
0033 7DE4 0400             data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
     7DE6 0000 
     7DE8 6568 
0034 7DEA B900             data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
     7DEC 0000 
     7DEE 66CE 
0035 7DF0 0E00             data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
     7DF2 0000 
     7DF4 65E2 
0036 7DF6 0100             data  key.fctn.7, pane.focus.fb, edkey.action.fb.tab.next
     7DF8 0000 
     7DFA 688C 
0037                       ;-------------------------------------------------------
0038                       ; Block marking/modifier
0039                       ;-------------------------------------------------------
0040 7DFC 9600             data  key.ctrl.v, pane.focus.fb, edkey.action.block.mark
     7DFE 0000 
     7E00 67C6 
0041 7E02 9200             data  key.ctrl.r, pane.focus.fb, edkey.action.block.reset
     7E04 0000 
     7E06 67CE 
0042 7E08 8300             data  key.ctrl.c, pane.focus.fb, edkey.action.block.copy
     7E0A 0000 
     7E0C 67DA 
0043 7E0E 8400             data  key.ctrl.d, pane.focus.fb, edkey.action.block.delete
     7E10 0000 
     7E12 6816 
0044 7E14 8D00             data  key.ctrl.m, pane.focus.fb, edkey.action.block.move
     7E16 0000 
     7E18 6840 
0045 7E1A 8700             data  key.ctrl.g, pane.focus.fb, edkey.action.block.goto.m1
     7E1C 0000 
     7E1E 6872 
0046                       ;-------------------------------------------------------
0047                       ; Other action keys
0048                       ;-------------------------------------------------------
0049 7E20 0500             data  key.fctn.plus, pane.focus.fb, edkey.action.quit
     7E22 0000 
     7E24 6748 
0050 7E26 9500             data  key.ctrl.u, pane.focus.fb, edkey.action.toggle.ruler
     7E28 0000 
     7E2A 675A 
0051 7E2C 9A00             data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
     7E2E 0000 
     7E30 75FE 
0052                       ;-------------------------------------------------------
0053                       ; Dialog keys
0054                       ;-------------------------------------------------------
0055 7E32 8000             data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
     7E34 0000 
     7E36 6780 
0056 7E38 9B00             data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
     7E3A 0000 
     7E3C 678C 
0057 7E3E 8800             data  key.ctrl.h, pane.focus.fb, edkey.action.about
     7E40 0000 
     7E42 7CE2 
0058 7E44 9300             data  key.ctrl.s, pane.focus.fb, dialog.save
     7E46 0000 
     7E48 7D06 
0059 7E4A 8F00             data  key.ctrl.o, pane.focus.fb, dialog.load
     7E4C 0000 
     7E4E 7CF4 
0060                       ;-------------------------------------------------------
0061                       ; End of list
0062                       ;-------------------------------------------------------
0063 7E50 FFFF             data  EOL                           ; EOL
0064               
0065               
0066               
0067               
0068               *---------------------------------------------------------------
0069               * Action keys mapping table: Command Buffer (CMDB)
0070               *---------------------------------------------------------------
0071               keymap_actions.cmdb:
0072                       ;-------------------------------------------------------
0073                       ; Dialog specific: File load
0074                       ;-------------------------------------------------------
0075 7E52 0E00             data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
     7E54 000A 
     7E56 6A1A 
0076 7E58 0D00             data  key.enter, id.dialog.load, edkey.action.cmdb.load
     7E5A 000A 
     7E5C 694C 
0077                       ;-------------------------------------------------------
0078                       ; Dialog specific: Unsaved changes
0079                       ;-------------------------------------------------------
0080 7E5E 0C00             data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
     7E60 0065 
     7E62 69F0 
0081 7E64 0D00             data  key.enter, id.dialog.unsaved, dialog.save
     7E66 0065 
     7E68 7D06 
0082                       ;-------------------------------------------------------
0083                       ; Dialog specific: File save
0084                       ;-------------------------------------------------------
0085 7E6A 0D00             data  key.enter, id.dialog.save, edkey.action.cmdb.save
     7E6C 000B 
     7E6E 6990 
0086 7E70 0D00             data  key.enter, id.dialog.saveblock, edkey.action.cmdb.save
     7E72 000C 
     7E74 6990 
0087                       ;-------------------------------------------------------
0088                       ; Dialog specific: About
0089                       ;-------------------------------------------------------
0090 7E76 0F00             data  key.fctn.9, id.dialog.about, edkey.action.cmdb.close.about
     7E78 0067 
     7E7A 6A26 
0091 7E7C 0D00             data  key.enter, id.dialog.about, edkey.action.cmdb.close.about
     7E7E 0067 
     7E80 6A26 
0092                       ;-------------------------------------------------------
0093                       ; Movement keys
0094                       ;-------------------------------------------------------
0095 7E82 0800             data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
     7E84 0001 
     7E86 689A 
0096 7E88 0900             data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
     7E8A 0001 
     7E8C 68AC 
0097 7E8E BF00             data  key.fctn.h, pane.focus.cmdb, edkey.action.cmdb.home
     7E90 0001 
     7E92 68C4 
0098 7E94 C200             data  key.fctn.l, pane.focus.cmdb, edkey.action.cmdb.end
     7E96 0001 
     7E98 68D8 
0099                       ;-------------------------------------------------------
0100                       ; Modifier keys
0101                       ;-------------------------------------------------------
0102 7E9A 0700             data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
     7E9C 0001 
     7E9E 68F0 
0103                       ;-------------------------------------------------------
0104                       ; Other action keys
0105                       ;-------------------------------------------------------
0106 7EA0 0F00             data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
     7EA2 0001 
     7EA4 6A32 
0107 7EA6 0500             data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
     7EA8 0001 
     7EAA 6748 
0108 7EAC 9A00             data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
     7EAE 0001 
     7EB0 75FE 
0109                       ;------------------------------------------------------
0110                       ; End of list
0111                       ;-------------------------------------------------------
0112 7EB2 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.393026
0185                       ;-----------------------------------------------------------------------
0186                       ; Bank specific vector table
0187                       ;-----------------------------------------------------------------------
0191 7EB4 7EB4                   data $                ; Bank 1 ROM size OK.
0193                       ;-------------------------------------------------------
0194                       ; Vector table bank 1: >7f9c - >7fff
0195                       ;-------------------------------------------------------
0196                       copy  "rom.vectors.bank1.asm"
**** **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 6CC4     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0010 7F9E 6B7C     vec.2   data  idx.entry.update      ;    for index functions.
0011 7FA0 6C2A     vec.3   data  idx.entry.delete      ;
0012 7FA2 6BCE     vec.4   data  idx.pointer.get       ;
0013 7FA4 2026     vec.5   data  cpu.crash             ;
0014 7FA6 2026     vec.6   data  cpu.crash             ;
0015 7FA8 2026     vec.7   data  cpu.crash             ;
0016 7FAA 2026     vec.8   data  cpu.crash             ;
0017 7FAC 2026     vec.9   data  cpu.crash             ;
0018 7FAE 6DAC     vec.10  data  edb.line.pack.fb      ;
0019 7FB0 6EA4     vec.11  data  edb.line.unpack.fb    ;
0020 7FB2 2026     vec.12  data  cpu.crash             ;
0021 7FB4 2026     vec.13  data  cpu.crash             ;
0022 7FB6 2026     vec.14  data  cpu.crash             ;
0023 7FB8 693A     vec.15  data  edkey.action.cmdb.show
0024 7FBA 2026     vec.16  data  cpu.crash             ;
0025 7FBC 2026     vec.17  data  cpu.crash             ;
0026 7FBE 2026     vec.18  data  cpu.crash             ;
0027 7FC0 73EC     vec.19  data  cmdb.cmd.clear        ;
0028 7FC2 6AD0     vec.20  data  fb.refresh            ;
0029 7FC4 7D72     vec.21  data  fb.vdpdump            ;
0030 7FC6 2026     vec.22  data  cpu.crash             ;
0031 7FC8 2026     vec.23  data  cpu.crash             ;
0032 7FCA 2026     vec.24  data  cpu.crash             ;
0033 7FCC 2026     vec.25  data  cpu.crash             ;
0034 7FCE 2026     vec.26  data  cpu.crash             ;
0035 7FD0 2026     vec.27  data  cpu.crash             ;
0036 7FD2 7806     vec.28  data  pane.cursor.blink     ;
0037 7FD4 77E8     vec.29  data  pane.cursor.hide      ;
0038 7FD6 7A94     vec.30  data  pane.errline.show     ;
0039 7FD8 765C     vec.31  data  pane.action.colorscheme.load
0040 7FDA 77CE     vec.32  data  pane.action.colorscheme.statlines
**** **** ****     > stevie_b1.asm.393026
0197               
0198               
0199               
0200               
0201               *--------------------------------------------------------------
0202               * Video mode configuration
0203               *--------------------------------------------------------------
0204      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0205      0004     spfbck  equ   >04                   ; Screen background color.
0206      339A     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0207      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0208      0050     colrow  equ   80                    ; Columns per row
0209      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0210      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0211      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0212      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

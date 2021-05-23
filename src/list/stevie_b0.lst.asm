XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b0.asm.3171309
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b0.asm               ; Version 210523-3171309
0010               *
0011               * Bank 0 "Jill"
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
0029               ;device.f18a.mode.30x80    equ  0       ; F18a 30 rows mode on
0030               ;device.fg99.mode.adv      equ  0       ; FG99 advanced mode on
0031               
0032               
0033               *--------------------------------------------------------------
0034               * JS99er F18a 30x80, FG99 advanced mode
0035               *--------------------------------------------------------------
0036      0001     device.f18a.mode.30x80    equ  1       ; F18a 30 rows mode on
0037      0001     device.fg99.mode.adv      equ  1       ; FG99 advanced mode on
**** **** ****     > stevie_b0.asm.3171309
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
**** **** ****     > stevie_b0.asm.3171309
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
0087               
0088      001D     pane.botrow               equ  29      ; Bottom row on screen
0089               
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
0108      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0109                                                      ; VDP TAT address of 1st CMDB row
0110      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
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
**** **** ****     > stevie_b0.asm.3171309
0017               
0018               ***************************************************************
0019               * Spectra2 core configuration
0020               ********|*****|*********************|**************************
0021      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0022                                                   ; grows downwards to >2000
0023               ***************************************************************
0024               * BANK 0
0025               ********|*****|*********************|**************************
0026      6000     bankid  equ   bank0.rom             ; Set bank identifier to current bank
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
0035               
0037               
0038 6010 1653             byte  22
0039 6011 ....             text  'STEVIE 1.1H (30X80+AM)'
0040                       even
0041               
0049               
**** **** ****     > stevie_b0.asm.3171309
0030               
0031               ***************************************************************
0032               * Step 1: Switch to bank 0 (uniform code accross all banks)
0033               ********|*****|*********************|**************************
0034                       aorg  kickstart.code1       ; >6030
0035               kickstart.step1:
0036 6030 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6032 6000 
0037               ***************************************************************
0038               * Step 2: Copy SP2 library from ROM to >2000 - >2fff
0039               ********|*****|*********************|**************************
0040               kickstart.step2:
0041 6034 0200  20         li    r0,reloc.sp2          ; Start of code to relocate
     6036 6096 
0042 6038 0201  20         li    r1,>2000
     603A 2000 
0043 603C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     603E 0100 
0044 6040 06A0  32         bl    @kickstart.copy       ; Copy memory
     6042 6064 
0045               ***************************************************************
0046               * Step 3: Copy Stevie resident modules from ROM to >3000 - >3fff
0047               ********|*****|*********************|**************************
0048               kickstart.step3:
0049 6044 0200  20         li    r0,reloc.stevie       ; Start of code to relocate
     6046 70C6 
0050 6048 0201  20         li    r1,>3000
     604A 3000 
0051 604C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     604E 0100 
0052 6050 06A0  32         bl    @kickstart.copy       ; Copy memory
     6052 6064 
0053               ***************************************************************
0054               * Step 4: Start SP2 kernel (runs in low MEMEXP)
0055               ********|*****|*********************|**************************
0056               kickstart.step4:
0057 6054 0460  28         b     @runlib               ; Start spectra2 library
     6056 2E48 
0058                       ;------------------------------------------------------
0059                       ; Assert. Should not get here! Crash and burn!
0060                       ;------------------------------------------------------
0061 6058 0200  20         li    r0,$                  ; Current location
     605A 6058 
0062 605C C800  38         mov   r0,@>ffce             ; \ Save caller address
     605E FFCE 
0063 6060 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6062 2026 
0064               ***************************************************************
0065               * Step 5: Handover from SP2 to Stevie "main" in low MEMEXP
0066               ********|*****|*********************|**************************
0067                       ; "main" in low MEMEXP is automatically called by SP2 runlib.
0068               
0069               ***************************************************************
0070               * Copy routine
0071               ********|*****|*********************|**************************
0072               kickstart.copy:
0073                       ;------------------------------------------------------
0074                       ; Copy memory to destination
0075                       ; r0 = Source CPU address
0076                       ; r1 = Target CPU address
0077                       ; r2 = Bytes to copy/16
0078                       ;------------------------------------------------------
0079 6064 CC70  46 !       mov   *r0+,*r1+             ; Copy word 1
0080 6066 CC70  46         mov   *r0+,*r1+             ; Copy word 2
0081 6068 CC70  46         mov   *r0+,*r1+             ; Copy word 3
0082 606A CC70  46         mov   *r0+,*r1+             ; Copy word 4
0083 606C CC70  46         mov   *r0+,*r1+             ; Copy word 5
0084 606E CC70  46         mov   *r0+,*r1+             ; Copy word 6
0085 6070 CC70  46         mov   *r0+,*r1+             ; Copy word 7
0086 6072 CC70  46         mov   *r0+,*r1+             ; Copy word 8
0087 6074 0602  14         dec   r2
0088 6076 16F6  14         jne   -!                    ; Loop until done
0089 6078 045B  20         b     *r11                  ; Return to caller
0090               
0091               
0092               
0093               ***************************************************************
0094               * Load character patterns
0095               ********|*****|*********************|**************************
0096               vdp.patterns.dump:
0097 607A 0649  14         dect  stack
0098 607C C64B  30         mov   r11,*stack            ; Push return address
0099                       ;-------------------------------------------------------
0100                       ; Dump sprite patterns from ROM to VDP SDT
0101                       ;-------------------------------------------------------
0102 607E 06A0  32         bl    @cpym2v
     6080 248A 
0103 6082 2800                   data sprpdt,cursors,5*8
     6084 38F8 
     6086 0028 
0104                       ;-------------------------------------------------------
0105                       ; Dump character patterns from ROM to VDP PDT
0106                       ;-------------------------------------------------------
0107 6088 06A0  32         bl    @cpym2v
     608A 248A 
0108 608C 1008                   data >1008,patterns,25*8
     608E 3920 
     6090 00C8 
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               vdp.patterns.dump.exit:
0113 6092 C2F9  30         mov   *stack+,r11           ; Pop R11
0114 6094 045B  20         b     *r11                  ; Return to task
0115               
0116               
0117               
0118               
0119               ***************************************************************
0120               * Code data: Relocated code SP2 >2000 - >2eff (3840 bytes max)
0121               ********|*****|*********************|**************************
0122               reloc.sp2:
0123                       xorg  >2000                 ; Relocate SP2 code to >2000
0124                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0012 6096 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 6098 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 609A 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 609C 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 609E 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 60A0 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 60A2 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 60A4 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 60A6 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 60A8 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 60AA 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 60AC 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 60AE 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 60B0 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 60B2 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 60B4 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 60B6 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 60B8 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 60BA D000     w$d000  data  >d000                 ; >d000
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
0038 60BC 022B  22         ai    r11,-4                ; Remove opcode offset
     60BE FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 60C0 C800  38         mov   r0,@>ffe0
     60C2 FFE0 
0043 60C4 C801  38         mov   r1,@>ffe2
     60C6 FFE2 
0044 60C8 C802  38         mov   r2,@>ffe4
     60CA FFE4 
0045 60CC C803  38         mov   r3,@>ffe6
     60CE FFE6 
0046 60D0 C804  38         mov   r4,@>ffe8
     60D2 FFE8 
0047 60D4 C805  38         mov   r5,@>ffea
     60D6 FFEA 
0048 60D8 C806  38         mov   r6,@>ffec
     60DA FFEC 
0049 60DC C807  38         mov   r7,@>ffee
     60DE FFEE 
0050 60E0 C808  38         mov   r8,@>fff0
     60E2 FFF0 
0051 60E4 C809  38         mov   r9,@>fff2
     60E6 FFF2 
0052 60E8 C80A  38         mov   r10,@>fff4
     60EA FFF4 
0053 60EC C80B  38         mov   r11,@>fff6
     60EE FFF6 
0054 60F0 C80C  38         mov   r12,@>fff8
     60F2 FFF8 
0055 60F4 C80D  38         mov   r13,@>fffa
     60F6 FFFA 
0056 60F8 C80E  38         mov   r14,@>fffc
     60FA FFFC 
0057 60FC C80F  38         mov   r15,@>ffff
     60FE FFFF 
0058 6100 02A0  12         stwp  r0
0059 6102 C800  38         mov   r0,@>ffdc
     6104 FFDC 
0060 6106 02C0  12         stst  r0
0061 6108 C800  38         mov   r0,@>ffde
     610A FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 610C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     610E 8300 
0067 6110 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6112 8302 
0068 6114 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     6116 4A4A 
0069 6118 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     611A 2E4C 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 611C 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     611E 22FC 
0078 6120 21EC                   data graph1           ; Equate selected video mode table
0079               
0080 6122 06A0  32         bl    @ldfnt
     6124 2364 
0081 6126 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     6128 000C 
0082               
0083 612A 06A0  32         bl    @filv
     612C 2292 
0084 612E 0380                   data >0380,>f0,32*24  ; Load color table
     6130 00F0 
     6132 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 6134 06A0  32         bl    @putat                ; Show crash message
     6136 2446 
0089 6138 0000                   data >0000,cpu.crash.msg.crashed
     613A 2178 
0090               
0091 613C 06A0  32         bl    @puthex               ; Put hex value on screen
     613E 29D0 
0092 6140 0015                   byte 0,21             ; \ i  p0 = YX position
0093 6142 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 6144 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 6146 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 6148 06A0  32         bl    @putat                ; Show caller message
     614A 2446 
0101 614C 0100                   data >0100,cpu.crash.msg.caller
     614E 218E 
0102               
0103 6150 06A0  32         bl    @puthex               ; Put hex value on screen
     6152 29D0 
0104 6154 0115                   byte 1,21             ; \ i  p0 = YX position
0105 6156 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 6158 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 615A 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 615C 06A0  32         bl    @putat
     615E 2446 
0113 6160 0300                   byte 3,0
0114 6162 21AA                   data cpu.crash.msg.wp
0115 6164 06A0  32         bl    @putat
     6166 2446 
0116 6168 0400                   byte 4,0
0117 616A 21B0                   data cpu.crash.msg.st
0118 616C 06A0  32         bl    @putat
     616E 2446 
0119 6170 1600                   byte 22,0
0120 6172 21B6                   data cpu.crash.msg.source
0121 6174 06A0  32         bl    @putat
     6176 2446 
0122 6178 1700                   byte 23,0
0123 617A 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 617C 06A0  32         bl    @at                   ; Put cursor at YX
     617E 26D2 
0128 6180 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 6182 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6184 FFDC 
0132 6186 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 6188 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 618A 0649  14         dect  stack
0138 618C C644  30         mov   tmp0,*stack           ; Push tmp0
0139 618E 0649  14         dect  stack
0140 6190 C645  30         mov   tmp1,*stack           ; Push tmp1
0141 6192 0649  14         dect  stack
0142 6194 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 6196 C046  18         mov   tmp2,r1               ; Save register number
0148 6198 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     619A 0001 
0149 619C 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 619E 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 61A0 06A0  32         bl    @mknum
     61A2 29DA 
0154 61A4 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 61A6 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 61A8 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 61AA 06A0  32         bl    @setx                 ; Set cursor X position
     61AC 26E8 
0160 61AE 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 61B0 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61B2 2422 
0164 61B4 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 61B6 06A0  32         bl    @setx                 ; Set cursor X position
     61B8 26E8 
0168 61BA 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 61BC 0281  22         ci    r1,10
     61BE 000A 
0172 61C0 1102  14         jlt   !
0173 61C2 0620  34         dec   @wyx                  ; x=x-1
     61C4 832A 
0174               
0175 61C6 06A0  32 !       bl    @putstr
     61C8 2422 
0176 61CA 21A4                   data cpu.crash.msg.r
0177               
0178 61CC 06A0  32         bl    @mknum
     61CE 29DA 
0179 61D0 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 61D2 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 61D4 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 61D6 06A0  32         bl    @mkhex                ; Convert hex word to string
     61D8 294C 
0188 61DA 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 61DC 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 61DE 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 61E0 06A0  32         bl    @setx                 ; Set cursor X position
     61E2 26E8 
0194 61E4 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 61E6 06A0  32         bl    @putstr               ; Put '  >'
     61E8 2422 
0198 61EA 21A6                   data cpu.crash.msg.marker
0199               
0200 61EC 06A0  32         bl    @setx                 ; Set cursor X position
     61EE 26E8 
0201 61F0 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61F2 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61F4 2422 
0205 61F6 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61F8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61FA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61FE 06A0  32         bl    @down                 ; y=y+1
     6200 26D8 
0213               
0214 6202 0586  14         inc   tmp2
0215 6204 0286  22         ci    tmp2,17
     6206 0011 
0216 6208 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 620A 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     620C 2D4A 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 620E 1553             byte  21
0225 620F ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 6224 1543             byte  21
0230 6225 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 623A 0152             byte  1
0235 623B ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 623C 0320             byte  3
0240 623D ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 6240 042A             byte  4
0245 6241 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 6246 042A             byte  4
0250 6247 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 624C 1B53             byte  27
0255 624D ....             text  'Source    stevie_b0.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 6268 1842             byte  24
0260 6269 ....             text  'Build-ID  210523-3171309'
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
0007 6282 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6284 000E 
     6286 0106 
     6288 0204 
     628A 0020 
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
0032 628C 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     628E 000E 
     6290 0106 
     6292 00F4 
     6294 0028 
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
0058 6296 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6298 003F 
     629A 0240 
     629C 03F4 
     629E 0050 
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
0084 62A0 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     62A2 003F 
     62A4 0240 
     62A6 03F4 
     62A8 0050 
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
0013 62AA 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 62AC 16FD             data  >16fd                 ; |         jne   mcloop
0015 62AE 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 62B0 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 62B2 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 62B4 0201  20         li    r1,mccode             ; Machinecode to patch
     62B6 2214 
0037 62B8 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     62BA 8322 
0038 62BC CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 62BE CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 62C0 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 62C2 045B  20         b     *r11                  ; Return to caller
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
0056 62C4 C0F9  30 popr3   mov   *stack+,r3
0057 62C6 C0B9  30 popr2   mov   *stack+,r2
0058 62C8 C079  30 popr1   mov   *stack+,r1
0059 62CA C039  30 popr0   mov   *stack+,r0
0060 62CC C2F9  30 poprt   mov   *stack+,r11
0061 62CE 045B  20         b     *r11
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
0085 62D0 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 62D2 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 62D4 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 62D6 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 62D8 1604  14         jne   filchk                ; No, continue checking
0093               
0094 62DA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     62DC FFCE 
0095 62DE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     62E0 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 62E2 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     62E4 830B 
     62E6 830A 
0100               
0101 62E8 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62EA 0001 
0102 62EC 1602  14         jne   filchk2
0103 62EE DD05  32         movb  tmp1,*tmp0+
0104 62F0 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 62F2 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     62F4 0002 
0109 62F6 1603  14         jne   filchk3
0110 62F8 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 62FA DD05  32         movb  tmp1,*tmp0+
0112 62FC 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 62FE C1C4  18 filchk3 mov   tmp0,tmp3
0117 6300 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6302 0001 
0118 6304 1305  14         jeq   fil16b
0119 6306 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 6308 0606  14         dec   tmp2
0121 630A 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     630C 0002 
0122 630E 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 6310 C1C6  18 fil16b  mov   tmp2,tmp3
0127 6312 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6314 0001 
0128 6316 1301  14         jeq   dofill
0129 6318 0606  14         dec   tmp2                  ; Make TMP2 even
0130 631A CD05  34 dofill  mov   tmp1,*tmp0+
0131 631C 0646  14         dect  tmp2
0132 631E 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 6320 C1C7  18         mov   tmp3,tmp3
0137 6322 1301  14         jeq   fil.exit
0138 6324 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 6326 045B  20         b     *r11
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
0159 6328 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 632A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 632C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 632E 0264  22 xfilv   ori   tmp0,>4000
     6330 4000 
0166 6332 06C4  14         swpb  tmp0
0167 6334 D804  38         movb  tmp0,@vdpa
     6336 8C02 
0168 6338 06C4  14         swpb  tmp0
0169 633A D804  38         movb  tmp0,@vdpa
     633C 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 633E 020F  20         li    r15,vdpw              ; Set VDP write address
     6340 8C00 
0174 6342 06C5  14         swpb  tmp1
0175 6344 C820  54         mov   @filzz,@mcloop        ; Setup move command
     6346 22B8 
     6348 8320 
0176 634A 0460  28         b     @mcloop               ; Write data to VDP
     634C 8320 
0177               *--------------------------------------------------------------
0181 634E D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 6350 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     6352 4000 
0202 6354 06C4  14 vdra    swpb  tmp0
0203 6356 D804  38         movb  tmp0,@vdpa
     6358 8C02 
0204 635A 06C4  14         swpb  tmp0
0205 635C D804  38         movb  tmp0,@vdpa            ; Set VDP address
     635E 8C02 
0206 6360 045B  20         b     *r11                  ; Exit
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
0217 6362 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 6364 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 6366 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6368 4000 
0223 636A 06C4  14         swpb  tmp0                  ; \
0224 636C D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     636E 8C02 
0225 6370 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 6372 D804  38         movb  tmp0,@vdpa            ; /
     6374 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 6376 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 6378 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 637A 045B  20         b     *r11                  ; Exit
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
0251 637C C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 637E 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 6380 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6382 8C02 
0257 6384 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 6386 D804  38         movb  tmp0,@vdpa            ; /
     6388 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 638A D120  34         movb  @vdpr,tmp0            ; Read byte
     638C 8800 
0263 638E 0984  56         srl   tmp0,8                ; Right align
0264 6390 045B  20         b     *r11                  ; Exit
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
0283 6392 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 6394 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 6396 C144  18         mov   tmp0,tmp1
0289 6398 05C5  14         inct  tmp1
0290 639A D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 639C 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     639E FF00 
0292 63A0 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 63A2 C805  38         mov   tmp1,@wbase           ; Store calculated base
     63A4 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 63A6 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     63A8 8000 
0298 63AA 0206  20         li    tmp2,8
     63AC 0008 
0299 63AE D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     63B0 830B 
0300 63B2 06C5  14         swpb  tmp1
0301 63B4 D805  38         movb  tmp1,@vdpa
     63B6 8C02 
0302 63B8 06C5  14         swpb  tmp1
0303 63BA D805  38         movb  tmp1,@vdpa
     63BC 8C02 
0304 63BE 0225  22         ai    tmp1,>0100
     63C0 0100 
0305 63C2 0606  14         dec   tmp2
0306 63C4 16F4  14         jne   vidta1                ; Next register
0307 63C6 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     63C8 833A 
0308 63CA 045B  20         b     *r11
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
0325 63CC C13B  30 putvr   mov   *r11+,tmp0
0326 63CE 0264  22 putvrx  ori   tmp0,>8000
     63D0 8000 
0327 63D2 06C4  14         swpb  tmp0
0328 63D4 D804  38         movb  tmp0,@vdpa
     63D6 8C02 
0329 63D8 06C4  14         swpb  tmp0
0330 63DA D804  38         movb  tmp0,@vdpa
     63DC 8C02 
0331 63DE 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 63E0 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 63E2 C10E  18         mov   r14,tmp0
0341 63E4 0984  56         srl   tmp0,8
0342 63E6 06A0  32         bl    @putvrx               ; Write VR#0
     63E8 2338 
0343 63EA 0204  20         li    tmp0,>0100
     63EC 0100 
0344 63EE D820  54         movb  @r14lb,@tmp0lb
     63F0 831D 
     63F2 8309 
0345 63F4 06A0  32         bl    @putvrx               ; Write VR#1
     63F6 2338 
0346 63F8 0458  20         b     *tmp4                 ; Exit
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
0360 63FA C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 63FC 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 63FE C11B  26         mov   *r11,tmp0             ; Get P0
0363 6400 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6402 7FFF 
0364 6404 2120  38         coc   @wbit0,tmp0
     6406 2020 
0365 6408 1604  14         jne   ldfnt1
0366 640A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     640C 8000 
0367 640E 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6410 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 6412 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6414 23E6 
0372 6416 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6418 9C02 
0373 641A 06C4  14         swpb  tmp0
0374 641C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     641E 9C02 
0375 6420 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6422 9800 
0376 6424 06C5  14         swpb  tmp1
0377 6426 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     6428 9800 
0378 642A 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 642C D805  38         movb  tmp1,@grmwa
     642E 9C02 
0383 6430 06C5  14         swpb  tmp1
0384 6432 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6434 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 6436 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 6438 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     643A 22BA 
0390 643C 05C8  14         inct  tmp4                  ; R11=R11+2
0391 643E C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 6440 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     6442 7FFF 
0393 6444 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     6446 23E8 
0394 6448 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     644A 23EA 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 644C 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 644E 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 6450 D120  34         movb  @grmrd,tmp0
     6452 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 6454 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     6456 2020 
0405 6458 1603  14         jne   ldfnt3                ; No, so skip
0406 645A D1C4  18         movb  tmp0,tmp3
0407 645C 0917  56         srl   tmp3,1
0408 645E E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 6460 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6462 8C00 
0413 6464 0606  14         dec   tmp2
0414 6466 16F2  14         jne   ldfnt2
0415 6468 05C8  14         inct  tmp4                  ; R11=R11+2
0416 646A 020F  20         li    r15,vdpw              ; Set VDP write address
     646C 8C00 
0417 646E 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6470 7FFF 
0418 6472 0458  20         b     *tmp4                 ; Exit
0419 6474 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     6476 2000 
     6478 8C00 
0420 647A 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 647C 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     647E 0200 
     6480 0000 
0425 6482 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6484 01C0 
     6486 0101 
0426 6488 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     648A 02A0 
     648C 0101 
0427 648E 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6490 00E0 
     6492 0101 
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
0445 6494 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 6496 C3A0  34         mov   @wyx,r14              ; Get YX
     6498 832A 
0447 649A 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 649C 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     649E 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 64A0 C3A0  34         mov   @wyx,r14              ; Get YX
     64A2 832A 
0454 64A4 024E  22         andi  r14,>00ff             ; Remove Y
     64A6 00FF 
0455 64A8 A3CE  18         a     r14,r15               ; pos = pos + X
0456 64AA A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     64AC 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 64AE C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 64B0 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 64B2 020F  20         li    r15,vdpw              ; VDP write address
     64B4 8C00 
0463 64B6 045B  20         b     *r11
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
0481 64B8 C17B  30 putstr  mov   *r11+,tmp1
0482 64BA D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 64BC C1CB  18 xutstr  mov   r11,tmp3
0484 64BE 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     64C0 23FE 
0485 64C2 C2C7  18         mov   tmp3,r11
0486 64C4 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 64C6 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 64C8 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 64CA 0286  22         ci    tmp2,255              ; Length > 255 ?
     64CC 00FF 
0494 64CE 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 64D0 0460  28         b     @xpym2v               ; Display string
     64D2 2490 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 64D4 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     64D6 FFCE 
0501 64D8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64DA 2026 
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
0517 64DC C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     64DE 832A 
0518 64E0 0460  28         b     @putstr
     64E2 2422 
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
0539 64E4 0649  14         dect  stack
0540 64E6 C64B  30         mov   r11,*stack            ; Save return address
0541 64E8 0649  14         dect  stack
0542 64EA C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 64EC D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 64EE 0987  56         srl   tmp3,8                ; Right align
0549               
0550 64F0 0649  14         dect  stack
0551 64F2 C645  30         mov   tmp1,*stack           ; Push tmp1
0552 64F4 0649  14         dect  stack
0553 64F6 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 64F8 0649  14         dect  stack
0555 64FA C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 64FC 06A0  32         bl    @xutst0               ; Display string
     64FE 2424 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 6500 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 6502 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 6504 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 6506 06A0  32         bl    @down                 ; Move cursor down
     6508 26D8 
0566               
0567 650A A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 650C 0585  14         inc   tmp1                  ; Consider length byte
0569 650E 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     6510 2002 
0570 6512 1301  14         jeq   !                     ; Yes, skip adjustment
0571 6514 0585  14         inc   tmp1                  ; Make address even
0572 6516 0606  14 !       dec   tmp2
0573 6518 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 651A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 651C C2F9  30         mov   *stack+,r11           ; Pop r11
0580 651E 045B  20         b     *r11                  ; Return
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
0020 6520 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6522 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6524 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 6526 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 6528 1604  14         jne   !                     ; No, continue
0028               
0029 652A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     652C FFCE 
0030 652E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6530 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 6532 0264  22 !       ori   tmp0,>4000
     6534 4000 
0035 6536 06C4  14         swpb  tmp0
0036 6538 D804  38         movb  tmp0,@vdpa
     653A 8C02 
0037 653C 06C4  14         swpb  tmp0
0038 653E D804  38         movb  tmp0,@vdpa
     6540 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 6542 020F  20         li    r15,vdpw              ; Set VDP write address
     6544 8C00 
0043 6546 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6548 24BA 
     654A 8320 
0044 654C 0460  28         b     @mcloop               ; Write data to VDP and return
     654E 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 6550 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6552 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6554 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6556 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6558 06C4  14 xpyv2m  swpb  tmp0
0027 655A D804  38         movb  tmp0,@vdpa
     655C 8C02 
0028 655E 06C4  14         swpb  tmp0
0029 6560 D804  38         movb  tmp0,@vdpa
     6562 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6564 020F  20         li    r15,vdpr              ; Set VDP read address
     6566 8800 
0034 6568 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     656A 24DC 
     656C 8320 
0035 656E 0460  28         b     @mcloop               ; Read data from VDP
     6570 8320 
0036 6572 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6574 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6576 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6578 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 657A C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 657C 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 657E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6580 FFCE 
0034 6582 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6584 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6586 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6588 0001 
0039 658A 1603  14         jne   cpym0                 ; No, continue checking
0040 658C DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 658E 04C6  14         clr   tmp2                  ; Reset counter
0042 6590 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6592 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6594 7FFF 
0047 6596 C1C4  18         mov   tmp0,tmp3
0048 6598 0247  22         andi  tmp3,1
     659A 0001 
0049 659C 1618  14         jne   cpyodd                ; Odd source address handling
0050 659E C1C5  18 cpym1   mov   tmp1,tmp3
0051 65A0 0247  22         andi  tmp3,1
     65A2 0001 
0052 65A4 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 65A6 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     65A8 2020 
0057 65AA 1605  14         jne   cpym3
0058 65AC C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     65AE 253E 
     65B0 8320 
0059 65B2 0460  28         b     @mcloop               ; Copy memory and exit
     65B4 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 65B6 C1C6  18 cpym3   mov   tmp2,tmp3
0064 65B8 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     65BA 0001 
0065 65BC 1301  14         jeq   cpym4
0066 65BE 0606  14         dec   tmp2                  ; Make TMP2 even
0067 65C0 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 65C2 0646  14         dect  tmp2
0069 65C4 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 65C6 C1C7  18         mov   tmp3,tmp3
0074 65C8 1301  14         jeq   cpymz
0075 65CA D554  38         movb  *tmp0,*tmp1
0076 65CC 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 65CE 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     65D0 8000 
0081 65D2 10E9  14         jmp   cpym2
0082 65D4 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 65D6 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 65D8 0649  14         dect  stack
0065 65DA C64B  30         mov   r11,*stack            ; Push return address
0066 65DC 0649  14         dect  stack
0067 65DE C640  30         mov   r0,*stack             ; Push r0
0068 65E0 0649  14         dect  stack
0069 65E2 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 65E4 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 65E6 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 65E8 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     65EA 4000 
0077 65EC C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     65EE 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 65F0 020C  20         li    r12,>1e00             ; SAMS CRU address
     65F2 1E00 
0082 65F4 04C0  14         clr   r0
0083 65F6 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 65F8 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 65FA D100  18         movb  r0,tmp0
0086 65FC 0984  56         srl   tmp0,8                ; Right align
0087 65FE C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     6600 833C 
0088 6602 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 6604 C339  30         mov   *stack+,r12           ; Pop r12
0094 6606 C039  30         mov   *stack+,r0            ; Pop r0
0095 6608 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 660A 045B  20         b     *r11                  ; Return to caller
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
0131 660C C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 660E C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 6610 0649  14         dect  stack
0135 6612 C64B  30         mov   r11,*stack            ; Push return address
0136 6614 0649  14         dect  stack
0137 6616 C640  30         mov   r0,*stack             ; Push r0
0138 6618 0649  14         dect  stack
0139 661A C64C  30         mov   r12,*stack            ; Push r12
0140 661C 0649  14         dect  stack
0141 661E C644  30         mov   tmp0,*stack           ; Push tmp0
0142 6620 0649  14         dect  stack
0143 6622 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 6624 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 6626 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 6628 0284  22         ci    tmp0,255              ; Crash if page > 255
     662A 00FF 
0153 662C 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 662E 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     6630 001E 
0158 6632 150A  14         jgt   !
0159 6634 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     6636 0004 
0160 6638 1107  14         jlt   !
0161 663A 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     663C 0012 
0162 663E 1508  14         jgt   sams.page.set.switch_page
0163 6640 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     6642 0006 
0164 6644 1501  14         jgt   !
0165 6646 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 6648 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     664A FFCE 
0170 664C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     664E 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 6650 020C  20         li    r12,>1e00             ; SAMS CRU address
     6652 1E00 
0176 6654 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 6656 06C0  14         swpb  r0                    ; LSB to MSB
0178 6658 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 665A D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     665C 4000 
0180 665E 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 6660 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 6662 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 6664 C339  30         mov   *stack+,r12           ; Pop r12
0188 6666 C039  30         mov   *stack+,r0            ; Pop r0
0189 6668 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 666A 045B  20         b     *r11                  ; Return to caller
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
0204 666C 020C  20         li    r12,>1e00             ; SAMS CRU address
     666E 1E00 
0205 6670 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 6672 045B  20         b     *r11                  ; Return to caller
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
0227 6674 020C  20         li    r12,>1e00             ; SAMS CRU address
     6676 1E00 
0228 6678 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 667A 045B  20         b     *r11                  ; Return to caller
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
0260 667C C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 667E 0649  14         dect  stack
0263 6680 C64B  30         mov   r11,*stack            ; Save return address
0264 6682 0649  14         dect  stack
0265 6684 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 6686 0649  14         dect  stack
0267 6688 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 668A 0649  14         dect  stack
0269 668C C646  30         mov   tmp2,*stack           ; Save tmp2
0270 668E 0649  14         dect  stack
0271 6690 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 6692 0206  20         li    tmp2,8                ; Set loop counter
     6694 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 6696 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 6698 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 669A 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     669C 257A 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 669E 0606  14         dec   tmp2                  ; Next iteration
0288 66A0 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 66A2 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     66A4 25D6 
0294                                                   ; / activating changes.
0295               
0296 66A6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 66A8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 66AA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 66AC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 66AE C2F9  30         mov   *stack+,r11           ; Pop r11
0301 66B0 045B  20         b     *r11                  ; Return to caller
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
0318 66B2 0649  14         dect  stack
0319 66B4 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 66B6 06A0  32         bl    @sams.layout
     66B8 25E6 
0324 66BA 262A                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 66BC C2F9  30         mov   *stack+,r11           ; Pop r11
0330 66BE 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 66C0 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     66C2 0002 
0336 66C4 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     66C6 0003 
0337 66C8 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     66CA 000A 
0338 66CC B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     66CE 000B 
0339 66D0 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     66D2 000C 
0340 66D4 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     66D6 000D 
0341 66D8 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     66DA 000E 
0342 66DC F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     66DE 000F 
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
0363 66E0 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 66E2 0649  14         dect  stack
0366 66E4 C64B  30         mov   r11,*stack            ; Push return address
0367 66E6 0649  14         dect  stack
0368 66E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 66EA 0649  14         dect  stack
0370 66EC C645  30         mov   tmp1,*stack           ; Push tmp1
0371 66EE 0649  14         dect  stack
0372 66F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 66F2 0649  14         dect  stack
0374 66F4 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 66F6 0205  20         li    tmp1,sams.layout.copy.data
     66F8 2682 
0379 66FA 0206  20         li    tmp2,8                ; Set loop counter
     66FC 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66FE C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 6700 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     6702 2542 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 6704 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     6706 833C 
0390               
0391 6708 0606  14         dec   tmp2                  ; Next iteration
0392 670A 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 670C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 670E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 6710 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 6712 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 6714 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 6716 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 6718 2000             data  >2000                 ; >2000-2fff
0408 671A 3000             data  >3000                 ; >3000-3fff
0409 671C A000             data  >a000                 ; >a000-afff
0410 671E B000             data  >b000                 ; >b000-bfff
0411 6720 C000             data  >c000                 ; >c000-cfff
0412 6722 D000             data  >d000                 ; >d000-dfff
0413 6724 E000             data  >e000                 ; >e000-efff
0414 6726 F000             data  >f000                 ; >f000-ffff
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
0009 6728 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     672A FFBF 
0010 672C 0460  28         b     @putv01
     672E 234A 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 6730 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6732 0040 
0018 6734 0460  28         b     @putv01
     6736 234A 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 6738 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     673A FFDF 
0026 673C 0460  28         b     @putv01
     673E 234A 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 6740 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6742 0020 
0034 6744 0460  28         b     @putv01
     6746 234A 
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
0010 6748 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     674A FFFE 
0011 674C 0460  28         b     @putv01
     674E 234A 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6750 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6752 0001 
0019 6754 0460  28         b     @putv01
     6756 234A 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6758 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     675A FFFD 
0027 675C 0460  28         b     @putv01
     675E 234A 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6760 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6762 0002 
0035 6764 0460  28         b     @putv01
     6766 234A 
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
0018 6768 C83B  50 at      mov   *r11+,@wyx
     676A 832A 
0019 676C 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 676E B820  54 down    ab    @hb$01,@wyx
     6770 2012 
     6772 832A 
0028 6774 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6776 7820  54 up      sb    @hb$01,@wyx
     6778 2012 
     677A 832A 
0037 677C 045B  20         b     *r11
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
0049 677E C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6780 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6782 832A 
0051 6784 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6786 832A 
0052 6788 045B  20         b     *r11
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
0021 678A C120  34 yx2px   mov   @wyx,tmp0
     678C 832A 
0022 678E C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6790 06C4  14         swpb  tmp0                  ; Y<->X
0024 6792 04C5  14         clr   tmp1                  ; Clear before copy
0025 6794 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6796 20A0  38         coc   @wbit1,config         ; f18a present ?
     6798 201E 
0030 679A 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 679C 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     679E 833A 
     67A0 2734 
0032 67A2 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 67A4 0A15  56         sla   tmp1,1                ; X = X * 2
0035 67A6 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 67A8 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     67AA 0500 
0037 67AC 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 67AE D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 67B0 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 67B2 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 67B4 D105  18         movb  tmp1,tmp0
0051 67B6 06C4  14         swpb  tmp0                  ; X<->Y
0052 67B8 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     67BA 2020 
0053 67BC 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 67BE 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     67C0 2012 
0059 67C2 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     67C4 2024 
0060 67C6 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 67C8 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 67CA 0050            data   80
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
0013 67CC C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 67CE 06A0  32         bl    @putvr                ; Write once
     67D0 2336 
0015 67D2 391C             data  >391c                 ; VR1/57, value 00011100
0016 67D4 06A0  32         bl    @putvr                ; Write twice
     67D6 2336 
0017 67D8 391C             data  >391c                 ; VR1/57, value 00011100
0018 67DA 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 67DC C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 67DE 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     67E0 2336 
0028 67E2 391C             data  >391c
0029 67E4 0458  20         b     *tmp4                 ; Exit
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
0040 67E6 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 67E8 06A0  32         bl    @cpym2v
     67EA 248A 
0042 67EC 3F00             data  >3f00,f18chk_gpu,8    ; Copy F18A GPU code to VRAM
     67EE 2794 
     67F0 0008 
0043 67F2 06A0  32         bl    @putvr
     67F4 2336 
0044 67F6 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 67F8 06A0  32         bl    @putvr
     67FA 2336 
0046 67FC 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 67FE 0204  20         li    tmp0,>3f00
     6800 3F00 
0052 6802 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6804 22BE 
0053 6806 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6808 8800 
0054 680A 0984  56         srl   tmp0,8
0055 680C D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     680E 8800 
0056 6810 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 6812 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 6814 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     6816 BFFF 
0060 6818 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 681A 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     681C 4000 
0063               f18chk_exit:
0064 681E 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     6820 2292 
0065 6822 3F00             data  >3f00,>00,6
     6824 0000 
     6826 0006 
0066 6828 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 682A 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 682C 3F00             data  >3f00                 ; 3f02 / 3f00
0073 682E 0340             data  >0340                 ; 3f04   0340  idle
0074 6830 10FF             data  >10ff                 ; 3f06   10ff  jmp $
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
0093 6832 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0094                       ;------------------------------------------------------
0095                       ; Reset all F18a VDP registers to power-on defaults
0096                       ;------------------------------------------------------
0097 6834 06A0  32         bl    @putvr
     6836 2336 
0098 6838 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0099               
0100 683A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     683C 2336 
0101 683E 391C             data  >391c                 ; Lock the F18a
0102 6840 0458  20         b     *tmp4                 ; Exit
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
0121 6842 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0122 6844 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6846 201E 
0123 6848 1609  14         jne   f18fw1
0124               ***************************************************************
0125               * Read F18A major/minor version
0126               ***************************************************************
0127 684A C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     684C 8802 
0128 684E 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6850 2336 
0129 6852 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0130 6854 04C4  14         clr   tmp0
0131 6856 D120  34         movb  @vdps,tmp0
     6858 8802 
0132 685A 0984  56         srl   tmp0,8
0133 685C 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 685E C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6860 832A 
0018 6862 D17B  28         movb  *r11+,tmp1
0019 6864 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6866 D1BB  28         movb  *r11+,tmp2
0021 6868 0986  56         srl   tmp2,8                ; Repeat count
0022 686A C1CB  18         mov   r11,tmp3
0023 686C 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     686E 23FE 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6870 020B  20         li    r11,hchar1
     6872 27E2 
0028 6874 0460  28         b     @xfilv                ; Draw
     6876 2298 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6878 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     687A 2022 
0033 687C 1302  14         jeq   hchar2                ; Yes, exit
0034 687E C2C7  18         mov   tmp3,r11
0035 6880 10EE  14         jmp   hchar                 ; Next one
0036 6882 05C7  14 hchar2  inct  tmp3
0037 6884 0457  20         b     *tmp3                 ; Exit
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
0016 6886 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6888 2020 
0017 688A 020C  20         li    r12,>0024
     688C 0024 
0018 688E 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6890 288C 
0019 6892 04C6  14         clr   tmp2
0020 6894 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6896 04CC  14         clr   r12
0025 6898 1F08  20         tb    >0008                 ; Shift-key ?
0026 689A 1302  14         jeq   realk1                ; No
0027 689C 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     689E 28BC 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 68A0 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 68A2 1302  14         jeq   realk2                ; No
0033 68A4 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     68A6 28EC 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 68A8 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 68AA 1302  14         jeq   realk3                ; No
0039 68AC 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     68AE 291C 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 68B0 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     68B2 200C 
0044 68B4 1E15  20         sbz   >0015                 ; Set P5
0045 68B6 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 68B8 1302  14         jeq   realk4                ; No
0047 68BA E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     68BC 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 68BE 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 68C0 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     68C2 0006 
0053 68C4 0606  14 realk5  dec   tmp2
0054 68C6 020C  20         li    r12,>24               ; CRU address for P2-P4
     68C8 0024 
0055 68CA 06C6  14         swpb  tmp2
0056 68CC 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 68CE 06C6  14         swpb  tmp2
0058 68D0 020C  20         li    r12,6                 ; CRU read address
     68D2 0006 
0059 68D4 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 68D6 0547  14         inv   tmp3                  ;
0061 68D8 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     68DA FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 68DC 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 68DE 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 68E0 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 68E2 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 68E4 0285  22         ci    tmp1,8
     68E6 0008 
0070 68E8 1AFA  14         jl    realk6
0071 68EA C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 68EC 1BEB  14         jh    realk5                ; No, next column
0073 68EE 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 68F0 C206  18 realk8  mov   tmp2,tmp4
0078 68F2 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 68F4 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 68F6 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 68F8 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 68FA 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 68FC D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 68FE 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     6900 200C 
0089 6902 1608  14         jne   realka                ; No, continue saving key
0090 6904 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6906 28B6 
0091 6908 1A05  14         jl    realka
0092 690A 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     690C 28B4 
0093 690E 1B02  14         jh    realka                ; No, continue
0094 6910 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     6912 E000 
0095 6914 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6916 833C 
0096 6918 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     691A 200A 
0097 691C 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     691E 8C00 
0098                                                   ; / using R15 as temp storage
0099 6920 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 6922 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6924 0000 
     6926 FF0D 
     6928 203D 
0102 692A ....             text  'xws29ol.'
0103 6932 ....             text  'ced38ik,'
0104 693A ....             text  'vrf47ujm'
0105 6942 ....             text  'btg56yhn'
0106 694A ....             text  'zqa10p;/'
0107 6952 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6954 0000 
     6956 FF0D 
     6958 202B 
0108 695A ....             text  'XWS@(OL>'
0109 6962 ....             text  'CED#*IK<'
0110 696A ....             text  'VRF$&UJM'
0111 6972 ....             text  'BTG%^YHN'
0112 697A ....             text  'ZQA!)P:-'
0113 6982 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6984 0000 
     6986 FF0D 
     6988 2005 
0114 698A 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     698C 0804 
     698E 0F27 
     6990 C2B9 
0115 6992 600B             data  >600b,>0907,>063f,>c1B8
     6994 0907 
     6996 063F 
     6998 C1B8 
0116 699A 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     699C 7B02 
     699E 015F 
     69A0 C0C3 
0117 69A2 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     69A4 7D0E 
     69A6 0CC6 
     69A8 BFC4 
0118 69AA 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     69AC 7C03 
     69AE BC22 
     69B0 BDBA 
0119 69B2 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     69B4 0000 
     69B6 FF0D 
     69B8 209D 
0120 69BA 9897             data  >9897,>93b2,>9f8f,>8c9B
     69BC 93B2 
     69BE 9F8F 
     69C0 8C9B 
0121 69C2 8385             data  >8385,>84b3,>9e89,>8b80
     69C4 84B3 
     69C6 9E89 
     69C8 8B80 
0122 69CA 9692             data  >9692,>86b4,>b795,>8a8D
     69CC 86B4 
     69CE B795 
     69D0 8A8D 
0123 69D2 8294             data  >8294,>87b5,>b698,>888E
     69D4 87B5 
     69D6 B698 
     69D8 888E 
0124 69DA 9A91             data  >9a91,>81b1,>b090,>9cBB
     69DC 81B1 
     69DE B090 
     69E0 9CBB 
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
0023 69E2 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 69E4 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     69E6 8340 
0025 69E8 04E0  34         clr   @waux1
     69EA 833C 
0026 69EC 04E0  34         clr   @waux2
     69EE 833E 
0027 69F0 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     69F2 833C 
0028 69F4 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 69F6 0205  20         li    tmp1,4                ; 4 nibbles
     69F8 0004 
0033 69FA C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 69FC 0246  22         andi  tmp2,>000f            ; Only keep LSN
     69FE 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6A00 0286  22         ci    tmp2,>000a
     6A02 000A 
0039 6A04 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6A06 C21B  26         mov   *r11,tmp4
0045 6A08 0988  56         srl   tmp4,8                ; Right justify
0046 6A0A 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6A0C FFF6 
0047 6A0E 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6A10 C21B  26         mov   *r11,tmp4
0054 6A12 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6A14 00FF 
0055               
0056 6A16 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6A18 06C6  14         swpb  tmp2
0058 6A1A DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6A1C 0944  56         srl   tmp0,4                ; Next nibble
0060 6A1E 0605  14         dec   tmp1
0061 6A20 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6A22 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6A24 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6A26 C160  34         mov   @waux3,tmp1           ; Get pointer
     6A28 8340 
0067 6A2A 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6A2C 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6A2E C120  34         mov   @waux2,tmp0
     6A30 833E 
0070 6A32 06C4  14         swpb  tmp0
0071 6A34 DD44  32         movb  tmp0,*tmp1+
0072 6A36 06C4  14         swpb  tmp0
0073 6A38 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6A3A C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6A3C 8340 
0078 6A3E D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6A40 2016 
0079 6A42 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6A44 C120  34         mov   @waux1,tmp0
     6A46 833C 
0084 6A48 06C4  14         swpb  tmp0
0085 6A4A DD44  32         movb  tmp0,*tmp1+
0086 6A4C 06C4  14         swpb  tmp0
0087 6A4E DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6A50 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A52 2020 
0092 6A54 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6A56 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6A58 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6A5A 7FFF 
0098 6A5C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6A5E 8340 
0099 6A60 0460  28         b     @xutst0               ; Display string
     6A62 2424 
0100 6A64 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6A66 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6A68 832A 
0122 6A6A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6A6C 8000 
0123 6A6E 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6A70 0207  20 mknum   li    tmp3,5                ; Digit counter
     6A72 0005 
0020 6A74 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6A76 C155  26         mov   *tmp1,tmp1            ; /
0022 6A78 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6A7A 0228  22         ai    tmp4,4                ; Get end of buffer
     6A7C 0004 
0024 6A7E 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6A80 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6A82 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6A84 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6A86 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6A88 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6A8A D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6A8C C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6A8E 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6A90 0607  14         dec   tmp3                  ; Decrease counter
0036 6A92 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6A94 0207  20         li    tmp3,4                ; Check first 4 digits
     6A96 0004 
0041 6A98 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6A9A C11B  26         mov   *r11,tmp0
0043 6A9C 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6A9E 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6AA0 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6AA2 05CB  14 mknum3  inct  r11
0047 6AA4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6AA6 2020 
0048 6AA8 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6AAA 045B  20         b     *r11                  ; Exit
0050 6AAC DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6AAE 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6AB0 13F8  14         jeq   mknum3                ; Yes, exit
0053 6AB2 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6AB4 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6AB6 7FFF 
0058 6AB8 C10B  18         mov   r11,tmp0
0059 6ABA 0224  22         ai    tmp0,-4
     6ABC FFFC 
0060 6ABE C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6AC0 0206  20         li    tmp2,>0500            ; String length = 5
     6AC2 0500 
0062 6AC4 0460  28         b     @xutstr               ; Display string
     6AC6 2426 
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
0093 6AC8 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6ACA C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6ACC C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6ACE 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6AD0 0207  20         li    tmp3,5                ; Set counter
     6AD2 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6AD4 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6AD6 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6AD8 0584  14         inc   tmp0                  ; Next character
0105 6ADA 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6ADC 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6ADE 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6AE0 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6AE2 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6AE4 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6AE6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6AE8 0607  14         dec   tmp3                  ; Last character ?
0121 6AEA 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6AEC 045B  20         b     *r11                  ; Return
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
0139 6AEE C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6AF0 832A 
0140 6AF2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6AF4 8000 
0141 6AF6 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6AF8 0649  14         dect  stack
0023 6AFA C64B  30         mov   r11,*stack            ; Save return address
0024 6AFC 0649  14         dect  stack
0025 6AFE C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6B00 0649  14         dect  stack
0027 6B02 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6B04 0649  14         dect  stack
0029 6B06 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6B08 0649  14         dect  stack
0031 6B0A C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6B0C C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6B0E C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6B10 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6B12 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6B14 0649  14         dect  stack
0044 6B16 C64B  30         mov   r11,*stack            ; Save return address
0045 6B18 0649  14         dect  stack
0046 6B1A C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6B1C 0649  14         dect  stack
0048 6B1E C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6B20 0649  14         dect  stack
0050 6B22 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6B24 0649  14         dect  stack
0052 6B26 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6B28 C1D4  26 !       mov   *tmp0,tmp3
0057 6B2A 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6B2C 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6B2E 00FF 
0059 6B30 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6B32 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6B34 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6B36 0584  14         inc   tmp0                  ; Next byte
0067 6B38 0607  14         dec   tmp3                  ; Shorten string length
0068 6B3A 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6B3C 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6B3E 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6B40 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6B42 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6B44 C187  18         mov   tmp3,tmp2
0078 6B46 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6B48 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6B4A 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6B4C 24E4 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6B4E 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6B50 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B52 FFCE 
0090 6B54 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B56 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6B58 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6B5A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6B5C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6B5E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6B60 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6B62 045B  20         b     *r11                  ; Return to caller
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
0123 6B64 0649  14         dect  stack
0124 6B66 C64B  30         mov   r11,*stack            ; Save return address
0125 6B68 05D9  26         inct  *stack                ; Skip "data P0"
0126 6B6A 05D9  26         inct  *stack                ; Skip "data P1"
0127 6B6C 0649  14         dect  stack
0128 6B6E C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6B70 0649  14         dect  stack
0130 6B72 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6B74 0649  14         dect  stack
0132 6B76 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6B78 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6B7A C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6B7C 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6B7E 0649  14         dect  stack
0144 6B80 C64B  30         mov   r11,*stack            ; Save return address
0145 6B82 0649  14         dect  stack
0146 6B84 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6B86 0649  14         dect  stack
0148 6B88 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6B8A 0649  14         dect  stack
0150 6B8C C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6B8E 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6B90 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6B92 0586  14         inc   tmp2
0161 6B94 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6B96 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6B98 0286  22         ci    tmp2,255
     6B9A 00FF 
0167 6B9C 1505  14         jgt   string.getlenc.panic
0168 6B9E 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6BA0 0606  14         dec   tmp2                  ; One time adjustment
0174 6BA2 C806  38         mov   tmp2,@waux1           ; Store length
     6BA4 833C 
0175 6BA6 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6BA8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BAA FFCE 
0181 6BAC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BAE 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6BB0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6BB2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6BB4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6BB6 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6BB8 045B  20         b     *r11                  ; Return to caller
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
0056 6BBA A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6BBC 2B28             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6BBE C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6BC0 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6BC2 A428 
0064 6BC4 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6BC6 201C 
0065 6BC8 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6BCA 8356 
0066 6BCC C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6BCE 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6BD0 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6BD2 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6BD4 A434 
0073                       ;---------------------------; Inline VSBR start
0074 6BD6 06C0  14         swpb  r0                    ;
0075 6BD8 D800  38         movb  r0,@vdpa              ; Send low byte
     6BDA 8C02 
0076 6BDC 06C0  14         swpb  r0                    ;
0077 6BDE D800  38         movb  r0,@vdpa              ; Send high byte
     6BE0 8C02 
0078 6BE2 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6BE4 8800 
0079                       ;---------------------------; Inline VSBR end
0080 6BE6 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6BE8 0704  14         seto  r4                    ; Init counter
0086 6BEA 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6BEC A420 
0087 6BEE 0580  14 !       inc   r0                    ; Point to next char of name
0088 6BF0 0584  14         inc   r4                    ; Increment char counter
0089 6BF2 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6BF4 0007 
0090 6BF6 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6BF8 80C4  18         c     r4,r3                 ; End of name?
0093 6BFA 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6BFC 06C0  14         swpb  r0                    ;
0098 6BFE D800  38         movb  r0,@vdpa              ; Send low byte
     6C00 8C02 
0099 6C02 06C0  14         swpb  r0                    ;
0100 6C04 D800  38         movb  r0,@vdpa              ; Send high byte
     6C06 8C02 
0101 6C08 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6C0A 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6C0C DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6C0E 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6C10 2C90 
0109 6C12 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6C14 C104  18         mov   r4,r4                 ; Check if length = 0
0115 6C16 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6C18 04E0  34         clr   @>83d0
     6C1A 83D0 
0118 6C1C C804  38         mov   r4,@>8354             ; Save name length for search (length
     6C1E 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6C20 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6C22 A432 
0121               
0122 6C24 0584  14         inc   r4                    ; Adjust for dot
0123 6C26 A804  38         a     r4,@>8356             ; Point to position after name
     6C28 8356 
0124 6C2A C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6C2C 8356 
     6C2E A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6C30 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6C32 83E0 
0130 6C34 04C1  14         clr   r1                    ; Version found of dsr
0131 6C36 020C  20         li    r12,>0f00             ; Init cru address
     6C38 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6C3A C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6C3C 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6C3E 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6C40 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6C42 0100 
0145 6C44 04E0  34         clr   @>83d0                ; Clear in case we are done
     6C46 83D0 
0146 6C48 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6C4A 2000 
0147 6C4C 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6C4E C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6C50 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6C52 1D00  20         sbo   0                     ; Turn on ROM
0154 6C54 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6C56 4000 
0155 6C58 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6C5A 2C8C 
0156 6C5C 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6C5E A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6C60 A40A 
0166 6C62 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6C64 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6C66 83D2 
0172                                                   ; subprogram
0173               
0174 6C68 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6C6A C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6C6C 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6C6E C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6C70 83D2 
0183                                                   ; subprogram
0184               
0185 6C72 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6C74 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6C76 04C5  14         clr   r5                    ; Remove any old stuff
0194 6C78 D160  34         movb  @>8355,r5             ; Get length as counter
     6C7A 8355 
0195 6C7C 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6C7E 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6C80 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6C82 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6C84 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6C86 A420 
0206 6C88 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6C8A 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6C8C 0605  14         dec   r5                    ; Update loop counter
0211 6C8E 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6C90 0581  14         inc   r1                    ; Next version found
0217 6C92 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6C94 A42A 
0218 6C96 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6C98 A42C 
0219 6C9A C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6C9C A430 
0220               
0221 6C9E 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6CA0 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6CA2 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6CA4 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6CA6 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6CA8 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6CAA A400 
0233 6CAC C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6CAE C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6CB0 A428 
0239                                                   ; (8 or >a)
0240 6CB2 0281  22         ci    r1,8                  ; was it 8?
     6CB4 0008 
0241 6CB6 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6CB8 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6CBA 8350 
0243                                                   ; Get error byte from @>8350
0244 6CBC 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6CBE 06C0  14         swpb  r0                    ;
0252 6CC0 D800  38         movb  r0,@vdpa              ; send low byte
     6CC2 8C02 
0253 6CC4 06C0  14         swpb  r0                    ;
0254 6CC6 D800  38         movb  r0,@vdpa              ; send high byte
     6CC8 8C02 
0255 6CCA D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6CCC 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6CCE 09D1  56         srl   r1,13                 ; just keep error bits
0263 6CD0 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6CD2 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6CD4 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6CD6 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6CD8 A400 
0275               dsrlnk.error.devicename_invalid:
0276 6CDA 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6CDC 06C1  14         swpb  r1                    ; put error in hi byte
0279 6CDE D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6CE0 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6CE2 201C 
0281                                                   ; / to indicate error
0282 6CE4 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6CE6 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6CE8 2C54             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6CEA 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6CEC 83E0 
0316               
0317 6CEE 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6CF0 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6CF2 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6CF4 A42A 
0322 6CF6 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6CF8 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6CFA C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6CFC 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6CFE C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6D00 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6D02 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6D04 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6D06 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6D08 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6D0A 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6D0C 4000 
     6D0E 2C8C 
0337 6D10 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6D12 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6D14 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6D16 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6D18 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6D1A A400 
0355 6D1C C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6D1E A434 
0356               
0357 6D20 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6D22 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6D24 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6D26 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6D28 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6D2A C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6D2C 0649  14         dect  stack
0052 6D2E C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6D30 0204  20         li    tmp0,dsrlnk.savcru
     6D32 A42A 
0057 6D34 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6D36 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6D38 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6D3A 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6D3C 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6D3E 37D7 
0065 6D40 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6D42 8370 
0066                                                   ; / location
0067 6D44 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6D46 A44C 
0068 6D48 04C5  14         clr   tmp1                  ; io.op.open
0069 6D4A 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6D4C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6D4E 0649  14         dect  stack
0097 6D50 C64B  30         mov   r11,*stack            ; Save return address
0098 6D52 0205  20         li    tmp1,io.op.close      ; io.op.close
     6D54 0001 
0099 6D56 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6D58 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6D5A 0649  14         dect  stack
0125 6D5C C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6D5E 0205  20         li    tmp1,io.op.read       ; io.op.read
     6D60 0002 
0128 6D62 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6D64 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6D66 0649  14         dect  stack
0155 6D68 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6D6A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6D6C 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6D6E 0005 
0159               
0160 6D70 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6D72 A43E 
0161               
0162 6D74 06A0  32         bl    @xvputb               ; Write character count to PAB
     6D76 22D0 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6D78 0205  20         li    tmp1,io.op.write      ; io.op.write
     6D7A 0003 
0167 6D7C 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6D7E 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6D80 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6D82 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6D84 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6D86 1000  14         nop
0189               
0190               
0191               file.status:
0192 6D88 1000  14         nop
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
0227 6D8A C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6D8C A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6D8E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6D90 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6D92 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6D94 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6D96 22D0 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6D98 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6D9A 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6D9C C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6D9E A44C 
0246               
0247 6DA0 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6DA2 22D0 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6DA4 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6DA6 0009 
0254 6DA8 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6DAA 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6DAC C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6DAE 8322 
     6DB0 833C 
0259               
0260 6DB2 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6DB4 A42A 
0261 6DB6 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6DB8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6DBA 2B24 
0268 6DBC 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6DBE 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6DC0 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6DC2 2C50 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6DC4 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6DC6 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6DC8 833C 
     6DCA 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6DCC C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6DCE A436 
0292 6DD0 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6DD2 0005 
0293 6DD4 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6DD6 22E8 
0294 6DD8 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6DDA C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6DDC C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6DDE 045B  20         b     *r11                  ; Return to caller
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
0020 6DE0 0300  24 tmgr    limi  0                     ; No interrupt processing
     6DE2 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6DE4 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6DE6 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6DE8 2360  38         coc   @wbit2,r13            ; C flag on ?
     6DEA 201C 
0029 6DEC 1602  14         jne   tmgr1a                ; No, so move on
0030 6DEE E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6DF0 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6DF2 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6DF4 2020 
0035 6DF6 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6DF8 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6DFA 2010 
0048 6DFC 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6DFE 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6E00 200E 
0050 6E02 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6E04 0460  28         b     @kthread              ; Run kernel thread
     6E06 2DE8 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6E08 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6E0A 2014 
0056 6E0C 13EB  14         jeq   tmgr1
0057 6E0E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6E10 2012 
0058 6E12 16E8  14         jne   tmgr1
0059 6E14 C120  34         mov   @wtiusr,tmp0
     6E16 832E 
0060 6E18 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6E1A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6E1C 2DE6 
0065 6E1E C10A  18         mov   r10,tmp0
0066 6E20 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6E22 00FF 
0067 6E24 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6E26 201C 
0068 6E28 1303  14         jeq   tmgr5
0069 6E2A 0284  22         ci    tmp0,60               ; 1 second reached ?
     6E2C 003C 
0070 6E2E 1002  14         jmp   tmgr6
0071 6E30 0284  22 tmgr5   ci    tmp0,50
     6E32 0032 
0072 6E34 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6E36 1001  14         jmp   tmgr8
0074 6E38 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6E3A C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6E3C 832C 
0079 6E3E 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6E40 FF00 
0080 6E42 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6E44 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6E46 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6E48 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6E4A C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6E4C 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6E4E 830C 
     6E50 830D 
0089 6E52 1608  14         jne   tmgr10                ; No, get next slot
0090 6E54 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6E56 FF00 
0091 6E58 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6E5A C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6E5C 8330 
0096 6E5E 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6E60 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6E62 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6E64 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6E66 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6E68 8315 
     6E6A 8314 
0103 6E6C 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6E6E 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6E70 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6E72 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6E74 10F7  14         jmp   tmgr10                ; Process next slot
0108 6E76 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6E78 FF00 
0109 6E7A 10B4  14         jmp   tmgr1
0110 6E7C 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6E7E E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6E80 2010 
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
0041 6E82 06A0  32         bl    @realkb               ; Scan full keyboard
     6E84 27F0 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6E86 0460  28         b     @tmgr3                ; Exit
     6E88 2D72 
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
0017 6E8A C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6E8C 832E 
0018 6E8E E0A0  34         soc   @wbit7,config         ; Enable user hook
     6E90 2012 
0019 6E92 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D4E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6E94 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6E96 832E 
0029 6E98 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6E9A FEFF 
0030 6E9C 045B  20         b     *r11                  ; Return
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
0017 6E9E C13B  30 mkslot  mov   *r11+,tmp0
0018 6EA0 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6EA2 C184  18         mov   tmp0,tmp2
0023 6EA4 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6EA6 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6EA8 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6EAA CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6EAC 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6EAE C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6EB0 881B  46         c     *r11,@w$ffff          ; End of list ?
     6EB2 2022 
0035 6EB4 1301  14         jeq   mkslo1                ; Yes, exit
0036 6EB6 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6EB8 05CB  14 mkslo1  inct  r11
0041 6EBA 045B  20         b     *r11                  ; Exit
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
0052 6EBC C13B  30 clslot  mov   *r11+,tmp0
0053 6EBE 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6EC0 A120  34         a     @wtitab,tmp0          ; Add table base
     6EC2 832C 
0055 6EC4 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6EC6 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6EC8 045B  20         b     *r11                  ; Exit
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
0068 6ECA C13B  30 rsslot  mov   *r11+,tmp0
0069 6ECC 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 6ECE A120  34         a     @wtitab,tmp0          ; Add table base
     6ED0 832C 
0071 6ED2 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 6ED4 C154  26         mov   *tmp0,tmp1
0073 6ED6 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     6ED8 FF00 
0074 6EDA C505  30         mov   tmp1,*tmp0
0075 6EDC 045B  20         b     *r11                  ; Exit
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
0260 6EDE 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6EE0 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 6EE2 0300  24 runli1  limi  0                     ; Turn off interrupts
     6EE4 0000 
0266 6EE6 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6EE8 8300 
0267 6EEA C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6EEC 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 6EEE 0202  20 runli2  li    r2,>8308
     6EF0 8308 
0272 6EF2 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 6EF4 0282  22         ci    r2,>8400
     6EF6 8400 
0274 6EF8 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 6EFA 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     6EFC FFFF 
0279 6EFE 1602  14         jne   runli4                ; No, continue
0280 6F00 0420  54         blwp  @0                    ; Yes, bye bye
     6F02 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 6F04 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6F06 833C 
0285 6F08 04C1  14         clr   r1                    ; Reset counter
0286 6F0A 0202  20         li    r2,10                 ; We test 10 times
     6F0C 000A 
0287 6F0E C0E0  34 runli5  mov   @vdps,r3
     6F10 8802 
0288 6F12 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6F14 2020 
0289 6F16 1302  14         jeq   runli6
0290 6F18 0581  14         inc   r1                    ; Increase counter
0291 6F1A 10F9  14         jmp   runli5
0292 6F1C 0602  14 runli6  dec   r2                    ; Next test
0293 6F1E 16F7  14         jne   runli5
0294 6F20 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6F22 1250 
0295 6F24 1202  14         jle   runli7                ; No, so it must be NTSC
0296 6F26 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6F28 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 6F2A 06A0  32 runli7  bl    @loadmc
     6F2C 221E 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 6F2E 04C1  14 runli9  clr   r1
0305 6F30 04C2  14         clr   r2
0306 6F32 04C3  14         clr   r3
0307 6F34 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     6F36 3000 
0308 6F38 020F  20         li    r15,vdpw              ; Set VDP write address
     6F3A 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 6F3C 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6F3E 4A4A 
0317 6F40 1605  14         jne   runlia
0318 6F42 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6F44 2292 
0319 6F46 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     6F48 0000 
     6F4A 3000 
0324 6F4C 06A0  32 runlia  bl    @filv
     6F4E 2292 
0325 6F50 0FC0             data  pctadr,spfclr,16      ; Load color table
     6F52 00F4 
     6F54 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 6F56 06A0  32         bl    @f18unl               ; Unlock the F18A
     6F58 2736 
0333 6F5A 06A0  32         bl    @f18chk               ; Check if F18A is there
     6F5C 2750 
0334 6F5E 06A0  32         bl    @f18lck               ; Lock the F18A again
     6F60 2746 
0335               
0336 6F62 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     6F64 2336 
0337 6F66 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 6F68 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6F6A 22FC 
0351 6F6C 33A2             data  spvmod                ; Equate selected video mode table
0352 6F6E 0204  20         li    tmp0,spfont           ; Get font option
     6F70 000C 
0353 6F72 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 6F74 1304  14         jeq   runlid                ; Yes, skip it
0355 6F76 06A0  32         bl    @ldfnt
     6F78 2364 
0356 6F7A 1100             data  fntadr,spfont         ; Load specified font
     6F7C 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 6F7E 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6F80 4A4A 
0361 6F82 1602  14         jne   runlie                ; No, continue
0362 6F84 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6F86 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 6F88 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6F8A 0040 
0367 6F8C 0460  28         b     @main                 ; Give control to main program
     6F8E 3000 
**** **** ****     > stevie_b0.asm.3171309
0125                                                   ; Spectra 2
0126                       ;------------------------------------------------------
0127                       ; End of File marker
0128                       ;------------------------------------------------------
0129 6F90 DEAD             data  >dead,>beef,>dead,>beef
     6F92 BEEF 
     6F94 DEAD 
     6F96 BEEF 
0131               
0135 6F98 2F02                   data $                ; Bank 0 ROM size OK.
0137               
0138 6F9A ....             bss  300                    ; Fill remaining space with >00
0139               
0140               ***************************************************************
0141               * Code data: Relocated Stevie modules >3000 - >3fff (4K max)
0142               ********|*****|*********************|**************************
0143               reloc.stevie:
0144                       xorg  >3000                 ; Relocate Stevie modules to >3000
0145                       ;------------------------------------------------------
0146                       ; Activate bank 1 and branch to >6036
0147                       ;------------------------------------------------------
0148               main:
0149 70C6 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     70C8 6002 
0150               
0152 70CA 04E0  34         clr   @bank1.ram            ; Activate bank 1 "James" RAM
     70CC 6802 
0154               
0155 70CE 0460  28         b     @kickstart.code2      ; Jump to entry routine
     70D0 6036 
0156                       ;------------------------------------------------------
0157                       ; Resident Stevie modules: >3000 - >3fff
0158                       ;------------------------------------------------------
0159                       copy  "ram.resident.3000.asm"
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
0021 70D2 C13B  30         mov   *r11+,tmp0            ; P0
0022 70D4 C17B  30         mov   *r11+,tmp1            ; P1
0023 70D6 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 70D8 0649  14         dect  stack
0029 70DA C644  30         mov   tmp0,*stack           ; Push tmp0
0030 70DC 0649  14         dect  stack
0031 70DE C645  30         mov   tmp1,*stack           ; Push tmp1
0032 70E0 0649  14         dect  stack
0033 70E2 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 70E4 0649  14         dect  stack
0035 70E6 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 70E8 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     70EA 6000 
0040 70EC 1112  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 70EE C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     70F0 A026 
0044 70F2 0647  14         dect  tmp3
0045 70F4 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 70F6 0647  14         dect  tmp3
0047 70F8 C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 70FA C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     70FC A026 
0049               
0051 70FE 1002  14         jmp   rom.farjump.bankswitch.tgt.advfg99
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 7100 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 7102 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 7104 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 7106 0224  22         ai    tmp0,>0800
     7108 0800 
0066 710A 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071 710C C115  26         mov   *tmp1,tmp0            ; Deref value in vector address
0072 710E 1301  14         jeq   rom.farjump.bankswitch.failed1
0073                                                   ; Crash if null-pointer in vector
0074 7110 1004  14         jmp   rom.farjump.bankswitch.call
0075                                                   ; Call function in target bank
0076                       ;------------------------------------------------------
0077                       ; Assert 1 failed before bank-switch
0078                       ;------------------------------------------------------
0079               rom.farjump.bankswitch.failed1:
0080 7112 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7114 FFCE 
0081 7116 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7118 2026 
0082                       ;------------------------------------------------------
0083                       ; Call function in target bank
0084                       ;------------------------------------------------------
0085               rom.farjump.bankswitch.call:
0086 711A 0694  24         bl    *tmp0                 ; Call function
0087                       ;------------------------------------------------------
0088                       ; Bankswitch back to source bank
0089                       ;------------------------------------------------------
0090               rom.farjump.return:
0091 711C C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     711E A026 
0092 7120 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0093 7122 1313  14         jeq   rom.farjump.bankswitch.failed2
0094                                                   ; Crash if null-pointer in address
0095               
0096 7124 04F4  30         clr   *tmp0+                ; Remove bank write address from
0097                                                   ; farjump stack
0098               
0099 7126 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0100               
0101 7128 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0102                                                   ; farjump stack
0103               
0104 712A 028B  22         ci    r11,>6000
     712C 6000 
0105 712E 110D  14         jlt   rom.farjump.bankswitch.failed2
0106 7130 028B  22         ci    r11,>7fff
     7132 7FFF 
0107 7134 150A  14         jgt   rom.farjump.bankswitch.failed2
0108               
0109 7136 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     7138 A026 
0110               
0112 713A 1002  14         jmp   rom.farjump.bankswitch.src.advfg99
0114               
0115                       ;------------------------------------------------------
0116                       ; Bankswitch to source 8K ROM bank
0117                       ;------------------------------------------------------
0118               rom.farjump.bankswitch.src.rom8k:
0119 713C 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0120 713E 1009  14         jmp   rom.farjump.exit
0121                       ;------------------------------------------------------
0122                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0123                       ;------------------------------------------------------
0124               rom.farjump.bankswitch.src.advfg99:
0125 7140 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0126 7142 0225  22         ai    tmp1,>0800
     7144 0800 
0127 7146 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0128 7148 1004  14         jmp   rom.farjump.exit
0129                       ;------------------------------------------------------
0130                       ; Assert 2 failed after bank-switch
0131                       ;------------------------------------------------------
0132               rom.farjump.bankswitch.failed2:
0133 714A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     714C FFCE 
0134 714E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7150 2026 
0135                       ;-------------------------------------------------------
0136                       ; Exit
0137                       ;-------------------------------------------------------
0138               rom.farjump.exit:
0139 7152 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0140 7154 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0141 7156 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0142 7158 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0143 715A 045B  20         b     *r11                  ; Return to caller
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
0020 715C 0649  14         dect  stack
0021 715E C64B  30         mov   r11,*stack            ; Save return address
0022 7160 0649  14         dect  stack
0023 7162 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 7164 0649  14         dect  stack
0025 7166 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7168 0204  20         li    tmp0,fb.top
     716A A600 
0030 716C C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     716E A100 
0031 7170 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     7172 A104 
0032 7174 04E0  34         clr   @fb.row               ; Current row=0
     7176 A106 
0033 7178 04E0  34         clr   @fb.column            ; Current column=0
     717A A10C 
0034               
0035 717C 0204  20         li    tmp0,colrow
     717E 0050 
0036 7180 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     7182 A10E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 7184 C160  34         mov   @tv.ruler.visible,tmp1
     7186 A010 
0041 7188 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 718A 0204  20         li    tmp0,pane.botrow-2
     718C 001B 
0043 718E 1002  14         jmp   fb.init.cont
0044 7190 0204  20 !       li    tmp0,pane.botrow-1
     7192 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 7194 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     7196 A11A 
0050 7198 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     719A A11C 
0051               
0052 719C 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     719E A022 
0053 71A0 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     71A2 A110 
0054 71A4 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     71A6 A116 
0055 71A8 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     71AA A118 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 71AC 06A0  32         bl    @film
     71AE 223A 
0060 71B0 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     71B2 0000 
     71B4 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 71B6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 71B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 71BA C2F9  30         mov   *stack+,r11           ; Pop r11
0068 71BC 045B  20         b     *r11                  ; Return to caller
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
0046 71BE 0649  14         dect  stack
0047 71C0 C64B  30         mov   r11,*stack            ; Save return address
0048 71C2 0649  14         dect  stack
0049 71C4 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 71C6 0204  20         li    tmp0,idx.top
     71C8 B000 
0054 71CA C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     71CC A202 
0055               
0056 71CE C120  34         mov   @tv.sams.b000,tmp0
     71D0 A006 
0057 71D2 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     71D4 A500 
0058 71D6 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     71D8 A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 71DA 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     71DC 0004 
0063 71DE C804  38         mov   tmp0,@idx.sams.hipage ; /
     71E0 A504 
0064               
0065 71E2 06A0  32         bl    @_idx.sams.mapcolumn.on
     71E4 313A 
0066                                                   ; Index in continuous memory region
0067               
0068 71E6 06A0  32         bl    @film
     71E8 223A 
0069 71EA B000                   data idx.top,>00,idx.size * 5
     71EC 0000 
     71EE 5000 
0070                                                   ; Clear index
0071               
0072 71F0 06A0  32         bl    @_idx.sams.mapcolumn.off
     71F2 316E 
0073                                                   ; Restore memory window layout
0074               
0075 71F4 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     71F6 A502 
     71F8 A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 71FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 71FC C2F9  30         mov   *stack+,r11           ; Pop r11
0083 71FE 045B  20         b     *r11                  ; Return to caller
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
0096 7200 0649  14         dect  stack
0097 7202 C64B  30         mov   r11,*stack            ; Push return address
0098 7204 0649  14         dect  stack
0099 7206 C644  30         mov   tmp0,*stack           ; Push tmp0
0100 7208 0649  14         dect  stack
0101 720A C645  30         mov   tmp1,*stack           ; Push tmp1
0102 720C 0649  14         dect  stack
0103 720E C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 7210 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     7212 A502 
0108 7214 0205  20         li    tmp1,idx.top
     7216 B000 
0109 7218 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     721A 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 721C 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     721E 257A 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 7220 0584  14         inc   tmp0                  ; Next SAMS index page
0118 7222 0225  22         ai    tmp1,>1000            ; Next memory region
     7224 1000 
0119 7226 0606  14         dec   tmp2                  ; Update loop counter
0120 7228 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 722A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 722C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 722E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 7230 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 7232 045B  20         b     *r11                  ; Return to caller
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
0145 7234 0649  14         dect  stack
0146 7236 C64B  30         mov   r11,*stack            ; Push return address
0147 7238 0649  14         dect  stack
0148 723A C644  30         mov   tmp0,*stack           ; Push tmp0
0149 723C 0649  14         dect  stack
0150 723E C645  30         mov   tmp1,*stack           ; Push tmp1
0151 7240 0649  14         dect  stack
0152 7242 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 7244 0649  14         dect  stack
0154 7246 C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 7248 0205  20         li    tmp1,idx.top
     724A B000 
0159 724C 0206  20         li    tmp2,5                ; Always 5 pages
     724E 0005 
0160 7250 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     7252 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 7254 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 7256 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7258 257A 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 725A 0225  22         ai    tmp1,>1000            ; Next memory region
     725C 1000 
0171 725E 0606  14         dec   tmp2                  ; Update loop counter
0172 7260 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 7262 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 7264 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 7266 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 7268 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 726A C2F9  30         mov   *stack+,r11           ; Pop return address
0182 726C 045B  20         b     *r11                  ; Return to caller
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
0206 726E 0649  14         dect  stack
0207 7270 C64B  30         mov   r11,*stack            ; Save return address
0208 7272 0649  14         dect  stack
0209 7274 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 7276 0649  14         dect  stack
0211 7278 C645  30         mov   tmp1,*stack           ; Push tmp1
0212 727A 0649  14         dect  stack
0213 727C C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 727E C184  18         mov   tmp0,tmp2             ; Line number
0218 7280 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 7282 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     7284 0800 
0220               
0221 7286 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 7288 0A16  56         sla   tmp2,1                ; line number * 2
0226 728A C806  38         mov   tmp2,@outparm1        ; Offset index entry
     728C 2F30 
0227               
0228 728E A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     7290 A502 
0229 7292 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     7294 A500 
0230               
0231 7296 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 7298 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     729A A500 
0237 729C C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     729E A006 
0238               
0239 72A0 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 72A2 0205  20         li    tmp1,>b000            ; Memory window for index page
     72A4 B000 
0241               
0242 72A6 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     72A8 257A 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 72AA 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     72AC A504 
0249 72AE 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 72B0 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     72B2 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 72B4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 72B6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 72B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 72BA C2F9  30         mov   *stack+,r11           ; Pop r11
0260 72BC 045B  20         b     *r11                  ; Return to caller
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
0022 72BE 0649  14         dect  stack
0023 72C0 C64B  30         mov   r11,*stack            ; Save return address
0024 72C2 0649  14         dect  stack
0025 72C4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72C6 0204  20         li    tmp0,edb.top          ; \
     72C8 C000 
0030 72CA C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     72CC A200 
0031 72CE C804  38         mov   tmp0,@edb.next_free.ptr
     72D0 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 72D2 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     72D4 A20A 
0035               
0036 72D6 0204  20         li    tmp0,1
     72D8 0001 
0037 72DA C804  38         mov   tmp0,@edb.lines       ; Lines=1
     72DC A204 
0038               
0039 72DE 0720  34         seto  @edb.block.m1         ; Reset block start line
     72E0 A20C 
0040 72E2 0720  34         seto  @edb.block.m2         ; Reset block end line
     72E4 A20E 
0041               
0042 72E6 0204  20         li    tmp0,txt.newfile      ; "New file"
     72E8 3530 
0043 72EA C804  38         mov   tmp0,@edb.filename.ptr
     72EC A212 
0044               
0045 72EE 0204  20         li    tmp0,txt.filetype.none
     72F0 35EA 
0046 72F2 C804  38         mov   tmp0,@edb.filetype.ptr
     72F4 A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 72F6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 72F8 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 72FA 045B  20         b     *r11                  ; Return to caller
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
0022 72FC 0649  14         dect  stack
0023 72FE C64B  30         mov   r11,*stack            ; Save return address
0024 7300 0649  14         dect  stack
0025 7302 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7304 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     7306 D000 
0030 7308 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     730A A300 
0031               
0032 730C 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     730E A302 
0033 7310 0204  20         li    tmp0,4
     7312 0004 
0034 7314 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     7316 A306 
0035 7318 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     731A A308 
0036               
0037 731C 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     731E A316 
0038 7320 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     7322 A318 
0039 7324 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     7326 A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 7328 06A0  32         bl    @film
     732A 223A 
0044 732C D000             data  cmdb.top,>00,cmdb.size
     732E 0000 
     7330 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 7332 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 7334 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 7336 045B  20         b     *r11                  ; Return to caller
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
0022 7338 0649  14         dect  stack
0023 733A C64B  30         mov   r11,*stack            ; Save return address
0024 733C 0649  14         dect  stack
0025 733E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7340 04E0  34         clr   @tv.error.visible     ; Set to hidden
     7342 A028 
0030               
0031 7344 06A0  32         bl    @film
     7346 223A 
0032 7348 A02A                   data tv.error.msg,0,160
     734A 0000 
     734C 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 734E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 7350 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 7352 045B  20         b     *r11                  ; Return to caller
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
0022 7354 0649  14         dect  stack
0023 7356 C64B  30         mov   r11,*stack            ; Save return address
0024 7358 0649  14         dect  stack
0025 735A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 735C 0204  20         li    tmp0,1                ; \ Set default color scheme
     735E 0001 
0030 7360 C804  38         mov   tmp0,@tv.colorscheme  ; /
     7362 A012 
0031               
0032 7364 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     7366 A024 
0033 7368 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     736A 200C 
0034               
0035 736C 0204  20         li    tmp0,fj.bottom
     736E F000 
0036 7370 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     7372 A026 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 7374 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 7376 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 7378 045B  20         b     *r11                  ; Return to caller
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
0065 737A 0649  14         dect  stack
0066 737C C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 737E 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     7380 3236 
0071 7382 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7384 31F8 
0072 7386 06A0  32         bl    @idx.init             ; Initialize index
     7388 30F8 
0073 738A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     738C 3096 
0074 738E 06A0  32         bl    @errline.init         ; Initialize error line
     7390 3272 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 7392 06A0  32         bl    @hchar
     7394 27C8 
0079 7396 0034                   byte 0,52,32,18           ; Remove markers
     7398 2012 
0080 739A 1D00                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     739C 2032 
0081 739E FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 73A0 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 73A2 045B  20         b     *r11                  ; Return to caller
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
0020 73A4 0649  14         dect  stack
0021 73A6 C64B  30         mov   r11,*stack            ; Save return address
0022 73A8 0649  14         dect  stack
0023 73AA C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 73AC 06A0  32         bl    @mknum                ; Convert unsigned number to string
     73AE 29DA 
0028 73B0 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 73B2 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 73B4 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 73B6 0204  20         li    tmp0,unpacked.string
     73B8 2F44 
0034 73BA 04F4  30         clr   *tmp0+                ; Clear string 01
0035 73BC 04F4  30         clr   *tmp0+                ; Clear string 23
0036 73BE 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 73C0 06A0  32         bl    @trimnum              ; Trim unsigned number string
     73C2 2A32 
0039 73C4 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 73C6 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 73C8 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 73CA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 73CC C2F9  30         mov   *stack+,r11           ; Pop r11
0048 73CE 045B  20         b     *r11                  ; Return to caller
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
0073 73D0 0649  14         dect  stack
0074 73D2 C64B  30         mov   r11,*stack            ; Push return address
0075 73D4 0649  14         dect  stack
0076 73D6 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 73D8 0649  14         dect  stack
0078 73DA C645  30         mov   tmp1,*stack           ; Push tmp1
0079 73DC 0649  14         dect  stack
0080 73DE C646  30         mov   tmp2,*stack           ; Push tmp2
0081 73E0 0649  14         dect  stack
0082 73E2 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 73E4 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     73E6 2F20 
0087 73E8 D194  26         movb  *tmp0,tmp2            ; /
0088 73EA 0986  56         srl   tmp2,8                ; Right align
0089 73EC C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 73EE 8806  38         c     tmp2,@parm2           ; String length > requested length?
     73F0 2F22 
0092 73F2 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 73F4 C120  34         mov   @parm1,tmp0           ; Get source address
     73F6 2F20 
0097 73F8 C160  34         mov   @parm4,tmp1           ; Get destination address
     73FA 2F26 
0098 73FC 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 73FE 0649  14         dect  stack
0101 7400 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 7402 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     7404 24E4 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 7406 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 7408 C120  34         mov   @parm2,tmp0           ; Get requested length
     740A 2F22 
0113 740C 0A84  56         sla   tmp0,8                ; Left align
0114 740E C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     7410 2F26 
0115 7412 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 7414 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 7416 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 7418 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     741A 2F22 
0122 741C 6187  18         s     tmp3,tmp2             ; |
0123 741E 0586  14         inc   tmp2                  ; /
0124               
0125 7420 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     7422 2F24 
0126 7424 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 7426 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 7428 0606  14         dec   tmp2                  ; Update loop counter
0133 742A 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 742C C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     742E 2F26 
     7430 2F30 
0136 7432 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 7434 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7436 FFCE 
0142 7438 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     743A 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 743C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 743E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 7440 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 7442 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 7444 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 7446 045B  20         b     *r11                  ; Return to caller
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
0017 7448 0649  14         dect  stack
0018 744A C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 744C 06A0  32         bl    @sams.layout
     744E 25E6 
0023 7450 33BA                   data mem.sams.layout.data
0024               
0025 7452 06A0  32         bl    @sams.layout.copy
     7454 264A 
0026 7456 A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 7458 C820  54         mov   @tv.sams.c000,@edb.sams.page
     745A A008 
     745C A216 
0029 745E C820  54         mov   @edb.sams.page,@edb.sams.hipage
     7460 A216 
     7462 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 7464 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 7466 045B  20         b     *r11                  ; Return to caller
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
0033 7468 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     746A 003F 
     746C 0243 
     746E 05F4 
     7470 0050 
0034               
0035               romsat:
0036 7472 0000             data  >0000,>0001             ; Cursor YX, initial shape and colour
     7474 0001 
0037 7476 0000             data  >0000,>0301             ; Current line indicator
     7478 0301 
0038 747A 0820             data  >0820,>0401             ; Current line indicator
     747C 0401 
0039               nosprite:
0040 747E D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 7480 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7482 0002 
0048 7484 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     7486 0003 
0049 7488 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     748A 000A 
0050               
0051 748C B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     748E 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 7490 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     7492 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 7494 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7496 000D 
0060 7498 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     749A 000E 
0061 749C F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     749E 000F 
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
0117 74A0 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     74A2 F171 
     74A4 1B1F 
     74A6 71B1 
0118 74A8 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     74AA F0FF 
     74AC 1F1A 
     74AE F1FF 
0119 74B0 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     74B2 F0FF 
     74B4 1F12 
     74B6 F1F6 
0120 74B8 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     74BA 1E11 
     74BC 1A17 
     74BE 1E11 
0121 74C0 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     74C2 E1FF 
     74C4 1F1E 
     74C6 E1FF 
0122 74C8 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     74CA 1016 
     74CC 1B71 
     74CE 1711 
0123 74D0 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     74D2 1011 
     74D4 F1F1 
     74D6 1F11 
0124 74D8 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     74DA A1FF 
     74DC 1F1F 
     74DE F11F 
0125 74E0 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     74E2 12FF 
     74E4 1B12 
     74E6 12FF 
0126 74E8 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     74EA E1FF 
     74EC 1B1F 
     74EE F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 74F0 0007             byte  0,7,12,25               ; \   Default tab positions as used
     74F2 0C19 
0131 74F4 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     74F6 3B4F 
0132 74F8 FF00             byte  >ff,0,0,0               ; |
     74FA 0000 
0133 74FC 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     74FE 0000 
0134 7500 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     7502 0000 
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
0012 7504 0B53             byte  11
0013 7505 ....             text  'STEVIE 1.1H'
0014                       even
0015               
0016               txt.about.build
0017 7510 4C42             byte  76
0018 7511 ....             text  'Build: 210523-3171309 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 755E 012C             byte  1
0024 755F ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 7560 0520             byte  5
0029 7561 ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 7566 034F             byte  3
0034 7567 ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 756A 0349             byte  3
0039 756B ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 756E 012A             byte  1
0044 756F ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 7570 0A4C             byte  10
0049 7571 ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 757C 0A53             byte  10
0054 757D ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 7588 1244             byte  18
0059 7589 ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 759C 1143             byte  17
0064 759D ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 75AE 104D             byte  16
0069 75AF ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 75C0 1D53             byte  29
0074 75C1 ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 75DE 0846             byte  8
0079 75DF ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 75E8 026B             byte  2
0084 75E9 ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 75EC 054C             byte  5
0089 75ED ....             text  'Lines'
0090                       even
0091               
0092               txt.bufnum
0093 75F2 0323             byte  3
0094 75F3 ....             text  '#1 '
0095                       even
0096               
0097               txt.newfile
0098 75F6 0A5B             byte  10
0099 75F7 ....             text  '[New file]'
0100                       even
0101               
0102               txt.filetype.dv80
0103 7602 0444             byte  4
0104 7603 ....             text  'DV80'
0105                       even
0106               
0107               txt.m1
0108 7608 034D             byte  3
0109 7609 ....             text  'M1='
0110                       even
0111               
0112               txt.m2
0113 760C 034D             byte  3
0114 760D ....             text  'M2='
0115                       even
0116               
0117               txt.keys.default
0118 7610 135E             byte  19
0119 7611 ....             text  '^Help, ^Open, ^Save'
0120                       even
0121               
0122               txt.keys.block
0123 7624 2B5E             byte  43
0124 7625 ....             text  '^Del, ^Copy, ^Move, ^Goto M1, ^Reset, ^Save'
0125                       even
0126               
0127 7650 ....     txt.ruler          text    '.........'
0128                                  byte    18
0129 765A ....                        text    '.........'
0130                                  byte    19
0131 7664 ....                        text    '.........'
0132                                  byte    20
0133 766E ....                        text    '.........'
0134                                  byte    21
0135 7678 ....                        text    '.........'
0136                                  byte    22
0137 7682 ....                        text    '.........'
0138                                  byte    23
0139 768C ....                        text    '.........'
0140                                  byte    24
0141 7696 ....                        text    '.........'
0142                                  byte    25
0143                                  even
0144               
0145 76A0 020E     txt.alpha.down     data >020e,>0f00
     76A2 0F00 
0146 76A4 0110     txt.vertline       data >0110
0147               
0148               txt.ws1
0149 76A6 0120             byte  1
0150 76A7 ....             text  ' '
0151                       even
0152               
0153               txt.ws2
0154 76A8 0220             byte  2
0155 76A9 ....             text  '  '
0156                       even
0157               
0158               txt.ws3
0159 76AC 0320             byte  3
0160 76AD ....             text  '   '
0161                       even
0162               
0163               txt.ws4
0164 76B0 0420             byte  4
0165 76B1 ....             text  '    '
0166                       even
0167               
0168               txt.ws5
0169 76B6 0520             byte  5
0170 76B7 ....             text  '     '
0171                       even
0172               
0173      35EA     txt.filetype.none  equ txt.ws4
0174               
0175               
0176               ;--------------------------------------------------------------
0177               ; Dialog Load DV 80 file
0178               ;--------------------------------------------------------------
0179 76BC 1301     txt.head.load      byte 19,1,3,32
     76BE 0320 
0180 76C0 ....                        text 'Open DV80 file '
0181                                  byte 2
0182               txt.hint.load
0183 76D0 4746             byte  71
0184 76D1 ....             text  'Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0185                       even
0186               
0187               txt.keys.load
0188 7718 3246             byte  50
0189 7719 ....             text  'F9=Back, F3=Clear, F5=Fastmode, F-H=Home, F-L=End '
0190                       even
0191               
0192               txt.keys.load2
0193 774C 3246             byte  50
0194 774D ....             text  'F9=Back, F3=Clear, *F5=Fastmode, F-H=Home, F-L=End'
0195                       even
0196               
0197               
0198               ;--------------------------------------------------------------
0199               ; Dialog Save DV 80 file
0200               ;--------------------------------------------------------------
0201 7780 1301     txt.head.save      byte 19,1,3,32
     7782 0320 
0202 7784 ....                        text 'Save DV80 file '
0203                                  byte 2
0204 7794 2301     txt.head.save2     byte 35,1,3,32
     7796 0320 
0205 7798 ....                        text 'Save marked block to DV80 file '
0206                                  byte 2
0207               txt.hint.save
0208 77B8 0120             byte  1
0209 77B9 ....             text  ' '
0210                       even
0211               
0212               txt.keys.save
0213 77BA 2446             byte  36
0214 77BB ....             text  'F9=Back, F3=Clear, F-H=Home, F-L=End'
0215                       even
0216               
0217               
0218               ;--------------------------------------------------------------
0219               ; Dialog "Unsaved changes"
0220               ;--------------------------------------------------------------
0221 77E0 1401     txt.head.unsaved   byte 20,1,3,32
     77E2 0320 
0222 77E4 ....                        text 'Unsaved changes '
0223 77F4 0221                        byte 2
0224               txt.info.unsaved
0225                       byte  33
0226 77F6 ....             text  'Warning! Unsaved changes in file.'
0227                       even
0228               
0229               txt.hint.unsaved
0230 7818 2A50             byte  42
0231 7819 ....             text  'Press F6 to proceed or ENTER to save file.'
0232                       even
0233               
0234               txt.keys.unsaved
0235 7844 2446             byte  36
0236 7845 ....             text  'F9=Back, F6=Proceed, ENTER=Save file'
0237                       even
0238               
0239               
0240               ;--------------------------------------------------------------
0241               ; Dialog "About"
0242               ;--------------------------------------------------------------
0243 786A 0A01     txt.head.about     byte 10,1,3,32
     786C 0320 
0244 786E ....                        text 'About '
0245 7874 0200                        byte 2
0246               
0247               txt.info.about
0248                       byte  0
0249 7876 ....             text
0250                       even
0251               
0252               txt.hint.about
0253 7876 2650             byte  38
0254 7877 ....             text  'Press F9 or ENTER to return to editor.'
0255                       even
0256               
0257 789E 2746     txt.keys.about     byte 39
0258 789F ....                        text 'F9=Back, ENTER=Back, '
0259 78B4 0E0F                        byte 14,15
0260 78B6 ....                        text '=Alpha Lock down'
0261               
0262               ;--------------------------------------------------------------
0263               ; Strings for error line pane
0264               ;--------------------------------------------------------------
0265               txt.ioerr.load
0266 78C6 2049             byte  32
0267 78C7 ....             text  'I/O error. Failed loading file: '
0268                       even
0269               
0270               txt.ioerr.save
0271 78E8 2049             byte  32
0272 78E9 ....             text  'I/O error. Failed saving file:  '
0273                       even
0274               
0275               txt.memfull.load
0276 790A 4049             byte  64
0277 790B ....             text  'Index memory full. Could not fully load file into editor buffer.'
0278                       even
0279               
0280               txt.io.nofile
0281 794C 2149             byte  33
0282 794D ....             text  'I/O error. No filename specified.'
0283                       even
0284               
0285               txt.block.inside
0286 796E 3445             byte  52
0287 796F ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0288                       even
0289               
0290               
0291               ;--------------------------------------------------------------
0292               ; Strings for command buffer
0293               ;--------------------------------------------------------------
0294               txt.cmdb.prompt
0295 79A4 013E             byte  1
0296 79A5 ....             text  '>'
0297                       even
0298               
0299               txt.colorscheme
0300 79A6 0D43             byte  13
0301 79A7 ....             text  'Color scheme:'
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
0022 79B4 DEAD             data  >dead,>beef,>dead,>beef
     79B6 BEEF 
     79B8 DEAD 
     79BA BEEF 
**** **** ****     > stevie_b0.asm.3171309
0160               
0164 79BC 38F6                   data $                ; Bank 0 ROM size OK.
0166               
0167                       ;------------------------------------------------------
0168                       ; Data patterns
0169                       ;------------------------------------------------------
0170                       copy  "data.patterns.asm"
**** **** ****     > data.patterns.asm
0001               * FILE......: data.patterns.asm
0002               * Purpose...: Sprite and character patterns
0003               
0004               ;--------------------------------------------------------------
0005               ; Sprite patterns
0006               ;--------------------------------------------------------------
0007               cursors:
0008 79BE 0000             byte  >00,>00,>00,>00,>00,>00,>00,>1c ; Cursor 1 - Insert mode
     79C0 0000 
     79C2 0000 
     79C4 001C 
0009 79C6 1010             byte  >10,>10,>10,>10,>10,>10,>10,>00 ; Cursor 2 - Insert mode
     79C8 1010 
     79CA 1010 
     79CC 1000 
0010 79CE 1C1C             byte  >1c,>1c,>1c,>1c,>1c,>1c,>1c,>00 ; Cursor 3 - Overwrite mode
     79D0 1C1C 
     79D2 1C1C 
     79D4 1C00 
0011 79D6 0001             byte  >00,>01,>03,>07,>07,>03,>01,>00 ; Current line indicator    <
     79D8 0307 
     79DA 0703 
     79DC 0100 
0012 79DE 1C08             byte  >1c,>08,>00,>00,>00,>00,>00,>00 ; Current column indicator  v
     79E0 0000 
     79E2 0000 
     79E4 0000 
0013               
0014               
0015               
0016               
0017               
0018               ;--------------------------------------------------------------
0019               ; Character patterns
0020               ;--------------------------------------------------------------
0021               patterns:
0022 79E6 0000             data  >0000,>0000,>ff00,>0000 ; 01. Single line
     79E8 0000 
     79EA FF00 
     79EC 0000 
0023 79EE 8080             data  >8080,>8080,>ff80,>8080 ; 02. Connector |-
     79F0 8080 
     79F2 FF80 
     79F4 8080 
0024 79F6 0404             data  >0404,>0404,>ff04,>0404 ; 03. Connector -|
     79F8 0404 
     79FA FF04 
     79FC 0404 
0025               
0026               patterns.box:
0027 79FE 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     7A00 0000 
     7A02 FF80 
     7A04 BFA0 
0028 7A06 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     7A08 0000 
     7A0A FC04 
     7A0C F414 
0029 7A0E A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     7A10 A0A0 
     7A12 A0A0 
     7A14 A0A0 
0030 7A16 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     7A18 1414 
     7A1A 1414 
     7A1C 1414 
0031 7A1E A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     7A20 A0A0 
     7A22 BF80 
     7A24 FF00 
0032 7A26 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     7A28 1414 
     7A2A F404 
     7A2C FC00 
0033 7A2E 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     7A30 C0C0 
     7A32 C0C0 
     7A34 0080 
0034 7A36 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     7A38 0F0F 
     7A3A 0F0F 
     7A3C 0000 
0035               
0036               
0037               patterns.cr:
0038 7A3E 6C48             data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
     7A40 6C48 
     7A42 4800 
     7A44 7C00 
0039 7A46 0024             data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow
     7A48 64FC 
     7A4A 6020 
     7A4C 0000 
0040               
0041               
0042               alphalock:
0043 7A4E FFC0             data  >ffc0,>8894,>9c94,>c0ff ; 14. alpha lock down - char1
     7A50 8894 
     7A52 9C94 
     7A54 C0FF 
0044 7A56 FC0C             data  >fc0c,>4444,>4474,>0cfc ; 15. alpha lock down - char2
     7A58 4444 
     7A5A 4474 
     7A5C 0CFC 
0045               
0046               
0047               vertline:
0048 7A5E 1010             data  >1010,>1010,>1010,>1010 ; 16. Vertical line
     7A60 1010 
     7A62 1010 
     7A64 1010 
0049 7A66 0000             data  >0000,>0000,>3030,>3030 ; 17. Tab indicator
     7A68 0000 
     7A6A 3030 
     7A6C 3030 
0050               
0051               
0052               low.digits:
0053                       ; digits 1-4 (18-21)
0054 7A6E 0000             byte >00,>00,>00,>10,>30,>10,>10,>38
     7A70 0010 
     7A72 3010 
     7A74 1038 
0055 7A76 0000             byte >00,>00,>00,>38,>08,>38,>20,>38
     7A78 0038 
     7A7A 0838 
     7A7C 2038 
0056 7A7E 0000             byte >00,>00,>00,>38,>08,>38,>08,>38
     7A80 0038 
     7A82 0838 
     7A84 0838 
0057 7A86 0000             byte >00,>00,>00,>28,>28,>38,>08,>08
     7A88 0028 
     7A8A 2838 
     7A8C 0808 
0058                       ; digits 5-8 (22-25)
0059 7A8E 0000             byte >00,>00,>00,>38,>20,>38,>08,>38
     7A90 0038 
     7A92 2038 
     7A94 0838 
0060 7A96 0000             byte >00,>00,>00,>38,>20,>38,>28,>38
     7A98 0038 
     7A9A 2038 
     7A9C 2838 
0061 7A9E 0000             byte >00,>00,>00,>38,>08,>10,>20,>20
     7AA0 0038 
     7AA2 0810 
     7AA4 2020 
0062 7AA6 0000             byte >00,>00,>00,>38,>28,>38,>28,>38
     7AA8 0038 
     7AAA 2838 
     7AAC 2838 
**** **** ****     > stevie_b0.asm.3171309
0171                       ;------------------------------------------------------
0172                       ; Bank specific vector table
0173                       ;------------------------------------------------------
0177 7AAE 39E8                   data $                ; Bank 0 ROM size OK.
0179                       ;-------------------------------------------------------
0180                       ; Vector table bank 0: >7f9c - >7fff
0181                       ;-------------------------------------------------------
0182                       copy  "rom.vectors.bank0.asm"
**** **** ****     > rom.vectors.bank0.asm
0001               * FILE......: rom.vectors.bank0.asm
0002               * Purpose...: Bank 0 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 607A     vec.1   data  vdp.patterns.dump     ;
0010 7F9E 2026     vec.2   data  cpu.crash             ;
0011 7FA0 2026     vec.3   data  cpu.crash             ;
0012 7FA2 2026     vec.4   data  cpu.crash             ;
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
**** **** ****     > stevie_b0.asm.3171309
0183               
0184               
0185               
0186               
0187               *--------------------------------------------------------------
0188               * Video mode configuration for SP2
0189               *--------------------------------------------------------------
0190      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0191      0004     spfbck  equ   >04                   ; Screen background color.
0192      33A2     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0193      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0194      0050     colrow  equ   80                    ; Columns per row
0195      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0196      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0197      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0198      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

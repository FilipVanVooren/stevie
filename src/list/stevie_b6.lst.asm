XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b6.asm.1052616
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b6.asm               ; Version 210912-1052616
0010               *
0011               * Bank 6 "Jenifer"
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
0018      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0019      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0020      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0021      0001     skip_random_generator     equ  1       ; Skip random functions
0022      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0023               *--------------------------------------------------------------
0024               * Classic99 F18a 24x80, no FG99 advanced mode
0025               *--------------------------------------------------------------
0026      0001     device.f18a               equ  1       ; F18a GPU
0027      0000     device.9938               equ  0       ; 9938 GPU
0028      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode on
0029               
0030               
0031               *--------------------------------------------------------------
0032               * JS99er F18a 30x80, FG99 advanced mode
0033               *--------------------------------------------------------------
0034               ; device.f18a             equ  0       ; F18a GPU
0035               ; device.9938             equ  1       ; 9938 GPU
0036               ; device.fg99.mode.adv    equ  1       ; FG99 advanced mode on
**** **** ****     > stevie_b6.asm.1052616
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
0012      600A     bank5.rom                 equ  >600a   ; Jumbo
0013      600C     bank6.rom                 equ  >600c   ; Jenifer
0014      600E     bank7.rom                 equ  >600e   ; Jonas
0015               *--------------------------------------------------------------
0016               * RAM 4K banks (Only valid in advanced mode FG99)
0017               *--------------------------------------------------------------
0018      6800     bank0.ram                 equ  >6800   ; Jill
0019      6802     bank1.ram                 equ  >6802   ; James
0020      6804     bank2.ram                 equ  >6804   ; Jacky
0021      6806     bank3.ram                 equ  >6806   ; John
0022      6808     bank4.ram                 equ  >6808   ; Janine
0023      680A     bank5.ram                 equ  >680a   ; Jumbo
0024      680C     bank6.ram                 equ  >680c   ; Jenifer
0025      680E     bank7.ram                 equ  >680e   ; Jonas
**** **** ****     > stevie_b6.asm.1052616
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
0013               *     2000-2f1f    3872           spectra2 core library
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
0046               *     eef0-efef     256           Backup scratchpad memory
0047               *     eff0-efff      16           Farjump return stack (trampolines)
0048               *     f000-ffff    4096           spectra2 extended library
0049               *
0050               *
0051               * CARTRIDGE SPACE (6000-7fff)
0052               *
0053               *     Mem range   Bytes    BANK   Purpose
0054               *     =========   =====    ====   ==================================
0055               *     6000-633f               0   Cartridge header
0056               *     6040-7fff               0   SP2 library + Stevie library
0057               *                                 relocated to RAM space
0058               *     ..............................................................
0059               *     6000-633f               1   Cartridge header
0060               *     6040-7fbf               1   Stevie program code
0061               *     7fc0-7fff      64       1   Vector table (32 vectors)
0062               *     ..............................................................
0063               *     6000-633f               2   Cartridge header
0064               *     6040-7fbf               2   Stevie program code
0065               *     7fc0-7fff      64       2   Vector table (32 vectors)
0066               *     ..............................................................
0067               *     6000-633f               3   Cartridge header
0068               *     6040-7fbf               3   Stevie program code
0069               *     7fc0-7fff      64       3   Vector table (32 vectors)
0070               *     ..............................................................
0071               *     6000-633f               4   Cartridge header
0072               *     6040-7fbf               4   Stevie program code
0073               *     7fc0-7fff      64       4   Vector table (32 vectors)
0074               *     ..............................................................
0075               *     6000-633f               5   Cartridge header
0076               *     6040-7fbf               5   Stevie program code
0077               *     7fc0-7fff      64       5   Vector table (32 vectors)
0078               *     ..............................................................
0079               *     6000-633f               6   Cartridge header
0080               *     6040-7fbf               6   Stevie program code
0081               *     7fc0-7fff      64       6   Vector table (32 vectors)
0082               *     ..............................................................
0083               *     6000-633f               7   Cartridge header
0084               *     6040-7fbf               7   SP2 library in cartridge space
0085               *     7fc0-7fff      64       7   Vector table (32 vectors)
0086               *
0087               *
0088               *
0089               * VDP RAM F18a (0000-47ff)
0090               *
0091               *     Mem range   Bytes    Hex    Purpose
0092               *     =========   =====   =====   =================================
0093               *     0000-095f    2400   >0960   PNT: Pattern Name Table
0094               *     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
0095               *     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
0096               *     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
0097               *     1800-215f    2400   >0960   TAT: Tile Attribute Table
0098               *                                      (Position based colors F18a, 80 colums)
0099               *     2180                        SAT: Sprite Attribute Table
0100               *                                      (Cursor in F18a, 80 cols mode)
0101               *     2800                        SPT: Sprite Pattern Table
0102               *                                      (Cursor in F18a, 80 columns, 2K boundary)
0103               *===============================================================================
0104               
0105               *--------------------------------------------------------------
0106               * Graphics mode selection
0107               *--------------------------------------------------------------
0109               
0110      001D     pane.botrow               equ  29      ; Bottom row on screen
0111               
0117               *--------------------------------------------------------------
0118               * Stevie Dialog / Pane specific equates
0119               *--------------------------------------------------------------
0120      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0121      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0122               ;-----------------------------------------------------------------
0123               ;   Dialog ID's >= 100 indicate that command prompt should be
0124               ;   hidden and no characters added to CMDB keyboard buffer
0125               ;-----------------------------------------------------------------
0126      000A     id.dialog.load            equ  10      ; "Load DV80 file"
0127      000B     id.dialog.save            equ  11      ; "Save DV80 file"
0128      000C     id.dialog.saveblock       equ  12      ; "Save codeblock to DV80 file"
0129      0064     id.dialog.menu            equ  100     ; "Stevie Menu"
0130      0065     id.dialog.unsaved         equ  101     ; "Unsaved changes"
0131      0066     id.dialog.block           equ  102     ; "Block move/copy/delete"
0132      0067     id.dialog.about           equ  103     ; "About"
0133      0068     id.dialog.file            equ  104     ; "File"
0134      0069     id.dialog.basic           equ  105     ; "Basic"
0135               *--------------------------------------------------------------
0136               * Stevie specific equates
0137               *--------------------------------------------------------------
0138      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0139      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0140      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0141      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0142      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0143      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0144                                                      ; VDP TAT address of 1st CMDB row
0145      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0146                                                      ; VDP SIT size 80 columns, 24/30 rows
0147      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0148      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0149               *--------------------------------------------------------------
0150               * SPECTRA2 / Stevie startup options
0151               *--------------------------------------------------------------
0152      0001     debug                     equ  1       ; Turn on spectra2 debugging
0153      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0154      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0155      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0156      7E00     cpu.scrpad.tgt            equ  >7e00   ; \ Dump of OS monitor scratchpad
0157                                                      ; | memory stored in cartridge ROM
0158                                                      ; / bank3.asm
0159               *--------------------------------------------------------------
0160               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0161               *--------------------------------------------------------------
0162      A000     core1.top         equ  >a000           ; Structure begin
0163      A000     parm1             equ  core1.top + 0   ; Function parameter 1
0164      A002     parm2             equ  core1.top + 2   ; Function parameter 2
0165      A004     parm3             equ  core1.top + 4   ; Function parameter 3
0166      A006     parm4             equ  core1.top + 6   ; Function parameter 4
0167      A008     parm5             equ  core1.top + 8   ; Function parameter 5
0168      A00A     parm6             equ  core1.top + 10  ; Function parameter 6
0169      A00C     parm7             equ  core1.top + 12  ; Function parameter 7
0170      A00E     parm8             equ  core1.top + 14  ; Function parameter 8
0171      A010     outparm1          equ  core1.top + 16  ; Function output parameter 1
0172      A012     outparm2          equ  core1.top + 18  ; Function output parameter 2
0173      A014     outparm3          equ  core1.top + 20  ; Function output parameter 3
0174      A016     outparm4          equ  core1.top + 22  ; Function output parameter 4
0175      A018     outparm5          equ  core1.top + 24  ; Function output parameter 5
0176      A01A     outparm6          equ  core1.top + 26  ; Function output parameter 6
0177      A01C     outparm7          equ  core1.top + 28  ; Function output parameter 7
0178      A01E     outparm8          equ  core1.top + 30  ; Function output parameter 8
0179      A020     keyrptcnt         equ  core1.top + 32  ; Key repeat-count (auto-repeat function)
0180      A022     keycode1          equ  core1.top + 34  ; Current key scanned
0181      A024     keycode2          equ  core1.top + 36  ; Previous key scanned
0182      A026     unpacked.string   equ  core1.top + 38  ; 6 char string with unpacked uin16
0183      A02C     core1.free        equ  core1.top + 44  ; End of structure
0184               *--------------------------------------------------------------
0185               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0186               *--------------------------------------------------------------
0187      A100     core2.top         equ  >a100           ; Structure begin
0188      A100     timers            equ  core2.top       ; Timer table
0189      A140     rambuf            equ  core2.top + 64  ; RAM workbuffer
0190      A180     ramsat            equ  core2.top + 128 ; Sprite Attribute Table in RAM
0191      A1A0     core2.free        equ  core2.top + 160 ; End of structure
0192               *--------------------------------------------------------------
0193               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0194               *--------------------------------------------------------------
0195      A200     tv.top            equ  >a200           ; Structure begin
0196      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0197      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0198      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0199      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0200      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0201      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0202      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0203      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0204      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0205      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0206      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0207      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0208      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0209      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0210      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0211      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0212      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0213      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0214      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0215      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0216      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0217      A22A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0218      A2CA     tv.free           equ  tv.top + 202    ; End of structure
0219               *--------------------------------------------------------------
0220               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0221               *--------------------------------------------------------------
0222      A300     fb.struct         equ  >a300           ; Structure begin
0223      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0224      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0225      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0226                                                      ; line X in editor buffer).
0227      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0228                                                      ; (offset 0 .. @fb.scrrows)
0229      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0230      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0231      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0232      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0233      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0234      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0235      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0236      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0237      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0238      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0239      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0240      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0241      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0242      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0243               *--------------------------------------------------------------
0244               * File handle structure               @>a400-a4ff   (256 bytes)
0245               *--------------------------------------------------------------
0246      A400     fh.struct         equ  >a400           ; stevie file handling structures
0247               ;***********************************************************************
0248               ; ATTENTION
0249               ; The dsrlnk variables must form a continuous memory block and keep
0250               ; their order!
0251               ;***********************************************************************
0252      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0253      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0254      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0255      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0256      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0257      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0258      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0259      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0260      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0261      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0262      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0263      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0264      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0265      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0266      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0267      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0268      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0269      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0270      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0271      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0272      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0273      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0274      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0275      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0276      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0277      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0278      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0279      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0280      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0281      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0282      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0283      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0284               *--------------------------------------------------------------
0285               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0286               *--------------------------------------------------------------
0287      A500     edb.struct        equ  >a500           ; Begin structure
0288      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0289      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0290      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0291      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0292      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0293      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0294      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0295      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0296      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0297      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0298                                                      ; with current filename.
0299      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0300                                                      ; with current file type.
0301      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0302      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0303      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0304                                                      ; for filename, but not always used.
0305      A569     edb.free          equ  edb.struct + 105; End of structure
0306               *--------------------------------------------------------------
0307               * Index structure                     @>a600-a6ff   (256 bytes)
0308               *--------------------------------------------------------------
0309      A600     idx.struct        equ  >a600           ; stevie index structure
0310      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0311      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0312      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0313      A606     idx.free          equ  idx.struct + 6  ; End of structure
0314               *--------------------------------------------------------------
0315               * Command buffer structure            @>a700-a7ff   (256 bytes)
0316               *--------------------------------------------------------------
0317      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0318      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0319      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0320      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0321      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0322      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0323      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0324      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0325      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0326      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0327      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0328      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0329      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0330      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0331      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0332      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0333      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0334      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0335      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0336      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0337      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0338      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0339      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0340      A779     cmdb.free         equ  cmdb.struct +121; End of structure
0341               *--------------------------------------------------------------
0342               * Farjump return stack                @>af00-afff   (256 bytes)
0343               *--------------------------------------------------------------
0344      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0345                                                      ; Grows downwards from high to low.
0346               *--------------------------------------------------------------
0347               * Index                               @>b000-bfff  (4096 bytes)
0348               *--------------------------------------------------------------
0349      B000     idx.top           equ  >b000           ; Top of index
0350      1000     idx.size          equ  4096            ; Index size
0351               *--------------------------------------------------------------
0352               * Editor buffer                       @>c000-cfff  (4096 bytes)
0353               *--------------------------------------------------------------
0354      C000     edb.top           equ  >c000           ; Editor buffer high memory
0355      1000     edb.size          equ  4096            ; Editor buffer size
0356               *--------------------------------------------------------------
0357               * Frame buffer                        @>d000-dfff  (4096 bytes)
0358               *--------------------------------------------------------------
0359      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0360      0960     fb.size           equ  80*30           ; Frame buffer size
0361               *--------------------------------------------------------------
0362               * Command buffer history              @>e000-efff  (4096 bytes)
0363               *--------------------------------------------------------------
0364      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0365      1000     cmdb.size         equ  4096            ; Command buffer size
0366               *--------------------------------------------------------------
0367               * Heap                                @>f000-ffff  (4096 bytes)
0368               *--------------------------------------------------------------
0369      F000     heap.top          equ  >f000           ; Top of heap
**** **** ****     > stevie_b6.asm.1052616
0017               
0018               ***************************************************************
0019               * Spectra2 core configuration
0020               ********|*****|*********************|**************************
0021      AF00     sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
0022                                                   ; grows from high to low.
0023               ***************************************************************
0024               * BANK 6
0025               ********|*****|*********************|**************************
0026      600C     bankid  equ   bank6.rom             ; Set bank identifier to current bank
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
0031 600E 6040             data  kickstart.code1       ; 14 \ Program address                 >600e
0032                                                   ; 15 /
0033               
0035               
0043               
0044 6010 0B53             byte  11
0045 6011 ....             text  'STEVIE 1.1T'
0046                       even
0047               
0049               
**** **** ****     > stevie_b6.asm.1052616
0030               
0031               ***************************************************************
0032               * Step 1: Switch to bank 0 (uniform code accross all banks)
0033               ********|*****|*********************|**************************
0034                       aorg  kickstart.code1       ; >6040
0035 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000 
0036               ***************************************************************
0037               * Step 2: Satisfy assembler, must know relocated code
0038               ********|*****|*********************|**************************
0039                       xorg  >2000                 ; Relocate to >2000
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
0069               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300->83ff
0070               *                                   ; to pre-defined backup address
0071               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0072               *******************************************************************************
0073               
0074               *//////////////////////////////////////////////////////////////
0075               *                       RUNLIB SETUP
0076               *//////////////////////////////////////////////////////////////
0077               
0078                       copy  "memsetup.equ"             ; Equates runlib scratchpad mem setup
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
0079                       copy  "registers.equ"            ; Equates runlib registers
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
0080                       copy  "portaddr.equ"             ; Equates runlib hw port addresses
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
0081                       copy  "param.equ"                ; Equates runlib parameters
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
0082               
0086               
0087                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
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
0012 6044 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 6046 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 6048 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 604A 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 604C 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 604E 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 6050 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 6052 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 6054 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 6056 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 6058 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 605A 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 605C 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 605E 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 6060 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 6062 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 6064 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 6066 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 6068 D000     w$d000  data  >d000                 ; >d000
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
0088                       copy  "config.equ"               ; Equates for bits in config register
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
0089                       copy  "cpu_crash.asm"            ; CPU crash handler
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
0038 606A 022B  22         ai    r11,-4                ; Remove opcode offset
     606C FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 606E C800  38         mov   r0,@>ffe0
     6070 FFE0 
0043 6072 C801  38         mov   r1,@>ffe2
     6074 FFE2 
0044 6076 C802  38         mov   r2,@>ffe4
     6078 FFE4 
0045 607A C803  38         mov   r3,@>ffe6
     607C FFE6 
0046 607E C804  38         mov   r4,@>ffe8
     6080 FFE8 
0047 6082 C805  38         mov   r5,@>ffea
     6084 FFEA 
0048 6086 C806  38         mov   r6,@>ffec
     6088 FFEC 
0049 608A C807  38         mov   r7,@>ffee
     608C FFEE 
0050 608E C808  38         mov   r8,@>fff0
     6090 FFF0 
0051 6092 C809  38         mov   r9,@>fff2
     6094 FFF2 
0052 6096 C80A  38         mov   r10,@>fff4
     6098 FFF4 
0053 609A C80B  38         mov   r11,@>fff6
     609C FFF6 
0054 609E C80C  38         mov   r12,@>fff8
     60A0 FFF8 
0055 60A2 C80D  38         mov   r13,@>fffa
     60A4 FFFA 
0056 60A6 C80E  38         mov   r14,@>fffc
     60A8 FFFC 
0057 60AA C80F  38         mov   r15,@>ffff
     60AC FFFF 
0058 60AE 02A0  12         stwp  r0
0059 60B0 C800  38         mov   r0,@>ffdc
     60B2 FFDC 
0060 60B4 02C0  12         stst  r0
0061 60B6 C800  38         mov   r0,@>ffde
     60B8 FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 60BA 02E0  18         lwpi  ws1                   ; Activate workspace 1
     60BC 8300 
0067 60BE 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     60C0 8302 
0068 60C2 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     60C4 4A4A 
0069 60C6 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     60C8 2FDE 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 60CA 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     60CC 2306 
0078 60CE 21EC                   data graph1           ; Equate selected video mode table
0079               
0080 60D0 06A0  32         bl    @ldfnt
     60D2 236E 
0081 60D4 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     60D6 000C 
0082               
0083 60D8 06A0  32         bl    @filv
     60DA 229C 
0084 60DC 0380                   data >0380,>f0,32*24  ; Load color table
     60DE 00F0 
     60E0 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 60E2 06A0  32         bl    @putat                ; Show crash message
     60E4 2450 
0089 60E6 0000                   data >0000,cpu.crash.msg.crashed
     60E8 2178 
0090               
0091 60EA 06A0  32         bl    @puthex               ; Put hex value on screen
     60EC 2A9A 
0092 60EE 0015                   byte 0,21             ; \ i  p0 = YX position
0093 60F0 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 60F2 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 60F4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 60F6 06A0  32         bl    @putat                ; Show caller message
     60F8 2450 
0101 60FA 0100                   data >0100,cpu.crash.msg.caller
     60FC 218E 
0102               
0103 60FE 06A0  32         bl    @puthex               ; Put hex value on screen
     6100 2A9A 
0104 6102 0115                   byte 1,21             ; \ i  p0 = YX position
0105 6104 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 6106 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 6108 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 610A 06A0  32         bl    @putat
     610C 2450 
0113 610E 0300                   byte 3,0
0114 6110 21AA                   data cpu.crash.msg.wp
0115 6112 06A0  32         bl    @putat
     6114 2450 
0116 6116 0400                   byte 4,0
0117 6118 21B0                   data cpu.crash.msg.st
0118 611A 06A0  32         bl    @putat
     611C 2450 
0119 611E 1600                   byte 22,0
0120 6120 21B6                   data cpu.crash.msg.source
0121 6122 06A0  32         bl    @putat
     6124 2450 
0122 6126 1700                   byte 23,0
0123 6128 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 612A 06A0  32         bl    @at                   ; Put cursor at YX
     612C 26DC 
0128 612E 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 6130 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6132 FFDC 
0132 6134 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 6136 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 6138 0649  14         dect  stack
0138 613A C644  30         mov   tmp0,*stack           ; Push tmp0
0139 613C 0649  14         dect  stack
0140 613E C645  30         mov   tmp1,*stack           ; Push tmp1
0141 6140 0649  14         dect  stack
0142 6142 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 6144 C046  18         mov   tmp2,r1               ; Save register number
0148 6146 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     6148 0001 
0149 614A 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 614C 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 614E 06A0  32         bl    @mknum
     6150 2AA4 
0154 6152 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 6154 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 6156 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 6158 06A0  32         bl    @setx                 ; Set cursor X position
     615A 26F2 
0160 615C 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 615E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6160 242C 
0164 6162 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 6164 06A0  32         bl    @setx                 ; Set cursor X position
     6166 26F2 
0168 6168 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 616A 0281  22         ci    r1,10
     616C 000A 
0172 616E 1102  14         jlt   !
0173 6170 0620  34         dec   @wyx                  ; x=x-1
     6172 832A 
0174               
0175 6174 06A0  32 !       bl    @putstr
     6176 242C 
0176 6178 21A4                   data cpu.crash.msg.r
0177               
0178 617A 06A0  32         bl    @mknum
     617C 2AA4 
0179 617E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 6180 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 6182 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 6184 06A0  32         bl    @mkhex                ; Convert hex word to string
     6186 2A16 
0188 6188 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 618A A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 618C 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 618E 06A0  32         bl    @setx                 ; Set cursor X position
     6190 26F2 
0194 6192 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 6194 06A0  32         bl    @putstr               ; Put '  >'
     6196 242C 
0198 6198 21A6                   data cpu.crash.msg.marker
0199               
0200 619A 06A0  32         bl    @setx                 ; Set cursor X position
     619C 26F2 
0201 619E 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61A0 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61A2 242C 
0205 61A4 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61A6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61AC 06A0  32         bl    @down                 ; y=y+1
     61AE 26E2 
0213               
0214 61B0 0586  14         inc   tmp2
0215 61B2 0286  22         ci    tmp2,17
     61B4 0011 
0216 61B6 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 61B8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     61BA 2ED2 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 61BC 1553             byte  21
0225 61BD ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 61D2 1543             byte  21
0230 61D3 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 61E8 0152             byte  1
0235 61E9 ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 61EA 0320             byte  3
0240 61EB ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 61EE 042A             byte  4
0245 61EF ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 61F4 042A             byte  4
0250 61F5 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 61FA 1B53             byte  27
0255 61FB ....             text  'Source    stevie_b6.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 6216 1842             byte  24
0260 6217 ....             text  'Build-ID  210912-1052616'
0261                       even
0262               
**** **** ****     > runlib.asm
0090                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 6230 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6232 000E 
     6234 0106 
     6236 0204 
     6238 0020 
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
0029               
0030               ***************************************************************
0031               * TI Basic mode 1 (32 columns/24 rows)
0032               *--------------------------------------------------------------
0033 623A 00E2     tibasic byte  >00,>e2,>00,>0c,>00,>06,>00,SPFBCK,0,32
     623C 000C 
     623E 0006 
     6240 0004 
     6242 0020 
0034               *
0035               * ; VDP#0 Control bits
0036               * ;      bit 6=0: M3 | Graphics 1 mode
0037               * ;      bit 7=0: Disable external VDP input
0038               * ; VDP#1 Control bits
0039               * ;      bit 0=1: 16K selection
0040               * ;      bit 1=1: Enable display
0041               * ;      bit 2=1: Enable VDP interrupt
0042               * ;      bit 3=0: M1 \ Graphics 1 mode
0043               * ;      bit 4=0: M2 /
0044               * ;      bit 5=0: reserved
0045               * ;      bit 6=1: 16x16 sprites
0046               * ;      bit 7=0: Sprite magnification (1x)
0047               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0048               * ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
0049               * ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
0050               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0051               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0052               * ; VDP#7 Set screen background color
0053               
0054               
0055               
0056               
0057               ***************************************************************
0058               * Textmode (40 columns/24 rows)
0059               *--------------------------------------------------------------
0060 6244 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6246 000E 
     6248 0106 
     624A 00F4 
     624C 0028 
0061               *
0062               * ; VDP#0 Control bits
0063               * ;      bit 6=0: M3 | Graphics 1 mode
0064               * ;      bit 7=0: Disable external VDP input
0065               * ; VDP#1 Control bits
0066               * ;      bit 0=1: 16K selection
0067               * ;      bit 1=1: Enable display
0068               * ;      bit 2=1: Enable VDP interrupt
0069               * ;      bit 3=1: M1 \ TEXT MODE
0070               * ;      bit 4=0: M2 /
0071               * ;      bit 5=0: reserved
0072               * ;      bit 6=1: 16x16 sprites
0073               * ;      bit 7=0: Sprite magnification (1x)
0074               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0075               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0076               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0077               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0078               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0079               * ; VDP#7 Set foreground/background color
0080               ***************************************************************
0081               
0082               
0083               ***************************************************************
0084               * Textmode (80 columns, 24 rows) - F18A
0085               *--------------------------------------------------------------
0086 624E 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6250 003F 
     6252 0240 
     6254 03F4 
     6256 0050 
0087               *
0088               * ; VDP#0 Control bits
0089               * ;      bit 6=0: M3 | Graphics 1 mode
0090               * ;      bit 7=0: Disable external VDP input
0091               * ; VDP#1 Control bits
0092               * ;      bit 0=1: 16K selection
0093               * ;      bit 1=1: Enable display
0094               * ;      bit 2=1: Enable VDP interrupt
0095               * ;      bit 3=1: M1 \ TEXT MODE
0096               * ;      bit 4=0: M2 /
0097               * ;      bit 5=0: reserved
0098               * ;      bit 6=0: 8x8 sprites
0099               * ;      bit 7=0: Sprite magnification (1x)
0100               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0101               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0102               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0103               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0104               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0105               * ; VDP#7 Set foreground/background color
0106               ***************************************************************
0107               
0108               
0109               ***************************************************************
0110               * Textmode (80 columns, 30 rows) - F18A
0111               *--------------------------------------------------------------
0112 6258 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     625A 003F 
     625C 0240 
     625E 03F4 
     6260 0050 
0113               *
0114               * ; VDP#0 Control bits
0115               * ;      bit 6=0: M3 | Graphics 1 mode
0116               * ;      bit 7=0: Disable external VDP input
0117               * ; VDP#1 Control bits
0118               * ;      bit 0=1: 16K selection
0119               * ;      bit 1=1: Enable display
0120               * ;      bit 2=1: Enable VDP interrupt
0121               * ;      bit 3=1: M1 \ TEXT MODE
0122               * ;      bit 4=0: M2 /
0123               * ;      bit 5=0: reserved
0124               * ;      bit 6=0: 8x8 sprites
0125               * ;      bit 7=0: Sprite magnification (1x)
0126               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0127               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0128               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0129               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0130               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0131               * ; VDP#7 Set foreground/background color
0132               ***************************************************************
**** **** ****     > runlib.asm
0091                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0013 6262 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6264 16FD             data  >16fd                 ; |         jne   mcloop
0015 6266 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6268 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 626A 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 626C 0201  20         li    r1,mccode             ; Machinecode to patch
     626E 221E 
0037 6270 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6272 8322 
0038 6274 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 6276 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 6278 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 627A 045B  20         b     *r11                  ; Return to caller
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
0056 627C C0F9  30 popr3   mov   *stack+,r3
0057 627E C0B9  30 popr2   mov   *stack+,r2
0058 6280 C079  30 popr1   mov   *stack+,r1
0059 6282 C039  30 popr0   mov   *stack+,r0
0060 6284 C2F9  30 poprt   mov   *stack+,r11
0061 6286 045B  20         b     *r11
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
0085 6288 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 628A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 628C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 628E C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 6290 1604  14         jne   filchk                ; No, continue checking
0093               
0094 6292 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6294 FFCE 
0095 6296 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6298 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 629A D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     629C 830B 
     629E 830A 
0100               
0101 62A0 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62A2 0001 
0102 62A4 1602  14         jne   filchk2
0103 62A6 DD05  32         movb  tmp1,*tmp0+
0104 62A8 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 62AA 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     62AC 0002 
0109 62AE 1603  14         jne   filchk3
0110 62B0 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 62B2 DD05  32         movb  tmp1,*tmp0+
0112 62B4 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 62B6 C1C4  18 filchk3 mov   tmp0,tmp3
0117 62B8 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62BA 0001 
0118 62BC 1305  14         jeq   fil16b
0119 62BE DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 62C0 0606  14         dec   tmp2
0121 62C2 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     62C4 0002 
0122 62C6 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 62C8 C1C6  18 fil16b  mov   tmp2,tmp3
0127 62CA 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62CC 0001 
0128 62CE 1301  14         jeq   dofill
0129 62D0 0606  14         dec   tmp2                  ; Make TMP2 even
0130 62D2 CD05  34 dofill  mov   tmp1,*tmp0+
0131 62D4 0646  14         dect  tmp2
0132 62D6 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 62D8 C1C7  18         mov   tmp3,tmp3
0137 62DA 1301  14         jeq   fil.exit
0138 62DC DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 62DE 045B  20         b     *r11
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
0159 62E0 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 62E2 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 62E4 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 62E6 0264  22 xfilv   ori   tmp0,>4000
     62E8 4000 
0166 62EA 06C4  14         swpb  tmp0
0167 62EC D804  38         movb  tmp0,@vdpa
     62EE 8C02 
0168 62F0 06C4  14         swpb  tmp0
0169 62F2 D804  38         movb  tmp0,@vdpa
     62F4 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 62F6 020F  20         li    r15,vdpw              ; Set VDP write address
     62F8 8C00 
0174 62FA 06C5  14         swpb  tmp1
0175 62FC C820  54         mov   @filzz,@mcloop        ; Setup move command
     62FE 22C2 
     6300 8320 
0176 6302 0460  28         b     @mcloop               ; Write data to VDP
     6304 8320 
0177               *--------------------------------------------------------------
0181 6306 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 6308 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     630A 4000 
0202 630C 06C4  14 vdra    swpb  tmp0
0203 630E D804  38         movb  tmp0,@vdpa
     6310 8C02 
0204 6312 06C4  14         swpb  tmp0
0205 6314 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6316 8C02 
0206 6318 045B  20         b     *r11                  ; Exit
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
0217 631A C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 631C C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 631E 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6320 4000 
0223 6322 06C4  14         swpb  tmp0                  ; \
0224 6324 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6326 8C02 
0225 6328 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 632A D804  38         movb  tmp0,@vdpa            ; /
     632C 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 632E 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 6330 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 6332 045B  20         b     *r11                  ; Exit
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
0251 6334 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 6336 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 6338 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     633A 8C02 
0257 633C 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 633E D804  38         movb  tmp0,@vdpa            ; /
     6340 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 6342 D120  34         movb  @vdpr,tmp0            ; Read byte
     6344 8800 
0263 6346 0984  56         srl   tmp0,8                ; Right align
0264 6348 045B  20         b     *r11                  ; Exit
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
0283 634A C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 634C C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 634E C144  18         mov   tmp0,tmp1
0289 6350 05C5  14         inct  tmp1
0290 6352 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 6354 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6356 FF00 
0292 6358 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 635A C805  38         mov   tmp1,@wbase           ; Store calculated base
     635C 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 635E 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6360 8000 
0298 6362 0206  20         li    tmp2,8
     6364 0008 
0299 6366 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6368 830B 
0300 636A 06C5  14         swpb  tmp1
0301 636C D805  38         movb  tmp1,@vdpa
     636E 8C02 
0302 6370 06C5  14         swpb  tmp1
0303 6372 D805  38         movb  tmp1,@vdpa
     6374 8C02 
0304 6376 0225  22         ai    tmp1,>0100
     6378 0100 
0305 637A 0606  14         dec   tmp2
0306 637C 16F4  14         jne   vidta1                ; Next register
0307 637E C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6380 833A 
0308 6382 045B  20         b     *r11
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
0325 6384 C13B  30 putvr   mov   *r11+,tmp0
0326 6386 0264  22 putvrx  ori   tmp0,>8000
     6388 8000 
0327 638A 06C4  14         swpb  tmp0
0328 638C D804  38         movb  tmp0,@vdpa
     638E 8C02 
0329 6390 06C4  14         swpb  tmp0
0330 6392 D804  38         movb  tmp0,@vdpa
     6394 8C02 
0331 6396 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 6398 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 639A C10E  18         mov   r14,tmp0
0341 639C 0984  56         srl   tmp0,8
0342 639E 06A0  32         bl    @putvrx               ; Write VR#0
     63A0 2342 
0343 63A2 0204  20         li    tmp0,>0100
     63A4 0100 
0344 63A6 D820  54         movb  @r14lb,@tmp0lb
     63A8 831D 
     63AA 8309 
0345 63AC 06A0  32         bl    @putvrx               ; Write VR#1
     63AE 2342 
0346 63B0 0458  20         b     *tmp4                 ; Exit
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
0360 63B2 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 63B4 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 63B6 C11B  26         mov   *r11,tmp0             ; Get P0
0363 63B8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63BA 7FFF 
0364 63BC 2120  38         coc   @wbit0,tmp0
     63BE 2020 
0365 63C0 1604  14         jne   ldfnt1
0366 63C2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     63C4 8000 
0367 63C6 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     63C8 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 63CA C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     63CC 23F0 
0372 63CE D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     63D0 9C02 
0373 63D2 06C4  14         swpb  tmp0
0374 63D4 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     63D6 9C02 
0375 63D8 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     63DA 9800 
0376 63DC 06C5  14         swpb  tmp1
0377 63DE D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     63E0 9800 
0378 63E2 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 63E4 D805  38         movb  tmp1,@grmwa
     63E6 9C02 
0383 63E8 06C5  14         swpb  tmp1
0384 63EA D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     63EC 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 63EE C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 63F0 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     63F2 22C4 
0390 63F4 05C8  14         inct  tmp4                  ; R11=R11+2
0391 63F6 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 63F8 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     63FA 7FFF 
0393 63FC C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     63FE 23F2 
0394 6400 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     6402 23F4 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 6404 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 6406 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 6408 D120  34         movb  @grmrd,tmp0
     640A 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 640C 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     640E 2020 
0405 6410 1603  14         jne   ldfnt3                ; No, so skip
0406 6412 D1C4  18         movb  tmp0,tmp3
0407 6414 0917  56         srl   tmp3,1
0408 6416 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 6418 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     641A 8C00 
0413 641C 0606  14         dec   tmp2
0414 641E 16F2  14         jne   ldfnt2
0415 6420 05C8  14         inct  tmp4                  ; R11=R11+2
0416 6422 020F  20         li    r15,vdpw              ; Set VDP write address
     6424 8C00 
0417 6426 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6428 7FFF 
0418 642A 0458  20         b     *tmp4                 ; Exit
0419 642C D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     642E 2000 
     6430 8C00 
0420 6432 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 6434 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6436 0200 
     6438 0000 
0425 643A 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     643C 01C0 
     643E 0101 
0426 6440 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6442 02A0 
     6444 0101 
0427 6446 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6448 00E0 
     644A 0101 
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
0445 644C C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 644E C3A0  34         mov   @wyx,r14              ; Get YX
     6450 832A 
0447 6452 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 6454 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6456 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 6458 C3A0  34         mov   @wyx,r14              ; Get YX
     645A 832A 
0454 645C 024E  22         andi  r14,>00ff             ; Remove Y
     645E 00FF 
0455 6460 A3CE  18         a     r14,r15               ; pos = pos + X
0456 6462 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6464 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 6466 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 6468 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 646A 020F  20         li    r15,vdpw              ; VDP write address
     646C 8C00 
0463 646E 045B  20         b     *r11
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
0481 6470 C17B  30 putstr  mov   *r11+,tmp1
0482 6472 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 6474 C1CB  18 xutstr  mov   r11,tmp3
0484 6476 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6478 2408 
0485 647A C2C7  18         mov   tmp3,r11
0486 647C 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 647E C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 6480 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 6482 0286  22         ci    tmp2,255              ; Length > 255 ?
     6484 00FF 
0494 6486 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 6488 0460  28         b     @xpym2v               ; Display string
     648A 249A 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 648C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     648E FFCE 
0501 6490 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6492 2026 
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
0517 6494 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6496 832A 
0518 6498 0460  28         b     @putstr
     649A 242C 
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
0539 649C 0649  14         dect  stack
0540 649E C64B  30         mov   r11,*stack            ; Save return address
0541 64A0 0649  14         dect  stack
0542 64A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 64A4 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 64A6 0987  56         srl   tmp3,8                ; Right align
0549               
0550 64A8 0649  14         dect  stack
0551 64AA C645  30         mov   tmp1,*stack           ; Push tmp1
0552 64AC 0649  14         dect  stack
0553 64AE C646  30         mov   tmp2,*stack           ; Push tmp2
0554 64B0 0649  14         dect  stack
0555 64B2 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 64B4 06A0  32         bl    @xutst0               ; Display string
     64B6 242E 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 64B8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 64BA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 64BC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 64BE 06A0  32         bl    @down                 ; Move cursor down
     64C0 26E2 
0566               
0567 64C2 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 64C4 0585  14         inc   tmp1                  ; Consider length byte
0569 64C6 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     64C8 2002 
0570 64CA 1301  14         jeq   !                     ; Yes, skip adjustment
0571 64CC 0585  14         inc   tmp1                  ; Make address even
0572 64CE 0606  14 !       dec   tmp2
0573 64D0 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 64D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 64D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 64D6 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0092               
0094                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0020 64D8 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 64DA C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 64DC C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 64DE C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 64E0 1604  14         jne   !                     ; No, continue
0028               
0029 64E2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64E4 FFCE 
0030 64E6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64E8 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 64EA 0264  22 !       ori   tmp0,>4000
     64EC 4000 
0035 64EE 06C4  14         swpb  tmp0
0036 64F0 D804  38         movb  tmp0,@vdpa
     64F2 8C02 
0037 64F4 06C4  14         swpb  tmp0
0038 64F6 D804  38         movb  tmp0,@vdpa
     64F8 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 64FA 020F  20         li    r15,vdpw              ; Set VDP write address
     64FC 8C00 
0043 64FE C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6500 24C4 
     6502 8320 
0044 6504 0460  28         b     @mcloop               ; Write data to VDP and return
     6506 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 6508 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0096               
0098                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0020 650A C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 650C C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 650E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6510 06C4  14 xpyv2m  swpb  tmp0
0027 6512 D804  38         movb  tmp0,@vdpa
     6514 8C02 
0028 6516 06C4  14         swpb  tmp0
0029 6518 D804  38         movb  tmp0,@vdpa
     651A 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 651C 020F  20         li    r15,vdpr              ; Set VDP read address
     651E 8800 
0034 6520 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6522 24E6 
     6524 8320 
0035 6526 0460  28         b     @mcloop               ; Read data from VDP
     6528 8320 
0036 652A DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0100               
0102                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0024 652C C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 652E C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6530 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6532 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6534 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6536 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6538 FFCE 
0034 653A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     653C 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 653E 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6540 0001 
0039 6542 1603  14         jne   cpym0                 ; No, continue checking
0040 6544 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6546 04C6  14         clr   tmp2                  ; Reset counter
0042 6548 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 654A 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     654C 7FFF 
0047 654E C1C4  18         mov   tmp0,tmp3
0048 6550 0247  22         andi  tmp3,1
     6552 0001 
0049 6554 1618  14         jne   cpyodd                ; Odd source address handling
0050 6556 C1C5  18 cpym1   mov   tmp1,tmp3
0051 6558 0247  22         andi  tmp3,1
     655A 0001 
0052 655C 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 655E 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     6560 2020 
0057 6562 1605  14         jne   cpym3
0058 6564 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     6566 2548 
     6568 8320 
0059 656A 0460  28         b     @mcloop               ; Copy memory and exit
     656C 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 656E C1C6  18 cpym3   mov   tmp2,tmp3
0064 6570 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6572 0001 
0065 6574 1301  14         jeq   cpym4
0066 6576 0606  14         dec   tmp2                  ; Make TMP2 even
0067 6578 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 657A 0646  14         dect  tmp2
0069 657C 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 657E C1C7  18         mov   tmp3,tmp3
0074 6580 1301  14         jeq   cpymz
0075 6582 D554  38         movb  *tmp0,*tmp1
0076 6584 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 6586 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     6588 8000 
0081 658A 10E9  14         jmp   cpym2
0082 658C DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0104               
0108               
0112               
0114                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
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
0062 658E C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 6590 0649  14         dect  stack
0065 6592 C64B  30         mov   r11,*stack            ; Push return address
0066 6594 0649  14         dect  stack
0067 6596 C640  30         mov   r0,*stack             ; Push r0
0068 6598 0649  14         dect  stack
0069 659A C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 659C 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 659E 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 65A0 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     65A2 4000 
0077 65A4 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     65A6 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 65A8 020C  20         li    r12,>1e00             ; SAMS CRU address
     65AA 1E00 
0082 65AC 04C0  14         clr   r0
0083 65AE 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 65B0 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 65B2 D100  18         movb  r0,tmp0
0086 65B4 0984  56         srl   tmp0,8                ; Right align
0087 65B6 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     65B8 833C 
0088 65BA 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 65BC C339  30         mov   *stack+,r12           ; Pop r12
0094 65BE C039  30         mov   *stack+,r0            ; Pop r0
0095 65C0 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 65C2 045B  20         b     *r11                  ; Return to caller
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
0131 65C4 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 65C6 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 65C8 0649  14         dect  stack
0135 65CA C64B  30         mov   r11,*stack            ; Push return address
0136 65CC 0649  14         dect  stack
0137 65CE C640  30         mov   r0,*stack             ; Push r0
0138 65D0 0649  14         dect  stack
0139 65D2 C64C  30         mov   r12,*stack            ; Push r12
0140 65D4 0649  14         dect  stack
0141 65D6 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 65D8 0649  14         dect  stack
0143 65DA C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 65DC 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 65DE 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 65E0 0284  22         ci    tmp0,255              ; Crash if page > 255
     65E2 00FF 
0153 65E4 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 65E6 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     65E8 001E 
0158 65EA 150A  14         jgt   !
0159 65EC 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     65EE 0004 
0160 65F0 1107  14         jlt   !
0161 65F2 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     65F4 0012 
0162 65F6 1508  14         jgt   sams.page.set.switch_page
0163 65F8 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     65FA 0006 
0164 65FC 1501  14         jgt   !
0165 65FE 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 6600 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6602 FFCE 
0170 6604 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6606 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 6608 020C  20         li    r12,>1e00             ; SAMS CRU address
     660A 1E00 
0176 660C C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 660E 06C0  14         swpb  r0                    ; LSB to MSB
0178 6610 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 6612 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     6614 4000 
0180 6616 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 6618 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 661A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 661C C339  30         mov   *stack+,r12           ; Pop r12
0188 661E C039  30         mov   *stack+,r0            ; Pop r0
0189 6620 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 6622 045B  20         b     *r11                  ; Return to caller
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
0204 6624 020C  20         li    r12,>1e00             ; SAMS CRU address
     6626 1E00 
0205 6628 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 662A 045B  20         b     *r11                  ; Return to caller
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
0227 662C 020C  20         li    r12,>1e00             ; SAMS CRU address
     662E 1E00 
0228 6630 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 6632 045B  20         b     *r11                  ; Return to caller
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
0260 6634 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 6636 0649  14         dect  stack
0263 6638 C64B  30         mov   r11,*stack            ; Save return address
0264 663A 0649  14         dect  stack
0265 663C C644  30         mov   tmp0,*stack           ; Save tmp0
0266 663E 0649  14         dect  stack
0267 6640 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 6642 0649  14         dect  stack
0269 6644 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 6646 0649  14         dect  stack
0271 6648 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 664A 0206  20         li    tmp2,8                ; Set loop counter
     664C 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 664E C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 6650 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 6652 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     6654 2584 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 6656 0606  14         dec   tmp2                  ; Next iteration
0288 6658 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 665A 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     665C 25E0 
0294                                                   ; / activating changes.
0295               
0296 665E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 6660 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 6662 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 6664 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 6666 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 6668 045B  20         b     *r11                  ; Return to caller
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
0318 666A 0649  14         dect  stack
0319 666C C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 666E 06A0  32         bl    @sams.layout
     6670 25F0 
0324 6672 2634                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 6674 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 6676 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 6678 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     667A 0002 
0336 667C 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     667E 0003 
0337 6680 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     6682 000A 
0338 6684 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     6686 000B 
0339 6688 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     668A 000C 
0340 668C D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     668E 000D 
0341 6690 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     6692 000E 
0342 6694 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     6696 000F 
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
0363 6698 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 669A 0649  14         dect  stack
0366 669C C64B  30         mov   r11,*stack            ; Push return address
0367 669E 0649  14         dect  stack
0368 66A0 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 66A2 0649  14         dect  stack
0370 66A4 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 66A6 0649  14         dect  stack
0372 66A8 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 66AA 0649  14         dect  stack
0374 66AC C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 66AE 0205  20         li    tmp1,sams.layout.copy.data
     66B0 268C 
0379 66B2 0206  20         li    tmp2,8                ; Set loop counter
     66B4 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66B6 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66B8 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66BA 254C 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 66BC CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     66BE 833C 
0390               
0391 66C0 0606  14         dec   tmp2                  ; Next iteration
0392 66C2 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 66C4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 66C6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 66C8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 66CA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 66CC C2F9  30         mov   *stack+,r11           ; Pop r11
0402 66CE 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 66D0 2000             data  >2000                 ; >2000-2fff
0408 66D2 3000             data  >3000                 ; >3000-3fff
0409 66D4 A000             data  >a000                 ; >a000-afff
0410 66D6 B000             data  >b000                 ; >b000-bfff
0411 66D8 C000             data  >c000                 ; >c000-cfff
0412 66DA D000             data  >d000                 ; >d000-dfff
0413 66DC E000             data  >e000                 ; >e000-efff
0414 66DE F000             data  >f000                 ; >f000-ffff
0415               
**** **** ****     > runlib.asm
0116               
0118                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 66E0 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     66E2 FFBF 
0010 66E4 0460  28         b     @putv01
     66E6 2354 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 66E8 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     66EA 0040 
0018 66EC 0460  28         b     @putv01
     66EE 2354 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 66F0 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     66F2 FFDF 
0026 66F4 0460  28         b     @putv01
     66F6 2354 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 66F8 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     66FA 0020 
0034 66FC 0460  28         b     @putv01
     66FE 2354 
**** **** ****     > runlib.asm
0120               
0122                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 6700 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6702 FFFE 
0011 6704 0460  28         b     @putv01
     6706 2354 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6708 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     670A 0001 
0019 670C 0460  28         b     @putv01
     670E 2354 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6710 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6712 FFFD 
0027 6714 0460  28         b     @putv01
     6716 2354 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6718 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     671A 0002 
0035 671C 0460  28         b     @putv01
     671E 2354 
**** **** ****     > runlib.asm
0124               
0126                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 6720 C83B  50 at      mov   *r11+,@wyx
     6722 832A 
0019 6724 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6726 B820  54 down    ab    @hb$01,@wyx
     6728 2012 
     672A 832A 
0028 672C 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 672E 7820  54 up      sb    @hb$01,@wyx
     6730 2012 
     6732 832A 
0037 6734 045B  20         b     *r11
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
0049 6736 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6738 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     673A 832A 
0051 673C C804  38         mov   tmp0,@wyx             ; Save as new YX position
     673E 832A 
0052 6740 045B  20         b     *r11
**** **** ****     > runlib.asm
0128               
0130                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
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
0021 6742 C120  34 yx2px   mov   @wyx,tmp0
     6744 832A 
0022 6746 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6748 06C4  14         swpb  tmp0                  ; Y<->X
0024 674A 04C5  14         clr   tmp1                  ; Clear before copy
0025 674C D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 674E 20A0  38         coc   @wbit1,config         ; f18a present ?
     6750 201E 
0030 6752 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6754 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6756 833A 
     6758 273E 
0032 675A 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 675C 0A15  56         sla   tmp1,1                ; X = X * 2
0035 675E B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6760 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6762 0500 
0037 6764 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6766 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6768 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 676A 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 676C D105  18         movb  tmp1,tmp0
0051 676E 06C4  14         swpb  tmp0                  ; X<->Y
0052 6770 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6772 2020 
0053 6774 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 6776 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     6778 2012 
0059 677A 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     677C 2024 
0060 677E 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6780 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6782 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0132               
0136               
0140               
0142                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
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
0013 6784 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6786 06A0  32         bl    @putvr                ; Write once
     6788 2340 
0015 678A 391C             data  >391c                 ; VR1/57, value 00011100
0016 678C 06A0  32         bl    @putvr                ; Write twice
     678E 2340 
0017 6790 391C             data  >391c                 ; VR1/57, value 00011100
0018 6792 06A0  32         bl    @putvr
     6794 2340 
0019 6796 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 6798 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 679A C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 679C 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     679E 2340 
0030 67A0 3900             data  >3900
0031 67A2 0458  20         b     *tmp4                 ; Exit
0032               
0033               
0034               ***************************************************************
0035               * f18chk - Check if F18A VDP present
0036               ***************************************************************
0037               *  bl   @f18chk
0038               *--------------------------------------------------------------
0039               *  REMARKS
0040               *  Expects that the f18a is unlocked when calling this function.
0041               *  Runs GPU code at VDP >3f00
0042               ********|*****|*********************|**************************
0043 67A4 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 67A6 06A0  32         bl    @cpym2v
     67A8 2494 
0045 67AA 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     67AC 27A4 
     67AE 0006 
0046 67B0 06A0  32         bl    @putvr
     67B2 2340 
0047 67B4 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 67B6 06A0  32         bl    @putvr
     67B8 2340 
0049 67BA 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 67BC 0204  20         li    tmp0,>3f00
     67BE 3F00 
0055 67C0 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67C2 22C8 
0056 67C4 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     67C6 8800 
0057 67C8 0984  56         srl   tmp0,8
0058 67CA D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     67CC 8800 
0059 67CE C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 67D0 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 67D2 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     67D4 BFFF 
0063 67D6 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 67D8 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     67DA 4000 
0066               f18chk_exit:
0067 67DC 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     67DE 229C 
0068 67E0 3F00             data  >3f00,>00,6
     67E2 0000 
     67E4 0006 
0069 67E6 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 67E8 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 67EA 3F00             data  >3f00                 ; 3f02 / 3f00
0076 67EC 0340             data  >0340                 ; 3f04   0340  idle
0077               
0078               
0079               ***************************************************************
0080               * f18rst - Reset f18a into standard settings
0081               ***************************************************************
0082               *  bl   @f18rst
0083               *--------------------------------------------------------------
0084               *  REMARKS
0085               *  This is used to leave the F18A mode and revert all settings
0086               *  that could lead to corruption when doing BLWP @0
0087               *
0088               *  Is expected to run while the f18a is unlocked.
0089               *
0090               *  There are some F18a settings that stay on when doing blwp @0
0091               *  and the TI title screen cannot recover from that.
0092               *
0093               *  It is your responsibility to set video mode tables should
0094               *  you want to continue instead of doing blwp @0 after your
0095               *  program cleanup
0096               ********|*****|*********************|**************************
0097 67EE C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 67F0 06A0  32         bl    @putvr
     67F2 2340 
0102 67F4 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 67F6 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     67F8 2340 
0105 67FA 3900             data  >3900                 ; Lock the F18a
0106 67FC 0458  20         b     *tmp4                 ; Exit
0107               
0108               
0109               
0110               ***************************************************************
0111               * f18fwv - Get F18A Firmware Version
0112               ***************************************************************
0113               *  bl   @f18fwv
0114               *--------------------------------------------------------------
0115               *  REMARKS
0116               *  Successfully tested with F18A v1.8, note that this does not
0117               *  work with F18 v1.3 but you shouldn't be using such old F18A
0118               *  firmware to begin with.
0119               *--------------------------------------------------------------
0120               *  TMP0 High nibble = major version
0121               *  TMP0 Low nibble  = minor version
0122               *
0123               *  Example: >0018     F18a Firmware v1.8
0124               ********|*****|*********************|**************************
0125 67FE C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 6800 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6802 201E 
0127 6804 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 6806 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6808 8802 
0132 680A 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     680C 2340 
0133 680E 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 6810 04C4  14         clr   tmp0
0135 6812 D120  34         movb  @vdps,tmp0
     6814 8802 
0136 6816 0984  56         srl   tmp0,8
0137 6818 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0144               
0146                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0017 681A C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     681C 832A 
0018 681E D17B  28         movb  *r11+,tmp1
0019 6820 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6822 D1BB  28         movb  *r11+,tmp2
0021 6824 0986  56         srl   tmp2,8                ; Repeat count
0022 6826 C1CB  18         mov   r11,tmp3
0023 6828 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     682A 2408 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 682C 020B  20         li    r11,hchar1
     682E 27F0 
0028 6830 0460  28         b     @xfilv                ; Draw
     6832 22A2 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6834 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6836 2022 
0033 6838 1302  14         jeq   hchar2                ; Yes, exit
0034 683A C2C7  18         mov   tmp3,r11
0035 683C 10EE  14         jmp   hchar                 ; Next one
0036 683E 05C7  14 hchar2  inct  tmp3
0037 6840 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0148               
0152               
0156               
0160               
0162                       copy  "snd_player.asm"           ; Sound player
**** **** ****     > snd_player.asm
0001               * FILE......: snd_player.asm
0002               * Purpose...: Sound player support code
0003               
0004               
0005               ***************************************************************
0006               * MUTE - Mute all sound generators
0007               ***************************************************************
0008               *  BL  @MUTE
0009               *  Mute sound generators and clear sound pointer
0010               *
0011               *  BL  @MUTE2
0012               *  Mute sound generators without clearing sound pointer
0013               ********|*****|*********************|**************************
0014 6842 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     6844 8334 
0015 6846 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     6848 2006 
0016 684A 0204  20         li    tmp0,muttab
     684C 2818 
0017 684E 0205  20         li    tmp1,sound            ; Sound generator port >8400
     6850 8400 
0018 6852 D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 6854 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 6856 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 6858 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 685A 045B  20         b     *r11
0023 685C 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     685E DFFF 
0024               
0025               
0026               ***************************************************************
0027               * SDPREP - Prepare for playing sound
0028               ***************************************************************
0029               *  BL   @SDPREP
0030               *  DATA P0,P1
0031               *
0032               *  P0 = Address where tune is stored
0033               *  P1 = Option flags for sound player
0034               *--------------------------------------------------------------
0035               *  REMARKS
0036               *  Use the below equates for P1:
0037               *
0038               *  SDOPT1 => Tune is in CPU memory + loop
0039               *  SDOPT2 => Tune is in CPU memory
0040               *  SDOPT3 => Tune is in VRAM + loop
0041               *  SDOPT4 => Tune is in VRAM
0042               ********|*****|*********************|**************************
0043 6860 C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     6862 8334 
0044 6864 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     6866 8336 
0045 6868 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     686A FFF8 
0046 686C E0BB  30         soc   *r11+,config          ; Set options
0047 686E D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     6870 2012 
     6872 831B 
0048 6874 045B  20         b     *r11
0049               
0050               ***************************************************************
0051               * SDPLAY - Sound player for tune in VRAM or CPU memory
0052               ***************************************************************
0053               *  BL  @SDPLAY
0054               *--------------------------------------------------------------
0055               *  REMARKS
0056               *  Set config register bit13=0 to pause player.
0057               *  Set config register bit14=1 to repeat (or play next tune).
0058               ********|*****|*********************|**************************
0059 6876 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     6878 2006 
0060 687A 1301  14         jeq   sdpla1                ; Yes, play
0061 687C 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 687E 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 6880 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     6882 831B 
     6884 2000 
0067 6886 1301  14         jeq   sdpla3                ; Play next note
0068 6888 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 688A 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     688C 2002 
0070 688E 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 6890 C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     6892 8336 
0075 6894 06C4  14         swpb  tmp0
0076 6896 D804  38         movb  tmp0,@vdpa
     6898 8C02 
0077 689A 06C4  14         swpb  tmp0
0078 689C D804  38         movb  tmp0,@vdpa
     689E 8C02 
0079 68A0 04C4  14         clr   tmp0
0080 68A2 D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     68A4 8800 
0081 68A6 131E  14         jeq   sdexit                ; Yes. exit
0082 68A8 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 68AA A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     68AC 8336 
0084 68AE D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     68B0 8800 
     68B2 8400 
0085 68B4 0604  14         dec   tmp0
0086 68B6 16FB  14         jne   vdpla2
0087 68B8 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     68BA 8800 
     68BC 831B 
0088 68BE 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     68C0 8336 
0089 68C2 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 68C4 C120  34 mmplay  mov   @wsdtmp,tmp0
     68C6 8336 
0094 68C8 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 68CA 130C  14         jeq   sdexit                ; Yes, exit
0096 68CC 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 68CE A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     68D0 8336 
0098 68D2 D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     68D4 8400 
0099 68D6 0605  14         dec   tmp1
0100 68D8 16FC  14         jne   mmpla2
0101 68DA D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     68DC 831B 
0102 68DE 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     68E0 8336 
0103 68E2 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 68E4 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     68E6 2004 
0108 68E8 1607  14         jne   sdexi2                ; No, exit
0109 68EA C820  54         mov   @wsdlst,@wsdtmp
     68EC 8334 
     68EE 8336 
0110 68F0 D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     68F2 2012 
     68F4 831B 
0111 68F6 045B  20 sdexi1  b     *r11                  ; Exit
0112 68F8 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     68FA FFF8 
0113 68FC 045B  20         b     *r11                  ; Exit
0114               
**** **** ****     > runlib.asm
0164               
0168               
0172               
0176               
0178                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 68FE 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6900 2020 
0017 6902 020C  20         li    r12,>0024
     6904 0024 
0018 6906 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6908 2956 
0019 690A 04C6  14         clr   tmp2
0020 690C 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 690E 04CC  14         clr   r12
0025 6910 1F08  20         tb    >0008                 ; Shift-key ?
0026 6912 1302  14         jeq   realk1                ; No
0027 6914 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6916 2986 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6918 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 691A 1302  14         jeq   realk2                ; No
0033 691C 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     691E 29B6 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6920 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6922 1302  14         jeq   realk3                ; No
0039 6924 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6926 29E6 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6928 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     692A 200C 
0044 692C 1E15  20         sbz   >0015                 ; Set P5
0045 692E 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 6930 1302  14         jeq   realk4                ; No
0047 6932 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     6934 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 6936 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 6938 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     693A 0006 
0053 693C 0606  14 realk5  dec   tmp2
0054 693E 020C  20         li    r12,>24               ; CRU address for P2-P4
     6940 0024 
0055 6942 06C6  14         swpb  tmp2
0056 6944 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 6946 06C6  14         swpb  tmp2
0058 6948 020C  20         li    r12,6                 ; CRU read address
     694A 0006 
0059 694C 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 694E 0547  14         inv   tmp3                  ;
0061 6950 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6952 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 6954 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 6956 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 6958 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 695A 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 695C 0285  22         ci    tmp1,8
     695E 0008 
0070 6960 1AFA  14         jl    realk6
0071 6962 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 6964 1BEB  14         jh    realk5                ; No, next column
0073 6966 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 6968 C206  18 realk8  mov   tmp2,tmp4
0078 696A 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 696C A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 696E A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 6970 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 6972 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 6974 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 6976 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     6978 200C 
0089 697A 1608  14         jne   realka                ; No, continue saving key
0090 697C 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     697E 2980 
0091 6980 1A05  14         jl    realka
0092 6982 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6984 297E 
0093 6986 1B02  14         jh    realka                ; No, continue
0094 6988 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     698A E000 
0095 698C C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     698E 833C 
0096 6990 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6992 200A 
0097 6994 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     6996 8C00 
0098                                                   ; / using R15 as temp storage
0099 6998 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 699A FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     699C 0000 
     699E FF0D 
     69A0 203D 
0102 69A2 ....             text  'xws29ol.'
0103 69AA ....             text  'ced38ik,'
0104 69B2 ....             text  'vrf47ujm'
0105 69BA ....             text  'btg56yhn'
0106 69C2 ....             text  'zqa10p;/'
0107 69CA FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     69CC 0000 
     69CE FF0D 
     69D0 202B 
0108 69D2 ....             text  'XWS@(OL>'
0109 69DA ....             text  'CED#*IK<'
0110 69E2 ....             text  'VRF$&UJM'
0111 69EA ....             text  'BTG%^YHN'
0112 69F2 ....             text  'ZQA!)P:-'
0113 69FA FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     69FC 0000 
     69FE FF0D 
     6A00 2005 
0114 6A02 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6A04 0804 
     6A06 0F27 
     6A08 C2B9 
0115 6A0A 600B             data  >600b,>0907,>063f,>c1B8
     6A0C 0907 
     6A0E 063F 
     6A10 C1B8 
0116 6A12 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6A14 7B02 
     6A16 015F 
     6A18 C0C3 
0117 6A1A BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6A1C 7D0E 
     6A1E 0CC6 
     6A20 BFC4 
0118 6A22 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6A24 7C03 
     6A26 BC22 
     6A28 BDBA 
0119 6A2A FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6A2C 0000 
     6A2E FF0D 
     6A30 209D 
0120 6A32 9897             data  >9897,>93b2,>9f8f,>8c9B
     6A34 93B2 
     6A36 9F8F 
     6A38 8C9B 
0121 6A3A 8385             data  >8385,>84b3,>9e89,>8b80
     6A3C 84B3 
     6A3E 9E89 
     6A40 8B80 
0122 6A42 9692             data  >9692,>86b4,>b795,>8a8D
     6A44 86B4 
     6A46 B795 
     6A48 8A8D 
0123 6A4A 8294             data  >8294,>87b5,>b698,>888E
     6A4C 87B5 
     6A4E B698 
     6A50 888E 
0124 6A52 9A91             data  >9a91,>81b1,>b090,>9cBB
     6A54 81B1 
     6A56 B090 
     6A58 9CBB 
**** **** ****     > runlib.asm
0180               
0182                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0023 6A5A C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6A5C C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6A5E 8340 
0025 6A60 04E0  34         clr   @waux1
     6A62 833C 
0026 6A64 04E0  34         clr   @waux2
     6A66 833E 
0027 6A68 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6A6A 833C 
0028 6A6C C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 6A6E 0205  20         li    tmp1,4                ; 4 nibbles
     6A70 0004 
0033 6A72 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6A74 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6A76 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6A78 0286  22         ci    tmp2,>000a
     6A7A 000A 
0039 6A7C 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6A7E C21B  26         mov   *r11,tmp4
0045 6A80 0988  56         srl   tmp4,8                ; Right justify
0046 6A82 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6A84 FFF6 
0047 6A86 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6A88 C21B  26         mov   *r11,tmp4
0054 6A8A 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6A8C 00FF 
0055               
0056 6A8E A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6A90 06C6  14         swpb  tmp2
0058 6A92 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6A94 0944  56         srl   tmp0,4                ; Next nibble
0060 6A96 0605  14         dec   tmp1
0061 6A98 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6A9A 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6A9C BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6A9E C160  34         mov   @waux3,tmp1           ; Get pointer
     6AA0 8340 
0067 6AA2 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6AA4 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6AA6 C120  34         mov   @waux2,tmp0
     6AA8 833E 
0070 6AAA 06C4  14         swpb  tmp0
0071 6AAC DD44  32         movb  tmp0,*tmp1+
0072 6AAE 06C4  14         swpb  tmp0
0073 6AB0 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6AB2 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6AB4 8340 
0078 6AB6 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6AB8 2016 
0079 6ABA 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6ABC C120  34         mov   @waux1,tmp0
     6ABE 833C 
0084 6AC0 06C4  14         swpb  tmp0
0085 6AC2 DD44  32         movb  tmp0,*tmp1+
0086 6AC4 06C4  14         swpb  tmp0
0087 6AC6 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6AC8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6ACA 2020 
0092 6ACC 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6ACE 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6AD0 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6AD2 7FFF 
0098 6AD4 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6AD6 8340 
0099 6AD8 0460  28         b     @xutst0               ; Display string
     6ADA 242E 
0100 6ADC 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6ADE C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6AE0 832A 
0122 6AE2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6AE4 8000 
0123 6AE6 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0184               
0186                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 6AE8 0207  20 mknum   li    tmp3,5                ; Digit counter
     6AEA 0005 
0020 6AEC C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6AEE C155  26         mov   *tmp1,tmp1            ; /
0022 6AF0 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6AF2 0228  22         ai    tmp4,4                ; Get end of buffer
     6AF4 0004 
0024 6AF6 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6AF8 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6AFA 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6AFC 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6AFE 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6B00 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6B02 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6B04 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6B06 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6B08 0607  14         dec   tmp3                  ; Decrease counter
0036 6B0A 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6B0C 0207  20         li    tmp3,4                ; Check first 4 digits
     6B0E 0004 
0041 6B10 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6B12 C11B  26         mov   *r11,tmp0
0043 6B14 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6B16 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6B18 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6B1A 05CB  14 mknum3  inct  r11
0047 6B1C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6B1E 2020 
0048 6B20 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6B22 045B  20         b     *r11                  ; Exit
0050 6B24 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6B26 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6B28 13F8  14         jeq   mknum3                ; Yes, exit
0053 6B2A 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6B2C 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6B2E 7FFF 
0058 6B30 C10B  18         mov   r11,tmp0
0059 6B32 0224  22         ai    tmp0,-4
     6B34 FFFC 
0060 6B36 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6B38 0206  20         li    tmp2,>0500            ; String length = 5
     6B3A 0500 
0062 6B3C 0460  28         b     @xutstr               ; Display string
     6B3E 2430 
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
0093 6B40 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6B42 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6B44 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6B46 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6B48 0207  20         li    tmp3,5                ; Set counter
     6B4A 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6B4C 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6B4E 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6B50 0584  14         inc   tmp0                  ; Next character
0105 6B52 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6B54 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6B56 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6B58 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6B5A DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6B5C 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6B5E DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6B60 0607  14         dec   tmp3                  ; Last character ?
0121 6B62 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6B64 045B  20         b     *r11                  ; Return
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
0139 6B66 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6B68 832A 
0140 6B6A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6B6C 8000 
0141 6B6E 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0188               
0192               
0196               
0200               
0204               
0206                       copy  "cpu_strings.asm"          ; String utilities support
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
0022 6B70 0649  14         dect  stack
0023 6B72 C64B  30         mov   r11,*stack            ; Save return address
0024 6B74 0649  14         dect  stack
0025 6B76 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6B78 0649  14         dect  stack
0027 6B7A C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6B7C 0649  14         dect  stack
0029 6B7E C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6B80 0649  14         dect  stack
0031 6B82 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6B84 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6B86 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6B88 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6B8A 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6B8C 0649  14         dect  stack
0044 6B8E C64B  30         mov   r11,*stack            ; Save return address
0045 6B90 0649  14         dect  stack
0046 6B92 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6B94 0649  14         dect  stack
0048 6B96 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6B98 0649  14         dect  stack
0050 6B9A C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6B9C 0649  14         dect  stack
0052 6B9E C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6BA0 C1D4  26 !       mov   *tmp0,tmp3
0057 6BA2 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6BA4 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6BA6 00FF 
0059 6BA8 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6BAA 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6BAC 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6BAE 0584  14         inc   tmp0                  ; Next byte
0067 6BB0 0607  14         dec   tmp3                  ; Shorten string length
0068 6BB2 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6BB4 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6BB6 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6BB8 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6BBA 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6BBC C187  18         mov   tmp3,tmp2
0078 6BBE 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6BC0 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6BC2 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6BC4 24EE 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6BC6 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6BC8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BCA FFCE 
0090 6BCC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BCE 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6BD0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6BD2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6BD4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6BD6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6BD8 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6BDA 045B  20         b     *r11                  ; Return to caller
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
0123 6BDC 0649  14         dect  stack
0124 6BDE C64B  30         mov   r11,*stack            ; Save return address
0125 6BE0 05D9  26         inct  *stack                ; Skip "data P0"
0126 6BE2 05D9  26         inct  *stack                ; Skip "data P1"
0127 6BE4 0649  14         dect  stack
0128 6BE6 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6BE8 0649  14         dect  stack
0130 6BEA C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6BEC 0649  14         dect  stack
0132 6BEE C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6BF0 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6BF2 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6BF4 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6BF6 0649  14         dect  stack
0144 6BF8 C64B  30         mov   r11,*stack            ; Save return address
0145 6BFA 0649  14         dect  stack
0146 6BFC C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6BFE 0649  14         dect  stack
0148 6C00 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6C02 0649  14         dect  stack
0150 6C04 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6C06 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6C08 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6C0A 0586  14         inc   tmp2
0161 6C0C 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6C0E 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6C10 0286  22         ci    tmp2,255
     6C12 00FF 
0167 6C14 1505  14         jgt   string.getlenc.panic
0168 6C16 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6C18 0606  14         dec   tmp2                  ; One time adjustment
0174 6C1A C806  38         mov   tmp2,@waux1           ; Store length
     6C1C 833C 
0175 6C1E 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6C20 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C22 FFCE 
0181 6C24 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C26 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6C28 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6C2A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6C2C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6C2E C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6C30 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0208               
0212               
0214                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
**** **** ****     > cpu_scrpad_backrest.asm
0001               * FILE......: cpu_scrpad_backrest.asm
0002               * Purpose...: Scratchpad memory backup/restore functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                Scratchpad memory backup/restore
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * cpu.scrpad.backup - Backup 256 bytes of scratchpad >8300 to
0010               *                     predefined memory target @cpu.scrpad.tgt
0011               ***************************************************************
0012               *  bl   @cpu.scrpad.backup
0013               *--------------------------------------------------------------
0014               *  Register usage
0015               *  r0-r2, but values restored before exit
0016               *--------------------------------------------------------------
0017               *  Backup 256 bytes of scratchpad memory >8300 to destination
0018               *  @cpu.scrpad.tgt (+ >ff)
0019               *
0020               *  Expects current workspace to be in scratchpad memory.
0021               ********|*****|*********************|**************************
0022               cpu.scrpad.backup:
0023 6C32 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     6C34 7E00 
0024 6C36 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     6C38 7E02 
0025 6C3A C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     6C3C 7E04 
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 6C3E 0200  20         li    r0,>8306              ; Scratchpad source address
     6C40 8306 
0030 6C42 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     6C44 7E06 
0031 6C46 0202  20         li    r2,62                 ; Loop counter
     6C48 003E 
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 6C4A CC70  46         mov   *r0+,*r1+
0037 6C4C CC70  46         mov   *r0+,*r1+
0038 6C4E 0642  14         dect  r2
0039 6C50 16FC  14         jne   cpu.scrpad.backup.copy
0040 6C52 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     6C54 83FE 
     6C56 7EFE 
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 6C58 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     6C5A 7E00 
0046 6C5C C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     6C5E 7E02 
0047 6C60 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     6C62 7E04 
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 6C64 045B  20         b     *r11                  ; Return to caller
0053               
0054               
0055               ***************************************************************
0056               * cpu.scrpad.restore - Restore 256 bytes of scratchpad from
0057               *                      predefined target @cpu.scrpad.tgt
0058               *                      to destination >8300
0059               ***************************************************************
0060               *  bl   @cpu.scrpad.restore
0061               *--------------------------------------------------------------
0062               *  Register usage
0063               *  r0-r2
0064               *--------------------------------------------------------------
0065               *  Restore scratchpad from memory area @cpu.scrpad.tgt (+ >ff).
0066               *  Current workspace can be outside scratchpad when called.
0067               ********|*****|*********************|**************************
0068               cpu.scrpad.restore:
0069 6C66 C80B  38         mov   r11,@rambuf           ; Backup return address
     6C68 A140 
0070                       ;------------------------------------------------------
0071                       ; Prepare for copy loop, WS
0072                       ;------------------------------------------------------
0073 6C6A 0200  20         li    r0,cpu.scrpad.tgt + 6
     6C6C 7E06 
0074 6C6E 0201  20         li    r1,>8306
     6C70 8306 
0075 6C72 0202  20         li    r2,62
     6C74 003E 
0076                       ;------------------------------------------------------
0077                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 6C76 CC70  46         mov   *r0+,*r1+
0081 6C78 CC70  46         mov   *r0+,*r1+
0082 6C7A 0642  14         dect  r2
0083 6C7C 16FC  14         jne   cpu.scrpad.restore.copy
0084 6C7E C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     6C80 7EFE 
     6C82 83FE 
0085                                                   ; Copy last word
0086                       ;------------------------------------------------------
0087                       ; Restore scratchpad >8300 - >8304
0088                       ;------------------------------------------------------
0089 6C84 C820  54         mov   @cpu.scrpad.tgt,@>8300       ; r0
     6C86 7E00 
     6C88 8300 
0090 6C8A C820  54         mov   @cpu.scrpad.tgt + 2,@>8302   ; r1
     6C8C 7E02 
     6C8E 8302 
0091 6C90 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304   ; r2
     6C92 7E04 
     6C94 8304 
0092                       ;------------------------------------------------------
0093                       ; Exit
0094                       ;------------------------------------------------------
0095               cpu.scrpad.restore.exit:
0096 6C96 C2E0  34         mov   @rambuf,r11           ; Restore return address
     6C98 A140 
0097 6C9A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0215                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
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
0010               * cpu.scrpad.pgout - Page out 256 bytes of scratchpad at >8300
0011               *                    to CPU memory destination P0 (tmp1)
0012               *                    and replace with 256 bytes of memory from
0013               *                    predefined destination @cpu.scrpad.target
0014               *
0015               *                    Workspace at
0016               ***************************************************************
0017               *  bl   @cpu.scrpad.pgout
0018               *       DATA p0
0019               *
0020               *  P0 = CPU memory destination
0021               *--------------------------------------------------------------
0022               *  bl   @xcpu.scrpad.pgout
0023               *  tmp1 = CPU memory destination
0024               *--------------------------------------------------------------
0025               *  Register usage
0026               *  tmp0-tmp2 = Used as temporary registers
0027               *  tmp3      = Copy of CPU memory destination
0028               *--------------------------------------------------------------
0029               *  Remarks
0030               *  Copies 256 bytes from scratchpad to CPU memory destination
0031               *  specified in P0 (TMP1).
0032               *
0033               *  Then copies 256 bytes from @cpu.scrpad.tgt to scratchpad
0034               *  >8300 and activates workspace in >8300
0035               ********|*****|*********************|**************************
0036               cpu.scrpad.pgout:
0037 6C9C C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0038                       ;------------------------------------------------------
0039                       ; Copy scratchpad memory to destination
0040                       ;------------------------------------------------------
0041               xcpu.scrpad.pgout:
0042 6C9E 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6CA0 8300 
0043 6CA2 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0044 6CA4 0206  20         li    tmp2,16               ; tmp2 = 256/16
     6CA6 0010 
0045                       ;------------------------------------------------------
0046                       ; Copy memory
0047                       ;------------------------------------------------------
0048 6CA8 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0049 6CAA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0050 6CAC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0051 6CAE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0052 6CB0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0053 6CB2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0054 6CB4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0055 6CB6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0056 6CB8 0606  14         dec   tmp2
0057 6CBA 16F6  14         jne   -!                    ; Loop until done
0058                       ;------------------------------------------------------
0059                       ; Switch to new workspace
0060                       ;------------------------------------------------------
0061 6CBC C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0062 6CBE 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6CC0 2C82 
0063                                                   ; R14=PC
0064 6CC2 04CF  14         clr   r15                   ; R15=STATUS
0065                       ;------------------------------------------------------
0066                       ; If we get here, WS was copied to specified
0067                       ; destination.  Also contents of r13,r14,r15
0068                       ; are about to be overwritten by rtwp instruction.
0069                       ;------------------------------------------------------
0070 6CC4 0380  18         rtwp                        ; Activate copied workspace
0071                                                   ; in non-scratchpad memory!
0072               
0073               cpu.scrpad.pgout.after.rtwp:
0074 6CC6 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     6CC8 2C22 
0075                                                   ; from @cpu.scrpad.tgt to @>8300
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               cpu.scrpad.pgout.exit:
0080 6CCA 045B  20         b     *r11                  ; Return to caller
0081               
0082               
0083               ***************************************************************
0084               * cpu.scrpad.pgin - Page in 256 bytes of scratchpad memory
0085               *                   at >8300 from CPU memory specified in
0086               *                   p0 (tmp0)
0087               ***************************************************************
0088               *  bl   @cpu.scrpad.pgin
0089               *  DATA p0
0090               *  P0 = CPU memory source
0091               *--------------------------------------------------------------
0092               *  bl   @memx.scrpad.pgin
0093               *  TMP0 = CPU memory source
0094               *--------------------------------------------------------------
0095               *  Register usage
0096               *  tmp0-tmp2 = Used as temporary registers
0097               *--------------------------------------------------------------
0098               *  Remarks
0099               *  Copies 256 bytes from CPU memory source to scratchpad >8300
0100               *  and activates workspace in scratchpad >8300
0101               ********|*****|*********************|**************************
0102               cpu.scrpad.pgin:
0103 6CCC C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0104                       ;------------------------------------------------------
0105                       ; Copy scratchpad memory to destination
0106                       ;------------------------------------------------------
0107               xcpu.scrpad.pgin:
0108 6CCE 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6CD0 8300 
0109 6CD2 0206  20         li    tmp2,16               ; tmp2 = 256/16
     6CD4 0010 
0110                       ;------------------------------------------------------
0111                       ; Copy memory
0112                       ;------------------------------------------------------
0113 6CD6 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0114 6CD8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0115 6CDA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0116 6CDC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0117 6CDE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0118 6CE0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0119 6CE2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0120 6CE4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0121 6CE6 0606  14         dec   tmp2
0122 6CE8 16F6  14         jne   -!                    ; Loop until done
0123                       ;------------------------------------------------------
0124                       ; Switch workspace to scratchpad memory
0125                       ;------------------------------------------------------
0126 6CEA 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6CEC 8300 
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               cpu.scrpad.pgin.exit:
0131 6CEE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0217               
0219                       copy  "fio.equ"                  ; File I/O equates
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
0220                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
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
0056 6CF0 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6CF2 2CB0             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6CF4 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6CF6 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6CF8 A428 
0064 6CFA 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6CFC 201C 
0065 6CFE C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6D00 8356 
0066 6D02 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6D04 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6D06 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6D08 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6D0A A434 
0073                       ;---------------------------; Inline VSBR start
0074 6D0C 06C0  14         swpb  r0                    ;
0075 6D0E D800  38         movb  r0,@vdpa              ; Send low byte
     6D10 8C02 
0076 6D12 06C0  14         swpb  r0                    ;
0077 6D14 D800  38         movb  r0,@vdpa              ; Send high byte
     6D16 8C02 
0078 6D18 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6D1A 8800 
0079                       ;---------------------------; Inline VSBR end
0080 6D1C 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6D1E 0704  14         seto  r4                    ; Init counter
0086 6D20 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6D22 A420 
0087 6D24 0580  14 !       inc   r0                    ; Point to next char of name
0088 6D26 0584  14         inc   r4                    ; Increment char counter
0089 6D28 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6D2A 0007 
0090 6D2C 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6D2E 80C4  18         c     r4,r3                 ; End of name?
0093 6D30 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6D32 06C0  14         swpb  r0                    ;
0098 6D34 D800  38         movb  r0,@vdpa              ; Send low byte
     6D36 8C02 
0099 6D38 06C0  14         swpb  r0                    ;
0100 6D3A D800  38         movb  r0,@vdpa              ; Send high byte
     6D3C 8C02 
0101 6D3E D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6D40 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6D42 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6D44 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6D46 2E18 
0109 6D48 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6D4A C104  18         mov   r4,r4                 ; Check if length = 0
0115 6D4C 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6D4E 04E0  34         clr   @>83d0
     6D50 83D0 
0118 6D52 C804  38         mov   r4,@>8354             ; Save name length for search (length
     6D54 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6D56 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6D58 A432 
0121               
0122 6D5A 0584  14         inc   r4                    ; Adjust for dot
0123 6D5C A804  38         a     r4,@>8356             ; Point to position after name
     6D5E 8356 
0124 6D60 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6D62 8356 
     6D64 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6D66 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6D68 83E0 
0130 6D6A 04C1  14         clr   r1                    ; Version found of dsr
0131 6D6C 020C  20         li    r12,>0f00             ; Init cru address
     6D6E 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6D70 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6D72 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6D74 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6D76 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6D78 0100 
0145 6D7A 04E0  34         clr   @>83d0                ; Clear in case we are done
     6D7C 83D0 
0146 6D7E 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6D80 2000 
0147 6D82 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6D84 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6D86 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6D88 1D00  20         sbo   0                     ; Turn on ROM
0154 6D8A 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6D8C 4000 
0155 6D8E 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6D90 2E14 
0156 6D92 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6D94 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6D96 A40A 
0166 6D98 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6D9A C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6D9C 83D2 
0172                                                   ; subprogram
0173               
0174 6D9E 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6DA0 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6DA2 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6DA4 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6DA6 83D2 
0183                                                   ; subprogram
0184               
0185 6DA8 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6DAA C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6DAC 04C5  14         clr   r5                    ; Remove any old stuff
0194 6DAE D160  34         movb  @>8355,r5             ; Get length as counter
     6DB0 8355 
0195 6DB2 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6DB4 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6DB6 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6DB8 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6DBA 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6DBC A420 
0206 6DBE 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6DC0 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6DC2 0605  14         dec   r5                    ; Update loop counter
0211 6DC4 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6DC6 0581  14         inc   r1                    ; Next version found
0217 6DC8 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6DCA A42A 
0218 6DCC C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6DCE A42C 
0219 6DD0 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6DD2 A430 
0220               
0221 6DD4 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6DD6 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6DD8 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6DDA 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6DDC 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6DDE 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6DE0 A400 
0233 6DE2 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6DE4 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6DE6 A428 
0239                                                   ; (8 or >a)
0240 6DE8 0281  22         ci    r1,8                  ; was it 8?
     6DEA 0008 
0241 6DEC 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6DEE D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6DF0 8350 
0243                                                   ; Get error byte from @>8350
0244 6DF2 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6DF4 06C0  14         swpb  r0                    ;
0252 6DF6 D800  38         movb  r0,@vdpa              ; send low byte
     6DF8 8C02 
0253 6DFA 06C0  14         swpb  r0                    ;
0254 6DFC D800  38         movb  r0,@vdpa              ; send high byte
     6DFE 8C02 
0255 6E00 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6E02 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6E04 09D1  56         srl   r1,13                 ; just keep error bits
0263 6E06 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6E08 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6E0A 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6E0C 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6E0E A400 
0275               dsrlnk.error.devicename_invalid:
0276 6E10 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6E12 06C1  14         swpb  r1                    ; put error in hi byte
0279 6E14 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6E16 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6E18 201C 
0281                                                   ; / to indicate error
0282 6E1A 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6E1C A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6E1E 2DDC             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6E20 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6E22 83E0 
0316               
0317 6E24 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6E26 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6E28 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6E2A A42A 
0322 6E2C C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6E2E C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6E30 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6E32 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6E34 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6E36 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6E38 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6E3A 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6E3C 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6E3E 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6E40 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6E42 4000 
     6E44 2E14 
0337 6E46 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6E48 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6E4A 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6E4C 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6E4E 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6E50 A400 
0355 6E52 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6E54 A434 
0356               
0357 6E56 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6E58 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6E5A 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6E5C ....     dsrlnk.period     text  '.'         ; For finding end of device name
0367               
0368                       even
**** **** ****     > runlib.asm
0221                       copy  "fio_level3.asm"           ; File I/O level 3 support
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
0045 6E5E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6E60 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6E62 0649  14         dect  stack
0052 6E64 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6E66 0204  20         li    tmp0,dsrlnk.savcru
     6E68 A42A 
0057 6E6A 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6E6C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6E6E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6E70 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6E72 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6E74 37D7 
0065 6E76 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6E78 8370 
0066                                                   ; / location
0067 6E7A C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6E7C A44C 
0068 6E7E 04C5  14         clr   tmp1                  ; io.op.open
0069 6E80 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6E82 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6E84 0649  14         dect  stack
0097 6E86 C64B  30         mov   r11,*stack            ; Save return address
0098 6E88 0205  20         li    tmp1,io.op.close      ; io.op.close
     6E8A 0001 
0099 6E8C 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6E8E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6E90 0649  14         dect  stack
0125 6E92 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6E94 0205  20         li    tmp1,io.op.read       ; io.op.read
     6E96 0002 
0128 6E98 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6E9A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6E9C 0649  14         dect  stack
0155 6E9E C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6EA0 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6EA2 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6EA4 0005 
0159               
0160 6EA6 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6EA8 A43E 
0161               
0162 6EAA 06A0  32         bl    @xvputb               ; Write character count to PAB
     6EAC 22DA 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6EAE 0205  20         li    tmp1,io.op.write      ; io.op.write
     6EB0 0003 
0167 6EB2 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6EB4 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6EB6 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6EB8 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6EBA 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6EBC 1000  14         nop
0189               
0190               
0191               file.status:
0192 6EBE 1000  14         nop
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
0227 6EC0 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6EC2 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6EC4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6EC6 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6EC8 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6ECA 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6ECC 22DA 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6ECE C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6ED0 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6ED2 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6ED4 A44C 
0246               
0247 6ED6 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6ED8 22DA 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6EDA 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6EDC 0009 
0254 6EDE C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6EE0 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6EE2 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6EE4 8322 
     6EE6 833C 
0259               
0260 6EE8 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6EEA A42A 
0261 6EEC 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6EEE 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6EF0 2CAC 
0268 6EF2 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6EF4 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6EF6 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6EF8 2DD8 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6EFA 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6EFC C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6EFE 833C 
     6F00 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6F02 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6F04 A436 
0292 6F06 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6F08 0005 
0293 6F0A 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6F0C 22F2 
0294 6F0E C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6F10 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6F12 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6F14 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0223               
0224               *//////////////////////////////////////////////////////////////
0225               *                            TIMERS
0226               *//////////////////////////////////////////////////////////////
0227               
0228                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 6F16 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F18 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F1A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F1C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F1E 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F20 201C 
0029 6F22 1602  14         jne   tmgr1a                ; No, so move on
0030 6F24 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F26 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F28 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F2A 2020 
0035 6F2C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F2E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F30 2010 
0048 6F32 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F34 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F36 200E 
0050 6F38 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F3A 0460  28         b     @kthread              ; Run kernel thread
     6F3C 2F70 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F3E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F40 2014 
0056 6F42 13EB  14         jeq   tmgr1
0057 6F44 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F46 2012 
0058 6F48 16E8  14         jne   tmgr1
0059 6F4A C120  34         mov   @wtiusr,tmp0
     6F4C 832E 
0060 6F4E 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F50 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F52 2F6E 
0065 6F54 C10A  18         mov   r10,tmp0
0066 6F56 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F58 00FF 
0067 6F5A 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F5C 201C 
0068 6F5E 1303  14         jeq   tmgr5
0069 6F60 0284  22         ci    tmp0,60               ; 1 second reached ?
     6F62 003C 
0070 6F64 1002  14         jmp   tmgr6
0071 6F66 0284  22 tmgr5   ci    tmp0,50
     6F68 0032 
0072 6F6A 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6F6C 1001  14         jmp   tmgr8
0074 6F6E 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6F70 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6F72 832C 
0079 6F74 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6F76 FF00 
0080 6F78 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6F7A 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6F7C 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6F7E 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6F80 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6F82 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6F84 830C 
     6F86 830D 
0089 6F88 1608  14         jne   tmgr10                ; No, get next slot
0090 6F8A 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6F8C FF00 
0091 6F8E C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6F90 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6F92 8330 
0096 6F94 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6F96 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6F98 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6F9A 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6F9C 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6F9E 8315 
     6FA0 8314 
0103 6FA2 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6FA4 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6FA6 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6FA8 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6FAA 10F7  14         jmp   tmgr10                ; Process next slot
0108 6FAC 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6FAE FF00 
0109 6FB0 10B4  14         jmp   tmgr1
0110 6FB2 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0229                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 6FB4 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6FB6 2010 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 6FB8 20A0  38         coc   @wbit13,config        ; Sound player on ?
     6FBA 2006 
0023 6FBC 1602  14         jne   kthread_kb
0024 6FBE 06A0  32         bl    @sdpla1               ; Run sound player
     6FC0 283A 
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 6FC2 06A0  32         bl    @realkb               ; Scan full keyboard
     6FC4 28BA 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6FC6 0460  28         b     @tmgr3                ; Exit
     6FC8 2EFA 
**** **** ****     > runlib.asm
0230                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 6FCA C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6FCC 832E 
0018 6FCE E0A0  34         soc   @wbit7,config         ; Enable user hook
     6FD0 2012 
0019 6FD2 045B  20 mkhoo1  b     *r11                  ; Return
0020      2ED6     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6FD4 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6FD6 832E 
0029 6FD8 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6FDA FEFF 
0030 6FDC 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0231               
0233                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 6FDE C13B  30 mkslot  mov   *r11+,tmp0
0018 6FE0 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6FE2 C184  18         mov   tmp0,tmp2
0023 6FE4 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6FE6 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6FE8 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6FEA CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6FEC 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6FEE C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6FF0 881B  46         c     *r11,@w$ffff          ; End of list ?
     6FF2 2022 
0035 6FF4 1301  14         jeq   mkslo1                ; Yes, exit
0036 6FF6 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6FF8 05CB  14 mkslo1  inct  r11
0041 6FFA 045B  20         b     *r11                  ; Exit
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
0052 6FFC C13B  30 clslot  mov   *r11+,tmp0
0053 6FFE 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 7000 A120  34         a     @wtitab,tmp0          ; Add table base
     7002 832C 
0055 7004 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 7006 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 7008 045B  20         b     *r11                  ; Exit
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
0068 700A C13B  30 rsslot  mov   *r11+,tmp0
0069 700C 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 700E A120  34         a     @wtitab,tmp0          ; Add table base
     7010 832C 
0071 7012 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 7014 C154  26         mov   *tmp0,tmp1
0073 7016 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     7018 FF00 
0074 701A C505  30         mov   tmp1,*tmp0
0075 701C 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0235               
0236               
0237               
0238               *//////////////////////////////////////////////////////////////
0239               *                    RUNLIB INITIALISATION
0240               *//////////////////////////////////////////////////////////////
0241               
0242               ***************************************************************
0243               *  RUNLIB - Runtime library initalisation
0244               ***************************************************************
0245               *  B  @RUNLIB
0246               *--------------------------------------------------------------
0247               *  REMARKS
0248               *  if R0 in WS1 equals >4a4a we were called from the system
0249               *  crash handler so we return there after initialisation.
0250               
0251               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0252               *  after clearing scratchpad memory. This has higher priority
0253               *  as crash handler flag R0.
0254               ********|*****|*********************|**************************
0261 701E 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7020 8302 
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 7022 0300  24 runli1  limi  0                     ; Turn off interrupts
     7024 0000 
0267 7026 02E0  18         lwpi  ws1                   ; Activate workspace 1
     7028 8300 
0268 702A C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     702C 83C0 
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 702E 0202  20 runli2  li    r2,>8308
     7030 8308 
0273 7032 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 7034 0282  22         ci    r2,>8400
     7036 8400 
0275 7038 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 703A 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     703C FFFF 
0280 703E 1602  14         jne   runli4                ; No, continue
0281 7040 0420  54         blwp  @0                    ; Yes, bye bye
     7042 0000 
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 7044 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7046 833C 
0286 7048 04C1  14         clr   r1                    ; Reset counter
0287 704A 0202  20         li    r2,10                 ; We test 10 times
     704C 000A 
0288 704E C0E0  34 runli5  mov   @vdps,r3
     7050 8802 
0289 7052 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7054 2020 
0290 7056 1302  14         jeq   runli6
0291 7058 0581  14         inc   r1                    ; Increase counter
0292 705A 10F9  14         jmp   runli5
0293 705C 0602  14 runli6  dec   r2                    ; Next test
0294 705E 16F7  14         jne   runli5
0295 7060 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7062 1250 
0296 7064 1202  14         jle   runli7                ; No, so it must be NTSC
0297 7066 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     7068 201C 
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 706A 06A0  32 runli7  bl    @loadmc
     706C 2228 
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 706E 04C1  14 runli9  clr   r1
0306 7070 04C2  14         clr   r2
0307 7072 04C3  14         clr   r3
0308 7074 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     7076 AF00 
0309 7078 020F  20         li    r15,vdpw              ; Set VDP write address
     707A 8C00 
0311 707C 06A0  32         bl    @mute                 ; Mute sound generators
     707E 27FE 
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 7080 0280  22         ci    r0,>4a4a              ; Crash flag set?
     7082 4A4A 
0318 7084 1605  14         jne   runlia
0319 7086 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     7088 229C 
0320 708A 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     708C 0000 
     708E 3000 
0325 7090 06A0  32 runlia  bl    @filv
     7092 229C 
0326 7094 0FC0             data  pctadr,spfclr,16      ; Load color table
     7096 00F4 
     7098 0010 
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 709A 06A0  32         bl    @f18unl               ; Unlock the F18A
     709C 2740 
0334 709E 06A0  32         bl    @f18chk               ; Check if F18A is there
     70A0 2760 
0335 70A2 06A0  32         bl    @f18lck               ; Lock the F18A again
     70A4 2756 
0336               
0337 70A6 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     70A8 2340 
0338 70AA 3201                   data >3201            ; F18a VR50 (>32), bit 1
0340               *--------------------------------------------------------------
0341               * Check if there is a speech synthesizer attached
0342               *--------------------------------------------------------------
0344               *       <<skipped>>
0348               *--------------------------------------------------------------
0349               * Load video mode table & font
0350               *--------------------------------------------------------------
0351 70AC 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     70AE 2306 
0352 70B0 3438             data  spvmod                ; Equate selected video mode table
0353 70B2 0204  20         li    tmp0,spfont           ; Get font option
     70B4 000C 
0354 70B6 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0355 70B8 1304  14         jeq   runlid                ; Yes, skip it
0356 70BA 06A0  32         bl    @ldfnt
     70BC 236E 
0357 70BE 1100             data  fntadr,spfont         ; Load specified font
     70C0 000C 
0358               *--------------------------------------------------------------
0359               * Did a system crash occur before runlib was called?
0360               *--------------------------------------------------------------
0361 70C2 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     70C4 4A4A 
0362 70C6 1602  14         jne   runlie                ; No, continue
0363 70C8 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     70CA 2086 
0364               *--------------------------------------------------------------
0365               * Branch to main program
0366               *--------------------------------------------------------------
0367 70CC 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     70CE 0040 
0368 70D0 0460  28         b     @main                 ; Give control to main program
     70D2 6046 
**** **** ****     > stevie_b6.asm.1052616
0041                       copy  "ram.resident.asm"
**** **** ****     > ram.resident.asm
0001               * FILE......: ram.resident.asm
0002               * Purpose...: Resident modules in LOW MEMEXP callable from all ROM banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Resident Stevie modules
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
0021 70D4 C13B  30         mov   *r11+,tmp0            ; P0
0022 70D6 C17B  30         mov   *r11+,tmp1            ; P1
0023 70D8 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 70DA 0649  14         dect  stack
0029 70DC C644  30         mov   tmp0,*stack           ; Push tmp0
0030 70DE 0649  14         dect  stack
0031 70E0 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 70E2 0649  14         dect  stack
0033 70E4 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 70E6 0649  14         dect  stack
0035 70E8 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 70EA 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     70EC 6000 
0040 70EE 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 70F0 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     70F2 A226 
0044 70F4 0647  14         dect  tmp3
0045 70F6 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 70F8 0647  14         dect  tmp3
0047 70FA C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 70FC C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     70FE A226 
0049               
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
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @parm1 if >ffff
0073                       ;------------------------------------------------------
0074 710C 0285  22         ci    tmp1,>ffff
     710E FFFF 
0075 7110 1602  14         jne   !
0076 7112 C160  34         mov   @parm1,tmp1
     7114 A000 
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 7116 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 7118 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084               
0085 711A 1004  14         jmp   rom.farjump.bankswitch.call
0086                                                   ; Call function in target bank
0087                       ;------------------------------------------------------
0088                       ; Assert 1 failed before bank-switch
0089                       ;------------------------------------------------------
0090               rom.farjump.bankswitch.failed1:
0091 711C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     711E FFCE 
0092 7120 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7122 2026 
0093                       ;------------------------------------------------------
0094                       ; Call function in target bank
0095                       ;------------------------------------------------------
0096               rom.farjump.bankswitch.call:
0097 7124 0694  24         bl    *tmp0                 ; Call function
0098                       ;------------------------------------------------------
0099                       ; Bankswitch back to source bank
0100                       ;------------------------------------------------------
0101               rom.farjump.return:
0102 7126 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     7128 A226 
0103 712A C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0104 712C 1312  14         jeq   rom.farjump.bankswitch.failed2
0105                                                   ; Crash if null-pointer in address
0106               
0107 712E 04F4  30         clr   *tmp0+                ; Remove bank write address from
0108                                                   ; farjump stack
0109               
0110 7130 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0111               
0112 7132 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0113                                                   ; farjump stack
0114               
0115 7134 028B  22         ci    r11,>6000
     7136 6000 
0116 7138 110C  14         jlt   rom.farjump.bankswitch.failed2
0117 713A 028B  22         ci    r11,>7fff
     713C 7FFF 
0118 713E 1509  14         jgt   rom.farjump.bankswitch.failed2
0119               
0120 7140 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     7142 A226 
0121               
0125               
0126                       ;------------------------------------------------------
0127                       ; Bankswitch to source 8K ROM bank
0128                       ;------------------------------------------------------
0129               rom.farjump.bankswitch.src.rom8k:
0130 7144 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0131 7146 1009  14         jmp   rom.farjump.exit
0132                       ;------------------------------------------------------
0133                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0134                       ;------------------------------------------------------
0135               rom.farjump.bankswitch.src.advfg99:
0136 7148 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0137 714A 0225  22         ai    tmp1,>0800
     714C 0800 
0138 714E 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0139 7150 1004  14         jmp   rom.farjump.exit
0140                       ;------------------------------------------------------
0141                       ; Assert 2 failed after bank-switch
0142                       ;------------------------------------------------------
0143               rom.farjump.bankswitch.failed2:
0144 7152 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7154 FFCE 
0145 7156 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7158 2026 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               rom.farjump.exit:
0150 715A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0151 715C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0152 715E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0153 7160 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0154 7162 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
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
0020 7164 0649  14         dect  stack
0021 7166 C64B  30         mov   r11,*stack            ; Save return address
0022 7168 0649  14         dect  stack
0023 716A C644  30         mov   tmp0,*stack           ; Push tmp0
0024 716C 0649  14         dect  stack
0025 716E C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7170 0204  20         li    tmp0,fb.top
     7172 D000 
0030 7174 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     7176 A300 
0031 7178 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     717A A304 
0032 717C 04E0  34         clr   @fb.row               ; Current row=0
     717E A306 
0033 7180 04E0  34         clr   @fb.column            ; Current column=0
     7182 A30C 
0034               
0035 7184 0204  20         li    tmp0,colrow
     7186 0050 
0036 7188 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     718A A30E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 718C C160  34         mov   @tv.ruler.visible,tmp1
     718E A210 
0041 7190 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 7192 0204  20         li    tmp0,pane.botrow-2
     7194 001B 
0043 7196 1002  14         jmp   fb.init.cont
0044 7198 0204  20 !       li    tmp0,pane.botrow-1
     719A 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 719C C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     719E A31A 
0050 71A0 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     71A2 A31C 
0051               
0052 71A4 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     71A6 A222 
0053 71A8 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     71AA A310 
0054 71AC 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     71AE A316 
0055 71B0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     71B2 A318 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 71B4 06A0  32         bl    @film
     71B6 2244 
0060 71B8 D000             data  fb.top,>00,fb.size    ; Clear it all the way
     71BA 0000 
     71BC 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 71BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 71C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 71C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 71C4 045B  20         b     *r11                  ; Return to caller
0069               
**** **** ****     > ram.resident.asm
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
0046 71C6 0649  14         dect  stack
0047 71C8 C64B  30         mov   r11,*stack            ; Save return address
0048 71CA 0649  14         dect  stack
0049 71CC C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 71CE 0204  20         li    tmp0,idx.top
     71D0 B000 
0054 71D2 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     71D4 A502 
0055               
0056 71D6 C120  34         mov   @tv.sams.b000,tmp0
     71D8 A206 
0057 71DA C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     71DC A600 
0058 71DE C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     71E0 A602 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 71E2 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     71E4 0004 
0063 71E6 C804  38         mov   tmp0,@idx.sams.hipage ; /
     71E8 A604 
0064               
0065 71EA 06A0  32         bl    @_idx.sams.mapcolumn.on
     71EC 31C4 
0066                                                   ; Index in continuous memory region
0067               
0068 71EE 06A0  32         bl    @film
     71F0 2244 
0069 71F2 B000                   data idx.top,>00,idx.size * 5
     71F4 0000 
     71F6 5000 
0070                                                   ; Clear index
0071               
0072 71F8 06A0  32         bl    @_idx.sams.mapcolumn.off
     71FA 31F8 
0073                                                   ; Restore memory window layout
0074               
0075 71FC C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     71FE A602 
     7200 A604 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 7202 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 7204 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 7206 045B  20         b     *r11                  ; Return to caller
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
0096 7208 0649  14         dect  stack
0097 720A C64B  30         mov   r11,*stack            ; Push return address
0098 720C 0649  14         dect  stack
0099 720E C644  30         mov   tmp0,*stack           ; Push tmp0
0100 7210 0649  14         dect  stack
0101 7212 C645  30         mov   tmp1,*stack           ; Push tmp1
0102 7214 0649  14         dect  stack
0103 7216 C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 7218 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     721A A602 
0108 721C 0205  20         li    tmp1,idx.top
     721E B000 
0109 7220 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     7222 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 7224 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     7226 2584 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 7228 0584  14         inc   tmp0                  ; Next SAMS index page
0118 722A 0225  22         ai    tmp1,>1000            ; Next memory region
     722C 1000 
0119 722E 0606  14         dec   tmp2                  ; Update loop counter
0120 7230 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 7232 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 7234 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 7236 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 7238 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 723A 045B  20         b     *r11                  ; Return to caller
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
0145 723C 0649  14         dect  stack
0146 723E C64B  30         mov   r11,*stack            ; Push return address
0147 7240 0649  14         dect  stack
0148 7242 C644  30         mov   tmp0,*stack           ; Push tmp0
0149 7244 0649  14         dect  stack
0150 7246 C645  30         mov   tmp1,*stack           ; Push tmp1
0151 7248 0649  14         dect  stack
0152 724A C646  30         mov   tmp2,*stack           ; Push tmp2
0153 724C 0649  14         dect  stack
0154 724E C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 7250 0205  20         li    tmp1,idx.top
     7252 B000 
0159 7254 0206  20         li    tmp2,5                ; Always 5 pages
     7256 0005 
0160 7258 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     725A A206 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 725C C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 725E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7260 2584 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 7262 0225  22         ai    tmp1,>1000            ; Next memory region
     7264 1000 
0171 7266 0606  14         dec   tmp2                  ; Update loop counter
0172 7268 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 726A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 726C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 726E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 7270 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 7272 C2F9  30         mov   *stack+,r11           ; Pop return address
0182 7274 045B  20         b     *r11                  ; Return to caller
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
0206 7276 0649  14         dect  stack
0207 7278 C64B  30         mov   r11,*stack            ; Save return address
0208 727A 0649  14         dect  stack
0209 727C C644  30         mov   tmp0,*stack           ; Push tmp0
0210 727E 0649  14         dect  stack
0211 7280 C645  30         mov   tmp1,*stack           ; Push tmp1
0212 7282 0649  14         dect  stack
0213 7284 C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 7286 C184  18         mov   tmp0,tmp2             ; Line number
0218 7288 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 728A 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     728C 0800 
0220               
0221 728E 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 7290 0A16  56         sla   tmp2,1                ; line number * 2
0226 7292 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     7294 A010 
0227               
0228 7296 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     7298 A602 
0229 729A 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     729C A600 
0230               
0231 729E 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 72A0 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     72A2 A600 
0237 72A4 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     72A6 A206 
0238               
0239 72A8 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 72AA 0205  20         li    tmp1,>b000            ; Memory window for index page
     72AC B000 
0241               
0242 72AE 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     72B0 2584 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 72B2 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     72B4 A604 
0249 72B6 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 72B8 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     72BA A604 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 72BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 72BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 72C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 72C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0260 72C4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
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
0022 72C6 0649  14         dect  stack
0023 72C8 C64B  30         mov   r11,*stack            ; Save return address
0024 72CA 0649  14         dect  stack
0025 72CC C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72CE 0204  20         li    tmp0,edb.top          ; \
     72D0 C000 
0030 72D2 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     72D4 A500 
0031 72D6 C804  38         mov   tmp0,@edb.next_free.ptr
     72D8 A508 
0032                                                   ; Set pointer to next free line
0033               
0034 72DA 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     72DC A50A 
0035               
0036 72DE 0204  20         li    tmp0,1
     72E0 0001 
0037 72E2 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     72E4 A504 
0038               
0039 72E6 0720  34         seto  @edb.block.m1         ; Reset block start line
     72E8 A50C 
0040 72EA 0720  34         seto  @edb.block.m2         ; Reset block end line
     72EC A50E 
0041               
0042 72EE 0204  20         li    tmp0,txt.newfile      ; "New file"
     72F0 35C2 
0043 72F2 C804  38         mov   tmp0,@edb.filename.ptr
     72F4 A512 
0044               
0045 72F6 0204  20         li    tmp0,txt.filetype.none
     72F8 367A 
0046 72FA C804  38         mov   tmp0,@edb.filetype.ptr
     72FC A514 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 72FE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 7300 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 7302 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
**** **** ****     > ram.resident.asm
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
0022 7304 0649  14         dect  stack
0023 7306 C64B  30         mov   r11,*stack            ; Save return address
0024 7308 0649  14         dect  stack
0025 730A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 730C 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     730E E000 
0030 7310 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     7312 A700 
0031               
0032 7314 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     7316 A702 
0033 7318 0204  20         li    tmp0,4
     731A 0004 
0034 731C C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     731E A706 
0035 7320 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     7322 A708 
0036               
0037 7324 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     7326 A716 
0038 7328 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     732A A718 
0039 732C 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     732E A726 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 7330 06A0  32         bl    @film
     7332 2244 
0044 7334 E000             data  cmdb.top,>00,cmdb.size
     7336 0000 
     7338 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 733A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 733C C2F9  30         mov   *stack+,r11           ; Pop r11
0052 733E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
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
0022 7340 0649  14         dect  stack
0023 7342 C64B  30         mov   r11,*stack            ; Save return address
0024 7344 0649  14         dect  stack
0025 7346 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7348 04E0  34         clr   @tv.error.visible     ; Set to hidden
     734A A228 
0030               
0031 734C 06A0  32         bl    @film
     734E 2244 
0032 7350 A22A                   data tv.error.msg,0,160
     7352 0000 
     7354 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 7356 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 7358 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 735A 045B  20         b     *r11                  ; Return to caller
0040               
**** **** ****     > ram.resident.asm
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
0022 735C 0649  14         dect  stack
0023 735E C64B  30         mov   r11,*stack            ; Save return address
0024 7360 0649  14         dect  stack
0025 7362 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7364 0204  20         li    tmp0,1                ; \ Set default color scheme
     7366 0001 
0030 7368 C804  38         mov   tmp0,@tv.colorscheme  ; /
     736A A212 
0031               
0032 736C 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     736E A224 
0033 7370 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     7372 200C 
0034               
0035 7374 0204  20         li    tmp0,fj.bottom
     7376 B000 
0036 7378 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     737A A226 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 737C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 737E C2F9  30         mov   *stack+,r11           ; Pop R11
0043 7380 045B  20         b     *r11                  ; Return to caller
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
0065 7382 0649  14         dect  stack
0066 7384 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 7386 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     7388 32C0 
0071 738A 06A0  32         bl    @edb.init             ; Initialize editor buffer
     738C 3282 
0072 738E 06A0  32         bl    @idx.init             ; Initialize index
     7390 3182 
0073 7392 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7394 3120 
0074 7396 06A0  32         bl    @errline.init         ; Initialize error line
     7398 32FC 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 739A 06A0  32         bl    @hchar
     739C 27D6 
0079 739E 0034                   byte 0,52,32,18           ; Remove markers
     73A0 2012 
0080 73A2 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     73A4 2033 
0081 73A6 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 73A8 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 73AA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
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
0020 73AC 0649  14         dect  stack
0021 73AE C64B  30         mov   r11,*stack            ; Save return address
0022 73B0 0649  14         dect  stack
0023 73B2 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 73B4 06A0  32         bl    @mknum                ; Convert unsigned number to string
     73B6 2AA4 
0028 73B8 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 73BA A140                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 73BC 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 73BE 0204  20         li    tmp0,unpacked.string
     73C0 A026 
0034 73C2 04F4  30         clr   *tmp0+                ; Clear string 01
0035 73C4 04F4  30         clr   *tmp0+                ; Clear string 23
0036 73C6 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 73C8 06A0  32         bl    @trimnum              ; Trim unsigned number string
     73CA 2AFC 
0039 73CC A140                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 73CE A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 73D0 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 73D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 73D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 73D6 045B  20         b     *r11                  ; Return to caller
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
0073 73D8 0649  14         dect  stack
0074 73DA C64B  30         mov   r11,*stack            ; Push return address
0075 73DC 0649  14         dect  stack
0076 73DE C644  30         mov   tmp0,*stack           ; Push tmp0
0077 73E0 0649  14         dect  stack
0078 73E2 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 73E4 0649  14         dect  stack
0080 73E6 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 73E8 0649  14         dect  stack
0082 73EA C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 73EC C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     73EE A000 
0087 73F0 D194  26         movb  *tmp0,tmp2            ; /
0088 73F2 0986  56         srl   tmp2,8                ; Right align
0089 73F4 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 73F6 8806  38         c     tmp2,@parm2           ; String length > requested length?
     73F8 A002 
0092 73FA 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 73FC C120  34         mov   @parm1,tmp0           ; Get source address
     73FE A000 
0097 7400 C160  34         mov   @parm4,tmp1           ; Get destination address
     7402 A006 
0098 7404 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 7406 0649  14         dect  stack
0101 7408 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 740A 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     740C 24EE 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 740E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 7410 C120  34         mov   @parm2,tmp0           ; Get requested length
     7412 A002 
0113 7414 0A84  56         sla   tmp0,8                ; Left align
0114 7416 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     7418 A006 
0115 741A D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 741C A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 741E 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 7420 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     7422 A002 
0122 7424 6187  18         s     tmp3,tmp2             ; |
0123 7426 0586  14         inc   tmp2                  ; /
0124               
0125 7428 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     742A A004 
0126 742C 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 742E DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 7430 0606  14         dec   tmp2                  ; Update loop counter
0133 7432 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 7434 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     7436 A006 
     7438 A010 
0136 743A 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 743C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     743E FFCE 
0142 7440 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7442 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 7444 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 7446 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 7448 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 744A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 744C C2F9  30         mov   *stack+,r11           ; Pop r11
0152 744E 045B  20         b     *r11                  ; Return to caller
0153               
0154               
0155               ***************************************************************
0156               * tv.quit
0157               * Reset computer to monitor
0158               ***************************************************************
0159               * b    @tv.quit
0160               *--------------------------------------------------------------
0161               * INPUT
0162               * none
0163               *--------------------------------------------------------------
0164               * OUTPUT
0165               * none
0166               *--------------------------------------------------------------
0167               * Register usage
0168               * none
0169               ***************************************************************
0170               tv.quit:
0171                       ;-------------------------------------------------------
0172                       ; Reset/lock F18a
0173                       ;-------------------------------------------------------
0174 7450 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     7452 27AA 
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 7454 04E0  34         clr   @bank0.rom            ; Activate bank 0
     7456 6000 
0179 7458 0420  54         blwp  @0                    ; Reset to monitor
     745A 0000 
**** **** ****     > ram.resident.asm
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
0017 745C 0649  14         dect  stack
0018 745E C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 7460 06A0  32         bl    @sams.layout
     7462 25F0 
0023 7464 3450                   data mem.sams.layout.data
0024               
0025 7466 06A0  32         bl    @sams.layout.copy
     7468 2654 
0026 746A A200                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 746C C820  54         mov   @tv.sams.c000,@edb.sams.page
     746E A208 
     7470 A516 
0029 7472 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     7474 A516 
     7476 A518 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 7478 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 747A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
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
0033 747C 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     747E 003F 
     7480 0243 
     7482 05F4 
     7484 0050 
0034               
0035               romsat:
0036 7486 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     7488 0201 
0037 748A 0000             data  >0000,>0301             ; Current line indicator
     748C 0301 
0038 748E 0820             data  >0820,>0401             ; Current line indicator
     7490 0401 
0039               nosprite:
0040 7492 D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 7494 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7496 0002 
0048 7498 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     749A 0003 
0049 749C A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     749E 000A 
0050               
0051 74A0 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     74A2 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 74A4 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     74A6 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 74A8 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     74AA 000D 
0060 74AC E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     74AE 000E 
0061 74B0 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     74B2 000F 
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
0117 74B4 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     74B6 F171 
     74B8 1B1F 
     74BA 71B1 
0118 74BC A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     74BE F0FF 
     74C0 1F1A 
     74C2 F1FF 
0119 74C4 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     74C6 F0FF 
     74C8 1F12 
     74CA F1F6 
0120 74CC F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     74CE 1E11 
     74D0 1A17 
     74D2 1E11 
0121 74D4 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     74D6 E1FF 
     74D8 1F1E 
     74DA E1FF 
0122 74DC 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     74DE 1016 
     74E0 1B71 
     74E2 1711 
0123 74E4 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     74E6 1011 
     74E8 F1F1 
     74EA 1F11 
0124 74EC 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     74EE A1FF 
     74F0 1F1F 
     74F2 F11F 
0125 74F4 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     74F6 12FF 
     74F8 1B12 
     74FA 12FF 
0126 74FC F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     74FE E1FF 
     7500 1B1F 
     7502 F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 7504 0007             byte  0,7,12,25               ; \   Default tab positions as used
     7506 0C19 
0131 7508 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     750A 3B4F 
0132 750C FF00             byte  >ff,0,0,0               ; |
     750E 0000 
0133 7510 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     7512 0000 
0134 7514 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     7516 0000 
0135                       even
**** **** ****     > ram.resident.asm
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
0012 7518 0B53             byte  11
0013 7519 ....             text  'STEVIE 1.1S'
0014                       even
0015               
0016               txt.about.build
0017 7524 4C42             byte  76
0018 7525 ....             text  'Build: 210912-1052616 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 7572 012C             byte  1
0024 7573 ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 7574 0520             byte  5
0029 7575 ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 757A 034F             byte  3
0034 757B ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 757E 0349             byte  3
0039 757F ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 7582 012A             byte  1
0044 7583 ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 7584 0A4C             byte  10
0049 7585 ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 7590 0A53             byte  10
0054 7591 ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 759C 1244             byte  18
0059 759D ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 75B0 1143             byte  17
0064 75B1 ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 75C2 104D             byte  16
0069 75C3 ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 75D4 1D53             byte  29
0074 75D5 ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 75F2 0846             byte  8
0079 75F3 ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 75FC 026B             byte  2
0084 75FD ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 7600 054C             byte  5
0089 7601 ....             text  'Lines'
0090                       even
0091               
0092               txt.newfile
0093 7606 0A5B             byte  10
0094 7607 ....             text  '[New file]'
0095                       even
0096               
0097               txt.filetype.dv80
0098 7612 0444             byte  4
0099 7613 ....             text  'DV80'
0100                       even
0101               
0102               txt.m1
0103 7618 034D             byte  3
0104 7619 ....             text  'M1='
0105                       even
0106               
0107               txt.m2
0108 761C 034D             byte  3
0109 761D ....             text  'M2='
0110                       even
0111               
0112               txt.keys.default
0113 7620 0746             byte  7
0114 7621 ....             text  'F9=Menu'
0115                       even
0116               
0117               txt.keys.block
0118 7628 3342             byte  51
0119 7629 ....             text  'Block: F9=Back  ^Del  ^Copy  ^Move  ^Goto M1  ^Save'
0120                       even
0121               
0122 765C ....     txt.ruler          text    '.........'
0123                                  byte    18
0124 7666 ....                        text    '.........'
0125                                  byte    19
0126 7670 ....                        text    '.........'
0127                                  byte    20
0128 767A ....                        text    '.........'
0129                                  byte    21
0130 7684 ....                        text    '.........'
0131                                  byte    22
0132 768E ....                        text    '.........'
0133                                  byte    23
0134 7698 ....                        text    '.........'
0135                                  byte    24
0136 76A2 ....                        text    '.........'
0137                                  byte    25
0138                                  even
0139 76AC 020E     txt.alpha.down     data >020e,>0f00
     76AE 0F00 
0140 76B0 0110     txt.vertline       data >0110
0141 76B2 011C     txt.keymarker      byte 1,28
0142               
0143               txt.ws1
0144 76B4 0120             byte  1
0145 76B5 ....             text  ' '
0146                       even
0147               
0148               txt.ws2
0149 76B6 0220             byte  2
0150 76B7 ....             text  '  '
0151                       even
0152               
0153               txt.ws3
0154 76BA 0320             byte  3
0155 76BB ....             text  '   '
0156                       even
0157               
0158               txt.ws4
0159 76BE 0420             byte  4
0160 76BF ....             text  '    '
0161                       even
0162               
0163               txt.ws5
0164 76C4 0520             byte  5
0165 76C5 ....             text  '     '
0166                       even
0167               
0168      367A     txt.filetype.none  equ txt.ws4
0169               
0170               
0171               ;--------------------------------------------------------------
0172               ; Dialog Load DV 80 file
0173               ;--------------------------------------------------------------
0174 76CA 1301     txt.head.load      byte 19,1,3
     76CC 0320 
0175 76CD ....                        text ' Open DV80 file '
0176                                  byte 2
0177               txt.hint.load
0178 76DE 3D53             byte  61
0179 76DF ....             text  'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'
0180                       even
0181               
0182               
0183 771C 3146     txt.keys.load      byte 49
0184 771D ....                        text 'F9=Back  F3=Clear  F5=Fastmode  F-H=Home  F-L=End'
0185               
0186 774E 3246     txt.keys.load2     byte 50
0187 774F ....                        text 'F9=Back  F3=Clear  *F5=Fastmode  F-H=Home  F-L=End'
0188               
0189               ;--------------------------------------------------------------
0190               ; Dialog Save DV 80 file
0191               ;--------------------------------------------------------------
0192 7782 0103     txt.head.save      byte 19,1,3
0193 7784 ....                        text ' Save DV80 file '
0194 7794 0223                        byte 2
0195 7796 0103     txt.head.save2     byte 35,1,3,32
     7798 2053 
0196 7799 ....                        text 'Save marked block to DV80 file '
0197 77B8 0201                        byte 2
0198               txt.hint.save
0199                       byte  1
0200 77BA ....             text  ' '
0201                       even
0202               
0203               
0204 77BC 2446     txt.keys.save      byte 36
0205 77BD ....                        text 'F9=Back  F3=Clear  F-H=Home  F-L=End'
0206               
0207               ;--------------------------------------------------------------
0208               ; Dialog "Unsaved changes"
0209               ;--------------------------------------------------------------
0210 77E2 0103     txt.head.unsaved   byte 20,1,3
0211 77E4 ....                        text ' Unsaved changes '
0212                                  byte 2
0213               txt.info.unsaved
0214 77F6 2157             byte  33
0215 77F7 ....             text  'Warning! Unsaved changes in file.'
0216                       even
0217               
0218               txt.hint.unsaved
0219 7818 2A50             byte  42
0220 7819 ....             text  'Press F6 to proceed or ENTER to save file.'
0221                       even
0222               
0223               txt.keys.unsaved
0224 7844 2843             byte  40
0225 7845 ....             text  'Confirm: F9=Back  F6=Proceed  ENTER=Save'
0226                       even
0227               
0228               
0229               ;--------------------------------------------------------------
0230               ; Dialog "About"
0231               ;--------------------------------------------------------------
0232 786E 0A01     txt.head.about     byte 10,1,3
     7870 0320 
0233 7871 ....                        text ' About '
0234 7878 0200                        byte 2
0235               
0236               txt.info.about
0237                       byte  0
0238 787A ....             text
0239                       even
0240               
0241               txt.hint.about
0242 787A 1D50             byte  29
0243 787B ....             text  'Press F9 to return to editor.'
0244                       even
0245               
0246 7898 2148     txt.keys.about     byte 33
0247 7899 ....                        text 'Help: F9=Back  '
0248 78A8 0E0F                        byte 14,15
0249 78AA ....                        text '=Alpha Lock down'
0250               
0251               
0252               ;--------------------------------------------------------------
0253               ; Dialog "Menu"
0254               ;--------------------------------------------------------------
0255 78BA 1001     txt.head.menu      byte 16,1,3
     78BC 0320 
0256 78BD ....                        text ' Stevie 1.1T '
0257 78CA 021A                        byte 2
0258               
0259               txt.info.menu
0260                       byte  26
0261 78CC ....             text  'File / Basic / Help / Quit'
0262                       even
0263               
0264 78E6 0007     pos.info.menu      byte 0,7,15,22,>ff
     78E8 0F16 
     78EA FF28 
0265               txt.hint.menu
0266                       byte  40
0267 78EC ....             text  'Press F,B,H,Q or F9 to return to editor.'
0268                       even
0269               
0270               txt.keys.menu
0271 7914 0746             byte  7
0272 7915 ....             text  'F9=Back'
0273                       even
0274               
0275               
0276               
0277               ;--------------------------------------------------------------
0278               ; Dialog "File"
0279               ;--------------------------------------------------------------
0280 791C 0901     txt.head.file      byte 9,1,3
     791E 0320 
0281 791F ....                        text ' File '
0282                                  byte 2
0283               
0284               txt.info.file
0285 7926 114E             byte  17
0286 7927 ....             text  'New / Open / Save'
0287                       even
0288               
0289 7938 0006     pos.info.file      byte 0,6,13,>ff
     793A 0DFF 
0290               txt.hint.file
0291 793C 2650             byte  38
0292 793D ....             text  'Press N,O,S or F9 to return to editor.'
0293                       even
0294               
0295               txt.keys.file
0296 7964 0746             byte  7
0297 7965 ....             text  'F9=Back'
0298                       even
0299               
0300               
0301               ;--------------------------------------------------------------
0302               ; Dialog "Basic"
0303               ;--------------------------------------------------------------
0304 796C 0E01     txt.head.basic     byte 14,1,3
     796E 0320 
0305 796F ....                        text ' Run basic '
0306 797A 021C                        byte 2
0307               
0308               txt.info.basic
0309                       byte  28
0310 797C ....             text  'TI Basic / TI Extended Basic'
0311                       even
0312               
0313 7998 030E     pos.info.basic     byte 3,14,>ff
     799A FF3E 
0314               txt.hint.basic
0315                       byte  62
0316 799C ....             text  'Press B,E for running basic dialect or F9 to return to editor.'
0317                       even
0318               
0319               txt.keys.basic
0320 79DA 0746             byte  7
0321 79DB ....             text  'F9=Back'
0322                       even
0323               
0324               
0325               
0326               ;--------------------------------------------------------------
0327               ; Strings for error line pane
0328               ;--------------------------------------------------------------
0329               txt.ioerr.load
0330 79E2 2049             byte  32
0331 79E3 ....             text  'I/O error. Failed loading file: '
0332                       even
0333               
0334               txt.ioerr.save
0335 7A04 2049             byte  32
0336 7A05 ....             text  'I/O error. Failed saving file:  '
0337                       even
0338               
0339               txt.memfull.load
0340 7A26 4049             byte  64
0341 7A27 ....             text  'Index memory full. Could not fully load file into editor buffer.'
0342                       even
0343               
0344               txt.io.nofile
0345 7A68 2149             byte  33
0346 7A69 ....             text  'I/O error. No filename specified.'
0347                       even
0348               
0349               txt.block.inside
0350 7A8A 3445             byte  52
0351 7A8B ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0352                       even
0353               
0354               
0355               ;--------------------------------------------------------------
0356               ; Strings for command buffer
0357               ;--------------------------------------------------------------
0358               txt.cmdb.prompt
0359 7AC0 013E             byte  1
0360 7AC1 ....             text  '>'
0361                       even
0362               
0363               txt.colorscheme
0364 7AC2 0D43             byte  13
0365 7AC3 ....             text  'Color scheme:'
0366                       even
0367               
**** **** ****     > ram.resident.asm
0018                       copy  "data.keymap.keys.asm"   ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.keys.asm
0001               * FILE......: data.keymap.keys.asm
0002               * Purpose...: Keyboard mapping
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Keyboard scancodes - Letter keys
0007               *-------------|---------------------|---------------------------
0008      0042     key.uc.b      equ >42               ; B
0009      0045     key.uc.e      equ >45               ; E
0010      0046     key.uc.f      equ >46               ; F
0011      0048     key.uc.h      equ >48               ; H
0012      004E     key.uc.n      equ >4e               ; N
0013      0053     key.uc.s      equ >53               ; S
0014      004F     key.uc.o      equ >4f               ; O
0015      0051     key.uc.q      equ >51               ; Q
0016      00A2     key.lc.b      equ >a2               ; b
0017      00A5     key.lc.e      equ >a5               ; e
0018      00A6     key.lc.f      equ >a6               ; f
0019      00A8     key.lc.h      equ >a8               ; h
0020      006E     key.lc.n      equ >6e               ; n
0021      0073     key.lc.s      equ >73               ; s
0022      006F     key.lc.o      equ >6f               ; o
0023      0071     key.lc.q      equ >71               ; q
0024               
0025               
0026               *---------------------------------------------------------------
0027               * Keyboard scancodes - Function keys
0028               *-------------|---------------------|---------------------------
0029      00BC     key.fctn.0    equ >bc               ; fctn + 0
0030      0003     key.fctn.1    equ >03               ; fctn + 1
0031      0004     key.fctn.2    equ >04               ; fctn + 2
0032      0007     key.fctn.3    equ >07               ; fctn + 3
0033      0002     key.fctn.4    equ >02               ; fctn + 4
0034      000E     key.fctn.5    equ >0e               ; fctn + 5
0035      000C     key.fctn.6    equ >0c               ; fctn + 6
0036      0001     key.fctn.7    equ >01               ; fctn + 7
0037      0006     key.fctn.8    equ >06               ; fctn + 8
0038      000F     key.fctn.9    equ >0f               ; fctn + 9
0039      0000     key.fctn.a    equ >00               ; fctn + a
0040      00BE     key.fctn.b    equ >be               ; fctn + b
0041      0000     key.fctn.c    equ >00               ; fctn + c
0042      0009     key.fctn.d    equ >09               ; fctn + d
0043      000B     key.fctn.e    equ >0b               ; fctn + e
0044      0000     key.fctn.f    equ >00               ; fctn + f
0045      0000     key.fctn.g    equ >00               ; fctn + g
0046      00BF     key.fctn.h    equ >bf               ; fctn + h
0047      0000     key.fctn.i    equ >00               ; fctn + i
0048      00C0     key.fctn.j    equ >c0               ; fctn + j
0049      00C1     key.fctn.k    equ >c1               ; fctn + k
0050      00C2     key.fctn.l    equ >c2               ; fctn + l
0051      00C3     key.fctn.m    equ >c3               ; fctn + m
0052      00C4     key.fctn.n    equ >c4               ; fctn + n
0053      0000     key.fctn.o    equ >00               ; fctn + o
0054      0000     key.fctn.p    equ >00               ; fctn + p
0055      00C5     key.fctn.q    equ >c5               ; fctn + q
0056      0000     key.fctn.r    equ >00               ; fctn + r
0057      0008     key.fctn.s    equ >08               ; fctn + s
0058      0000     key.fctn.t    equ >00               ; fctn + t
0059      0000     key.fctn.u    equ >00               ; fctn + u
0060      007F     key.fctn.v    equ >7f               ; fctn + v
0061      007E     key.fctn.w    equ >7e               ; fctn + w
0062      000A     key.fctn.x    equ >0a               ; fctn + x
0063      00C6     key.fctn.y    equ >c6               ; fctn + y
0064      0000     key.fctn.z    equ >00               ; fctn + z
0065               *---------------------------------------------------------------
0066               * Keyboard scancodes - Function keys extra
0067               *---------------------------------------------------------------
0068      00B9     key.fctn.dot    equ >b9             ; fctn + .
0069      00B8     key.fctn.comma  equ >b8             ; fctn + ,
0070      0005     key.fctn.plus   equ >05             ; fctn + +
0071               *---------------------------------------------------------------
0072               * Keyboard scancodes - control keys
0073               *-------------|---------------------|---------------------------
0074      00B0     key.ctrl.0    equ >b0               ; ctrl + 0
0075      00B1     key.ctrl.1    equ >b1               ; ctrl + 1
0076      00B2     key.ctrl.2    equ >b2               ; ctrl + 2
0077      00B3     key.ctrl.3    equ >b3               ; ctrl + 3
0078      00B4     key.ctrl.4    equ >b4               ; ctrl + 4
0079      00B5     key.ctrl.5    equ >b5               ; ctrl + 5
0080      00B6     key.ctrl.6    equ >b6               ; ctrl + 6
0081      00B7     key.ctrl.7    equ >b7               ; ctrl + 7
0082      009E     key.ctrl.8    equ >9e               ; ctrl + 8
0083      009F     key.ctrl.9    equ >9f               ; ctrl + 9
0084      0081     key.ctrl.a    equ >81               ; ctrl + a
0085      0082     key.ctrl.b    equ >82               ; ctrl + b
0086      0083     key.ctrl.c    equ >83               ; ctrl + c
0087      0084     key.ctrl.d    equ >84               ; ctrl + d
0088      0085     key.ctrl.e    equ >85               ; ctrl + e
0089      0086     key.ctrl.f    equ >86               ; ctrl + f
0090      0087     key.ctrl.g    equ >87               ; ctrl + g
0091      0088     key.ctrl.h    equ >88               ; ctrl + h
0092      0089     key.ctrl.i    equ >89               ; ctrl + i
0093      008A     key.ctrl.j    equ >8a               ; ctrl + j
0094      008B     key.ctrl.k    equ >8b               ; ctrl + k
0095      008C     key.ctrl.l    equ >8c               ; ctrl + l
0096      008D     key.ctrl.m    equ >8d               ; ctrl + m
0097      008E     key.ctrl.n    equ >8e               ; ctrl + n
0098      008F     key.ctrl.o    equ >8f               ; ctrl + o
0099      0090     key.ctrl.p    equ >90               ; ctrl + p
0100      0091     key.ctrl.q    equ >91               ; ctrl + q
0101      0092     key.ctrl.r    equ >92               ; ctrl + r
0102      0093     key.ctrl.s    equ >93               ; ctrl + s
0103      0094     key.ctrl.t    equ >94               ; ctrl + t
0104      0095     key.ctrl.u    equ >95               ; ctrl + u
0105      0096     key.ctrl.v    equ >96               ; ctrl + v
0106      0097     key.ctrl.w    equ >97               ; ctrl + w
0107      0098     key.ctrl.x    equ >98               ; ctrl + x
0108      0099     key.ctrl.y    equ >99               ; ctrl + y
0109      009A     key.ctrl.z    equ >9a               ; ctrl + z
0110               *---------------------------------------------------------------
0111               * Keyboard scancodes - control keys extra
0112               *---------------------------------------------------------------
0113      009B     key.ctrl.dot    equ >9b             ; ctrl + .
0114      0080     key.ctrl.comma  equ >80             ; ctrl + ,
0115      009D     key.ctrl.plus   equ >9d             ; ctrl + +
0116               *---------------------------------------------------------------
0117               * Special keys
0118               *---------------------------------------------------------------
0119      000D     key.enter     equ >0d               ; enter
**** **** ****     > stevie_b6.asm.1052616
0042                       ;------------------------------------------------------
0043                       ; Activate bank 1 and branch to  >6036
0044                       ;------------------------------------------------------
0045 7AD0 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     7AD2 6002 
0046               
0050               
0051 7AD4 0460  28         b     @kickstart.code2      ; Jump to entry routine
     7AD6 6046 
0052               ***************************************************************
0053               * Step 3: Include main editor modules
0054               ********|*****|*********************|**************************
0055               main:
0056                       aorg  kickstart.code2       ; >6046
0057 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 2026 
0058                       ;-----------------------------------------------------------------------
0059                       ; Stubs using trampoline
0060                       ;-----------------------------------------------------------------------
0061                       copy  "rom.stubs.bank6.asm" ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank6.asm
0001               * FILE......: rom.stubs.bank6.asm
0002               * Purpose...: Bank 6 stubs for functions in other banks
**** **** ****     > stevie_b6.asm.1052616
0062                       ;-----------------------------------------------------------------------
0063                       ; Bank full check
0064                       ;-----------------------------------------------------------------------
0068                       ;-----------------------------------------------------------------------
0069                       ; Vector table
0070                       ;-----------------------------------------------------------------------
0071                       aorg  >7fc0
0072                       copy  "rom.vectors.bank6.asm"
**** **** ****     > rom.vectors.bank6.asm
0001               * FILE......: rom.vectors.bank6.asm
0002               * Purpose...: Bank 6 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 2026     vec.1   data  cpu.crash             ;
0008 7FC2 2026     vec.2   data  cpu.crash             ;
0009 7FC4 2026     vec.3   data  cpu.crash             ;
0010 7FC6 2026     vec.4   data  cpu.crash             ;
0011 7FC8 2026     vec.5   data  cpu.crash             ;
0012 7FCA 2026     vec.6   data  cpu.crash             ;
0013 7FCC 2026     vec.7   data  cpu.crash             ;
0014 7FCE 2026     vec.8   data  cpu.crash             ;
0015 7FD0 2026     vec.9   data  cpu.crash             ;
0016 7FD2 2026     vec.10  data  cpu.crash             ;
0017 7FD4 2026     vec.11  data  cpu.crash             ;
0018 7FD6 2026     vec.12  data  cpu.crash             ;
0019 7FD8 2026     vec.13  data  cpu.crash             ;
0020 7FDA 2026     vec.14  data  cpu.crash             ;
0021 7FDC 2026     vec.15  data  cpu.crash             ;
0022 7FDE 2026     vec.16  data  cpu.crash             ;
0023 7FE0 2026     vec.17  data  cpu.crash             ;
0024 7FE2 2026     vec.18  data  cpu.crash             ;
0025 7FE4 2026     vec.19  data  cpu.crash             ;
0026 7FE6 2026     vec.20  data  cpu.crash             ;
0027 7FE8 2026     vec.21  data  cpu.crash             ;
0028 7FEA 2026     vec.22  data  cpu.crash             ;
0029 7FEC 2026     vec.23  data  cpu.crash             ;
0030 7FEE 2026     vec.24  data  cpu.crash             ;
0031 7FF0 2026     vec.25  data  cpu.crash             ;
0032 7FF2 2026     vec.26  data  cpu.crash             ;
0033 7FF4 2026     vec.27  data  cpu.crash             ;
0034 7FF6 2026     vec.28  data  cpu.crash             ;
0035 7FF8 2026     vec.29  data  cpu.crash             ;
0036 7FFA 2026     vec.30  data  cpu.crash             ;
0037 7FFC 2026     vec.31  data  cpu.crash             ;
0038 7FFE 2026     vec.32  data  cpu.crash             ;
**** **** ****     > stevie_b6.asm.1052616
0073                                                   ; Vector table bank 6
0074               
0075               *--------------------------------------------------------------
0076               * Video mode configuration
0077               *--------------------------------------------------------------
0078      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0079      0004     spfbck  equ   >04                   ; Screen background color.
0080      3438     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0081      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0082      0050     colrow  equ   80                    ; Columns per row
0083      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0084      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0085      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0086      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

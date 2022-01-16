XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b0.asm.57700
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2022 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b0.asm               ; Version 220116-1948400
0010               *
0011               * Bank 0 "Jill"
0012               * Setup resident SP2/Stevie modules and start SP2 kernel
0013               ***************************************************************
0014                       copy  "rom.build.asm"       ; Cartridge build options
     **** ****     > rom.build.asm
0001               * FILE......: rom.build.asm
0002               * Purpose...: Cartridge build options
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
0023      0001     skip_sams_layout          equ  1       ; Skip SAMS memory layout routine
0024                                                      ; \
0025                                                      ; | The SAMS support module needs to be
0026                                                      ; | embedded in the cartridge space, so
0027                                                      ; / do not load it here.
0028               
0029               *--------------------------------------------------------------
0030               * SPECTRA2 / Stevie startup options
0031               *--------------------------------------------------------------
0032      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0033      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0034      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0035      0001     rom0_kscan_on             equ  1       ; Use KSCAN in console ROM#0
0036               
0037               
0038               
0039               *--------------------------------------------------------------
0040               * classic99 and JS99er emulators are mutually exclusive.
0041               * At the time of writing JS99er has full F18a compatibility.
0042               *
0043               * If build target is the JS99er emulator or an F18a equiped TI-99/4a
0044               * then set the 'full_f18a_support' equate to 1.
0045               *
0046               * When targetting the classic99 emulator then set the
0047               * 'full_f18a_support' equate to 0.
0048               * This will build the trimmed down version with 24x80 resolution.
0049               *--------------------------------------------------------------
0050      0000     debug                     equ  0       ; Turn on debugging mode
0051      0001     full_f18a_support         equ  1       ; 30 rows mode with sprites
0052               
0053               
0054               *--------------------------------------------------------------
0055               * JS99er F18a 30x80, no FG99 advanced mode
0056               *--------------------------------------------------------------
0058      0001     device.f18a               equ  1       ; F18a GPU
0059      0000     device.9938               equ  0       ; 9938 GPU
0060      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode off
0062               
0063               
0064               
0065               *--------------------------------------------------------------
0066               * Classic99 F18a 24x80, no FG99 advanced mode
0067               *--------------------------------------------------------------
                   < stevie_b0.asm.57700
0015                       copy  "rom.order.asm"       ; ROM bank ordster "non-inverted"
     **** ****     > rom.order.asm
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
0026               
0027      7FC0     bankx.vectab              equ  >7fc0   ; Start address of vector table
                   < stevie_b0.asm.57700
0016                       copy  "equates.asm"         ; Equates Stevie configuration
     **** ****     > equates.asm
0001               * FILE......: equates.asm
0002               * Purpose...: The main equates file for Stevie editor
0003               
0004               
0005               *===============================================================================
0006               * Memory map
0007               * ==========
0008               *
0009               * CARTRIDGE SPACE (6000-7fff)
0010               *
0011               *     Mem range   Bytes    BANK   Purpose
0012               *     =========   =====    ====   ==================================
0013               *     6000-633f               0   Cartridge header
0014               *     6040-7fff               0   SP2 library + Stevie library
0015               *                                 relocated to RAM space
0016               *     ..............................................................
0017               *     6000-633f               1   Cartridge header
0018               *     6040-7fbf               1   Stevie program code
0019               *     7fc0-7fff      64       1   Vector table (32 vectors)
0020               *     ..............................................................
0021               *     6000-633f               2   Cartridge header
0022               *     6040-7fbf               2   Stevie program code
0023               *     7fc0-7fff      64       2   Vector table (32 vectors)
0024               *     ..............................................................
0025               *     6000-633f               3   Cartridge header
0026               *     6040-7fbf               3   Stevie program code
0027               *     7fc0-7fff      64       3   Vector table (32 vectors)
0028               *     ..............................................................
0029               *     6000-633f               4   Cartridge header
0030               *     6040-7fbf               4   Stevie program code
0031               *     7fc0-7fff      64       4   Vector table (32 vectors)
0032               *     ..............................................................
0033               *     6000-633f               5   Cartridge header
0034               *     6040-7fbf               5   Stevie program code
0035               *     7fc0-7fff      64       5   Vector table (32 vectors)
0036               *     ..............................................................
0037               *     6000-633f               6   Cartridge header
0038               *     6040-7fbf               6   Stevie program code
0039               *     7fc0-7fff      64       6   Vector table (32 vectors)
0040               *     ..............................................................
0041               *     6000-633f               7   Cartridge header
0042               *     6040-7fbf               7   SP2 library in cartridge space
0043               *     7fc0-7fff      64       7   Vector table (32 vectors)
0044               *
0045               *
0046               *
0047               * VDP RAM F18a (0000-47ff)
0048               *
0049               *     Mem range   Bytes    Hex    Purpose
0050               *     =========   =====   =====   =================================
0051               *     0000-095f    2400   >0960   PNT: Pattern Name Table
0052               *     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
0053               *     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
0054               *     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
0055               *     1800-215f    2400   >0960   TAT: Tile Attribute Table
0056               *                                      (Position based colors F18a, 80 colums)
0057               *     2180                        SAT: Sprite Attribute Table
0058               *                                      (Cursor in F18a, 80 cols mode)
0059               *     2800                        SPT: Sprite Pattern Table
0060               *                                      (Cursor in F18a, 80 columns, 2K boundary)
0061               *===============================================================================
0062               
0063               *--------------------------------------------------------------
0064               * Graphics mode selection
0065               *--------------------------------------------------------------
0067               
0068      001D     pane.botrow               equ  29      ; Bottom row on screen
0069               
0075               *--------------------------------------------------------------
0076               * Stevie Dialog / Pane specific equates
0077               *--------------------------------------------------------------
0078      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0079      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0080               ;-----------------------------------------------------------------
0081               ;   Dialog ID's
0082               ;-----------------------------------------------------------------
0083      000A     id.dialog.load            equ  10      ; "Load file"
0084      000B     id.dialog.save            equ  11      ; "Save file"
0085      000C     id.dialog.saveblock       equ  12      ; "Save block to file"
0086      000D     id.dialog.insert          equ  13      ; "Insert file"
0087      000E     id.dialog.append          equ  14      ; "Append file"
0088      000F     id.dialog.print           equ  15      ; "Print file"
0089      0010     id.dialog.printblock      equ  16      ; "Print block"
0090      0011     id.dialog.clipdev         equ  17      ; "Configure clipboard device"
0091               ;-----------------------------------------------------------------
0092               ;   Dialog ID's >= 100 indicate that command prompt should be
0093               ;   hidden and no characters added to CMDB keyboard buffer.
0094               ;-----------------------------------------------------------------
0095      0064     id.dialog.menu            equ  100     ; "Main Menu"
0096      0065     id.dialog.unsaved         equ  101     ; "Unsaved changes"
0097      0066     id.dialog.block           equ  102     ; "Block move/copy/delete/print/..."
0098      0067     id.dialog.clipboard       equ  103     ; "Copy clipboard to line ..."
0099      0068     id.dialog.help            equ  104     ; "About"
0100      0069     id.dialog.file            equ  105     ; "File"
0101      006A     id.dialog.cartridge       equ  106     ; "Cartridge"
0102      006B     id.dialog.basic           equ  107     ; "Basic"
0103      006C     id.dialog.config          equ  108     ; "Configure"
0104               *--------------------------------------------------------------
0105               * Suffix characters for clipboards
0106               *--------------------------------------------------------------
0107      3100     clip1                     equ  >3100   ; '1'
0108      3200     clip2                     equ  >3200   ; '2'
0109      3300     clip3                     equ  >3300   ; '3'
0110      3400     clip4                     equ  >3400   ; '4'
0111      3500     clip5                     equ  >3500   ; '5'
0112               *--------------------------------------------------------------
0113               * File work mode
0114               *--------------------------------------------------------------
0115      0001     id.file.loadfile          equ  1       ; Load file
0116      0002     id.file.insertfile        equ  2       ; Insert file
0117      0003     id.file.appendfile        equ  3       ; Append file
0118      0004     id.file.savefile          equ  4       ; Save file
0119      0005     id.file.saveblock         equ  5       ; Save block to file
0120      0006     id.file.clipblock         equ  6       ; Save block to clipboard
0121      0007     id.file.printfile         equ  7       ; Print file
0122      0008     id.file.printblock        equ  8       ; Print block
0123               *--------------------------------------------------------------
0124               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0125               *--------------------------------------------------------------
0126      A000     core1.top         equ  >a000           ; Structure begin
0127      A000     parm1             equ  core1.top + 0   ; Function parameter 1
0128      A002     parm2             equ  core1.top + 2   ; Function parameter 2
0129      A004     parm3             equ  core1.top + 4   ; Function parameter 3
0130      A006     parm4             equ  core1.top + 6   ; Function parameter 4
0131      A008     parm5             equ  core1.top + 8   ; Function parameter 5
0132      A00A     parm6             equ  core1.top + 10  ; Function parameter 6
0133      A00C     parm7             equ  core1.top + 12  ; Function parameter 7
0134      A00E     parm8             equ  core1.top + 14  ; Function parameter 8
0135      A010     outparm1          equ  core1.top + 16  ; Function output parameter 1
0136      A012     outparm2          equ  core1.top + 18  ; Function output parameter 2
0137      A014     outparm3          equ  core1.top + 20  ; Function output parameter 3
0138      A016     outparm4          equ  core1.top + 22  ; Function output parameter 4
0139      A018     outparm5          equ  core1.top + 24  ; Function output parameter 5
0140      A01A     outparm6          equ  core1.top + 26  ; Function output parameter 6
0141      A01C     outparm7          equ  core1.top + 28  ; Function output parameter 7
0142      A01E     outparm8          equ  core1.top + 30  ; Function output parameter 8
0143      A020     keyrptcnt         equ  core1.top + 32  ; Key repeat-count (auto-repeat function)
0144      A022     keycode1          equ  core1.top + 34  ; Current key scanned
0145      A024     keycode2          equ  core1.top + 36  ; Previous key scanned
0146      A026     unpacked.string   equ  core1.top + 38  ; 6 char string with unpacked uin16
0147      A02C     tibasic.hidesid   equ  core1.top + 44  ; Hide TI-Basic session ID
0148      A02E     tibasic.session   equ  core1.top + 46  ; Active TI-Basic session (1-5)
0149      A030     tibasic1.status   equ  core1.top + 48  ; TI Basic session 1
0150      A032     tibasic2.status   equ  core1.top + 50  ; TI Basic session 2
0151      A034     tibasic3.status   equ  core1.top + 52  ; TI Basic session 3
0152      A036     tibasic4.status   equ  core1.top + 54  ; TI Basic session 4
0153      A038     tibasic5.status   equ  core1.top + 56  ; TI Basic session 5
0154      A03A     trmpvector        equ  core1.top + 58  ; Vector trampoline (if p1|tmp1 = >ffff)
0155      A03C     ramsat            equ  core1.top + 60  ; Sprite Attr. Table in RAM (14 bytes)
0156      A04A     timers            equ  core1.top + 74  ; Timers (80 bytes)
0157      A09A     core1.free        equ  core1.top + 154 ; End of structure
0158               *--------------------------------------------------------------
0159               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0160               *--------------------------------------------------------------
0161      A100     core2.top         equ  >a100           ; Structure begin
0162      A100     rambuf            equ  core2.top       ; RAM workbuffer
0163      A200     core2.free        equ  core2.top + 256 ; End of structure
0164               *--------------------------------------------------------------
0165               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0166               *--------------------------------------------------------------
0167      A200     tv.top            equ  >a200           ; Structure begin
0168      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0169      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0170      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0171      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0172      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0173      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0174      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0175      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0176      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0177      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0178      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0179      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0180      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0181      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0182      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0183      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0184      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0185      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0186      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0187      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0188      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0189      A22A     tv.error.rows     equ  tv.top + 42     ; Number of rows in error pane
0190      A22C     tv.sp2.conf       equ  tv.top + 44     ; Backup of SP2 config register
0191      A22E     tv.error.msg      equ  tv.top + 46     ; Error message (max. 160 characters)
0192      A2CE     tv.free           equ  tv.top + 206    ; End of structure
0193               *--------------------------------------------------------------
0194               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0195               *--------------------------------------------------------------
0196      A300     fb.struct         equ  >a300           ; Structure begin
0197      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0198      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0199      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0200                                                      ; line X in editor buffer).
0201      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0202                                                      ; (offset 0 .. @fb.scrrows)
0203      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0204      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0205      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0206      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0207      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0208      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0209      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0210      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0211      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0212      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0213      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0214      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0215      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0216      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0217               *--------------------------------------------------------------
0218               * File handle structure               @>a400-a4ff   (256 bytes)
0219               *--------------------------------------------------------------
0220      A400     fh.struct         equ  >a400           ; stevie file handling structures
0221               ;***********************************************************************
0222               ; ATTENTION
0223               ; The dsrlnk variables must form a continuous memory block and keep
0224               ; their order!
0225               ;***********************************************************************
0226      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0227      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0228      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0229      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0230      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0231      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0232      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0233      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0234      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0235      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0236      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0237      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0238      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0239      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0240      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0241      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0242      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0243      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0244      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0245      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0246      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0247      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0248      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0249      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0250      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0251      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0252      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0253      A45A     fh.workmode       equ  fh.struct + 90  ; Working mode (used in callbacks)
0254      A45C     fh.kilobytes.prev equ  fh.struct + 92  ; Kilobytes processed (previous)
0255      A45E     fh.line           equ  fh.struct + 94  ; Editor buffer line currently processing
0256      A460     fh.temp1          equ  fh.struct + 96  ; Temporary variable 1
0257      A462     fh.temp2          equ  fh.struct + 98  ; Temporary variable 2
0258      A464     fh.temp3          equ  fh.struct +100  ; Temporary variable 3
0259      A466     fh.membuffer      equ  fh.struct +102  ; 80 bytes file memory buffer
0260      A4B6     fh.free           equ  fh.struct +182  ; End of structure
0261      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0262      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0263               *--------------------------------------------------------------
0264               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0265               *--------------------------------------------------------------
0266      A500     edb.struct        equ  >a500           ; Begin structure
0267      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0268      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0269      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0270      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0271      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0272      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0273      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0274      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0275      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0276      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0277                                                      ; with current filename.
0278      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0279                                                      ; with current file type.
0280      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0281      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0282      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0283                                                      ; for filename, but not always used.
0284      A56A     edb.free          equ  edb.struct + 106; End of structure
0285               *--------------------------------------------------------------
0286               * Index structure                     @>a600-a6ff   (256 bytes)
0287               *--------------------------------------------------------------
0288      A600     idx.struct        equ  >a600           ; stevie index structure
0289      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0290      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0291      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0292      A606     idx.free          equ  idx.struct + 6  ; End of structure
0293               *--------------------------------------------------------------
0294               * Command buffer structure            @>a700-a7ff   (256 bytes)
0295               *--------------------------------------------------------------
0296      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0297      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0298      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0299      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0300      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0301      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0302      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0303      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0304      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0305      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0306      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0307      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0308      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0309      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0310      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0311      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0312      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0313      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0314      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0315      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0316      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0317      A728     cmdb.cmdall       equ  cmdb.struct + 40; Current command including length-byte
0318      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0319      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0320      A77A     cmdb.panhead.buf  equ  cmdb.struct +122; String buffer for pane header
0321      A7AC     cmdb.dflt.fname   equ  cmdb.struct +172; Default for filename
0322      A800     cmdb.free         equ  cmdb.struct +256; End of structure
0323               *--------------------------------------------------------------
0324               * Stevie value stack                  @>a800-a8ff   (256 bytes)
0325               *--------------------------------------------------------------
0326      A900     sp2.stktop        equ  >a900           ; \ SP2 stack >a800 - >a8ff
0327                                                      ; | The stack grows from high memory
0328                                                      ; / to low memory.
0329               *--------------------------------------------------------------
0330               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0331               *--------------------------------------------------------------
0332      7E00     cpu.scrpad.src    equ  >7e00           ; \ Dump of OS monitor scratchpad
0333                                                      ; / stored in cartridge ROM bank7.asm
0334               
0335      F960     cpu.scrpad.tgt    equ  >f960           ; \ Target copy of OS monitor scratchpad
0336                                                      ; | in high-memory.
0337                                                      ; /
0338               
0339      AD00     cpu.scrpad.moved  equ  >ad00           ; Stevie scratchpad memory when paged-out
0340                                                      ; because of TI Basic/External program
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
0357               * Frame buffer & Default devices      @>d000-dfff  (4096 bytes)
0358               *--------------------------------------------------------------
0359      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0360      0960     fb.size           equ  80*30           ; Frame buffer size
0361      D960     tv.printer.fname  equ  >d960           ; Default printer   (80 char)
0362      D9B0     tv.clip.fname     equ  >d9b0           ; Default clipboard (80 char)
0363               *--------------------------------------------------------------
0364               * Command buffer history              @>e000-efff  (4096 bytes)
0365               *--------------------------------------------------------------
0366      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0367      1000     cmdb.size         equ  4096            ; Command buffer size
0368               *--------------------------------------------------------------
0369               * Heap                                @>f000-ffff  (4096 bytes)
0370               *--------------------------------------------------------------
0371      F000     heap.top          equ  >f000           ; Top of heap
0372               
0373               
0374               *--------------------------------------------------------------
0375               * Stevie specific equates
0376               *--------------------------------------------------------------
0377      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0378      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0379      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0380      A022     rom0_kscan_out            equ  keycode1; Where to store value of key pressed
0381               
0382      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0383      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0384      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0385                                                      ; VDP TAT address of 1st CMDB row
0386      0000     vdp.sit.base              equ  >0000   ; VDP SIT base address
0387      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0388                                                      ; VDP SIT size 80 columns, 24/30 rows
0389      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0390      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0391      00FE     tv.1timeonly              equ  254     ; One-time only flag indicator
                   < stevie_b0.asm.57700
0017                       copy  "data.keymap.keys.asm"; Equates for keyboard mapping
     **** ****     > data.keymap.keys.asm
0001               * FILE......: data.keymap.keys.asm
0002               * Purpose...: Keyboard mapping
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Keyboard scancodes - Numeric keys
0007               *-------------|---------------------|---------------------------
0008      0030     key.num.0     equ >30               ; 0
0009      0031     key.num.1     equ >31               ; 1
0010      0032     key.num.2     equ >32               ; 2
0011      0033     key.num.3     equ >33               ; 3
0012      0034     key.num.4     equ >34               ; 4
0013      0035     key.num.5     equ >35               ; 5
0014      0036     key.num.6     equ >36               ; 6
0015      0037     key.num.7     equ >37               ; 7
0016      0038     key.num.8     equ >38               ; 8
0017      0039     key.num.9     equ >39               ; 9
0018               *---------------------------------------------------------------
0019               * Keyboard scancodes - Letter keys
0020               *-------------|---------------------|---------------------------
0021      0042     key.uc.b      equ >42               ; B
0022      0043     key.uc.c      equ >43               ; C
0023      0045     key.uc.e      equ >45               ; E
0024      0046     key.uc.f      equ >46               ; F
0025      0048     key.uc.h      equ >48               ; H
0026      0049     key.uc.i      equ >49               ; I
0027      004E     key.uc.n      equ >4e               ; N
0028      0053     key.uc.s      equ >53               ; S
0029      004F     key.uc.o      equ >4f               ; O
0030      0050     key.uc.p      equ >50               ; P
0031      0051     key.uc.q      equ >51               ; Q
0032      00A2     key.lc.b      equ >a2               ; b
0033      00A5     key.lc.e      equ >a5               ; e
0034      00A6     key.lc.f      equ >a6               ; f
0035      00A8     key.lc.h      equ >a8               ; h
0036      006E     key.lc.n      equ >6e               ; n
0037      0073     key.lc.s      equ >73               ; s
0038      006F     key.lc.o      equ >6f               ; o
0039      0070     key.lc.p      equ >70               ; p
0040      0071     key.lc.q      equ >71               ; q
0041               *---------------------------------------------------------------
0042               * Keyboard scancodes - Function keys
0043               *-------------|---------------------|---------------------------
0044      00BC     key.fctn.0    equ >bc               ; fctn + 0
0045      0003     key.fctn.1    equ >03               ; fctn + 1
0046      0004     key.fctn.2    equ >04               ; fctn + 2
0047      0007     key.fctn.3    equ >07               ; fctn + 3
0048      0002     key.fctn.4    equ >02               ; fctn + 4
0049      000E     key.fctn.5    equ >0e               ; fctn + 5
0050      000C     key.fctn.6    equ >0c               ; fctn + 6
0051      0001     key.fctn.7    equ >01               ; fctn + 7
0052      0006     key.fctn.8    equ >06               ; fctn + 8
0053      000F     key.fctn.9    equ >0f               ; fctn + 9
0054      0000     key.fctn.a    equ >00               ; fctn + a
0055      00BE     key.fctn.b    equ >be               ; fctn + b
0056      0000     key.fctn.c    equ >00               ; fctn + c
0057      0009     key.fctn.d    equ >09               ; fctn + d
0058      000B     key.fctn.e    equ >0b               ; fctn + e
0059      0000     key.fctn.f    equ >00               ; fctn + f
0060      0000     key.fctn.g    equ >00               ; fctn + g
0061      00BF     key.fctn.h    equ >bf               ; fctn + h
0062      0000     key.fctn.i    equ >00               ; fctn + i
0063      00C0     key.fctn.j    equ >c0               ; fctn + j
0064      00C1     key.fctn.k    equ >c1               ; fctn + k
0065      00C2     key.fctn.l    equ >c2               ; fctn + l
0066      00C3     key.fctn.m    equ >c3               ; fctn + m
0067      00C4     key.fctn.n    equ >c4               ; fctn + n
0068      0000     key.fctn.o    equ >00               ; fctn + o
0069      0000     key.fctn.p    equ >00               ; fctn + p
0070      00C5     key.fctn.q    equ >c5               ; fctn + q
0071      0000     key.fctn.r    equ >00               ; fctn + r
0072      0008     key.fctn.s    equ >08               ; fctn + s
0073      0000     key.fctn.t    equ >00               ; fctn + t
0074      0000     key.fctn.u    equ >00               ; fctn + u
0075      007F     key.fctn.v    equ >7f               ; fctn + v
0076      007E     key.fctn.w    equ >7e               ; fctn + w
0077      000A     key.fctn.x    equ >0a               ; fctn + x
0078      00C6     key.fctn.y    equ >c6               ; fctn + y
0079      0000     key.fctn.z    equ >00               ; fctn + z
0080               *---------------------------------------------------------------
0081               * Keyboard scancodes - Function keys extra
0082               *---------------------------------------------------------------
0083      00B9     key.fctn.dot    equ >b9             ; fctn + .
0084      00B8     key.fctn.comma  equ >b8             ; fctn + ,
0085      0005     key.fctn.plus   equ >05             ; fctn + +
0086               *---------------------------------------------------------------
0087               * Keyboard scancodes - control keys
0088               *-------------|---------------------|---------------------------
0089      00B0     key.ctrl.0    equ >b0               ; ctrl + 0
0090      00B1     key.ctrl.1    equ >b1               ; ctrl + 1
0091      00B2     key.ctrl.2    equ >b2               ; ctrl + 2
0092      00B3     key.ctrl.3    equ >b3               ; ctrl + 3
0093      00B4     key.ctrl.4    equ >b4               ; ctrl + 4
0094      00B5     key.ctrl.5    equ >b5               ; ctrl + 5
0095      00B6     key.ctrl.6    equ >b6               ; ctrl + 6
0096      00B7     key.ctrl.7    equ >b7               ; ctrl + 7
0097      009E     key.ctrl.8    equ >9e               ; ctrl + 8
0098      009F     key.ctrl.9    equ >9f               ; ctrl + 9
0099      0081     key.ctrl.a    equ >81               ; ctrl + a
0100      0082     key.ctrl.b    equ >82               ; ctrl + b
0101      0083     key.ctrl.c    equ >83               ; ctrl + c
0102      0084     key.ctrl.d    equ >84               ; ctrl + d
0103      0085     key.ctrl.e    equ >85               ; ctrl + e
0104      0086     key.ctrl.f    equ >86               ; ctrl + f
0105      0087     key.ctrl.g    equ >87               ; ctrl + g
0106      0088     key.ctrl.h    equ >88               ; ctrl + h
0107      0089     key.ctrl.i    equ >89               ; ctrl + i
0108      008A     key.ctrl.j    equ >8a               ; ctrl + j
0109      008B     key.ctrl.k    equ >8b               ; ctrl + k
0110      008C     key.ctrl.l    equ >8c               ; ctrl + l
0111      008D     key.ctrl.m    equ >8d               ; ctrl + m
0112      008E     key.ctrl.n    equ >8e               ; ctrl + n
0113      008F     key.ctrl.o    equ >8f               ; ctrl + o
0114      0090     key.ctrl.p    equ >90               ; ctrl + p
0115      0091     key.ctrl.q    equ >91               ; ctrl + q
0116      0092     key.ctrl.r    equ >92               ; ctrl + r
0117      0093     key.ctrl.s    equ >93               ; ctrl + s
0118      0094     key.ctrl.t    equ >94               ; ctrl + t
0119      0095     key.ctrl.u    equ >95               ; ctrl + u
0120      0096     key.ctrl.v    equ >96               ; ctrl + v
0121      0097     key.ctrl.w    equ >97               ; ctrl + w
0122      0098     key.ctrl.x    equ >98               ; ctrl + x
0123      0099     key.ctrl.y    equ >99               ; ctrl + y
0124      009A     key.ctrl.z    equ >9a               ; ctrl + z
0125               *---------------------------------------------------------------
0126               * Keyboard scancodes - control keys extra
0127               *---------------------------------------------------------------
0128      009B     key.ctrl.dot    equ >9b             ; ctrl + .
0129      0080     key.ctrl.comma  equ >80             ; ctrl + ,
0130      009D     key.ctrl.plus   equ >9d             ; ctrl + +
0131      00BB     key.ctrl.slash  equ >bb             ; ctrl + /
0132      00F0     key.ctrl.space  equ >f0             ; ctrl + SPACE
0133               *---------------------------------------------------------------
0134               * Special keys
0135               *---------------------------------------------------------------
0136      000D     key.enter     equ >0d               ; enter
0137      0020     key.space     equ >20               ; space
                   < stevie_b0.asm.57700
0018               
0019               ***************************************************************
0020               * BANK 0
0021               ********|*****|*********************|**************************
0022      6000     bankid  equ   bank0.rom             ; Set bank identifier to current bank
0023                       aorg  >6000
0024                       save  >6000,>8000           ; Save bank
0025                       copy  "rom.header.asm"      ; Include cartridge header
     **** ****     > rom.header.asm
0001               * FILE......: rom.header.asm
0002               * Purpose...: Cartridge header
0003               
0004               *--------------------------------------------------------------
0005               * Cartridge header
0006               ********|*****|*********************|**************************
0007 6000 AA               byte  >aa                   ; 0  Standard header                   >6000
0008 6001   01             byte  >01                   ; 1  Version number
0009 6002 01               byte  >01                   ; 2  Number of programs (optional)     >6002
0010 6003   00             byte  0                     ; 3  Reserved ('R' = adv. mode FG99)
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
0044 6010 0B               byte  11
0045 6011   53             text  'STEVIE 1.2P'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3250     
0046                       even
0047               
0049               
                   < stevie_b0.asm.57700
0026               
0027               ***************************************************************
0028               * Step 1: Switch to bank 0 (uniform code accross all banks)
0029               ********|*****|*********************|**************************
0030                       aorg  kickstart.code1       ; >6040
0031 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000     
0032               ***************************************************************
0033               * Step 2: Setup SAMS banks (inline code because no SP2 yet!)
0034               ********|*****|*********************|**************************
0035 6044 020C  20         li    r12,>1e00             ; SAMS CRU address
     6046 1E00     
0036 6048 1E01  20         sbz   1                     ; Disable SAMS mapper
0037 604A 1D00  20         sbo   0                     ; Enable access to SAMS registers
0038 604C 04C0  14         clr   r0                    ; \ Page 0 in >2000 - >2fff
0039 604E D800  38         movb  r0,@>4004             ; /
     6050 4004     
0040               
0041 6052 0200  20         li    r0,>0100              ; \ Page 1 in >3000 - >3fff
     6054 0100     
0042 6056 D800  38         movb  r0,@>4006             ; /
     6058 4006     
0043               
0044 605A 0200  20         li    r0,>0400              ; \ Page 4 in >a000 - >afff
     605C 0400     
0045 605E D800  38         movb  r0,@>4014             ; /
     6060 4014     
0046               
0047 6062 0200  20         li    r0,>2000              ; \ Page 20 in >b000 - >bfff
     6064 2000     
0048 6066 D800  38         movb  r0,@>4016             ; /
     6068 4016     
0049               
0050 606A 0200  20         li    r0,>4000              ; \ Page 40 in >c000 - >bfff
     606C 4000     
0051 606E D800  38         movb  r0,@>4018             ; /
     6070 4018     
0052               
0053 6072 0200  20         li    r0,>0500              ; \ Page 5 in >d000 - >dfff
     6074 0500     
0054 6076 D800  38         movb  r0,@>401a             ; /
     6078 401A     
0055               
0056 607A 0200  20         li    r0,>0600              ; \ Page 6 in >ec000 - >efff
     607C 0600     
0057 607E D800  38         movb  r0,@>401c             ; /
     6080 401C     
0058               
0059 6082 0200  20         li    r0,>0700              ; \ Page 7 in >f000 - >ffff
     6084 0700     
0060 6086 D800  38         movb  r0,@>401e             ; /
     6088 401E     
0061               
0062 608A 1E00  20         sbz   0                     ; Disable access to SAMS registers
0063 608C 1D01  20         sbo   1                     ; Enable SAMS mapper
0064               
0065               ***************************************************************
0066               * Step 3: Copy resident modules from ROM to RAM >2000 - >3fff
0067               ********|*****|*********************|**************************
0068 608E 0200  20         li    r0,reloc.resident     ; Start of code to relocate
     6090 60BE     
0069 6092 0201  20         li    r1,>2000
     6094 2000     
0070 6096 0202  20         li    r2,512                ; Copy 8K (512 * 16 bytes)
     6098 0200     
0071                       ;------------------------------------------------------
0072                       ; Copy memory to destination
0073                       ; r0 = Source CPU address
0074                       ; r1 = Target CPU address
0075                       ; r2 = Bytes to copy/16
0076                       ;------------------------------------------------------
0077 609A CC70  46 !       mov   *r0+,*r1+             ; Copy word 1
0078 609C CC70  46         mov   *r0+,*r1+             ; Copy word 2
0079 609E CC70  46         mov   *r0+,*r1+             ; Copy word 3
0080 60A0 CC70  46         mov   *r0+,*r1+             ; Copy word 4
0081 60A2 CC70  46         mov   *r0+,*r1+             ; Copy word 5
0082 60A4 CC70  46         mov   *r0+,*r1+             ; Copy word 6
0083 60A6 CC70  46         mov   *r0+,*r1+             ; Copy word 7
0084 60A8 CC70  46         mov   *r0+,*r1+             ; Copy word 8
0085 60AA 0602  14         dec   r2
0086 60AC 16F6  14         jne   -!                    ; Loop until done
0087               ***************************************************************
0088               * Step 4: Start SP2 kernel (runs in low MEMEXP)
0089               ********|*****|*********************|**************************
0090 60AE 0460  28         b     @runlib               ; Start spectra2 library
     60B0 2EDC     
0091                                                   ; "main" in low MEMEXP is automatically
0092                                                   ; called by SP2 runlib.
0093                       ;------------------------------------------------------
0094                       ; Assert. Should not get here!
0095                       ;------------------------------------------------------
0096 60B2 0200  20         li    r0,$                  ; Current location
     60B4 60B2     
0097 60B6 C800  38         mov   r0,@>ffce             ; \ Save caller address
     60B8 FFCE     
0098 60BA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     60BC 2026     
0099               
0100               ***************************************************************
0101               * Code data: Relocated code
0102               ********|*****|*********************|**************************
0103               reloc.resident:
0104                       ;------------------------------------------------------
0105                       ; Resident libraries
0106                       ;------------------------------------------------------
0107                       xorg  >2000                 ; Relocate to >2000
0108                       copy  "runlib.asm"
     **** ****     > runlib.asm
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
0011               *                      2010-2022 by Filip Van Vooren
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
0027               * skip_sams                 equ  1  ; Skip support for SAMS memory expansion
0028               * skip_sams_layout          equ  1  ; Skip SAMS memory layout routine
0029               *
0030               * == VDP
0031               * skip_textmode             equ  1  ; Skip 40x24 textmode support
0032               * skip_vdp_f18a             equ  1  ; Skip f18a support
0033               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0034               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0035               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0036               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0037               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0038               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0039               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0040               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0041               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0042               * skip_vdp_sprites          equ  1  ; Skip sprites support
0043               * skip_vdp_cursor           equ  1  ; Skip cursor support
0044               *
0045               * == Sound & speech
0046               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0047               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0048               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0049               *
0050               * == Keyboard
0051               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0052               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0053               * use_rom0_kscan            equ  1  ; Use KSCAN in console ROM#0
0054               *
0055               * == Utilities
0056               * skip_random_generator     equ  1  ; Skip random generator functions
0057               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0058               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0059               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0060               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0061               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0062               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0063               * skip_cpu_strings          equ  1  ; Skip string support utilities
0064               
0065               * == Kernel/Multitasking
0066               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0067               * skip_mem_paging           equ  1  ; Skip support for memory paging
0068               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0069               *
0070               * == Startup behaviour
0071               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300->83ff
0072               *                                   ; to pre-defined backup address
0073               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0074               *******************************************************************************
0075               
0076               *//////////////////////////////////////////////////////////////
0077               *                       RUNLIB SETUP
0078               *//////////////////////////////////////////////////////////////
0079               
0080                       copy  "memsetup.equ"             ; Equates runlib scratchpad mem setup
     **** ****     > memsetup.equ
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
                   < runlib.asm
0081                       copy  "registers.equ"            ; Equates runlib registers
     **** ****     > registers.equ
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
                   < runlib.asm
0082                       copy  "portaddr.equ"             ; Equates runlib hw port addresses
     **** ****     > portaddr.equ
0001               * FILE......: portaddr.equ
0002               * Purpose...: Equates for hardware port addresses and vectors
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
0018               
0019      000E     kscan   equ   >000e                 ; Address of KSCAN routine in console ROM 0
                   < runlib.asm
0083                       copy  "param.equ"                ; Equates runlib parameters
     **** ****     > param.equ
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
                   < runlib.asm
0084               
0088               
0089                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
     **** ****     > cpu_constants.asm
0001               * FILE......: cpu_constants.asm
0002               * Purpose...: Constants used by Spectra2 and for own use
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********|*****|*********************|**************************
0007               
0008               *--------------------------------------------------------------
0009               * Word values
0010               *--------------------------------------------------------------
0011               ;                                   ;       0123456789ABCDEF
0012 60BE 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 60C0 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 60C2 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 60C4 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 60C6 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 60C8 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 60CA 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 60CC 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 60CE 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 60D0 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 60D2 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 60D4 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 60D6 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 60D8 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 60DA 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 60DC 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 60DE 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 60E0 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 60E2 D000     w$d000  data  >d000                 ; >d000
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
                   < runlib.asm
0090                       copy  "config.equ"               ; Equates for bits in config register
     **** ****     > config.equ
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
                   < runlib.asm
0091                       copy  "cpu_crash.asm"            ; CPU crash handler
     **** ****     > cpu_crash.asm
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
0038 60E4 022B  22         ai    r11,-4                ; Remove opcode offset
     60E6 FFFC     
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 60E8 C800  38         mov   r0,@>ffe0
     60EA FFE0     
0043 60EC C801  38         mov   r1,@>ffe2
     60EE FFE2     
0044 60F0 C802  38         mov   r2,@>ffe4
     60F2 FFE4     
0045 60F4 C803  38         mov   r3,@>ffe6
     60F6 FFE6     
0046 60F8 C804  38         mov   r4,@>ffe8
     60FA FFE8     
0047 60FC C805  38         mov   r5,@>ffea
     60FE FFEA     
0048 6100 C806  38         mov   r6,@>ffec
     6102 FFEC     
0049 6104 C807  38         mov   r7,@>ffee
     6106 FFEE     
0050 6108 C808  38         mov   r8,@>fff0
     610A FFF0     
0051 610C C809  38         mov   r9,@>fff2
     610E FFF2     
0052 6110 C80A  38         mov   r10,@>fff4
     6112 FFF4     
0053 6114 C80B  38         mov   r11,@>fff6
     6116 FFF6     
0054 6118 C80C  38         mov   r12,@>fff8
     611A FFF8     
0055 611C C80D  38         mov   r13,@>fffa
     611E FFFA     
0056 6120 C80E  38         mov   r14,@>fffc
     6122 FFFC     
0057 6124 C80F  38         mov   r15,@>ffff
     6126 FFFF     
0058 6128 02A0  12         stwp  r0
0059 612A C800  38         mov   r0,@>ffdc
     612C FFDC     
0060 612E 02C0  12         stst  r0
0061 6130 C800  38         mov   r0,@>ffde
     6132 FFDE     
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 6134 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6136 8300     
0067 6138 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     613A 8302     
0068 613C 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     613E 4A4A     
0069 6140 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     6142 2EE0     
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 6144 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6146 230C     
0078 6148 2206                   data graph1           ; \ i  p0 = pointer to video mode table
0079                                                   ; /
0080               
0081 614A 06A0  32         bl    @ldfnt
     614C 2374     
0082 614E 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     6150 000C     
0083               
0084 6152 06A0  32         bl    @filv
     6154 22A2     
0085 6156 0000                   data >0000,32,32*24   ; Clear screen
     6158 0020     
     615A 0300     
0086               
0087 615C 06A0  32         bl    @filv
     615E 22A2     
0088 6160 0380                   data >0380,>f0,32*24  ; Load color table
     6162 00F0     
     6164 0300     
0089                       ;------------------------------------------------------
0090                       ; Show crash address
0091                       ;------------------------------------------------------
0092 6166 06A0  32         bl    @putat                ; Show crash message
     6168 2456     
0093 616A 0000                   data >0000,cpu.crash.msg.crashed
     616C 2192     
0094               
0095 616E 06A0  32         bl    @puthex               ; Put hex value on screen
     6170 29AC     
0096 6172 0015                   byte 0,21             ; \ i  p0 = YX position
0097 6174 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0098 6176 A100                   data rambuf           ; | i  p2 = Pointer to ram buffer
0099 6178 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0100                                                   ; /         LSB offset for ASCII digit 0-9
0101                       ;------------------------------------------------------
0102                       ; Show caller address
0103                       ;------------------------------------------------------
0104 617A 06A0  32         bl    @putat                ; Show caller message
     617C 2456     
0105 617E 0100                   data >0100,cpu.crash.msg.caller
     6180 21A8     
0106               
0107 6182 06A0  32         bl    @puthex               ; Put hex value on screen
     6184 29AC     
0108 6186 0115                   byte 1,21             ; \ i  p0 = YX position
0109 6188 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0110 618A A100                   data rambuf           ; | i  p2 = Pointer to ram buffer
0111 618C 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0112                                                   ; /         LSB offset for ASCII digit 0-9
0113                       ;------------------------------------------------------
0114                       ; Display labels
0115                       ;------------------------------------------------------
0116 618E 06A0  32         bl    @putat
     6190 2456     
0117 6192 0300                   byte 3,0
0118 6194 21C4                   data cpu.crash.msg.wp
0119 6196 06A0  32         bl    @putat
     6198 2456     
0120 619A 0400                   byte 4,0
0121 619C 21CA                   data cpu.crash.msg.st
0122 619E 06A0  32         bl    @putat
     61A0 2456     
0123 61A2 1600                   byte 22,0
0124 61A4 21D0                   data cpu.crash.msg.source
0125 61A6 06A0  32         bl    @putat
     61A8 2456     
0126 61AA 1700                   byte 23,0
0127 61AC 21EC                   data cpu.crash.msg.id
0128                       ;------------------------------------------------------
0129                       ; Show crash registers WP, ST, R0 - R15
0130                       ;------------------------------------------------------
0131 61AE 06A0  32         bl    @at                   ; Put cursor at YX
     61B0 26DA     
0132 61B2 0304                   byte 3,4              ; \ i p0 = YX position
0133                                                   ; /
0134               
0135 61B4 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     61B6 FFDC     
0136 61B8 04C6  14         clr   tmp2                  ; Loop counter
0137               
0138               cpu.crash.showreg:
0139 61BA C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0140               
0141 61BC 0649  14         dect  stack
0142 61BE C644  30         mov   tmp0,*stack           ; Push tmp0
0143 61C0 0649  14         dect  stack
0144 61C2 C645  30         mov   tmp1,*stack           ; Push tmp1
0145 61C4 0649  14         dect  stack
0146 61C6 C646  30         mov   tmp2,*stack           ; Push tmp2
0147                       ;------------------------------------------------------
0148                       ; Display crash register number
0149                       ;------------------------------------------------------
0150               cpu.crash.showreg.label:
0151 61C8 C046  18         mov   tmp2,r1               ; Save register number
0152 61CA 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     61CC 0001     
0153 61CE 1220  14         jle   cpu.crash.showreg.content
0154                                                   ; Yes, skip
0155               
0156 61D0 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0157 61D2 06A0  32         bl    @mknum
     61D4 29B6     
0158 61D6 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0159 61D8 A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0160 61DA 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0161                                                   ; /         LSB offset for ASCII digit 0-9
0162               
0163 61DC 06A0  32         bl    @setx                 ; Set cursor X position
     61DE 26F0     
0164 61E0 0000                   data 0                ; \ i  p0 =  Cursor Y position
0165                                                   ; /
0166               
0167 61E2 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     61E4 0400     
0168 61E6 D804  38         movb  tmp0,@rambuf          ;
     61E8 A100     
0169               
0170 61EA 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61EC 2432     
0171 61EE A100                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0172                                                   ; /
0173               
0174 61F0 06A0  32         bl    @setx                 ; Set cursor X position
     61F2 26F0     
0175 61F4 0002                   data 2                ; \ i  p0 =  Cursor Y position
0176                                                   ; /
0177               
0178 61F6 0281  22         ci    r1,10
     61F8 000A     
0179 61FA 1102  14         jlt   !
0180 61FC 0620  34         dec   @wyx                  ; x=x-1
     61FE 832A     
0181               
0182 6200 06A0  32 !       bl    @putstr
     6202 2432     
0183 6204 21BE                   data cpu.crash.msg.r
0184               
0185 6206 06A0  32         bl    @mknum
     6208 29B6     
0186 620A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0187 620C A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0188 620E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0189                                                   ; /         LSB offset for ASCII digit 0-9
0190                       ;------------------------------------------------------
0191                       ; Display crash register content
0192                       ;------------------------------------------------------
0193               cpu.crash.showreg.content:
0194 6210 06A0  32         bl    @mkhex                ; Convert hex word to string
     6212 2928     
0195 6214 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0196 6216 A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0197 6218 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0198                                                   ; /         LSB offset for ASCII digit 0-9
0199               
0200 621A 06A0  32         bl    @setx                 ; Set cursor X position
     621C 26F0     
0201 621E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 6220 06A0  32         bl    @putstr               ; Put '  >'
     6222 2432     
0205 6224 21C0                   data cpu.crash.msg.marker
0206               
0207 6226 06A0  32         bl    @setx                 ; Set cursor X position
     6228 26F0     
0208 622A 0007                   data 7                ; \ i  p0 =  Cursor Y position
0209                                                   ; /
0210               
0211 622C 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     622E 0400     
0212 6230 D804  38         movb  tmp0,@rambuf          ;
     6232 A100     
0213               
0214 6234 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6236 2432     
0215 6238 A100                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0216                                                   ; /
0217               
0218 623A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0219 623C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0220 623E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0221               
0222 6240 06A0  32         bl    @down                 ; y=y+1
     6242 26E0     
0223               
0224 6244 0586  14         inc   tmp2
0225 6246 0286  22         ci    tmp2,17
     6248 0011     
0226 624A 12B7  14         jle   cpu.crash.showreg     ; Show next register
0227                       ;------------------------------------------------------
0228                       ; Kernel takes over
0229                       ;------------------------------------------------------
0230 624C 0460  28         b     @cpu.crash.showbank   ; Expected to be included in
     624E 7FB0     
0231               
0232               
0233               cpu.crash.msg.crashed
0234 6250 15               byte  21
0235 6251   53             text  'System crashed near >'
     6252 7973     
     6254 7465     
     6256 6D20     
     6258 6372     
     625A 6173     
     625C 6865     
     625E 6420     
     6260 6E65     
     6262 6172     
     6264 203E     
0236                       even
0237               
0238               cpu.crash.msg.caller
0239 6266 15               byte  21
0240 6267   43             text  'Caller address near >'
     6268 616C     
     626A 6C65     
     626C 7220     
     626E 6164     
     6270 6472     
     6272 6573     
     6274 7320     
     6276 6E65     
     6278 6172     
     627A 203E     
0241                       even
0242               
0243               cpu.crash.msg.r
0244 627C 01               byte  1
0245 627D   52             text  'R'
0246                       even
0247               
0248               cpu.crash.msg.marker
0249 627E 03               byte  3
0250 627F   20             text  '  >'
     6280 203E     
0251                       even
0252               
0253               cpu.crash.msg.wp
0254 6282 04               byte  4
0255 6283   2A             text  '**WP'
     6284 2A57     
     6286 50       
0256                       even
0257               
0258               cpu.crash.msg.st
0259 6288 04               byte  4
0260 6289   2A             text  '**ST'
     628A 2A53     
     628C 54       
0261                       even
0262               
0263               cpu.crash.msg.source
0264 628E 1B               byte  27
0265 628F   53             text  'Source    stevie_b0.lst.asm'
     6290 6F75     
     6292 7263     
     6294 6520     
     6296 2020     
     6298 2073     
     629A 7465     
     629C 7669     
     629E 655F     
     62A0 6230     
     62A2 2E6C     
     62A4 7374     
     62A6 2E61     
     62A8 736D     
0266                       even
0267               
0268               cpu.crash.msg.id
0269 62AA 18               byte  24
0270 62AB   42             text  'Build-ID  220116-1948400'
     62AC 7569     
     62AE 6C64     
     62B0 2D49     
     62B2 4420     
     62B4 2032     
     62B6 3230     
     62B8 3131     
     62BA 362D     
     62BC 3139     
     62BE 3438     
     62C0 3430     
     62C2 30       
0271                       even
0272               
                   < runlib.asm
0092                       copy  "vdp_tables.asm"           ; Data used by runtime library
     **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 62C4 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     62C6 000E     
     62C8 0106     
     62CA 0204     
     62CC 0020     
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
0032 62CE 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     62D0 000E     
     62D2 0106     
     62D4 00F4     
     62D6 0028     
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
0058 62D8 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     62DA 003F     
     62DC 0240     
     62DE 03F4     
     62E0 0050     
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
                   < runlib.asm
0093                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
     **** ****     > basic_cpu_vdp.asm
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
0013 62E2 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 62E4 16FD             data  >16fd                 ; |         jne   mcloop
0015 62E6 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 62E8 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 62EA 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 62EC 0201  20         li    r1,mccode             ; Machinecode to patch
     62EE 2224     
0037 62F0 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     62F2 8322     
0038 62F4 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 62F6 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 62F8 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 62FA 045B  20         b     *r11                  ; Return to caller
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
0056 62FC C0F9  30 popr3   mov   *stack+,r3
0057 62FE C0B9  30 popr2   mov   *stack+,r2
0058 6300 C079  30 popr1   mov   *stack+,r1
0059 6302 C039  30 popr0   mov   *stack+,r0
0060 6304 C2F9  30 poprt   mov   *stack+,r11
0061 6306 045B  20         b     *r11
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
0085 6308 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 630A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 630C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 630E C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 6310 1604  14         jne   filchk                ; No, continue checking
0093               
0094 6312 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6314 FFCE     
0095 6316 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6318 2026     
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 631A D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     631C 830B     
     631E 830A     
0100               
0101 6320 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     6322 0001     
0102 6324 1602  14         jne   filchk2
0103 6326 DD05  32         movb  tmp1,*tmp0+
0104 6328 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 632A 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     632C 0002     
0109 632E 1603  14         jne   filchk3
0110 6330 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 6332 DD05  32         movb  tmp1,*tmp0+
0112 6334 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 6336 C1C4  18 filchk3 mov   tmp0,tmp3
0117 6338 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     633A 0001     
0118 633C 1305  14         jeq   fil16b
0119 633E DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 6340 0606  14         dec   tmp2
0121 6342 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     6344 0002     
0122 6346 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 6348 C1C6  18 fil16b  mov   tmp2,tmp3
0127 634A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     634C 0001     
0128 634E 1301  14         jeq   dofill
0129 6350 0606  14         dec   tmp2                  ; Make TMP2 even
0130 6352 CD05  34 dofill  mov   tmp1,*tmp0+
0131 6354 0646  14         dect  tmp2
0132 6356 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 6358 C1C7  18         mov   tmp3,tmp3
0137 635A 1301  14         jeq   fil.exit
0138 635C DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 635E 045B  20         b     *r11
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
0159 6360 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 6362 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 6364 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 6366 0264  22 xfilv   ori   tmp0,>4000
     6368 4000     
0166 636A 06C4  14         swpb  tmp0
0167 636C D804  38         movb  tmp0,@vdpa
     636E 8C02     
0168 6370 06C4  14         swpb  tmp0
0169 6372 D804  38         movb  tmp0,@vdpa
     6374 8C02     
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 6376 020F  20         li    r15,vdpw              ; Set VDP write address
     6378 8C00     
0174 637A 06C5  14         swpb  tmp1
0175 637C C820  54         mov   @filzz,@mcloop        ; Setup move command
     637E 22C8     
     6380 8320     
0176 6382 0460  28         b     @mcloop               ; Write data to VDP
     6384 8320     
0177               *--------------------------------------------------------------
0181 6386 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 6388 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     638A 4000     
0202 638C 06C4  14 vdra    swpb  tmp0
0203 638E D804  38         movb  tmp0,@vdpa
     6390 8C02     
0204 6392 06C4  14         swpb  tmp0
0205 6394 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6396 8C02     
0206 6398 045B  20         b     *r11                  ; Exit
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
0217 639A C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 639C C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 639E 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     63A0 4000     
0223 63A2 06C4  14         swpb  tmp0                  ; \
0224 63A4 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     63A6 8C02     
0225 63A8 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 63AA D804  38         movb  tmp0,@vdpa            ; /
     63AC 8C02     
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 63AE 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 63B0 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 63B2 045B  20         b     *r11                  ; Exit
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
0251 63B4 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 63B6 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 63B8 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     63BA 8C02     
0257 63BC 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 63BE D804  38         movb  tmp0,@vdpa            ; /
     63C0 8C02     
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 63C2 D120  34         movb  @vdpr,tmp0            ; Read byte
     63C4 8800     
0263 63C6 0984  56         srl   tmp0,8                ; Right align
0264 63C8 045B  20         b     *r11                  ; Exit
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
0283 63CA C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 63CC C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 63CE C144  18         mov   tmp0,tmp1
0289 63D0 05C5  14         inct  tmp1
0290 63D2 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 63D4 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     63D6 FF00     
0292 63D8 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 63DA C805  38         mov   tmp1,@wbase           ; Store calculated base
     63DC 8328     
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 63DE 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     63E0 8000     
0298 63E2 0206  20         li    tmp2,8
     63E4 0008     
0299 63E6 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     63E8 830B     
0300 63EA 06C5  14         swpb  tmp1
0301 63EC D805  38         movb  tmp1,@vdpa
     63EE 8C02     
0302 63F0 06C5  14         swpb  tmp1
0303 63F2 D805  38         movb  tmp1,@vdpa
     63F4 8C02     
0304 63F6 0225  22         ai    tmp1,>0100
     63F8 0100     
0305 63FA 0606  14         dec   tmp2
0306 63FC 16F4  14         jne   vidta1                ; Next register
0307 63FE C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6400 833A     
0308 6402 045B  20         b     *r11
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
0325 6404 C13B  30 putvr   mov   *r11+,tmp0
0326 6406 0264  22 putvrx  ori   tmp0,>8000
     6408 8000     
0327 640A 06C4  14         swpb  tmp0
0328 640C D804  38         movb  tmp0,@vdpa
     640E 8C02     
0329 6410 06C4  14         swpb  tmp0
0330 6412 D804  38         movb  tmp0,@vdpa
     6414 8C02     
0331 6416 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 6418 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 641A C10E  18         mov   r14,tmp0
0341 641C 0984  56         srl   tmp0,8
0342 641E 06A0  32         bl    @putvrx               ; Write VR#0
     6420 2348     
0343 6422 0204  20         li    tmp0,>0100
     6424 0100     
0344 6426 D820  54         movb  @r14lb,@tmp0lb
     6428 831D     
     642A 8309     
0345 642C 06A0  32         bl    @putvrx               ; Write VR#1
     642E 2348     
0346 6430 0458  20         b     *tmp4                 ; Exit
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
0360 6432 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 6434 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 6436 C11B  26         mov   *r11,tmp0             ; Get P0
0363 6438 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     643A 7FFF     
0364 643C 2120  38         coc   @wbit0,tmp0
     643E 2020     
0365 6440 1604  14         jne   ldfnt1
0366 6442 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6444 8000     
0367 6446 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6448 7FFF     
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 644A C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     644C 23F6     
0372 644E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6450 9C02     
0373 6452 06C4  14         swpb  tmp0
0374 6454 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6456 9C02     
0375 6458 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     645A 9800     
0376 645C 06C5  14         swpb  tmp1
0377 645E D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     6460 9800     
0378 6462 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 6464 D805  38         movb  tmp1,@grmwa
     6466 9C02     
0383 6468 06C5  14         swpb  tmp1
0384 646A D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     646C 9C02     
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 646E C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 6470 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     6472 22CA     
0390 6474 05C8  14         inct  tmp4                  ; R11=R11+2
0391 6476 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 6478 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     647A 7FFF     
0393 647C C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     647E 23F8     
0394 6480 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     6482 23FA     
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 6484 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 6486 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 6488 D120  34         movb  @grmrd,tmp0
     648A 9800     
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 648C 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     648E 2020     
0405 6490 1603  14         jne   ldfnt3                ; No, so skip
0406 6492 D1C4  18         movb  tmp0,tmp3
0407 6494 0917  56         srl   tmp3,1
0408 6496 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 6498 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     649A 8C00     
0413 649C 0606  14         dec   tmp2
0414 649E 16F2  14         jne   ldfnt2
0415 64A0 05C8  14         inct  tmp4                  ; R11=R11+2
0416 64A2 020F  20         li    r15,vdpw              ; Set VDP write address
     64A4 8C00     
0417 64A6 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     64A8 7FFF     
0418 64AA 0458  20         b     *tmp4                 ; Exit
0419 64AC D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     64AE 2000     
     64B0 8C00     
0420 64B2 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 64B4 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     64B6 0200     
     64B8 0000     
0425 64BA 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     64BC 01C0     
     64BE 0101     
0426 64C0 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     64C2 02A0     
     64C4 0101     
0427 64C6 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     64C8 00E0     
     64CA 0101     
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
0445 64CC C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 64CE C3A0  34         mov   @wyx,r14              ; Get YX
     64D0 832A     
0447 64D2 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 64D4 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     64D6 833A     
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 64D8 C3A0  34         mov   @wyx,r14              ; Get YX
     64DA 832A     
0454 64DC 024E  22         andi  r14,>00ff             ; Remove Y
     64DE 00FF     
0455 64E0 A3CE  18         a     r14,r15               ; pos = pos + X
0456 64E2 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     64E4 8328     
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 64E6 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 64E8 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 64EA 020F  20         li    r15,vdpw              ; VDP write address
     64EC 8C00     
0463 64EE 045B  20         b     *r11
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
0481 64F0 C17B  30 putstr  mov   *r11+,tmp1
0482 64F2 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 64F4 C1CB  18 xutstr  mov   r11,tmp3
0484 64F6 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     64F8 240E     
0485 64FA C2C7  18         mov   tmp3,r11
0486 64FC 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 64FE C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 6500 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 6502 0286  22         ci    tmp2,255              ; Length > 255 ?
     6504 00FF     
0494 6506 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 6508 0460  28         b     @xpym2v               ; Display string
     650A 24A0     
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 650C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     650E FFCE     
0501 6510 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6512 2026     
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
0517 6514 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6516 832A     
0518 6518 0460  28         b     @putstr
     651A 2432     
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
0539 651C 0649  14         dect  stack
0540 651E C64B  30         mov   r11,*stack            ; Save return address
0541 6520 0649  14         dect  stack
0542 6522 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 6524 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 6526 0987  56         srl   tmp3,8                ; Right align
0549               
0550 6528 0649  14         dect  stack
0551 652A C645  30         mov   tmp1,*stack           ; Push tmp1
0552 652C 0649  14         dect  stack
0553 652E C646  30         mov   tmp2,*stack           ; Push tmp2
0554 6530 0649  14         dect  stack
0555 6532 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 6534 06A0  32         bl    @xutst0               ; Display string
     6536 2434     
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 6538 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 653A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 653C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 653E 06A0  32         bl    @down                 ; Move cursor down
     6540 26E0     
0566               
0567 6542 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 6544 0585  14         inc   tmp1                  ; Consider length byte
0569 6546 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     6548 2002     
0570 654A 1301  14         jeq   !                     ; Yes, skip adjustment
0571 654C 0585  14         inc   tmp1                  ; Make address even
0572 654E 0606  14 !       dec   tmp2
0573 6550 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 6552 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 6554 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 6556 045B  20         b     *r11                  ; Return
                   < runlib.asm
0094               
0096                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
     **** ****     > copy_cpu_vram.asm
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
0020 6558 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 655A C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 655C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 655E C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 6560 1604  14         jne   !                     ; No, continue
0028               
0029 6562 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6564 FFCE     
0030 6566 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6568 2026     
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 656A 0264  22 !       ori   tmp0,>4000
     656C 4000     
0035 656E 06C4  14         swpb  tmp0
0036 6570 D804  38         movb  tmp0,@vdpa
     6572 8C02     
0037 6574 06C4  14         swpb  tmp0
0038 6576 D804  38         movb  tmp0,@vdpa
     6578 8C02     
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 657A 020F  20         li    r15,vdpw              ; Set VDP write address
     657C 8C00     
0043 657E C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6580 24CA     
     6582 8320     
0044 6584 0460  28         b     @mcloop               ; Write data to VDP and return
     6586 8320     
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 6588 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
                   < runlib.asm
0098               
0100                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
     **** ****     > copy_vram_cpu.asm
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
0020 658A C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 658C C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 658E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6590 06C4  14 xpyv2m  swpb  tmp0
0027 6592 D804  38         movb  tmp0,@vdpa
     6594 8C02     
0028 6596 06C4  14         swpb  tmp0
0029 6598 D804  38         movb  tmp0,@vdpa
     659A 8C02     
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 659C 020F  20         li    r15,vdpr              ; Set VDP read address
     659E 8800     
0034 65A0 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     65A2 24EC     
     65A4 8320     
0035 65A6 0460  28         b     @mcloop               ; Read data from VDP
     65A8 8320     
0036 65AA DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
                   < runlib.asm
0102               
0104                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
     **** ****     > copy_cpu_cpu.asm
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
0024 65AC C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 65AE C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 65B0 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 65B2 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 65B4 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 65B6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     65B8 FFCE     
0034 65BA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     65BC 2026     
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 65BE 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     65C0 0001     
0039 65C2 1603  14         jne   cpym0                 ; No, continue checking
0040 65C4 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 65C6 04C6  14         clr   tmp2                  ; Reset counter
0042 65C8 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 65CA 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     65CC 7FFF     
0047 65CE C1C4  18         mov   tmp0,tmp3
0048 65D0 0247  22         andi  tmp3,1
     65D2 0001     
0049 65D4 1618  14         jne   cpyodd                ; Odd source address handling
0050 65D6 C1C5  18 cpym1   mov   tmp1,tmp3
0051 65D8 0247  22         andi  tmp3,1
     65DA 0001     
0052 65DC 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 65DE 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     65E0 2020     
0057 65E2 1605  14         jne   cpym3
0058 65E4 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     65E6 254E     
     65E8 8320     
0059 65EA 0460  28         b     @mcloop               ; Copy memory and exit
     65EC 8320     
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 65EE C1C6  18 cpym3   mov   tmp2,tmp3
0064 65F0 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     65F2 0001     
0065 65F4 1301  14         jeq   cpym4
0066 65F6 0606  14         dec   tmp2                  ; Make TMP2 even
0067 65F8 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 65FA 0646  14         dect  tmp2
0069 65FC 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 65FE C1C7  18         mov   tmp3,tmp3
0074 6600 1301  14         jeq   cpymz
0075 6602 D554  38         movb  *tmp0,*tmp1
0076 6604 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 6606 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     6608 8000     
0081 660A 10E9  14         jmp   cpym2
0082 660C DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
                   < runlib.asm
0106               
0110               
0114               
0116                       copy  "cpu_sams.asm"             ; Support for SAMS memory card
     **** ****     > cpu_sams.asm
0001               * FILE......: cpu_sams.asm
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
0062 660E C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 6610 0649  14         dect  stack
0065 6612 C64B  30         mov   r11,*stack            ; Push return address
0066 6614 0649  14         dect  stack
0067 6616 C640  30         mov   r0,*stack             ; Push r0
0068 6618 0649  14         dect  stack
0069 661A C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 661C 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 661E 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 6620 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     6622 4000     
0077 6624 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     6626 833E     
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 6628 020C  20         li    r12,>1e00             ; SAMS CRU address
     662A 1E00     
0082 662C 04C0  14         clr   r0
0083 662E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 6630 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 6632 D100  18         movb  r0,tmp0
0086 6634 0984  56         srl   tmp0,8                ; Right align
0087 6636 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     6638 833C     
0088 663A 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 663C C339  30         mov   *stack+,r12           ; Pop r12
0094 663E C039  30         mov   *stack+,r0            ; Pop r0
0095 6640 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 6642 045B  20         b     *r11                  ; Return to caller
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
0131 6644 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 6646 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 6648 0649  14         dect  stack
0135 664A C64B  30         mov   r11,*stack            ; Push return address
0136 664C 0649  14         dect  stack
0137 664E C640  30         mov   r0,*stack             ; Push r0
0138 6650 0649  14         dect  stack
0139 6652 C64C  30         mov   r12,*stack            ; Push r12
0140 6654 0649  14         dect  stack
0141 6656 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 6658 0649  14         dect  stack
0143 665A C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 665C 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 665E 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 6660 0284  22         ci    tmp0,255              ; Crash if page > 255
     6662 00FF     
0153 6664 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 6666 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     6668 001E     
0158 666A 150A  14         jgt   !
0159 666C 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     666E 0004     
0160 6670 1107  14         jlt   !
0161 6672 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     6674 0012     
0162 6676 1508  14         jgt   sams.page.set.switch_page
0163 6678 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     667A 0006     
0164 667C 1501  14         jgt   !
0165 667E 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 6680 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6682 FFCE     
0170 6684 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6686 2026     
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 6688 020C  20         li    r12,>1e00             ; SAMS CRU address
     668A 1E00     
0176 668C C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 668E 06C0  14         swpb  r0                    ; LSB to MSB
0178 6690 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 6692 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     6694 4000     
0180 6696 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 6698 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 669A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 669C C339  30         mov   *stack+,r12           ; Pop r12
0188 669E C039  30         mov   *stack+,r0            ; Pop r0
0189 66A0 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 66A2 045B  20         b     *r11                  ; Return to caller
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
0204 66A4 0649  14         dect  stack
0205 66A6 C64C  30         mov   r12,*stack            ; Push r12
0206 66A8 020C  20         li    r12,>1e00             ; SAMS CRU address
     66AA 1E00     
0207 66AC 1D01  20         sbo   1                     ; Enable SAMS mapper
0208               *--------------------------------------------------------------
0209               * Exit
0210               *--------------------------------------------------------------
0211               sams.mapping.on.exit:
0212 66AE C339  30         mov   *stack+,r12           ; Pop r12
0213 66B0 045B  20         b     *r11                  ; Return to caller
0214               
0215               
0216               
0217               
0218               ***************************************************************
0219               * sams.mapping.off - Disable SAMS mapping mode
0220               ***************************************************************
0221               * bl  @sams.mapping.off
0222               *--------------------------------------------------------------
0223               * OUTPUT
0224               * none
0225               *--------------------------------------------------------------
0226               * Register usage
0227               * r12
0228               ********|*****|*********************|**************************
0229               sams.mapping.off:
0230 66B2 0649  14         dect  stack
0231 66B4 C64C  30         mov   r12,*stack            ; Push r12
0232 66B6 020C  20         li    r12,>1e00             ; SAMS CRU address
     66B8 1E00     
0233 66BA 1E01  20         sbz   1                     ; Disable SAMS mapper
0234               *--------------------------------------------------------------
0235               * Exit
0236               *--------------------------------------------------------------
0237               sams.mapping.off.exit:
0238 66BC C339  30         mov   *stack+,r12           ; Pop r12
0239 66BE 045B  20         b     *r11                  ; Return to caller
0240               
0241               
0242               
0243               
0244               
0245               ***************************************************************
0246               * sams.layout
0247               * Setup SAMS memory banks
0248               ***************************************************************
0249               * bl  @sams.layout
0250               *     data P0
0251               *--------------------------------------------------------------
0252               * INPUT
0253               * P0 = Pointer to SAMS page layout table
0254               *--------------------------------------------------------------
0255               * bl  @xsams.layout
0256               *
0257               * tmp0 = Pointer to SAMS page layout table
0258               *--------------------------------------------------------------
0259               * OUTPUT
0260               * none
0261               *--------------------------------------------------------------
0262               * Register usage
0263               * tmp0, r12
0264               ********|*****|*********************|**************************
0265               
0266               
0267               sams.layout:
0268 66C0 C13B  30         mov   *r11+,tmp0            ; Get P0
0269               xsams.layout:
0270 66C2 0649  14         dect  stack
0271 66C4 C64B  30         mov   r11,*stack            ; Save return address
0272 66C6 0649  14         dect  stack
0273 66C8 C644  30         mov   tmp0,*stack           ; Save tmp0
0274 66CA 0649  14         dect  stack
0275 66CC C64C  30         mov   r12,*stack            ; Save r12
0276                       ;------------------------------------------------------
0277                       ; Set SAMS registers
0278                       ;------------------------------------------------------
0279 66CE 020C  20         li    r12,>1e00             ; SAMS CRU address
     66D0 1E00     
0280 66D2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0281               
0282 66D4 C834  50         mov  *tmp0+,@>4004          ; Set page for >2000 - >2fff
     66D6 4004     
0283 66D8 C834  50         mov  *tmp0+,@>4006          ; Set page for >3000 - >3fff
     66DA 4006     
0284 66DC C834  50         mov  *tmp0+,@>4014          ; Set page for >a000 - >afff
     66DE 4014     
0285 66E0 C834  50         mov  *tmp0+,@>4016          ; Set page for >b000 - >bfff
     66E2 4016     
0286 66E4 C834  50         mov  *tmp0+,@>4018          ; Set page for >c000 - >cfff
     66E6 4018     
0287 66E8 C834  50         mov  *tmp0+,@>401a          ; Set page for >d000 - >dfff
     66EA 401A     
0288 66EC C834  50         mov  *tmp0+,@>401c          ; Set page for >e000 - >efff
     66EE 401C     
0289 66F0 C834  50         mov  *tmp0+,@>401e          ; Set page for >f000 - >ffff
     66F2 401E     
0290               
0291 66F4 1E00  20         sbz   0                     ; Disable access to SAMS registers
0292 66F6 1D01  20         sbo   1                     ; Enable SAMS mapper
0293                       ;------------------------------------------------------
0294                       ; Exit
0295                       ;------------------------------------------------------
0296               sams.layout.exit:
0297 66F8 C339  30         mov   *stack+,r12           ; Pop r12
0298 66FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0299 66FC C2F9  30         mov   *stack+,r11           ; Pop r11
0300 66FE 045B  20         b     *r11                  ; Return to caller
0301               ***************************************************************
0302               * SAMS standard page layout table
0303               *--------------------------------------------------------------
0304               sams.layout.standard:
0305 6700 0200             data  >0200                 ; >2000-2fff, SAMS page >02
0306 6702 0300             data  >0300                 ; >3000-3fff, SAMS page >03
0307 6704 0A00             data  >0a00                 ; >a000-afff, SAMS page >0a
0308 6706 0B00             data  >0b00                 ; >b000-bfff, SAMS page >0b
0309 6708 0C00             data  >0c00                 ; >c000-cfff, SAMS page >0c
0310 670A 0D00             data  >0d00                 ; >d000-dfff, SAMS page >0d
0311 670C 0E00             data  >0e00                 ; >e000-efff, SAMS page >0e
0312 670E 0F00             data  >0f00                 ; >f000-ffff, SAMS page >0f
0313               
0314               
0315               ***************************************************************
0316               * sams.layout.copy
0317               * Copy SAMS memory layout
0318               ***************************************************************
0319               * bl  @sams.layout.copy
0320               *     data P0
0321               *--------------------------------------------------------------
0322               * P0 = Pointer to 8 words RAM buffer for results
0323               *--------------------------------------------------------------
0324               * OUTPUT
0325               * RAM buffer will have the SAMS page number for each range
0326               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0327               *--------------------------------------------------------------
0328               * Register usage
0329               * tmp0, tmp1, tmp2, tmp3
0330               ***************************************************************
0331               sams.layout.copy:
0332 6710 C1FB  30         mov   *r11+,tmp3            ; Get P0
0333               
0334 6712 0649  14         dect  stack
0335 6714 C64B  30         mov   r11,*stack            ; Push return address
0336 6716 0649  14         dect  stack
0337 6718 C644  30         mov   tmp0,*stack           ; Push tmp0
0338 671A 0649  14         dect  stack
0339 671C C645  30         mov   tmp1,*stack           ; Push tmp1
0340 671E 0649  14         dect  stack
0341 6720 C646  30         mov   tmp2,*stack           ; Push tmp2
0342 6722 0649  14         dect  stack
0343 6724 C647  30         mov   tmp3,*stack           ; Push tmp3
0344                       ;------------------------------------------------------
0345                       ; Copy SAMS layout
0346                       ;------------------------------------------------------
0347 6726 0205  20         li    tmp1,sams.layout.copy.data
     6728 268A     
0348 672A 0206  20         li    tmp2,8                ; Set loop counter
     672C 0008     
0349                       ;------------------------------------------------------
0350                       ; Set SAMS memory pages
0351                       ;------------------------------------------------------
0352               sams.layout.copy.loop:
0353 672E C135  30         mov   *tmp1+,tmp0           ; Get memory address
0354 6730 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     6732 2552     
0355                                                   ; | i  tmp0   = Memory address
0356                                                   ; / o  @waux1 = SAMS page
0357               
0358 6734 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     6736 833C     
0359               
0360 6738 0606  14         dec   tmp2                  ; Next iteration
0361 673A 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0362                       ;------------------------------------------------------
0363                       ; Exit
0364                       ;------------------------------------------------------
0365               sams.layout.copy.exit:
0366 673C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0367 673E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0368 6740 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0369 6742 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0370 6744 C2F9  30         mov   *stack+,r11           ; Pop r11
0371 6746 045B  20         b     *r11                  ; Return to caller
0372               ***************************************************************
0373               * SAMS memory range table
0374               *--------------------------------------------------------------
0375               sams.layout.copy.data:
0376 6748 2000             data  >2000                 ; >2000-2fff
0377 674A 3000             data  >3000                 ; >3000-3fff
0378 674C A000             data  >a000                 ; >a000-afff
0379 674E B000             data  >b000                 ; >b000-bfff
0380 6750 C000             data  >c000                 ; >c000-cfff
0381 6752 D000             data  >d000                 ; >d000-dfff
0382 6754 E000             data  >e000                 ; >e000-efff
0383 6756 F000             data  >f000                 ; >f000-ffff
                   < runlib.asm
0118               
0122               
0124                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
     **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 6758 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     675A FFBF     
0010 675C 0460  28         b     @putv01
     675E 235A     
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 6760 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6762 0040     
0018 6764 0460  28         b     @putv01
     6766 235A     
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 6768 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     676A FFDF     
0026 676C 0460  28         b     @putv01
     676E 235A     
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 6770 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6772 0020     
0034 6774 0460  28         b     @putv01
     6776 235A     
                   < runlib.asm
0126               
0128                       copy  "vdp_sprites.asm"          ; VDP sprites
     **** ****     > vdp_sprites.asm
0001               ***************************************************************
0002               * FILE......: vdp_sprites.asm
0003               * Purpose...: Sprites support
0004               
0005               ***************************************************************
0006               * SMAG1X - Set sprite magnification 1x
0007               ***************************************************************
0008               *  BL @SMAG1X
0009               ********|*****|*********************|**************************
0010 6778 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     677A FFFE     
0011 677C 0460  28         b     @putv01
     677E 235A     
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6780 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6782 0001     
0019 6784 0460  28         b     @putv01
     6786 235A     
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6788 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     678A FFFD     
0027 678C 0460  28         b     @putv01
     678E 235A     
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6790 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6792 0002     
0035 6794 0460  28         b     @putv01
     6796 235A     
                   < runlib.asm
0130               
0132                       copy  "vdp_cursor.asm"           ; VDP cursor handling
     **** ****     > vdp_cursor.asm
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
0018 6798 C83B  50 at      mov   *r11+,@wyx
     679A 832A     
0019 679C 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 679E B820  54 down    ab    @hb$01,@wyx
     67A0 2012     
     67A2 832A     
0028 67A4 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 67A6 7820  54 up      sb    @hb$01,@wyx
     67A8 2012     
     67AA 832A     
0037 67AC 045B  20         b     *r11
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
0049 67AE C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 67B0 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     67B2 832A     
0051 67B4 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     67B6 832A     
0052 67B8 045B  20         b     *r11
                   < runlib.asm
0134               
0136                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
     **** ****     > vdp_yx2px_calc.asm
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
0021 67BA C120  34 yx2px   mov   @wyx,tmp0
     67BC 832A     
0022 67BE C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 67C0 06C4  14         swpb  tmp0                  ; Y<->X
0024 67C2 04C5  14         clr   tmp1                  ; Clear before copy
0025 67C4 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 67C6 20A0  38         coc   @wbit1,config         ; f18a present ?
     67C8 201E     
0030 67CA 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 67CC 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     67CE 833A     
     67D0 273C     
0032 67D2 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 67D4 0A15  56         sla   tmp1,1                ; X = X * 2
0035 67D6 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 67D8 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     67DA 0500     
0037 67DC 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 67DE D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 67E0 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 67E2 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 67E4 D105  18         movb  tmp1,tmp0
0051 67E6 06C4  14         swpb  tmp0                  ; X<->Y
0052 67E8 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     67EA 2020     
0053 67EC 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 67EE 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     67F0 2012     
0059 67F2 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     67F4 2024     
0060 67F6 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 67F8 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 67FA 0050            data   80
0067               
0068               
                   < runlib.asm
0138               
0142               
0146               
0148                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
     **** ****     > vdp_f18a.asm
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
0013 67FC C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 67FE 06A0  32         bl    @putvr                ; Write once
     6800 2346     
0015 6802 391C             data  >391c                 ; VR1/57, value 00011100
0016 6804 06A0  32         bl    @putvr                ; Write twice
     6806 2346     
0017 6808 391C             data  >391c                 ; VR1/57, value 00011100
0018 680A 06A0  32         bl    @putvr
     680C 2346     
0019 680E 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 6810 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 6812 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 6814 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     6816 2346     
0030 6818 3900             data  >3900
0031 681A 0458  20         b     *tmp4                 ; Exit
0032               
0033               
0034               ***************************************************************
0035               * f18idl - Put GPU in F18A VDP in idle mode (stop GPU program)
0036               ***************************************************************
0037               *  bl   @f18idl
0038               *--------------------------------------------------------------
0039               *  REMARKS
0040               *  Expects that the f18a is unlocked when calling this function.
0041               ********|*****|*********************|**************************
0042 681C C20B  18 f18idl  mov   r11,tmp4              ; Save R11
0043 681E 06A0  32         bl    @putvr                ; VR56 >38, value 00000000
     6820 2346     
0044 6822 3800             data  >3800                 ; Reset and load PC (GPU idle!)
0045 6824 0458  20         b     *tmp4                 ; Exit
0046               
0047               
0048               
0049               ***************************************************************
0050               * f18chk - Check if F18A VDP present
0051               ***************************************************************
0052               *  bl   @f18chk
0053               *--------------------------------------------------------------
0054               *  REMARKS
0055               *  Expects that the f18a is unlocked when calling this function.
0056               *  Runs GPU code at VDP >3f00
0057               ********|*****|*********************|**************************
0058 6826 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0059 6828 06A0  32         bl    @cpym2v
     682A 249A     
0060 682C 3F00             data  >3f00,f18chk_gpu,8    ; Copy F18A GPU code to VRAM
     682E 27B2     
     6830 0008     
0061 6832 06A0  32         bl    @putvr
     6834 2346     
0062 6836 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0063 6838 06A0  32         bl    @putvr
     683A 2346     
0064 683C 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0065                                                   ; GPU code should run now
0066               
0067 683E 06A0  32         bl    @putvr                ; VR56 >38, value 00000000
     6840 2346     
0068 6842 3800             data  >3800                 ; Reset and load PC (GPU idle!)
0069               ***************************************************************
0070               * VDP @>3f00 == 0 ? F18A present : F18a not present
0071               ***************************************************************
0072 6844 0204  20         li    tmp0,>3f00
     6846 3F00     
0073 6848 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     684A 22CE     
0074 684C D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     684E 8800     
0075 6850 0984  56         srl   tmp0,8
0076 6852 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     6854 8800     
0077 6856 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0078 6858 1303  14         jeq   f18chk_yes
0079               f18chk_no:
0080 685A 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     685C BFFF     
0081 685E 1002  14         jmp   f18chk_exit
0082               f18chk_yes:
0083 6860 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6862 4000     
0084               
0085               f18chk_exit:
0086 6864 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     6866 22A2     
0087 6868 3F00             data  >3f00,>00,6
     686A 0000     
     686C 0006     
0088 686E 0458  20         b     *tmp4                 ; Exit
0089               ***************************************************************
0090               * GPU code
0091               ********|*****|*********************|**************************
0092               f18chk_gpu
0093 6870 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0094 6872 3F00             data  >3f00                 ; 3f02 / 3f00
0095 6874 0340             data  >0340                 ; 3f04   0340  idle
0096 6876 10FF             data  >10ff                 ; 3f06   10ff  \ jmp $
0097                                                   ;              | Make classic99 debugger
0098                                                   ;              | happy if break on illegal
0099                                                   ;              / opcode is on.
0100               
0101               ***************************************************************
0102               * f18rst - Reset f18a into standard settings
0103               ***************************************************************
0104               *  bl   @f18rst
0105               *--------------------------------------------------------------
0106               *  REMARKS
0107               *  This is used to leave the F18A mode and revert all settings
0108               *  that could lead to corruption when doing BLWP @0
0109               *
0110               *  Is expected to run while the f18a is unlocked.
0111               *
0112               *  There are some F18a settings that stay on when doing blwp @0
0113               *  and the TI title screen cannot recover from that.
0114               *
0115               *  It is your responsibility to set video mode tables should
0116               *  you want to continue instead of doing blwp @0 after your
0117               *  program cleanup
0118               ********|*****|*********************|**************************
0119 6878 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0120                       ;------------------------------------------------------
0121                       ; Reset all F18a VDP registers to power-on defaults
0122                       ;------------------------------------------------------
0123 687A 06A0  32         bl    @putvr
     687C 2346     
0124 687E 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0125               
0126 6880 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     6882 2346     
0127 6884 3900             data  >3900                 ; Lock the F18a
0128 6886 0458  20         b     *tmp4                 ; Exit
0129               
0130               
0131               
0132               ***************************************************************
0133               * f18fwv - Get F18A Firmware Version
0134               ***************************************************************
0135               *  bl   @f18fwv
0136               *--------------------------------------------------------------
0137               *  REMARKS
0138               *  Successfully tested with F18A v1.8, note that this does not
0139               *  work with F18 v1.3 but you shouldn't be using such old F18A
0140               *  firmware to begin with.
0141               *--------------------------------------------------------------
0142               *  TMP0 High nibble = major version
0143               *  TMP0 Low nibble  = minor version
0144               *
0145               *  Example: >0018     F18a Firmware v1.8
0146               ********|*****|*********************|**************************
0147 6888 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0148 688A 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     688C 201E     
0149 688E 1609  14         jne   f18fw1
0150               ***************************************************************
0151               * Read F18A major/minor version
0152               ***************************************************************
0153 6890 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6892 8802     
0154 6894 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6896 2346     
0155 6898 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0156 689A 04C4  14         clr   tmp0
0157 689C D120  34         movb  @vdps,tmp0
     689E 8802     
0158 68A0 0984  56         srl   tmp0,8
0159 68A2 0458  20 f18fw1  b     *tmp4                 ; Exit
                   < runlib.asm
0150               
0152                       copy  "vdp_hchar.asm"            ; VDP hchar functions
     **** ****     > vdp_hchar.asm
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
0017 68A4 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     68A6 832A     
0018 68A8 D17B  28         movb  *r11+,tmp1
0019 68AA 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 68AC D1BB  28         movb  *r11+,tmp2
0021 68AE 0986  56         srl   tmp2,8                ; Repeat count
0022 68B0 C1CB  18         mov   r11,tmp3
0023 68B2 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     68B4 240E     
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 68B6 020B  20         li    r11,hchar1
     68B8 2800     
0028 68BA 0460  28         b     @xfilv                ; Draw
     68BC 22A8     
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 68BE 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     68C0 2022     
0033 68C2 1302  14         jeq   hchar2                ; Yes, exit
0034 68C4 C2C7  18         mov   tmp3,r11
0035 68C6 10EE  14         jmp   hchar                 ; Next one
0036 68C8 05C7  14 hchar2  inct  tmp3
0037 68CA 0457  20         b     *tmp3                 ; Exit
                   < runlib.asm
0154               
0158               
0162               
0166               
0168                       copy  "snd_player.asm"           ; Sound player
     **** ****     > snd_player.asm
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
0014 68CC 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     68CE 8334     
0015 68D0 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     68D2 2006     
0016 68D4 0204  20         li    tmp0,muttab
     68D6 2828     
0017 68D8 0205  20         li    tmp1,sound            ; Sound generator port >8400
     68DA 8400     
0018 68DC D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 68DE D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 68E0 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 68E2 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 68E4 045B  20         b     *r11
0023 68E6 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     68E8 DFFF     
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
0043 68EA C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     68EC 8334     
0044 68EE C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     68F0 8336     
0045 68F2 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     68F4 FFF8     
0046 68F6 E0BB  30         soc   *r11+,config          ; Set options
0047 68F8 D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     68FA 2012     
     68FC 831B     
0048 68FE 045B  20         b     *r11
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
0059 6900 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     6902 2006     
0060 6904 1301  14         jeq   sdpla1                ; Yes, play
0061 6906 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 6908 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 690A 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     690C 831B     
     690E 2000     
0067 6910 1301  14         jeq   sdpla3                ; Play next note
0068 6912 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 6914 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     6916 2002     
0070 6918 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 691A C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     691C 8336     
0075 691E 06C4  14         swpb  tmp0
0076 6920 D804  38         movb  tmp0,@vdpa
     6922 8C02     
0077 6924 06C4  14         swpb  tmp0
0078 6926 D804  38         movb  tmp0,@vdpa
     6928 8C02     
0079 692A 04C4  14         clr   tmp0
0080 692C D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     692E 8800     
0081 6930 131E  14         jeq   sdexit                ; Yes. exit
0082 6932 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 6934 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     6936 8336     
0084 6938 D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     693A 8800     
     693C 8400     
0085 693E 0604  14         dec   tmp0
0086 6940 16FB  14         jne   vdpla2
0087 6942 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     6944 8800     
     6946 831B     
0088 6948 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     694A 8336     
0089 694C 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 694E C120  34 mmplay  mov   @wsdtmp,tmp0
     6950 8336     
0094 6952 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 6954 130C  14         jeq   sdexit                ; Yes, exit
0096 6956 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 6958 A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     695A 8336     
0098 695C D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     695E 8400     
0099 6960 0605  14         dec   tmp1
0100 6962 16FC  14         jne   mmpla2
0101 6964 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     6966 831B     
0102 6968 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     696A 8336     
0103 696C 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 696E 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     6970 2004     
0108 6972 1607  14         jne   sdexi2                ; No, exit
0109 6974 C820  54         mov   @wsdlst,@wsdtmp
     6976 8334     
     6978 8336     
0110 697A D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     697C 2012     
     697E 831B     
0111 6980 045B  20 sdexi1  b     *r11                  ; Exit
0112 6982 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     6984 FFF8     
0113 6986 045B  20         b     *r11                  ; Exit
0114               
                   < runlib.asm
0170               
0174               
0178               
0182               
0185                       copy  "keyb_rkscan.asm"          ; Use ROM#0 OS monitor KSCAN
     **** ****     > keyb_rkscan.asm
0001               * FILE......: keyb_rkscan.asm
0002               * Purpose...: Full (real) keyboard support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     KEYBOARD FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * RKSCAN - Scan keyboard using ROM#0 OS monitor KSCAN
0010               ***************************************************************
0011               *  BL @RKSCAN
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               *--------------------------------------------------------------
0016               * Scratchpad usage by console KSCAN:
0017               *
0018               * >8373  I/O:    LSB of GPL subroutine stack pointer 80 = (>8380)
0019               * >8374  Input:  keyboard scan mode (default=0)
0020               * >8375  Output: ASCII code detected by keyboard scan
0021               * >8376  Output: Joystick Y-status by keyboard scan
0022               * >8377  Output: Joystick X-status by keyboard scan
0023               * >837c  Output: GPL status byte (>20 if key pressed)
0024               * >838a  I/O:    GPL substack
0025               * >838c  I/O:    GPL substack
0026               * >83c6  I/O:    ISRWS R3 Keyboard state and debounce info
0027               * >83c8  I/O:    ISRWS R4 Keyboard state and debounce info
0028               * >83ca  I/O:    ISRWS R5 Keyboard state and debounce info
0029               * >83d4  I/O:    ISRWS R10 Contents of VDP register 01
0030               * >83d6  I/O:    ISRWS R11 Screen timeout counter, blanks when 0000
0031               * >83d8  I/O:    ISRWS R12 (Backup return address old R11 in GPLWS)
0032               * >83f8  output: GPLWS R12 (CRU base address for key scan)
0033               * >83fa  output: GPLWS R13 (GROM/GRAM read data port 9800)
0034               * >83fe  I/O:    GPLWS R15 (VDP write address port 8c02)
0035               ********|*****|*********************|**************************
0036               rkscan:
0037 6988 0649  14         dect  stack
0038 698A C64B  30         mov   r11,*stack            ; Push return address
0039 698C 0649  14         dect  stack
0040 698E C644  30         mov   tmp0,*stack           ; Push tmp0
0041                       ;------------------------------------------------------
0042                       ; (1) Check for alpha lock
0043                       ;------------------------------------------------------
0044 6990 40A0  34         szc   @wbit10,config        ; Reset CONFIG register bit 10=0
     6992 200C     
0045               
0046                       ; See CRU interface and keyboard sections for details
0047                       ; http://www.nouspikel.com/ti99/titechpages.htm
0048               
0049 6994 04CC  14         clr   r12                   ; Set base address (to bit 0) so
0050                                                   ; following offsets correspond
0051               
0052 6996 1E15  20         sbz   >0015                 ; \ Set bit 21 (PIN 5 attached to alpha
0053                                                   ; / lock column) to 0.
0054               
0055 6998 1F07  20         tb    7                     ; \ Copy CRU bit 7 into EQ bit
0056                                                   ; | That is CRU INT7*/P15 pin (keyboard row
0057                                                   ; | with keys FCTN, 2,3,4,5,1,
0058                                                   ; / [joy1-up,joy2-up, Alpha Lock])
0059               
0060 699A 1302  14         jeq   rkscan.prepare        ; No, alpha lock is off
0061               
0062 699C E0A0  34         soc   @wbit10,config        ; \ Yes, alpha lock is on.
     699E 200C     
0063                                                   ; / Set CONFIG register bit 10=1
0064                       ;------------------------------------------------------
0065                       ; (2) Prepare for OS monitor kscan
0066                       ;------------------------------------------------------
0067               rkscan.prepare:
0068 69A0 C820  54         mov   @scrpad.83c6,@>83c6   ; Required for lowercase support
     69A2 2922     
     69A4 83C6     
0069 69A6 C820  54         mov   @scrpad.83fa,@>83fa   ; Load GPLWS R13
     69A8 2924     
     69AA 83FA     
0070 69AC C820  54         mov   @scrpad.83fe,@>83fe   ; Load GPLWS R15
     69AE 2926     
     69B0 83FE     
0071               
0072 69B2 04C4  14         clr   tmp0                  ; \ Keyboard mode in MSB
0073                                                   ; / 00=Scan all of keyboard
0074               
0075 69B4 D804  38         movb  tmp0,@>8374           ; Set keyboard mode at @>8374
     69B6 8374     
0076                                                   ; (scan entire keyboard)
0077               
0078 69B8 02E0  18         lwpi  >83e0                 ; Activate GPL workspace
     69BA 83E0     
0079 69BC 06A0  32         bl    @kscan                ; Call KSCAN
     69BE 000E     
0080 69C0 02E0  18         lwpi  ws1                   ; Activate user workspace
     69C2 8300     
0081                       ;------------------------------------------------------
0082                       ; (3) Check if key pressed
0083                       ;------------------------------------------------------
0084 69C4 D120  34         movb  @>837c,tmp0           ; Get flag
     69C6 837C     
0085 69C8 0A34  56         sla   tmp0,3                ; Flag value is >20
0086 69CA 1707  14         jnc   rkscan.exit           ; No key pressed, exit early
0087                       ;------------------------------------------------------
0088                       ; (4) Key detected, store in memory
0089                       ;------------------------------------------------------
0090 69CC D120  34         movb  @>8375,tmp0           ; \ Key pressed is at @>8375
     69CE 8375     
0091 69D0 0984  56         srl   tmp0,8                ; / Move to LSB
0093 69D2 C804  38         mov   tmp0,@rom0_kscan_out  ; Store ASCII value in user location
     69D4 A022     
0097 69D6 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     69D8 200A     
0098                       ;------------------------------------------------------
0099                       ; Exit
0100                       ;------------------------------------------------------
0101               rkscan.exit:
0102 69DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0103 69DC C2F9  30         mov   *stack+,r11           ; Pop r11
0104 69DE 045B  20         b     *r11                  ; Return to caller
0105               
0106               
0107 69E0 0200     scrpad.83c6   data >0200            ; Required for KSCAN to support lowercase
0108 69E2 9800     scrpad.83fa   data >9800
0109               
0110               ; Dummy value for GPLWS R15 (instead of VDP write address port 8c02)
0111               ; We do not want console KSCAN to fiddle with VDP registers while Stevie
0112               ; is running
0113               
0114 69E4 83A0     scrpad.83fe   data >83a0            ; 8c02
                   < runlib.asm
0190               
0192                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
     **** ****     > cpu_hexsupport.asm
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
0023 69E6 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 69E8 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     69EA 8340     
0025 69EC 04E0  34         clr   @waux1
     69EE 833C     
0026 69F0 04E0  34         clr   @waux2
     69F2 833E     
0027 69F4 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     69F6 833C     
0028 69F8 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 69FA 0205  20         li    tmp1,4                ; 4 nibbles
     69FC 0004     
0033 69FE C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6A00 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6A02 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6A04 0286  22         ci    tmp2,>000a
     6A06 000A     
0039 6A08 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6A0A C21B  26         mov   *r11,tmp4
0045 6A0C 0988  56         srl   tmp4,8                ; Right justify
0046 6A0E 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6A10 FFF6     
0047 6A12 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6A14 C21B  26         mov   *r11,tmp4
0054 6A16 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6A18 00FF     
0055               
0056 6A1A A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6A1C 06C6  14         swpb  tmp2
0058 6A1E DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6A20 0944  56         srl   tmp0,4                ; Next nibble
0060 6A22 0605  14         dec   tmp1
0061 6A24 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6A26 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6A28 BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6A2A C160  34         mov   @waux3,tmp1           ; Get pointer
     6A2C 8340     
0067 6A2E 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6A30 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6A32 C120  34         mov   @waux2,tmp0
     6A34 833E     
0070 6A36 06C4  14         swpb  tmp0
0071 6A38 DD44  32         movb  tmp0,*tmp1+
0072 6A3A 06C4  14         swpb  tmp0
0073 6A3C DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6A3E C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6A40 8340     
0078 6A42 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6A44 2016     
0079 6A46 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6A48 C120  34         mov   @waux1,tmp0
     6A4A 833C     
0084 6A4C 06C4  14         swpb  tmp0
0085 6A4E DD44  32         movb  tmp0,*tmp1+
0086 6A50 06C4  14         swpb  tmp0
0087 6A52 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6A54 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A56 2020     
0092 6A58 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6A5A 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6A5C 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6A5E 7FFF     
0098 6A60 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6A62 8340     
0099 6A64 0460  28         b     @xutst0               ; Display string
     6A66 2434     
0100 6A68 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6A6A C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6A6C 832A     
0122 6A6E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6A70 8000     
0123 6A72 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
                   < runlib.asm
0194               
0196                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
     **** ****     > cpu_numsupport.asm
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
0019 6A74 0207  20 mknum   li    tmp3,5                ; Digit counter
     6A76 0005     
0020 6A78 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6A7A C155  26         mov   *tmp1,tmp1            ; /
0022 6A7C C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6A7E 0228  22         ai    tmp4,4                ; Get end of buffer
     6A80 0004     
0024 6A82 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6A84 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6A86 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6A88 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6A8A 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6A8C B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6A8E D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6A90 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6A92 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6A94 0607  14         dec   tmp3                  ; Decrease counter
0036 6A96 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6A98 0207  20         li    tmp3,4                ; Check first 4 digits
     6A9A 0004     
0041 6A9C 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6A9E C11B  26         mov   *r11,tmp0
0043 6AA0 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6AA2 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6AA4 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6AA6 05CB  14 mknum3  inct  r11
0047 6AA8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6AAA 2020     
0048 6AAC 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6AAE 045B  20         b     *r11                  ; Exit
0050 6AB0 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6AB2 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6AB4 13F8  14         jeq   mknum3                ; Yes, exit
0053 6AB6 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6AB8 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6ABA 7FFF     
0058 6ABC C10B  18         mov   r11,tmp0
0059 6ABE 0224  22         ai    tmp0,-4
     6AC0 FFFC     
0060 6AC2 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6AC4 0206  20         li    tmp2,>0500            ; String length = 5
     6AC6 0500     
0062 6AC8 0460  28         b     @xutstr               ; Display string
     6ACA 2436     
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
0093 6ACC C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6ACE C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6AD0 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6AD2 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6AD4 0207  20         li    tmp3,5                ; Set counter
     6AD6 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6AD8 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6ADA 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6ADC 0584  14         inc   tmp0                  ; Next character
0105 6ADE 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6AE0 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6AE2 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6AE4 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6AE6 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6AE8 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6AEA DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6AEC 0607  14         dec   tmp3                  ; Last character ?
0121 6AEE 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6AF0 045B  20         b     *r11                  ; Return
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
0139 6AF2 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6AF4 832A     
0140 6AF6 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6AF8 8000     
0141 6AFA 10BC  14         jmp   mknum                 ; Convert number and display
                   < runlib.asm
0198               
0202               
0206               
0210               
0214               
0216                       copy  "cpu_strings.asm"          ; String utilities support
     **** ****     > cpu_strings.asm
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
0022 6AFC 0649  14         dect  stack
0023 6AFE C64B  30         mov   r11,*stack            ; Save return address
0024 6B00 0649  14         dect  stack
0025 6B02 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6B04 0649  14         dect  stack
0027 6B06 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6B08 0649  14         dect  stack
0029 6B0A C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6B0C 0649  14         dect  stack
0031 6B0E C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6B10 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6B12 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6B14 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6B16 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6B18 0649  14         dect  stack
0044 6B1A C64B  30         mov   r11,*stack            ; Save return address
0045 6B1C 0649  14         dect  stack
0046 6B1E C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6B20 0649  14         dect  stack
0048 6B22 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6B24 0649  14         dect  stack
0050 6B26 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6B28 0649  14         dect  stack
0052 6B2A C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6B2C C1D4  26 !       mov   *tmp0,tmp3
0057 6B2E 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6B30 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6B32 00FF     
0059 6B34 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6B36 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6B38 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6B3A 0584  14         inc   tmp0                  ; Next byte
0067 6B3C 0607  14         dec   tmp3                  ; Shorten string length
0068 6B3E 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6B40 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6B42 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6B44 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6B46 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6B48 C187  18         mov   tmp3,tmp2
0078 6B4A 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6B4C DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6B4E 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6B50 24F4     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6B52 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6B54 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B56 FFCE     
0090 6B58 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B5A 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6B5C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6B5E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6B60 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6B62 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6B64 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6B66 045B  20         b     *r11                  ; Return to caller
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
0123 6B68 0649  14         dect  stack
0124 6B6A C64B  30         mov   r11,*stack            ; Save return address
0125 6B6C 05D9  26         inct  *stack                ; Skip "data P0"
0126 6B6E 05D9  26         inct  *stack                ; Skip "data P1"
0127 6B70 0649  14         dect  stack
0128 6B72 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6B74 0649  14         dect  stack
0130 6B76 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6B78 0649  14         dect  stack
0132 6B7A C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6B7C C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6B7E C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6B80 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6B82 0649  14         dect  stack
0144 6B84 C64B  30         mov   r11,*stack            ; Save return address
0145 6B86 0649  14         dect  stack
0146 6B88 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6B8A 0649  14         dect  stack
0148 6B8C C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6B8E 0649  14         dect  stack
0150 6B90 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6B92 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6B94 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6B96 0586  14         inc   tmp2
0161 6B98 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6B9A 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6B9C 0286  22         ci    tmp2,255
     6B9E 00FF     
0167 6BA0 1505  14         jgt   string.getlenc.panic
0168 6BA2 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6BA4 0606  14         dec   tmp2                  ; One time adjustment
0174 6BA6 C806  38         mov   tmp2,@waux1           ; Store length
     6BA8 833C     
0175 6BAA 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6BAC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BAE FFCE     
0181 6BB0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BB2 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6BB4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6BB6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6BB8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6BBA C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6BBC 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0218               
0222               
0224                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
     **** ****     > cpu_scrpad_backrest.asm
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
0023 6BBE C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     6BC0 F960     
0024 6BC2 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     6BC4 F962     
0025 6BC6 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     6BC8 F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 6BCA 0200  20         li    r0,>8306              ; Scratchpad source address
     6BCC 8306     
0030 6BCE 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     6BD0 F966     
0031 6BD2 0202  20         li    r2,62                 ; Loop counter
     6BD4 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 6BD6 CC70  46         mov   *r0+,*r1+
0037 6BD8 CC70  46         mov   *r0+,*r1+
0038 6BDA 0642  14         dect  r2
0039 6BDC 16FC  14         jne   cpu.scrpad.backup.copy
0040 6BDE C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     6BE0 83FE     
     6BE2 FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 6BE4 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     6BE6 F960     
0046 6BE8 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     6BEA F962     
0047 6BEC C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     6BEE F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 6BF0 045B  20         b     *r11                  ; Return to caller
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
0063               *  r0-r1
0064               *--------------------------------------------------------------
0065               *  Restore scratchpad from memory area @cpu.scrpad.tgt (+ >ff).
0066               *  Current workspace may not be in scratchpad >8300 when called.
0067               *
0068               *  Destroys r0,r1
0069               ********|*****|*********************|**************************
0070               cpu.scrpad.restore:
0071                       ;------------------------------------------------------
0072                       ; Prepare for copy loop, WS
0073                       ;------------------------------------------------------
0074 6BF2 0200  20         li    r0,cpu.scrpad.tgt
     6BF4 F960     
0075 6BF6 0201  20         li    r1,>8300
     6BF8 8300     
0076                       ;------------------------------------------------------
0077                       ; Copy 256 bytes from @cpu.scrpad.tgt to >8300
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 6BFA CC70  46         mov   *r0+,*r1+
0081 6BFC CC70  46         mov   *r0+,*r1+
0082 6BFE 0281  22         ci    r1,>8400
     6C00 8400     
0083 6C02 11FB  14         jlt   cpu.scrpad.restore.copy
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               cpu.scrpad.restore.exit:
0088 6C04 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0225                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
     **** ****     > cpu_scrpad_paging.asm
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
0014               ***************************************************************
0015               *  bl   @cpu.scrpad.pgout
0016               *       DATA p0
0017               *
0018               *  P0 = CPU memory destination
0019               *--------------------------------------------------------------
0020               *  bl   @xcpu.scrpad.pgout
0021               *  tmp1 = CPU memory destination
0022               *--------------------------------------------------------------
0023               *  Register usage
0024               *  tmp3      = Copy of CPU memory destination
0025               *  tmp0-tmp2 = Used as temporary registers
0026               *  @waux1    = Copy of r5 (tmp1)
0027               *--------------------------------------------------------------
0028               *  Remarks
0029               *  Copies 256 bytes from scratchpad to CPU memory destination
0030               *  specified in P0 (tmp1).
0031               *
0032               *  Then switches to the newly copied workspace in P0 (tmp1).
0033               *
0034               *  Finally it copies 256 bytes from @cpu.scrpad.tgt
0035               *  to scratchpad >8300 and activates workspace at >8300
0036               ********|*****|*********************|**************************
0037               cpu.scrpad.pgout:
0038 6C06 C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 6C08 CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 6C0A CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 6C0C CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 6C0E CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 6C10 CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 6C12 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 6C14 CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 6C16 CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 6C18 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     6C1A 8310     
0055                                                   ;        as of register r8
0056 6C1C 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     6C1E 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 6C20 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 6C22 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 6C24 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 6C26 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 6C28 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 6C2A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 6C2C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 6C2E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 6C30 0606  14         dec   tmp2
0069 6C32 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 6C34 C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 6C36 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6C38 2B80     
0075                                                   ; R14=PC
0076 6C3A 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 6C3C 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 6C3E 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     6C40 2B34     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 6C42 045B  20         b     *r11                  ; Return to caller
0094               
0095               
0096               ***************************************************************
0097               * cpu.scrpad.pgin - Page in 256 bytes of scratchpad memory
0098               *                   at >8300 from CPU memory specified in
0099               *                   p0 (tmp0)
0100               ***************************************************************
0101               *  bl   @cpu.scrpad.pgin
0102               *       DATA p0
0103               *
0104               *  P0 = CPU memory source
0105               *--------------------------------------------------------------
0106               *  bl   @memx.scrpad.pgin
0107               *  TMP0 = CPU memory source
0108               *--------------------------------------------------------------
0109               *  Register usage
0110               *  tmp0-tmp2 = Used as temporary registers
0111               *--------------------------------------------------------------
0112               *  Remarks
0113               *  Copies 256 bytes from CPU memory source to scratchpad >8300
0114               *  and activates workspace in scratchpad >8300
0115               *
0116               *  It's expected that the workspace is outside scratchpad >8300
0117               *  when calling this function.
0118               ********|*****|*********************|**************************
0119               cpu.scrpad.pgin:
0120 6C44 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0121                       ;------------------------------------------------------
0122                       ; Copy scratchpad memory to destination
0123                       ;------------------------------------------------------
0124               xcpu.scrpad.pgin:
0125 6C46 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6C48 8300     
0126 6C4A 0206  20         li    tmp2,16               ; tmp2 = 256/16
     6C4C 0010     
0127                       ;------------------------------------------------------
0128                       ; Copy memory
0129                       ;------------------------------------------------------
0130 6C4E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0131 6C50 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0132 6C52 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0133 6C54 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0134 6C56 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0135 6C58 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0136 6C5A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0137 6C5C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0138 6C5E 0606  14         dec   tmp2
0139 6C60 16F6  14         jne   -!                    ; Loop until done
0140                       ;------------------------------------------------------
0141                       ; Switch workspace to scratchpad memory
0142                       ;------------------------------------------------------
0143 6C62 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6C64 8300     
0144                       ;------------------------------------------------------
0145                       ; Exit
0146                       ;------------------------------------------------------
0147               cpu.scrpad.pgin.exit:
0148 6C66 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0227               
0229                       copy  "fio.equ"                  ; File I/O equates
     **** ****     > fio.equ
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
                   < runlib.asm
0230                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
     **** ****     > fio_dsrlnk.asm
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
0056 6C68 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6C6A 2BAE             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6C6C C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6C6E C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6C70 A428     
0064 6C72 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6C74 201C     
0065 6C76 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6C78 8356     
0066 6C7A C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6C7C 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6C7E FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6C80 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6C82 A434     
0073                       ;---------------------------; Inline VSBR start
0074 6C84 06C0  14         swpb  r0                    ;
0075 6C86 D800  38         movb  r0,@vdpa              ; Send low byte
     6C88 8C02     
0076 6C8A 06C0  14         swpb  r0                    ;
0077 6C8C D800  38         movb  r0,@vdpa              ; Send high byte
     6C8E 8C02     
0078 6C90 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6C92 8800     
0079                       ;---------------------------; Inline VSBR end
0080 6C94 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6C96 0704  14         seto  r4                    ; Init counter
0086 6C98 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6C9A A420     
0087 6C9C 0580  14 !       inc   r0                    ; Point to next char of name
0088 6C9E 0584  14         inc   r4                    ; Increment char counter
0089 6CA0 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6CA2 0007     
0090 6CA4 1573  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6CA6 80C4  18         c     r4,r3                 ; End of name?
0093 6CA8 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6CAA 06C0  14         swpb  r0                    ;
0098 6CAC D800  38         movb  r0,@vdpa              ; Send low byte
     6CAE 8C02     
0099 6CB0 06C0  14         swpb  r0                    ;
0100 6CB2 D800  38         movb  r0,@vdpa              ; Send high byte
     6CB4 8C02     
0101 6CB6 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6CB8 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6CBA DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6CBC 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6CBE 2D1A     
0109 6CC0 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6CC2 C104  18         mov   r4,r4                 ; Check if length = 0
0115 6CC4 1363  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6CC6 04E0  34         clr   @>83d0
     6CC8 83D0     
0118 6CCA C804  38         mov   r4,@>8354             ; Save name length for search (length
     6CCC 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6CCE C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6CD0 A432     
0121               
0122 6CD2 0584  14         inc   r4                    ; Adjust for dot
0123 6CD4 A804  38         a     r4,@>8356             ; Point to position after name
     6CD6 8356     
0124 6CD8 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6CDA 8356     
     6CDC A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6CDE 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6CE0 83E0     
0130 6CE2 04C1  14         clr   r1                    ; Version found of dsr
0131 6CE4 020C  20         li    r12,>0f00             ; Init cru address
     6CE6 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6CE8 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6CEA 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6CEC 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6CEE 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6CF0 0100     
0145 6CF2 04E0  34         clr   @>83d0                ; Clear in case we are done
     6CF4 83D0     
0146 6CF6 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6CF8 2000     
0147 6CFA 1346  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6CFC C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6CFE 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6D00 1D00  20         sbo   0                     ; Turn on ROM
0154 6D02 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6D04 4000     
0155 6D06 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6D08 2D16     
0156 6D0A 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6D0C A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6D0E A40A     
0166 6D10 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6D12 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6D14 83D2     
0172                                                   ; subprogram
0173               
0174 6D16 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6D18 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6D1A 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6D1C C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6D1E 83D2     
0183                                                   ; subprogram
0184               
0185 6D20 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6D22 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6D24 04C5  14         clr   r5                    ; Remove any old stuff
0194 6D26 D160  34         movb  @>8355,r5             ; Get length as counter
     6D28 8355     
0195 6D2A 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6D2C 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6D2E 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6D30 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6D32 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6D34 A420     
0206 6D36 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6D38 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6D3A 0605  14         dec   r5                    ; Update loop counter
0211 6D3C 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6D3E 0581  14         inc   r1                    ; Next version found
0217 6D40 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6D42 A42A     
0218 6D44 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6D46 A42C     
0219 6D48 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6D4A A430     
0220               
0221 6D4C 020D  20         li    r13,>9800             ; Set GROM base to >9800 to prevent
     6D4E 9800     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6D50 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6D52 8C02     
0225                                                   ; lockup of TI Disk Controller DSR.
0226               
0227 6D54 0699  24         bl    *r9                   ; Execute DSR
0228                       ;
0229                       ; Depending on IO result the DSR in card ROM does RET
0230                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0231                       ;
0232 6D56 10DD  14         jmp   dsrlnk.dsrscan.nextentry
0233                                                   ; (1) error return
0234 6D58 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0235 6D5A 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6D5C A400     
0236 6D5E C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0237                       ;------------------------------------------------------
0238                       ; Returned from DSR
0239                       ;------------------------------------------------------
0240               dsrlnk.dsrscan.return_dsr:
0241 6D60 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6D62 A428     
0242                                                   ; (8 or >a)
0243 6D64 0281  22         ci    r1,8                  ; was it 8?
     6D66 0008     
0244 6D68 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0245 6D6A D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6D6C 8350     
0246                                                   ; Get error byte from @>8350
0247 6D6E 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0248               
0249                       ;------------------------------------------------------
0250                       ; Read VDP PAB byte 1 after DSR call completed (status)
0251                       ;------------------------------------------------------
0252               dsrlnk.dsrscan.dsr.8:
0253                       ;---------------------------; Inline VSBR start
0254 6D70 06C0  14         swpb  r0                    ;
0255 6D72 D800  38         movb  r0,@vdpa              ; send low byte
     6D74 8C02     
0256 6D76 06C0  14         swpb  r0                    ;
0257 6D78 D800  38         movb  r0,@vdpa              ; send high byte
     6D7A 8C02     
0258 6D7C D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6D7E 8800     
0259                       ;---------------------------; Inline VSBR end
0260               
0261                       ;------------------------------------------------------
0262                       ; Return DSR error to caller
0263                       ;------------------------------------------------------
0264               dsrlnk.dsrscan.dsr.a:
0265 6D80 09D1  56         srl   r1,13                 ; just keep error bits
0266 6D82 1605  14         jne   dsrlnk.error.io_error
0267                                                   ; handle IO error
0268 6D84 0380  18         rtwp                        ; Return from DSR workspace to caller
0269                                                   ; workspace
0270               
0271                       ;------------------------------------------------------
0272                       ; IO-error handler
0273                       ;------------------------------------------------------
0274               dsrlnk.error.nodsr_found_off:
0275 6D86 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0276               dsrlnk.error.nodsr_found:
0277 6D88 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6D8A A400     
0278               dsrlnk.error.devicename_invalid:
0279 6D8C 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0280               dsrlnk.error.io_error:
0281 6D8E 06C1  14         swpb  r1                    ; put error in hi byte
0282 6D90 D741  30         movb  r1,*r13               ; store error flags in callers r0
0283 6D92 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6D94 201C     
0284                                                   ; / to indicate error
0285 6D96 0380  18         rtwp                        ; Return from DSR workspace to caller
0286                                                   ; workspace
0287               
0288               
0289               ***************************************************************
0290               * dsrln.reuse - Reuse previous DSRLNK call for improved speed
0291               ***************************************************************
0292               *  blwp @dsrlnk.reuse
0293               *--------------------------------------------------------------
0294               *  Input:
0295               *  @>8356         = Pointer to VDP PAB file descriptor length byte (PAB+9)
0296               *  @dsrlnk.savcru = CRU address of device in previous DSR call
0297               *  @dsrlnk.savent = DSR entry address of previous DSR call
0298               *  @dsrlnk.savver = Version used in previous DSR call
0299               *  @dsrlnk.pabptr = Pointer to PAB in VDP memory, set in previous DSR call
0300               *--------------------------------------------------------------
0301               *  Output:
0302               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0303               *--------------------------------------------------------------
0304               *  Remarks:
0305               *   Call the same DSR entry again without having to scan through
0306               *   all devices again.
0307               *
0308               *   Expects dsrlnk.savver, @dsrlnk.savent, @dsrlnk.savcru to be
0309               *   set by previous DSRLNK call.
0310               ********|*****|*********************|**************************
0311               dsrlnk.reuse:
0312 6D98 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0313 6D9A 2CDE             data  dsrlnk.reuse.init     ; entry point
0314                       ;------------------------------------------------------
0315                       ; DSRLNK entry point
0316                       ;------------------------------------------------------
0317               dsrlnk.reuse.init:
0318 6D9C 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6D9E 83E0     
0319               
0320 6DA0 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6DA2 201C     
0321                       ;------------------------------------------------------
0322                       ; Restore dsrlnk variables of previous DSR call
0323                       ;------------------------------------------------------
0324 6DA4 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6DA6 A42A     
0325 6DA8 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0326 6DAA C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0327 6DAC C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6DAE 8356     
0328                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0329 6DB0 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0330 6DB2 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6DB4 8354     
0331                       ;------------------------------------------------------
0332                       ; Call DSR program in card/device
0333                       ;------------------------------------------------------
0334 6DB6 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6DB8 8C02     
0335                                                   ; lockup of TI Disk Controller DSR.
0336               
0337 6DBA 1D00  20         sbo   >00                   ; Open card/device ROM
0338               
0339 6DBC 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6DBE 4000     
     6DC0 2D16     
0340 6DC2 16E2  14         jne   dsrlnk.error.nodsr_found
0341                                                   ; No, error code 0 = Bad Device name
0342                                                   ; The above jump may happen only in case of
0343                                                   ; either card hardware malfunction or if
0344                                                   ; there are 2 cards opened at the same time.
0345               
0346 6DC4 0699  24         bl    *r9                   ; Execute DSR
0347                       ;
0348                       ; Depending on IO result the DSR in card ROM does RET
0349                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0350                       ;
0351 6DC6 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0352                                                   ; (1) error return
0353 6DC8 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0354                       ;------------------------------------------------------
0355                       ; Now check if any DSR error occured
0356                       ;------------------------------------------------------
0357 6DCA 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6DCC A400     
0358 6DCE C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6DD0 A434     
0359               
0360 6DD2 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0361                                                   ; Rest is the same as with normal DSRLNK
0362               
0363               
0364               ********************************************************************************
0365               
0366 6DD4 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0367 6DD6 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0368                                                   ; a @blwp @dsrlnk
0369 6DD8 2E       dsrlnk.period     text  '.'         ; For finding end of device name
0370               
0371                       even
                   < runlib.asm
0231                       copy  "fio_level3.asm"           ; File I/O level 3 support
     **** ****     > fio_level3.asm
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
0045 6DDA C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6DDC C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6DDE 0649  14         dect  stack
0052 6DE0 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6DE2 0204  20         li    tmp0,dsrlnk.savcru
     6DE4 A42A     
0057 6DE6 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6DE8 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6DEA 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6DEC 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6DEE 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6DF0 37D7     
0065 6DF2 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6DF4 8370     
0066                                                   ; / location
0067 6DF6 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6DF8 A44C     
0068 6DFA 04C5  14         clr   tmp1                  ; io.op.open
0069 6DFC 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6DFE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6E00 0649  14         dect  stack
0097 6E02 C64B  30         mov   r11,*stack            ; Save return address
0098 6E04 0205  20         li    tmp1,io.op.close      ; io.op.close
     6E06 0001     
0099 6E08 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6E0A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6E0C 0649  14         dect  stack
0125 6E0E C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6E10 0205  20         li    tmp1,io.op.read       ; io.op.read
     6E12 0002     
0128 6E14 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6E16 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6E18 0649  14         dect  stack
0155 6E1A C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6E1C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6E1E 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6E20 0005     
0159               
0160 6E22 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6E24 A43E     
0161               
0162 6E26 06A0  32         bl    @xvputb               ; Write character count to PAB
     6E28 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6E2A 0205  20         li    tmp1,io.op.write      ; io.op.write
     6E2C 0003     
0167 6E2E 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6E30 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6E32 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6E34 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6E36 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6E38 1000  14         nop
0189               
0190               
0191               file.status:
0192 6E3A 1000  14         nop
0193               
0194               
0195               
0196               ***************************************************************
0197               * _file.record.fop - File operation
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
0218               *  Private, only to be called from inside fio_level3 module
0219               *  via jump or branch instruction.
0220               *
0221               *  Uses @waux1 for backup/restore of memory word @>8322
0222               ********|*****|*********************|**************************
0223               _file.record.fop:
0224                       ;------------------------------------------------------
0225                       ; Write to PAB required?
0226                       ;------------------------------------------------------
0227 6E3C C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6E3E A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6E40 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6E42 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6E44 A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6E46 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6E48 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6E4A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6E4C 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6E4E C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6E50 A44C     
0246               
0247 6E52 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6E54 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6E56 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6E58 0009     
0254 6E5A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6E5C 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6E5E C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6E60 8322     
     6E62 833C     
0259               
0260 6E64 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6E66 A42A     
0261 6E68 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6E6A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6E6C 2BAA     
0268 6E6E 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6E70 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6E72 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6E74 2CDA     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6E76 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6E78 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6E7A 833C     
     6E7C 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6E7E C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6E80 A436     
0292 6E82 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6E84 0005     
0293 6E86 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6E88 22F8     
0294 6E8A C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6E8C C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6E8E C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6E90 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0233               
0234               *//////////////////////////////////////////////////////////////
0235               *                            TIMERS
0236               *//////////////////////////////////////////////////////////////
0237               
0238                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
     **** ****     > timers_tmgr.asm
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
0020 6E92 0300  24 tmgr    limi  0                     ; No interrupt processing
     6E94 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6E96 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6E98 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6E9A 2360  38         coc   @wbit2,r13            ; C flag on ?
     6E9C 201C     
0029 6E9E 1602  14         jne   tmgr1a                ; No, so move on
0030 6EA0 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6EA2 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6EA4 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6EA6 2020     
0035 6EA8 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6EAA 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6EAC 2010     
0048 6EAE 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6EB0 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6EB2 200E     
0050 6EB4 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6EB6 0460  28         b     @kthread              ; Run kernel thread
     6EB8 2E72     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6EBA 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6EBC 2014     
0056 6EBE 13EB  14         jeq   tmgr1
0057 6EC0 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6EC2 2012     
0058 6EC4 16E8  14         jne   tmgr1
0059 6EC6 C120  34         mov   @wtiusr,tmp0
     6EC8 832E     
0060 6ECA 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6ECC 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6ECE 2E70     
0065 6ED0 C10A  18         mov   r10,tmp0
0066 6ED2 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6ED4 00FF     
0067 6ED6 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6ED8 201C     
0068 6EDA 1303  14         jeq   tmgr5
0069 6EDC 0284  22         ci    tmp0,60               ; 1 second reached ?
     6EDE 003C     
0070 6EE0 1002  14         jmp   tmgr6
0071 6EE2 0284  22 tmgr5   ci    tmp0,50
     6EE4 0032     
0072 6EE6 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6EE8 1001  14         jmp   tmgr8
0074 6EEA 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6EEC C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6EEE 832C     
0079 6EF0 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6EF2 FF00     
0080 6EF4 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6EF6 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6EF8 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6EFA 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6EFC C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6EFE 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6F00 830C     
     6F02 830D     
0089 6F04 1608  14         jne   tmgr10                ; No, get next slot
0090 6F06 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6F08 FF00     
0091 6F0A C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6F0C C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6F0E 8330     
0096 6F10 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6F12 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6F14 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6F16 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6F18 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6F1A 8315     
     6F1C 8314     
0103 6F1E 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6F20 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6F22 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6F24 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6F26 10F7  14         jmp   tmgr10                ; Process next slot
0108 6F28 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6F2A FF00     
0109 6F2C 10B4  14         jmp   tmgr1
0110 6F2E 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
                   < runlib.asm
0239                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
     **** ****     > timers_kthread.asm
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
0015 6F30 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6F32 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 6F34 20A0  38         coc   @wbit13,config        ; Sound player on ?
     6F36 2006     
0023 6F38 1602  14         jne   kthread_kb
0024 6F3A 06A0  32         bl    @sdpla1               ; Run sound player
     6F3C 284A     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0042 6F3E 06A0  32         bl    @rkscan               ; Scan full keyboard with ROM#0 KSCAN
     6F40 28CA     
0047               *--------------------------------------------------------------
0048               kthread_exit
0049 6F42 0460  28         b     @tmgr3                ; Exit
     6F44 2DFC     
                   < runlib.asm
0240                       copy  "timers_hooks.asm"         ; Timers / User hooks
     **** ****     > timers_hooks.asm
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
0017 6F46 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6F48 832E     
0018 6F4A E0A0  34         soc   @wbit7,config         ; Enable user hook
     6F4C 2012     
0019 6F4E 045B  20 mkhoo1  b     *r11                  ; Return
0020      2DD8     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6F50 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6F52 832E     
0029 6F54 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6F56 FEFF     
0030 6F58 045B  20         b     *r11                  ; Return
                   < runlib.asm
0241               
0243                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
     **** ****     > timers_alloc.asm
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
0017 6F5A C13B  30 mkslot  mov   *r11+,tmp0
0018 6F5C C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6F5E C184  18         mov   tmp0,tmp2
0023 6F60 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6F62 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6F64 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6F66 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6F68 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6F6A C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6F6C 881B  46         c     *r11,@w$ffff          ; End of list ?
     6F6E 2022     
0035 6F70 1301  14         jeq   mkslo1                ; Yes, exit
0036 6F72 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6F74 05CB  14 mkslo1  inct  r11
0041 6F76 045B  20         b     *r11                  ; Exit
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
0052 6F78 C13B  30 clslot  mov   *r11+,tmp0
0053 6F7A 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6F7C A120  34         a     @wtitab,tmp0          ; Add table base
     6F7E 832C     
0055 6F80 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6F82 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6F84 045B  20         b     *r11                  ; Exit
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
0068 6F86 C13B  30 rsslot  mov   *r11+,tmp0
0069 6F88 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 6F8A A120  34         a     @wtitab,tmp0          ; Add table base
     6F8C 832C     
0071 6F8E 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 6F90 C154  26         mov   *tmp0,tmp1
0073 6F92 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     6F94 FF00     
0074 6F96 C505  30         mov   tmp1,*tmp0
0075 6F98 045B  20         b     *r11                  ; Exit
                   < runlib.asm
0245               
0246               
0247               
0248               *//////////////////////////////////////////////////////////////
0249               *                    RUNLIB INITIALISATION
0250               *//////////////////////////////////////////////////////////////
0251               
0252               ***************************************************************
0253               *  RUNLIB - Runtime library initalisation
0254               ***************************************************************
0255               *  B  @RUNLIB
0256               *--------------------------------------------------------------
0257               *  REMARKS
0258               *  if R0 in WS1 equals >4a4a we were called from the system
0259               *  crash handler so we return there after initialisation.
0260               
0261               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0262               *  after clearing scratchpad memory. This has higher priority
0263               *  as crash handler flag R0.
0264               ********|*****|*********************|**************************
0271 6F9A 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6F9C 8302     
0273               *--------------------------------------------------------------
0274               * Alternative entry point
0275               *--------------------------------------------------------------
0276 6F9E 0300  24 runli1  limi  0                     ; Turn off interrupts
     6FA0 0000     
0277 6FA2 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6FA4 8300     
0278 6FA6 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6FA8 83C0     
0279               *--------------------------------------------------------------
0280               * Clear scratch-pad memory from R4 upwards
0281               *--------------------------------------------------------------
0282 6FAA 0202  20 runli2  li    r2,>8308
     6FAC 8308     
0283 6FAE 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0284 6FB0 0282  22         ci    r2,>8400
     6FB2 8400     
0285 6FB4 16FC  14         jne   runli3
0286               *--------------------------------------------------------------
0287               * Exit to TI-99/4A title screen ?
0288               *--------------------------------------------------------------
0289 6FB6 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     6FB8 FFFF     
0290 6FBA 1602  14         jne   runli4                ; No, continue
0291 6FBC 0420  54         blwp  @0                    ; Yes, bye bye
     6FBE 0000     
0292               *--------------------------------------------------------------
0293               * Determine if VDP is PAL or NTSC
0294               *--------------------------------------------------------------
0295 6FC0 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6FC2 833C     
0296 6FC4 04C1  14         clr   r1                    ; Reset counter
0297 6FC6 0202  20         li    r2,10                 ; We test 10 times
     6FC8 000A     
0298 6FCA C0E0  34 runli5  mov   @vdps,r3
     6FCC 8802     
0299 6FCE 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6FD0 2020     
0300 6FD2 1302  14         jeq   runli6
0301 6FD4 0581  14         inc   r1                    ; Increase counter
0302 6FD6 10F9  14         jmp   runli5
0303 6FD8 0602  14 runli6  dec   r2                    ; Next test
0304 6FDA 16F7  14         jne   runli5
0305 6FDC 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6FDE 1250     
0306 6FE0 1202  14         jle   runli7                ; No, so it must be NTSC
0307 6FE2 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6FE4 201C     
0308               *--------------------------------------------------------------
0309               * Copy machine code to scratchpad (prepare tight loop)
0310               *--------------------------------------------------------------
0311 6FE6 06A0  32 runli7  bl    @loadmc
     6FE8 222E     
0312               *--------------------------------------------------------------
0313               * Initialize registers, memory, ...
0314               *--------------------------------------------------------------
0315 6FEA 04C1  14 runli9  clr   r1
0316 6FEC 04C2  14         clr   r2
0317 6FEE 04C3  14         clr   r3
0318 6FF0 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     6FF2 A900     
0319 6FF4 020F  20         li    r15,vdpw              ; Set VDP write address
     6FF6 8C00     
0321 6FF8 06A0  32         bl    @mute                 ; Mute sound generators
     6FFA 280E     
0323               *--------------------------------------------------------------
0324               * Setup video memory
0325               *--------------------------------------------------------------
0327 6FFC 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6FFE 4A4A     
0328 7000 1605  14         jne   runlia
0329 7002 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     7004 22A2     
0330 7006 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     7008 0000     
     700A 3000     
0335 700C 06A0  32 runlia  bl    @filv
     700E 22A2     
0336 7010 0FC0             data  pctadr,spfclr,16      ; Load color table
     7012 00F4     
     7014 0010     
0337               *--------------------------------------------------------------
0338               * Check if there is a F18A present
0339               *--------------------------------------------------------------
0343 7016 06A0  32         bl    @f18unl               ; Unlock the F18A
     7018 273E     
0344 701A 06A0  32         bl    @f18chk               ; Check if F18A is there \
     701C 2768     
0345 701E 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     7020 2768     
0346 7022 06A0  32         bl    @f18chk               ; Check if F18A is there /
     7024 2768     
0347 7026 06A0  32         bl    @f18lck               ; Lock the F18A again
     7028 2754     
0348               
0349 702A 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     702C 2346     
0350 702E 3201                   data >3201            ; F18a VR50 (>32), bit 1
0352               *--------------------------------------------------------------
0353               * Check if there is a speech synthesizer attached
0354               *--------------------------------------------------------------
0356               *       <<skipped>>
0360               *--------------------------------------------------------------
0361               * Load video mode table & font
0362               *--------------------------------------------------------------
0363 7030 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     7032 230C     
0364 7034 35E2             data  spvmod                ; Equate selected video mode table
0365 7036 0204  20         li    tmp0,spfont           ; Get font option
     7038 000C     
0366 703A 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0367 703C 1304  14         jeq   runlid                ; Yes, skip it
0368 703E 06A0  32         bl    @ldfnt
     7040 2374     
0369 7042 1100             data  fntadr,spfont         ; Load specified font
     7044 000C     
0370               *--------------------------------------------------------------
0371               * Did a system crash occur before runlib was called?
0372               *--------------------------------------------------------------
0373 7046 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     7048 4A4A     
0374 704A 1602  14         jne   runlie                ; No, continue
0375 704C 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     704E 2086     
0376               *--------------------------------------------------------------
0377               * Branch to main program
0378               *--------------------------------------------------------------
0379 7050 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     7052 0040     
0380 7054 0460  28         b     @main                 ; Give control to main program
     7056 39D6     
                   < stevie_b0.asm.57700
0109                       copy  "ram.resident.asm"
     **** ****     > ram.resident.asm
0001               * FILE......: ram.resident.asm
0002               * Purpose...: Resident modules in LOW MEMEXP callable from all ROM banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Low-level modules
0006                       ;------------------------------------------------------
0007                       copy  "rom.farjump.asm"        ; ROM bankswitch trampoline
     **** ****     > rom.farjump.asm
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
0021 7058 C13B  30         mov   *r11+,tmp0            ; P0
0022 705A C17B  30         mov   *r11+,tmp1            ; P1
0023 705C C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 705E 0649  14         dect  stack
0029 7060 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 7062 0649  14         dect  stack
0031 7064 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 7066 0649  14         dect  stack
0033 7068 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 706A 0649  14         dect  stack
0035 706C C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 706E 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     7070 6000     
0040 7072 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 7074 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     7076 A226     
0044 7078 0647  14         dect  tmp3
0045 707A C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 707C 0647  14         dect  tmp3
0047 707E C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 7080 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     7082 A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 7084 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 7086 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 7088 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 708A 0224  22         ai    tmp0,>0800
     708C 0800     
0066 708E 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 7090 0285  22         ci    tmp1,>ffff
     7092 FFFF     
0075 7094 1602  14         jne   !
0076 7096 C160  34         mov   @trmpvector,tmp1
     7098 A03A     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 709A C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 709C 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 709E 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 70A0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70A2 FFCE     
0091 70A4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70A6 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 70A8 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 70AA C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     70AC A226     
0102 70AE C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 70B0 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 70B2 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 70B4 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 70B6 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 70B8 028B  22         ci    r11,>6000
     70BA 6000     
0115 70BC 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 70BE 028B  22         ci    r11,>7fff
     70C0 7FFF     
0117 70C2 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 70C4 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     70C6 A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 70C8 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 70CA 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 70CC 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 70CE 0225  22         ai    tmp1,>0800
     70D0 0800     
0137 70D2 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 70D4 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 70D6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70D8 FFCE     
0144 70DA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70DC 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 70DE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 70E0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 70E2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 70E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 70E6 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0008                       copy  "fb.asm"                 ; Framebuffer
     **** ****     > fb.asm
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
0020 70E8 0649  14         dect  stack
0021 70EA C64B  30         mov   r11,*stack            ; Save return address
0022 70EC 0649  14         dect  stack
0023 70EE C644  30         mov   tmp0,*stack           ; Push tmp0
0024 70F0 0649  14         dect  stack
0025 70F2 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 70F4 0204  20         li    tmp0,fb.top
     70F6 D000     
0030 70F8 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     70FA A300     
0031 70FC 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     70FE A304     
0032 7100 04E0  34         clr   @fb.row               ; Current row=0
     7102 A306     
0033 7104 04E0  34         clr   @fb.column            ; Current column=0
     7106 A30C     
0034               
0035 7108 0204  20         li    tmp0,colrow
     710A 0050     
0036 710C C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     710E A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 7110 C160  34         mov   @tv.ruler.visible,tmp1
     7112 A210     
0041 7114 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 7116 0204  20         li    tmp0,pane.botrow-2
     7118 001B     
0043 711A 1002  14         jmp   fb.init.cont
0044 711C 0204  20 !       li    tmp0,pane.botrow-1
     711E 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 7120 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     7122 A31A     
0050 7124 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     7126 A31C     
0051               
0052 7128 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     712A A222     
0053 712C 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     712E A310     
0054 7130 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     7132 A316     
0055 7134 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     7136 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 7138 06A0  32         bl    @film
     713A 224A     
0060 713C D000             data  fb.top,>00,fb.size    ; Clear it all the way
     713E 0000     
     7140 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 7142 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 7144 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 7146 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 7148 045B  20         b     *r11                  ; Return to caller
0069               
                   < ram.resident.asm
0009                       copy  "idx.asm"                ; Index management
     **** ****     > idx.asm
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
0013               *  MSB = SAMS Page 40-ff
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
0027               *
0028               *
0029               * The index starts at SAMS page >20 and can allocate up to page >3f
0030               * for a total of 32 pages (128 K). With that up to 65536 lines of text
0031               * can be addressed.
0032               ***************************************************************
0033               
0034               
0035               ***************************************************************
0036               * idx.init
0037               * Initialize index
0038               ***************************************************************
0039               * bl @idx.init
0040               *--------------------------------------------------------------
0041               * INPUT
0042               * none
0043               *--------------------------------------------------------------
0044               * OUTPUT
0045               * none
0046               *--------------------------------------------------------------
0047               * Register usage
0048               * tmp0
0049               ********|*****|*********************|**************************
0050               idx.init:
0051 714A 0649  14         dect  stack
0052 714C C64B  30         mov   r11,*stack            ; Save return address
0053 714E 0649  14         dect  stack
0054 7150 C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 7152 0204  20         li    tmp0,idx.top
     7154 B000     
0059 7156 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7158 A502     
0060               
0061 715A C120  34         mov   @tv.sams.b000,tmp0
     715C A206     
0062 715E C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     7160 A600     
0063 7162 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     7164 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 7166 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     7168 0004     
0068 716A C804  38         mov   tmp0,@idx.sams.hipage ; /
     716C A604     
0069               
0070 716E 06A0  32         bl    @_idx.sams.mapcolumn.on
     7170 30CE     
0071                                                   ; Index in continuous memory region
0072               
0073 7172 06A0  32         bl    @film
     7174 224A     
0074 7176 B000                   data idx.top,>00,idx.size * 5
     7178 0000     
     717A 5000     
0075                                                   ; Clear index
0076               
0077 717C 06A0  32         bl    @_idx.sams.mapcolumn.off
     717E 3102     
0078                                                   ; Restore memory window layout
0079               
0080 7180 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     7182 A602     
     7184 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 7186 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 7188 C2F9  30         mov   *stack+,r11           ; Pop r11
0088 718A 045B  20         b     *r11                  ; Return to caller
0089               
0090               
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
0101 718C 0649  14         dect  stack
0102 718E C64B  30         mov   r11,*stack            ; Push return address
0103 7190 0649  14         dect  stack
0104 7192 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 7194 0649  14         dect  stack
0106 7196 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 7198 0649  14         dect  stack
0108 719A C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 719C C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     719E A602     
0113 71A0 0205  20         li    tmp1,idx.top
     71A2 B000     
0114 71A4 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     71A6 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 71A8 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     71AA 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 71AC 0584  14         inc   tmp0                  ; Next SAMS index page
0123 71AE 0225  22         ai    tmp1,>1000            ; Next memory region
     71B0 1000     
0124 71B2 0606  14         dec   tmp2                  ; Update loop counter
0125 71B4 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 71B6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 71B8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 71BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 71BC C2F9  30         mov   *stack+,r11           ; Pop return address
0134 71BE 045B  20         b     *r11                  ; Return to caller
0135               
0136               
0137               ***************************************************************
0138               * _idx.sams.mapcolumn.off
0139               * Restore normal SAMS layout again (single index page)
0140               ***************************************************************
0141               * bl @_idx.sams.mapcolumn.off
0142               *--------------------------------------------------------------
0143               * Register usage
0144               * tmp0, tmp1, tmp2, tmp3
0145               *--------------------------------------------------------------
0146               *  Remarks
0147               *  Private, only to be called from inside idx module
0148               ********|*****|*********************|**************************
0149               _idx.sams.mapcolumn.off:
0150 71C0 0649  14         dect  stack
0151 71C2 C64B  30         mov   r11,*stack            ; Push return address
0152 71C4 0649  14         dect  stack
0153 71C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 71C8 0649  14         dect  stack
0155 71CA C645  30         mov   tmp1,*stack           ; Push tmp1
0156 71CC 0649  14         dect  stack
0157 71CE C646  30         mov   tmp2,*stack           ; Push tmp2
0158 71D0 0649  14         dect  stack
0159 71D2 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 71D4 0205  20         li    tmp1,idx.top
     71D6 B000     
0164 71D8 0206  20         li    tmp2,5                ; Always 5 pages
     71DA 0005     
0165 71DC 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     71DE A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 71E0 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 71E2 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     71E4 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 71E6 0225  22         ai    tmp1,>1000            ; Next memory region
     71E8 1000     
0176 71EA 0606  14         dec   tmp2                  ; Update loop counter
0177 71EC 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 71EE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 71F0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 71F2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 71F4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 71F6 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 71F8 045B  20         b     *r11                  ; Return to caller
0188               
0189               
0190               
0191               ***************************************************************
0192               * _idx.samspage.get
0193               * Get SAMS page for index
0194               ***************************************************************
0195               * bl @_idx.samspage.get
0196               *--------------------------------------------------------------
0197               * INPUT
0198               * tmp0 = Line number
0199               *--------------------------------------------------------------
0200               * OUTPUT
0201               * @outparm1 = Offset for index entry in index SAMS page
0202               *--------------------------------------------------------------
0203               * Register usage
0204               * tmp0, tmp1, tmp2
0205               *--------------------------------------------------------------
0206               *  Remarks
0207               *  Private, only to be called from inside idx module.
0208               *  Activates SAMS page containing required index slot entry.
0209               ********|*****|*********************|**************************
0210               _idx.samspage.get:
0211 71FA 0649  14         dect  stack
0212 71FC C64B  30         mov   r11,*stack            ; Save return address
0213 71FE 0649  14         dect  stack
0214 7200 C644  30         mov   tmp0,*stack           ; Push tmp0
0215 7202 0649  14         dect  stack
0216 7204 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 7206 0649  14         dect  stack
0218 7208 C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 720A C184  18         mov   tmp0,tmp2             ; Line number
0223 720C 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 720E 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     7210 0800     
0225               
0226 7212 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 7214 0A16  56         sla   tmp2,1                ; line number * 2
0231 7216 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     7218 A010     
0232               
0233 721A A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     721C A602     
0234 721E 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     7220 A600     
0235               
0236 7222 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 7224 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     7226 A600     
0242 7228 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     722A A206     
0243 722C C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 722E 0205  20         li    tmp1,>b000            ; Memory window for index page
     7230 B000     
0246               
0247 7232 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     7234 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 7236 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     7238 A604     
0254 723A 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 723C C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     723E A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 7240 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 7242 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 7244 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 7246 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 7248 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0010                       copy  "edb.asm"                ; Editor Buffer
     **** ****     > edb.asm
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
0022 724A 0649  14         dect  stack
0023 724C C64B  30         mov   r11,*stack            ; Save return address
0024 724E 0649  14         dect  stack
0025 7250 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7252 0204  20         li    tmp0,edb.top          ; \
     7254 C000     
0030 7256 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     7258 A500     
0031 725A C804  38         mov   tmp0,@edb.next_free.ptr
     725C A508     
0032                                                   ; Set pointer to next free line
0033               
0034 725E 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7260 A50A     
0035               
0036 7262 0204  20         li    tmp0,1
     7264 0001     
0037 7266 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     7268 A504     
0038               
0039 726A 0720  34         seto  @edb.block.m1         ; Reset block start line
     726C A50C     
0040 726E 0720  34         seto  @edb.block.m2         ; Reset block end line
     7270 A50E     
0041               
0042 7272 0204  20         li    tmp0,txt.newfile      ; "New file"
     7274 37EC     
0043 7276 C804  38         mov   tmp0,@edb.filename.ptr
     7278 A512     
0044               
0045 727A 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     727C A440     
0046 727E 04E0  34         clr   @fh.kilobytes.prev    ; /
     7280 A45C     
0047               
0048 7282 0204  20         li    tmp0,txt.filetype.none
     7284 38A8     
0049 7286 C804  38         mov   tmp0,@edb.filetype.ptr
     7288 A514     
0050               
0051               edb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 728A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 728C C2F9  30         mov   *stack+,r11           ; Pop r11
0057 728E 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               
0061               
                   < ram.resident.asm
0011                       copy  "cmdb.asm"               ; Command buffer
     **** ****     > cmdb.asm
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
0022 7290 0649  14         dect  stack
0023 7292 C64B  30         mov   r11,*stack            ; Save return address
0024 7294 0649  14         dect  stack
0025 7296 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7298 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     729A E000     
0030 729C C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     729E A700     
0031               
0032 72A0 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     72A2 A702     
0033 72A4 0204  20         li    tmp0,4
     72A6 0004     
0034 72A8 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     72AA A706     
0035 72AC C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     72AE A708     
0036               
0037 72B0 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     72B2 A716     
0038 72B4 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     72B6 A718     
0039 72B8 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     72BA A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 72BC 06A0  32         bl    @film
     72BE 224A     
0044 72C0 E000             data  cmdb.top,>00,cmdb.size
     72C2 0000     
     72C4 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 72C6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 72C8 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 72CA 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0012                       copy  "errpane.asm"            ; Error pane
     **** ****     > errpane.asm
0001               * FILE......: errpane.asm
0002               * Purpose...: Error pane utilities
0003               
0004               ***************************************************************
0005               * errpane.init
0006               * Initialize error pane
0007               ***************************************************************
0008               * bl @errpane.init
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
0020               ***************************************************************
0021               errpane.init:
0022 72CC 0649  14         dect  stack
0023 72CE C64B  30         mov   r11,*stack            ; Save return address
0024 72D0 0649  14         dect  stack
0025 72D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 72D4 0649  14         dect  stack
0027 72D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 72D8 0649  14         dect  stack
0029 72DA C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 72DC 04E0  34         clr   @tv.error.visible     ; Set to hidden
     72DE A228     
0034 72E0 0204  20         li    tmp0,3
     72E2 0003     
0035 72E4 C804  38         mov   tmp0,@tv.error.rows   ; Number of rows in error pane
     72E6 A22A     
0036               
0037 72E8 06A0  32         bl    @film
     72EA 224A     
0038 72EC A22E                   data tv.error.msg,0,160
     72EE 0000     
     72F0 00A0     
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               errpane.exit:
0043 72F2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 72F4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 72F6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 72F8 C2F9  30         mov   *stack+,r11           ; Pop R11
0047 72FA 045B  20         b     *r11                  ; Return to caller
0048               
                   < ram.resident.asm
0013                       copy  "tv.asm"                 ; Main editor configuration
     **** ****     > tv.asm
0001               * FILE......: tv.asm
0002               * Purpose...: Initialize editor
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
0022 72FC 0649  14         dect  stack
0023 72FE C64B  30         mov   r11,*stack            ; Save return address
0024 7300 0649  14         dect  stack
0025 7302 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7304 0649  14         dect  stack
0027 7306 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 7308 0649  14         dect  stack
0029 730A C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 730C 0204  20         li    tmp0,1                ; \ Set default color scheme
     730E 0001     
0034 7310 C804  38         mov   tmp0,@tv.colorscheme  ; /
     7312 A212     
0035               
0036 7314 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     7316 A224     
0037 7318 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     731A 200C     
0038               
0039 731C 0204  20         li    tmp0,fj.bottom
     731E B000     
0040 7320 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     7322 A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 7324 06A0  32         bl    @cpym2m
     7326 24EE     
0045 7328 3980                   data def.printer.fname,tv.printer.fname,7
     732A D960     
     732C 0007     
0046               
0047 732E 06A0  32         bl    @cpym2m
     7330 24EE     
0048 7332 3988                   data def.clip.fname,tv.clip.fname,10
     7334 D9B0     
     7336 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 7338 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 733A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 733C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 733E C2F9  30         mov   *stack+,r11           ; Pop R11
0057 7340 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0014                       copy  "tv.quit.asm"            ; Exit Stevie and return to monitor
     **** ****     > tv.quit.asm
0001               * FILE......: tv.quit.asm
0002               * Purpose...: Quit Stevie and return to monitor
0003               
0004               ***************************************************************
0005               * tv.quit
0006               * Quit stevie and return to monitor
0007               ***************************************************************
0008               * b    @tv.quit
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ***************************************************************
0019               tv.quit:
0020                       ;-------------------------------------------------------
0021                       ; Reset/lock F18a
0022                       ;-------------------------------------------------------
0023 7342 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     7344 27BA     
0024                       ;-------------------------------------------------------
0025                       ; Load legacy SAMS page layout and exit to monitor
0026                       ;-------------------------------------------------------
0027 7346 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7348 2F9A     
0028 734A 600E                   data bank7.rom        ; | i  p0 = bank address
0029 734C 7FC0                   data bankx.vectab     ; | i  p1 = Vector with target address
0030 734E 6000                   data bankid           ; / i  p2 = Source ROM bank for return
0031               
0032                       ; We never return here. We call @mem.sams.set.legacy (vector1) and
0033                       ; in there activate bank 0 in cartridge space and return to monitor.
0034                       ;
0035                       ; Reason for doing so is that @tv.quit is located in
0036                       ; low memory expansion. So switching SAMS banks or turning off the SAMS
0037                       ; mapper results in invalid OPCODE's because the program just isn't
0038                       ; there in low memory expansion anymore.
                   < ram.resident.asm
0015                       copy  "tv.reset.asm"           ; Reset editor (clear buffers)
     **** ****     > tv.reset.asm
0001               * FILE......: tv.reset.asm
0002               * Purpose...: Reset editor (clear buffers)
0003               
0004               
0005               ***************************************************************
0006               * tv.reset
0007               * Reset editor (clear buffers)
0008               ***************************************************************
0009               * bl @tv.reset
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * r11
0019               *--------------------------------------------------------------
0020               * Notes
0021               ***************************************************************
0022               tv.reset:
0023 7350 0649  14         dect  stack
0024 7352 C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Reset editor
0027                       ;------------------------------------------------------
0028 7354 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     7356 31D2     
0029 7358 06A0  32         bl    @edb.init             ; Initialize editor buffer
     735A 318C     
0030 735C 06A0  32         bl    @idx.init             ; Initialize index
     735E 308C     
0031 7360 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7362 302A     
0032 7364 06A0  32         bl    @errpane.init         ; Initialize error pane
     7366 320E     
0033                       ;------------------------------------------------------
0034                       ; Remove markers and shortcuts
0035                       ;------------------------------------------------------
0036 7368 06A0  32         bl    @hchar
     736A 27E6     
0037 736C 0034                   byte 0,52,32,18           ; Remove markers
     736E 2012     
0038 7370 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     7372 2033     
0039 7374 FFFF                   data eol
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               tv.reset.exit:
0044 7376 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 7378 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0016                       copy  "tv.unpack.uint16.asm"   ; Unpack 16bit unsigned integer to string
     **** ****     > tv.unpack.uint16.asm
0001               * FILE......: tv.unpack.uint16.asm
0002               * Purpose...: Unpack 16bit unsigned integer to string
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
0020 737A 0649  14         dect  stack
0021 737C C64B  30         mov   r11,*stack            ; Save return address
0022 737E 0649  14         dect  stack
0023 7380 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 7382 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7384 29B6     
0028 7386 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 7388 A100                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 738A 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 738B   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 738C 0204  20         li    tmp0,unpacked.string
     738E A026     
0034 7390 04F4  30         clr   *tmp0+                ; Clear string 01
0035 7392 04F4  30         clr   *tmp0+                ; Clear string 23
0036 7394 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 7396 06A0  32         bl    @trimnum              ; Trim unsigned number string
     7398 2A0E     
0039 739A A100                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 739C A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 739E 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 73A0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 73A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 73A4 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0017                       copy  "tv.pad.string.asm"      ; Pad string to specified length
     **** ****     > tv.pad.string.asm
0001               * FILE......: tv.pad.string.asm
0002               * Purpose...: pad string to specified length
0003               
0004               
0005               ***************************************************************
0006               * tv.pad.string
0007               * pad string to specified length
0008               ***************************************************************
0009               * bl @tv.pad.string
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @parm1 = Pointer to length-prefixed string
0013               * @parm2 = Requested length
0014               * @parm3 = Fill character
0015               * @parm4 = Pointer to string buffer
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * @outparm1 = Pointer to padded string
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * none
0022               ***************************************************************
0023               tv.pad.string:
0024 73A6 0649  14         dect  stack
0025 73A8 C64B  30         mov   r11,*stack            ; Push return address
0026 73AA 0649  14         dect  stack
0027 73AC C644  30         mov   tmp0,*stack           ; Push tmp0
0028 73AE 0649  14         dect  stack
0029 73B0 C645  30         mov   tmp1,*stack           ; Push tmp1
0030 73B2 0649  14         dect  stack
0031 73B4 C646  30         mov   tmp2,*stack           ; Push tmp2
0032 73B6 0649  14         dect  stack
0033 73B8 C647  30         mov   tmp3,*stack           ; Push tmp3
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 73BA C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     73BC A000     
0038 73BE D194  26         movb  *tmp0,tmp2            ; /
0039 73C0 0986  56         srl   tmp2,8                ; Right align
0040 73C2 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0041               
0042 73C4 8806  38         c     tmp2,@parm2           ; String length > requested length?
     73C6 A002     
0043 73C8 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0044                       ;------------------------------------------------------
0045                       ; Copy string to buffer
0046                       ;------------------------------------------------------
0047 73CA C120  34         mov   @parm1,tmp0           ; Get source address
     73CC A000     
0048 73CE C160  34         mov   @parm4,tmp1           ; Get destination address
     73D0 A006     
0049 73D2 0586  14         inc   tmp2                  ; Also include length-byte in copy
0050               
0051 73D4 0649  14         dect  stack
0052 73D6 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0053               
0054 73D8 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     73DA 24F4     
0055                                                   ; \ i  tmp0 = Source CPU memory address
0056                                                   ; | i  tmp1 = Target CPU memory address
0057                                                   ; / i  tmp2 = Number of bytes to copy
0058               
0059 73DC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0060                       ;------------------------------------------------------
0061                       ; Set length of new string
0062                       ;------------------------------------------------------
0063 73DE C120  34         mov   @parm2,tmp0           ; Get requested length
     73E0 A002     
0064 73E2 0A84  56         sla   tmp0,8                ; Left align
0065 73E4 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     73E6 A006     
0066 73E8 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0067 73EA A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0068 73EC 0585  14         inc   tmp1                  ; /
0069                       ;------------------------------------------------------
0070                       ; Prepare for padding string
0071                       ;------------------------------------------------------
0072 73EE C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     73F0 A002     
0073 73F2 6187  18         s     tmp3,tmp2             ; |
0074 73F4 0586  14         inc   tmp2                  ; /
0075               
0076 73F6 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     73F8 A004     
0077 73FA 0A84  56         sla   tmp0,8                ; Left align
0078                       ;------------------------------------------------------
0079                       ; Right-pad string to destination length
0080                       ;------------------------------------------------------
0081               tv.pad.string.loop:
0082 73FC DD44  32         movb  tmp0,*tmp1+           ; Pad character
0083 73FE 0606  14         dec   tmp2                  ; Update loop counter
0084 7400 15FD  14         jgt   tv.pad.string.loop    ; Next character
0085               
0086 7402 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     7404 A006     
     7406 A010     
0087 7408 1004  14         jmp   tv.pad.string.exit    ; Exit
0088                       ;-----------------------------------------------------------------------
0089                       ; CPU crash
0090                       ;-----------------------------------------------------------------------
0091               tv.pad.string.panic:
0092 740A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     740C FFCE     
0093 740E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7410 2026     
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               tv.pad.string.exit:
0098 7412 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0099 7414 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 7416 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 7418 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 741A C2F9  30         mov   *stack+,r11           ; Pop r11
0103 741C 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0018                       ;-----------------------------------------------------------------------
0019                       ; Logic for Index management
0020                       ;-----------------------------------------------------------------------
0021                       copy  "idx.update.asm"         ; Index management - Update entry
     **** ****     > idx.update.asm
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
0022 741E 0649  14         dect  stack
0023 7420 C64B  30         mov   r11,*stack            ; Save return address
0024 7422 0649  14         dect  stack
0025 7424 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7426 0649  14         dect  stack
0027 7428 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 742A C120  34         mov   @parm1,tmp0           ; Get line number
     742C A000     
0032 742E C160  34         mov   @parm2,tmp1           ; Get pointer
     7430 A002     
0033 7432 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 7434 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     7436 0FFF     
0039 7438 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 743A 06E0  34         swpb  @parm3
     743C A004     
0044 743E D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     7440 A004     
0045 7442 06E0  34         swpb  @parm3                ; \ Restore original order again,
     7444 A004     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 7446 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     7448 313C     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 744A C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     744C A010     
0056 744E C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     7450 B000     
0057 7452 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     7454 A010     
0058 7456 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 7458 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     745A 313C     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 745C C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     745E A010     
0068 7460 04E4  34         clr   @idx.top(tmp0)        ; /
     7462 B000     
0069 7464 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     7466 A010     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 7468 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 746A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 746C C2F9  30         mov   *stack+,r11           ; Pop r11
0077 746E 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0022                       copy  "idx.pointer.asm"        ; Index management - Get pointer to line
     **** ****     > idx.pointer.asm
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
0021 7470 0649  14         dect  stack
0022 7472 C64B  30         mov   r11,*stack            ; Save return address
0023 7474 0649  14         dect  stack
0024 7476 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7478 0649  14         dect  stack
0026 747A C645  30         mov   tmp1,*stack           ; Push tmp1
0027 747C 0649  14         dect  stack
0028 747E C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 7480 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7482 A000     
0033               
0034 7484 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     7486 313C     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 7488 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     748A A010     
0039 748C C164  34         mov   @idx.top(tmp0),tmp1   ; /
     748E B000     
0040               
0041 7490 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 7492 C185  18         mov   tmp1,tmp2             ; \
0047 7494 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 7496 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     7498 00FF     
0052 749A 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 749C 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     749E C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 74A0 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     74A2 A010     
0059 74A4 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     74A6 A012     
0060 74A8 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 74AA 04E0  34         clr   @outparm1
     74AC A010     
0066 74AE 04E0  34         clr   @outparm2
     74B0 A012     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 74B2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 74B4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 74B6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 74B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 74BA 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0023                       copy  "idx.delete.asm"         ; Index management - delete slot
     **** ****     > idx.delete.asm
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
0017 74BC 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     74BE B000     
0018 74C0 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 74C2 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 74C4 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 74C6 0606  14         dec   tmp2                  ; tmp2--
0026 74C8 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 74CA 045B  20         b     *r11                  ; Return to caller
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
0046 74CC 0649  14         dect  stack
0047 74CE C64B  30         mov   r11,*stack            ; Save return address
0048 74D0 0649  14         dect  stack
0049 74D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 74D4 0649  14         dect  stack
0051 74D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 74D8 0649  14         dect  stack
0053 74DA C646  30         mov   tmp2,*stack           ; Push tmp2
0054 74DC 0649  14         dect  stack
0055 74DE C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 74E0 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     74E2 A000     
0060               
0061 74E4 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     74E6 313C     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 74E8 C120  34         mov   @outparm1,tmp0        ; Index offset
     74EA A010     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 74EC C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     74EE A002     
0070 74F0 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 74F2 61A0  34         s     @parm1,tmp2           ; Calculate loop
     74F4 A000     
0074 74F6 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 74F8 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     74FA B000     
0081 74FC 04D4  26         clr   *tmp0                 ; Clear index entry
0082 74FE 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 7500 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     7502 A002     
0088 7504 0287  22         ci    tmp3,2048
     7506 0800     
0089 7508 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 750A 06A0  32         bl    @_idx.sams.mapcolumn.on
     750C 30CE     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 750E C120  34         mov   @parm1,tmp0           ; Restore line number
     7510 A000     
0103 7512 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 7514 06A0  32         bl    @_idx.entry.delete.reorg
     7516 33FE     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 7518 06A0  32         bl    @_idx.sams.mapcolumn.off
     751A 3102     
0111                                                   ; Restore memory window layout
0112               
0113 751C 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 751E 06A0  32         bl    @_idx.entry.delete.reorg
     7520 33FE     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 7522 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 7524 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 7526 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 7528 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 752A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 752C C2F9  30         mov   *stack+,r11           ; Pop r11
0132 752E 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0024                       copy  "idx.insert.asm"         ; Index management - insert slot
     **** ****     > idx.insert.asm
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
0017 7530 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     7532 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 7534 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 7536 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7538 FFCE     
0027 753A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     753C 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 753E 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     7540 B000     
0032 7542 C144  18         mov   tmp0,tmp1             ; a = current slot
0033 7544 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 7546 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 7548 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 754A 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 754C 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 754E A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 7550 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     7552 AFFC     
0043 7554 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 7556 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7558 FFCE     
0049 755A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     755C 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 755E C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 7560 0644  14         dect  tmp0                  ; Move pointer up
0056 7562 0645  14         dect  tmp1                  ; Move pointer up
0057 7564 0606  14         dec   tmp2                  ; Next index entry
0058 7566 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 7568 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 756A 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 756C 045B  20         b     *r11                  ; Return to caller
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
0088 756E 0649  14         dect  stack
0089 7570 C64B  30         mov   r11,*stack            ; Save return address
0090 7572 0649  14         dect  stack
0091 7574 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 7576 0649  14         dect  stack
0093 7578 C645  30         mov   tmp1,*stack           ; Push tmp1
0094 757A 0649  14         dect  stack
0095 757C C646  30         mov   tmp2,*stack           ; Push tmp2
0096 757E 0649  14         dect  stack
0097 7580 C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 7582 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7584 A002     
0102 7586 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7588 A000     
0103 758A 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 758C C1E0  34         mov   @parm2,tmp3
     758E A002     
0110 7590 0287  22         ci    tmp3,2048
     7592 0800     
0111 7594 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 7596 06A0  32         bl    @_idx.sams.mapcolumn.on
     7598 30CE     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 759A C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     759C A002     
0123 759E 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 75A0 06A0  32         bl    @_idx.entry.insert.reorg
     75A2 3472     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 75A4 06A0  32         bl    @_idx.sams.mapcolumn.off
     75A6 3102     
0131                                                   ; Restore memory window layout
0132               
0133 75A8 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 75AA C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     75AC A002     
0139               
0140 75AE 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     75B0 313C     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 75B2 C120  34         mov   @outparm1,tmp0        ; Index offset
     75B4 A010     
0145               
0146 75B6 06A0  32         bl    @_idx.entry.insert.reorg
     75B8 3472     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 75BA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 75BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 75BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 75C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 75C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0160 75C4 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0025                       ;-----------------------------------------------------------------------
0026                       ; Logic for editor buffer
0027                       ;-----------------------------------------------------------------------
0028                       copy  "edb.line.mappage.asm"   ; Activate edbuf SAMS page for line
     **** ****     > edb.line.mappage.asm
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
0021 75C6 0649  14         dect  stack
0022 75C8 C64B  30         mov   r11,*stack            ; Push return address
0023 75CA 0649  14         dect  stack
0024 75CC C644  30         mov   tmp0,*stack           ; Push tmp0
0025 75CE 0649  14         dect  stack
0026 75D0 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 75D2 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     75D4 A504     
0031 75D6 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 75D8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     75DA FFCE     
0037 75DC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     75DE 2026     
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 75E0 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     75E2 A000     
0043               
0044 75E4 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     75E6 33B2     
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 75E8 C120  34         mov   @outparm2,tmp0        ; SAMS page
     75EA A012     
0050 75EC C160  34         mov   @outparm1,tmp1        ; Pointer to line
     75EE A010     
0051 75F0 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 75F2 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     75F4 A208     
0057 75F6 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 75F8 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     75FA 258A     
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 75FC C820  54         mov   @outparm2,@tv.sams.c000
     75FE A012     
     7600 A208     
0066                                                   ; Set page in shadow registers
0067               
0068 7602 C820  54         mov   @outparm2,@edb.sams.page
     7604 A012     
     7606 A516     
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 7608 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 760A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 760C C2F9  30         mov   *stack+,r11           ; Pop r11
0077 760E 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0029                       copy  "edb.line.getlen.asm"    ; Get line length
     **** ****     > edb.line.getlen.asm
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
0021 7610 0649  14         dect  stack
0022 7612 C64B  30         mov   r11,*stack            ; Push return address
0023 7614 0649  14         dect  stack
0024 7616 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7618 0649  14         dect  stack
0026 761A C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 761C 04E0  34         clr   @outparm1             ; Reset length
     761E A010     
0031 7620 04E0  34         clr   @outparm2             ; Reset SAMS bank
     7622 A012     
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 7624 C120  34         mov   @parm1,tmp0           ; \
     7626 A000     
0036 7628 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 762A 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     762C A504     
0039 762E 1101  14         jlt   !                     ; No, continue processing
0040 7630 100F  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 7632 C120  34 !       mov   @parm1,tmp0           ; Get line
     7634 A000     
0046               
0047 7636 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     7638 3508     
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 763A C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     763C A010     
0053 763E 1308  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 7640 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 7642 C805  38         mov   tmp1,@outparm1        ; Save length
     7644 A010     
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 7646 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     7648 0050     
0064 764A 1204  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system or limit length to 80
0068                       ;------------------------------------------------------
0073 764C 0205  20         li    tmp1,80               ; Only process first 80 characters
     764E 0050     
0075                       ;------------------------------------------------------
0076                       ; Set length to 0 if null-pointer
0077                       ;------------------------------------------------------
0078               edb.line.getlength.null:
0079 7650 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     7652 A010     
0080                       ;------------------------------------------------------
0081                       ; Exit
0082                       ;------------------------------------------------------
0083               edb.line.getlength.exit:
0084 7654 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0085 7656 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0086 7658 C2F9  30         mov   *stack+,r11           ; Pop r11
0087 765A 045B  20         b     *r11                  ; Return to caller
0088               
0089               
0090               
0091               ***************************************************************
0092               * edb.line.getlength2
0093               * Get length of current row (as seen from editor buffer side)
0094               ***************************************************************
0095               *  bl   @edb.line.getlength2
0096               *--------------------------------------------------------------
0097               * INPUT
0098               * @fb.row = Row in frame buffer
0099               *--------------------------------------------------------------
0100               * OUTPUT
0101               * @fb.row.length = Length of row
0102               *--------------------------------------------------------------
0103               * Register usage
0104               * tmp0
0105               ********|*****|*********************|**************************
0106               edb.line.getlength2:
0107 765C 0649  14         dect  stack
0108 765E C64B  30         mov   r11,*stack            ; Save return address
0109 7660 0649  14         dect  stack
0110 7662 C644  30         mov   tmp0,*stack           ; Push tmp0
0111                       ;------------------------------------------------------
0112                       ; Calculate line in editor buffer
0113                       ;------------------------------------------------------
0114 7664 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7666 A304     
0115 7668 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     766A A306     
0116                       ;------------------------------------------------------
0117                       ; Get length
0118                       ;------------------------------------------------------
0119 766C C804  38         mov   tmp0,@parm1
     766E A000     
0120 7670 06A0  32         bl    @edb.line.getlength
     7672 3552     
0121 7674 C820  54         mov   @outparm1,@fb.row.length
     7676 A010     
     7678 A308     
0122                                                   ; Save row length
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               edb.line.getlength2.exit:
0127 767A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 767C C2F9  30         mov   *stack+,r11           ; Pop R11
0129 767E 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0030                       ;-----------------------------------------------------------------------
0031                       ; Utility functions
0032                       ;-----------------------------------------------------------------------
0033                       copy  "pane.topline.clearmsg.asm"
     **** ****     > pane.topline.clearmsg.asm
0001               * FILE......: pane.topline.clearmsg.asm
0002               * Purpose...: One-shot task for clearing overlay message in top line
0003               
0004               
0005               ***************************************************************
0006               * pane.topline.oneshot.clearmsg
0007               * Remove overlay message in top line
0008               ***************************************************************
0009               * Runs as one-shot task in slot 3
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * none
0019               ********|*****|*********************|**************************
0020               pane.topline.oneshot.clearmsg:
0021 7680 0649  14         dect  stack
0022 7682 C64B  30         mov   r11,*stack            ; Push return address
0023 7684 0649  14         dect  stack
0024 7686 C660  46         mov   @wyx,*stack           ; Push cursor position
     7688 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 768A 06A0  32         bl    @hchar
     768C 27E6     
0029 768E 0034                   byte 0,52,32,18
     7690 2012     
0030 7692 FFFF                   data EOL              ; Clear message
0031               
0032 7694 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     7696 A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 7698 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     769A 832A     
0038 769C C2F9  30         mov   *stack+,r11           ; Pop R11
0039 769E 045B  20         b     *r11                  ; Return to task
                   < ram.resident.asm
0034                                                      ; Remove overlay messsage in top line
0035                       ;------------------------------------------------------
0036                       ; Program data
0037                       ;------------------------------------------------------
0038                       copy  "data.constants.asm"     ; Constants
     **** ****     > data.constants.asm
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
0032               stevie.80x30:
0033 76A0 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     76A2 003F     
     76A4 0243     
     76A6 05F4     
     76A8 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 76AA 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     76AC 000C     
     76AE 0006     
     76B0 0007     
     76B2 0020     
0041               *
0042               * ; VDP#0 Control bits
0043               * ;      bit 6=0: M3 | Graphics 1 mode
0044               * ;      bit 7=0: Disable external VDP input
0045               * ; VDP#1 Control bits
0046               * ;      bit 0=1: 16K selection
0047               * ;      bit 1=1: Enable display
0048               * ;      bit 2=1: Enable VDP interrupt
0049               * ;      bit 3=0: M1 \ Graphics 1 mode
0050               * ;      bit 4=0: M2 /
0051               * ;      bit 5=0: reserved
0052               * ;      bit 6=1: 16x16 sprites
0053               * ;      bit 7=0: Sprite magnification (1x)
0054               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0055               * ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
0056               * ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
0057               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0058               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0059               * ; VDP#7 Set screen background color
0060               
0061               
0062               
0063               ***************************************************************
0064               * TI Basic mode (32 columns/30 rows) - F18A
0065               *--------------------------------------------------------------
0066               tibasic.32x30:
0067 76B4 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     76B6 000C     
     76B8 0006     
     76BA 0007     
     76BC 0020     
0068               *
0069               * ; VDP#0 Control bits
0070               * ;      bit 6=0: M3 | Graphics 1 mode
0071               * ;      bit 7=0: Disable external VDP input
0072               * ; VDP#1 Control bits
0073               * ;      bit 0=1: 16K selection
0074               * ;      bit 1=1: Enable display
0075               * ;      bit 2=1: Enable VDP interrupt
0076               * ;      bit 3=0: M1 \ Graphics 1 mode
0077               * ;      bit 4=0: M2 /
0078               * ;      bit 5=0: reserved
0079               * ;      bit 6=1: 16x16 sprites
0080               * ;      bit 7=0: Sprite magnification (1x)
0081               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0082               * ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
0083               * ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
0084               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0085               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0086               * ; VDP#7 Set screen background color
0087               * ;
0088               * ; The table by itself is not sufficient for turning on 30 rows
0089               * ; mode. You also need to unlock the F18a and set VR49 (>31) to
0090               * ; value >40.
0091               
0092               
0093               ***************************************************************
0094               * Sprite Attribute Table
0095               *--------------------------------------------------------------
0096               romsat:
0097                                                   ; YX, initial shape and color
0098 76BE 0000             data  >0000,>0001           ; Cursor
     76C0 0001     
0099 76C2 0000             data  >0000,>0101           ; Current line indicator     <
     76C4 0101     
0100 76C6 0820             data  >0820,>0201           ; Current column indicator   v
     76C8 0201     
0101               nosprite:
0102 76CA D000             data  >d000                 ; End-of-Sprites list
0103               
0104               
0105               
0106               
0107               ***************************************************************
0108               * Stevie color schemes table
0109               *--------------------------------------------------------------
0110               * Word 1
0111               * A  MSB  high-nibble    Foreground color text line in frame buffer
0112               * B  MSB  low-nibble     Background color text line in frame buffer
0113               * C  LSB  high-nibble    Foreground color top/bottom line
0114               * D  LSB  low-nibble     Background color top/bottom line
0115               *
0116               * Word 2
0117               * E  MSB  high-nibble    Foreground color cmdb pane
0118               * F  MSB  low-nibble     Background color cmdb pane
0119               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0120               * H  LSB  low-nibble     Cursor foreground color frame buffer
0121               *
0122               * Word 3
0123               * I  MSB  high-nibble    Foreground color busy top/bottom line
0124               * J  MSB  low-nibble     Background color busy top/bottom line
0125               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0126               * L  LSB  low-nibble     Background color marked line in frame buffer
0127               *
0128               * Word 4
0129               * M  MSB  high-nibble    Foreground color command buffer header line
0130               * N  MSB  low-nibble     Background color command buffer header line
0131               * O  LSB  high-nibble    Foreground color line+column indicator frame buffer
0132               * P  LSB  low-nibble     Foreground color ruler frame buffer
0133               *
0134               * Colors
0135               * 0  Transparant
0136               * 1  black
0137               * 2  Green
0138               * 3  Light Green
0139               * 4  Blue
0140               * 5  Light Blue
0141               * 6  Dark Red
0142               * 7  Cyan
0143               * 8  Red
0144               * 9  Light Red
0145               * A  Yellow
0146               * B  Light Yellow
0147               * C  Dark Green
0148               * D  Magenta
0149               * E  Grey
0150               * F  White
0151               *--------------------------------------------------------------
0152      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0153               
0154               tv.colorscheme.table:
0155                       ;                             ; #
0156                       ;      ABCD  EFGH  IJKL  MNOP ; -
0157 76CC F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     76CE F171     
     76D0 1B1F     
     76D2 71B1     
0158 76D4 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     76D6 F0FF     
     76D8 1F1A     
     76DA F1FF     
0159 76DC 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     76DE F0FF     
     76E0 1F12     
     76E2 F1F6     
0160 76E4 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     76E6 1E11     
     76E8 1A17     
     76EA 1E11     
0161 76EC E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     76EE E1FF     
     76F0 1F1E     
     76F2 E1FF     
0162 76F4 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     76F6 1016     
     76F8 1B71     
     76FA 1711     
0163 76FC 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     76FE 1011     
     7700 F1F1     
     7702 1F11     
0164 7704 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     7706 A1FF     
     7708 1F1F     
     770A F11F     
0165 770C 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     770E 12FF     
     7710 1B12     
     7712 12FF     
0166 7714 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     7716 E1FF     
     7718 1B1F     
     771A F131     
0167                       even
0168               
0169               tv.tabs.table:
0170 771C 0007             byte  0,7,12,25               ; \   Default tab positions as used
     771E 0C19     
0171 7720 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     7722 3B4F     
0172 7724 FF00             byte  >ff,0,0,0               ; |
     7726 0000     
0173 7728 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     772A 0000     
0174 772C 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     772E 0000     
0175                       even
                   < ram.resident.asm
0039                       copy  "data.strings.asm"       ; Strings
     **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               txt.delim
0009 7730 01               byte  1
0010 7731   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 7732 05               byte  5
0015 7733   20             text  '  BOT'
     7734 2042     
     7736 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 7738 03               byte  3
0020 7739   4F             text  'OVR'
     773A 5652     
0021                       even
0022               
0023               txt.insert
0024 773C 03               byte  3
0025 773D   49             text  'INS'
     773E 4E53     
0026                       even
0027               
0028               txt.star
0029 7740 01               byte  1
0030 7741   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 7742 0A               byte  10
0035 7743   4C             text  'Loading...'
     7744 6F61     
     7746 6469     
     7748 6E67     
     774A 2E2E     
     774C 2E       
0036                       even
0037               
0038               txt.saving
0039 774E 0A               byte  10
0040 774F   53             text  'Saving....'
     7750 6176     
     7752 696E     
     7754 672E     
     7756 2E2E     
     7758 2E       
0041                       even
0042               
0043               txt.printing
0044 775A 12               byte  18
0045 775B   50             text  'Printing file.....'
     775C 7269     
     775E 6E74     
     7760 696E     
     7762 6720     
     7764 6669     
     7766 6C65     
     7768 2E2E     
     776A 2E2E     
     776C 2E       
0046                       even
0047               
0048               txt.block.del
0049 776E 12               byte  18
0050 776F   44             text  'Deleting block....'
     7770 656C     
     7772 6574     
     7774 696E     
     7776 6720     
     7778 626C     
     777A 6F63     
     777C 6B2E     
     777E 2E2E     
     7780 2E       
0051                       even
0052               
0053               txt.block.copy
0054 7782 11               byte  17
0055 7783   43             text  'Copying block....'
     7784 6F70     
     7786 7969     
     7788 6E67     
     778A 2062     
     778C 6C6F     
     778E 636B     
     7790 2E2E     
     7792 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 7794 10               byte  16
0060 7795   4D             text  'Moving block....'
     7796 6F76     
     7798 696E     
     779A 6720     
     779C 626C     
     779E 6F63     
     77A0 6B2E     
     77A2 2E2E     
     77A4 2E       
0061                       even
0062               
0063               txt.block.save
0064 77A6 18               byte  24
0065 77A7   53             text  'Saving block to file....'
     77A8 6176     
     77AA 696E     
     77AC 6720     
     77AE 626C     
     77B0 6F63     
     77B2 6B20     
     77B4 746F     
     77B6 2066     
     77B8 696C     
     77BA 652E     
     77BC 2E2E     
     77BE 2E       
0066                       even
0067               
0068               txt.block.clip
0069 77C0 18               byte  24
0070 77C1   43             text  'Copying to clipboard....'
     77C2 6F70     
     77C4 7969     
     77C6 6E67     
     77C8 2074     
     77CA 6F20     
     77CC 636C     
     77CE 6970     
     77D0 626F     
     77D2 6172     
     77D4 642E     
     77D6 2E2E     
     77D8 2E       
0071                       even
0072               
0073               txt.block.print
0074 77DA 12               byte  18
0075 77DB   50             text  'Printing block....'
     77DC 7269     
     77DE 6E74     
     77E0 696E     
     77E2 6720     
     77E4 626C     
     77E6 6F63     
     77E8 6B2E     
     77EA 2E2E     
     77EC 2E       
0076                       even
0077               
0078               txt.clearmem
0079 77EE 13               byte  19
0080 77EF   43             text  'Clearing memory....'
     77F0 6C65     
     77F2 6172     
     77F4 696E     
     77F6 6720     
     77F8 6D65     
     77FA 6D6F     
     77FC 7279     
     77FE 2E2E     
     7800 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 7802 0E               byte  14
0085 7803   4C             text  'Load completed'
     7804 6F61     
     7806 6420     
     7808 636F     
     780A 6D70     
     780C 6C65     
     780E 7465     
     7810 64       
0086                       even
0087               
0088               txt.done.insert
0089 7812 10               byte  16
0090 7813   49             text  'Insert completed'
     7814 6E73     
     7816 6572     
     7818 7420     
     781A 636F     
     781C 6D70     
     781E 6C65     
     7820 7465     
     7822 64       
0091                       even
0092               
0093               txt.done.append
0094 7824 10               byte  16
0095 7825   41             text  'Append completed'
     7826 7070     
     7828 656E     
     782A 6420     
     782C 636F     
     782E 6D70     
     7830 6C65     
     7832 7465     
     7834 64       
0096                       even
0097               
0098               txt.done.save
0099 7836 0E               byte  14
0100 7837   53             text  'Save completed'
     7838 6176     
     783A 6520     
     783C 636F     
     783E 6D70     
     7840 6C65     
     7842 7465     
     7844 64       
0101                       even
0102               
0103               txt.done.copy
0104 7846 0E               byte  14
0105 7847   43             text  'Copy completed'
     7848 6F70     
     784A 7920     
     784C 636F     
     784E 6D70     
     7850 6C65     
     7852 7465     
     7854 64       
0106                       even
0107               
0108               txt.done.print
0109 7856 0F               byte  15
0110 7857   50             text  'Print completed'
     7858 7269     
     785A 6E74     
     785C 2063     
     785E 6F6D     
     7860 706C     
     7862 6574     
     7864 6564     
0111                       even
0112               
0113               txt.done.delete
0114 7866 10               byte  16
0115 7867   44             text  'Delete completed'
     7868 656C     
     786A 6574     
     786C 6520     
     786E 636F     
     7870 6D70     
     7872 6C65     
     7874 7465     
     7876 64       
0116                       even
0117               
0118               txt.done.clipboard
0119 7878 0F               byte  15
0120 7879   43             text  'Clipboard saved'
     787A 6C69     
     787C 7062     
     787E 6F61     
     7880 7264     
     7882 2073     
     7884 6176     
     7886 6564     
0121                       even
0122               
0123               txt.done.clipdev
0124 7888 0D               byte  13
0125 7889   43             text  'Clipboard set'
     788A 6C69     
     788C 7062     
     788E 6F61     
     7890 7264     
     7892 2073     
     7894 6574     
0126                       even
0127               
0128               txt.fastmode
0129 7896 08               byte  8
0130 7897   46             text  'Fastmode'
     7898 6173     
     789A 746D     
     789C 6F64     
     789E 65       
0131                       even
0132               
0133               txt.kb
0134 78A0 02               byte  2
0135 78A1   6B             text  'kb'
     78A2 62       
0136                       even
0137               
0138               txt.lines
0139 78A4 05               byte  5
0140 78A5   4C             text  'Lines'
     78A6 696E     
     78A8 6573     
0141                       even
0142               
0143               txt.newfile
0144 78AA 0A               byte  10
0145 78AB   5B             text  '[New file]'
     78AC 4E65     
     78AE 7720     
     78B0 6669     
     78B2 6C65     
     78B4 5D       
0146                       even
0147               
0148               txt.filetype.dv80
0149 78B6 04               byte  4
0150 78B7   44             text  'DV80'
     78B8 5638     
     78BA 30       
0151                       even
0152               
0153               txt.m1
0154 78BC 03               byte  3
0155 78BD   4D             text  'M1='
     78BE 313D     
0156                       even
0157               
0158               txt.m2
0159 78C0 03               byte  3
0160 78C1   4D             text  'M2='
     78C2 323D     
0161                       even
0162               
0163               txt.keys.default
0164 78C4 07               byte  7
0165 78C5   46             text  'F9-Menu'
     78C6 392D     
     78C8 4D65     
     78CA 6E75     
0166                       even
0167               
0168               txt.keys.block
0169 78CC 36               byte  54
0170 78CD   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     78CE 392D     
     78D0 4261     
     78D2 636B     
     78D4 2020     
     78D6 5E43     
     78D8 6F70     
     78DA 7920     
     78DC 205E     
     78DE 4D6F     
     78E0 7665     
     78E2 2020     
     78E4 5E44     
     78E6 656C     
     78E8 2020     
     78EA 5E53     
     78EC 6176     
     78EE 6520     
     78F0 205E     
     78F2 5072     
     78F4 696E     
     78F6 7420     
     78F8 205E     
     78FA 5B31     
     78FC 2D35     
     78FE 5D43     
     7900 6C69     
     7902 70       
0171                       even
0172               
0173 7904 2E2E     txt.ruler          text    '.........'
     7906 2E2E     
     7908 2E2E     
     790A 2E2E     
     790C 2E       
0174 790D   12                        byte    18
0175 790E 2E2E                        text    '.........'
     7910 2E2E     
     7912 2E2E     
     7914 2E2E     
     7916 2E       
0176 7917   13                        byte    19
0177 7918 2E2E                        text    '.........'
     791A 2E2E     
     791C 2E2E     
     791E 2E2E     
     7920 2E       
0178 7921   14                        byte    20
0179 7922 2E2E                        text    '.........'
     7924 2E2E     
     7926 2E2E     
     7928 2E2E     
     792A 2E       
0180 792B   15                        byte    21
0181 792C 2E2E                        text    '.........'
     792E 2E2E     
     7930 2E2E     
     7932 2E2E     
     7934 2E       
0182 7935   16                        byte    22
0183 7936 2E2E                        text    '.........'
     7938 2E2E     
     793A 2E2E     
     793C 2E2E     
     793E 2E       
0184 793F   17                        byte    23
0185 7940 2E2E                        text    '.........'
     7942 2E2E     
     7944 2E2E     
     7946 2E2E     
     7948 2E       
0186 7949   18                        byte    24
0187 794A 2E2E                        text    '.........'
     794C 2E2E     
     794E 2E2E     
     7950 2E2E     
     7952 2E       
0188 7953   19                        byte    25
0189                                  even
0190 7954 020E     txt.alpha.down     data >020e,>0f00
     7956 0F00     
0191 7958 0110     txt.vertline       data >0110
0192 795A 011C     txt.keymarker      byte 1,28
0193               
0194               txt.ws1
0195 795C 01               byte  1
0196 795D   20             text  ' '
0197                       even
0198               
0199               txt.ws2
0200 795E 02               byte  2
0201 795F   20             text  '  '
     7960 20       
0202                       even
0203               
0204               txt.ws3
0205 7962 03               byte  3
0206 7963   20             text  '   '
     7964 2020     
0207                       even
0208               
0209               txt.ws4
0210 7966 04               byte  4
0211 7967   20             text  '    '
     7968 2020     
     796A 20       
0212                       even
0213               
0214               txt.ws5
0215 796C 05               byte  5
0216 796D   20             text  '     '
     796E 2020     
     7970 2020     
0217                       even
0218               
0219      38A8     txt.filetype.none  equ txt.ws4
0220               
0221               
0222               ;--------------------------------------------------------------
0223               ; Strings for error line pane
0224               ;--------------------------------------------------------------
0225               txt.ioerr.load
0226 7972 15               byte  21
0227 7973   46             text  'Failed loading file: '
     7974 6169     
     7976 6C65     
     7978 6420     
     797A 6C6F     
     797C 6164     
     797E 696E     
     7980 6720     
     7982 6669     
     7984 6C65     
     7986 3A20     
0228                       even
0229               
0230               txt.ioerr.save
0231 7988 14               byte  20
0232 7989   46             text  'Failed saving file: '
     798A 6169     
     798C 6C65     
     798E 6420     
     7990 7361     
     7992 7669     
     7994 6E67     
     7996 2066     
     7998 696C     
     799A 653A     
     799C 20       
0233                       even
0234               
0235               txt.ioerr.print
0236 799E 1B               byte  27
0237 799F   46             text  'Failed printing to device: '
     79A0 6169     
     79A2 6C65     
     79A4 6420     
     79A6 7072     
     79A8 696E     
     79AA 7469     
     79AC 6E67     
     79AE 2074     
     79B0 6F20     
     79B2 6465     
     79B4 7669     
     79B6 6365     
     79B8 3A20     
0238                       even
0239               
0240               txt.io.nofile
0241 79BA 16               byte  22
0242 79BB   4E             text  'No filename specified.'
     79BC 6F20     
     79BE 6669     
     79C0 6C65     
     79C2 6E61     
     79C4 6D65     
     79C6 2073     
     79C8 7065     
     79CA 6369     
     79CC 6669     
     79CE 6564     
     79D0 2E       
0243                       even
0244               
0245               txt.memfull.load
0246 79D2 2D               byte  45
0247 79D3   49             text  'Index full. File too large for editor buffer.'
     79D4 6E64     
     79D6 6578     
     79D8 2066     
     79DA 756C     
     79DC 6C2E     
     79DE 2046     
     79E0 696C     
     79E2 6520     
     79E4 746F     
     79E6 6F20     
     79E8 6C61     
     79EA 7267     
     79EC 6520     
     79EE 666F     
     79F0 7220     
     79F2 6564     
     79F4 6974     
     79F6 6F72     
     79F8 2062     
     79FA 7566     
     79FC 6665     
     79FE 722E     
0248                       even
0249               
0250               txt.block.inside
0251 7A00 2D               byte  45
0252 7A01   43             text  'Copy/Move target must be outside M1-M2 range.'
     7A02 6F70     
     7A04 792F     
     7A06 4D6F     
     7A08 7665     
     7A0A 2074     
     7A0C 6172     
     7A0E 6765     
     7A10 7420     
     7A12 6D75     
     7A14 7374     
     7A16 2062     
     7A18 6520     
     7A1A 6F75     
     7A1C 7473     
     7A1E 6964     
     7A20 6520     
     7A22 4D31     
     7A24 2D4D     
     7A26 3220     
     7A28 7261     
     7A2A 6E67     
     7A2C 652E     
0253                       even
0254               
0255               
0256               ;--------------------------------------------------------------
0257               ; Strings for command buffer
0258               ;--------------------------------------------------------------
0259               txt.cmdb.prompt
0260 7A2E 01               byte  1
0261 7A2F   3E             text  '>'
0262                       even
0263               
0264               txt.colorscheme
0265 7A30 0D               byte  13
0266 7A31   43             text  'Color scheme:'
     7A32 6F6C     
     7A34 6F72     
     7A36 2073     
     7A38 6368     
     7A3A 656D     
     7A3C 653A     
0267                       even
0268               
                   < ram.resident.asm
0040                       copy  "data.defaults.asm"      ; Default values (devices, ...)
     **** ****     > data.defaults.asm
0001               * FILE......: data.defaults.asm
0002               * Purpose...: Default values for Stevie
0003               
0004               ***************************************************************
0005               *                     Default values
0006               ********|*****|*********************|**************************
0007               def.printer.fname
0008 7A3E 06               byte  6
0009 7A3F   50             text  'PI.PIO'
     7A40 492E     
     7A42 5049     
     7A44 4F       
0010                       even
0011               
0012               def.clip.fname
0013 7A46 09               byte  9
0014 7A47   44             text  'DSK1.CLIP'
     7A48 534B     
     7A4A 312E     
     7A4C 434C     
     7A4E 4950     
0015                       even
0016               
0017               def.clip.fname.b
0018 7A50 09               byte  9
0019 7A51   44             text  'DSK2.CLIP'
     7A52 534B     
     7A54 322E     
     7A56 434C     
     7A58 4950     
0020                       even
0021               
0022               def.clip.fname.c
0023 7A5A 09               byte  9
0024 7A5B   54             text  'TIPI.CLIP'
     7A5C 4950     
     7A5E 492E     
     7A60 434C     
     7A62 4950     
0025                       even
0026               
0027               def.devices
0028 7A64 2F               byte  47
0029 7A65   2C             text  ',DSK,HDX,IDE,PI.,PIO,TIPI.,RD,SCS,SDD,WDS,RS232'
     7A66 4453     
     7A68 4B2C     
     7A6A 4844     
     7A6C 582C     
     7A6E 4944     
     7A70 452C     
     7A72 5049     
     7A74 2E2C     
     7A76 5049     
     7A78 4F2C     
     7A7A 5449     
     7A7C 5049     
     7A7E 2E2C     
     7A80 5244     
     7A82 2C53     
     7A84 4353     
     7A86 2C53     
     7A88 4444     
     7A8A 2C57     
     7A8C 4453     
     7A8E 2C52     
     7A90 5332     
     7A92 3332     
0030                       even
0031               
                   < ram.resident.asm
                   < stevie_b0.asm.57700
0110                       ;------------------------------------------------------
0111                       ; Stevie main entry point
0112                       ;------------------------------------------------------
0113               main:
0114 7A94 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     7A96 6002     
0115               
0119               
0120 7A98 0460  28         b     @kickstart.code2      ; Jump to entry routine >6046
     7A9A 6046     
0121                       ;------------------------------------------------------
0122                       ; Memory full check
0123                       ;------------------------------------------------------
0125               
0129 7A9C 39DE                   data $                ; Bank 0 ROM size OK.
0131                       ;-----------------------------------------------------------------------
0132                       ; Show bank in CPU crash screen
0133                       ;-----------------------------------------------------------------------
0134               cpu.crash.showbank:
0135                       aorg >7fb0
0136 7FB0 06A0  32         bl    @putat
     7FB2 2456     
0137 7FB4 0314                   byte 3,20
0138 7FB6 7FBA                   data cpu.crash.showbank.bankstr
0139 7FB8 10FF  14         jmp   $
0140               cpu.crash.showbank.bankstr:
0141               
0142 7FBA 05               byte  5
0143 7FBB   52             text  'ROM#0'
     7FBC 4F4D     
     7FBE 2330     
0144                       even
0145               
0146               *--------------------------------------------------------------
0147               * Video mode configuration for SP2
0148               *--------------------------------------------------------------
0149      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0150      0004     spfbck  equ   >04                   ; Screen background color.
0151      35E2     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0152      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0153      0050     colrow  equ   80                    ; Columns per row
0154      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0155      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0156      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0157      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

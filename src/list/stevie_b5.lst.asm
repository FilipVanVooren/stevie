XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b5.asm.60011
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2022 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b5.asm               ; Version 220116-1949060
0010               *
0011               * Bank 5 "Jumbo"
0012               * Editor Buffer methods delegated from bank 1
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
                   < stevie_b5.asm.60011
0015                       copy  "rom.order.asm"       ; ROM bank order "non-inverted"
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
                   < stevie_b5.asm.60011
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
                   < stevie_b5.asm.60011
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
                   < stevie_b5.asm.60011
0018               
0019               ***************************************************************
0020               * BANK 5
0021               ********|*****|*********************|**************************
0022      600A     bankid  equ   bank5.rom             ; Set bank identifier to current bank
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
                   < stevie_b5.asm.60011
0026               
0027               ***************************************************************
0028               * Step 1: Switch to bank 0 (uniform code accross all banks)
0029               ********|*****|*********************|**************************
0030                       aorg  kickstart.code1       ; >6040
0031 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000     
0032               ***************************************************************
0033               * Step 2: Satisfy assembler, must know relocated code
0034               ********|*****|*********************|**************************
0035                       aorg  >2000                 ; Relocate to >2000
0036                       copy  "runlib.asm"
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
     2084 2EE0     
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 230C     
0078 208A 2206                   data graph1           ; \ i  p0 = pointer to video mode table
0079                                                   ; /
0080               
0081 208C 06A0  32         bl    @ldfnt
     208E 2374     
0082 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C     
0083               
0084 2094 06A0  32         bl    @filv
     2096 22A2     
0085 2098 0000                   data >0000,32,32*24   ; Clear screen
     209A 0020     
     209C 0300     
0086               
0087 209E 06A0  32         bl    @filv
     20A0 22A2     
0088 20A2 0380                   data >0380,>f0,32*24  ; Load color table
     20A4 00F0     
     20A6 0300     
0089                       ;------------------------------------------------------
0090                       ; Show crash address
0091                       ;------------------------------------------------------
0092 20A8 06A0  32         bl    @putat                ; Show crash message
     20AA 2456     
0093 20AC 0000                   data >0000,cpu.crash.msg.crashed
     20AE 2192     
0094               
0095 20B0 06A0  32         bl    @puthex               ; Put hex value on screen
     20B2 29AC     
0096 20B4 0015                   byte 0,21             ; \ i  p0 = YX position
0097 20B6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0098 20B8 A100                   data rambuf           ; | i  p2 = Pointer to ram buffer
0099 20BA 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0100                                                   ; /         LSB offset for ASCII digit 0-9
0101                       ;------------------------------------------------------
0102                       ; Show caller address
0103                       ;------------------------------------------------------
0104 20BC 06A0  32         bl    @putat                ; Show caller message
     20BE 2456     
0105 20C0 0100                   data >0100,cpu.crash.msg.caller
     20C2 21A8     
0106               
0107 20C4 06A0  32         bl    @puthex               ; Put hex value on screen
     20C6 29AC     
0108 20C8 0115                   byte 1,21             ; \ i  p0 = YX position
0109 20CA FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0110 20CC A100                   data rambuf           ; | i  p2 = Pointer to ram buffer
0111 20CE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0112                                                   ; /         LSB offset for ASCII digit 0-9
0113                       ;------------------------------------------------------
0114                       ; Display labels
0115                       ;------------------------------------------------------
0116 20D0 06A0  32         bl    @putat
     20D2 2456     
0117 20D4 0300                   byte 3,0
0118 20D6 21C4                   data cpu.crash.msg.wp
0119 20D8 06A0  32         bl    @putat
     20DA 2456     
0120 20DC 0400                   byte 4,0
0121 20DE 21CA                   data cpu.crash.msg.st
0122 20E0 06A0  32         bl    @putat
     20E2 2456     
0123 20E4 1600                   byte 22,0
0124 20E6 21D0                   data cpu.crash.msg.source
0125 20E8 06A0  32         bl    @putat
     20EA 2456     
0126 20EC 1700                   byte 23,0
0127 20EE 21EC                   data cpu.crash.msg.id
0128                       ;------------------------------------------------------
0129                       ; Show crash registers WP, ST, R0 - R15
0130                       ;------------------------------------------------------
0131 20F0 06A0  32         bl    @at                   ; Put cursor at YX
     20F2 26DA     
0132 20F4 0304                   byte 3,4              ; \ i p0 = YX position
0133                                                   ; /
0134               
0135 20F6 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20F8 FFDC     
0136 20FA 04C6  14         clr   tmp2                  ; Loop counter
0137               
0138               cpu.crash.showreg:
0139 20FC C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0140               
0141 20FE 0649  14         dect  stack
0142 2100 C644  30         mov   tmp0,*stack           ; Push tmp0
0143 2102 0649  14         dect  stack
0144 2104 C645  30         mov   tmp1,*stack           ; Push tmp1
0145 2106 0649  14         dect  stack
0146 2108 C646  30         mov   tmp2,*stack           ; Push tmp2
0147                       ;------------------------------------------------------
0148                       ; Display crash register number
0149                       ;------------------------------------------------------
0150               cpu.crash.showreg.label:
0151 210A C046  18         mov   tmp2,r1               ; Save register number
0152 210C 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     210E 0001     
0153 2110 1220  14         jle   cpu.crash.showreg.content
0154                                                   ; Yes, skip
0155               
0156 2112 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0157 2114 06A0  32         bl    @mknum
     2116 29B6     
0158 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0159 211A A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0160 211C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0161                                                   ; /         LSB offset for ASCII digit 0-9
0162               
0163 211E 06A0  32         bl    @setx                 ; Set cursor X position
     2120 26F0     
0164 2122 0000                   data 0                ; \ i  p0 =  Cursor Y position
0165                                                   ; /
0166               
0167 2124 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     2126 0400     
0168 2128 D804  38         movb  tmp0,@rambuf          ;
     212A A100     
0169               
0170 212C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     212E 2432     
0171 2130 A100                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0172                                                   ; /
0173               
0174 2132 06A0  32         bl    @setx                 ; Set cursor X position
     2134 26F0     
0175 2136 0002                   data 2                ; \ i  p0 =  Cursor Y position
0176                                                   ; /
0177               
0178 2138 0281  22         ci    r1,10
     213A 000A     
0179 213C 1102  14         jlt   !
0180 213E 0620  34         dec   @wyx                  ; x=x-1
     2140 832A     
0181               
0182 2142 06A0  32 !       bl    @putstr
     2144 2432     
0183 2146 21BE                   data cpu.crash.msg.r
0184               
0185 2148 06A0  32         bl    @mknum
     214A 29B6     
0186 214C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0187 214E A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0188 2150 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0189                                                   ; /         LSB offset for ASCII digit 0-9
0190                       ;------------------------------------------------------
0191                       ; Display crash register content
0192                       ;------------------------------------------------------
0193               cpu.crash.showreg.content:
0194 2152 06A0  32         bl    @mkhex                ; Convert hex word to string
     2154 2928     
0195 2156 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0196 2158 A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0197 215A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0198                                                   ; /         LSB offset for ASCII digit 0-9
0199               
0200 215C 06A0  32         bl    @setx                 ; Set cursor X position
     215E 26F0     
0201 2160 0004                   data 4                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 2162 06A0  32         bl    @putstr               ; Put '  >'
     2164 2432     
0205 2166 21C0                   data cpu.crash.msg.marker
0206               
0207 2168 06A0  32         bl    @setx                 ; Set cursor X position
     216A 26F0     
0208 216C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0209                                                   ; /
0210               
0211 216E 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     2170 0400     
0212 2172 D804  38         movb  tmp0,@rambuf          ;
     2174 A100     
0213               
0214 2176 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2178 2432     
0215 217A A100                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0216                                                   ; /
0217               
0218 217C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0219 217E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0220 2180 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0221               
0222 2182 06A0  32         bl    @down                 ; y=y+1
     2184 26E0     
0223               
0224 2186 0586  14         inc   tmp2
0225 2188 0286  22         ci    tmp2,17
     218A 0011     
0226 218C 12B7  14         jle   cpu.crash.showreg     ; Show next register
0227                       ;------------------------------------------------------
0228                       ; Kernel takes over
0229                       ;------------------------------------------------------
0230 218E 0460  28         b     @cpu.crash.showbank   ; Expected to be included in
     2190 7FB0     
0231               
0232               
0233               cpu.crash.msg.crashed
0234 2192 15               byte  21
0235 2193   53             text  'System crashed near >'
     2194 7973     
     2196 7465     
     2198 6D20     
     219A 6372     
     219C 6173     
     219E 6865     
     21A0 6420     
     21A2 6E65     
     21A4 6172     
     21A6 203E     
0236                       even
0237               
0238               cpu.crash.msg.caller
0239 21A8 15               byte  21
0240 21A9   43             text  'Caller address near >'
     21AA 616C     
     21AC 6C65     
     21AE 7220     
     21B0 6164     
     21B2 6472     
     21B4 6573     
     21B6 7320     
     21B8 6E65     
     21BA 6172     
     21BC 203E     
0241                       even
0242               
0243               cpu.crash.msg.r
0244 21BE 01               byte  1
0245 21BF   52             text  'R'
0246                       even
0247               
0248               cpu.crash.msg.marker
0249 21C0 03               byte  3
0250 21C1   20             text  '  >'
     21C2 203E     
0251                       even
0252               
0253               cpu.crash.msg.wp
0254 21C4 04               byte  4
0255 21C5   2A             text  '**WP'
     21C6 2A57     
     21C8 50       
0256                       even
0257               
0258               cpu.crash.msg.st
0259 21CA 04               byte  4
0260 21CB   2A             text  '**ST'
     21CC 2A53     
     21CE 54       
0261                       even
0262               
0263               cpu.crash.msg.source
0264 21D0 1B               byte  27
0265 21D1   53             text  'Source    stevie_b5.lst.asm'
     21D2 6F75     
     21D4 7263     
     21D6 6520     
     21D8 2020     
     21DA 2073     
     21DC 7465     
     21DE 7669     
     21E0 655F     
     21E2 6235     
     21E4 2E6C     
     21E6 7374     
     21E8 2E61     
     21EA 736D     
0266                       even
0267               
0268               cpu.crash.msg.id
0269 21EC 18               byte  24
0270 21ED   42             text  'Build-ID  220116-1949060'
     21EE 7569     
     21F0 6C64     
     21F2 2D49     
     21F4 4420     
     21F6 2032     
     21F8 3230     
     21FA 3131     
     21FC 362D     
     21FE 3139     
     2200 3439     
     2202 3036     
     2204 30       
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
0007 2206 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     2208 000E     
     220A 0106     
     220C 0204     
     220E 0020     
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
0032 2210 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     2212 000E     
     2214 0106     
     2216 00F4     
     2218 0028     
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
0058 221A 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     221C 003F     
     221E 0240     
     2220 03F4     
     2222 0050     
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
0013 2224 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2226 16FD             data  >16fd                 ; |         jne   mcloop
0015 2228 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 222A D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 222C 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 222E 0201  20         li    r1,mccode             ; Machinecode to patch
     2230 2224     
0037 2232 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2234 8322     
0038 2236 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2238 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 223A CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 223C 045B  20         b     *r11                  ; Return to caller
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
0056 223E C0F9  30 popr3   mov   *stack+,r3
0057 2240 C0B9  30 popr2   mov   *stack+,r2
0058 2242 C079  30 popr1   mov   *stack+,r1
0059 2244 C039  30 popr0   mov   *stack+,r0
0060 2246 C2F9  30 poprt   mov   *stack+,r11
0061 2248 045B  20         b     *r11
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
0085 224A C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 224C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 224E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 2250 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 2252 1604  14         jne   filchk                ; No, continue checking
0093               
0094 2254 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2256 FFCE     
0095 2258 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     225A 2026     
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 225C D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     225E 830B     
     2260 830A     
0100               
0101 2262 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2264 0001     
0102 2266 1602  14         jne   filchk2
0103 2268 DD05  32         movb  tmp1,*tmp0+
0104 226A 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 226C 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     226E 0002     
0109 2270 1603  14         jne   filchk3
0110 2272 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 2274 DD05  32         movb  tmp1,*tmp0+
0112 2276 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2278 C1C4  18 filchk3 mov   tmp0,tmp3
0117 227A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     227C 0001     
0118 227E 1305  14         jeq   fil16b
0119 2280 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 2282 0606  14         dec   tmp2
0121 2284 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2286 0002     
0122 2288 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 228A C1C6  18 fil16b  mov   tmp2,tmp3
0127 228C 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     228E 0001     
0128 2290 1301  14         jeq   dofill
0129 2292 0606  14         dec   tmp2                  ; Make TMP2 even
0130 2294 CD05  34 dofill  mov   tmp1,*tmp0+
0131 2296 0646  14         dect  tmp2
0132 2298 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 229A C1C7  18         mov   tmp3,tmp3
0137 229C 1301  14         jeq   fil.exit
0138 229E DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 22A0 045B  20         b     *r11
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
0159 22A2 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 22A4 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 22A6 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 22A8 0264  22 xfilv   ori   tmp0,>4000
     22AA 4000     
0166 22AC 06C4  14         swpb  tmp0
0167 22AE D804  38         movb  tmp0,@vdpa
     22B0 8C02     
0168 22B2 06C4  14         swpb  tmp0
0169 22B4 D804  38         movb  tmp0,@vdpa
     22B6 8C02     
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22B8 020F  20         li    r15,vdpw              ; Set VDP write address
     22BA 8C00     
0174 22BC 06C5  14         swpb  tmp1
0175 22BE C820  54         mov   @filzz,@mcloop        ; Setup move command
     22C0 22C8     
     22C2 8320     
0176 22C4 0460  28         b     @mcloop               ; Write data to VDP
     22C6 8320     
0177               *--------------------------------------------------------------
0181 22C8 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22CA 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22CC 4000     
0202 22CE 06C4  14 vdra    swpb  tmp0
0203 22D0 D804  38         movb  tmp0,@vdpa
     22D2 8C02     
0204 22D4 06C4  14         swpb  tmp0
0205 22D6 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22D8 8C02     
0206 22DA 045B  20         b     *r11                  ; Exit
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
0217 22DC C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22DE C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22E0 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22E2 4000     
0223 22E4 06C4  14         swpb  tmp0                  ; \
0224 22E6 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22E8 8C02     
0225 22EA 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22EC D804  38         movb  tmp0,@vdpa            ; /
     22EE 8C02     
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22F0 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22F2 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22F4 045B  20         b     *r11                  ; Exit
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
0251 22F6 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22F8 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22FA D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22FC 8C02     
0257 22FE 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 2300 D804  38         movb  tmp0,@vdpa            ; /
     2302 8C02     
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 2304 D120  34         movb  @vdpr,tmp0            ; Read byte
     2306 8800     
0263 2308 0984  56         srl   tmp0,8                ; Right align
0264 230A 045B  20         b     *r11                  ; Exit
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
0283 230C C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 230E C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 2310 C144  18         mov   tmp0,tmp1
0289 2312 05C5  14         inct  tmp1
0290 2314 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2316 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2318 FF00     
0292 231A 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 231C C805  38         mov   tmp1,@wbase           ; Store calculated base
     231E 8328     
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 2320 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2322 8000     
0298 2324 0206  20         li    tmp2,8
     2326 0008     
0299 2328 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     232A 830B     
0300 232C 06C5  14         swpb  tmp1
0301 232E D805  38         movb  tmp1,@vdpa
     2330 8C02     
0302 2332 06C5  14         swpb  tmp1
0303 2334 D805  38         movb  tmp1,@vdpa
     2336 8C02     
0304 2338 0225  22         ai    tmp1,>0100
     233A 0100     
0305 233C 0606  14         dec   tmp2
0306 233E 16F4  14         jne   vidta1                ; Next register
0307 2340 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2342 833A     
0308 2344 045B  20         b     *r11
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
0325 2346 C13B  30 putvr   mov   *r11+,tmp0
0326 2348 0264  22 putvrx  ori   tmp0,>8000
     234A 8000     
0327 234C 06C4  14         swpb  tmp0
0328 234E D804  38         movb  tmp0,@vdpa
     2350 8C02     
0329 2352 06C4  14         swpb  tmp0
0330 2354 D804  38         movb  tmp0,@vdpa
     2356 8C02     
0331 2358 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 235A C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 235C C10E  18         mov   r14,tmp0
0341 235E 0984  56         srl   tmp0,8
0342 2360 06A0  32         bl    @putvrx               ; Write VR#0
     2362 2348     
0343 2364 0204  20         li    tmp0,>0100
     2366 0100     
0344 2368 D820  54         movb  @r14lb,@tmp0lb
     236A 831D     
     236C 8309     
0345 236E 06A0  32         bl    @putvrx               ; Write VR#1
     2370 2348     
0346 2372 0458  20         b     *tmp4                 ; Exit
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
0360 2374 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2376 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2378 C11B  26         mov   *r11,tmp0             ; Get P0
0363 237A 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     237C 7FFF     
0364 237E 2120  38         coc   @wbit0,tmp0
     2380 2020     
0365 2382 1604  14         jne   ldfnt1
0366 2384 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2386 8000     
0367 2388 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     238A 7FFF     
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 238C C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     238E 23F6     
0372 2390 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2392 9C02     
0373 2394 06C4  14         swpb  tmp0
0374 2396 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2398 9C02     
0375 239A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     239C 9800     
0376 239E 06C5  14         swpb  tmp1
0377 23A0 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     23A2 9800     
0378 23A4 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 23A6 D805  38         movb  tmp1,@grmwa
     23A8 9C02     
0383 23AA 06C5  14         swpb  tmp1
0384 23AC D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     23AE 9C02     
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23B0 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23B2 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23B4 22CA     
0390 23B6 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23B8 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23BA 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23BC 7FFF     
0393 23BE C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23C0 23F8     
0394 23C2 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23C4 23FA     
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23C6 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23C8 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23CA D120  34         movb  @grmrd,tmp0
     23CC 9800     
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23CE 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23D0 2020     
0405 23D2 1603  14         jne   ldfnt3                ; No, so skip
0406 23D4 D1C4  18         movb  tmp0,tmp3
0407 23D6 0917  56         srl   tmp3,1
0408 23D8 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23DA D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23DC 8C00     
0413 23DE 0606  14         dec   tmp2
0414 23E0 16F2  14         jne   ldfnt2
0415 23E2 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23E4 020F  20         li    r15,vdpw              ; Set VDP write address
     23E6 8C00     
0417 23E8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23EA 7FFF     
0418 23EC 0458  20         b     *tmp4                 ; Exit
0419 23EE D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23F0 2000     
     23F2 8C00     
0420 23F4 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23F6 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23F8 0200     
     23FA 0000     
0425 23FC 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23FE 01C0     
     2400 0101     
0426 2402 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     2404 02A0     
     2406 0101     
0427 2408 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     240A 00E0     
     240C 0101     
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
0445 240E C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 2410 C3A0  34         mov   @wyx,r14              ; Get YX
     2412 832A     
0447 2414 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2416 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2418 833A     
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 241A C3A0  34         mov   @wyx,r14              ; Get YX
     241C 832A     
0454 241E 024E  22         andi  r14,>00ff             ; Remove Y
     2420 00FF     
0455 2422 A3CE  18         a     r14,r15               ; pos = pos + X
0456 2424 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2426 8328     
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2428 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 242A C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 242C 020F  20         li    r15,vdpw              ; VDP write address
     242E 8C00     
0463 2430 045B  20         b     *r11
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
0481 2432 C17B  30 putstr  mov   *r11+,tmp1
0482 2434 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 2436 C1CB  18 xutstr  mov   r11,tmp3
0484 2438 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     243A 240E     
0485 243C C2C7  18         mov   tmp3,r11
0486 243E 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 2440 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 2442 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 2444 0286  22         ci    tmp2,255              ; Length > 255 ?
     2446 00FF     
0494 2448 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 244A 0460  28         b     @xpym2v               ; Display string
     244C 24A0     
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 244E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2450 FFCE     
0501 2452 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2454 2026     
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
0517 2456 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2458 832A     
0518 245A 0460  28         b     @putstr
     245C 2432     
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
0539 245E 0649  14         dect  stack
0540 2460 C64B  30         mov   r11,*stack            ; Save return address
0541 2462 0649  14         dect  stack
0542 2464 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 2466 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 2468 0987  56         srl   tmp3,8                ; Right align
0549               
0550 246A 0649  14         dect  stack
0551 246C C645  30         mov   tmp1,*stack           ; Push tmp1
0552 246E 0649  14         dect  stack
0553 2470 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 2472 0649  14         dect  stack
0555 2474 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 2476 06A0  32         bl    @xutst0               ; Display string
     2478 2434     
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 247A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 247C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 247E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 2480 06A0  32         bl    @down                 ; Move cursor down
     2482 26E0     
0566               
0567 2484 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 2486 0585  14         inc   tmp1                  ; Consider length byte
0569 2488 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     248A 2002     
0570 248C 1301  14         jeq   !                     ; Yes, skip adjustment
0571 248E 0585  14         inc   tmp1                  ; Make address even
0572 2490 0606  14 !       dec   tmp2
0573 2492 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 2494 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 2496 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 2498 045B  20         b     *r11                  ; Return
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
0020 249A C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 249C C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 249E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 24A0 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 24A2 1604  14         jne   !                     ; No, continue
0028               
0029 24A4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24A6 FFCE     
0030 24A8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24AA 2026     
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 24AC 0264  22 !       ori   tmp0,>4000
     24AE 4000     
0035 24B0 06C4  14         swpb  tmp0
0036 24B2 D804  38         movb  tmp0,@vdpa
     24B4 8C02     
0037 24B6 06C4  14         swpb  tmp0
0038 24B8 D804  38         movb  tmp0,@vdpa
     24BA 8C02     
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 24BC 020F  20         li    r15,vdpw              ; Set VDP write address
     24BE 8C00     
0043 24C0 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     24C2 24CA     
     24C4 8320     
0044 24C6 0460  28         b     @mcloop               ; Write data to VDP and return
     24C8 8320     
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 24CA D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 24CC C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 24CE C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 24D0 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 24D2 06C4  14 xpyv2m  swpb  tmp0
0027 24D4 D804  38         movb  tmp0,@vdpa
     24D6 8C02     
0028 24D8 06C4  14         swpb  tmp0
0029 24DA D804  38         movb  tmp0,@vdpa
     24DC 8C02     
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 24DE 020F  20         li    r15,vdpr              ; Set VDP read address
     24E0 8800     
0034 24E2 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24E4 24EC     
     24E6 8320     
0035 24E8 0460  28         b     @mcloop               ; Read data from VDP
     24EA 8320     
0036 24EC DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24EE C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24F0 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24F2 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24F4 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24F6 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24F8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24FA FFCE     
0034 24FC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24FE 2026     
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 2500 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     2502 0001     
0039 2504 1603  14         jne   cpym0                 ; No, continue checking
0040 2506 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 2508 04C6  14         clr   tmp2                  ; Reset counter
0042 250A 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 250C 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     250E 7FFF     
0047 2510 C1C4  18         mov   tmp0,tmp3
0048 2512 0247  22         andi  tmp3,1
     2514 0001     
0049 2516 1618  14         jne   cpyodd                ; Odd source address handling
0050 2518 C1C5  18 cpym1   mov   tmp1,tmp3
0051 251A 0247  22         andi  tmp3,1
     251C 0001     
0052 251E 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2520 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2522 2020     
0057 2524 1605  14         jne   cpym3
0058 2526 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     2528 254E     
     252A 8320     
0059 252C 0460  28         b     @mcloop               ; Copy memory and exit
     252E 8320     
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 2530 C1C6  18 cpym3   mov   tmp2,tmp3
0064 2532 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2534 0001     
0065 2536 1301  14         jeq   cpym4
0066 2538 0606  14         dec   tmp2                  ; Make TMP2 even
0067 253A CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 253C 0646  14         dect  tmp2
0069 253E 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 2540 C1C7  18         mov   tmp3,tmp3
0074 2542 1301  14         jeq   cpymz
0075 2544 D554  38         movb  *tmp0,*tmp1
0076 2546 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2548 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     254A 8000     
0081 254C 10E9  14         jmp   cpym2
0082 254E DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 2550 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2552 0649  14         dect  stack
0065 2554 C64B  30         mov   r11,*stack            ; Push return address
0066 2556 0649  14         dect  stack
0067 2558 C640  30         mov   r0,*stack             ; Push r0
0068 255A 0649  14         dect  stack
0069 255C C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 255E 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2560 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2562 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2564 4000     
0077 2566 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2568 833E     
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 256A 020C  20         li    r12,>1e00             ; SAMS CRU address
     256C 1E00     
0082 256E 04C0  14         clr   r0
0083 2570 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2572 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2574 D100  18         movb  r0,tmp0
0086 2576 0984  56         srl   tmp0,8                ; Right align
0087 2578 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     257A 833C     
0088 257C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 257E C339  30         mov   *stack+,r12           ; Pop r12
0094 2580 C039  30         mov   *stack+,r0            ; Pop r0
0095 2582 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2584 045B  20         b     *r11                  ; Return to caller
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
0131 2586 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2588 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 258A 0649  14         dect  stack
0135 258C C64B  30         mov   r11,*stack            ; Push return address
0136 258E 0649  14         dect  stack
0137 2590 C640  30         mov   r0,*stack             ; Push r0
0138 2592 0649  14         dect  stack
0139 2594 C64C  30         mov   r12,*stack            ; Push r12
0140 2596 0649  14         dect  stack
0141 2598 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 259A 0649  14         dect  stack
0143 259C C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 259E 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 25A0 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 25A2 0284  22         ci    tmp0,255              ; Crash if page > 255
     25A4 00FF     
0153 25A6 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 25A8 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     25AA 001E     
0158 25AC 150A  14         jgt   !
0159 25AE 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     25B0 0004     
0160 25B2 1107  14         jlt   !
0161 25B4 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     25B6 0012     
0162 25B8 1508  14         jgt   sams.page.set.switch_page
0163 25BA 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     25BC 0006     
0164 25BE 1501  14         jgt   !
0165 25C0 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 25C2 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     25C4 FFCE     
0170 25C6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     25C8 2026     
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 25CA 020C  20         li    r12,>1e00             ; SAMS CRU address
     25CC 1E00     
0176 25CE C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 25D0 06C0  14         swpb  r0                    ; LSB to MSB
0178 25D2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 25D4 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     25D6 4000     
0180 25D8 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 25DA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 25DC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 25DE C339  30         mov   *stack+,r12           ; Pop r12
0188 25E0 C039  30         mov   *stack+,r0            ; Pop r0
0189 25E2 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25E4 045B  20         b     *r11                  ; Return to caller
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
0204 25E6 0649  14         dect  stack
0205 25E8 C64C  30         mov   r12,*stack            ; Push r12
0206 25EA 020C  20         li    r12,>1e00             ; SAMS CRU address
     25EC 1E00     
0207 25EE 1D01  20         sbo   1                     ; Enable SAMS mapper
0208               *--------------------------------------------------------------
0209               * Exit
0210               *--------------------------------------------------------------
0211               sams.mapping.on.exit:
0212 25F0 C339  30         mov   *stack+,r12           ; Pop r12
0213 25F2 045B  20         b     *r11                  ; Return to caller
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
0230 25F4 0649  14         dect  stack
0231 25F6 C64C  30         mov   r12,*stack            ; Push r12
0232 25F8 020C  20         li    r12,>1e00             ; SAMS CRU address
     25FA 1E00     
0233 25FC 1E01  20         sbz   1                     ; Disable SAMS mapper
0234               *--------------------------------------------------------------
0235               * Exit
0236               *--------------------------------------------------------------
0237               sams.mapping.off.exit:
0238 25FE C339  30         mov   *stack+,r12           ; Pop r12
0239 2600 045B  20         b     *r11                  ; Return to caller
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
0268 2602 C13B  30         mov   *r11+,tmp0            ; Get P0
0269               xsams.layout:
0270 2604 0649  14         dect  stack
0271 2606 C64B  30         mov   r11,*stack            ; Save return address
0272 2608 0649  14         dect  stack
0273 260A C644  30         mov   tmp0,*stack           ; Save tmp0
0274 260C 0649  14         dect  stack
0275 260E C64C  30         mov   r12,*stack            ; Save r12
0276                       ;------------------------------------------------------
0277                       ; Set SAMS registers
0278                       ;------------------------------------------------------
0279 2610 020C  20         li    r12,>1e00             ; SAMS CRU address
     2612 1E00     
0280 2614 1D00  20         sbo   0                     ; Enable access to SAMS registers
0281               
0282 2616 C834  50         mov  *tmp0+,@>4004          ; Set page for >2000 - >2fff
     2618 4004     
0283 261A C834  50         mov  *tmp0+,@>4006          ; Set page for >3000 - >3fff
     261C 4006     
0284 261E C834  50         mov  *tmp0+,@>4014          ; Set page for >a000 - >afff
     2620 4014     
0285 2622 C834  50         mov  *tmp0+,@>4016          ; Set page for >b000 - >bfff
     2624 4016     
0286 2626 C834  50         mov  *tmp0+,@>4018          ; Set page for >c000 - >cfff
     2628 4018     
0287 262A C834  50         mov  *tmp0+,@>401a          ; Set page for >d000 - >dfff
     262C 401A     
0288 262E C834  50         mov  *tmp0+,@>401c          ; Set page for >e000 - >efff
     2630 401C     
0289 2632 C834  50         mov  *tmp0+,@>401e          ; Set page for >f000 - >ffff
     2634 401E     
0290               
0291 2636 1E00  20         sbz   0                     ; Disable access to SAMS registers
0292 2638 1D01  20         sbo   1                     ; Enable SAMS mapper
0293                       ;------------------------------------------------------
0294                       ; Exit
0295                       ;------------------------------------------------------
0296               sams.layout.exit:
0297 263A C339  30         mov   *stack+,r12           ; Pop r12
0298 263C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0299 263E C2F9  30         mov   *stack+,r11           ; Pop r11
0300 2640 045B  20         b     *r11                  ; Return to caller
0301               ***************************************************************
0302               * SAMS standard page layout table
0303               *--------------------------------------------------------------
0304               sams.layout.standard:
0305 2642 0200             data  >0200                 ; >2000-2fff, SAMS page >02
0306 2644 0300             data  >0300                 ; >3000-3fff, SAMS page >03
0307 2646 0A00             data  >0a00                 ; >a000-afff, SAMS page >0a
0308 2648 0B00             data  >0b00                 ; >b000-bfff, SAMS page >0b
0309 264A 0C00             data  >0c00                 ; >c000-cfff, SAMS page >0c
0310 264C 0D00             data  >0d00                 ; >d000-dfff, SAMS page >0d
0311 264E 0E00             data  >0e00                 ; >e000-efff, SAMS page >0e
0312 2650 0F00             data  >0f00                 ; >f000-ffff, SAMS page >0f
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
0332 2652 C1FB  30         mov   *r11+,tmp3            ; Get P0
0333               
0334 2654 0649  14         dect  stack
0335 2656 C64B  30         mov   r11,*stack            ; Push return address
0336 2658 0649  14         dect  stack
0337 265A C644  30         mov   tmp0,*stack           ; Push tmp0
0338 265C 0649  14         dect  stack
0339 265E C645  30         mov   tmp1,*stack           ; Push tmp1
0340 2660 0649  14         dect  stack
0341 2662 C646  30         mov   tmp2,*stack           ; Push tmp2
0342 2664 0649  14         dect  stack
0343 2666 C647  30         mov   tmp3,*stack           ; Push tmp3
0344                       ;------------------------------------------------------
0345                       ; Copy SAMS layout
0346                       ;------------------------------------------------------
0347 2668 0205  20         li    tmp1,sams.layout.copy.data
     266A 268A     
0348 266C 0206  20         li    tmp2,8                ; Set loop counter
     266E 0008     
0349                       ;------------------------------------------------------
0350                       ; Set SAMS memory pages
0351                       ;------------------------------------------------------
0352               sams.layout.copy.loop:
0353 2670 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0354 2672 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     2674 2552     
0355                                                   ; | i  tmp0   = Memory address
0356                                                   ; / o  @waux1 = SAMS page
0357               
0358 2676 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2678 833C     
0359               
0360 267A 0606  14         dec   tmp2                  ; Next iteration
0361 267C 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0362                       ;------------------------------------------------------
0363                       ; Exit
0364                       ;------------------------------------------------------
0365               sams.layout.copy.exit:
0366 267E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0367 2680 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0368 2682 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0369 2684 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0370 2686 C2F9  30         mov   *stack+,r11           ; Pop r11
0371 2688 045B  20         b     *r11                  ; Return to caller
0372               ***************************************************************
0373               * SAMS memory range table
0374               *--------------------------------------------------------------
0375               sams.layout.copy.data:
0376 268A 2000             data  >2000                 ; >2000-2fff
0377 268C 3000             data  >3000                 ; >3000-3fff
0378 268E A000             data  >a000                 ; >a000-afff
0379 2690 B000             data  >b000                 ; >b000-bfff
0380 2692 C000             data  >c000                 ; >c000-cfff
0381 2694 D000             data  >d000                 ; >d000-dfff
0382 2696 E000             data  >e000                 ; >e000-efff
0383 2698 F000             data  >f000                 ; >f000-ffff
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
0009 269A 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     269C FFBF     
0010 269E 0460  28         b     @putv01
     26A0 235A     
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 26A2 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     26A4 0040     
0018 26A6 0460  28         b     @putv01
     26A8 235A     
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 26AA 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     26AC FFDF     
0026 26AE 0460  28         b     @putv01
     26B0 235A     
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 26B2 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     26B4 0020     
0034 26B6 0460  28         b     @putv01
     26B8 235A     
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
0010 26BA 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     26BC FFFE     
0011 26BE 0460  28         b     @putv01
     26C0 235A     
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 26C2 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     26C4 0001     
0019 26C6 0460  28         b     @putv01
     26C8 235A     
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 26CA 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     26CC FFFD     
0027 26CE 0460  28         b     @putv01
     26D0 235A     
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 26D2 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     26D4 0002     
0035 26D6 0460  28         b     @putv01
     26D8 235A     
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
0018 26DA C83B  50 at      mov   *r11+,@wyx
     26DC 832A     
0019 26DE 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26E0 B820  54 down    ab    @hb$01,@wyx
     26E2 2012     
     26E4 832A     
0028 26E6 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26E8 7820  54 up      sb    @hb$01,@wyx
     26EA 2012     
     26EC 832A     
0037 26EE 045B  20         b     *r11
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
0049 26F0 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26F2 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26F4 832A     
0051 26F6 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26F8 832A     
0052 26FA 045B  20         b     *r11
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
0021 26FC C120  34 yx2px   mov   @wyx,tmp0
     26FE 832A     
0022 2700 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 2702 06C4  14         swpb  tmp0                  ; Y<->X
0024 2704 04C5  14         clr   tmp1                  ; Clear before copy
0025 2706 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 2708 20A0  38         coc   @wbit1,config         ; f18a present ?
     270A 201E     
0030 270C 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 270E 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2710 833A     
     2712 273C     
0032 2714 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 2716 0A15  56         sla   tmp1,1                ; X = X * 2
0035 2718 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 271A 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     271C 0500     
0037 271E 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2720 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 2722 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 2724 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 2726 D105  18         movb  tmp1,tmp0
0051 2728 06C4  14         swpb  tmp0                  ; X<->Y
0052 272A 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     272C 2020     
0053 272E 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 2730 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     2732 2012     
0059 2734 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     2736 2024     
0060 2738 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 273A 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 273C 0050            data   80
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
0013 273E C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2740 06A0  32         bl    @putvr                ; Write once
     2742 2346     
0015 2744 391C             data  >391c                 ; VR1/57, value 00011100
0016 2746 06A0  32         bl    @putvr                ; Write twice
     2748 2346     
0017 274A 391C             data  >391c                 ; VR1/57, value 00011100
0018 274C 06A0  32         bl    @putvr
     274E 2346     
0019 2750 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 2752 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 2754 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 2756 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     2758 2346     
0030 275A 3900             data  >3900
0031 275C 0458  20         b     *tmp4                 ; Exit
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
0042 275E C20B  18 f18idl  mov   r11,tmp4              ; Save R11
0043 2760 06A0  32         bl    @putvr                ; VR56 >38, value 00000000
     2762 2346     
0044 2764 3800             data  >3800                 ; Reset and load PC (GPU idle!)
0045 2766 0458  20         b     *tmp4                 ; Exit
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
0058 2768 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0059 276A 06A0  32         bl    @cpym2v
     276C 249A     
0060 276E 3F00             data  >3f00,f18chk_gpu,8    ; Copy F18A GPU code to VRAM
     2770 27B2     
     2772 0008     
0061 2774 06A0  32         bl    @putvr
     2776 2346     
0062 2778 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0063 277A 06A0  32         bl    @putvr
     277C 2346     
0064 277E 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0065                                                   ; GPU code should run now
0066               
0067 2780 06A0  32         bl    @putvr                ; VR56 >38, value 00000000
     2782 2346     
0068 2784 3800             data  >3800                 ; Reset and load PC (GPU idle!)
0069               ***************************************************************
0070               * VDP @>3f00 == 0 ? F18A present : F18a not present
0071               ***************************************************************
0072 2786 0204  20         li    tmp0,>3f00
     2788 3F00     
0073 278A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     278C 22CE     
0074 278E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2790 8800     
0075 2792 0984  56         srl   tmp0,8
0076 2794 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2796 8800     
0077 2798 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0078 279A 1303  14         jeq   f18chk_yes
0079               f18chk_no:
0080 279C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     279E BFFF     
0081 27A0 1002  14         jmp   f18chk_exit
0082               f18chk_yes:
0083 27A2 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     27A4 4000     
0084               
0085               f18chk_exit:
0086 27A6 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     27A8 22A2     
0087 27AA 3F00             data  >3f00,>00,6
     27AC 0000     
     27AE 0006     
0088 27B0 0458  20         b     *tmp4                 ; Exit
0089               ***************************************************************
0090               * GPU code
0091               ********|*****|*********************|**************************
0092               f18chk_gpu
0093 27B2 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0094 27B4 3F00             data  >3f00                 ; 3f02 / 3f00
0095 27B6 0340             data  >0340                 ; 3f04   0340  idle
0096 27B8 10FF             data  >10ff                 ; 3f06   10ff  \ jmp $
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
0119 27BA C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0120                       ;------------------------------------------------------
0121                       ; Reset all F18a VDP registers to power-on defaults
0122                       ;------------------------------------------------------
0123 27BC 06A0  32         bl    @putvr
     27BE 2346     
0124 27C0 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0125               
0126 27C2 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     27C4 2346     
0127 27C6 3900             data  >3900                 ; Lock the F18a
0128 27C8 0458  20         b     *tmp4                 ; Exit
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
0147 27CA C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0148 27CC 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27CE 201E     
0149 27D0 1609  14         jne   f18fw1
0150               ***************************************************************
0151               * Read F18A major/minor version
0152               ***************************************************************
0153 27D2 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27D4 8802     
0154 27D6 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27D8 2346     
0155 27DA 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0156 27DC 04C4  14         clr   tmp0
0157 27DE D120  34         movb  @vdps,tmp0
     27E0 8802     
0158 27E2 0984  56         srl   tmp0,8
0159 27E4 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 27E6 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27E8 832A     
0018 27EA D17B  28         movb  *r11+,tmp1
0019 27EC 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27EE D1BB  28         movb  *r11+,tmp2
0021 27F0 0986  56         srl   tmp2,8                ; Repeat count
0022 27F2 C1CB  18         mov   r11,tmp3
0023 27F4 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27F6 240E     
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27F8 020B  20         li    r11,hchar1
     27FA 2800     
0028 27FC 0460  28         b     @xfilv                ; Draw
     27FE 22A8     
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 2800 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     2802 2022     
0033 2804 1302  14         jeq   hchar2                ; Yes, exit
0034 2806 C2C7  18         mov   tmp3,r11
0035 2808 10EE  14         jmp   hchar                 ; Next one
0036 280A 05C7  14 hchar2  inct  tmp3
0037 280C 0457  20         b     *tmp3                 ; Exit
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
0014 280E 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     2810 8334     
0015 2812 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     2814 2006     
0016 2816 0204  20         li    tmp0,muttab
     2818 2828     
0017 281A 0205  20         li    tmp1,sound            ; Sound generator port >8400
     281C 8400     
0018 281E D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 2820 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 2822 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 2824 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 2826 045B  20         b     *r11
0023 2828 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     282A DFFF     
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
0043 282C C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     282E 8334     
0044 2830 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     2832 8336     
0045 2834 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     2836 FFF8     
0046 2838 E0BB  30         soc   *r11+,config          ; Set options
0047 283A D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     283C 2012     
     283E 831B     
0048 2840 045B  20         b     *r11
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
0059 2842 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     2844 2006     
0060 2846 1301  14         jeq   sdpla1                ; Yes, play
0061 2848 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 284A 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 284C 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     284E 831B     
     2850 2000     
0067 2852 1301  14         jeq   sdpla3                ; Play next note
0068 2854 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 2856 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     2858 2002     
0070 285A 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 285C C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     285E 8336     
0075 2860 06C4  14         swpb  tmp0
0076 2862 D804  38         movb  tmp0,@vdpa
     2864 8C02     
0077 2866 06C4  14         swpb  tmp0
0078 2868 D804  38         movb  tmp0,@vdpa
     286A 8C02     
0079 286C 04C4  14         clr   tmp0
0080 286E D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     2870 8800     
0081 2872 131E  14         jeq   sdexit                ; Yes. exit
0082 2874 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 2876 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     2878 8336     
0084 287A D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     287C 8800     
     287E 8400     
0085 2880 0604  14         dec   tmp0
0086 2882 16FB  14         jne   vdpla2
0087 2884 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     2886 8800     
     2888 831B     
0088 288A 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     288C 8336     
0089 288E 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 2890 C120  34 mmplay  mov   @wsdtmp,tmp0
     2892 8336     
0094 2894 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 2896 130C  14         jeq   sdexit                ; Yes, exit
0096 2898 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 289A A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     289C 8336     
0098 289E D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     28A0 8400     
0099 28A2 0605  14         dec   tmp1
0100 28A4 16FC  14         jne   mmpla2
0101 28A6 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     28A8 831B     
0102 28AA 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     28AC 8336     
0103 28AE 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 28B0 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     28B2 2004     
0108 28B4 1607  14         jne   sdexi2                ; No, exit
0109 28B6 C820  54         mov   @wsdlst,@wsdtmp
     28B8 8334     
     28BA 8336     
0110 28BC D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     28BE 2012     
     28C0 831B     
0111 28C2 045B  20 sdexi1  b     *r11                  ; Exit
0112 28C4 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     28C6 FFF8     
0113 28C8 045B  20         b     *r11                  ; Exit
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
0037 28CA 0649  14         dect  stack
0038 28CC C64B  30         mov   r11,*stack            ; Push return address
0039 28CE 0649  14         dect  stack
0040 28D0 C644  30         mov   tmp0,*stack           ; Push tmp0
0041                       ;------------------------------------------------------
0042                       ; (1) Check for alpha lock
0043                       ;------------------------------------------------------
0044 28D2 40A0  34         szc   @wbit10,config        ; Reset CONFIG register bit 10=0
     28D4 200C     
0045               
0046                       ; See CRU interface and keyboard sections for details
0047                       ; http://www.nouspikel.com/ti99/titechpages.htm
0048               
0049 28D6 04CC  14         clr   r12                   ; Set base address (to bit 0) so
0050                                                   ; following offsets correspond
0051               
0052 28D8 1E15  20         sbz   >0015                 ; \ Set bit 21 (PIN 5 attached to alpha
0053                                                   ; / lock column) to 0.
0054               
0055 28DA 1F07  20         tb    7                     ; \ Copy CRU bit 7 into EQ bit
0056                                                   ; | That is CRU INT7*/P15 pin (keyboard row
0057                                                   ; | with keys FCTN, 2,3,4,5,1,
0058                                                   ; / [joy1-up,joy2-up, Alpha Lock])
0059               
0060 28DC 1302  14         jeq   rkscan.prepare        ; No, alpha lock is off
0061               
0062 28DE E0A0  34         soc   @wbit10,config        ; \ Yes, alpha lock is on.
     28E0 200C     
0063                                                   ; / Set CONFIG register bit 10=1
0064                       ;------------------------------------------------------
0065                       ; (2) Prepare for OS monitor kscan
0066                       ;------------------------------------------------------
0067               rkscan.prepare:
0068 28E2 C820  54         mov   @scrpad.83c6,@>83c6   ; Required for lowercase support
     28E4 2922     
     28E6 83C6     
0069 28E8 C820  54         mov   @scrpad.83fa,@>83fa   ; Load GPLWS R13
     28EA 2924     
     28EC 83FA     
0070 28EE C820  54         mov   @scrpad.83fe,@>83fe   ; Load GPLWS R15
     28F0 2926     
     28F2 83FE     
0071               
0072 28F4 04C4  14         clr   tmp0                  ; \ Keyboard mode in MSB
0073                                                   ; / 00=Scan all of keyboard
0074               
0075 28F6 D804  38         movb  tmp0,@>8374           ; Set keyboard mode at @>8374
     28F8 8374     
0076                                                   ; (scan entire keyboard)
0077               
0078 28FA 02E0  18         lwpi  >83e0                 ; Activate GPL workspace
     28FC 83E0     
0079 28FE 06A0  32         bl    @kscan                ; Call KSCAN
     2900 000E     
0080 2902 02E0  18         lwpi  ws1                   ; Activate user workspace
     2904 8300     
0081                       ;------------------------------------------------------
0082                       ; (3) Check if key pressed
0083                       ;------------------------------------------------------
0084 2906 D120  34         movb  @>837c,tmp0           ; Get flag
     2908 837C     
0085 290A 0A34  56         sla   tmp0,3                ; Flag value is >20
0086 290C 1707  14         jnc   rkscan.exit           ; No key pressed, exit early
0087                       ;------------------------------------------------------
0088                       ; (4) Key detected, store in memory
0089                       ;------------------------------------------------------
0090 290E D120  34         movb  @>8375,tmp0           ; \ Key pressed is at @>8375
     2910 8375     
0091 2912 0984  56         srl   tmp0,8                ; / Move to LSB
0093 2914 C804  38         mov   tmp0,@rom0_kscan_out  ; Store ASCII value in user location
     2916 A022     
0097 2918 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     291A 200A     
0098                       ;------------------------------------------------------
0099                       ; Exit
0100                       ;------------------------------------------------------
0101               rkscan.exit:
0102 291C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0103 291E C2F9  30         mov   *stack+,r11           ; Pop r11
0104 2920 045B  20         b     *r11                  ; Return to caller
0105               
0106               
0107 2922 0200     scrpad.83c6   data >0200            ; Required for KSCAN to support lowercase
0108 2924 9800     scrpad.83fa   data >9800
0109               
0110               ; Dummy value for GPLWS R15 (instead of VDP write address port 8c02)
0111               ; We do not want console KSCAN to fiddle with VDP registers while Stevie
0112               ; is running
0113               
0114 2926 83A0     scrpad.83fe   data >83a0            ; 8c02
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
0023 2928 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 292A C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     292C 8340     
0025 292E 04E0  34         clr   @waux1
     2930 833C     
0026 2932 04E0  34         clr   @waux2
     2934 833E     
0027 2936 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2938 833C     
0028 293A C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 293C 0205  20         li    tmp1,4                ; 4 nibbles
     293E 0004     
0033 2940 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2942 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2944 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2946 0286  22         ci    tmp2,>000a
     2948 000A     
0039 294A 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 294C C21B  26         mov   *r11,tmp4
0045 294E 0988  56         srl   tmp4,8                ; Right justify
0046 2950 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2952 FFF6     
0047 2954 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2956 C21B  26         mov   *r11,tmp4
0054 2958 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     295A 00FF     
0055               
0056 295C A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 295E 06C6  14         swpb  tmp2
0058 2960 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2962 0944  56         srl   tmp0,4                ; Next nibble
0060 2964 0605  14         dec   tmp1
0061 2966 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2968 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     296A BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 296C C160  34         mov   @waux3,tmp1           ; Get pointer
     296E 8340     
0067 2970 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2972 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2974 C120  34         mov   @waux2,tmp0
     2976 833E     
0070 2978 06C4  14         swpb  tmp0
0071 297A DD44  32         movb  tmp0,*tmp1+
0072 297C 06C4  14         swpb  tmp0
0073 297E DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2980 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2982 8340     
0078 2984 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2986 2016     
0079 2988 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 298A C120  34         mov   @waux1,tmp0
     298C 833C     
0084 298E 06C4  14         swpb  tmp0
0085 2990 DD44  32         movb  tmp0,*tmp1+
0086 2992 06C4  14         swpb  tmp0
0087 2994 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2996 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2998 2020     
0092 299A 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 299C 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 299E 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29A0 7FFF     
0098 29A2 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29A4 8340     
0099 29A6 0460  28         b     @xutst0               ; Display string
     29A8 2434     
0100 29AA 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29AC C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29AE 832A     
0122 29B0 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29B2 8000     
0123 29B4 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29B6 0207  20 mknum   li    tmp3,5                ; Digit counter
     29B8 0005     
0020 29BA C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29BC C155  26         mov   *tmp1,tmp1            ; /
0022 29BE C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29C0 0228  22         ai    tmp4,4                ; Get end of buffer
     29C2 0004     
0024 29C4 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29C6 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29C8 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29CA 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29CC 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29CE B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29D0 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29D2 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29D4 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29D6 0607  14         dec   tmp3                  ; Decrease counter
0036 29D8 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29DA 0207  20         li    tmp3,4                ; Check first 4 digits
     29DC 0004     
0041 29DE 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29E0 C11B  26         mov   *r11,tmp0
0043 29E2 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29E4 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29E6 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29E8 05CB  14 mknum3  inct  r11
0047 29EA 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29EC 2020     
0048 29EE 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29F0 045B  20         b     *r11                  ; Exit
0050 29F2 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29F4 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29F6 13F8  14         jeq   mknum3                ; Yes, exit
0053 29F8 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29FA 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29FC 7FFF     
0058 29FE C10B  18         mov   r11,tmp0
0059 2A00 0224  22         ai    tmp0,-4
     2A02 FFFC     
0060 2A04 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A06 0206  20         li    tmp2,>0500            ; String length = 5
     2A08 0500     
0062 2A0A 0460  28         b     @xutstr               ; Display string
     2A0C 2436     
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
0093 2A0E C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A10 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A12 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A14 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A16 0207  20         li    tmp3,5                ; Set counter
     2A18 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A1A 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A1C 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A1E 0584  14         inc   tmp0                  ; Next character
0105 2A20 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A22 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A24 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A26 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A28 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A2A 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A2C DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A2E 0607  14         dec   tmp3                  ; Last character ?
0121 2A30 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A32 045B  20         b     *r11                  ; Return
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
0139 2A34 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A36 832A     
0140 2A38 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A3A 8000     
0141 2A3C 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A3E 0649  14         dect  stack
0023 2A40 C64B  30         mov   r11,*stack            ; Save return address
0024 2A42 0649  14         dect  stack
0025 2A44 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A46 0649  14         dect  stack
0027 2A48 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A4A 0649  14         dect  stack
0029 2A4C C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A4E 0649  14         dect  stack
0031 2A50 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A52 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A54 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A56 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A58 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A5A 0649  14         dect  stack
0044 2A5C C64B  30         mov   r11,*stack            ; Save return address
0045 2A5E 0649  14         dect  stack
0046 2A60 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A62 0649  14         dect  stack
0048 2A64 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A66 0649  14         dect  stack
0050 2A68 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A6A 0649  14         dect  stack
0052 2A6C C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A6E C1D4  26 !       mov   *tmp0,tmp3
0057 2A70 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A72 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A74 00FF     
0059 2A76 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A78 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A7A 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A7C 0584  14         inc   tmp0                  ; Next byte
0067 2A7E 0607  14         dec   tmp3                  ; Shorten string length
0068 2A80 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A82 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A84 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A86 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A88 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A8A C187  18         mov   tmp3,tmp2
0078 2A8C 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A8E DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A90 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A92 24F4     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A94 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A96 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A98 FFCE     
0090 2A9A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A9C 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A9E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AA0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2AA2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2AA4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2AA6 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2AA8 045B  20         b     *r11                  ; Return to caller
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
0123 2AAA 0649  14         dect  stack
0124 2AAC C64B  30         mov   r11,*stack            ; Save return address
0125 2AAE 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AB0 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AB2 0649  14         dect  stack
0128 2AB4 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2AB6 0649  14         dect  stack
0130 2AB8 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2ABA 0649  14         dect  stack
0132 2ABC C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2ABE C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AC0 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AC2 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AC4 0649  14         dect  stack
0144 2AC6 C64B  30         mov   r11,*stack            ; Save return address
0145 2AC8 0649  14         dect  stack
0146 2ACA C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2ACC 0649  14         dect  stack
0148 2ACE C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AD0 0649  14         dect  stack
0150 2AD2 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AD4 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AD6 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AD8 0586  14         inc   tmp2
0161 2ADA 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2ADC 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2ADE 0286  22         ci    tmp2,255
     2AE0 00FF     
0167 2AE2 1505  14         jgt   string.getlenc.panic
0168 2AE4 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2AE6 0606  14         dec   tmp2                  ; One time adjustment
0174 2AE8 C806  38         mov   tmp2,@waux1           ; Store length
     2AEA 833C     
0175 2AEC 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2AEE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AF0 FFCE     
0181 2AF2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AF4 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2AF6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2AF8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AFA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AFC C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2AFE 045B  20         b     *r11                  ; Return to caller
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
0023 2B00 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2B02 F960     
0024 2B04 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2B06 F962     
0025 2B08 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2B0A F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 2B0C 0200  20         li    r0,>8306              ; Scratchpad source address
     2B0E 8306     
0030 2B10 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2B12 F966     
0031 2B14 0202  20         li    r2,62                 ; Loop counter
     2B16 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 2B18 CC70  46         mov   *r0+,*r1+
0037 2B1A CC70  46         mov   *r0+,*r1+
0038 2B1C 0642  14         dect  r2
0039 2B1E 16FC  14         jne   cpu.scrpad.backup.copy
0040 2B20 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2B22 83FE     
     2B24 FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 2B26 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2B28 F960     
0046 2B2A C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2B2C F962     
0047 2B2E C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2B30 F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 2B32 045B  20         b     *r11                  ; Return to caller
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
0074 2B34 0200  20         li    r0,cpu.scrpad.tgt
     2B36 F960     
0075 2B38 0201  20         li    r1,>8300
     2B3A 8300     
0076                       ;------------------------------------------------------
0077                       ; Copy 256 bytes from @cpu.scrpad.tgt to >8300
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 2B3C CC70  46         mov   *r0+,*r1+
0081 2B3E CC70  46         mov   *r0+,*r1+
0082 2B40 0281  22         ci    r1,>8400
     2B42 8400     
0083 2B44 11FB  14         jlt   cpu.scrpad.restore.copy
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               cpu.scrpad.restore.exit:
0088 2B46 045B  20         b     *r11                  ; Return to caller
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
0038 2B48 C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 2B4A CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 2B4C CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 2B4E CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 2B50 CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 2B52 CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 2B54 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 2B56 CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 2B58 CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 2B5A 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     2B5C 8310     
0055                                                   ;        as of register r8
0056 2B5E 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     2B60 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 2B62 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 2B64 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 2B66 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 2B68 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 2B6A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 2B6C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 2B6E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 2B70 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 2B72 0606  14         dec   tmp2
0069 2B74 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 2B76 C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 2B78 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2B7A 2B80     
0075                                                   ; R14=PC
0076 2B7C 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 2B7E 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 2B80 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     2B82 2B34     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 2B84 045B  20         b     *r11                  ; Return to caller
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
0120 2B86 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0121                       ;------------------------------------------------------
0122                       ; Copy scratchpad memory to destination
0123                       ;------------------------------------------------------
0124               xcpu.scrpad.pgin:
0125 2B88 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2B8A 8300     
0126 2B8C 0206  20         li    tmp2,16               ; tmp2 = 256/16
     2B8E 0010     
0127                       ;------------------------------------------------------
0128                       ; Copy memory
0129                       ;------------------------------------------------------
0130 2B90 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0131 2B92 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0132 2B94 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0133 2B96 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0134 2B98 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0135 2B9A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0136 2B9C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0137 2B9E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0138 2BA0 0606  14         dec   tmp2
0139 2BA2 16F6  14         jne   -!                    ; Loop until done
0140                       ;------------------------------------------------------
0141                       ; Switch workspace to scratchpad memory
0142                       ;------------------------------------------------------
0143 2BA4 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2BA6 8300     
0144                       ;------------------------------------------------------
0145                       ; Exit
0146                       ;------------------------------------------------------
0147               cpu.scrpad.pgin.exit:
0148 2BA8 045B  20         b     *r11                  ; Return to caller
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
0056 2BAA A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2BAC 2BAE             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2BAE C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2BB0 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2BB2 A428     
0064 2BB4 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2BB6 201C     
0065 2BB8 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2BBA 8356     
0066 2BBC C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2BBE 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2BC0 FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2BC2 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2BC4 A434     
0073                       ;---------------------------; Inline VSBR start
0074 2BC6 06C0  14         swpb  r0                    ;
0075 2BC8 D800  38         movb  r0,@vdpa              ; Send low byte
     2BCA 8C02     
0076 2BCC 06C0  14         swpb  r0                    ;
0077 2BCE D800  38         movb  r0,@vdpa              ; Send high byte
     2BD0 8C02     
0078 2BD2 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2BD4 8800     
0079                       ;---------------------------; Inline VSBR end
0080 2BD6 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2BD8 0704  14         seto  r4                    ; Init counter
0086 2BDA 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BDC A420     
0087 2BDE 0580  14 !       inc   r0                    ; Point to next char of name
0088 2BE0 0584  14         inc   r4                    ; Increment char counter
0089 2BE2 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2BE4 0007     
0090 2BE6 1573  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2BE8 80C4  18         c     r4,r3                 ; End of name?
0093 2BEA 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2BEC 06C0  14         swpb  r0                    ;
0098 2BEE D800  38         movb  r0,@vdpa              ; Send low byte
     2BF0 8C02     
0099 2BF2 06C0  14         swpb  r0                    ;
0100 2BF4 D800  38         movb  r0,@vdpa              ; Send high byte
     2BF6 8C02     
0101 2BF8 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2BFA 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2BFC DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2BFE 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2C00 2D1A     
0109 2C02 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2C04 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2C06 1363  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2C08 04E0  34         clr   @>83d0
     2C0A 83D0     
0118 2C0C C804  38         mov   r4,@>8354             ; Save name length for search (length
     2C0E 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2C10 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2C12 A432     
0121               
0122 2C14 0584  14         inc   r4                    ; Adjust for dot
0123 2C16 A804  38         a     r4,@>8356             ; Point to position after name
     2C18 8356     
0124 2C1A C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2C1C 8356     
     2C1E A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2C20 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C22 83E0     
0130 2C24 04C1  14         clr   r1                    ; Version found of dsr
0131 2C26 020C  20         li    r12,>0f00             ; Init cru address
     2C28 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2C2A C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2C2C 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2C2E 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2C30 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2C32 0100     
0145 2C34 04E0  34         clr   @>83d0                ; Clear in case we are done
     2C36 83D0     
0146 2C38 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2C3A 2000     
0147 2C3C 1346  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2C3E C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2C40 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2C42 1D00  20         sbo   0                     ; Turn on ROM
0154 2C44 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2C46 4000     
0155 2C48 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2C4A 2D16     
0156 2C4C 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2C4E A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2C50 A40A     
0166 2C52 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2C54 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2C56 83D2     
0172                                                   ; subprogram
0173               
0174 2C58 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2C5A C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2C5C 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2C5E C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2C60 83D2     
0183                                                   ; subprogram
0184               
0185 2C62 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2C64 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2C66 04C5  14         clr   r5                    ; Remove any old stuff
0194 2C68 D160  34         movb  @>8355,r5             ; Get length as counter
     2C6A 8355     
0195 2C6C 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2C6E 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2C70 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2C72 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2C74 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2C76 A420     
0206 2C78 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2C7A 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2C7C 0605  14         dec   r5                    ; Update loop counter
0211 2C7E 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2C80 0581  14         inc   r1                    ; Next version found
0217 2C82 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2C84 A42A     
0218 2C86 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C88 A42C     
0219 2C8A C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C8C A430     
0220               
0221 2C8E 020D  20         li    r13,>9800             ; Set GROM base to >9800 to prevent
     2C90 9800     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C92 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C94 8C02     
0225                                                   ; lockup of TI Disk Controller DSR.
0226               
0227 2C96 0699  24         bl    *r9                   ; Execute DSR
0228                       ;
0229                       ; Depending on IO result the DSR in card ROM does RET
0230                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0231                       ;
0232 2C98 10DD  14         jmp   dsrlnk.dsrscan.nextentry
0233                                                   ; (1) error return
0234 2C9A 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0235 2C9C 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C9E A400     
0236 2CA0 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0237                       ;------------------------------------------------------
0238                       ; Returned from DSR
0239                       ;------------------------------------------------------
0240               dsrlnk.dsrscan.return_dsr:
0241 2CA2 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2CA4 A428     
0242                                                   ; (8 or >a)
0243 2CA6 0281  22         ci    r1,8                  ; was it 8?
     2CA8 0008     
0244 2CAA 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0245 2CAC D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2CAE 8350     
0246                                                   ; Get error byte from @>8350
0247 2CB0 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0248               
0249                       ;------------------------------------------------------
0250                       ; Read VDP PAB byte 1 after DSR call completed (status)
0251                       ;------------------------------------------------------
0252               dsrlnk.dsrscan.dsr.8:
0253                       ;---------------------------; Inline VSBR start
0254 2CB2 06C0  14         swpb  r0                    ;
0255 2CB4 D800  38         movb  r0,@vdpa              ; send low byte
     2CB6 8C02     
0256 2CB8 06C0  14         swpb  r0                    ;
0257 2CBA D800  38         movb  r0,@vdpa              ; send high byte
     2CBC 8C02     
0258 2CBE D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2CC0 8800     
0259                       ;---------------------------; Inline VSBR end
0260               
0261                       ;------------------------------------------------------
0262                       ; Return DSR error to caller
0263                       ;------------------------------------------------------
0264               dsrlnk.dsrscan.dsr.a:
0265 2CC2 09D1  56         srl   r1,13                 ; just keep error bits
0266 2CC4 1605  14         jne   dsrlnk.error.io_error
0267                                                   ; handle IO error
0268 2CC6 0380  18         rtwp                        ; Return from DSR workspace to caller
0269                                                   ; workspace
0270               
0271                       ;------------------------------------------------------
0272                       ; IO-error handler
0273                       ;------------------------------------------------------
0274               dsrlnk.error.nodsr_found_off:
0275 2CC8 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0276               dsrlnk.error.nodsr_found:
0277 2CCA 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2CCC A400     
0278               dsrlnk.error.devicename_invalid:
0279 2CCE 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0280               dsrlnk.error.io_error:
0281 2CD0 06C1  14         swpb  r1                    ; put error in hi byte
0282 2CD2 D741  30         movb  r1,*r13               ; store error flags in callers r0
0283 2CD4 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2CD6 201C     
0284                                                   ; / to indicate error
0285 2CD8 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0312 2CDA A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0313 2CDC 2CDE             data  dsrlnk.reuse.init     ; entry point
0314                       ;------------------------------------------------------
0315                       ; DSRLNK entry point
0316                       ;------------------------------------------------------
0317               dsrlnk.reuse.init:
0318 2CDE 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2CE0 83E0     
0319               
0320 2CE2 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2CE4 201C     
0321                       ;------------------------------------------------------
0322                       ; Restore dsrlnk variables of previous DSR call
0323                       ;------------------------------------------------------
0324 2CE6 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2CE8 A42A     
0325 2CEA C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0326 2CEC C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0327 2CEE C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2CF0 8356     
0328                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0329 2CF2 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0330 2CF4 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2CF6 8354     
0331                       ;------------------------------------------------------
0332                       ; Call DSR program in card/device
0333                       ;------------------------------------------------------
0334 2CF8 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2CFA 8C02     
0335                                                   ; lockup of TI Disk Controller DSR.
0336               
0337 2CFC 1D00  20         sbo   >00                   ; Open card/device ROM
0338               
0339 2CFE 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2D00 4000     
     2D02 2D16     
0340 2D04 16E2  14         jne   dsrlnk.error.nodsr_found
0341                                                   ; No, error code 0 = Bad Device name
0342                                                   ; The above jump may happen only in case of
0343                                                   ; either card hardware malfunction or if
0344                                                   ; there are 2 cards opened at the same time.
0345               
0346 2D06 0699  24         bl    *r9                   ; Execute DSR
0347                       ;
0348                       ; Depending on IO result the DSR in card ROM does RET
0349                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0350                       ;
0351 2D08 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0352                                                   ; (1) error return
0353 2D0A 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0354                       ;------------------------------------------------------
0355                       ; Now check if any DSR error occured
0356                       ;------------------------------------------------------
0357 2D0C 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2D0E A400     
0358 2D10 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2D12 A434     
0359               
0360 2D14 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0361                                                   ; Rest is the same as with normal DSRLNK
0362               
0363               
0364               ********************************************************************************
0365               
0366 2D16 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0367 2D18 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0368                                                   ; a @blwp @dsrlnk
0369 2D1A 2E       dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2D1C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2D1E C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2D20 0649  14         dect  stack
0052 2D22 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2D24 0204  20         li    tmp0,dsrlnk.savcru
     2D26 A42A     
0057 2D28 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2D2A 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2D2C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2D2E 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2D30 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2D32 37D7     
0065 2D34 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2D36 8370     
0066                                                   ; / location
0067 2D38 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2D3A A44C     
0068 2D3C 04C5  14         clr   tmp1                  ; io.op.open
0069 2D3E 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2D40 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2D42 0649  14         dect  stack
0097 2D44 C64B  30         mov   r11,*stack            ; Save return address
0098 2D46 0205  20         li    tmp1,io.op.close      ; io.op.close
     2D48 0001     
0099 2D4A 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2D4C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2D4E 0649  14         dect  stack
0125 2D50 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2D52 0205  20         li    tmp1,io.op.read       ; io.op.read
     2D54 0002     
0128 2D56 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2D58 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2D5A 0649  14         dect  stack
0155 2D5C C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2D5E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2D60 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2D62 0005     
0159               
0160 2D64 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2D66 A43E     
0161               
0162 2D68 06A0  32         bl    @xvputb               ; Write character count to PAB
     2D6A 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2D6C 0205  20         li    tmp1,io.op.write      ; io.op.write
     2D6E 0003     
0167 2D70 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2D72 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2D74 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2D76 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2D78 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2D7A 1000  14         nop
0189               
0190               
0191               file.status:
0192 2D7C 1000  14         nop
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
0227 2D7E C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2D80 A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2D82 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2D84 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2D86 A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2D88 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2D8A 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D8C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D8E 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D90 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D92 A44C     
0246               
0247 2D94 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D96 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D98 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D9A 0009     
0254 2D9C C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2D9E 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2DA0 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2DA2 8322     
     2DA4 833C     
0259               
0260 2DA6 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2DA8 A42A     
0261 2DAA 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2DAC 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2DAE 2BAA     
0268 2DB0 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2DB2 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2DB4 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2DB6 2CDA     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2DB8 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2DBA C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2DBC 833C     
     2DBE 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2DC0 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2DC2 A436     
0292 2DC4 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2DC6 0005     
0293 2DC8 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2DCA 22F8     
0294 2DCC C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2DCE C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2DD0 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2DD2 045B  20         b     *r11                  ; Return to caller
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
0020 2DD4 0300  24 tmgr    limi  0                     ; No interrupt processing
     2DD6 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2DD8 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2DDA 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2DDC 2360  38         coc   @wbit2,r13            ; C flag on ?
     2DDE 201C     
0029 2DE0 1602  14         jne   tmgr1a                ; No, so move on
0030 2DE2 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2DE4 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2DE6 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2DE8 2020     
0035 2DEA 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2DEC 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2DEE 2010     
0048 2DF0 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2DF2 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2DF4 200E     
0050 2DF6 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2DF8 0460  28         b     @kthread              ; Run kernel thread
     2DFA 2E72     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2DFC 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2DFE 2014     
0056 2E00 13EB  14         jeq   tmgr1
0057 2E02 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2E04 2012     
0058 2E06 16E8  14         jne   tmgr1
0059 2E08 C120  34         mov   @wtiusr,tmp0
     2E0A 832E     
0060 2E0C 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2E0E 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2E10 2E70     
0065 2E12 C10A  18         mov   r10,tmp0
0066 2E14 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2E16 00FF     
0067 2E18 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2E1A 201C     
0068 2E1C 1303  14         jeq   tmgr5
0069 2E1E 0284  22         ci    tmp0,60               ; 1 second reached ?
     2E20 003C     
0070 2E22 1002  14         jmp   tmgr6
0071 2E24 0284  22 tmgr5   ci    tmp0,50
     2E26 0032     
0072 2E28 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2E2A 1001  14         jmp   tmgr8
0074 2E2C 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2E2E C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2E30 832C     
0079 2E32 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2E34 FF00     
0080 2E36 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2E38 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2E3A 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2E3C 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2E3E C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2E40 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2E42 830C     
     2E44 830D     
0089 2E46 1608  14         jne   tmgr10                ; No, get next slot
0090 2E48 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2E4A FF00     
0091 2E4C C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2E4E C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2E50 8330     
0096 2E52 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2E54 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2E56 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2E58 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2E5A 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2E5C 8315     
     2E5E 8314     
0103 2E60 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2E62 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2E64 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2E66 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2E68 10F7  14         jmp   tmgr10                ; Process next slot
0108 2E6A 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2E6C FF00     
0109 2E6E 10B4  14         jmp   tmgr1
0110 2E70 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2E72 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2E74 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 2E76 20A0  38         coc   @wbit13,config        ; Sound player on ?
     2E78 2006     
0023 2E7A 1602  14         jne   kthread_kb
0024 2E7C 06A0  32         bl    @sdpla1               ; Run sound player
     2E7E 284A     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0042 2E80 06A0  32         bl    @rkscan               ; Scan full keyboard with ROM#0 KSCAN
     2E82 28CA     
0047               *--------------------------------------------------------------
0048               kthread_exit
0049 2E84 0460  28         b     @tmgr3                ; Exit
     2E86 2DFC     
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
0017 2E88 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2E8A 832E     
0018 2E8C E0A0  34         soc   @wbit7,config         ; Enable user hook
     2E8E 2012     
0019 2E90 045B  20 mkhoo1  b     *r11                  ; Return
0020      2DD8     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2E92 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2E94 832E     
0029 2E96 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E98 FEFF     
0030 2E9A 045B  20         b     *r11                  ; Return
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
0017 2E9C C13B  30 mkslot  mov   *r11+,tmp0
0018 2E9E C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2EA0 C184  18         mov   tmp0,tmp2
0023 2EA2 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2EA4 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2EA6 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2EA8 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2EAA 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2EAC C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2EAE 881B  46         c     *r11,@w$ffff          ; End of list ?
     2EB0 2022     
0035 2EB2 1301  14         jeq   mkslo1                ; Yes, exit
0036 2EB4 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2EB6 05CB  14 mkslo1  inct  r11
0041 2EB8 045B  20         b     *r11                  ; Exit
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
0052 2EBA C13B  30 clslot  mov   *r11+,tmp0
0053 2EBC 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2EBE A120  34         a     @wtitab,tmp0          ; Add table base
     2EC0 832C     
0055 2EC2 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2EC4 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2EC6 045B  20         b     *r11                  ; Exit
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
0068 2EC8 C13B  30 rsslot  mov   *r11+,tmp0
0069 2ECA 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2ECC A120  34         a     @wtitab,tmp0          ; Add table base
     2ECE 832C     
0071 2ED0 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2ED2 C154  26         mov   *tmp0,tmp1
0073 2ED4 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2ED6 FF00     
0074 2ED8 C505  30         mov   tmp1,*tmp0
0075 2EDA 045B  20         b     *r11                  ; Exit
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
0271 2EDC 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2EDE 8302     
0273               *--------------------------------------------------------------
0274               * Alternative entry point
0275               *--------------------------------------------------------------
0276 2EE0 0300  24 runli1  limi  0                     ; Turn off interrupts
     2EE2 0000     
0277 2EE4 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2EE6 8300     
0278 2EE8 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2EEA 83C0     
0279               *--------------------------------------------------------------
0280               * Clear scratch-pad memory from R4 upwards
0281               *--------------------------------------------------------------
0282 2EEC 0202  20 runli2  li    r2,>8308
     2EEE 8308     
0283 2EF0 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0284 2EF2 0282  22         ci    r2,>8400
     2EF4 8400     
0285 2EF6 16FC  14         jne   runli3
0286               *--------------------------------------------------------------
0287               * Exit to TI-99/4A title screen ?
0288               *--------------------------------------------------------------
0289 2EF8 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2EFA FFFF     
0290 2EFC 1602  14         jne   runli4                ; No, continue
0291 2EFE 0420  54         blwp  @0                    ; Yes, bye bye
     2F00 0000     
0292               *--------------------------------------------------------------
0293               * Determine if VDP is PAL or NTSC
0294               *--------------------------------------------------------------
0295 2F02 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2F04 833C     
0296 2F06 04C1  14         clr   r1                    ; Reset counter
0297 2F08 0202  20         li    r2,10                 ; We test 10 times
     2F0A 000A     
0298 2F0C C0E0  34 runli5  mov   @vdps,r3
     2F0E 8802     
0299 2F10 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2F12 2020     
0300 2F14 1302  14         jeq   runli6
0301 2F16 0581  14         inc   r1                    ; Increase counter
0302 2F18 10F9  14         jmp   runli5
0303 2F1A 0602  14 runli6  dec   r2                    ; Next test
0304 2F1C 16F7  14         jne   runli5
0305 2F1E 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2F20 1250     
0306 2F22 1202  14         jle   runli7                ; No, so it must be NTSC
0307 2F24 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2F26 201C     
0308               *--------------------------------------------------------------
0309               * Copy machine code to scratchpad (prepare tight loop)
0310               *--------------------------------------------------------------
0311 2F28 06A0  32 runli7  bl    @loadmc
     2F2A 222E     
0312               *--------------------------------------------------------------
0313               * Initialize registers, memory, ...
0314               *--------------------------------------------------------------
0315 2F2C 04C1  14 runli9  clr   r1
0316 2F2E 04C2  14         clr   r2
0317 2F30 04C3  14         clr   r3
0318 2F32 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2F34 A900     
0319 2F36 020F  20         li    r15,vdpw              ; Set VDP write address
     2F38 8C00     
0321 2F3A 06A0  32         bl    @mute                 ; Mute sound generators
     2F3C 280E     
0323               *--------------------------------------------------------------
0324               * Setup video memory
0325               *--------------------------------------------------------------
0327 2F3E 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2F40 4A4A     
0328 2F42 1605  14         jne   runlia
0329 2F44 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2F46 22A2     
0330 2F48 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2F4A 0000     
     2F4C 3000     
0335 2F4E 06A0  32 runlia  bl    @filv
     2F50 22A2     
0336 2F52 0FC0             data  pctadr,spfclr,16      ; Load color table
     2F54 00F4     
     2F56 0010     
0337               *--------------------------------------------------------------
0338               * Check if there is a F18A present
0339               *--------------------------------------------------------------
0343 2F58 06A0  32         bl    @f18unl               ; Unlock the F18A
     2F5A 273E     
0344 2F5C 06A0  32         bl    @f18chk               ; Check if F18A is there \
     2F5E 2768     
0345 2F60 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     2F62 2768     
0346 2F64 06A0  32         bl    @f18chk               ; Check if F18A is there /
     2F66 2768     
0347 2F68 06A0  32         bl    @f18lck               ; Lock the F18A again
     2F6A 2754     
0348               
0349 2F6C 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2F6E 2346     
0350 2F70 3201                   data >3201            ; F18a VR50 (>32), bit 1
0352               *--------------------------------------------------------------
0353               * Check if there is a speech synthesizer attached
0354               *--------------------------------------------------------------
0356               *       <<skipped>>
0360               *--------------------------------------------------------------
0361               * Load video mode table & font
0362               *--------------------------------------------------------------
0363 2F72 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2F74 230C     
0364 2F76 35E2             data  spvmod                ; Equate selected video mode table
0365 2F78 0204  20         li    tmp0,spfont           ; Get font option
     2F7A 000C     
0366 2F7C 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0367 2F7E 1304  14         jeq   runlid                ; Yes, skip it
0368 2F80 06A0  32         bl    @ldfnt
     2F82 2374     
0369 2F84 1100             data  fntadr,spfont         ; Load specified font
     2F86 000C     
0370               *--------------------------------------------------------------
0371               * Did a system crash occur before runlib was called?
0372               *--------------------------------------------------------------
0373 2F88 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2F8A 4A4A     
0374 2F8C 1602  14         jne   runlie                ; No, continue
0375 2F8E 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2F90 2086     
0376               *--------------------------------------------------------------
0377               * Branch to main program
0378               *--------------------------------------------------------------
0379 2F92 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2F94 0040     
0380 2F96 0460  28         b     @main                 ; Give control to main program
     2F98 6046     
                   < stevie_b5.asm.60011
0037                       copy  "ram.resident.asm"
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
0021 2F9A C13B  30         mov   *r11+,tmp0            ; P0
0022 2F9C C17B  30         mov   *r11+,tmp1            ; P1
0023 2F9E C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 2FA0 0649  14         dect  stack
0029 2FA2 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 2FA4 0649  14         dect  stack
0031 2FA6 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 2FA8 0649  14         dect  stack
0033 2FAA C646  30         mov   tmp2,*stack           ; Push tmp2
0034 2FAC 0649  14         dect  stack
0035 2FAE C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 2FB0 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     2FB2 6000     
0040 2FB4 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 2FB6 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     2FB8 A226     
0044 2FBA 0647  14         dect  tmp3
0045 2FBC C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 2FBE 0647  14         dect  tmp3
0047 2FC0 C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 2FC2 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     2FC4 A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 2FC6 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 2FC8 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 2FCA 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 2FCC 0224  22         ai    tmp0,>0800
     2FCE 0800     
0066 2FD0 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 2FD2 0285  22         ci    tmp1,>ffff
     2FD4 FFFF     
0075 2FD6 1602  14         jne   !
0076 2FD8 C160  34         mov   @trmpvector,tmp1
     2FDA A03A     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 2FDC C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 2FDE 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 2FE0 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 2FE2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2FE4 FFCE     
0091 2FE6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2FE8 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 2FEA 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 2FEC C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     2FEE A226     
0102 2FF0 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 2FF2 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 2FF4 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 2FF6 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 2FF8 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 2FFA 028B  22         ci    r11,>6000
     2FFC 6000     
0115 2FFE 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 3000 028B  22         ci    r11,>7fff
     3002 7FFF     
0117 3004 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 3006 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     3008 A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 300A 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 300C 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 300E 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 3010 0225  22         ai    tmp1,>0800
     3012 0800     
0137 3014 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 3016 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 3018 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     301A FFCE     
0144 301C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     301E 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 3020 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 3022 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 3024 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 3026 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 3028 045B  20         b     *r11                  ; Return to caller
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
0020 302A 0649  14         dect  stack
0021 302C C64B  30         mov   r11,*stack            ; Save return address
0022 302E 0649  14         dect  stack
0023 3030 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 3032 0649  14         dect  stack
0025 3034 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3036 0204  20         li    tmp0,fb.top
     3038 D000     
0030 303A C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     303C A300     
0031 303E 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     3040 A304     
0032 3042 04E0  34         clr   @fb.row               ; Current row=0
     3044 A306     
0033 3046 04E0  34         clr   @fb.column            ; Current column=0
     3048 A30C     
0034               
0035 304A 0204  20         li    tmp0,colrow
     304C 0050     
0036 304E C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     3050 A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 3052 C160  34         mov   @tv.ruler.visible,tmp1
     3054 A210     
0041 3056 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 3058 0204  20         li    tmp0,pane.botrow-2
     305A 001B     
0043 305C 1002  14         jmp   fb.init.cont
0044 305E 0204  20 !       li    tmp0,pane.botrow-1
     3060 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 3062 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     3064 A31A     
0050 3066 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3068 A31C     
0051               
0052 306A 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     306C A222     
0053 306E 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     3070 A310     
0054 3072 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     3074 A316     
0055 3076 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     3078 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 307A 06A0  32         bl    @film
     307C 224A     
0060 307E D000             data  fb.top,>00,fb.size    ; Clear it all the way
     3080 0000     
     3082 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 3084 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 3086 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 3088 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 308A 045B  20         b     *r11                  ; Return to caller
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
0051 308C 0649  14         dect  stack
0052 308E C64B  30         mov   r11,*stack            ; Save return address
0053 3090 0649  14         dect  stack
0054 3092 C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 3094 0204  20         li    tmp0,idx.top
     3096 B000     
0059 3098 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     309A A502     
0060               
0061 309C C120  34         mov   @tv.sams.b000,tmp0
     309E A206     
0062 30A0 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     30A2 A600     
0063 30A4 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     30A6 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 30A8 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     30AA 0004     
0068 30AC C804  38         mov   tmp0,@idx.sams.hipage ; /
     30AE A604     
0069               
0070 30B0 06A0  32         bl    @_idx.sams.mapcolumn.on
     30B2 30CE     
0071                                                   ; Index in continuous memory region
0072               
0073 30B4 06A0  32         bl    @film
     30B6 224A     
0074 30B8 B000                   data idx.top,>00,idx.size * 5
     30BA 0000     
     30BC 5000     
0075                                                   ; Clear index
0076               
0077 30BE 06A0  32         bl    @_idx.sams.mapcolumn.off
     30C0 3102     
0078                                                   ; Restore memory window layout
0079               
0080 30C2 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     30C4 A602     
     30C6 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 30C8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 30CA C2F9  30         mov   *stack+,r11           ; Pop r11
0088 30CC 045B  20         b     *r11                  ; Return to caller
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
0101 30CE 0649  14         dect  stack
0102 30D0 C64B  30         mov   r11,*stack            ; Push return address
0103 30D2 0649  14         dect  stack
0104 30D4 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 30D6 0649  14         dect  stack
0106 30D8 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 30DA 0649  14         dect  stack
0108 30DC C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 30DE C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     30E0 A602     
0113 30E2 0205  20         li    tmp1,idx.top
     30E4 B000     
0114 30E6 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     30E8 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 30EA 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     30EC 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 30EE 0584  14         inc   tmp0                  ; Next SAMS index page
0123 30F0 0225  22         ai    tmp1,>1000            ; Next memory region
     30F2 1000     
0124 30F4 0606  14         dec   tmp2                  ; Update loop counter
0125 30F6 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 30F8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 30FA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 30FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 30FE C2F9  30         mov   *stack+,r11           ; Pop return address
0134 3100 045B  20         b     *r11                  ; Return to caller
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
0150 3102 0649  14         dect  stack
0151 3104 C64B  30         mov   r11,*stack            ; Push return address
0152 3106 0649  14         dect  stack
0153 3108 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 310A 0649  14         dect  stack
0155 310C C645  30         mov   tmp1,*stack           ; Push tmp1
0156 310E 0649  14         dect  stack
0157 3110 C646  30         mov   tmp2,*stack           ; Push tmp2
0158 3112 0649  14         dect  stack
0159 3114 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 3116 0205  20         li    tmp1,idx.top
     3118 B000     
0164 311A 0206  20         li    tmp2,5                ; Always 5 pages
     311C 0005     
0165 311E 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     3120 A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 3122 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 3124 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3126 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 3128 0225  22         ai    tmp1,>1000            ; Next memory region
     312A 1000     
0176 312C 0606  14         dec   tmp2                  ; Update loop counter
0177 312E 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 3130 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 3132 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 3134 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 3136 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 3138 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 313A 045B  20         b     *r11                  ; Return to caller
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
0211 313C 0649  14         dect  stack
0212 313E C64B  30         mov   r11,*stack            ; Save return address
0213 3140 0649  14         dect  stack
0214 3142 C644  30         mov   tmp0,*stack           ; Push tmp0
0215 3144 0649  14         dect  stack
0216 3146 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 3148 0649  14         dect  stack
0218 314A C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 314C C184  18         mov   tmp0,tmp2             ; Line number
0223 314E 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 3150 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     3152 0800     
0225               
0226 3154 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 3156 0A16  56         sla   tmp2,1                ; line number * 2
0231 3158 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     315A A010     
0232               
0233 315C A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     315E A602     
0234 3160 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     3162 A600     
0235               
0236 3164 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 3166 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     3168 A600     
0242 316A C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     316C A206     
0243 316E C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 3170 0205  20         li    tmp1,>b000            ; Memory window for index page
     3172 B000     
0246               
0247 3174 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     3176 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 3178 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     317A A604     
0254 317C 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 317E C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     3180 A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 3182 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 3184 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 3186 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 3188 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 318A 045B  20         b     *r11                  ; Return to caller
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
0022 318C 0649  14         dect  stack
0023 318E C64B  30         mov   r11,*stack            ; Save return address
0024 3190 0649  14         dect  stack
0025 3192 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3194 0204  20         li    tmp0,edb.top          ; \
     3196 C000     
0030 3198 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     319A A500     
0031 319C C804  38         mov   tmp0,@edb.next_free.ptr
     319E A508     
0032                                                   ; Set pointer to next free line
0033               
0034 31A0 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     31A2 A50A     
0035               
0036 31A4 0204  20         li    tmp0,1
     31A6 0001     
0037 31A8 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     31AA A504     
0038               
0039 31AC 0720  34         seto  @edb.block.m1         ; Reset block start line
     31AE A50C     
0040 31B0 0720  34         seto  @edb.block.m2         ; Reset block end line
     31B2 A50E     
0041               
0042 31B4 0204  20         li    tmp0,txt.newfile      ; "New file"
     31B6 37EC     
0043 31B8 C804  38         mov   tmp0,@edb.filename.ptr
     31BA A512     
0044               
0045 31BC 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     31BE A440     
0046 31C0 04E0  34         clr   @fh.kilobytes.prev    ; /
     31C2 A45C     
0047               
0048 31C4 0204  20         li    tmp0,txt.filetype.none
     31C6 38A8     
0049 31C8 C804  38         mov   tmp0,@edb.filetype.ptr
     31CA A514     
0050               
0051               edb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 31CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 31CE C2F9  30         mov   *stack+,r11           ; Pop r11
0057 31D0 045B  20         b     *r11                  ; Return to caller
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
0022 31D2 0649  14         dect  stack
0023 31D4 C64B  30         mov   r11,*stack            ; Save return address
0024 31D6 0649  14         dect  stack
0025 31D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31DA 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     31DC E000     
0030 31DE C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     31E0 A700     
0031               
0032 31E2 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     31E4 A702     
0033 31E6 0204  20         li    tmp0,4
     31E8 0004     
0034 31EA C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     31EC A706     
0035 31EE C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     31F0 A708     
0036               
0037 31F2 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     31F4 A716     
0038 31F6 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     31F8 A718     
0039 31FA 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     31FC A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 31FE 06A0  32         bl    @film
     3200 224A     
0044 3202 E000             data  cmdb.top,>00,cmdb.size
     3204 0000     
     3206 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3208 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 320A C2F9  30         mov   *stack+,r11           ; Pop r11
0052 320C 045B  20         b     *r11                  ; Return to caller
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
0022 320E 0649  14         dect  stack
0023 3210 C64B  30         mov   r11,*stack            ; Save return address
0024 3212 0649  14         dect  stack
0025 3214 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3216 0649  14         dect  stack
0027 3218 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 321A 0649  14         dect  stack
0029 321C C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 321E 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3220 A228     
0034 3222 0204  20         li    tmp0,3
     3224 0003     
0035 3226 C804  38         mov   tmp0,@tv.error.rows   ; Number of rows in error pane
     3228 A22A     
0036               
0037 322A 06A0  32         bl    @film
     322C 224A     
0038 322E A22E                   data tv.error.msg,0,160
     3230 0000     
     3232 00A0     
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               errpane.exit:
0043 3234 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 3236 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 3238 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 323A C2F9  30         mov   *stack+,r11           ; Pop R11
0047 323C 045B  20         b     *r11                  ; Return to caller
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
0022 323E 0649  14         dect  stack
0023 3240 C64B  30         mov   r11,*stack            ; Save return address
0024 3242 0649  14         dect  stack
0025 3244 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3246 0649  14         dect  stack
0027 3248 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 324A 0649  14         dect  stack
0029 324C C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 324E 0204  20         li    tmp0,1                ; \ Set default color scheme
     3250 0001     
0034 3252 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3254 A212     
0035               
0036 3256 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3258 A224     
0037 325A E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     325C 200C     
0038               
0039 325E 0204  20         li    tmp0,fj.bottom
     3260 B000     
0040 3262 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     3264 A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 3266 06A0  32         bl    @cpym2m
     3268 24EE     
0045 326A 3980                   data def.printer.fname,tv.printer.fname,7
     326C D960     
     326E 0007     
0046               
0047 3270 06A0  32         bl    @cpym2m
     3272 24EE     
0048 3274 3988                   data def.clip.fname,tv.clip.fname,10
     3276 D9B0     
     3278 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 327A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 327C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 327E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 3280 C2F9  30         mov   *stack+,r11           ; Pop R11
0057 3282 045B  20         b     *r11                  ; Return to caller
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
0023 3284 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     3286 27BA     
0024                       ;-------------------------------------------------------
0025                       ; Load legacy SAMS page layout and exit to monitor
0026                       ;-------------------------------------------------------
0027 3288 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     328A 2F9A     
0028 328C 600E                   data bank7.rom        ; | i  p0 = bank address
0029 328E 7FC0                   data bankx.vectab     ; | i  p1 = Vector with target address
0030 3290 600A                   data bankid           ; / i  p2 = Source ROM bank for return
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
0023 3292 0649  14         dect  stack
0024 3294 C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Reset editor
0027                       ;------------------------------------------------------
0028 3296 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3298 31D2     
0029 329A 06A0  32         bl    @edb.init             ; Initialize editor buffer
     329C 318C     
0030 329E 06A0  32         bl    @idx.init             ; Initialize index
     32A0 308C     
0031 32A2 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32A4 302A     
0032 32A6 06A0  32         bl    @errpane.init         ; Initialize error pane
     32A8 320E     
0033                       ;------------------------------------------------------
0034                       ; Remove markers and shortcuts
0035                       ;------------------------------------------------------
0036 32AA 06A0  32         bl    @hchar
     32AC 27E6     
0037 32AE 0034                   byte 0,52,32,18           ; Remove markers
     32B0 2012     
0038 32B2 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     32B4 2033     
0039 32B6 FFFF                   data eol
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               tv.reset.exit:
0044 32B8 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 32BA 045B  20         b     *r11                  ; Return to caller
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
0020 32BC 0649  14         dect  stack
0021 32BE C64B  30         mov   r11,*stack            ; Save return address
0022 32C0 0649  14         dect  stack
0023 32C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32C4 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32C6 29B6     
0028 32C8 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32CA A100                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32CC 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 32CD   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32CE 0204  20         li    tmp0,unpacked.string
     32D0 A026     
0034 32D2 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32D4 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32D6 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32D8 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32DA 2A0E     
0039 32DC A100                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32DE A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32E0 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 32E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 32E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 32E6 045B  20         b     *r11                  ; Return to caller
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
0024 32E8 0649  14         dect  stack
0025 32EA C64B  30         mov   r11,*stack            ; Push return address
0026 32EC 0649  14         dect  stack
0027 32EE C644  30         mov   tmp0,*stack           ; Push tmp0
0028 32F0 0649  14         dect  stack
0029 32F2 C645  30         mov   tmp1,*stack           ; Push tmp1
0030 32F4 0649  14         dect  stack
0031 32F6 C646  30         mov   tmp2,*stack           ; Push tmp2
0032 32F8 0649  14         dect  stack
0033 32FA C647  30         mov   tmp3,*stack           ; Push tmp3
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 32FC C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     32FE A000     
0038 3300 D194  26         movb  *tmp0,tmp2            ; /
0039 3302 0986  56         srl   tmp2,8                ; Right align
0040 3304 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0041               
0042 3306 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3308 A002     
0043 330A 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0044                       ;------------------------------------------------------
0045                       ; Copy string to buffer
0046                       ;------------------------------------------------------
0047 330C C120  34         mov   @parm1,tmp0           ; Get source address
     330E A000     
0048 3310 C160  34         mov   @parm4,tmp1           ; Get destination address
     3312 A006     
0049 3314 0586  14         inc   tmp2                  ; Also include length-byte in copy
0050               
0051 3316 0649  14         dect  stack
0052 3318 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0053               
0054 331A 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     331C 24F4     
0055                                                   ; \ i  tmp0 = Source CPU memory address
0056                                                   ; | i  tmp1 = Target CPU memory address
0057                                                   ; / i  tmp2 = Number of bytes to copy
0058               
0059 331E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0060                       ;------------------------------------------------------
0061                       ; Set length of new string
0062                       ;------------------------------------------------------
0063 3320 C120  34         mov   @parm2,tmp0           ; Get requested length
     3322 A002     
0064 3324 0A84  56         sla   tmp0,8                ; Left align
0065 3326 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3328 A006     
0066 332A D544  30         movb  tmp0,*tmp1            ; Set new length of string
0067 332C A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0068 332E 0585  14         inc   tmp1                  ; /
0069                       ;------------------------------------------------------
0070                       ; Prepare for padding string
0071                       ;------------------------------------------------------
0072 3330 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     3332 A002     
0073 3334 6187  18         s     tmp3,tmp2             ; |
0074 3336 0586  14         inc   tmp2                  ; /
0075               
0076 3338 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     333A A004     
0077 333C 0A84  56         sla   tmp0,8                ; Left align
0078                       ;------------------------------------------------------
0079                       ; Right-pad string to destination length
0080                       ;------------------------------------------------------
0081               tv.pad.string.loop:
0082 333E DD44  32         movb  tmp0,*tmp1+           ; Pad character
0083 3340 0606  14         dec   tmp2                  ; Update loop counter
0084 3342 15FD  14         jgt   tv.pad.string.loop    ; Next character
0085               
0086 3344 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3346 A006     
     3348 A010     
0087 334A 1004  14         jmp   tv.pad.string.exit    ; Exit
0088                       ;-----------------------------------------------------------------------
0089                       ; CPU crash
0090                       ;-----------------------------------------------------------------------
0091               tv.pad.string.panic:
0092 334C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     334E FFCE     
0093 3350 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3352 2026     
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               tv.pad.string.exit:
0098 3354 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0099 3356 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 3358 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 335A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 335C C2F9  30         mov   *stack+,r11           ; Pop r11
0103 335E 045B  20         b     *r11                  ; Return to caller
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
0022 3360 0649  14         dect  stack
0023 3362 C64B  30         mov   r11,*stack            ; Save return address
0024 3364 0649  14         dect  stack
0025 3366 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3368 0649  14         dect  stack
0027 336A C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 336C C120  34         mov   @parm1,tmp0           ; Get line number
     336E A000     
0032 3370 C160  34         mov   @parm2,tmp1           ; Get pointer
     3372 A002     
0033 3374 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 3376 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     3378 0FFF     
0039 337A 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 337C 06E0  34         swpb  @parm3
     337E A004     
0044 3380 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     3382 A004     
0045 3384 06E0  34         swpb  @parm3                ; \ Restore original order again,
     3386 A004     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 3388 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     338A 313C     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 338C C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     338E A010     
0056 3390 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     3392 B000     
0057 3394 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     3396 A010     
0058 3398 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 339A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     339C 313C     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 339E C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     33A0 A010     
0068 33A2 04E4  34         clr   @idx.top(tmp0)        ; /
     33A4 B000     
0069 33A6 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     33A8 A010     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 33AA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 33AC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 33AE C2F9  30         mov   *stack+,r11           ; Pop r11
0077 33B0 045B  20         b     *r11                  ; Return to caller
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
0021 33B2 0649  14         dect  stack
0022 33B4 C64B  30         mov   r11,*stack            ; Save return address
0023 33B6 0649  14         dect  stack
0024 33B8 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 33BA 0649  14         dect  stack
0026 33BC C645  30         mov   tmp1,*stack           ; Push tmp1
0027 33BE 0649  14         dect  stack
0028 33C0 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 33C2 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     33C4 A000     
0033               
0034 33C6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     33C8 313C     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 33CA C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     33CC A010     
0039 33CE C164  34         mov   @idx.top(tmp0),tmp1   ; /
     33D0 B000     
0040               
0041 33D2 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 33D4 C185  18         mov   tmp1,tmp2             ; \
0047 33D6 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 33D8 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     33DA 00FF     
0052 33DC 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 33DE 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     33E0 C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 33E2 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     33E4 A010     
0059 33E6 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     33E8 A012     
0060 33EA 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 33EC 04E0  34         clr   @outparm1
     33EE A010     
0066 33F0 04E0  34         clr   @outparm2
     33F2 A012     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 33F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 33F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 33F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 33FA C2F9  30         mov   *stack+,r11           ; Pop r11
0075 33FC 045B  20         b     *r11                  ; Return to caller
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
0017 33FE 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     3400 B000     
0018 3402 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 3404 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 3406 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 3408 0606  14         dec   tmp2                  ; tmp2--
0026 340A 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 340C 045B  20         b     *r11                  ; Return to caller
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
0046 340E 0649  14         dect  stack
0047 3410 C64B  30         mov   r11,*stack            ; Save return address
0048 3412 0649  14         dect  stack
0049 3414 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 3416 0649  14         dect  stack
0051 3418 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 341A 0649  14         dect  stack
0053 341C C646  30         mov   tmp2,*stack           ; Push tmp2
0054 341E 0649  14         dect  stack
0055 3420 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 3422 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     3424 A000     
0060               
0061 3426 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3428 313C     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 342A C120  34         mov   @outparm1,tmp0        ; Index offset
     342C A010     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 342E C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     3430 A002     
0070 3432 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 3434 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3436 A000     
0074 3438 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 343A 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     343C B000     
0081 343E 04D4  26         clr   *tmp0                 ; Clear index entry
0082 3440 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 3442 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     3444 A002     
0088 3446 0287  22         ci    tmp3,2048
     3448 0800     
0089 344A 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 344C 06A0  32         bl    @_idx.sams.mapcolumn.on
     344E 30CE     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 3450 C120  34         mov   @parm1,tmp0           ; Restore line number
     3452 A000     
0103 3454 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 3456 06A0  32         bl    @_idx.entry.delete.reorg
     3458 33FE     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 345A 06A0  32         bl    @_idx.sams.mapcolumn.off
     345C 3102     
0111                                                   ; Restore memory window layout
0112               
0113 345E 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 3460 06A0  32         bl    @_idx.entry.delete.reorg
     3462 33FE     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 3464 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 3466 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 3468 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 346A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 346C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 346E C2F9  30         mov   *stack+,r11           ; Pop r11
0132 3470 045B  20         b     *r11                  ; Return to caller
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
0017 3472 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     3474 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 3476 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 3478 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     347A FFCE     
0027 347C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     347E 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 3480 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     3482 B000     
0032 3484 C144  18         mov   tmp0,tmp1             ; a = current slot
0033 3486 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 3488 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 348A C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 348C 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 348E 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 3490 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 3492 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     3494 AFFC     
0043 3496 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 3498 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     349A FFCE     
0049 349C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     349E 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 34A0 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 34A2 0644  14         dect  tmp0                  ; Move pointer up
0056 34A4 0645  14         dect  tmp1                  ; Move pointer up
0057 34A6 0606  14         dec   tmp2                  ; Next index entry
0058 34A8 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 34AA 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 34AC 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 34AE 045B  20         b     *r11                  ; Return to caller
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
0088 34B0 0649  14         dect  stack
0089 34B2 C64B  30         mov   r11,*stack            ; Save return address
0090 34B4 0649  14         dect  stack
0091 34B6 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 34B8 0649  14         dect  stack
0093 34BA C645  30         mov   tmp1,*stack           ; Push tmp1
0094 34BC 0649  14         dect  stack
0095 34BE C646  30         mov   tmp2,*stack           ; Push tmp2
0096 34C0 0649  14         dect  stack
0097 34C2 C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 34C4 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     34C6 A002     
0102 34C8 61A0  34         s     @parm1,tmp2           ; Calculate loop
     34CA A000     
0103 34CC 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 34CE C1E0  34         mov   @parm2,tmp3
     34D0 A002     
0110 34D2 0287  22         ci    tmp3,2048
     34D4 0800     
0111 34D6 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 34D8 06A0  32         bl    @_idx.sams.mapcolumn.on
     34DA 30CE     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 34DC C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     34DE A002     
0123 34E0 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 34E2 06A0  32         bl    @_idx.entry.insert.reorg
     34E4 3472     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 34E6 06A0  32         bl    @_idx.sams.mapcolumn.off
     34E8 3102     
0131                                                   ; Restore memory window layout
0132               
0133 34EA 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 34EC C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     34EE A002     
0139               
0140 34F0 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     34F2 313C     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 34F4 C120  34         mov   @outparm1,tmp0        ; Index offset
     34F6 A010     
0145               
0146 34F8 06A0  32         bl    @_idx.entry.insert.reorg
     34FA 3472     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 34FC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 34FE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 3500 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 3502 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 3504 C2F9  30         mov   *stack+,r11           ; Pop r11
0160 3506 045B  20         b     *r11                  ; Return to caller
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
0021 3508 0649  14         dect  stack
0022 350A C64B  30         mov   r11,*stack            ; Push return address
0023 350C 0649  14         dect  stack
0024 350E C644  30         mov   tmp0,*stack           ; Push tmp0
0025 3510 0649  14         dect  stack
0026 3512 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 3514 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     3516 A504     
0031 3518 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 351A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     351C FFCE     
0037 351E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3520 2026     
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 3522 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     3524 A000     
0043               
0044 3526 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     3528 33B2     
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 352A C120  34         mov   @outparm2,tmp0        ; SAMS page
     352C A012     
0050 352E C160  34         mov   @outparm1,tmp1        ; Pointer to line
     3530 A010     
0051 3532 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 3534 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     3536 A208     
0057 3538 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 353A 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     353C 258A     
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 353E C820  54         mov   @outparm2,@tv.sams.c000
     3540 A012     
     3542 A208     
0066                                                   ; Set page in shadow registers
0067               
0068 3544 C820  54         mov   @outparm2,@edb.sams.page
     3546 A012     
     3548 A516     
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 354A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 354C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 354E C2F9  30         mov   *stack+,r11           ; Pop r11
0077 3550 045B  20         b     *r11                  ; Return to caller
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
0021 3552 0649  14         dect  stack
0022 3554 C64B  30         mov   r11,*stack            ; Push return address
0023 3556 0649  14         dect  stack
0024 3558 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 355A 0649  14         dect  stack
0026 355C C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 355E 04E0  34         clr   @outparm1             ; Reset length
     3560 A010     
0031 3562 04E0  34         clr   @outparm2             ; Reset SAMS bank
     3564 A012     
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 3566 C120  34         mov   @parm1,tmp0           ; \
     3568 A000     
0036 356A 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 356C 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     356E A504     
0039 3570 1101  14         jlt   !                     ; No, continue processing
0040 3572 100F  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 3574 C120  34 !       mov   @parm1,tmp0           ; Get line
     3576 A000     
0046               
0047 3578 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     357A 3508     
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 357C C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     357E A010     
0053 3580 1308  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 3582 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 3584 C805  38         mov   tmp1,@outparm1        ; Save length
     3586 A010     
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 3588 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     358A 0050     
0064 358C 1204  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system or limit length to 80
0068                       ;------------------------------------------------------
0073 358E 0205  20         li    tmp1,80               ; Only process first 80 characters
     3590 0050     
0075                       ;------------------------------------------------------
0076                       ; Set length to 0 if null-pointer
0077                       ;------------------------------------------------------
0078               edb.line.getlength.null:
0079 3592 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     3594 A010     
0080                       ;------------------------------------------------------
0081                       ; Exit
0082                       ;------------------------------------------------------
0083               edb.line.getlength.exit:
0084 3596 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0085 3598 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0086 359A C2F9  30         mov   *stack+,r11           ; Pop r11
0087 359C 045B  20         b     *r11                  ; Return to caller
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
0107 359E 0649  14         dect  stack
0108 35A0 C64B  30         mov   r11,*stack            ; Save return address
0109 35A2 0649  14         dect  stack
0110 35A4 C644  30         mov   tmp0,*stack           ; Push tmp0
0111                       ;------------------------------------------------------
0112                       ; Calculate line in editor buffer
0113                       ;------------------------------------------------------
0114 35A6 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     35A8 A304     
0115 35AA A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     35AC A306     
0116                       ;------------------------------------------------------
0117                       ; Get length
0118                       ;------------------------------------------------------
0119 35AE C804  38         mov   tmp0,@parm1
     35B0 A000     
0120 35B2 06A0  32         bl    @edb.line.getlength
     35B4 3552     
0121 35B6 C820  54         mov   @outparm1,@fb.row.length
     35B8 A010     
     35BA A308     
0122                                                   ; Save row length
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               edb.line.getlength2.exit:
0127 35BC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 35BE C2F9  30         mov   *stack+,r11           ; Pop R11
0129 35C0 045B  20         b     *r11                  ; Return to caller
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
0021 35C2 0649  14         dect  stack
0022 35C4 C64B  30         mov   r11,*stack            ; Push return address
0023 35C6 0649  14         dect  stack
0024 35C8 C660  46         mov   @wyx,*stack           ; Push cursor position
     35CA 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 35CC 06A0  32         bl    @hchar
     35CE 27E6     
0029 35D0 0034                   byte 0,52,32,18
     35D2 2012     
0030 35D4 FFFF                   data EOL              ; Clear message
0031               
0032 35D6 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     35D8 A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 35DA C839  50         mov   *stack+,@wyx          ; Pop cursor position
     35DC 832A     
0038 35DE C2F9  30         mov   *stack+,r11           ; Pop R11
0039 35E0 045B  20         b     *r11                  ; Return to task
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
0033 35E2 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     35E4 003F     
     35E6 0243     
     35E8 05F4     
     35EA 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 35EC 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     35EE 000C     
     35F0 0006     
     35F2 0007     
     35F4 0020     
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
0067 35F6 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     35F8 000C     
     35FA 0006     
     35FC 0007     
     35FE 0020     
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
0098 3600 0000             data  >0000,>0001           ; Cursor
     3602 0001     
0099 3604 0000             data  >0000,>0101           ; Current line indicator     <
     3606 0101     
0100 3608 0820             data  >0820,>0201           ; Current column indicator   v
     360A 0201     
0101               nosprite:
0102 360C D000             data  >d000                 ; End-of-Sprites list
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
0157 360E F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     3610 F171     
     3612 1B1F     
     3614 71B1     
0158 3616 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     3618 F0FF     
     361A 1F1A     
     361C F1FF     
0159 361E 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     3620 F0FF     
     3622 1F12     
     3624 F1F6     
0160 3626 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     3628 1E11     
     362A 1A17     
     362C 1E11     
0161 362E E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     3630 E1FF     
     3632 1F1E     
     3634 E1FF     
0162 3636 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     3638 1016     
     363A 1B71     
     363C 1711     
0163 363E 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3640 1011     
     3642 F1F1     
     3644 1F11     
0164 3646 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     3648 A1FF     
     364A 1F1F     
     364C F11F     
0165 364E 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     3650 12FF     
     3652 1B12     
     3654 12FF     
0166 3656 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     3658 E1FF     
     365A 1B1F     
     365C F131     
0167                       even
0168               
0169               tv.tabs.table:
0170 365E 0007             byte  0,7,12,25               ; \   Default tab positions as used
     3660 0C19     
0171 3662 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     3664 3B4F     
0172 3666 FF00             byte  >ff,0,0,0               ; |
     3668 0000     
0173 366A 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     366C 0000     
0174 366E 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     3670 0000     
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
0009 3672 01               byte  1
0010 3673   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 3674 05               byte  5
0015 3675   20             text  '  BOT'
     3676 2042     
     3678 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 367A 03               byte  3
0020 367B   4F             text  'OVR'
     367C 5652     
0021                       even
0022               
0023               txt.insert
0024 367E 03               byte  3
0025 367F   49             text  'INS'
     3680 4E53     
0026                       even
0027               
0028               txt.star
0029 3682 01               byte  1
0030 3683   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 3684 0A               byte  10
0035 3685   4C             text  'Loading...'
     3686 6F61     
     3688 6469     
     368A 6E67     
     368C 2E2E     
     368E 2E       
0036                       even
0037               
0038               txt.saving
0039 3690 0A               byte  10
0040 3691   53             text  'Saving....'
     3692 6176     
     3694 696E     
     3696 672E     
     3698 2E2E     
     369A 2E       
0041                       even
0042               
0043               txt.printing
0044 369C 12               byte  18
0045 369D   50             text  'Printing file.....'
     369E 7269     
     36A0 6E74     
     36A2 696E     
     36A4 6720     
     36A6 6669     
     36A8 6C65     
     36AA 2E2E     
     36AC 2E2E     
     36AE 2E       
0046                       even
0047               
0048               txt.block.del
0049 36B0 12               byte  18
0050 36B1   44             text  'Deleting block....'
     36B2 656C     
     36B4 6574     
     36B6 696E     
     36B8 6720     
     36BA 626C     
     36BC 6F63     
     36BE 6B2E     
     36C0 2E2E     
     36C2 2E       
0051                       even
0052               
0053               txt.block.copy
0054 36C4 11               byte  17
0055 36C5   43             text  'Copying block....'
     36C6 6F70     
     36C8 7969     
     36CA 6E67     
     36CC 2062     
     36CE 6C6F     
     36D0 636B     
     36D2 2E2E     
     36D4 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 36D6 10               byte  16
0060 36D7   4D             text  'Moving block....'
     36D8 6F76     
     36DA 696E     
     36DC 6720     
     36DE 626C     
     36E0 6F63     
     36E2 6B2E     
     36E4 2E2E     
     36E6 2E       
0061                       even
0062               
0063               txt.block.save
0064 36E8 18               byte  24
0065 36E9   53             text  'Saving block to file....'
     36EA 6176     
     36EC 696E     
     36EE 6720     
     36F0 626C     
     36F2 6F63     
     36F4 6B20     
     36F6 746F     
     36F8 2066     
     36FA 696C     
     36FC 652E     
     36FE 2E2E     
     3700 2E       
0066                       even
0067               
0068               txt.block.clip
0069 3702 18               byte  24
0070 3703   43             text  'Copying to clipboard....'
     3704 6F70     
     3706 7969     
     3708 6E67     
     370A 2074     
     370C 6F20     
     370E 636C     
     3710 6970     
     3712 626F     
     3714 6172     
     3716 642E     
     3718 2E2E     
     371A 2E       
0071                       even
0072               
0073               txt.block.print
0074 371C 12               byte  18
0075 371D   50             text  'Printing block....'
     371E 7269     
     3720 6E74     
     3722 696E     
     3724 6720     
     3726 626C     
     3728 6F63     
     372A 6B2E     
     372C 2E2E     
     372E 2E       
0076                       even
0077               
0078               txt.clearmem
0079 3730 13               byte  19
0080 3731   43             text  'Clearing memory....'
     3732 6C65     
     3734 6172     
     3736 696E     
     3738 6720     
     373A 6D65     
     373C 6D6F     
     373E 7279     
     3740 2E2E     
     3742 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 3744 0E               byte  14
0085 3745   4C             text  'Load completed'
     3746 6F61     
     3748 6420     
     374A 636F     
     374C 6D70     
     374E 6C65     
     3750 7465     
     3752 64       
0086                       even
0087               
0088               txt.done.insert
0089 3754 10               byte  16
0090 3755   49             text  'Insert completed'
     3756 6E73     
     3758 6572     
     375A 7420     
     375C 636F     
     375E 6D70     
     3760 6C65     
     3762 7465     
     3764 64       
0091                       even
0092               
0093               txt.done.append
0094 3766 10               byte  16
0095 3767   41             text  'Append completed'
     3768 7070     
     376A 656E     
     376C 6420     
     376E 636F     
     3770 6D70     
     3772 6C65     
     3774 7465     
     3776 64       
0096                       even
0097               
0098               txt.done.save
0099 3778 0E               byte  14
0100 3779   53             text  'Save completed'
     377A 6176     
     377C 6520     
     377E 636F     
     3780 6D70     
     3782 6C65     
     3784 7465     
     3786 64       
0101                       even
0102               
0103               txt.done.copy
0104 3788 0E               byte  14
0105 3789   43             text  'Copy completed'
     378A 6F70     
     378C 7920     
     378E 636F     
     3790 6D70     
     3792 6C65     
     3794 7465     
     3796 64       
0106                       even
0107               
0108               txt.done.print
0109 3798 0F               byte  15
0110 3799   50             text  'Print completed'
     379A 7269     
     379C 6E74     
     379E 2063     
     37A0 6F6D     
     37A2 706C     
     37A4 6574     
     37A6 6564     
0111                       even
0112               
0113               txt.done.delete
0114 37A8 10               byte  16
0115 37A9   44             text  'Delete completed'
     37AA 656C     
     37AC 6574     
     37AE 6520     
     37B0 636F     
     37B2 6D70     
     37B4 6C65     
     37B6 7465     
     37B8 64       
0116                       even
0117               
0118               txt.done.clipboard
0119 37BA 0F               byte  15
0120 37BB   43             text  'Clipboard saved'
     37BC 6C69     
     37BE 7062     
     37C0 6F61     
     37C2 7264     
     37C4 2073     
     37C6 6176     
     37C8 6564     
0121                       even
0122               
0123               txt.done.clipdev
0124 37CA 0D               byte  13
0125 37CB   43             text  'Clipboard set'
     37CC 6C69     
     37CE 7062     
     37D0 6F61     
     37D2 7264     
     37D4 2073     
     37D6 6574     
0126                       even
0127               
0128               txt.fastmode
0129 37D8 08               byte  8
0130 37D9   46             text  'Fastmode'
     37DA 6173     
     37DC 746D     
     37DE 6F64     
     37E0 65       
0131                       even
0132               
0133               txt.kb
0134 37E2 02               byte  2
0135 37E3   6B             text  'kb'
     37E4 62       
0136                       even
0137               
0138               txt.lines
0139 37E6 05               byte  5
0140 37E7   4C             text  'Lines'
     37E8 696E     
     37EA 6573     
0141                       even
0142               
0143               txt.newfile
0144 37EC 0A               byte  10
0145 37ED   5B             text  '[New file]'
     37EE 4E65     
     37F0 7720     
     37F2 6669     
     37F4 6C65     
     37F6 5D       
0146                       even
0147               
0148               txt.filetype.dv80
0149 37F8 04               byte  4
0150 37F9   44             text  'DV80'
     37FA 5638     
     37FC 30       
0151                       even
0152               
0153               txt.m1
0154 37FE 03               byte  3
0155 37FF   4D             text  'M1='
     3800 313D     
0156                       even
0157               
0158               txt.m2
0159 3802 03               byte  3
0160 3803   4D             text  'M2='
     3804 323D     
0161                       even
0162               
0163               txt.keys.default
0164 3806 07               byte  7
0165 3807   46             text  'F9-Menu'
     3808 392D     
     380A 4D65     
     380C 6E75     
0166                       even
0167               
0168               txt.keys.block
0169 380E 36               byte  54
0170 380F   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     3810 392D     
     3812 4261     
     3814 636B     
     3816 2020     
     3818 5E43     
     381A 6F70     
     381C 7920     
     381E 205E     
     3820 4D6F     
     3822 7665     
     3824 2020     
     3826 5E44     
     3828 656C     
     382A 2020     
     382C 5E53     
     382E 6176     
     3830 6520     
     3832 205E     
     3834 5072     
     3836 696E     
     3838 7420     
     383A 205E     
     383C 5B31     
     383E 2D35     
     3840 5D43     
     3842 6C69     
     3844 70       
0171                       even
0172               
0173 3846 2E2E     txt.ruler          text    '.........'
     3848 2E2E     
     384A 2E2E     
     384C 2E2E     
     384E 2E       
0174 384F   12                        byte    18
0175 3850 2E2E                        text    '.........'
     3852 2E2E     
     3854 2E2E     
     3856 2E2E     
     3858 2E       
0176 3859   13                        byte    19
0177 385A 2E2E                        text    '.........'
     385C 2E2E     
     385E 2E2E     
     3860 2E2E     
     3862 2E       
0178 3863   14                        byte    20
0179 3864 2E2E                        text    '.........'
     3866 2E2E     
     3868 2E2E     
     386A 2E2E     
     386C 2E       
0180 386D   15                        byte    21
0181 386E 2E2E                        text    '.........'
     3870 2E2E     
     3872 2E2E     
     3874 2E2E     
     3876 2E       
0182 3877   16                        byte    22
0183 3878 2E2E                        text    '.........'
     387A 2E2E     
     387C 2E2E     
     387E 2E2E     
     3880 2E       
0184 3881   17                        byte    23
0185 3882 2E2E                        text    '.........'
     3884 2E2E     
     3886 2E2E     
     3888 2E2E     
     388A 2E       
0186 388B   18                        byte    24
0187 388C 2E2E                        text    '.........'
     388E 2E2E     
     3890 2E2E     
     3892 2E2E     
     3894 2E       
0188 3895   19                        byte    25
0189                                  even
0190 3896 020E     txt.alpha.down     data >020e,>0f00
     3898 0F00     
0191 389A 0110     txt.vertline       data >0110
0192 389C 011C     txt.keymarker      byte 1,28
0193               
0194               txt.ws1
0195 389E 01               byte  1
0196 389F   20             text  ' '
0197                       even
0198               
0199               txt.ws2
0200 38A0 02               byte  2
0201 38A1   20             text  '  '
     38A2 20       
0202                       even
0203               
0204               txt.ws3
0205 38A4 03               byte  3
0206 38A5   20             text  '   '
     38A6 2020     
0207                       even
0208               
0209               txt.ws4
0210 38A8 04               byte  4
0211 38A9   20             text  '    '
     38AA 2020     
     38AC 20       
0212                       even
0213               
0214               txt.ws5
0215 38AE 05               byte  5
0216 38AF   20             text  '     '
     38B0 2020     
     38B2 2020     
0217                       even
0218               
0219      38A8     txt.filetype.none  equ txt.ws4
0220               
0221               
0222               ;--------------------------------------------------------------
0223               ; Strings for error line pane
0224               ;--------------------------------------------------------------
0225               txt.ioerr.load
0226 38B4 15               byte  21
0227 38B5   46             text  'Failed loading file: '
     38B6 6169     
     38B8 6C65     
     38BA 6420     
     38BC 6C6F     
     38BE 6164     
     38C0 696E     
     38C2 6720     
     38C4 6669     
     38C6 6C65     
     38C8 3A20     
0228                       even
0229               
0230               txt.ioerr.save
0231 38CA 14               byte  20
0232 38CB   46             text  'Failed saving file: '
     38CC 6169     
     38CE 6C65     
     38D0 6420     
     38D2 7361     
     38D4 7669     
     38D6 6E67     
     38D8 2066     
     38DA 696C     
     38DC 653A     
     38DE 20       
0233                       even
0234               
0235               txt.ioerr.print
0236 38E0 1B               byte  27
0237 38E1   46             text  'Failed printing to device: '
     38E2 6169     
     38E4 6C65     
     38E6 6420     
     38E8 7072     
     38EA 696E     
     38EC 7469     
     38EE 6E67     
     38F0 2074     
     38F2 6F20     
     38F4 6465     
     38F6 7669     
     38F8 6365     
     38FA 3A20     
0238                       even
0239               
0240               txt.io.nofile
0241 38FC 16               byte  22
0242 38FD   4E             text  'No filename specified.'
     38FE 6F20     
     3900 6669     
     3902 6C65     
     3904 6E61     
     3906 6D65     
     3908 2073     
     390A 7065     
     390C 6369     
     390E 6669     
     3910 6564     
     3912 2E       
0243                       even
0244               
0245               txt.memfull.load
0246 3914 2D               byte  45
0247 3915   49             text  'Index full. File too large for editor buffer.'
     3916 6E64     
     3918 6578     
     391A 2066     
     391C 756C     
     391E 6C2E     
     3920 2046     
     3922 696C     
     3924 6520     
     3926 746F     
     3928 6F20     
     392A 6C61     
     392C 7267     
     392E 6520     
     3930 666F     
     3932 7220     
     3934 6564     
     3936 6974     
     3938 6F72     
     393A 2062     
     393C 7566     
     393E 6665     
     3940 722E     
0248                       even
0249               
0250               txt.block.inside
0251 3942 2D               byte  45
0252 3943   43             text  'Copy/Move target must be outside M1-M2 range.'
     3944 6F70     
     3946 792F     
     3948 4D6F     
     394A 7665     
     394C 2074     
     394E 6172     
     3950 6765     
     3952 7420     
     3954 6D75     
     3956 7374     
     3958 2062     
     395A 6520     
     395C 6F75     
     395E 7473     
     3960 6964     
     3962 6520     
     3964 4D31     
     3966 2D4D     
     3968 3220     
     396A 7261     
     396C 6E67     
     396E 652E     
0253                       even
0254               
0255               
0256               ;--------------------------------------------------------------
0257               ; Strings for command buffer
0258               ;--------------------------------------------------------------
0259               txt.cmdb.prompt
0260 3970 01               byte  1
0261 3971   3E             text  '>'
0262                       even
0263               
0264               txt.colorscheme
0265 3972 0D               byte  13
0266 3973   43             text  'Color scheme:'
     3974 6F6C     
     3976 6F72     
     3978 2073     
     397A 6368     
     397C 656D     
     397E 653A     
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
0008 3980 06               byte  6
0009 3981   50             text  'PI.PIO'
     3982 492E     
     3984 5049     
     3986 4F       
0010                       even
0011               
0012               def.clip.fname
0013 3988 09               byte  9
0014 3989   44             text  'DSK1.CLIP'
     398A 534B     
     398C 312E     
     398E 434C     
     3990 4950     
0015                       even
0016               
0017               def.clip.fname.b
0018 3992 09               byte  9
0019 3993   44             text  'DSK2.CLIP'
     3994 534B     
     3996 322E     
     3998 434C     
     399A 4950     
0020                       even
0021               
0022               def.clip.fname.c
0023 399C 09               byte  9
0024 399D   54             text  'TIPI.CLIP'
     399E 4950     
     39A0 492E     
     39A2 434C     
     39A4 4950     
0025                       even
0026               
0027               def.devices
0028 39A6 2F               byte  47
0029 39A7   2C             text  ',DSK,HDX,IDE,PI.,PIO,TIPI.,RD,SCS,SDD,WDS,RS232'
     39A8 4453     
     39AA 4B2C     
     39AC 4844     
     39AE 582C     
     39B0 4944     
     39B2 452C     
     39B4 5049     
     39B6 2E2C     
     39B8 5049     
     39BA 4F2C     
     39BC 5449     
     39BE 5049     
     39C0 2E2C     
     39C2 5244     
     39C4 2C53     
     39C6 4353     
     39C8 2C53     
     39CA 4444     
     39CC 2C57     
     39CE 4453     
     39D0 2C52     
     39D2 5332     
     39D4 3332     
0030                       even
0031               
                   < ram.resident.asm
                   < stevie_b5.asm.60011
0038                       ;------------------------------------------------------
0039                       ; Activate bank 1 and branch to  >6036
0040                       ;------------------------------------------------------
0041 39D6 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     39D8 6002     
0042               
0046               
0047 39DA 0460  28         b     @kickstart.code2      ; Jump to entry routine
     39DC 6046     
0048               ***************************************************************
0049               * Step 3: Include main editor modules
0050               ********|*****|*********************|**************************
0051               main:
0052                       aorg  kickstart.code2       ; >6046
0053 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 2026     
0054                       ;-----------------------------------------------------------------------
0055                       ; Logic for Editor Buffer (2)
0056                       ;-----------------------------------------------------------------------
0057                       copy  "edb.clear.sams.asm"  ; Clear SAMS pages of editor buffer
     **** ****     > edb.clear.sams.asm
0001               * FILE......: edb.clear.sams.asm
0002               * Purpose...: Clear SAMS pages of editor buffer
0003               
0004               ***************************************************************
0005               * edb.clear
0006               * Clear SAMS pages of editor buffer
0007               ***************************************************************
0008               *  bl   @edb.clear.sams
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * NONE
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * NONE
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               ********|*****|*********************|**************************
0019               edb.clear.sams:
0020 604A 0649  14         dect  stack
0021 604C C64B  30         mov   r11,*stack            ; Save return address
0022 604E 0649  14         dect  stack
0023 6050 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6052 0649  14         dect  stack
0025 6054 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6056 0649  14         dect  stack
0027 6058 C646  30         mov   tmp2,*stack           ; Push tmp2
0028 605A 0649  14         dect  stack
0029 605C C647  30         mov   tmp3,*stack           ; Push tmp3
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 605E C1A0  34         mov   @edb.sams.hipage,tmp2 ; Highest SAMS page used
     6060 A518     
0034                       ;------------------------------------------------------
0035                       ; Clear SAMS memory
0036                       ;------------------------------------------------------
0037               edb.clear.sams.loop:
0038 6062 C106  18         mov   tmp2,tmp0             ; SAMS page
0039 6064 0205  20         li    tmp1,>c000            ; Memory region to map
     6066 C000     
0040               
0041 6068 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     606A 258A     
0042                                                   ; \ i  tmp0 = SAMS page
0043                                                   ; / i  tmp1 = Memory address
0044               
0045 606C 0649  14         dect  stack
0046 606E C646  30         mov   tmp2,*stack           ; Push tmp2
0047               
0048 6070 06A0  32         bl    @film                 ; \ Clear memory
     6072 224A     
0049 6074 C000                   data >c000,0,4096     ; / Overwrites tmp0-tmp3 (!)
     6076 0000     
     6078 1000     
0050               
0051 607A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0052               
0053 607C 0606  14         dec   tmp2
0054 607E 0286  22         ci    tmp2,>3f              ; First page (>40) reached?
     6080 003F     
0055 6082 15EF  14         jgt   edb.clear.sams.loop   ; No, next iteration
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               edb.clear.sams.exit:
0060 6084 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0061 6086 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 6088 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 608A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 608C C2F9  30         mov   *stack+,r11           ; Pop r11
0065 608E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0058                       copy  "edb.hipage.alloc.asm"; Allocate SAMS page for editor buffer
     **** ****     > edb.hipage.alloc.asm
0001               * FILE......: edb.hipage.alloc.asm
0002               * Purpose...: Editor buffer utilities
0003               
0004               
0005               ***************************************************************
0006               * edb.hipage.alloc
0007               * Check and increase highest SAMS page of editor buffer
0008               ***************************************************************
0009               *  bl   @edb.hipage.alloc
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @edb.next_free.ptr = Pointer to next free line
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1
0018               ********|*****|*********************|**************************
0019               edb.hipage.alloc:
0020 6090 0649  14         dect  stack
0021 6092 C64B  30         mov   r11,*stack            ; Save return address
0022 6094 0649  14         dect  stack
0023 6096 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6098 0649  14         dect  stack
0025 609A C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.hipage.alloc.check_setpage:
0030 609C C120  34         mov   @edb.next_free.ptr,tmp0
     609E A508     
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 60A0 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     60A2 0FFF     
0035 60A4 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     60A6 0052     
0036 60A8 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     60AA 0FF0     
0037 60AC 1105  14         jlt   edb.hipage.alloc.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 60AE 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     60B0 A518     
0043 60B2 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     60B4 A500     
     60B6 A508     
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.hipage.alloc.setpage:
0049 60B8 C120  34         mov   @edb.sams.hipage,tmp0
     60BA A518     
0050 60BC C160  34         mov   @edb.top.ptr,tmp1
     60BE A500     
0051 60C0 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     60C2 258A     
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 60C4 1004  14         jmp   edb.hipage.alloc.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.hipage.alloc.crash:
0060 60C6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     60C8 FFCE     
0061 60CA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     60CC 2026     
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.hipage.alloc.exit:
0066 60CE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 60D0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 60D2 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 60D4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0059                       copy  "edb.line.del.asm"    ; Delete line
     **** ****     > edb.line.del.asm
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
0024 60D6 0649  14         dect  stack
0025 60D8 C64B  30         mov   r11,*stack            ; Save return address
0026 60DA 0649  14         dect  stack
0027 60DC C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 60DE 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     60E0 A000     
     60E2 A504     
0032 60E4 1204  14         jle   !
0033 60E6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     60E8 FFCE     
0034 60EA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     60EC 2026     
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 60EE 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     60F0 A506     
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 60F2 C120  34          mov   @edb.lines,tmp0      ; \
     60F4 A504     
0043 60F6 0284  22          ci    tmp0,1               ; | Only single line?
     60F8 0001     
0044 60FA 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 60FC 0620  34         dec   @parm1                ; Base 0
     60FE A000     
0049 6100 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6102 A504     
     6104 A002     
0050               
0051 6106 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     6108 340E     
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 610A 0620  34         dec   @edb.lines            ; One line less in editor buffer
     610C A504     
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 610E 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6110 A50C     
     6112 2022     
0061 6114 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 6116 8820  54         c     @parm1,@edb.block.m1  ; \
     6118 A000     
     611A A50C     
0064 611C 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 611E 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 6120 8820  54         c     @edb.block.m1,@w$0001 ; \
     6122 A50C     
     6124 2002     
0068 6126 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 6128 0620  34         dec   @edb.block.m1         ; M1--
     612A A50C     
0071 612C 0720  34         seto  @fb.colorize          ; Set colorize flag
     612E A310     
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 6130 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6132 A50E     
     6134 2022     
0077 6136 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 6138 8820  54         c     @parm1,@edb.block.m2  ; \
     613A A000     
     613C A50E     
0080 613E 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 6140 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 6142 8820  54         c     @edb.block.m2,@w$0001 ; \
     6144 A50E     
     6146 2002     
0084 6148 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 614A 0620  34         dec   @edb.block.m2         ; M2--
     614C A50E     
0087 614E 0720  34         seto  @fb.colorize          ; Set colorize flag
     6150 A310     
0088 6152 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 6154 04E0  34         clr   @parm1                ; 1st line
     6156 A000     
0094 6158 04E0  34         clr   @parm2                ; 1st line
     615A A002     
0095               
0096 615C 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     615E 340E     
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 6160 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 6162 C2F9  30         mov   *stack+,r11           ; Pop r11
0105 6164 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0060                       copy  "edb.line.copy.asm"   ; Copy line
     **** ****     > edb.line.copy.asm
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
0031 6166 0649  14         dect  stack
0032 6168 C64B  30         mov   r11,*stack            ; Save return address
0033 616A 0649  14         dect  stack
0034 616C C644  30         mov   tmp0,*stack           ; Push tmp0
0035 616E 0649  14         dect  stack
0036 6170 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 6172 0649  14         dect  stack
0038 6174 C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 6176 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     6178 A000     
     617A A504     
0043 617C 1204  14         jle   !
0044 617E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6180 FFCE     
0045 6182 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6184 2026     
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 6186 C120  34 !       mov   @parm2,tmp0           ; Get target line number
     6188 A002     
0050 618A 0604  14         dec   tmp0                  ; Base 0
0051 618C C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     618E A102     
0052 6190 04E0  34         clr   @rambuf               ; Set source line length=0
     6192 A100     
0053 6194 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     6196 A104     
0054 6198 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     619A A106     
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 619C C120  34         mov   @parm1,tmp0           ; Get source line number
     619E A000     
0059 61A0 0604  14         dec   tmp0                  ; Base 0
0060               
0061 61A2 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     61A4 3508     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 61A6 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     61A8 A010     
0069 61AA 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 61AC 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 61AE C154  26         mov   *tmp0,tmp1            ; Get line length
0076 61B0 C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     61B2 A100     
0077 61B4 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     61B6 A100     
0078 61B8 C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     61BA A104     
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 61BC 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     61BE 0050     
0083 61C0 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 61C2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     61C4 FFCE     
0088 61C6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     61C8 2026     
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 61CA A820  54         a     @w$1000,@edb.top.ptr
     61CC 201A     
     61CE A500     
0094 61D0 A820  54         a     @w$1000,@edb.next_free.ptr
     61D2 201A     
     61D4 A508     
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 61D6 06A0  32         bl    @edb.hipage.alloc     ; Check and increase highest SAMS page
     61D8 6090     
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 61DA C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     61DC A104     
0111 61DE C160  34         mov   @edb.next_free.ptr,tmp1
     61E0 A508     
0112                                                   ; Pointer to space for new target line
0113               
0114 61E2 C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     61E4 A100     
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 61E6 06A0  32         bl    @xpym2m               ; Copy memory block
     61E8 24F4     
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 61EA 6820  54         s     @w$1000,@edb.top.ptr
     61EC 201A     
     61EE A500     
0127 61F0 6820  54         s     @w$1000,@edb.next_free.ptr
     61F2 201A     
     61F4 A508     
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 61F6 C820  54         mov   @edb.next_free.ptr,@rambuf+6
     61F8 A508     
     61FA A106     
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 61FC C120  34         mov   @edb.sams.page,tmp0
     61FE A516     
0138 6200 C160  34         mov   @edb.top.ptr,tmp1
     6202 A500     
0139 6204 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6206 258A     
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 6208 C120  34         mov   @tv.sams.d000,tmp0
     620A A20A     
0146 620C 0205  20         li    tmp1,>d000
     620E D000     
0147 6210 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6212 258A     
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 6214 A820  54         a     @rambuf,@edb.next_free.ptr
     6216 A100     
     6218 A508     
0154                                                      ; Add length of line
0155               
0156 621A C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     621C A508     
0157 621E 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 6220 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6222 000F     
0159 6224 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6226 A508     
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 6228 C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     622A A102     
     622C A000     
0165 622E C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     6230 A106     
     6232 A002     
0166 6234 C820  54         mov   @edb.sams.hipage,@parm3
     6236 A518     
     6238 A004     
0167                                                   ; SAMS page to use
0168               
0169 623A 06A0  32         bl    @idx.entry.update     ; Update index
     623C 3360     
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 623E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 6240 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 6242 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 6244 C2F9  30         mov   *stack+,r11           ; Pop r11
0182 6246 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0061                       copy  "edb.block.mark.asm"  ; Mark code block
     **** ****     > edb.block.mark.asm
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
0011               * @edb.block.m1 = Marker M1 line
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * NONE
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * NONE
0018               ********|*****|*********************|**************************
0019               edb.block.mark.m1:
0020 6248 0649  14         dect  stack
0021 624A C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 624C C820  54         mov   @fb.row,@parm1
     624E A306     
     6250 A000     
0026 6252 06A0  32         bl    @fb.row2line          ; Row to editor line
     6254 6558     
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 6256 05A0  34         inc   @outparm1             ; Add base 1
     6258 A010     
0032               
0033 625A C820  54         mov   @outparm1,@edb.block.m1
     625C A010     
     625E A50C     
0034                                                   ; Set block marker M1
0035 6260 0720  34         seto  @fb.colorize          ; Set colorize flag
     6262 A310     
0036 6264 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     6266 A316     
0037 6268 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     626A A318     
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 626C C2F9  30         mov   *stack+,r11           ; Pop r11
0043 626E 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               ***************************************************************
0047               * edb.block.mark.m2
0048               * Mark M2 line for block operation
0049               ***************************************************************
0050               *  bl   @edb.block.mark.m2
0051               *--------------------------------------------------------------
0052               * INPUT
0053               * @edb.block.m2 = Marker M2 line
0054               *--------------------------------------------------------------
0055               * OUTPUT
0056               * NONE
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * NONE
0060               ********|*****|*********************|**************************
0061               edb.block.mark.m2:
0062 6270 0649  14         dect  stack
0063 6272 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 6274 C820  54         mov   @fb.row,@parm1
     6276 A306     
     6278 A000     
0068 627A 06A0  32         bl    @fb.row2line          ; Row to editor line
     627C 6558     
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 627E 05A0  34         inc   @outparm1             ; Add base 1
     6280 A010     
0074               
0075 6282 C820  54         mov   @outparm1,@edb.block.m2
     6284 A010     
     6286 A50E     
0076                                                   ; Set block marker M2
0077               
0078 6288 0720  34         seto  @fb.colorize          ; Set colorize flag
     628A A310     
0079 628C 0720  34         seto  @fb.dirty             ; Trigger refresh
     628E A316     
0080 6290 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6292 A318     
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 6294 C2F9  30         mov   *stack+,r11           ; Pop r11
0086 6296 045B  20         b     *r11                  ; Return to caller
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
0097               * @edb.block.m1 = Marker M1 line
0098               * @edb.block.m2 = Marker M2 line
0099               *--------------------------------------------------------------
0100               * OUTPUT
0101               * NONE
0102               *--------------------------------------------------------------
0103               * Register usage
0104               * tmp0, tmp1
0105               ********|*****|*********************|**************************
0106               edb.block.mark:
0107 6298 0649  14         dect  stack
0108 629A C64B  30         mov   r11,*stack            ; Push return address
0109 629C 0649  14         dect  stack
0110 629E C644  30         mov   tmp0,*stack           ; Push tmp0
0111 62A0 0649  14         dect  stack
0112 62A2 C645  30         mov   tmp1,*stack           ; Push tmp1
0113                       ;------------------------------------------------------
0114                       ; Get current line position in editor buffer
0115                       ;------------------------------------------------------
0116 62A4 C820  54         mov   @fb.row,@parm1
     62A6 A306     
     62A8 A000     
0117 62AA 06A0  32         bl    @fb.row2line          ; Row to editor line
     62AC 6558     
0118                                                   ; \ i @fb.topline = Top line in frame buffer
0119                                                   ; | i @parm1      = Row in frame buffer
0120                                                   ; / o @outparm1   = Matching line in EB
0121               
0122 62AE C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     62B0 A010     
0123 62B2 0585  14         inc   tmp1                  ; Add base 1
0124                       ;------------------------------------------------------
0125                       ; Check if M1 and M2 must be set
0126                       ;------------------------------------------------------
0127 62B4 C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     62B6 A50C     
0128 62B8 0584  14         inc   tmp0                  ; /
0129 62BA 1608  14         jne   edb.block.mark.is_line_m1
0130                                                   ; No, skip to update M1
0131                       ;------------------------------------------------------
0132                       ; Set M1 and M2 and exit
0133                       ;------------------------------------------------------
0134 62BC 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     62BE 6248     
0135 62C0 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     62C2 6270     
0136 62C4 1008  14         jmp   edb.block.mark.exit
0137                       ;------------------------------------------------------
0138                       ; Set M1 and exit
0139                       ;------------------------------------------------------
0140               _edb.block.mark.m1.set:
0141 62C6 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     62C8 6248     
0142 62CA 1005  14         jmp   edb.block.mark.exit
0143                       ;------------------------------------------------------
0144                       ; Update M1 if current line < M1
0145                       ;------------------------------------------------------
0146               edb.block.mark.is_line_m1:
0147 62CC 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     62CE A50C     
0148 62D0 15FA  14         jgt   _edb.block.mark.m1.set
0149                                                   ; Set M1 to current line and exit
0150                       ;------------------------------------------------------
0151                       ; Set M2 and exit
0152                       ;------------------------------------------------------
0153 62D2 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     62D4 6270     
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               edb.block.mark.exit:
0158 62D6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0159 62D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 62DA C2F9  30         mov   *stack+,r11           ; Pop r11
0161 62DC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0062                       copy  "edb.block.clip.asm"  ; Save code block to clipboard
     **** ****     > edb.block.clip.asm
0001               * FILE......: edb.block.clip.asm
0002               * Purpose...: Save block to clipboard
0003               
0004               ***************************************************************
0005               * edb.block.clip
0006               * Save block to specified clipboard
0007               ***************************************************************
0008               *  bl   @edb.block.clip
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @edb.clip.filename = Device and filename of clipboard
0012               * @edb.block.m1      = Marker M1 line
0013               * @edb.block.m2      = Marker M2 line
0014               * @parm1             = Suffix clipboard file (none, 1-5)
0015               *--------------------------------------------------------------
0016               * OUTPUT
0017               * none
0018               *--------------------------------------------------------------
0019               * Register usage
0020               * tmp0,tmp1,tmp2
0021               *--------------------------------------------------------------
0022               * Remarks
0023               * none
0024               ********|*****|*********************|**************************
0025               edb.block.clip:
0026 62DE 0649  14         dect  stack
0027 62E0 C64B  30         mov   r11,*stack            ; Save return address
0028 62E2 0649  14         dect  stack
0029 62E4 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 62E6 0649  14         dect  stack
0031 62E8 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 62EA 0649  14         dect  stack
0033 62EC C646  30         mov   tmp2,*stack           ; Push tmp2
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 62EE 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     62F0 A50C     
     62F2 2022     
0038 62F4 132F  14         jeq   edb.block.clip.exit   ; Yes, exit early
0039               
0040 62F6 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     62F8 A50E     
     62FA 2022     
0041 62FC 132B  14         jeq   edb.block.clip.exit   ; Yes, exit early
0042               
0043 62FE 8820  54         c     @edb.block.m1,@edb.block.m2
     6300 A50C     
     6302 A50E     
0044                                                   ; M1 > M2 ?
0045 6304 1527  14         jgt   edb.block.clip.exit   ; Yes, exit early
0046                       ;------------------------------------------------------
0047                       ; Generate clipboard device/file name
0048                       ;------------------------------------------------------
0049 6306 06A0  32         bl    @cpym2m
     6308 24EE     
0050 630A D9B0                   data tv.clip.fname,heap.top,80
     630C F000     
     630E 0050     
0051               
0052 6310 C120  34         mov   @parm1,tmp0           ; Check if suffix necessary
     6312 A000     
0053 6314 130D  14         jeq   edb.block.clip.save   ; No suffix, skip to save
0054                       ;------------------------------------------------------
0055                       ; Append suffix character to clipboard device/filename
0056                       ;------------------------------------------------------
0057 6316 C120  34         mov   @tv.clip.fname,tmp0
     6318 D9B0     
0058 631A C144  18         mov   tmp0,tmp1
0059 631C 0984  56         srl   tmp0,8                ; Get string length
0060 631E 0224  22         ai    tmp0,heap.top         ; Add base
     6320 F000     
0061 6322 0584  14         inc   tmp0                  ; Consider length-prefix byte
0062 6324 D520  46         movb  @parm1,*tmp0          ; Append suffix
     6326 A000     
0063               
0064 6328 0225  22         ai    tmp1,>0100            ; \ Update clipboard string length
     632A 0100     
0065 632C D805  38         movb  tmp1,@heap.top        ; /
     632E F000     
0066                       ;------------------------------------------------------
0067                       ; Save code block M1-M2 to clipboard
0068                       ;------------------------------------------------------
0069               edb.block.clip.save:
0070 6330 0204  20         li    tmp0,heap.top         ; \ Set pointer to clipboard filename
     6332 F000     
0071 6334 C804  38         mov   tmp0,@parm1           ; /
     6336 A000     
0072               
0073 6338 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     633A A50C     
     633C A002     
0074 633E 0620  34         dec   @parm2                ; /
     6340 A002     
0075               
0076 6342 C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     6344 A50E     
     6346 A004     
0077               
0078 6348 0204  20         li    tmp0,id.file.clipblock
     634A 0006     
0079 634C C804  38         mov   tmp0,@parm4           ; Save block to clipboard
     634E A006     
0080               
0081 6350 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6352 657C     
0082                                                   ; \ i  parm1 = Pointer to length-prefixed
0083                                                   ; |            device/filename string
0084                                                   ; | i  parm2 = First line to save (base 0)
0085                                                   ; | i  parm3 = Last line to save  (base 0)
0086                                                   ; | i  parm4 = Work mode
0087                                                   ; /
0088                       ;------------------------------------------------------
0089                       ; Exit
0090                       ;------------------------------------------------------
0091               edb.block.clip.exit:
0092 6354 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0093 6356 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0094 6358 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0095 635A C2F9  30         mov   *stack+,r11           ; Pop R11
0096 635C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0063                       copy  "edb.block.reset.asm" ; Reset markers
     **** ****     > edb.block.reset.asm
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
0017 635E 0649  14         dect  stack
0018 6360 C64B  30         mov   r11,*stack            ; Push return address
0019 6362 0649  14         dect  stack
0020 6364 C660  46         mov   @wyx,*stack           ; Push cursor position
     6366 832A     
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 6368 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     636A A50C     
0025 636C 0720  34         seto  @edb.block.m2         ; /
     636E A50E     
0026               
0027 6370 0720  34         seto  @fb.colorize          ; Set colorize flag
     6372 A310     
0028 6374 0720  34         seto  @fb.dirty             ; Trigger refresh
     6376 A316     
0029 6378 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     637A A318     
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 637C 0720  34         seto  @parm1                ; Do not turn screen off while
     637E A000     
0034                                                   ; reloading color scheme
0035               
0036 6380 04E0  34         clr   @parm2                ; Don't skip colorizing marked lines
     6382 A002     
0037 6384 04E0  34         clr   @parm3                ; Colorize all panes
     6386 A004     
0038               
0039 6388 06A0  32         bl    @pane.action.colorscheme.load
     638A 658E     
0040                                                   ; Reload color scheme
0041                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0042                                                   ; | i  @parm2 = Skip colorizing marked lines
0043                                                   ; |             if >FFFF
0044                                                   ; | i  @parm3 = Only colorize CMDB pane
0045                                                   ; /             if >FFFF
0046               
0047               
0048                       ;------------------------------------------------------
0049                       ; Remove markers
0050                       ;------------------------------------------------------
0051 638C C820  54         mov   @tv.color,@parm1      ; Set normal color
     638E A218     
     6390 A000     
0052 6392 06A0  32         bl    @pane.action.colorscheme.statlines
     6394 65A0     
0053                                                   ; Set color combination for status lines
0054                                                   ; \ i  @parm1 = Color combination
0055                                                   ; /
0056               
0057 6396 06A0  32         bl    @hchar
     6398 27E6     
0058 639A 0034                   byte 0,52,32,18           ; Remove markers
     639C 2012     
0059 639E 1D00                   byte pane.botrow,0,32,55  ; Remove block shortcuts
     63A0 2037     
0060 63A2 FFFF                   data eol
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               edb.block.reset.exit:
0065 63A4 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     63A6 832A     
0066 63A8 C2F9  30         mov   *stack+,r11           ; Pop r11
0067 63AA 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0064                       copy  "edb.block.del.asm"   ; Delete code block
     **** ****     > edb.block.del.asm
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
0011               * @edb.block.m1 = Marker M1 line
0012               * @edb.block.m2 = Marker M2 line
0013               *
0014               * @parm1 = Message flag
0015               *          (>0000 = Display message "Deleting block")
0016               *          (>ffff = Skip message display)
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * @outparm1 = success (>ffff), no action (>0000)
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0,tmp1,tmp2
0023               *--------------------------------------------------------------
0024               * Remarks
0025               * For simplicity reasons we're assuming base 1 during copy
0026               * (first line starts at 1 instead of 0).
0027               * Makes it easier when comparing values.
0028               ********|*****|*********************|**************************
0029               edb.block.delete:
0030 63AC 0649  14         dect  stack
0031 63AE C64B  30         mov   r11,*stack            ; Save return address
0032 63B0 0649  14         dect  stack
0033 63B2 C644  30         mov   tmp0,*stack           ; Push tmp0
0034 63B4 0649  14         dect  stack
0035 63B6 C645  30         mov   tmp1,*stack           ; Push tmp1
0036 63B8 0649  14         dect  stack
0037 63BA C646  30         mov   tmp2,*stack           ; Push tmp2
0038               
0039 63BC 04E0  34         clr   @outparm1             ; No action (>0000)
     63BE A010     
0040                       ;------------------------------------------------------
0041                       ; Asserts
0042                       ;------------------------------------------------------
0043 63C0 C120  34         mov   @edb.block.m1,tmp0    ; \
     63C2 A50C     
0044 63C4 0584  14         inc   tmp0                  ; | M1 unset?
0045 63C6 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0046               
0047 63C8 C160  34         mov   @edb.block.m2,tmp1    ; \
     63CA A50E     
0048 63CC 0584  14         inc   tmp0                  ; | M2 unset?
0049 63CE 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Check message to display
0052                       ;------------------------------------------------------
0053 63D0 C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     63D2 A000     
0054 63D4 160E  14         jne   edb.block.delete.prep ; No, skip message display
0055                       ;------------------------------------------------------
0056                       ; Display "Deleting...."
0057                       ;------------------------------------------------------
0058 63D6 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     63D8 A21C     
     63DA A000     
0059               
0060 63DC 06A0  32         bl    @pane.action.colorscheme.statlines
     63DE 65A0     
0061                                                   ; Set color combination for status lines
0062                                                   ; \ i  @parm1 = Color combination
0063                                                   ; /
0064               
0065 63E0 06A0  32         bl    @hchar
     63E2 27E6     
0066 63E4 1D00                   byte pane.botrow,0,32,55
     63E6 2037     
0067 63E8 FFFF                   data eol              ; Remove markers and block shortcuts
0068               
0069 63EA 06A0  32         bl    @putat
     63EC 2456     
0070 63EE 1D00                   byte pane.botrow,0
0071 63F0 36B0                   data txt.block.del    ; Display "Deleting block...."
0072                       ;------------------------------------------------------
0073                       ; Prepare for delete
0074                       ;------------------------------------------------------
0075               edb.block.delete.prep:
0076 63F2 C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     63F4 A50C     
0077 63F6 0604  14         dec   tmp0                  ; Base 0
0078               
0079 63F8 C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     63FA A50E     
0080 63FC 0605  14         dec   tmp1                  ; Base 0
0081               
0082 63FE C804  38         mov   tmp0,@parm1           ; Delete line on M1
     6400 A000     
0083 6402 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6404 A504     
     6406 A002     
0084 6408 0620  34         dec   @parm2                ; Base 0
     640A A002     
0085               
0086 640C C185  18         mov   tmp1,tmp2             ; \
0087 640E 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0088 6410 0586  14         inc   tmp2                  ; /
0089                       ;------------------------------------------------------
0090                       ; Delete block
0091                       ;------------------------------------------------------
0092               edb.block.delete.loop:
0093 6412 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     6414 340E     
0094                                                   ; \ i  @parm1 = Line in editor buffer
0095                                                   ; / i  @parm2 = Last line for index reorg
0096               
0097 6416 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     6418 A504     
0098 641A 0620  34         dec   @parm2                ; /
     641C A002     
0099               
0100 641E 0606  14         dec   tmp2
0101 6420 15F8  14         jgt   edb.block.delete.loop ; Next line
0102 6422 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6424 A506     
0103                       ;------------------------------------------------------
0104                       ; Set topline for framebuffer refresh
0105                       ;------------------------------------------------------
0106 6426 8820  54         c     @fb.topline,@edb.lines
     6428 A304     
     642A A504     
0107                                                   ; Beyond editor buffer?
0108 642C 1504  14         jgt   !                     ; Yes, goto line 1
0109               
0110 642E C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     6430 A304     
     6432 A000     
0111 6434 1002  14         jmp   edb.block.delete.fb.refresh
0112 6436 04E0  34 !       clr   @parm1                ; Set line to start with
     6438 A000     
0113                       ;------------------------------------------------------
0114                       ; Refresh framebuffer and reset block markers
0115                       ;------------------------------------------------------
0116               edb.block.delete.fb.refresh:
0117 643A 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     643C 6546     
0118                                                   ; | i  @parm1 = Line to start with
0119                                                   ; /             (becomes @fb.topline)
0120               
0121 643E 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     6440 635E     
0122               
0123 6442 0720  34         seto  @outparm1             ; Delete completed
     6444 A010     
0124                       ;------------------------------------------------------
0125                       ; Exit
0126                       ;------------------------------------------------------
0127               edb.block.delete.exit:
0128 6446 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6448 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 644A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 644C C2F9  30         mov   *stack+,r11           ; Pop R11
0132 644E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0065                       copy  "edb.block.copy.asm"  ; Copy code block
     **** ****     > edb.block.copy.asm
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
0011               * @edb.block.m1 = Marker M1 line
0012               * @edb.block.m2 = Marker M2 line
0013               *
0014               * @parm1 = Message flag
0015               *          (>0000 = Display message "Copying block...")
0016               *          (>ffff = Display message "Moving block....")
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * @outparm1 = success (>ffff), no action (>0000)
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0,tmp1,tmp2
0023               *--------------------------------------------------------------
0024               * Remarks
0025               * For simplicity reasons we're assuming base 1 during copy
0026               * (first line starts at 1 instead of 0).
0027               * Makes it easier when comparing values.
0028               ********|*****|*********************|**************************
0029               edb.block.copy:
0030 6450 0649  14         dect  stack
0031 6452 C64B  30         mov   r11,*stack            ; Save return address
0032 6454 0649  14         dect  stack
0033 6456 C644  30         mov   tmp0,*stack           ; Push tmp0
0034 6458 0649  14         dect  stack
0035 645A C645  30         mov   tmp1,*stack           ; Push tmp1
0036 645C 0649  14         dect  stack
0037 645E C646  30         mov   tmp2,*stack           ; Push tmp2
0038 6460 0649  14         dect  stack
0039 6462 C660  46         mov   @parm1,*stack         ; Push parm1
     6464 A000     
0040 6466 04E0  34         clr   @outparm1             ; No action (>0000)
     6468 A010     
0041                       ;------------------------------------------------------
0042                       ; Asserts
0043                       ;------------------------------------------------------
0044 646A 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     646C A50C     
     646E 2022     
0045 6470 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 6472 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6474 A50E     
     6476 2022     
0048 6478 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0049               
0050 647A 8820  54         c     @edb.block.m1,@edb.block.m2
     647C A50C     
     647E A50E     
0051                                                   ; M1 > M2 ?
0052 6480 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0053                       ;------------------------------------------------------
0054                       ; Get current line position in editor buffer
0055                       ;------------------------------------------------------
0056 6482 C820  54         mov   @fb.row,@parm1
     6484 A306     
     6486 A000     
0057 6488 06A0  32         bl    @fb.row2line          ; Row to editor line
     648A 6558     
0058                                                   ; \ i @fb.topline = Top line in frame buffer
0059                                                   ; | i @parm1      = Row in frame buffer
0060                                                   ; / o @outparm1   = Matching line in EB
0061               
0062 648C C120  34         mov   @outparm1,tmp0        ; \
     648E A010     
0063 6490 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0064 6492 C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     6494 A510     
0065                       ;------------------------------------------------------
0066                       ; Show error and exit if M1 < current line < M2
0067                       ;------------------------------------------------------
0068 6496 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     6498 A010     
0069 649A 110D  14         jlt   !                     ; Yes, skip check
0070               
0071 649C 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     649E A010     
0072 64A0 150A  14         jgt   !                     ; Yes, skip check
0073               
0074 64A2 06A0  32         bl    @cpym2m
     64A4 24EE     
0075 64A6 3942                   data txt.block.inside,tv.error.msg,53
     64A8 A22E     
     64AA 0035     
0076               
0077 64AC 06A0  32         bl    @pane.errline.show    ; Show error line
     64AE 656A     
0078               
0079 64B0 04E0  34         clr   @outparm1             ; No action (>0000)
     64B2 A010     
0080 64B4 1041  14         jmp   edb.block.copy.exit   ; Exit early
0081                       ;------------------------------------------------------
0082                       ; Display message Copy/Move
0083                       ;------------------------------------------------------
0084 64B6 C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     64B8 A21C     
     64BA A000     
0085 64BC 06A0  32         bl    @pane.action.colorscheme.statlines
     64BE 65A0     
0086                                                   ; Set color combination for status lines
0087                                                   ; \ i  @parm1 = Color combination
0088                                                   ; /
0089               
0090 64C0 06A0  32         bl    @hchar
     64C2 27E6     
0091 64C4 1D00                   byte pane.botrow,0,32,55
     64C6 2037     
0092 64C8 FFFF                   data eol              ; Remove markers and block shortcuts
0093                       ;------------------------------------------------------
0094                       ; Check message to display
0095                       ;------------------------------------------------------
0096 64CA C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0097                                                   ; / @parm1 = >0000 ?
0098 64CC 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0099               
0100 64CE 06A0  32         bl    @putat
     64D0 2456     
0101 64D2 1D00                   byte pane.botrow,0
0102 64D4 36C4                   data txt.block.copy   ; Display "Copying block...."
0103 64D6 1004  14         jmp   edb.block.copy.prep
0104               
0105               edb.block.copy.msg2:
0106 64D8 06A0  32         bl    @putat
     64DA 2456     
0107 64DC 1D00                   byte pane.botrow,0
0108 64DE 36D6                   data txt.block.move   ; Display "Moving block...."
0109                       ;------------------------------------------------------
0110                       ; Prepare for copy
0111                       ;------------------------------------------------------
0112               edb.block.copy.prep:
0113 64E0 C120  34         mov   @edb.block.m1,tmp0    ; M1
     64E2 A50C     
0114 64E4 C1A0  34         mov   @edb.block.m2,tmp2    ; \
     64E6 A50E     
0115 64E8 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0116 64EA 0586  14         inc   tmp2                  ; /
0117               
0118 64EC C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     64EE A510     
0119                       ;------------------------------------------------------
0120                       ; Copy code block
0121                       ;------------------------------------------------------
0122               edb.block.copy.loop:
0123 64F0 C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     64F2 A000     
0124 64F4 0620  34         dec   @parm1                ; Base 0 offset for index required
     64F6 A000     
0125 64F8 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     64FA A504     
     64FC A002     
0126               
0127 64FE 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     6500 34B0     
0128                                                   ; \ i  @parm1 = Line for insert
0129                                                   ; / i  @parm2 = Last line to reorg
0130                       ;------------------------------------------------------
0131                       ; Increase M1-M2 block if target line before M1
0132                       ;------------------------------------------------------
0133 6502 8805  38         c     tmp1,@edb.block.m1
     6504 A50C     
0134 6506 1506  14         jgt   edb.block.copy.loop.docopy
0135 6508 1305  14         jeq   edb.block.copy.loop.docopy
0136               
0137 650A 05A0  34         inc   @edb.block.m1         ; M1++
     650C A50C     
0138 650E 05A0  34         inc   @edb.block.m2         ; M2++
     6510 A50E     
0139 6512 0584  14         inc   tmp0                  ; Increase source line number too!
0140                       ;------------------------------------------------------
0141                       ; Copy line
0142                       ;------------------------------------------------------
0143               edb.block.copy.loop.docopy:
0144 6514 C804  38         mov   tmp0,@parm1           ; Source line for copy
     6516 A000     
0145 6518 C805  38         mov   tmp1,@parm2           ; Target line for copy
     651A A002     
0146               
0147 651C 06A0  32         bl    @edb.line.copy        ; Copy line
     651E 6166     
0148                                                   ; \ i  @parm1 = Source line in editor buffer
0149                                                   ; / i  @parm2 = Target line in editor buffer
0150                       ;------------------------------------------------------
0151                       ; Housekeeping for next copy
0152                       ;------------------------------------------------------
0153 6520 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6522 A504     
0154 6524 0584  14         inc   tmp0                  ; Next source line
0155 6526 0585  14         inc   tmp1                  ; Next target line
0156 6528 0606  14         dec   tmp2                  ; Update ĺoop counter
0157 652A 15E2  14         jgt   edb.block.copy.loop   ; Next line
0158                       ;------------------------------------------------------
0159                       ; Copy loop completed
0160                       ;------------------------------------------------------
0161 652C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     652E A506     
0162 6530 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     6532 A316     
0163 6534 0720  34         seto  @outparm1             ; Copy completed
     6536 A010     
0164                       ;------------------------------------------------------
0165                       ; Exit
0166                       ;------------------------------------------------------
0167               edb.block.copy.exit:
0168 6538 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     653A A000     
0169 653C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0170 653E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0171 6540 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0172 6542 C2F9  30         mov   *stack+,r11           ; Pop R11
0173 6544 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0066                       ;-----------------------------------------------------------------------
0067                       ; Stubs
0068                       ;-----------------------------------------------------------------------
0069                       copy  "rom.stubs.bank5.asm" ; Bank specific stubs
     **** ****     > rom.stubs.bank5.asm
0001               * FILE......: rom.stubs.bank5.asm
0002               * Purpose...: Bank 5 stubs for functions in other banks
0003               
0004               
0005               ***************************************************************
0006               * Stub for "fb.refresh"
0007               * bank1 vec.20
0008               ********|*****|*********************|**************************
0009               fb.refresh:
0010 6546 0649  14         dect  stack
0011 6548 C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Call function in bank 1
0014                       ;------------------------------------------------------
0015 654A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     654C 2F9A     
0016 654E 6002                   data bank1.rom        ; | i  p0 = bank address
0017 6550 7FE6                   data vec.20           ; | i  p1 = Vector with target address
0018 6552 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 6554 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 6556 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "fb.row2line"
0028               * bank1 vec.22
0029               ********|*****|*********************|**************************
0030               fb.row2line:
0031 6558 0649  14         dect  stack
0032 655A C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Call function in bank 1
0035                       ;------------------------------------------------------
0036 655C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     655E 2F9A     
0037 6560 6002                   data bank1.rom        ; | i  p0 = bank address
0038 6562 7FEA                   data vec.22           ; | i  p1 = Vector with target address
0039 6564 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0040                       ;------------------------------------------------------
0041                       ; Exit
0042                       ;------------------------------------------------------
0043 6566 C2F9  30         mov   *stack+,r11           ; Pop r11
0044 6568 045B  20         b     *r11                  ; Return to caller
0045               
0046               
0047               ***************************************************************
0048               * Stub for "pane.errline.show"
0049               * bank1 vec.30
0050               ********|*****|*********************|**************************
0051               pane.errline.show:
0052 656A 0649  14         dect  stack
0053 656C C64B  30         mov   r11,*stack            ; Save return address
0054                       ;------------------------------------------------------
0055                       ; Call function in bank 1
0056                       ;------------------------------------------------------
0057 656E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6570 2F9A     
0058 6572 6002                   data bank1.rom        ; | i  p0 = bank address
0059 6574 7FFA                   data vec.30           ; | i  p1 = Vector with target address
0060 6576 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064 6578 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 657A 045B  20         b     *r11                  ; Return to caller
0066               
0067               
0068               ***************************************************************
0069               * Stub for "fm.savefile"
0070               * bank2 vec.4
0071               ********|*****|*********************|**************************
0072               fm.savefile:
0073 657C 0649  14         dect  stack
0074 657E C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Call function in bank 2
0077                       ;------------------------------------------------------
0078 6580 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6582 2F9A     
0079 6584 6004                   data bank2.rom        ; | i  p0 = bank address
0080 6586 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0081 6588 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085 658A C2F9  30         mov   *stack+,r11           ; Pop r11
0086 658C 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               ***************************************************************
0090               * Stub for "pane.action.colorscheme.load"
0091               * bank1 vec.31
0092               ********|*****|*********************|**************************
0093               pane.action.colorscheme.load
0094 658E 0649  14         dect  stack
0095 6590 C64B  30         mov   r11,*stack            ; Save return address
0096                       ;------------------------------------------------------
0097                       ; Call function in bank 1
0098                       ;------------------------------------------------------
0099 6592 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6594 2F9A     
0100 6596 6002                   data bank1.rom        ; | i  p0 = bank address
0101 6598 7FFC                   data vec.31           ; | i  p1 = Vector with target address
0102 659A 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0103                       ;------------------------------------------------------
0104                       ; Exit
0105                       ;------------------------------------------------------
0106 659C C2F9  30         mov   *stack+,r11           ; Pop r11
0107 659E 045B  20         b     *r11                  ; Return to caller
0108               
0109               
0110               ***************************************************************
0111               * Stub for "pane.action.colorscheme.statuslines"
0112               * bank1 vec.32
0113               ********|*****|*********************|**************************
0114               pane.action.colorscheme.statlines
0115 65A0 0649  14         dect  stack
0116 65A2 C64B  30         mov   r11,*stack            ; Save return address
0117                       ;------------------------------------------------------
0118                       ; Call function in bank 1
0119                       ;------------------------------------------------------
0120 65A4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     65A6 2F9A     
0121 65A8 6002                   data bank1.rom        ; | i  p0 = bank address
0122 65AA 7FFE                   data vec.32           ; | i  p1 = Vector with target address
0123 65AC 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0124                       ;------------------------------------------------------
0125                       ; Exit
0126                       ;------------------------------------------------------
0127 65AE C2F9  30         mov   *stack+,r11           ; Pop r11
0128 65B0 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.60011
0070                       copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks > 0
     **** ****     > rom.stubs.bankx.asm
0001               * FILE......: rom.stubs.bankx.asm
0002               * Purpose...: Stubs to include in all banks > 0
0003               
0004               
0005               
0006               ***************************************************************
0007               * Stub for "mem.sams.setup.stevie"
0008               * bank1 vec.1
0009               ********|*****|*********************|**************************
0011               
0012               mem.sams.setup.stevie:
0013 65B2 0649  14         dect  stack
0014 65B4 C64B  30         mov   r11,*stack            ; Save return address
0015                       ;------------------------------------------------------
0016                       ; Call function in bank 1
0017                       ;------------------------------------------------------
0018 65B6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     65B8 2F9A     
0019 65BA 6002                   data bank1.rom        ; | i  p0 = bank address
0020 65BC 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0021 65BE 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0022                       ;------------------------------------------------------
0023                       ; Exit
0024                       ;------------------------------------------------------
0025 65C0 C2F9  30         mov   *stack+,r11           ; Pop r11
0026 65C2 045B  20         b     *r11                  ; Return to caller
0027               
0029               
0030               
0031               ***************************************************************
0032               * Stub for "mem.sams.set.legacy"
0033               * bank7 vec.1
0034               ********|*****|*********************|**************************
0036               
0037               mem.sams.set.legacy:
0038 65C4 0649  14         dect  stack
0039 65C6 C64B  30         mov   r11,*stack            ; Save return address
0040                       ;------------------------------------------------------
0041                       ; Dump VDP patterns
0042                       ;------------------------------------------------------
0043 65C8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     65CA 2F9A     
0044 65CC 600E                   data bank7.rom        ; | i  p0 = bank address
0045 65CE 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0046 65D0 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 65D2 C2F9  30         mov   *stack+,r11           ; Pop r11
0051 65D4 045B  20         b     *r11                  ; Return to caller
0052               
0054               
0055               
0056               ***************************************************************
0057               * Stub for "mem.sams.set.boot"
0058               * bank7 vec.2
0059               ********|*****|*********************|**************************
0061               
0062               mem.sams.set.boot:
0063 65D6 0649  14         dect  stack
0064 65D8 C64B  30         mov   r11,*stack            ; Save return address
0065                       ;------------------------------------------------------
0066                       ; Dump VDP patterns
0067                       ;------------------------------------------------------
0068 65DA 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     65DC 2F9A     
0069 65DE 600E                   data bank7.rom        ; | i  p0 = bank address
0070 65E0 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0071 65E2 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0072                       ;------------------------------------------------------
0073                       ; Exit
0074                       ;------------------------------------------------------
0075 65E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0076 65E6 045B  20         b     *r11                  ; Return to caller
0077               
0079               
0080               
0081               ***************************************************************
0082               * Stub for "mem.sams.set.stevie"
0083               * bank7 vec.3
0084               ********|*****|*********************|**************************
0086               
0087               mem.sams.set.stevie:
0088 65E8 0649  14         dect  stack
0089 65EA C64B  30         mov   r11,*stack            ; Save return address
0090                       ;------------------------------------------------------
0091                       ; Dump VDP patterns
0092                       ;------------------------------------------------------
0093 65EC 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     65EE 2F9A     
0094 65F0 600E                   data bank7.rom        ; | i  p0 = bank address
0095 65F2 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0096 65F4 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0097                       ;------------------------------------------------------
0098                       ; Exit
0099                       ;------------------------------------------------------
0100 65F6 C2F9  30         mov   *stack+,r11           ; Pop r11
0101 65F8 045B  20         b     *r11                  ; Return to caller
0102               
0104               
0105               
0106               
                   < stevie_b5.asm.60011
0071                       ;-----------------------------------------------------------------------
0072                       ; Program data
0073                       ;-----------------------------------------------------------------------
0074                       ; Not applicable
0075                       ;-----------------------------------------------------------------------
0076                       ; Bank full check
0077                       ;-----------------------------------------------------------------------
0081                       ;-----------------------------------------------------------------------
0082                       ; Show ROM bank in CPU crash screen
0083                       ;-----------------------------------------------------------------------
0084               cpu.crash.showbank:
0085                       aorg >7fb0
0086 7FB0 06A0  32         bl    @putat
     7FB2 2456     
0087 7FB4 0314                   byte 3,20
0088 7FB6 7FBA                   data cpu.crash.showbank.bankstr
0089 7FB8 10FF  14         jmp   $
0090               cpu.crash.showbank.bankstr:
0091               
0092 7FBA 05               byte  5
0093 7FBB   52             text  'ROM#5'
     7FBC 4F4D     
     7FBE 2335     
0094                       even
0095               
0096                       ;-----------------------------------------------------------------------
0097                       ; Vector table
0098                       ;-----------------------------------------------------------------------
0099                       aorg  bankx.vectab
0100                       copy  "rom.vectors.bank5.asm"
     **** ****     > rom.vectors.bank5.asm
0001               * FILE......: rom.vectors.bank5.asm
0002               * Purpose...: Bank 5 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 604A     vec.1   data  edb.clear.sams        ;
0008 7FC2 6090     vec.2   data  edb.hipage.alloc      ;
0009 7FC4 6298     vec.3   data  edb.block.mark        ;
0010 7FC6 6248     vec.4   data  edb.block.mark.m1     ;
0011 7FC8 6270     vec.5   data  edb.block.mark.m2     ;
0012 7FCA 62DE     vec.6   data  edb.block.clip        ;
0013 7FCC 635E     vec.7   data  edb.block.reset       ;
0014 7FCE 63AC     vec.8   data  edb.block.delete      ;
0015 7FD0 6450     vec.9   data  edb.block.copy        ;
0016 7FD2 60D6     vec.10  data  edb.line.del          ;
0017 7FD4 6166     vec.11  data  edb.line.copy         ;
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
                   < stevie_b5.asm.60011
0101                                                   ; Vector table bank 5
0102               
0103               *--------------------------------------------------------------
0104               * Video mode configuration
0105               *--------------------------------------------------------------
0106      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0107      0004     spfbck  equ   >04                   ; Screen background color.
0108      35E2     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0109      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0110      0050     colrow  equ   80                    ; Columns per row
0111      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0112      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0113      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0114      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

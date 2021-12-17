XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b5.asm.31152
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b5.asm               ; Version 211217-1822420
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
0023               
0024               *--------------------------------------------------------------
0025               * classic99 and JS99er emulators are mutually exclusive.
0026               * At the time of writing JS99er has full F18a compatibility.
0027               *
0028               * When targetting the JS99er emulator or a real F18a + TI-99/4a
0029               * then set the 'full_f18a_support' equate to 1.
0030               *
0031               * When targetting the classic99 emulator then set the
0032               * 'full_f18a_support' equate to 0. This will activate the
0033               * trimmed down 9938 version, that only works in classic99, but
0034               * not on the real TI-99/4a yet.
0035               *--------------------------------------------------------------
0036      0001     full_f18a_support         equ  1       ; 30 rows mode with sprites
0037               
0038               
0039               *--------------------------------------------------------------
0040               * JS99er F18a 30x80, no FG99 advanced mode
0041               *--------------------------------------------------------------
0043      0001     device.f18a               equ  1       ; F18a GPU
0044      0000     device.9938               equ  0       ; 9938 GPU
0045      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode off
0047               
0048               
0049               
0050               *--------------------------------------------------------------
0051               * Classic99 F18a 24x80, no FG99 advanced mode
0052               *--------------------------------------------------------------
                   < stevie_b5.asm.31152
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
                   < stevie_b5.asm.31152
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
0101      006A     id.dialog.basic           equ  106     ; "Basic"
0102      006B     id.dialog.config          equ  107     ; "Configure"
0103               *--------------------------------------------------------------
0104               * Stevie specific equates
0105               *--------------------------------------------------------------
0106      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0107      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0108      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0109      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0110      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0111      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0112                                                      ; VDP TAT address of 1st CMDB row
0113      0000     vdp.sit.base              equ  >0000   ; VDP SIT base address
0114      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0115                                                      ; VDP SIT size 80 columns, 24/30 rows
0116      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0117      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0118      00FE     tv.1timeonly              equ  254     ; One-time only flag indicator
0119               *--------------------------------------------------------------
0120               * Suffix characters for clipboards
0121               *--------------------------------------------------------------
0122      3100     clip1                     equ  >3100   ; '1'
0123      3200     clip2                     equ  >3200   ; '2'
0124      3300     clip3                     equ  >3300   ; '3'
0125      3400     clip4                     equ  >3400   ; '4'
0126      3500     clip5                     equ  >3500   ; '5'
0127               *--------------------------------------------------------------
0128               * File work mode
0129               *--------------------------------------------------------------
0130      0001     id.file.loadfile          equ  1       ; Load file
0131      0002     id.file.insertfile        equ  2       ; Insert file
0132      0003     id.file.appendfile        equ  3       ; Append file
0133      0004     id.file.savefile          equ  4       ; Save file
0134      0005     id.file.saveblock         equ  5       ; Save block to file
0135      0006     id.file.clipblock         equ  6       ; Save block to clipboard
0136      0007     id.file.printfile         equ  7       ; Print file
0137      0008     id.file.printblock        equ  8       ; Print block
0138               *--------------------------------------------------------------
0139               * SPECTRA2 / Stevie startup options
0140               *--------------------------------------------------------------
0141      0001     debug                     equ  1       ; Turn on spectra2 debugging
0142      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0143      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0144      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0145               
0146      7E00     cpu.scrpad.src            equ  >7e00   ; \ Dump of OS monitor scratchpad
0147                                                      ; | stored in cartridge ROM
0148                                                      ; / bank3.asm
0149               
0150      F960     cpu.scrpad.tgt            equ  >f960   ; \ Destination for copy of TI Basic
0151                                                      ; | scratchpad RAM (SAMS bank #08)
0152                                                      ; /
0153               
0154               
0155               *--------------------------------------------------------------
0156               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0157               *--------------------------------------------------------------
0158      A000     core1.top         equ  >a000           ; Structure begin
0159      A000     parm1             equ  core1.top + 0   ; Function parameter 1
0160      A002     parm2             equ  core1.top + 2   ; Function parameter 2
0161      A004     parm3             equ  core1.top + 4   ; Function parameter 3
0162      A006     parm4             equ  core1.top + 6   ; Function parameter 4
0163      A008     parm5             equ  core1.top + 8   ; Function parameter 5
0164      A00A     parm6             equ  core1.top + 10  ; Function parameter 6
0165      A00C     parm7             equ  core1.top + 12  ; Function parameter 7
0166      A00E     parm8             equ  core1.top + 14  ; Function parameter 8
0167      A010     outparm1          equ  core1.top + 16  ; Function output parameter 1
0168      A012     outparm2          equ  core1.top + 18  ; Function output parameter 2
0169      A014     outparm3          equ  core1.top + 20  ; Function output parameter 3
0170      A016     outparm4          equ  core1.top + 22  ; Function output parameter 4
0171      A018     outparm5          equ  core1.top + 24  ; Function output parameter 5
0172      A01A     outparm6          equ  core1.top + 26  ; Function output parameter 6
0173      A01C     outparm7          equ  core1.top + 28  ; Function output parameter 7
0174      A01E     outparm8          equ  core1.top + 30  ; Function output parameter 8
0175      A020     keyrptcnt         equ  core1.top + 32  ; Key repeat-count (auto-repeat function)
0176      A022     keycode1          equ  core1.top + 34  ; Current key scanned
0177      A024     keycode2          equ  core1.top + 36  ; Previous key scanned
0178      A026     unpacked.string   equ  core1.top + 38  ; 6 char string with unpacked uin16
0179      A02C     tibasic.status    equ  core1.top + 44  ; TI Basic status flags
0180                                                      ; 0000 = Initialize TI-Basic
0181                                                      ; 0001 = TI-Basic reentry
0182      A02E     trmpvector        equ  core1.top + 46  ; Vector trampoline (if p1|tmp1 = >ffff)
0183      A030     ramsat            equ  core1.top + 48  ; Sprite Attr. Table in RAM (14 bytes)
0184      A040     timers            equ  core1.top + 64  ; Timers (80 bytes)
0185      A090     core1.free        equ  core1.top + 144 ; End of structure
0186               *--------------------------------------------------------------
0187               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0188               *--------------------------------------------------------------
0189      A100     core2.top         equ  >a100           ; Structure begin
0190      A100     rambuf            equ  core2.top       ; RAM workbuffer
0191      A200     core2.free        equ  core2.top + 256 ; End of structure
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
0217      A22A     tv.error.rows     equ  tv.top + 42     ; Number of rows in error pane
0218      A22C     tv.error.msg      equ  tv.top + 44     ; Error message (max. 160 characters)
0219      A2CC     tv.free           equ  tv.top + 204    ; End of structure
0220               *--------------------------------------------------------------
0221               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0222               *--------------------------------------------------------------
0223      A300     fb.struct         equ  >a300           ; Structure begin
0224      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0225      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0226      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0227                                                      ; line X in editor buffer).
0228      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0229                                                      ; (offset 0 .. @fb.scrrows)
0230      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0231      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0232      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0233      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0234      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0235      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0236      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0237      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0238      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0239      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0240      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0241      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0242      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0243      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0244               *--------------------------------------------------------------
0245               * File handle structure               @>a400-a4ff   (256 bytes)
0246               *--------------------------------------------------------------
0247      A400     fh.struct         equ  >a400           ; stevie file handling structures
0248               ;***********************************************************************
0249               ; ATTENTION
0250               ; The dsrlnk variables must form a continuous memory block and keep
0251               ; their order!
0252               ;***********************************************************************
0253      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0254      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0255      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0256      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0257      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0258      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0259      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0260      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0261      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0262      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0263      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0264      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0265      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0266      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0267      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0268      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0269      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0270      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0271      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0272      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0273      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0274      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0275      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0276      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0277      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0278      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0279      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0280      A45A     fh.workmode       equ  fh.struct + 90  ; Working mode (used in callbacks)
0281      A45C     fh.kilobytes.prev equ  fh.struct + 92  ; Kilobytes processed (previous)
0282      A45E     fh.line           equ  fh.struct + 94  ; Editor buffer line currently processing
0283      A460     fh.temp1          equ  fh.struct + 96  ; Temporary variable 1
0284      A462     fh.temp2          equ  fh.struct + 98  ; Temporary variable 2
0285      A464     fh.temp3          equ  fh.struct +100  ; Temporary variable 3
0286      A466     fh.membuffer      equ  fh.struct +102  ; 80 bytes file memory buffer
0287      A4B6     fh.free           equ  fh.struct +182  ; End of structure
0288      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0289      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0290               *--------------------------------------------------------------
0291               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0292               *--------------------------------------------------------------
0293      A500     edb.struct        equ  >a500           ; Begin structure
0294      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0295      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0296      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0297      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0298      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0299      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0300      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0301      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0302      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0303      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0304                                                      ; with current filename.
0305      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0306                                                      ; with current file type.
0307      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0308      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0309      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0310                                                      ; for filename, but not always used.
0311      A56A     edb.free          equ  edb.struct + 106; End of structure
0312               *--------------------------------------------------------------
0313               * Index structure                     @>a600-a6ff   (256 bytes)
0314               *--------------------------------------------------------------
0315      A600     idx.struct        equ  >a600           ; stevie index structure
0316      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0317      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0318      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0319      A606     idx.free          equ  idx.struct + 6  ; End of structure
0320               *--------------------------------------------------------------
0321               * Command buffer structure            @>a700-a7ff   (256 bytes)
0322               *--------------------------------------------------------------
0323      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0324      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0325      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0326      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0327      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0328      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0329      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0330      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0331      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0332      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0333      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0334      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0335      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0336      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0337      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0338      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0339      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0340      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0341      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0342      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0343      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0344      A728     cmdb.cmdall       equ  cmdb.struct + 40; Current command including length-byte
0345      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0346      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0347      A77A     cmdb.panhead.buf  equ  cmdb.struct +122; String buffer for pane header
0348      A7AC     cmdb.dflt.fname   equ  cmdb.struct +172; Default for filename
0349      A800     cmdb.free         equ  cmdb.struct +256; End of structure
0350               *--------------------------------------------------------------
0351               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0352               *--------------------------------------------------------------
0353      AD00     scrpad.copy       equ  >ad00           ; Copy of Stevie scratchpad memory
0354               *--------------------------------------------------------------
0355               * Farjump return stack                @>af00-afff   (256 bytes)
0356               *--------------------------------------------------------------
0357      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0358                                                      ; Grows downwards from high to low.
0359               *--------------------------------------------------------------
0360               * Index                               @>b000-bfff  (4096 bytes)
0361               *--------------------------------------------------------------
0362      B000     idx.top           equ  >b000           ; Top of index
0363      1000     idx.size          equ  4096            ; Index size
0364               *--------------------------------------------------------------
0365               * Editor buffer                       @>c000-cfff  (4096 bytes)
0366               *--------------------------------------------------------------
0367      C000     edb.top           equ  >c000           ; Editor buffer high memory
0368      1000     edb.size          equ  4096            ; Editor buffer size
0369               *--------------------------------------------------------------
0370               * Frame buffer & Default devices      @>d000-dfff  (4096 bytes)
0371               *--------------------------------------------------------------
0372      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0373      0960     fb.size           equ  80*30           ; Frame buffer size
0374      D960     tv.printer.fname  equ  >d960           ; Default printer   (80 char)
0375      D9B0     tv.clip.fname     equ  >d9b0           ; Default clipboard (80 char)
0376               *--------------------------------------------------------------
0377               * Command buffer history              @>e000-efff  (4096 bytes)
0378               *--------------------------------------------------------------
0379      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0380      1000     cmdb.size         equ  4096            ; Command buffer size
0381               *--------------------------------------------------------------
0382               * Heap                                @>f000-ffff  (4096 bytes)
0383               *--------------------------------------------------------------
0384      F000     heap.top          equ  >f000           ; Top of heap
                   < stevie_b5.asm.31152
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
                   < stevie_b5.asm.31152
0018               
0019               ***************************************************************
0020               * Spectra2 core configuration
0021               ********|*****|*********************|**************************
0022      AF00     sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
0023                                                   ; grows from high to low.
0024               ***************************************************************
0025               * BANK 5
0026               ********|*****|*********************|**************************
0027      600A     bankid  equ   bank5.rom             ; Set bank identifier to current bank
0028                       aorg  >6000
0029                       save  >6000,>8000           ; Save bank
0030                       copy  "rom.header.asm"      ; Include cartridge header
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
0045 6011   53             text  'STEVIE 1.2K'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 324B     
0046                       even
0047               
0049               
                   < stevie_b5.asm.31152
0031               
0032               ***************************************************************
0033               * Step 1: Switch to bank 0 (uniform code accross all banks)
0034               ********|*****|*********************|**************************
0035                       aorg  kickstart.code1       ; >6040
0036 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000     
0037               ***************************************************************
0038               * Step 2: Satisfy assembler, must know relocated code
0039               ********|*****|*********************|**************************
0040                       aorg  >2000                 ; Relocate to >2000
0041                       copy  "runlib.asm"
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
0079                       copy  "registers.equ"            ; Equates runlib registers
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
0080                       copy  "portaddr.equ"             ; Equates runlib hw port addresses
     **** ****     > portaddr.equ
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
                   < runlib.asm
0081                       copy  "param.equ"                ; Equates runlib parameters
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
0082               
0086               
0087                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
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
0088                       copy  "config.equ"               ; Equates for bits in config register
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
0089                       copy  "cpu_crash.asm"            ; CPU crash handler
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
     2084 2FFC     
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
     20B2 2AB2     
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
     20C6 2AB2     
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
     20F2 26E2     
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
     2116 2ABC     
0158 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0159 211A A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0160 211C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0161                                                   ; /         LSB offset for ASCII digit 0-9
0162               
0163 211E 06A0  32         bl    @setx                 ; Set cursor X position
     2120 26F8     
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
     2134 26F8     
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
     214A 2ABC     
0186 214C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0187 214E A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0188 2150 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0189                                                   ; /         LSB offset for ASCII digit 0-9
0190                       ;------------------------------------------------------
0191                       ; Display crash register content
0192                       ;------------------------------------------------------
0193               cpu.crash.showreg.content:
0194 2152 06A0  32         bl    @mkhex                ; Convert hex word to string
     2154 2A2E     
0195 2156 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0196 2158 A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0197 215A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0198                                                   ; /         LSB offset for ASCII digit 0-9
0199               
0200 215C 06A0  32         bl    @setx                 ; Set cursor X position
     215E 26F8     
0201 2160 0004                   data 4                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 2162 06A0  32         bl    @putstr               ; Put '  >'
     2164 2432     
0205 2166 21C0                   data cpu.crash.msg.marker
0206               
0207 2168 06A0  32         bl    @setx                 ; Set cursor X position
     216A 26F8     
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
     2184 26E8     
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
0270 21ED   42             text  'Build-ID  211217-1822420'
     21EE 7569     
     21F0 6C64     
     21F2 2D49     
     21F4 4420     
     21F6 2032     
     21F8 3131     
     21FA 3231     
     21FC 372D     
     21FE 3138     
     2200 3232     
     2202 3432     
     2204 30       
0271                       even
0272               
                   < runlib.asm
0090                       copy  "vdp_tables.asm"           ; Data used by runtime library
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
0091                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
     2482 26E8     
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
0092               
0094                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0096               
0098                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0100               
0102                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0104               
0108               
0112               
0114                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
     **** ****     > cpu_sams_support.asm
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
0204 25E6 020C  20         li    r12,>1e00             ; SAMS CRU address
     25E8 1E00     
0205 25EA 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25EC 045B  20         b     *r11                  ; Return to caller
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
0227 25EE 020C  20         li    r12,>1e00             ; SAMS CRU address
     25F0 1E00     
0228 25F2 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25F4 045B  20         b     *r11                  ; Return to caller
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
0260 25F6 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25F8 0649  14         dect  stack
0263 25FA C64B  30         mov   r11,*stack            ; Save return address
0264 25FC 0649  14         dect  stack
0265 25FE C644  30         mov   tmp0,*stack           ; Save tmp0
0266 2600 0649  14         dect  stack
0267 2602 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 2604 0649  14         dect  stack
0269 2606 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 2608 0649  14         dect  stack
0271 260A C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 260C 0206  20         li    tmp2,8                ; Set loop counter
     260E 0008     
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 2610 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 2612 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 2614 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2616 258A     
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 2618 0606  14         dec   tmp2                  ; Next iteration
0288 261A 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 261C 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     261E 25E6     
0294                                                   ; / activating changes.
0295               
0296 2620 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 2622 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 2624 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 2626 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 2628 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 262A 045B  20         b     *r11                  ; Return to caller
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
0318 262C 0649  14         dect  stack
0319 262E C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 2630 06A0  32         bl    @sams.layout
     2632 25F6     
0324 2634 263A                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 2636 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 2638 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 263A 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     263C 0002     
0336 263E 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     2640 0003     
0337 2642 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     2644 000A     
0338 2646 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2648 000B     
0339 264A C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     264C 000C     
0340 264E D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     2650 000D     
0341 2652 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2654 000E     
0342 2656 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2658 000F     
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
0363 265A C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 265C 0649  14         dect  stack
0366 265E C64B  30         mov   r11,*stack            ; Push return address
0367 2660 0649  14         dect  stack
0368 2662 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2664 0649  14         dect  stack
0370 2666 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2668 0649  14         dect  stack
0372 266A C646  30         mov   tmp2,*stack           ; Push tmp2
0373 266C 0649  14         dect  stack
0374 266E C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 2670 0205  20         li    tmp1,sams.layout.copy.data
     2672 2692     
0379 2674 0206  20         li    tmp2,8                ; Set loop counter
     2676 0008     
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2678 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 267A 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     267C 2552     
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 267E CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2680 833C     
0390               
0391 2682 0606  14         dec   tmp2                  ; Next iteration
0392 2684 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2686 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2688 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 268A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 268C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 268E C2F9  30         mov   *stack+,r11           ; Pop r11
0402 2690 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2692 2000             data  >2000                 ; >2000-2fff
0408 2694 3000             data  >3000                 ; >3000-3fff
0409 2696 A000             data  >a000                 ; >a000-afff
0410 2698 B000             data  >b000                 ; >b000-bfff
0411 269A C000             data  >c000                 ; >c000-cfff
0412 269C D000             data  >d000                 ; >d000-dfff
0413 269E E000             data  >e000                 ; >e000-efff
0414 26A0 F000             data  >f000                 ; >f000-ffff
0415               
                   < runlib.asm
0116               
0118                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
     **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 26A2 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     26A4 FFBF     
0010 26A6 0460  28         b     @putv01
     26A8 235A     
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 26AA 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     26AC 0040     
0018 26AE 0460  28         b     @putv01
     26B0 235A     
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 26B2 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     26B4 FFDF     
0026 26B6 0460  28         b     @putv01
     26B8 235A     
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 26BA 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     26BC 0020     
0034 26BE 0460  28         b     @putv01
     26C0 235A     
                   < runlib.asm
0120               
0122                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 26C2 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     26C4 FFFE     
0011 26C6 0460  28         b     @putv01
     26C8 235A     
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 26CA 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     26CC 0001     
0019 26CE 0460  28         b     @putv01
     26D0 235A     
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 26D2 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     26D4 FFFD     
0027 26D6 0460  28         b     @putv01
     26D8 235A     
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 26DA 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     26DC 0002     
0035 26DE 0460  28         b     @putv01
     26E0 235A     
                   < runlib.asm
0124               
0126                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 26E2 C83B  50 at      mov   *r11+,@wyx
     26E4 832A     
0019 26E6 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26E8 B820  54 down    ab    @hb$01,@wyx
     26EA 2012     
     26EC 832A     
0028 26EE 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26F0 7820  54 up      sb    @hb$01,@wyx
     26F2 2012     
     26F4 832A     
0037 26F6 045B  20         b     *r11
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
0049 26F8 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26FA D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26FC 832A     
0051 26FE C804  38         mov   tmp0,@wyx             ; Save as new YX position
     2700 832A     
0052 2702 045B  20         b     *r11
                   < runlib.asm
0128               
0130                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
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
0021 2704 C120  34 yx2px   mov   @wyx,tmp0
     2706 832A     
0022 2708 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 270A 06C4  14         swpb  tmp0                  ; Y<->X
0024 270C 04C5  14         clr   tmp1                  ; Clear before copy
0025 270E D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 2710 20A0  38         coc   @wbit1,config         ; f18a present ?
     2712 201E     
0030 2714 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2716 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2718 833A     
     271A 2744     
0032 271C 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 271E 0A15  56         sla   tmp1,1                ; X = X * 2
0035 2720 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 2722 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     2724 0500     
0037 2726 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2728 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 272A 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 272C 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 272E D105  18         movb  tmp1,tmp0
0051 2730 06C4  14         swpb  tmp0                  ; X<->Y
0052 2732 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     2734 2020     
0053 2736 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 2738 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     273A 2012     
0059 273C 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     273E 2024     
0060 2740 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 2742 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 2744 0050            data   80
0067               
0068               
                   < runlib.asm
0132               
0136               
0140               
0142                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
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
0013 2746 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2748 06A0  32         bl    @putvr                ; Write once
     274A 2346     
0015 274C 391C             data  >391c                 ; VR1/57, value 00011100
0016 274E 06A0  32         bl    @putvr                ; Write twice
     2750 2346     
0017 2752 391C             data  >391c                 ; VR1/57, value 00011100
0018 2754 06A0  32         bl    @putvr
     2756 2346     
0019 2758 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 275A 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 275C C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 275E 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     2760 2346     
0030 2762 3900             data  >3900
0031 2764 0458  20         b     *tmp4                 ; Exit
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
0042 2766 C20B  18 f18idl  mov   r11,tmp4              ; Save R11
0043 2768 06A0  32         bl    @putvr                ; VR56 >38, value 00000000
     276A 2346     
0044 276C 3800             data  >3800                 ; Reset and load PC (GPU idle!)
0045 276E 0458  20         b     *tmp4                 ; Exit
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
0058 2770 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0059 2772 06A0  32         bl    @cpym2v
     2774 249A     
0060 2776 3F00             data  >3f00,f18chk_gpu,8    ; Copy F18A GPU code to VRAM
     2778 27BA     
     277A 0008     
0061 277C 06A0  32         bl    @putvr
     277E 2346     
0062 2780 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0063 2782 06A0  32         bl    @putvr
     2784 2346     
0064 2786 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0065                                                   ; GPU code should run now
0066               
0067 2788 06A0  32         bl    @putvr                ; VR56 >38, value 00000000
     278A 2346     
0068 278C 3800             data  >3800                 ; Reset and load PC (GPU idle!)
0069               ***************************************************************
0070               * VDP @>3f00 == 0 ? F18A present : F18a not present
0071               ***************************************************************
0072 278E 0204  20         li    tmp0,>3f00
     2790 3F00     
0073 2792 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     2794 22CE     
0074 2796 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2798 8800     
0075 279A 0984  56         srl   tmp0,8
0076 279C D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     279E 8800     
0077 27A0 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0078 27A2 1303  14         jeq   f18chk_yes
0079               f18chk_no:
0080 27A4 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     27A6 BFFF     
0081 27A8 1002  14         jmp   f18chk_exit
0082               f18chk_yes:
0083 27AA 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     27AC 4000     
0084               
0085               f18chk_exit:
0086 27AE 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     27B0 22A2     
0087 27B2 3F00             data  >3f00,>00,6
     27B4 0000     
     27B6 0006     
0088 27B8 0458  20         b     *tmp4                 ; Exit
0089               ***************************************************************
0090               * GPU code
0091               ********|*****|*********************|**************************
0092               f18chk_gpu
0093 27BA 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0094 27BC 3F00             data  >3f00                 ; 3f02 / 3f00
0095 27BE 0340             data  >0340                 ; 3f04   0340  idle
0096 27C0 10FF             data  >10ff                 ; 3f06   10ff  \ jmp $
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
0119 27C2 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0120                       ;------------------------------------------------------
0121                       ; Reset all F18a VDP registers to power-on defaults
0122                       ;------------------------------------------------------
0123 27C4 06A0  32         bl    @putvr
     27C6 2346     
0124 27C8 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0125               
0126 27CA 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     27CC 2346     
0127 27CE 3900             data  >3900                 ; Lock the F18a
0128 27D0 0458  20         b     *tmp4                 ; Exit
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
0147 27D2 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0148 27D4 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27D6 201E     
0149 27D8 1609  14         jne   f18fw1
0150               ***************************************************************
0151               * Read F18A major/minor version
0152               ***************************************************************
0153 27DA C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27DC 8802     
0154 27DE 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27E0 2346     
0155 27E2 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0156 27E4 04C4  14         clr   tmp0
0157 27E6 D120  34         movb  @vdps,tmp0
     27E8 8802     
0158 27EA 0984  56         srl   tmp0,8
0159 27EC 0458  20 f18fw1  b     *tmp4                 ; Exit
                   < runlib.asm
0144               
0146                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0017 27EE C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27F0 832A     
0018 27F2 D17B  28         movb  *r11+,tmp1
0019 27F4 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27F6 D1BB  28         movb  *r11+,tmp2
0021 27F8 0986  56         srl   tmp2,8                ; Repeat count
0022 27FA C1CB  18         mov   r11,tmp3
0023 27FC 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27FE 240E     
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 2800 020B  20         li    r11,hchar1
     2802 2808     
0028 2804 0460  28         b     @xfilv                ; Draw
     2806 22A8     
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 2808 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     280A 2022     
0033 280C 1302  14         jeq   hchar2                ; Yes, exit
0034 280E C2C7  18         mov   tmp3,r11
0035 2810 10EE  14         jmp   hchar                 ; Next one
0036 2812 05C7  14 hchar2  inct  tmp3
0037 2814 0457  20         b     *tmp3                 ; Exit
                   < runlib.asm
0148               
0152               
0156               
0160               
0162                       copy  "snd_player.asm"           ; Sound player
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
0014 2816 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     2818 8334     
0015 281A 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     281C 2006     
0016 281E 0204  20         li    tmp0,muttab
     2820 2830     
0017 2822 0205  20         li    tmp1,sound            ; Sound generator port >8400
     2824 8400     
0018 2826 D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 2828 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 282A D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 282C D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 282E 045B  20         b     *r11
0023 2830 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     2832 DFFF     
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
0043 2834 C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     2836 8334     
0044 2838 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     283A 8336     
0045 283C 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     283E FFF8     
0046 2840 E0BB  30         soc   *r11+,config          ; Set options
0047 2842 D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     2844 2012     
     2846 831B     
0048 2848 045B  20         b     *r11
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
0059 284A 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     284C 2006     
0060 284E 1301  14         jeq   sdpla1                ; Yes, play
0061 2850 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 2852 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 2854 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     2856 831B     
     2858 2000     
0067 285A 1301  14         jeq   sdpla3                ; Play next note
0068 285C 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 285E 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     2860 2002     
0070 2862 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 2864 C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     2866 8336     
0075 2868 06C4  14         swpb  tmp0
0076 286A D804  38         movb  tmp0,@vdpa
     286C 8C02     
0077 286E 06C4  14         swpb  tmp0
0078 2870 D804  38         movb  tmp0,@vdpa
     2872 8C02     
0079 2874 04C4  14         clr   tmp0
0080 2876 D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     2878 8800     
0081 287A 131E  14         jeq   sdexit                ; Yes. exit
0082 287C 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 287E A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     2880 8336     
0084 2882 D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     2884 8800     
     2886 8400     
0085 2888 0604  14         dec   tmp0
0086 288A 16FB  14         jne   vdpla2
0087 288C D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     288E 8800     
     2890 831B     
0088 2892 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     2894 8336     
0089 2896 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 2898 C120  34 mmplay  mov   @wsdtmp,tmp0
     289A 8336     
0094 289C D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 289E 130C  14         jeq   sdexit                ; Yes, exit
0096 28A0 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 28A2 A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     28A4 8336     
0098 28A6 D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     28A8 8400     
0099 28AA 0605  14         dec   tmp1
0100 28AC 16FC  14         jne   mmpla2
0101 28AE D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     28B0 831B     
0102 28B2 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     28B4 8336     
0103 28B6 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 28B8 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     28BA 2004     
0108 28BC 1607  14         jne   sdexi2                ; No, exit
0109 28BE C820  54         mov   @wsdlst,@wsdtmp
     28C0 8334     
     28C2 8336     
0110 28C4 D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     28C6 2012     
     28C8 831B     
0111 28CA 045B  20 sdexi1  b     *r11                  ; Exit
0112 28CC 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     28CE FFF8     
0113 28D0 045B  20         b     *r11                  ; Exit
0114               
                   < runlib.asm
0164               
0168               
0172               
0176               
0178                       copy  "keyb_real.asm"            ; Real Keyboard support
     **** ****     > keyb_real.asm
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
0016 28D2 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     28D4 2020     
0017 28D6 020C  20         li    r12,>0024
     28D8 0024     
0018 28DA 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     28DC 296E     
0019 28DE 04C6  14         clr   tmp2
0020 28E0 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 28E2 04CC  14         clr   r12
0025 28E4 1F08  20         tb    >0008                 ; Shift-key ?
0026 28E6 1302  14         jeq   realk1                ; No
0027 28E8 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     28EA 299E     
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 28EC 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 28EE 1302  14         jeq   realk2                ; No
0033 28F0 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     28F2 29CE     
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 28F4 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 28F6 1302  14         jeq   realk3                ; No
0039 28F8 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     28FA 29FE     
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 28FC 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     28FE 200C     
0044 2900 1E15  20         sbz   >0015                 ; Set P5
0045 2902 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 2904 1302  14         jeq   realk4                ; No
0047 2906 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     2908 200C     
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 290A 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 290C 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     290E 0006     
0053 2910 0606  14 realk5  dec   tmp2
0054 2912 020C  20         li    r12,>24               ; CRU address for P2-P4
     2914 0024     
0055 2916 06C6  14         swpb  tmp2
0056 2918 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 291A 06C6  14         swpb  tmp2
0058 291C 020C  20         li    r12,6                 ; CRU read address
     291E 0006     
0059 2920 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 2922 0547  14         inv   tmp3                  ;
0061 2924 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2926 FF00     
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2928 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 292A 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 292C 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 292E 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 2930 0285  22         ci    tmp1,8
     2932 0008     
0070 2934 1AFA  14         jl    realk6
0071 2936 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2938 1BEB  14         jh    realk5                ; No, next column
0073 293A 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 293C C206  18 realk8  mov   tmp2,tmp4
0078 293E 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 2940 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 2942 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2944 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2946 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2948 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 294A 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     294C 200C     
0089 294E 1608  14         jne   realka                ; No, continue saving key
0090 2950 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2952 2998     
0091 2954 1A05  14         jl    realka
0092 2956 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2958 2996     
0093 295A 1B02  14         jh    realka                ; No, continue
0094 295C 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     295E E000     
0095 2960 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2962 833C     
0096 2964 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2966 200A     
0097 2968 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     296A 8C00     
0098                                                   ; / using R15 as temp storage
0099 296C 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 296E FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2970 0000     
     2972 FF0D     
     2974 203D     
0102 2976 7877             text  'xws29ol.'
     2978 7332     
     297A 396F     
     297C 6C2E     
0103 297E 6365             text  'ced38ik,'
     2980 6433     
     2982 3869     
     2984 6B2C     
0104 2986 7672             text  'vrf47ujm'
     2988 6634     
     298A 3775     
     298C 6A6D     
0105 298E 6274             text  'btg56yhn'
     2990 6735     
     2992 3679     
     2994 686E     
0106 2996 7A71             text  'zqa10p;/'
     2998 6131     
     299A 3070     
     299C 3B2F     
0107 299E FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     29A0 0000     
     29A2 FF0D     
     29A4 202B     
0108 29A6 5857             text  'XWS@(OL>'
     29A8 5340     
     29AA 284F     
     29AC 4C3E     
0109 29AE 4345             text  'CED#*IK<'
     29B0 4423     
     29B2 2A49     
     29B4 4B3C     
0110 29B6 5652             text  'VRF$&UJM'
     29B8 4624     
     29BA 2655     
     29BC 4A4D     
0111 29BE 4254             text  'BTG%^YHN'
     29C0 4725     
     29C2 5E59     
     29C4 484E     
0112 29C6 5A51             text  'ZQA!)P:-'
     29C8 4121     
     29CA 2950     
     29CC 3A2D     
0113 29CE FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     29D0 0000     
     29D2 FF0D     
     29D4 2005     
0114 29D6 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     29D8 0804     
     29DA 0F27     
     29DC C2B9     
0115 29DE 600B             data  >600b,>0907,>063f,>c1B8
     29E0 0907     
     29E2 063F     
     29E4 C1B8     
0116 29E6 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     29E8 7B02     
     29EA 015F     
     29EC C0C3     
0117 29EE BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     29F0 7D0E     
     29F2 0CC6     
     29F4 BFC4     
0118 29F6 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     29F8 7C03     
     29FA BC22     
     29FC BDBA     
0119 29FE FF00     kbctrl  data  >ff00,>0000,>ff0d,>f09D
     2A00 0000     
     2A02 FF0D     
     2A04 F09D     
0120 2A06 9897             data  >9897,>93b2,>9f8f,>8c9B
     2A08 93B2     
     2A0A 9F8F     
     2A0C 8C9B     
0121 2A0E 8385             data  >8385,>84b3,>9e89,>8b80
     2A10 84B3     
     2A12 9E89     
     2A14 8B80     
0122 2A16 9692             data  >9692,>86b4,>b795,>8a8D
     2A18 86B4     
     2A1A B795     
     2A1C 8A8D     
0123 2A1E 8294             data  >8294,>87b5,>b698,>888E
     2A20 87B5     
     2A22 B698     
     2A24 888E     
0124 2A26 9A91             data  >9a91,>81b1,>b090,>9cBB
     2A28 81B1     
     2A2A B090     
     2A2C 9CBB     
                   < runlib.asm
0180               
0182                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0023 2A2E C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2A30 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2A32 8340     
0025 2A34 04E0  34         clr   @waux1
     2A36 833C     
0026 2A38 04E0  34         clr   @waux2
     2A3A 833E     
0027 2A3C 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2A3E 833C     
0028 2A40 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2A42 0205  20         li    tmp1,4                ; 4 nibbles
     2A44 0004     
0033 2A46 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2A48 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2A4A 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2A4C 0286  22         ci    tmp2,>000a
     2A4E 000A     
0039 2A50 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2A52 C21B  26         mov   *r11,tmp4
0045 2A54 0988  56         srl   tmp4,8                ; Right justify
0046 2A56 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2A58 FFF6     
0047 2A5A 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2A5C C21B  26         mov   *r11,tmp4
0054 2A5E 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2A60 00FF     
0055               
0056 2A62 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2A64 06C6  14         swpb  tmp2
0058 2A66 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2A68 0944  56         srl   tmp0,4                ; Next nibble
0060 2A6A 0605  14         dec   tmp1
0061 2A6C 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2A6E 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2A70 BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2A72 C160  34         mov   @waux3,tmp1           ; Get pointer
     2A74 8340     
0067 2A76 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2A78 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2A7A C120  34         mov   @waux2,tmp0
     2A7C 833E     
0070 2A7E 06C4  14         swpb  tmp0
0071 2A80 DD44  32         movb  tmp0,*tmp1+
0072 2A82 06C4  14         swpb  tmp0
0073 2A84 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2A86 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2A88 8340     
0078 2A8A D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2A8C 2016     
0079 2A8E 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2A90 C120  34         mov   @waux1,tmp0
     2A92 833C     
0084 2A94 06C4  14         swpb  tmp0
0085 2A96 DD44  32         movb  tmp0,*tmp1+
0086 2A98 06C4  14         swpb  tmp0
0087 2A9A DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2A9C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A9E 2020     
0092 2AA0 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2AA2 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2AA4 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2AA6 7FFF     
0098 2AA8 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2AAA 8340     
0099 2AAC 0460  28         b     @xutst0               ; Display string
     2AAE 2434     
0100 2AB0 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2AB2 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2AB4 832A     
0122 2AB6 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2AB8 8000     
0123 2ABA 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
                   < runlib.asm
0184               
0186                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 2ABC 0207  20 mknum   li    tmp3,5                ; Digit counter
     2ABE 0005     
0020 2AC0 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 2AC2 C155  26         mov   *tmp1,tmp1            ; /
0022 2AC4 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 2AC6 0228  22         ai    tmp4,4                ; Get end of buffer
     2AC8 0004     
0024 2ACA 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     2ACC 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 2ACE 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 2AD0 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 2AD2 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 2AD4 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 2AD6 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 2AD8 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 2ADA 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 2ADC 0607  14         dec   tmp3                  ; Decrease counter
0036 2ADE 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 2AE0 0207  20         li    tmp3,4                ; Check first 4 digits
     2AE2 0004     
0041 2AE4 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2AE6 C11B  26         mov   *r11,tmp0
0043 2AE8 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2AEA 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2AEC 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2AEE 05CB  14 mknum3  inct  r11
0047 2AF0 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2AF2 2020     
0048 2AF4 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2AF6 045B  20         b     *r11                  ; Exit
0050 2AF8 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2AFA 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2AFC 13F8  14         jeq   mknum3                ; Yes, exit
0053 2AFE 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2B00 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2B02 7FFF     
0058 2B04 C10B  18         mov   r11,tmp0
0059 2B06 0224  22         ai    tmp0,-4
     2B08 FFFC     
0060 2B0A C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2B0C 0206  20         li    tmp2,>0500            ; String length = 5
     2B0E 0500     
0062 2B10 0460  28         b     @xutstr               ; Display string
     2B12 2436     
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
0093 2B14 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2B16 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2B18 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2B1A 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2B1C 0207  20         li    tmp3,5                ; Set counter
     2B1E 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2B20 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2B22 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2B24 0584  14         inc   tmp0                  ; Next character
0105 2B26 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2B28 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2B2A 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2B2C 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2B2E DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2B30 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2B32 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2B34 0607  14         dec   tmp3                  ; Last character ?
0121 2B36 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2B38 045B  20         b     *r11                  ; Return
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
0139 2B3A C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2B3C 832A     
0140 2B3E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2B40 8000     
0141 2B42 10BC  14         jmp   mknum                 ; Convert number and display
                   < runlib.asm
0188               
0192               
0196               
0200               
0204               
0206                       copy  "cpu_strings.asm"          ; String utilities support
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
0022 2B44 0649  14         dect  stack
0023 2B46 C64B  30         mov   r11,*stack            ; Save return address
0024 2B48 0649  14         dect  stack
0025 2B4A C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2B4C 0649  14         dect  stack
0027 2B4E C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2B50 0649  14         dect  stack
0029 2B52 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2B54 0649  14         dect  stack
0031 2B56 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2B58 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2B5A C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2B5C C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2B5E 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2B60 0649  14         dect  stack
0044 2B62 C64B  30         mov   r11,*stack            ; Save return address
0045 2B64 0649  14         dect  stack
0046 2B66 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2B68 0649  14         dect  stack
0048 2B6A C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2B6C 0649  14         dect  stack
0050 2B6E C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2B70 0649  14         dect  stack
0052 2B72 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2B74 C1D4  26 !       mov   *tmp0,tmp3
0057 2B76 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2B78 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2B7A 00FF     
0059 2B7C 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2B7E 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2B80 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2B82 0584  14         inc   tmp0                  ; Next byte
0067 2B84 0607  14         dec   tmp3                  ; Shorten string length
0068 2B86 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2B88 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2B8A 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2B8C C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2B8E 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2B90 C187  18         mov   tmp3,tmp2
0078 2B92 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2B94 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2B96 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2B98 24F4     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2B9A 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2B9C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B9E FFCE     
0090 2BA0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2BA2 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2BA4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2BA6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2BA8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2BAA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2BAC C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2BAE 045B  20         b     *r11                  ; Return to caller
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
0123 2BB0 0649  14         dect  stack
0124 2BB2 C64B  30         mov   r11,*stack            ; Save return address
0125 2BB4 05D9  26         inct  *stack                ; Skip "data P0"
0126 2BB6 05D9  26         inct  *stack                ; Skip "data P1"
0127 2BB8 0649  14         dect  stack
0128 2BBA C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2BBC 0649  14         dect  stack
0130 2BBE C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2BC0 0649  14         dect  stack
0132 2BC2 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2BC4 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2BC6 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2BC8 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2BCA 0649  14         dect  stack
0144 2BCC C64B  30         mov   r11,*stack            ; Save return address
0145 2BCE 0649  14         dect  stack
0146 2BD0 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2BD2 0649  14         dect  stack
0148 2BD4 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2BD6 0649  14         dect  stack
0150 2BD8 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2BDA 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2BDC 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2BDE 0586  14         inc   tmp2
0161 2BE0 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2BE2 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2BE4 0286  22         ci    tmp2,255
     2BE6 00FF     
0167 2BE8 1505  14         jgt   string.getlenc.panic
0168 2BEA 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2BEC 0606  14         dec   tmp2                  ; One time adjustment
0174 2BEE C806  38         mov   tmp2,@waux1           ; Store length
     2BF0 833C     
0175 2BF2 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2BF4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2BF6 FFCE     
0181 2BF8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2BFA 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2BFC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2BFE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2C00 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2C02 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2C04 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0208               
0212               
0214                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
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
0023 2C06 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2C08 F960     
0024 2C0A C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2C0C F962     
0025 2C0E C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2C10 F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 2C12 0200  20         li    r0,>8306              ; Scratchpad source address
     2C14 8306     
0030 2C16 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2C18 F966     
0031 2C1A 0202  20         li    r2,62                 ; Loop counter
     2C1C 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 2C1E CC70  46         mov   *r0+,*r1+
0037 2C20 CC70  46         mov   *r0+,*r1+
0038 2C22 0642  14         dect  r2
0039 2C24 16FC  14         jne   cpu.scrpad.backup.copy
0040 2C26 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2C28 83FE     
     2C2A FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 2C2C C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2C2E F960     
0046 2C30 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2C32 F962     
0047 2C34 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2C36 F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 2C38 045B  20         b     *r11                  ; Return to caller
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
0066               *  Current workspace may not be in scratchpad >8300 when called.
0067               ********|*****|*********************|**************************
0068               cpu.scrpad.restore:
0069 2C3A 0649  14         dect  stack
0070 2C3C C64B  30         mov   r11,*stack            ; Save return address
0071 2C3E 0649  14         dect  stack
0072 2C40 C640  30         mov   r0,*stack             ; Push r0
0073 2C42 0649  14         dect  stack
0074 2C44 C641  30         mov   r1,*stack             ; Push r1
0075 2C46 0649  14         dect  stack
0076 2C48 C642  30         mov   r2,*stack             ; Push r2
0077                       ;------------------------------------------------------
0078                       ; Prepare for copy loop, WS
0079                       ;------------------------------------------------------
0080 2C4A 0200  20         li    r0,cpu.scrpad.tgt
     2C4C F960     
0081 2C4E 0201  20         li    r1,>8300
     2C50 8300     
0082 2C52 0202  20         li    r2,64
     2C54 0040     
0083                       ;------------------------------------------------------
0084                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0085                       ;------------------------------------------------------
0086               cpu.scrpad.restore.copy:
0087 2C56 CC70  46         mov   *r0+,*r1+
0088 2C58 CC70  46         mov   *r0+,*r1+
0089 2C5A 0602  14         dec   r2
0090 2C5C 16FC  14         jne   cpu.scrpad.restore.copy
0091                       ;------------------------------------------------------
0092                       ; Exit
0093                       ;------------------------------------------------------
0094               cpu.scrpad.restore.exit:
0095 2C5E C0B9  30         mov   *stack+,r2            ; Pop r2
0096 2C60 C079  30         mov   *stack+,r1            ; Pop r1
0097 2C62 C039  30         mov   *stack+,r0            ; Pop r0
0098 2C64 C2F9  30         mov   *stack+,r11           ; Pop r11
0099 2C66 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0215                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
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
0038 2C68 C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 2C6A CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 2C6C CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 2C6E CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 2C70 CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 2C72 CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 2C74 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 2C76 CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 2C78 CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 2C7A 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     2C7C 8310     
0055                                                   ;        as of register r8
0056 2C7E 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     2C80 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 2C82 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 2C84 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 2C86 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 2C88 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 2C8A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 2C8C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 2C8E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 2C90 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 2C92 0606  14         dec   tmp2
0069 2C94 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 2C96 C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 2C98 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2C9A 2CA0     
0075                                                   ; R14=PC
0076 2C9C 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 2C9E 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 2CA0 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     2CA2 2C3A     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 2CA4 045B  20         b     *r11                  ; Return to caller
0094               
0095               
0096               ***************************************************************
0097               * cpu.scrpad.pgin - Page in 256 bytes of scratchpad memory
0098               *                   at >8300 from CPU memory specified in
0099               *                   p0 (tmp0)
0100               ***************************************************************
0101               *  bl   @cpu.scrpad.pgin
0102               *  DATA p0
0103               *  P0 = CPU memory source
0104               *--------------------------------------------------------------
0105               *  bl   @memx.scrpad.pgin
0106               *  TMP0 = CPU memory source
0107               *--------------------------------------------------------------
0108               *  Register usage
0109               *  tmp0-tmp2 = Used as temporary registers
0110               *--------------------------------------------------------------
0111               *  Remarks
0112               *  Copies 256 bytes from CPU memory source to scratchpad >8300
0113               *  and activates workspace in scratchpad >8300
0114               *
0115               *  It's expected that the workspace is outside scratchpad >8300
0116               *  when calling this function.
0117               ********|*****|*********************|**************************
0118               cpu.scrpad.pgin:
0119 2CA6 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0120                       ;------------------------------------------------------
0121                       ; Copy scratchpad memory to destination
0122                       ;------------------------------------------------------
0123               xcpu.scrpad.pgin:
0124 2CA8 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2CAA 8300     
0125 2CAC 0206  20         li    tmp2,16               ; tmp2 = 256/16
     2CAE 0010     
0126                       ;------------------------------------------------------
0127                       ; Copy memory
0128                       ;------------------------------------------------------
0129 2CB0 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0130 2CB2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0131 2CB4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0132 2CB6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0133 2CB8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0134 2CBA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0135 2CBC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0136 2CBE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0137 2CC0 0606  14         dec   tmp2
0138 2CC2 16F6  14         jne   -!                    ; Loop until done
0139                       ;------------------------------------------------------
0140                       ; Switch workspace to scratchpad memory
0141                       ;------------------------------------------------------
0142 2CC4 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2CC6 8300     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               cpu.scrpad.pgin.exit:
0147 2CC8 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0217               
0219                       copy  "fio.equ"                  ; File I/O equates
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
0220                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
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
0056 2CCA A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2CCC 2CCE             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2CCE C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2CD0 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2CD2 A428     
0064 2CD4 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2CD6 201C     
0065 2CD8 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2CDA 8356     
0066 2CDC C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2CDE 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2CE0 FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2CE2 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2CE4 A434     
0073                       ;---------------------------; Inline VSBR start
0074 2CE6 06C0  14         swpb  r0                    ;
0075 2CE8 D800  38         movb  r0,@vdpa              ; Send low byte
     2CEA 8C02     
0076 2CEC 06C0  14         swpb  r0                    ;
0077 2CEE D800  38         movb  r0,@vdpa              ; Send high byte
     2CF0 8C02     
0078 2CF2 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2CF4 8800     
0079                       ;---------------------------; Inline VSBR end
0080 2CF6 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2CF8 0704  14         seto  r4                    ; Init counter
0086 2CFA 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2CFC A420     
0087 2CFE 0580  14 !       inc   r0                    ; Point to next char of name
0088 2D00 0584  14         inc   r4                    ; Increment char counter
0089 2D02 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2D04 0007     
0090 2D06 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2D08 80C4  18         c     r4,r3                 ; End of name?
0093 2D0A 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2D0C 06C0  14         swpb  r0                    ;
0098 2D0E D800  38         movb  r0,@vdpa              ; Send low byte
     2D10 8C02     
0099 2D12 06C0  14         swpb  r0                    ;
0100 2D14 D800  38         movb  r0,@vdpa              ; Send high byte
     2D16 8C02     
0101 2D18 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2D1A 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2D1C DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2D1E 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2D20 2E36     
0109 2D22 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2D24 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2D26 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2D28 04E0  34         clr   @>83d0
     2D2A 83D0     
0118 2D2C C804  38         mov   r4,@>8354             ; Save name length for search (length
     2D2E 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2D30 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2D32 A432     
0121               
0122 2D34 0584  14         inc   r4                    ; Adjust for dot
0123 2D36 A804  38         a     r4,@>8356             ; Point to position after name
     2D38 8356     
0124 2D3A C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2D3C 8356     
     2D3E A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2D40 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2D42 83E0     
0130 2D44 04C1  14         clr   r1                    ; Version found of dsr
0131 2D46 020C  20         li    r12,>0f00             ; Init cru address
     2D48 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2D4A C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2D4C 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2D4E 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2D50 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2D52 0100     
0145 2D54 04E0  34         clr   @>83d0                ; Clear in case we are done
     2D56 83D0     
0146 2D58 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2D5A 2000     
0147 2D5C 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2D5E C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2D60 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2D62 1D00  20         sbo   0                     ; Turn on ROM
0154 2D64 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2D66 4000     
0155 2D68 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2D6A 2E32     
0156 2D6C 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2D6E A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2D70 A40A     
0166 2D72 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2D74 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2D76 83D2     
0172                                                   ; subprogram
0173               
0174 2D78 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2D7A C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2D7C 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2D7E C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2D80 83D2     
0183                                                   ; subprogram
0184               
0185 2D82 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2D84 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2D86 04C5  14         clr   r5                    ; Remove any old stuff
0194 2D88 D160  34         movb  @>8355,r5             ; Get length as counter
     2D8A 8355     
0195 2D8C 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2D8E 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2D90 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2D92 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2D94 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2D96 A420     
0206 2D98 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2D9A 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2D9C 0605  14         dec   r5                    ; Update loop counter
0211 2D9E 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2DA0 0581  14         inc   r1                    ; Next version found
0217 2DA2 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2DA4 A42A     
0218 2DA6 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2DA8 A42C     
0219 2DAA C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2DAC A430     
0220               
0221 2DAE 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2DB0 8C02     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2DB2 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2DB4 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2DB6 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2DB8 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2DBA A400     
0233 2DBC C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2DBE C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2DC0 A428     
0239                                                   ; (8 or >a)
0240 2DC2 0281  22         ci    r1,8                  ; was it 8?
     2DC4 0008     
0241 2DC6 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2DC8 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2DCA 8350     
0243                                                   ; Get error byte from @>8350
0244 2DCC 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2DCE 06C0  14         swpb  r0                    ;
0252 2DD0 D800  38         movb  r0,@vdpa              ; send low byte
     2DD2 8C02     
0253 2DD4 06C0  14         swpb  r0                    ;
0254 2DD6 D800  38         movb  r0,@vdpa              ; send high byte
     2DD8 8C02     
0255 2DDA D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2DDC 8800     
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2DDE 09D1  56         srl   r1,13                 ; just keep error bits
0263 2DE0 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2DE2 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2DE4 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2DE6 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2DE8 A400     
0275               dsrlnk.error.devicename_invalid:
0276 2DEA 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2DEC 06C1  14         swpb  r1                    ; put error in hi byte
0279 2DEE D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2DF0 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2DF2 201C     
0281                                                   ; / to indicate error
0282 2DF4 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2DF6 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2DF8 2DFA             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2DFA 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2DFC 83E0     
0316               
0317 2DFE 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2E00 201C     
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2E02 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2E04 A42A     
0322 2E06 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2E08 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2E0A C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2E0C 8356     
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2E0E C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2E10 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2E12 8354     
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2E14 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2E16 8C02     
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2E18 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2E1A 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2E1C 4000     
     2E1E 2E32     
0337 2E20 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2E22 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2E24 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2E26 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2E28 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2E2A A400     
0355 2E2C C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2E2E A434     
0356               
0357 2E30 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2E32 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2E34 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2E36 2E       dsrlnk.period     text  '.'         ; For finding end of device name
0367               
0368                       even
                   < runlib.asm
0221                       copy  "fio_level3.asm"           ; File I/O level 3 support
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
0045 2E38 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2E3A C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2E3C 0649  14         dect  stack
0052 2E3E C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2E40 0204  20         li    tmp0,dsrlnk.savcru
     2E42 A42A     
0057 2E44 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2E46 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2E48 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2E4A 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2E4C 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2E4E 37D7     
0065 2E50 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2E52 8370     
0066                                                   ; / location
0067 2E54 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2E56 A44C     
0068 2E58 04C5  14         clr   tmp1                  ; io.op.open
0069 2E5A 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2E5C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2E5E 0649  14         dect  stack
0097 2E60 C64B  30         mov   r11,*stack            ; Save return address
0098 2E62 0205  20         li    tmp1,io.op.close      ; io.op.close
     2E64 0001     
0099 2E66 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2E68 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2E6A 0649  14         dect  stack
0125 2E6C C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2E6E 0205  20         li    tmp1,io.op.read       ; io.op.read
     2E70 0002     
0128 2E72 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2E74 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2E76 0649  14         dect  stack
0155 2E78 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2E7A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2E7C 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2E7E 0005     
0159               
0160 2E80 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2E82 A43E     
0161               
0162 2E84 06A0  32         bl    @xvputb               ; Write character count to PAB
     2E86 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2E88 0205  20         li    tmp1,io.op.write      ; io.op.write
     2E8A 0003     
0167 2E8C 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2E8E 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2E90 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2E92 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2E94 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2E96 1000  14         nop
0189               
0190               
0191               file.status:
0192 2E98 1000  14         nop
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
0227 2E9A C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2E9C A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2E9E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2EA0 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2EA2 A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2EA4 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2EA6 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2EA8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2EAA 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2EAC C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2EAE A44C     
0246               
0247 2EB0 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2EB2 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2EB4 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2EB6 0009     
0254 2EB8 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2EBA 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2EBC C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2EBE 8322     
     2EC0 833C     
0259               
0260 2EC2 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2EC4 A42A     
0261 2EC6 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2EC8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2ECA 2CCA     
0268 2ECC 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2ECE 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2ED0 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2ED2 2DF6     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2ED4 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2ED6 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2ED8 833C     
     2EDA 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2EDC C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2EDE A436     
0292 2EE0 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2EE2 0005     
0293 2EE4 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2EE6 22F8     
0294 2EE8 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2EEA C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2EEC C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2EEE 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0223               
0224               *//////////////////////////////////////////////////////////////
0225               *                            TIMERS
0226               *//////////////////////////////////////////////////////////////
0227               
0228                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 2EF0 0300  24 tmgr    limi  0                     ; No interrupt processing
     2EF2 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2EF4 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2EF6 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2EF8 2360  38         coc   @wbit2,r13            ; C flag on ?
     2EFA 201C     
0029 2EFC 1602  14         jne   tmgr1a                ; No, so move on
0030 2EFE E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2F00 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2F02 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2F04 2020     
0035 2F06 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2F08 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2F0A 2010     
0048 2F0C 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2F0E 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2F10 200E     
0050 2F12 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2F14 0460  28         b     @kthread              ; Run kernel thread
     2F16 2F8E     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2F18 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2F1A 2014     
0056 2F1C 13EB  14         jeq   tmgr1
0057 2F1E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2F20 2012     
0058 2F22 16E8  14         jne   tmgr1
0059 2F24 C120  34         mov   @wtiusr,tmp0
     2F26 832E     
0060 2F28 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2F2A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2F2C 2F8C     
0065 2F2E C10A  18         mov   r10,tmp0
0066 2F30 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2F32 00FF     
0067 2F34 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2F36 201C     
0068 2F38 1303  14         jeq   tmgr5
0069 2F3A 0284  22         ci    tmp0,60               ; 1 second reached ?
     2F3C 003C     
0070 2F3E 1002  14         jmp   tmgr6
0071 2F40 0284  22 tmgr5   ci    tmp0,50
     2F42 0032     
0072 2F44 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2F46 1001  14         jmp   tmgr8
0074 2F48 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2F4A C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2F4C 832C     
0079 2F4E 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2F50 FF00     
0080 2F52 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2F54 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2F56 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2F58 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2F5A C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2F5C 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2F5E 830C     
     2F60 830D     
0089 2F62 1608  14         jne   tmgr10                ; No, get next slot
0090 2F64 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2F66 FF00     
0091 2F68 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2F6A C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2F6C 8330     
0096 2F6E 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2F70 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2F72 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2F74 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2F76 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2F78 8315     
     2F7A 8314     
0103 2F7C 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2F7E 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2F80 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2F82 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2F84 10F7  14         jmp   tmgr10                ; Process next slot
0108 2F86 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2F88 FF00     
0109 2F8A 10B4  14         jmp   tmgr1
0110 2F8C 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
                   < runlib.asm
0229                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 2F8E E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2F90 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 2F92 20A0  38         coc   @wbit13,config        ; Sound player on ?
     2F94 2006     
0023 2F96 1602  14         jne   kthread_kb
0024 2F98 06A0  32         bl    @sdpla1               ; Run sound player
     2F9A 2852     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 2F9C 06A0  32         bl    @realkb               ; Scan full keyboard
     2F9E 28D2     
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2FA0 0460  28         b     @tmgr3                ; Exit
     2FA2 2F18     
                   < runlib.asm
0230                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 2FA4 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2FA6 832E     
0018 2FA8 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2FAA 2012     
0019 2FAC 045B  20 mkhoo1  b     *r11                  ; Return
0020      2EF4     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2FAE 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2FB0 832E     
0029 2FB2 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2FB4 FEFF     
0030 2FB6 045B  20         b     *r11                  ; Return
                   < runlib.asm
0231               
0233                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 2FB8 C13B  30 mkslot  mov   *r11+,tmp0
0018 2FBA C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2FBC C184  18         mov   tmp0,tmp2
0023 2FBE 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2FC0 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2FC2 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2FC4 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2FC6 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2FC8 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2FCA 881B  46         c     *r11,@w$ffff          ; End of list ?
     2FCC 2022     
0035 2FCE 1301  14         jeq   mkslo1                ; Yes, exit
0036 2FD0 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2FD2 05CB  14 mkslo1  inct  r11
0041 2FD4 045B  20         b     *r11                  ; Exit
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
0052 2FD6 C13B  30 clslot  mov   *r11+,tmp0
0053 2FD8 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2FDA A120  34         a     @wtitab,tmp0          ; Add table base
     2FDC 832C     
0055 2FDE 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2FE0 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2FE2 045B  20         b     *r11                  ; Exit
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
0068 2FE4 C13B  30 rsslot  mov   *r11+,tmp0
0069 2FE6 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2FE8 A120  34         a     @wtitab,tmp0          ; Add table base
     2FEA 832C     
0071 2FEC 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2FEE C154  26         mov   *tmp0,tmp1
0073 2FF0 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2FF2 FF00     
0074 2FF4 C505  30         mov   tmp1,*tmp0
0075 2FF6 045B  20         b     *r11                  ; Exit
                   < runlib.asm
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
0261 2FF8 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2FFA 8302     
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 2FFC 0300  24 runli1  limi  0                     ; Turn off interrupts
     2FFE 0000     
0267 3000 02E0  18         lwpi  ws1                   ; Activate workspace 1
     3002 8300     
0268 3004 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     3006 83C0     
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 3008 0202  20 runli2  li    r2,>8308
     300A 8308     
0273 300C 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 300E 0282  22         ci    r2,>8400
     3010 8400     
0275 3012 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 3014 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     3016 FFFF     
0280 3018 1602  14         jne   runli4                ; No, continue
0281 301A 0420  54         blwp  @0                    ; Yes, bye bye
     301C 0000     
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 301E C803  38 runli4  mov   r3,@waux1             ; Store random seed
     3020 833C     
0286 3022 04C1  14         clr   r1                    ; Reset counter
0287 3024 0202  20         li    r2,10                 ; We test 10 times
     3026 000A     
0288 3028 C0E0  34 runli5  mov   @vdps,r3
     302A 8802     
0289 302C 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     302E 2020     
0290 3030 1302  14         jeq   runli6
0291 3032 0581  14         inc   r1                    ; Increase counter
0292 3034 10F9  14         jmp   runli5
0293 3036 0602  14 runli6  dec   r2                    ; Next test
0294 3038 16F7  14         jne   runli5
0295 303A 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     303C 1250     
0296 303E 1202  14         jle   runli7                ; No, so it must be NTSC
0297 3040 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     3042 201C     
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 3044 06A0  32 runli7  bl    @loadmc
     3046 222E     
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 3048 04C1  14 runli9  clr   r1
0306 304A 04C2  14         clr   r2
0307 304C 04C3  14         clr   r3
0308 304E 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     3050 AF00     
0309 3052 020F  20         li    r15,vdpw              ; Set VDP write address
     3054 8C00     
0311 3056 06A0  32         bl    @mute                 ; Mute sound generators
     3058 2816     
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 305A 0280  22         ci    r0,>4a4a              ; Crash flag set?
     305C 4A4A     
0318 305E 1605  14         jne   runlia
0319 3060 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     3062 22A2     
0320 3064 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     3066 0000     
     3068 3000     
0325 306A 06A0  32 runlia  bl    @filv
     306C 22A2     
0326 306E 0FC0             data  pctadr,spfclr,16      ; Load color table
     3070 00F4     
     3072 0010     
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 3074 06A0  32         bl    @f18unl               ; Unlock the F18A
     3076 2746     
0334 3078 06A0  32         bl    @f18chk               ; Check if F18A is there \
     307A 2770     
0335 307C 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     307E 2770     
0336 3080 06A0  32         bl    @f18chk               ; Check if F18A is there /
     3082 2770     
0337 3084 06A0  32         bl    @f18lck               ; Lock the F18A again
     3086 275C     
0338               
0339 3088 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     308A 2346     
0340 308C 3201                   data >3201            ; F18a VR50 (>32), bit 1
0342               *--------------------------------------------------------------
0343               * Check if there is a speech synthesizer attached
0344               *--------------------------------------------------------------
0346               *       <<skipped>>
0350               *--------------------------------------------------------------
0351               * Load video mode table & font
0352               *--------------------------------------------------------------
0353 308E 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     3090 230C     
0354 3092 3666             data  spvmod                ; Equate selected video mode table
0355 3094 0204  20         li    tmp0,spfont           ; Get font option
     3096 000C     
0356 3098 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0357 309A 1304  14         jeq   runlid                ; Yes, skip it
0358 309C 06A0  32         bl    @ldfnt
     309E 2374     
0359 30A0 1100             data  fntadr,spfont         ; Load specified font
     30A2 000C     
0360               *--------------------------------------------------------------
0361               * Did a system crash occur before runlib was called?
0362               *--------------------------------------------------------------
0363 30A4 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     30A6 4A4A     
0364 30A8 1602  14         jne   runlie                ; No, continue
0365 30AA 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     30AC 2086     
0366               *--------------------------------------------------------------
0367               * Branch to main program
0368               *--------------------------------------------------------------
0369 30AE 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     30B0 0040     
0370 30B2 0460  28         b     @main                 ; Give control to main program
     30B4 6046     
                   < stevie_b5.asm.31152
0042                       copy  "ram.resident.asm"
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
0021 30B6 C13B  30         mov   *r11+,tmp0            ; P0
0022 30B8 C17B  30         mov   *r11+,tmp1            ; P1
0023 30BA C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 30BC 0649  14         dect  stack
0029 30BE C644  30         mov   tmp0,*stack           ; Push tmp0
0030 30C0 0649  14         dect  stack
0031 30C2 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 30C4 0649  14         dect  stack
0033 30C6 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 30C8 0649  14         dect  stack
0035 30CA C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 30CC 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     30CE 6000     
0040 30D0 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 30D2 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     30D4 A226     
0044 30D6 0647  14         dect  tmp3
0045 30D8 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 30DA 0647  14         dect  tmp3
0047 30DC C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 30DE C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     30E0 A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 30E2 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 30E4 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 30E6 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 30E8 0224  22         ai    tmp0,>0800
     30EA 0800     
0066 30EC 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 30EE 0285  22         ci    tmp1,>ffff
     30F0 FFFF     
0075 30F2 1602  14         jne   !
0076 30F4 C160  34         mov   @trmpvector,tmp1
     30F6 A02E     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 30F8 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 30FA 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 30FC 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 30FE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3100 FFCE     
0091 3102 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3104 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 3106 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 3108 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     310A A226     
0102 310C C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 310E 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 3110 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 3112 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 3114 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 3116 028B  22         ci    r11,>6000
     3118 6000     
0115 311A 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 311C 028B  22         ci    r11,>7fff
     311E 7FFF     
0117 3120 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 3122 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     3124 A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 3126 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 3128 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 312A 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 312C 0225  22         ai    tmp1,>0800
     312E 0800     
0137 3130 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 3132 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 3134 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3136 FFCE     
0144 3138 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     313A 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 313C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 313E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 3140 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 3142 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 3144 045B  20         b     *r11                  ; Return to caller
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
0020 3146 0649  14         dect  stack
0021 3148 C64B  30         mov   r11,*stack            ; Save return address
0022 314A 0649  14         dect  stack
0023 314C C644  30         mov   tmp0,*stack           ; Push tmp0
0024 314E 0649  14         dect  stack
0025 3150 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3152 0204  20         li    tmp0,fb.top
     3154 D000     
0030 3156 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3158 A300     
0031 315A 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     315C A304     
0032 315E 04E0  34         clr   @fb.row               ; Current row=0
     3160 A306     
0033 3162 04E0  34         clr   @fb.column            ; Current column=0
     3164 A30C     
0034               
0035 3166 0204  20         li    tmp0,colrow
     3168 0050     
0036 316A C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     316C A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 316E C160  34         mov   @tv.ruler.visible,tmp1
     3170 A210     
0041 3172 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 3174 0204  20         li    tmp0,pane.botrow-2
     3176 001B     
0043 3178 1002  14         jmp   fb.init.cont
0044 317A 0204  20 !       li    tmp0,pane.botrow-1
     317C 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 317E C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     3180 A31A     
0050 3182 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3184 A31C     
0051               
0052 3186 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     3188 A222     
0053 318A 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     318C A310     
0054 318E 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     3190 A316     
0055 3192 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     3194 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 3196 06A0  32         bl    @film
     3198 224A     
0060 319A D000             data  fb.top,>00,fb.size    ; Clear it all the way
     319C 0000     
     319E 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 31A0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 31A2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 31A4 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 31A6 045B  20         b     *r11                  ; Return to caller
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
0051 31A8 0649  14         dect  stack
0052 31AA C64B  30         mov   r11,*stack            ; Save return address
0053 31AC 0649  14         dect  stack
0054 31AE C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 31B0 0204  20         li    tmp0,idx.top
     31B2 B000     
0059 31B4 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     31B6 A502     
0060               
0061 31B8 C120  34         mov   @tv.sams.b000,tmp0
     31BA A206     
0062 31BC C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     31BE A600     
0063 31C0 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     31C2 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 31C4 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     31C6 0004     
0068 31C8 C804  38         mov   tmp0,@idx.sams.hipage ; /
     31CA A604     
0069               
0070 31CC 06A0  32         bl    @_idx.sams.mapcolumn.on
     31CE 31EA     
0071                                                   ; Index in continuous memory region
0072               
0073 31D0 06A0  32         bl    @film
     31D2 224A     
0074 31D4 B000                   data idx.top,>00,idx.size * 5
     31D6 0000     
     31D8 5000     
0075                                                   ; Clear index
0076               
0077 31DA 06A0  32         bl    @_idx.sams.mapcolumn.off
     31DC 321E     
0078                                                   ; Restore memory window layout
0079               
0080 31DE C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     31E0 A602     
     31E2 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 31E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 31E6 C2F9  30         mov   *stack+,r11           ; Pop r11
0088 31E8 045B  20         b     *r11                  ; Return to caller
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
0101 31EA 0649  14         dect  stack
0102 31EC C64B  30         mov   r11,*stack            ; Push return address
0103 31EE 0649  14         dect  stack
0104 31F0 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 31F2 0649  14         dect  stack
0106 31F4 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 31F6 0649  14         dect  stack
0108 31F8 C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 31FA C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     31FC A602     
0113 31FE 0205  20         li    tmp1,idx.top
     3200 B000     
0114 3202 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     3204 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 3206 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     3208 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 320A 0584  14         inc   tmp0                  ; Next SAMS index page
0123 320C 0225  22         ai    tmp1,>1000            ; Next memory region
     320E 1000     
0124 3210 0606  14         dec   tmp2                  ; Update loop counter
0125 3212 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 3214 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 3216 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 3218 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 321A C2F9  30         mov   *stack+,r11           ; Pop return address
0134 321C 045B  20         b     *r11                  ; Return to caller
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
0150 321E 0649  14         dect  stack
0151 3220 C64B  30         mov   r11,*stack            ; Push return address
0152 3222 0649  14         dect  stack
0153 3224 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 3226 0649  14         dect  stack
0155 3228 C645  30         mov   tmp1,*stack           ; Push tmp1
0156 322A 0649  14         dect  stack
0157 322C C646  30         mov   tmp2,*stack           ; Push tmp2
0158 322E 0649  14         dect  stack
0159 3230 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 3232 0205  20         li    tmp1,idx.top
     3234 B000     
0164 3236 0206  20         li    tmp2,5                ; Always 5 pages
     3238 0005     
0165 323A 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     323C A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 323E C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 3240 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3242 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 3244 0225  22         ai    tmp1,>1000            ; Next memory region
     3246 1000     
0176 3248 0606  14         dec   tmp2                  ; Update loop counter
0177 324A 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 324C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 324E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 3250 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 3252 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 3254 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 3256 045B  20         b     *r11                  ; Return to caller
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
0211 3258 0649  14         dect  stack
0212 325A C64B  30         mov   r11,*stack            ; Save return address
0213 325C 0649  14         dect  stack
0214 325E C644  30         mov   tmp0,*stack           ; Push tmp0
0215 3260 0649  14         dect  stack
0216 3262 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 3264 0649  14         dect  stack
0218 3266 C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 3268 C184  18         mov   tmp0,tmp2             ; Line number
0223 326A 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 326C 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     326E 0800     
0225               
0226 3270 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 3272 0A16  56         sla   tmp2,1                ; line number * 2
0231 3274 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     3276 A010     
0232               
0233 3278 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     327A A602     
0234 327C 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     327E A600     
0235               
0236 3280 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 3282 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     3284 A600     
0242 3286 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     3288 A206     
0243 328A C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 328C 0205  20         li    tmp1,>b000            ; Memory window for index page
     328E B000     
0246               
0247 3290 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     3292 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 3294 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     3296 A604     
0254 3298 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 329A C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     329C A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 329E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 32A0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 32A2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 32A4 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 32A6 045B  20         b     *r11                  ; Return to caller
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
0022 32A8 0649  14         dect  stack
0023 32AA C64B  30         mov   r11,*stack            ; Save return address
0024 32AC 0649  14         dect  stack
0025 32AE C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 32B0 06A0  32         bl    @mem.sams.layout      ; Load standard SAMS pages again
     32B2 347E     
0030               
0031 32B4 0204  20         li    tmp0,edb.top          ; \
     32B6 C000     
0032 32B8 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     32BA A500     
0033 32BC C804  38         mov   tmp0,@edb.next_free.ptr
     32BE A508     
0034                                                   ; Set pointer to next free line
0035               
0036 32C0 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     32C2 A50A     
0037               
0038 32C4 0204  20         li    tmp0,1
     32C6 0001     
0039 32C8 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     32CA A504     
0040               
0041 32CC 0720  34         seto  @edb.block.m1         ; Reset block start line
     32CE A50C     
0042 32D0 0720  34         seto  @edb.block.m2         ; Reset block end line
     32D2 A50E     
0043               
0044 32D4 0204  20         li    tmp0,txt.newfile      ; "New file"
     32D6 38D0     
0045 32D8 C804  38         mov   tmp0,@edb.filename.ptr
     32DA A512     
0046               
0047 32DC 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     32DE A440     
0048 32E0 04E0  34         clr   @fh.kilobytes.prev    ; /
     32E2 A45C     
0049               
0050 32E4 0204  20         li    tmp0,txt.filetype.none
     32E6 398C     
0051 32E8 C804  38         mov   tmp0,@edb.filetype.ptr
     32EA A514     
0052               
0053               edb.init.exit:
0054                       ;------------------------------------------------------
0055                       ; Exit
0056                       ;------------------------------------------------------
0057 32EC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 32EE C2F9  30         mov   *stack+,r11           ; Pop r11
0059 32F0 045B  20         b     *r11                  ; Return to caller
0060               
0061               
0062               
0063               
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
0022 32F2 0649  14         dect  stack
0023 32F4 C64B  30         mov   r11,*stack            ; Save return address
0024 32F6 0649  14         dect  stack
0025 32F8 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 32FA 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     32FC E000     
0030 32FE C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     3300 A700     
0031               
0032 3302 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     3304 A702     
0033 3306 0204  20         li    tmp0,4
     3308 0004     
0034 330A C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     330C A706     
0035 330E C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     3310 A708     
0036               
0037 3312 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3314 A716     
0038 3316 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3318 A718     
0039 331A 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     331C A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 331E 06A0  32         bl    @film
     3320 224A     
0044 3322 E000             data  cmdb.top,>00,cmdb.size
     3324 0000     
     3326 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3328 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 332A C2F9  30         mov   *stack+,r11           ; Pop r11
0052 332C 045B  20         b     *r11                  ; Return to caller
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
0022 332E 0649  14         dect  stack
0023 3330 C64B  30         mov   r11,*stack            ; Save return address
0024 3332 0649  14         dect  stack
0025 3334 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3336 0649  14         dect  stack
0027 3338 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 333A 0649  14         dect  stack
0029 333C C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 333E 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3340 A228     
0034 3342 0204  20         li    tmp0,3
     3344 0003     
0035 3346 C804  38         mov   tmp0,@tv.error.rows   ; Number of rows in error pane
     3348 A22A     
0036               
0037 334A 06A0  32         bl    @film
     334C 224A     
0038 334E A22C                   data tv.error.msg,0,160
     3350 0000     
     3352 00A0     
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               errpane.exit:
0043 3354 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 3356 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 3358 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 335A C2F9  30         mov   *stack+,r11           ; Pop R11
0047 335C 045B  20         b     *r11                  ; Return to caller
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
0022 335E 0649  14         dect  stack
0023 3360 C64B  30         mov   r11,*stack            ; Save return address
0024 3362 0649  14         dect  stack
0025 3364 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3366 0649  14         dect  stack
0027 3368 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 336A 0649  14         dect  stack
0029 336C C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 336E 0204  20         li    tmp0,1                ; \ Set default color scheme
     3370 0001     
0034 3372 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3374 A212     
0035               
0036 3376 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3378 A224     
0037 337A E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     337C 200C     
0038               
0039 337E 0204  20         li    tmp0,fj.bottom
     3380 B000     
0040 3382 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     3384 A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 3386 06A0  32         bl    @cpym2m
     3388 24EE     
0045 338A 3A64                   data def.printer.fname,tv.printer.fname,7
     338C D960     
     338E 0007     
0046               
0047 3390 06A0  32         bl    @cpym2m
     3392 24EE     
0048 3394 3A6C                   data def.clip.fname,tv.clip.fname,10
     3396 D9B0     
     3398 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 339A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 339C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 339E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 33A0 C2F9  30         mov   *stack+,r11           ; Pop R11
0057 33A2 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0014                       copy  "tv.utils.asm"           ; General purpose utility functions
     **** ****     > tv.utils.asm
0001               * FILE......: tv.utils.asm
0002               * Purpose...: General purpose utility functions
0003               
0004               ***************************************************************
0005               * tv.quit
0006               * Reset computer to monitor
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
0023 33A4 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     33A6 27C2     
0024                       ;-------------------------------------------------------
0025                       ; Activate bank 0 and exit
0026                       ;-------------------------------------------------------
0027 33A8 04E0  34         clr   @bank0.rom            ; Activate bank 0
     33AA 6000     
0028 33AC 0420  54         blwp  @0                    ; Reset to monitor
     33AE 0000     
0029               
0030               
0031               ***************************************************************
0032               * tv.reset
0033               * Reset editor (clear buffer)
0034               ***************************************************************
0035               * bl @tv.reset
0036               *--------------------------------------------------------------
0037               * INPUT
0038               * none
0039               *--------------------------------------------------------------
0040               * OUTPUT
0041               * none
0042               *--------------------------------------------------------------
0043               * Register usage
0044               * r11
0045               *--------------------------------------------------------------
0046               * Notes
0047               ***************************************************************
0048               tv.reset:
0049 33B0 0649  14         dect  stack
0050 33B2 C64B  30         mov   r11,*stack            ; Save return address
0051                       ;------------------------------------------------------
0052                       ; Reset editor
0053                       ;------------------------------------------------------
0054 33B4 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     33B6 32F2     
0055 33B8 06A0  32         bl    @edb.init             ; Initialize editor buffer
     33BA 32A8     
0056 33BC 06A0  32         bl    @idx.init             ; Initialize index
     33BE 31A8     
0057 33C0 06A0  32         bl    @fb.init              ; Initialize framebuffer
     33C2 3146     
0058 33C4 06A0  32         bl    @errpane.init         ; Initialize error pane
     33C6 332E     
0059                       ;------------------------------------------------------
0060                       ; Remove markers and shortcuts
0061                       ;------------------------------------------------------
0062 33C8 06A0  32         bl    @hchar
     33CA 27EE     
0063 33CC 0034                   byte 0,52,32,18           ; Remove markers
     33CE 2012     
0064 33D0 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     33D2 2033     
0065 33D4 FFFF                   data eol
0066                       ;-------------------------------------------------------
0067                       ; Exit
0068                       ;-------------------------------------------------------
0069               tv.reset.exit:
0070 33D6 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 33D8 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0015                       copy  "tv.unpack.uint16.asm"   ; Unpack 16bit unsigned integer to string
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
0020 33DA 0649  14         dect  stack
0021 33DC C64B  30         mov   r11,*stack            ; Save return address
0022 33DE 0649  14         dect  stack
0023 33E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 33E2 06A0  32         bl    @mknum                ; Convert unsigned number to string
     33E4 2ABC     
0028 33E6 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 33E8 A100                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 33EA 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 33EB   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 33EC 0204  20         li    tmp0,unpacked.string
     33EE A026     
0034 33F0 04F4  30         clr   *tmp0+                ; Clear string 01
0035 33F2 04F4  30         clr   *tmp0+                ; Clear string 23
0036 33F4 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 33F6 06A0  32         bl    @trimnum              ; Trim unsigned number string
     33F8 2B14     
0039 33FA A100                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 33FC A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 33FE 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 3400 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 3402 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 3404 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0016                       copy  "tv.pad.string.asm"      ; Pad string to specified length
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
0024 3406 0649  14         dect  stack
0025 3408 C64B  30         mov   r11,*stack            ; Push return address
0026 340A 0649  14         dect  stack
0027 340C C644  30         mov   tmp0,*stack           ; Push tmp0
0028 340E 0649  14         dect  stack
0029 3410 C645  30         mov   tmp1,*stack           ; Push tmp1
0030 3412 0649  14         dect  stack
0031 3414 C646  30         mov   tmp2,*stack           ; Push tmp2
0032 3416 0649  14         dect  stack
0033 3418 C647  30         mov   tmp3,*stack           ; Push tmp3
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 341A C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     341C A000     
0038 341E D194  26         movb  *tmp0,tmp2            ; /
0039 3420 0986  56         srl   tmp2,8                ; Right align
0040 3422 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0041               
0042 3424 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3426 A002     
0043 3428 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0044                       ;------------------------------------------------------
0045                       ; Copy string to buffer
0046                       ;------------------------------------------------------
0047 342A C120  34         mov   @parm1,tmp0           ; Get source address
     342C A000     
0048 342E C160  34         mov   @parm4,tmp1           ; Get destination address
     3430 A006     
0049 3432 0586  14         inc   tmp2                  ; Also include length-byte in copy
0050               
0051 3434 0649  14         dect  stack
0052 3436 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0053               
0054 3438 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     343A 24F4     
0055                                                   ; \ i  tmp0 = Source CPU memory address
0056                                                   ; | i  tmp1 = Target CPU memory address
0057                                                   ; / i  tmp2 = Number of bytes to copy
0058               
0059 343C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0060                       ;------------------------------------------------------
0061                       ; Set length of new string
0062                       ;------------------------------------------------------
0063 343E C120  34         mov   @parm2,tmp0           ; Get requested length
     3440 A002     
0064 3442 0A84  56         sla   tmp0,8                ; Left align
0065 3444 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3446 A006     
0066 3448 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0067 344A A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0068 344C 0585  14         inc   tmp1                  ; /
0069                       ;------------------------------------------------------
0070                       ; Prepare for padding string
0071                       ;------------------------------------------------------
0072 344E C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     3450 A002     
0073 3452 6187  18         s     tmp3,tmp2             ; |
0074 3454 0586  14         inc   tmp2                  ; /
0075               
0076 3456 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3458 A004     
0077 345A 0A84  56         sla   tmp0,8                ; Left align
0078                       ;------------------------------------------------------
0079                       ; Right-pad string to destination length
0080                       ;------------------------------------------------------
0081               tv.pad.string.loop:
0082 345C DD44  32         movb  tmp0,*tmp1+           ; Pad character
0083 345E 0606  14         dec   tmp2                  ; Update loop counter
0084 3460 15FD  14         jgt   tv.pad.string.loop    ; Next character
0085               
0086 3462 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3464 A006     
     3466 A010     
0087 3468 1004  14         jmp   tv.pad.string.exit    ; Exit
0088                       ;-----------------------------------------------------------------------
0089                       ; CPU crash
0090                       ;-----------------------------------------------------------------------
0091               tv.pad.string.panic:
0092 346A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     346C FFCE     
0093 346E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3470 2026     
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               tv.pad.string.exit:
0098 3472 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0099 3474 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 3476 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 3478 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 347A C2F9  30         mov   *stack+,r11           ; Pop r11
0103 347C 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0017                       copy  "mem.asm"                ; Memory Management (SAMS)
     **** ****     > mem.asm
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
0017 347E 0649  14         dect  stack
0018 3480 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 3482 06A0  32         bl    @sams.layout
     3484 25F6     
0023 3486 3692                   data mem.sams.layout.data
0024               
0025 3488 06A0  32         bl    @sams.layout.copy
     348A 265A     
0026 348C A200                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 348E C820  54         mov   @tv.sams.c000,@edb.sams.page
     3490 A208     
     3492 A516     
0029 3494 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     3496 A516     
     3498 A518     
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 349A C2F9  30         mov   *stack+,r11           ; Pop r11
0036 349C 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0018                       ;-----------------------------------------------------------------------
0019                       ; Logic for Index management
0020                       ;-----------------------------------------------------------------------
0021                       copy  "idx.update.asm"      ; Index management - Update entry
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
0022 349E 0649  14         dect  stack
0023 34A0 C64B  30         mov   r11,*stack            ; Save return address
0024 34A2 0649  14         dect  stack
0025 34A4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 34A6 0649  14         dect  stack
0027 34A8 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 34AA C120  34         mov   @parm1,tmp0           ; Get line number
     34AC A000     
0032 34AE C160  34         mov   @parm2,tmp1           ; Get pointer
     34B0 A002     
0033 34B2 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 34B4 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     34B6 0FFF     
0039 34B8 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 34BA 06E0  34         swpb  @parm3
     34BC A004     
0044 34BE D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     34C0 A004     
0045 34C2 06E0  34         swpb  @parm3                ; \ Restore original order again,
     34C4 A004     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 34C6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     34C8 3258     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 34CA C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     34CC A010     
0056 34CE C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     34D0 B000     
0057 34D2 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     34D4 A010     
0058 34D6 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 34D8 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     34DA 3258     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 34DC C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     34DE A010     
0068 34E0 04E4  34         clr   @idx.top(tmp0)        ; /
     34E2 B000     
0069 34E4 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     34E6 A010     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 34E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 34EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 34EC C2F9  30         mov   *stack+,r11           ; Pop r11
0077 34EE 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0022                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0021 34F0 0649  14         dect  stack
0022 34F2 C64B  30         mov   r11,*stack            ; Save return address
0023 34F4 0649  14         dect  stack
0024 34F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 34F8 0649  14         dect  stack
0026 34FA C645  30         mov   tmp1,*stack           ; Push tmp1
0027 34FC 0649  14         dect  stack
0028 34FE C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 3500 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     3502 A000     
0033               
0034 3504 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     3506 3258     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 3508 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     350A A010     
0039 350C C164  34         mov   @idx.top(tmp0),tmp1   ; /
     350E B000     
0040               
0041 3510 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 3512 C185  18         mov   tmp1,tmp2             ; \
0047 3514 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 3516 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     3518 00FF     
0052 351A 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 351C 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     351E C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 3520 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     3522 A010     
0059 3524 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     3526 A012     
0060 3528 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 352A 04E0  34         clr   @outparm1
     352C A010     
0066 352E 04E0  34         clr   @outparm2
     3530 A012     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 3532 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 3534 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 3536 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 3538 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 353A 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0023                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0017 353C 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     353E B000     
0018 3540 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 3542 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 3544 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 3546 0606  14         dec   tmp2                  ; tmp2--
0026 3548 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 354A 045B  20         b     *r11                  ; Return to caller
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
0046 354C 0649  14         dect  stack
0047 354E C64B  30         mov   r11,*stack            ; Save return address
0048 3550 0649  14         dect  stack
0049 3552 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 3554 0649  14         dect  stack
0051 3556 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 3558 0649  14         dect  stack
0053 355A C646  30         mov   tmp2,*stack           ; Push tmp2
0054 355C 0649  14         dect  stack
0055 355E C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 3560 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     3562 A000     
0060               
0061 3564 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3566 3258     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 3568 C120  34         mov   @outparm1,tmp0        ; Index offset
     356A A010     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 356C C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     356E A002     
0070 3570 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 3572 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3574 A000     
0074 3576 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 3578 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     357A B000     
0081 357C 04D4  26         clr   *tmp0                 ; Clear index entry
0082 357E 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 3580 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     3582 A002     
0088 3584 0287  22         ci    tmp3,2048
     3586 0800     
0089 3588 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 358A 06A0  32         bl    @_idx.sams.mapcolumn.on
     358C 31EA     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 358E C120  34         mov   @parm1,tmp0           ; Restore line number
     3590 A000     
0103 3592 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 3594 06A0  32         bl    @_idx.entry.delete.reorg
     3596 353C     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 3598 06A0  32         bl    @_idx.sams.mapcolumn.off
     359A 321E     
0111                                                   ; Restore memory window layout
0112               
0113 359C 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 359E 06A0  32         bl    @_idx.entry.delete.reorg
     35A0 353C     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 35A2 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 35A4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 35A6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 35A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 35AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 35AC C2F9  30         mov   *stack+,r11           ; Pop r11
0132 35AE 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0024                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0017 35B0 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     35B2 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 35B4 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 35B6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     35B8 FFCE     
0027 35BA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     35BC 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 35BE 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     35C0 B000     
0032 35C2 C144  18         mov   tmp0,tmp1             ; a = current slot
0033 35C4 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 35C6 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 35C8 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 35CA 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 35CC 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 35CE A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 35D0 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     35D2 AFFC     
0043 35D4 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 35D6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     35D8 FFCE     
0049 35DA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     35DC 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 35DE C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 35E0 0644  14         dect  tmp0                  ; Move pointer up
0056 35E2 0645  14         dect  tmp1                  ; Move pointer up
0057 35E4 0606  14         dec   tmp2                  ; Next index entry
0058 35E6 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 35E8 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 35EA 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 35EC 045B  20         b     *r11                  ; Return to caller
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
0088 35EE 0649  14         dect  stack
0089 35F0 C64B  30         mov   r11,*stack            ; Save return address
0090 35F2 0649  14         dect  stack
0091 35F4 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 35F6 0649  14         dect  stack
0093 35F8 C645  30         mov   tmp1,*stack           ; Push tmp1
0094 35FA 0649  14         dect  stack
0095 35FC C646  30         mov   tmp2,*stack           ; Push tmp2
0096 35FE 0649  14         dect  stack
0097 3600 C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 3602 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     3604 A002     
0102 3606 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3608 A000     
0103 360A 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 360C C1E0  34         mov   @parm2,tmp3
     360E A002     
0110 3610 0287  22         ci    tmp3,2048
     3612 0800     
0111 3614 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 3616 06A0  32         bl    @_idx.sams.mapcolumn.on
     3618 31EA     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 361A C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     361C A002     
0123 361E 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 3620 06A0  32         bl    @_idx.entry.insert.reorg
     3622 35B0     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 3624 06A0  32         bl    @_idx.sams.mapcolumn.off
     3626 321E     
0131                                                   ; Restore memory window layout
0132               
0133 3628 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 362A C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     362C A002     
0139               
0140 362E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3630 3258     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 3632 C120  34         mov   @outparm1,tmp0        ; Index offset
     3634 A010     
0145               
0146 3636 06A0  32         bl    @_idx.entry.insert.reorg
     3638 35B0     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 363A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 363C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 363E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 3640 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 3642 C2F9  30         mov   *stack+,r11           ; Pop r11
0160 3644 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0025                       ;-----------------------------------------------------------------------
0026                       ; Utility functions
0027                       ;-----------------------------------------------------------------------
0028                       copy  "pane.topline.clearmsg.asm"
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
0021 3646 0649  14         dect  stack
0022 3648 C64B  30         mov   r11,*stack            ; Push return address
0023 364A 0649  14         dect  stack
0024 364C C660  46         mov   @wyx,*stack           ; Push cursor position
     364E 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 3650 06A0  32         bl    @hchar
     3652 27EE     
0029 3654 0034                   byte 0,52,32,18
     3656 2012     
0030 3658 FFFF                   data EOL              ; Clear message
0031               
0032 365A 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     365C A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 365E C839  50         mov   *stack+,@wyx          ; Pop cursor position
     3660 832A     
0038 3662 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3664 045B  20         b     *r11                  ; Return to task
                   < ram.resident.asm
0029                                                      ; Remove overlay messsage in top line
0030                       ;------------------------------------------------------
0031                       ; Program data
0032                       ;------------------------------------------------------
0033                       copy  "data.constants.asm"     ; Constants
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
0033 3666 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     3668 003F     
     366A 0243     
     366C 05F4     
     366E 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 3670 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     3672 000C     
     3674 0006     
     3676 0007     
     3678 0020     
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
0067 367A 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     367C 000C     
     367E 0006     
     3680 0007     
     3682 0020     
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
0098 3684 0000             data  >0000,>0001           ; Cursor
     3686 0001     
0099 3688 0000             data  >0000,>0101           ; Current line indicator     <
     368A 0101     
0100 368C 0820             data  >0820,>0201           ; Current column indicator   v
     368E 0201     
0101               nosprite:
0102 3690 D000             data  >d000                 ; End-of-Sprites list
0103               
0104               
0105               ***************************************************************
0106               * SAMS page layout table for Stevie (16 words)
0107               *--------------------------------------------------------------
0108               mem.sams.layout.data:
0109 3692 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     3694 0002     
0110 3696 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     3698 0003     
0111 369A A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     369C 000A     
0112 369E B000             data  >b000,>0020           ; >b000-bfff, SAMS page >20
     36A0 0020     
0113                                                   ;   Index can allocate
0114                                                   ;   pages >20 to >3f.
0115 36A2 C000             data  >c000,>0040           ; >c000-cfff, SAMS page >40
     36A4 0040     
0116                                                   ;   Editor buffer can allocate
0117                                                   ;   pages >40 to >ff.
0118 36A6 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     36A8 000D     
0119 36AA E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     36AC 000E     
0120 36AE F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     36B0 000F     
0121               
0122               
0123               ***************************************************************
0124               * SAMS page layout table for calling external progam (16 words)
0125               *--------------------------------------------------------------
0126               mem.sams.external:
0127 36B2 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     36B4 0002     
0128 36B6 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     36B8 0003     
0129 36BA A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     36BC 000A     
0130 36BE B000             data  >b000,>0030           ; >b000-bfff, SAMS page >30
     36C0 0030     
0131 36C2 C000             data  >c000,>0031           ; >c000-cfff, SAMS page >31
     36C4 0031     
0132 36C6 D000             data  >d000,>0032           ; >d000-dfff, SAMS page >32
     36C8 0032     
0133 36CA E000             data  >e000,>0033           ; >e000-efff, SAMS page >33
     36CC 0033     
0134 36CE F000             data  >f000,>0034           ; >f000-ffff, SAMS page >34
     36D0 0034     
0135               
0136               
0137               ***************************************************************
0138               * SAMS page layout table for TI Basic (16 words)
0139               *--------------------------------------------------------------
0140               mem.sams.tibasic:
0141 36D2 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     36D4 0002     
0142 36D6 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     36D8 0003     
0143 36DA A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     36DC 000A     
0144 36DE B000             data  >b000,>0004           ; >b000-bfff, SAMS page >04
     36E0 0004     
0145 36E2 C000             data  >c000,>0005           ; >c000-cfff, SAMS page >05
     36E4 0005     
0146 36E6 D000             data  >d000,>0006           ; >d000-dfff, SAMS page >06
     36E8 0006     
0147 36EA E000             data  >e000,>0007           ; >e000-efff, SAMS page >07
     36EC 0007     
0148 36EE F000             data  >f000,>0008           ; >f000-ffff, SAMS page >08
     36F0 0008     
0149               
0150               
0151               
0152               ***************************************************************
0153               * Stevie color schemes table
0154               *--------------------------------------------------------------
0155               * Word 1
0156               * A  MSB  high-nibble    Foreground color text line in frame buffer
0157               * B  MSB  low-nibble     Background color text line in frame buffer
0158               * C  LSB  high-nibble    Foreground color top/bottom line
0159               * D  LSB  low-nibble     Background color top/bottom line
0160               *
0161               * Word 2
0162               * E  MSB  high-nibble    Foreground color cmdb pane
0163               * F  MSB  low-nibble     Background color cmdb pane
0164               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0165               * H  LSB  low-nibble     Cursor foreground color frame buffer
0166               *
0167               * Word 3
0168               * I  MSB  high-nibble    Foreground color busy top/bottom line
0169               * J  MSB  low-nibble     Background color busy top/bottom line
0170               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0171               * L  LSB  low-nibble     Background color marked line in frame buffer
0172               *
0173               * Word 4
0174               * M  MSB  high-nibble    Foreground color command buffer header line
0175               * N  MSB  low-nibble     Background color command buffer header line
0176               * O  LSB  high-nibble    Foreground color line+column indicator frame buffer
0177               * P  LSB  low-nibble     Foreground color ruler frame buffer
0178               *
0179               * Colors
0180               * 0  Transparant
0181               * 1  black
0182               * 2  Green
0183               * 3  Light Green
0184               * 4  Blue
0185               * 5  Light Blue
0186               * 6  Dark Red
0187               * 7  Cyan
0188               * 8  Red
0189               * 9  Light Red
0190               * A  Yellow
0191               * B  Light Yellow
0192               * C  Dark Green
0193               * D  Magenta
0194               * E  Grey
0195               * F  White
0196               *--------------------------------------------------------------
0197      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0198               
0199               tv.colorscheme.table:
0200                       ;                             ; #
0201                       ;      ABCD  EFGH  IJKL  MNOP ; -
0202 36F2 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     36F4 F171     
     36F6 1B1F     
     36F8 71B1     
0203 36FA A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     36FC F0FF     
     36FE 1F1A     
     3700 F1FF     
0204 3702 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     3704 F0FF     
     3706 1F12     
     3708 F1F6     
0205 370A F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     370C 1E11     
     370E 1A17     
     3710 1E11     
0206 3712 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     3714 E1FF     
     3716 1F1E     
     3718 E1FF     
0207 371A 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     371C 1016     
     371E 1B71     
     3720 1711     
0208 3722 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3724 1011     
     3726 F1F1     
     3728 1F11     
0209 372A 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     372C A1FF     
     372E 1F1F     
     3730 F11F     
0210 3732 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     3734 12FF     
     3736 1B12     
     3738 12FF     
0211 373A F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     373C E1FF     
     373E 1B1F     
     3740 F131     
0212                       even
0213               
0214               tv.tabs.table:
0215 3742 0007             byte  0,7,12,25               ; \   Default tab positions as used
     3744 0C19     
0216 3746 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     3748 3B4F     
0217 374A FF00             byte  >ff,0,0,0               ; |
     374C 0000     
0218 374E 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     3750 0000     
0219 3752 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     3754 0000     
0220                       even
                   < ram.resident.asm
0034                       copy  "data.strings.asm"       ; Strings
     **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               txt.delim
0009 3756 01               byte  1
0010 3757   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 3758 05               byte  5
0015 3759   20             text  '  BOT'
     375A 2042     
     375C 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 375E 03               byte  3
0020 375F   4F             text  'OVR'
     3760 5652     
0021                       even
0022               
0023               txt.insert
0024 3762 03               byte  3
0025 3763   49             text  'INS'
     3764 4E53     
0026                       even
0027               
0028               txt.star
0029 3766 01               byte  1
0030 3767   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 3768 0A               byte  10
0035 3769   4C             text  'Loading...'
     376A 6F61     
     376C 6469     
     376E 6E67     
     3770 2E2E     
     3772 2E       
0036                       even
0037               
0038               txt.saving
0039 3774 0A               byte  10
0040 3775   53             text  'Saving....'
     3776 6176     
     3778 696E     
     377A 672E     
     377C 2E2E     
     377E 2E       
0041                       even
0042               
0043               txt.printing
0044 3780 12               byte  18
0045 3781   50             text  'Printing file.....'
     3782 7269     
     3784 6E74     
     3786 696E     
     3788 6720     
     378A 6669     
     378C 6C65     
     378E 2E2E     
     3790 2E2E     
     3792 2E       
0046                       even
0047               
0048               txt.block.del
0049 3794 12               byte  18
0050 3795   44             text  'Deleting block....'
     3796 656C     
     3798 6574     
     379A 696E     
     379C 6720     
     379E 626C     
     37A0 6F63     
     37A2 6B2E     
     37A4 2E2E     
     37A6 2E       
0051                       even
0052               
0053               txt.block.copy
0054 37A8 11               byte  17
0055 37A9   43             text  'Copying block....'
     37AA 6F70     
     37AC 7969     
     37AE 6E67     
     37B0 2062     
     37B2 6C6F     
     37B4 636B     
     37B6 2E2E     
     37B8 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 37BA 10               byte  16
0060 37BB   4D             text  'Moving block....'
     37BC 6F76     
     37BE 696E     
     37C0 6720     
     37C2 626C     
     37C4 6F63     
     37C6 6B2E     
     37C8 2E2E     
     37CA 2E       
0061                       even
0062               
0063               txt.block.save
0064 37CC 18               byte  24
0065 37CD   53             text  'Saving block to file....'
     37CE 6176     
     37D0 696E     
     37D2 6720     
     37D4 626C     
     37D6 6F63     
     37D8 6B20     
     37DA 746F     
     37DC 2066     
     37DE 696C     
     37E0 652E     
     37E2 2E2E     
     37E4 2E       
0066                       even
0067               
0068               txt.block.clip
0069 37E6 18               byte  24
0070 37E7   43             text  'Copying to clipboard....'
     37E8 6F70     
     37EA 7969     
     37EC 6E67     
     37EE 2074     
     37F0 6F20     
     37F2 636C     
     37F4 6970     
     37F6 626F     
     37F8 6172     
     37FA 642E     
     37FC 2E2E     
     37FE 2E       
0071                       even
0072               
0073               txt.block.print
0074 3800 12               byte  18
0075 3801   50             text  'Printing block....'
     3802 7269     
     3804 6E74     
     3806 696E     
     3808 6720     
     380A 626C     
     380C 6F63     
     380E 6B2E     
     3810 2E2E     
     3812 2E       
0076                       even
0077               
0078               txt.clearmem
0079 3814 13               byte  19
0080 3815   43             text  'Clearing memory....'
     3816 6C65     
     3818 6172     
     381A 696E     
     381C 6720     
     381E 6D65     
     3820 6D6F     
     3822 7279     
     3824 2E2E     
     3826 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 3828 0E               byte  14
0085 3829   4C             text  'Load completed'
     382A 6F61     
     382C 6420     
     382E 636F     
     3830 6D70     
     3832 6C65     
     3834 7465     
     3836 64       
0086                       even
0087               
0088               txt.done.insert
0089 3838 10               byte  16
0090 3839   49             text  'Insert completed'
     383A 6E73     
     383C 6572     
     383E 7420     
     3840 636F     
     3842 6D70     
     3844 6C65     
     3846 7465     
     3848 64       
0091                       even
0092               
0093               txt.done.append
0094 384A 10               byte  16
0095 384B   41             text  'Append completed'
     384C 7070     
     384E 656E     
     3850 6420     
     3852 636F     
     3854 6D70     
     3856 6C65     
     3858 7465     
     385A 64       
0096                       even
0097               
0098               txt.done.save
0099 385C 0E               byte  14
0100 385D   53             text  'Save completed'
     385E 6176     
     3860 6520     
     3862 636F     
     3864 6D70     
     3866 6C65     
     3868 7465     
     386A 64       
0101                       even
0102               
0103               txt.done.copy
0104 386C 0E               byte  14
0105 386D   43             text  'Copy completed'
     386E 6F70     
     3870 7920     
     3872 636F     
     3874 6D70     
     3876 6C65     
     3878 7465     
     387A 64       
0106                       even
0107               
0108               txt.done.print
0109 387C 0F               byte  15
0110 387D   50             text  'Print completed'
     387E 7269     
     3880 6E74     
     3882 2063     
     3884 6F6D     
     3886 706C     
     3888 6574     
     388A 6564     
0111                       even
0112               
0113               txt.done.delete
0114 388C 10               byte  16
0115 388D   44             text  'Delete completed'
     388E 656C     
     3890 6574     
     3892 6520     
     3894 636F     
     3896 6D70     
     3898 6C65     
     389A 7465     
     389C 64       
0116                       even
0117               
0118               txt.done.clipboard
0119 389E 0F               byte  15
0120 389F   43             text  'Clipboard saved'
     38A0 6C69     
     38A2 7062     
     38A4 6F61     
     38A6 7264     
     38A8 2073     
     38AA 6176     
     38AC 6564     
0121                       even
0122               
0123               txt.done.clipdev
0124 38AE 0D               byte  13
0125 38AF   43             text  'Clipboard set'
     38B0 6C69     
     38B2 7062     
     38B4 6F61     
     38B6 7264     
     38B8 2073     
     38BA 6574     
0126                       even
0127               
0128               txt.fastmode
0129 38BC 08               byte  8
0130 38BD   46             text  'Fastmode'
     38BE 6173     
     38C0 746D     
     38C2 6F64     
     38C4 65       
0131                       even
0132               
0133               txt.kb
0134 38C6 02               byte  2
0135 38C7   6B             text  'kb'
     38C8 62       
0136                       even
0137               
0138               txt.lines
0139 38CA 05               byte  5
0140 38CB   4C             text  'Lines'
     38CC 696E     
     38CE 6573     
0141                       even
0142               
0143               txt.newfile
0144 38D0 0A               byte  10
0145 38D1   5B             text  '[New file]'
     38D2 4E65     
     38D4 7720     
     38D6 6669     
     38D8 6C65     
     38DA 5D       
0146                       even
0147               
0148               txt.filetype.dv80
0149 38DC 04               byte  4
0150 38DD   44             text  'DV80'
     38DE 5638     
     38E0 30       
0151                       even
0152               
0153               txt.m1
0154 38E2 03               byte  3
0155 38E3   4D             text  'M1='
     38E4 313D     
0156                       even
0157               
0158               txt.m2
0159 38E6 03               byte  3
0160 38E7   4D             text  'M2='
     38E8 323D     
0161                       even
0162               
0163               txt.keys.default
0164 38EA 07               byte  7
0165 38EB   46             text  'F9-Menu'
     38EC 392D     
     38EE 4D65     
     38F0 6E75     
0166                       even
0167               
0168               txt.keys.block
0169 38F2 36               byte  54
0170 38F3   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     38F4 392D     
     38F6 4261     
     38F8 636B     
     38FA 2020     
     38FC 5E43     
     38FE 6F70     
     3900 7920     
     3902 205E     
     3904 4D6F     
     3906 7665     
     3908 2020     
     390A 5E44     
     390C 656C     
     390E 2020     
     3910 5E53     
     3912 6176     
     3914 6520     
     3916 205E     
     3918 5072     
     391A 696E     
     391C 7420     
     391E 205E     
     3920 5B31     
     3922 2D35     
     3924 5D43     
     3926 6C69     
     3928 70       
0171                       even
0172               
0173 392A 2E2E     txt.ruler          text    '.........'
     392C 2E2E     
     392E 2E2E     
     3930 2E2E     
     3932 2E       
0174 3933   12                        byte    18
0175 3934 2E2E                        text    '.........'
     3936 2E2E     
     3938 2E2E     
     393A 2E2E     
     393C 2E       
0176 393D   13                        byte    19
0177 393E 2E2E                        text    '.........'
     3940 2E2E     
     3942 2E2E     
     3944 2E2E     
     3946 2E       
0178 3947   14                        byte    20
0179 3948 2E2E                        text    '.........'
     394A 2E2E     
     394C 2E2E     
     394E 2E2E     
     3950 2E       
0180 3951   15                        byte    21
0181 3952 2E2E                        text    '.........'
     3954 2E2E     
     3956 2E2E     
     3958 2E2E     
     395A 2E       
0182 395B   16                        byte    22
0183 395C 2E2E                        text    '.........'
     395E 2E2E     
     3960 2E2E     
     3962 2E2E     
     3964 2E       
0184 3965   17                        byte    23
0185 3966 2E2E                        text    '.........'
     3968 2E2E     
     396A 2E2E     
     396C 2E2E     
     396E 2E       
0186 396F   18                        byte    24
0187 3970 2E2E                        text    '.........'
     3972 2E2E     
     3974 2E2E     
     3976 2E2E     
     3978 2E       
0188 3979   19                        byte    25
0189                                  even
0190 397A 020E     txt.alpha.down     data >020e,>0f00
     397C 0F00     
0191 397E 0110     txt.vertline       data >0110
0192 3980 011C     txt.keymarker      byte 1,28
0193               
0194               txt.ws1
0195 3982 01               byte  1
0196 3983   20             text  ' '
0197                       even
0198               
0199               txt.ws2
0200 3984 02               byte  2
0201 3985   20             text  '  '
     3986 20       
0202                       even
0203               
0204               txt.ws3
0205 3988 03               byte  3
0206 3989   20             text  '   '
     398A 2020     
0207                       even
0208               
0209               txt.ws4
0210 398C 04               byte  4
0211 398D   20             text  '    '
     398E 2020     
     3990 20       
0212                       even
0213               
0214               txt.ws5
0215 3992 05               byte  5
0216 3993   20             text  '     '
     3994 2020     
     3996 2020     
0217                       even
0218               
0219      398C     txt.filetype.none  equ txt.ws4
0220               
0221               
0222               ;--------------------------------------------------------------
0223               ; Strings for error line pane
0224               ;--------------------------------------------------------------
0225               txt.ioerr.load
0226 3998 15               byte  21
0227 3999   46             text  'Failed loading file: '
     399A 6169     
     399C 6C65     
     399E 6420     
     39A0 6C6F     
     39A2 6164     
     39A4 696E     
     39A6 6720     
     39A8 6669     
     39AA 6C65     
     39AC 3A20     
0228                       even
0229               
0230               txt.ioerr.save
0231 39AE 14               byte  20
0232 39AF   46             text  'Failed saving file: '
     39B0 6169     
     39B2 6C65     
     39B4 6420     
     39B6 7361     
     39B8 7669     
     39BA 6E67     
     39BC 2066     
     39BE 696C     
     39C0 653A     
     39C2 20       
0233                       even
0234               
0235               txt.ioerr.print
0236 39C4 1B               byte  27
0237 39C5   46             text  'Failed printing to device: '
     39C6 6169     
     39C8 6C65     
     39CA 6420     
     39CC 7072     
     39CE 696E     
     39D0 7469     
     39D2 6E67     
     39D4 2074     
     39D6 6F20     
     39D8 6465     
     39DA 7669     
     39DC 6365     
     39DE 3A20     
0238                       even
0239               
0240               txt.io.nofile
0241 39E0 16               byte  22
0242 39E1   4E             text  'No filename specified.'
     39E2 6F20     
     39E4 6669     
     39E6 6C65     
     39E8 6E61     
     39EA 6D65     
     39EC 2073     
     39EE 7065     
     39F0 6369     
     39F2 6669     
     39F4 6564     
     39F6 2E       
0243                       even
0244               
0245               txt.memfull.load
0246 39F8 2D               byte  45
0247 39F9   49             text  'Index full. File too large for editor buffer.'
     39FA 6E64     
     39FC 6578     
     39FE 2066     
     3A00 756C     
     3A02 6C2E     
     3A04 2046     
     3A06 696C     
     3A08 6520     
     3A0A 746F     
     3A0C 6F20     
     3A0E 6C61     
     3A10 7267     
     3A12 6520     
     3A14 666F     
     3A16 7220     
     3A18 6564     
     3A1A 6974     
     3A1C 6F72     
     3A1E 2062     
     3A20 7566     
     3A22 6665     
     3A24 722E     
0248                       even
0249               
0250               txt.block.inside
0251 3A26 2D               byte  45
0252 3A27   43             text  'Copy/Move target must be outside M1-M2 range.'
     3A28 6F70     
     3A2A 792F     
     3A2C 4D6F     
     3A2E 7665     
     3A30 2074     
     3A32 6172     
     3A34 6765     
     3A36 7420     
     3A38 6D75     
     3A3A 7374     
     3A3C 2062     
     3A3E 6520     
     3A40 6F75     
     3A42 7473     
     3A44 6964     
     3A46 6520     
     3A48 4D31     
     3A4A 2D4D     
     3A4C 3220     
     3A4E 7261     
     3A50 6E67     
     3A52 652E     
0253                       even
0254               
0255               
0256               ;--------------------------------------------------------------
0257               ; Strings for command buffer
0258               ;--------------------------------------------------------------
0259               txt.cmdb.prompt
0260 3A54 01               byte  1
0261 3A55   3E             text  '>'
0262                       even
0263               
0264               txt.colorscheme
0265 3A56 0D               byte  13
0266 3A57   43             text  'Color scheme:'
     3A58 6F6C     
     3A5A 6F72     
     3A5C 2073     
     3A5E 6368     
     3A60 656D     
     3A62 653A     
0267                       even
0268               
                   < ram.resident.asm
0035                       copy  "data.defaults.asm"      ; Default values (devices, ...)
     **** ****     > data.defaults.asm
0001               * FILE......: data.defaults.asm
0002               * Purpose...: Stevie Editor - data segment (default values)
0003               
0004               ***************************************************************
0005               *                     Default values
0006               ********|*****|*********************|**************************
0007               def.printer.fname
0008 3A64 06               byte  6
0009 3A65   50             text  'PI.PIO'
     3A66 492E     
     3A68 5049     
     3A6A 4F       
0010                       even
0011               
0012               def.clip.fname
0013 3A6C 09               byte  9
0014 3A6D   44             text  'DSK1.CLIP'
     3A6E 534B     
     3A70 312E     
     3A72 434C     
     3A74 4950     
0015                       even
0016               
0017               def.clip.fname.b
0018 3A76 09               byte  9
0019 3A77   44             text  'DSK8.CLIP'
     3A78 534B     
     3A7A 382E     
     3A7C 434C     
     3A7E 4950     
0020                       even
0021               
0022               def.clip.fname.c
0023 3A80 10               byte  16
0024 3A81   54             text  'TIPI.STEVIE.CLIP'
     3A82 4950     
     3A84 492E     
     3A86 5354     
     3A88 4556     
     3A8A 4945     
     3A8C 2E43     
     3A8E 4C49     
     3A90 50       
0025                       even
0026               
0027               def.devices
0028 3A92 2F               byte  47
0029 3A93   2C             text  ',DSK,HDX,IDE,PI.,PIO,TIPI.,RD,SCS,SDD,WDS,RS232'
     3A94 4453     
     3A96 4B2C     
     3A98 4844     
     3A9A 582C     
     3A9C 4944     
     3A9E 452C     
     3AA0 5049     
     3AA2 2E2C     
     3AA4 5049     
     3AA6 4F2C     
     3AA8 5449     
     3AAA 5049     
     3AAC 2E2C     
     3AAE 5244     
     3AB0 2C53     
     3AB2 4353     
     3AB4 2C53     
     3AB6 4444     
     3AB8 2C57     
     3ABA 4453     
     3ABC 2C52     
     3ABE 5332     
     3AC0 3332     
0030                       even
0031               
                   < ram.resident.asm
                   < stevie_b5.asm.31152
0043                       ;------------------------------------------------------
0044                       ; Activate bank 1 and branch to  >6036
0045                       ;------------------------------------------------------
0046 3AC2 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3AC4 6002     
0047               
0051               
0052 3AC6 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3AC8 6046     
0053               ***************************************************************
0054               * Step 3: Include main editor modules
0055               ********|*****|*********************|**************************
0056               main:
0057                       aorg  kickstart.code2       ; >6046
0058 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 2026     
0059                       ;-----------------------------------------------------------------------
0060                       ; Logic for Editor Buffer (2)
0061                       ;-----------------------------------------------------------------------
0062                       copy  "edb.clear.sams.asm"  ; Clear SAMS pages of editor buffer
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
                   < stevie_b5.asm.31152
0063                       copy  "edb.hipage.alloc.asm"; Allocate SAMS page for editor buffer
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
                   < stevie_b5.asm.31152
0064                       copy  "edb.block.mark.asm"  ; Mark code block
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
0020 60D6 0649  14         dect  stack
0021 60D8 C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 60DA C820  54         mov   @fb.row,@parm1
     60DC A306     
     60DE A000     
0026 60E0 06A0  32         bl    @fb.row2line          ; Row to editor line
     60E2 62F0     
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 60E4 05A0  34         inc   @outparm1             ; Add base 1
     60E6 A010     
0032               
0033 60E8 C820  54         mov   @outparm1,@edb.block.m1
     60EA A010     
     60EC A50C     
0034                                                   ; Set block marker M1
0035 60EE 0720  34         seto  @fb.colorize          ; Set colorize flag
     60F0 A310     
0036 60F2 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     60F4 A316     
0037 60F6 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     60F8 A318     
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 60FA C2F9  30         mov   *stack+,r11           ; Pop r11
0043 60FC 045B  20         b     *r11                  ; Return to caller
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
0062 60FE 0649  14         dect  stack
0063 6100 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 6102 C820  54         mov   @fb.row,@parm1
     6104 A306     
     6106 A000     
0068 6108 06A0  32         bl    @fb.row2line          ; Row to editor line
     610A 62F0     
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 610C 05A0  34         inc   @outparm1             ; Add base 1
     610E A010     
0074               
0075 6110 C820  54         mov   @outparm1,@edb.block.m2
     6112 A010     
     6114 A50E     
0076                                                   ; Set block marker M2
0077               
0078 6116 0720  34         seto  @fb.colorize          ; Set colorize flag
     6118 A310     
0079 611A 0720  34         seto  @fb.dirty             ; Trigger refresh
     611C A316     
0080 611E 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6120 A318     
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 6122 C2F9  30         mov   *stack+,r11           ; Pop r11
0086 6124 045B  20         b     *r11                  ; Return to caller
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
0107 6126 0649  14         dect  stack
0108 6128 C64B  30         mov   r11,*stack            ; Push return address
0109 612A 0649  14         dect  stack
0110 612C C644  30         mov   tmp0,*stack           ; Push tmp0
0111 612E 0649  14         dect  stack
0112 6130 C645  30         mov   tmp1,*stack           ; Push tmp1
0113                       ;------------------------------------------------------
0114                       ; Get current line position in editor buffer
0115                       ;------------------------------------------------------
0116 6132 C820  54         mov   @fb.row,@parm1
     6134 A306     
     6136 A000     
0117 6138 06A0  32         bl    @fb.row2line          ; Row to editor line
     613A 62F0     
0118                                                   ; \ i @fb.topline = Top line in frame buffer
0119                                                   ; | i @parm1      = Row in frame buffer
0120                                                   ; / o @outparm1   = Matching line in EB
0121               
0122 613C C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     613E A010     
0123 6140 0585  14         inc   tmp1                  ; Add base 1
0124                       ;------------------------------------------------------
0125                       ; Check if M1 and M2 must be set
0126                       ;------------------------------------------------------
0127 6142 C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     6144 A50C     
0128 6146 0584  14         inc   tmp0                  ; /
0129 6148 1608  14         jne   edb.block.mark.is_line_m1
0130                                                   ; No, skip to update M1
0131                       ;------------------------------------------------------
0132                       ; Set M1 and M2 and exit
0133                       ;------------------------------------------------------
0134 614A 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     614C 60D6     
0135 614E 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     6150 60FE     
0136 6152 1008  14         jmp   edb.block.mark.exit
0137                       ;------------------------------------------------------
0138                       ; Set M1 and exit
0139                       ;------------------------------------------------------
0140               _edb.block.mark.m1.set:
0141 6154 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     6156 60D6     
0142 6158 1005  14         jmp   edb.block.mark.exit
0143                       ;------------------------------------------------------
0144                       ; Update M1 if current line < M1
0145                       ;------------------------------------------------------
0146               edb.block.mark.is_line_m1:
0147 615A 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     615C A50C     
0148 615E 15FA  14         jgt   _edb.block.mark.m1.set
0149                                                   ; Set M1 to current line and exit
0150                       ;------------------------------------------------------
0151                       ; Set M2 and exit
0152                       ;------------------------------------------------------
0153 6160 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     6162 60FE     
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               edb.block.mark.exit:
0158 6164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0159 6166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 6168 C2F9  30         mov   *stack+,r11           ; Pop r11
0161 616A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.31152
0065                       copy  "edb.block.clip.asm"  ; Save code block to clipboard
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
0026 616C 0649  14         dect  stack
0027 616E C64B  30         mov   r11,*stack            ; Save return address
0028 6170 0649  14         dect  stack
0029 6172 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 6174 0649  14         dect  stack
0031 6176 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 6178 0649  14         dect  stack
0033 617A C646  30         mov   tmp2,*stack           ; Push tmp2
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 617C 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     617E A50C     
     6180 2022     
0038 6182 132F  14         jeq   edb.block.clip.exit   ; Yes, exit early
0039               
0040 6184 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6186 A50E     
     6188 2022     
0041 618A 132B  14         jeq   edb.block.clip.exit   ; Yes, exit early
0042               
0043 618C 8820  54         c     @edb.block.m1,@edb.block.m2
     618E A50C     
     6190 A50E     
0044                                                   ; M1 > M2 ?
0045 6192 1527  14         jgt   edb.block.clip.exit   ; Yes, exit early
0046                       ;------------------------------------------------------
0047                       ; Generate clipboard device/file name
0048                       ;------------------------------------------------------
0049 6194 06A0  32         bl    @cpym2m
     6196 24EE     
0050 6198 D9B0                   data tv.clip.fname,heap.top,80
     619A F000     
     619C 0050     
0051               
0052 619E C120  34         mov   @parm1,tmp0           ; Check if suffix necessary
     61A0 A000     
0053 61A2 130D  14         jeq   edb.block.clip.save   ; No suffix, skip to save
0054                       ;------------------------------------------------------
0055                       ; Append suffix character to clipboard device/filename
0056                       ;------------------------------------------------------
0057 61A4 C120  34         mov   @tv.clip.fname,tmp0
     61A6 D9B0     
0058 61A8 C144  18         mov   tmp0,tmp1
0059 61AA 0984  56         srl   tmp0,8                ; Get string length
0060 61AC 0224  22         ai    tmp0,heap.top         ; Add base
     61AE F000     
0061 61B0 0584  14         inc   tmp0                  ; Consider length-prefix byte
0062 61B2 D520  46         movb  @parm1,*tmp0          ; Append suffix
     61B4 A000     
0063               
0064 61B6 0225  22         ai    tmp1,>0100            ; \ Update clipboard string length
     61B8 0100     
0065 61BA D805  38         movb  tmp1,@heap.top        ; /
     61BC F000     
0066                       ;------------------------------------------------------
0067                       ; Save code block M1-M2 to clipboard
0068                       ;------------------------------------------------------
0069               edb.block.clip.save:
0070 61BE 0204  20         li    tmp0,heap.top         ; \ Set pointer to clipboard filename
     61C0 F000     
0071 61C2 C804  38         mov   tmp0,@parm1           ; /
     61C4 A000     
0072               
0073 61C6 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     61C8 A50C     
     61CA A002     
0074 61CC 0620  34         dec   @parm2                ; /
     61CE A002     
0075               
0076 61D0 C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     61D2 A50E     
     61D4 A004     
0077               
0078 61D6 0204  20         li    tmp0,id.file.clipblock
     61D8 0006     
0079 61DA C804  38         mov   tmp0,@parm4           ; Save block to clipboard
     61DC A006     
0080               
0081 61DE 06A0  32         bl    @fm.savefile          ; Save DV80 file
     61E0 6302     
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
0092 61E2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0093 61E4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0094 61E6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0095 61E8 C2F9  30         mov   *stack+,r11           ; Pop R11
0096 61EA 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.31152
0066                       copy  "edb.block.reset.asm" ; Reset markers
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
0017 61EC 0649  14         dect  stack
0018 61EE C64B  30         mov   r11,*stack            ; Push return address
0019 61F0 0649  14         dect  stack
0020 61F2 C660  46         mov   @wyx,*stack           ; Push cursor position
     61F4 832A     
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 61F6 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     61F8 A50C     
0025 61FA 0720  34         seto  @edb.block.m2         ; /
     61FC A50E     
0026               
0027 61FE 0720  34         seto  @fb.colorize          ; Set colorize flag
     6200 A310     
0028 6202 0720  34         seto  @fb.dirty             ; Trigger refresh
     6204 A316     
0029 6206 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6208 A318     
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 620A 0720  34         seto  @parm1                ; Do not turn screen off while
     620C A000     
0034                                                   ; reloading color scheme
0035               
0036 620E 04E0  34         clr   @parm2                ; Don't skip colorizing marked lines
     6210 A002     
0037 6212 04E0  34         clr   @parm3                ; Colorize all panes
     6214 A004     
0038               
0039 6216 06A0  32         bl    @pane.action.colorscheme.load
     6218 6314     
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
0051 621A C820  54         mov   @tv.color,@parm1      ; Set normal color
     621C A218     
     621E A000     
0052 6220 06A0  32         bl    @pane.action.colorscheme.statlines
     6222 6326     
0053                                                   ; Set color combination for status lines
0054                                                   ; \ i  @parm1 = Color combination
0055                                                   ; /
0056               
0057 6224 06A0  32         bl    @hchar
     6226 27EE     
0058 6228 0034                   byte 0,52,32,18           ; Remove markers
     622A 2012     
0059 622C 1D00                   byte pane.botrow,0,32,55  ; Remove block shortcuts
     622E 2037     
0060 6230 FFFF                   data eol
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               edb.block.reset.exit:
0065 6232 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     6234 832A     
0066 6236 C2F9  30         mov   *stack+,r11           ; Pop r11
0067 6238 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.31152
0067                       copy  "edb.block.del.asm"   ; Delete code block
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
0030 623A 0649  14         dect  stack
0031 623C C64B  30         mov   r11,*stack            ; Save return address
0032 623E 0649  14         dect  stack
0033 6240 C644  30         mov   tmp0,*stack           ; Push tmp0
0034 6242 0649  14         dect  stack
0035 6244 C645  30         mov   tmp1,*stack           ; Push tmp1
0036 6246 0649  14         dect  stack
0037 6248 C646  30         mov   tmp2,*stack           ; Push tmp2
0038               
0039 624A 04E0  34         clr   @outparm1             ; No action (>0000)
     624C A010     
0040                       ;------------------------------------------------------
0041                       ; Asserts
0042                       ;------------------------------------------------------
0043 624E C120  34         mov   @edb.block.m1,tmp0    ; \
     6250 A50C     
0044 6252 0584  14         inc   tmp0                  ; | M1 unset?
0045 6254 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0046               
0047 6256 C160  34         mov   @edb.block.m2,tmp1    ; \
     6258 A50E     
0048 625A 0584  14         inc   tmp0                  ; | M2 unset?
0049 625C 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Check message to display
0052                       ;------------------------------------------------------
0053 625E C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     6260 A000     
0054 6262 160E  14         jne   edb.block.delete.prep ; No, skip message display
0055                       ;------------------------------------------------------
0056                       ; Display "Deleting...."
0057                       ;------------------------------------------------------
0058 6264 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     6266 A21C     
     6268 A000     
0059               
0060 626A 06A0  32         bl    @pane.action.colorscheme.statlines
     626C 6326     
0061                                                   ; Set color combination for status lines
0062                                                   ; \ i  @parm1 = Color combination
0063                                                   ; /
0064               
0065 626E 06A0  32         bl    @hchar
     6270 27EE     
0066 6272 1D00                   byte pane.botrow,0,32,55
     6274 2037     
0067 6276 FFFF                   data eol              ; Remove markers and block shortcuts
0068               
0069 6278 06A0  32         bl    @putat
     627A 2456     
0070 627C 1D00                   byte pane.botrow,0
0071 627E 3794                   data txt.block.del    ; Display "Deleting block...."
0072                       ;------------------------------------------------------
0073                       ; Prepare for delete
0074                       ;------------------------------------------------------
0075               edb.block.delete.prep:
0076 6280 C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     6282 A50C     
0077 6284 0604  14         dec   tmp0                  ; Base 0
0078               
0079 6286 C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     6288 A50E     
0080 628A 0605  14         dec   tmp1                  ; Base 0
0081               
0082 628C C804  38         mov   tmp0,@parm1           ; Delete line on M1
     628E A000     
0083 6290 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6292 A504     
     6294 A002     
0084 6296 0620  34         dec   @parm2                ; Base 0
     6298 A002     
0085               
0086 629A C185  18         mov   tmp1,tmp2             ; \
0087 629C 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0088 629E 0586  14         inc   tmp2                  ; /
0089                       ;------------------------------------------------------
0090                       ; Delete block
0091                       ;------------------------------------------------------
0092               edb.block.delete.loop:
0093 62A0 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     62A2 354C     
0094                                                   ; \ i  @parm1 = Line in editor buffer
0095                                                   ; / i  @parm2 = Last line for index reorg
0096               
0097 62A4 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     62A6 A504     
0098 62A8 0620  34         dec   @parm2                ; /
     62AA A002     
0099               
0100 62AC 0606  14         dec   tmp2
0101 62AE 15F8  14         jgt   edb.block.delete.loop ; Next line
0102 62B0 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     62B2 A506     
0103                       ;------------------------------------------------------
0104                       ; Set topline for framebuffer refresh
0105                       ;------------------------------------------------------
0106 62B4 8820  54         c     @fb.topline,@edb.lines
     62B6 A304     
     62B8 A504     
0107                                                   ; Beyond editor buffer?
0108 62BA 1504  14         jgt   !                     ; Yes, goto line 1
0109               
0110 62BC C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     62BE A304     
     62C0 A000     
0111 62C2 1002  14         jmp   edb.block.delete.fb.refresh
0112 62C4 04E0  34 !       clr   @parm1                ; Set line to start with
     62C6 A000     
0113                       ;------------------------------------------------------
0114                       ; Refresh framebuffer and reset block markers
0115                       ;------------------------------------------------------
0116               edb.block.delete.fb.refresh:
0117 62C8 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     62CA 62DE     
0118                                                   ; | i  @parm1 = Line to start with
0119                                                   ; /             (becomes @fb.topline)
0120               
0121 62CC 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     62CE 61EC     
0122               
0123 62D0 0720  34         seto  @outparm1             ; Delete completed
     62D2 A010     
0124                       ;------------------------------------------------------
0125                       ; Exit
0126                       ;------------------------------------------------------
0127               edb.block.delete.exit:
0128 62D4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 62D6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 62D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 62DA C2F9  30         mov   *stack+,r11           ; Pop R11
0132 62DC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.31152
0068                       ;-----------------------------------------------------------------------
0069                       ; Stubs
0070                       ;-----------------------------------------------------------------------
0071                       copy  "rom.stubs.bank5.asm" ; Stubs for functions in other banks
     **** ****     > rom.stubs.bank5.asm
0001               * FILE......: rom.stubs.bank5.asm
0002               * Purpose...: Bank 5 stubs for functions in other banks
0003               
0004               
0005               
0006               ***************************************************************
0007               * Stub for "fb.refresh"
0008               * bank1 vec.20
0009               ********|*****|*********************|**************************
0010               fb.refresh:
0011 62DE 0649  14         dect  stack
0012 62E0 C64B  30         mov   r11,*stack            ; Save return address
0013                       ;------------------------------------------------------
0014                       ; Call function in bank 1
0015                       ;------------------------------------------------------
0016 62E2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     62E4 30B6     
0017 62E6 6002                   data bank1.rom        ; | i  p0 = bank address
0018 62E8 7FE6                   data vec.20           ; | i  p1 = Vector with target address
0019 62EA 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0020                       ;------------------------------------------------------
0021                       ; Exit
0022                       ;------------------------------------------------------
0023 62EC C2F9  30         mov   *stack+,r11           ; Pop r11
0024 62EE 045B  20         b     *r11                  ; Return to caller
0025               
0026               
0027               ***************************************************************
0028               * Stub for "fb.row2line"
0029               * bank1 vec.22
0030               ********|*****|*********************|**************************
0031               fb.row2line:
0032 62F0 0649  14         dect  stack
0033 62F2 C64B  30         mov   r11,*stack            ; Save return address
0034                       ;------------------------------------------------------
0035                       ; Call function in bank 1
0036                       ;------------------------------------------------------
0037 62F4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     62F6 30B6     
0038 62F8 6002                   data bank1.rom        ; | i  p0 = bank address
0039 62FA 7FEA                   data vec.22           ; | i  p1 = Vector with target address
0040 62FC 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044 62FE C2F9  30         mov   *stack+,r11           ; Pop r11
0045 6300 045B  20         b     *r11                  ; Return to caller
0046               
0047               
0048               ***************************************************************
0049               * Stub for "fm.savefile"
0050               * bank2 vec.4
0051               ********|*****|*********************|**************************
0052               fm.savefile:
0053 6302 0649  14         dect  stack
0054 6304 C64B  30         mov   r11,*stack            ; Save return address
0055                       ;------------------------------------------------------
0056                       ; Call function in bank 2
0057                       ;------------------------------------------------------
0058 6306 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6308 30B6     
0059 630A 6004                   data bank2.rom        ; | i  p0 = bank address
0060 630C 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0061 630E 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065 6310 C2F9  30         mov   *stack+,r11           ; Pop r11
0066 6312 045B  20         b     *r11                  ; Return to caller
0067               
0068               
0069               ***************************************************************
0070               * Stub for "pane.action.colorscheme.load"
0071               * bank1 vec.31
0072               ********|*****|*********************|**************************
0073               pane.action.colorscheme.load
0074 6314 0649  14         dect  stack
0075 6316 C64B  30         mov   r11,*stack            ; Save return address
0076                       ;------------------------------------------------------
0077                       ; Call function in bank 1
0078                       ;------------------------------------------------------
0079 6318 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     631A 30B6     
0080 631C 6002                   data bank1.rom        ; | i  p0 = bank address
0081 631E 7FFC                   data vec.31           ; | i  p1 = Vector with target address
0082 6320 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0083                       ;------------------------------------------------------
0084                       ; Exit
0085                       ;------------------------------------------------------
0086 6322 C2F9  30         mov   *stack+,r11           ; Pop r11
0087 6324 045B  20         b     *r11                  ; Return to caller
0088               
0089               
0090               ***************************************************************
0091               * Stub for "pane.action.colorscheme.statuslines"
0092               * bank1 vec.32
0093               ********|*****|*********************|**************************
0094               pane.action.colorscheme.statlines
0095 6326 0649  14         dect  stack
0096 6328 C64B  30         mov   r11,*stack            ; Save return address
0097                       ;------------------------------------------------------
0098                       ; Call function in bank 1
0099                       ;------------------------------------------------------
0100 632A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     632C 30B6     
0101 632E 6002                   data bank1.rom        ; | i  p0 = bank address
0102 6330 7FFE                   data vec.32           ; | i  p1 = Vector with target address
0103 6332 600A                   data bankid           ; / i  p2 = Source ROM bank for return
0104                       ;------------------------------------------------------
0105                       ; Exit
0106                       ;------------------------------------------------------
0107 6334 C2F9  30         mov   *stack+,r11           ; Pop r11
0108 6336 045B  20         b     *r11                  ; Return to caller
                   < stevie_b5.asm.31152
0072                       ;-----------------------------------------------------------------------
0073                       ; Program data
0074                       ;-----------------------------------------------------------------------
0075                       ; Not applicable
0076                       ;-----------------------------------------------------------------------
0077                       ; Bank full check
0078                       ;-----------------------------------------------------------------------
0082                       ;-----------------------------------------------------------------------
0083                       ; Show ROM bank in CPU crash screen
0084                       ;-----------------------------------------------------------------------
0085               cpu.crash.showbank:
0086                       aorg >7fb0
0087 7FB0 06A0  32         bl    @putat
     7FB2 2456     
0088 7FB4 0314                   byte 3,20
0089 7FB6 7FBA                   data cpu.crash.showbank.bankstr
0090 7FB8 10FF  14         jmp   $
0091               cpu.crash.showbank.bankstr:
0092               
0093 7FBA 05               byte  5
0094 7FBB   52             text  'ROM#5'
     7FBC 4F4D     
     7FBE 2335     
0095                       even
0096               
0097                       ;-----------------------------------------------------------------------
0098                       ; Vector table
0099                       ;-----------------------------------------------------------------------
0100                       aorg  >7fc0
0101                       copy  "rom.vectors.bank5.asm"
     **** ****     > rom.vectors.bank5.asm
0001               * FILE......: rom.vectors.bank5.asm
0002               * Purpose...: Bank 5 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 604A     vec.1   data  edb.clear.sams        ;
0008 7FC2 6090     vec.2   data  edb.hipage.alloc      ;
0009 7FC4 6126     vec.3   data  edb.block.mark        ;
0010 7FC6 60D6     vec.4   data  edb.block.mark.m1     ;
0011 7FC8 60FE     vec.5   data  edb.block.mark.m2     ;
0012 7FCA 616C     vec.6   data  edb.block.clip        ;
0013 7FCC 61EC     vec.7   data  edb.block.reset       ;
0014 7FCE 623A     vec.8   data  edb.block.delete      ;
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
                   < stevie_b5.asm.31152
0102                                                   ; Vector table bank 5
0103               
0104               *--------------------------------------------------------------
0105               * Video mode configuration
0106               *--------------------------------------------------------------
0107      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0108      0004     spfbck  equ   >04                   ; Screen background color.
0109      3666     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0110      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0111      0050     colrow  equ   80                    ; Columns per row
0112      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0113      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0114      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0115      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

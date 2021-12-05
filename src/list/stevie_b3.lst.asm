XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b3.asm.61108
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b3.asm               ; Version 211205-1903310
0010               *
0011               * Bank 3 "John"
0012               * Dialogs & Command Buffer pane
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
                   < stevie_b3.asm.61108
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
                   < stevie_b3.asm.61108
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
0087      000E     id.dialog.print           equ  14      ; "Print file"
0088      000F     id.dialog.printblock      equ  15      ; "Print block"
0089      0010     id.dialog.clipdev         equ  16      ; "Configure clipboard device"
0090               ;-----------------------------------------------------------------
0091               ;   Dialog ID's >= 100 indicate that command prompt should be
0092               ;   hidden and no characters added to CMDB keyboard buffer.
0093               ;-----------------------------------------------------------------
0094      0064     id.dialog.menu            equ  100     ; "Main Menu"
0095      0065     id.dialog.unsaved         equ  101     ; "Unsaved changes"
0096      0066     id.dialog.block           equ  102     ; "Block move/copy/delete/print/..."
0097      0067     id.dialog.clipboard       equ  103     ; "Copy clipboard to line ..."
0098      0068     id.dialog.help            equ  104     ; "About"
0099      0069     id.dialog.file            equ  105     ; "File"
0100      006A     id.dialog.basic           equ  106     ; "Basic"
0101      006B     id.dialog.config          equ  107     ; "Configure"
0102               *--------------------------------------------------------------
0103               * Stevie specific equates
0104               *--------------------------------------------------------------
0105      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0106      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0107      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0108      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0109      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0110      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0111                                                      ; VDP TAT address of 1st CMDB row
0112      0000     vdp.sit.base              equ  >0000   ; VDP SIT base address
0113      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0114                                                      ; VDP SIT size 80 columns, 24/30 rows
0115      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0116      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0117               *--------------------------------------------------------------
0118               * Suffix characters for clipboards
0119               *--------------------------------------------------------------
0120      3100     clip1                     equ  >3100   ; '1'
0121      3200     clip2                     equ  >3200   ; '2'
0122      3300     clip3                     equ  >3300   ; '3'
0123      3400     clip4                     equ  >3400   ; '4'
0124      3500     clip5                     equ  >3500   ; '5'
0125               *--------------------------------------------------------------
0126               * File work mode
0127               *--------------------------------------------------------------
0128      0001     id.file.loadfile          equ  1       ; Load file
0129      0002     id.file.loadblock         equ  2       ; Insert block from file
0130      0003     id.file.savefile          equ  3       ; Save file
0131      0004     id.file.saveblock         equ  4       ; Save block to file
0132      0005     id.file.clipblock         equ  5       ; Save block to clipboard
0133      0006     id.file.printfile         equ  6       ; Print file
0134      0007     id.file.printblock        equ  7       ; Print block
0135               *--------------------------------------------------------------
0136               * SPECTRA2 / Stevie startup options
0137               *--------------------------------------------------------------
0138      0001     debug                     equ  1       ; Turn on spectra2 debugging
0139      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0140      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0141      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0142               
0143      7E00     cpu.scrpad.src            equ  >7e00   ; \ Dump of OS monitor scratchpad
0144                                                      ; | stored in cartridge ROM
0145                                                      ; / bank3.asm
0146               
0147      F960     cpu.scrpad.tgt            equ  >f960   ; \ Destination for copy of TI Basic
0148                                                      ; | scratchpad RAM (SAMS bank #08)
0149                                                      ; /
0150               
0151               
0152               *--------------------------------------------------------------
0153               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0154               *--------------------------------------------------------------
0155      A000     core1.top         equ  >a000           ; Structure begin
0156      A000     parm1             equ  core1.top + 0   ; Function parameter 1
0157      A002     parm2             equ  core1.top + 2   ; Function parameter 2
0158      A004     parm3             equ  core1.top + 4   ; Function parameter 3
0159      A006     parm4             equ  core1.top + 6   ; Function parameter 4
0160      A008     parm5             equ  core1.top + 8   ; Function parameter 5
0161      A00A     parm6             equ  core1.top + 10  ; Function parameter 6
0162      A00C     parm7             equ  core1.top + 12  ; Function parameter 7
0163      A00E     parm8             equ  core1.top + 14  ; Function parameter 8
0164      A010     outparm1          equ  core1.top + 16  ; Function output parameter 1
0165      A012     outparm2          equ  core1.top + 18  ; Function output parameter 2
0166      A014     outparm3          equ  core1.top + 20  ; Function output parameter 3
0167      A016     outparm4          equ  core1.top + 22  ; Function output parameter 4
0168      A018     outparm5          equ  core1.top + 24  ; Function output parameter 5
0169      A01A     outparm6          equ  core1.top + 26  ; Function output parameter 6
0170      A01C     outparm7          equ  core1.top + 28  ; Function output parameter 7
0171      A01E     outparm8          equ  core1.top + 30  ; Function output parameter 8
0172      A020     keyrptcnt         equ  core1.top + 32  ; Key repeat-count (auto-repeat function)
0173      A022     keycode1          equ  core1.top + 34  ; Current key scanned
0174      A024     keycode2          equ  core1.top + 36  ; Previous key scanned
0175      A026     unpacked.string   equ  core1.top + 38  ; 6 char string with unpacked uin16
0176      A02C     tibasic.status    equ  core1.top + 44  ; TI Basic status flags
0177                                                      ; 0000 = Initialize TI-Basic
0178                                                      ; 0001 = TI-Basic reentry
0179      A02E     trmpvector        equ  core1.top + 46  ; Vector trampoline (if p1|tmp1 = >ffff)
0180      A030     core1.free        equ  core1.top + 48  ; End of structure
0181               *--------------------------------------------------------------
0182               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0183               *--------------------------------------------------------------
0184      A100     core2.top         equ  >a100           ; Structure begin
0185      A100     timers            equ  core2.top       ; Timer table
0186      A140     rambuf            equ  core2.top + 64  ; RAM workbuffer (160 bytes)
0187      A1E0     ramsat            equ  core2.top + 224 ; Sprite Attr. Table in RAM (14 bytes)
0188      A1EE     core2.free        equ  core2.top + 238 ; End of structure
0189               *--------------------------------------------------------------
0190               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0191               *--------------------------------------------------------------
0192      A200     tv.top            equ  >a200           ; Structure begin
0193      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0194      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0195      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0196      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0197      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0198      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0199      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0200      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0201      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0202      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0203      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0204      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0205      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0206      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0207      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0208      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0209      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0210      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0211      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0212      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0213      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0214      A22A     tv.error.rows     equ  tv.top + 42     ; Number of rows in error pane
0215      A22C     tv.error.msg      equ  tv.top + 44     ; Error message (max. 160 characters)
0216      A2CC     tv.free           equ  tv.top + 204    ; End of structure
0217               *--------------------------------------------------------------
0218               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0219               *--------------------------------------------------------------
0220      A300     fb.struct         equ  >a300           ; Structure begin
0221      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0222      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0223      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0224                                                      ; line X in editor buffer).
0225      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0226                                                      ; (offset 0 .. @fb.scrrows)
0227      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0228      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0229      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0230      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0231      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0232      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0233      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0234      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0235      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0236      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0237      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0238      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0239      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0240      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0241               *--------------------------------------------------------------
0242               * File handle structure               @>a400-a4ff   (256 bytes)
0243               *--------------------------------------------------------------
0244      A400     fh.struct         equ  >a400           ; stevie file handling structures
0245               ;***********************************************************************
0246               ; ATTENTION
0247               ; The dsrlnk variables must form a continuous memory block and keep
0248               ; their order!
0249               ;***********************************************************************
0250      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0251      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0252      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0253      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0254      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0255      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0256      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0257      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0258      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0259      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0260      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0261      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0262      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0263      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0264      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0265      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0266      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0267      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0268      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0269      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0270      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0271      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0272      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0273      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0274      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0275      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0276      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0277      A45A     fh.workmode       equ  fh.struct + 90  ; Working mode (used in callbacks)
0278      A45C     fh.kilobytes.prev equ  fh.struct + 92  ; Kilobytes processed (previous)
0279      A45E     fh.line           equ  fh.struct + 94  ; Editor buffer line currently processing
0280      A460     fh.temp1          equ  fh.struct + 96  ; Temporary variable 1
0281      A462     fh.temp2          equ  fh.struct + 98  ; Temporary variable 2
0282      A464     fh.temp3          equ  fh.struct +100  ; Temporary variable 3
0283      A466     fh.membuffer      equ  fh.struct +102  ; 80 bytes file memory buffer
0284      A4B6     fh.free           equ  fh.struct +182  ; End of structure
0285      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0286      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0287               *--------------------------------------------------------------
0288               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0289               *--------------------------------------------------------------
0290      A500     edb.struct        equ  >a500           ; Begin structure
0291      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0292      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0293      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0294      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0295      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0296      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0297      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0298      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0299      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0300      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0301                                                      ; with current filename.
0302      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0303                                                      ; with current file type.
0304      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0305      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0306      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0307                                                      ; for filename, but not always used.
0308      A56A     edb.free          equ  edb.struct + 106; End of structure
0309               *--------------------------------------------------------------
0310               * Index structure                     @>a600-a6ff   (256 bytes)
0311               *--------------------------------------------------------------
0312      A600     idx.struct        equ  >a600           ; stevie index structure
0313      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0314      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0315      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0316      A606     idx.free          equ  idx.struct + 6  ; End of structure
0317               *--------------------------------------------------------------
0318               * Command buffer structure            @>a700-a7ff   (256 bytes)
0319               *--------------------------------------------------------------
0320      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0321      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0322      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0323      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0324      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0325      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0326      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0327      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0328      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0329      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0330      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0331      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0332      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0333      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0334      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0335      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0336      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0337      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0338      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0339      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0340      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0341      A728     cmdb.cmdall       equ  cmdb.struct + 40; Current command including length-byte
0342      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0343      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0344      A77A     cmdb.panhead.buf  equ  cmdb.struct +122; String buffer for pane header
0345      A7C8     cmdb.free         equ  cmdb.struct +200; End of structure
0346               *--------------------------------------------------------------
0347               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0348               *--------------------------------------------------------------
0349      AD00     scrpad.copy       equ  >ad00           ; Copy of Stevie scratchpad memory
0350               *--------------------------------------------------------------
0351               * Farjump return stack                @>af00-afff   (256 bytes)
0352               *--------------------------------------------------------------
0353      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0354                                                      ; Grows downwards from high to low.
0355               *--------------------------------------------------------------
0356               * Index                               @>b000-bfff  (4096 bytes)
0357               *--------------------------------------------------------------
0358      B000     idx.top           equ  >b000           ; Top of index
0359      1000     idx.size          equ  4096            ; Index size
0360               *--------------------------------------------------------------
0361               * Editor buffer                       @>c000-cfff  (4096 bytes)
0362               *--------------------------------------------------------------
0363      C000     edb.top           equ  >c000           ; Editor buffer high memory
0364      1000     edb.size          equ  4096            ; Editor buffer size
0365               *--------------------------------------------------------------
0366               * Frame buffer & Default devices      @>d000-dfff  (4096 bytes)
0367               *--------------------------------------------------------------
0368      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0369      0960     fb.size           equ  80*30           ; Frame buffer size
0370      D960     tv.printer.fname  equ  >d960           ; Default printer   (80 char)
0371      D9B0     tv.clip.fname     equ  >d9b0           ; Default clipboard (80 char)
0372               *--------------------------------------------------------------
0373               * Command buffer history              @>e000-efff  (4096 bytes)
0374               *--------------------------------------------------------------
0375      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0376      1000     cmdb.size         equ  4096            ; Command buffer size
0377               *--------------------------------------------------------------
0378               * Heap                                @>f000-ffff  (4096 bytes)
0379               *--------------------------------------------------------------
0380      F000     heap.top          equ  >f000           ; Top of heap
                   < stevie_b3.asm.61108
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
                   < stevie_b3.asm.61108
0018               
0019               ***************************************************************
0020               * Spectra2 core configuration
0021               ********|*****|*********************|**************************
0022      AF00     sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
0023                                                   ; grows from high to low.
0024               ***************************************************************
0025               * BANK 3
0026               ********|*****|*********************|**************************
0027      6006     bankid  equ   bank3.rom             ; Set bank identifier to current bank
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
0045 6011   53             text  'STEVIE 1.2H'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3248     
0046                       even
0047               
0049               
                   < stevie_b3.asm.61108
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
     2084 2FEA     
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
     20B2 2AA0     
0096 20B4 0015                   byte 0,21             ; \ i  p0 = YX position
0097 20B6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0098 20B8 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
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
     20C6 2AA0     
0108 20C8 0115                   byte 1,21             ; \ i  p0 = YX position
0109 20CA FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0110 20CC A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
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
     2116 2AAA     
0158 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0159 211A A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
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
     212A A140     
0169               
0170 212C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     212E 2432     
0171 2130 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
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
     214A 2AAA     
0186 214C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0187 214E A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0188 2150 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0189                                                   ; /         LSB offset for ASCII digit 0-9
0190                       ;------------------------------------------------------
0191                       ; Display crash register content
0192                       ;------------------------------------------------------
0193               cpu.crash.showreg.content:
0194 2152 06A0  32         bl    @mkhex                ; Convert hex word to string
     2154 2A1C     
0195 2156 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0196 2158 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
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
     2174 A140     
0213               
0214 2176 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2178 2432     
0215 217A A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
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
0265 21D1   53             text  'Source    stevie_b3.lst.asm'
     21D2 6F75     
     21D4 7263     
     21D6 6520     
     21D8 2020     
     21DA 2073     
     21DC 7465     
     21DE 7669     
     21E0 655F     
     21E2 6233     
     21E4 2E6C     
     21E6 7374     
     21E8 2E61     
     21EA 736D     
0266                       even
0267               
0268               cpu.crash.msg.id
0269 21EC 18               byte  24
0270 21ED   42             text  'Build-ID  211205-1903310'
     21EE 7569     
     21F0 6C64     
     21F2 2D49     
     21F4 4420     
     21F6 2032     
     21F8 3131     
     21FA 3230     
     21FC 352D     
     21FE 3139     
     2200 3033     
     2202 3331     
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
0035               * f18chk - Check if F18A VDP present
0036               ***************************************************************
0037               *  bl   @f18chk
0038               *--------------------------------------------------------------
0039               *  REMARKS
0040               *  Expects that the f18a is unlocked when calling this function.
0041               *  Runs GPU code at VDP >3f00
0042               ********|*****|*********************|**************************
0043 2766 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 2768 06A0  32         bl    @cpym2v
     276A 249A     
0045 276C 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     276E 27AA     
     2770 0006     
0046 2772 06A0  32         bl    @putvr
     2774 2346     
0047 2776 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 2778 06A0  32         bl    @putvr
     277A 2346     
0049 277C 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 277E 0204  20         li    tmp0,>3f00
     2780 3F00     
0055 2782 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     2784 22CE     
0056 2786 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2788 8800     
0057 278A 0984  56         srl   tmp0,8
0058 278C D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     278E 8800     
0059 2790 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 2792 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 2794 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2796 BFFF     
0063 2798 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 279A 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     279C 4000     
0066               f18chk_exit:
0067 279E 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     27A0 22A2     
0068 27A2 3F00             data  >3f00,>00,6
     27A4 0000     
     27A6 0006     
0069 27A8 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 27AA 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 27AC 3F00             data  >3f00                 ; 3f02 / 3f00
0076 27AE 0340             data  >0340                 ; 3f04   0340  idle
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
0097 27B0 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 27B2 06A0  32         bl    @putvr
     27B4 2346     
0102 27B6 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 27B8 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     27BA 2346     
0105 27BC 3900             data  >3900                 ; Lock the F18a
0106 27BE 0458  20         b     *tmp4                 ; Exit
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
0125 27C0 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 27C2 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27C4 201E     
0127 27C6 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 27C8 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27CA 8802     
0132 27CC 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27CE 2346     
0133 27D0 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 27D2 04C4  14         clr   tmp0
0135 27D4 D120  34         movb  @vdps,tmp0
     27D6 8802     
0136 27D8 0984  56         srl   tmp0,8
0137 27DA 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 27DC C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27DE 832A     
0018 27E0 D17B  28         movb  *r11+,tmp1
0019 27E2 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27E4 D1BB  28         movb  *r11+,tmp2
0021 27E6 0986  56         srl   tmp2,8                ; Repeat count
0022 27E8 C1CB  18         mov   r11,tmp3
0023 27EA 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27EC 240E     
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27EE 020B  20         li    r11,hchar1
     27F0 27F6     
0028 27F2 0460  28         b     @xfilv                ; Draw
     27F4 22A8     
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27F6 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27F8 2022     
0033 27FA 1302  14         jeq   hchar2                ; Yes, exit
0034 27FC C2C7  18         mov   tmp3,r11
0035 27FE 10EE  14         jmp   hchar                 ; Next one
0036 2800 05C7  14 hchar2  inct  tmp3
0037 2802 0457  20         b     *tmp3                 ; Exit
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
0014 2804 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     2806 8334     
0015 2808 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     280A 2006     
0016 280C 0204  20         li    tmp0,muttab
     280E 281E     
0017 2810 0205  20         li    tmp1,sound            ; Sound generator port >8400
     2812 8400     
0018 2814 D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 2816 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 2818 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 281A D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 281C 045B  20         b     *r11
0023 281E 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     2820 DFFF     
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
0043 2822 C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     2824 8334     
0044 2826 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     2828 8336     
0045 282A 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     282C FFF8     
0046 282E E0BB  30         soc   *r11+,config          ; Set options
0047 2830 D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     2832 2012     
     2834 831B     
0048 2836 045B  20         b     *r11
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
0059 2838 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     283A 2006     
0060 283C 1301  14         jeq   sdpla1                ; Yes, play
0061 283E 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 2840 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 2842 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     2844 831B     
     2846 2000     
0067 2848 1301  14         jeq   sdpla3                ; Play next note
0068 284A 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 284C 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     284E 2002     
0070 2850 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 2852 C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     2854 8336     
0075 2856 06C4  14         swpb  tmp0
0076 2858 D804  38         movb  tmp0,@vdpa
     285A 8C02     
0077 285C 06C4  14         swpb  tmp0
0078 285E D804  38         movb  tmp0,@vdpa
     2860 8C02     
0079 2862 04C4  14         clr   tmp0
0080 2864 D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     2866 8800     
0081 2868 131E  14         jeq   sdexit                ; Yes. exit
0082 286A 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 286C A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     286E 8336     
0084 2870 D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     2872 8800     
     2874 8400     
0085 2876 0604  14         dec   tmp0
0086 2878 16FB  14         jne   vdpla2
0087 287A D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     287C 8800     
     287E 831B     
0088 2880 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     2882 8336     
0089 2884 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 2886 C120  34 mmplay  mov   @wsdtmp,tmp0
     2888 8336     
0094 288A D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 288C 130C  14         jeq   sdexit                ; Yes, exit
0096 288E 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 2890 A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     2892 8336     
0098 2894 D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     2896 8400     
0099 2898 0605  14         dec   tmp1
0100 289A 16FC  14         jne   mmpla2
0101 289C D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     289E 831B     
0102 28A0 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     28A2 8336     
0103 28A4 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 28A6 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     28A8 2004     
0108 28AA 1607  14         jne   sdexi2                ; No, exit
0109 28AC C820  54         mov   @wsdlst,@wsdtmp
     28AE 8334     
     28B0 8336     
0110 28B2 D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     28B4 2012     
     28B6 831B     
0111 28B8 045B  20 sdexi1  b     *r11                  ; Exit
0112 28BA 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     28BC FFF8     
0113 28BE 045B  20         b     *r11                  ; Exit
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
0016 28C0 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     28C2 2020     
0017 28C4 020C  20         li    r12,>0024
     28C6 0024     
0018 28C8 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     28CA 295C     
0019 28CC 04C6  14         clr   tmp2
0020 28CE 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 28D0 04CC  14         clr   r12
0025 28D2 1F08  20         tb    >0008                 ; Shift-key ?
0026 28D4 1302  14         jeq   realk1                ; No
0027 28D6 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     28D8 298C     
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 28DA 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 28DC 1302  14         jeq   realk2                ; No
0033 28DE 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     28E0 29BC     
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 28E2 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 28E4 1302  14         jeq   realk3                ; No
0039 28E6 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     28E8 29EC     
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 28EA 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     28EC 200C     
0044 28EE 1E15  20         sbz   >0015                 ; Set P5
0045 28F0 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 28F2 1302  14         jeq   realk4                ; No
0047 28F4 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     28F6 200C     
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 28F8 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 28FA 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     28FC 0006     
0053 28FE 0606  14 realk5  dec   tmp2
0054 2900 020C  20         li    r12,>24               ; CRU address for P2-P4
     2902 0024     
0055 2904 06C6  14         swpb  tmp2
0056 2906 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2908 06C6  14         swpb  tmp2
0058 290A 020C  20         li    r12,6                 ; CRU read address
     290C 0006     
0059 290E 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 2910 0547  14         inv   tmp3                  ;
0061 2912 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2914 FF00     
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2916 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2918 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 291A 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 291C 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 291E 0285  22         ci    tmp1,8
     2920 0008     
0070 2922 1AFA  14         jl    realk6
0071 2924 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2926 1BEB  14         jh    realk5                ; No, next column
0073 2928 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 292A C206  18 realk8  mov   tmp2,tmp4
0078 292C 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 292E A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 2930 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2932 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2934 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2936 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2938 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     293A 200C     
0089 293C 1608  14         jne   realka                ; No, continue saving key
0090 293E 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2940 2986     
0091 2942 1A05  14         jl    realka
0092 2944 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2946 2984     
0093 2948 1B02  14         jh    realka                ; No, continue
0094 294A 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     294C E000     
0095 294E C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2950 833C     
0096 2952 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2954 200A     
0097 2956 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2958 8C00     
0098                                                   ; / using R15 as temp storage
0099 295A 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 295C FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     295E 0000     
     2960 FF0D     
     2962 203D     
0102 2964 7877             text  'xws29ol.'
     2966 7332     
     2968 396F     
     296A 6C2E     
0103 296C 6365             text  'ced38ik,'
     296E 6433     
     2970 3869     
     2972 6B2C     
0104 2974 7672             text  'vrf47ujm'
     2976 6634     
     2978 3775     
     297A 6A6D     
0105 297C 6274             text  'btg56yhn'
     297E 6735     
     2980 3679     
     2982 686E     
0106 2984 7A71             text  'zqa10p;/'
     2986 6131     
     2988 3070     
     298A 3B2F     
0107 298C FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     298E 0000     
     2990 FF0D     
     2992 202B     
0108 2994 5857             text  'XWS@(OL>'
     2996 5340     
     2998 284F     
     299A 4C3E     
0109 299C 4345             text  'CED#*IK<'
     299E 4423     
     29A0 2A49     
     29A2 4B3C     
0110 29A4 5652             text  'VRF$&UJM'
     29A6 4624     
     29A8 2655     
     29AA 4A4D     
0111 29AC 4254             text  'BTG%^YHN'
     29AE 4725     
     29B0 5E59     
     29B2 484E     
0112 29B4 5A51             text  'ZQA!)P:-'
     29B6 4121     
     29B8 2950     
     29BA 3A2D     
0113 29BC FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     29BE 0000     
     29C0 FF0D     
     29C2 2005     
0114 29C4 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     29C6 0804     
     29C8 0F27     
     29CA C2B9     
0115 29CC 600B             data  >600b,>0907,>063f,>c1B8
     29CE 0907     
     29D0 063F     
     29D2 C1B8     
0116 29D4 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     29D6 7B02     
     29D8 015F     
     29DA C0C3     
0117 29DC BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     29DE 7D0E     
     29E0 0CC6     
     29E2 BFC4     
0118 29E4 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     29E6 7C03     
     29E8 BC22     
     29EA BDBA     
0119 29EC FF00     kbctrl  data  >ff00,>0000,>ff0d,>f09D
     29EE 0000     
     29F0 FF0D     
     29F2 F09D     
0120 29F4 9897             data  >9897,>93b2,>9f8f,>8c9B
     29F6 93B2     
     29F8 9F8F     
     29FA 8C9B     
0121 29FC 8385             data  >8385,>84b3,>9e89,>8b80
     29FE 84B3     
     2A00 9E89     
     2A02 8B80     
0122 2A04 9692             data  >9692,>86b4,>b795,>8a8D
     2A06 86B4     
     2A08 B795     
     2A0A 8A8D     
0123 2A0C 8294             data  >8294,>87b5,>b698,>888E
     2A0E 87B5     
     2A10 B698     
     2A12 888E     
0124 2A14 9A91             data  >9a91,>81b1,>b090,>9cBB
     2A16 81B1     
     2A18 B090     
     2A1A 9CBB     
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
0023 2A1C C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2A1E C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2A20 8340     
0025 2A22 04E0  34         clr   @waux1
     2A24 833C     
0026 2A26 04E0  34         clr   @waux2
     2A28 833E     
0027 2A2A 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2A2C 833C     
0028 2A2E C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2A30 0205  20         li    tmp1,4                ; 4 nibbles
     2A32 0004     
0033 2A34 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2A36 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2A38 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2A3A 0286  22         ci    tmp2,>000a
     2A3C 000A     
0039 2A3E 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2A40 C21B  26         mov   *r11,tmp4
0045 2A42 0988  56         srl   tmp4,8                ; Right justify
0046 2A44 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2A46 FFF6     
0047 2A48 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2A4A C21B  26         mov   *r11,tmp4
0054 2A4C 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2A4E 00FF     
0055               
0056 2A50 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2A52 06C6  14         swpb  tmp2
0058 2A54 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2A56 0944  56         srl   tmp0,4                ; Next nibble
0060 2A58 0605  14         dec   tmp1
0061 2A5A 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2A5C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2A5E BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2A60 C160  34         mov   @waux3,tmp1           ; Get pointer
     2A62 8340     
0067 2A64 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2A66 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2A68 C120  34         mov   @waux2,tmp0
     2A6A 833E     
0070 2A6C 06C4  14         swpb  tmp0
0071 2A6E DD44  32         movb  tmp0,*tmp1+
0072 2A70 06C4  14         swpb  tmp0
0073 2A72 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2A74 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2A76 8340     
0078 2A78 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2A7A 2016     
0079 2A7C 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2A7E C120  34         mov   @waux1,tmp0
     2A80 833C     
0084 2A82 06C4  14         swpb  tmp0
0085 2A84 DD44  32         movb  tmp0,*tmp1+
0086 2A86 06C4  14         swpb  tmp0
0087 2A88 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2A8A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A8C 2020     
0092 2A8E 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2A90 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2A92 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2A94 7FFF     
0098 2A96 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2A98 8340     
0099 2A9A 0460  28         b     @xutst0               ; Display string
     2A9C 2434     
0100 2A9E 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2AA0 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2AA2 832A     
0122 2AA4 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2AA6 8000     
0123 2AA8 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 2AAA 0207  20 mknum   li    tmp3,5                ; Digit counter
     2AAC 0005     
0020 2AAE C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 2AB0 C155  26         mov   *tmp1,tmp1            ; /
0022 2AB2 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 2AB4 0228  22         ai    tmp4,4                ; Get end of buffer
     2AB6 0004     
0024 2AB8 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     2ABA 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 2ABC 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 2ABE 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 2AC0 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 2AC2 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 2AC4 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 2AC6 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 2AC8 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 2ACA 0607  14         dec   tmp3                  ; Decrease counter
0036 2ACC 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 2ACE 0207  20         li    tmp3,4                ; Check first 4 digits
     2AD0 0004     
0041 2AD2 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2AD4 C11B  26         mov   *r11,tmp0
0043 2AD6 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2AD8 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2ADA 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2ADC 05CB  14 mknum3  inct  r11
0047 2ADE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2AE0 2020     
0048 2AE2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2AE4 045B  20         b     *r11                  ; Exit
0050 2AE6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2AE8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2AEA 13F8  14         jeq   mknum3                ; Yes, exit
0053 2AEC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2AEE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2AF0 7FFF     
0058 2AF2 C10B  18         mov   r11,tmp0
0059 2AF4 0224  22         ai    tmp0,-4
     2AF6 FFFC     
0060 2AF8 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2AFA 0206  20         li    tmp2,>0500            ; String length = 5
     2AFC 0500     
0062 2AFE 0460  28         b     @xutstr               ; Display string
     2B00 2436     
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
0093 2B02 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2B04 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2B06 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2B08 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2B0A 0207  20         li    tmp3,5                ; Set counter
     2B0C 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2B0E 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2B10 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2B12 0584  14         inc   tmp0                  ; Next character
0105 2B14 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2B16 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2B18 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2B1A 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2B1C DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2B1E 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2B20 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2B22 0607  14         dec   tmp3                  ; Last character ?
0121 2B24 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2B26 045B  20         b     *r11                  ; Return
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
0139 2B28 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2B2A 832A     
0140 2B2C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2B2E 8000     
0141 2B30 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2B32 0649  14         dect  stack
0023 2B34 C64B  30         mov   r11,*stack            ; Save return address
0024 2B36 0649  14         dect  stack
0025 2B38 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2B3A 0649  14         dect  stack
0027 2B3C C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2B3E 0649  14         dect  stack
0029 2B40 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2B42 0649  14         dect  stack
0031 2B44 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2B46 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2B48 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2B4A C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2B4C 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2B4E 0649  14         dect  stack
0044 2B50 C64B  30         mov   r11,*stack            ; Save return address
0045 2B52 0649  14         dect  stack
0046 2B54 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2B56 0649  14         dect  stack
0048 2B58 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2B5A 0649  14         dect  stack
0050 2B5C C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2B5E 0649  14         dect  stack
0052 2B60 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2B62 C1D4  26 !       mov   *tmp0,tmp3
0057 2B64 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2B66 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2B68 00FF     
0059 2B6A 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2B6C 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2B6E 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2B70 0584  14         inc   tmp0                  ; Next byte
0067 2B72 0607  14         dec   tmp3                  ; Shorten string length
0068 2B74 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2B76 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2B78 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2B7A C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2B7C 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2B7E C187  18         mov   tmp3,tmp2
0078 2B80 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2B82 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2B84 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2B86 24F4     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2B88 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2B8A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B8C FFCE     
0090 2B8E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B90 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2B92 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2B94 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2B96 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2B98 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2B9A C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2B9C 045B  20         b     *r11                  ; Return to caller
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
0123 2B9E 0649  14         dect  stack
0124 2BA0 C64B  30         mov   r11,*stack            ; Save return address
0125 2BA2 05D9  26         inct  *stack                ; Skip "data P0"
0126 2BA4 05D9  26         inct  *stack                ; Skip "data P1"
0127 2BA6 0649  14         dect  stack
0128 2BA8 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2BAA 0649  14         dect  stack
0130 2BAC C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2BAE 0649  14         dect  stack
0132 2BB0 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2BB2 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2BB4 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2BB6 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2BB8 0649  14         dect  stack
0144 2BBA C64B  30         mov   r11,*stack            ; Save return address
0145 2BBC 0649  14         dect  stack
0146 2BBE C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2BC0 0649  14         dect  stack
0148 2BC2 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2BC4 0649  14         dect  stack
0150 2BC6 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2BC8 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2BCA 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2BCC 0586  14         inc   tmp2
0161 2BCE 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2BD0 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2BD2 0286  22         ci    tmp2,255
     2BD4 00FF     
0167 2BD6 1505  14         jgt   string.getlenc.panic
0168 2BD8 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2BDA 0606  14         dec   tmp2                  ; One time adjustment
0174 2BDC C806  38         mov   tmp2,@waux1           ; Store length
     2BDE 833C     
0175 2BE0 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2BE2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2BE4 FFCE     
0181 2BE6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2BE8 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2BEA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2BEC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2BEE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2BF0 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2BF2 045B  20         b     *r11                  ; Return to caller
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
0023 2BF4 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2BF6 F960     
0024 2BF8 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2BFA F962     
0025 2BFC C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2BFE F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 2C00 0200  20         li    r0,>8306              ; Scratchpad source address
     2C02 8306     
0030 2C04 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2C06 F966     
0031 2C08 0202  20         li    r2,62                 ; Loop counter
     2C0A 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 2C0C CC70  46         mov   *r0+,*r1+
0037 2C0E CC70  46         mov   *r0+,*r1+
0038 2C10 0642  14         dect  r2
0039 2C12 16FC  14         jne   cpu.scrpad.backup.copy
0040 2C14 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2C16 83FE     
     2C18 FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 2C1A C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2C1C F960     
0046 2C1E C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2C20 F962     
0047 2C22 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2C24 F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 2C26 045B  20         b     *r11                  ; Return to caller
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
0069 2C28 0649  14         dect  stack
0070 2C2A C64B  30         mov   r11,*stack            ; Save return address
0071 2C2C 0649  14         dect  stack
0072 2C2E C640  30         mov   r0,*stack             ; Push r0
0073 2C30 0649  14         dect  stack
0074 2C32 C641  30         mov   r1,*stack             ; Push r1
0075 2C34 0649  14         dect  stack
0076 2C36 C642  30         mov   r2,*stack             ; Push r2
0077                       ;------------------------------------------------------
0078                       ; Prepare for copy loop, WS
0079                       ;------------------------------------------------------
0080 2C38 0200  20         li    r0,cpu.scrpad.tgt
     2C3A F960     
0081 2C3C 0201  20         li    r1,>8300
     2C3E 8300     
0082 2C40 0202  20         li    r2,64
     2C42 0040     
0083                       ;------------------------------------------------------
0084                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0085                       ;------------------------------------------------------
0086               cpu.scrpad.restore.copy:
0087 2C44 CC70  46         mov   *r0+,*r1+
0088 2C46 CC70  46         mov   *r0+,*r1+
0089 2C48 0602  14         dec   r2
0090 2C4A 16FC  14         jne   cpu.scrpad.restore.copy
0091                       ;------------------------------------------------------
0092                       ; Exit
0093                       ;------------------------------------------------------
0094               cpu.scrpad.restore.exit:
0095 2C4C C0B9  30         mov   *stack+,r2            ; Pop r2
0096 2C4E C079  30         mov   *stack+,r1            ; Pop r1
0097 2C50 C039  30         mov   *stack+,r0            ; Pop r0
0098 2C52 C2F9  30         mov   *stack+,r11           ; Pop r11
0099 2C54 045B  20         b     *r11                  ; Return to caller
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
0038 2C56 C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 2C58 CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 2C5A CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 2C5C CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 2C5E CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 2C60 CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 2C62 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 2C64 CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 2C66 CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 2C68 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     2C6A 8310     
0055                                                   ;        as of register r8
0056 2C6C 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     2C6E 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 2C70 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 2C72 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 2C74 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 2C76 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 2C78 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 2C7A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 2C7C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 2C7E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 2C80 0606  14         dec   tmp2
0069 2C82 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 2C84 C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 2C86 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2C88 2C8E     
0075                                                   ; R14=PC
0076 2C8A 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 2C8C 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 2C8E 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     2C90 2C28     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 2C92 045B  20         b     *r11                  ; Return to caller
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
0119 2C94 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0120                       ;------------------------------------------------------
0121                       ; Copy scratchpad memory to destination
0122                       ;------------------------------------------------------
0123               xcpu.scrpad.pgin:
0124 2C96 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2C98 8300     
0125 2C9A 0206  20         li    tmp2,16               ; tmp2 = 256/16
     2C9C 0010     
0126                       ;------------------------------------------------------
0127                       ; Copy memory
0128                       ;------------------------------------------------------
0129 2C9E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0130 2CA0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0131 2CA2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0132 2CA4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0133 2CA6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0134 2CA8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0135 2CAA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0136 2CAC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0137 2CAE 0606  14         dec   tmp2
0138 2CB0 16F6  14         jne   -!                    ; Loop until done
0139                       ;------------------------------------------------------
0140                       ; Switch workspace to scratchpad memory
0141                       ;------------------------------------------------------
0142 2CB2 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2CB4 8300     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               cpu.scrpad.pgin.exit:
0147 2CB6 045B  20         b     *r11                  ; Return to caller
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
0056 2CB8 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2CBA 2CBC             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2CBC C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2CBE C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2CC0 A428     
0064 2CC2 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2CC4 201C     
0065 2CC6 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2CC8 8356     
0066 2CCA C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2CCC 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2CCE FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2CD0 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2CD2 A434     
0073                       ;---------------------------; Inline VSBR start
0074 2CD4 06C0  14         swpb  r0                    ;
0075 2CD6 D800  38         movb  r0,@vdpa              ; Send low byte
     2CD8 8C02     
0076 2CDA 06C0  14         swpb  r0                    ;
0077 2CDC D800  38         movb  r0,@vdpa              ; Send high byte
     2CDE 8C02     
0078 2CE0 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2CE2 8800     
0079                       ;---------------------------; Inline VSBR end
0080 2CE4 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2CE6 0704  14         seto  r4                    ; Init counter
0086 2CE8 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2CEA A420     
0087 2CEC 0580  14 !       inc   r0                    ; Point to next char of name
0088 2CEE 0584  14         inc   r4                    ; Increment char counter
0089 2CF0 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2CF2 0007     
0090 2CF4 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2CF6 80C4  18         c     r4,r3                 ; End of name?
0093 2CF8 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2CFA 06C0  14         swpb  r0                    ;
0098 2CFC D800  38         movb  r0,@vdpa              ; Send low byte
     2CFE 8C02     
0099 2D00 06C0  14         swpb  r0                    ;
0100 2D02 D800  38         movb  r0,@vdpa              ; Send high byte
     2D04 8C02     
0101 2D06 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2D08 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2D0A DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2D0C 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2D0E 2E24     
0109 2D10 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2D12 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2D14 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2D16 04E0  34         clr   @>83d0
     2D18 83D0     
0118 2D1A C804  38         mov   r4,@>8354             ; Save name length for search (length
     2D1C 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2D1E C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2D20 A432     
0121               
0122 2D22 0584  14         inc   r4                    ; Adjust for dot
0123 2D24 A804  38         a     r4,@>8356             ; Point to position after name
     2D26 8356     
0124 2D28 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2D2A 8356     
     2D2C A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2D2E 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2D30 83E0     
0130 2D32 04C1  14         clr   r1                    ; Version found of dsr
0131 2D34 020C  20         li    r12,>0f00             ; Init cru address
     2D36 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2D38 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2D3A 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2D3C 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2D3E 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2D40 0100     
0145 2D42 04E0  34         clr   @>83d0                ; Clear in case we are done
     2D44 83D0     
0146 2D46 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2D48 2000     
0147 2D4A 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2D4C C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2D4E 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2D50 1D00  20         sbo   0                     ; Turn on ROM
0154 2D52 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2D54 4000     
0155 2D56 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2D58 2E20     
0156 2D5A 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2D5C A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2D5E A40A     
0166 2D60 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2D62 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2D64 83D2     
0172                                                   ; subprogram
0173               
0174 2D66 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2D68 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2D6A 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2D6C C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2D6E 83D2     
0183                                                   ; subprogram
0184               
0185 2D70 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2D72 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2D74 04C5  14         clr   r5                    ; Remove any old stuff
0194 2D76 D160  34         movb  @>8355,r5             ; Get length as counter
     2D78 8355     
0195 2D7A 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2D7C 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2D7E 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2D80 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2D82 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2D84 A420     
0206 2D86 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2D88 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2D8A 0605  14         dec   r5                    ; Update loop counter
0211 2D8C 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2D8E 0581  14         inc   r1                    ; Next version found
0217 2D90 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2D92 A42A     
0218 2D94 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2D96 A42C     
0219 2D98 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2D9A A430     
0220               
0221 2D9C 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2D9E 8C02     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2DA0 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2DA2 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2DA4 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2DA6 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2DA8 A400     
0233 2DAA C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2DAC C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2DAE A428     
0239                                                   ; (8 or >a)
0240 2DB0 0281  22         ci    r1,8                  ; was it 8?
     2DB2 0008     
0241 2DB4 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2DB6 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2DB8 8350     
0243                                                   ; Get error byte from @>8350
0244 2DBA 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2DBC 06C0  14         swpb  r0                    ;
0252 2DBE D800  38         movb  r0,@vdpa              ; send low byte
     2DC0 8C02     
0253 2DC2 06C0  14         swpb  r0                    ;
0254 2DC4 D800  38         movb  r0,@vdpa              ; send high byte
     2DC6 8C02     
0255 2DC8 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2DCA 8800     
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2DCC 09D1  56         srl   r1,13                 ; just keep error bits
0263 2DCE 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2DD0 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2DD2 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2DD4 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2DD6 A400     
0275               dsrlnk.error.devicename_invalid:
0276 2DD8 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2DDA 06C1  14         swpb  r1                    ; put error in hi byte
0279 2DDC D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2DDE F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2DE0 201C     
0281                                                   ; / to indicate error
0282 2DE2 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2DE4 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2DE6 2DE8             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2DE8 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2DEA 83E0     
0316               
0317 2DEC 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2DEE 201C     
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2DF0 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2DF2 A42A     
0322 2DF4 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2DF6 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2DF8 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2DFA 8356     
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2DFC C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2DFE C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2E00 8354     
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2E02 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2E04 8C02     
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2E06 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2E08 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2E0A 4000     
     2E0C 2E20     
0337 2E0E 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2E10 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2E12 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2E14 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2E16 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2E18 A400     
0355 2E1A C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2E1C A434     
0356               
0357 2E1E 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2E20 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2E22 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2E24 2E       dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2E26 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2E28 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2E2A 0649  14         dect  stack
0052 2E2C C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2E2E 0204  20         li    tmp0,dsrlnk.savcru
     2E30 A42A     
0057 2E32 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2E34 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2E36 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2E38 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2E3A 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2E3C 37D7     
0065 2E3E C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2E40 8370     
0066                                                   ; / location
0067 2E42 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2E44 A44C     
0068 2E46 04C5  14         clr   tmp1                  ; io.op.open
0069 2E48 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2E4A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2E4C 0649  14         dect  stack
0097 2E4E C64B  30         mov   r11,*stack            ; Save return address
0098 2E50 0205  20         li    tmp1,io.op.close      ; io.op.close
     2E52 0001     
0099 2E54 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2E56 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2E58 0649  14         dect  stack
0125 2E5A C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2E5C 0205  20         li    tmp1,io.op.read       ; io.op.read
     2E5E 0002     
0128 2E60 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2E62 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2E64 0649  14         dect  stack
0155 2E66 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2E68 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2E6A 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2E6C 0005     
0159               
0160 2E6E C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2E70 A43E     
0161               
0162 2E72 06A0  32         bl    @xvputb               ; Write character count to PAB
     2E74 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2E76 0205  20         li    tmp1,io.op.write      ; io.op.write
     2E78 0003     
0167 2E7A 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2E7C 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2E7E 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2E80 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2E82 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2E84 1000  14         nop
0189               
0190               
0191               file.status:
0192 2E86 1000  14         nop
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
0227 2E88 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2E8A A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2E8C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2E8E A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2E90 A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2E92 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2E94 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2E96 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2E98 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2E9A C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2E9C A44C     
0246               
0247 2E9E 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2EA0 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2EA2 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2EA4 0009     
0254 2EA6 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2EA8 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2EAA C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2EAC 8322     
     2EAE 833C     
0259               
0260 2EB0 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2EB2 A42A     
0261 2EB4 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2EB6 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2EB8 2CB8     
0268 2EBA 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2EBC 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2EBE 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2EC0 2DE4     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2EC2 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2EC4 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2EC6 833C     
     2EC8 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2ECA C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2ECC A436     
0292 2ECE 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2ED0 0005     
0293 2ED2 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2ED4 22F8     
0294 2ED6 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2ED8 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2EDA C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2EDC 045B  20         b     *r11                  ; Return to caller
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
0020 2EDE 0300  24 tmgr    limi  0                     ; No interrupt processing
     2EE0 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2EE2 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2EE4 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2EE6 2360  38         coc   @wbit2,r13            ; C flag on ?
     2EE8 201C     
0029 2EEA 1602  14         jne   tmgr1a                ; No, so move on
0030 2EEC E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2EEE 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2EF0 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2EF2 2020     
0035 2EF4 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2EF6 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2EF8 2010     
0048 2EFA 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2EFC 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2EFE 200E     
0050 2F00 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2F02 0460  28         b     @kthread              ; Run kernel thread
     2F04 2F7C     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2F06 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2F08 2014     
0056 2F0A 13EB  14         jeq   tmgr1
0057 2F0C 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2F0E 2012     
0058 2F10 16E8  14         jne   tmgr1
0059 2F12 C120  34         mov   @wtiusr,tmp0
     2F14 832E     
0060 2F16 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2F18 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2F1A 2F7A     
0065 2F1C C10A  18         mov   r10,tmp0
0066 2F1E 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2F20 00FF     
0067 2F22 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2F24 201C     
0068 2F26 1303  14         jeq   tmgr5
0069 2F28 0284  22         ci    tmp0,60               ; 1 second reached ?
     2F2A 003C     
0070 2F2C 1002  14         jmp   tmgr6
0071 2F2E 0284  22 tmgr5   ci    tmp0,50
     2F30 0032     
0072 2F32 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2F34 1001  14         jmp   tmgr8
0074 2F36 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2F38 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2F3A 832C     
0079 2F3C 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2F3E FF00     
0080 2F40 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2F42 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2F44 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2F46 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2F48 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2F4A 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2F4C 830C     
     2F4E 830D     
0089 2F50 1608  14         jne   tmgr10                ; No, get next slot
0090 2F52 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2F54 FF00     
0091 2F56 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2F58 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2F5A 8330     
0096 2F5C 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2F5E C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2F60 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2F62 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2F64 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2F66 8315     
     2F68 8314     
0103 2F6A 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2F6C 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2F6E 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2F70 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2F72 10F7  14         jmp   tmgr10                ; Process next slot
0108 2F74 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2F76 FF00     
0109 2F78 10B4  14         jmp   tmgr1
0110 2F7A 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2F7C E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2F7E 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 2F80 20A0  38         coc   @wbit13,config        ; Sound player on ?
     2F82 2006     
0023 2F84 1602  14         jne   kthread_kb
0024 2F86 06A0  32         bl    @sdpla1               ; Run sound player
     2F88 2840     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 2F8A 06A0  32         bl    @realkb               ; Scan full keyboard
     2F8C 28C0     
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2F8E 0460  28         b     @tmgr3                ; Exit
     2F90 2F06     
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
0017 2F92 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2F94 832E     
0018 2F96 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2F98 2012     
0019 2F9A 045B  20 mkhoo1  b     *r11                  ; Return
0020      2EE2     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2F9C 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2F9E 832E     
0029 2FA0 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2FA2 FEFF     
0030 2FA4 045B  20         b     *r11                  ; Return
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
0017 2FA6 C13B  30 mkslot  mov   *r11+,tmp0
0018 2FA8 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2FAA C184  18         mov   tmp0,tmp2
0023 2FAC 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2FAE A1A0  34         a     @wtitab,tmp2          ; Add table base
     2FB0 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2FB2 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2FB4 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2FB6 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2FB8 881B  46         c     *r11,@w$ffff          ; End of list ?
     2FBA 2022     
0035 2FBC 1301  14         jeq   mkslo1                ; Yes, exit
0036 2FBE 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2FC0 05CB  14 mkslo1  inct  r11
0041 2FC2 045B  20         b     *r11                  ; Exit
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
0052 2FC4 C13B  30 clslot  mov   *r11+,tmp0
0053 2FC6 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2FC8 A120  34         a     @wtitab,tmp0          ; Add table base
     2FCA 832C     
0055 2FCC 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2FCE 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2FD0 045B  20         b     *r11                  ; Exit
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
0068 2FD2 C13B  30 rsslot  mov   *r11+,tmp0
0069 2FD4 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2FD6 A120  34         a     @wtitab,tmp0          ; Add table base
     2FD8 832C     
0071 2FDA 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2FDC C154  26         mov   *tmp0,tmp1
0073 2FDE 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2FE0 FF00     
0074 2FE2 C505  30         mov   tmp1,*tmp0
0075 2FE4 045B  20         b     *r11                  ; Exit
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
0261 2FE6 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2FE8 8302     
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 2FEA 0300  24 runli1  limi  0                     ; Turn off interrupts
     2FEC 0000     
0267 2FEE 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2FF0 8300     
0268 2FF2 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2FF4 83C0     
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 2FF6 0202  20 runli2  li    r2,>8308
     2FF8 8308     
0273 2FFA 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 2FFC 0282  22         ci    r2,>8400
     2FFE 8400     
0275 3000 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 3002 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     3004 FFFF     
0280 3006 1602  14         jne   runli4                ; No, continue
0281 3008 0420  54         blwp  @0                    ; Yes, bye bye
     300A 0000     
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 300C C803  38 runli4  mov   r3,@waux1             ; Store random seed
     300E 833C     
0286 3010 04C1  14         clr   r1                    ; Reset counter
0287 3012 0202  20         li    r2,10                 ; We test 10 times
     3014 000A     
0288 3016 C0E0  34 runli5  mov   @vdps,r3
     3018 8802     
0289 301A 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     301C 2020     
0290 301E 1302  14         jeq   runli6
0291 3020 0581  14         inc   r1                    ; Increase counter
0292 3022 10F9  14         jmp   runli5
0293 3024 0602  14 runli6  dec   r2                    ; Next test
0294 3026 16F7  14         jne   runli5
0295 3028 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     302A 1250     
0296 302C 1202  14         jle   runli7                ; No, so it must be NTSC
0297 302E 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     3030 201C     
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 3032 06A0  32 runli7  bl    @loadmc
     3034 222E     
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 3036 04C1  14 runli9  clr   r1
0306 3038 04C2  14         clr   r2
0307 303A 04C3  14         clr   r3
0308 303C 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     303E AF00     
0309 3040 020F  20         li    r15,vdpw              ; Set VDP write address
     3042 8C00     
0311 3044 06A0  32         bl    @mute                 ; Mute sound generators
     3046 2804     
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 3048 0280  22         ci    r0,>4a4a              ; Crash flag set?
     304A 4A4A     
0318 304C 1605  14         jne   runlia
0319 304E 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     3050 22A2     
0320 3052 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     3054 0000     
     3056 3000     
0325 3058 06A0  32 runlia  bl    @filv
     305A 22A2     
0326 305C 0FC0             data  pctadr,spfclr,16      ; Load color table
     305E 00F4     
     3060 0010     
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 3062 06A0  32         bl    @f18unl               ; Unlock the F18A
     3064 2746     
0334 3066 06A0  32         bl    @f18chk               ; Check if F18A is there \
     3068 2766     
0335 306A 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     306C 2766     
0336 306E 06A0  32         bl    @f18chk               ; Check if F18A is there /
     3070 2766     
0337 3072 06A0  32         bl    @f18lck               ; Lock the F18A again
     3074 275C     
0338               
0339 3076 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     3078 2346     
0340 307A 3201                   data >3201            ; F18a VR50 (>32), bit 1
0342               *--------------------------------------------------------------
0343               * Check if there is a speech synthesizer attached
0344               *--------------------------------------------------------------
0346               *       <<skipped>>
0350               *--------------------------------------------------------------
0351               * Load video mode table & font
0352               *--------------------------------------------------------------
0353 307C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     307E 230C     
0354 3080 3654             data  spvmod                ; Equate selected video mode table
0355 3082 0204  20         li    tmp0,spfont           ; Get font option
     3084 000C     
0356 3086 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0357 3088 1304  14         jeq   runlid                ; Yes, skip it
0358 308A 06A0  32         bl    @ldfnt
     308C 2374     
0359 308E 1100             data  fntadr,spfont         ; Load specified font
     3090 000C     
0360               *--------------------------------------------------------------
0361               * Did a system crash occur before runlib was called?
0362               *--------------------------------------------------------------
0363 3092 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     3094 4A4A     
0364 3096 1602  14         jne   runlie                ; No, continue
0365 3098 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     309A 2086     
0366               *--------------------------------------------------------------
0367               * Branch to main program
0368               *--------------------------------------------------------------
0369 309C 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     309E 0040     
0370 30A0 0460  28         b     @main                 ; Give control to main program
     30A2 6046     
                   < stevie_b3.asm.61108
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
0021 30A4 C13B  30         mov   *r11+,tmp0            ; P0
0022 30A6 C17B  30         mov   *r11+,tmp1            ; P1
0023 30A8 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 30AA 0649  14         dect  stack
0029 30AC C644  30         mov   tmp0,*stack           ; Push tmp0
0030 30AE 0649  14         dect  stack
0031 30B0 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 30B2 0649  14         dect  stack
0033 30B4 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 30B6 0649  14         dect  stack
0035 30B8 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 30BA 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     30BC 6000     
0040 30BE 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 30C0 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     30C2 A226     
0044 30C4 0647  14         dect  tmp3
0045 30C6 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 30C8 0647  14         dect  tmp3
0047 30CA C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 30CC C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     30CE A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 30D0 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 30D2 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 30D4 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 30D6 0224  22         ai    tmp0,>0800
     30D8 0800     
0066 30DA 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 30DC 0285  22         ci    tmp1,>ffff
     30DE FFFF     
0075 30E0 1602  14         jne   !
0076 30E2 C160  34         mov   @trmpvector,tmp1
     30E4 A02E     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 30E6 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 30E8 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 30EA 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 30EC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     30EE FFCE     
0091 30F0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     30F2 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 30F4 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 30F6 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     30F8 A226     
0102 30FA C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 30FC 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 30FE 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 3100 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 3102 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 3104 028B  22         ci    r11,>6000
     3106 6000     
0115 3108 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 310A 028B  22         ci    r11,>7fff
     310C 7FFF     
0117 310E 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 3110 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     3112 A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 3114 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 3116 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 3118 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 311A 0225  22         ai    tmp1,>0800
     311C 0800     
0137 311E 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 3120 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 3122 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3124 FFCE     
0144 3126 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3128 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 312A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 312C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 312E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 3130 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 3132 045B  20         b     *r11                  ; Return to caller
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
0020 3134 0649  14         dect  stack
0021 3136 C64B  30         mov   r11,*stack            ; Save return address
0022 3138 0649  14         dect  stack
0023 313A C644  30         mov   tmp0,*stack           ; Push tmp0
0024 313C 0649  14         dect  stack
0025 313E C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3140 0204  20         li    tmp0,fb.top
     3142 D000     
0030 3144 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3146 A300     
0031 3148 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     314A A304     
0032 314C 04E0  34         clr   @fb.row               ; Current row=0
     314E A306     
0033 3150 04E0  34         clr   @fb.column            ; Current column=0
     3152 A30C     
0034               
0035 3154 0204  20         li    tmp0,colrow
     3156 0050     
0036 3158 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     315A A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 315C C160  34         mov   @tv.ruler.visible,tmp1
     315E A210     
0041 3160 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 3162 0204  20         li    tmp0,pane.botrow-2
     3164 001B     
0043 3166 1002  14         jmp   fb.init.cont
0044 3168 0204  20 !       li    tmp0,pane.botrow-1
     316A 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 316C C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     316E A31A     
0050 3170 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3172 A31C     
0051               
0052 3174 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     3176 A222     
0053 3178 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     317A A310     
0054 317C 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     317E A316     
0055 3180 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     3182 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 3184 06A0  32         bl    @film
     3186 224A     
0060 3188 D000             data  fb.top,>00,fb.size    ; Clear it all the way
     318A 0000     
     318C 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 318E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 3190 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 3192 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 3194 045B  20         b     *r11                  ; Return to caller
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
0051 3196 0649  14         dect  stack
0052 3198 C64B  30         mov   r11,*stack            ; Save return address
0053 319A 0649  14         dect  stack
0054 319C C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 319E 0204  20         li    tmp0,idx.top
     31A0 B000     
0059 31A2 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     31A4 A502     
0060               
0061 31A6 C120  34         mov   @tv.sams.b000,tmp0
     31A8 A206     
0062 31AA C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     31AC A600     
0063 31AE C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     31B0 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 31B2 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     31B4 0004     
0068 31B6 C804  38         mov   tmp0,@idx.sams.hipage ; /
     31B8 A604     
0069               
0070 31BA 06A0  32         bl    @_idx.sams.mapcolumn.on
     31BC 31D8     
0071                                                   ; Index in continuous memory region
0072               
0073 31BE 06A0  32         bl    @film
     31C0 224A     
0074 31C2 B000                   data idx.top,>00,idx.size * 5
     31C4 0000     
     31C6 5000     
0075                                                   ; Clear index
0076               
0077 31C8 06A0  32         bl    @_idx.sams.mapcolumn.off
     31CA 320C     
0078                                                   ; Restore memory window layout
0079               
0080 31CC C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     31CE A602     
     31D0 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 31D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 31D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0088 31D6 045B  20         b     *r11                  ; Return to caller
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
0101 31D8 0649  14         dect  stack
0102 31DA C64B  30         mov   r11,*stack            ; Push return address
0103 31DC 0649  14         dect  stack
0104 31DE C644  30         mov   tmp0,*stack           ; Push tmp0
0105 31E0 0649  14         dect  stack
0106 31E2 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 31E4 0649  14         dect  stack
0108 31E6 C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 31E8 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     31EA A602     
0113 31EC 0205  20         li    tmp1,idx.top
     31EE B000     
0114 31F0 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     31F2 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 31F4 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     31F6 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 31F8 0584  14         inc   tmp0                  ; Next SAMS index page
0123 31FA 0225  22         ai    tmp1,>1000            ; Next memory region
     31FC 1000     
0124 31FE 0606  14         dec   tmp2                  ; Update loop counter
0125 3200 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 3202 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 3204 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 3206 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 3208 C2F9  30         mov   *stack+,r11           ; Pop return address
0134 320A 045B  20         b     *r11                  ; Return to caller
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
0150 320C 0649  14         dect  stack
0151 320E C64B  30         mov   r11,*stack            ; Push return address
0152 3210 0649  14         dect  stack
0153 3212 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 3214 0649  14         dect  stack
0155 3216 C645  30         mov   tmp1,*stack           ; Push tmp1
0156 3218 0649  14         dect  stack
0157 321A C646  30         mov   tmp2,*stack           ; Push tmp2
0158 321C 0649  14         dect  stack
0159 321E C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 3220 0205  20         li    tmp1,idx.top
     3222 B000     
0164 3224 0206  20         li    tmp2,5                ; Always 5 pages
     3226 0005     
0165 3228 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     322A A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 322C C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 322E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3230 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 3232 0225  22         ai    tmp1,>1000            ; Next memory region
     3234 1000     
0176 3236 0606  14         dec   tmp2                  ; Update loop counter
0177 3238 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 323A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 323C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 323E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 3240 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 3242 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 3244 045B  20         b     *r11                  ; Return to caller
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
0211 3246 0649  14         dect  stack
0212 3248 C64B  30         mov   r11,*stack            ; Save return address
0213 324A 0649  14         dect  stack
0214 324C C644  30         mov   tmp0,*stack           ; Push tmp0
0215 324E 0649  14         dect  stack
0216 3250 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 3252 0649  14         dect  stack
0218 3254 C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 3256 C184  18         mov   tmp0,tmp2             ; Line number
0223 3258 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 325A 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     325C 0800     
0225               
0226 325E 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 3260 0A16  56         sla   tmp2,1                ; line number * 2
0231 3262 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     3264 A010     
0232               
0233 3266 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     3268 A602     
0234 326A 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     326C A600     
0235               
0236 326E 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 3270 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     3272 A600     
0242 3274 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     3276 A206     
0243 3278 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 327A 0205  20         li    tmp1,>b000            ; Memory window for index page
     327C B000     
0246               
0247 327E 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     3280 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 3282 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     3284 A604     
0254 3286 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 3288 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     328A A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 328C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 328E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 3290 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 3292 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 3294 045B  20         b     *r11                  ; Return to caller
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
0022 3296 0649  14         dect  stack
0023 3298 C64B  30         mov   r11,*stack            ; Save return address
0024 329A 0649  14         dect  stack
0025 329C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 329E 06A0  32         bl    @mem.sams.layout      ; Load standard SAMS pages again
     32A0 346C     
0030               
0031 32A2 0204  20         li    tmp0,edb.top          ; \
     32A4 C000     
0032 32A6 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     32A8 A500     
0033 32AA C804  38         mov   tmp0,@edb.next_free.ptr
     32AC A508     
0034                                                   ; Set pointer to next free line
0035               
0036 32AE 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     32B0 A50A     
0037               
0038 32B2 0204  20         li    tmp0,1
     32B4 0001     
0039 32B6 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     32B8 A504     
0040               
0041 32BA 0720  34         seto  @edb.block.m1         ; Reset block start line
     32BC A50C     
0042 32BE 0720  34         seto  @edb.block.m2         ; Reset block end line
     32C0 A50E     
0043               
0044 32C2 0204  20         li    tmp0,txt.newfile      ; "New file"
     32C4 38AC     
0045 32C6 C804  38         mov   tmp0,@edb.filename.ptr
     32C8 A512     
0046               
0047 32CA 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     32CC A440     
0048 32CE 04E0  34         clr   @fh.kilobytes.prev    ; /
     32D0 A45C     
0049               
0050 32D2 0204  20         li    tmp0,txt.filetype.none
     32D4 3968     
0051 32D6 C804  38         mov   tmp0,@edb.filetype.ptr
     32D8 A514     
0052               
0053               edb.init.exit:
0054                       ;------------------------------------------------------
0055                       ; Exit
0056                       ;------------------------------------------------------
0057 32DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 32DC C2F9  30         mov   *stack+,r11           ; Pop r11
0059 32DE 045B  20         b     *r11                  ; Return to caller
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
0022 32E0 0649  14         dect  stack
0023 32E2 C64B  30         mov   r11,*stack            ; Save return address
0024 32E4 0649  14         dect  stack
0025 32E6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 32E8 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     32EA E000     
0030 32EC C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     32EE A700     
0031               
0032 32F0 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     32F2 A702     
0033 32F4 0204  20         li    tmp0,4
     32F6 0004     
0034 32F8 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     32FA A706     
0035 32FC C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     32FE A708     
0036               
0037 3300 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3302 A716     
0038 3304 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3306 A718     
0039 3308 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     330A A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 330C 06A0  32         bl    @film
     330E 224A     
0044 3310 E000             data  cmdb.top,>00,cmdb.size
     3312 0000     
     3314 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3316 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3318 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 331A 045B  20         b     *r11                  ; Return to caller
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
0022 331C 0649  14         dect  stack
0023 331E C64B  30         mov   r11,*stack            ; Save return address
0024 3320 0649  14         dect  stack
0025 3322 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3324 0649  14         dect  stack
0027 3326 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3328 0649  14         dect  stack
0029 332A C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 332C 04E0  34         clr   @tv.error.visible     ; Set to hidden
     332E A228     
0034 3330 0204  20         li    tmp0,3
     3332 0003     
0035 3334 C804  38         mov   tmp0,@tv.error.rows   ; Number of rows in error pane
     3336 A22A     
0036               
0037 3338 06A0  32         bl    @film
     333A 224A     
0038 333C A22C                   data tv.error.msg,0,160
     333E 0000     
     3340 00A0     
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               errpane.exit:
0043 3342 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 3344 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 3346 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 3348 C2F9  30         mov   *stack+,r11           ; Pop R11
0047 334A 045B  20         b     *r11                  ; Return to caller
0048               
                   < ram.resident.asm
0013                       copy  "tv.asm"                 ; Main editor configuration
     **** ****     > tv.asm
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
0022 334C 0649  14         dect  stack
0023 334E C64B  30         mov   r11,*stack            ; Save return address
0024 3350 0649  14         dect  stack
0025 3352 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3354 0649  14         dect  stack
0027 3356 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3358 0649  14         dect  stack
0029 335A C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 335C 0204  20         li    tmp0,1                ; \ Set default color scheme
     335E 0001     
0034 3360 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3362 A212     
0035               
0036 3364 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3366 A224     
0037 3368 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     336A 200C     
0038               
0039 336C 0204  20         li    tmp0,fj.bottom
     336E B000     
0040 3370 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     3372 A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 3374 06A0  32         bl    @cpym2m
     3376 24EE     
0045 3378 3A40                   data def.printer.fname,tv.printer.fname,7
     337A D960     
     337C 0007     
0046               
0047 337E 06A0  32         bl    @cpym2m
     3380 24EE     
0048 3382 3A48                   data def.clip.fname,tv.clip.fname,10
     3384 D9B0     
     3386 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 3388 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 338A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 338C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 338E C2F9  30         mov   *stack+,r11           ; Pop R11
0057 3390 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               
0061               ***************************************************************
0062               * tv.reset
0063               * Reset editor (clear buffer)
0064               ***************************************************************
0065               * bl @tv.reset
0066               *--------------------------------------------------------------
0067               * INPUT
0068               * none
0069               *--------------------------------------------------------------
0070               * OUTPUT
0071               * none
0072               *--------------------------------------------------------------
0073               * Register usage
0074               * r11
0075               *--------------------------------------------------------------
0076               * Notes
0077               ***************************************************************
0078               tv.reset:
0079 3392 0649  14         dect  stack
0080 3394 C64B  30         mov   r11,*stack            ; Save return address
0081                       ;------------------------------------------------------
0082                       ; Reset editor
0083                       ;------------------------------------------------------
0084 3396 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3398 32E0     
0085 339A 06A0  32         bl    @edb.init             ; Initialize editor buffer
     339C 3296     
0086 339E 06A0  32         bl    @idx.init             ; Initialize index
     33A0 3196     
0087 33A2 06A0  32         bl    @fb.init              ; Initialize framebuffer
     33A4 3134     
0088 33A6 06A0  32         bl    @errpane.init         ; Initialize error pane
     33A8 331C     
0089                       ;------------------------------------------------------
0090                       ; Remove markers and shortcuts
0091                       ;------------------------------------------------------
0092 33AA 06A0  32         bl    @hchar
     33AC 27DC     
0093 33AE 0034                   byte 0,52,32,18           ; Remove markers
     33B0 2012     
0094 33B2 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     33B4 2033     
0095 33B6 FFFF                   data eol
0096                       ;-------------------------------------------------------
0097                       ; Exit
0098                       ;-------------------------------------------------------
0099               tv.reset.exit:
0100 33B8 C2F9  30         mov   *stack+,r11           ; Pop R11
0101 33BA 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0014                       copy  "tv.utils.asm"           ; General purpose utility functions
     **** ****     > tv.utils.asm
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
0020 33BC 0649  14         dect  stack
0021 33BE C64B  30         mov   r11,*stack            ; Save return address
0022 33C0 0649  14         dect  stack
0023 33C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 33C4 06A0  32         bl    @mknum                ; Convert unsigned number to string
     33C6 2AAA     
0028 33C8 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 33CA A140                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 33CC 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 33CD   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 33CE 0204  20         li    tmp0,unpacked.string
     33D0 A026     
0034 33D2 04F4  30         clr   *tmp0+                ; Clear string 01
0035 33D4 04F4  30         clr   *tmp0+                ; Clear string 23
0036 33D6 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 33D8 06A0  32         bl    @trimnum              ; Trim unsigned number string
     33DA 2B02     
0039 33DC A140                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 33DE A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 33E0 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 33E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 33E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 33E6 045B  20         b     *r11                  ; Return to caller
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
0073 33E8 0649  14         dect  stack
0074 33EA C64B  30         mov   r11,*stack            ; Push return address
0075 33EC 0649  14         dect  stack
0076 33EE C644  30         mov   tmp0,*stack           ; Push tmp0
0077 33F0 0649  14         dect  stack
0078 33F2 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 33F4 0649  14         dect  stack
0080 33F6 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 33F8 0649  14         dect  stack
0082 33FA C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 33FC C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     33FE A000     
0087 3400 D194  26         movb  *tmp0,tmp2            ; /
0088 3402 0986  56         srl   tmp2,8                ; Right align
0089 3404 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 3406 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3408 A002     
0092 340A 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 340C C120  34         mov   @parm1,tmp0           ; Get source address
     340E A000     
0097 3410 C160  34         mov   @parm4,tmp1           ; Get destination address
     3412 A006     
0098 3414 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 3416 0649  14         dect  stack
0101 3418 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 341A 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     341C 24F4     
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 341E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 3420 C120  34         mov   @parm2,tmp0           ; Get requested length
     3422 A002     
0113 3424 0A84  56         sla   tmp0,8                ; Left align
0114 3426 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3428 A006     
0115 342A D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 342C A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 342E 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 3430 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     3432 A002     
0122 3434 6187  18         s     tmp3,tmp2             ; |
0123 3436 0586  14         inc   tmp2                  ; /
0124               
0125 3438 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     343A A004     
0126 343C 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 343E DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 3440 0606  14         dec   tmp2                  ; Update loop counter
0133 3442 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 3444 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3446 A006     
     3448 A010     
0136 344A 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 344C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     344E FFCE     
0142 3450 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3452 2026     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 3454 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 3456 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 3458 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 345A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 345C C2F9  30         mov   *stack+,r11           ; Pop r11
0152 345E 045B  20         b     *r11                  ; Return to caller
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
0174 3460 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     3462 27B0     
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 3464 04E0  34         clr   @bank0.rom            ; Activate bank 0
     3466 6000     
0179 3468 0420  54         blwp  @0                    ; Reset to monitor
     346A 0000     
                   < ram.resident.asm
0015                       copy  "mem.asm"                ; Memory Management (SAMS)
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
0017 346C 0649  14         dect  stack
0018 346E C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 3470 06A0  32         bl    @sams.layout
     3472 25F6     
0023 3474 3680                   data mem.sams.layout.data
0024               
0025 3476 06A0  32         bl    @sams.layout.copy
     3478 265A     
0026 347A A200                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 347C C820  54         mov   @tv.sams.c000,@edb.sams.page
     347E A208     
     3480 A516     
0029 3482 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     3484 A516     
     3486 A518     
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 3488 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 348A 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0016                       ;-----------------------------------------------------------------------
0017                       ; Logic for Index management
0018                       ;-----------------------------------------------------------------------
0019                       copy  "idx.update.asm"      ; Index management - Update entry
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
0022 348C 0649  14         dect  stack
0023 348E C64B  30         mov   r11,*stack            ; Save return address
0024 3490 0649  14         dect  stack
0025 3492 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3494 0649  14         dect  stack
0027 3496 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 3498 C120  34         mov   @parm1,tmp0           ; Get line number
     349A A000     
0032 349C C160  34         mov   @parm2,tmp1           ; Get pointer
     349E A002     
0033 34A0 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 34A2 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     34A4 0FFF     
0039 34A6 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 34A8 06E0  34         swpb  @parm3
     34AA A004     
0044 34AC D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     34AE A004     
0045 34B0 06E0  34         swpb  @parm3                ; \ Restore original order again,
     34B2 A004     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 34B4 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     34B6 3246     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 34B8 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     34BA A010     
0056 34BC C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     34BE B000     
0057 34C0 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     34C2 A010     
0058 34C4 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 34C6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     34C8 3246     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 34CA C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     34CC A010     
0068 34CE 04E4  34         clr   @idx.top(tmp0)        ; /
     34D0 B000     
0069 34D2 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     34D4 A010     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 34D6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 34D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 34DA C2F9  30         mov   *stack+,r11           ; Pop r11
0077 34DC 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0020                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0021 34DE 0649  14         dect  stack
0022 34E0 C64B  30         mov   r11,*stack            ; Save return address
0023 34E2 0649  14         dect  stack
0024 34E4 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 34E6 0649  14         dect  stack
0026 34E8 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 34EA 0649  14         dect  stack
0028 34EC C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 34EE C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     34F0 A000     
0033               
0034 34F2 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     34F4 3246     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 34F6 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     34F8 A010     
0039 34FA C164  34         mov   @idx.top(tmp0),tmp1   ; /
     34FC B000     
0040               
0041 34FE 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 3500 C185  18         mov   tmp1,tmp2             ; \
0047 3502 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 3504 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     3506 00FF     
0052 3508 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 350A 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     350C C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 350E C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     3510 A010     
0059 3512 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     3514 A012     
0060 3516 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 3518 04E0  34         clr   @outparm1
     351A A010     
0066 351C 04E0  34         clr   @outparm2
     351E A012     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 3520 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 3522 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 3524 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 3526 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 3528 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0021                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0017 352A 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     352C B000     
0018 352E C144  18         mov   tmp0,tmp1             ; a = current slot
0019 3530 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 3532 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 3534 0606  14         dec   tmp2                  ; tmp2--
0026 3536 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 3538 045B  20         b     *r11                  ; Return to caller
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
0046 353A 0649  14         dect  stack
0047 353C C64B  30         mov   r11,*stack            ; Save return address
0048 353E 0649  14         dect  stack
0049 3540 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 3542 0649  14         dect  stack
0051 3544 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 3546 0649  14         dect  stack
0053 3548 C646  30         mov   tmp2,*stack           ; Push tmp2
0054 354A 0649  14         dect  stack
0055 354C C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 354E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     3550 A000     
0060               
0061 3552 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3554 3246     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 3556 C120  34         mov   @outparm1,tmp0        ; Index offset
     3558 A010     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 355A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     355C A002     
0070 355E 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 3560 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3562 A000     
0074 3564 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 3566 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     3568 B000     
0081 356A 04D4  26         clr   *tmp0                 ; Clear index entry
0082 356C 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 356E C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     3570 A002     
0088 3572 0287  22         ci    tmp3,2048
     3574 0800     
0089 3576 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 3578 06A0  32         bl    @_idx.sams.mapcolumn.on
     357A 31D8     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 357C C120  34         mov   @parm1,tmp0           ; Restore line number
     357E A000     
0103 3580 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 3582 06A0  32         bl    @_idx.entry.delete.reorg
     3584 352A     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 3586 06A0  32         bl    @_idx.sams.mapcolumn.off
     3588 320C     
0111                                                   ; Restore memory window layout
0112               
0113 358A 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 358C 06A0  32         bl    @_idx.entry.delete.reorg
     358E 352A     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 3590 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 3592 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 3594 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 3596 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 3598 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 359A C2F9  30         mov   *stack+,r11           ; Pop r11
0132 359C 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0022                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0017 359E 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     35A0 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 35A2 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 35A4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     35A6 FFCE     
0027 35A8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     35AA 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 35AC 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     35AE B000     
0032 35B0 C144  18         mov   tmp0,tmp1             ; a = current slot
0033 35B2 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 35B4 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 35B6 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 35B8 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 35BA 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 35BC A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 35BE 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     35C0 AFFC     
0043 35C2 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 35C4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     35C6 FFCE     
0049 35C8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     35CA 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 35CC C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 35CE 0644  14         dect  tmp0                  ; Move pointer up
0056 35D0 0645  14         dect  tmp1                  ; Move pointer up
0057 35D2 0606  14         dec   tmp2                  ; Next index entry
0058 35D4 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 35D6 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 35D8 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 35DA 045B  20         b     *r11                  ; Return to caller
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
0088 35DC 0649  14         dect  stack
0089 35DE C64B  30         mov   r11,*stack            ; Save return address
0090 35E0 0649  14         dect  stack
0091 35E2 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 35E4 0649  14         dect  stack
0093 35E6 C645  30         mov   tmp1,*stack           ; Push tmp1
0094 35E8 0649  14         dect  stack
0095 35EA C646  30         mov   tmp2,*stack           ; Push tmp2
0096 35EC 0649  14         dect  stack
0097 35EE C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 35F0 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     35F2 A002     
0102 35F4 61A0  34         s     @parm1,tmp2           ; Calculate loop
     35F6 A000     
0103 35F8 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 35FA C1E0  34         mov   @parm2,tmp3
     35FC A002     
0110 35FE 0287  22         ci    tmp3,2048
     3600 0800     
0111 3602 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 3604 06A0  32         bl    @_idx.sams.mapcolumn.on
     3606 31D8     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 3608 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     360A A002     
0123 360C 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 360E 06A0  32         bl    @_idx.entry.insert.reorg
     3610 359E     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 3612 06A0  32         bl    @_idx.sams.mapcolumn.off
     3614 320C     
0131                                                   ; Restore memory window layout
0132               
0133 3616 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 3618 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     361A A002     
0139               
0140 361C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     361E 3246     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 3620 C120  34         mov   @outparm1,tmp0        ; Index offset
     3622 A010     
0145               
0146 3624 06A0  32         bl    @_idx.entry.insert.reorg
     3626 359E     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 3628 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 362A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 362C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 362E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 3630 C2F9  30         mov   *stack+,r11           ; Pop r11
0160 3632 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0023                       ;-----------------------------------------------------------------------
0024                       ; Utility functions
0025                       ;-----------------------------------------------------------------------
0026                       copy  "pane.topline.clearmsg.asm"
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
0021 3634 0649  14         dect  stack
0022 3636 C64B  30         mov   r11,*stack            ; Push return address
0023 3638 0649  14         dect  stack
0024 363A C660  46         mov   @wyx,*stack           ; Push cursor position
     363C 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 363E 06A0  32         bl    @hchar
     3640 27DC     
0029 3642 0034                   byte 0,52,32,18
     3644 2012     
0030 3646 FFFF                   data EOL              ; Clear message
0031               
0032 3648 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     364A A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 364C C839  50         mov   *stack+,@wyx          ; Pop cursor position
     364E 832A     
0038 3650 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3652 045B  20         b     *r11                  ; Return to task
                   < ram.resident.asm
0027                                                      ; Remove overlay messsage in top line
0028                       ;------------------------------------------------------
0029                       ; Program data
0030                       ;------------------------------------------------------
0031                       copy  "data.constants.asm"     ; Constants
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
0033 3654 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     3656 003F     
     3658 0243     
     365A 05F4     
     365C 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 365E 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     3660 000C     
     3662 0006     
     3664 0007     
     3666 0020     
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
0067 3668 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     366A 000C     
     366C 0006     
     366E 0007     
     3670 0020     
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
0098 3672 0000             data  >0000,>0001           ; Cursor
     3674 0001     
0099 3676 0000             data  >0000,>0101           ; Current line indicator     <
     3678 0101     
0100 367A 0820             data  >0820,>0201           ; Current column indicator   v
     367C 0201     
0101               nosprite:
0102 367E D000             data  >d000                 ; End-of-Sprites list
0103               
0104               
0105               ***************************************************************
0106               * SAMS page layout table for Stevie (16 words)
0107               *--------------------------------------------------------------
0108               mem.sams.layout.data:
0109 3680 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     3682 0002     
0110 3684 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     3686 0003     
0111 3688 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     368A 000A     
0112 368C B000             data  >b000,>0020           ; >b000-bfff, SAMS page >20
     368E 0020     
0113                                                   ;   Index can allocate
0114                                                   ;   pages >20 to >3f.
0115 3690 C000             data  >c000,>0040           ; >c000-cfff, SAMS page >40
     3692 0040     
0116                                                   ;   Editor buffer can allocate
0117                                                   ;   pages >40 to >ff.
0118 3694 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     3696 000D     
0119 3698 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     369A 000E     
0120 369C F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     369E 000F     
0121               
0122               
0123               ***************************************************************
0124               * SAMS page layout table for calling external progam (16 words)
0125               *--------------------------------------------------------------
0126               mem.sams.external:
0127 36A0 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     36A2 0002     
0128 36A4 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     36A6 0003     
0129 36A8 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     36AA 000A     
0130 36AC B000             data  >b000,>0030           ; >b000-bfff, SAMS page >30
     36AE 0030     
0131 36B0 C000             data  >c000,>0031           ; >c000-cfff, SAMS page >31
     36B2 0031     
0132 36B4 D000             data  >d000,>0032           ; >d000-dfff, SAMS page >32
     36B6 0032     
0133 36B8 E000             data  >e000,>0033           ; >e000-efff, SAMS page >33
     36BA 0033     
0134 36BC F000             data  >f000,>0034           ; >f000-ffff, SAMS page >34
     36BE 0034     
0135               
0136               
0137               ***************************************************************
0138               * SAMS page layout table for TI Basic (16 words)
0139               *--------------------------------------------------------------
0140               mem.sams.tibasic:
0141 36C0 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     36C2 0002     
0142 36C4 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     36C6 0003     
0143 36C8 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     36CA 000A     
0144 36CC B000             data  >b000,>0004           ; >b000-bfff, SAMS page >04
     36CE 0004     
0145 36D0 C000             data  >c000,>0005           ; >c000-cfff, SAMS page >05
     36D2 0005     
0146 36D4 D000             data  >d000,>0006           ; >d000-dfff, SAMS page >06
     36D6 0006     
0147 36D8 E000             data  >e000,>0007           ; >e000-efff, SAMS page >07
     36DA 0007     
0148 36DC F000             data  >f000,>0008           ; >f000-ffff, SAMS page >08
     36DE 0008     
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
0202 36E0 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     36E2 F171     
     36E4 1B1F     
     36E6 71B1     
0203 36E8 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     36EA F0FF     
     36EC 1F1A     
     36EE F1FF     
0204 36F0 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     36F2 F0FF     
     36F4 1F12     
     36F6 F1F6     
0205 36F8 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     36FA 1E11     
     36FC 1A17     
     36FE 1E11     
0206 3700 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     3702 E1FF     
     3704 1F1E     
     3706 E1FF     
0207 3708 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     370A 1016     
     370C 1B71     
     370E 1711     
0208 3710 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3712 1011     
     3714 F1F1     
     3716 1F11     
0209 3718 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     371A A1FF     
     371C 1F1F     
     371E F11F     
0210 3720 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     3722 12FF     
     3724 1B12     
     3726 12FF     
0211 3728 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     372A E1FF     
     372C 1B1F     
     372E F131     
0212                       even
0213               
0214               tv.tabs.table:
0215 3730 0007             byte  0,7,12,25               ; \   Default tab positions as used
     3732 0C19     
0216 3734 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     3736 3B4F     
0217 3738 FF00             byte  >ff,0,0,0               ; |
     373A 0000     
0218 373C 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     373E 0000     
0219 3740 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     3742 0000     
0220                       even
                   < ram.resident.asm
0032                       copy  "data.strings.asm"       ; Strings
     **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               txt.delim
0009 3744 01               byte  1
0010 3745   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 3746 05               byte  5
0015 3747   20             text  '  BOT'
     3748 2042     
     374A 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 374C 03               byte  3
0020 374D   4F             text  'OVR'
     374E 5652     
0021                       even
0022               
0023               txt.insert
0024 3750 03               byte  3
0025 3751   49             text  'INS'
     3752 4E53     
0026                       even
0027               
0028               txt.star
0029 3754 01               byte  1
0030 3755   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 3756 0A               byte  10
0035 3757   4C             text  'Loading...'
     3758 6F61     
     375A 6469     
     375C 6E67     
     375E 2E2E     
     3760 2E       
0036                       even
0037               
0038               txt.saving
0039 3762 0A               byte  10
0040 3763   53             text  'Saving....'
     3764 6176     
     3766 696E     
     3768 672E     
     376A 2E2E     
     376C 2E       
0041                       even
0042               
0043               txt.printing
0044 376E 12               byte  18
0045 376F   50             text  'Printing file.....'
     3770 7269     
     3772 6E74     
     3774 696E     
     3776 6720     
     3778 6669     
     377A 6C65     
     377C 2E2E     
     377E 2E2E     
     3780 2E       
0046                       even
0047               
0048               txt.block.del
0049 3782 12               byte  18
0050 3783   44             text  'Deleting block....'
     3784 656C     
     3786 6574     
     3788 696E     
     378A 6720     
     378C 626C     
     378E 6F63     
     3790 6B2E     
     3792 2E2E     
     3794 2E       
0051                       even
0052               
0053               txt.block.copy
0054 3796 11               byte  17
0055 3797   43             text  'Copying block....'
     3798 6F70     
     379A 7969     
     379C 6E67     
     379E 2062     
     37A0 6C6F     
     37A2 636B     
     37A4 2E2E     
     37A6 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 37A8 10               byte  16
0060 37A9   4D             text  'Moving block....'
     37AA 6F76     
     37AC 696E     
     37AE 6720     
     37B0 626C     
     37B2 6F63     
     37B4 6B2E     
     37B6 2E2E     
     37B8 2E       
0061                       even
0062               
0063               txt.block.save
0064 37BA 18               byte  24
0065 37BB   53             text  'Saving block to file....'
     37BC 6176     
     37BE 696E     
     37C0 6720     
     37C2 626C     
     37C4 6F63     
     37C6 6B20     
     37C8 746F     
     37CA 2066     
     37CC 696C     
     37CE 652E     
     37D0 2E2E     
     37D2 2E       
0066                       even
0067               
0068               txt.block.clip
0069 37D4 18               byte  24
0070 37D5   43             text  'Copying to clipboard....'
     37D6 6F70     
     37D8 7969     
     37DA 6E67     
     37DC 2074     
     37DE 6F20     
     37E0 636C     
     37E2 6970     
     37E4 626F     
     37E6 6172     
     37E8 642E     
     37EA 2E2E     
     37EC 2E       
0071                       even
0072               
0073               txt.block.print
0074 37EE 12               byte  18
0075 37EF   50             text  'Printing block....'
     37F0 7269     
     37F2 6E74     
     37F4 696E     
     37F6 6720     
     37F8 626C     
     37FA 6F63     
     37FC 6B2E     
     37FE 2E2E     
     3800 2E       
0076                       even
0077               
0078               txt.clearmem
0079 3802 13               byte  19
0080 3803   43             text  'Clearing memory....'
     3804 6C65     
     3806 6172     
     3808 696E     
     380A 6720     
     380C 6D65     
     380E 6D6F     
     3810 7279     
     3812 2E2E     
     3814 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 3816 0E               byte  14
0085 3817   4C             text  'Load completed'
     3818 6F61     
     381A 6420     
     381C 636F     
     381E 6D70     
     3820 6C65     
     3822 7465     
     3824 64       
0086                       even
0087               
0088               txt.done.insert
0089 3826 10               byte  16
0090 3827   49             text  'Insert completed'
     3828 6E73     
     382A 6572     
     382C 7420     
     382E 636F     
     3830 6D70     
     3832 6C65     
     3834 7465     
     3836 64       
0091                       even
0092               
0093               txt.done.save
0094 3838 0E               byte  14
0095 3839   53             text  'Save completed'
     383A 6176     
     383C 6520     
     383E 636F     
     3840 6D70     
     3842 6C65     
     3844 7465     
     3846 64       
0096                       even
0097               
0098               txt.done.copy
0099 3848 0E               byte  14
0100 3849   43             text  'Copy completed'
     384A 6F70     
     384C 7920     
     384E 636F     
     3850 6D70     
     3852 6C65     
     3854 7465     
     3856 64       
0101                       even
0102               
0103               txt.done.print
0104 3858 0F               byte  15
0105 3859   50             text  'Print completed'
     385A 7269     
     385C 6E74     
     385E 2063     
     3860 6F6D     
     3862 706C     
     3864 6574     
     3866 6564     
0106                       even
0107               
0108               txt.done.delete
0109 3868 10               byte  16
0110 3869   44             text  'Delete completed'
     386A 656C     
     386C 6574     
     386E 6520     
     3870 636F     
     3872 6D70     
     3874 6C65     
     3876 7465     
     3878 64       
0111                       even
0112               
0113               txt.done.clipboard
0114 387A 0F               byte  15
0115 387B   43             text  'Clipboard saved'
     387C 6C69     
     387E 7062     
     3880 6F61     
     3882 7264     
     3884 2073     
     3886 6176     
     3888 6564     
0116                       even
0117               
0118               txt.done.clipdev
0119 388A 0D               byte  13
0120 388B   43             text  'Clipboard set'
     388C 6C69     
     388E 7062     
     3890 6F61     
     3892 7264     
     3894 2073     
     3896 6574     
0121                       even
0122               
0123               txt.fastmode
0124 3898 08               byte  8
0125 3899   46             text  'Fastmode'
     389A 6173     
     389C 746D     
     389E 6F64     
     38A0 65       
0126                       even
0127               
0128               txt.kb
0129 38A2 02               byte  2
0130 38A3   6B             text  'kb'
     38A4 62       
0131                       even
0132               
0133               txt.lines
0134 38A6 05               byte  5
0135 38A7   4C             text  'Lines'
     38A8 696E     
     38AA 6573     
0136                       even
0137               
0138               txt.newfile
0139 38AC 0A               byte  10
0140 38AD   5B             text  '[New file]'
     38AE 4E65     
     38B0 7720     
     38B2 6669     
     38B4 6C65     
     38B6 5D       
0141                       even
0142               
0143               txt.filetype.dv80
0144 38B8 04               byte  4
0145 38B9   44             text  'DV80'
     38BA 5638     
     38BC 30       
0146                       even
0147               
0148               txt.m1
0149 38BE 03               byte  3
0150 38BF   4D             text  'M1='
     38C0 313D     
0151                       even
0152               
0153               txt.m2
0154 38C2 03               byte  3
0155 38C3   4D             text  'M2='
     38C4 323D     
0156                       even
0157               
0158               txt.keys.default
0159 38C6 07               byte  7
0160 38C7   46             text  'F9-Menu'
     38C8 392D     
     38CA 4D65     
     38CC 6E75     
0161                       even
0162               
0163               txt.keys.block
0164 38CE 36               byte  54
0165 38CF   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     38D0 392D     
     38D2 4261     
     38D4 636B     
     38D6 2020     
     38D8 5E43     
     38DA 6F70     
     38DC 7920     
     38DE 205E     
     38E0 4D6F     
     38E2 7665     
     38E4 2020     
     38E6 5E44     
     38E8 656C     
     38EA 2020     
     38EC 5E53     
     38EE 6176     
     38F0 6520     
     38F2 205E     
     38F4 5072     
     38F6 696E     
     38F8 7420     
     38FA 205E     
     38FC 5B31     
     38FE 2D35     
     3900 5D43     
     3902 6C69     
     3904 70       
0166                       even
0167               
0168 3906 2E2E     txt.ruler          text    '.........'
     3908 2E2E     
     390A 2E2E     
     390C 2E2E     
     390E 2E       
0169 390F   12                        byte    18
0170 3910 2E2E                        text    '.........'
     3912 2E2E     
     3914 2E2E     
     3916 2E2E     
     3918 2E       
0171 3919   13                        byte    19
0172 391A 2E2E                        text    '.........'
     391C 2E2E     
     391E 2E2E     
     3920 2E2E     
     3922 2E       
0173 3923   14                        byte    20
0174 3924 2E2E                        text    '.........'
     3926 2E2E     
     3928 2E2E     
     392A 2E2E     
     392C 2E       
0175 392D   15                        byte    21
0176 392E 2E2E                        text    '.........'
     3930 2E2E     
     3932 2E2E     
     3934 2E2E     
     3936 2E       
0177 3937   16                        byte    22
0178 3938 2E2E                        text    '.........'
     393A 2E2E     
     393C 2E2E     
     393E 2E2E     
     3940 2E       
0179 3941   17                        byte    23
0180 3942 2E2E                        text    '.........'
     3944 2E2E     
     3946 2E2E     
     3948 2E2E     
     394A 2E       
0181 394B   18                        byte    24
0182 394C 2E2E                        text    '.........'
     394E 2E2E     
     3950 2E2E     
     3952 2E2E     
     3954 2E       
0183 3955   19                        byte    25
0184                                  even
0185 3956 020E     txt.alpha.down     data >020e,>0f00
     3958 0F00     
0186 395A 0110     txt.vertline       data >0110
0187 395C 011C     txt.keymarker      byte 1,28
0188               
0189               txt.ws1
0190 395E 01               byte  1
0191 395F   20             text  ' '
0192                       even
0193               
0194               txt.ws2
0195 3960 02               byte  2
0196 3961   20             text  '  '
     3962 20       
0197                       even
0198               
0199               txt.ws3
0200 3964 03               byte  3
0201 3965   20             text  '   '
     3966 2020     
0202                       even
0203               
0204               txt.ws4
0205 3968 04               byte  4
0206 3969   20             text  '    '
     396A 2020     
     396C 20       
0207                       even
0208               
0209               txt.ws5
0210 396E 05               byte  5
0211 396F   20             text  '     '
     3970 2020     
     3972 2020     
0212                       even
0213               
0214      3968     txt.filetype.none  equ txt.ws4
0215               
0216               
0217               ;--------------------------------------------------------------
0218               ; Strings for error line pane
0219               ;--------------------------------------------------------------
0220               txt.ioerr.load
0221 3974 15               byte  21
0222 3975   46             text  'Failed loading file: '
     3976 6169     
     3978 6C65     
     397A 6420     
     397C 6C6F     
     397E 6164     
     3980 696E     
     3982 6720     
     3984 6669     
     3986 6C65     
     3988 3A20     
0223                       even
0224               
0225               txt.ioerr.save
0226 398A 14               byte  20
0227 398B   46             text  'Failed saving file: '
     398C 6169     
     398E 6C65     
     3990 6420     
     3992 7361     
     3994 7669     
     3996 6E67     
     3998 2066     
     399A 696C     
     399C 653A     
     399E 20       
0228                       even
0229               
0230               txt.ioerr.print
0231 39A0 1B               byte  27
0232 39A1   46             text  'Failed printing to device: '
     39A2 6169     
     39A4 6C65     
     39A6 6420     
     39A8 7072     
     39AA 696E     
     39AC 7469     
     39AE 6E67     
     39B0 2074     
     39B2 6F20     
     39B4 6465     
     39B6 7669     
     39B8 6365     
     39BA 3A20     
0233                       even
0234               
0235               txt.io.nofile
0236 39BC 16               byte  22
0237 39BD   4E             text  'No filename specified.'
     39BE 6F20     
     39C0 6669     
     39C2 6C65     
     39C4 6E61     
     39C6 6D65     
     39C8 2073     
     39CA 7065     
     39CC 6369     
     39CE 6669     
     39D0 6564     
     39D2 2E       
0238                       even
0239               
0240               txt.memfull.load
0241 39D4 2D               byte  45
0242 39D5   49             text  'Index full. File too large for editor buffer.'
     39D6 6E64     
     39D8 6578     
     39DA 2066     
     39DC 756C     
     39DE 6C2E     
     39E0 2046     
     39E2 696C     
     39E4 6520     
     39E6 746F     
     39E8 6F20     
     39EA 6C61     
     39EC 7267     
     39EE 6520     
     39F0 666F     
     39F2 7220     
     39F4 6564     
     39F6 6974     
     39F8 6F72     
     39FA 2062     
     39FC 7566     
     39FE 6665     
     3A00 722E     
0243                       even
0244               
0245               txt.block.inside
0246 3A02 2D               byte  45
0247 3A03   43             text  'Copy/Move target must be outside M1-M2 range.'
     3A04 6F70     
     3A06 792F     
     3A08 4D6F     
     3A0A 7665     
     3A0C 2074     
     3A0E 6172     
     3A10 6765     
     3A12 7420     
     3A14 6D75     
     3A16 7374     
     3A18 2062     
     3A1A 6520     
     3A1C 6F75     
     3A1E 7473     
     3A20 6964     
     3A22 6520     
     3A24 4D31     
     3A26 2D4D     
     3A28 3220     
     3A2A 7261     
     3A2C 6E67     
     3A2E 652E     
0248                       even
0249               
0250               
0251               ;--------------------------------------------------------------
0252               ; Strings for command buffer
0253               ;--------------------------------------------------------------
0254               txt.cmdb.prompt
0255 3A30 01               byte  1
0256 3A31   3E             text  '>'
0257                       even
0258               
0259               txt.colorscheme
0260 3A32 0D               byte  13
0261 3A33   43             text  'Color scheme:'
     3A34 6F6C     
     3A36 6F72     
     3A38 2073     
     3A3A 6368     
     3A3C 656D     
     3A3E 653A     
0262                       even
0263               
                   < ram.resident.asm
0033                       copy  "data.defaults.asm"      ; Default values (devices, ...)
     **** ****     > data.defaults.asm
0001               * FILE......: data.defaults.asm
0002               * Purpose...: Stevie Editor - data segment (default values)
0003               
0004               ***************************************************************
0005               *                     Default values
0006               ********|*****|*********************|**************************
0007               def.printer.fname
0008 3A40 06               byte  6
0009 3A41   50             text  'PI.PIO'
     3A42 492E     
     3A44 5049     
     3A46 4F       
0010                       even
0011               
0012               def.clip.fname
0013 3A48 09               byte  9
0014 3A49   44             text  'DSK1.CLIP'
     3A4A 534B     
     3A4C 312E     
     3A4E 434C     
     3A50 4950     
0015                       even
0016               
0017               def.clip.fname.b
0018 3A52 09               byte  9
0019 3A53   44             text  'DSK8.CLIP'
     3A54 534B     
     3A56 382E     
     3A58 434C     
     3A5A 4950     
0020                       even
0021               
0022               def.clip.fname.c
0023 3A5C 10               byte  16
0024 3A5D   54             text  'TIPI.STEVIE.CLIP'
     3A5E 4950     
     3A60 492E     
     3A62 5354     
     3A64 4556     
     3A66 4945     
     3A68 2E43     
     3A6A 4C49     
     3A6C 50       
0025                       even
0026               
                   < ram.resident.asm
                   < stevie_b3.asm.61108
0043                       ;------------------------------------------------------
0044                       ; Activate bank 1 and branch to  >6036
0045                       ;------------------------------------------------------
0046 3A6E 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3A70 6002     
0047               
0051               
0052 3A72 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3A74 6046     
0053               ***************************************************************
0054               * Step 3: Include main editor modules
0055               ********|*****|*********************|**************************
0056               main:
0057               
0058                       aorg  kickstart.code2       ; >6046
0059 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 2026     
0060                       ;-----------------------------------------------------------------------
0061                       ; Include files - Shared code
0062                       ;-----------------------------------------------------------------------
0063               
0064                       ;-----------------------------------------------------------------------
0065                       ; Include files - Dialogs
0066                       ;-----------------------------------------------------------------------
0067                       copy  "dialog.menu.asm"      ; Dialog "Stevie Menu"
     **** ****     > dialog.menu.asm
0001               * FILE......: dialog.menu.asm
0002               * Purpose...: Dialog "Main Menu"
0003               
0004               ***************************************************************
0005               * dialog.menu
0006               * Open Dialog "Main Menu"
0007               ***************************************************************
0008               * b @dialog.menu
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
0020               ********|*****|*********************|**************************
0021               dialog.menu:
0022 604A 0649  14         dect  stack
0023 604C C64B  30         mov   r11,*stack            ; Save return address
0024 604E 0649  14         dect  stack
0025 6050 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6052 0204  20         li    tmp0,id.dialog.menu
     6054 0064     
0030 6056 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6058 A71A     
0031               
0032 605A 0204  20         li    tmp0,txt.head.menu
     605C 7448     
0033 605E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6060 A71C     
0034               
0035 6062 0204  20         li    tmp0,txt.info.menu
     6064 7457     
0036 6066 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6068 A71E     
0037               
0038 606A 0204  20         li    tmp0,pos.info.menu
     606C 7472     
0039 606E C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     6070 A722     
0040               
0041 6072 0204  20         li    tmp0,txt.hint.menu
     6074 7477     
0042 6076 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6078 A720     
0043               
0044 607A 0204  20         li    tmp0,txt.keys.menu
     607C 747A     
0045 607E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6080 A724     
0046               
0047 6082 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6084 6E5E     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.menu.exit:
0052 6086 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6088 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 608A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0068                       copy  "dialog.help.asm"      ; Dialog "Help"
     **** ****     > dialog.help.asm
0001               * FILE......: dialog.help.asm
0002               * Purpose...: Stevie Editor - About dialog
0003               
0004               *---------------------------------------------------------------
0005               * Show Stevie welcome/about dialog
0006               *---------------------------------------------------------------
0007               dialog.help:
0008 608C 0649  14         dect  stack
0009 608E C64B  30         mov   r11,*stack            ; Save return address
0010                       ;-------------------------------------------------------
0011                       ; Setup dialog
0012                       ;-------------------------------------------------------
0013 6090 06A0  32         bl    @scroff               ; turn screen off
     6092 26A2     
0014               
0015 6094 0204  20         li    tmp0,id.dialog.help
     6096 0068     
0016 6098 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     609A A71A     
0017               
0018 609C 06A0  32         bl    @dialog.help.content  ; display content in modal dialog
     609E 60CC     
0019               
0020 60A0 0204  20         li    tmp0,txt.head.about
     60A2 73B2     
0021 60A4 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     60A6 A71C     
0022               
0023 60A8 0204  20         li    tmp0,txt.about.build
     60AA 73FA     
0024 60AC C804  38         mov   tmp0,@cmdb.paninfo    ; Info line
     60AE A71E     
0025 60B0 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     60B2 A722     
0026               
0027 60B4 0204  20         li    tmp0,txt.hint.about
     60B6 73BE     
0028 60B8 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     60BA A720     
0029               
0030 60BC 0204  20         li    tmp0,txt.keys.about
     60BE 73E6     
0031 60C0 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     60C2 A724     
0032               
0033 60C4 06A0  32         bl    @scron                ; Turn screen on
     60C6 26AA     
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               dialog.help.exit:
0038 60C8 C2F9  30         mov   *stack+,r11           ; Pop r11
0039 60CA 045B  20         b     *r11                  ; Return
0040               
0041               
0042               
0043               ***************************************************************
0044               * dialog.help.content
0045               * Show content in modal dialog
0046               ***************************************************************
0047               * bl  @dialog.help.content
0048               *--------------------------------------------------------------
0049               * OUTPUT
0050               * none
0051               *--------------------------------------------------------------
0052               * Register usage
0053               * tmp0
0054               ********|*****|*********************|**************************
0055               dialog.help.content:
0056 60CC 0649  14         dect  stack
0057 60CE C64B  30         mov   r11,*stack            ; Save return address
0058 60D0 0649  14         dect  stack
0059 60D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0060 60D4 0649  14         dect  stack
0061 60D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0062 60D8 0649  14         dect  stack
0063 60DA C646  30         mov   tmp2,*stack           ; Push tmp2
0064 60DC 0649  14         dect  stack
0065 60DE C660  46         mov   @wyx,*stack           ; Push cursor position
     60E0 832A     
0066                       ;------------------------------------------------------
0067                       ; Clear screen and set colors
0068                       ;------------------------------------------------------
0069 60E2 06A0  32         bl    @filv
     60E4 22A2     
0070 60E6 0050                   data vdp.fb.toprow.sit,32,vdp.sit.size - 160
     60E8 0020     
     60EA 08C0     
0071                                                   ; Clear screen
0072               
0073                       ;
0074                       ; Colours are also set in pane.action.colorscheme.load
0075                       ; but we also set them here to avoid flickering due to
0076                       ; timing delay before function is called.
0077                       ;
0078               
0079 60EC 0204  20         li    tmp0,vdp.fb.toprow.tat
     60EE 1850     
0080 60F0 C160  34         mov   @tv.color,tmp1        ; Get color for framebuffer
     60F2 A218     
0081 60F4 0985  56         srl   tmp1,8                ; Right justify
0082 60F6 0206  20         li    tmp2,vdp.sit.size - 160
     60F8 08C0     
0083                                                   ; Prepare for loading color attributes
0084               
0085 60FA 06A0  32         bl    @xfilv                ; \ Fill VDP memory
     60FC 22A8     
0086                                                   ; | i  tmp0 = Memory start address
0087                                                   ; | i  tmp1 = Byte to fill
0088                                                   ; / i  tmp2 = Number of bytes to fill
0089               
0090 60FE 06A0  32         bl    @filv
     6100 22A2     
0091 6102 2180                   data sprsat,>d0,32    ; Turn off sprites
     6104 00D0     
     6106 0020     
0092                       ;------------------------------------------------------
0093                       ; Display keyboard shortcuts (part 1)
0094                       ;------------------------------------------------------
0095 6108 0204  20         li    tmp0,>0100            ; Y=1, X=0
     610A 0100     
0096 610C C804  38         mov   tmp0,@wyx             ; Set cursor position
     610E 832A     
0097 6110 0205  20         li    tmp1,dialog.help.help.part1
     6112 613E     
0098                                                   ; Pointer to string
0099 6114 0206  20         li    tmp2,23               ; Set loop counter
     6116 0017     
0100               
0101 6118 06A0  32         bl    @putlst               ; Loop over string list and display
     611A 245E     
0102                                                   ; \ i  @wyx = Cursor position
0103                                                   ; | i  tmp1 = Pointer to first length-
0104                                                   ; |           prefixed string in list
0105                                                   ; / i  tmp2 = Number of strings to display
0106               
0107                       ;------------------------------------------------------
0108                       ; Display keyboard shortcuts (part 2)
0109                       ;------------------------------------------------------
0110 611C 0204  20         li    tmp0,>012a            ; Y=1, X=42
     611E 012A     
0111 6120 C804  38         mov   tmp0,@wyx             ; Set cursor position
     6122 832A     
0112 6124 0205  20         li    tmp1,dialog.help.help.part2
     6126 6362     
0113                                                   ; Pointer to string
0114 6128 0206  20         li    tmp2,24               ; Set loop counter
     612A 0018     
0115               
0116 612C 06A0  32         bl    @putlst               ; Loop over string list and display
     612E 245E     
0117                                                   ; \ i  @wyx = Cursor position
0118                                                   ; | i  tmp1 = Pointer to first length-
0119                                                   ; |           prefixed string in list
0120                                                   ; / i  tmp2 = Number of strings to display
0121               
0122                       ;------------------------------------------------------
0123                       ; Exit
0124                       ;------------------------------------------------------
0125               dialog.help.content.exit:
0126 6130 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     6132 832A     
0127 6134 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0128 6136 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0129 6138 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0130 613A C2F9  30         mov   *stack+,r11           ; Pop r11
0131 613C 045B  20         b     *r11                  ; Return
0132               
0133               
0134               
0135               dialog.help.help.part1:
0136               
0137 613E 23               byte  35
0138 613F   2D             text  '------------- Cursor --------------'
     6140 2D2D     
     6142 2D2D     
     6144 2D2D     
     6146 2D2D     
     6148 2D2D     
     614A 2D2D     
     614C 2043     
     614E 7572     
     6150 736F     
     6152 7220     
     6154 2D2D     
     6156 2D2D     
     6158 2D2D     
     615A 2D2D     
     615C 2D2D     
     615E 2D2D     
     6160 2D2D     
0139                       even
0140               
0141               
0142 6162 12               byte  18
0143 6163   46             text  'Fctn s        Left'
     6164 6374     
     6166 6E20     
     6168 7320     
     616A 2020     
     616C 2020     
     616E 2020     
     6170 204C     
     6172 6566     
     6174 74       
0144                       even
0145               
0146               
0147 6176 13               byte  19
0148 6177   46             text  'Fctn d        Right'
     6178 6374     
     617A 6E20     
     617C 6420     
     617E 2020     
     6180 2020     
     6182 2020     
     6184 2052     
     6186 6967     
     6188 6874     
0149                       even
0150               
0151               
0152 618A 10               byte  16
0153 618B   46             text  'Fctn e        Up'
     618C 6374     
     618E 6E20     
     6190 6520     
     6192 2020     
     6194 2020     
     6196 2020     
     6198 2055     
     619A 70       
0154                       even
0155               
0156               
0157 619C 12               byte  18
0158 619D   46             text  'Fctn x        Down'
     619E 6374     
     61A0 6E20     
     61A2 7820     
     61A4 2020     
     61A6 2020     
     61A8 2020     
     61AA 2044     
     61AC 6F77     
     61AE 6E       
0159                       even
0160               
0161               
0162 61B0 12               byte  18
0163 61B1   46             text  'Fctn h        Home'
     61B2 6374     
     61B4 6E20     
     61B6 6820     
     61B8 2020     
     61BA 2020     
     61BC 2020     
     61BE 2048     
     61C0 6F6D     
     61C2 65       
0164                       even
0165               
0166               
0167 61C4 11               byte  17
0168 61C5   46             text  'Fctn l        End'
     61C6 6374     
     61C8 6E20     
     61CA 6C20     
     61CC 2020     
     61CE 2020     
     61D0 2020     
     61D2 2045     
     61D4 6E64     
0169                       even
0170               
0171               
0172 61D6 17               byte  23
0173 61D7   46             text  'Fctn j        Prev word'
     61D8 6374     
     61DA 6E20     
     61DC 6A20     
     61DE 2020     
     61E0 2020     
     61E2 2020     
     61E4 2050     
     61E6 7265     
     61E8 7620     
     61EA 776F     
     61EC 7264     
0174                       even
0175               
0176               
0177 61EE 17               byte  23
0178 61EF   46             text  'Fctn k        Next word'
     61F0 6374     
     61F2 6E20     
     61F4 6B20     
     61F6 2020     
     61F8 2020     
     61FA 2020     
     61FC 204E     
     61FE 6578     
     6200 7420     
     6202 776F     
     6204 7264     
0179                       even
0180               
0181               
0182 6206 16               byte  22
0183 6207   46             text  'Fctn 7   ^t   Next tab'
     6208 6374     
     620A 6E20     
     620C 3720     
     620E 2020     
     6210 5E74     
     6212 2020     
     6214 204E     
     6216 6578     
     6218 7420     
     621A 7461     
     621C 62       
0184                       even
0185               
0186               
0187 621E 15               byte  21
0188 621F   46             text  'Fctn 6   ^e   Page up'
     6220 6374     
     6222 6E20     
     6224 3620     
     6226 2020     
     6228 5E65     
     622A 2020     
     622C 2050     
     622E 6167     
     6230 6520     
     6232 7570     
0189                       even
0190               
0191               
0192 6234 17               byte  23
0193 6235   46             text  'Fctn 4   ^x   Page down'
     6236 6374     
     6238 6E20     
     623A 3420     
     623C 2020     
     623E 5E78     
     6240 2020     
     6242 2050     
     6244 6167     
     6246 6520     
     6248 646F     
     624A 776E     
0194                       even
0195               
0196               
0197 624C 18               byte  24
0198 624D   46             text  'Fctn v        Screen top'
     624E 6374     
     6250 6E20     
     6252 7620     
     6254 2020     
     6256 2020     
     6258 2020     
     625A 2053     
     625C 6372     
     625E 6565     
     6260 6E20     
     6262 746F     
     6264 70       
0199                       even
0200               
0201               
0202 6266 1B               byte  27
0203 6267   46             text  'Fctn b        Screen bottom'
     6268 6374     
     626A 6E20     
     626C 6220     
     626E 2020     
     6270 2020     
     6272 2020     
     6274 2053     
     6276 6372     
     6278 6565     
     627A 6E20     
     627C 626F     
     627E 7474     
     6280 6F6D     
0204                       even
0205               
0206               
0207 6282 16               byte  22
0208 6283   43             text  'Ctrl v   ^v   File top'
     6284 7472     
     6286 6C20     
     6288 7620     
     628A 2020     
     628C 5E76     
     628E 2020     
     6290 2046     
     6292 696C     
     6294 6520     
     6296 746F     
     6298 70       
0209                       even
0210               
0211               
0212 629A 19               byte  25
0213 629B   43             text  'Ctrl b   ^b   File bottom'
     629C 7472     
     629E 6C20     
     62A0 6220     
     62A2 2020     
     62A4 5E62     
     62A6 2020     
     62A8 2046     
     62AA 696C     
     62AC 6520     
     62AE 626F     
     62B0 7474     
     62B2 6F6D     
0214                       even
0215               
0216               
0217               
0218 62B4 01               byte  1
0219 62B5   20             text  ' '
0220                       even
0221               
0222               
0223 62B6 23               byte  35
0224 62B7   2D             text  '------------- Others --------------'
     62B8 2D2D     
     62BA 2D2D     
     62BC 2D2D     
     62BE 2D2D     
     62C0 2D2D     
     62C2 2D2D     
     62C4 204F     
     62C6 7468     
     62C8 6572     
     62CA 7320     
     62CC 2D2D     
     62CE 2D2D     
     62D0 2D2D     
     62D2 2D2D     
     62D4 2D2D     
     62D6 2D2D     
     62D8 2D2D     
0225                       even
0226               
0227               
0228 62DA 12               byte  18
0229 62DB   46             text  'Fctn +   ^q   Quit'
     62DC 6374     
     62DE 6E20     
     62E0 2B20     
     62E2 2020     
     62E4 5E71     
     62E6 2020     
     62E8 2051     
     62EA 7569     
     62EC 74       
0230                       even
0231               
0232               
0233 62EE 12               byte  18
0234 62EF   43             text  'Ctrl h   ^h   Help'
     62F0 7472     
     62F2 6C20     
     62F4 6820     
     62F6 2020     
     62F8 5E68     
     62FA 2020     
     62FC 2048     
     62FE 656C     
     6300 70       
0235                       even
0236               
0237               
0238 6302 1A               byte  26
0239 6303   63             text  'ctrl u   ^u   Toggle ruler'
     6304 7472     
     6306 6C20     
     6308 7520     
     630A 2020     
     630C 5E75     
     630E 2020     
     6310 2054     
     6312 6F67     
     6314 676C     
     6316 6520     
     6318 7275     
     631A 6C65     
     631C 72       
0240                       even
0241               
0242               
0243 631E 21               byte  33
0244 631F   43             text  'Ctrl z   ^z   Cycle color schemes'
     6320 7472     
     6322 6C20     
     6324 7A20     
     6326 2020     
     6328 5E7A     
     632A 2020     
     632C 2043     
     632E 7963     
     6330 6C65     
     6332 2063     
     6334 6F6C     
     6336 6F72     
     6338 2073     
     633A 6368     
     633C 656D     
     633E 6573     
0245                       even
0246               
0247               
0248 6340 20               byte  32
0249 6341   63             text  'ctrl /   ^/   TI Basic (F9=exit)'
     6342 7472     
     6344 6C20     
     6346 2F20     
     6348 2020     
     634A 5E2F     
     634C 2020     
     634E 2054     
     6350 4920     
     6352 4261     
     6354 7369     
     6356 6320     
     6358 2846     
     635A 393D     
     635C 6578     
     635E 6974     
     6360 29       
0250                       even
0251               
0252               
0253               dialog.help.help.part2:
0254               
0255 6362 23               byte  35
0256 6363   2D             text  '------------- File ----------------'
     6364 2D2D     
     6366 2D2D     
     6368 2D2D     
     636A 2D2D     
     636C 2D2D     
     636E 2D2D     
     6370 2046     
     6372 696C     
     6374 6520     
     6376 2D2D     
     6378 2D2D     
     637A 2D2D     
     637C 2D2D     
     637E 2D2D     
     6380 2D2D     
     6382 2D2D     
     6384 2D2D     
0257                       even
0258               
0259               
0260 6386 21               byte  33
0261 6387   43             text  'Ctrl i   ^i   Insert file at line'
     6388 7472     
     638A 6C20     
     638C 6920     
     638E 2020     
     6390 5E69     
     6392 2020     
     6394 2049     
     6396 6E73     
     6398 6572     
     639A 7420     
     639C 6669     
     639E 6C65     
     63A0 2061     
     63A2 7420     
     63A4 6C69     
     63A6 6E65     
0262                       even
0263               
0264               
0265 63A8 24               byte  36
0266 63A9   43             text  'Ctrl c   ^c   Copy clipboard to line'
     63AA 7472     
     63AC 6C20     
     63AE 6320     
     63B0 2020     
     63B2 5E63     
     63B4 2020     
     63B6 2043     
     63B8 6F70     
     63BA 7920     
     63BC 636C     
     63BE 6970     
     63C0 626F     
     63C2 6172     
     63C4 6420     
     63C6 746F     
     63C8 206C     
     63CA 696E     
     63CC 65       
0267                       even
0268               
0269               
0270 63CE 17               byte  23
0271 63CF   43             text  'Ctrl o   ^o   Open file'
     63D0 7472     
     63D2 6C20     
     63D4 6F20     
     63D6 2020     
     63D8 5E6F     
     63DA 2020     
     63DC 204F     
     63DE 7065     
     63E0 6E20     
     63E2 6669     
     63E4 6C65     
0272                       even
0273               
0274               
0275 63E6 18               byte  24
0276 63E7   43             text  'Ctrl p   ^p   Print file'
     63E8 7472     
     63EA 6C20     
     63EC 7020     
     63EE 2020     
     63F0 5E70     
     63F2 2020     
     63F4 2050     
     63F6 7269     
     63F8 6E74     
     63FA 2066     
     63FC 696C     
     63FE 65       
0277                       even
0278               
0279               
0280 6400 17               byte  23
0281 6401   43             text  'Ctrl s   ^s   Save file'
     6402 7472     
     6404 6C20     
     6406 7320     
     6408 2020     
     640A 5E73     
     640C 2020     
     640E 2053     
     6410 6176     
     6412 6520     
     6414 6669     
     6416 6C65     
0282                       even
0283               
0284               
0285 6418 1C               byte  28
0286 6419   43             text  'Ctrl ,   ^,   Load prev file'
     641A 7472     
     641C 6C20     
     641E 2C20     
     6420 2020     
     6422 5E2C     
     6424 2020     
     6426 204C     
     6428 6F61     
     642A 6420     
     642C 7072     
     642E 6576     
     6430 2066     
     6432 696C     
     6434 65       
0287                       even
0288               
0289               
0290 6436 1C               byte  28
0291 6437   43             text  'Ctrl .   ^.   Load next file'
     6438 7472     
     643A 6C20     
     643C 2E20     
     643E 2020     
     6440 5E2E     
     6442 2020     
     6444 204C     
     6446 6F61     
     6448 6420     
     644A 6E65     
     644C 7874     
     644E 2066     
     6450 696C     
     6452 65       
0292                       even
0293               
0294               
0295 6454 23               byte  35
0296 6455   2D             text  '------------- Block mode ----------'
     6456 2D2D     
     6458 2D2D     
     645A 2D2D     
     645C 2D2D     
     645E 2D2D     
     6460 2D2D     
     6462 2042     
     6464 6C6F     
     6466 636B     
     6468 206D     
     646A 6F64     
     646C 6520     
     646E 2D2D     
     6470 2D2D     
     6472 2D2D     
     6474 2D2D     
     6476 2D2D     
0297                       even
0298               
0299               
0300 6478 1E               byte  30
0301 6479   43             text  'Ctrl SPACE    Set M1/M2 marker'
     647A 7472     
     647C 6C20     
     647E 5350     
     6480 4143     
     6482 4520     
     6484 2020     
     6486 2053     
     6488 6574     
     648A 204D     
     648C 312F     
     648E 4D32     
     6490 206D     
     6492 6172     
     6494 6B65     
     6496 72       
0302                       even
0303               
0304               
0305 6498 1A               byte  26
0306 6499   43             text  'Ctrl d   ^d   Delete block'
     649A 7472     
     649C 6C20     
     649E 6420     
     64A0 2020     
     64A2 5E64     
     64A4 2020     
     64A6 2044     
     64A8 656C     
     64AA 6574     
     64AC 6520     
     64AE 626C     
     64B0 6F63     
     64B2 6B       
0307                       even
0308               
0309               
0310 64B4 18               byte  24
0311 64B5   43             text  'Ctrl c   ^c   Copy block'
     64B6 7472     
     64B8 6C20     
     64BA 6320     
     64BC 2020     
     64BE 5E63     
     64C0 2020     
     64C2 2043     
     64C4 6F70     
     64C6 7920     
     64C8 626C     
     64CA 6F63     
     64CC 6B       
0312                       even
0313               
0314               
0315 64CE 1C               byte  28
0316 64CF   43             text  'Ctrl g   ^g   Goto marker M1'
     64D0 7472     
     64D2 6C20     
     64D4 6720     
     64D6 2020     
     64D8 5E67     
     64DA 2020     
     64DC 2047     
     64DE 6F74     
     64E0 6F20     
     64E2 6D61     
     64E4 726B     
     64E6 6572     
     64E8 204D     
     64EA 31       
0317                       even
0318               
0319               
0320 64EC 18               byte  24
0321 64ED   43             text  'Ctrl m   ^m   Move block'
     64EE 7472     
     64F0 6C20     
     64F2 6D20     
     64F4 2020     
     64F6 5E6D     
     64F8 2020     
     64FA 204D     
     64FC 6F76     
     64FE 6520     
     6500 626C     
     6502 6F63     
     6504 6B       
0322                       even
0323               
0324               
0325 6506 20               byte  32
0326 6507   43             text  'Ctrl s   ^s   Save block to file'
     6508 7472     
     650A 6C20     
     650C 7320     
     650E 2020     
     6510 5E73     
     6512 2020     
     6514 2053     
     6516 6176     
     6518 6520     
     651A 626C     
     651C 6F63     
     651E 6B20     
     6520 746F     
     6522 2066     
     6524 696C     
     6526 65       
0327                       even
0328               
0329               
0330 6528 23               byte  35
0331 6529   43             text  'Ctrl ^1..^5   Copy to clipboard 1-5'
     652A 7472     
     652C 6C20     
     652E 5E31     
     6530 2E2E     
     6532 5E35     
     6534 2020     
     6536 2043     
     6538 6F70     
     653A 7920     
     653C 746F     
     653E 2063     
     6540 6C69     
     6542 7062     
     6544 6F61     
     6546 7264     
     6548 2031     
     654A 2D35     
0332                       even
0333               
0334               
0335 654C 01               byte  1
0336 654D   20             text  ' '
0337                       even
0338               
0339               
0340 654E 23               byte  35
0341 654F   2D             text  '------------- Modifiers -----------'
     6550 2D2D     
     6552 2D2D     
     6554 2D2D     
     6556 2D2D     
     6558 2D2D     
     655A 2D2D     
     655C 204D     
     655E 6F64     
     6560 6966     
     6562 6965     
     6564 7273     
     6566 202D     
     6568 2D2D     
     656A 2D2D     
     656C 2D2D     
     656E 2D2D     
     6570 2D2D     
0342                       even
0343               
0344               
0345 6572 1E               byte  30
0346 6573   46             text  'Fctn 1        Delete character'
     6574 6374     
     6576 6E20     
     6578 3120     
     657A 2020     
     657C 2020     
     657E 2020     
     6580 2044     
     6582 656C     
     6584 6574     
     6586 6520     
     6588 6368     
     658A 6172     
     658C 6163     
     658E 7465     
     6590 72       
0347                       even
0348               
0349               
0350 6592 1E               byte  30
0351 6593   46             text  'Fctn 2        Insert character'
     6594 6374     
     6596 6E20     
     6598 3220     
     659A 2020     
     659C 2020     
     659E 2020     
     65A0 2049     
     65A2 6E73     
     65A4 6572     
     65A6 7420     
     65A8 6368     
     65AA 6172     
     65AC 6163     
     65AE 7465     
     65B0 72       
0352                       even
0353               
0354               
0355 65B2 19               byte  25
0356 65B3   46             text  'Fctn 3        Delete line'
     65B4 6374     
     65B6 6E20     
     65B8 3320     
     65BA 2020     
     65BC 2020     
     65BE 2020     
     65C0 2044     
     65C2 656C     
     65C4 6574     
     65C6 6520     
     65C8 6C69     
     65CA 6E65     
0357                       even
0358               
0359               
0360 65CC 20               byte  32
0361 65CD   43             text  'Ctrl l   ^l   Delete end of line'
     65CE 7472     
     65D0 6C20     
     65D2 6C20     
     65D4 2020     
     65D6 5E6C     
     65D8 2020     
     65DA 2044     
     65DC 656C     
     65DE 6574     
     65E0 6520     
     65E2 656E     
     65E4 6420     
     65E6 6F66     
     65E8 206C     
     65EA 696E     
     65EC 65       
0362                       even
0363               
0364               
0365 65EE 19               byte  25
0366 65EF   46             text  'Fctn 8        Insert line'
     65F0 6374     
     65F2 6E20     
     65F4 3820     
     65F6 2020     
     65F8 2020     
     65FA 2020     
     65FC 2049     
     65FE 6E73     
     6600 6572     
     6602 7420     
     6604 6C69     
     6606 6E65     
0367                       even
0368               
0369               
0370 6608 1E               byte  30
0371 6609   46             text  'Fctn .        Insert/Overwrite'
     660A 6374     
     660C 6E20     
     660E 2E20     
     6610 2020     
     6612 2020     
     6614 2020     
     6616 2049     
     6618 6E73     
     661A 6572     
     661C 742F     
     661E 4F76     
     6620 6572     
     6622 7772     
     6624 6974     
     6626 65       
0372                       even
0373               
                   < stevie_b3.asm.61108
0069                       copy  "dialog.file.asm"      ; Dialog "File"
     **** ****     > dialog.file.asm
0001               * FILE......: dialog.file.asm
0002               * Purpose...: Dialog "File"
0003               
0004               ***************************************************************
0005               * dialog.file
0006               * Open Dialog "File"
0007               ***************************************************************
0008               * b @dialog.file
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
0020               ********|*****|*********************|**************************
0021               dialog.file:
0022 6628 0649  14         dect  stack
0023 662A C64B  30         mov   r11,*stack            ; Save return address
0024 662C 0649  14         dect  stack
0025 662E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6630 0204  20         li    tmp0,id.dialog.file
     6632 0069     
0030 6634 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6636 A71A     
0031               
0032 6638 0204  20         li    tmp0,txt.head.file
     663A 7482     
0033 663C C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     663E A71C     
0034               
0035 6640 0204  20         li    tmp0,txt.info.file
     6642 748C     
0036 6644 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6646 A71E     
0037               
0038 6648 0204  20         li    tmp0,pos.info.file
     664A 74B2     
0039 664C C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     664E A722     
0040               
0041 6650 0204  20         li    tmp0,txt.hint.file
     6652 74B8     
0042 6654 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6656 A720     
0043               
0044 6658 0204  20         li    tmp0,txt.keys.file
     665A 74BA     
0045 665C C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     665E A724     
0046               
0047 6660 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6662 6E5E     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.file.exit:
0052 6664 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6666 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 6668 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0070                       copy  "dialog.config.asm"    ; Dialog "Configure"
     **** ****     > dialog.config.asm
0001               * FILE......: dialog.config.asm
0002               * Purpose...: Dialog "Configure"
0003               
0004               ***************************************************************
0005               * dialog.config
0006               * Open Dialog "Configure"
0007               ***************************************************************
0008               * b @dialog.config
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
0020               ********|*****|*********************|**************************
0021               dialog.config:
0022 666A 0649  14         dect  stack
0023 666C C64B  30         mov   r11,*stack            ; Save return address
0024 666E 0649  14         dect  stack
0025 6670 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6672 0204  20         li    tmp0,id.dialog.config
     6674 006B     
0030 6676 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6678 A71A     
0031               
0032 667A 0204  20         li    tmp0,txt.head.config
     667C 74FC     
0033 667E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6680 A71C     
0034               
0035 6682 0204  20         li    tmp0,txt.info.config
     6684 750B     
0036 6686 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6688 A71E     
0037               
0038 668A 0204  20         li    tmp0,pos.info.config
     668C 7516     
0039 668E C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     6690 A722     
0040               
0041 6692 0204  20         li    tmp0,txt.hint.config
     6694 7518     
0042 6696 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6698 A720     
0043               
0044 669A 0204  20         li    tmp0,txt.keys.config
     669C 751A     
0045 669E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     66A0 A724     
0046               
0047 66A2 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     66A4 6E5E     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.config.exit:
0052 66A6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 66A8 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 66AA 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0071                       copy  "dialog.load.asm"      ; Dialog "Load file"
     **** ****     > dialog.load.asm
0001               * FILE......: dialog.load.asm
0002               * Purpose...: Dialog "Load DV80 file"
0003               
0004               ***************************************************************
0005               * dialog.load
0006               * Open Dialog for loading DV 80 file
0007               ***************************************************************
0008               * b @dialog.load
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
0020               ********|*****|*********************|**************************
0021               dialog.load:
0022 66AC 0649  14         dect  stack
0023 66AE C64B  30         mov   r11,*stack            ; Save return address
0024 66B0 0649  14         dect  stack
0025 66B2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Show dialog "Unsaved changes" if editor buffer dirty
0028                       ;-------------------------------------------------------
0029 66B4 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     66B6 A506     
0030 66B8 1303  14         jeq   dialog.load.setup     ; No, skip "Unsaved changes"
0031               
0032 66BA 06A0  32         bl    @dialog.unsaved       ; Show dialog
     66BC 6962     
0033 66BE 1025  14         jmp   dialog.load.exit      ; Exit early
0034                       ;-------------------------------------------------------
0035                       ; Setup dialog
0036                       ;-------------------------------------------------------
0037               dialog.load.setup:
0038 66C0 0204  20         li    tmp0,id.dialog.load
     66C2 000A     
0039 66C4 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     66C6 A71A     
0040               
0041 66C8 0204  20         li    tmp0,txt.head.load
     66CA 702B     
0042 66CC C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     66CE A71C     
0043               
0044 66D0 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     66D2 A71E     
0045 66D4 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     66D6 A722     
0046               
0047 66D8 0204  20         li    tmp0,txt.hint.load
     66DA 703A     
0048 66DC C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     66DE A720     
0049               
0050 66E0 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     66E2 A44E     
0051 66E4 1303  14         jeq   !
0052                       ;-------------------------------------------------------
0053                       ; Show that FastMode is on
0054                       ;-------------------------------------------------------
0055 66E6 0204  20         li    tmp0,txt.keys.load2   ; Highlight FastMode
     66E8 707A     
0056 66EA 1002  14         jmp   dialog.load.keylist
0057                       ;-------------------------------------------------------
0058                       ; Show that FastMode is off
0059                       ;-------------------------------------------------------
0060 66EC 0204  20 !       li    tmp0,txt.keys.load
     66EE 705A     
0061                       ;-------------------------------------------------------
0062                       ; Show dialog
0063                       ;-------------------------------------------------------
0064               dialog.load.keylist:
0065 66F0 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     66F2 A724     
0066                       ;-------------------------------------------------------
0067                       ; Set command line
0068                       ;-------------------------------------------------------
0069 66F4 0204  20         li    tmp0,edb.filename     ; Set filename
     66F6 A51A     
0070 66F8 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     66FA A000     
0071               
0072 66FC 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     66FE 6CCE     
0073                                                   ; \ i  @parm1 = Pointer to string w. preset
0074                                                   ; /
0075                       ;-------------------------------------------------------
0076                       ; Set cursor shape
0077                       ;-------------------------------------------------------
0078 6700 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6702 6E4C     
0079 6704 C820  54         mov   @tv.curshape,@ramsat+2
     6706 A214     
     6708 A1E2     
0080                                                   ; Get cursor shape and color
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               dialog.load.exit:
0085 670A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0086 670C C2F9  30         mov   *stack+,r11           ; Pop R11
0087 670E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0072                       copy  "dialog.save.asm"      ; Dialog "Save file"
     **** ****     > dialog.save.asm
0001               * FILE......: dialog.save.asm
0002               * Purpose...: Dialog "Save DV80 file"
0003               
0004               ***************************************************************
0005               * dialog.save
0006               * Open Dialog for saving file
0007               ***************************************************************
0008               * b @dialog.save
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
0020               ********|*****|*********************|**************************
0021               dialog.save:
0022 6710 0649  14         dect  stack
0023 6712 C64B  30         mov   r11,*stack            ; Save return address
0024 6714 0649  14         dect  stack
0025 6716 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029 6718 8820  54         c     @fb.row.dirty,@w$ffff
     671A A30A     
     671C 2022     
0030 671E 1604  14         jne   !                     ; Skip crunching if clean
0031 6720 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6722 6DF2     
0032 6724 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6726 A30A     
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036 6728 8820  54 !       c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     672A A50E     
     672C 2022     
0037 672E 130B  14         jeq   dialog.save.default   ; Yes, so show default dialog
0038                       ;-------------------------------------------------------
0039                       ; Setup dialog title
0040                       ;-------------------------------------------------------
0041 6730 06A0  32         bl    @cmdb.cmd.clear       ; Clear current CMDB command
     6732 6C86     
0042               
0043 6734 0204  20         li    tmp0,id.dialog.saveblock
     6736 000C     
0044 6738 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     673A A71A     
0045 673C 0204  20         li    tmp0,txt.head.save2   ; Title "Save block to file"
     673E 70A9     
0046 6740 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6742 A71C     
0047 6744 100E  14         jmp   dialog.save.header
0048                       ;-------------------------------------------------------
0049                       ; Default dialog
0050                       ;-------------------------------------------------------
0051               dialog.save.default:
0052 6746 0204  20         li    tmp0,id.dialog.save
     6748 000B     
0053 674A C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     674C A71A     
0054 674E 0204  20         li    tmp0,txt.head.save    ; Title "Save file"
     6750 709A     
0055 6752 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6754 A71C     
0056                       ;-------------------------------------------------------
0057                       ; Set command line
0058                       ;-------------------------------------------------------
0059 6756 0204  20         li    tmp0,edb.filename     ; Set filename
     6758 A51A     
0060 675A C804  38         mov   tmp0,@parm1           ; Get pointer to string
     675C A000     
0061               
0062 675E 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6760 6CCE     
0063                                                   ; \ i  @parm1 = Pointer to string w. preset
0064                                                   ; /
0065                       ;-------------------------------------------------------
0066                       ; Setup header
0067                       ;-------------------------------------------------------
0068               dialog.save.header:
0069               
0070 6762 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     6764 A71E     
0071 6766 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6768 A722     
0072               
0073 676A 0204  20         li    tmp0,txt.hint.save
     676C 70C1     
0074 676E C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6770 A720     
0075               
0076 6772 0204  20         li    tmp0,txt.keys.save
     6774 70E0     
0077 6776 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6778 A724     
0078               
0079 677A 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     677C A44E     
0080                       ;-------------------------------------------------------
0081                       ; Set cursor shape
0082                       ;-------------------------------------------------------
0083 677E 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6780 6E4C     
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               dialog.save.exit:
0088 6782 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 6784 C2F9  30         mov   *stack+,r11           ; Pop R11
0090 6786 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0073                       copy  "dialog.print.asm"     ; Dialog "Print file"
     **** ****     > dialog.print.asm
0001               * FILE......: dialog.print.asm
0002               * Purpose...: Dialog "Print file"
0003               
0004               ***************************************************************
0005               * dialog.print
0006               * Open Dialog for printing file
0007               ***************************************************************
0008               * b @dialog.print
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
0020               ********|*****|*********************|**************************
0021               dialog.print:
0022 6788 0649  14         dect  stack
0023 678A C64B  30         mov   r11,*stack            ; Save return address
0024 678C 0649  14         dect  stack
0025 678E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029 6790 8820  54         c     @fb.row.dirty,@w$ffff
     6792 A30A     
     6794 2022     
0030 6796 1604  14         jne   !                     ; Skip crunching if clean
0031 6798 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     679A 6DF2     
0032 679C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     679E A30A     
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036 67A0 8820  54 !       c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67A2 A50E     
     67A4 2022     
0037 67A6 1307  14         jeq   dialog.print.default  ; Yes, so show default dialog
0038                       ;-------------------------------------------------------
0039                       ; Setup dialog title
0040                       ;-------------------------------------------------------
0041 67A8 0204  20         li    tmp0,id.dialog.printblock
     67AA 000F     
0042 67AC C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     67AE A71A     
0043 67B0 0204  20         li    tmp0,txt.head.print2  ; Title "Print block to file"
     67B2 72CC     
0044               
0045 67B4 1006  14         jmp   dialog.print.header
0046                       ;-------------------------------------------------------
0047                       ; Default dialog
0048                       ;-------------------------------------------------------
0049               dialog.print.default:
0050 67B6 0204  20         li    tmp0,id.dialog.print
     67B8 000E     
0051 67BA C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     67BC A71A     
0052 67BE 0204  20         li    tmp0,txt.head.print   ; Title "Print file"
     67C0 72BC     
0053                       ;-------------------------------------------------------
0054                       ; Setup header
0055                       ;-------------------------------------------------------
0056               dialog.print.header:
0057 67C2 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     67C4 A71C     
0058               
0059 67C6 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     67C8 A71E     
0060 67CA 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     67CC A722     
0061               
0062 67CE 0204  20         li    tmp0,txt.hint.print
     67D0 72DD     
0063 67D2 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     67D4 A720     
0064               
0065 67D6 0204  20         li    tmp0,txt.keys.save
     67D8 70E0     
0066 67DA C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     67DC A724     
0067               
0068 67DE 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     67E0 A44E     
0069                       ;-------------------------------------------------------
0070                       ; Set command line
0071                       ;-------------------------------------------------------
0072 67E2 0204  20         li    tmp0,tv.printer.fname ; Set printer name
     67E4 D960     
0073 67E6 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     67E8 A000     
0074               
0075 67EA 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     67EC 6CCE     
0076                                                   ; \ i  @parm1 = Pointer to string w. preset
0077                                                   ; /
0078                       ;-------------------------------------------------------
0079                       ; Set cursor shape
0080                       ;-------------------------------------------------------
0081 67EE 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     67F0 6E4C     
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               dialog.print.exit:
0086 67F2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 67F4 C2F9  30         mov   *stack+,r11           ; Pop R11
0088 67F6 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0074                       copy  "dialog.insert.asm"    ; Dialog "Insert file at line"
     **** ****     > dialog.insert.asm
0001               * FILE......: dialog.insert.asm
0002               * Purpose...: Dialog "Insert DV80 file"
0003               
0004               ***************************************************************
0005               * dialog.insert
0006               * Open Dialog for inserting DV 80 file
0007               ***************************************************************
0008               * b @dialog.insert
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
0020               ********|*****|*********************|**************************
0021               dialog.insert:
0022 67F8 0649  14         dect  stack
0023 67FA C64B  30         mov   r11,*stack            ; Save return address
0024 67FC 0649  14         dect  stack
0025 67FE C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029               dialog.insert.setup:
0030 6800 0204  20         li    tmp0,id.dialog.insert
     6802 000D     
0031 6804 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6806 A71A     
0032                       ;------------------------------------------------------
0033                       ; Include line number in pane header
0034                       ;------------------------------------------------------
0035 6808 06A0  32         bl    @film
     680A 224A     
0036 680C A77A                   data cmdb.panhead.buf,>00,80
     680E 0000     
     6810 0050     
0037                                                   ; Clear pane header buffer
0038               
0039 6812 06A0  32         bl    @cpym2m
     6814 24EE     
0040 6816 70F2                   data txt.head.insert,cmdb.panhead.buf,25
     6818 A77A     
     681A 0019     
0041               
0042 681C C820  54         mov   @fb.row,@parm1
     681E A306     
     6820 A000     
0043 6822 06A0  32         bl    @fb.row2line          ; Row to editor line
     6824 6E28     
0044                                                   ; \ i @fb.topline = Top line in frame buffer
0045                                                   ; | i @parm1      = Row in frame buffer
0046                                                   ; / o @outparm1   = Matching line in EB
0047               
0048 6826 05A0  34         inc   @outparm1             ; Add base 1
     6828 A010     
0049               
0050 682A 06A0  32         bl    @mknum                ; Convert integer to string
     682C 2AAA     
0051 682E A010                   data  outparm1        ; \ i  p0 = Pointer to 16 bit unsigned int
0052 6830 A140                   data  rambuf          ; | i  p1 = Pointer to 5 byte string buffer
0053 6832 30                     byte  48              ; | i  p2 = MSB offset for ASCII digit
0054 6833   30                   byte  48              ; / i  p2 = LSB char for replacing leading 0
0055               
0056 6834 06A0  32         bl    @cpym2m
     6836 24EE     
0057 6838 A140                   data rambuf,cmdb.panhead.buf + 24,5
     683A A792     
     683C 0005     
0058                                                   ; Add line number to buffer
0059               
0060 683E 0204  20         li    tmp0,29
     6840 001D     
0061 6842 0A84  56         sla   tmp0,8
0062 6844 D804  38         movb  tmp0,@cmdb.panhead.buf ; Set length byte
     6846 A77A     
0063               
0064 6848 0204  20         li    tmp0,cmdb.panhead.buf
     684A A77A     
0065 684C C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     684E A71C     
0066                       ;------------------------------------------------------
0067                       ; Other panel strings
0068                       ;------------------------------------------------------
0069 6850 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     6852 A71E     
0070 6854 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6856 A722     
0071               
0072 6858 0204  20         li    tmp0,txt.hint.insert
     685A 710B     
0073 685C C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     685E A720     
0074               
0075 6860 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6862 6C86     
0076               
0077 6864 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6866 A44E     
0078 6868 1303  14         jeq   !
0079                       ;-------------------------------------------------------
0080                       ; Show that FastMode is on
0081                       ;-------------------------------------------------------
0082 686A 0204  20         li    tmp0,txt.keys.insert  ; Highlight FastMode
     686C 712C     
0083 686E 1002  14         jmp   dialog.insert.keylist
0084                       ;-------------------------------------------------------
0085                       ; Show that FastMode is off
0086                       ;-------------------------------------------------------
0087 6870 0204  20 !       li    tmp0,txt.keys.insert
     6872 712C     
0088                       ;-------------------------------------------------------
0089                       ; Show dialog
0090                       ;-------------------------------------------------------
0091               dialog.insert.keylist:
0092 6874 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6876 A724     
0093                       ;-------------------------------------------------------
0094                       ; Set cursor shape
0095                       ;-------------------------------------------------------
0096 6878 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     687A 6E4C     
0097 687C C820  54         mov   @tv.curshape,@ramsat+2
     687E A214     
     6880 A1E2     
0098                                                   ; Get cursor shape and color
0099                       ;-------------------------------------------------------
0100                       ; Exit
0101                       ;-------------------------------------------------------
0102               dialog.insert.exit:
0103 6882 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 6884 C2F9  30         mov   *stack+,r11           ; Pop R11
0105 6886 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0075                       copy  "dialog.clipdev.asm"   ; Dialog "Configure clipboard device"
     **** ****     > dialog.clipdev.asm
0001               * FILE......: dialog.clipdev.asm
0002               * Purpose...: Dialog "Configure clipboard device"
0003               
0004               ***************************************************************
0005               * dialog.clipdev
0006               * Open Dialog "Configure clipboard device"
0007               ***************************************************************
0008               * b @dialog.clipdevice
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
0020               ********|*****|*********************|**************************
0021               dialog.clipdev:
0022 6888 0649  14         dect  stack
0023 688A C64B  30         mov   r11,*stack            ; Save return address
0024 688C 0649  14         dect  stack
0025 688E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6890 0204  20         li    tmp0,id.dialog.clipdev
     6892 0010     
0030 6894 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6896 A71A     
0031               
0032 6898 0204  20         li    tmp0,txt.head.clipdev
     689A 716C     
0033 689C C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     689E A71C     
0034               
0035 68A0 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     68A2 A71E     
0036 68A4 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     68A6 A722     
0037               
0038 68A8 0204  20         li    tmp0,txt.hint.clipdev
     68AA 718C     
0039 68AC C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     68AE A720     
0040               
0041 68B0 0204  20         li    tmp0,txt.keys.clipdev
     68B2 71BA     
0042 68B4 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     68B6 A724     
0043                       ;-------------------------------------------------------
0044                       ; Set command line
0045                       ;-------------------------------------------------------
0046 68B8 0204  20         li    tmp0,tv.clip.fname    ; Set clipboard
     68BA D9B0     
0047 68BC C804  38         mov   tmp0,@parm1           ; Get pointer to string
     68BE A000     
0048               
0049 68C0 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     68C2 6CCE     
0050                                                   ; \ i  @parm1 = Pointer to string w. preset
0051                                                   ; /
0052                       ;-------------------------------------------------------
0053                       ; Set cursor shape
0054                       ;-------------------------------------------------------
0055 68C4 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     68C6 6E4C     
0056 68C8 C820  54         mov   @tv.curshape,@ramsat+2
     68CA A214     
     68CC A1E2     
0057                                                   ; Get cursor shape and color
0058                       ;-------------------------------------------------------
0059                       ; Exit
0060                       ;-------------------------------------------------------
0061               dialog.clipdevice.exit:
0062 68CE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0063 68D0 C2F9  30         mov   *stack+,r11           ; Pop R11
0064 68D2 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0076                       copy  "dialog.clipboard.asm" ; Dialog "Copy from clipboard"
     **** ****     > dialog.clipboard.asm
0001               * FILE......: dialog.clipboard.asm
0002               * Purpose...: Dialog "Insert snippet from clipboard"
0003               
0004               ***************************************************************
0005               * dialog.clipboard
0006               * Open Dialog for inserting snippet from clipboard
0007               ***************************************************************
0008               * b @dialog.clipboard
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
0020               ********|*****|*********************|**************************
0021               dialog.clipboard:
0022 68D4 0649  14         dect  stack
0023 68D6 C64B  30         mov   r11,*stack            ; Save return address
0024 68D8 0649  14         dect  stack
0025 68DA C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029               dialog.clipboard.setup:
0030 68DC 0204  20         li    tmp0,id.dialog.clipboard
     68DE 0067     
0031 68E0 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     68E2 A71A     
0032                       ;------------------------------------------------------
0033                       ; Include line number in pane header
0034                       ;------------------------------------------------------
0035 68E4 06A0  32         bl    @film
     68E6 224A     
0036 68E8 A77A                   data cmdb.panhead.buf,>00,80
     68EA 0000     
     68EC 0050     
0037                                                   ; Clear pane header buffer
0038               
0039 68EE 06A0  32         bl    @cpym2m
     68F0 24EE     
0040 68F2 71FE                   data txt.head.clipboard,cmdb.panhead.buf,27
     68F4 A77A     
     68F6 001B     
0041               
0042 68F8 C820  54         mov   @fb.row,@parm1
     68FA A306     
     68FC A000     
0043 68FE 06A0  32         bl    @fb.row2line          ; Row to editor line
     6900 6E28     
0044                                                   ; \ i @fb.topline = Top line in frame buffer
0045                                                   ; | i @parm1      = Row in frame buffer
0046                                                   ; / o @outparm1   = Matching line in EB
0047               
0048 6902 05A0  34         inc   @outparm1             ; Add base 1
     6904 A010     
0049               
0050 6906 06A0  32         bl    @mknum                ; Convert integer to string
     6908 2AAA     
0051 690A A010                   data  outparm1        ; \ i  p0 = Pointer to 16 bit unsigned int
0052 690C A140                   data  rambuf          ; | i  p1 = Pointer to 5 byte string buffer
0053 690E 30                     byte  48              ; | i  p2 = MSB offset for ASCII digit
0054 690F   30                   byte  48              ; / i  p2 = LSB char for replacing leading 0
0055               
0056 6910 06A0  32         bl    @cpym2m
     6912 24EE     
0057 6914 A140                   data rambuf,cmdb.panhead.buf + 27,5
     6916 A795     
     6918 0005     
0058                                                   ; Add line number to buffer
0059               
0060 691A 0204  20         li    tmp0,32
     691C 0020     
0061 691E 0A84  56         sla   tmp0,8
0062 6920 D804  38         movb  tmp0,@cmdb.panhead.buf ; Set length byte
     6922 A77A     
0063               
0064 6924 0204  20         li    tmp0,cmdb.panhead.buf
     6926 A77A     
0065 6928 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     692A A71C     
0066                       ;------------------------------------------------------
0067                       ; Other panel strings
0068                       ;------------------------------------------------------
0069 692C 0204  20         li    tmp0,txt.hint.clipboard
     692E 722C     
0070 6930 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6932 A720     
0071               
0072 6934 0204  20         li    tmp0,txt.info.clipboard
     6936 721A     
0073 6938 C804  38         mov   tmp0,@cmdb.paninfo    ; Show info message
     693A A71E     
0074               
0075 693C 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     693E A722     
0076               
0077 6940 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6942 6C86     
0078               
0079 6944 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6946 A44E     
0080 6948 1303  14         jeq   !
0081                       ;-------------------------------------------------------
0082                       ; Show that FastMode is on
0083                       ;-------------------------------------------------------
0084 694A 0204  20         li    tmp0,txt.keys.clipboard ; Highlight FastMode
     694C 7274     
0085 694E 1002  14         jmp   dialog.clipboard.keylist
0086                       ;-------------------------------------------------------
0087                       ; Show that FastMode is off
0088                       ;-------------------------------------------------------
0089 6950 0204  20 !       li    tmp0,txt.keys.clipboard
     6952 7274     
0090                       ;-------------------------------------------------------
0091                       ; Show dialog
0092                       ;-------------------------------------------------------
0093               dialog.clipboard.keylist:
0094 6954 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6956 A724     
0095               
0096 6958 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     695A 6E5E     
0097                       ;-------------------------------------------------------
0098                       ; Exit
0099                       ;-------------------------------------------------------
0100               dialog.clipboard.exit:
0101 695C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 695E C2F9  30         mov   *stack+,r11           ; Pop R11
0103 6960 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0077                       copy  "dialog.unsaved.asm"   ; Dialog "Unsaved changes"
     **** ****     > dialog.unsaved.asm
0001               * FILE......: dialog.unsaved.asm
0002               * Purpose...: Dialog "Unsaved changes"
0003               
0004               ***************************************************************
0005               * dialog.unsaved
0006               * Open Dialog "Unsaved changes"
0007               ***************************************************************
0008               * b @dialog.unsaved
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
0020               ********|*****|*********************|**************************
0021               dialog.unsaved:
0022 6962 0649  14         dect  stack
0023 6964 C64B  30         mov   r11,*stack            ; Save return address
0024 6966 0649  14         dect  stack
0025 6968 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 696A 0204  20         li    tmp0,id.dialog.unsaved
     696C 0065     
0030 696E C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6970 A71A     
0031               
0032 6972 0204  20         li    tmp0,txt.head.unsaved
     6974 731C     
0033 6976 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6978 A71C     
0034               
0035 697A 0204  20         li    tmp0,txt.info.unsaved
     697C 7331     
0036 697E C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6980 A71E     
0037 6982 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6984 A722     
0038               
0039 6986 0204  20         li    tmp0,txt.hint.unsaved
     6988 7354     
0040 698A C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     698C A720     
0041               
0042 698E 0204  20         li    tmp0,txt.keys.unsaved
     6990 738C     
0043 6992 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6994 A724     
0044               
0045 6996 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6998 6E5E     
0046                       ;-------------------------------------------------------
0047                       ; Exit
0048                       ;-------------------------------------------------------
0049               dialog.unsaved.exit:
0050 699A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 699C C2F9  30         mov   *stack+,r11           ; Pop R11
0052 699E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0078                       copy  "dialog.basic.asm"     ; Dialog "Basic"
     **** ****     > dialog.basic.asm
0001               * basic......: dialog.basic.asm
0002               * Purpose...: Dialog "Basic"
0003               
0004               ***************************************************************
0005               * dialog.basic
0006               * Open Dialog "Basic"
0007               ***************************************************************
0008               * b @dialog.basic
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
0020               ********|*****|*********************|**************************
0021               dialog.basic:
0022 69A0 0649  14         dect  stack
0023 69A2 C64B  30         mov   r11,*stack            ; Save return address
0024 69A4 0649  14         dect  stack
0025 69A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 69A8 0204  20         li    tmp0,id.dialog.basic
     69AA 006A     
0030 69AC C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     69AE A71A     
0031               
0032 69B0 0204  20         li    tmp0,txt.head.basic
     69B2 74C2     
0033 69B4 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     69B6 A71C     
0034               
0035 69B8 0204  20         li    tmp0,txt.info.basic
     69BA 74D1     
0036 69BC C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     69BE A71E     
0037               
0038 69C0 0204  20         li    tmp0,pos.info.basic
     69C2 74EE     
0039 69C4 C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     69C6 A722     
0040               
0041 69C8 0204  20         li    tmp0,txt.hint.basic
     69CA 74F1     
0042 69CC C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     69CE A720     
0043               
0044 69D0 0204  20         li    tmp0,txt.keys.basic
     69D2 74F4     
0045 69D4 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     69D6 A724     
0046               
0047 69D8 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     69DA 6E5E     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.basic.exit:
0052 69DC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 69DE C2F9  30         mov   *stack+,r11           ; Pop R11
0054 69E0 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0079                       ;-----------------------------------------------------------------------
0080                       ; Command buffer handling
0081                       ;-----------------------------------------------------------------------
0082                       copy  "pane.utils.hint.asm" ; Show hint in pane
     **** ****     > pane.utils.hint.asm
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
0021 69E2 0649  14         dect  stack
0022 69E4 C64B  30         mov   r11,*stack            ; Save return address
0023 69E6 0649  14         dect  stack
0024 69E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 69EA 0649  14         dect  stack
0026 69EC C645  30         mov   tmp1,*stack           ; Push tmp1
0027 69EE 0649  14         dect  stack
0028 69F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 69F2 0649  14         dect  stack
0030 69F4 C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 69F6 C820  54         mov   @parm1,@wyx           ; Set cursor
     69F8 A000     
     69FA 832A     
0035 69FC C160  34         mov   @parm2,tmp1           ; Get string to display
     69FE A002     
0036 6A00 06A0  32         bl    @xutst0               ; Display string
     6A02 2434     
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 6A04 C120  34         mov   @parm2,tmp0
     6A06 A002     
0041 6A08 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 6A0A 0984  56         srl   tmp0,8                ; Right justify
0043 6A0C C184  18         mov   tmp0,tmp2
0044 6A0E C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 6A10 0506  16         neg   tmp2
0046 6A12 0226  22         ai    tmp2,80               ; Number of bytes to fill
     6A14 0050     
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 6A16 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     6A18 A000     
0051 6A1A A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 6A1C C804  38         mov   tmp0,@wyx             ; / Set cursor
     6A1E 832A     
0053               
0054 6A20 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6A22 240E     
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 6A24 0205  20         li    tmp1,32               ; Byte to fill
     6A26 0020     
0059               
0060 6A28 06A0  32         bl    @xfilv                ; Clear line
     6A2A 22A8     
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 6A2C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 6A2E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 6A30 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 6A32 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 6A34 C2F9  30         mov   *stack+,r11           ; Pop R11
0073 6A36 045B  20         b     *r11                  ; Return to caller
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
0095 6A38 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     6A3A A000     
0096 6A3C C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     6A3E A002     
0097 6A40 0649  14         dect  stack
0098 6A42 C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 6A44 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6A46 69E2     
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 6A48 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 6A4A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0083                       copy  "pane.cmdb.show.asm"  ; Show command buffer pane
     **** ****     > pane.cmdb.show.asm
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
0022 6A4C 0649  14         dect  stack
0023 6A4E C64B  30         mov   r11,*stack            ; Save return address
0024 6A50 0649  14         dect  stack
0025 6A52 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 6A54 C820  54         mov   @wyx,@cmdb.fb.yxsave
     6A56 832A     
     6A58 A704     
0030                                                   ; Save YX position in frame buffer
0031               
0032 6A5A 0204  20         li    tmp0,pane.botrow
     6A5C 001D     
0033 6A5E 6120  34         s     @cmdb.scrrows,tmp0
     6A60 A706     
0034 6A62 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     6A64 A31A     
0035               
0036 6A66 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 6A68 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     6A6A A70E     
0038               
0039 6A6C 0224  22         ai    tmp0,>0100
     6A6E 0100     
0040 6A70 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     6A72 A710     
0041 6A74 0584  14         inc   tmp0
0042 6A76 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     6A78 A70A     
0043               
0044 6A7A 0720  34         seto  @cmdb.visible         ; Show pane
     6A7C A702     
0045 6A7E 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     6A80 A718     
0046               
0047 6A82 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     6A84 0001     
0048 6A86 C804  38         mov   tmp0,@tv.pane.focus   ; /
     6A88 A222     
0049               
0050 6A8A 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     6A8C 6E3A     
0051               
0052 6A8E 0720  34         seto  @parm1                ; Do not turn screen off while
     6A90 A000     
0053                                                   ; reloading color scheme
0054               
0055 6A92 06A0  32         bl    @pane.action.colorscheme.load
     6A94 6E82     
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 6A96 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 6A98 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6A9A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0084                       copy  "pane.cmdb.hide.asm"  ; Hide command buffer pane
     **** ****     > pane.cmdb.hide.asm
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
0023 6A9C 0649  14         dect  stack
0024 6A9E C64B  30         mov   r11,*stack            ; Save return address
0025 6AA0 0649  14         dect  stack
0026 6AA2 C660  46         mov   @parm1,*stack         ; Push @parm1
     6AA4 A000     
0027                       ;------------------------------------------------------
0028                       ; Hide command buffer pane
0029                       ;------------------------------------------------------
0030 6AA6 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     6AA8 A31C     
     6AAA A31A     
0031                       ;------------------------------------------------------
0032                       ; Adjust frame buffer size if error pane visible
0033                       ;------------------------------------------------------
0034 6AAC C820  54         mov   @tv.error.visible,@tv.error.visible
     6AAE A228     
     6AB0 A228     
0035 6AB2 1302  14         jeq   !
0036 6AB4 0620  34         dec   @fb.scrrows
     6AB6 A31A     
0037                       ;------------------------------------------------------
0038                       ; Clear error/hint & status line
0039                       ;------------------------------------------------------
0040 6AB8 06A0  32 !       bl    @hchar
     6ABA 27DC     
0041 6ABC 1900                   byte pane.botrow-4,0,32,80*3
     6ABE 20F0     
0042 6AC0 1C00                   byte pane.botrow-1,0,32,80*2
     6AC2 20A0     
0043 6AC4 FFFF                   data EOL
0044                       ;------------------------------------------------------
0045                       ; Adjust frame buffer size if ruler visible
0046                       ;------------------------------------------------------
0047 6AC6 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     6AC8 A210     
     6ACA A210     
0048 6ACC 1302  14         jeq   pane.cmdb.hide.rest
0049 6ACE 0620  34         dec   @fb.scrrows
     6AD0 A31A     
0050                       ;------------------------------------------------------
0051                       ; Hide command buffer pane (rest)
0052                       ;------------------------------------------------------
0053               pane.cmdb.hide.rest:
0054 6AD2 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     6AD4 A704     
     6AD6 832A     
0055 6AD8 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     6ADA A702     
0056 6ADC 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6ADE A316     
0057 6AE0 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     6AE2 A222     
0058                       ;------------------------------------------------------
0059                       ; Reload current color scheme
0060                       ;------------------------------------------------------
0061 6AE4 0720  34         seto  @parm1                ; Do not turn screen off while
     6AE6 A000     
0062                                                   ; reloading color scheme
0063               
0064 6AE8 06A0  32         bl    @pane.action.colorscheme.load
     6AEA 6E82     
0065                                                   ; Reload color scheme
0066                                                   ; i  parm1 = Skip screen off if >FFFF
0067                       ;------------------------------------------------------
0068                       ; Show cursor again
0069                       ;------------------------------------------------------
0070 6AEC 06A0  32         bl    @pane.cursor.blink
     6AEE 6E4C     
0071                       ;------------------------------------------------------
0072                       ; Exit
0073                       ;------------------------------------------------------
0074               pane.cmdb.hide.exit:
0075 6AF0 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6AF2 A000     
0076 6AF4 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6AF6 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0085                       copy  "pane.cmdb.draw.asm"  ; Draw command buffer pane contents
     **** ****     > pane.cmdb.draw.asm
0001               * FILE......: pane.cmdb.draw.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
0003               
0004               ***************************************************************
0005               * pane.cmdb.draw
0006               * Draw content in command buffer pane
0007               ***************************************************************
0008               * bl  @pane.cmdb.draw
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @cmdb.panhead  = Pointer to string with dialog header
0012               * @cmdb.paninfo  = Pointer to string with info message or >0000
0013               *                  if input prompt required
0014               * @cmdb.panhint  = Pointer to string with hint message
0015               * @cmdb.pankeys  = Pointer to string with key shortcuts for dialog
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0, tmp1, tmp2
0022               ********|*****|*********************|**************************
0023               pane.cmdb.draw:
0024 6AF8 0649  14         dect  stack
0025 6AFA C64B  30         mov   r11,*stack            ; Save return address
0026 6AFC 0649  14         dect  stack
0027 6AFE C644  30         mov   tmp0,*stack           ; Push tmp0
0028 6B00 0649  14         dect  stack
0029 6B02 C645  30         mov   tmp1,*stack           ; Push tmp1
0030                       ;------------------------------------------------------
0031                       ; Command buffer header line
0032                       ;------------------------------------------------------
0033 6B04 C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     6B06 A71C     
     6B08 A000     
0034 6B0A 0204  20         li    tmp0,80
     6B0C 0050     
0035 6B0E C804  38         mov   tmp0,@parm2           ; Set requested length
     6B10 A002     
0036 6B12 0204  20         li    tmp0,1
     6B14 0001     
0037 6B16 C804  38         mov   tmp0,@parm3           ; Set character to fill
     6B18 A004     
0038 6B1A 0204  20         li    tmp0,rambuf
     6B1C A140     
0039 6B1E C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     6B20 A006     
0040               
0041 6B22 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     6B24 33E8     
0042                                                   ; \ i  @parm1 = Pointer to string
0043                                                   ; | i  @parm2 = Requested length
0044                                                   ; | i  @parm3 = Fill character
0045                                                   ; | i  @parm4 = Pointer to buffer with
0046                                                   ; /             output string
0047               
0048 6B26 06A0  32         bl    @cpym2m
     6B28 24EE     
0049 6B2A 701E                   data txt.stevie,rambuf+68,13
     6B2C A184     
     6B2E 000D     
0050                                                   ;
0051                                                   ; Add Stevie banner
0052                                                   ;
0053               
0054 6B30 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     6B32 A70E     
     6B34 832A     
0055 6B36 C160  34         mov   @outparm1,tmp1        ; | Display pane header
     6B38 A010     
0056 6B3A 06A0  32         bl    @xutst0               ; /
     6B3C 2434     
0057                       ;------------------------------------------------------
0058                       ; Check dialog id
0059                       ;------------------------------------------------------
0060 6B3E 04E0  34         clr   @waux1                ; Default is show prompt
     6B40 833C     
0061               
0062 6B42 C120  34         mov   @cmdb.dialog,tmp0
     6B44 A71A     
0063 6B46 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     6B48 0063     
0064 6B4A 121D  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0065 6B4C 0720  34         seto  @waux1                ; /
     6B4E 833C     
0066                       ;------------------------------------------------------
0067                       ; Show info message instead of prompt
0068                       ;------------------------------------------------------
0069 6B50 C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     6B52 A71E     
0070 6B54 1318  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0071               
0072 6B56 C820  54         mov   @cmdb.paninfo,@parm1  ; Get string to display
     6B58 A71E     
     6B5A A000     
0073 6B5C 0204  20         li    tmp0,80
     6B5E 0050     
0074 6B60 C804  38         mov   tmp0,@parm2           ; Set requested length
     6B62 A002     
0075 6B64 0204  20         li    tmp0,32
     6B66 0020     
0076 6B68 C804  38         mov   tmp0,@parm3           ; Set character to fill
     6B6A A004     
0077 6B6C 0204  20         li    tmp0,rambuf
     6B6E A140     
0078 6B70 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     6B72 A006     
0079               
0080 6B74 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     6B76 33E8     
0081                                                   ; \ i  @parm1 = Pointer to string
0082                                                   ; | i  @parm2 = Requested length
0083                                                   ; | i  @parm3 = Fill character
0084                                                   ; | i  @parm4 = Pointer to buffer with
0085                                                   ; /             output string
0086               
0087 6B78 06A0  32         bl    @at
     6B7A 26E2     
0088 6B7C 1A00                   byte pane.botrow-3,0  ; Position cursor
0089               
0090 6B7E C160  34         mov   @outparm1,tmp1        ; \ Display pane header
     6B80 A010     
0091 6B82 06A0  32         bl    @xutst0               ; /
     6B84 2434     
0092                       ;------------------------------------------------------
0093                       ; Clear lines after prompt in command buffer
0094                       ;------------------------------------------------------
0095               pane.cmdb.draw.clear:
0096 6B86 06A0  32         bl    @hchar
     6B88 27DC     
0097 6B8A 1B00                   byte pane.botrow-2,0,32,80
     6B8C 2050     
0098 6B8E FFFF                   data EOL              ; Remove key markers
0099                       ;------------------------------------------------------
0100                       ; Show key markers ?
0101                       ;------------------------------------------------------
0102 6B90 C120  34         mov   @cmdb.panmarkers,tmp0
     6B92 A722     
0103 6B94 1310  14         jeq   pane.cmdb.draw.hint   ; no, skip key markers
0104                       ;------------------------------------------------------
0105                       ; Loop over key marker list
0106                       ;------------------------------------------------------
0107               pane.cmdb.draw.marker.loop:
0108 6B96 D174  28         movb  *tmp0+,tmp1           ; Get X position
0109 6B98 0985  56         srl   tmp1,8                ; Right align
0110 6B9A 0285  22         ci    tmp1,>00ff            ; End of list reached?
     6B9C 00FF     
0111 6B9E 130B  14         jeq   pane.cmdb.draw.hint   ; Yes, exit loop
0112               
0113 6BA0 0265  22         ori   tmp1,(pane.botrow - 2) * 256
     6BA2 1B00     
0114                                                   ; y=bottom row - 3, x=(key marker position)
0115 6BA4 C805  38         mov   tmp1,@wyx             ; Set cursor position
     6BA6 832A     
0116               
0117 6BA8 0649  14         dect  stack
0118 6BAA C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 6BAC 06A0  32         bl    @putstr
     6BAE 2432     
0121 6BB0 395C                   data txt.keymarker    ; Show key marker
0122               
0123 6BB2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124                       ;------------------------------------------------------
0125                       ; Show marker
0126                       ;------------------------------------------------------
0127 6BB4 10F0  14         jmp   pane.cmdb.draw.marker.loop
0128                                                   ; Next iteration
0129                       ;------------------------------------------------------
0130                       ; Display pane hint in command buffer
0131                       ;------------------------------------------------------
0132               pane.cmdb.draw.hint:
0133 6BB6 0204  20         li    tmp0,pane.botrow - 1  ; \
     6BB8 001C     
0134 6BBA 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0135 6BBC C804  38         mov   tmp0,@parm1           ; Set parameter
     6BBE A000     
0136 6BC0 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     6BC2 A720     
     6BC4 A002     
0137               
0138 6BC6 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6BC8 69E2     
0139                                                   ; \ i  parm1 = Pointer to string with hint
0140                                                   ; / i  parm2 = YX position
0141                       ;------------------------------------------------------
0142                       ; Display keys in status line
0143                       ;------------------------------------------------------
0144 6BCA 0204  20         li    tmp0,pane.botrow      ; \
     6BCC 001D     
0145 6BCE 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0146 6BD0 C804  38         mov   tmp0,@parm1           ; Set parameter
     6BD2 A000     
0147 6BD4 C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     6BD6 A724     
     6BD8 A002     
0148               
0149 6BDA 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6BDC 69E2     
0150                                                   ; \ i  parm1 = Pointer to string with hint
0151                                                   ; / i  parm2 = YX position
0152                       ;------------------------------------------------------
0153                       ; ALPHA-Lock key down?
0154                       ;------------------------------------------------------
0155 6BDE 20A0  38         coc   @wbit10,config
     6BE0 200C     
0156 6BE2 1306  14         jeq   pane.cmdb.draw.alpha.down
0157                       ;------------------------------------------------------
0158                       ; AlPHA-Lock is up
0159                       ;------------------------------------------------------
0160 6BE4 06A0  32         bl    @hchar
     6BE6 27DC     
0161 6BE8 1D4E                   byte pane.botrow,78,32,2
     6BEA 2002     
0162 6BEC FFFF                   data eol
0163               
0164 6BEE 1004  14         jmp   pane.cmdb.draw.promptcmd
0165                       ;------------------------------------------------------
0166                       ; AlPHA-Lock is down
0167                       ;------------------------------------------------------
0168               pane.cmdb.draw.alpha.down:
0169 6BF0 06A0  32         bl    @putat
     6BF2 2456     
0170 6BF4 1D4E                   byte   pane.botrow,78
0171 6BF6 3956                   data   txt.alpha.down
0172                       ;------------------------------------------------------
0173                       ; Command buffer content
0174                       ;------------------------------------------------------
0175               pane.cmdb.draw.promptcmd:
0176 6BF8 C120  34         mov   @waux1,tmp0           ; Flag set?
     6BFA 833C     
0177 6BFC 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0178 6BFE 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     6C00 6C3C     
0179                       ;------------------------------------------------------
0180                       ; Exit
0181                       ;------------------------------------------------------
0182               pane.cmdb.draw.exit:
0183 6C02 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0184 6C04 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0185 6C06 C2F9  30         mov   *stack+,r11           ; Pop r11
0186 6C08 045B  20         b     *r11                  ; Return
                   < stevie_b3.asm.61108
0086                       copy  "error.display.asm"   ; Show error message
     **** ****     > error.display.asm
0001               
0002               ***************************************************************
0003               * error.display
0004               * Display error message
0005               ***************************************************************
0006               * bl  @error.display
0007               *--------------------------------------------------------------
0008               * INPUT
0009               * @parm1 = Pointer to error message
0010               *--------------------------------------------------------------
0011               * OUTPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * Register usage
0015               * tmp0,tmp1,tmp2
0016               ********|*****|*********************|**************************
0017               error.display:
0018 6C0A 0649  14         dect  stack
0019 6C0C C64B  30         mov   r11,*stack            ; Save return address
0020 6C0E 0649  14         dect  stack
0021 6C10 C644  30         mov   tmp0,*stack           ; Push tmp0
0022 6C12 0649  14         dect  stack
0023 6C14 C645  30         mov   tmp1,*stack           ; Push tmp1
0024 6C16 0649  14         dect  stack
0025 6C18 C646  30         mov   tmp2,*stack           ; Push tmp2
0026                       ;------------------------------------------------------
0027                       ; Display error message
0028                       ;------------------------------------------------------
0029 6C1A C120  34         mov   @parm1,tmp0           ; \ Get length of string
     6C1C A000     
0030 6C1E D194  26         movb  *tmp0,tmp2            ; |
0031 6C20 0986  56         srl   tmp2,8                ; / Right align
0032               
0033 6C22 C120  34         mov   @parm1,tmp0           ; Get error message
     6C24 A000     
0034 6C26 0205  20         li    tmp1,tv.error.msg     ; Set error message
     6C28 A22C     
0035               
0036 6C2A 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     6C2C 24F4     
0037                                                   ; \ i  tmp0 = Source CPU memory address
0038                                                   ; | i  tmp1 = Target CPU memory address
0039                                                   ; / i  tmp2 = Number of bytes to copy
0040               
0041 6C2E 06A0  32         bl    @pane.errline.show    ; Display error message
     6C30 6E70     
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               error.display.exit:
0046 6C32 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 6C34 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 6C36 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 6C38 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 6C3A 045B  20         b     *r11                  ; Return
                   < stevie_b3.asm.61108
0087                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
     **** ****     > cmdb.refresh.asm
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
0022 6C3C 0649  14         dect  stack
0023 6C3E C64B  30         mov   r11,*stack            ; Save return address
0024 6C40 0649  14         dect  stack
0025 6C42 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6C44 0649  14         dect  stack
0027 6C46 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6C48 0649  14         dect  stack
0029 6C4A C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6C4C 0649  14         dect  stack
0031 6C4E C660  46         mov   @wyx,*stack           ; Push cursor position
     6C50 832A     
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 6C52 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6C54 A710     
     6C56 832A     
0036               
0037 6C58 05A0  34         inc   @wyx                  ; X +1 for prompt
     6C5A 832A     
0038               
0039 6C5C 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6C5E 240E     
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 6C60 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6C62 A729     
0044 6C64 0206  20         li    tmp2,1*79             ; Command length
     6C66 004F     
0045               
0046 6C68 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6C6A 24A0     
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 6C6C C820  54         mov   @cmdb.yxprompt,@wyx
     6C6E A710     
     6C70 832A     
0054 6C72 06A0  32         bl    @putstr
     6C74 2432     
0055 6C76 3A30                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 6C78 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     6C7A 832A     
0061 6C7C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 6C7E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 6C80 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 6C82 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6C84 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0088                       copy  "cmdb.cmd.asm"        ; Command line handling
     **** ****     > cmdb.cmd.asm
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
0022 6C86 0649  14         dect  stack
0023 6C88 C64B  30         mov   r11,*stack            ; Save return address
0024 6C8A 0649  14         dect  stack
0025 6C8C C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6C8E 0649  14         dect  stack
0027 6C90 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6C92 0649  14         dect  stack
0029 6C94 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 6C96 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6C98 A728     
0034 6C9A 06A0  32         bl    @film                 ; Clear command
     6C9C 224A     
0035 6C9E A729                   data  cmdb.cmd,>00,80
     6CA0 0000     
     6CA2 0050     
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 6CA4 C120  34         mov   @cmdb.yxprompt,tmp0
     6CA6 A710     
0040 6CA8 0584  14         inc   tmp0
0041 6CAA C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6CAC A70A     
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 6CAE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 6CB0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 6CB2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 6CB4 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 6CB6 045B  20         b     *r11                  ; Return to caller
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
0075 6CB8 0649  14         dect  stack
0076 6CBA C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 6CBC 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6CBE 2B9E     
0081 6CC0 A729                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6CC2 0000     
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 6CC4 C820  54         mov   @waux1,@outparm1     ; Save length of string
     6CC6 833C     
     6CC8 A010     
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 6CCA C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6CCC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0089                       copy  "cmdb.cmd.set.asm"    ; Set command line to preset value
     **** ****     > cmdb.cmd.set.asm
0001               * FILE......: cmdb.cmd.set.asm
0002               * Purpose...: Set command line
0003               
0004               ***************************************************************
0005               * cmdb.cmd.set
0006               * Set current command
0007               ***************************************************************
0008               * bl @cmdb.cmd.set
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Pointer to string with command
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               cmdb.cmd.set:
0022 6CCE 0649  14         dect  stack
0023 6CD0 C64B  30         mov   r11,*stack            ; Save return address
0024 6CD2 0649  14         dect  stack
0025 6CD4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6CD6 0649  14         dect  stack
0027 6CD8 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6CDA 0649  14         dect  stack
0029 6CDC C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 6CDE 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6CE0 A728     
0034 6CE2 06A0  32         bl    @film                 ; Clear command
     6CE4 224A     
0035 6CE6 A729                   data  cmdb.cmd,>00,80
     6CE8 0000     
     6CEA 0050     
0036                       ;------------------------------------------------------
0037                       ; Get string length
0038                       ;------------------------------------------------------
0039 6CEC C120  34         mov   @parm1,tmp0
     6CEE A000     
0040 6CF0 D1B4  28         movb  *tmp0+,tmp2           ; Get length byte
0041 6CF2 0986  56         srl   tmp2,8                ; Right align
0042 6CF4 1501  14         jgt   !
0043                       ;------------------------------------------------------
0044                       ; Assert: invalid length, we just exit here
0045                       ;------------------------------------------------------
0046 6CF6 100B  14         jmp   cmdb.cmd.set.exit     ; No harm done
0047                       ;------------------------------------------------------
0048                       ; Copy string to command
0049                       ;------------------------------------------------------
0050 6CF8 0205  20 !       li   tmp1,cmdb.cmd          ; Destination
     6CFA A729     
0051 6CFC 06A0  32         bl   @xpym2m                ; Copy string
     6CFE 24F4     
0052                       ;------------------------------------------------------
0053                       ; Put cursor at beginning of line
0054                       ;------------------------------------------------------
0055 6D00 C120  34         mov   @cmdb.yxprompt,tmp0
     6D02 A710     
0056 6D04 0584  14         inc   tmp0
0057 6D06 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6D08 A70A     
0058               
0059 6D0A 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     6D0C A718     
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063               cmdb.cmd.set.exit:
0064 6D0E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0065 6D10 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 6D12 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 6D14 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 6D16 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0090                       copy  "cmdb.cmd.preset.asm" ; Preset shortcuts in dialogs
     **** ****     > cmdb.cmd.preset.asm
0001               * FILE......: cmdb.cmd.preset.asm
0002               * Purpose...: Set command to preset based on dialog and shortcut pressed
0003               
0004               ***************************************************************
0005               * cmdb.cmd.preset
0006               * Set command to preset based on dialog and shortcut pressed
0007               ***************************************************************
0008               * bl   @cmdb.cmd.preset
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @waux1       = Key pressed
0012               * @cmdb.dialog = ID of current dialog
0013               *--------------------------------------------------------------
0014               * Register usage
0015               * tmp0, tmp1, tmp2
0016               ********|*****|*********************|**************************
0017               cmdb.cmd.preset:
0018 6D18 0649  14         dect  stack
0019 6D1A C64B  30         mov   r11,*stack            ; Save return address
0020 6D1C 0649  14         dect  stack
0021 6D1E C644  30         mov   tmp0,*stack           ; Push tmp0
0022 6D20 0649  14         dect  stack
0023 6D22 C645  30         mov   tmp1,*stack           ; Push tmp1
0024 6D24 0649  14         dect  stack
0025 6D26 C646  30         mov   tmp2,*stack           ; Push tmp2
0026               
0027 6D28 0204  20         li    tmp0,cmdb.cmd.preset.data
     6D2A 7522     
0028                                                   ; Load table
0029               
0030 6D2C C1A0  34         mov   @waux1,tmp2           ; \ Get keyboard code
     6D2E 833C     
0031 6D30 0986  56         srl   tmp2,8                ; / Right align
0032                       ;-------------------------------------------------------
0033                       ; Loop over table with presets
0034                       ;-------------------------------------------------------
0035               cmdb.cmd.preset.loop:
0036 6D32 8834  50         c     *tmp0+,@cmdb.dialog   ; Dialog matches?
     6D34 A71A     
0037 6D36 1607  14         jne   cmdb.cmd.preset.next  ; No, next entry
0038                       ;-------------------------------------------------------
0039                       ; Dialog matches, check if shortcut matches
0040                       ;-------------------------------------------------------
0041 6D38 81B4  30         c     *tmp0+,tmp2           ; Compare with keyboard shortcut
0042 6D3A 1606  14         jne   !                     ; No match, next entry
0043                       ;-------------------------------------------------------
0044                       ; Entry in table matches, set preset
0045                       ;-------------------------------------------------------
0046 6D3C C814  46         mov   *tmp0,@parm1          ; Get pointer to string
     6D3E A000     
0047               
0048 6D40 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6D42 6CCE     
0049                                                   ; \ i  @parm1 = Pointer to string w. preset
0050                                                   ; /
0051               
0052 6D44 1006  14         jmp   cmdb.cmd.preset.exit  ; Exit
0053                       ;-------------------------------------------------------
0054                       ; Dialog does not match, prepare for next entry
0055                       ;-------------------------------------------------------
0056               cmdb.cmd.preset.next:
0057 6D46 05C4  14         inct  tmp0                  ; Skip shortcut
0058 6D48 05C4  14 !       inct  tmp0                  ; Skip pointer to string
0059                       ;-------------------------------------------------------
0060                       ; End of list reached?
0061                       ;-------------------------------------------------------
0062 6D4A C154  26         mov   *tmp0,tmp1            ; Get entry
0063 6D4C 0285  22         ci    tmp1,EOL              ; EOL identifier found?
     6D4E FFFF     
0064 6D50 16F0  14         jne   cmdb.cmd.preset.loop  ; Not yet, next entry
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               cmdb.cmd.preset.exit:
0069 6D52 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 6D54 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 6D56 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 6D58 C2F9  30         mov   *stack+,r11           ; Pop r11
0073 6D5A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0091                       ;-----------------------------------------------------------------------
0092                       ; Toggle fastmode in Load/Save DV80 dialogs
0093                       ;-----------------------------------------------------------------------
0094                       copy  "fm.fastmode.asm"     ; Turn fastmode on/off for file operation
     **** ****     > fm.fastmode.asm
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
0017               * tmp0, tmp1, tmp2
0018               ********|*****|*********************|**************************
0019               fm.fastmode:
0020 6D5C 0649  14         dect  stack
0021 6D5E C64B  30         mov   r11,*stack            ; Save return address
0022 6D60 0649  14         dect  stack
0023 6D62 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6D64 0649  14         dect  stack
0025 6D66 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6D68 0649  14         dect  stack
0027 6D6A C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Toggle fastmode
0030                       ;------------------------------------------------------
0031 6D6C C160  34         mov   @cmdb.dialog,tmp1     ; Get ID of current dialog
     6D6E A71A     
0032 6D70 C120  34         mov   @fh.offsetopcode,tmp0 ; Get file opcode offset
     6D72 A44E     
0033 6D74 131B  14         jeq   fm.fastmode.on        ; Toggle on if offset is 0
0034                       ;------------------------------------------------------
0035                       ; Turn fast mode off
0036                       ;------------------------------------------------------
0037               fm.fastmode.off:
0038 6D76 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     6D78 A44E     
0039               
0040 6D7A 0206  20         li    tmp2,id.dialog.load
     6D7C 000A     
0041 6D7E 8185  18         c     tmp1,tmp2
0042 6D80 130C  14         jeq   fm.fastmode.off.1
0043               
0044 6D82 0206  20         li    tmp2,id.dialog.insert
     6D84 000D     
0045 6D86 8185  18         c     tmp1,tmp2
0046 6D88 130B  14         jeq   fm.fastmode.off.2
0047               
0048 6D8A 0206  20         li    tmp2,id.dialog.clipboard
     6D8C 0067     
0049 6D8E 8185  18         c     tmp1,tmp2
0050 6D90 130A  14         jeq   fm.fastmode.off.3
0051                       ;------------------------------------------------------
0052                       ; Assert
0053                       ;------------------------------------------------------
0054 6D92 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D94 FFCE     
0055 6D96 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D98 2026     
0056                       ;------------------------------------------------------
0057                       ; Keylist fastmode off
0058                       ;------------------------------------------------------
0059               fm.fastmode.off.1:
0060 6D9A 0204  20         li    tmp0,txt.keys.load
     6D9C 705A     
0061 6D9E 1022  14         jmp   fm.fastmode.keylist
0062               fm.fastmode.off.2:
0063 6DA0 0204  20         li    tmp0,txt.keys.insert
     6DA2 712C     
0064 6DA4 101F  14         jmp   fm.fastmode.keylist
0065               fm.fastmode.off.3:
0066 6DA6 0204  20         li    tmp0,txt.keys.clipboard
     6DA8 7274     
0067 6DAA 101C  14         jmp   fm.fastmode.keylist
0068                       ;------------------------------------------------------
0069                       ; Turn fast mode on
0070                       ;------------------------------------------------------
0071               fm.fastmode.on:
0072 6DAC 0204  20         li    tmp0,>40              ; Data buffer in CPU RAM
     6DAE 0040     
0073 6DB0 C804  38         mov   tmp0,@fh.offsetopcode
     6DB2 A44E     
0074               
0075 6DB4 0206  20         li    tmp2,id.dialog.load
     6DB6 000A     
0076 6DB8 8185  18         c     tmp1,tmp2
0077 6DBA 130C  14         jeq   fm.fastmode.on.1
0078               
0079 6DBC 0206  20         li    tmp2,id.dialog.insert
     6DBE 000D     
0080 6DC0 8185  18         c     tmp1,tmp2
0081 6DC2 130B  14         jeq   fm.fastmode.on.2
0082               
0083 6DC4 0206  20         li    tmp2,id.dialog.clipboard
     6DC6 0067     
0084 6DC8 8185  18         c     tmp1,tmp2
0085 6DCA 130A  14         jeq   fm.fastmode.on.3
0086                       ;------------------------------------------------------
0087                       ; Assert
0088                       ;------------------------------------------------------
0089 6DCC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DCE FFCE     
0090 6DD0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DD2 2026     
0091                       ;------------------------------------------------------
0092                       ; Keylist fastmode on
0093                       ;------------------------------------------------------
0094               fm.fastmode.on.1:
0095 6DD4 0204  20         li    tmp0,txt.keys.load2
     6DD6 707A     
0096 6DD8 1005  14         jmp   fm.fastmode.keylist
0097               fm.fastmode.on.2:
0098 6DDA 0204  20         li    tmp0,txt.keys.insert2
     6DDC 714C     
0099 6DDE 1002  14         jmp   fm.fastmode.keylist
0100               fm.fastmode.on.3:
0101 6DE0 0204  20         li    tmp0,txt.keys.clipboard2
     6DE2 7298     
0102                       ;------------------------------------------------------
0103                       ; Set keylist
0104                       ;------------------------------------------------------
0105               fm.fastmode.keylist:
0106 6DE4 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6DE6 A724     
0107               *--------------------------------------------------------------
0108               * Exit
0109               *--------------------------------------------------------------
0110               fm.fastmode.exit:
0111 6DE8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0112 6DEA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0113 6DEC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0114 6DEE C2F9  30         mov   *stack+,r11           ; Pop R11
0115 6DF0 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.61108
0095                       ;-----------------------------------------------------------------------
0096                       ; Stubs
0097                       ;-----------------------------------------------------------------------
0098                       copy  "rom.stubs.bank3.asm" ; Stubs for functions in other banks
     **** ****     > rom.stubs.bank3.asm
0001               * FILE......: rom.stubs.bank3.asm
0002               * Purpose...: Bank 3 stubs for functions in other banks
0003               
0004               
0005               ***************************************************************
0006               * Stub for "edb.line.pack"
0007               * bank1 vec.10
0008               ********|*****|*********************|**************************
0009               edb.line.pack:
0010 6DF2 0649  14         dect  stack
0011 6DF4 C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Call function in bank 1
0014                       ;------------------------------------------------------
0015 6DF6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6DF8 30A4     
0016 6DFA 6002                   data bank1.rom        ; | i  p0 = bank address
0017 6DFC 7FD2                   data vec.10           ; | i  p1 = Vector with target address
0018 6DFE 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 6E00 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 6E02 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "edkey.action.cmdb.show"
0028               * bank1 vec.15
0029               ********|*****|*********************|**************************
0030               edkey.action.cmdb.show:
0031 6E04 0649  14         dect  stack
0032 6E06 C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Call function in bank 1
0035                       ;------------------------------------------------------
0036 6E08 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6E0A 30A4     
0037 6E0C 6002                   data bank1.rom        ; | i  p0 = bank address
0038 6E0E 7FDC                   data vec.15           ; | i  p1 = Vector with target address
0039 6E10 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0040                       ;------------------------------------------------------
0041                       ; Exit
0042                       ;------------------------------------------------------
0043 6E12 C2F9  30         mov   *stack+,r11           ; Pop r11
0044 6E14 045B  20         b     *r11                  ; Return to caller
0045               
0046               
0047               ***************************************************************
0048               * Stub for "fb.refresh"
0049               * bank1 vec.20
0050               ********|*****|*********************|**************************
0051               fb.refresh:
0052 6E16 0649  14         dect  stack
0053 6E18 C64B  30         mov   r11,*stack            ; Save return address
0054                       ;------------------------------------------------------
0055                       ; Call function in bank 1
0056                       ;------------------------------------------------------
0057 6E1A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6E1C 30A4     
0058 6E1E 6002                   data bank1.rom        ; | i  p0 = bank address
0059 6E20 7FE6                   data vec.20           ; | i  p1 = Vector with target address
0060 6E22 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064 6E24 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6E26 045B  20         b     *r11                  ; Return to caller
0066               
0067               
0068               ***************************************************************
0069               * Stub for "fb.row2line"
0070               * bank1 vec.22
0071               ********|*****|*********************|**************************
0072               fb.row2line:
0073 6E28 0649  14         dect  stack
0074 6E2A C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Call function in bank 1
0077                       ;------------------------------------------------------
0078 6E2C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6E2E 30A4     
0079 6E30 6002                   data bank1.rom        ; | i  p0 = bank address
0080 6E32 7FEA                   data vec.22           ; | i  p1 = Vector with target address
0081 6E34 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085 6E36 C2F9  30         mov   *stack+,r11           ; Pop r11
0086 6E38 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               ***************************************************************
0090               * Stub for "pane.errline.hide"
0091               * bank1 vec.27
0092               ********|*****|*********************|**************************
0093               pane.errline.hide:
0094 6E3A 0649  14         dect  stack
0095 6E3C C64B  30         mov   r11,*stack            ; Save return address
0096                       ;------------------------------------------------------
0097                       ; Call function in bank 1
0098                       ;------------------------------------------------------
0099 6E3E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6E40 30A4     
0100 6E42 6002                   data bank1.rom        ; | i  p0 = bank address
0101 6E44 7FF4                   data vec.27           ; | i  p1 = Vector with target address
0102 6E46 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0103                       ;------------------------------------------------------
0104                       ; Exit
0105                       ;------------------------------------------------------
0106 6E48 C2F9  30         mov   *stack+,r11           ; Pop r11
0107 6E4A 045B  20         b     *r11                  ; Return to caller
0108               
0109               
0110               
0111               ***************************************************************
0112               * Stub for "pane.cursor.blink"
0113               * bank1 vec.28
0114               ********|*****|*********************|**************************
0115               pane.cursor.blink:
0116 6E4C 0649  14         dect  stack
0117 6E4E C64B  30         mov   r11,*stack            ; Save return address
0118                       ;------------------------------------------------------
0119                       ; Call function in bank 1
0120                       ;------------------------------------------------------
0121 6E50 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6E52 30A4     
0122 6E54 6002                   data bank1.rom        ; | i  p0 = bank address
0123 6E56 7FF6                   data vec.28           ; | i  p1 = Vector with target address
0124 6E58 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0125                       ;------------------------------------------------------
0126                       ; Exit
0127                       ;------------------------------------------------------
0128 6E5A C2F9  30         mov   *stack+,r11           ; Pop r11
0129 6E5C 045B  20         b     *r11                  ; Return to caller
0130               
0131               
0132               ***************************************************************
0133               * Stub for "pane.cursor.hide"
0134               * bank1 vec.29
0135               ********|*****|*********************|**************************
0136               pane.cursor.hide:
0137 6E5E 0649  14         dect  stack
0138 6E60 C64B  30         mov   r11,*stack            ; Save return address
0139                       ;------------------------------------------------------
0140                       ; Call function in bank 1
0141                       ;------------------------------------------------------
0142 6E62 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6E64 30A4     
0143 6E66 6002                   data bank1.rom        ; | i  p0 = bank address
0144 6E68 7FF8                   data vec.29           ; | i  p1 = Vector with target address
0145 6E6A 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0146                       ;------------------------------------------------------
0147                       ; Exit
0148                       ;------------------------------------------------------
0149 6E6C C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6E6E 045B  20         b     *r11                  ; Return to caller
0151               
0152               
0153               ***************************************************************
0154               * Stub for "pane.errline.show"
0155               * bank1 vec.30
0156               ********|*****|*********************|**************************
0157               pane.errline.show:
0158 6E70 0649  14         dect  stack
0159 6E72 C64B  30         mov   r11,*stack            ; Save return address
0160                       ;------------------------------------------------------
0161                       ; Call function in bank 1
0162                       ;------------------------------------------------------
0163 6E74 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6E76 30A4     
0164 6E78 6002                   data bank1.rom        ; | i  p0 = bank address
0165 6E7A 7FFA                   data vec.30           ; | i  p1 = Vector with target address
0166 6E7C 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0167                       ;------------------------------------------------------
0168                       ; Exit
0169                       ;------------------------------------------------------
0170 6E7E C2F9  30         mov   *stack+,r11           ; Pop r11
0171 6E80 045B  20         b     *r11                  ; Return to caller
0172               
0173               
0174               ***************************************************************
0175               * Stub for "pane.action.colorscheme.load"
0176               * bank1 vec.31
0177               ********|*****|*********************|**************************
0178               pane.action.colorscheme.load:
0179 6E82 0649  14         dect  stack
0180 6E84 C64B  30         mov   r11,*stack            ; Save return address
0181                       ;------------------------------------------------------
0182                       ; Call function in bank 1
0183                       ;------------------------------------------------------
0184 6E86 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6E88 30A4     
0185 6E8A 6002                   data bank1.rom        ; | i  p0 = bank address
0186 6E8C 7FFC                   data vec.31           ; | i  p1 = Vector with target address
0187 6E8E 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0188                       ;------------------------------------------------------
0189                       ; Exit
0190                       ;------------------------------------------------------
0191 6E90 C2F9  30         mov   *stack+,r11           ; Pop r11
0192 6E92 045B  20         b     *r11                  ; Return to caller
0193               
0194               
0195               ***************************************************************
0196               
0197               ; TODO Include _trampoline.bank1.ret
0198               ; TODO Refactor stubs for using _trampoline.bank1.ret
                   < stevie_b3.asm.61108
0099                       ;-----------------------------------------------------------------------
0100                       ; Basic interpreter
0101                       ;-----------------------------------------------------------------------
0102                       copy  "tibasic.asm"         ; Run TI Basic session
     **** ****     > tibasic.asm
0001               * FILE......: tibasic.asm
0002               * Purpose...: Run console TI Basic
0003               
0004               ***************************************************************
0005               * tibasic
0006               * Run TI Basic session
0007               ***************************************************************
0008               * bl   @tibasic
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * r1 in GPL WS, tmp0, tmp1
0015               *--------------------------------------------------------------
0016               * Remarks
0017               * tibasic >> b @0070 (GPL interpreter/TI Basic) >> isr >> tibasic.return
0018               ********|*****|*********************|**************************
0019               tibasic:
0020 6E94 0649  14         dect  stack
0021 6E96 C64B  30         mov   r11,*stack            ; Save return address
0022 6E98 0649  14         dect  stack
0023 6E9A C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6E9C 0649  14         dect  stack
0025 6E9E C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;-------------------------------------------------------
0027                       ; Setup SAMS memory
0028                       ;-------------------------------------------------------
0029 6EA0 06A0  32         bl    @sams.layout.copy     ; Backup Stevie SAMS page layout
     6EA2 265A     
0030 6EA4 A200                   data tv.sams.2000     ; \ @i = target address of 8 words table
0031                                                   ; /      that contains SAMS layout
0032               
0033               
0034 6EA6 06A0  32         bl    @scroff               ; Turn off screen
     6EA8 26A2     
0035               
0036 6EAA 06A0  32         bl    @sams.layout
     6EAC 25F6     
0037 6EAE 36A0                   data mem.sams.external
0038                                                   ; Load SAMS page layout for calling an
0039                                                   ; external program.
0040               
0041 6EB0 06A0  32         bl    @cpyv2m
     6EB2 24CC     
0042 6EB4 0000                   data >0000,>b000,16384
     6EB6 B000     
     6EB8 4000     
0043                                                   ; Copy Stevie 16K VDP memory to RAM buffer
0044                                                   ; buffer >b000->efff
0045               
0046 6EBA 06A0  32         bl    @sams.layout
     6EBC 25F6     
0047 6EBE 36C0                   data mem.sams.tibasic ; Load SAMS page layout for TI Basic
0048                       ;-------------------------------------------------------
0049                       ; Put VDP in TI Basic compatible mode (32x24)
0050                       ;-------------------------------------------------------
0051 6EC0 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     6EC2 27B0     
0052               
0053 6EC4 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6EC6 230C     
0054 6EC8 365E                   data tibasic.32x24    ; Equate selected video mode table
0055               
0056                     ;  bl    @f18unl               ; Unlock the F18a
0057               
0058                     ;  bl    @putvr                ; Turn on 30 rows mode.
0059                     ;        data >3140            ; F18a VR49 (>31).
0060                       ;-------------------------------------------------------
0061                       ; Resume existing TI Basic session?
0062                       ;-------------------------------------------------------
0063 6ECA C820  54         mov   @tibasic.status,@tibasic.status
     6ECC A02C     
     6ECE A02C     
0064                                                   ; New TI-Basic session?
0065 6ED0 152E  14         jgt   tibasic.resume        ; No, resume existing session
0066                       ;-------------------------------------------------------
0067                       ; New TI Basic session
0068                       ;-------------------------------------------------------
0069               tibasic.init:
0070 6ED2 06A0  32         bl    @cpym2m
     6ED4 24EE     
0071 6ED6 7E00                   data cpu.scrpad.src,cpu.scrpad.tgt,256
     6ED8 F960     
     6EDA 0100     
0072                                                   ; Initialize TI Basic scrpad memory in
0073                                                   ; @cpu.scrpad.tgt (SAMS bank #08) with dump
0074                                                   ; of OS Monitor scrpad stored at
0075                                                   ; @cpu.scrpad.src (bank 3).
0076               
0077 6EDC 06A0  32         bl    @ldfnt
     6EDE 2374     
0078 6EE0 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     6EE2 000C     
0079               
0080 6EE4 06A0  32         bl    @filv
     6EE6 22A2     
0081 6EE8 0300                   data >0300,>D0,2      ; No sprites
     6EEA 00D0     
     6EEC 0002     
0082               
0083 6EEE 06A0  32         bl    @cpu.scrpad.pgout     ; \ Copy 256 bytes stevie scratchpad to
     6EF0 2C56     
0084 6EF2 AD00                   data scrpad.copy      ; | >ad00 and then load TI Basic scrpad from
0085                                                   ; / predefined address @cpu.scrpad.target
0086               
0087 6EF4 04CB  14         clr   r11
0088 6EF6 C820  54         mov   @tibasic.scrpad.83d4,@>83d4
     6EF8 6F42     
     6EFA 83D4     
0089 6EFC C820  54         mov   @tibasic.scrpad.83fa,@>83fa
     6EFE 6F44     
     6F00 83FA     
0090 6F02 C820  54         mov   @tibasic.scrpad.83fc,@>83fc
     6F04 6F46     
     6F06 83FC     
0091 6F08 C820  54         mov   @tibasic.scrpad.83fe,@>83fe
     6F0A 6F48     
     6F0C 83FE     
0092                       ;-------------------------------------------------------
0093                       ; Register ISR hook
0094                       ;-------------------------------------------------------
0095 6F0E 0201  20         li    r1,isr                ; \
     6F10 6F4A     
0096 6F12 C801  38         mov   r1,@>83c4             ; | >83c4 = Pointer to start address of ISR
     6F14 83C4     
0097                                                   ; /
0098                       ;-------------------------------------------------------
0099                       ; Run TI Basic session in GPL Interpreter
0100                       ;-------------------------------------------------------
0101 6F16 02E0  18         lwpi  >83e0
     6F18 83E0     
0102 6F1A 0201  20         li    r1,>216f              ; Entrypoint for GPL TI Basic interpreter
     6F1C 216F     
0103 6F1E D801  38         movb  r1,@grmwa             ; \
     6F20 9C02     
0104 6F22 06C1  14         swpb  r1                    ; | Set GPL address
0105 6F24 D801  38         movb  r1,@grmwa             ; /
     6F26 9C02     
0106 6F28 1000  14         nop
0107 6F2A 0460  28         b     @>70                  ; Start GPL interpreter
     6F2C 0070     
0108                       ;-------------------------------------------------------
0109                       ; Resume existing TI-Basic session
0110                       ;-------------------------------------------------------
0111               tibasic.resume:
0112 6F2E 06A0  32         bl    @cpym2v
     6F30 249A     
0113 6F32 0000                   data >0000,>b000,16384
     6F34 B000     
     6F36 4000     
0114                                                   ; Restore TI Basic 16K VDP memory from
0115                                                   ; RAM buffer >b000->efff (SAMS pages #04-07)
0116               
0117 6F38 06A0  32         bl    @cpu.scrpad.pgout     ; \ Copy 256 bytes stevie scratchpad to
     6F3A 2C56     
0118 6F3C AD00                   data scrpad.copy      ; | >ad00 and then load TI Basic scrpad from
0119                                                   ; / predefined address @cpu.scrpad.target
0120               
0121 6F3E 0460  28         b     @>0ab8                ; Return from interrupt routine.
     6F40 0AB8     
0122                                                   ; See TI Intern page 32 (german)
0123                       ;-------------------------------------------------------
0124                       ; Required values for scratchpad
0125                       ;-------------------------------------------------------
0126               tibasic.scrpad.83d4:
0127 6F42 E0D5             data  >e0d5
0128               tibasic.scrpad.83fa:
0129 6F44 9800             data  >9800
0130               tibasic.scrpad.83fc:
0131 6F46 0108             data  >0108
0132               tibasic.scrpad.83fe:
0133 6F48 8C02             data  >8c02
0134               
0135               
0136               
0137               ***************************************************************
0138               * isr
0139               * Interrupt Service Routine in TI Basic
0140               ***************************************************************
0141               * Called from console rom at >0ab6
0142               * See TI Intern page 32 (german) for details
0143               *--------------------------------------------------------------
0144               * OUTPUT
0145               * none
0146               *--------------------------------------------------------------
0147               * Register usage
0148               * r7, 12
0149               ********|*****|*********************|**************************
0150               isr:
0151 6F4A 0300  24         limi  0                     ; \ Turn off interrupts
     6F4C 0000     
0152                                                   ; / Prevent ISR reentry
0153               
0154 6F4E C807  38         mov   r7,@rambuf            ; Backup R7
     6F50 A140     
0155 6F52 C80C  38         mov   r12,@rambuf+2         ; Backup R12
     6F54 A142     
0156                       ;-------------------------------------------------------
0157                       ; Hotkey pressed?
0158                       ;-------------------------------------------------------
0159 6F56 C1E0  34         mov   @>8374,r7             ; Get keyboard scancode
     6F58 8374     
0160 6F5A 0247  22         andi  r7,>00ff              ; LSB only
     6F5C 00FF     
0161 6F5E 0287  22         ci    r7,>0f                ; Hotkey fctn + '9' pressed?
     6F60 000F     
0162 6F62 1305  14         jeq   tibasic.return        ; Yes, return to Stevie
0163                       ;-------------------------------------------------------
0164                       ; Return from ISR
0165                       ;-------------------------------------------------------
0166               isr.exit:
0167 6F64 C320  34         mov   @rambuf+2,r12         ; Restore R12
     6F66 A142     
0168 6F68 C1E0  34         mov   @rambuf,r7            ; Restore R7
     6F6A A140     
0169 6F6C 045B  20         b     *r11                  ; Return from ISR
0170               
0171               
0172               
0173               ***************************************************************
0174               * tibasic.return
0175               * Return from TI Basic to Stevie
0176               ***************************************************************
0177               * bl   @tibasic.return
0178               *--------------------------------------------------------------
0179               * OUTPUT
0180               * none
0181               *--------------------------------------------------------------
0182               * Register usage
0183               * r1 in GPL WS, tmp0, tmp1
0184               *--------------------------------------------------------------
0185               * REMARKS
0186               * Called from ISR code
0187               ********|*****|*********************|**************************
0188               tibasic.return:
0189 6F6E 02E0  18         lwpi  >ad00                 ; Activate Stevie workspace in core RAM 2
     6F70 AD00     
0190               
0191               
0192 6F72 D820  54         movb  @w$ffff,@>8375        ; Reset keycode
     6F74 2022     
     6F76 8375     
0193               
0194 6F78 06A0  32         bl    @cpym2m
     6F7A 24EE     
0195 6F7C 8300                   data >8300,cpu.scrpad.tgt,256
     6F7E F960     
     6F80 0100     
0196                                                   ; Backup TI Basic scratchpad to
0197                                                   ; @cpu.scrpad.tgt (SAMS bank #08)
0198               
0199 6F82 06A0  32         bl    @cpu.scrpad.pgin      ; Page in copy of Stevie scratch pad memory
     6F84 2C94     
0200 6F86 AD00                   data scrpad.copy      ; and activate workspace at >8300
0201               
0202 6F88 06A0  32         bl    @mute                 ; Mute sound generators
     6F8A 2804     
0203                       ;-------------------------------------------------------
0204                       ; Cleanup after return from TI Basic
0205                       ;-------------------------------------------------------
0206 6F8C 06A0  32         bl    @scroff               ; Turn screen off
     6F8E 26A2     
0207 6F90 06A0  32         bl    @cpyv2m
     6F92 24CC     
0208 6F94 0000                   data >0000,>b000,16384
     6F96 B000     
     6F98 4000     
0209                                                   ; Dump TI Basic 16K VDP memory to ram buffer
0210                                                   ; >b000->efff
0211               
0212 6F9A C160  34         mov   @tibasic.status,tmp1  ; \
     6F9C A02C     
0213 6F9E 0265  22         ori   tmp1,1                ; | Set TI Basic reentry flag
     6FA0 0001     
0214 6FA2 C805  38         mov   tmp1,@tibasic.status  ; /
     6FA4 A02C     
0215               
0216               
0217 6FA6 06A0  32         bl    @sams.layout
     6FA8 25F6     
0218 6FAA 36A0                   data mem.sams.external
0219                                                   ; Load SAMS page layout for returning from
0220                                                   ; external program.
0221               
0222 6FAC 06A0  32         bl    @cpym2v
     6FAE 249A     
0223 6FB0 0000                   data >0000,>b000,16384
     6FB2 B000     
     6FB4 4000     
0224                                                   ; Restore Stevie 16K to VDP from RAM buffer
0225                                                   ; >b000->efff
0226                       ;-------------------------------------------------------
0227                       ; Restore SAMS memory layout for Stevie
0228                       ;-------------------------------------------------------
0229 6FB6 C120  34         mov   @tv.sams.b000,tmp0
     6FB8 A206     
0230 6FBA 0205  20         li    tmp1,>b000
     6FBC B000     
0231 6FBE 06A0  32         bl    @xsams.page.set       ; Set sams page for address >b000
     6FC0 258A     
0232               
0233 6FC2 C120  34         mov   @tv.sams.c000,tmp0
     6FC4 A208     
0234 6FC6 0205  20         li    tmp1,>c000
     6FC8 C000     
0235 6FCA 06A0  32         bl    @xsams.page.set       ; Set sams page for address >c000
     6FCC 258A     
0236               
0237 6FCE C120  34         mov   @tv.sams.d000,tmp0
     6FD0 A20A     
0238 6FD2 0205  20         li    tmp1,>d000
     6FD4 D000     
0239 6FD6 06A0  32         bl    @xsams.page.set       ; Set sams page for address >d000
     6FD8 258A     
0240               
0241 6FDA C120  34         mov   @tv.sams.e000,tmp0
     6FDC A20C     
0242 6FDE 0205  20         li    tmp1,>e000
     6FE0 E000     
0243 6FE2 06A0  32         bl    @xsams.page.set       ; Set sams page for address >e000
     6FE4 258A     
0244               
0245 6FE6 C120  34         mov   @tv.sams.f000,tmp0
     6FE8 A20E     
0246 6FEA 0205  20         li    tmp1,>f000
     6FEC F000     
0247 6FEE 06A0  32         bl    @xsams.page.set       ; Set sams page for address >f000
     6FF0 258A     
0248                       ;-------------------------------------------------------
0249                       ; Setup F18a 80x30 mode again
0250                       ;-------------------------------------------------------
0251 6FF2 06A0  32         bl    @f18unl               ; Unlock the F18a
     6FF4 2746     
0253               
0254 6FF6 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6FF8 2346     
0255 6FFA 3140                   data >3140            ; F18a VR49 (>31), bit 40
0256               
0258               
0259 6FFC 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6FFE 230C     
0260 7000 3654                   data stevie.80x30     ; Equate selected video mode table
0261               
0262 7002 06A0  32         bl    @putvr                ; Turn on position based attributes
     7004 2346     
0263 7006 3202                   data >3202            ; F18a VR50 (>32), bit 2
0264               
0265 7008 06A0  32         bl    @putvr                ; Set VDP TAT base address for position
     700A 2346     
0266 700C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0267               
0268 700E 04E0  34         clr   @parm1                ; Screen off while reloading color scheme
     7010 A000     
0269 7012 06A0  32         bl    @pane.action.colorscheme.load
     7014 6E82     
0270                                                   ; Reload color scheme
0271                                                   ; i  parm1 = Skip screen off if >FFFF
0272                       ;------------------------------------------------------
0273                       ; Exit
0274                       ;------------------------------------------------------
0275               tibasic.return.exit:
0276 7016 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0277 7018 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0278 701A C2F9  30         mov   *stack+,r11           ; Pop r11
0279 701C 045B  20         b     *r11                  ; Return
                   < stevie_b3.asm.61108
0103                       ;-----------------------------------------------------------------------
0104                       ; Program data
0105                       ;-----------------------------------------------------------------------
0106                       copy  "data.strings.bank3.asm"  ; Strings used in bank 3
     **** ****     > data.strings.bank3.asm
0001               * FILE......: data.strings.bank3.asm
0002               * Purpose...: Strings used in Stevie bank 3
0003               
0004               
0005               ***************************************************************
0006               *                       Strings
0007               ***************************************************************
0008               
0009 701E 2053     txt.stevie         text ' Stevie 1.2H '
     7020 7465     
     7022 7669     
     7024 6520     
     7026 312E     
     7028 3248     
     702A 20       
0010               
0011               ;--------------------------------------------------------------
0012               ; Dialog "Load file"
0013               ;--------------------------------------------------------------
0014 702B   0E     txt.head.load      byte 14,1,1
     702C 0101     
0015 702E 204F                        text ' Open file '
     7030 7065     
     7032 6E20     
     7034 6669     
     7036 6C65     
     7038 20       
0016 7039   01                        byte 1
0017               txt.hint.load
0018 703A 1E               byte  30
0019 703B   47             text  'Give filename of file to open.'
     703C 6976     
     703E 6520     
     7040 6669     
     7042 6C65     
     7044 6E61     
     7046 6D65     
     7048 206F     
     704A 6620     
     704C 6669     
     704E 6C65     
     7050 2074     
     7052 6F20     
     7054 6F70     
     7056 656E     
     7058 2E       
0020                       even
0021               
0022               
0023               txt.keys.load
0024 705A 1E               byte  30
0025 705B   46             text  'F9-Back  F3-Clear  F5-Fastmode'
     705C 392D     
     705E 4261     
     7060 636B     
     7062 2020     
     7064 4633     
     7066 2D43     
     7068 6C65     
     706A 6172     
     706C 2020     
     706E 4635     
     7070 2D46     
     7072 6173     
     7074 746D     
     7076 6F64     
     7078 65       
0026                       even
0027               
0028               txt.keys.load2
0029 707A 1F               byte  31
0030 707B   46             text  'F9-Back  F3-Clear  *F5-Fastmode'
     707C 392D     
     707E 4261     
     7080 636B     
     7082 2020     
     7084 4633     
     7086 2D43     
     7088 6C65     
     708A 6172     
     708C 2020     
     708E 2A46     
     7090 352D     
     7092 4661     
     7094 7374     
     7096 6D6F     
     7098 6465     
0031                       even
0032               
0033               
0034               ;--------------------------------------------------------------
0035               ; Dialog "Save file"
0036               ;--------------------------------------------------------------
0037 709A 0E01     txt.head.save      byte 14,1,1
     709C 01       
0038 709D   20                        text ' Save file '
     709E 5361     
     70A0 7665     
     70A2 2066     
     70A4 696C     
     70A6 6520     
0039 70A8 01                          byte 1
0040 70A9   16     txt.head.save2     byte 22,1,1
     70AA 0101     
0041 70AC 2053                        text ' Save block to file '
     70AE 6176     
     70B0 6520     
     70B2 626C     
     70B4 6F63     
     70B6 6B20     
     70B8 746F     
     70BA 2066     
     70BC 696C     
     70BE 6520     
0042 70C0 01                          byte 1
0043               txt.hint.save
0044 70C1   1E             byte  30
0045 70C2 4769             text  'Give filename of file to save.'
     70C4 7665     
     70C6 2066     
     70C8 696C     
     70CA 656E     
     70CC 616D     
     70CE 6520     
     70D0 6F66     
     70D2 2066     
     70D4 696C     
     70D6 6520     
     70D8 746F     
     70DA 2073     
     70DC 6176     
     70DE 652E     
0046                       even
0047               
0048               txt.keys.save
0049 70E0 11               byte  17
0050 70E1   46             text  'F9-Back  F3-Clear'
     70E2 392D     
     70E4 4261     
     70E6 636B     
     70E8 2020     
     70EA 4633     
     70EC 2D43     
     70EE 6C65     
     70F0 6172     
0051                       even
0052               
0053               
0054               
0055               ;--------------------------------------------------------------
0056               ; Dialog "Insert file"
0057               ;--------------------------------------------------------------
0058 70F2 1801     txt.head.insert    byte 24,1,1
     70F4 01       
0059 70F5   20                        text ' Insert file at line '
     70F6 496E     
     70F8 7365     
     70FA 7274     
     70FC 2066     
     70FE 696C     
     7100 6520     
     7102 6174     
     7104 206C     
     7106 696E     
     7108 6520     
0060 710A 01                          byte 1
0061               txt.hint.insert
0062 710B   20             byte  32
0063 710C 4769             text  'Give filename of file to insert.'
     710E 7665     
     7110 2066     
     7112 696C     
     7114 656E     
     7116 616D     
     7118 6520     
     711A 6F66     
     711C 2066     
     711E 696C     
     7120 6520     
     7122 746F     
     7124 2069     
     7126 6E73     
     7128 6572     
     712A 742E     
0064                       even
0065               
0066               
0067               txt.keys.insert
0068 712C 1E               byte  30
0069 712D   46             text  'F9-Back  F3-Clear  F5-Fastmode'
     712E 392D     
     7130 4261     
     7132 636B     
     7134 2020     
     7136 4633     
     7138 2D43     
     713A 6C65     
     713C 6172     
     713E 2020     
     7140 4635     
     7142 2D46     
     7144 6173     
     7146 746D     
     7148 6F64     
     714A 65       
0070                       even
0071               
0072               txt.keys.insert2
0073 714C 1F               byte  31
0074 714D   46             text  'F9-Back  F3-Clear  *F5-Fastmode'
     714E 392D     
     7150 4261     
     7152 636B     
     7154 2020     
     7156 4633     
     7158 2D43     
     715A 6C65     
     715C 6172     
     715E 2020     
     7160 2A46     
     7162 352D     
     7164 4661     
     7166 7374     
     7168 6D6F     
     716A 6465     
0075                       even
0076               
0077               
0078               
0079               ;--------------------------------------------------------------
0080               ; Dialog "Configure clipboard device"
0081               ;--------------------------------------------------------------
0082 716C 1F01     txt.head.clipdev   byte 31,1,1
     716E 01       
0083 716F   20                        text ' Configure clipboard device '
     7170 436F     
     7172 6E66     
     7174 6967     
     7176 7572     
     7178 6520     
     717A 636C     
     717C 6970     
     717E 626F     
     7180 6172     
     7182 6420     
     7184 6465     
     7186 7669     
     7188 6365     
     718A 20       
0084 718B   01                        byte 1
0085               txt.hint.clipdev
0086 718C 2D               byte  45
0087 718D   47             text  'Give device and filename prefix of clipboard.'
     718E 6976     
     7190 6520     
     7192 6465     
     7194 7669     
     7196 6365     
     7198 2061     
     719A 6E64     
     719C 2066     
     719E 696C     
     71A0 656E     
     71A2 616D     
     71A4 6520     
     71A6 7072     
     71A8 6566     
     71AA 6978     
     71AC 206F     
     71AE 6620     
     71B0 636C     
     71B2 6970     
     71B4 626F     
     71B6 6172     
     71B8 642E     
0088                       even
0089               
0090               txt.keys.clipdev
0091 71BA 42               byte  66
0092 71BB   46             text  'F9-Back  F3-Clear  ^A=DSK1.CLIP  ^B=DSK8.CLIP  ^C=TIPI.STEVIE.CLIP'
     71BC 392D     
     71BE 4261     
     71C0 636B     
     71C2 2020     
     71C4 4633     
     71C6 2D43     
     71C8 6C65     
     71CA 6172     
     71CC 2020     
     71CE 5E41     
     71D0 3D44     
     71D2 534B     
     71D4 312E     
     71D6 434C     
     71D8 4950     
     71DA 2020     
     71DC 5E42     
     71DE 3D44     
     71E0 534B     
     71E2 382E     
     71E4 434C     
     71E6 4950     
     71E8 2020     
     71EA 5E43     
     71EC 3D54     
     71EE 4950     
     71F0 492E     
     71F2 5354     
     71F4 4556     
     71F6 4945     
     71F8 2E43     
     71FA 4C49     
     71FC 50       
0093                       even
0094               
0095               
0096               
0097               ;--------------------------------------------------------------
0098               ; Dialog "Copy clipboard"
0099               ;--------------------------------------------------------------
0100 71FE 1B01     txt.head.clipboard byte 27,1,1
     7200 01       
0101 7201   20                        text ' Copy clipboard to line '
     7202 436F     
     7204 7079     
     7206 2063     
     7208 6C69     
     720A 7062     
     720C 6F61     
     720E 7264     
     7210 2074     
     7212 6F20     
     7214 6C69     
     7216 6E65     
     7218 20       
0102 7219   01                        byte 1
0103               txt.info.clipboard
0104 721A 10               byte  16
0105 721B   43             text  'Clipboard [1-5]?'
     721C 6C69     
     721E 7062     
     7220 6F61     
     7222 7264     
     7224 205B     
     7226 312D     
     7228 355D     
     722A 3F       
0106                       even
0107               
0108               txt.hint.clipboard
0109 722C 47               byte  71
0110 722D   50             text  'Press 1 to 5 to copy clipboard, press F7 to configure clipboard device.'
     722E 7265     
     7230 7373     
     7232 2031     
     7234 2074     
     7236 6F20     
     7238 3520     
     723A 746F     
     723C 2063     
     723E 6F70     
     7240 7920     
     7242 636C     
     7244 6970     
     7246 626F     
     7248 6172     
     724A 642C     
     724C 2070     
     724E 7265     
     7250 7373     
     7252 2046     
     7254 3720     
     7256 746F     
     7258 2063     
     725A 6F6E     
     725C 6669     
     725E 6775     
     7260 7265     
     7262 2063     
     7264 6C69     
     7266 7062     
     7268 6F61     
     726A 7264     
     726C 2064     
     726E 6576     
     7270 6963     
     7272 652E     
0111                       even
0112               
0113               
0114               txt.keys.clipboard
0115 7274 22               byte  34
0116 7275   46             text  'F9-Back  F5-Fastmode  F7-Configure'
     7276 392D     
     7278 4261     
     727A 636B     
     727C 2020     
     727E 4635     
     7280 2D46     
     7282 6173     
     7284 746D     
     7286 6F64     
     7288 6520     
     728A 2046     
     728C 372D     
     728E 436F     
     7290 6E66     
     7292 6967     
     7294 7572     
     7296 65       
0117                       even
0118               
0119               txt.keys.clipboard2
0120 7298 23               byte  35
0121 7299   46             text  'F9-Back  *F5-Fastmode  F7-Configure'
     729A 392D     
     729C 4261     
     729E 636B     
     72A0 2020     
     72A2 2A46     
     72A4 352D     
     72A6 4661     
     72A8 7374     
     72AA 6D6F     
     72AC 6465     
     72AE 2020     
     72B0 4637     
     72B2 2D43     
     72B4 6F6E     
     72B6 6669     
     72B8 6775     
     72BA 7265     
0122                       even
0123               
0124               
0125               
0126               ;--------------------------------------------------------------
0127               ; Dialog "Print file"
0128               ;--------------------------------------------------------------
0129 72BC 0F01     txt.head.print     byte 15,1,1
     72BE 01       
0130 72BF   20                        text ' Print file '
     72C0 5072     
     72C2 696E     
     72C4 7420     
     72C6 6669     
     72C8 6C65     
     72CA 20       
0131 72CB   01                        byte 1
0132 72CC 1001     txt.head.print2    byte 16,1,1
     72CE 01       
0133 72CF   20                        text ' Print block '
     72D0 5072     
     72D2 696E     
     72D4 7420     
     72D6 626C     
     72D8 6F63     
     72DA 6B20     
0134 72DC 01                          byte 1
0135               txt.hint.print
0136 72DD   2B             byte  43
0137 72DE 4769             text  'Give printer device name (PIO, PI.PIO, ...)'
     72E0 7665     
     72E2 2070     
     72E4 7269     
     72E6 6E74     
     72E8 6572     
     72EA 2064     
     72EC 6576     
     72EE 6963     
     72F0 6520     
     72F2 6E61     
     72F4 6D65     
     72F6 2028     
     72F8 5049     
     72FA 4F2C     
     72FC 2050     
     72FE 492E     
     7300 5049     
     7302 4F2C     
     7304 202E     
     7306 2E2E     
     7308 29       
0138                       even
0139               
0140               txt.keys.print
0141 730A 11               byte  17
0142 730B   46             text  'F9-Back  F3-Clear'
     730C 392D     
     730E 4261     
     7310 636B     
     7312 2020     
     7314 4633     
     7316 2D43     
     7318 6C65     
     731A 6172     
0143                       even
0144               
0145               
0146               ;--------------------------------------------------------------
0147               ; Dialog "Unsaved changes"
0148               ;--------------------------------------------------------------
0149 731C 1401     txt.head.unsaved   byte 20,1,1
     731E 01       
0150 731F   20                        text ' Unsaved changes '
     7320 556E     
     7322 7361     
     7324 7665     
     7326 6420     
     7328 6368     
     732A 616E     
     732C 6765     
     732E 7320     
0151 7330 01                          byte 1
0152               txt.info.unsaved
0153 7331   21             byte  33
0154 7332 5761             text  'Warning! Unsaved changes in file.'
     7334 726E     
     7336 696E     
     7338 6721     
     733A 2055     
     733C 6E73     
     733E 6176     
     7340 6564     
     7342 2063     
     7344 6861     
     7346 6E67     
     7348 6573     
     734A 2069     
     734C 6E20     
     734E 6669     
     7350 6C65     
     7352 2E       
0155                       even
0156               
0157               txt.hint.unsaved
0158 7354 37               byte  55
0159 7355   50             text  'Press F6 or SPACE to proceed. Press ENTER to save file.'
     7356 7265     
     7358 7373     
     735A 2046     
     735C 3620     
     735E 6F72     
     7360 2053     
     7362 5041     
     7364 4345     
     7366 2074     
     7368 6F20     
     736A 7072     
     736C 6F63     
     736E 6565     
     7370 642E     
     7372 2050     
     7374 7265     
     7376 7373     
     7378 2045     
     737A 4E54     
     737C 4552     
     737E 2074     
     7380 6F20     
     7382 7361     
     7384 7665     
     7386 2066     
     7388 696C     
     738A 652E     
0160                       even
0161               
0162               txt.keys.unsaved
0163 738C 25               byte  37
0164 738D   46             text  'F9-Back  F6/SPACE-Proceed  ENTER-Save'
     738E 392D     
     7390 4261     
     7392 636B     
     7394 2020     
     7396 4636     
     7398 2F53     
     739A 5041     
     739C 4345     
     739E 2D50     
     73A0 726F     
     73A2 6365     
     73A4 6564     
     73A6 2020     
     73A8 454E     
     73AA 5445     
     73AC 522D     
     73AE 5361     
     73B0 7665     
0165                       even
0166               
0167               
0168               ;--------------------------------------------------------------
0169               ; Dialog "Help"
0170               ;--------------------------------------------------------------
0171 73B2 0901     txt.head.about     byte 9,1,1
     73B4 01       
0172 73B5   20                        text ' Help '
     73B6 4865     
     73B8 6C70     
     73BA 20       
0173 73BB   01                        byte 1
0174               
0175               txt.info.about
0176 73BC 02               byte  2
0177 73BD   00             text  ''
0178                       even
0179               
0180               txt.hint.about
0181 73BE 26               byte  38
0182 73BF   50             text  'Press F9 or ENTER to return to editor.'
     73C0 7265     
     73C2 7373     
     73C4 2046     
     73C6 3920     
     73C8 6F72     
     73CA 2045     
     73CC 4E54     
     73CE 4552     
     73D0 2074     
     73D2 6F20     
     73D4 7265     
     73D6 7475     
     73D8 726E     
     73DA 2074     
     73DC 6F20     
     73DE 6564     
     73E0 6974     
     73E2 6F72     
     73E4 2E       
0183                       even
0184               
0185               txt.keys.about
0186 73E6 13               byte  19
0187 73E7   46             text  'F9-Back  ENTER-Back'
     73E8 392D     
     73EA 4261     
     73EC 636B     
     73EE 2020     
     73F0 454E     
     73F2 5445     
     73F4 522D     
     73F6 4261     
     73F8 636B     
0188                       even
0189               
0190               txt.about.build
0191 73FA 4C               byte  76
0192 73FB   42             text  'Build: 211205-1903310 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
     73FC 7569     
     73FE 6C64     
     7400 3A20     
     7402 3231     
     7404 3132     
     7406 3035     
     7408 2D31     
     740A 3930     
     740C 3333     
     740E 3130     
     7410 202F     
     7412 2032     
     7414 3031     
     7416 382D     
     7418 3230     
     741A 3231     
     741C 2046     
     741E 696C     
     7420 6970     
     7422 2056     
     7424 616E     
     7426 2056     
     7428 6F6F     
     742A 7265     
     742C 6E20     
     742E 2F20     
     7430 7265     
     7432 7472     
     7434 6F63     
     7436 6C6F     
     7438 7564     
     743A 7320     
     743C 6F6E     
     743E 2041     
     7440 7461     
     7442 7269     
     7444 6167     
     7446 65       
0193                       even
0194               
0195               
0196               
0197               ;--------------------------------------------------------------
0198               ; Dialog "Main Menu"
0199               ;--------------------------------------------------------------
0200 7448 0E01     txt.head.menu      byte 14,1,1
     744A 01       
0201 744B   20                        text ' Main Menu '
     744C 4D61     
     744E 696E     
     7450 204D     
     7452 656E     
     7454 7520     
0202 7456 01                          byte 1
0203               
0204               txt.info.menu
0205 7457   1A             byte  26
0206 7458 4669             text  'File   Basic   Help   Quit'
     745A 6C65     
     745C 2020     
     745E 2042     
     7460 6173     
     7462 6963     
     7464 2020     
     7466 2048     
     7468 656C     
     746A 7020     
     746C 2020     
     746E 5175     
     7470 6974     
0207                       even
0208               
0209 7472 0007     pos.info.menu      byte 0,7,15,22,>ff
     7474 0F16     
     7476 FF       
0210               txt.hint.menu
0211 7477   01             byte  1
0212 7478 20               text  ' '
0213                       even
0214               
0215               txt.keys.menu
0216 747A 07               byte  7
0217 747B   46             text  'F9-Back'
     747C 392D     
     747E 4261     
     7480 636B     
0218                       even
0219               
0220               
0221               
0222               ;--------------------------------------------------------------
0223               ; Dialog "File"
0224               ;--------------------------------------------------------------
0225 7482 0901     txt.head.file      byte 9,1,1
     7484 01       
0226 7485   20                        text ' File '
     7486 4669     
     7488 6C65     
     748A 20       
0227 748B   01                        byte 1
0228               
0229               txt.info.file
0230 748C 25               byte  37
0231 748D   4E             text  'New   Open   Save   Print   Configure'
     748E 6577     
     7490 2020     
     7492 204F     
     7494 7065     
     7496 6E20     
     7498 2020     
     749A 5361     
     749C 7665     
     749E 2020     
     74A0 2050     
     74A2 7269     
     74A4 6E74     
     74A6 2020     
     74A8 2043     
     74AA 6F6E     
     74AC 6669     
     74AE 6775     
     74B0 7265     
0232                       even
0233               
0234 74B2 0006     pos.info.file      byte 0,6,13,20,28,>ff
     74B4 0D14     
     74B6 1CFF     
0235               txt.hint.file
0236 74B8 01               byte  1
0237 74B9   20             text  ' '
0238                       even
0239               
0240               txt.keys.file
0241 74BA 07               byte  7
0242 74BB   46             text  'F9-Back'
     74BC 392D     
     74BE 4261     
     74C0 636B     
0243                       even
0244               
0245               
0246               
0247               ;--------------------------------------------------------------
0248               ; Dialog "Basic"
0249               ;--------------------------------------------------------------
0250 74C2 0E01     txt.head.basic     byte 14,1,1
     74C4 01       
0251 74C5   20                        text ' Run basic '
     74C6 5275     
     74C8 6E20     
     74CA 6261     
     74CC 7369     
     74CE 6320     
0252 74D0 01                          byte 1
0253               
0254               txt.info.basic
0255 74D1   1C             byte  28
0256 74D2 5449             text  'TI Basic   TI Extended Basic'
     74D4 2042     
     74D6 6173     
     74D8 6963     
     74DA 2020     
     74DC 2054     
     74DE 4920     
     74E0 4578     
     74E2 7465     
     74E4 6E64     
     74E6 6564     
     74E8 2042     
     74EA 6173     
     74EC 6963     
0257                       even
0258               
0259 74EE 030E     pos.info.basic     byte 3,14,>ff
     74F0 FF       
0260               txt.hint.basic
0261 74F1   01             byte  1
0262 74F2 20               text  ' '
0263                       even
0264               
0265               txt.keys.basic
0266 74F4 07               byte  7
0267 74F5   46             text  'F9-Back'
     74F6 392D     
     74F8 4261     
     74FA 636B     
0268                       even
0269               
0270               
0271               
0272               ;--------------------------------------------------------------
0273               ; Dialog "Configure"
0274               ;--------------------------------------------------------------
0275 74FC 0E01     txt.head.config    byte 14,1,1
     74FE 01       
0276 74FF   20                        text ' Configure '
     7500 436F     
     7502 6E66     
     7504 6967     
     7506 7572     
     7508 6520     
0277 750A 01                          byte 1
0278               
0279               txt.info.config
0280 750B   09             byte  9
0281 750C 436C             text  'Clipboard'
     750E 6970     
     7510 626F     
     7512 6172     
     7514 64       
0282                       even
0283               
0284 7516 00FF     pos.info.config    byte 0,>ff
0285               txt.hint.config
0286 7518 01               byte  1
0287 7519   20             text  ' '
0288                       even
0289               
0290               txt.keys.config
0291 751A 07               byte  7
0292 751B   46             text  'F9-Back'
     751C 392D     
     751E 4261     
     7520 636B     
0293                       even
0294               
                   < stevie_b3.asm.61108
0107                       copy  "data.keymap.presets.asm" ; Shortcut presets in dialogs
     **** ****     > data.keymap.presets.asm
0001               * FILE......: data.keymap.presets.asm
0002               * Purpose...: Shortcut presets in dialogs
0003               
0004               *---------------------------------------------------------------
0005               * Shorcut presets for dialogs
0006               *-------------|---------------------|---------------------------
0007               cmdb.cmd.preset.data:
0008                       ;-------------------------------------------------------
0009                       ; Dialog "Configure clipboard device"
0010                       ;-------------------------------------------------------
0011 7522 0010             data  id.dialog.clipdev,key.ctrl.a,def.clip.fname
     7524 0081     
     7526 3A48     
0012 7528 0010             data  id.dialog.clipdev,key.ctrl.b,def.clip.fname.b
     752A 0082     
     752C 3A52     
0013 752E 0010             data  id.dialog.clipdev,key.ctrl.c,def.clip.fname.C
     7530 0083     
     7532 3A5C     
0014                       ;------------------------------------------------------
0015                       ; End of list
0016                       ;-------------------------------------------------------
0017 7534 FFFF             data  EOL                   ; EOL
                   < stevie_b3.asm.61108
0108                       ;-----------------------------------------------------------------------
0109                       ; Bank full check
0110                       ;-----------------------------------------------------------------------
0114                       ;-----------------------------------------------------------------------
0115                       ; Show ROM bank in CPU crash screen
0116                       ;-----------------------------------------------------------------------
0117               cpu.crash.showbank:
0118                       aorg >7fb0
0119 7FB0 06A0  32         bl    @putat
     7FB2 2456     
0120 7FB4 0314                   byte 3,20
0121 7FB6 7FBA                   data cpu.crash.showbank.bankstr
0122 7FB8 10FF  14         jmp   $
0123               cpu.crash.showbank.bankstr:
0124               
0125 7FBA 0D               byte  13
0126 7FBB   52             text  'ROM#3'
     7FBC 4F4D     
     7FBE 2333     
0127                       even
0128               
0129                       ;-----------------------------------------------------------------------
0130                       ; Scratchpad memory dump
0131                       ;-----------------------------------------------------------------------
0132                       aorg >7e00
0133                       copy  "data.scrpad.asm"     ; Required for TI Basic
     **** ****     > data.scrpad.asm
0001               * FILE......: data.scrpad.asm
0002               * Purpose...: Stevie Editor - data segment (scratchpad dump()
0003               
0004               ***************************************************************
0005               *    TI MONITOR scratchpad dump on cartridge menu screen
0006               ***************************************************************
0007               
0008               scrpad.monitor:
0009                       ;-------------------------------------------------------
0010                       ; Scratchpad TI monitor on cartridge selection screen
0011                       ;-------------------------------------------------------
0012 7E00 0000             byte  >00,>00,>21,>4D,>00,>00,>00,>00    ; >8300 - >8307
     7E02 214D     
     7E04 0000     
     7E06 0000     
0013 7E08 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8308 - >830f
     7E0A 0000     
     7E0C 0000     
     7E0E 0000     
0014 7E10 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8310 - >8317
     7E12 0000     
     7E14 0000     
     7E16 0000     
0015 7E18 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8318 - >831f
     7E1A 0000     
     7E1C 0000     
     7E1E 0000     
0016 7E20 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8320 - >8327
     7E22 0000     
     7E24 0000     
     7E26 0000     
0017 7E28 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8328 - >832f
     7E2A 0000     
     7E2C 0000     
     7E2E 0000     
0018 7E30 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8330 - >8337
     7E32 0000     
     7E34 0000     
     7E36 0000     
0019 7E38 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8338 - >833f
     7E3A 0000     
     7E3C 0000     
     7E3E 0000     
0020 7E40 0000             byte  >00,>00,>60,>13,>00,>00,>00,>00    ; >8340 - >8347
     7E42 6013     
     7E44 0000     
     7E46 0000     
0021 7E48 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8348 - >834f
     7E4A 0000     
     7E4C 0000     
     7E4E 0000     
0022 7E50 0000             byte  >00,>00,>01,>24,>00,>00,>00,>00    ; >8350 - >8357
     7E52 0124     
     7E54 0000     
     7E56 0000     
0023 7E58 311E             byte  >31,>1E,>00,>00,>00,>00,>00,>08    ; >8358 - >835f
     7E5A 0000     
     7E5C 0000     
     7E5E 0008     
0024 7E60 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8360 - >8367
     7E62 0000     
     7E64 0000     
     7E66 0000     
0025 7E68 0000             byte  >00,>00,>21,>52,>01,>06,>00,>00    ; >8368 - >836f
     7E6A 2152     
     7E6C 0106     
     7E6E 0000     
0026 7E70 37D7             byte  >37,>D7,>FE,>7E,>00,>FF,>00,>00    ; >8370 - >8377
     7E72 FE7E     
     7E74 00FF     
     7E76 0000     
0027 7E78 52D2             byte  >52,>D2,>00,>E4,>00,>00,>05,>09    ; >8378 - >837f
     7E7A 00E4     
     7E7C 0000     
     7E7E 0509     
0028 7E80 02FA             byte  >02,>FA,>03,>85,>00,>00,>00,>00    ; >8380 - >8387
     7E82 0385     
     7E84 0000     
     7E86 0000     
0029 7E88 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8388 - >838f
     7E8A 0000     
     7E8C 0000     
     7E8E 0000     
0030 7E90 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8390 - >8397
     7E92 0000     
     7E94 0000     
     7E96 0000     
0031 7E98 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8398 - >839f
     7E9A 0000     
     7E9C 0000     
     7E9E 0000     
0032 7EA0 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >83A0 - >83a7
     7EA2 0000     
     7EA4 0000     
     7EA6 0000     
0033 7EA8 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >83A8 - >83af
     7EAA 0000     
     7EAC 0000     
     7EAE 0000     
0034 7EB0 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >83B0 - >83b7
     7EB2 0000     
     7EB4 0000     
     7EB6 0000     
0035 7EB8 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >83B8 - >83bf
     7EBA 0000     
     7EBC 0000     
     7EBE 0000     
0036 7EC0 5209             byte  >52,>09,>00,>00,>00,>00,>00,>00    ; >83C0 - >83c7
     7EC2 0000     
     7EC4 0000     
     7EC6 0000     
0037 7EC8 FFFF             byte  >FF,>FF,>FF,>00,>04,>84,>00,>00    ; >83C8 - >83cf
     7ECA FF00     
     7ECC 0484     
     7ECE 0000     
0038 7ED0 9804             byte  >98,>04,>E0,>00,>E0,>d5,>0A,>A6    ; >83D0 - >83d7
     7ED2 E000     
     7ED4 E0D5     
     7ED6 0AA6     
0039 7ED8 0070             byte  >00,>70,>83,>E0,>00,>74,>D0,>02    ; >83D8 - >83df
     7EDA 83E0     
     7EDC 0074     
     7EDE D002     
0040 7EE0 FFFF             byte  >FF,>FF,>FF,>FF,>00,>00,>04,>84    ; >83E0 - >83e7
     7EE2 FFFF     
     7EE4 0000     
     7EE6 0484     
0041 7EE8 0080             byte  >00,>80,>00,>00,>00,>00,>00,>00    ; >83E8 - >83ef
     7EEA 0000     
     7EEC 0000     
     7EEE 0000     
0042 7EF0 0000             byte  >00,>00,>00,>06,>05,>20,>04,>80    ; >83F0 - >83f7
     7EF2 0006     
     7EF4 0520     
     7EF6 0480     
0043 7EF8 0006             byte  >00,>06,>98,>00,>01,>08,>8C,>02    ; >83F8 - >83ff
     7EFA 9800     
     7EFC 0108     
     7EFE 8C02     
                   < stevie_b3.asm.61108
0134                       ;-----------------------------------------------------------------------
0135                       ; Vector table
0136                       ;-----------------------------------------------------------------------
0137                       aorg  >7fc0
0138                       copy  "rom.vectors.bank3.asm"
     **** ****     > rom.vectors.bank3.asm
0001               * FILE......: rom.vectors.bank3.asm
0002               * Purpose...: Bank 3 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 608C     vec.1   data  dialog.help           ; Dialog "About"
0008 7FC2 66AC     vec.2   data  dialog.load           ; Dialog "Load file"
0009 7FC4 6710     vec.3   data  dialog.save           ; Dialog "Save file"
0010 7FC6 67F8     vec.4   data  dialog.insert         ; Dialog "Insert file at line ..."
0011 7FC8 6788     vec.5   data  dialog.print          ; Dialog "Print file"
0012 7FCA 6628     vec.6   data  dialog.file           ; Dialog "File"
0013 7FCC 6962     vec.7   data  dialog.unsaved        ; Dialog "Unsaved changes"
0014 7FCE 68D4     vec.8   data  dialog.clipboard      ; Dialog "Copy clipboard to line ..."
0015 7FD0 6888     vec.9   data  dialog.clipdev        ; Dialog "Configure clipboard device"
0016 7FD2 666A     vec.10  data  dialog.config         ; Dialog "Configure"
0017 7FD4 2026     vec.11  data  cpu.crash             ;
0018 7FD6 2026     vec.12  data  cpu.crash             ;
0019 7FD8 2026     vec.13  data  cpu.crash             ;
0020 7FDA 2026     vec.14  data  cpu.crash             ;
0021 7FDC 6E94     vec.15  data  tibasic               ; Run TI Basic interpreter
0022 7FDE 2026     vec.16  data  cpu.crash             ;
0023 7FE0 2026     vec.17  data  cpu.crash             ;
0024 7FE2 6C0A     vec.18  data  error.display         ; Show error message
0025 7FE4 69E2     vec.19  data  pane.show_hintx       ; Show or hide hint (register version)
0026 7FE6 6A4C     vec.20  data  pane.cmdb.show        ; Show command buffer pane (=dialog)
0027 7FE8 6A9C     vec.21  data  pane.cmdb.hide        ; Hide command buffer pane
0028 7FEA 6AF8     vec.22  data  pane.cmdb.draw        ; Draw content in command
0029 7FEC 2026     vec.23  data  cpu.crash             ;
0030 7FEE 6C3C     vec.24  data  cmdb.refresh          ;
0031 7FF0 6C86     vec.25  data  cmdb.cmd.clear        ;
0032 7FF2 6CB8     vec.26  data  cmdb.cmd.getlength    ;
0033 7FF4 6D18     vec.27  data  cmdb.cmd.preset       ;
0034 7FF6 6CCE     vec.28  data  cmdb.cmd.set          ;
0035 7FF8 2026     vec.29  data  cpu.crash             ;
0036 7FFA 604A     vec.30  data  dialog.menu           ; Dialog "Main Menu"
0037 7FFC 2026     vec.31  data  cpu.crash             ;
0038 7FFE 6D5C     vec.32  data  fm.fastmode           ; Toggle fastmode on/off in Load dialog
                   < stevie_b3.asm.61108
0139                                                   ; Vector table bank 3
0140               
0141               
0142               *--------------------------------------------------------------
0143               * Video mode configuration
0144               *--------------------------------------------------------------
0145      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0146      0004     spfbck  equ   >04                   ; Screen background color.
0147      3654     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0148      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0149      0050     colrow  equ   80                    ; Columns per row
0150      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0151      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0152      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0153      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

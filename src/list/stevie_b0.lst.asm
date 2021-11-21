XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b0.asm.103101
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               *************************************ste**************************
0009               * File: stevie_b0.asm               ; Version 211121-2047490
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
                   < stevie_b0.asm.103101
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
                   < stevie_b0.asm.103101
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
0214      A22A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0215      A2CA     tv.free           equ  tv.top + 202    ; End of structure
0216               *--------------------------------------------------------------
0217               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0218               *--------------------------------------------------------------
0219      A300     fb.struct         equ  >a300           ; Structure begin
0220      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0221      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0222      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0223                                                      ; line X in editor buffer).
0224      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0225                                                      ; (offset 0 .. @fb.scrrows)
0226      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0227      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0228      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0229      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0230      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0231      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0232      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0233      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0234      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0235      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0236      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0237      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0238      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0239      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0240               *--------------------------------------------------------------
0241               * File handle structure               @>a400-a4ff   (256 bytes)
0242               *--------------------------------------------------------------
0243      A400     fh.struct         equ  >a400           ; stevie file handling structures
0244               ;***********************************************************************
0245               ; ATTENTION
0246               ; The dsrlnk variables must form a continuous memory block and keep
0247               ; their order!
0248               ;***********************************************************************
0249      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0250      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0251      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0252      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0253      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0254      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0255      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0256      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0257      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0258      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0259      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0260      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0261      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0262      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0263      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0264      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0265      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0266      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0267      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0268      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0269      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0270      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0271      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0272      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0273      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0274      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0275      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0276      A45A     fh.workmode       equ  fh.struct + 90  ; Working mode (used in callbacks)
0277      A45C     fh.kilobytes.prev equ  fh.struct + 92  ; Kilobytes processed (previous)
0278      A45E     fh.line           equ  fh.struct + 94  ; Editor buffer line currently processing
0279      A460     fh.temp1          equ  fh.struct + 96  ; Temporary variable 1
0280      A462     fh.temp2          equ  fh.struct + 98  ; Temporary variable 2
0281      A464     fh.temp3          equ  fh.struct +100  ; Temporary variable 3
0282      A466     fh.membuffer      equ  fh.struct +102  ; 80 bytes file memory buffer
0283      A4B6     fh.free           equ  fh.struct +182  ; End of structure
0284      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0285      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0286               *--------------------------------------------------------------
0287               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0288               *--------------------------------------------------------------
0289      A500     edb.struct        equ  >a500           ; Begin structure
0290      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0291      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0292      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0293      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0294      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0295      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0296      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0297      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0298      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0299      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0300                                                      ; with current filename.
0301      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0302                                                      ; with current file type.
0303      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0304      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0305      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0306                                                      ; for filename, but not always used.
0307      A56A     edb.free          equ  edb.struct + 106; End of structure
0308               *--------------------------------------------------------------
0309               * Index structure                     @>a600-a6ff   (256 bytes)
0310               *--------------------------------------------------------------
0311      A600     idx.struct        equ  >a600           ; stevie index structure
0312      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0313      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0314      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0315      A606     idx.free          equ  idx.struct + 6  ; End of structure
0316               *--------------------------------------------------------------
0317               * Command buffer structure            @>a700-a7ff   (256 bytes)
0318               *--------------------------------------------------------------
0319      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0320      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0321      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0322      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0323      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0324      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0325      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0326      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0327      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0328      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0329      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0330      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0331      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0332      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0333      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0334      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0335      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0336      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0337      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0338      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0339      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0340      A728     cmdb.cmdall       equ  cmdb.struct + 40; Current command including length-byte
0341      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0342      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0343      A77A     cmdb.panhead.buf  equ  cmdb.struct +122; String buffer for pane header
0344      A7C8     cmdb.free         equ  cmdb.struct +200; End of structure
0345               *--------------------------------------------------------------
0346               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0347               *--------------------------------------------------------------
0348      AD00     scrpad.copy       equ  >ad00           ; Copy of Stevie scratchpad memory
0349               *--------------------------------------------------------------
0350               * Farjump return stack                @>af00-afff   (256 bytes)
0351               *--------------------------------------------------------------
0352      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0353                                                      ; Grows downwards from high to low.
0354               *--------------------------------------------------------------
0355               * Index                               @>b000-bfff  (4096 bytes)
0356               *--------------------------------------------------------------
0357      B000     idx.top           equ  >b000           ; Top of index
0358      1000     idx.size          equ  4096            ; Index size
0359               *--------------------------------------------------------------
0360               * Editor buffer                       @>c000-cfff  (4096 bytes)
0361               *--------------------------------------------------------------
0362      C000     edb.top           equ  >c000           ; Editor buffer high memory
0363      1000     edb.size          equ  4096            ; Editor buffer size
0364               *--------------------------------------------------------------
0365               * Frame buffer & Default devices      @>d000-dfff  (4096 bytes)
0366               *--------------------------------------------------------------
0367      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0368      0960     fb.size           equ  80*30           ; Frame buffer size
0369      D960     tv.printer.fname  equ  >d960           ; Default printer   (80 char)
0370      D9B0     tv.clip.fname     equ  >d9b0           ; Default clipboard (80 char)
0371               *--------------------------------------------------------------
0372               * Command buffer history              @>e000-efff  (4096 bytes)
0373               *--------------------------------------------------------------
0374      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0375      1000     cmdb.size         equ  4096            ; Command buffer size
0376               *--------------------------------------------------------------
0377               * Heap                                @>f000-ffff  (4096 bytes)
0378               *--------------------------------------------------------------
0379      F000     heap.top          equ  >f000           ; Top of heap
                   < stevie_b0.asm.103101
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
                   < stevie_b0.asm.103101
0018               
0019               ***************************************************************
0020               * Spectra2 core configuration
0021               ********|*****|*********************|**************************
0022      AF00     sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
0023                                                   ; grows from high to low.
0024               ***************************************************************
0025               * BANK 0
0026               ********|*****|*********************|**************************
0027      6000     bankid  equ   bank0.rom             ; Set bank identifier to current bank
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
0045 6011   53             text  'STEVIE 1.2F'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3246     
0046                       even
0047               
0049               
                   < stevie_b0.asm.103101
0031               
0032               ***************************************************************
0033               * Step 1: Switch to bank 0 (uniform code accross all banks)
0034               ********|*****|*********************|**************************
0035                       aorg  kickstart.code1       ; >6040
0036 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000     
0037               ***************************************************************
0038               * Step 2: Copy resident modules from ROM to RAM >2000 - >3fff
0039               ********|*****|*********************|**************************
0040 6044 0200  20         li    r0,reloc.resident     ; Start of code to relocate
     6046 607A     
0041 6048 0201  20         li    r1,>2000
     604A 2000     
0042 604C 0202  20         li    r2,512                ; Copy 8K (512 * 16 bytes)
     604E 0200     
0043 6050 06A0  32         bl    @kickstart.copy       ; Copy memory
     6052 6064     
0044               ***************************************************************
0045               * Step 4: Start SP2 kernel (runs in low MEMEXP)
0046               ********|*****|*********************|**************************
0047 6054 0460  28         b     @runlib               ; Start spectra2 library
     6056 2FE6     
0048                                                   ; "main" in low MEMEXP is automatically
0049                                                   ; called by SP2 runlib.
0050                       ;------------------------------------------------------
0051                       ; Assert. Should not get here! Crash and burn!
0052                       ;------------------------------------------------------
0053 6058 0200  20         li    r0,$                  ; Current location
     605A 6058     
0054 605C C800  38         mov   r0,@>ffce             ; \ Save caller address
     605E FFCE     
0055 6060 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6062 2026     
0056               ***************************************************************
0057               * Copy routine
0058               ********|*****|*********************|**************************
0059               kickstart.copy:
0060                       ;------------------------------------------------------
0061                       ; Copy memory to destination
0062                       ; r0 = Source CPU address
0063                       ; r1 = Target CPU address
0064                       ; r2 = Bytes to copy/16
0065                       ;------------------------------------------------------
0066 6064 CC70  46 !       mov   *r0+,*r1+             ; Copy word 1
0067 6066 CC70  46         mov   *r0+,*r1+             ; Copy word 2
0068 6068 CC70  46         mov   *r0+,*r1+             ; Copy word 3
0069 606A CC70  46         mov   *r0+,*r1+             ; Copy word 4
0070 606C CC70  46         mov   *r0+,*r1+             ; Copy word 5
0071 606E CC70  46         mov   *r0+,*r1+             ; Copy word 6
0072 6070 CC70  46         mov   *r0+,*r1+             ; Copy word 7
0073 6072 CC70  46         mov   *r0+,*r1+             ; Copy word 8
0074 6074 0602  14         dec   r2
0075 6076 16F6  14         jne   -!                    ; Loop until done
0076 6078 045B  20         b     *r11                  ; Return to caller
0077               
0078               ***************************************************************
0079               * Code data: Relocated code
0080               ********|*****|*********************|**************************
0081               reloc.resident:
0082                       ;------------------------------------------------------
0083                       ; Resident libraries
0084                       ;------------------------------------------------------
0085                       xorg  >2000                 ; Relocate to >2000
0086                       copy  "runlib.asm"
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
0012 607A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 607C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 607E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 6080 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 6082 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 6084 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 6086 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 6088 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 608A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 608C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 608E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 6090 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 6092 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 6094 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 6096 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 6098 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 609A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 609C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 609E D000     w$d000  data  >d000                 ; >d000
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
0038 60A0 022B  22         ai    r11,-4                ; Remove opcode offset
     60A2 FFFC     
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 60A4 C800  38         mov   r0,@>ffe0
     60A6 FFE0     
0043 60A8 C801  38         mov   r1,@>ffe2
     60AA FFE2     
0044 60AC C802  38         mov   r2,@>ffe4
     60AE FFE4     
0045 60B0 C803  38         mov   r3,@>ffe6
     60B2 FFE6     
0046 60B4 C804  38         mov   r4,@>ffe8
     60B6 FFE8     
0047 60B8 C805  38         mov   r5,@>ffea
     60BA FFEA     
0048 60BC C806  38         mov   r6,@>ffec
     60BE FFEC     
0049 60C0 C807  38         mov   r7,@>ffee
     60C2 FFEE     
0050 60C4 C808  38         mov   r8,@>fff0
     60C6 FFF0     
0051 60C8 C809  38         mov   r9,@>fff2
     60CA FFF2     
0052 60CC C80A  38         mov   r10,@>fff4
     60CE FFF4     
0053 60D0 C80B  38         mov   r11,@>fff6
     60D2 FFF6     
0054 60D4 C80C  38         mov   r12,@>fff8
     60D6 FFF8     
0055 60D8 C80D  38         mov   r13,@>fffa
     60DA FFFA     
0056 60DC C80E  38         mov   r14,@>fffc
     60DE FFFC     
0057 60E0 C80F  38         mov   r15,@>ffff
     60E2 FFFF     
0058 60E4 02A0  12         stwp  r0
0059 60E6 C800  38         mov   r0,@>ffdc
     60E8 FFDC     
0060 60EA 02C0  12         stst  r0
0061 60EC C800  38         mov   r0,@>ffde
     60EE FFDE     
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 60F0 02E0  18         lwpi  ws1                   ; Activate workspace 1
     60F2 8300     
0067 60F4 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     60F6 8302     
0068 60F8 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     60FA 4A4A     
0069 60FC 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     60FE 2FEA     
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 6100 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6102 230C     
0078 6104 2206                   data graph1           ; \ i  p0 = pointer to video mode table
0079                                                   ; /
0080               
0081 6106 06A0  32         bl    @ldfnt
     6108 2374     
0082 610A 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     610C 000C     
0083               
0084 610E 06A0  32         bl    @filv
     6110 22A2     
0085 6112 0000                   data >0000,32,32*24   ; Clear screen
     6114 0020     
     6116 0300     
0086               
0087 6118 06A0  32         bl    @filv
     611A 22A2     
0088 611C 0380                   data >0380,>f0,32*24  ; Load color table
     611E 00F0     
     6120 0300     
0089                       ;------------------------------------------------------
0090                       ; Show crash address
0091                       ;------------------------------------------------------
0092 6122 06A0  32         bl    @putat                ; Show crash message
     6124 2456     
0093 6126 0000                   data >0000,cpu.crash.msg.crashed
     6128 2192     
0094               
0095 612A 06A0  32         bl    @puthex               ; Put hex value on screen
     612C 2AA0     
0096 612E 0015                   byte 0,21             ; \ i  p0 = YX position
0097 6130 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0098 6132 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0099 6134 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0100                                                   ; /         LSB offset for ASCII digit 0-9
0101                       ;------------------------------------------------------
0102                       ; Show caller address
0103                       ;------------------------------------------------------
0104 6136 06A0  32         bl    @putat                ; Show caller message
     6138 2456     
0105 613A 0100                   data >0100,cpu.crash.msg.caller
     613C 21A8     
0106               
0107 613E 06A0  32         bl    @puthex               ; Put hex value on screen
     6140 2AA0     
0108 6142 0115                   byte 1,21             ; \ i  p0 = YX position
0109 6144 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0110 6146 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0111 6148 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0112                                                   ; /         LSB offset for ASCII digit 0-9
0113                       ;------------------------------------------------------
0114                       ; Display labels
0115                       ;------------------------------------------------------
0116 614A 06A0  32         bl    @putat
     614C 2456     
0117 614E 0300                   byte 3,0
0118 6150 21C4                   data cpu.crash.msg.wp
0119 6152 06A0  32         bl    @putat
     6154 2456     
0120 6156 0400                   byte 4,0
0121 6158 21CA                   data cpu.crash.msg.st
0122 615A 06A0  32         bl    @putat
     615C 2456     
0123 615E 1600                   byte 22,0
0124 6160 21D0                   data cpu.crash.msg.source
0125 6162 06A0  32         bl    @putat
     6164 2456     
0126 6166 1700                   byte 23,0
0127 6168 21EC                   data cpu.crash.msg.id
0128                       ;------------------------------------------------------
0129                       ; Show crash registers WP, ST, R0 - R15
0130                       ;------------------------------------------------------
0131 616A 06A0  32         bl    @at                   ; Put cursor at YX
     616C 26E2     
0132 616E 0304                   byte 3,4              ; \ i p0 = YX position
0133                                                   ; /
0134               
0135 6170 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6172 FFDC     
0136 6174 04C6  14         clr   tmp2                  ; Loop counter
0137               
0138               cpu.crash.showreg:
0139 6176 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0140               
0141 6178 0649  14         dect  stack
0142 617A C644  30         mov   tmp0,*stack           ; Push tmp0
0143 617C 0649  14         dect  stack
0144 617E C645  30         mov   tmp1,*stack           ; Push tmp1
0145 6180 0649  14         dect  stack
0146 6182 C646  30         mov   tmp2,*stack           ; Push tmp2
0147                       ;------------------------------------------------------
0148                       ; Display crash register number
0149                       ;------------------------------------------------------
0150               cpu.crash.showreg.label:
0151 6184 C046  18         mov   tmp2,r1               ; Save register number
0152 6186 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     6188 0001     
0153 618A 1220  14         jle   cpu.crash.showreg.content
0154                                                   ; Yes, skip
0155               
0156 618C 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0157 618E 06A0  32         bl    @mknum
     6190 2AAA     
0158 6192 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0159 6194 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0160 6196 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0161                                                   ; /         LSB offset for ASCII digit 0-9
0162               
0163 6198 06A0  32         bl    @setx                 ; Set cursor X position
     619A 26F8     
0164 619C 0000                   data 0                ; \ i  p0 =  Cursor Y position
0165                                                   ; /
0166               
0167 619E 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     61A0 0400     
0168 61A2 D804  38         movb  tmp0,@rambuf          ;
     61A4 A140     
0169               
0170 61A6 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61A8 2432     
0171 61AA A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0172                                                   ; /
0173               
0174 61AC 06A0  32         bl    @setx                 ; Set cursor X position
     61AE 26F8     
0175 61B0 0002                   data 2                ; \ i  p0 =  Cursor Y position
0176                                                   ; /
0177               
0178 61B2 0281  22         ci    r1,10
     61B4 000A     
0179 61B6 1102  14         jlt   !
0180 61B8 0620  34         dec   @wyx                  ; x=x-1
     61BA 832A     
0181               
0182 61BC 06A0  32 !       bl    @putstr
     61BE 2432     
0183 61C0 21BE                   data cpu.crash.msg.r
0184               
0185 61C2 06A0  32         bl    @mknum
     61C4 2AAA     
0186 61C6 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0187 61C8 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0188 61CA 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0189                                                   ; /         LSB offset for ASCII digit 0-9
0190                       ;------------------------------------------------------
0191                       ; Display crash register content
0192                       ;------------------------------------------------------
0193               cpu.crash.showreg.content:
0194 61CC 06A0  32         bl    @mkhex                ; Convert hex word to string
     61CE 2A1C     
0195 61D0 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0196 61D2 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0197 61D4 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0198                                                   ; /         LSB offset for ASCII digit 0-9
0199               
0200 61D6 06A0  32         bl    @setx                 ; Set cursor X position
     61D8 26F8     
0201 61DA 0004                   data 4                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61DC 06A0  32         bl    @putstr               ; Put '  >'
     61DE 2432     
0205 61E0 21C0                   data cpu.crash.msg.marker
0206               
0207 61E2 06A0  32         bl    @setx                 ; Set cursor X position
     61E4 26F8     
0208 61E6 0007                   data 7                ; \ i  p0 =  Cursor Y position
0209                                                   ; /
0210               
0211 61E8 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     61EA 0400     
0212 61EC D804  38         movb  tmp0,@rambuf          ;
     61EE A140     
0213               
0214 61F0 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61F2 2432     
0215 61F4 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0216                                                   ; /
0217               
0218 61F6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0219 61F8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0220 61FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0221               
0222 61FC 06A0  32         bl    @down                 ; y=y+1
     61FE 26E8     
0223               
0224 6200 0586  14         inc   tmp2
0225 6202 0286  22         ci    tmp2,17
     6204 0011     
0226 6206 12B7  14         jle   cpu.crash.showreg     ; Show next register
0227                       ;------------------------------------------------------
0228                       ; Kernel takes over
0229                       ;------------------------------------------------------
0230 6208 0460  28         b     @cpu.crash.showbank   ; Expected to be included in
     620A 7FB0     
0231               
0232               
0233               cpu.crash.msg.crashed
0234 620C 15               byte  21
0235 620D   53             text  'System crashed near >'
     620E 7973     
     6210 7465     
     6212 6D20     
     6214 6372     
     6216 6173     
     6218 6865     
     621A 6420     
     621C 6E65     
     621E 6172     
     6220 203E     
0236                       even
0237               
0238               cpu.crash.msg.caller
0239 6222 15               byte  21
0240 6223   43             text  'Caller address near >'
     6224 616C     
     6226 6C65     
     6228 7220     
     622A 6164     
     622C 6472     
     622E 6573     
     6230 7320     
     6232 6E65     
     6234 6172     
     6236 203E     
0241                       even
0242               
0243               cpu.crash.msg.r
0244 6238 01               byte  1
0245 6239   52             text  'R'
0246                       even
0247               
0248               cpu.crash.msg.marker
0249 623A 03               byte  3
0250 623B   20             text  '  >'
     623C 203E     
0251                       even
0252               
0253               cpu.crash.msg.wp
0254 623E 04               byte  4
0255 623F   2A             text  '**WP'
     6240 2A57     
     6242 50       
0256                       even
0257               
0258               cpu.crash.msg.st
0259 6244 04               byte  4
0260 6245   2A             text  '**ST'
     6246 2A53     
     6248 54       
0261                       even
0262               
0263               cpu.crash.msg.source
0264 624A 1B               byte  27
0265 624B   53             text  'Source    stevie_b0.lst.asm'
     624C 6F75     
     624E 7263     
     6250 6520     
     6252 2020     
     6254 2073     
     6256 7465     
     6258 7669     
     625A 655F     
     625C 6230     
     625E 2E6C     
     6260 7374     
     6262 2E61     
     6264 736D     
0266                       even
0267               
0268               cpu.crash.msg.id
0269 6266 18               byte  24
0270 6267   42             text  'Build-ID  211121-2047490'
     6268 7569     
     626A 6C64     
     626C 2D49     
     626E 4420     
     6270 2032     
     6272 3131     
     6274 3132     
     6276 312D     
     6278 3230     
     627A 3437     
     627C 3439     
     627E 30       
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
0007 6280 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6282 000E     
     6284 0106     
     6286 0204     
     6288 0020     
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
0032 628A 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     628C 000E     
     628E 0106     
     6290 00F4     
     6292 0028     
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
0058 6294 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6296 003F     
     6298 0240     
     629A 03F4     
     629C 0050     
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
0013 629E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 62A0 16FD             data  >16fd                 ; |         jne   mcloop
0015 62A2 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 62A4 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 62A6 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 62A8 0201  20         li    r1,mccode             ; Machinecode to patch
     62AA 2224     
0037 62AC 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     62AE 8322     
0038 62B0 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 62B2 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 62B4 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 62B6 045B  20         b     *r11                  ; Return to caller
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
0056 62B8 C0F9  30 popr3   mov   *stack+,r3
0057 62BA C0B9  30 popr2   mov   *stack+,r2
0058 62BC C079  30 popr1   mov   *stack+,r1
0059 62BE C039  30 popr0   mov   *stack+,r0
0060 62C0 C2F9  30 poprt   mov   *stack+,r11
0061 62C2 045B  20         b     *r11
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
0085 62C4 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 62C6 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 62C8 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 62CA C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 62CC 1604  14         jne   filchk                ; No, continue checking
0093               
0094 62CE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     62D0 FFCE     
0095 62D2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     62D4 2026     
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 62D6 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     62D8 830B     
     62DA 830A     
0100               
0101 62DC 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62DE 0001     
0102 62E0 1602  14         jne   filchk2
0103 62E2 DD05  32         movb  tmp1,*tmp0+
0104 62E4 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 62E6 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     62E8 0002     
0109 62EA 1603  14         jne   filchk3
0110 62EC DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 62EE DD05  32         movb  tmp1,*tmp0+
0112 62F0 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 62F2 C1C4  18 filchk3 mov   tmp0,tmp3
0117 62F4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62F6 0001     
0118 62F8 1305  14         jeq   fil16b
0119 62FA DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 62FC 0606  14         dec   tmp2
0121 62FE 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     6300 0002     
0122 6302 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 6304 C1C6  18 fil16b  mov   tmp2,tmp3
0127 6306 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6308 0001     
0128 630A 1301  14         jeq   dofill
0129 630C 0606  14         dec   tmp2                  ; Make TMP2 even
0130 630E CD05  34 dofill  mov   tmp1,*tmp0+
0131 6310 0646  14         dect  tmp2
0132 6312 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 6314 C1C7  18         mov   tmp3,tmp3
0137 6316 1301  14         jeq   fil.exit
0138 6318 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 631A 045B  20         b     *r11
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
0159 631C C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 631E C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 6320 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 6322 0264  22 xfilv   ori   tmp0,>4000
     6324 4000     
0166 6326 06C4  14         swpb  tmp0
0167 6328 D804  38         movb  tmp0,@vdpa
     632A 8C02     
0168 632C 06C4  14         swpb  tmp0
0169 632E D804  38         movb  tmp0,@vdpa
     6330 8C02     
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 6332 020F  20         li    r15,vdpw              ; Set VDP write address
     6334 8C00     
0174 6336 06C5  14         swpb  tmp1
0175 6338 C820  54         mov   @filzz,@mcloop        ; Setup move command
     633A 22C8     
     633C 8320     
0176 633E 0460  28         b     @mcloop               ; Write data to VDP
     6340 8320     
0177               *--------------------------------------------------------------
0181 6342 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 6344 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     6346 4000     
0202 6348 06C4  14 vdra    swpb  tmp0
0203 634A D804  38         movb  tmp0,@vdpa
     634C 8C02     
0204 634E 06C4  14         swpb  tmp0
0205 6350 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6352 8C02     
0206 6354 045B  20         b     *r11                  ; Exit
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
0217 6356 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 6358 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 635A 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     635C 4000     
0223 635E 06C4  14         swpb  tmp0                  ; \
0224 6360 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6362 8C02     
0225 6364 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 6366 D804  38         movb  tmp0,@vdpa            ; /
     6368 8C02     
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 636A 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 636C D7C5  30         movb  tmp1,*r15             ; Write byte
0232 636E 045B  20         b     *r11                  ; Exit
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
0251 6370 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 6372 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 6374 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6376 8C02     
0257 6378 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 637A D804  38         movb  tmp0,@vdpa            ; /
     637C 8C02     
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 637E D120  34         movb  @vdpr,tmp0            ; Read byte
     6380 8800     
0263 6382 0984  56         srl   tmp0,8                ; Right align
0264 6384 045B  20         b     *r11                  ; Exit
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
0283 6386 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 6388 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 638A C144  18         mov   tmp0,tmp1
0289 638C 05C5  14         inct  tmp1
0290 638E D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 6390 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6392 FF00     
0292 6394 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 6396 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6398 8328     
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 639A 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     639C 8000     
0298 639E 0206  20         li    tmp2,8
     63A0 0008     
0299 63A2 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     63A4 830B     
0300 63A6 06C5  14         swpb  tmp1
0301 63A8 D805  38         movb  tmp1,@vdpa
     63AA 8C02     
0302 63AC 06C5  14         swpb  tmp1
0303 63AE D805  38         movb  tmp1,@vdpa
     63B0 8C02     
0304 63B2 0225  22         ai    tmp1,>0100
     63B4 0100     
0305 63B6 0606  14         dec   tmp2
0306 63B8 16F4  14         jne   vidta1                ; Next register
0307 63BA C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     63BC 833A     
0308 63BE 045B  20         b     *r11
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
0325 63C0 C13B  30 putvr   mov   *r11+,tmp0
0326 63C2 0264  22 putvrx  ori   tmp0,>8000
     63C4 8000     
0327 63C6 06C4  14         swpb  tmp0
0328 63C8 D804  38         movb  tmp0,@vdpa
     63CA 8C02     
0329 63CC 06C4  14         swpb  tmp0
0330 63CE D804  38         movb  tmp0,@vdpa
     63D0 8C02     
0331 63D2 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 63D4 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 63D6 C10E  18         mov   r14,tmp0
0341 63D8 0984  56         srl   tmp0,8
0342 63DA 06A0  32         bl    @putvrx               ; Write VR#0
     63DC 2348     
0343 63DE 0204  20         li    tmp0,>0100
     63E0 0100     
0344 63E2 D820  54         movb  @r14lb,@tmp0lb
     63E4 831D     
     63E6 8309     
0345 63E8 06A0  32         bl    @putvrx               ; Write VR#1
     63EA 2348     
0346 63EC 0458  20         b     *tmp4                 ; Exit
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
0360 63EE C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 63F0 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 63F2 C11B  26         mov   *r11,tmp0             ; Get P0
0363 63F4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63F6 7FFF     
0364 63F8 2120  38         coc   @wbit0,tmp0
     63FA 2020     
0365 63FC 1604  14         jne   ldfnt1
0366 63FE 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6400 8000     
0367 6402 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6404 7FFF     
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 6406 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6408 23F6     
0372 640A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     640C 9C02     
0373 640E 06C4  14         swpb  tmp0
0374 6410 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6412 9C02     
0375 6414 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6416 9800     
0376 6418 06C5  14         swpb  tmp1
0377 641A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     641C 9800     
0378 641E 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 6420 D805  38         movb  tmp1,@grmwa
     6422 9C02     
0383 6424 06C5  14         swpb  tmp1
0384 6426 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6428 9C02     
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 642A C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 642C 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     642E 22CA     
0390 6430 05C8  14         inct  tmp4                  ; R11=R11+2
0391 6432 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 6434 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     6436 7FFF     
0393 6438 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     643A 23F8     
0394 643C C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     643E 23FA     
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 6440 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 6442 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 6444 D120  34         movb  @grmrd,tmp0
     6446 9800     
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 6448 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     644A 2020     
0405 644C 1603  14         jne   ldfnt3                ; No, so skip
0406 644E D1C4  18         movb  tmp0,tmp3
0407 6450 0917  56         srl   tmp3,1
0408 6452 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 6454 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6456 8C00     
0413 6458 0606  14         dec   tmp2
0414 645A 16F2  14         jne   ldfnt2
0415 645C 05C8  14         inct  tmp4                  ; R11=R11+2
0416 645E 020F  20         li    r15,vdpw              ; Set VDP write address
     6460 8C00     
0417 6462 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6464 7FFF     
0418 6466 0458  20         b     *tmp4                 ; Exit
0419 6468 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     646A 2000     
     646C 8C00     
0420 646E 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 6470 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6472 0200     
     6474 0000     
0425 6476 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6478 01C0     
     647A 0101     
0426 647C 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     647E 02A0     
     6480 0101     
0427 6482 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6484 00E0     
     6486 0101     
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
0445 6488 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 648A C3A0  34         mov   @wyx,r14              ; Get YX
     648C 832A     
0447 648E 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 6490 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6492 833A     
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 6494 C3A0  34         mov   @wyx,r14              ; Get YX
     6496 832A     
0454 6498 024E  22         andi  r14,>00ff             ; Remove Y
     649A 00FF     
0455 649C A3CE  18         a     r14,r15               ; pos = pos + X
0456 649E A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     64A0 8328     
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 64A2 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 64A4 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 64A6 020F  20         li    r15,vdpw              ; VDP write address
     64A8 8C00     
0463 64AA 045B  20         b     *r11
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
0481 64AC C17B  30 putstr  mov   *r11+,tmp1
0482 64AE D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 64B0 C1CB  18 xutstr  mov   r11,tmp3
0484 64B2 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     64B4 240E     
0485 64B6 C2C7  18         mov   tmp3,r11
0486 64B8 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 64BA C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 64BC 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 64BE 0286  22         ci    tmp2,255              ; Length > 255 ?
     64C0 00FF     
0494 64C2 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 64C4 0460  28         b     @xpym2v               ; Display string
     64C6 24A0     
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 64C8 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     64CA FFCE     
0501 64CC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64CE 2026     
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
0517 64D0 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     64D2 832A     
0518 64D4 0460  28         b     @putstr
     64D6 2432     
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
0539 64D8 0649  14         dect  stack
0540 64DA C64B  30         mov   r11,*stack            ; Save return address
0541 64DC 0649  14         dect  stack
0542 64DE C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 64E0 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 64E2 0987  56         srl   tmp3,8                ; Right align
0549               
0550 64E4 0649  14         dect  stack
0551 64E6 C645  30         mov   tmp1,*stack           ; Push tmp1
0552 64E8 0649  14         dect  stack
0553 64EA C646  30         mov   tmp2,*stack           ; Push tmp2
0554 64EC 0649  14         dect  stack
0555 64EE C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 64F0 06A0  32         bl    @xutst0               ; Display string
     64F2 2434     
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 64F4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 64F6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 64F8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 64FA 06A0  32         bl    @down                 ; Move cursor down
     64FC 26E8     
0566               
0567 64FE A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 6500 0585  14         inc   tmp1                  ; Consider length byte
0569 6502 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     6504 2002     
0570 6506 1301  14         jeq   !                     ; Yes, skip adjustment
0571 6508 0585  14         inc   tmp1                  ; Make address even
0572 650A 0606  14 !       dec   tmp2
0573 650C 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 650E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 6510 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 6512 045B  20         b     *r11                  ; Return
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
0020 6514 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6516 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6518 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 651A C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 651C 1604  14         jne   !                     ; No, continue
0028               
0029 651E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6520 FFCE     
0030 6522 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6524 2026     
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 6526 0264  22 !       ori   tmp0,>4000
     6528 4000     
0035 652A 06C4  14         swpb  tmp0
0036 652C D804  38         movb  tmp0,@vdpa
     652E 8C02     
0037 6530 06C4  14         swpb  tmp0
0038 6532 D804  38         movb  tmp0,@vdpa
     6534 8C02     
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 6536 020F  20         li    r15,vdpw              ; Set VDP write address
     6538 8C00     
0043 653A C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     653C 24CA     
     653E 8320     
0044 6540 0460  28         b     @mcloop               ; Write data to VDP and return
     6542 8320     
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 6544 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6546 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6548 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 654A C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 654C 06C4  14 xpyv2m  swpb  tmp0
0027 654E D804  38         movb  tmp0,@vdpa
     6550 8C02     
0028 6552 06C4  14         swpb  tmp0
0029 6554 D804  38         movb  tmp0,@vdpa
     6556 8C02     
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6558 020F  20         li    r15,vdpr              ; Set VDP read address
     655A 8800     
0034 655C C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     655E 24EC     
     6560 8320     
0035 6562 0460  28         b     @mcloop               ; Read data from VDP
     6564 8320     
0036 6566 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6568 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 656A C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 656C C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 656E C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6570 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6572 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6574 FFCE     
0034 6576 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6578 2026     
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 657A 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     657C 0001     
0039 657E 1603  14         jne   cpym0                 ; No, continue checking
0040 6580 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6582 04C6  14         clr   tmp2                  ; Reset counter
0042 6584 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6586 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6588 7FFF     
0047 658A C1C4  18         mov   tmp0,tmp3
0048 658C 0247  22         andi  tmp3,1
     658E 0001     
0049 6590 1618  14         jne   cpyodd                ; Odd source address handling
0050 6592 C1C5  18 cpym1   mov   tmp1,tmp3
0051 6594 0247  22         andi  tmp3,1
     6596 0001     
0052 6598 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 659A 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     659C 2020     
0057 659E 1605  14         jne   cpym3
0058 65A0 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     65A2 254E     
     65A4 8320     
0059 65A6 0460  28         b     @mcloop               ; Copy memory and exit
     65A8 8320     
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 65AA C1C6  18 cpym3   mov   tmp2,tmp3
0064 65AC 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     65AE 0001     
0065 65B0 1301  14         jeq   cpym4
0066 65B2 0606  14         dec   tmp2                  ; Make TMP2 even
0067 65B4 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 65B6 0646  14         dect  tmp2
0069 65B8 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 65BA C1C7  18         mov   tmp3,tmp3
0074 65BC 1301  14         jeq   cpymz
0075 65BE D554  38         movb  *tmp0,*tmp1
0076 65C0 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 65C2 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     65C4 8000     
0081 65C6 10E9  14         jmp   cpym2
0082 65C8 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 65CA C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 65CC 0649  14         dect  stack
0065 65CE C64B  30         mov   r11,*stack            ; Push return address
0066 65D0 0649  14         dect  stack
0067 65D2 C640  30         mov   r0,*stack             ; Push r0
0068 65D4 0649  14         dect  stack
0069 65D6 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 65D8 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 65DA 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 65DC 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     65DE 4000     
0077 65E0 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     65E2 833E     
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 65E4 020C  20         li    r12,>1e00             ; SAMS CRU address
     65E6 1E00     
0082 65E8 04C0  14         clr   r0
0083 65EA 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 65EC D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 65EE D100  18         movb  r0,tmp0
0086 65F0 0984  56         srl   tmp0,8                ; Right align
0087 65F2 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     65F4 833C     
0088 65F6 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 65F8 C339  30         mov   *stack+,r12           ; Pop r12
0094 65FA C039  30         mov   *stack+,r0            ; Pop r0
0095 65FC C2F9  30         mov   *stack+,r11           ; Pop return address
0096 65FE 045B  20         b     *r11                  ; Return to caller
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
0131 6600 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 6602 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 6604 0649  14         dect  stack
0135 6606 C64B  30         mov   r11,*stack            ; Push return address
0136 6608 0649  14         dect  stack
0137 660A C640  30         mov   r0,*stack             ; Push r0
0138 660C 0649  14         dect  stack
0139 660E C64C  30         mov   r12,*stack            ; Push r12
0140 6610 0649  14         dect  stack
0141 6612 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 6614 0649  14         dect  stack
0143 6616 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 6618 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 661A 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 661C 0284  22         ci    tmp0,255              ; Crash if page > 255
     661E 00FF     
0153 6620 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 6622 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     6624 001E     
0158 6626 150A  14         jgt   !
0159 6628 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     662A 0004     
0160 662C 1107  14         jlt   !
0161 662E 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     6630 0012     
0162 6632 1508  14         jgt   sams.page.set.switch_page
0163 6634 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     6636 0006     
0164 6638 1501  14         jgt   !
0165 663A 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 663C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     663E FFCE     
0170 6640 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6642 2026     
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 6644 020C  20         li    r12,>1e00             ; SAMS CRU address
     6646 1E00     
0176 6648 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 664A 06C0  14         swpb  r0                    ; LSB to MSB
0178 664C 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 664E D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     6650 4000     
0180 6652 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 6654 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 6656 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 6658 C339  30         mov   *stack+,r12           ; Pop r12
0188 665A C039  30         mov   *stack+,r0            ; Pop r0
0189 665C C2F9  30         mov   *stack+,r11           ; Pop return address
0190 665E 045B  20         b     *r11                  ; Return to caller
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
0204 6660 020C  20         li    r12,>1e00             ; SAMS CRU address
     6662 1E00     
0205 6664 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 6666 045B  20         b     *r11                  ; Return to caller
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
0227 6668 020C  20         li    r12,>1e00             ; SAMS CRU address
     666A 1E00     
0228 666C 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 666E 045B  20         b     *r11                  ; Return to caller
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
0260 6670 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 6672 0649  14         dect  stack
0263 6674 C64B  30         mov   r11,*stack            ; Save return address
0264 6676 0649  14         dect  stack
0265 6678 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 667A 0649  14         dect  stack
0267 667C C645  30         mov   tmp1,*stack           ; Save tmp1
0268 667E 0649  14         dect  stack
0269 6680 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 6682 0649  14         dect  stack
0271 6684 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 6686 0206  20         li    tmp2,8                ; Set loop counter
     6688 0008     
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 668A C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 668C C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 668E 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     6690 258A     
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 6692 0606  14         dec   tmp2                  ; Next iteration
0288 6694 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 6696 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6698 25E6     
0294                                                   ; / activating changes.
0295               
0296 669A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 669C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 669E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 66A0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 66A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 66A4 045B  20         b     *r11                  ; Return to caller
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
0318 66A6 0649  14         dect  stack
0319 66A8 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 66AA 06A0  32         bl    @sams.layout
     66AC 25F6     
0324 66AE 263A                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 66B0 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 66B2 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 66B4 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     66B6 0002     
0336 66B8 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     66BA 0003     
0337 66BC A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     66BE 000A     
0338 66C0 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     66C2 000B     
0339 66C4 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     66C6 000C     
0340 66C8 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     66CA 000D     
0341 66CC E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     66CE 000E     
0342 66D0 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     66D2 000F     
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
0363 66D4 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 66D6 0649  14         dect  stack
0366 66D8 C64B  30         mov   r11,*stack            ; Push return address
0367 66DA 0649  14         dect  stack
0368 66DC C644  30         mov   tmp0,*stack           ; Push tmp0
0369 66DE 0649  14         dect  stack
0370 66E0 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 66E2 0649  14         dect  stack
0372 66E4 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 66E6 0649  14         dect  stack
0374 66E8 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 66EA 0205  20         li    tmp1,sams.layout.copy.data
     66EC 2692     
0379 66EE 0206  20         li    tmp2,8                ; Set loop counter
     66F0 0008     
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66F2 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66F4 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66F6 2552     
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 66F8 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     66FA 833C     
0390               
0391 66FC 0606  14         dec   tmp2                  ; Next iteration
0392 66FE 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 6700 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 6702 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 6704 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 6706 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 6708 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 670A 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 670C 2000             data  >2000                 ; >2000-2fff
0408 670E 3000             data  >3000                 ; >3000-3fff
0409 6710 A000             data  >a000                 ; >a000-afff
0410 6712 B000             data  >b000                 ; >b000-bfff
0411 6714 C000             data  >c000                 ; >c000-cfff
0412 6716 D000             data  >d000                 ; >d000-dfff
0413 6718 E000             data  >e000                 ; >e000-efff
0414 671A F000             data  >f000                 ; >f000-ffff
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
0009 671C 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     671E FFBF     
0010 6720 0460  28         b     @putv01
     6722 235A     
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 6724 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6726 0040     
0018 6728 0460  28         b     @putv01
     672A 235A     
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 672C 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     672E FFDF     
0026 6730 0460  28         b     @putv01
     6732 235A     
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 6734 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6736 0020     
0034 6738 0460  28         b     @putv01
     673A 235A     
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
0010 673C 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     673E FFFE     
0011 6740 0460  28         b     @putv01
     6742 235A     
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6744 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6746 0001     
0019 6748 0460  28         b     @putv01
     674A 235A     
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 674C 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     674E FFFD     
0027 6750 0460  28         b     @putv01
     6752 235A     
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6754 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6756 0002     
0035 6758 0460  28         b     @putv01
     675A 235A     
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
0018 675C C83B  50 at      mov   *r11+,@wyx
     675E 832A     
0019 6760 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6762 B820  54 down    ab    @hb$01,@wyx
     6764 2012     
     6766 832A     
0028 6768 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 676A 7820  54 up      sb    @hb$01,@wyx
     676C 2012     
     676E 832A     
0037 6770 045B  20         b     *r11
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
0049 6772 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6774 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6776 832A     
0051 6778 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     677A 832A     
0052 677C 045B  20         b     *r11
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
0021 677E C120  34 yx2px   mov   @wyx,tmp0
     6780 832A     
0022 6782 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6784 06C4  14         swpb  tmp0                  ; Y<->X
0024 6786 04C5  14         clr   tmp1                  ; Clear before copy
0025 6788 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 678A 20A0  38         coc   @wbit1,config         ; f18a present ?
     678C 201E     
0030 678E 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6790 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6792 833A     
     6794 2744     
0032 6796 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6798 0A15  56         sla   tmp1,1                ; X = X * 2
0035 679A B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 679C 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     679E 0500     
0037 67A0 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 67A2 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 67A4 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 67A6 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 67A8 D105  18         movb  tmp1,tmp0
0051 67AA 06C4  14         swpb  tmp0                  ; X<->Y
0052 67AC 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     67AE 2020     
0053 67B0 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 67B2 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     67B4 2012     
0059 67B6 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     67B8 2024     
0060 67BA 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 67BC 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 67BE 0050            data   80
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
0013 67C0 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 67C2 06A0  32         bl    @putvr                ; Write once
     67C4 2346     
0015 67C6 391C             data  >391c                 ; VR1/57, value 00011100
0016 67C8 06A0  32         bl    @putvr                ; Write twice
     67CA 2346     
0017 67CC 391C             data  >391c                 ; VR1/57, value 00011100
0018 67CE 06A0  32         bl    @putvr
     67D0 2346     
0019 67D2 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 67D4 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 67D6 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 67D8 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     67DA 2346     
0030 67DC 3900             data  >3900
0031 67DE 0458  20         b     *tmp4                 ; Exit
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
0043 67E0 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 67E2 06A0  32         bl    @cpym2v
     67E4 249A     
0045 67E6 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     67E8 27AA     
     67EA 0006     
0046 67EC 06A0  32         bl    @putvr
     67EE 2346     
0047 67F0 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 67F2 06A0  32         bl    @putvr
     67F4 2346     
0049 67F6 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 67F8 0204  20         li    tmp0,>3f00
     67FA 3F00     
0055 67FC 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67FE 22CE     
0056 6800 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6802 8800     
0057 6804 0984  56         srl   tmp0,8
0058 6806 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     6808 8800     
0059 680A C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 680C 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 680E 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     6810 BFFF     
0063 6812 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 6814 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6816 4000     
0066               f18chk_exit:
0067 6818 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     681A 22A2     
0068 681C 3F00             data  >3f00,>00,6
     681E 0000     
     6820 0006     
0069 6822 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 6824 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 6826 3F00             data  >3f00                 ; 3f02 / 3f00
0076 6828 0340             data  >0340                 ; 3f04   0340  idle
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
0097 682A C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 682C 06A0  32         bl    @putvr
     682E 2346     
0102 6830 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 6832 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     6834 2346     
0105 6836 3900             data  >3900                 ; Lock the F18a
0106 6838 0458  20         b     *tmp4                 ; Exit
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
0125 683A C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 683C 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     683E 201E     
0127 6840 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 6842 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6844 8802     
0132 6846 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6848 2346     
0133 684A 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 684C 04C4  14         clr   tmp0
0135 684E D120  34         movb  @vdps,tmp0
     6850 8802     
0136 6852 0984  56         srl   tmp0,8
0137 6854 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6856 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6858 832A     
0018 685A D17B  28         movb  *r11+,tmp1
0019 685C 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 685E D1BB  28         movb  *r11+,tmp2
0021 6860 0986  56         srl   tmp2,8                ; Repeat count
0022 6862 C1CB  18         mov   r11,tmp3
0023 6864 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6866 240E     
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6868 020B  20         li    r11,hchar1
     686A 27F6     
0028 686C 0460  28         b     @xfilv                ; Draw
     686E 22A8     
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6870 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6872 2022     
0033 6874 1302  14         jeq   hchar2                ; Yes, exit
0034 6876 C2C7  18         mov   tmp3,r11
0035 6878 10EE  14         jmp   hchar                 ; Next one
0036 687A 05C7  14 hchar2  inct  tmp3
0037 687C 0457  20         b     *tmp3                 ; Exit
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
0014 687E 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     6880 8334     
0015 6882 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     6884 2006     
0016 6886 0204  20         li    tmp0,muttab
     6888 281E     
0017 688A 0205  20         li    tmp1,sound            ; Sound generator port >8400
     688C 8400     
0018 688E D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 6890 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 6892 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 6894 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 6896 045B  20         b     *r11
0023 6898 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     689A DFFF     
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
0043 689C C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     689E 8334     
0044 68A0 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     68A2 8336     
0045 68A4 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     68A6 FFF8     
0046 68A8 E0BB  30         soc   *r11+,config          ; Set options
0047 68AA D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     68AC 2012     
     68AE 831B     
0048 68B0 045B  20         b     *r11
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
0059 68B2 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     68B4 2006     
0060 68B6 1301  14         jeq   sdpla1                ; Yes, play
0061 68B8 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 68BA 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 68BC 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     68BE 831B     
     68C0 2000     
0067 68C2 1301  14         jeq   sdpla3                ; Play next note
0068 68C4 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 68C6 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     68C8 2002     
0070 68CA 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 68CC C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     68CE 8336     
0075 68D0 06C4  14         swpb  tmp0
0076 68D2 D804  38         movb  tmp0,@vdpa
     68D4 8C02     
0077 68D6 06C4  14         swpb  tmp0
0078 68D8 D804  38         movb  tmp0,@vdpa
     68DA 8C02     
0079 68DC 04C4  14         clr   tmp0
0080 68DE D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     68E0 8800     
0081 68E2 131E  14         jeq   sdexit                ; Yes. exit
0082 68E4 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 68E6 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     68E8 8336     
0084 68EA D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     68EC 8800     
     68EE 8400     
0085 68F0 0604  14         dec   tmp0
0086 68F2 16FB  14         jne   vdpla2
0087 68F4 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     68F6 8800     
     68F8 831B     
0088 68FA 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     68FC 8336     
0089 68FE 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 6900 C120  34 mmplay  mov   @wsdtmp,tmp0
     6902 8336     
0094 6904 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 6906 130C  14         jeq   sdexit                ; Yes, exit
0096 6908 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 690A A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     690C 8336     
0098 690E D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     6910 8400     
0099 6912 0605  14         dec   tmp1
0100 6914 16FC  14         jne   mmpla2
0101 6916 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     6918 831B     
0102 691A 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     691C 8336     
0103 691E 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 6920 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     6922 2004     
0108 6924 1607  14         jne   sdexi2                ; No, exit
0109 6926 C820  54         mov   @wsdlst,@wsdtmp
     6928 8334     
     692A 8336     
0110 692C D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     692E 2012     
     6930 831B     
0111 6932 045B  20 sdexi1  b     *r11                  ; Exit
0112 6934 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     6936 FFF8     
0113 6938 045B  20         b     *r11                  ; Exit
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
0016 693A 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     693C 2020     
0017 693E 020C  20         li    r12,>0024
     6940 0024     
0018 6942 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6944 295C     
0019 6946 04C6  14         clr   tmp2
0020 6948 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 694A 04CC  14         clr   r12
0025 694C 1F08  20         tb    >0008                 ; Shift-key ?
0026 694E 1302  14         jeq   realk1                ; No
0027 6950 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6952 298C     
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6954 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6956 1302  14         jeq   realk2                ; No
0033 6958 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     695A 29BC     
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 695C 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 695E 1302  14         jeq   realk3                ; No
0039 6960 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6962 29EC     
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6964 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     6966 200C     
0044 6968 1E15  20         sbz   >0015                 ; Set P5
0045 696A 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 696C 1302  14         jeq   realk4                ; No
0047 696E E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     6970 200C     
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 6972 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 6974 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6976 0006     
0053 6978 0606  14 realk5  dec   tmp2
0054 697A 020C  20         li    r12,>24               ; CRU address for P2-P4
     697C 0024     
0055 697E 06C6  14         swpb  tmp2
0056 6980 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 6982 06C6  14         swpb  tmp2
0058 6984 020C  20         li    r12,6                 ; CRU read address
     6986 0006     
0059 6988 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 698A 0547  14         inv   tmp3                  ;
0061 698C 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     698E FF00     
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 6990 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 6992 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 6994 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 6996 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 6998 0285  22         ci    tmp1,8
     699A 0008     
0070 699C 1AFA  14         jl    realk6
0071 699E C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 69A0 1BEB  14         jh    realk5                ; No, next column
0073 69A2 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 69A4 C206  18 realk8  mov   tmp2,tmp4
0078 69A6 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 69A8 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 69AA A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 69AC D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 69AE 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 69B0 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 69B2 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     69B4 200C     
0089 69B6 1608  14         jne   realka                ; No, continue saving key
0090 69B8 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     69BA 2986     
0091 69BC 1A05  14         jl    realka
0092 69BE 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     69C0 2984     
0093 69C2 1B02  14         jh    realka                ; No, continue
0094 69C4 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     69C6 E000     
0095 69C8 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     69CA 833C     
0096 69CC E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     69CE 200A     
0097 69D0 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     69D2 8C00     
0098                                                   ; / using R15 as temp storage
0099 69D4 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 69D6 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     69D8 0000     
     69DA FF0D     
     69DC 203D     
0102 69DE 7877             text  'xws29ol.'
     69E0 7332     
     69E2 396F     
     69E4 6C2E     
0103 69E6 6365             text  'ced38ik,'
     69E8 6433     
     69EA 3869     
     69EC 6B2C     
0104 69EE 7672             text  'vrf47ujm'
     69F0 6634     
     69F2 3775     
     69F4 6A6D     
0105 69F6 6274             text  'btg56yhn'
     69F8 6735     
     69FA 3679     
     69FC 686E     
0106 69FE 7A71             text  'zqa10p;/'
     6A00 6131     
     6A02 3070     
     6A04 3B2F     
0107 6A06 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6A08 0000     
     6A0A FF0D     
     6A0C 202B     
0108 6A0E 5857             text  'XWS@(OL>'
     6A10 5340     
     6A12 284F     
     6A14 4C3E     
0109 6A16 4345             text  'CED#*IK<'
     6A18 4423     
     6A1A 2A49     
     6A1C 4B3C     
0110 6A1E 5652             text  'VRF$&UJM'
     6A20 4624     
     6A22 2655     
     6A24 4A4D     
0111 6A26 4254             text  'BTG%^YHN'
     6A28 4725     
     6A2A 5E59     
     6A2C 484E     
0112 6A2E 5A51             text  'ZQA!)P:-'
     6A30 4121     
     6A32 2950     
     6A34 3A2D     
0113 6A36 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6A38 0000     
     6A3A FF0D     
     6A3C 2005     
0114 6A3E 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6A40 0804     
     6A42 0F27     
     6A44 C2B9     
0115 6A46 600B             data  >600b,>0907,>063f,>c1B8
     6A48 0907     
     6A4A 063F     
     6A4C C1B8     
0116 6A4E 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6A50 7B02     
     6A52 015F     
     6A54 C0C3     
0117 6A56 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6A58 7D0E     
     6A5A 0CC6     
     6A5C BFC4     
0118 6A5E 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6A60 7C03     
     6A62 BC22     
     6A64 BDBA     
0119 6A66 FF00     kbctrl  data  >ff00,>0000,>ff0d,>f09D
     6A68 0000     
     6A6A FF0D     
     6A6C F09D     
0120 6A6E 9897             data  >9897,>93b2,>9f8f,>8c9B
     6A70 93B2     
     6A72 9F8F     
     6A74 8C9B     
0121 6A76 8385             data  >8385,>84b3,>9e89,>8b80
     6A78 84B3     
     6A7A 9E89     
     6A7C 8B80     
0122 6A7E 9692             data  >9692,>86b4,>b795,>8a8D
     6A80 86B4     
     6A82 B795     
     6A84 8A8D     
0123 6A86 8294             data  >8294,>87b5,>b698,>888E
     6A88 87B5     
     6A8A B698     
     6A8C 888E     
0124 6A8E 9A91             data  >9a91,>81b1,>b090,>9cBB
     6A90 81B1     
     6A92 B090     
     6A94 9CBB     
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
0023 6A96 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6A98 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6A9A 8340     
0025 6A9C 04E0  34         clr   @waux1
     6A9E 833C     
0026 6AA0 04E0  34         clr   @waux2
     6AA2 833E     
0027 6AA4 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6AA6 833C     
0028 6AA8 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 6AAA 0205  20         li    tmp1,4                ; 4 nibbles
     6AAC 0004     
0033 6AAE C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6AB0 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6AB2 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6AB4 0286  22         ci    tmp2,>000a
     6AB6 000A     
0039 6AB8 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6ABA C21B  26         mov   *r11,tmp4
0045 6ABC 0988  56         srl   tmp4,8                ; Right justify
0046 6ABE 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6AC0 FFF6     
0047 6AC2 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6AC4 C21B  26         mov   *r11,tmp4
0054 6AC6 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6AC8 00FF     
0055               
0056 6ACA A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6ACC 06C6  14         swpb  tmp2
0058 6ACE DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6AD0 0944  56         srl   tmp0,4                ; Next nibble
0060 6AD2 0605  14         dec   tmp1
0061 6AD4 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6AD6 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6AD8 BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6ADA C160  34         mov   @waux3,tmp1           ; Get pointer
     6ADC 8340     
0067 6ADE 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6AE0 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6AE2 C120  34         mov   @waux2,tmp0
     6AE4 833E     
0070 6AE6 06C4  14         swpb  tmp0
0071 6AE8 DD44  32         movb  tmp0,*tmp1+
0072 6AEA 06C4  14         swpb  tmp0
0073 6AEC DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6AEE C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6AF0 8340     
0078 6AF2 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6AF4 2016     
0079 6AF6 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6AF8 C120  34         mov   @waux1,tmp0
     6AFA 833C     
0084 6AFC 06C4  14         swpb  tmp0
0085 6AFE DD44  32         movb  tmp0,*tmp1+
0086 6B00 06C4  14         swpb  tmp0
0087 6B02 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6B04 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6B06 2020     
0092 6B08 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6B0A 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6B0C 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6B0E 7FFF     
0098 6B10 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6B12 8340     
0099 6B14 0460  28         b     @xutst0               ; Display string
     6B16 2434     
0100 6B18 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6B1A C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6B1C 832A     
0122 6B1E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6B20 8000     
0123 6B22 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6B24 0207  20 mknum   li    tmp3,5                ; Digit counter
     6B26 0005     
0020 6B28 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6B2A C155  26         mov   *tmp1,tmp1            ; /
0022 6B2C C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6B2E 0228  22         ai    tmp4,4                ; Get end of buffer
     6B30 0004     
0024 6B32 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6B34 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6B36 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6B38 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6B3A 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6B3C B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6B3E D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6B40 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6B42 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6B44 0607  14         dec   tmp3                  ; Decrease counter
0036 6B46 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6B48 0207  20         li    tmp3,4                ; Check first 4 digits
     6B4A 0004     
0041 6B4C 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6B4E C11B  26         mov   *r11,tmp0
0043 6B50 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6B52 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6B54 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6B56 05CB  14 mknum3  inct  r11
0047 6B58 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6B5A 2020     
0048 6B5C 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6B5E 045B  20         b     *r11                  ; Exit
0050 6B60 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6B62 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6B64 13F8  14         jeq   mknum3                ; Yes, exit
0053 6B66 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6B68 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6B6A 7FFF     
0058 6B6C C10B  18         mov   r11,tmp0
0059 6B6E 0224  22         ai    tmp0,-4
     6B70 FFFC     
0060 6B72 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6B74 0206  20         li    tmp2,>0500            ; String length = 5
     6B76 0500     
0062 6B78 0460  28         b     @xutstr               ; Display string
     6B7A 2436     
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
0093 6B7C C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6B7E C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6B80 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6B82 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6B84 0207  20         li    tmp3,5                ; Set counter
     6B86 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6B88 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6B8A 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6B8C 0584  14         inc   tmp0                  ; Next character
0105 6B8E 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6B90 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6B92 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6B94 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6B96 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6B98 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6B9A DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6B9C 0607  14         dec   tmp3                  ; Last character ?
0121 6B9E 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6BA0 045B  20         b     *r11                  ; Return
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
0139 6BA2 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6BA4 832A     
0140 6BA6 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6BA8 8000     
0141 6BAA 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6BAC 0649  14         dect  stack
0023 6BAE C64B  30         mov   r11,*stack            ; Save return address
0024 6BB0 0649  14         dect  stack
0025 6BB2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6BB4 0649  14         dect  stack
0027 6BB6 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6BB8 0649  14         dect  stack
0029 6BBA C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6BBC 0649  14         dect  stack
0031 6BBE C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6BC0 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6BC2 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6BC4 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6BC6 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6BC8 0649  14         dect  stack
0044 6BCA C64B  30         mov   r11,*stack            ; Save return address
0045 6BCC 0649  14         dect  stack
0046 6BCE C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6BD0 0649  14         dect  stack
0048 6BD2 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6BD4 0649  14         dect  stack
0050 6BD6 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6BD8 0649  14         dect  stack
0052 6BDA C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6BDC C1D4  26 !       mov   *tmp0,tmp3
0057 6BDE 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6BE0 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6BE2 00FF     
0059 6BE4 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6BE6 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6BE8 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6BEA 0584  14         inc   tmp0                  ; Next byte
0067 6BEC 0607  14         dec   tmp3                  ; Shorten string length
0068 6BEE 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6BF0 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6BF2 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6BF4 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6BF6 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6BF8 C187  18         mov   tmp3,tmp2
0078 6BFA 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6BFC DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6BFE 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6C00 24F4     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6C02 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6C04 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C06 FFCE     
0090 6C08 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C0A 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6C0C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6C0E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6C10 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6C12 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6C14 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6C16 045B  20         b     *r11                  ; Return to caller
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
0123 6C18 0649  14         dect  stack
0124 6C1A C64B  30         mov   r11,*stack            ; Save return address
0125 6C1C 05D9  26         inct  *stack                ; Skip "data P0"
0126 6C1E 05D9  26         inct  *stack                ; Skip "data P1"
0127 6C20 0649  14         dect  stack
0128 6C22 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6C24 0649  14         dect  stack
0130 6C26 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6C28 0649  14         dect  stack
0132 6C2A C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6C2C C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6C2E C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6C30 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6C32 0649  14         dect  stack
0144 6C34 C64B  30         mov   r11,*stack            ; Save return address
0145 6C36 0649  14         dect  stack
0146 6C38 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6C3A 0649  14         dect  stack
0148 6C3C C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6C3E 0649  14         dect  stack
0150 6C40 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6C42 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6C44 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6C46 0586  14         inc   tmp2
0161 6C48 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6C4A 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6C4C 0286  22         ci    tmp2,255
     6C4E 00FF     
0167 6C50 1505  14         jgt   string.getlenc.panic
0168 6C52 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6C54 0606  14         dec   tmp2                  ; One time adjustment
0174 6C56 C806  38         mov   tmp2,@waux1           ; Store length
     6C58 833C     
0175 6C5A 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6C5C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C5E FFCE     
0181 6C60 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C62 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6C64 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6C66 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6C68 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6C6A C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6C6C 045B  20         b     *r11                  ; Return to caller
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
0023 6C6E C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     6C70 F960     
0024 6C72 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     6C74 F962     
0025 6C76 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     6C78 F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 6C7A 0200  20         li    r0,>8306              ; Scratchpad source address
     6C7C 8306     
0030 6C7E 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     6C80 F966     
0031 6C82 0202  20         li    r2,62                 ; Loop counter
     6C84 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 6C86 CC70  46         mov   *r0+,*r1+
0037 6C88 CC70  46         mov   *r0+,*r1+
0038 6C8A 0642  14         dect  r2
0039 6C8C 16FC  14         jne   cpu.scrpad.backup.copy
0040 6C8E C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     6C90 83FE     
     6C92 FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 6C94 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     6C96 F960     
0046 6C98 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     6C9A F962     
0047 6C9C C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     6C9E F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 6CA0 045B  20         b     *r11                  ; Return to caller
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
0069 6CA2 0649  14         dect  stack
0070 6CA4 C64B  30         mov   r11,*stack            ; Save return address
0071 6CA6 0649  14         dect  stack
0072 6CA8 C640  30         mov   r0,*stack             ; Push r0
0073 6CAA 0649  14         dect  stack
0074 6CAC C641  30         mov   r1,*stack             ; Push r1
0075 6CAE 0649  14         dect  stack
0076 6CB0 C642  30         mov   r2,*stack             ; Push r2
0077                       ;------------------------------------------------------
0078                       ; Prepare for copy loop, WS
0079                       ;------------------------------------------------------
0080 6CB2 0200  20         li    r0,cpu.scrpad.tgt
     6CB4 F960     
0081 6CB6 0201  20         li    r1,>8300
     6CB8 8300     
0082 6CBA 0202  20         li    r2,64
     6CBC 0040     
0083                       ;------------------------------------------------------
0084                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0085                       ;------------------------------------------------------
0086               cpu.scrpad.restore.copy:
0087 6CBE CC70  46         mov   *r0+,*r1+
0088 6CC0 CC70  46         mov   *r0+,*r1+
0089 6CC2 0602  14         dec   r2
0090 6CC4 16FC  14         jne   cpu.scrpad.restore.copy
0091                       ;------------------------------------------------------
0092                       ; Exit
0093                       ;------------------------------------------------------
0094               cpu.scrpad.restore.exit:
0095 6CC6 C0B9  30         mov   *stack+,r2            ; Pop r2
0096 6CC8 C079  30         mov   *stack+,r1            ; Pop r1
0097 6CCA C039  30         mov   *stack+,r0            ; Pop r0
0098 6CCC C2F9  30         mov   *stack+,r11           ; Pop r11
0099 6CCE 045B  20         b     *r11                  ; Return to caller
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
0038 6CD0 C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 6CD2 CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 6CD4 CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 6CD6 CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 6CD8 CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 6CDA CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 6CDC CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 6CDE CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 6CE0 CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 6CE2 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     6CE4 8310     
0055                                                   ;        as of register r8
0056 6CE6 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     6CE8 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 6CEA CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 6CEC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 6CEE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 6CF0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 6CF2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 6CF4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 6CF6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 6CF8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 6CFA 0606  14         dec   tmp2
0069 6CFC 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 6CFE C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 6D00 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6D02 2C8E     
0075                                                   ; R14=PC
0076 6D04 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 6D06 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 6D08 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     6D0A 2C28     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 6D0C 045B  20         b     *r11                  ; Return to caller
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
0119 6D0E C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0120                       ;------------------------------------------------------
0121                       ; Copy scratchpad memory to destination
0122                       ;------------------------------------------------------
0123               xcpu.scrpad.pgin:
0124 6D10 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6D12 8300     
0125 6D14 0206  20         li    tmp2,16               ; tmp2 = 256/16
     6D16 0010     
0126                       ;------------------------------------------------------
0127                       ; Copy memory
0128                       ;------------------------------------------------------
0129 6D18 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0130 6D1A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0131 6D1C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0132 6D1E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0133 6D20 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0134 6D22 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0135 6D24 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0136 6D26 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0137 6D28 0606  14         dec   tmp2
0138 6D2A 16F6  14         jne   -!                    ; Loop until done
0139                       ;------------------------------------------------------
0140                       ; Switch workspace to scratchpad memory
0141                       ;------------------------------------------------------
0142 6D2C 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6D2E 8300     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               cpu.scrpad.pgin.exit:
0147 6D30 045B  20         b     *r11                  ; Return to caller
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
0056 6D32 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6D34 2CBC             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6D36 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6D38 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6D3A A428     
0064 6D3C 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6D3E 201C     
0065 6D40 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6D42 8356     
0066 6D44 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6D46 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6D48 FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6D4A C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6D4C A434     
0073                       ;---------------------------; Inline VSBR start
0074 6D4E 06C0  14         swpb  r0                    ;
0075 6D50 D800  38         movb  r0,@vdpa              ; Send low byte
     6D52 8C02     
0076 6D54 06C0  14         swpb  r0                    ;
0077 6D56 D800  38         movb  r0,@vdpa              ; Send high byte
     6D58 8C02     
0078 6D5A D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6D5C 8800     
0079                       ;---------------------------; Inline VSBR end
0080 6D5E 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6D60 0704  14         seto  r4                    ; Init counter
0086 6D62 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6D64 A420     
0087 6D66 0580  14 !       inc   r0                    ; Point to next char of name
0088 6D68 0584  14         inc   r4                    ; Increment char counter
0089 6D6A 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6D6C 0007     
0090 6D6E 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6D70 80C4  18         c     r4,r3                 ; End of name?
0093 6D72 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6D74 06C0  14         swpb  r0                    ;
0098 6D76 D800  38         movb  r0,@vdpa              ; Send low byte
     6D78 8C02     
0099 6D7A 06C0  14         swpb  r0                    ;
0100 6D7C D800  38         movb  r0,@vdpa              ; Send high byte
     6D7E 8C02     
0101 6D80 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6D82 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6D84 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6D86 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6D88 2E24     
0109 6D8A 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6D8C C104  18         mov   r4,r4                 ; Check if length = 0
0115 6D8E 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6D90 04E0  34         clr   @>83d0
     6D92 83D0     
0118 6D94 C804  38         mov   r4,@>8354             ; Save name length for search (length
     6D96 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6D98 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6D9A A432     
0121               
0122 6D9C 0584  14         inc   r4                    ; Adjust for dot
0123 6D9E A804  38         a     r4,@>8356             ; Point to position after name
     6DA0 8356     
0124 6DA2 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6DA4 8356     
     6DA6 A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6DA8 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6DAA 83E0     
0130 6DAC 04C1  14         clr   r1                    ; Version found of dsr
0131 6DAE 020C  20         li    r12,>0f00             ; Init cru address
     6DB0 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6DB2 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6DB4 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6DB6 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6DB8 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6DBA 0100     
0145 6DBC 04E0  34         clr   @>83d0                ; Clear in case we are done
     6DBE 83D0     
0146 6DC0 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6DC2 2000     
0147 6DC4 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6DC6 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6DC8 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6DCA 1D00  20         sbo   0                     ; Turn on ROM
0154 6DCC 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6DCE 4000     
0155 6DD0 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6DD2 2E20     
0156 6DD4 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6DD6 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6DD8 A40A     
0166 6DDA 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6DDC C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6DDE 83D2     
0172                                                   ; subprogram
0173               
0174 6DE0 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6DE2 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6DE4 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6DE6 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6DE8 83D2     
0183                                                   ; subprogram
0184               
0185 6DEA 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6DEC C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6DEE 04C5  14         clr   r5                    ; Remove any old stuff
0194 6DF0 D160  34         movb  @>8355,r5             ; Get length as counter
     6DF2 8355     
0195 6DF4 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6DF6 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6DF8 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6DFA 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6DFC 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6DFE A420     
0206 6E00 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6E02 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6E04 0605  14         dec   r5                    ; Update loop counter
0211 6E06 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6E08 0581  14         inc   r1                    ; Next version found
0217 6E0A C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6E0C A42A     
0218 6E0E C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6E10 A42C     
0219 6E12 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6E14 A430     
0220               
0221 6E16 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6E18 8C02     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6E1A 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6E1C 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6E1E 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6E20 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6E22 A400     
0233 6E24 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6E26 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6E28 A428     
0239                                                   ; (8 or >a)
0240 6E2A 0281  22         ci    r1,8                  ; was it 8?
     6E2C 0008     
0241 6E2E 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6E30 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6E32 8350     
0243                                                   ; Get error byte from @>8350
0244 6E34 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6E36 06C0  14         swpb  r0                    ;
0252 6E38 D800  38         movb  r0,@vdpa              ; send low byte
     6E3A 8C02     
0253 6E3C 06C0  14         swpb  r0                    ;
0254 6E3E D800  38         movb  r0,@vdpa              ; send high byte
     6E40 8C02     
0255 6E42 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6E44 8800     
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6E46 09D1  56         srl   r1,13                 ; just keep error bits
0263 6E48 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6E4A 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6E4C 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6E4E 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6E50 A400     
0275               dsrlnk.error.devicename_invalid:
0276 6E52 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6E54 06C1  14         swpb  r1                    ; put error in hi byte
0279 6E56 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6E58 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6E5A 201C     
0281                                                   ; / to indicate error
0282 6E5C 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6E5E A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6E60 2DE8             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6E62 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6E64 83E0     
0316               
0317 6E66 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6E68 201C     
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6E6A 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6E6C A42A     
0322 6E6E C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6E70 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6E72 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6E74 8356     
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6E76 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6E78 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6E7A 8354     
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6E7C 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6E7E 8C02     
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6E80 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6E82 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6E84 4000     
     6E86 2E20     
0337 6E88 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6E8A 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6E8C 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6E8E 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6E90 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6E92 A400     
0355 6E94 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6E96 A434     
0356               
0357 6E98 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6E9A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6E9C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6E9E 2E       dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6EA0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6EA2 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6EA4 0649  14         dect  stack
0052 6EA6 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6EA8 0204  20         li    tmp0,dsrlnk.savcru
     6EAA A42A     
0057 6EAC 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6EAE 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6EB0 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6EB2 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6EB4 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6EB6 37D7     
0065 6EB8 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6EBA 8370     
0066                                                   ; / location
0067 6EBC C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6EBE A44C     
0068 6EC0 04C5  14         clr   tmp1                  ; io.op.open
0069 6EC2 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6EC4 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6EC6 0649  14         dect  stack
0097 6EC8 C64B  30         mov   r11,*stack            ; Save return address
0098 6ECA 0205  20         li    tmp1,io.op.close      ; io.op.close
     6ECC 0001     
0099 6ECE 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6ED0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6ED2 0649  14         dect  stack
0125 6ED4 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6ED6 0205  20         li    tmp1,io.op.read       ; io.op.read
     6ED8 0002     
0128 6EDA 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6EDC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6EDE 0649  14         dect  stack
0155 6EE0 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6EE2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6EE4 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6EE6 0005     
0159               
0160 6EE8 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6EEA A43E     
0161               
0162 6EEC 06A0  32         bl    @xvputb               ; Write character count to PAB
     6EEE 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6EF0 0205  20         li    tmp1,io.op.write      ; io.op.write
     6EF2 0003     
0167 6EF4 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6EF6 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6EF8 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6EFA 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6EFC 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6EFE 1000  14         nop
0189               
0190               
0191               file.status:
0192 6F00 1000  14         nop
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
0227 6F02 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6F04 A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6F06 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6F08 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6F0A A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6F0C 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6F0E 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6F10 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6F12 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6F14 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6F16 A44C     
0246               
0247 6F18 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6F1A 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6F1C 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6F1E 0009     
0254 6F20 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6F22 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6F24 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6F26 8322     
     6F28 833C     
0259               
0260 6F2A C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6F2C A42A     
0261 6F2E 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6F30 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6F32 2CB8     
0268 6F34 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6F36 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6F38 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6F3A 2DE4     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6F3C 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6F3E C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6F40 833C     
     6F42 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6F44 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6F46 A436     
0292 6F48 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6F4A 0005     
0293 6F4C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6F4E 22F8     
0294 6F50 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6F52 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6F54 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6F56 045B  20         b     *r11                  ; Return to caller
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
0020 6F58 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F5A 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F5C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F5E 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F60 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F62 201C     
0029 6F64 1602  14         jne   tmgr1a                ; No, so move on
0030 6F66 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F68 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F6A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F6C 2020     
0035 6F6E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F70 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F72 2010     
0048 6F74 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F76 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F78 200E     
0050 6F7A 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F7C 0460  28         b     @kthread              ; Run kernel thread
     6F7E 2F7C     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F80 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F82 2014     
0056 6F84 13EB  14         jeq   tmgr1
0057 6F86 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F88 2012     
0058 6F8A 16E8  14         jne   tmgr1
0059 6F8C C120  34         mov   @wtiusr,tmp0
     6F8E 832E     
0060 6F90 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F92 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F94 2F7A     
0065 6F96 C10A  18         mov   r10,tmp0
0066 6F98 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F9A 00FF     
0067 6F9C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F9E 201C     
0068 6FA0 1303  14         jeq   tmgr5
0069 6FA2 0284  22         ci    tmp0,60               ; 1 second reached ?
     6FA4 003C     
0070 6FA6 1002  14         jmp   tmgr6
0071 6FA8 0284  22 tmgr5   ci    tmp0,50
     6FAA 0032     
0072 6FAC 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6FAE 1001  14         jmp   tmgr8
0074 6FB0 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6FB2 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6FB4 832C     
0079 6FB6 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6FB8 FF00     
0080 6FBA C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6FBC 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6FBE 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6FC0 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6FC2 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6FC4 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6FC6 830C     
     6FC8 830D     
0089 6FCA 1608  14         jne   tmgr10                ; No, get next slot
0090 6FCC 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6FCE FF00     
0091 6FD0 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6FD2 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6FD4 8330     
0096 6FD6 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6FD8 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6FDA 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6FDC 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6FDE 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6FE0 8315     
     6FE2 8314     
0103 6FE4 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6FE6 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6FE8 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6FEA 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6FEC 10F7  14         jmp   tmgr10                ; Process next slot
0108 6FEE 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6FF0 FF00     
0109 6FF2 10B4  14         jmp   tmgr1
0110 6FF4 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6FF6 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6FF8 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 6FFA 20A0  38         coc   @wbit13,config        ; Sound player on ?
     6FFC 2006     
0023 6FFE 1602  14         jne   kthread_kb
0024 7000 06A0  32         bl    @sdpla1               ; Run sound player
     7002 2840     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 7004 06A0  32         bl    @realkb               ; Scan full keyboard
     7006 28C0     
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 7008 0460  28         b     @tmgr3                ; Exit
     700A 2F06     
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
0017 700C C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     700E 832E     
0018 7010 E0A0  34         soc   @wbit7,config         ; Enable user hook
     7012 2012     
0019 7014 045B  20 mkhoo1  b     *r11                  ; Return
0020      2EE2     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 7016 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     7018 832E     
0029 701A 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     701C FEFF     
0030 701E 045B  20         b     *r11                  ; Return
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
0017 7020 C13B  30 mkslot  mov   *r11+,tmp0
0018 7022 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 7024 C184  18         mov   tmp0,tmp2
0023 7026 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 7028 A1A0  34         a     @wtitab,tmp2          ; Add table base
     702A 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 702C CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 702E 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 7030 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 7032 881B  46         c     *r11,@w$ffff          ; End of list ?
     7034 2022     
0035 7036 1301  14         jeq   mkslo1                ; Yes, exit
0036 7038 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 703A 05CB  14 mkslo1  inct  r11
0041 703C 045B  20         b     *r11                  ; Exit
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
0052 703E C13B  30 clslot  mov   *r11+,tmp0
0053 7040 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 7042 A120  34         a     @wtitab,tmp0          ; Add table base
     7044 832C     
0055 7046 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 7048 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 704A 045B  20         b     *r11                  ; Exit
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
0068 704C C13B  30 rsslot  mov   *r11+,tmp0
0069 704E 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 7050 A120  34         a     @wtitab,tmp0          ; Add table base
     7052 832C     
0071 7054 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 7056 C154  26         mov   *tmp0,tmp1
0073 7058 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     705A FF00     
0074 705C C505  30         mov   tmp1,*tmp0
0075 705E 045B  20         b     *r11                  ; Exit
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
0261 7060 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7062 8302     
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 7064 0300  24 runli1  limi  0                     ; Turn off interrupts
     7066 0000     
0267 7068 02E0  18         lwpi  ws1                   ; Activate workspace 1
     706A 8300     
0268 706C C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     706E 83C0     
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 7070 0202  20 runli2  li    r2,>8308
     7072 8308     
0273 7074 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 7076 0282  22         ci    r2,>8400
     7078 8400     
0275 707A 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 707C 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     707E FFFF     
0280 7080 1602  14         jne   runli4                ; No, continue
0281 7082 0420  54         blwp  @0                    ; Yes, bye bye
     7084 0000     
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 7086 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7088 833C     
0286 708A 04C1  14         clr   r1                    ; Reset counter
0287 708C 0202  20         li    r2,10                 ; We test 10 times
     708E 000A     
0288 7090 C0E0  34 runli5  mov   @vdps,r3
     7092 8802     
0289 7094 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7096 2020     
0290 7098 1302  14         jeq   runli6
0291 709A 0581  14         inc   r1                    ; Increase counter
0292 709C 10F9  14         jmp   runli5
0293 709E 0602  14 runli6  dec   r2                    ; Next test
0294 70A0 16F7  14         jne   runli5
0295 70A2 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     70A4 1250     
0296 70A6 1202  14         jle   runli7                ; No, so it must be NTSC
0297 70A8 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     70AA 201C     
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 70AC 06A0  32 runli7  bl    @loadmc
     70AE 222E     
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 70B0 04C1  14 runli9  clr   r1
0306 70B2 04C2  14         clr   r2
0307 70B4 04C3  14         clr   r3
0308 70B6 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     70B8 AF00     
0309 70BA 020F  20         li    r15,vdpw              ; Set VDP write address
     70BC 8C00     
0311 70BE 06A0  32         bl    @mute                 ; Mute sound generators
     70C0 2804     
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 70C2 0280  22         ci    r0,>4a4a              ; Crash flag set?
     70C4 4A4A     
0318 70C6 1605  14         jne   runlia
0319 70C8 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     70CA 22A2     
0320 70CC 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     70CE 0000     
     70D0 3000     
0325 70D2 06A0  32 runlia  bl    @filv
     70D4 22A2     
0326 70D6 0FC0             data  pctadr,spfclr,16      ; Load color table
     70D8 00F4     
     70DA 0010     
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 70DC 06A0  32         bl    @f18unl               ; Unlock the F18A
     70DE 2746     
0334 70E0 06A0  32         bl    @f18chk               ; Check if F18A is there \
     70E2 2766     
0335 70E4 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     70E6 2766     
0336 70E8 06A0  32         bl    @f18chk               ; Check if F18A is there /
     70EA 2766     
0337 70EC 06A0  32         bl    @f18lck               ; Lock the F18A again
     70EE 275C     
0338               
0339 70F0 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     70F2 2346     
0340 70F4 3201                   data >3201            ; F18a VR50 (>32), bit 1
0342               *--------------------------------------------------------------
0343               * Check if there is a speech synthesizer attached
0344               *--------------------------------------------------------------
0346               *       <<skipped>>
0350               *--------------------------------------------------------------
0351               * Load video mode table & font
0352               *--------------------------------------------------------------
0353 70F6 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     70F8 230C     
0354 70FA 3640             data  spvmod                ; Equate selected video mode table
0355 70FC 0204  20         li    tmp0,spfont           ; Get font option
     70FE 000C     
0356 7100 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0357 7102 1304  14         jeq   runlid                ; Yes, skip it
0358 7104 06A0  32         bl    @ldfnt
     7106 2374     
0359 7108 1100             data  fntadr,spfont         ; Load specified font
     710A 000C     
0360               *--------------------------------------------------------------
0361               * Did a system crash occur before runlib was called?
0362               *--------------------------------------------------------------
0363 710C 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     710E 4A4A     
0364 7110 1602  14         jne   runlie                ; No, continue
0365 7112 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     7114 2086     
0366               *--------------------------------------------------------------
0367               * Branch to main program
0368               *--------------------------------------------------------------
0369 7116 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     7118 0040     
0370 711A 0460  28         b     @main                 ; Give control to main program
     711C 3A3E     
                   < stevie_b0.asm.103101
0087                       copy  "ram.resident.asm"
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
0021 711E C13B  30         mov   *r11+,tmp0            ; P0
0022 7120 C17B  30         mov   *r11+,tmp1            ; P1
0023 7122 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 7124 0649  14         dect  stack
0029 7126 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 7128 0649  14         dect  stack
0031 712A C645  30         mov   tmp1,*stack           ; Push tmp1
0032 712C 0649  14         dect  stack
0033 712E C646  30         mov   tmp2,*stack           ; Push tmp2
0034 7130 0649  14         dect  stack
0035 7132 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 7134 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     7136 6000     
0040 7138 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 713A C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     713C A226     
0044 713E 0647  14         dect  tmp3
0045 7140 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 7142 0647  14         dect  tmp3
0047 7144 C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 7146 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     7148 A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 714A 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 714C 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 714E 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 7150 0224  22         ai    tmp0,>0800
     7152 0800     
0066 7154 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 7156 0285  22         ci    tmp1,>ffff
     7158 FFFF     
0075 715A 1602  14         jne   !
0076 715C C160  34         mov   @trmpvector,tmp1
     715E A02E     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 7160 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 7162 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 7164 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 7166 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7168 FFCE     
0091 716A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     716C 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 716E 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 7170 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     7172 A226     
0102 7174 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 7176 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 7178 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 717A C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 717C 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 717E 028B  22         ci    r11,>6000
     7180 6000     
0115 7182 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 7184 028B  22         ci    r11,>7fff
     7186 7FFF     
0117 7188 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 718A C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     718C A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 718E 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 7190 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 7192 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 7194 0225  22         ai    tmp1,>0800
     7196 0800     
0137 7198 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 719A 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 719C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     719E FFCE     
0144 71A0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     71A2 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 71A4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 71A6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 71A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 71AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 71AC 045B  20         b     *r11                  ; Return to caller
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
0020 71AE 0649  14         dect  stack
0021 71B0 C64B  30         mov   r11,*stack            ; Save return address
0022 71B2 0649  14         dect  stack
0023 71B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 71B6 0649  14         dect  stack
0025 71B8 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 71BA 0204  20         li    tmp0,fb.top
     71BC D000     
0030 71BE C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     71C0 A300     
0031 71C2 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     71C4 A304     
0032 71C6 04E0  34         clr   @fb.row               ; Current row=0
     71C8 A306     
0033 71CA 04E0  34         clr   @fb.column            ; Current column=0
     71CC A30C     
0034               
0035 71CE 0204  20         li    tmp0,colrow
     71D0 0050     
0036 71D2 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     71D4 A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 71D6 C160  34         mov   @tv.ruler.visible,tmp1
     71D8 A210     
0041 71DA 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 71DC 0204  20         li    tmp0,pane.botrow-2
     71DE 001B     
0043 71E0 1002  14         jmp   fb.init.cont
0044 71E2 0204  20 !       li    tmp0,pane.botrow-1
     71E4 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 71E6 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     71E8 A31A     
0050 71EA C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     71EC A31C     
0051               
0052 71EE 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     71F0 A222     
0053 71F2 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     71F4 A310     
0054 71F6 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     71F8 A316     
0055 71FA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     71FC A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 71FE 06A0  32         bl    @film
     7200 224A     
0060 7202 D000             data  fb.top,>00,fb.size    ; Clear it all the way
     7204 0000     
     7206 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 7208 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 720A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 720C C2F9  30         mov   *stack+,r11           ; Pop r11
0068 720E 045B  20         b     *r11                  ; Return to caller
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
0051 7210 0649  14         dect  stack
0052 7212 C64B  30         mov   r11,*stack            ; Save return address
0053 7214 0649  14         dect  stack
0054 7216 C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 7218 0204  20         li    tmp0,idx.top
     721A B000     
0059 721C C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     721E A502     
0060               
0061 7220 C120  34         mov   @tv.sams.b000,tmp0
     7222 A206     
0062 7224 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     7226 A600     
0063 7228 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     722A A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 722C 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     722E 0004     
0068 7230 C804  38         mov   tmp0,@idx.sams.hipage ; /
     7232 A604     
0069               
0070 7234 06A0  32         bl    @_idx.sams.mapcolumn.on
     7236 31D8     
0071                                                   ; Index in continuous memory region
0072               
0073 7238 06A0  32         bl    @film
     723A 224A     
0074 723C B000                   data idx.top,>00,idx.size * 5
     723E 0000     
     7240 5000     
0075                                                   ; Clear index
0076               
0077 7242 06A0  32         bl    @_idx.sams.mapcolumn.off
     7244 320C     
0078                                                   ; Restore memory window layout
0079               
0080 7246 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     7248 A602     
     724A A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 724C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 724E C2F9  30         mov   *stack+,r11           ; Pop r11
0088 7250 045B  20         b     *r11                  ; Return to caller
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
0101 7252 0649  14         dect  stack
0102 7254 C64B  30         mov   r11,*stack            ; Push return address
0103 7256 0649  14         dect  stack
0104 7258 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 725A 0649  14         dect  stack
0106 725C C645  30         mov   tmp1,*stack           ; Push tmp1
0107 725E 0649  14         dect  stack
0108 7260 C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 7262 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     7264 A602     
0113 7266 0205  20         li    tmp1,idx.top
     7268 B000     
0114 726A 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     726C 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 726E 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     7270 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 7272 0584  14         inc   tmp0                  ; Next SAMS index page
0123 7274 0225  22         ai    tmp1,>1000            ; Next memory region
     7276 1000     
0124 7278 0606  14         dec   tmp2                  ; Update loop counter
0125 727A 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 727C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 727E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 7280 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 7282 C2F9  30         mov   *stack+,r11           ; Pop return address
0134 7284 045B  20         b     *r11                  ; Return to caller
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
0150 7286 0649  14         dect  stack
0151 7288 C64B  30         mov   r11,*stack            ; Push return address
0152 728A 0649  14         dect  stack
0153 728C C644  30         mov   tmp0,*stack           ; Push tmp0
0154 728E 0649  14         dect  stack
0155 7290 C645  30         mov   tmp1,*stack           ; Push tmp1
0156 7292 0649  14         dect  stack
0157 7294 C646  30         mov   tmp2,*stack           ; Push tmp2
0158 7296 0649  14         dect  stack
0159 7298 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 729A 0205  20         li    tmp1,idx.top
     729C B000     
0164 729E 0206  20         li    tmp2,5                ; Always 5 pages
     72A0 0005     
0165 72A2 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     72A4 A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 72A6 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 72A8 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     72AA 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 72AC 0225  22         ai    tmp1,>1000            ; Next memory region
     72AE 1000     
0176 72B0 0606  14         dec   tmp2                  ; Update loop counter
0177 72B2 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 72B4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 72B6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 72B8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 72BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 72BC C2F9  30         mov   *stack+,r11           ; Pop return address
0187 72BE 045B  20         b     *r11                  ; Return to caller
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
0211 72C0 0649  14         dect  stack
0212 72C2 C64B  30         mov   r11,*stack            ; Save return address
0213 72C4 0649  14         dect  stack
0214 72C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0215 72C8 0649  14         dect  stack
0216 72CA C645  30         mov   tmp1,*stack           ; Push tmp1
0217 72CC 0649  14         dect  stack
0218 72CE C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 72D0 C184  18         mov   tmp0,tmp2             ; Line number
0223 72D2 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 72D4 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     72D6 0800     
0225               
0226 72D8 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 72DA 0A16  56         sla   tmp2,1                ; line number * 2
0231 72DC C806  38         mov   tmp2,@outparm1        ; Offset index entry
     72DE A010     
0232               
0233 72E0 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     72E2 A602     
0234 72E4 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     72E6 A600     
0235               
0236 72E8 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 72EA C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     72EC A600     
0242 72EE C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     72F0 A206     
0243 72F2 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 72F4 0205  20         li    tmp1,>b000            ; Memory window for index page
     72F6 B000     
0246               
0247 72F8 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     72FA 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 72FC 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     72FE A604     
0254 7300 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 7302 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     7304 A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 7306 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 7308 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 730A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 730C C2F9  30         mov   *stack+,r11           ; Pop r11
0265 730E 045B  20         b     *r11                  ; Return to caller
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
0022 7310 0649  14         dect  stack
0023 7312 C64B  30         mov   r11,*stack            ; Save return address
0024 7314 0649  14         dect  stack
0025 7316 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7318 06A0  32         bl    @mem.sams.layout      ; Load standard SAMS pages again
     731A 3458     
0030               
0031 731C 0204  20         li    tmp0,edb.top          ; \
     731E C000     
0032 7320 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     7322 A500     
0033 7324 C804  38         mov   tmp0,@edb.next_free.ptr
     7326 A508     
0034                                                   ; Set pointer to next free line
0035               
0036 7328 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     732A A50A     
0037               
0038 732C 0204  20         li    tmp0,1
     732E 0001     
0039 7330 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     7332 A504     
0040               
0041 7334 0720  34         seto  @edb.block.m1         ; Reset block start line
     7336 A50C     
0042 7338 0720  34         seto  @edb.block.m2         ; Reset block end line
     733A A50E     
0043               
0044 733C 0204  20         li    tmp0,txt.newfile      ; "New file"
     733E 3898     
0045 7340 C804  38         mov   tmp0,@edb.filename.ptr
     7342 A512     
0046               
0047 7344 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     7346 A440     
0048 7348 04E0  34         clr   @fh.kilobytes.prev    ; /
     734A A45C     
0049               
0050 734C 0204  20         li    tmp0,txt.filetype.none
     734E 3954     
0051 7350 C804  38         mov   tmp0,@edb.filetype.ptr
     7352 A514     
0052               
0053               edb.init.exit:
0054                       ;------------------------------------------------------
0055                       ; Exit
0056                       ;------------------------------------------------------
0057 7354 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7356 C2F9  30         mov   *stack+,r11           ; Pop r11
0059 7358 045B  20         b     *r11                  ; Return to caller
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
0022 735A 0649  14         dect  stack
0023 735C C64B  30         mov   r11,*stack            ; Save return address
0024 735E 0649  14         dect  stack
0025 7360 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7362 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     7364 E000     
0030 7366 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     7368 A700     
0031               
0032 736A 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     736C A702     
0033 736E 0204  20         li    tmp0,4
     7370 0004     
0034 7372 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     7374 A706     
0035 7376 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     7378 A708     
0036               
0037 737A 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     737C A716     
0038 737E 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     7380 A718     
0039 7382 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     7384 A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 7386 06A0  32         bl    @film
     7388 224A     
0044 738A E000             data  cmdb.top,>00,cmdb.size
     738C 0000     
     738E 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 7390 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 7392 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 7394 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0012                       copy  "errline.asm"            ; Error line
     **** ****     > errline.asm
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
0022 7396 0649  14         dect  stack
0023 7398 C64B  30         mov   r11,*stack            ; Save return address
0024 739A 0649  14         dect  stack
0025 739C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 739E 04E0  34         clr   @tv.error.visible     ; Set to hidden
     73A0 A228     
0030               
0031 73A2 06A0  32         bl    @film
     73A4 224A     
0032 73A6 A22A                   data tv.error.msg,0,160
     73A8 0000     
     73AA 00A0     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 73AC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 73AE C2F9  30         mov   *stack+,r11           ; Pop R11
0039 73B0 045B  20         b     *r11                  ; Return to caller
0040               
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
0022 73B2 0649  14         dect  stack
0023 73B4 C64B  30         mov   r11,*stack            ; Save return address
0024 73B6 0649  14         dect  stack
0025 73B8 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 73BA 0649  14         dect  stack
0027 73BC C645  30         mov   tmp1,*stack           ; Push tmp1
0028 73BE 0649  14         dect  stack
0029 73C0 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 73C2 0204  20         li    tmp0,1                ; \ Set default color scheme
     73C4 0001     
0034 73C6 C804  38         mov   tmp0,@tv.colorscheme  ; /
     73C8 A212     
0035               
0036 73CA 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     73CC A224     
0037 73CE E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     73D0 200C     
0038               
0039 73D2 0204  20         li    tmp0,fj.bottom
     73D4 B000     
0040 73D6 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     73D8 A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 73DA 06A0  32         bl    @cpym2m
     73DC 24EE     
0045 73DE 3A2C                   data def.printer.fname,tv.printer.fname,7
     73E0 D960     
     73E2 0007     
0046               
0047 73E4 06A0  32         bl    @cpym2m
     73E6 24EE     
0048 73E8 3A34                   data def.clip.fname,tv.clip.fname,10
     73EA D9B0     
     73EC 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 73EE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 73F0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 73F2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 73F4 C2F9  30         mov   *stack+,r11           ; Pop R11
0057 73F6 045B  20         b     *r11                  ; Return to caller
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
0079 73F8 0649  14         dect  stack
0080 73FA C64B  30         mov   r11,*stack            ; Save return address
0081                       ;------------------------------------------------------
0082                       ; Reset editor
0083                       ;------------------------------------------------------
0084 73FC 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     73FE 32E0     
0085 7400 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7402 3296     
0086 7404 06A0  32         bl    @idx.init             ; Initialize index
     7406 3196     
0087 7408 06A0  32         bl    @fb.init              ; Initialize framebuffer
     740A 3134     
0088 740C 06A0  32         bl    @errline.init         ; Initialize error line
     740E 331C     
0089                       ;------------------------------------------------------
0090                       ; Remove markers and shortcuts
0091                       ;------------------------------------------------------
0092 7410 06A0  32         bl    @hchar
     7412 27DC     
0093 7414 0034                   byte 0,52,32,18           ; Remove markers
     7416 2012     
0094 7418 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     741A 2033     
0095 741C FFFF                   data eol
0096                       ;-------------------------------------------------------
0097                       ; Exit
0098                       ;-------------------------------------------------------
0099               tv.reset.exit:
0100 741E C2F9  30         mov   *stack+,r11           ; Pop R11
0101 7420 045B  20         b     *r11                  ; Return to caller
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
0020 7422 0649  14         dect  stack
0021 7424 C64B  30         mov   r11,*stack            ; Save return address
0022 7426 0649  14         dect  stack
0023 7428 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 742A 06A0  32         bl    @mknum                ; Convert unsigned number to string
     742C 2AAA     
0028 742E A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 7430 A140                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 7432 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 7433   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 7434 0204  20         li    tmp0,unpacked.string
     7436 A026     
0034 7438 04F4  30         clr   *tmp0+                ; Clear string 01
0035 743A 04F4  30         clr   *tmp0+                ; Clear string 23
0036 743C 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 743E 06A0  32         bl    @trimnum              ; Trim unsigned number string
     7440 2B02     
0039 7442 A140                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 7444 A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 7446 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 7448 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 744A C2F9  30         mov   *stack+,r11           ; Pop r11
0048 744C 045B  20         b     *r11                  ; Return to caller
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
0073 744E 0649  14         dect  stack
0074 7450 C64B  30         mov   r11,*stack            ; Push return address
0075 7452 0649  14         dect  stack
0076 7454 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 7456 0649  14         dect  stack
0078 7458 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 745A 0649  14         dect  stack
0080 745C C646  30         mov   tmp2,*stack           ; Push tmp2
0081 745E 0649  14         dect  stack
0082 7460 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 7462 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     7464 A000     
0087 7466 D194  26         movb  *tmp0,tmp2            ; /
0088 7468 0986  56         srl   tmp2,8                ; Right align
0089 746A C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 746C 8806  38         c     tmp2,@parm2           ; String length > requested length?
     746E A002     
0092 7470 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 7472 C120  34         mov   @parm1,tmp0           ; Get source address
     7474 A000     
0097 7476 C160  34         mov   @parm4,tmp1           ; Get destination address
     7478 A006     
0098 747A 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 747C 0649  14         dect  stack
0101 747E C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 7480 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     7482 24F4     
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 7484 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 7486 C120  34         mov   @parm2,tmp0           ; Get requested length
     7488 A002     
0113 748A 0A84  56         sla   tmp0,8                ; Left align
0114 748C C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     748E A006     
0115 7490 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 7492 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 7494 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 7496 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     7498 A002     
0122 749A 6187  18         s     tmp3,tmp2             ; |
0123 749C 0586  14         inc   tmp2                  ; /
0124               
0125 749E C120  34         mov   @parm3,tmp0           ; Get byte to padd
     74A0 A004     
0126 74A2 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 74A4 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 74A6 0606  14         dec   tmp2                  ; Update loop counter
0133 74A8 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 74AA C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     74AC A006     
     74AE A010     
0136 74B0 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 74B2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     74B4 FFCE     
0142 74B6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     74B8 2026     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 74BA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 74BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 74BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 74C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 74C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 74C4 045B  20         b     *r11                  ; Return to caller
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
0174 74C6 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     74C8 27B0     
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 74CA 04E0  34         clr   @bank0.rom            ; Activate bank 0
     74CC 6000     
0179 74CE 0420  54         blwp  @0                    ; Reset to monitor
     74D0 0000     
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
0017 74D2 0649  14         dect  stack
0018 74D4 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 74D6 06A0  32         bl    @sams.layout
     74D8 25F6     
0023 74DA 366C                   data mem.sams.layout.data
0024               
0025 74DC 06A0  32         bl    @sams.layout.copy
     74DE 265A     
0026 74E0 A200                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 74E2 C820  54         mov   @tv.sams.c000,@edb.sams.page
     74E4 A208     
     74E6 A516     
0029 74E8 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     74EA A516     
     74EC A518     
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 74EE C2F9  30         mov   *stack+,r11           ; Pop r11
0036 74F0 045B  20         b     *r11                  ; Return to caller
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
0022 74F2 0649  14         dect  stack
0023 74F4 C64B  30         mov   r11,*stack            ; Save return address
0024 74F6 0649  14         dect  stack
0025 74F8 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 74FA 0649  14         dect  stack
0027 74FC C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 74FE C120  34         mov   @parm1,tmp0           ; Get line number
     7500 A000     
0032 7502 C160  34         mov   @parm2,tmp1           ; Get pointer
     7504 A002     
0033 7506 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 7508 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     750A 0FFF     
0039 750C 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 750E 06E0  34         swpb  @parm3
     7510 A004     
0044 7512 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     7514 A004     
0045 7516 06E0  34         swpb  @parm3                ; \ Restore original order again,
     7518 A004     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 751A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     751C 3246     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 751E C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     7520 A010     
0056 7522 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     7524 B000     
0057 7526 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     7528 A010     
0058 752A 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 752C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     752E 3246     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 7530 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     7532 A010     
0068 7534 04E4  34         clr   @idx.top(tmp0)        ; /
     7536 B000     
0069 7538 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     753A A010     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 753C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 753E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 7540 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 7542 045B  20         b     *r11                  ; Return to caller
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
0021 7544 0649  14         dect  stack
0022 7546 C64B  30         mov   r11,*stack            ; Save return address
0023 7548 0649  14         dect  stack
0024 754A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 754C 0649  14         dect  stack
0026 754E C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7550 0649  14         dect  stack
0028 7552 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 7554 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7556 A000     
0033               
0034 7558 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     755A 3246     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 755C C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     755E A010     
0039 7560 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     7562 B000     
0040               
0041 7564 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 7566 C185  18         mov   tmp1,tmp2             ; \
0047 7568 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 756A 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     756C 00FF     
0052 756E 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 7570 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     7572 C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 7574 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     7576 A010     
0059 7578 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     757A A012     
0060 757C 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 757E 04E0  34         clr   @outparm1
     7580 A010     
0066 7582 04E0  34         clr   @outparm2
     7584 A012     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 7586 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 7588 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 758A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 758C C2F9  30         mov   *stack+,r11           ; Pop r11
0075 758E 045B  20         b     *r11                  ; Return to caller
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
0017 7590 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     7592 B000     
0018 7594 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 7596 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 7598 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 759A 0606  14         dec   tmp2                  ; tmp2--
0026 759C 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 759E 045B  20         b     *r11                  ; Return to caller
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
0046 75A0 0649  14         dect  stack
0047 75A2 C64B  30         mov   r11,*stack            ; Save return address
0048 75A4 0649  14         dect  stack
0049 75A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 75A8 0649  14         dect  stack
0051 75AA C645  30         mov   tmp1,*stack           ; Push tmp1
0052 75AC 0649  14         dect  stack
0053 75AE C646  30         mov   tmp2,*stack           ; Push tmp2
0054 75B0 0649  14         dect  stack
0055 75B2 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 75B4 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     75B6 A000     
0060               
0061 75B8 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     75BA 3246     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 75BC C120  34         mov   @outparm1,tmp0        ; Index offset
     75BE A010     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 75C0 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     75C2 A002     
0070 75C4 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 75C6 61A0  34         s     @parm1,tmp2           ; Calculate loop
     75C8 A000     
0074 75CA 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 75CC 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     75CE B000     
0081 75D0 04D4  26         clr   *tmp0                 ; Clear index entry
0082 75D2 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 75D4 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     75D6 A002     
0088 75D8 0287  22         ci    tmp3,2048
     75DA 0800     
0089 75DC 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 75DE 06A0  32         bl    @_idx.sams.mapcolumn.on
     75E0 31D8     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 75E2 C120  34         mov   @parm1,tmp0           ; Restore line number
     75E4 A000     
0103 75E6 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 75E8 06A0  32         bl    @_idx.entry.delete.reorg
     75EA 3516     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 75EC 06A0  32         bl    @_idx.sams.mapcolumn.off
     75EE 320C     
0111                                                   ; Restore memory window layout
0112               
0113 75F0 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 75F2 06A0  32         bl    @_idx.entry.delete.reorg
     75F4 3516     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 75F6 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 75F8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 75FA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 75FC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 75FE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 7600 C2F9  30         mov   *stack+,r11           ; Pop r11
0132 7602 045B  20         b     *r11                  ; Return to caller
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
0017 7604 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     7606 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 7608 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 760A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     760C FFCE     
0027 760E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7610 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 7612 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     7614 B000     
0032 7616 C144  18         mov   tmp0,tmp1             ; a = current slot
0033 7618 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 761A 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 761C C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 761E 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 7620 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 7622 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 7624 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     7626 AFFC     
0043 7628 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 762A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     762C FFCE     
0049 762E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7630 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 7632 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 7634 0644  14         dect  tmp0                  ; Move pointer up
0056 7636 0645  14         dect  tmp1                  ; Move pointer up
0057 7638 0606  14         dec   tmp2                  ; Next index entry
0058 763A 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 763C 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 763E 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 7640 045B  20         b     *r11                  ; Return to caller
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
0088 7642 0649  14         dect  stack
0089 7644 C64B  30         mov   r11,*stack            ; Save return address
0090 7646 0649  14         dect  stack
0091 7648 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 764A 0649  14         dect  stack
0093 764C C645  30         mov   tmp1,*stack           ; Push tmp1
0094 764E 0649  14         dect  stack
0095 7650 C646  30         mov   tmp2,*stack           ; Push tmp2
0096 7652 0649  14         dect  stack
0097 7654 C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 7656 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7658 A002     
0102 765A 61A0  34         s     @parm1,tmp2           ; Calculate loop
     765C A000     
0103 765E 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 7660 C1E0  34         mov   @parm2,tmp3
     7662 A002     
0110 7664 0287  22         ci    tmp3,2048
     7666 0800     
0111 7668 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 766A 06A0  32         bl    @_idx.sams.mapcolumn.on
     766C 31D8     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 766E C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7670 A002     
0123 7672 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 7674 06A0  32         bl    @_idx.entry.insert.reorg
     7676 358A     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 7678 06A0  32         bl    @_idx.sams.mapcolumn.off
     767A 320C     
0131                                                   ; Restore memory window layout
0132               
0133 767C 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 767E C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7680 A002     
0139               
0140 7682 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     7684 3246     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 7686 C120  34         mov   @outparm1,tmp0        ; Index offset
     7688 A010     
0145               
0146 768A 06A0  32         bl    @_idx.entry.insert.reorg
     768C 358A     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 768E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 7690 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 7692 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 7694 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 7696 C2F9  30         mov   *stack+,r11           ; Pop r11
0160 7698 045B  20         b     *r11                  ; Return to caller
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
0021 769A 0649  14         dect  stack
0022 769C C64B  30         mov   r11,*stack            ; Push return address
0023 769E 0649  14         dect  stack
0024 76A0 C660  46         mov   @wyx,*stack           ; Push cursor position
     76A2 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 76A4 06A0  32         bl    @hchar
     76A6 27DC     
0029 76A8 0034                   byte 0,52,32,18
     76AA 2012     
0030 76AC FFFF                   data EOL              ; Clear message
0031               
0032 76AE 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     76B0 A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 76B2 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     76B4 832A     
0038 76B6 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 76B8 045B  20         b     *r11                  ; Return to task
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
0033 76BA 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     76BC 003F     
     76BE 0243     
     76C0 05F4     
     76C2 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 76C4 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     76C6 000C     
     76C8 0006     
     76CA 0007     
     76CC 0020     
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
0067 76CE 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     76D0 000C     
     76D2 0006     
     76D4 0007     
     76D6 0020     
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
0087               
0088               romsat:
0089                                                   ; YX, initial shape and color
0090 76D8 0000             data  >0000,>0001           ; Cursor
     76DA 0001     
0091 76DC 0000             data  >0000,>0101           ; Current line indicator     <
     76DE 0101     
0092 76E0 0820             data  >0820,>0201           ; Current column indicator   v
     76E2 0201     
0093               nosprite:
0094 76E4 D000             data  >d000                 ; End-of-Sprites list
0095               
0096               
0097               ***************************************************************
0098               * SAMS page layout table for Stevie (16 words)
0099               *--------------------------------------------------------------
0100               mem.sams.layout.data:
0101 76E6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     76E8 0002     
0102 76EA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     76EC 0003     
0103 76EE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     76F0 000A     
0104 76F2 B000             data  >b000,>0020           ; >b000-bfff, SAMS page >20
     76F4 0020     
0105                                                   ;   Index can allocate
0106                                                   ;   pages >20 to >3f.
0107 76F6 C000             data  >c000,>0040           ; >c000-cfff, SAMS page >40
     76F8 0040     
0108                                                   ;   Editor buffer can allocate
0109                                                   ;   pages >40 to >ff.
0110 76FA D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     76FC 000D     
0111 76FE E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     7700 000E     
0112 7702 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     7704 000F     
0113               
0114               
0115               ***************************************************************
0116               * SAMS page layout table for calling external progam (16 words)
0117               *--------------------------------------------------------------
0118               mem.sams.external:
0119 7706 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7708 0002     
0120 770A 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     770C 0003     
0121 770E A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     7710 000A     
0122 7712 B000             data  >b000,>0030           ; >b000-bfff, SAMS page >30
     7714 0030     
0123 7716 C000             data  >c000,>0031           ; >c000-cfff, SAMS page >31
     7718 0031     
0124 771A D000             data  >d000,>0032           ; >d000-dfff, SAMS page >32
     771C 0032     
0125 771E E000             data  >e000,>0033           ; >e000-efff, SAMS page >33
     7720 0033     
0126 7722 F000             data  >f000,>0034           ; >f000-ffff, SAMS page >34
     7724 0034     
0127               
0128               
0129               ***************************************************************
0130               * SAMS page layout table for TI Basic (16 words)
0131               *--------------------------------------------------------------
0132               mem.sams.tibasic:
0133 7726 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7728 0002     
0134 772A 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     772C 0003     
0135 772E A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     7730 000A     
0136 7732 B000             data  >b000,>0004           ; >b000-bfff, SAMS page >04
     7734 0004     
0137 7736 C000             data  >c000,>0005           ; >c000-cfff, SAMS page >05
     7738 0005     
0138 773A D000             data  >d000,>0006           ; >d000-dfff, SAMS page >06
     773C 0006     
0139 773E E000             data  >e000,>0007           ; >e000-efff, SAMS page >07
     7740 0007     
0140 7742 F000             data  >f000,>0008           ; >f000-ffff, SAMS page >08
     7744 0008     
0141               
0142               
0143               
0144               ***************************************************************
0145               * Stevie color schemes table
0146               *--------------------------------------------------------------
0147               * Word 1
0148               * A  MSB  high-nibble    Foreground color text line in frame buffer
0149               * B  MSB  low-nibble     Background color text line in frame buffer
0150               * C  LSB  high-nibble    Foreground color top/bottom line
0151               * D  LSB  low-nibble     Background color top/bottom line
0152               *
0153               * Word 2
0154               * E  MSB  high-nibble    Foreground color cmdb pane
0155               * F  MSB  low-nibble     Background color cmdb pane
0156               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0157               * H  LSB  low-nibble     Cursor foreground color frame buffer
0158               *
0159               * Word 3
0160               * I  MSB  high-nibble    Foreground color busy top/bottom line
0161               * J  MSB  low-nibble     Background color busy top/bottom line
0162               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0163               * L  LSB  low-nibble     Background color marked line in frame buffer
0164               *
0165               * Word 4
0166               * M  MSB  high-nibble    Foreground color command buffer header line
0167               * N  MSB  low-nibble     Background color command buffer header line
0168               * O  LSB  high-nibble    Foreground color line+column indicator frame buffer
0169               * P  LSB  low-nibble     Foreground color ruler frame buffer
0170               *
0171               * Colors
0172               * 0  Transparant
0173               * 1  black
0174               * 2  Green
0175               * 3  Light Green
0176               * 4  Blue
0177               * 5  Light Blue
0178               * 6  Dark Red
0179               * 7  Cyan
0180               * 8  Red
0181               * 9  Light Red
0182               * A  Yellow
0183               * B  Light Yellow
0184               * C  Dark Green
0185               * D  Magenta
0186               * E  Grey
0187               * F  White
0188               *--------------------------------------------------------------
0189      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0190               
0191               tv.colorscheme.table:
0192                       ;                             ; #
0193                       ;      ABCD  EFGH  IJKL  MNOP ; -
0194 7746 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     7748 F171     
     774A 1B1F     
     774C 71B1     
0195 774E A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     7750 F0FF     
     7752 1F1A     
     7754 F1FF     
0196 7756 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     7758 F0FF     
     775A 1F12     
     775C F1F6     
0197 775E F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     7760 1E11     
     7762 1A17     
     7764 1E11     
0198 7766 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     7768 E1FF     
     776A 1F1E     
     776C E1FF     
0199 776E 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     7770 1016     
     7772 1B71     
     7774 1711     
0200 7776 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     7778 1011     
     777A F1F1     
     777C 1F11     
0201 777E 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     7780 A1FF     
     7782 1F1F     
     7784 F11F     
0202 7786 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     7788 12FF     
     778A 1B12     
     778C 12FF     
0203 778E F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     7790 E1FF     
     7792 1B1F     
     7794 F131     
0204                       even
0205               
0206               tv.tabs.table:
0207 7796 0007             byte  0,7,12,25               ; \   Default tab positions as used
     7798 0C19     
0208 779A 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     779C 3B4F     
0209 779E FF00             byte  >ff,0,0,0               ; |
     77A0 0000     
0210 77A2 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     77A4 0000     
0211 77A6 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     77A8 0000     
0212                       even
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
0009 77AA 01               byte  1
0010 77AB   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 77AC 05               byte  5
0015 77AD   20             text  '  BOT'
     77AE 2042     
     77B0 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 77B2 03               byte  3
0020 77B3   4F             text  'OVR'
     77B4 5652     
0021                       even
0022               
0023               txt.insert
0024 77B6 03               byte  3
0025 77B7   49             text  'INS'
     77B8 4E53     
0026                       even
0027               
0028               txt.star
0029 77BA 01               byte  1
0030 77BB   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 77BC 0A               byte  10
0035 77BD   4C             text  'Loading...'
     77BE 6F61     
     77C0 6469     
     77C2 6E67     
     77C4 2E2E     
     77C6 2E       
0036                       even
0037               
0038               txt.saving
0039 77C8 0A               byte  10
0040 77C9   53             text  'Saving....'
     77CA 6176     
     77CC 696E     
     77CE 672E     
     77D0 2E2E     
     77D2 2E       
0041                       even
0042               
0043               txt.printing
0044 77D4 12               byte  18
0045 77D5   50             text  'Printing file.....'
     77D6 7269     
     77D8 6E74     
     77DA 696E     
     77DC 6720     
     77DE 6669     
     77E0 6C65     
     77E2 2E2E     
     77E4 2E2E     
     77E6 2E       
0046                       even
0047               
0048               txt.block.del
0049 77E8 12               byte  18
0050 77E9   44             text  'Deleting block....'
     77EA 656C     
     77EC 6574     
     77EE 696E     
     77F0 6720     
     77F2 626C     
     77F4 6F63     
     77F6 6B2E     
     77F8 2E2E     
     77FA 2E       
0051                       even
0052               
0053               txt.block.copy
0054 77FC 11               byte  17
0055 77FD   43             text  'Copying block....'
     77FE 6F70     
     7800 7969     
     7802 6E67     
     7804 2062     
     7806 6C6F     
     7808 636B     
     780A 2E2E     
     780C 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 780E 10               byte  16
0060 780F   4D             text  'Moving block....'
     7810 6F76     
     7812 696E     
     7814 6720     
     7816 626C     
     7818 6F63     
     781A 6B2E     
     781C 2E2E     
     781E 2E       
0061                       even
0062               
0063               txt.block.save
0064 7820 18               byte  24
0065 7821   53             text  'Saving block to file....'
     7822 6176     
     7824 696E     
     7826 6720     
     7828 626C     
     782A 6F63     
     782C 6B20     
     782E 746F     
     7830 2066     
     7832 696C     
     7834 652E     
     7836 2E2E     
     7838 2E       
0066                       even
0067               
0068               txt.block.clip
0069 783A 18               byte  24
0070 783B   43             text  'Copying to clipboard....'
     783C 6F70     
     783E 7969     
     7840 6E67     
     7842 2074     
     7844 6F20     
     7846 636C     
     7848 6970     
     784A 626F     
     784C 6172     
     784E 642E     
     7850 2E2E     
     7852 2E       
0071                       even
0072               
0073               txt.block.print
0074 7854 12               byte  18
0075 7855   50             text  'Printing block....'
     7856 7269     
     7858 6E74     
     785A 696E     
     785C 6720     
     785E 626C     
     7860 6F63     
     7862 6B2E     
     7864 2E2E     
     7866 2E       
0076                       even
0077               
0078               txt.clearmem
0079 7868 13               byte  19
0080 7869   43             text  'Clearing memory....'
     786A 6C65     
     786C 6172     
     786E 696E     
     7870 6720     
     7872 6D65     
     7874 6D6F     
     7876 7279     
     7878 2E2E     
     787A 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 787C 0E               byte  14
0085 787D   4C             text  'Load completed'
     787E 6F61     
     7880 6420     
     7882 636F     
     7884 6D70     
     7886 6C65     
     7888 7465     
     788A 64       
0086                       even
0087               
0088               txt.done.insert
0089 788C 10               byte  16
0090 788D   49             text  'Insert completed'
     788E 6E73     
     7890 6572     
     7892 7420     
     7894 636F     
     7896 6D70     
     7898 6C65     
     789A 7465     
     789C 64       
0091                       even
0092               
0093               txt.done.save
0094 789E 0E               byte  14
0095 789F   53             text  'Save completed'
     78A0 6176     
     78A2 6520     
     78A4 636F     
     78A6 6D70     
     78A8 6C65     
     78AA 7465     
     78AC 64       
0096                       even
0097               
0098               txt.done.copy
0099 78AE 0E               byte  14
0100 78AF   43             text  'Copy completed'
     78B0 6F70     
     78B2 7920     
     78B4 636F     
     78B6 6D70     
     78B8 6C65     
     78BA 7465     
     78BC 64       
0101                       even
0102               
0103               txt.done.print
0104 78BE 0F               byte  15
0105 78BF   50             text  'Print completed'
     78C0 7269     
     78C2 6E74     
     78C4 2063     
     78C6 6F6D     
     78C8 706C     
     78CA 6574     
     78CC 6564     
0106                       even
0107               
0108               txt.done.delete
0109 78CE 10               byte  16
0110 78CF   44             text  'Delete completed'
     78D0 656C     
     78D2 6574     
     78D4 6520     
     78D6 636F     
     78D8 6D70     
     78DA 6C65     
     78DC 7465     
     78DE 64       
0111                       even
0112               
0113               txt.done.clipboard
0114 78E0 0F               byte  15
0115 78E1   43             text  'Clipboard saved'
     78E2 6C69     
     78E4 7062     
     78E6 6F61     
     78E8 7264     
     78EA 2073     
     78EC 6176     
     78EE 6564     
0116                       even
0117               
0118               txt.done.clipdev
0119 78F0 0D               byte  13
0120 78F1   43             text  'Clipboard set'
     78F2 6C69     
     78F4 7062     
     78F6 6F61     
     78F8 7264     
     78FA 2073     
     78FC 6574     
0121                       even
0122               
0123               txt.fastmode
0124 78FE 08               byte  8
0125 78FF   46             text  'Fastmode'
     7900 6173     
     7902 746D     
     7904 6F64     
     7906 65       
0126                       even
0127               
0128               txt.kb
0129 7908 02               byte  2
0130 7909   6B             text  'kb'
     790A 62       
0131                       even
0132               
0133               txt.lines
0134 790C 05               byte  5
0135 790D   4C             text  'Lines'
     790E 696E     
     7910 6573     
0136                       even
0137               
0138               txt.newfile
0139 7912 0A               byte  10
0140 7913   5B             text  '[New file]'
     7914 4E65     
     7916 7720     
     7918 6669     
     791A 6C65     
     791C 5D       
0141                       even
0142               
0143               txt.filetype.dv80
0144 791E 04               byte  4
0145 791F   44             text  'DV80'
     7920 5638     
     7922 30       
0146                       even
0147               
0148               txt.m1
0149 7924 03               byte  3
0150 7925   4D             text  'M1='
     7926 313D     
0151                       even
0152               
0153               txt.m2
0154 7928 03               byte  3
0155 7929   4D             text  'M2='
     792A 323D     
0156                       even
0157               
0158               txt.keys.default
0159 792C 07               byte  7
0160 792D   46             text  'F9-Menu'
     792E 392D     
     7930 4D65     
     7932 6E75     
0161                       even
0162               
0163               txt.keys.block
0164 7934 36               byte  54
0165 7935   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     7936 392D     
     7938 4261     
     793A 636B     
     793C 2020     
     793E 5E43     
     7940 6F70     
     7942 7920     
     7944 205E     
     7946 4D6F     
     7948 7665     
     794A 2020     
     794C 5E44     
     794E 656C     
     7950 2020     
     7952 5E53     
     7954 6176     
     7956 6520     
     7958 205E     
     795A 5072     
     795C 696E     
     795E 7420     
     7960 205E     
     7962 5B31     
     7964 2D35     
     7966 5D43     
     7968 6C69     
     796A 70       
0166                       even
0167               
0168 796C 2E2E     txt.ruler          text    '.........'
     796E 2E2E     
     7970 2E2E     
     7972 2E2E     
     7974 2E       
0169 7975   12                        byte    18
0170 7976 2E2E                        text    '.........'
     7978 2E2E     
     797A 2E2E     
     797C 2E2E     
     797E 2E       
0171 797F   13                        byte    19
0172 7980 2E2E                        text    '.........'
     7982 2E2E     
     7984 2E2E     
     7986 2E2E     
     7988 2E       
0173 7989   14                        byte    20
0174 798A 2E2E                        text    '.........'
     798C 2E2E     
     798E 2E2E     
     7990 2E2E     
     7992 2E       
0175 7993   15                        byte    21
0176 7994 2E2E                        text    '.........'
     7996 2E2E     
     7998 2E2E     
     799A 2E2E     
     799C 2E       
0177 799D   16                        byte    22
0178 799E 2E2E                        text    '.........'
     79A0 2E2E     
     79A2 2E2E     
     79A4 2E2E     
     79A6 2E       
0179 79A7   17                        byte    23
0180 79A8 2E2E                        text    '.........'
     79AA 2E2E     
     79AC 2E2E     
     79AE 2E2E     
     79B0 2E       
0181 79B1   18                        byte    24
0182 79B2 2E2E                        text    '.........'
     79B4 2E2E     
     79B6 2E2E     
     79B8 2E2E     
     79BA 2E       
0183 79BB   19                        byte    25
0184                                  even
0185 79BC 020E     txt.alpha.down     data >020e,>0f00
     79BE 0F00     
0186 79C0 0110     txt.vertline       data >0110
0187 79C2 011C     txt.keymarker      byte 1,28
0188               
0189               txt.ws1
0190 79C4 01               byte  1
0191 79C5   20             text  ' '
0192                       even
0193               
0194               txt.ws2
0195 79C6 02               byte  2
0196 79C7   20             text  '  '
     79C8 20       
0197                       even
0198               
0199               txt.ws3
0200 79CA 03               byte  3
0201 79CB   20             text  '   '
     79CC 2020     
0202                       even
0203               
0204               txt.ws4
0205 79CE 04               byte  4
0206 79CF   20             text  '    '
     79D0 2020     
     79D2 20       
0207                       even
0208               
0209               txt.ws5
0210 79D4 05               byte  5
0211 79D5   20             text  '     '
     79D6 2020     
     79D8 2020     
0212                       even
0213               
0214      3954     txt.filetype.none  equ txt.ws4
0215               
0216               
0217               ;--------------------------------------------------------------
0218               ; Strings for error line pane
0219               ;--------------------------------------------------------------
0220               txt.ioerr.load
0221 79DA 15               byte  21
0222 79DB   46             text  'Failed loading file: '
     79DC 6169     
     79DE 6C65     
     79E0 6420     
     79E2 6C6F     
     79E4 6164     
     79E6 696E     
     79E8 6720     
     79EA 6669     
     79EC 6C65     
     79EE 3A20     
0223                       even
0224               
0225               txt.ioerr.save
0226 79F0 14               byte  20
0227 79F1   46             text  'Failed saving file: '
     79F2 6169     
     79F4 6C65     
     79F6 6420     
     79F8 7361     
     79FA 7669     
     79FC 6E67     
     79FE 2066     
     7A00 696C     
     7A02 653A     
     7A04 20       
0228                       even
0229               
0230               txt.ioerr.print
0231 7A06 1B               byte  27
0232 7A07   46             text  'Failed printing to device: '
     7A08 6169     
     7A0A 6C65     
     7A0C 6420     
     7A0E 7072     
     7A10 696E     
     7A12 7469     
     7A14 6E67     
     7A16 2074     
     7A18 6F20     
     7A1A 6465     
     7A1C 7669     
     7A1E 6365     
     7A20 3A20     
0233                       even
0234               
0235               txt.io.nofile
0236 7A22 16               byte  22
0237 7A23   4E             text  'No filename specified.'
     7A24 6F20     
     7A26 6669     
     7A28 6C65     
     7A2A 6E61     
     7A2C 6D65     
     7A2E 2073     
     7A30 7065     
     7A32 6369     
     7A34 6669     
     7A36 6564     
     7A38 2E       
0238                       even
0239               
0240               txt.memfull.load
0241 7A3A 2D               byte  45
0242 7A3B   49             text  'Index full. File too large for editor buffer.'
     7A3C 6E64     
     7A3E 6578     
     7A40 2066     
     7A42 756C     
     7A44 6C2E     
     7A46 2046     
     7A48 696C     
     7A4A 6520     
     7A4C 746F     
     7A4E 6F20     
     7A50 6C61     
     7A52 7267     
     7A54 6520     
     7A56 666F     
     7A58 7220     
     7A5A 6564     
     7A5C 6974     
     7A5E 6F72     
     7A60 2062     
     7A62 7566     
     7A64 6665     
     7A66 722E     
0243                       even
0244               
0245               txt.block.inside
0246 7A68 2D               byte  45
0247 7A69   43             text  'Copy/Move target must be outside M1-M2 range.'
     7A6A 6F70     
     7A6C 792F     
     7A6E 4D6F     
     7A70 7665     
     7A72 2074     
     7A74 6172     
     7A76 6765     
     7A78 7420     
     7A7A 6D75     
     7A7C 7374     
     7A7E 2062     
     7A80 6520     
     7A82 6F75     
     7A84 7473     
     7A86 6964     
     7A88 6520     
     7A8A 4D31     
     7A8C 2D4D     
     7A8E 3220     
     7A90 7261     
     7A92 6E67     
     7A94 652E     
0248                       even
0249               
0250               
0251               ;--------------------------------------------------------------
0252               ; Strings for command buffer
0253               ;--------------------------------------------------------------
0254               txt.cmdb.prompt
0255 7A96 01               byte  1
0256 7A97   3E             text  '>'
0257                       even
0258               
0259               txt.colorscheme
0260 7A98 0D               byte  13
0261 7A99   43             text  'Color scheme:'
     7A9A 6F6C     
     7A9C 6F72     
     7A9E 2073     
     7AA0 6368     
     7AA2 656D     
     7AA4 653A     
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
0008 7AA6 06               byte  6
0009 7AA7   50             text  'PI.PIO'
     7AA8 492E     
     7AAA 5049     
     7AAC 4F       
0010                       even
0011               
0012               def.clip.fname
0013 7AAE 09               byte  9
0014 7AAF   44             text  'DSK1.CLIP'
     7AB0 534B     
     7AB2 312E     
     7AB4 434C     
     7AB6 4950     
0015                       even
0016               
                   < ram.resident.asm
                   < stevie_b0.asm.103101
0088                       ;------------------------------------------------------
0089                       ; Activate bank 1 and branch to >6046
0090                       ;------------------------------------------------------
0091               main:
0092 7AB8 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     7ABA 6002     
0093               
0097               
0098 7ABC 0460  28         b     @kickstart.code2      ; Jump to entry routine
     7ABE 6046     
0099                       ;------------------------------------------------------
0100                       ; Memory full check
0101                       ;------------------------------------------------------
0103               
0107 7AC0 3A46                   data $                ; Bank 0 ROM size OK.
0109                       ;-----------------------------------------------------------------------
0110                       ; Show bank in CPU crash screen
0111                       ;-----------------------------------------------------------------------
0112               cpu.crash.showbank:
0113                       aorg >7fb0
0114 7FB0 06A0  32         bl    @putat
     7FB2 2456     
0115 7FB4 0314                   byte 3,20
0116 7FB6 7FBA                   data cpu.crash.showbank.bankstr
0117 7FB8 10FF  14         jmp   $
0118               cpu.crash.showbank.bankstr:
0119               
0120 7FBA 05               byte  5
0121 7FBB   52             text  'ROM#0'
     7FBC 4F4D     
     7FBE 2330     
0122                       even
0123               
0124               *--------------------------------------------------------------
0125               * Video mode configuration for SP2
0126               *--------------------------------------------------------------
0127      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0128      0004     spfbck  equ   >04                   ; Screen background color.
0129      3640     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0130      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0131      0050     colrow  equ   80                    ; Columns per row
0132      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0133      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0134      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0135      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
0136               

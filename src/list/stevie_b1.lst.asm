XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b1.asm.31063
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2022 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 220105-1702330
0010               *
0011               * Bank 1 "James"
0012               * Editor core
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
0030               * classic99 and JS99er emulators are mutually exclusive.
0031               * At the time of writing JS99er has full F18a compatibility.
0032               *
0033               * If build target is the JS99er emulator or an F18a equiped TI-99/4a
0034               * then set the 'full_f18a_support' equate to 1.
0035               *
0036               * When targetting the classic99 emulator then set the
0037               * 'full_f18a_support' equate to 0.
0038               * This will build  the trimmed down version with 24x80 resolution.
0039               *--------------------------------------------------------------
0040      0001     full_f18a_support         equ  1       ; 30 rows mode with sprites
0041               
0042               
0043               *--------------------------------------------------------------
0044               * JS99er F18a 30x80, no FG99 advanced mode
0045               *--------------------------------------------------------------
0047      0001     device.f18a               equ  1       ; F18a GPU
0048      0000     device.9938               equ  0       ; 9938 GPU
0049      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode off
0051               
0052               
0053               
0054               *--------------------------------------------------------------
0055               * Classic99 F18a 24x80, no FG99 advanced mode
0056               *--------------------------------------------------------------
                   < stevie_b1.asm.31063
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
                   < stevie_b1.asm.31063
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
0105               * Stevie specific equates
0106               *--------------------------------------------------------------
0107      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0108      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0109      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0110      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0111      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0112      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0113                                                      ; VDP TAT address of 1st CMDB row
0114      0000     vdp.sit.base              equ  >0000   ; VDP SIT base address
0115      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0116                                                      ; VDP SIT size 80 columns, 24/30 rows
0117      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0118      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0119      00FE     tv.1timeonly              equ  254     ; One-time only flag indicator
0120               *--------------------------------------------------------------
0121               * Suffix characters for clipboards
0122               *--------------------------------------------------------------
0123      3100     clip1                     equ  >3100   ; '1'
0124      3200     clip2                     equ  >3200   ; '2'
0125      3300     clip3                     equ  >3300   ; '3'
0126      3400     clip4                     equ  >3400   ; '4'
0127      3500     clip5                     equ  >3500   ; '5'
0128               *--------------------------------------------------------------
0129               * File work mode
0130               *--------------------------------------------------------------
0131      0001     id.file.loadfile          equ  1       ; Load file
0132      0002     id.file.insertfile        equ  2       ; Insert file
0133      0003     id.file.appendfile        equ  3       ; Append file
0134      0004     id.file.savefile          equ  4       ; Save file
0135      0005     id.file.saveblock         equ  5       ; Save block to file
0136      0006     id.file.clipblock         equ  6       ; Save block to clipboard
0137      0007     id.file.printfile         equ  7       ; Print file
0138      0008     id.file.printblock        equ  8       ; Print block
0139               *--------------------------------------------------------------
0140               * SPECTRA2 / Stevie startup options
0141               *--------------------------------------------------------------
0142      0001     debug                     equ  1       ; Turn on spectra2 debugging
0143      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0144      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0145      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0146               *--------------------------------------------------------------
0147               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0148               *--------------------------------------------------------------
0149      A000     core1.top         equ  >a000           ; Structure begin
0150      A000     parm1             equ  core1.top + 0   ; Function parameter 1
0151      A002     parm2             equ  core1.top + 2   ; Function parameter 2
0152      A004     parm3             equ  core1.top + 4   ; Function parameter 3
0153      A006     parm4             equ  core1.top + 6   ; Function parameter 4
0154      A008     parm5             equ  core1.top + 8   ; Function parameter 5
0155      A00A     parm6             equ  core1.top + 10  ; Function parameter 6
0156      A00C     parm7             equ  core1.top + 12  ; Function parameter 7
0157      A00E     parm8             equ  core1.top + 14  ; Function parameter 8
0158      A010     outparm1          equ  core1.top + 16  ; Function output parameter 1
0159      A012     outparm2          equ  core1.top + 18  ; Function output parameter 2
0160      A014     outparm3          equ  core1.top + 20  ; Function output parameter 3
0161      A016     outparm4          equ  core1.top + 22  ; Function output parameter 4
0162      A018     outparm5          equ  core1.top + 24  ; Function output parameter 5
0163      A01A     outparm6          equ  core1.top + 26  ; Function output parameter 6
0164      A01C     outparm7          equ  core1.top + 28  ; Function output parameter 7
0165      A01E     outparm8          equ  core1.top + 30  ; Function output parameter 8
0166      A020     keyrptcnt         equ  core1.top + 32  ; Key repeat-count (auto-repeat function)
0167      A022     keycode1          equ  core1.top + 34  ; Current key scanned
0168      A024     keycode2          equ  core1.top + 36  ; Previous key scanned
0169      A026     unpacked.string   equ  core1.top + 38  ; 6 char string with unpacked uin16
0170      A02C     tibasic.hidesid   equ  core1.top + 44  ; Hide TI-Basic session ID
0171      A02E     tibasic.session   equ  core1.top + 46  ; Active TI-Basic session (1-5)
0172      A030     tibasic1.status   equ  core1.top + 48  ; TI Basic session 1
0173      A032     tibasic2.status   equ  core1.top + 50  ; TI Basic session 2
0174      A034     tibasic3.status   equ  core1.top + 52  ; TI Basic session 3
0175      A036     tibasic4.status   equ  core1.top + 54  ; TI Basic session 4
0176      A038     tibasic5.status   equ  core1.top + 56  ; TI Basic session 5
0177      A03A     trmpvector        equ  core1.top + 58  ; Vector trampoline (if p1|tmp1 = >ffff)
0178      A03C     ramsat            equ  core1.top + 60  ; Sprite Attr. Table in RAM (14 bytes)
0179      A04A     timers            equ  core1.top + 74  ; Timers (80 bytes)
0180      A09A     core1.free        equ  core1.top + 154 ; End of structure
0181               *--------------------------------------------------------------
0182               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0183               *--------------------------------------------------------------
0184      A100     core2.top         equ  >a100           ; Structure begin
0185      A100     rambuf            equ  core2.top       ; RAM workbuffer
0186      A200     core2.free        equ  core2.top + 256 ; End of structure
0187               *--------------------------------------------------------------
0188               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0189               *--------------------------------------------------------------
0190      A200     tv.top            equ  >a200           ; Structure begin
0191      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0192      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0193      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0194      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0195      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0196      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0197      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0198      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0199      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0200      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0201      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0202      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0203      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0204      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0205      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0206      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0207      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0208      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0209      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0210      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0211      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0212      A22A     tv.error.rows     equ  tv.top + 42     ; Number of rows in error pane
0213      A22C     tv.sp2.conf       equ  tv.top + 44     ; Backup of SP2 config register
0214      A22E     tv.error.msg      equ  tv.top + 46     ; Error message (max. 160 characters)
0215      A2CE     tv.free           equ  tv.top + 206    ; End of structure
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
0344      A7AC     cmdb.dflt.fname   equ  cmdb.struct +172; Default for filename
0345      A800     cmdb.free         equ  cmdb.struct +256; End of structure
0346               *--------------------------------------------------------------
0347               * Stevie value stack                  @>a800-a8ff   (256 bytes)
0348               *--------------------------------------------------------------
0349      A900     sp2.stktop        equ  >a900           ; \ SP2 stack >a800 - >a8ff
0350                                                      ; | The stack grows from high memory
0351                                                      ; / to low memory.
0352               *--------------------------------------------------------------
0353               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0354               *--------------------------------------------------------------
0355      7E00     cpu.scrpad.src    equ  >7e00           ; \ Dump of OS monitor scratchpad
0356                                                      ; / stored in cartridge ROM bank7.asm
0357               
0358      F960     cpu.scrpad.tgt    equ  >f960           ; \ Target copy of OS monitor scratchpad
0359                                                      ; | in high-memory.
0360                                                      ; /
0361               
0362      AD00     cpu.scrpad.moved  equ  >ad00           ; Stevie scratchpad memory when paged-out
0363                                                      ; because of TI Basic/External program
0364               *--------------------------------------------------------------
0365               * Farjump return stack                @>af00-afff   (256 bytes)
0366               *--------------------------------------------------------------
0367      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0368                                                      ; Grows downwards from high to low.
0369               *--------------------------------------------------------------
0370               * Index                               @>b000-bfff  (4096 bytes)
0371               *--------------------------------------------------------------
0372      B000     idx.top           equ  >b000           ; Top of index
0373      1000     idx.size          equ  4096            ; Index size
0374               *--------------------------------------------------------------
0375               * Editor buffer                       @>c000-cfff  (4096 bytes)
0376               *--------------------------------------------------------------
0377      C000     edb.top           equ  >c000           ; Editor buffer high memory
0378      1000     edb.size          equ  4096            ; Editor buffer size
0379               *--------------------------------------------------------------
0380               * Frame buffer & Default devices      @>d000-dfff  (4096 bytes)
0381               *--------------------------------------------------------------
0382      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0383      0960     fb.size           equ  80*30           ; Frame buffer size
0384      D960     tv.printer.fname  equ  >d960           ; Default printer   (80 char)
0385      D9B0     tv.clip.fname     equ  >d9b0           ; Default clipboard (80 char)
0386               *--------------------------------------------------------------
0387               * Command buffer history              @>e000-efff  (4096 bytes)
0388               *--------------------------------------------------------------
0389      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0390      1000     cmdb.size         equ  4096            ; Command buffer size
0391               *--------------------------------------------------------------
0392               * Heap                                @>f000-ffff  (4096 bytes)
0393               *--------------------------------------------------------------
0394      F000     heap.top          equ  >f000           ; Top of heap
                   < stevie_b1.asm.31063
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
                   < stevie_b1.asm.31063
0018               
0019               ***************************************************************
0020               * BANK 1
0021               ********|*****|*********************|**************************
0022      6002     bankid  equ   bank1.rom             ; Set bank identifier to current bank
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
0045 6011   53             text  'STEVIE 1.2N'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 324E     
0046                       even
0047               
0049               
                   < stevie_b1.asm.31063
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
0050               * ==  Keyboard
0051               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0052               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0053               *
0054               * == Utilities
0055               * skip_random_generator     equ  1  ; Skip random generator functions
0056               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0057               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0058               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0059               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0060               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0061               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0062               * skip_cpu_strings          equ  1  ; Skip string support utilities
0063               
0064               * == Kernel/Multitasking
0065               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0066               * skip_mem_paging           equ  1  ; Skip support for memory paging
0067               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0068               *
0069               * == Startup behaviour
0070               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300->83ff
0071               *                                   ; to pre-defined backup address
0072               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0073               *******************************************************************************
0074               
0075               *//////////////////////////////////////////////////////////////
0076               *                       RUNLIB SETUP
0077               *//////////////////////////////////////////////////////////////
0078               
0079                       copy  "memsetup.equ"             ; Equates runlib scratchpad mem setup
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
0080                       copy  "registers.equ"            ; Equates runlib registers
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
0081                       copy  "portaddr.equ"             ; Equates runlib hw port addresses
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
0082                       copy  "param.equ"                ; Equates runlib parameters
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
0083               
0087               
0088                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
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
0089                       copy  "config.equ"               ; Equates for bits in config register
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
0090                       copy  "cpu_crash.asm"            ; CPU crash handler
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
     2084 2FDE     
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
     20B2 2AAA     
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
     20C6 2AAA     
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
     2116 2AB4     
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
     214A 2AB4     
0186 214C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0187 214E A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0188 2150 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0189                                                   ; /         LSB offset for ASCII digit 0-9
0190                       ;------------------------------------------------------
0191                       ; Display crash register content
0192                       ;------------------------------------------------------
0193               cpu.crash.showreg.content:
0194 2152 06A0  32         bl    @mkhex                ; Convert hex word to string
     2154 2A26     
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
0265 21D1   53             text  'Source    stevie_b1.lst.asm'
     21D2 6F75     
     21D4 7263     
     21D6 6520     
     21D8 2020     
     21DA 2073     
     21DC 7465     
     21DE 7669     
     21E0 655F     
     21E2 6231     
     21E4 2E6C     
     21E6 7374     
     21E8 2E61     
     21EA 736D     
0266                       even
0267               
0268               cpu.crash.msg.id
0269 21EC 18               byte  24
0270 21ED   42             text  'Build-ID  220105-1702330'
     21EE 7569     
     21F0 6C64     
     21F2 2D49     
     21F4 4420     
     21F6 2032     
     21F8 3230     
     21FA 3130     
     21FC 352D     
     21FE 3137     
     2200 3032     
     2202 3333     
     2204 30       
0271                       even
0272               
                   < runlib.asm
0091                       copy  "vdp_tables.asm"           ; Data used by runtime library
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
0092                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0093               
0095                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0097               
0099                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0101               
0103                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0105               
0109               
0113               
0115                       copy  "cpu_sams.asm"             ; Support for SAMS memory card
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
0117               
0121               
0123                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
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
0125               
0127                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0129               
0131                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0133               
0135                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
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
0137               
0141               
0145               
0147                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
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
0149               
0151                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0153               
0157               
0161               
0165               
0167                       copy  "snd_player.asm"           ; Sound player
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
0169               
0173               
0177               
0181               
0183                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 28CA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     28CC 2020     
0017 28CE 020C  20         li    r12,>0024
     28D0 0024     
0018 28D2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     28D4 2966     
0019 28D6 04C6  14         clr   tmp2
0020 28D8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 28DA 04CC  14         clr   r12
0025 28DC 1F08  20         tb    >0008                 ; Shift-key ?
0026 28DE 1302  14         jeq   realk1                ; No
0027 28E0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     28E2 2996     
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 28E4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 28E6 1302  14         jeq   realk2                ; No
0033 28E8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     28EA 29C6     
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 28EC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 28EE 1302  14         jeq   realk3                ; No
0039 28F0 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     28F2 29F6     
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 28F4 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     28F6 200C     
0044 28F8 1E15  20         sbz   >0015                 ; Set P5
0045 28FA 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 28FC 1302  14         jeq   realk4                ; No
0047 28FE E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     2900 200C     
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 2902 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 2904 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     2906 0006     
0053 2908 0606  14 realk5  dec   tmp2
0054 290A 020C  20         li    r12,>24               ; CRU address for P2-P4
     290C 0024     
0055 290E 06C6  14         swpb  tmp2
0056 2910 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2912 06C6  14         swpb  tmp2
0058 2914 020C  20         li    r12,6                 ; CRU read address
     2916 0006     
0059 2918 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 291A 0547  14         inv   tmp3                  ;
0061 291C 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     291E FF00     
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2920 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2922 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2924 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 2926 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 2928 0285  22         ci    tmp1,8
     292A 0008     
0070 292C 1AFA  14         jl    realk6
0071 292E C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2930 1BEB  14         jh    realk5                ; No, next column
0073 2932 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2934 C206  18 realk8  mov   tmp2,tmp4
0078 2936 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 2938 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 293A A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 293C D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 293E 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2940 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2942 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2944 200C     
0089 2946 1608  14         jne   realka                ; No, continue saving key
0090 2948 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     294A 2990     
0091 294C 1A05  14         jl    realka
0092 294E 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2950 298E     
0093 2952 1B02  14         jh    realka                ; No, continue
0094 2954 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     2956 E000     
0095 2958 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     295A 833C     
0096 295C E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     295E 200A     
0097 2960 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2962 8C00     
0098                                                   ; / using R15 as temp storage
0099 2964 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 2966 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2968 0000     
     296A FF0D     
     296C 203D     
0102 296E 7877             text  'xws29ol.'
     2970 7332     
     2972 396F     
     2974 6C2E     
0103 2976 6365             text  'ced38ik,'
     2978 6433     
     297A 3869     
     297C 6B2C     
0104 297E 7672             text  'vrf47ujm'
     2980 6634     
     2982 3775     
     2984 6A6D     
0105 2986 6274             text  'btg56yhn'
     2988 6735     
     298A 3679     
     298C 686E     
0106 298E 7A71             text  'zqa10p;/'
     2990 6131     
     2992 3070     
     2994 3B2F     
0107 2996 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2998 0000     
     299A FF0D     
     299C 202B     
0108 299E 5857             text  'XWS@(OL>'
     29A0 5340     
     29A2 284F     
     29A4 4C3E     
0109 29A6 4345             text  'CED#*IK<'
     29A8 4423     
     29AA 2A49     
     29AC 4B3C     
0110 29AE 5652             text  'VRF$&UJM'
     29B0 4624     
     29B2 2655     
     29B4 4A4D     
0111 29B6 4254             text  'BTG%^YHN'
     29B8 4725     
     29BA 5E59     
     29BC 484E     
0112 29BE 5A51             text  'ZQA!)P:-'
     29C0 4121     
     29C2 2950     
     29C4 3A2D     
0113 29C6 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     29C8 0000     
     29CA FF0D     
     29CC 2005     
0114 29CE 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     29D0 0804     
     29D2 0F27     
     29D4 C2B9     
0115 29D6 600B             data  >600b,>0907,>063f,>c1B8
     29D8 0907     
     29DA 063F     
     29DC C1B8     
0116 29DE 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     29E0 7B02     
     29E2 015F     
     29E4 C0C3     
0117 29E6 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     29E8 7D0E     
     29EA 0CC6     
     29EC BFC4     
0118 29EE 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     29F0 7C03     
     29F2 BC22     
     29F4 BDBA     
0119 29F6 FF00     kbctrl  data  >ff00,>0000,>ff0d,>f09D
     29F8 0000     
     29FA FF0D     
     29FC F09D     
0120 29FE 9897             data  >9897,>93b2,>9f8f,>8c9B
     2A00 93B2     
     2A02 9F8F     
     2A04 8C9B     
0121 2A06 8385             data  >8385,>84b3,>9e89,>8b80
     2A08 84B3     
     2A0A 9E89     
     2A0C 8B80     
0122 2A0E 9692             data  >9692,>86b4,>b795,>8a8D
     2A10 86B4     
     2A12 B795     
     2A14 8A8D     
0123 2A16 8294             data  >8294,>87b5,>b698,>888E
     2A18 87B5     
     2A1A B698     
     2A1C 888E     
0124 2A1E 9A91             data  >9a91,>81b1,>b090,>9cBB
     2A20 81B1     
     2A22 B090     
     2A24 9CBB     
                   < runlib.asm
0185               
0187                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0023 2A26 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2A28 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2A2A 8340     
0025 2A2C 04E0  34         clr   @waux1
     2A2E 833C     
0026 2A30 04E0  34         clr   @waux2
     2A32 833E     
0027 2A34 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2A36 833C     
0028 2A38 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2A3A 0205  20         li    tmp1,4                ; 4 nibbles
     2A3C 0004     
0033 2A3E C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2A40 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2A42 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2A44 0286  22         ci    tmp2,>000a
     2A46 000A     
0039 2A48 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2A4A C21B  26         mov   *r11,tmp4
0045 2A4C 0988  56         srl   tmp4,8                ; Right justify
0046 2A4E 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2A50 FFF6     
0047 2A52 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2A54 C21B  26         mov   *r11,tmp4
0054 2A56 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2A58 00FF     
0055               
0056 2A5A A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2A5C 06C6  14         swpb  tmp2
0058 2A5E DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2A60 0944  56         srl   tmp0,4                ; Next nibble
0060 2A62 0605  14         dec   tmp1
0061 2A64 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2A66 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2A68 BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2A6A C160  34         mov   @waux3,tmp1           ; Get pointer
     2A6C 8340     
0067 2A6E 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2A70 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2A72 C120  34         mov   @waux2,tmp0
     2A74 833E     
0070 2A76 06C4  14         swpb  tmp0
0071 2A78 DD44  32         movb  tmp0,*tmp1+
0072 2A7A 06C4  14         swpb  tmp0
0073 2A7C DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2A7E C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2A80 8340     
0078 2A82 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2A84 2016     
0079 2A86 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2A88 C120  34         mov   @waux1,tmp0
     2A8A 833C     
0084 2A8C 06C4  14         swpb  tmp0
0085 2A8E DD44  32         movb  tmp0,*tmp1+
0086 2A90 06C4  14         swpb  tmp0
0087 2A92 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2A94 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A96 2020     
0092 2A98 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2A9A 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2A9C 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2A9E 7FFF     
0098 2AA0 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2AA2 8340     
0099 2AA4 0460  28         b     @xutst0               ; Display string
     2AA6 2434     
0100 2AA8 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2AAA C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2AAC 832A     
0122 2AAE 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2AB0 8000     
0123 2AB2 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
                   < runlib.asm
0189               
0191                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 2AB4 0207  20 mknum   li    tmp3,5                ; Digit counter
     2AB6 0005     
0020 2AB8 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 2ABA C155  26         mov   *tmp1,tmp1            ; /
0022 2ABC C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 2ABE 0228  22         ai    tmp4,4                ; Get end of buffer
     2AC0 0004     
0024 2AC2 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     2AC4 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 2AC6 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 2AC8 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 2ACA 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 2ACC B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 2ACE D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 2AD0 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 2AD2 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 2AD4 0607  14         dec   tmp3                  ; Decrease counter
0036 2AD6 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 2AD8 0207  20         li    tmp3,4                ; Check first 4 digits
     2ADA 0004     
0041 2ADC 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2ADE C11B  26         mov   *r11,tmp0
0043 2AE0 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2AE2 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2AE4 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2AE6 05CB  14 mknum3  inct  r11
0047 2AE8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2AEA 2020     
0048 2AEC 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2AEE 045B  20         b     *r11                  ; Exit
0050 2AF0 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2AF2 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2AF4 13F8  14         jeq   mknum3                ; Yes, exit
0053 2AF6 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2AF8 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2AFA 7FFF     
0058 2AFC C10B  18         mov   r11,tmp0
0059 2AFE 0224  22         ai    tmp0,-4
     2B00 FFFC     
0060 2B02 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2B04 0206  20         li    tmp2,>0500            ; String length = 5
     2B06 0500     
0062 2B08 0460  28         b     @xutstr               ; Display string
     2B0A 2436     
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
0093 2B0C C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2B0E C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2B10 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2B12 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2B14 0207  20         li    tmp3,5                ; Set counter
     2B16 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2B18 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2B1A 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2B1C 0584  14         inc   tmp0                  ; Next character
0105 2B1E 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2B20 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2B22 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2B24 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2B26 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2B28 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2B2A DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2B2C 0607  14         dec   tmp3                  ; Last character ?
0121 2B2E 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2B30 045B  20         b     *r11                  ; Return
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
0139 2B32 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2B34 832A     
0140 2B36 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2B38 8000     
0141 2B3A 10BC  14         jmp   mknum                 ; Convert number and display
                   < runlib.asm
0193               
0197               
0201               
0205               
0209               
0211                       copy  "cpu_strings.asm"          ; String utilities support
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
0022 2B3C 0649  14         dect  stack
0023 2B3E C64B  30         mov   r11,*stack            ; Save return address
0024 2B40 0649  14         dect  stack
0025 2B42 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2B44 0649  14         dect  stack
0027 2B46 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2B48 0649  14         dect  stack
0029 2B4A C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2B4C 0649  14         dect  stack
0031 2B4E C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2B50 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2B52 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2B54 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2B56 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2B58 0649  14         dect  stack
0044 2B5A C64B  30         mov   r11,*stack            ; Save return address
0045 2B5C 0649  14         dect  stack
0046 2B5E C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2B60 0649  14         dect  stack
0048 2B62 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2B64 0649  14         dect  stack
0050 2B66 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2B68 0649  14         dect  stack
0052 2B6A C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2B6C C1D4  26 !       mov   *tmp0,tmp3
0057 2B6E 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2B70 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2B72 00FF     
0059 2B74 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2B76 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2B78 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2B7A 0584  14         inc   tmp0                  ; Next byte
0067 2B7C 0607  14         dec   tmp3                  ; Shorten string length
0068 2B7E 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2B80 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2B82 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2B84 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2B86 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2B88 C187  18         mov   tmp3,tmp2
0078 2B8A 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2B8C DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2B8E 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2B90 24F4     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2B92 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2B94 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B96 FFCE     
0090 2B98 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B9A 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2B9C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2B9E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2BA0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2BA2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2BA4 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2BA6 045B  20         b     *r11                  ; Return to caller
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
0123 2BA8 0649  14         dect  stack
0124 2BAA C64B  30         mov   r11,*stack            ; Save return address
0125 2BAC 05D9  26         inct  *stack                ; Skip "data P0"
0126 2BAE 05D9  26         inct  *stack                ; Skip "data P1"
0127 2BB0 0649  14         dect  stack
0128 2BB2 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2BB4 0649  14         dect  stack
0130 2BB6 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2BB8 0649  14         dect  stack
0132 2BBA C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2BBC C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2BBE C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2BC0 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2BC2 0649  14         dect  stack
0144 2BC4 C64B  30         mov   r11,*stack            ; Save return address
0145 2BC6 0649  14         dect  stack
0146 2BC8 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2BCA 0649  14         dect  stack
0148 2BCC C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2BCE 0649  14         dect  stack
0150 2BD0 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2BD2 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2BD4 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2BD6 0586  14         inc   tmp2
0161 2BD8 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2BDA 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2BDC 0286  22         ci    tmp2,255
     2BDE 00FF     
0167 2BE0 1505  14         jgt   string.getlenc.panic
0168 2BE2 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2BE4 0606  14         dec   tmp2                  ; One time adjustment
0174 2BE6 C806  38         mov   tmp2,@waux1           ; Store length
     2BE8 833C     
0175 2BEA 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2BEC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2BEE FFCE     
0181 2BF0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2BF2 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2BF4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2BF6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2BF8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2BFA C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2BFC 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0213               
0217               
0219                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
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
0023 2BFE C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2C00 F960     
0024 2C02 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2C04 F962     
0025 2C06 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2C08 F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 2C0A 0200  20         li    r0,>8306              ; Scratchpad source address
     2C0C 8306     
0030 2C0E 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2C10 F966     
0031 2C12 0202  20         li    r2,62                 ; Loop counter
     2C14 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 2C16 CC70  46         mov   *r0+,*r1+
0037 2C18 CC70  46         mov   *r0+,*r1+
0038 2C1A 0642  14         dect  r2
0039 2C1C 16FC  14         jne   cpu.scrpad.backup.copy
0040 2C1E C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2C20 83FE     
     2C22 FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 2C24 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2C26 F960     
0046 2C28 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2C2A F962     
0047 2C2C C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2C2E F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 2C30 045B  20         b     *r11                  ; Return to caller
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
0074 2C32 0200  20         li    r0,cpu.scrpad.tgt
     2C34 F960     
0075 2C36 0201  20         li    r1,>8300
     2C38 8300     
0076                       ;------------------------------------------------------
0077                       ; Copy 256 bytes from @cpu.scrpad.tgt to >8300
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 2C3A CC70  46         mov   *r0+,*r1+
0081 2C3C CC70  46         mov   *r0+,*r1+
0082 2C3E 0281  22         ci    r1,>8400
     2C40 8400     
0083 2C42 11FB  14         jlt   cpu.scrpad.restore.copy
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               cpu.scrpad.restore.exit:
0088 2C44 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0220                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
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
0038 2C46 C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 2C48 CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 2C4A CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 2C4C CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 2C4E CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 2C50 CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 2C52 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 2C54 CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 2C56 CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 2C58 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     2C5A 8310     
0055                                                   ;        as of register r8
0056 2C5C 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     2C5E 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 2C60 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 2C62 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 2C64 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 2C66 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 2C68 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 2C6A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 2C6C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 2C6E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 2C70 0606  14         dec   tmp2
0069 2C72 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 2C74 C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 2C76 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2C78 2C7E     
0075                                                   ; R14=PC
0076 2C7A 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 2C7C 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 2C7E 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     2C80 2C32     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 2C82 045B  20         b     *r11                  ; Return to caller
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
0120 2C84 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0121                       ;------------------------------------------------------
0122                       ; Copy scratchpad memory to destination
0123                       ;------------------------------------------------------
0124               xcpu.scrpad.pgin:
0125 2C86 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2C88 8300     
0126 2C8A 0206  20         li    tmp2,16               ; tmp2 = 256/16
     2C8C 0010     
0127                       ;------------------------------------------------------
0128                       ; Copy memory
0129                       ;------------------------------------------------------
0130 2C8E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0131 2C90 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0132 2C92 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0133 2C94 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0134 2C96 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0135 2C98 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0136 2C9A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0137 2C9C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0138 2C9E 0606  14         dec   tmp2
0139 2CA0 16F6  14         jne   -!                    ; Loop until done
0140                       ;------------------------------------------------------
0141                       ; Switch workspace to scratchpad memory
0142                       ;------------------------------------------------------
0143 2CA2 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2CA4 8300     
0144                       ;------------------------------------------------------
0145                       ; Exit
0146                       ;------------------------------------------------------
0147               cpu.scrpad.pgin.exit:
0148 2CA6 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0222               
0224                       copy  "fio.equ"                  ; File I/O equates
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
0225                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
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
0056 2CA8 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2CAA 2CAC             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2CAC C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2CAE C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2CB0 A428     
0064 2CB2 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2CB4 201C     
0065 2CB6 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2CB8 8356     
0066 2CBA C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2CBC 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2CBE FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2CC0 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2CC2 A434     
0073                       ;---------------------------; Inline VSBR start
0074 2CC4 06C0  14         swpb  r0                    ;
0075 2CC6 D800  38         movb  r0,@vdpa              ; Send low byte
     2CC8 8C02     
0076 2CCA 06C0  14         swpb  r0                    ;
0077 2CCC D800  38         movb  r0,@vdpa              ; Send high byte
     2CCE 8C02     
0078 2CD0 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2CD2 8800     
0079                       ;---------------------------; Inline VSBR end
0080 2CD4 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2CD6 0704  14         seto  r4                    ; Init counter
0086 2CD8 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2CDA A420     
0087 2CDC 0580  14 !       inc   r0                    ; Point to next char of name
0088 2CDE 0584  14         inc   r4                    ; Increment char counter
0089 2CE0 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2CE2 0007     
0090 2CE4 1573  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2CE6 80C4  18         c     r4,r3                 ; End of name?
0093 2CE8 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2CEA 06C0  14         swpb  r0                    ;
0098 2CEC D800  38         movb  r0,@vdpa              ; Send low byte
     2CEE 8C02     
0099 2CF0 06C0  14         swpb  r0                    ;
0100 2CF2 D800  38         movb  r0,@vdpa              ; Send high byte
     2CF4 8C02     
0101 2CF6 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2CF8 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2CFA DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2CFC 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2CFE 2E18     
0109 2D00 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2D02 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2D04 1363  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2D06 04E0  34         clr   @>83d0
     2D08 83D0     
0118 2D0A C804  38         mov   r4,@>8354             ; Save name length for search (length
     2D0C 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2D0E C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2D10 A432     
0121               
0122 2D12 0584  14         inc   r4                    ; Adjust for dot
0123 2D14 A804  38         a     r4,@>8356             ; Point to position after name
     2D16 8356     
0124 2D18 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2D1A 8356     
     2D1C A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2D1E 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2D20 83E0     
0130 2D22 04C1  14         clr   r1                    ; Version found of dsr
0131 2D24 020C  20         li    r12,>0f00             ; Init cru address
     2D26 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2D28 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2D2A 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2D2C 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2D2E 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2D30 0100     
0145 2D32 04E0  34         clr   @>83d0                ; Clear in case we are done
     2D34 83D0     
0146 2D36 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2D38 2000     
0147 2D3A 1346  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2D3C C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2D3E 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2D40 1D00  20         sbo   0                     ; Turn on ROM
0154 2D42 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2D44 4000     
0155 2D46 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2D48 2E14     
0156 2D4A 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2D4C A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2D4E A40A     
0166 2D50 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2D52 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2D54 83D2     
0172                                                   ; subprogram
0173               
0174 2D56 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2D58 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2D5A 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2D5C C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2D5E 83D2     
0183                                                   ; subprogram
0184               
0185 2D60 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2D62 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2D64 04C5  14         clr   r5                    ; Remove any old stuff
0194 2D66 D160  34         movb  @>8355,r5             ; Get length as counter
     2D68 8355     
0195 2D6A 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2D6C 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2D6E 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2D70 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2D72 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2D74 A420     
0206 2D76 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2D78 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2D7A 0605  14         dec   r5                    ; Update loop counter
0211 2D7C 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2D7E 0581  14         inc   r1                    ; Next version found
0217 2D80 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2D82 A42A     
0218 2D84 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2D86 A42C     
0219 2D88 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2D8A A430     
0220               
0221 2D8C 020D  20         li    r13,>9800             ; Set GROM base to >9800 to prevent
     2D8E 9800     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2D90 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2D92 8C02     
0225                                                   ; lockup of TI Disk Controller DSR.
0226               
0227 2D94 0699  24         bl    *r9                   ; Execute DSR
0228                       ;
0229                       ; Depending on IO result the DSR in card ROM does RET
0230                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0231                       ;
0232 2D96 10DD  14         jmp   dsrlnk.dsrscan.nextentry
0233                                                   ; (1) error return
0234 2D98 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0235 2D9A 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2D9C A400     
0236 2D9E C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0237                       ;------------------------------------------------------
0238                       ; Returned from DSR
0239                       ;------------------------------------------------------
0240               dsrlnk.dsrscan.return_dsr:
0241 2DA0 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2DA2 A428     
0242                                                   ; (8 or >a)
0243 2DA4 0281  22         ci    r1,8                  ; was it 8?
     2DA6 0008     
0244 2DA8 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0245 2DAA D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2DAC 8350     
0246                                                   ; Get error byte from @>8350
0247 2DAE 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0248               
0249                       ;------------------------------------------------------
0250                       ; Read VDP PAB byte 1 after DSR call completed (status)
0251                       ;------------------------------------------------------
0252               dsrlnk.dsrscan.dsr.8:
0253                       ;---------------------------; Inline VSBR start
0254 2DB0 06C0  14         swpb  r0                    ;
0255 2DB2 D800  38         movb  r0,@vdpa              ; send low byte
     2DB4 8C02     
0256 2DB6 06C0  14         swpb  r0                    ;
0257 2DB8 D800  38         movb  r0,@vdpa              ; send high byte
     2DBA 8C02     
0258 2DBC D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2DBE 8800     
0259                       ;---------------------------; Inline VSBR end
0260               
0261                       ;------------------------------------------------------
0262                       ; Return DSR error to caller
0263                       ;------------------------------------------------------
0264               dsrlnk.dsrscan.dsr.a:
0265 2DC0 09D1  56         srl   r1,13                 ; just keep error bits
0266 2DC2 1605  14         jne   dsrlnk.error.io_error
0267                                                   ; handle IO error
0268 2DC4 0380  18         rtwp                        ; Return from DSR workspace to caller
0269                                                   ; workspace
0270               
0271                       ;------------------------------------------------------
0272                       ; IO-error handler
0273                       ;------------------------------------------------------
0274               dsrlnk.error.nodsr_found_off:
0275 2DC6 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0276               dsrlnk.error.nodsr_found:
0277 2DC8 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2DCA A400     
0278               dsrlnk.error.devicename_invalid:
0279 2DCC 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0280               dsrlnk.error.io_error:
0281 2DCE 06C1  14         swpb  r1                    ; put error in hi byte
0282 2DD0 D741  30         movb  r1,*r13               ; store error flags in callers r0
0283 2DD2 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2DD4 201C     
0284                                                   ; / to indicate error
0285 2DD6 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0312 2DD8 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0313 2DDA 2DDC             data  dsrlnk.reuse.init     ; entry point
0314                       ;------------------------------------------------------
0315                       ; DSRLNK entry point
0316                       ;------------------------------------------------------
0317               dsrlnk.reuse.init:
0318 2DDC 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2DDE 83E0     
0319               
0320 2DE0 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2DE2 201C     
0321                       ;------------------------------------------------------
0322                       ; Restore dsrlnk variables of previous DSR call
0323                       ;------------------------------------------------------
0324 2DE4 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2DE6 A42A     
0325 2DE8 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0326 2DEA C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0327 2DEC C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2DEE 8356     
0328                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0329 2DF0 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0330 2DF2 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2DF4 8354     
0331                       ;------------------------------------------------------
0332                       ; Call DSR program in card/device
0333                       ;------------------------------------------------------
0334 2DF6 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2DF8 8C02     
0335                                                   ; lockup of TI Disk Controller DSR.
0336               
0337 2DFA 1D00  20         sbo   >00                   ; Open card/device ROM
0338               
0339 2DFC 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2DFE 4000     
     2E00 2E14     
0340 2E02 16E2  14         jne   dsrlnk.error.nodsr_found
0341                                                   ; No, error code 0 = Bad Device name
0342                                                   ; The above jump may happen only in case of
0343                                                   ; either card hardware malfunction or if
0344                                                   ; there are 2 cards opened at the same time.
0345               
0346 2E04 0699  24         bl    *r9                   ; Execute DSR
0347                       ;
0348                       ; Depending on IO result the DSR in card ROM does RET
0349                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0350                       ;
0351 2E06 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0352                                                   ; (1) error return
0353 2E08 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0354                       ;------------------------------------------------------
0355                       ; Now check if any DSR error occured
0356                       ;------------------------------------------------------
0357 2E0A 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2E0C A400     
0358 2E0E C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2E10 A434     
0359               
0360 2E12 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0361                                                   ; Rest is the same as with normal DSRLNK
0362               
0363               
0364               ********************************************************************************
0365               
0366 2E14 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0367 2E16 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0368                                                   ; a @blwp @dsrlnk
0369 2E18 2E       dsrlnk.period     text  '.'         ; For finding end of device name
0370               
0371                       even
                   < runlib.asm
0226                       copy  "fio_level3.asm"           ; File I/O level 3 support
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
0045 2E1A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2E1C C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2E1E 0649  14         dect  stack
0052 2E20 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2E22 0204  20         li    tmp0,dsrlnk.savcru
     2E24 A42A     
0057 2E26 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2E28 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2E2A 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2E2C 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2E2E 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2E30 37D7     
0065 2E32 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2E34 8370     
0066                                                   ; / location
0067 2E36 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2E38 A44C     
0068 2E3A 04C5  14         clr   tmp1                  ; io.op.open
0069 2E3C 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2E3E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2E40 0649  14         dect  stack
0097 2E42 C64B  30         mov   r11,*stack            ; Save return address
0098 2E44 0205  20         li    tmp1,io.op.close      ; io.op.close
     2E46 0001     
0099 2E48 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2E4A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2E4C 0649  14         dect  stack
0125 2E4E C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2E50 0205  20         li    tmp1,io.op.read       ; io.op.read
     2E52 0002     
0128 2E54 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2E56 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2E58 0649  14         dect  stack
0155 2E5A C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2E5C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2E5E 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2E60 0005     
0159               
0160 2E62 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2E64 A43E     
0161               
0162 2E66 06A0  32         bl    @xvputb               ; Write character count to PAB
     2E68 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2E6A 0205  20         li    tmp1,io.op.write      ; io.op.write
     2E6C 0003     
0167 2E6E 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2E70 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2E72 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2E74 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2E76 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2E78 1000  14         nop
0189               
0190               
0191               file.status:
0192 2E7A 1000  14         nop
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
0227 2E7C C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2E7E A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2E80 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2E82 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2E84 A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2E86 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2E88 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2E8A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2E8C 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2E8E C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2E90 A44C     
0246               
0247 2E92 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2E94 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2E96 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2E98 0009     
0254 2E9A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2E9C 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2E9E C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2EA0 8322     
     2EA2 833C     
0259               
0260 2EA4 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2EA6 A42A     
0261 2EA8 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2EAA 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2EAC 2CA8     
0268 2EAE 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2EB0 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2EB2 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2EB4 2DD8     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2EB6 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2EB8 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2EBA 833C     
     2EBC 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2EBE C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2EC0 A436     
0292 2EC2 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2EC4 0005     
0293 2EC6 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2EC8 22F8     
0294 2ECA C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2ECC C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2ECE C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2ED0 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0228               
0229               *//////////////////////////////////////////////////////////////
0230               *                            TIMERS
0231               *//////////////////////////////////////////////////////////////
0232               
0233                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 2ED2 0300  24 tmgr    limi  0                     ; No interrupt processing
     2ED4 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2ED6 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2ED8 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2EDA 2360  38         coc   @wbit2,r13            ; C flag on ?
     2EDC 201C     
0029 2EDE 1602  14         jne   tmgr1a                ; No, so move on
0030 2EE0 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2EE2 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2EE4 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2EE6 2020     
0035 2EE8 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2EEA 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2EEC 2010     
0048 2EEE 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2EF0 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2EF2 200E     
0050 2EF4 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2EF6 0460  28         b     @kthread              ; Run kernel thread
     2EF8 2F70     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2EFA 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2EFC 2014     
0056 2EFE 13EB  14         jeq   tmgr1
0057 2F00 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2F02 2012     
0058 2F04 16E8  14         jne   tmgr1
0059 2F06 C120  34         mov   @wtiusr,tmp0
     2F08 832E     
0060 2F0A 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2F0C 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2F0E 2F6E     
0065 2F10 C10A  18         mov   r10,tmp0
0066 2F12 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2F14 00FF     
0067 2F16 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2F18 201C     
0068 2F1A 1303  14         jeq   tmgr5
0069 2F1C 0284  22         ci    tmp0,60               ; 1 second reached ?
     2F1E 003C     
0070 2F20 1002  14         jmp   tmgr6
0071 2F22 0284  22 tmgr5   ci    tmp0,50
     2F24 0032     
0072 2F26 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2F28 1001  14         jmp   tmgr8
0074 2F2A 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2F2C C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2F2E 832C     
0079 2F30 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2F32 FF00     
0080 2F34 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2F36 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2F38 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2F3A 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2F3C C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2F3E 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2F40 830C     
     2F42 830D     
0089 2F44 1608  14         jne   tmgr10                ; No, get next slot
0090 2F46 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2F48 FF00     
0091 2F4A C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2F4C C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2F4E 8330     
0096 2F50 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2F52 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2F54 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2F56 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2F58 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2F5A 8315     
     2F5C 8314     
0103 2F5E 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2F60 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2F62 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2F64 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2F66 10F7  14         jmp   tmgr10                ; Process next slot
0108 2F68 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2F6A FF00     
0109 2F6C 10B4  14         jmp   tmgr1
0110 2F6E 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
                   < runlib.asm
0234                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 2F70 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2F72 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 2F74 20A0  38         coc   @wbit13,config        ; Sound player on ?
     2F76 2006     
0023 2F78 1602  14         jne   kthread_kb
0024 2F7A 06A0  32         bl    @sdpla1               ; Run sound player
     2F7C 284A     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 2F7E 06A0  32         bl    @realkb               ; Scan full keyboard
     2F80 28CA     
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2F82 0460  28         b     @tmgr3                ; Exit
     2F84 2EFA     
                   < runlib.asm
0235                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 2F86 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2F88 832E     
0018 2F8A E0A0  34         soc   @wbit7,config         ; Enable user hook
     2F8C 2012     
0019 2F8E 045B  20 mkhoo1  b     *r11                  ; Return
0020      2ED6     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2F90 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2F92 832E     
0029 2F94 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2F96 FEFF     
0030 2F98 045B  20         b     *r11                  ; Return
                   < runlib.asm
0236               
0238                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 2F9A C13B  30 mkslot  mov   *r11+,tmp0
0018 2F9C C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2F9E C184  18         mov   tmp0,tmp2
0023 2FA0 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2FA2 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2FA4 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2FA6 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2FA8 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2FAA C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2FAC 881B  46         c     *r11,@w$ffff          ; End of list ?
     2FAE 2022     
0035 2FB0 1301  14         jeq   mkslo1                ; Yes, exit
0036 2FB2 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2FB4 05CB  14 mkslo1  inct  r11
0041 2FB6 045B  20         b     *r11                  ; Exit
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
0052 2FB8 C13B  30 clslot  mov   *r11+,tmp0
0053 2FBA 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2FBC A120  34         a     @wtitab,tmp0          ; Add table base
     2FBE 832C     
0055 2FC0 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2FC2 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2FC4 045B  20         b     *r11                  ; Exit
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
0068 2FC6 C13B  30 rsslot  mov   *r11+,tmp0
0069 2FC8 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2FCA A120  34         a     @wtitab,tmp0          ; Add table base
     2FCC 832C     
0071 2FCE 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2FD0 C154  26         mov   *tmp0,tmp1
0073 2FD2 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2FD4 FF00     
0074 2FD6 C505  30         mov   tmp1,*tmp0
0075 2FD8 045B  20         b     *r11                  ; Exit
                   < runlib.asm
0240               
0241               
0242               
0243               *//////////////////////////////////////////////////////////////
0244               *                    RUNLIB INITIALISATION
0245               *//////////////////////////////////////////////////////////////
0246               
0247               ***************************************************************
0248               *  RUNLIB - Runtime library initalisation
0249               ***************************************************************
0250               *  B  @RUNLIB
0251               *--------------------------------------------------------------
0252               *  REMARKS
0253               *  if R0 in WS1 equals >4a4a we were called from the system
0254               *  crash handler so we return there after initialisation.
0255               
0256               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0257               *  after clearing scratchpad memory. This has higher priority
0258               *  as crash handler flag R0.
0259               ********|*****|*********************|**************************
0266 2FDA 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2FDC 8302     
0268               *--------------------------------------------------------------
0269               * Alternative entry point
0270               *--------------------------------------------------------------
0271 2FDE 0300  24 runli1  limi  0                     ; Turn off interrupts
     2FE0 0000     
0272 2FE2 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2FE4 8300     
0273 2FE6 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2FE8 83C0     
0274               *--------------------------------------------------------------
0275               * Clear scratch-pad memory from R4 upwards
0276               *--------------------------------------------------------------
0277 2FEA 0202  20 runli2  li    r2,>8308
     2FEC 8308     
0278 2FEE 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0279 2FF0 0282  22         ci    r2,>8400
     2FF2 8400     
0280 2FF4 16FC  14         jne   runli3
0281               *--------------------------------------------------------------
0282               * Exit to TI-99/4A title screen ?
0283               *--------------------------------------------------------------
0284 2FF6 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2FF8 FFFF     
0285 2FFA 1602  14         jne   runli4                ; No, continue
0286 2FFC 0420  54         blwp  @0                    ; Yes, bye bye
     2FFE 0000     
0287               *--------------------------------------------------------------
0288               * Determine if VDP is PAL or NTSC
0289               *--------------------------------------------------------------
0290 3000 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     3002 833C     
0291 3004 04C1  14         clr   r1                    ; Reset counter
0292 3006 0202  20         li    r2,10                 ; We test 10 times
     3008 000A     
0293 300A C0E0  34 runli5  mov   @vdps,r3
     300C 8802     
0294 300E 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     3010 2020     
0295 3012 1302  14         jeq   runli6
0296 3014 0581  14         inc   r1                    ; Increase counter
0297 3016 10F9  14         jmp   runli5
0298 3018 0602  14 runli6  dec   r2                    ; Next test
0299 301A 16F7  14         jne   runli5
0300 301C 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     301E 1250     
0301 3020 1202  14         jle   runli7                ; No, so it must be NTSC
0302 3022 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     3024 201C     
0303               *--------------------------------------------------------------
0304               * Copy machine code to scratchpad (prepare tight loop)
0305               *--------------------------------------------------------------
0306 3026 06A0  32 runli7  bl    @loadmc
     3028 222E     
0307               *--------------------------------------------------------------
0308               * Initialize registers, memory, ...
0309               *--------------------------------------------------------------
0310 302A 04C1  14 runli9  clr   r1
0311 302C 04C2  14         clr   r2
0312 302E 04C3  14         clr   r3
0313 3030 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     3032 A900     
0314 3034 020F  20         li    r15,vdpw              ; Set VDP write address
     3036 8C00     
0316 3038 06A0  32         bl    @mute                 ; Mute sound generators
     303A 280E     
0318               *--------------------------------------------------------------
0319               * Setup video memory
0320               *--------------------------------------------------------------
0322 303C 0280  22         ci    r0,>4a4a              ; Crash flag set?
     303E 4A4A     
0323 3040 1605  14         jne   runlia
0324 3042 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     3044 22A2     
0325 3046 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     3048 0000     
     304A 3000     
0330 304C 06A0  32 runlia  bl    @filv
     304E 22A2     
0331 3050 0FC0             data  pctadr,spfclr,16      ; Load color table
     3052 00F4     
     3054 0010     
0332               *--------------------------------------------------------------
0333               * Check if there is a F18A present
0334               *--------------------------------------------------------------
0338 3056 06A0  32         bl    @f18unl               ; Unlock the F18A
     3058 273E     
0339 305A 06A0  32         bl    @f18chk               ; Check if F18A is there \
     305C 2768     
0340 305E 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     3060 2768     
0341 3062 06A0  32         bl    @f18chk               ; Check if F18A is there /
     3064 2768     
0342 3066 06A0  32         bl    @f18lck               ; Lock the F18A again
     3068 2754     
0343               
0344 306A 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     306C 2346     
0345 306E 3201                   data >3201            ; F18a VR50 (>32), bit 1
0347               *--------------------------------------------------------------
0348               * Check if there is a speech synthesizer attached
0349               *--------------------------------------------------------------
0351               *       <<skipped>>
0355               *--------------------------------------------------------------
0356               * Load video mode table & font
0357               *--------------------------------------------------------------
0358 3070 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     3072 230C     
0359 3074 36E4             data  spvmod                ; Equate selected video mode table
0360 3076 0204  20         li    tmp0,spfont           ; Get font option
     3078 000C     
0361 307A 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0362 307C 1304  14         jeq   runlid                ; Yes, skip it
0363 307E 06A0  32         bl    @ldfnt
     3080 2374     
0364 3082 1100             data  fntadr,spfont         ; Load specified font
     3084 000C     
0365               *--------------------------------------------------------------
0366               * Did a system crash occur before runlib was called?
0367               *--------------------------------------------------------------
0368 3086 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     3088 4A4A     
0369 308A 1602  14         jne   runlie                ; No, continue
0370 308C 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     308E 2086     
0371               *--------------------------------------------------------------
0372               * Branch to main program
0373               *--------------------------------------------------------------
0374 3090 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     3092 0040     
0375 3094 0460  28         b     @main                 ; Give control to main program
     3096 6046     
                   < stevie_b1.asm.31063
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
0021 3098 C13B  30         mov   *r11+,tmp0            ; P0
0022 309A C17B  30         mov   *r11+,tmp1            ; P1
0023 309C C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 309E 0649  14         dect  stack
0029 30A0 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 30A2 0649  14         dect  stack
0031 30A4 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 30A6 0649  14         dect  stack
0033 30A8 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 30AA 0649  14         dect  stack
0035 30AC C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 30AE 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     30B0 6000     
0040 30B2 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 30B4 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     30B6 A226     
0044 30B8 0647  14         dect  tmp3
0045 30BA C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 30BC 0647  14         dect  tmp3
0047 30BE C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 30C0 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     30C2 A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 30C4 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 30C6 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 30C8 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 30CA 0224  22         ai    tmp0,>0800
     30CC 0800     
0066 30CE 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 30D0 0285  22         ci    tmp1,>ffff
     30D2 FFFF     
0075 30D4 1602  14         jne   !
0076 30D6 C160  34         mov   @trmpvector,tmp1
     30D8 A03A     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 30DA C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 30DC 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 30DE 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 30E0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     30E2 FFCE     
0091 30E4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     30E6 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 30E8 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 30EA C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     30EC A226     
0102 30EE C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 30F0 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 30F2 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 30F4 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 30F6 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 30F8 028B  22         ci    r11,>6000
     30FA 6000     
0115 30FC 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 30FE 028B  22         ci    r11,>7fff
     3100 7FFF     
0117 3102 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 3104 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     3106 A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 3108 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 310A 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 310C 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 310E 0225  22         ai    tmp1,>0800
     3110 0800     
0137 3112 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 3114 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 3116 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3118 FFCE     
0144 311A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     311C 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 311E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 3120 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 3122 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 3124 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 3126 045B  20         b     *r11                  ; Return to caller
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
0020 3128 0649  14         dect  stack
0021 312A C64B  30         mov   r11,*stack            ; Save return address
0022 312C 0649  14         dect  stack
0023 312E C644  30         mov   tmp0,*stack           ; Push tmp0
0024 3130 0649  14         dect  stack
0025 3132 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3134 0204  20         li    tmp0,fb.top
     3136 D000     
0030 3138 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     313A A300     
0031 313C 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     313E A304     
0032 3140 04E0  34         clr   @fb.row               ; Current row=0
     3142 A306     
0033 3144 04E0  34         clr   @fb.column            ; Current column=0
     3146 A30C     
0034               
0035 3148 0204  20         li    tmp0,colrow
     314A 0050     
0036 314C C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     314E A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 3150 C160  34         mov   @tv.ruler.visible,tmp1
     3152 A210     
0041 3154 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 3156 0204  20         li    tmp0,pane.botrow-2
     3158 001B     
0043 315A 1002  14         jmp   fb.init.cont
0044 315C 0204  20 !       li    tmp0,pane.botrow-1
     315E 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 3160 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     3162 A31A     
0050 3164 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3166 A31C     
0051               
0052 3168 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     316A A222     
0053 316C 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     316E A310     
0054 3170 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     3172 A316     
0055 3174 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     3176 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 3178 06A0  32         bl    @film
     317A 224A     
0060 317C D000             data  fb.top,>00,fb.size    ; Clear it all the way
     317E 0000     
     3180 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 3182 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 3184 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 3186 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 3188 045B  20         b     *r11                  ; Return to caller
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
0051 318A 0649  14         dect  stack
0052 318C C64B  30         mov   r11,*stack            ; Save return address
0053 318E 0649  14         dect  stack
0054 3190 C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 3192 0204  20         li    tmp0,idx.top
     3194 B000     
0059 3196 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     3198 A502     
0060               
0061 319A C120  34         mov   @tv.sams.b000,tmp0
     319C A206     
0062 319E C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     31A0 A600     
0063 31A2 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     31A4 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 31A6 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     31A8 0004     
0068 31AA C804  38         mov   tmp0,@idx.sams.hipage ; /
     31AC A604     
0069               
0070 31AE 06A0  32         bl    @_idx.sams.mapcolumn.on
     31B0 31CC     
0071                                                   ; Index in continuous memory region
0072               
0073 31B2 06A0  32         bl    @film
     31B4 224A     
0074 31B6 B000                   data idx.top,>00,idx.size * 5
     31B8 0000     
     31BA 5000     
0075                                                   ; Clear index
0076               
0077 31BC 06A0  32         bl    @_idx.sams.mapcolumn.off
     31BE 3200     
0078                                                   ; Restore memory window layout
0079               
0080 31C0 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     31C2 A602     
     31C4 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 31C6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 31C8 C2F9  30         mov   *stack+,r11           ; Pop r11
0088 31CA 045B  20         b     *r11                  ; Return to caller
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
0101 31CC 0649  14         dect  stack
0102 31CE C64B  30         mov   r11,*stack            ; Push return address
0103 31D0 0649  14         dect  stack
0104 31D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 31D4 0649  14         dect  stack
0106 31D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 31D8 0649  14         dect  stack
0108 31DA C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 31DC C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     31DE A602     
0113 31E0 0205  20         li    tmp1,idx.top
     31E2 B000     
0114 31E4 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     31E6 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 31E8 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     31EA 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 31EC 0584  14         inc   tmp0                  ; Next SAMS index page
0123 31EE 0225  22         ai    tmp1,>1000            ; Next memory region
     31F0 1000     
0124 31F2 0606  14         dec   tmp2                  ; Update loop counter
0125 31F4 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 31F6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 31F8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 31FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 31FC C2F9  30         mov   *stack+,r11           ; Pop return address
0134 31FE 045B  20         b     *r11                  ; Return to caller
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
0150 3200 0649  14         dect  stack
0151 3202 C64B  30         mov   r11,*stack            ; Push return address
0152 3204 0649  14         dect  stack
0153 3206 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 3208 0649  14         dect  stack
0155 320A C645  30         mov   tmp1,*stack           ; Push tmp1
0156 320C 0649  14         dect  stack
0157 320E C646  30         mov   tmp2,*stack           ; Push tmp2
0158 3210 0649  14         dect  stack
0159 3212 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 3214 0205  20         li    tmp1,idx.top
     3216 B000     
0164 3218 0206  20         li    tmp2,5                ; Always 5 pages
     321A 0005     
0165 321C 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     321E A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 3220 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 3222 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3224 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 3226 0225  22         ai    tmp1,>1000            ; Next memory region
     3228 1000     
0176 322A 0606  14         dec   tmp2                  ; Update loop counter
0177 322C 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 322E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 3230 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 3232 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 3234 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 3236 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 3238 045B  20         b     *r11                  ; Return to caller
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
0211 323A 0649  14         dect  stack
0212 323C C64B  30         mov   r11,*stack            ; Save return address
0213 323E 0649  14         dect  stack
0214 3240 C644  30         mov   tmp0,*stack           ; Push tmp0
0215 3242 0649  14         dect  stack
0216 3244 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 3246 0649  14         dect  stack
0218 3248 C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 324A C184  18         mov   tmp0,tmp2             ; Line number
0223 324C 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 324E 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     3250 0800     
0225               
0226 3252 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 3254 0A16  56         sla   tmp2,1                ; line number * 2
0231 3256 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     3258 A010     
0232               
0233 325A A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     325C A602     
0234 325E 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     3260 A600     
0235               
0236 3262 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 3264 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     3266 A600     
0242 3268 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     326A A206     
0243 326C C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 326E 0205  20         li    tmp1,>b000            ; Memory window for index page
     3270 B000     
0246               
0247 3272 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     3274 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 3276 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     3278 A604     
0254 327A 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 327C C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     327E A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 3280 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 3282 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 3284 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 3286 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 3288 045B  20         b     *r11                  ; Return to caller
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
0022 328A 0649  14         dect  stack
0023 328C C64B  30         mov   r11,*stack            ; Save return address
0024 328E 0649  14         dect  stack
0025 3290 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3292 0204  20         li    tmp0,edb.top          ; \
     3294 C000     
0030 3296 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     3298 A500     
0031 329A C804  38         mov   tmp0,@edb.next_free.ptr
     329C A508     
0032                                                   ; Set pointer to next free line
0033               
0034 329E 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     32A0 A50A     
0035               
0036 32A2 0204  20         li    tmp0,1
     32A4 0001     
0037 32A6 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     32A8 A504     
0038               
0039 32AA 0720  34         seto  @edb.block.m1         ; Reset block start line
     32AC A50C     
0040 32AE 0720  34         seto  @edb.block.m2         ; Reset block end line
     32B0 A50E     
0041               
0042 32B2 0204  20         li    tmp0,txt.newfile      ; "New file"
     32B4 38EE     
0043 32B6 C804  38         mov   tmp0,@edb.filename.ptr
     32B8 A512     
0044               
0045 32BA 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     32BC A440     
0046 32BE 04E0  34         clr   @fh.kilobytes.prev    ; /
     32C0 A45C     
0047               
0048 32C2 0204  20         li    tmp0,txt.filetype.none
     32C4 39AA     
0049 32C6 C804  38         mov   tmp0,@edb.filetype.ptr
     32C8 A514     
0050               
0051               edb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 32CA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 32CC C2F9  30         mov   *stack+,r11           ; Pop r11
0057 32CE 045B  20         b     *r11                  ; Return to caller
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
0022 32D0 0649  14         dect  stack
0023 32D2 C64B  30         mov   r11,*stack            ; Save return address
0024 32D4 0649  14         dect  stack
0025 32D6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 32D8 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     32DA E000     
0030 32DC C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     32DE A700     
0031               
0032 32E0 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     32E2 A702     
0033 32E4 0204  20         li    tmp0,4
     32E6 0004     
0034 32E8 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     32EA A706     
0035 32EC C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     32EE A708     
0036               
0037 32F0 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     32F2 A716     
0038 32F4 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     32F6 A718     
0039 32F8 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     32FA A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 32FC 06A0  32         bl    @film
     32FE 224A     
0044 3300 E000             data  cmdb.top,>00,cmdb.size
     3302 0000     
     3304 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3306 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3308 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 330A 045B  20         b     *r11                  ; Return to caller
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
0022 330C 0649  14         dect  stack
0023 330E C64B  30         mov   r11,*stack            ; Save return address
0024 3310 0649  14         dect  stack
0025 3312 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3314 0649  14         dect  stack
0027 3316 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3318 0649  14         dect  stack
0029 331A C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 331C 04E0  34         clr   @tv.error.visible     ; Set to hidden
     331E A228     
0034 3320 0204  20         li    tmp0,3
     3322 0003     
0035 3324 C804  38         mov   tmp0,@tv.error.rows   ; Number of rows in error pane
     3326 A22A     
0036               
0037 3328 06A0  32         bl    @film
     332A 224A     
0038 332C A22E                   data tv.error.msg,0,160
     332E 0000     
     3330 00A0     
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               errpane.exit:
0043 3332 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 3334 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 3336 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 3338 C2F9  30         mov   *stack+,r11           ; Pop R11
0047 333A 045B  20         b     *r11                  ; Return to caller
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
0022 333C 0649  14         dect  stack
0023 333E C64B  30         mov   r11,*stack            ; Save return address
0024 3340 0649  14         dect  stack
0025 3342 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3344 0649  14         dect  stack
0027 3346 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3348 0649  14         dect  stack
0029 334A C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 334C 0204  20         li    tmp0,1                ; \ Set default color scheme
     334E 0001     
0034 3350 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3352 A212     
0035               
0036 3354 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3356 A224     
0037 3358 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     335A 200C     
0038               
0039 335C 0204  20         li    tmp0,fj.bottom
     335E B000     
0040 3360 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     3362 A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 3364 06A0  32         bl    @cpym2m
     3366 24EE     
0045 3368 3A82                   data def.printer.fname,tv.printer.fname,7
     336A D960     
     336C 0007     
0046               
0047 336E 06A0  32         bl    @cpym2m
     3370 24EE     
0048 3372 3A8A                   data def.clip.fname,tv.clip.fname,10
     3374 D9B0     
     3376 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 3378 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 337A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 337C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 337E C2F9  30         mov   *stack+,r11           ; Pop R11
0057 3380 045B  20         b     *r11                  ; Return to caller
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
0023 3382 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     3384 27BA     
0024                       ;-------------------------------------------------------
0025                       ; Load legacy SAMS page layout and exit to monitor
0026                       ;-------------------------------------------------------
0027 3386 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     3388 3098     
0028 338A 600E                   data bank7.rom        ; | i  p0 = bank address
0029 338C 7FC0                   data bankx.vectab     ; | i  p1 = Vector with target address
0030 338E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
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
0023 3390 0649  14         dect  stack
0024 3392 C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Reset editor
0027                       ;------------------------------------------------------
0028 3394 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3396 32D0     
0029 3398 06A0  32         bl    @edb.init             ; Initialize editor buffer
     339A 328A     
0030 339C 06A0  32         bl    @idx.init             ; Initialize index
     339E 318A     
0031 33A0 06A0  32         bl    @fb.init              ; Initialize framebuffer
     33A2 3128     
0032 33A4 06A0  32         bl    @errpane.init         ; Initialize error pane
     33A6 330C     
0033                       ;------------------------------------------------------
0034                       ; Remove markers and shortcuts
0035                       ;------------------------------------------------------
0036 33A8 06A0  32         bl    @hchar
     33AA 27E6     
0037 33AC 0034                   byte 0,52,32,18           ; Remove markers
     33AE 2012     
0038 33B0 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     33B2 2033     
0039 33B4 FFFF                   data eol
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               tv.reset.exit:
0044 33B6 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 33B8 045B  20         b     *r11                  ; Return to caller
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
0020 33BA 0649  14         dect  stack
0021 33BC C64B  30         mov   r11,*stack            ; Save return address
0022 33BE 0649  14         dect  stack
0023 33C0 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 33C2 06A0  32         bl    @mknum                ; Convert unsigned number to string
     33C4 2AB4     
0028 33C6 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 33C8 A100                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 33CA 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 33CB   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 33CC 0204  20         li    tmp0,unpacked.string
     33CE A026     
0034 33D0 04F4  30         clr   *tmp0+                ; Clear string 01
0035 33D2 04F4  30         clr   *tmp0+                ; Clear string 23
0036 33D4 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 33D6 06A0  32         bl    @trimnum              ; Trim unsigned number string
     33D8 2B0C     
0039 33DA A100                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 33DC A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 33DE 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 33E0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 33E2 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 33E4 045B  20         b     *r11                  ; Return to caller
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
0024 33E6 0649  14         dect  stack
0025 33E8 C64B  30         mov   r11,*stack            ; Push return address
0026 33EA 0649  14         dect  stack
0027 33EC C644  30         mov   tmp0,*stack           ; Push tmp0
0028 33EE 0649  14         dect  stack
0029 33F0 C645  30         mov   tmp1,*stack           ; Push tmp1
0030 33F2 0649  14         dect  stack
0031 33F4 C646  30         mov   tmp2,*stack           ; Push tmp2
0032 33F6 0649  14         dect  stack
0033 33F8 C647  30         mov   tmp3,*stack           ; Push tmp3
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 33FA C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     33FC A000     
0038 33FE D194  26         movb  *tmp0,tmp2            ; /
0039 3400 0986  56         srl   tmp2,8                ; Right align
0040 3402 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0041               
0042 3404 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3406 A002     
0043 3408 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0044                       ;------------------------------------------------------
0045                       ; Copy string to buffer
0046                       ;------------------------------------------------------
0047 340A C120  34         mov   @parm1,tmp0           ; Get source address
     340C A000     
0048 340E C160  34         mov   @parm4,tmp1           ; Get destination address
     3410 A006     
0049 3412 0586  14         inc   tmp2                  ; Also include length-byte in copy
0050               
0051 3414 0649  14         dect  stack
0052 3416 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0053               
0054 3418 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     341A 24F4     
0055                                                   ; \ i  tmp0 = Source CPU memory address
0056                                                   ; | i  tmp1 = Target CPU memory address
0057                                                   ; / i  tmp2 = Number of bytes to copy
0058               
0059 341C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0060                       ;------------------------------------------------------
0061                       ; Set length of new string
0062                       ;------------------------------------------------------
0063 341E C120  34         mov   @parm2,tmp0           ; Get requested length
     3420 A002     
0064 3422 0A84  56         sla   tmp0,8                ; Left align
0065 3424 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3426 A006     
0066 3428 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0067 342A A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0068 342C 0585  14         inc   tmp1                  ; /
0069                       ;------------------------------------------------------
0070                       ; Prepare for padding string
0071                       ;------------------------------------------------------
0072 342E C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     3430 A002     
0073 3432 6187  18         s     tmp3,tmp2             ; |
0074 3434 0586  14         inc   tmp2                  ; /
0075               
0076 3436 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3438 A004     
0077 343A 0A84  56         sla   tmp0,8                ; Left align
0078                       ;------------------------------------------------------
0079                       ; Right-pad string to destination length
0080                       ;------------------------------------------------------
0081               tv.pad.string.loop:
0082 343C DD44  32         movb  tmp0,*tmp1+           ; Pad character
0083 343E 0606  14         dec   tmp2                  ; Update loop counter
0084 3440 15FD  14         jgt   tv.pad.string.loop    ; Next character
0085               
0086 3442 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3444 A006     
     3446 A010     
0087 3448 1004  14         jmp   tv.pad.string.exit    ; Exit
0088                       ;-----------------------------------------------------------------------
0089                       ; CPU crash
0090                       ;-----------------------------------------------------------------------
0091               tv.pad.string.panic:
0092 344A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     344C FFCE     
0093 344E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3450 2026     
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               tv.pad.string.exit:
0098 3452 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0099 3454 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 3456 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 3458 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 345A C2F9  30         mov   *stack+,r11           ; Pop r11
0103 345C 045B  20         b     *r11                  ; Return to caller
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
0022 345E 0649  14         dect  stack
0023 3460 C64B  30         mov   r11,*stack            ; Save return address
0024 3462 0649  14         dect  stack
0025 3464 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3466 0649  14         dect  stack
0027 3468 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 346A C120  34         mov   @parm1,tmp0           ; Get line number
     346C A000     
0032 346E C160  34         mov   @parm2,tmp1           ; Get pointer
     3470 A002     
0033 3472 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 3474 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     3476 0FFF     
0039 3478 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 347A 06E0  34         swpb  @parm3
     347C A004     
0044 347E D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     3480 A004     
0045 3482 06E0  34         swpb  @parm3                ; \ Restore original order again,
     3484 A004     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 3486 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3488 323A     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 348A C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     348C A010     
0056 348E C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     3490 B000     
0057 3492 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     3494 A010     
0058 3496 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 3498 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     349A 323A     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 349C C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     349E A010     
0068 34A0 04E4  34         clr   @idx.top(tmp0)        ; /
     34A2 B000     
0069 34A4 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     34A6 A010     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 34A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 34AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 34AC C2F9  30         mov   *stack+,r11           ; Pop r11
0077 34AE 045B  20         b     *r11                  ; Return to caller
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
0021 34B0 0649  14         dect  stack
0022 34B2 C64B  30         mov   r11,*stack            ; Save return address
0023 34B4 0649  14         dect  stack
0024 34B6 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 34B8 0649  14         dect  stack
0026 34BA C645  30         mov   tmp1,*stack           ; Push tmp1
0027 34BC 0649  14         dect  stack
0028 34BE C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 34C0 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     34C2 A000     
0033               
0034 34C4 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     34C6 323A     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 34C8 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     34CA A010     
0039 34CC C164  34         mov   @idx.top(tmp0),tmp1   ; /
     34CE B000     
0040               
0041 34D0 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 34D2 C185  18         mov   tmp1,tmp2             ; \
0047 34D4 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 34D6 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     34D8 00FF     
0052 34DA 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 34DC 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     34DE C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 34E0 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     34E2 A010     
0059 34E4 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     34E6 A012     
0060 34E8 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 34EA 04E0  34         clr   @outparm1
     34EC A010     
0066 34EE 04E0  34         clr   @outparm2
     34F0 A012     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 34F2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 34F4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 34F6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 34F8 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 34FA 045B  20         b     *r11                  ; Return to caller
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
0017 34FC 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     34FE B000     
0018 3500 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 3502 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 3504 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 3506 0606  14         dec   tmp2                  ; tmp2--
0026 3508 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 350A 045B  20         b     *r11                  ; Return to caller
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
0046 350C 0649  14         dect  stack
0047 350E C64B  30         mov   r11,*stack            ; Save return address
0048 3510 0649  14         dect  stack
0049 3512 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 3514 0649  14         dect  stack
0051 3516 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 3518 0649  14         dect  stack
0053 351A C646  30         mov   tmp2,*stack           ; Push tmp2
0054 351C 0649  14         dect  stack
0055 351E C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 3520 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     3522 A000     
0060               
0061 3524 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3526 323A     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 3528 C120  34         mov   @outparm1,tmp0        ; Index offset
     352A A010     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 352C C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     352E A002     
0070 3530 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 3532 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3534 A000     
0074 3536 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 3538 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     353A B000     
0081 353C 04D4  26         clr   *tmp0                 ; Clear index entry
0082 353E 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 3540 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     3542 A002     
0088 3544 0287  22         ci    tmp3,2048
     3546 0800     
0089 3548 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 354A 06A0  32         bl    @_idx.sams.mapcolumn.on
     354C 31CC     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 354E C120  34         mov   @parm1,tmp0           ; Restore line number
     3550 A000     
0103 3552 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 3554 06A0  32         bl    @_idx.entry.delete.reorg
     3556 34FC     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 3558 06A0  32         bl    @_idx.sams.mapcolumn.off
     355A 3200     
0111                                                   ; Restore memory window layout
0112               
0113 355C 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 355E 06A0  32         bl    @_idx.entry.delete.reorg
     3560 34FC     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 3562 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 3564 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 3566 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 3568 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 356A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 356C C2F9  30         mov   *stack+,r11           ; Pop r11
0132 356E 045B  20         b     *r11                  ; Return to caller
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
0017 3570 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     3572 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 3574 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 3576 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3578 FFCE     
0027 357A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     357C 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 357E 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     3580 B000     
0032 3582 C144  18         mov   tmp0,tmp1             ; a = current slot
0033 3584 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 3586 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 3588 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 358A 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 358C 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 358E A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 3590 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     3592 AFFC     
0043 3594 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 3596 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3598 FFCE     
0049 359A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     359C 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 359E C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 35A0 0644  14         dect  tmp0                  ; Move pointer up
0056 35A2 0645  14         dect  tmp1                  ; Move pointer up
0057 35A4 0606  14         dec   tmp2                  ; Next index entry
0058 35A6 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 35A8 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 35AA 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 35AC 045B  20         b     *r11                  ; Return to caller
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
0088 35AE 0649  14         dect  stack
0089 35B0 C64B  30         mov   r11,*stack            ; Save return address
0090 35B2 0649  14         dect  stack
0091 35B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 35B6 0649  14         dect  stack
0093 35B8 C645  30         mov   tmp1,*stack           ; Push tmp1
0094 35BA 0649  14         dect  stack
0095 35BC C646  30         mov   tmp2,*stack           ; Push tmp2
0096 35BE 0649  14         dect  stack
0097 35C0 C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 35C2 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     35C4 A002     
0102 35C6 61A0  34         s     @parm1,tmp2           ; Calculate loop
     35C8 A000     
0103 35CA 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 35CC C1E0  34         mov   @parm2,tmp3
     35CE A002     
0110 35D0 0287  22         ci    tmp3,2048
     35D2 0800     
0111 35D4 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 35D6 06A0  32         bl    @_idx.sams.mapcolumn.on
     35D8 31CC     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 35DA C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     35DC A002     
0123 35DE 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 35E0 06A0  32         bl    @_idx.entry.insert.reorg
     35E2 3570     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 35E4 06A0  32         bl    @_idx.sams.mapcolumn.off
     35E6 3200     
0131                                                   ; Restore memory window layout
0132               
0133 35E8 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 35EA C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     35EC A002     
0139               
0140 35EE 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     35F0 323A     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 35F2 C120  34         mov   @outparm1,tmp0        ; Index offset
     35F4 A010     
0145               
0146 35F6 06A0  32         bl    @_idx.entry.insert.reorg
     35F8 3570     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 35FA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 35FC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 35FE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 3600 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 3602 C2F9  30         mov   *stack+,r11           ; Pop r11
0160 3604 045B  20         b     *r11                  ; Return to caller
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
0021 3606 0649  14         dect  stack
0022 3608 C64B  30         mov   r11,*stack            ; Push return address
0023 360A 0649  14         dect  stack
0024 360C C644  30         mov   tmp0,*stack           ; Push tmp0
0025 360E 0649  14         dect  stack
0026 3610 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 3612 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     3614 A504     
0031 3616 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 3618 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     361A FFCE     
0037 361C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     361E 2026     
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 3620 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     3622 A000     
0043               
0044 3624 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     3626 34B0     
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 3628 C120  34         mov   @outparm2,tmp0        ; SAMS page
     362A A012     
0050 362C C160  34         mov   @outparm1,tmp1        ; Pointer to line
     362E A010     
0051 3630 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 3632 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     3634 A208     
0057 3636 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 3638 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     363A 258A     
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 363C C820  54         mov   @outparm2,@tv.sams.c000
     363E A012     
     3640 A208     
0066                                                   ; Set page in shadow registers
0067               
0068 3642 C820  54         mov   @outparm2,@edb.sams.page
     3644 A012     
     3646 A516     
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 3648 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 364A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 364C C2F9  30         mov   *stack+,r11           ; Pop r11
0077 364E 045B  20         b     *r11                  ; Return to caller
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
0021 3650 0649  14         dect  stack
0022 3652 C64B  30         mov   r11,*stack            ; Push return address
0023 3654 0649  14         dect  stack
0024 3656 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 3658 0649  14         dect  stack
0026 365A C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 365C 04E0  34         clr   @outparm1             ; Reset length
     365E A010     
0031 3660 04E0  34         clr   @outparm2             ; Reset SAMS bank
     3662 A012     
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 3664 C120  34         mov   @parm1,tmp0           ; \
     3666 A000     
0036 3668 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 366A 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     366C A504     
0039 366E 1101  14         jlt   !                     ; No, continue processing
0040 3670 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 3672 C120  34 !       mov   @parm1,tmp0           ; Get line
     3674 A000     
0046               
0047 3676 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     3678 3606     
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 367A C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     367C A010     
0053 367E 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 3680 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 3682 C805  38         mov   tmp1,@outparm1        ; Save length
     3684 A010     
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 3686 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     3688 0050     
0064 368A 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 368C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     368E FFCE     
0070 3690 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3692 2026     
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 3694 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     3696 A010     
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 3698 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 369A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 369C C2F9  30         mov   *stack+,r11           ; Pop r11
0083 369E 045B  20         b     *r11                  ; Return to caller
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
0103 36A0 0649  14         dect  stack
0104 36A2 C64B  30         mov   r11,*stack            ; Save return address
0105 36A4 0649  14         dect  stack
0106 36A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 36A8 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     36AA A304     
0111 36AC A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     36AE A306     
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 36B0 C804  38         mov   tmp0,@parm1
     36B2 A000     
0116 36B4 06A0  32         bl    @edb.line.getlength
     36B6 3650     
0117 36B8 C820  54         mov   @outparm1,@fb.row.length
     36BA A010     
     36BC A308     
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 36BE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 36C0 C2F9  30         mov   *stack+,r11           ; Pop R11
0125 36C2 045B  20         b     *r11                  ; Return to caller
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
0021 36C4 0649  14         dect  stack
0022 36C6 C64B  30         mov   r11,*stack            ; Push return address
0023 36C8 0649  14         dect  stack
0024 36CA C660  46         mov   @wyx,*stack           ; Push cursor position
     36CC 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 36CE 06A0  32         bl    @hchar
     36D0 27E6     
0029 36D2 0034                   byte 0,52,32,18
     36D4 2012     
0030 36D6 FFFF                   data EOL              ; Clear message
0031               
0032 36D8 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     36DA A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 36DC C839  50         mov   *stack+,@wyx          ; Pop cursor position
     36DE 832A     
0038 36E0 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 36E2 045B  20         b     *r11                  ; Return to task
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
0033 36E4 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     36E6 003F     
     36E8 0243     
     36EA 05F4     
     36EC 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 36EE 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     36F0 000C     
     36F2 0006     
     36F4 0007     
     36F6 0020     
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
0067 36F8 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     36FA 000C     
     36FC 0006     
     36FE 0007     
     3700 0020     
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
0098 3702 0000             data  >0000,>0001           ; Cursor
     3704 0001     
0099 3706 0000             data  >0000,>0101           ; Current line indicator     <
     3708 0101     
0100 370A 0820             data  >0820,>0201           ; Current column indicator   v
     370C 0201     
0101               nosprite:
0102 370E D000             data  >d000                 ; End-of-Sprites list
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
0157 3710 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     3712 F171     
     3714 1B1F     
     3716 71B1     
0158 3718 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     371A F0FF     
     371C 1F1A     
     371E F1FF     
0159 3720 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     3722 F0FF     
     3724 1F12     
     3726 F1F6     
0160 3728 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     372A 1E11     
     372C 1A17     
     372E 1E11     
0161 3730 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     3732 E1FF     
     3734 1F1E     
     3736 E1FF     
0162 3738 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     373A 1016     
     373C 1B71     
     373E 1711     
0163 3740 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3742 1011     
     3744 F1F1     
     3746 1F11     
0164 3748 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     374A A1FF     
     374C 1F1F     
     374E F11F     
0165 3750 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     3752 12FF     
     3754 1B12     
     3756 12FF     
0166 3758 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     375A E1FF     
     375C 1B1F     
     375E F131     
0167                       even
0168               
0169               tv.tabs.table:
0170 3760 0007             byte  0,7,12,25               ; \   Default tab positions as used
     3762 0C19     
0171 3764 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     3766 3B4F     
0172 3768 FF00             byte  >ff,0,0,0               ; |
     376A 0000     
0173 376C 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     376E 0000     
0174 3770 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     3772 0000     
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
0009 3774 01               byte  1
0010 3775   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 3776 05               byte  5
0015 3777   20             text  '  BOT'
     3778 2042     
     377A 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 377C 03               byte  3
0020 377D   4F             text  'OVR'
     377E 5652     
0021                       even
0022               
0023               txt.insert
0024 3780 03               byte  3
0025 3781   49             text  'INS'
     3782 4E53     
0026                       even
0027               
0028               txt.star
0029 3784 01               byte  1
0030 3785   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 3786 0A               byte  10
0035 3787   4C             text  'Loading...'
     3788 6F61     
     378A 6469     
     378C 6E67     
     378E 2E2E     
     3790 2E       
0036                       even
0037               
0038               txt.saving
0039 3792 0A               byte  10
0040 3793   53             text  'Saving....'
     3794 6176     
     3796 696E     
     3798 672E     
     379A 2E2E     
     379C 2E       
0041                       even
0042               
0043               txt.printing
0044 379E 12               byte  18
0045 379F   50             text  'Printing file.....'
     37A0 7269     
     37A2 6E74     
     37A4 696E     
     37A6 6720     
     37A8 6669     
     37AA 6C65     
     37AC 2E2E     
     37AE 2E2E     
     37B0 2E       
0046                       even
0047               
0048               txt.block.del
0049 37B2 12               byte  18
0050 37B3   44             text  'Deleting block....'
     37B4 656C     
     37B6 6574     
     37B8 696E     
     37BA 6720     
     37BC 626C     
     37BE 6F63     
     37C0 6B2E     
     37C2 2E2E     
     37C4 2E       
0051                       even
0052               
0053               txt.block.copy
0054 37C6 11               byte  17
0055 37C7   43             text  'Copying block....'
     37C8 6F70     
     37CA 7969     
     37CC 6E67     
     37CE 2062     
     37D0 6C6F     
     37D2 636B     
     37D4 2E2E     
     37D6 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 37D8 10               byte  16
0060 37D9   4D             text  'Moving block....'
     37DA 6F76     
     37DC 696E     
     37DE 6720     
     37E0 626C     
     37E2 6F63     
     37E4 6B2E     
     37E6 2E2E     
     37E8 2E       
0061                       even
0062               
0063               txt.block.save
0064 37EA 18               byte  24
0065 37EB   53             text  'Saving block to file....'
     37EC 6176     
     37EE 696E     
     37F0 6720     
     37F2 626C     
     37F4 6F63     
     37F6 6B20     
     37F8 746F     
     37FA 2066     
     37FC 696C     
     37FE 652E     
     3800 2E2E     
     3802 2E       
0066                       even
0067               
0068               txt.block.clip
0069 3804 18               byte  24
0070 3805   43             text  'Copying to clipboard....'
     3806 6F70     
     3808 7969     
     380A 6E67     
     380C 2074     
     380E 6F20     
     3810 636C     
     3812 6970     
     3814 626F     
     3816 6172     
     3818 642E     
     381A 2E2E     
     381C 2E       
0071                       even
0072               
0073               txt.block.print
0074 381E 12               byte  18
0075 381F   50             text  'Printing block....'
     3820 7269     
     3822 6E74     
     3824 696E     
     3826 6720     
     3828 626C     
     382A 6F63     
     382C 6B2E     
     382E 2E2E     
     3830 2E       
0076                       even
0077               
0078               txt.clearmem
0079 3832 13               byte  19
0080 3833   43             text  'Clearing memory....'
     3834 6C65     
     3836 6172     
     3838 696E     
     383A 6720     
     383C 6D65     
     383E 6D6F     
     3840 7279     
     3842 2E2E     
     3844 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 3846 0E               byte  14
0085 3847   4C             text  'Load completed'
     3848 6F61     
     384A 6420     
     384C 636F     
     384E 6D70     
     3850 6C65     
     3852 7465     
     3854 64       
0086                       even
0087               
0088               txt.done.insert
0089 3856 10               byte  16
0090 3857   49             text  'Insert completed'
     3858 6E73     
     385A 6572     
     385C 7420     
     385E 636F     
     3860 6D70     
     3862 6C65     
     3864 7465     
     3866 64       
0091                       even
0092               
0093               txt.done.append
0094 3868 10               byte  16
0095 3869   41             text  'Append completed'
     386A 7070     
     386C 656E     
     386E 6420     
     3870 636F     
     3872 6D70     
     3874 6C65     
     3876 7465     
     3878 64       
0096                       even
0097               
0098               txt.done.save
0099 387A 0E               byte  14
0100 387B   53             text  'Save completed'
     387C 6176     
     387E 6520     
     3880 636F     
     3882 6D70     
     3884 6C65     
     3886 7465     
     3888 64       
0101                       even
0102               
0103               txt.done.copy
0104 388A 0E               byte  14
0105 388B   43             text  'Copy completed'
     388C 6F70     
     388E 7920     
     3890 636F     
     3892 6D70     
     3894 6C65     
     3896 7465     
     3898 64       
0106                       even
0107               
0108               txt.done.print
0109 389A 0F               byte  15
0110 389B   50             text  'Print completed'
     389C 7269     
     389E 6E74     
     38A0 2063     
     38A2 6F6D     
     38A4 706C     
     38A6 6574     
     38A8 6564     
0111                       even
0112               
0113               txt.done.delete
0114 38AA 10               byte  16
0115 38AB   44             text  'Delete completed'
     38AC 656C     
     38AE 6574     
     38B0 6520     
     38B2 636F     
     38B4 6D70     
     38B6 6C65     
     38B8 7465     
     38BA 64       
0116                       even
0117               
0118               txt.done.clipboard
0119 38BC 0F               byte  15
0120 38BD   43             text  'Clipboard saved'
     38BE 6C69     
     38C0 7062     
     38C2 6F61     
     38C4 7264     
     38C6 2073     
     38C8 6176     
     38CA 6564     
0121                       even
0122               
0123               txt.done.clipdev
0124 38CC 0D               byte  13
0125 38CD   43             text  'Clipboard set'
     38CE 6C69     
     38D0 7062     
     38D2 6F61     
     38D4 7264     
     38D6 2073     
     38D8 6574     
0126                       even
0127               
0128               txt.fastmode
0129 38DA 08               byte  8
0130 38DB   46             text  'Fastmode'
     38DC 6173     
     38DE 746D     
     38E0 6F64     
     38E2 65       
0131                       even
0132               
0133               txt.kb
0134 38E4 02               byte  2
0135 38E5   6B             text  'kb'
     38E6 62       
0136                       even
0137               
0138               txt.lines
0139 38E8 05               byte  5
0140 38E9   4C             text  'Lines'
     38EA 696E     
     38EC 6573     
0141                       even
0142               
0143               txt.newfile
0144 38EE 0A               byte  10
0145 38EF   5B             text  '[New file]'
     38F0 4E65     
     38F2 7720     
     38F4 6669     
     38F6 6C65     
     38F8 5D       
0146                       even
0147               
0148               txt.filetype.dv80
0149 38FA 04               byte  4
0150 38FB   44             text  'DV80'
     38FC 5638     
     38FE 30       
0151                       even
0152               
0153               txt.m1
0154 3900 03               byte  3
0155 3901   4D             text  'M1='
     3902 313D     
0156                       even
0157               
0158               txt.m2
0159 3904 03               byte  3
0160 3905   4D             text  'M2='
     3906 323D     
0161                       even
0162               
0163               txt.keys.default
0164 3908 07               byte  7
0165 3909   46             text  'F9-Menu'
     390A 392D     
     390C 4D65     
     390E 6E75     
0166                       even
0167               
0168               txt.keys.block
0169 3910 36               byte  54
0170 3911   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     3912 392D     
     3914 4261     
     3916 636B     
     3918 2020     
     391A 5E43     
     391C 6F70     
     391E 7920     
     3920 205E     
     3922 4D6F     
     3924 7665     
     3926 2020     
     3928 5E44     
     392A 656C     
     392C 2020     
     392E 5E53     
     3930 6176     
     3932 6520     
     3934 205E     
     3936 5072     
     3938 696E     
     393A 7420     
     393C 205E     
     393E 5B31     
     3940 2D35     
     3942 5D43     
     3944 6C69     
     3946 70       
0171                       even
0172               
0173 3948 2E2E     txt.ruler          text    '.........'
     394A 2E2E     
     394C 2E2E     
     394E 2E2E     
     3950 2E       
0174 3951   12                        byte    18
0175 3952 2E2E                        text    '.........'
     3954 2E2E     
     3956 2E2E     
     3958 2E2E     
     395A 2E       
0176 395B   13                        byte    19
0177 395C 2E2E                        text    '.........'
     395E 2E2E     
     3960 2E2E     
     3962 2E2E     
     3964 2E       
0178 3965   14                        byte    20
0179 3966 2E2E                        text    '.........'
     3968 2E2E     
     396A 2E2E     
     396C 2E2E     
     396E 2E       
0180 396F   15                        byte    21
0181 3970 2E2E                        text    '.........'
     3972 2E2E     
     3974 2E2E     
     3976 2E2E     
     3978 2E       
0182 3979   16                        byte    22
0183 397A 2E2E                        text    '.........'
     397C 2E2E     
     397E 2E2E     
     3980 2E2E     
     3982 2E       
0184 3983   17                        byte    23
0185 3984 2E2E                        text    '.........'
     3986 2E2E     
     3988 2E2E     
     398A 2E2E     
     398C 2E       
0186 398D   18                        byte    24
0187 398E 2E2E                        text    '.........'
     3990 2E2E     
     3992 2E2E     
     3994 2E2E     
     3996 2E       
0188 3997   19                        byte    25
0189                                  even
0190 3998 020E     txt.alpha.down     data >020e,>0f00
     399A 0F00     
0191 399C 0110     txt.vertline       data >0110
0192 399E 011C     txt.keymarker      byte 1,28
0193               
0194               txt.ws1
0195 39A0 01               byte  1
0196 39A1   20             text  ' '
0197                       even
0198               
0199               txt.ws2
0200 39A2 02               byte  2
0201 39A3   20             text  '  '
     39A4 20       
0202                       even
0203               
0204               txt.ws3
0205 39A6 03               byte  3
0206 39A7   20             text  '   '
     39A8 2020     
0207                       even
0208               
0209               txt.ws4
0210 39AA 04               byte  4
0211 39AB   20             text  '    '
     39AC 2020     
     39AE 20       
0212                       even
0213               
0214               txt.ws5
0215 39B0 05               byte  5
0216 39B1   20             text  '     '
     39B2 2020     
     39B4 2020     
0217                       even
0218               
0219      39AA     txt.filetype.none  equ txt.ws4
0220               
0221               
0222               ;--------------------------------------------------------------
0223               ; Strings for error line pane
0224               ;--------------------------------------------------------------
0225               txt.ioerr.load
0226 39B6 15               byte  21
0227 39B7   46             text  'Failed loading file: '
     39B8 6169     
     39BA 6C65     
     39BC 6420     
     39BE 6C6F     
     39C0 6164     
     39C2 696E     
     39C4 6720     
     39C6 6669     
     39C8 6C65     
     39CA 3A20     
0228                       even
0229               
0230               txt.ioerr.save
0231 39CC 14               byte  20
0232 39CD   46             text  'Failed saving file: '
     39CE 6169     
     39D0 6C65     
     39D2 6420     
     39D4 7361     
     39D6 7669     
     39D8 6E67     
     39DA 2066     
     39DC 696C     
     39DE 653A     
     39E0 20       
0233                       even
0234               
0235               txt.ioerr.print
0236 39E2 1B               byte  27
0237 39E3   46             text  'Failed printing to device: '
     39E4 6169     
     39E6 6C65     
     39E8 6420     
     39EA 7072     
     39EC 696E     
     39EE 7469     
     39F0 6E67     
     39F2 2074     
     39F4 6F20     
     39F6 6465     
     39F8 7669     
     39FA 6365     
     39FC 3A20     
0238                       even
0239               
0240               txt.io.nofile
0241 39FE 16               byte  22
0242 39FF   4E             text  'No filename specified.'
     3A00 6F20     
     3A02 6669     
     3A04 6C65     
     3A06 6E61     
     3A08 6D65     
     3A0A 2073     
     3A0C 7065     
     3A0E 6369     
     3A10 6669     
     3A12 6564     
     3A14 2E       
0243                       even
0244               
0245               txt.memfull.load
0246 3A16 2D               byte  45
0247 3A17   49             text  'Index full. File too large for editor buffer.'
     3A18 6E64     
     3A1A 6578     
     3A1C 2066     
     3A1E 756C     
     3A20 6C2E     
     3A22 2046     
     3A24 696C     
     3A26 6520     
     3A28 746F     
     3A2A 6F20     
     3A2C 6C61     
     3A2E 7267     
     3A30 6520     
     3A32 666F     
     3A34 7220     
     3A36 6564     
     3A38 6974     
     3A3A 6F72     
     3A3C 2062     
     3A3E 7566     
     3A40 6665     
     3A42 722E     
0248                       even
0249               
0250               txt.block.inside
0251 3A44 2D               byte  45
0252 3A45   43             text  'Copy/Move target must be outside M1-M2 range.'
     3A46 6F70     
     3A48 792F     
     3A4A 4D6F     
     3A4C 7665     
     3A4E 2074     
     3A50 6172     
     3A52 6765     
     3A54 7420     
     3A56 6D75     
     3A58 7374     
     3A5A 2062     
     3A5C 6520     
     3A5E 6F75     
     3A60 7473     
     3A62 6964     
     3A64 6520     
     3A66 4D31     
     3A68 2D4D     
     3A6A 3220     
     3A6C 7261     
     3A6E 6E67     
     3A70 652E     
0253                       even
0254               
0255               
0256               ;--------------------------------------------------------------
0257               ; Strings for command buffer
0258               ;--------------------------------------------------------------
0259               txt.cmdb.prompt
0260 3A72 01               byte  1
0261 3A73   3E             text  '>'
0262                       even
0263               
0264               txt.colorscheme
0265 3A74 0D               byte  13
0266 3A75   43             text  'Color scheme:'
     3A76 6F6C     
     3A78 6F72     
     3A7A 2073     
     3A7C 6368     
     3A7E 656D     
     3A80 653A     
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
0008 3A82 06               byte  6
0009 3A83   50             text  'PI.PIO'
     3A84 492E     
     3A86 5049     
     3A88 4F       
0010                       even
0011               
0012               def.clip.fname
0013 3A8A 09               byte  9
0014 3A8B   44             text  'DSK1.CLIP'
     3A8C 534B     
     3A8E 312E     
     3A90 434C     
     3A92 4950     
0015                       even
0016               
0017               def.clip.fname.b
0018 3A94 09               byte  9
0019 3A95   44             text  'DSK2.CLIP'
     3A96 534B     
     3A98 322E     
     3A9A 434C     
     3A9C 4950     
0020                       even
0021               
0022               def.clip.fname.c
0023 3A9E 09               byte  9
0024 3A9F   54             text  'TIPI.CLIP'
     3AA0 4950     
     3AA2 492E     
     3AA4 434C     
     3AA6 4950     
0025                       even
0026               
0027               def.devices
0028 3AA8 2F               byte  47
0029 3AA9   2C             text  ',DSK,HDX,IDE,PI.,PIO,TIPI.,RD,SCS,SDD,WDS,RS232'
     3AAA 4453     
     3AAC 4B2C     
     3AAE 4844     
     3AB0 582C     
     3AB2 4944     
     3AB4 452C     
     3AB6 5049     
     3AB8 2E2C     
     3ABA 5049     
     3ABC 4F2C     
     3ABE 5449     
     3AC0 5049     
     3AC2 2E2C     
     3AC4 5244     
     3AC6 2C53     
     3AC8 4353     
     3ACA 2C53     
     3ACC 4444     
     3ACE 2C57     
     3AD0 4453     
     3AD2 2C52     
     3AD4 5332     
     3AD6 3332     
0030                       even
0031               
                   < ram.resident.asm
                   < stevie_b1.asm.31063
0038                       ;------------------------------------------------------
0039                       ; Activate bank 1 and branch to  >6036
0040                       ;------------------------------------------------------
0041 3AD8 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3ADA 6002     
0042               
0046               
0047 3ADC 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3ADE 6046     
0048               ***************************************************************
0049               * Step 3: Include main editor modules
0050               ********|*****|*********************|**************************
0051               main:
0052                       aorg  kickstart.code2       ; >6046
0053 6046 0460  28         b     @main.stevie          ; Start editor
     6048 604A     
0054                       ;-----------------------------------------------------------------------
0055                       ; Include files
0056                       ;-----------------------------------------------------------------------
0057                       copy  "main.asm"                    ; Main file (entrypoint)
     **** ****     > main.asm
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
0028 604A 20A0  38         coc   @wbit1,config         ; F18a detected?
     604C 201E     
0029 604E 1301  14         jeq   main.continue
0030 6050 1000  14         nop                         ; Ignore for now if no f18a detected
0031               
0032               main.continue:
0033                       ;------------------------------------------------------
0034                       ; Setup F18A VDP
0035                       ;------------------------------------------------------
0036 6052 06A0  32         bl    @mute                 ; Turn sound generators off
     6054 280E     
0037 6056 06A0  32         bl    @scroff               ; Turn screen off
     6058 269A     
0038               
0039 605A 06A0  32         bl    @f18unl               ; Unlock the F18a
     605C 273E     
0040               
0042               
0043 605E 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6060 2346     
0044 6062 3140                   data >3140            ; F18a VR49 (>31), bit 40
0045               
0047               
0048 6064 06A0  32         bl    @putvr                ; Turn on position based attributes
     6066 2346     
0049 6068 3202                   data >3202            ; F18a VR50 (>32), bit 2
0050               
0051 606A 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     606C 2346     
0052 606E 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0053                       ;------------------------------------------------------
0054                       ; Clear screen (VDP SIT)
0055                       ;------------------------------------------------------
0056 6070 06A0  32         bl    @filv
     6072 22A2     
0057 6074 0000                   data >0000,32,vdp.sit.size
     6076 0020     
     6078 0960     
0058                                                   ; Clear screen
0059                       ;------------------------------------------------------
0060                       ; Initialize high memory expansion
0061                       ;------------------------------------------------------
0062 607A 06A0  32         bl    @film
     607C 224A     
0063 607E A000                   data >a000,00,20000   ; Clear a000-eedf
     6080 0000     
     6082 4E20     
0064                       ;------------------------------------------------------
0065                       ; Setup cursor, screen, etc.
0066                       ;------------------------------------------------------
0067 6084 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6086 26BA     
0068 6088 06A0  32         bl    @s8x8                 ; Small sprite
     608A 26CA     
0069               
0070 608C 06A0  32         bl    @cpym2m
     608E 24EE     
0071 6090 3702                   data romsat,ramsat,14 ; Load sprite SAT
     6092 A03C     
     6094 000E     
0072               
0073 6096 C820  54         mov   @romsat+2,@tv.curshape
     6098 3704     
     609A A214     
0074                                                   ; Save cursor shape & color
0075               
0076 609C 06A0  32         bl    @vdp.patterns.dump    ; Load sprite and character patterns
     609E 7B2C     
0077               *--------------------------------------------------------------
0078               * Initialize
0079               *--------------------------------------------------------------
0080 60A0 06A0  32         bl    @mem.sams.setup.stevie
     60A2 60F2     
0081                                                   ; Load SAMS pages for stevie
0082               
0083 60A4 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A6 333C     
0084 60A8 06A0  32         bl    @tv.reset             ; Reset editor
     60AA 3390     
0085                       ;------------------------------------------------------
0086                       ; Load colorscheme amd turn on screen
0087                       ;------------------------------------------------------
0088 60AC 04E0  34         clr   @parm1                ; Screen off while reloading color scheme
     60AE A000     
0089 60B0 04E0  34         clr   @parm2                ; Don't skip colorizing marked lines
     60B2 A002     
0090 60B4 04E0  34         clr   @parm3                ; Colorize all panes
     60B6 A004     
0091               
0092 60B8 06A0  32         bl    @pane.action.colorscheme.load
     60BA 72AA     
0093                                                   ; Reload color scheme
0094                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0095                                                   ; | i  @parm2 = Skip colorizing marked lines
0096                                                   ; |             if >FFFF
0097                                                   ; | i  @parm3 = Only colorize CMDB pane
0098                                                   ; /             if >FFFF
0099                       ;-------------------------------------------------------
0100                       ; Setup editor tasks & hook
0101                       ;-------------------------------------------------------
0102 60BC 0204  20         li    tmp0,>0300
     60BE 0300     
0103 60C0 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60C2 8314     
0104               
0105 60C4 06A0  32         bl    @at
     60C6 26DA     
0106 60C8 0000                   data  >0000           ; Cursor YX position = >0000
0107               
0108 60CA 0204  20         li    tmp0,timers
     60CC A04A     
0109 60CE C804  38         mov   tmp0,@wtitab
     60D0 832C     
0110               
0112               
0113 60D2 06A0  32         bl    @mkslot
     60D4 2F9A     
0114 60D6 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60D8 7162     
0115 60DA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60DC 7170     
0116 60DE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60E0 7212     
0117 60E2 0360                   data >0360,task.oneshot      ; Task 3 - One shot task
     60E4 7240     
0118 60E6 FFFF                   data eol
0119               
0129               
0130               
0131 60E8 06A0  32         bl    @mkhook
     60EA 2F86     
0132 60EC 710C                   data hook.keyscan     ; Setup user hook
0133               
0134 60EE 0460  28         b     @tmgr                 ; Start timers and kthread
     60F0 2ED2     
                   < stevie_b1.asm.31063
0058                       ;-----------------------------------------------------------------------
0059                       ; Low-level modules
0060                       ;-----------------------------------------------------------------------
0061                       copy  "mem.sams.setup.asm"          ; SAMS memory setup for Stevie
     **** ****     > mem.sams.setup.asm
0001               * FILE......: mem.sams.setup.asm
0002               * Purpose...: SAMS Memory setup for Stevie
0003               
0004               ***************************************************************
0005               * mem.sams.setup.stevie
0006               * Setup SAMS memory pages for Stevie
0007               ***************************************************************
0008               * bl  @mem.sams.setup.stevie
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ***************************************************************
0016               mem.sams.setup.stevie:
0017 60F2 0649  14         dect  stack
0018 60F4 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 60F6 06A0  32         bl    @mem.sams.set.boot    ; Set SAMS banks in boot for Stevie
     60F8 7B92     
0023               
0024 60FA 06A0  32         bl    @sams.layout.copy
     60FC 2652     
0025 60FE A200                   data tv.sams.2000     ; Copy SAMS bank ID to shadow table.
0026               
0027 6100 C820  54         mov   @tv.sams.c000,@edb.sams.page
     6102 A208     
     6104 A516     
0028 6106 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     6108 A516     
     610A A518     
0029                                                   ; Track editor buffer SAMS page
0030                       ;------------------------------------------------------
0031                       ; Exit
0032                       ;------------------------------------------------------
0033               mem.sams.setup.stevie.exit:
0034 610C C2F9  30         mov   *stack+,r11           ; Pop r11
0035 610E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0062                       ;-----------------------------------------------------------------------
0063                       ; Keyboard actions
0064                       ;-----------------------------------------------------------------------
0065                       copy  "edkey.key.process.asm"       ; Process keyboard actions
     **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               ****************************************************************
0005               * Editor - Process action keys
0006               ****************************************************************
0007               edkey.key.process:
0008 6110 C160  34         mov   @waux1,tmp1           ; \
     6112 833C     
0009 6114 0245  22         andi  tmp1,>ff00            ; | Get key value and clear LSB
     6116 FF00     
0010 6118 C805  38         mov   tmp1,@waux1           ; /
     611A 833C     
0011 611C 0707  14         seto  tmp3                  ; EOL marker
0012                       ;-------------------------------------------------------
0013                       ; Process key depending on pane with focus
0014                       ;-------------------------------------------------------
0015 611E C1A0  34         mov   @tv.pane.focus,tmp2
     6120 A222     
0016 6122 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     6124 0000     
0017 6126 1307  14         jeq   edkey.key.process.loadmap.editor
0018                                                   ; Yes, so load editor keymap
0019               
0020 6128 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     612A 0001     
0021 612C 1307  14         jeq   edkey.key.process.loadmap.cmdb
0022                                                   ; Yes, so load CMDB keymap
0023                       ;-------------------------------------------------------
0024                       ; Pane without focus, crash
0025                       ;-------------------------------------------------------
0026 612E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6130 FFCE     
0027 6132 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     6134 2026     
0028                       ;-------------------------------------------------------
0029                       ; Load Editor keyboard map
0030                       ;-------------------------------------------------------
0031               edkey.key.process.loadmap.editor:
0032 6136 0206  20         li    tmp2,keymap_actions.editor
     6138 7BB6     
0033 613A 1002  14         jmp   edkey.key.check.next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 613C 0206  20         li    tmp2,keymap_actions.cmdb
     613E 7C80     
0039                       ;-------------------------------------------------------
0040                       ; Iterate over keyboard map for matching action key
0041                       ;-------------------------------------------------------
0042               edkey.key.check.next:
0043 6140 91D6  26         cb    *tmp2,tmp3            ; EOL reached ?
0044 6142 1327  14         jeq   edkey.key.process.addbuffer
0045                                                   ; Yes, means no action key pressed,
0046                                                   ; so add character to buffer
0047                       ;-------------------------------------------------------
0048                       ; Check for action key match
0049                       ;-------------------------------------------------------
0050 6144 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0051 6146 130F  14         jeq   edkey.key.check.scope
0052                                                   ; Yes, check scope
0053                       ;-------------------------------------------------------
0054                       ; If key in range 'a..z' then also check 'A..Z'
0055                       ;-------------------------------------------------------
0056 6148 0285  22         ci    tmp1,>6100            ; ASCII 97 'a'
     614A 6100     
0057 614C 1109  14         jlt   edkey.key.check.next.entry
0058               
0059 614E 0285  22         ci    tmp1,>7a00            ; ASCII 122 'z'
     6150 7A00     
0060 6152 1506  14         jgt   edkey.key.check.next.entry
0061               
0062 6154 0225  22         ai    tmp1,->2000           ; Make uppercase
     6156 E000     
0063 6158 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0064 615A 1305  14         jeq   edkey.key.check.scope
0065                                                   ; Yes, check scope
0066                       ;-------------------------------------------------------
0067                       ; Key is no action key, keep case for later (buffer)
0068                       ;-------------------------------------------------------
0069 615C 0225  22         ai    tmp1,>2000            ; Make lowercase
     615E 2000     
0070               
0071               edkey.key.check.next.entry:
0072 6160 0226  22         ai    tmp2,4                ; Skip current entry
     6162 0004     
0073 6164 10ED  14         jmp   edkey.key.check.next  ; Check next entry
0074                       ;-------------------------------------------------------
0075                       ; Check scope of key
0076                       ;-------------------------------------------------------
0077               edkey.key.check.scope:
0078 6166 0586  14         inc   tmp2                  ; Move to scope
0079 6168 9816  46         cb    *tmp2,@tv.pane.focus+1
     616A A223     
0080                                                   ; (1) Process key if scope matches pane
0081 616C 1308  14         jeq   edkey.key.process.action
0082               
0083 616E 9816  46         cb    *tmp2,@cmdb.dialog+1  ; (2) Process key if scope matches dialog
     6170 A71B     
0084 6172 1305  14         jeq   edkey.key.process.action
0085                       ;-------------------------------------------------------
0086                       ; Key pressed outside valid scope, ignore action entry
0087                       ;-------------------------------------------------------
0088 6174 0226  22         ai    tmp2,3                ; Skip current entry
     6176 0003     
0089 6178 C160  34         mov   @waux1,tmp1           ; Restore original case of key
     617A 833C     
0090 617C 10E1  14         jmp   edkey.key.check.next  ; Process next action entry
0091                       ;-------------------------------------------------------
0092                       ; Trigger keyboard action
0093                       ;-------------------------------------------------------
0094               edkey.key.process.action:
0095 617E 0586  14         inc   tmp2                  ; Move to action address
0096 6180 C196  26         mov   *tmp2,tmp2            ; Get action address
0097               
0098 6182 0204  20         li    tmp0,id.dialog.unsaved
     6184 0065     
0099 6186 8120  34         c     @cmdb.dialog,tmp0
     6188 A71A     
0100 618A 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0101               
0102 618C C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     618E A726     
0103 6190 0456  20 !       b     *tmp2                 ; Process key action
0104                       ;-------------------------------------------------------
0105                       ; Add character to editor or cmdb buffer
0106                       ;-------------------------------------------------------
0107               edkey.key.process.addbuffer:
0108 6192 C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     6194 A222     
0109 6196 1602  14         jne   !                     ; No, skip frame buffer
0110 6198 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     619A 6684     
0111                       ;-------------------------------------------------------
0112                       ; CMDB buffer
0113                       ;-------------------------------------------------------
0114 619C 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     619E 0001     
0115 61A0 1607  14         jne   edkey.key.process.crash
0116                                                   ; No, crash
0117                       ;-------------------------------------------------------
0118                       ; Don't add character if dialog has ID >= 100
0119                       ;-------------------------------------------------------
0120 61A2 C120  34         mov   @cmdb.dialog,tmp0
     61A4 A71A     
0121 61A6 0284  22         ci    tmp0,99
     61A8 0063     
0122 61AA 1506  14         jgt   edkey.key.process.exit
0123                       ;-------------------------------------------------------
0124                       ; Add character to CMDB
0125                       ;-------------------------------------------------------
0126 61AC 0460  28         b     @edkey.action.cmdb.char
     61AE 6900     
0127                                                   ; Add character to CMDB buffer
0128                       ;-------------------------------------------------------
0129                       ; Crash
0130                       ;-------------------------------------------------------
0131               edkey.key.process.crash:
0132 61B0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     61B2 FFCE     
0133 61B4 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     61B6 2026     
0134                       ;-------------------------------------------------------
0135                       ; Exit
0136                       ;-------------------------------------------------------
0137               edkey.key.process.exit:
0138 61B8 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     61BA 7156     
                   < stevie_b1.asm.31063
0066                       ;-----------------------------------------------------------------------
0067                       ; Keyboard actions - Framebuffer (1)
0068                       ;-----------------------------------------------------------------------
0069                       copy  "edkey.fb.mov.leftright.asm"  ; Move left / right / home / end
     **** ****     > edkey.fb.mov.leftright.asm
0001               * FILE......: edkey.fb.mov.leftright.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.left:
0008 61BC C120  34         mov   @fb.column,tmp0
     61BE A30C     
0009 61C0 1308  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 61C2 0620  34         dec   @fb.column            ; Column-- in screen buffer
     61C4 A30C     
0014 61C6 0620  34         dec   @wyx                  ; Column-- VDP cursor
     61C8 832A     
0015 61CA 0620  34         dec   @fb.current
     61CC A302     
0016 61CE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61D0 A318     
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 61D2 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61D4 7156     
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 61D6 8820  54         c     @fb.column,@fb.row.length
     61D8 A30C     
     61DA A308     
0028 61DC 1408  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 61DE 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     61E0 A30C     
0033 61E2 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     61E4 832A     
0034 61E6 05A0  34         inc   @fb.current
     61E8 A302     
0035 61EA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61EC A318     
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039 61EE 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61F0 7156     
0040               
0041               
0042               *---------------------------------------------------------------
0043               * Cursor beginning of line
0044               *---------------------------------------------------------------
0045               edkey.action.home:
0046 61F2 06A0  32         bl    @fb.cursor.home       ; Move cursor to beginning of line
     61F4 6DC4     
0047                       ;-------------------------------------------------------
0048                       ; Exit
0049                       ;-------------------------------------------------------
0050 61F6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61F8 7156     
0051               
0052               
0053               *---------------------------------------------------------------
0054               * Cursor end of line
0055               *---------------------------------------------------------------
0056               edkey.action.end:
0057 61FA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61FC A318     
0058 61FE C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     6200 A308     
0059 6202 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     6204 0050     
0060 6206 1102  14         jlt   !                     ; | is right of last character on line,
0061 6208 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     620A 004F     
0062                       ;-------------------------------------------------------
0063                       ; Set cursor X position
0064                       ;-------------------------------------------------------
0065 620C C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     620E A30C     
0066 6210 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6212 26F2     
0067 6214 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6216 6CC6     
0068                       ;-------------------------------------------------------
0069                       ; Exit
0070                       ;-------------------------------------------------------
0071 6218 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     621A 7156     
                   < stevie_b1.asm.31063
0070                       copy  "edkey.fb.mov.word.asm"       ; Move previous / next word
     **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 621C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     621E A318     
0009 6220 C120  34         mov   @fb.column,tmp0
     6222 A30C     
0010 6224 1322  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 6226 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6228 A302     
0015 622A 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 622C 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 622E 0605  14         dec   tmp1
0022 6230 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 6232 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 6234 D195  26         movb  *tmp1,tmp2            ; Get character
0030 6236 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 6238 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 623A 0986  56         srl   tmp2,8                ; Right justify
0033 623C 0286  22         ci    tmp2,32               ; Space character found?
     623E 0020     
0034 6240 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 6242 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6244 2020     
0040 6246 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 6248 0287  22         ci    tmp3,>20ff            ; First character is space
     624A 20FF     
0043 624C 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 624E C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6250 A30C     
0048 6252 61C4  18         s     tmp0,tmp3
0049 6254 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     6256 0002     
0050 6258 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 625A 0585  14         inc   tmp1
0056 625C 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 625E C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6260 A30C     
0062 6262 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6264 26F2     
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 6266 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6268 6CC6     
0068 626A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     626C 7156     
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 626E 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6270 A318     
0077 6272 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 6274 C120  34         mov   @fb.column,tmp0
     6276 A30C     
0079 6278 8804  38         c     tmp0,@fb.row.length
     627A A308     
0080 627C 1426  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 627E C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6280 A302     
0085 6282 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 6284 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 6286 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 6288 0585  14         inc   tmp1
0097 628A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 628C 8804  38         c     tmp0,@fb.row.length
     628E A308     
0099 6290 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 6292 D195  26         movb  *tmp1,tmp2            ; Get character
0106 6294 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 6296 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 6298 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 629A 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     629C FFFF     
0111 629E 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 62A0 0286  22         ci    tmp2,32
     62A2 0020     
0117 62A4 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 62A6 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 62A8 0286  22         ci    tmp2,32               ; Space character found?
     62AA 0020     
0125 62AC 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 62AE 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     62B0 2020     
0131 62B2 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 62B4 0287  22         ci    tmp3,>20ff            ; First characer is space?
     62B6 20FF     
0134 62B8 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 62BA 0585  14         inc   tmp1
0139 62BC 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 62BE C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     62C0 A30C     
0145 62C2 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62C4 26F2     
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 62C6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62C8 6CC6     
0151 62CA 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62CC 7156     
0152               
0153               
                   < stevie_b1.asm.31063
0071                       copy  "edkey.fb.mov.updown.asm"     ; Move line up / down
     **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 62CE 06A0  32         bl    @fb.cursor.up         ; Move cursor up
     62D0 6CEE     
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012               edkey.action.up.exit:
0013 62D2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62D4 7156     
0014               
0015               
0016               
0017               *---------------------------------------------------------------
0018               * Cursor down
0019               *---------------------------------------------------------------
0020               edkey.action.down:
0021 62D6 06A0  32         bl    @fb.cursor.down       ; Move cursor down
     62D8 6D4C     
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.down.exit:
0026 62DA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62DC 7156     
                   < stevie_b1.asm.31063
0072                       copy  "edkey.fb.mov.paging.asm"     ; Move page up / down
     **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 62DE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62E0 A318     
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 62E2 8820  54         c     @fb.row.dirty,@w$ffff
     62E4 A30A     
     62E6 2022     
0013 62E8 1604  14         jne   edkey.action.ppage.sanity
0014 62EA 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62EC 6F62     
0015 62EE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62F0 A30A     
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 62F2 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     62F4 A304     
0021 62F6 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 62F8 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     62FA A31A     
0026 62FC 1503  14         jgt   edkey.action.ppage.topline
0027 62FE 04E0  34         clr   @fb.topline           ; topline = 0
     6300 A304     
0028 6302 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 6304 6820  54         s     @fb.scrrows,@fb.topline
     6306 A31A     
     6308 A304     
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 630A C820  54         mov   @fb.topline,@parm1
     630C A304     
     630E A000     
0039 6310 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6312 A310     
0040               
0041 6314 1078  14         jmp   edkey.goto.fb.toprow  ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 6316 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6318 7156     
0048               
0049               
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Next page
0054               *---------------------------------------------------------------
0055               edkey.action.npage:
0056 631A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     631C A318     
0057                       ;-------------------------------------------------------
0058                       ; Crunch current row if dirty
0059                       ;-------------------------------------------------------
0060 631E 8820  54         c     @fb.row.dirty,@w$ffff
     6320 A30A     
     6322 2022     
0061 6324 1604  14         jne   edkey.action.npage.sanity
0062 6326 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6328 6F62     
0063 632A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     632C A30A     
0064                       ;-------------------------------------------------------
0065                       ; Assert
0066                       ;-------------------------------------------------------
0067               edkey.action.npage.sanity:
0068 632E C120  34         mov   @fb.topline,tmp0
     6330 A304     
0069 6332 A120  34         a     @fb.scrrows,tmp0
     6334 A31A     
0070 6336 0584  14         inc   tmp0                  ; Base 1 offset !
0071 6338 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     633A A504     
0072 633C 1509  14         jgt   edkey.action.npage.exit
0073                       ;-------------------------------------------------------
0074                       ; Adjust topline
0075                       ;-------------------------------------------------------
0076               edkey.action.npage.topline:
0077 633E A820  54         a     @fb.scrrows,@fb.topline
     6340 A31A     
     6342 A304     
0078                       ;-------------------------------------------------------
0079                       ; Refresh page
0080                       ;-------------------------------------------------------
0081               edkey.action.npage.refresh:
0082 6344 C820  54         mov   @fb.topline,@parm1
     6346 A304     
     6348 A000     
0083 634A 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     634C A310     
0084               
0085 634E 105B  14         jmp   edkey.goto.fb.toprow  ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 6350 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6352 7156     
                   < stevie_b1.asm.31063
0073                       copy  "edkey.fb.mov.topbot.asm"     ; Move file top / bottom
     **** ****     > edkey.fb.mov.topbot.asm
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
0011 6354 8820  54         c     @fb.row.dirty,@w$ffff
     6356 A30A     
     6358 2022     
0012 635A 1604  14         jne   edkey.action.top.refresh
0013 635C 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     635E 6F62     
0014 6360 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6362 A30A     
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 6364 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     6366 A000     
0020 6368 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     636A A310     
0021               
0022 636C 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     636E 6406     
0023                                                   ; / i  @parm1 = Line in editor buffer
0024               
0025               
0026               *---------------------------------------------------------------
0027               * Goto top of screen
0028               *---------------------------------------------------------------
0029               edkey.action.topscr:
0030                       ;-------------------------------------------------------
0031                       ; Crunch current row if dirty
0032                       ;-------------------------------------------------------
0033 6370 8820  54         c     @fb.row.dirty,@w$ffff
     6372 A30A     
     6374 2022     
0034 6376 1604  14         jne   edkey.action.topscr.refresh
0035 6378 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     637A 6F62     
0036 637C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     637E A30A     
0037               edkey.action.topscr.refresh:
0038 6380 C820  54         mov   @fb.topline,@parm1    ; Set to top line in frame buffer
     6382 A304     
     6384 A000     
0039 6386 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6388 6406     
0040                                                   ; / i  @parm1 = Line in editor buffer
0041               
0042               
0043               
0044               *---------------------------------------------------------------
0045               * Goto bottom of file
0046               *---------------------------------------------------------------
0047               edkey.action.bot:
0048                       ;-------------------------------------------------------
0049                       ; Crunch current row if dirty
0050                       ;-------------------------------------------------------
0051 638A 8820  54         c     @fb.row.dirty,@w$ffff
     638C A30A     
     638E 2022     
0052 6390 1604  14         jne   edkey.action.bot.refresh
0053 6392 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6394 6F62     
0054 6396 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6398 A30A     
0055                       ;-------------------------------------------------------
0056                       ; Refresh page
0057                       ;-------------------------------------------------------
0058               edkey.action.bot.refresh:
0059 639A 8820  54         c     @edb.lines,@fb.scrrows
     639C A504     
     639E A31A     
0060 63A0 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0061               
0062 63A2 C120  34         mov   @edb.lines,tmp0
     63A4 A504     
0063 63A6 6120  34         s     @fb.scrrows,tmp0
     63A8 A31A     
0064 63AA C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     63AC A000     
0065 63AE 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63B0 A310     
0066               
0067 63B2 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     63B4 6406     
0068                                                   ; / i  @parm1 = Line in editor buffer
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               edkey.action.bot.exit:
0073 63B6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63B8 7156     
0074               
0075               
0076               
0077               *---------------------------------------------------------------
0078               * Goto bottom of screen
0079               *---------------------------------------------------------------
0080               edkey.action.botscr:
0081 63BA 0649  14         dect  stack
0082 63BC C644  30         mov   tmp0,*stack           ; Push tmp0
0083                       ;-------------------------------------------------------
0084                       ; Crunch current row if dirty
0085                       ;-------------------------------------------------------
0086 63BE 8820  54         c     @fb.row.dirty,@w$ffff
     63C0 A30A     
     63C2 2022     
0087 63C4 1604  14         jne   edkey.action.botscr.cursor
0088 63C6 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63C8 6F62     
0089 63CA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63CC A30A     
0090                       ;-------------------------------------------------------
0091                       ; Position cursor
0092                       ;-------------------------------------------------------
0093               edkey.action.botscr.cursor:
0094 63CE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     63D0 A318     
0095               
0096 63D2 8820  54         c     @fb.scrrows,@edb.lines
     63D4 A31A     
     63D6 A504     
0097 63D8 1503  14         jgt   edkey.action.botscr.eof
0098 63DA C120  34         mov   @fb.scrrows,tmp0      ; Get bottom row
     63DC A31A     
0099 63DE 1002  14         jmp   !
0100                       ;-------------------------------------------------------
0101                       ; Cursor at EOF
0102                       ;-------------------------------------------------------
0103               edkey.action.botscr.eof:
0104 63E0 C120  34         mov   @edb.lines,tmp0       ; Get last line in file
     63E2 A504     
0105                       ;-------------------------------------------------------
0106                       ; Position cursor
0107                       ;-------------------------------------------------------
0108 63E4 0604  14 !       dec   tmp0                  ; Base 0
0109 63E6 C804  38         mov   tmp0,@fb.row          ; Frame buffer bottom line
     63E8 A306     
0110 63EA 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63EC A30C     
0111               
0112 63EE C120  34         mov   @fb.row,tmp0          ;
     63F0 A306     
0113 63F2 0A84  56         sla   tmp0,8                ; Position cursor
0114 63F4 C804  38         mov   tmp0,@wyx             ;
     63F6 832A     
0115               
0116 63F8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63FA 6CC6     
0117               
0118 63FC 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     63FE 36A0     
0119                                                   ; | i  @fb.row        = Row in frame buffer
0120                                                   ; / o  @fb.row.length = Length of row
0121                       ;-------------------------------------------------------
0122                       ; Exit
0123                       ;-------------------------------------------------------
0124               edkey.action.botscr.exit:
0125 6400 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0126 6402 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6404 7156     
                   < stevie_b1.asm.31063
0074                       copy  "edkey.fb.mov.goto.asm"       ; Goto line in editor buffer
     **** ****     > edkey.fb.mov.goto.asm
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
0013               * b    @edkey.goto.fb.toprow
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @parm1  = Line in editor buffer to display as top row (goto)
0017               *
0018               * Register usage
0019               * none
0020               ********|*****|*********************|**************************
0021               edkey.goto.fb.toprow:
0022 6406 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6408 A318     
0023               
0024 640A 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     640C 6EB6     
0025                                                   ; | i  @parm1 = Line to start with
0026                                                   ; /             (becomes @fb.topline)
0027               
0028 640E 04E0  34         clr   @fb.row               ; Frame buffer line 0
     6410 A306     
0029 6412 04E0  34         clr   @fb.column            ; Frame buffer column 0
     6414 A30C     
0030 6416 04E0  34         clr   @wyx                  ; Position VDP cursor
     6418 832A     
0031 641A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     641C 6CC6     
0032               
0033 641E 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6420 36A0     
0034                                                   ; | i  @fb.row        = Row in frame buffer
0035                                                   ; / o  @fb.row.length = Length of row
0036               
0037 6422 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6424 7156     
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Goto specified line (@parm1) in editor buffer
0042               *---------------------------------------------------------------
0043               edkey.action.goto:
0044                       ;-------------------------------------------------------
0045                       ; Crunch current row if dirty
0046                       ;-------------------------------------------------------
0047 6426 8820  54         c     @fb.row.dirty,@w$ffff
     6428 A30A     
     642A 2022     
0048 642C 1609  14         jne   edkey.action.goto.refresh
0049               
0050 642E 0649  14         dect  stack
0051 6430 C660  46         mov   @parm1,*stack         ; Push parm1
     6432 A000     
0052 6434 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6436 6F62     
0053 6438 C839  50         mov   *stack+,@parm1        ; Pop parm1
     643A A000     
0054               
0055 643C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     643E A30A     
0056                       ;-------------------------------------------------------
0057                       ; Refresh page
0058                       ;-------------------------------------------------------
0059               edkey.action.goto.refresh:
0060 6440 0720  34         seto  @fb.colorize           ; Colorize M1/M2 marked lines (if present)
     6442 A310     
0061               
0062 6444 0460  28         b     @edkey.goto.fb.toprow  ; Position cursor and exit
     6446 6406     
0063                                                    ; \ i  @parm1 = Line in editor buffer
0064                                                    ; /
                   < stevie_b1.asm.31063
0075                       copy  "edkey.fb.del.asm"            ; Delete characters or lines
     **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 6448 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     644A A506     
0009 644C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     644E 6CC6     
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 6450 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6452 A308     
0015 6454 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 6456 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6458 A302     
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 645A C1C6  18         mov   tmp2,tmp3             ; \
0024 645C 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 645E 81E0  34         c     @fb.column,tmp3
     6460 A30C     
0026 6462 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 6464 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 6466 D505  30         movb  tmp1,*tmp0            ; /
0033 6468 C820  54         mov   @fb.column,@fb.row.length
     646A A30C     
     646C A308     
0034                                                   ; Row length - 1
0035 646E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6470 A30A     
0036 6472 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6474 A316     
0037 6476 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 6478 0286  22         ci    tmp2,colrow
     647A 0050     
0043 647C 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 647E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6480 FFCE     
0049 6482 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6484 2026     
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 6486 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 6488 61E0  34         s     @fb.column,tmp3
     648A A30C     
0056 648C 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 648E A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 6490 C144  18         mov   tmp0,tmp1
0059 6492 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 6494 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6496 A30C     
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 6498 C120  34         mov   @fb.current,tmp0      ; Get pointer
     649A A302     
0065 649C C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 649E 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 64A0 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 64A2 0606  14         dec   tmp2
0073 64A4 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 64A6 0206  20         li    tmp2,colrow
     64A8 0050     
0078 64AA 81A0  34         c     @fb.row.length,tmp2
     64AC A308     
0079 64AE 1603  14         jne   edkey.action.del_char.save
0080 64B0 0604  14         dec   tmp0                  ; One time adjustment
0081 64B2 04C5  14         clr   tmp1
0082 64B4 D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 64B6 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64B8 A30A     
0088 64BA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64BC A316     
0089 64BE 0620  34         dec   @fb.row.length        ; @fb.row.length--
     64C0 A308     
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 64C2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64C4 7156     
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 64C6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64C8 A506     
0102 64CA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64CC 6CC6     
0103 64CE C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64D0 A308     
0104 64D2 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 64D4 C120  34         mov   @fb.current,tmp0      ; Get pointer
     64D6 A302     
0110 64D8 C1A0  34         mov   @fb.colsline,tmp2
     64DA A30E     
0111 64DC 61A0  34         s     @fb.column,tmp2
     64DE A30C     
0112 64E0 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 64E2 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 64E4 0606  14         dec   tmp2
0119 64E6 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 64E8 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64EA A30A     
0124 64EC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64EE A316     
0125               
0126 64F0 C820  54         mov   @fb.column,@fb.row.length
     64F2 A30C     
     64F4 A308     
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 64F6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64F8 7156     
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 64FA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64FC 6CC6     
0143 64FE 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6500 A30A     
0144               
0145 6502 C820  54         mov   @fb.topline,@parm1    ; \
     6504 A304     
     6506 A000     
0146 6508 A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     650A A306     
     650C A000     
0147 650E 05A0  34         inc   @parm1                ; /
     6510 A000     
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 6512 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     6514 A000     
     6516 A504     
0153 6518 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 651A C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     651C A304     
     651E A000     
0157 6520 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6522 6EB6     
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 6524 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6526 62CE     
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 6528 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     652A 7B10     
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 652C 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     652E A000     
     6530 A504     
0170 6532 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 6534 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     6536 36A0     
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 6538 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     653A A304     
     653C A000     
0183               
0184 653E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6540 6EB6     
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 6542 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6544 A506     
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 6546 C120  34         mov   @fb.topline,tmp0
     6548 A304     
0193 654A A120  34         a     @fb.row,tmp0
     654C A306     
0194               
0195 654E 8804  38         c     tmp0,@edb.lines       ; Was last line?
     6550 A504     
0196 6552 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 6554 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6556 62CE     
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 6558 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     655A 61F2     
                   < stevie_b1.asm.31063
0076                       copy  "edkey.fb.ins.asm"            ; Insert characters or lines
     **** ****     > edkey.fb.ins.asm
0001               * FILE......: edkey.fb.ins.asm
0002               * Purpose...: Insert related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Insert character
0006               *
0007               * @parm1 = high byte has character to insert
0008               *---------------------------------------------------------------
0009               edkey.action.ins_char.ws:
0010 655C 0204  20         li    tmp0,>2000            ; White space
     655E 2000     
0011 6560 C804  38         mov   tmp0,@parm1
     6562 A000     
0012               edkey.action.ins_char:
0013 6564 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6566 A506     
0014 6568 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     656A 6CC6     
0015                       ;-------------------------------------------------------
0016                       ; Check 1 - Empty line
0017                       ;-------------------------------------------------------
0018               edkey.actions.ins.char.empty_line:
0019 656C C120  34         mov   @fb.current,tmp0      ; Get pointer
     656E A302     
0020 6570 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6572 A308     
0021 6574 133A  14         jeq   edkey.action.ins_char.append
0022                                                   ; Add character in append mode
0023                       ;-------------------------------------------------------
0024                       ; Check 2 - line-wrap if at character 80
0025                       ;-------------------------------------------------------
0026 6576 C160  34         mov   @fb.column,tmp1
     6578 A30C     
0027 657A 0285  22         ci    tmp1,colrow-1         ; At 80th character?
     657C 004F     
0028 657E 1110  14         jlt   !
0029 6580 C160  34         mov   @fb.row.length,tmp1
     6582 A308     
0030 6584 0285  22         ci    tmp1,colrow
     6586 0050     
0031 6588 160B  14         jne   !
0032                       ;-------------------------------------------------------
0033                       ; Wrap to new line
0034                       ;-------------------------------------------------------
0035 658A 0649  14         dect  Stack
0036 658C C660  46         mov   @parm1,*stack         ; Save character to add
     658E A000     
0037 6590 06A0  32         bl    @fb.cursor.down       ; Move cursor down 1 line
     6592 6D4C     
0038 6594 06A0  32         bl    @fb.insert.line       ; Insert empty line
     6596 6DEE     
0039 6598 C839  50         mov   *stack+,@parm1        ; Restore character to add
     659A A000     
0040 659C 04C6  14         clr   tmp2                  ; Clear line length
0041 659E 1025  14         jmp   edkey.action.ins_char.append
0042                       ;-------------------------------------------------------
0043                       ; Check 3 - EOL
0044                       ;-------------------------------------------------------
0045 65A0 8820  54 !       c     @fb.column,@fb.row.length
     65A2 A30C     
     65A4 A308     
0046 65A6 1321  14         jeq   edkey.action.ins_char.append
0047                                                   ; Add character in append mode
0048                       ;-------------------------------------------------------
0049                       ; Check 4 - Insert only until line length reaches 80th column
0050                       ;-------------------------------------------------------
0051 65A8 C160  34         mov   @fb.row.length,tmp1
     65AA A308     
0052 65AC 0285  22         ci    tmp1,colrow
     65AE 0050     
0053 65B0 1101  14         jlt   edkey.action.ins_char.prep
0054 65B2 101D  14         jmp   edkey.action.ins_char.exit
0055                       ;-------------------------------------------------------
0056                       ; Calculate number of characters to move
0057                       ;-------------------------------------------------------
0058               edkey.action.ins_char.prep:
0059 65B4 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0060 65B6 61E0  34         s     @fb.column,tmp3
     65B8 A30C     
0061 65BA 0607  14         dec   tmp3                  ; Remove base 1 offset
0062 65BC A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0063 65BE C144  18         mov   tmp0,tmp1
0064 65C0 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0065 65C2 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     65C4 A30C     
0066                       ;-------------------------------------------------------
0067                       ; Loop from end of line until current character
0068                       ;-------------------------------------------------------
0069               edkey.action.ins_char.loop:
0070 65C6 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0071 65C8 0604  14         dec   tmp0
0072 65CA 0605  14         dec   tmp1
0073 65CC 0606  14         dec   tmp2
0074 65CE 16FB  14         jne   edkey.action.ins_char.loop
0075                       ;-------------------------------------------------------
0076                       ; Insert specified character at current position
0077                       ;-------------------------------------------------------
0078 65D0 D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     65D2 A000     
0079                       ;-------------------------------------------------------
0080                       ; Save variables and exit
0081                       ;-------------------------------------------------------
0082 65D4 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65D6 A30A     
0083 65D8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65DA A316     
0084 65DC 05A0  34         inc   @fb.column
     65DE A30C     
0085 65E0 05A0  34         inc   @wyx
     65E2 832A     
0086 65E4 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65E6 A308     
0087 65E8 1002  14         jmp   edkey.action.ins_char.exit
0088                       ;-------------------------------------------------------
0089                       ; Add character in append mode
0090                       ;-------------------------------------------------------
0091               edkey.action.ins_char.append:
0092 65EA 0460  28         b     @edkey.action.char.overwrite
     65EC 66AA     
0093                       ;-------------------------------------------------------
0094                       ; Exit
0095                       ;-------------------------------------------------------
0096               edkey.action.ins_char.exit:
0097 65EE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65F0 7156     
0098               
0099               
0100               
0101               
0102               
0103               
0104               *---------------------------------------------------------------
0105               * Insert new line
0106               *---------------------------------------------------------------
0107               edkey.action.ins_line:
0108 65F2 06A0  32         bl    @fb.insert.line       ; Insert new line
     65F4 6DEE     
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               edkey.action.ins_line.exit:
0113 65F6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65F8 7156     
                   < stevie_b1.asm.31063
0077                       copy  "edkey.fb.mod.asm"            ; Actions for modifier keys
     **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 65FA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     65FC A318     
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 65FE 8820  54         c     @fb.row.dirty,@w$ffff
     6600 A30A     
     6602 2022     
0013 6604 1606  14         jne   edkey.action.enter.upd_counter
0014 6606 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6608 A506     
0015 660A 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     660C 6F62     
0016 660E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6610 A30A     
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 6612 C120  34         mov   @fb.topline,tmp0
     6614 A304     
0022 6616 A120  34         a     @fb.row,tmp0
     6618 A306     
0023 661A 0584  14         inc   tmp0
0024 661C 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     661E A504     
0025 6620 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 6622 05A0  34         inc   @edb.lines            ; Total lines++
     6624 A504     
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 6626 C120  34         mov   @fb.scrrows,tmp0
     6628 A31A     
0035 662A 0604  14         dec   tmp0
0036 662C 8120  34         c     @fb.row,tmp0
     662E A306     
0037 6630 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 6632 C120  34         mov   @fb.scrrows,tmp0
     6634 A31A     
0042 6636 C820  54         mov   @fb.topline,@parm1
     6638 A304     
     663A A000     
0043 663C 05A0  34         inc   @parm1
     663E A000     
0044 6640 06A0  32         bl    @fb.refresh
     6642 6EB6     
0045 6644 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6646 A310     
0046 6648 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 664A 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     664C A306     
0052 664E 06A0  32         bl    @down                 ; Row++ VDP cursor
     6650 26E0     
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 6652 06A0  32         bl    @fb.get.firstnonblank
     6654 6E6E     
0058 6656 C120  34         mov   @outparm1,tmp0
     6658 A010     
0059 665A C804  38         mov   tmp0,@fb.column
     665C A30C     
0060 665E 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     6660 26F2     
0061 6662 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     6664 36A0     
0062 6666 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6668 6CC6     
0063 666A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     666C A316     
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 666E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6670 7156     
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 6672 0649  14         dect  stack
0078 6674 C64B  30         mov   r11,*stack            ; Save return address
0079               
0080 6676 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6678 A318     
0081 667A 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     667C A50A     
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_onoff.exit:
0086 667E C2F9  30         mov   *stack+,r11           ; Pop r11
0087 6680 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6682 7156     
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Add character (frame buffer)
0093               *---------------------------------------------------------------
0094               edkey.action.char:
0095 6684 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6686 A318     
0096                       ;-------------------------------------------------------
0097                       ; Asserts
0098                       ;-------------------------------------------------------
0099 6688 D105  18         movb  tmp1,tmp0             ; Get keycode
0100 668A 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 668C 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     668E 0020     
0103 6690 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 6692 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6694 007E     
0107 6696 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 6698 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     669A A506     
0113 669C D805  38         movb  tmp1,@parm1           ; Store character for insert
     669E A000     
0114 66A0 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     66A2 A50A     
0115 66A4 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 66A6 0460  28         b     @edkey.action.ins_char
     66A8 6564     
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 66AA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     66AC 6CC6     
0126 66AE C120  34         mov   @fb.current,tmp0      ; Get pointer
     66B0 A302     
0127               
0128 66B2 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     66B4 A000     
0129 66B6 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     66B8 A30A     
0130 66BA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66BC A316     
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 66BE C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     66C0 A30C     
0135 66C2 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     66C4 004F     
0136 66C6 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 66C8 0205  20         li    tmp1,colrow           ; \
     66CA 0050     
0140 66CC C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     66CE A308     
0141 66D0 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 66D2 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     66D4 A30C     
0147 66D6 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     66D8 832A     
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 66DA 8820  54         c     @fb.column,@fb.row.length
     66DC A30C     
     66DE A308     
0152                                                   ; column < line length ?
0153 66E0 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 66E2 C820  54         mov   @fb.column,@fb.row.length
     66E4 A30C     
     66E6 A308     
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 66E8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66EA 7156     
                   < stevie_b1.asm.31063
0078                       copy  "edkey.fb.ruler.asm"          ; Toggle ruler on/off
     **** ****     > edkey.fb.ruler.asm
0001               * FILE......: edkey.fb.ruler.asm
0002               * Purpose...: Actions to toggle ruler on/off
0003               
0004               *---------------------------------------------------------------
0005               * Toggle ruler on/off
0006               ********|*****|*********************|**************************
0007               edkey.action.toggle.ruler:
0008 66EC 0649  14         dect  stack
0009 66EE C644  30         mov   tmp0,*stack           ; Push tmp0
0010 66F0 0649  14         dect  stack
0011 66F2 C660  46         mov   @wyx,*stack           ; Push cursor YX
     66F4 832A     
0012                       ;-------------------------------------------------------
0013                       ; Toggle ruler visibility
0014                       ;-------------------------------------------------------
0015 66F6 C120  34         mov   @tv.ruler.visible,tmp0
     66F8 A210     
0016                                                   ; Ruler currently off?
0017 66FA 1305  14         jeq   edkey.action.toggle.ruler.on
0018                                                   ; Yes, turn it on
0019                       ;-------------------------------------------------------
0020                       ; Turn ruler off
0021                       ;-------------------------------------------------------
0022               edkey.action.toggle.ruler.off:
0023 66FC 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     66FE A316     
0024 6700 04E0  34         clr   @tv.ruler.visible     ; Toggle ruler visibility
     6702 A210     
0025 6704 100C  14         jmp   edkey.action.toggle.ruler.fb
0026                       ;-------------------------------------------------------
0027                       ; Turn ruler on
0028                       ;-------------------------------------------------------
0029               edkey.action.toggle.ruler.on:
0030 6706 C120  34         mov   @fb.scrrows,tmp0      ; \ Check if on last row in
     6708 A31A     
0031 670A 0604  14         dec   tmp0                  ; | frame buffer, if yes
0032 670C 8120  34         c     @fb.row,tmp0          ; | silenty exit without any
     670E A306     
0033                                                   ; | action, preventing
0034                                                   ; / overflow on bottom row.
0035 6710 1308  14         jeq   edkey.action.toggle.ruler.exit
0036               
0037 6712 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     6714 A316     
0038 6716 0720  34         seto  @tv.ruler.visible     ; Set ruler visibility
     6718 A210     
0039 671A 06A0  32         bl    @fb.ruler.init        ; Setup ruler in RAM
     671C 7A80     
0040                       ;-------------------------------------------------------
0041                       ; Update framebuffer pane
0042                       ;-------------------------------------------------------
0043               edkey.action.toggle.ruler.fb:
0044 671E 06A0  32         bl    @pane.cmdb.hide       ; Same actions as when hiding CMDB
     6720 7A02     
0045                       ;-------------------------------------------------------
0046                       ; Exit
0047                       ;-------------------------------------------------------
0048               edkey.action.toggle.ruler.exit:
0049 6722 C839  50         mov   *stack+,@wyx          ; Pop cursor YX
     6724 832A     
0050 6726 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 6728 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     672A 7156     
                   < stevie_b1.asm.31063
0079                       copy  "edkey.fb.misc.asm"           ; Miscelanneous actions
     **** ****     > edkey.fb.misc.asm
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
0011 672C C120  34         mov   @edb.dirty,tmp0
     672E A506     
0012 6730 1302  14         jeq   !
0013 6732 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6734 7972     
0014                       ;-------------------------------------------------------
0015                       ; Quit Stevie
0016                       ;-------------------------------------------------------
0017 6736 0460  28 !       b     @tv.quit
     6738 3382     
0018               
0019               
0020               *---------------------------------------------------------------
0021               * Copy code block or open "Insert from clipboard" dialog
0022               *---------------------------------------------------------------
0023               edkey.action.copyblock_or_clipboard:
0024 673A 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     673C A50C     
     673E 2022     
0025 6740 1302  14         jeq   !
0026 6742 0460  28         b     @edkey.action.block.copy
     6744 67AE     
0027                                                   ; Copy code block
0028 6746 0460  28 !       b     @dialog.clipboard     ; Open "Insert from clipboard" dialog
     6748 7980     
                   < stevie_b1.asm.31063
0080                       copy  "edkey.fb.file.asm"           ; File related actions
     **** ****     > edkey.fb.file.asm
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
0011               * @cmdb.cmdlen
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.fb.fname.dec.load:
0017 674A 0649  14         dect  stack
0018 674C C644  30         mov   tmp0,*stack           ; Push tmp0
0019                       ;------------------------------------------------------
0020                       ; Adjust filename
0021                       ;------------------------------------------------------
0022 674E 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6750 A002     
0023               
0024 6752 0204  20         li    tmp0,edkey.action.fb.fname.dec.load
     6754 674A     
0025 6756 C804  38         mov   tmp0,@cmdb.action.ptr ; Set deferred action to run if proceeding
     6758 A726     
0026                                                   ; in "Unsaved changes" dialog
0027               
0028 675A 1008  14         jmp   edkey.action.fb.fname.doit
0029               
0030               
0031               edkey.action.fb.fname.inc.load:
0032 675C 0649  14         dect  stack
0033 675E C644  30         mov   tmp0,*stack           ; Push tmp0
0034                       ;------------------------------------------------------
0035                       ; Adjust filename
0036                       ;------------------------------------------------------
0037 6760 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     6762 A002     
0038               
0039 6764 0204  20         li    tmp0,edkey.action.fb.fname.inc.load
     6766 675C     
0040 6768 C804  38         mov   tmp0,@cmdb.action.ptr ; Set deferred action to run if proceeding
     676A A726     
0041                                                   ; in "Unsaved changes" dialog
0042               
0043                       ;------------------------------------------------------
0044                       ; Process filename
0045                       ;------------------------------------------------------
0046               edkey.action.fb.fname.doit:
0047 676C C120  34         mov   @edb.filename.ptr,tmp0
     676E A512     
0048 6770 1311  14         jeq   edkey.action.fb.fname.exit
0049                                                   ; Exit early if new file.
0050               
0051 6772 0284  22         ci    tmp0,txt.newfile
     6774 38EE     
0052 6776 130E  14         jeq   edkey.action.fb.fname.exit
0053                                                   ; Exit early if "[New file]"
0054               
0055 6778 C804  38         mov   tmp0,@parm1           ; Set filename
     677A A000     
0056                       ;------------------------------------------------------
0057                       ; Show dialog "Unsaved changed" if editor buffer dirty
0058                       ;------------------------------------------------------
0059 677C C120  34         mov   @edb.dirty,tmp0
     677E A506     
0060 6780 1303  14         jeq   !
0061 6782 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0062 6784 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6786 7972     
0063                       ;------------------------------------------------------
0064                       ; Update suffix
0065                       ;------------------------------------------------------
0066 6788 06A0  32 !       bl    @fm.browse.fname.suffix
     678A 7900     
0067                                                   ; Filename suffix adjust
0068                                                   ; i  \ parm1 = Pointer to filename
0069                                                   ; i  / parm2 = >FFFF or >0000
0070                       ;------------------------------------------------------
0071                       ; Load file
0072                       ;------------------------------------------------------
0073               edkey.action.fb.fname.doit.loadfile:
0074 678C 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     678E 7A02     
0075               
0076 6790 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6792 78C2     
0077                                                   ; \ i  parm1 = Pointer to length-prefixed
0078                                                   ; /            device/filename string
0079               
0080               
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edkey.action.fb.fname.exit:
0085 6794 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0086 6796 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6798 6354     
                   < stevie_b1.asm.31063
0081                       copy  "edkey.fb.block.asm"          ; Actions block move/copy/delete...
     **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1 or M2
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark:
0008 679A 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     679C 7ACA     
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 679E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67A0 7156     
0013               
0014               
0015               *---------------------------------------------------------------
0016               * Reset block markers M1/M2
0017               ********|*****|*********************|**************************
0018               edkey.action.block.reset:
0019 67A2 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67A4 7694     
0020 67A6 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     67A8 7AF2     
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 67AA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67AC 7156     
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Copy code block
0029               ********|*****|*********************|**************************
0030               edkey.action.block.copy:
0031 67AE 0649  14         dect  stack
0032 67B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0033                       ;-------------------------------------------------------
0034                       ; Exit early if nothing to do
0035                       ;-------------------------------------------------------
0036 67B2 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67B4 A50E     
     67B6 2022     
0037 67B8 1315  14         jeq   edkey.action.block.copy.exit
0038                                                   ; Yes, exit early
0039                       ;-------------------------------------------------------
0040                       ; Init
0041                       ;-------------------------------------------------------
0042 67BA C120  34         mov   @wyx,tmp0             ; Get cursor position
     67BC 832A     
0043 67BE 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     67C0 FF00     
0044 67C2 C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     67C4 A314     
0045                       ;-------------------------------------------------------
0046                       ; Copy
0047                       ;-------------------------------------------------------
0048 67C6 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67C8 7694     
0049               
0050 67CA 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     67CC A000     
0051 67CE 06A0  32         bl    @edb.block.copy       ; Copy code block
     67D0 7B06     
0052                                                   ; \ i  @parm1    = Message flag
0053                                                   ; / o  @outparm1 = >ffff if success
0054               
0055 67D2 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     67D4 A010     
     67D6 2000     
0056 67D8 1305  14         jeq   edkey.action.block.copy.exit
0057                                                   ; If yes, exit early
0058               
0059 67DA C820  54         mov   @fb.yxsave,@parm1
     67DC A314     
     67DE A000     
0060 67E0 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     67E2 6F26     
0061                                                   ; \ i  @parm1 = cursor YX position
0062                                                   ; /
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.block.copy.exit:
0067 67E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 67E6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67E8 7156     
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Delete code block
0075               ********|*****|*********************|**************************
0076               edkey.action.block.delete:
0077                       ;-------------------------------------------------------
0078                       ; Exit early if nothing to do
0079                       ;-------------------------------------------------------
0080 67EA 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67EC A50E     
     67EE 2022     
0081 67F0 130F  14         jeq   edkey.action.block.delete.exit
0082                                                   ; Yes, exit early
0083                       ;-------------------------------------------------------
0084                       ; Delete
0085                       ;-------------------------------------------------------
0086 67F2 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     67F4 7694     
0087               
0088 67F6 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     67F8 A000     
0089 67FA 06A0  32         bl    @edb.block.delete     ; Delete code block
     67FC 7AFC     
0090                                                   ; \ i  @parm1    = Display message Yes/No
0091                                                   ; / o  @outparm1 = >ffff if success
0092                       ;-------------------------------------------------------
0093                       ; Reposition in frame buffer
0094                       ;-------------------------------------------------------
0095 67FE 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     6800 A010     
     6802 2000     
0096 6804 1305  14         jeq   edkey.action.block.delete.exit
0097                                                   ; If yes, exit early
0098               
0099 6806 C820  54         mov   @fb.topline,@parm1
     6808 A304     
     680A A000     
0100 680C 0460  28         b     @edkey.goto.fb.toprow ; Position on top row in frame buffer
     680E 6406     
0101                                                   ; \ i  @parm1 = Line to display as top row
0102                                                   ; /
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               edkey.action.block.delete.exit:
0107 6810 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6812 7156     
0108               
0109               
0110               *---------------------------------------------------------------
0111               * Move code block
0112               ********|*****|*********************|**************************
0113               edkey.action.block.move:
0114                       ;-------------------------------------------------------
0115                       ; Exit early if nothing to do
0116                       ;-------------------------------------------------------
0117 6814 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6816 A50E     
     6818 2022     
0118 681A 1313  14         jeq   edkey.action.block.move.exit
0119                                                   ; Yes, exit early
0120                       ;-------------------------------------------------------
0121                       ; Delete
0122                       ;-------------------------------------------------------
0123 681C 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     681E 7694     
0124               
0125 6820 0720  34         seto  @parm1                ; Set message to "Moving block..."
     6822 A000     
0126 6824 06A0  32         bl    @edb.block.copy       ; Copy code block
     6826 7B06     
0127                                                   ; \ i  @parm1    = Message flag
0128                                                   ; / o  @outparm1 = >ffff if success
0129               
0130 6828 0720  34         seto  @parm1                ; Don't display delete message
     682A A000     
0131 682C 06A0  32         bl    @edb.block.delete     ; Delete code block
     682E 7AFC     
0132                                                   ; \ i  @parm1    = Display message Yes/No
0133                                                   ; / o  @outparm1 = >ffff if success
0134                       ;-------------------------------------------------------
0135                       ; Reposition in frame buffer
0136                       ;-------------------------------------------------------
0137 6830 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     6832 A010     
     6834 2000     
0138 6836 13EC  14         jeq   edkey.action.block.delete.exit
0139                                                   ; If yes, exit early
0140               
0141 6838 C820  54         mov   @fb.topline,@parm1
     683A A304     
     683C A000     
0142 683E 0460  28         b     @edkey.goto.fb.toprow ; Position on top row in frame buffer
     6840 6406     
0143                                                   ; \ i  @parm1 = Line to display as top row
0144                                                   ; /
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               edkey.action.block.move.exit:
0149 6842 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6844 7156     
0150               
0151               
0152               *---------------------------------------------------------------
0153               * Goto marker M1
0154               ********|*****|*********************|**************************
0155               edkey.action.block.goto.m1:
0156 6846 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6848 A50C     
     684A 2022     
0157 684C 1307  14         jeq   edkey.action.block.goto.m1.exit
0158                                                   ; Yes, exit early
0159                       ;-------------------------------------------------------
0160                       ; Goto marker M1
0161                       ;-------------------------------------------------------
0162 684E C820  54         mov   @edb.block.m1,@parm1
     6850 A50C     
     6852 A000     
0163 6854 0620  34         dec   @parm1                ; Base 0 offset
     6856 A000     
0164               
0165 6858 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     685A 6426     
0166                                                   ; \ i @parm1 = Target line in EB
0167                                                   ; /
0168                       ;-------------------------------------------------------
0169                       ; Exit
0170                       ;-------------------------------------------------------
0171               edkey.action.block.goto.m1.exit:
0172 685C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     685E 7156     
                   < stevie_b1.asm.31063
0082                       copy  "edkey.fb.tabs.asm"           ; tab-key related actions
     **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 6860 0649  14         dect  stack
0009 6862 C64B  30         mov   r11,*stack            ; Save return address
0010 6864 06A0  32         bl    @fb.tab.next          ; Jump to next tab position on line
     6866 7A6E     
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 6868 C2F9  30         mov   *stack+,r11           ; Pop r11
0016 686A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     686C 7156     
                   < stevie_b1.asm.31063
0083                       copy  "edkey.fb.clip.asm"           ; Clipboard actions
     **** ****     > edkey.fb.clip.asm
0001               * FILE......: edkey.fb.clip.asm
0002               * Purpose...: Clipboard File related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Save clipboards
0006               *---------------------------------------------------------------
0007               * b   @edkey.action.fb.clip.save.[1-5]
0008               *---------------------------------------------------------------
0009               * INPUT
0010               * none
0011               *--------------------------------------------------------------
0012               * Register usage
0013               * tmp0
0014               ********|*****|*********************|**************************
0015               edkey.action.fb.clip.save.1:
0016 686E 0204  20         li    tmp0,clip1
     6870 3100     
0017 6872 100B  14         jmp   !
0018               edkey.action.fb.clip.save.2:
0019 6874 0204  20         li    tmp0,clip2
     6876 3200     
0020 6878 1008  14         jmp   !
0021               edkey.action.fb.clip.save.3:
0022 687A 0204  20         li    tmp0,clip3
     687C 3300     
0023 687E 1005  14         jmp   !
0024               edkey.action.fb.clip.save.4:
0025 6880 0204  20         li    tmp0,clip4
     6882 3400     
0026 6884 1002  14         jmp   !
0027               edkey.action.fb.clip.save.5:
0028 6886 0204  20         li    tmp0,clip5
     6888 3500     
0029                       ;-------------------------------------------------------
0030                       ; Save block to clipboard
0031                       ;-------------------------------------------------------
0032 688A C804  38 !       mov   tmp0,@parm1
     688C A000     
0033 688E 06A0  32         bl    @edb.block.clip       ; Save block to clipboard
     6890 7AE8     
0034                                                   ; \ i  @parm1 = Suffix clipboard filename
0035                                                   ; /
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039               edkey.action.fb.clip.save.exit:
0040 6892 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0041               
0042 6894 C820  54         mov   @fb.topline,@parm1    ; Get topline
     6896 A304     
     6898 A000     
0043 689A 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     689C 6406     
0044                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.31063
0084                       ;-----------------------------------------------------------------------
0085                       ; Keyboard actions - Command Buffer
0086                       ;-----------------------------------------------------------------------
0087                       copy  "edkey.cmdb.mov.asm"          ; Actions for movement keys
     **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 689E C120  34         mov   @cmdb.column,tmp0
     68A0 A712     
0009 68A2 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 68A4 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     68A6 A712     
0014 68A8 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     68AA A70A     
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 68AC 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     68AE 7156     
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 68B0 06A0  32         bl    @cmdb.cmd.getlength
     68B2 7A2A     
0026 68B4 8820  54         c     @cmdb.column,@outparm1
     68B6 A712     
     68B8 A010     
0027 68BA 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 68BC 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     68BE A712     
0032 68C0 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     68C2 A70A     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 68C4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     68C6 7156     
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 68C8 04C4  14         clr   tmp0
0045 68CA C804  38         mov   tmp0,@cmdb.column      ; First column
     68CC A712     
0046 68CE 0584  14         inc   tmp0
0047 68D0 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     68D2 A70A     
0048 68D4 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     68D6 A70A     
0049               
0050 68D8 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68DA 7156     
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 68DC D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     68DE A728     
0057 68E0 0984  56         srl   tmp0,8                 ; Right justify
0058 68E2 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     68E4 A712     
0059 68E6 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 68E8 0224  22         ai    tmp0,>1a00             ; Y=26
     68EA 1A00     
0061 68EC C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     68EE A70A     
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 68F0 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68F2 7156     
                   < stevie_b1.asm.31063
0088                       copy  "edkey.cmdb.mod.asm"          ; Actions for modifier keys
     **** ****     > edkey.cmdb.mod.asm
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
0025 68F4 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     68F6 7A20     
0026 68F8 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     68FA A718     
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 68FC 0460  28         b     @edkey.action.cmdb.home
     68FE 68C8     
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
0060 6900 D105  18         movb  tmp1,tmp0             ; Get keycode
0061 6902 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 6904 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6906 0020     
0064 6908 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 690A 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     690C 007E     
0068 690E 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 6910 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6912 A718     
0074               
0075 6914 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6916 A729     
0076 6918 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     691A A712     
0077 691C D505  30         movb  tmp1,*tmp0            ; Add character
0078 691E 05A0  34         inc   @cmdb.column          ; Next column
     6920 A712     
0079 6922 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     6924 A70A     
0080               
0081 6926 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6928 7A2A     
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 692A C120  34         mov   @outparm1,tmp0
     692C A010     
0088 692E 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 6930 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6932 A728     
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 6934 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6936 7156     
                   < stevie_b1.asm.31063
0089                       copy  "edkey.cmdb.misc.asm"         ; Miscelanneous actions
     **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 6938 C120  34         mov   @cmdb.visible,tmp0
     693A A702     
0009 693C 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 693E 04E0  34         clr   @cmdb.column          ; Column = 0
     6940 A712     
0015 6942 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6944 79F8     
0016 6946 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 6948 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     694A 7A02     
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 694C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     694E 7156     
0027               
0028               
0029               
0030               
0031               
                   < stevie_b1.asm.31063
0090                       copy  "edkey.cmdb.file.new.asm"     ; New file
     **** ****     > edkey.cmdb.file.new.asm
0001               * FILE......: edkey.cmdb.fíle.new.asm
0002               * Purpose...: New file from command buffer pane
0003               
0004               *---------------------------------------------------------------
0005               * New file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.file.new:
0008                       ;-------------------------------------------------------
0009                       ; New file
0010                       ;-------------------------------------------------------
0011 6950 0649  14         dect  stack
0012 6952 C64B  30         mov   r11,*stack            ; Save return address
0013 6954 0649  14         dect  stack
0014 6956 C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;-------------------------------------------------------
0016                       ; Show dialog "Unsaved changes" if editor buffer dirty
0017                       ;-------------------------------------------------------
0018 6958 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     695A A506     
0019 695C 1303  14         jeq   !                     ; No, skip "Unsaved changes"
0020               
0021 695E 06A0  32         bl    @dialog.unsaved       ; Show dialog
     6960 7972     
0022 6962 1004  14         jmp   edkey.action.cmdb.file.new.exit
0023                       ;-------------------------------------------------------
0024                       ; Reset editor
0025                       ;-------------------------------------------------------
0026 6964 06A0  32 !       bl    @pane.cmdb.hide       ; Hide CMDB pane
     6966 7A02     
0027 6968 06A0  32         bl    @fm.newfile           ; New file in editor
     696A 7924     
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.file.new.exit:
0032 696C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0033 696E C2F9  30         mov   *stack+,r11           ; Pop R11
0034 6970 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     6972 6354     
                   < stevie_b1.asm.31063
0091                       copy  "edkey.cmdb.file.load.asm"    ; Open file
     **** ****     > edkey.cmdb.file.load.asm
0001               * FILE......: edkey.cmdb.fíle.load.asm
0002               * Purpose...: Load file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.load:
0008                       ;-------------------------------------------------------
0009                       ; Load file
0010                       ;-------------------------------------------------------
0011 6974 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6976 7A02     
0012               
0013 6978 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     697A 7A2A     
0014 697C C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     697E A010     
0015 6980 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 6982 0204  20         li    tmp0,txt.io.nofile    ; \
     6984 39FE     
0020 6986 C804  38         mov   tmp0,@parm1           ; / Error message
     6988 A000     
0021               
0022 698A 06A0  32         bl    @error.display        ; Show error message
     698C 79E4     
0023                                                   ; \ i  @parm1 = Pointer to error message
0024                                                   ; /
0025               
0026 698E 1012  14         jmp   edkey.action.cmdb.load.exit
0027                       ;-------------------------------------------------------
0028                       ; Get filename
0029                       ;-------------------------------------------------------
0030 6990 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0031 6992 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6994 A728     
0032               
0033 6996 06A0  32         bl    @cpym2m
     6998 24EE     
0034 699A A728                   data cmdb.cmdlen,heap.top,80
     699C F000     
     699E 0050     
0035                                                   ; Copy filename from command line to buffer
0036                       ;-------------------------------------------------------
0037                       ; Pass filename as parm1
0038                       ;-------------------------------------------------------
0039 69A0 0204  20         li    tmp0,heap.top         ; 1st line in heap
     69A2 F000     
0040 69A4 C804  38         mov   tmp0,@parm1
     69A6 A000     
0041                       ;-------------------------------------------------------
0042                       ; Load file
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.load.file:
0045 69A8 0204  20         li    tmp0,heap.top         ; 1st line in heap
     69AA F000     
0046 69AC C804  38         mov   tmp0,@parm1
     69AE A000     
0047               
0048 69B0 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     69B2 78C2     
0049                                                   ; \ i  parm1 = Pointer to length-prefixed
0050                                                   ; /            device/filename string
0051                       ;-------------------------------------------------------
0052                       ; Exit
0053                       ;-------------------------------------------------------
0054               edkey.action.cmdb.load.exit:
0055 69B4 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     69B6 6354     
                   < stevie_b1.asm.31063
0092                       copy  "edkey.cmdb.file.insert.asm"  ; Insert file
     **** ****     > edkey.cmdb.file.insert.asm
0001               * FILE......: edkey.cmdb.fíle.insert.asm
0002               * Purpose...: Insert file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Insert file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.insert:
0008 69B8 0649  14         dect  stack
0009 69BA C644  30         mov   tmp0,*stack           ; Push tmp0
0010 69BC 0649  14         dect  stack
0011 69BE C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     69C0 A304     
0012                       ;-------------------------------------------------------
0013                       ; Insert file at current line in editor buffer
0014                       ;-------------------------------------------------------
0015 69C2 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     69C4 7A02     
0016               
0017 69C6 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     69C8 7A2A     
0018 69CA C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     69CC A010     
0019 69CE 1607  14         jne   !                     ; No, prepare for load
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 69D0 0204  20         li    tmp0,txt.io.nofile    ; \
     69D2 39FE     
0024 69D4 C804  38         mov   tmp0,@parm1           ; / Error message
     69D6 A000     
0025               
0026 69D8 06A0  32         bl    @error.display        ; Show error message
     69DA 79E4     
0027                                                   ; \ i  @parm1 = Pointer to error message
0028                                                   ; /
0029               
0030 69DC 1029  14         jmp   edkey.action.cmdb.insert.exit
0031                       ;-------------------------------------------------------
0032                       ; Get filename
0033                       ;-------------------------------------------------------
0034 69DE 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0035 69E0 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     69E2 A728     
0036               
0037 69E4 06A0  32         bl    @cpym2m
     69E6 24EE     
0038 69E8 A728                   data cmdb.cmdall,heap.top,80
     69EA F000     
     69EC 0050     
0039                                                   ; Copy filename from command line to buffer
0040                       ;-------------------------------------------------------
0041                       ; Pass filename as parm1
0042                       ;-------------------------------------------------------
0043 69EE 0204  20         li    tmp0,heap.top         ; 1st line in heap
     69F0 F000     
0044 69F2 C804  38         mov   tmp0,@parm1
     69F4 A000     
0045                       ;-------------------------------------------------------
0046                       ; Insert file at line
0047                       ;-------------------------------------------------------
0048               edkey.action.cmdb.insert.file:
0049                       ;-------------------------------------------------------
0050                       ; Get line
0051                       ;-------------------------------------------------------
0052 69F6 C820  54         mov   @fb.row,@parm1
     69F8 A306     
     69FA A000     
0053 69FC 06A0  32         bl    @fb.row2line          ; Row to editor line
     69FE 6CAC     
0054                                                   ; \ i @fb.topline = Top line in frame buffer
0055                                                   ; | i @parm1      = Row in frame buffer
0056                                                   ; / o @outparm1   = Matching line in EB
0057               
0058 6A00 C820  54         mov   @outparm1,@parm2      ; \ Line to insert file at is the editor
     6A02 A010     
     6A04 A002     
0059 6A06 05A0  34         inc   @parm2                ; / line where the cursor is at +1
     6A08 A002     
0060                       ;-------------------------------------------------------
0061                       ; Get device/filename
0062                       ;-------------------------------------------------------
0063 6A0A 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6A0C F000     
0064 6A0E C804  38         mov   tmp0,@parm1
     6A10 A000     
0065                       ;-------------------------------------------------------
0066                       ; Insert file
0067                       ;-------------------------------------------------------
0068 6A12 0204  20         li    tmp0,id.file.insertfile
     6A14 0002     
0069 6A16 C804  38         mov   tmp0,@parm3           ; Set work mode
     6A18 A004     
0070               
0071 6A1A 06A0  32         bl    @fm.insertfile        ; Insert DV80 file
     6A1C 78E8     
0072                                                   ; \ i  parm1 = Pointer to length-prefixed
0073                                                   ; |            device/filename string
0074                                                   ; | i  parm2 = Line number to load file at
0075                                                   ; / i  parm3 = Work mode
0076                       ;-------------------------------------------------------
0077                       ; Refresh frame buffer
0078                       ;-------------------------------------------------------
0079 6A1E 0720  34         seto  @fb.dirty             ; Refresh frame buffer
     6A20 A316     
0080 6A22 0720  34         seto  @edb.dirty            ; Editor buffer dirty
     6A24 A506     
0081               
0082 6A26 C820  54         mov   @fb.topline,@parm1
     6A28 A304     
     6A2A A000     
0083 6A2C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6A2E 6EB6     
0084                                                   ; | i  @parm1 = Line to start with
0085                                                   ; /             (becomes @fb.topline)
0086               
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.cmdb.insert.exit:
0091 6A30 C839  50         mov   *stack+,@parm1        ; Pop top row
     6A32 A000     
0092 6A34 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0093 6A36 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6A38 6406     
0094                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.31063
0093                       copy  "edkey.cmdb.file.append.asm"  ; Append file
     **** ****     > edkey.cmdb.file.append.asm
0001               * FILE......: edkey.cmdb.fíle.append.asm
0002               * Purpose...: Append file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Append file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.append:
0008 6A3A 0649  14         dect  stack
0009 6A3C C644  30         mov   tmp0,*stack           ; Push tmp0
0010 6A3E 0649  14         dect  stack
0011 6A40 C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     6A42 A304     
0012                       ;-------------------------------------------------------
0013                       ; Append file after last line in editor buffer
0014                       ;-------------------------------------------------------
0015 6A44 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6A46 7A02     
0016               
0017 6A48 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6A4A 7A2A     
0018 6A4C C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6A4E A010     
0019 6A50 1607  14         jne   !                     ; No, prepare for load
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 6A52 0204  20         li    tmp0,txt.io.nofile    ; \
     6A54 39FE     
0024 6A56 C804  38         mov   tmp0,@parm1           ; / Error message
     6A58 A000     
0025               
0026 6A5A 06A0  32         bl    @error.display        ; Show error message
     6A5C 79E4     
0027                                                   ; \ i  @parm1 = Pointer to error message
0028                                                   ; /
0029               
0030 6A5E 1022  14         jmp   edkey.action.cmdb.append.exit
0031                       ;-------------------------------------------------------
0032                       ; Get filename
0033                       ;-------------------------------------------------------
0034 6A60 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0035 6A62 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6A64 A728     
0036               
0037 6A66 06A0  32         bl    @cpym2m
     6A68 24EE     
0038 6A6A A728                   data cmdb.cmdall,heap.top,80
     6A6C F000     
     6A6E 0050     
0039                                                   ; Copy filename from command line to buffer
0040                       ;-------------------------------------------------------
0041                       ; Pass filename as parm1
0042                       ;-------------------------------------------------------
0043 6A70 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6A72 F000     
0044 6A74 C804  38         mov   tmp0,@parm1
     6A76 A000     
0045                       ;-------------------------------------------------------
0046                       ; Append file
0047                       ;-------------------------------------------------------
0048               edkey.action.cmdb.append.file:
0049 6A78 C820  54         mov   @edb.lines,@parm2     ; \ Append file after last line in
     6A7A A504     
     6A7C A002     
0050                                                   ; / editor buffer (base 0 offset)
0051                       ;-------------------------------------------------------
0052                       ; Get device/filename
0053                       ;-------------------------------------------------------
0054 6A7E 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6A80 F000     
0055 6A82 C804  38         mov   tmp0,@parm1
     6A84 A000     
0056                       ;-------------------------------------------------------
0057                       ; Append file
0058                       ;-------------------------------------------------------
0059 6A86 0204  20         li    tmp0,id.file.appendfile
     6A88 0003     
0060 6A8A C804  38         mov   tmp0,@parm3           ; Set work mode
     6A8C A004     
0061               
0062 6A8E 06A0  32         bl    @fm.insertfile        ; Insert DV80 file
     6A90 78E8     
0063                                                   ; \ i  parm1 = Pointer to length-prefixed
0064                                                   ; |            device/filename string
0065                                                   ; | i  parm2 = Line number to load file at
0066                                                   ; / i  parm3 = Work mode
0067                       ;-------------------------------------------------------
0068                       ; Refresh frame buffer
0069                       ;-------------------------------------------------------
0070 6A92 0720  34         seto  @fb.dirty             ; Refresh frame buffer
     6A94 A316     
0071 6A96 0720  34         seto  @edb.dirty            ; Editor buffer dirty
     6A98 A506     
0072               
0073 6A9A C820  54         mov   @fb.topline,@parm1
     6A9C A304     
     6A9E A000     
0074 6AA0 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6AA2 6EB6     
0075                                                   ; | i  @parm1 = Line to start with
0076                                                   ; /             (becomes @fb.topline)
0077               
0078                       ;-------------------------------------------------------
0079                       ; Exit
0080                       ;-------------------------------------------------------
0081               edkey.action.cmdb.append.exit:
0082 6AA4 C839  50         mov   *stack+,@parm1        ; Pop top row
     6AA6 A000     
0083 6AA8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0084 6AAA 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6AAC 6406     
0085                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.31063
0094                       copy  "edkey.cmdb.file.clip.asm"    ; Copy clipboard to line
     **** ****     > edkey.cmdb.file.clip.asm
0001               * FILE......: edkey.cmdb.fíle.clip.asm
0002               * Purpose...: Copy clipboard file to line
0003               
0004               *---------------------------------------------------------------
0005               * Copy clipboard file to line
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.clip.1
0008 6AAE 0204  20         li    tmp0,clip1
     6AB0 3100     
0009 6AB2 100C  14         jmp   edkey.action.cmdb.clip
0010               
0011               edkey.action.cmdb.clip.2
0012 6AB4 0204  20         li    tmp0,clip2
     6AB6 3200     
0013 6AB8 1009  14         jmp   edkey.action.cmdb.clip
0014               
0015               edkey.action.cmdb.clip.3
0016 6ABA 0204  20         li    tmp0,clip3
     6ABC 3300     
0017 6ABE 1006  14         jmp   edkey.action.cmdb.clip
0018               
0019               edkey.action.cmdb.clip.4
0020 6AC0 0204  20         li    tmp0,clip4
     6AC2 3400     
0021 6AC4 1003  14         jmp   edkey.action.cmdb.clip
0022               
0023               edkey.action.cmdb.clip.5
0024 6AC6 0204  20         li    tmp0,clip5
     6AC8 3500     
0025 6ACA 1000  14         jmp   edkey.action.cmdb.clip
0026               
0027               
0028               edkey.action.cmdb.clip:
0029 6ACC C804  38         mov   tmp0,@parm1           ; Get clipboard suffix 0-9
     6ACE A000     
0030               
0031 6AD0 06A0  32         bl    @film
     6AD2 224A     
0032 6AD4 A728                   data cmdb.cmdall,>00,80
     6AD6 0000     
     6AD8 0050     
0033               
0034 6ADA 06A0  32         bl    @cpym2m
     6ADC 24EE     
0035 6ADE D9B0                   data tv.clip.fname,cmdb.cmdall,80
     6AE0 A728     
     6AE2 0050     
0036                       ;------------------------------------------------------
0037                       ; Append suffix character to clipboard device/filename
0038                       ;------------------------------------------------------
0039 6AE4 C120  34         mov   @tv.clip.fname,tmp0
     6AE6 D9B0     
0040 6AE8 C144  18         mov   tmp0,tmp1
0041 6AEA 0984  56         srl   tmp0,8                ; Get string length
0042 6AEC 0224  22         ai    tmp0,cmdb.cmdall      ; Add base
     6AEE A728     
0043 6AF0 0584  14         inc   tmp0                  ; Consider length-prefix byte
0044 6AF2 D520  46         movb  @parm1,*tmp0          ; Append suffix
     6AF4 A000     
0045               
0046 6AF6 0460  28         b     @edkey.action.cmdb.insert
     6AF8 69B8     
0047                                                   ; Insert file
                   < stevie_b1.asm.31063
0095                       copy  "edkey.cmdb.file.clipdev.asm" ; Configure clipboard device
     **** ****     > edkey.cmdb.file.clipdev.asm
0001               * FILE......: edkey.cmdb.fíle.clipdev.asm
0002               * Purpose...: Configure clipboard device
0003               
0004               *---------------------------------------------------------------
0005               * Configure clipboard device
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.clipdev.configure:
0008                       ;-------------------------------------------------------
0009                       ; Configure
0010                       ;-------------------------------------------------------
0011 6AFA 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6AFC 7A02     
0012               
0013 6AFE 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6B00 7A2A     
0014 6B02 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6B04 A010     
0015 6B06 1607  14         jne   !                     ; No, set clipboard device and filename
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 6B08 0204  20         li    tmp0,txt.io.nofile    ; \
     6B0A 39FE     
0020 6B0C C804  38         mov   tmp0,@parm1           ; / Error message
     6B0E A000     
0021               
0022 6B10 06A0  32         bl    @error.display        ; Show error message
     6B12 79E4     
0023                                                   ; \ i  @parm1 = Pointer to error message
0024                                                   ; /
0025               
0026 6B14 1018  14         jmp   edkey.action.cmdb.clipdev.configure.exit
0027                       ;-------------------------------------------------------
0028                       ; Set clipboard device and filename
0029                       ;-------------------------------------------------------
0030 6B16 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0031 6B18 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6B1A A728     
0032               
0033 6B1C 06A0  32         bl    @cpym2m
     6B1E 24EE     
0034 6B20 A728                   data cmdb.cmdall,tv.clip.fname,80
     6B22 D9B0     
     6B24 0050     
0035                                                   ; Copy filename from command line to buffer
0036               
0037                       ;-------------------------------------------------------
0038                       ; Show message
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.clipdev.configure.message:
0041 6B26 06A0  32         bl    @hchar
     6B28 27E6     
0042 6B2A 0034                   byte 0,52,32,20
     6B2C 2014     
0043 6B2E FFFF                   data EOL              ; Erase any previous message
0044               
0045 6B30 06A0  32         bl    @putat
     6B32 2456     
0046 6B34 0034                   byte 0,52
0047 6B36 38CC                   data txt.done.clipdev
0048                       ;-------------------------------------------------------
0049                       ; Setup one shot task for removing overlay message
0050                       ;-------------------------------------------------------
0051 6B38 0204  20         li    tmp0,pane.topline.oneshot.clearmsg
     6B3A 36C4     
0052 6B3C C804  38         mov   tmp0,@tv.task.oneshot
     6B3E A224     
0053               
0054 6B40 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     6B42 2FC6     
0055 6B44 0003                   data 3                ; / for getting consistent delay
0056                       ;-------------------------------------------------------
0057                       ; Exit
0058                       ;-------------------------------------------------------
0059               edkey.action.cmdb.clipdev.configure.exit:
0060 6B46 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6B48 6354     
                   < stevie_b1.asm.31063
0096                       copy  "edkey.cmdb.file.save.asm"    ; Save file
     **** ****     > edkey.cmdb.file.save.asm
0001               * FILE......: edkey.cmdb.fíle.save.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Save file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.save:
0008 6B4A 0649  14         dect  stack
0009 6B4C C644  30         mov   tmp0,*stack           ; Push tmp0
0010 6B4E 0649  14         dect  stack
0011 6B50 C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     6B52 A304     
0012                       ;-------------------------------------------------------
0013                       ; Save file
0014                       ;-------------------------------------------------------
0015 6B54 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6B56 7A02     
0016               
0017 6B58 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6B5A 7A2A     
0018 6B5C C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6B5E A010     
0019 6B60 1607  14         jne   !                     ; No, prepare for save
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 6B62 0204  20         li    tmp0,txt.io.nofile    ; \
     6B64 39FE     
0024 6B66 C804  38         mov   tmp0,@parm1           ; / Error message
     6B68 A000     
0025               
0026 6B6A 06A0  32         bl    @error.display        ; Show error message
     6B6C 79E4     
0027                                                   ; \ i  @parm1 = Pointer to error message
0028                                                   ; /
0029               
0030 6B6E 1026  14         jmp   edkey.action.cmdb.save.exit
0031                       ;-------------------------------------------------------
0032                       ; Get filename
0033                       ;-------------------------------------------------------
0034 6B70 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0035 6B72 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6B74 A728     
0036               
0037 6B76 06A0  32         bl    @cpym2m
     6B78 24EE     
0038 6B7A A728                   data cmdb.cmdlen,heap.top,80
     6B7C F000     
     6B7E 0050     
0039                                                   ; Copy filename from command line to buffer
0040                       ;-------------------------------------------------------
0041                       ; Pass filename as parm1
0042                       ;-------------------------------------------------------
0043 6B80 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6B82 F000     
0044 6B84 C804  38         mov   tmp0,@parm1
     6B86 A000     
0045                       ;-------------------------------------------------------
0046                       ; Save all lines in editor buffer?
0047                       ;-------------------------------------------------------
0048 6B88 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6B8A A50E     
     6B8C 2022     
0049 6B8E 130B  14         jeq   edkey.action.cmdb.save.all
0050                                                   ; Yes, so save all lines in editor buffer
0051                       ;-------------------------------------------------------
0052                       ; Only save code block M1-M2
0053                       ;-------------------------------------------------------
0054 6B90 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     6B92 A50C     
     6B94 A002     
0055 6B96 0620  34         dec   @parm2                ; /
     6B98 A002     
0056               
0057 6B9A C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     6B9C A50E     
     6B9E A004     
0058               
0059 6BA0 0204  20         li    tmp0,id.file.saveblock
     6BA2 0005     
0060 6BA4 1007  14         jmp   edkey.action.cmdb.save.file
0061                       ;-------------------------------------------------------
0062                       ; Save all lines in editor buffer
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.all:
0065 6BA6 04E0  34         clr   @parm2                ; First line to save
     6BA8 A002     
0066 6BAA C820  54         mov   @edb.lines,@parm3     ; Last line to save
     6BAC A504     
     6BAE A004     
0067               
0068 6BB0 0204  20         li    tmp0,id.file.savefile
     6BB2 0004     
0069                       ;-------------------------------------------------------
0070                       ; Save file
0071                       ;-------------------------------------------------------
0072               edkey.action.cmdb.save.file:
0073 6BB4 C804  38         mov   tmp0,@parm4           ; Set work mode
     6BB6 A006     
0074               
0075 6BB8 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6BBA 7912     
0076                                                   ; \ i  parm1 = Pointer to length-prefixed
0077                                                   ; |            device/filename string
0078                                                   ; | i  parm2 = First line to save (base 0)
0079                                                   ; | i  parm3 = Last line to save  (base 0)
0080                                                   ; | i  parm4 = Work mode
0081                                                   ; /
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.cmdb.save.exit:
0086 6BBC C839  50         mov   *stack+,@parm1        ; Pop top row
     6BBE A000     
0087 6BC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6BC2 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6BC4 6406     
0089                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.31063
0097                       copy  "edkey.cmdb.file.print.asm"   ; Print file
     **** ****     > edkey.cmdb.file.print.asm
0001               * FILE......: edkey.cmdb.fíle.print.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Print file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.print:
0008 6BC6 0649  14         dect  stack
0009 6BC8 C644  30         mov   tmp0,*stack           ; Push tmp0
0010 6BCA 0649  14         dect  stack
0011 6BCC C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     6BCE A304     
0012                       ;-------------------------------------------------------
0013                       ; Print file
0014                       ;-------------------------------------------------------
0015 6BD0 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6BD2 7A02     
0016               
0017 6BD4 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6BD6 7A2A     
0018 6BD8 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6BDA A010     
0019 6BDC 1607  14         jne   !                     ; No, prepare for print
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 6BDE 0204  20         li    tmp0,txt.io.nofile    ; \
     6BE0 39FE     
0024 6BE2 C804  38         mov   tmp0,@parm1           ; / Error message
     6BE4 A000     
0025               
0026 6BE6 06A0  32         bl    @error.display        ; Show error message
     6BE8 79E4     
0027                                                   ; \ i  @parm1 = Pointer to error message
0028                                                   ; /
0029               
0030 6BEA 1026  14         jmp   edkey.action.cmdb.print.exit
0031                       ;-------------------------------------------------------
0032                       ; Get filename
0033                       ;-------------------------------------------------------
0034 6BEC 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0035 6BEE D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6BF0 A728     
0036               
0037 6BF2 06A0  32         bl    @cpym2m
     6BF4 24EE     
0038 6BF6 A728                   data cmdb.cmdlen,heap.top,80
     6BF8 F000     
     6BFA 0050     
0039                                                   ; Copy filename from command line to buffer
0040                       ;-------------------------------------------------------
0041                       ; Pass filename as parm1
0042                       ;-------------------------------------------------------
0043 6BFC 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6BFE F000     
0044 6C00 C804  38         mov   tmp0,@parm1
     6C02 A000     
0045                       ;-------------------------------------------------------
0046                       ; Print all lines in editor buffer?
0047                       ;-------------------------------------------------------
0048 6C04 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6C06 A50E     
     6C08 2022     
0049 6C0A 130B  14         jeq   edkey.action.cmdb.print.all
0050                                                   ; Yes, so print all lines in editor buffer
0051                       ;-------------------------------------------------------
0052                       ; Only print code block M1-M2
0053                       ;-------------------------------------------------------
0054 6C0C C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     6C0E A50C     
     6C10 A002     
0055 6C12 0620  34         dec   @parm2                ; /
     6C14 A002     
0056               
0057 6C16 C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     6C18 A50E     
     6C1A A004     
0058               
0059 6C1C 0204  20         li    tmp0,id.file.printblock
     6C1E 0008     
0060 6C20 1007  14         jmp   edkey.action.cmdb.print.file
0061                       ;-------------------------------------------------------
0062                       ; Print all lines in editor buffer
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.print.all:
0065 6C22 04E0  34         clr   @parm2                ; First line to save
     6C24 A002     
0066 6C26 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     6C28 A504     
     6C2A A004     
0067               
0068 6C2C 0204  20         li    tmp0,id.file.printfile
     6C2E 0007     
0069                       ;-------------------------------------------------------
0070                       ; Print file
0071                       ;-------------------------------------------------------
0072               edkey.action.cmdb.Print.file:
0073 6C30 C804  38         mov   tmp0,@parm4           ; Set work mode
     6C32 A006     
0074               
0075 6C34 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6C36 7912     
0076                                                   ; \ i  parm1 = Pointer to length-prefixed
0077                                                   ; |            device/filename string
0078                                                   ; | i  parm2 = First line to save (base 0)
0079                                                   ; | i  parm3 = Last line to save  (base 0)
0080                                                   ; | i  parm4 = Work mode
0081                                                   ; /
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.cmdb.print.exit:
0086 6C38 C839  50         mov   *stack+,@parm1        ; Pop top row
     6C3A A000     
0087 6C3C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6C3E 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6C40 6406     
0089                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.31063
0098                       copy  "edkey.cmdb.dialog.asm"       ; Dialog specific actions
     **** ****     > edkey.cmdb.dialog.asm
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
0011               * @cmdb.action.ptr = Pointer to keyboard action to perform
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.cmdb.proceed:
0017                       ;-------------------------------------------------------
0018                       ; Intialisation
0019                       ;-------------------------------------------------------
0020 6C42 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     6C44 A506     
0021 6C46 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     6C48 74D4     
0022 6C4A 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6C4C 7A20     
0023 6C4E C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6C50 A726     
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 6C52 0284  22         ci    tmp0,>2000
     6C54 2000     
0028 6C56 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 6C58 0284  22         ci    tmp0,>7fff
     6C5A 7FFF     
0031 6C5C 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 6C5E 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 6C60 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6C62 FFCE     
0040 6C64 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C66 2026     
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 6C68 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6C6A 7156     
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
0063 6C6C 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6C6E 7A52     
0064 6C70 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6C72 A718     
0065 6C74 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6C76 7156     
0066               
0067               
0068               ***************************************************************
0069               * edkey.action.cmdb.sid.toggle
0070               * Toggle 'Show SID' on/off
0071               ***************************************************************
0072               * b   @edkey.action.cmdb.sid.toggle
0073               *--------------------------------------------------------------
0074               * INPUT
0075               * none
0076               *--------------------------------------------------------------
0077               * Register usage
0078               * none
0079               ********|*****|*********************|**************************
0080               edkey.action.cmdb.sid.toggle:
0081 6C78 06A0  32        bl    @tibasic.sid.toggle    ; Toggle SID mode.
     6C7A 7A48     
0082 6C7C 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6C7E A718     
0083 6C80 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6C82 7156     
0084               
0085               
0086               
0087               ***************************************************************
0088               * edkey.action.cmdb.preset
0089               * Set command value to preset
0090               ***************************************************************
0091               * b   @edkey.action.cmdb.preset
0092               *--------------------------------------------------------------
0093               * INPUT
0094               * none
0095               *--------------------------------------------------------------
0096               * Register usage
0097               * none
0098               ********|*****|*********************|**************************
0099               edkey.action.cmdb.preset:
0100 6C84 06A0  32        bl    @cmdb.cmd.preset       ; Set preset
     6C86 7A34     
0101 6C88 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6C8A 7156     
0102               
0103               
0104               
0105               ***************************************************************
0106               * dialog.close
0107               * Close dialog "About"
0108               ***************************************************************
0109               * b   @edkey.action.cmdb.close.about
0110               *--------------------------------------------------------------
0111               * OUTPUT
0112               * none
0113               *--------------------------------------------------------------
0114               * Register usage
0115               * none
0116               ********|*****|*********************|**************************
0117               edkey.action.cmdb.close.about:
0118                       ;------------------------------------------------------
0119                       ; Erase header line
0120                       ;------------------------------------------------------
0121 6C8C 06A0  32         bl    @hchar
     6C8E 27E6     
0122 6C90 0000                   byte 0,0,32,80*2
     6C92 20A0     
0123 6C94 FFFF                   data EOL
0124 6C96 1000  14         jmp   edkey.action.cmdb.close.dialog
0125               
0126               
0127               
0128               ***************************************************************
0129               * edkey.action.cmdb.close.dialog
0130               * Close dialog
0131               ***************************************************************
0132               * b   @edkey.action.cmdb.close.dialog
0133               *--------------------------------------------------------------
0134               * OUTPUT
0135               * none
0136               *--------------------------------------------------------------
0137               * Register usage
0138               * none
0139               ********|*****|*********************|**************************
0140               edkey.action.cmdb.close.dialog:
0141                       ;------------------------------------------------------
0142                       ; Close dialog
0143                       ;------------------------------------------------------
0144 6C98 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6C9A A71A     
0145 6C9C 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6C9E 74D4     
0146 6CA0 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6CA2 7A02     
0147 6CA4 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6CA6 A318     
0148                       ;-------------------------------------------------------
0149                       ; Exit
0150                       ;-------------------------------------------------------
0151               edkey.action.cmdb.close.dialog.exit:
0152 6CA8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6CAA 7156     
                   < stevie_b1.asm.31063
0099                       ;-----------------------------------------------------------------------
0100                       ; Logic for Framebuffer (1)
0101                       ;-----------------------------------------------------------------------
0102                       copy  "fb.utils.asm"                ; Framebuffer utilities
     **** ****     > fb.utils.asm
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
0024 6CAC 0649  14         dect  stack
0025 6CAE C64B  30         mov   r11,*stack            ; Save return address
0026 6CB0 0649  14         dect  stack
0027 6CB2 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6CB4 C120  34         mov   @parm1,tmp0
     6CB6 A000     
0032 6CB8 A120  34         a     @fb.topline,tmp0
     6CBA A304     
0033 6CBC C804  38         mov   tmp0,@outparm1
     6CBE A010     
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 6CC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6CC2 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6CC4 045B  20         b     *r11                  ; Return to caller
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
0068 6CC6 0649  14         dect  stack
0069 6CC8 C64B  30         mov   r11,*stack            ; Save return address
0070 6CCA 0649  14         dect  stack
0071 6CCC C644  30         mov   tmp0,*stack           ; Push tmp0
0072 6CCE 0649  14         dect  stack
0073 6CD0 C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 6CD2 C120  34         mov   @fb.row,tmp0
     6CD4 A306     
0078 6CD6 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6CD8 A30E     
0079 6CDA A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     6CDC A30C     
0080 6CDE A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     6CE0 A300     
0081 6CE2 C805  38         mov   tmp1,@fb.current
     6CE4 A302     
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 6CE6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 6CE8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6CEA C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6CEC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0103                       copy  "fb.cursor.up.asm"            ; Cursor up
     **** ****     > fb.cursor.up.asm
0001               * FILE......: fb.cursor.up.asm
0002               * Purpose...: Move the cursor up 1 line
0003               
0004               
0005               ***************************************************************
0006               * fb.cursor.up
0007               * Logic for moving cursor up 1 line
0008               ***************************************************************
0009               * bl @fb.cursor.up
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
0020               fb.cursor.up
0021 6CEE 0649  14         dect  stack
0022 6CF0 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;-------------------------------------------------------
0024                       ; Crunch current line if dirty
0025                       ;-------------------------------------------------------
0026 6CF2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6CF4 A318     
0027 6CF6 8820  54         c     @fb.row.dirty,@w$ffff
     6CF8 A30A     
     6CFA 2022     
0028 6CFC 1604  14         jne   fb.cursor.up.cursor
0029 6CFE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6D00 6F62     
0030 6D02 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6D04 A30A     
0031                       ;-------------------------------------------------------
0032                       ; Move cursor
0033                       ;-------------------------------------------------------
0034               fb.cursor.up.cursor:
0035 6D06 C120  34         mov   @fb.row,tmp0
     6D08 A306     
0036 6D0A 150B  14         jgt   fb.cursor.up.cursor_up
0037                                                   ; Move cursor up if fb.row > 0
0038 6D0C C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6D0E A304     
0039 6D10 130C  14         jeq   fb.cursor.up.set_cursorx
0040                                                   ; At top, only position cursor X
0041                       ;-------------------------------------------------------
0042                       ; Scroll 1 line
0043                       ;-------------------------------------------------------
0044 6D12 0604  14         dec   tmp0                  ; fb.topline--
0045 6D14 C804  38         mov   tmp0,@parm1           ; Scroll one line up
     6D16 A000     
0046               
0047 6D18 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6D1A 6EB6     
0048                                                   ; | i  @parm1 = Line to start with
0049                                                   ; /             (becomes @fb.topline)
0050               
0051 6D1C 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6D1E A310     
0052 6D20 1004  14         jmp   fb.cursor.up.set_cursorx
0053                       ;-------------------------------------------------------
0054                       ; Move cursor up
0055                       ;-------------------------------------------------------
0056               fb.cursor.up.cursor_up:
0057 6D22 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6D24 A306     
0058 6D26 06A0  32         bl    @up                   ; Row-- VDP cursor
     6D28 26E8     
0059                       ;-------------------------------------------------------
0060                       ; Check line length and position cursor
0061                       ;-------------------------------------------------------
0062               fb.cursor.up.set_cursorx:
0063 6D2A 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6D2C 36A0     
0064                                                   ; | i  @fb.row        = Row in frame buffer
0065                                                   ; / o  @fb.row.length = Length of row
0066               
0067 6D2E 8820  54         c     @fb.column,@fb.row.length
     6D30 A30C     
     6D32 A308     
0068 6D34 1207  14         jle   fb.cursor.up.exit
0069                       ;-------------------------------------------------------
0070                       ; Adjust cursor column position
0071                       ;-------------------------------------------------------
0072 6D36 C820  54         mov   @fb.row.length,@fb.column
     6D38 A308     
     6D3A A30C     
0073 6D3C C120  34         mov   @fb.column,tmp0
     6D3E A30C     
0074 6D40 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6D42 26F2     
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               fb.cursor.up.exit:
0079 6D44 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6D46 6CC6     
0080 6D48 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 6D4A 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.31063
0104                       copy  "fb.cursor.down.asm"          ; Cursor down
     **** ****     > fb.cursor.down.asm
0001               * FILE......: fb.cursor.down.asm
0002               * Purpose...: Move the cursor down 1 line
0003               
0004               
0005               ***************************************************************
0006               * fb.cursor.down
0007               * Logic for moving cursor down 1 line
0008               ***************************************************************
0009               * bl @fb.cursor.down
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
0020               fb.cursor.down:
0021 6D4C 0649  14         dect  stack
0022 6D4E C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Last line?
0025                       ;------------------------------------------------------
0026 6D50 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6D52 A306     
     6D54 A504     
0027 6D56 1332  14         jeq   fb.cursor.down.exit
0028                                                   ; Yes, skip further processing
0029 6D58 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6D5A A318     
0030                       ;-------------------------------------------------------
0031                       ; Crunch current row if dirty
0032                       ;-------------------------------------------------------
0033 6D5C 8820  54         c     @fb.row.dirty,@w$ffff
     6D5E A30A     
     6D60 2022     
0034 6D62 1604  14         jne   fb.cursor.down.move
0035 6D64 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6D66 6F62     
0036 6D68 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6D6A A30A     
0037                       ;-------------------------------------------------------
0038                       ; Move cursor
0039                       ;-------------------------------------------------------
0040               fb.cursor.down.move:
0041                       ;-------------------------------------------------------
0042                       ; EOF reached?
0043                       ;-------------------------------------------------------
0044 6D6C C120  34         mov   @fb.topline,tmp0
     6D6E A304     
0045 6D70 A120  34         a     @fb.row,tmp0
     6D72 A306     
0046 6D74 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6D76 A504     
0047 6D78 1314  14         jeq   fb.cursor.down.set_cursorx
0048                                                   ; Yes, only position cursor X
0049                       ;-------------------------------------------------------
0050                       ; Check if scrolling required
0051                       ;-------------------------------------------------------
0052 6D7A C120  34         mov   @fb.scrrows,tmp0
     6D7C A31A     
0053 6D7E 0604  14         dec   tmp0
0054 6D80 8120  34         c     @fb.row,tmp0
     6D82 A306     
0055 6D84 110A  14         jlt   fb.cursor.down.cursor
0056                       ;-------------------------------------------------------
0057                       ; Scroll 1 line
0058                       ;-------------------------------------------------------
0059 6D86 C820  54         mov   @fb.topline,@parm1
     6D88 A304     
     6D8A A000     
0060 6D8C 05A0  34         inc   @parm1
     6D8E A000     
0061               
0062 6D90 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6D92 6EB6     
0063                                                   ; | i  @parm1 = Line to start with
0064                                                   ; /             (becomes @fb.topline)
0065               
0066 6D94 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6D96 A310     
0067 6D98 1004  14         jmp   fb.cursor.down.set_cursorx
0068                       ;-------------------------------------------------------
0069                       ; Move cursor down a row, there are still rows left
0070                       ;-------------------------------------------------------
0071               fb.cursor.down.cursor:
0072 6D9A 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6D9C A306     
0073 6D9E 06A0  32         bl    @down                 ; Row++ VDP cursor
     6DA0 26E0     
0074                       ;-------------------------------------------------------
0075                       ; Check line length and position cursor
0076                       ;-------------------------------------------------------
0077               fb.cursor.down.set_cursorx:
0078 6DA2 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6DA4 36A0     
0079                                                   ; | i  @fb.row        = Row in frame buffer
0080                                                   ; / o  @fb.row.length = Length of row
0081               
0082 6DA6 8820  54         c     @fb.column,@fb.row.length
     6DA8 A30C     
     6DAA A308     
0083 6DAC 1207  14         jle   fb.cursor.down.exit
0084                                                   ; Exit
0085                       ;-------------------------------------------------------
0086                       ; Adjust cursor column position
0087                       ;-------------------------------------------------------
0088 6DAE C820  54         mov   @fb.row.length,@fb.column
     6DB0 A308     
     6DB2 A30C     
0089 6DB4 C120  34         mov   @fb.column,tmp0
     6DB6 A30C     
0090 6DB8 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6DBA 26F2     
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               fb.cursor.down.exit:
0095 6DBC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6DBE 6CC6     
0096 6DC0 C2F9  30         mov   *stack+,r11           ; Pop r11
0097 6DC2 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.31063
0105                       copy  "fb.cursor.home.asm"          ; Cursor home
     **** ****     > fb.cursor.home.asm
0001               * FILE......: fb.cursor.home.asm
0002               * Purpose...: Move the cursor home
0003               
0004               
0005               ***************************************************************
0006               * fb.cursor.home
0007               * Logic for moving cursor home
0008               ***************************************************************
0009               * bl @fb.cursor.home
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               fb.cursor.home:
0021 6DC4 0649  14         dect  stack
0022 6DC6 C64B  30         mov   r11,*stack            ; Save return address
0023 6DC8 0649  14         dect  stack
0024 6DCA C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;------------------------------------------------------
0026                       ; Cursor home
0027                       ;------------------------------------------------------
0028 6DCC 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6DCE A318     
0029 6DD0 C120  34         mov   @wyx,tmp0
     6DD2 832A     
0030 6DD4 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     6DD6 FF00     
0031 6DD8 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6DDA 832A     
0032 6DDC 04E0  34         clr   @fb.column
     6DDE A30C     
0033 6DE0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6DE2 6CC6     
0034 6DE4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6DE6 A318     
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               fb.cursor.home.exit:
0039 6DE8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0040 6DEA C2F9  30         mov   *stack+,r11           ; Pop r11
0041 6DEC 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.31063
0106                       copy  "fb.insert.line.asm"          ; Insert new line
     **** ****     > fb.insert.line.asm
0001               * FILE......: fb.insert.line.asm
0002               * Purpose...: Insert a new line
0003               
0004               ***************************************************************
0005               * fb.insert.line.asm
0006               * Logic for inserting a new line
0007               ***************************************************************
0008               * bl @fb.insert.line
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
0019               fb.insert.line:
0020 6DEE 0649  14         dect  stack
0021 6DF0 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Initialisation
0024                       ;-------------------------------------------------------
0025 6DF2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6DF4 A506     
0026                       ;-------------------------------------------------------
0027                       ; Crunch current line if dirty
0028                       ;-------------------------------------------------------
0029 6DF6 8820  54         c     @fb.row.dirty,@w$ffff
     6DF8 A30A     
     6DFA 2022     
0030 6DFC 1604  14         jne   fb.insert.line.insert
0031 6DFE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6E00 6F62     
0032 6E02 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6E04 A30A     
0033                       ;-------------------------------------------------------
0034                       ; Insert entry in index
0035                       ;-------------------------------------------------------
0036               fb.insert.line.insert:
0037 6E06 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6E08 6CC6     
0038 6E0A C820  54         mov   @fb.topline,@parm1
     6E0C A304     
     6E0E A000     
0039 6E10 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6E12 A306     
     6E14 A000     
0040 6E16 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6E18 A504     
     6E1A A002     
0041               
0042 6E1C 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6E1E 35AE     
0043                                                   ; \ i  parm1 = Line for insert
0044                                                   ; / i  parm2 = Last line to reorg
0045               
0046 6E20 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6E22 A504     
0047 6E24 04E0  34         clr   @fb.row.length        ; Current row length = 0
     6E26 A308     
0048                       ;-------------------------------------------------------
0049                       ; Check/Adjust marker M1
0050                       ;-------------------------------------------------------
0051               fb.insert.line.m1:
0052 6E28 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6E2A A50C     
     6E2C 2022     
0053 6E2E 1308  14         jeq   fb.insert.line.m2
0054                                                   ; Yes, skip to M2 check
0055               
0056 6E30 8820  54         c     @parm1,@edb.block.m1
     6E32 A000     
     6E34 A50C     
0057 6E36 1504  14         jgt   fb.insert.line.m2
0058 6E38 05A0  34         inc   @edb.block.m1         ; M1++
     6E3A A50C     
0059 6E3C 0720  34         seto  @fb.colorize          ; Set colorize flag
     6E3E A310     
0060                       ;-------------------------------------------------------
0061                       ; Check/Adjust marker M2
0062                       ;-------------------------------------------------------
0063               fb.insert.line.m2:
0064 6E40 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6E42 A50E     
     6E44 2022     
0065 6E46 1308  14         jeq   fb.insert.line.refresh
0066                                                   ; Yes, skip to refresh frame buffer
0067               
0068 6E48 8820  54         c     @parm1,@edb.block.m2
     6E4A A000     
     6E4C A50E     
0069 6E4E 1504  14         jgt   fb.insert.line.refresh
0070 6E50 05A0  34         inc   @edb.block.m2         ; M2++
     6E52 A50E     
0071 6E54 0720  34         seto  @fb.colorize          ; Set colorize flag
     6E56 A310     
0072                       ;-------------------------------------------------------
0073                       ; Refresh frame buffer and physical screen
0074                       ;-------------------------------------------------------
0075               fb.insert.line.refresh:
0076 6E58 C820  54         mov   @fb.topline,@parm1
     6E5A A304     
     6E5C A000     
0077               
0078 6E5E 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6E60 6EB6     
0079                                                   ; | i  @parm1 = Line to start with
0080                                                   ; /             (becomes @fb.topline)
0081               
0082 6E62 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6E64 A316     
0083 6E66 06A0  32         bl    @fb.cursor.home       ; Move cursor home
     6E68 6DC4     
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               fb.insert.line.exit:
0088 6E6A C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6E6C 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.31063
0107                       copy  "fb.get.firstnonblank.asm"    ; Get column of first non-blank char
     **** ****     > fb.get.firstnonblank.asm
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
0015 6E6E 0649  14         dect  stack
0016 6E70 C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6E72 04E0  34         clr   @fb.column
     6E74 A30C     
0021 6E76 06A0  32         bl    @fb.calc_pointer
     6E78 6CC6     
0022 6E7A 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6E7C 36A0     
0023 6E7E C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6E80 A308     
0024 6E82 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6E84 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6E86 A302     
0027 6E88 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6E8A D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6E8C 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6E8E 0285  22         ci    tmp1,>2000            ; Whitespace?
     6E90 2000     
0036 6E92 1503  14         jgt   fb.get.firstnonblank.match
0037 6E94 0606  14         dec   tmp2                  ; Counter--
0038 6E96 16F9  14         jne   fb.get.firstnonblank.loop
0039 6E98 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6E9A 6120  34         s     @fb.current,tmp0      ; Calculate column
     6E9C A302     
0045 6E9E 0604  14         dec   tmp0
0046 6EA0 C804  38         mov   tmp0,@outparm1        ; Save column
     6EA2 A010     
0047 6EA4 D805  38         movb  tmp1,@outparm2        ; Save character
     6EA6 A012     
0048 6EA8 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6EAA 04E0  34         clr   @outparm1             ; X=0
     6EAC A010     
0054 6EAE 04E0  34         clr   @outparm2             ; Null
     6EB0 A012     
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6EB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6EB4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0108                       copy  "fb.refresh.asm"              ; Refresh framebuffer
     **** ****     > fb.refresh.asm
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
0020 6EB6 0649  14         dect  stack
0021 6EB8 C64B  30         mov   r11,*stack            ; Push return address
0022 6EBA 0649  14         dect  stack
0023 6EBC C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6EBE 0649  14         dect  stack
0025 6EC0 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6EC2 0649  14         dect  stack
0027 6EC4 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6EC6 C820  54         mov   @parm1,@fb.topline
     6EC8 A000     
     6ECA A304     
0032 6ECC 04E0  34         clr   @parm2                ; Target row in frame buffer
     6ECE A002     
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6ED0 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6ED2 A000     
     6ED4 A504     
0037 6ED6 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6ED8 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6EDA 705A     
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6EDC 05A0  34         inc   @parm1                ; Next line in editor buffer
     6EDE A000     
0048 6EE0 05A0  34         inc   @parm2                ; Next row in frame buffer
     6EE2 A002     
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6EE4 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6EE6 A000     
     6EE8 A504     
0053 6EEA 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6EEC 8820  54         c     @parm2,@fb.scrrows
     6EEE A002     
     6EF0 A31A     
0056 6EF2 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6EF4 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6EF6 C120  34         mov   @parm2,tmp0           ; Current row
     6EF8 A002     
0064 6EFA C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6EFC A31A     
0065 6EFE 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6F00 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6F02 A30E     
0067               
0068 6F04 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6F06 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6F08 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6F0A A30E     
0072 6F0C A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6F0E A300     
0073               
0074 6F10 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6F12 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6F14 06A0  32         bl    @xfilm                ; \ Fill memory
     6F16 2250     
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6F18 0720  34         seto  @fb.dirty             ; Refresh screen
     6F1A A316     
0086               
0087 6F1C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0088 6F1E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0089 6F20 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0090 6F22 C2F9  30         mov   *stack+,r11           ; Pop r11
0091 6F24 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0109                       copy  "fb.restore.asm"              ; Restore framebuffer to normal opr.
     **** ****     > fb.restore.asm
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
0021 6F26 0649  14         dect  stack
0022 6F28 C64B  30         mov   r11,*stack            ; Save return address
0023 6F2A 0649  14         dect  stack
0024 6F2C C660  46         mov   @parm1,*stack         ; Push @parm1
     6F2E A000     
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6F30 C820  54         mov   @fb.topline,@parm1
     6F32 A304     
     6F34 A000     
0029 6F36 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6F38 6EB6     
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6F3A 0720  34         seto  @parm1                ; Skip Asserts
     6F3C A000     
0035 6F3E 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6F40 7A92     
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6F42 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6F44 A218     
     6F46 A000     
0042 6F48 06A0  32         bl    @pane.action.colorscheme.statlines
     6F4A 749C     
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6F4C 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6F4E A318     
0050               
0051 6F50 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6F52 74D4     
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6F54 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6F56 A000     
0057 6F58 C820  54         mov   @parm1,@wyx           ; Set cursor position
     6F5A A000     
     6F5C 832A     
0058 6F5E C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6F60 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.31063
0110                       ;-----------------------------------------------------------------------
0111                       ; Logic for Editor Buffer
0112                       ;-----------------------------------------------------------------------
0113                       copy  "edb.line.pack.fb.asm"        ; Pack line into editor buffer
     **** ****     > edb.line.pack.fb.asm
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
0027 6F62 0649  14         dect  stack
0028 6F64 C64B  30         mov   r11,*stack            ; Save return address
0029 6F66 0649  14         dect  stack
0030 6F68 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6F6A 0649  14         dect  stack
0032 6F6C C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6F6E 0649  14         dect  stack
0034 6F70 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 6F72 0649  14         dect  stack
0036 6F74 C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 6F76 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6F78 A30C     
     6F7A A100     
0041 6F7C 04E0  34         clr   @fb.column
     6F7E A30C     
0042 6F80 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6F82 6CC6     
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 6F84 04C4  14         clr   tmp0                  ; Counter
0047 6F86 04C7  14         clr   tmp3                  ; Counter for whitespace
0048 6F88 C160  34         mov   @fb.current,tmp1      ; Get position
     6F8A A302     
0049 6F8C C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6F8E A102     
0050                       ;------------------------------------------------------
0051                       ; Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 6F90 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 6F92 0986  56         srl   tmp2,8                ; Right justify
0056 6F94 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 6F96 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 6F98 0286  22         ci    tmp2,32               ; Was it a space character?
     6F9A 0020     
0063 6F9C 1301  14         jeq   edb.line.pack.fb.check80
0064 6F9E C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 6FA0 0284  22         ci    tmp0,colrow
     6FA2 0050     
0070 6FA4 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 6FA6 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 6FA8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FAA FFCE     
0078 6FAC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FAE 2026     
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 6FB0 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 6FB2 1103  14         jlt   edb.line.pack.fb.rtrim
0085 6FB4 C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     6FB6 A104     
0086 6FB8 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 6FBA C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     6FBC A104     
0092               
0093 6FBE 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 6FC0 C184  18         mov   tmp0,tmp2             ; \
0096 6FC2 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 6FC4 0586  14         inc   tmp2                  ; /
0098               
0099 6FC6 C107  18         mov   tmp3,tmp0             ; \
0100 6FC8 A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     6FCA A102     
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 6FCC DD05  32         movb  tmp1,*tmp0+
0104 6FCE 0606  14         dec   tmp2
0105 6FD0 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 6FD2 06A0  32 !       bl    @edb.hipage.alloc     ; Check and increase highest SAMS page
     6FD4 7AC0     
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; Step 2: Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 6FD6 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6FD8 A304     
     6FDA A000     
0117 6FDC A820  54         a     @fb.row,@parm1        ; /
     6FDE A306     
     6FE0 A000     
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 6FE2 C820  54         mov   @edb.next_free.ptr,@parm2
     6FE4 A508     
     6FE6 A002     
0123                                                   ; Pointer to new line
0124 6FE8 C820  54         mov   @edb.sams.hipage,@parm3
     6FEA A518     
     6FEC A004     
0125                                                   ; SAMS page to use
0126               
0127 6FEE 06A0  32         bl    @idx.entry.update     ; Update index
     6FF0 345E     
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 6FF2 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6FF4 A102     
0136 6FF6 C160  34         mov   @edb.next_free.ptr,tmp1
     6FF8 A508     
0137                                                   ; Address of line in editor buffer
0138               
0139 6FFA 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6FFC A508     
0140               
0141 6FFE C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     7000 A104     
0142 7002 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 7004 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 7006 0286  22         ci    tmp2,2
     7008 0002     
0150 700A 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 700C DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 700E DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 7010 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 7012 0286  22         ci    tmp2,1
     7014 0001     
0157 7016 1602  14         jne   edb.line.pack.fb.copyline.block
0158 7018 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 701A 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 701C 06A0  32         bl    @xpym2m               ; Copy memory block
     701E 24F4     
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 7020 A820  54         a     @rambuf+4,@edb.next_free.ptr
     7022 A104     
     7024 A508     
0171                                                      ; Add length of line
0172               
0173 7026 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7028 A508     
0174 702A 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 702C 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     702E 000F     
0176 7030 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     7032 A508     
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 7034 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7036 A100     
     7038 A30C     
0182               
0183 703A 8820  54         c     @edb.sams.hipage,@edb.sams.page
     703C A518     
     703E A516     
0184 7040 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 7042 C120  34         mov   @edb.sams.page,tmp0
     7044 A516     
0187 7046 C160  34         mov   @edb.top.ptr,tmp1
     7048 A500     
0188 704A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     704C 258A     
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 704E C1B9  30         mov   *stack+,tmp2          ; Pop tmp3
0196 7050 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 7052 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 7054 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 7056 C2F9  30         mov   *stack+,r11           ; Pop R11
0200 7058 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0114                       copy  "edb.line.unpack.fb.asm"      ; Unpack line from editor buffer
     **** ****     > edb.line.unpack.fb.asm
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
0028 705A 0649  14         dect  stack
0029 705C C64B  30         mov   r11,*stack            ; Save return address
0030 705E 0649  14         dect  stack
0031 7060 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 7062 0649  14         dect  stack
0033 7064 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 7066 0649  14         dect  stack
0035 7068 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 706A C820  54         mov   @parm1,@rambuf
     706C A000     
     706E A100     
0040 7070 C820  54         mov   @parm2,@rambuf+2
     7072 A002     
     7074 A102     
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 7076 C120  34         mov   @fb.colsline,tmp0
     7078 A30E     
0045 707A 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     707C A002     
0046 707E C1A0  34         mov   @fb.top.ptr,tmp2
     7080 A300     
0047 7082 A146  18         a     tmp2,tmp1             ; Add base to offset
0048 7084 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7086 A106     
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 7088 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     708A A000     
     708C A504     
0053 708E 1103  14         jlt   !                     ; No, continue processing
0054               
0055 7090 04E0  34         clr   @rambuf+8             ; Set length=0
     7092 A108     
0056 7094 1018  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 7096 C120  34 !       mov   @parm1,tmp0
     7098 A000     
0061 709A 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     709C 3606     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 709E C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     70A0 A010     
0069 70A2 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 70A4 04E0  34         clr   @rambuf+8             ; Set length=0
     70A6 A108     
0073 70A8 100E  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 70AA C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 70AC C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     70AE A104     
0080 70B0 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     70B2 A108     
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 70B4 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     70B6 0050     
0085                                                   ; /
0086 70B8 1206  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 70BA C0E0  34         mov   @rambuf,r3            ; Get Line number to unpack (base 0)
     70BC A100     
0091                                                   ; No purpose, only makes debugging easier
0092               
0093 70BE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70C0 FFCE     
0094 70C2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70C4 2026     
0095                       ;------------------------------------------------------
0096                       ; Erase chars from last column until column 80
0097                       ;------------------------------------------------------
0098               edb.line.unpack.fb.clear:
0099 70C6 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     70C8 A106     
0100 70CA A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     70CC A108     
0101               
0102 70CE 04C5  14         clr   tmp1                  ; Fill with >00
0103 70D0 C1A0  34         mov   @fb.colsline,tmp2
     70D2 A30E     
0104 70D4 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     70D6 A108     
0105 70D8 0586  14         inc   tmp2
0106               
0107 70DA 06A0  32         bl    @xfilm                ; Fill CPU memory
     70DC 2250     
0108                                                   ; \ i  tmp0 = Target address
0109                                                   ; | i  tmp1 = Byte to fill
0110                                                   ; / i  tmp2 = Repeat count
0111                       ;------------------------------------------------------
0112                       ; Prepare for unpacking data
0113                       ;------------------------------------------------------
0114               edb.line.unpack.fb.prepare:
0115 70DE C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     70E0 A108     
0116 70E2 130F  14         jeq   edb.line.unpack.fb.exit
0117                                                   ; Exit if length = 0
0118 70E4 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     70E6 A104     
0119 70E8 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     70EA A106     
0120                       ;------------------------------------------------------
0121                       ; Assert on line length
0122                       ;------------------------------------------------------
0123               edb.line.unpack.fb.copy:
0124 70EC 0286  22         ci    tmp2,80               ; Check line length
     70EE 0050     
0125 70F0 1204  14         jle   edb.line.unpack.fb.copy.doit
0126                       ;------------------------------------------------------
0127                       ; Crash the system
0128                       ;------------------------------------------------------
0129 70F2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70F4 FFCE     
0130 70F6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70F8 2026     
0131                       ;------------------------------------------------------
0132                       ; Copy memory block
0133                       ;------------------------------------------------------
0134               edb.line.unpack.fb.copy.doit:
0135 70FA C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     70FC A010     
0136               
0137 70FE 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7100 24F4     
0138                                                   ; \ i  tmp0 = Source address
0139                                                   ; | i  tmp1 = Target address
0140                                                   ; / i  tmp2 = Bytes to copy
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               edb.line.unpack.fb.exit:
0145 7102 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0146 7104 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0147 7106 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0148 7108 C2F9  30         mov   *stack+,r11           ; Pop r11
0149 710A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0115                       ;-----------------------------------------------------------------------
0116                       ; User hook, background tasks
0117                       ;-----------------------------------------------------------------------
0118                       copy  "hook.keyscan.asm"            ; SP2 user hook: keyboard scan
     **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               
0005               
0006               
0007               
0008               
0009               ****************************************************************
0010               * Editor - spectra2 user hook
0011               ****************************************************************
0012               hook.keyscan:
0013 710C 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     710E 200A     
0014 7110 161C  14         jne   hook.keyscan.clear_kbbuffer
0015                                                   ; No, clear buffer and exit
0016 7112 C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     7114 833C     
     7116 A022     
0017               *---------------------------------------------------------------
0018               * Identical key pressed ?
0019               *---------------------------------------------------------------
0020 7118 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     711A 200A     
0021 711C 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     711E A022     
     7120 A024     
0022 7122 1608  14         jne   hook.keyscan.new      ; New key pressed
0023               *---------------------------------------------------------------
0024               * Activate auto-repeat ?
0025               *---------------------------------------------------------------
0026 7124 05A0  34         inc   @keyrptcnt
     7126 A020     
0027 7128 C120  34         mov   @keyrptcnt,tmp0
     712A A020     
0028 712C 0284  22         ci    tmp0,30
     712E 001E     
0029 7130 1112  14         jlt   hook.keyscan.bounce   ; No, do keyboard bounce delay and return
0030 7132 1002  14         jmp   hook.keyscan.autorepeat
0031               *--------------------------------------------------------------
0032               * New key pressed
0033               *--------------------------------------------------------------
0034               hook.keyscan.new:
0035 7134 04E0  34         clr   @keyrptcnt            ; Reset key-repeat counter
     7136 A020     
0036               hook.keyscan.autorepeat:
0037 7138 0204  20         li    tmp0,250              ; \
     713A 00FA     
0038 713C 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0039 713E 16FE  14         jne   -!                    ; /
0040 7140 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     7142 A022     
     7144 A024     
0041 7146 0460  28         b     @edkey.key.process    ; Process key
     7148 6110     
0042               *--------------------------------------------------------------
0043               * Clear keyboard buffer if no key pressed
0044               *--------------------------------------------------------------
0045               hook.keyscan.clear_kbbuffer:
0046 714A 04E0  34         clr   @keycode1
     714C A022     
0047 714E 04E0  34         clr   @keycode2
     7150 A024     
0048 7152 04E0  34         clr   @keyrptcnt
     7154 A020     
0049               *--------------------------------------------------------------
0050               * Delay to avoid key bouncing
0051               *--------------------------------------------------------------
0052               hook.keyscan.bounce:
0053 7156 0204  20         li    tmp0,2000             ; Avoid key bouncing
     7158 07D0     
0054                       ;------------------------------------------------------
0055                       ; Delay loop
0056                       ;------------------------------------------------------
0057               hook.keyscan.bounce.loop:
0058 715A 0604  14         dec   tmp0
0059 715C 16FE  14         jne   hook.keyscan.bounce.loop
0060 715E 0460  28         b     @hookok               ; Return
     7160 2ED6     
0061               
                   < stevie_b1.asm.31063
0119                       copy  "task.vdp.panes.asm"          ; Draw editor panes in VDP
     **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 7162 0649  14         dect  stack
0009 7164 C64B  30         mov   r11,*stack            ; Save return address
0010                       ;------------------------------------------------------
0011                       ; Dump panes to VDP memory
0012                       ;------------------------------------------------------
0013 7166 06A0  32         bl    @pane.vdpdump
     7168 7800     
0014                       ;------------------------------------------------------
0015                       ; Exit task
0016                       ;------------------------------------------------------
0017               task.vdp.panes.exit:
0018 716A C2F9  30         mov   *stack+,r11           ; Pop r11
0019 716C 0460  28         b     @slotok
     716E 2F52     
                   < stevie_b1.asm.31063
0120               
0122                       copy  "task.vdp.cursor.sat.asm"     ; Copy cursor SAT to VDP
     **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 7170 0649  14         dect  stack
0009 7172 C64B  30         mov   r11,*stack            ; Save return address
0010 7174 0649  14         dect  stack
0011 7176 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7178 0649  14         dect  stack
0013 717A C645  30         mov   tmp1,*stack           ; Push tmp1
0014 717C 0649  14         dect  stack
0015 717E C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 7180 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7182 A222     
0020               
0021 7184 0284  22         ci    tmp0,pane.focus.fb
     7186 0000     
0022 7188 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 718A 0284  22         ci    tmp0,pane.focus.cmdb
     718C 0001     
0025 718E 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 7190 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7192 FFCE     
0031 7194 06A0  32         bl    @cpu.crash            ; / Halt system.
     7196 2026     
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 7198 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     719A A70A     
     719C 832A     
0037 719E E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     71A0 2020     
0038 71A2 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     71A4 26FC     
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 71A6 100C  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 71A8 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     71AA 2020     
0048 71AC 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     71AE 26FC     
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052                       ;------------------------------------------------------
0053                       ; Cursor Y adjustment (topline, ruler, ...)
0054                       ;------------------------------------------------------
0055 71B0 C160  34         mov   @tv.ruler.visible,tmp1
     71B2 A210     
0056 71B4 1303  14         jeq   task.vdp.copy.sat.fb.noruler
0057 71B6 0224  22         ai    tmp0,>1000            ; Adjust VDP cursor because of topline+ruler
     71B8 1000     
0058 71BA 1002  14         jmp   task.vdp.copy.sat.write
0059               
0060               task.vdp.copy.sat.fb.noruler:
0061 71BC 0224  22         ai    tmp0,>0800            ; Adjust VDP cursor because of topline
     71BE 0800     
0062                       ;------------------------------------------------------
0063                       ; Dump sprite attribute table
0064                       ;------------------------------------------------------
0065               task.vdp.copy.sat.write:
0066 71C0 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     71C2 A03C     
0067                       ;------------------------------------------------------
0068                       ; Handle column and row indicators
0069                       ;------------------------------------------------------
0070 71C4 C160  34         mov   @tv.ruler.visible,tmp1
     71C6 A210     
0071                                                   ; Ruler visible?
0072 71C8 1314  14         jeq   task.vdp.copy.sat.hide.indicators
0073                                                   ; Not visible, skip
0074               
0075 71CA C160  34         mov   @cmdb.visible,tmp1
     71CC A702     
0076 71CE 0285  22         ci    tmp1,>ffff            ; CMDB pane visible?
     71D0 FFFF     
0077 71D2 130F  14         jeq   task.vdp.copy.sat.hide.indicators
0078                                                   ; Not visible, skip
0079               
0080 71D4 0244  22         andi  tmp0,>ff00            ; \ Clear X position
     71D6 FF00     
0081 71D8 0264  22         ori   tmp0,240              ; | Line indicator on pixel X 240
     71DA 00F0     
0082 71DC C804  38         mov   tmp0,@ramsat+4        ; / Set line indicator    <
     71DE A040     
0083               
0084 71E0 C120  34         mov   @ramsat,tmp0
     71E2 A03C     
0085 71E4 0244  22         andi  tmp0,>00ff            ; \ Clear Y position
     71E6 00FF     
0086 71E8 0264  22         ori   tmp0,>0800            ; | Column indicator on pixel Y 8
     71EA 0800     
0087 71EC C804  38         mov   tmp0,@ramsat+8        ; / Set column indicator  v
     71EE A044     
0088               
0089 71F0 1005  14         jmp   task.vdp.copy.sat.write2
0090                       ;------------------------------------------------------
0091                       ; Do not show column and row indicators
0092                       ;------------------------------------------------------
0093               task.vdp.copy.sat.hide.indicators:
0094 71F2 04C5  14         clr   tmp1
0095 71F4 D805  38         movb  tmp1,@ramsat+7        ; \ Hide line indicator    <
     71F6 A043     
0096                                                   ; / by transparant color
0097 71F8 D805  38         movb  tmp1,@ramsat+11       ; \ Hide column indicator  v
     71FA A047     
0098                                                   ; / by transparant color
0099                       ;------------------------------------------------------
0100                       ; Dump to VDP
0101                       ;------------------------------------------------------
0102               task.vdp.copy.sat.write2:
0103 71FC 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     71FE 249A     
0104 7200 2180                   data sprsat,ramsat,14 ; \ i  p0 = VDP destination
     7202 A03C     
     7204 000E     
0105                                                   ; | i  p1 = ROM/RAM source
0106                                                   ; / i  p2 = Number of bytes to write
0107                       ;------------------------------------------------------
0108                       ; Exit
0109                       ;------------------------------------------------------
0110               task.vdp.copy.sat.exit:
0111 7206 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0112 7208 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0113 720A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0114 720C C2F9  30         mov   *stack+,r11           ; Pop r11
0115 720E 0460  28         b     @slotok               ; Exit task
     7210 2F52     
                   < stevie_b1.asm.31063
0123                       copy  "task.vdp.cursor.f18a.asm"    ; Set cursor shape in VDP (blink)
     **** ****     > task.vdp.cursor.f18a.asm
0001               * FILE......: task.vdp.cursor.f18a.asm
0002               * Purpose...: VDP sprite cursor shape (F18a version)
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 7212 0649  14         dect  stack
0009 7214 C64B  30         mov   r11,*stack            ; Save return address
0010 7216 0649  14         dect  stack
0011 7218 C644  30         mov   tmp0,*stack           ; Push tmp0
0012                       ;------------------------------------------------------
0013                       ; Toggle cursor
0014                       ;------------------------------------------------------
0015 721A 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     721C A312     
0016 721E 1304  14         jeq   task.vdp.cursor.visible
0017                       ;------------------------------------------------------
0018                       ; Hide cursor
0019                       ;------------------------------------------------------
0020 7220 04C4  14         clr   tmp0
0021 7222 D804  38         movb  tmp0,@ramsat+3        ; Hide cursor
     7224 A03F     
0022 7226 1003  14         jmp   task.vdp.cursor.copy.sat
0023                                                   ; Update VDP SAT and exit task
0024                       ;------------------------------------------------------
0025                       ; Show cursor
0026                       ;------------------------------------------------------
0027               task.vdp.cursor.visible:
0028 7228 C820  54         mov   @tv.curshape,@ramsat+2
     722A A214     
     722C A03E     
0029                                                   ; Get cursor shape and color
0030                       ;------------------------------------------------------
0031                       ; Copy SAT
0032                       ;------------------------------------------------------
0033               task.vdp.cursor.copy.sat:
0034 722E 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7230 249A     
0035 7232 2180                   data sprsat,ramsat,4  ; \ i  p0 = VDP destination
     7234 A03C     
     7236 0004     
0036                                                   ; | i  p1 = ROM/RAM source
0037                                                   ; / i  p2 = Number of bytes to write
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               task.vdp.cursor.exit:
0042 7238 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043 723A C2F9  30         mov   *stack+,r11           ; Pop r11
0044 723C 0460  28         b     @slotok               ; Exit task
     723E 2F52     
                   < stevie_b1.asm.31063
0127               
0128                       copy  "task.oneshot.asm"            ; Run "one shot" task
     **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 7240 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     7242 A224     
0010 7244 1301  14         jeq   task.oneshot.exit
0011               
0012 7246 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 7248 0460  28         b     @slotok                ; Exit task
     724A 2F52     
                   < stevie_b1.asm.31063
0129                       ;-----------------------------------------------------------------------
0130                       ; Screen pane utilities
0131                       ;-----------------------------------------------------------------------
0132                       copy  "pane.utils.colorscheme.asm"  ; Colorscheme handling in panes
     **** ****     > pane.utils.colorscheme.asm
0001               
0002               
0003               
0004               * FILE......: pane.utils.colorscheme.asm
0005               * Purpose...: Stevie Editor - Color scheme for panes
0006               
0007               ***************************************************************
0008               * pane.action.colorscheme.cycle
0009               * Cycle through available color scheme
0010               ***************************************************************
0011               * bl  @pane.action.colorscheme.cycle
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               ********|*****|*********************|**************************
0019               pane.action.colorscheme.cycle:
0020 724C 0649  14         dect  stack
0021 724E C64B  30         mov   r11,*stack            ; Push return address
0022 7250 0649  14         dect  stack
0023 7252 C644  30         mov   tmp0,*stack           ; Push tmp0
0024               
0025 7254 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7256 A212     
0026 7258 0284  22         ci    tmp0,tv.colorscheme.entries
     725A 000A     
0027                                                   ; Last entry reached?
0028 725C 1103  14         jlt   !
0029 725E 0204  20         li    tmp0,1                ; Reset color scheme index
     7260 0001     
0030 7262 1001  14         jmp   pane.action.colorscheme.switch
0031 7264 0584  14 !       inc   tmp0
0032                       ;-------------------------------------------------------
0033                       ; Switch to new color scheme
0034                       ;-------------------------------------------------------
0035               pane.action.colorscheme.switch:
0036 7266 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7268 A212     
0037               
0038 726A 06A0  32         bl    @pane.action.colorscheme.load
     726C 72AA     
0039                                                   ; Load current color scheme
0040                       ;-------------------------------------------------------
0041                       ; Show current color palette message
0042                       ;-------------------------------------------------------
0043 726E C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     7270 832A     
     7272 833C     
0044               
0045 7274 06A0  32         bl    @putnum
     7276 2B32     
0046 7278 003E                   byte 0,62
0047 727A A212                   data tv.colorscheme,rambuf,>3020
     727C A100     
     727E 3020     
0048               
0049 7280 06A0  32         bl    @putat
     7282 2456     
0050 7284 0034                   byte 0,52
0051 7286 3A74                   data txt.colorscheme  ; Show color palette message
0052               
0053 7288 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     728A 833C     
     728C 832A     
0054                       ;-------------------------------------------------------
0055                       ; Delay
0056                       ;-------------------------------------------------------
0057 728E 0204  20         li    tmp0,12000
     7290 2EE0     
0058 7292 0604  14 !       dec   tmp0
0059 7294 16FE  14         jne   -!
0060                       ;-------------------------------------------------------
0061                       ; Setup one shot task for removing message
0062                       ;-------------------------------------------------------
0063 7296 0204  20         li    tmp0,pane.topline.oneshot.clearmsg
     7298 36C4     
0064 729A C804  38         mov   tmp0,@tv.task.oneshot
     729C A224     
0065               
0066 729E 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     72A0 2FC6     
0067 72A2 0003                   data 3                ; / for getting consistent delay
0068                       ;-------------------------------------------------------
0069                       ; Exit
0070                       ;-------------------------------------------------------
0071               pane.action.colorscheme.cycle.exit:
0072 72A4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0073 72A6 C2F9  30         mov   *stack+,r11           ; Pop R11
0074 72A8 045B  20         b     *r11                  ; Return to caller
0075               
0076               
0077               
0078               ***************************************************************
0079               * pane.action.colorscheme.load
0080               * Load color scheme
0081               ***************************************************************
0082               * bl  @pane.action.colorscheme.load
0083               *--------------------------------------------------------------
0084               * INPUT
0085               * @tv.colorscheme = Index into color scheme table
0086               * @parm1          = Skip screen off if >FFFF
0087               * @parm2          = Skip colorizing marked lines if >FFFF
0088               * @parm3          = Only colorize CMDB pane if >FFFF
0089               *--------------------------------------------------------------
0090               * OUTPUT
0091               * none
0092               *--------------------------------------------------------------
0093               * Register usage
0094               * tmp0,tmp1,tmp2,tmp3,tmp4
0095               ********|*****|*********************|**************************
0096               pane.action.colorscheme.load:
0097 72AA 0649  14         dect  stack
0098 72AC C64B  30         mov   r11,*stack            ; Save return address
0099 72AE 0649  14         dect  stack
0100 72B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0101 72B2 0649  14         dect  stack
0102 72B4 C645  30         mov   tmp1,*stack           ; Push tmp1
0103 72B6 0649  14         dect  stack
0104 72B8 C646  30         mov   tmp2,*stack           ; Push tmp2
0105 72BA 0649  14         dect  stack
0106 72BC C647  30         mov   tmp3,*stack           ; Push tmp3
0107 72BE 0649  14         dect  stack
0108 72C0 C648  30         mov   tmp4,*stack           ; Push tmp4
0109 72C2 0649  14         dect  stack
0110 72C4 C660  46         mov   @parm1,*stack         ; Push parm1
     72C6 A000     
0111 72C8 0649  14         dect  stack
0112 72CA C660  46         mov   @parm2,*stack         ; Push parm2
     72CC A002     
0113 72CE 0649  14         dect  stack
0114 72D0 C660  46         mov   @parm3,*stack         ; Push parm3
     72D2 A004     
0115                       ;-------------------------------------------------------
0116                       ; Turn screen off
0117                       ;-------------------------------------------------------
0118 72D4 C120  34         mov   @parm1,tmp0
     72D6 A000     
0119 72D8 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     72DA FFFF     
0120 72DC 1302  14         jeq   !                     ; Yes, so skip screen off
0121 72DE 06A0  32         bl    @scroff               ; Turn screen off
     72E0 269A     
0122                       ;-------------------------------------------------------
0123                       ; Get FG/BG colors framebuffer text
0124                       ;-------------------------------------------------------
0125 72E2 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     72E4 A212     
0126 72E6 0604  14         dec   tmp0                  ; Internally work with base 0
0127               
0128 72E8 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0129 72EA 0224  22         ai    tmp0,tv.colorscheme.table
     72EC 3710     
0130                                                   ; Add base for color scheme data table
0131 72EE C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0132 72F0 C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     72F2 A218     
0133                       ;-------------------------------------------------------
0134                       ; Get and save cursor color
0135                       ;-------------------------------------------------------
0136 72F4 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0137 72F6 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     72F8 00FF     
0138 72FA C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     72FC A216     
0139                       ;-------------------------------------------------------
0140                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0141                       ;-------------------------------------------------------
0142 72FE C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0143 7300 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     7302 FF00     
0144 7304 0988  56         srl   tmp4,8                ; MSB to LSB
0145               
0146 7306 C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0147 7308 C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0148 730A 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0149 730C C806  38         mov   tmp2,@tv.busycolor    ; /
     730E A21C     
0150               
0151 7310 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     7312 00FF     
0152 7314 C805  38         mov   tmp1,@tv.markcolor    ; /
     7316 A21A     
0153               
0154 7318 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0155 731A 0985  56         srl   tmp1,8                ; \ Right align MN and
0156 731C C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     731E A220     
0157                       ;-------------------------------------------------------
0158                       ; Check if only CMDB needs to be colorized
0159                       ;-------------------------------------------------------
0160 7320 8820  54         c     @parm3,@w$ffff        ; Only colorize CMDB pane ?
     7322 A004     
     7324 2022     
0161 7326 133E  14         jeq   pane.action.colorscheme.cmdbpane
0162                                                   ; Yes, shortcut jump to CMDB pane
0163                       ;-------------------------------------------------------
0164                       ; Get FG color for ruler
0165                       ;-------------------------------------------------------
0166 7328 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0167 732A 0245  22         andi  tmp1,>000f            ; Only keep P
     732C 000F     
0168 732E 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0169 7330 C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     7332 A21E     
0170                       ;-------------------------------------------------------
0171                       ; Write sprite color of line and column indicators to SAT
0172                       ;-------------------------------------------------------
0173 7334 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0174 7336 0245  22         andi  tmp1,>00f0            ; Only keep O
     7338 00F0     
0175 733A 0A45  56         sla   tmp1,4                ; Move O to MSB
0176 733C D805  38         movb  tmp1,@ramsat+7        ; Line indicator FG color to SAT
     733E A043     
0177 7340 D805  38         movb  tmp1,@ramsat+11       ; Column indicator FG color to SAT
     7342 A047     
0178                       ;-------------------------------------------------------
0179                       ; Dump colors to VDP register 7 (text mode)
0180                       ;-------------------------------------------------------
0181 7344 C147  18         mov   tmp3,tmp1             ; Get work copy
0182 7346 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0183 7348 0265  22         ori   tmp1,>0700
     734A 0700     
0184 734C C105  18         mov   tmp1,tmp0
0185 734E 06A0  32         bl    @putvrx               ; Write VDP register
     7350 2348     
0186                       ;-------------------------------------------------------
0187                       ; Dump colors for frame buffer pane (TAT)
0188                       ;-------------------------------------------------------
0189 7352 C120  34         mov   @tv.ruler.visible,tmp0
     7354 A210     
0190 7356 130A  14         jeq   pane.action.colorscheme.fbdump.noruler
0191               
0192 7358 C120  34         mov   @cmdb.dialog,tmp0
     735A A71A     
0193 735C 0284  22         ci    tmp0,id.dialog.help   ; Help dialog active?
     735E 0068     
0194 7360 1305  14         jeq   pane.action.colorscheme.fbdump.noruler
0195                                                   ; Yes, skip ruler
0196                       ;-------------------------------------------------------
0197                       ; Ruler visible on screen (TAT)
0198                       ;-------------------------------------------------------
0199 7362 0204  20         li    tmp0,vdp.fb.toprow.tat+80
     7364 18A0     
0200                                                   ; VDP start address (frame buffer area)
0201               
0202 7366 0206  20         li    tmp2,(pane.botrow-2)*80
     7368 0870     
0203                                                   ; Number of bytes to fill
0204 736A 1004  14         jmp   pane.action.colorscheme.checkcmdb
0205               
0206               pane.action.colorscheme.fbdump.noruler:
0207                       ;-------------------------------------------------------
0208                       ; No ruler visible on screen (TAT)
0209                       ;-------------------------------------------------------
0210 736C 0204  20         li    tmp0,vdp.fb.toprow.tat
     736E 1850     
0211                                                   ; VDP start address (frame buffer area)
0212 7370 0206  20         li    tmp2,(pane.botrow-1)*80
     7372 08C0     
0213                                                   ; Number of bytes to fill
0214                       ;-------------------------------------------------------
0215                       ; Adjust bottom of frame buffer if CMDB visible
0216                       ;-------------------------------------------------------
0217               pane.action.colorscheme.checkcmdb:
0218 7374 C820  54         mov   @cmdb.visible,@cmdb.visible
     7376 A702     
     7378 A702     
0219 737A 1302  14         jeq   pane.action.colorscheme.fbdump
0220                                                   ; Not visible, skip adjustment
0221 737C 0226  22         ai    tmp2,-320             ; CMDB adjustment
     737E FEC0     
0222                       ;-------------------------------------------------------
0223                       ; Dump colors to VDP (TAT)
0224                       ;-------------------------------------------------------
0225               pane.action.colorscheme.fbdump:
0226 7380 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0227 7382 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0228               
0229 7384 06A0  32         bl    @xfilv                ; Fill colors
     7386 22A8     
0230                                                   ; i \  tmp0 = start address
0231                                                   ; i |  tmp1 = byte to fill
0232                                                   ; i /  tmp2 = number of bytes to fill
0233                       ;-------------------------------------------------------
0234                       ; Colorize marked lines
0235                       ;-------------------------------------------------------
0236 7388 C120  34         mov   @cmdb.dialog,tmp0
     738A A71A     
0237 738C 0284  22         ci    tmp0,id.dialog.help   ; Help dialog active?
     738E 0068     
0238 7390 1309  14         jeq   pane.action.colorscheme.cmdbpane
0239                                                   ; Yes, skip marked lines
0240               
0241 7392 C120  34         mov   @parm2,tmp0
     7394 A002     
0242 7396 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     7398 FFFF     
0243 739A 1304  14         jeq   pane.action.colorscheme.cmdbpane
0244               
0245 739C 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     739E A310     
0246 73A0 06A0  32         bl    @fb.colorlines
     73A2 7A92     
0247                       ;-------------------------------------------------------
0248                       ; Dump colors for CMDB header line (TAT)
0249                       ;-------------------------------------------------------
0250               pane.action.colorscheme.cmdbpane:
0251 73A4 C120  34         mov   @cmdb.visible,tmp0
     73A6 A702     
0252 73A8 1330  14         jeq   pane.action.colorscheme.errpane
0253                                                   ; Skip if CMDB pane is hidden
0254               
0255 73AA 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     73AC 1FD0     
0256                                                   ; VDP start address (CMDB top line)
0257               
0258 73AE C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     73B0 A220     
0259 73B2 0206  20         li    tmp2,1*67             ; Number of bytes to fill
     73B4 0043     
0260 73B6 06A0  32         bl    @xfilv                ; Fill colors
     73B8 22A8     
0261                                                   ; i \  tmp0 = start address
0262                                                   ; i |  tmp1 = byte to fill
0263                                                   ; i /  tmp2 = number of bytes to fill
0264                       ;-------------------------------------------------------
0265                       ; Dump colors for CMDB Stevie logo (TAT)
0266                       ;-------------------------------------------------------
0267 73BA 0204  20         li    tmp0,vdp.cmdb.toprow.tat+67
     73BC 2013     
0268 73BE C160  34         mov   @tv.cmdb.hcolor,tmp1  ;
     73C0 A220     
0269 73C2 D160  34         movb  @tv.cmdb.hcolor+1,tmp1
     73C4 A221     
0270                                                   ; Copy same value into MSB
0271 73C6 0945  56         srl   tmp1,4                ;
0272 73C8 0245  22         andi  tmp1,>00ff            ; Only keep LSB
     73CA 00FF     
0273               
0274 73CC 0206  20         li    tmp2,13               ; Number of bytes to fill
     73CE 000D     
0275 73D0 06A0  32         bl    @xfilv                ; Fill colors
     73D2 22A8     
0276                                                   ; i \  tmp0 = start address
0277                                                   ; i |  tmp1 = byte to fill
0278                                                   ; i /  tmp2 = number of bytes to fill
0279                       ;-------------------------------------------------------
0280                       ; Dump colors for CMDB pane content (TAT)
0281                       ;-------------------------------------------------------
0282 73D4 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     73D6 2020     
0283                                                   ; VDP start address (CMDB top line + 1)
0284 73D8 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0285 73DA 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     73DC 0050     
0286 73DE 06A0  32         bl    @xfilv                ; Fill colors
     73E0 22A8     
0287                                                   ; i \  tmp0 = start address
0288                                                   ; i |  tmp1 = byte to fill
0289                                                   ; i /  tmp2 = number of bytes to fill
0290               
0291 73E2 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 160
     73E4 2070     
0292                                                   ; VDP start address (CMDB top line + 2)
0293 73E6 C160  34         mov   @tv.cmdb.hcolor,tmp1  ; Same color as header line
     73E8 A220     
0294 73EA 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     73EC 0050     
0295 73EE 06A0  32         bl    @xfilv                ; Fill colors
     73F0 22A8     
0296                                                   ; i \  tmp0 = start address
0297                                                   ; i |  tmp1 = byte to fill
0298                                                   ; i /  tmp2 = number of bytes to fill
0299               
0300 73F2 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 240
     73F4 20C0     
0301                                                   ; VDP start address (CMDB top line + 3)
0302 73F6 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0303 73F8 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     73FA 0050     
0304 73FC 06A0  32         bl    @xfilv                ; Fill colors
     73FE 22A8     
0305                                                   ; i \  tmp0 = start address
0306                                                   ; i |  tmp1 = byte to fill
0307                                                   ; i /  tmp2 = number of bytes to fill
0308                       ;-------------------------------------------------------
0309                       ; Exit early if only CMDB needed to be colorized
0310                       ;-------------------------------------------------------
0311 7400 C120  34         mov   @parm3,tmp0
     7402 A004     
0312 7404 0284  22         ci    tmp0,>ffff            ; Only colorize CMDB pane ?
     7406 FFFF     
0313 7408 132F  14         jeq   pane.action.colorscheme.cursorcolor.cmdb
0314                                                   ; Yes, shortcut to CMDB cursor color
0315                       ;-------------------------------------------------------
0316                       ; Dump colors for error pane (TAT)
0317                       ;-------------------------------------------------------
0318               pane.action.colorscheme.errpane:
0319 740A C120  34         mov   @tv.error.visible,tmp0
     740C A228     
0320 740E 1306  14         jeq   pane.action.colorscheme.statline
0321                                                   ; Skip if error pane is hidden
0322               
0323 7410 0205  20         li    tmp1,>00f6            ; White on dark red
     7412 00F6     
0324 7414 C805  38         mov   tmp1,@parm1           ; Pass color combination
     7416 A000     
0325               
0326 7418 06A0  32         bl    @pane.errline.drawcolor
     741A 7600     
0327                                                   ; Draw color on rows in error pane
0328                                                   ; \ i  @tv.error.rows = Number of rows
0329                                                   ; / i  @parm1         = Color combination
0330                       ;-------------------------------------------------------
0331                       ; Dump colors for top line and bottom line (TAT)
0332                       ;-------------------------------------------------------
0333               pane.action.colorscheme.statline:
0334 741C C160  34         mov   @tv.color,tmp1
     741E A218     
0335 7420 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7422 00FF     
0336 7424 C805  38         mov   tmp1,@parm1           ; Set color combination
     7426 A000     
0337               
0338               
0339 7428 04E0  34         clr   @parm2                ; Top row on screen
     742A A002     
0340 742C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     742E 74F4     
0341                                                   ; \ i  @parm1 = Color combination
0342                                                   ; / i  @parm2 = Row on physical screen
0343               
0344 7430 0205  20         li    tmp1,pane.botrow
     7432 001D     
0345 7434 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     7436 A002     
0346 7438 06A0  32         bl    @colors.line.set      ; Load color combination for line
     743A 74F4     
0347                                                   ; \ i  @parm1 = Color combination
0348                                                   ; / i  @parm2 = Row on physical screen
0349                       ;-------------------------------------------------------
0350                       ; Dump colors for ruler if visible (TAT)
0351                       ;-------------------------------------------------------
0352 743C C160  34         mov   @cmdb.dialog,tmp1
     743E A71A     
0353 7440 0285  22         ci    tmp1,id.dialog.help   ; Help dialog active?
     7442 0068     
0354 7444 130A  14         jeq   pane.action.colorscheme.cursorcolor
0355                                                   ; Yes, skip ruler
0356               
0357 7446 C160  34         mov   @tv.ruler.visible,tmp1
     7448 A210     
0358 744A 1307  14         jeq   pane.action.colorscheme.cursorcolor
0359               
0360 744C 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     744E 7A80     
0361 7450 06A0  32         bl    @cpym2v
     7452 249A     
0362 7454 1850                   data vdp.fb.toprow.tat
0363 7456 A36E                   data fb.ruler.tat
0364 7458 0050                   data 80               ; Show ruler colors
0365                       ;-------------------------------------------------------
0366                       ; Dump cursor FG color to sprite table (SAT)
0367                       ;-------------------------------------------------------
0368               pane.action.colorscheme.cursorcolor:
0369 745A C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     745C A216     
0370               
0371 745E C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7460 A222     
0372 7462 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     7464 0000     
0373 7466 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0374                                                   ; Yes, set cursor color
0375               
0376               pane.action.colorscheme.cursorcolor.cmdb:
0377 7468 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     746A 00F0     
0378 746C 0A48  56         sla   tmp4,4                ; Move to MSB
0379 746E 1003  14         jmp   !
0380               
0381               pane.action.colorscheme.cursorcolor.fb:
0382 7470 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     7472 000F     
0383 7474 0A88  56         sla   tmp4,8                ; Move to MSB
0384               
0385 7476 D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7478 A03F     
0386 747A D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     747C A215     
0387                       ;-------------------------------------------------------
0388                       ; Exit
0389                       ;-------------------------------------------------------
0390               pane.action.colorscheme.load.exit:
0391 747E 06A0  32         bl    @scron                ; Turn screen on
     7480 26A2     
0392 7482 C839  50         mov   *stack+,@parm3        ; Pop @parm3
     7484 A004     
0393 7486 C839  50         mov   *stack+,@parm2        ; Pop @parm2
     7488 A002     
0394 748A C839  50         mov   *stack+,@parm1        ; Pop @parm1
     748C A000     
0395 748E C239  30         mov   *stack+,tmp4          ; Pop tmp4
0396 7490 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0397 7492 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0398 7494 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0399 7496 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0400 7498 C2F9  30         mov   *stack+,r11           ; Pop R11
0401 749A 045B  20         b     *r11                  ; Return to caller
0402               
0403               
0404               
0405               ***************************************************************
0406               * pane.action.colorscheme.statline
0407               * Set color combination for bottom status line
0408               ***************************************************************
0409               * bl @pane.action.colorscheme.statlines
0410               *--------------------------------------------------------------
0411               * INPUT
0412               * @parm1 = Color combination to set
0413               *--------------------------------------------------------------
0414               * OUTPUT
0415               * none
0416               *--------------------------------------------------------------
0417               * Register usage
0418               * tmp0, tmp1, tmp2
0419               ********|*****|*********************|**************************
0420               pane.action.colorscheme.statlines:
0421 749C 0649  14         dect  stack
0422 749E C64B  30         mov   r11,*stack            ; Save return address
0423 74A0 0649  14         dect  stack
0424 74A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0425                       ;------------------------------------------------------
0426                       ; Bottom line
0427                       ;------------------------------------------------------
0428 74A4 0204  20         li    tmp0,pane.botrow
     74A6 001D     
0429 74A8 C804  38         mov   tmp0,@parm2           ; Last row on screen
     74AA A002     
0430 74AC 06A0  32         bl    @colors.line.set      ; Load color combination for line
     74AE 74F4     
0431                                                   ; \ i  @parm1 = Color combination
0432                                                   ; / i  @parm2 = Row on physical screen
0433                       ;------------------------------------------------------
0434                       ; Exit
0435                       ;------------------------------------------------------
0436               pane.action.colorscheme.statlines.exit:
0437 74B0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0438 74B2 C2F9  30         mov   *stack+,r11           ; Pop R11
0439 74B4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0133                       copy  "pane.cursor.asm"             ; Cursor utility functions
     **** ****     > pane.cursor.asm
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
0020 74B6 0649  14         dect  stack
0021 74B8 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 74BA 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     74BC 22A2     
0026 74BE 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     74C0 0000     
     74C2 0008     
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 74C4 06A0  32         bl    @clslot
     74C6 2FB8     
0031 74C8 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 74CA 06A0  32         bl    @clslot
     74CC 2FB8     
0034 74CE 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 74D0 C2F9  30         mov   *stack+,r11           ; Pop R11
0040 74D2 045B  20         b     *r11                  ; Return to caller
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
0060 74D4 0649  14         dect  stack
0061 74D6 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 74D8 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     74DA 22A2     
0066 74DC 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     74DE 0000     
     74E0 0004     
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0071               
0072 74E2 06A0  32         bl    @mkslot
     74E4 2F9A     
0073 74E6 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     74E8 7170     
0074 74EA 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     74EC 7212     
0075 74EE FFFF                   data eol
0076               
0084               
0085                       ;-------------------------------------------------------
0086                       ; Exit
0087                       ;-------------------------------------------------------
0088               pane.cursor.blink.exit:
0089 74F0 C2F9  30         mov   *stack+,r11           ; Pop R11
0090 74F2 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0134                       ;-----------------------------------------------------------------------
0135                       ; Screen panes
0136                       ;-----------------------------------------------------------------------
0137                       copy  "colors.line.set.asm"         ; Set color combination for line
     **** ****     > colors.line.set.asm
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
0021 74F4 0649  14         dect  stack
0022 74F6 C64B  30         mov   r11,*stack            ; Save return address
0023 74F8 0649  14         dect  stack
0024 74FA C644  30         mov   tmp0,*stack           ; Push tmp0
0025 74FC 0649  14         dect  stack
0026 74FE C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7500 0649  14         dect  stack
0028 7502 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 7504 0649  14         dect  stack
0030 7506 C660  46         mov   @parm1,*stack         ; Push parm1
     7508 A000     
0031 750A 0649  14         dect  stack
0032 750C C660  46         mov   @parm2,*stack         ; Push parm2
     750E A002     
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 7510 C120  34         mov   @parm2,tmp0           ; Get target line
     7512 A002     
0037 7514 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     7516 0050     
0038 7518 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 751A C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 751C 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     751E 1800     
0042 7520 C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     7522 A000     
0043 7524 0206  20         li    tmp2,80               ; Number of bytes to fill
     7526 0050     
0044               
0045 7528 06A0  32         bl    @xfilv                ; Fill colors
     752A 22A8     
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 752C C839  50         mov   *stack+,@parm2        ; Pop @parm2
     752E A002     
0054 7530 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7532 A000     
0055 7534 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 7536 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7538 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 753A C2F9  30         mov   *stack+,r11           ; Pop R11
0059 753C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0138                       copy  "pane.topline.asm"            ; Top line
     **** ****     > pane.topline.asm
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
0017 753E 0649  14         dect  stack
0018 7540 C64B  30         mov   r11,*stack            ; Save return address
0019 7542 0649  14         dect  stack
0020 7544 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7546 0649  14         dect  stack
0022 7548 C660  46         mov   @wyx,*stack           ; Push cursor position
     754A 832A     
0023                       ;------------------------------------------------------
0024                       ; Show current file
0025                       ;------------------------------------------------------
0026               pane.topline.file:
0027 754C 06A0  32         bl    @at
     754E 26DA     
0028 7550 0000                   byte 0,0              ; y=0, x=0
0029               
0030 7552 C820  54         mov   @edb.filename.ptr,@parm1
     7554 A512     
     7556 A000     
0031                                                   ; Get string to display
0032 7558 0204  20         li    tmp0,47
     755A 002F     
0033 755C C804  38         mov   tmp0,@parm2           ; Set requested length
     755E A002     
0034 7560 0204  20         li    tmp0,32
     7562 0020     
0035 7564 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7566 A004     
0036 7568 0204  20         li    tmp0,rambuf
     756A A100     
0037 756C C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     756E A006     
0038               
0039               
0040 7570 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7572 33E6     
0041                                                   ; \ i  @parm1 = Pointer to string
0042                                                   ; | i  @parm2 = Requested length
0043                                                   ; | i  @parm3 = Fill characgter
0044                                                   ; | i  @parm4 = Pointer to buffer with
0045                                                   ; /             output string
0046               
0047 7574 C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7576 A010     
0048 7578 06A0  32         bl    @xutst0               ; /
     757A 2434     
0049                       ;------------------------------------------------------
0050                       ; Show if text was changed in editor buffer
0051                       ;------------------------------------------------------
0052               pane.topline.show_dirty:
0053 757C C120  34         mov   @edb.dirty,tmp0
     757E A506     
0054 7580 1305  14         jeq   pane.topline.nochange
0055                       ;------------------------------------------------------
0056                       ; Show "*"
0057                       ;------------------------------------------------------
0058 7582 06A0  32         bl    @putat
     7584 2456     
0059 7586 004F                   byte 0,79             ; y=0, x=79
0060 7588 3784                   data txt.star
0061 758A 1004  14         jmp   pane.topline.showmarkers
0062                       ;------------------------------------------------------
0063                       ; Show " "
0064                       ;------------------------------------------------------
0065               pane.topline.nochange:
0066 758C 06A0  32         bl    @putat
     758E 2456     
0067 7590 004F                   byte 0,79             ; y=0, x=79
0068 7592 39A0                   data txt.ws1          ; Single white space
0069                       ;------------------------------------------------------
0070                       ; Check if M1/M2 markers need to be shown
0071                       ;------------------------------------------------------
0072               pane.topline.showmarkers:
0073 7594 C120  34         mov   @edb.block.m1,tmp0    ; \
     7596 A50C     
0074 7598 0284  22         ci    tmp0,>ffff            ; | Exit early if M1 unset (>ffff)
     759A FFFF     
0075 759C 132C  14         jeq   pane.topline.exit     ; /
0076               
0077 759E C120  34         mov   @tv.task.oneshot,tmp0 ; \
     75A0 A224     
0078 75A2 0284  22         ci    tmp0,pane.topline.oneshot.clearmsg
     75A4 36C4     
0079                                                   ; | Exit early if overlay message visible
0080 75A6 1327  14         jeq   pane.topline.exit     ; /
0081                       ;------------------------------------------------------
0082                       ; Show M1 marker
0083                       ;------------------------------------------------------
0084 75A8 06A0  32         bl    @putat
     75AA 2456     
0085 75AC 0034                   byte 0,52
0086 75AE 3900                   data txt.m1           ; Show M1 marker message
0087               
0088 75B0 C820  54         mov   @edb.block.m1,@parm1
     75B2 A50C     
     75B4 A000     
0089 75B6 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     75B8 33BA     
0090                                                   ; \ i @parm1           = uint16
0091                                                   ; / o @unpacked.string = Output string
0092               
0093 75BA 0204  20         li    tmp0,>0500
     75BC 0500     
0094 75BE D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     75C0 A026     
0095               
0096 75C2 06A0  32         bl    @putat
     75C4 2456     
0097 75C6 0037                   byte 0,55
0098 75C8 A026                   data unpacked.string  ; Show M1 value
0099                       ;------------------------------------------------------
0100                       ; Show M2 marker
0101                       ;------------------------------------------------------
0102 75CA C120  34         mov   @edb.block.m2,tmp0    ; \
     75CC A50E     
0103 75CE 0284  22         ci    tmp0,>ffff            ; | Exit early if M2 unset (>ffff)
     75D0 FFFF     
0104 75D2 1311  14         jeq   pane.topline.exit     ; /
0105               
0106 75D4 06A0  32         bl    @putat
     75D6 2456     
0107 75D8 003E                   byte 0,62
0108 75DA 3904                   data txt.m2           ; Show M2 marker message
0109               
0110 75DC C820  54         mov   @edb.block.m2,@parm1
     75DE A50E     
     75E0 A000     
0111 75E2 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     75E4 33BA     
0112                                                   ; \ i @parm1           = uint16
0113                                                   ; / o @unpacked.string = Output string
0114               
0115 75E6 0204  20         li    tmp0,>0500
     75E8 0500     
0116 75EA D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     75EC A026     
0117               
0118 75EE 06A0  32         bl    @putat
     75F0 2456     
0119 75F2 0041                   byte 0,65
0120 75F4 A026                   data unpacked.string  ; Show M2 value
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               pane.topline.exit:
0125 75F6 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     75F8 832A     
0126 75FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0127 75FC C2F9  30         mov   *stack+,r11           ; Pop r11
0128 75FE 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.31063
0139                       copy  "pane.errline.asm"            ; Error line
     **** ****     > pane.errline.asm
0001               * FILE......: pane.errline.asm
0002               * Purpose...: Utilities for error lines
0003               
0004               ***************************************************************
0005               * pane.errline.drawcolor
0006               * Draw color on rows in error pane
0007               ***************************************************************
0008               * bl @pane.errline.drawcolor
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @tv.error.rows = Number of rows in error pane
0012               * @parm1         = Color combination
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               *--------------------------------------------------------------
0020               * Notes
0021               ********|*****|*********************|**************************
0022               pane.errline.drawcolor:
0023 7600 0649  14         dect  stack
0024 7602 C64B  30         mov   r11,*stack            ; Save return address
0025 7604 0649  14         dect  stack
0026 7606 C644  30         mov   tmp0,*stack           ; Push tmp0
0027 7608 0649  14         dect  stack
0028 760A C645  30         mov   tmp1,*stack           ; Push tmp1
0029 760C 0649  14         dect  stack
0030 760E C646  30         mov   tmp2,*stack           ; Push tmp2
0031                       ;-------------------------------------------------------
0032                       ; Determine 1st row in error pane
0033                       ;-------------------------------------------------------
0034 7610 0204  20         li    tmp0,pane.botrow      ; Get rows on screen
     7612 001D     
0035 7614 C144  18         mov   tmp0,tmp1             ; \ Get first row in error pane
0036 7616 6160  34         s     @tv.error.rows,tmp1   ; /
     7618 A22A     
0037                       ;-------------------------------------------------------
0038                       ; Dump colors for row
0039                       ;-------------------------------------------------------
0040               pane.errline.drawcolor.loop:
0041 761A C805  38         mov   tmp1,@parm2           ; Row on physical screen
     761C A002     
0042               
0043 761E 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7620 74F4     
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; / i  @parm2 = Row on physical screen
0046               
0047 7622 0585  14         inc   tmp1                  ; Next row
0048 7624 8105  18         c     tmp1,tmp0             ; Last row reached?
0049 7626 11F9  14         jlt   pane.errline.drawcolor.loop
0050                                                   ; Not yet, next iteration
0051                       ;-------------------------------------------------------
0052                       ; Exit
0053                       ;-------------------------------------------------------
0054               pane.errline.drawcolor.exit:
0055 7628 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 762A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 762C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 762E C2F9  30         mov   *stack+,r11           ; Pop R11
0059 7630 045B  20         b     *r11                  ; Return to caller
0060               
0061               
0062               
0063               
0064               ***************************************************************
0065               * pane.errline.show
0066               * Show command buffer pane
0067               ***************************************************************
0068               * bl @pane.errline.show
0069               *--------------------------------------------------------------
0070               * INPUT
0071               * @tv.error.msg = Error message to display
0072               *--------------------------------------------------------------
0073               * OUTPUT
0074               * none
0075               *--------------------------------------------------------------
0076               * Register usage
0077               * tmp0,tmp1
0078               *--------------------------------------------------------------
0079               * Notes
0080               ********|*****|*********************|**************************
0081               pane.errline.show:
0082 7632 0649  14         dect  stack
0083 7634 C64B  30         mov   r11,*stack            ; Save return address
0084 7636 0649  14         dect  stack
0085 7638 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 763A 0649  14         dect  stack
0087 763C C645  30         mov   tmp1,*stack           ; Push tmp1
0088               
0089 763E 0205  20         li    tmp1,>00f6            ; White on dark red
     7640 00F6     
0090 7642 C805  38         mov   tmp1,@parm1
     7644 A000     
0091               
0092 7646 06A0  32         bl    @pane.errline.drawcolor
     7648 7600     
0093                                                   ; Draw color on rows in error pane
0094                                                   ; \ i  @tv.error.rows = Number of rows
0095                                                   ; / i  @parm1         = Color combination
0096                       ;------------------------------------------------------
0097                       ; Pad error message up to 160 characters
0098                       ;------------------------------------------------------
0099 764A 0204  20         li    tmp0,tv.error.msg
     764C A22E     
0100 764E C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7650 A000     
0101               
0102 7652 0204  20         li    tmp0,240
     7654 00F0     
0103 7656 C804  38         mov   tmp0,@parm2           ; Set requested length
     7658 A002     
0104               
0105 765A 0204  20         li    tmp0,32
     765C 0020     
0106 765E C804  38         mov   tmp0,@parm3           ; Set character to fill
     7660 A004     
0107               
0108 7662 0204  20         li    tmp0,rambuf
     7664 A100     
0109 7666 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7668 A006     
0110               
0111 766A 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     766C 33E6     
0112                                                   ; \ i  @parm1 = Pointer to string
0113                                                   ; | i  @parm2 = Requested length
0114                                                   ; | i  @parm3 = Fill character
0115                                                   ; | i  @parm4 = Pointer to buffer with
0116                                                   ; /             output string
0117                       ;------------------------------------------------------
0118                       ; Show error message
0119                       ;------------------------------------------------------
0120 766E 06A0  32         bl    @at
     7670 26DA     
0121 7672 1A00                   byte pane.botrow-3,0  ; Set cursor
0122               
0123 7674 C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7676 A010     
0124 7678 06A0  32         bl    @xutst0               ; /
     767A 2434     
0125               
0126 767C C120  34         mov   @fb.scrrows.max,tmp0  ; \
     767E A31C     
0127 7680 6120  34         s     @tv.error.rows,tmp0   ; | Adjust number of rows in frame buffer
     7682 A22A     
0128 7684 C804  38         mov   tmp0,@fb.scrrows      ; /
     7686 A31A     
0129               
0130 7688 0720  34         seto  @tv.error.visible     ; Error line is visible
     768A A228     
0131                       ;------------------------------------------------------
0132                       ; Exit
0133                       ;------------------------------------------------------
0134               pane.errline.show.exit:
0135 768C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0136 768E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0137 7690 C2F9  30         mov   *stack+,r11           ; Pop r11
0138 7692 045B  20         b     *r11                  ; Return to caller
0139               
0140               
0141               
0142               ***************************************************************
0143               * pane.errline.hide
0144               * Hide error line
0145               ***************************************************************
0146               * bl @pane.errline.hide
0147               *--------------------------------------------------------------
0148               * INPUT
0149               * none
0150               *--------------------------------------------------------------
0151               * OUTPUT
0152               * none
0153               *--------------------------------------------------------------
0154               * Register usage
0155               * none
0156               *--------------------------------------------------------------
0157               * Hiding the error line passes pane focus to frame buffer.
0158               ********|*****|*********************|**************************
0159               pane.errline.hide:
0160 7694 0649  14         dect  stack
0161 7696 C64B  30         mov   r11,*stack            ; Save return address
0162 7698 0649  14         dect  stack
0163 769A C644  30         mov   tmp0,*stack           ; Push tmp0
0164                       ;------------------------------------------------------
0165                       ; Get color combination
0166                       ;------------------------------------------------------
0167 769C 06A0  32         bl    @errpane.init         ; Clear error line string in RAM
     769E 330C     
0168               
0169 76A0 C120  34         mov   @cmdb.visible,tmp0
     76A2 A702     
0170 76A4 1303  14         jeq   pane.errline.hide.fbcolor
0171                       ;------------------------------------------------------
0172                       ; CMDB pane color
0173                       ;------------------------------------------------------
0174 76A6 C120  34         mov   @tv.cmdb.hcolor,tmp0  ; Get colors of CMDB header line
     76A8 A220     
0175 76AA 1003  14         jmp   !
0176                       ;------------------------------------------------------
0177                       ; Frame buffer color
0178                       ;------------------------------------------------------
0179               pane.errline.hide.fbcolor:
0180 76AC C120  34         mov   @tv.color,tmp0        ; Get colors
     76AE A218     
0181 76B0 0984  56         srl   tmp0,8                ; Get rid of status line colors
0182                       ;------------------------------------------------------
0183                       ; Dump colors
0184                       ;------------------------------------------------------
0185 76B2 C804  38 !       mov   tmp0,@parm1           ; set foreground/background color
     76B4 A000     
0186               
0187 76B6 06A0  32         bl    @pane.errline.drawcolor
     76B8 7600     
0188                                                   ; Draw color on rows in error pane
0189                                                   ; \ i  @tv.error.rows = Number of rows
0190                                                   ; / i  @parm1         = Color combination
0191               
0192 76BA 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     76BC A228     
0193 76BE C820  54         mov   @fb.scrrows.max,@fb.scrrows
     76C0 A31C     
     76C2 A31A     
0194                                                   ; Set frame buffer to full size again
0195                       ;------------------------------------------------------
0196                       ; Exit
0197                       ;------------------------------------------------------
0198               pane.errline.hide.exit:
0199 76C4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200 76C6 C2F9  30         mov   *stack+,r11           ; Pop r11
0201 76C8 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0140                       copy  "pane.botline.asm"            ; Bottom line
     **** ****     > pane.botline.asm
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
0017 76CA 0649  14         dect  stack
0018 76CC C64B  30         mov   r11,*stack            ; Save return address
0019 76CE 0649  14         dect  stack
0020 76D0 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 76D2 0649  14         dect  stack
0022 76D4 C660  46         mov   @wyx,*stack           ; Push cursor position
     76D6 832A     
0023                       ;------------------------------------------------------
0024                       ; Show block shortcuts if set
0025                       ;------------------------------------------------------
0026 76D8 C120  34         mov   @edb.block.m2,tmp0    ; \
     76DA A50E     
0027 76DC 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0028                                                   ; /
0029 76DE 1305  14         jeq   pane.botline.show_keys
0030               
0031 76E0 06A0  32         bl    @putat
     76E2 2456     
0032 76E4 1D00                   byte pane.botrow,0
0033 76E6 3910                   data txt.keys.block   ; Show block shortcuts
0034               
0035 76E8 1004  14         jmp   pane.botline.show_mode
0036                       ;------------------------------------------------------
0037                       ; Show default message
0038                       ;------------------------------------------------------
0039               pane.botline.show_keys:
0040 76EA 06A0  32         bl    @putat
     76EC 2456     
0041 76EE 1D00                   byte pane.botrow,0
0042 76F0 3908                   data txt.keys.default ; Show default shortcuts
0043                       ;------------------------------------------------------
0044                       ; Show text editing mode
0045                       ;------------------------------------------------------
0046               pane.botline.show_mode:
0047 76F2 C120  34         mov   @edb.insmode,tmp0
     76F4 A50A     
0048 76F6 1605  14         jne   pane.botline.show_mode.insert
0049                       ;------------------------------------------------------
0050                       ; Overwrite mode
0051                       ;------------------------------------------------------
0052 76F8 06A0  32         bl    @putat
     76FA 2456     
0053 76FC 1D37                   byte  pane.botrow,55
0054 76FE 377C                   data  txt.ovrwrite
0055 7700 1004  14         jmp   pane.botline.show_linecol
0056                       ;------------------------------------------------------
0057                       ; Insert mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.insert:
0060 7702 06A0  32         bl    @putat
     7704 2456     
0061 7706 1D37                   byte  pane.botrow,55
0062 7708 3780                   data  txt.insert
0063                       ;------------------------------------------------------
0064                       ; Show "line,column"
0065                       ;------------------------------------------------------
0066               pane.botline.show_linecol:
0067 770A C820  54         mov   @fb.row,@parm1
     770C A306     
     770E A000     
0068 7710 06A0  32         bl    @fb.row2line          ; Row to editor line
     7712 6CAC     
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 7714 05A0  34         inc   @outparm1             ; Add base 1
     7716 A010     
0074                       ;------------------------------------------------------
0075                       ; Show line
0076                       ;------------------------------------------------------
0077 7718 06A0  32         bl    @putnum
     771A 2B32     
0078 771C 1D3B                   byte  pane.botrow,59  ; YX
0079 771E A010                   data  outparm1,rambuf
     7720 A100     
0080 7722 30                     byte  48              ; ASCII offset
0081 7723   20                   byte  32              ; Padding character
0082                       ;------------------------------------------------------
0083                       ; Show comma
0084                       ;------------------------------------------------------
0085 7724 06A0  32         bl    @putat
     7726 2456     
0086 7728 1D40                   byte  pane.botrow,64
0087 772A 3774                   data  txt.delim
0088                       ;------------------------------------------------------
0089                       ; Show column
0090                       ;------------------------------------------------------
0091 772C 06A0  32         bl    @film
     772E 224A     
0092 7730 A105                   data rambuf+5,32,12   ; Clear work buffer with space character
     7732 0020     
     7734 000C     
0093               
0094 7736 C820  54         mov   @fb.column,@waux1
     7738 A30C     
     773A 833C     
0095 773C 05A0  34         inc   @waux1                ; Offset 1
     773E 833C     
0096               
0097 7740 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7742 2AB4     
0098 7744 833C                   data  waux1,rambuf
     7746 A100     
0099 7748 30                     byte  48              ; ASCII offset
0100 7749   20                   byte  32              ; Fill character
0101               
0102 774A 06A0  32         bl    @trimnum              ; Trim number to the left
     774C 2B0C     
0103 774E A100                   data  rambuf,rambuf+5,32
     7750 A105     
     7752 0020     
0104               
0105 7754 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7756 0600     
0106 7758 D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     775A A105     
0107               
0108                       ;------------------------------------------------------
0109                       ; Decide if row length is to be shown
0110                       ;------------------------------------------------------
0111 775C C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     775E A30C     
0112 7760 0584  14         inc   tmp0                  ; /
0113 7762 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7764 A308     
0114 7766 1101  14         jlt   pane.botline.show_linecol.linelen
0115 7768 102B  14         jmp   pane.botline.show_linecol.colstring
0116                                                   ; Yes, skip showing row length
0117                       ;------------------------------------------------------
0118                       ; Add ',' delimiter and length of line to string
0119                       ;------------------------------------------------------
0120               pane.botline.show_linecol.linelen:
0121 776A C120  34         mov   @fb.column,tmp0       ; \
     776C A30C     
0122 776E 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7770 A107     
0123 7772 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7774 0009     
0124 7776 1101  14         jlt   !                     ; | column.
0125 7778 0585  14         inc   tmp1                  ; /
0126               
0127 777A 0204  20 !       li    tmp0,>2f00            ; \ ASCII '/'
     777C 2F00     
0128 777E DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0129               
0130 7780 C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7782 833C     
0131               
0132 7784 06A0  32         bl    @mknum
     7786 2AB4     
0133 7788 A308                   data  fb.row.length,rambuf
     778A A100     
0134 778C 30                     byte  48              ; ASCII offset
0135 778D   20                   byte  32              ; Padding character
0136               
0137 778E C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7790 833C     
0138               
0139 7792 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7794 A308     
0140 7796 0284  22         ci    tmp0,10               ; /
     7798 000A     
0141 779A 110B  14         jlt   pane.botline.show_line.1digit
0142                       ;------------------------------------------------------
0143                       ; Assert
0144                       ;------------------------------------------------------
0145 779C 0284  22         ci    tmp0,80
     779E 0050     
0146 77A0 1204  14         jle   pane.botline.show_line.2digits
0147                       ;------------------------------------------------------
0148                       ; Asserts failed
0149                       ;------------------------------------------------------
0150 77A2 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     77A4 FFCE     
0151 77A6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     77A8 2026     
0152                       ;------------------------------------------------------
0153                       ; Show length of line (2 digits)
0154                       ;------------------------------------------------------
0155               pane.botline.show_line.2digits:
0156 77AA 0204  20         li    tmp0,rambuf+3
     77AC A103     
0157 77AE DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0158 77B0 1002  14         jmp   pane.botline.show_line.rest
0159                       ;------------------------------------------------------
0160                       ; Show length of line (1 digits)
0161                       ;------------------------------------------------------
0162               pane.botline.show_line.1digit:
0163 77B2 0204  20         li    tmp0,rambuf+4
     77B4 A104     
0164               pane.botline.show_line.rest:
0165 77B6 DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0166 77B8 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     77BA A100     
0167 77BC DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     77BE A100     
0168                       ;------------------------------------------------------
0169                       ; Show column string
0170                       ;------------------------------------------------------
0171               pane.botline.show_linecol.colstring:
0172 77C0 06A0  32         bl    @putat
     77C2 2456     
0173 77C4 1D41                   byte pane.botrow,65
0174 77C6 A105                   data rambuf+5         ; Show string
0175                       ;------------------------------------------------------
0176                       ; Show lines in buffer unless on last line in file
0177                       ;------------------------------------------------------
0178 77C8 C820  54         mov   @fb.row,@parm1
     77CA A306     
     77CC A000     
0179 77CE 06A0  32         bl    @fb.row2line
     77D0 6CAC     
0180 77D2 8820  54         c     @edb.lines,@outparm1
     77D4 A504     
     77D6 A010     
0181 77D8 1605  14         jne   pane.botline.show_lines_in_buffer
0182               
0183 77DA 06A0  32         bl    @putat
     77DC 2456     
0184 77DE 1D48                   byte pane.botrow,72
0185 77E0 3776                   data txt.bottom
0186               
0187 77E2 1009  14         jmp   pane.botline.exit
0188                       ;------------------------------------------------------
0189                       ; Show lines in buffer
0190                       ;------------------------------------------------------
0191               pane.botline.show_lines_in_buffer:
0192 77E4 C820  54         mov   @edb.lines,@waux1
     77E6 A504     
     77E8 833C     
0193               
0194 77EA 06A0  32         bl    @putnum
     77EC 2B32     
0195 77EE 1D48                   byte pane.botrow,72   ; YX
0196 77F0 833C                   data waux1,rambuf
     77F2 A100     
0197 77F4 30                     byte 48
0198 77F5   20                   byte 32
0199                       ;------------------------------------------------------
0200                       ; Exit
0201                       ;------------------------------------------------------
0202               pane.botline.exit:
0203 77F6 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     77F8 832A     
0204 77FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0205 77FC C2F9  30         mov   *stack+,r11           ; Pop r11
0206 77FE 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.31063
0141                       copy  "pane.vdpdump.asm"            ; Dump panes to VDP memory
     **** ****     > pane.vdpdump.asm
0001               * FILE......: pane.vdpdump.asm
0002               * Purpose...: Dump all panes to VDP
0003               
0004               ***************************************************************
0005               * pane.vdpdump
0006               * Dump all panes to VDP
0007               ***************************************************************
0008               * bl @pane.vdpdump
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @fb.dirty         = Refresh frame buffer if set
0012               * @fb.status.dirty  = Refresh top/bottom status lines if set
0013               * @fb.colorize      = Colorize range M1/M2 if set
0014               * @cmdb.dirty       = Refresh command buffer pane if set
0015               * @tv.ruler.visible = Show ruler below top status line if set
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0,tmp1,tmp2
0022               ********|*****|*********************|**************************
0023               pane.vdpdump:
0024 7800 0649  14         dect  stack
0025 7802 C64B  30         mov   r11,*stack            ; Save return address
0026 7804 0649  14         dect  stack
0027 7806 C644  30         mov   tmp0,*stack           ; Push tmp0
0028 7808 0649  14         dect  stack
0029 780A C660  46         mov   @wyx,*stack           ; Push cursor position
     780C 832A     
0030                       ;------------------------------------------------------
0031                       ; ALPHA-Lock key down?
0032                       ;------------------------------------------------------
0033               pane.vdpdump.alpha_lock:
0034 780E 20A0  38         coc   @wbit10,config
     7810 200C     
0035 7812 1305  14         jeq   pane.vdpdump.alpha_lock.down
0036                       ;------------------------------------------------------
0037                       ; AlPHA-Lock is up
0038                       ;------------------------------------------------------
0039 7814 06A0  32         bl    @putat
     7816 2456     
0040 7818 1D4E                   byte pane.botrow,78
0041 781A 39AA                   data txt.ws4
0042 781C 1004  14         jmp   pane.vdpdump.cmdb.check
0043                       ;------------------------------------------------------
0044                       ; AlPHA-Lock is down
0045                       ;------------------------------------------------------
0046               pane.vdpdump.alpha_lock.down:
0047 781E 06A0  32         bl    @putat
     7820 2456     
0048 7822 1D4E                   byte pane.botrow,78
0049 7824 3998                   data txt.alpha.down
0050                       ;------------------------------------------------------
0051                       ; Command buffer visible ?
0052                       ;------------------------------------------------------
0053               pane.vdpdump.cmdb.check
0054 7826 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     7828 A702     
0055 782A 1324  14         jeq   !                     ; No, skip CMDB pane
0056                       ;-------------------------------------------------------
0057                       ; Draw command buffer pane if dirty
0058                       ;-------------------------------------------------------
0059               pane.vdpdump.cmdb.draw:
0060 782C C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     782E A718     
0061 7830 1343  14         jeq   pane.vdpdump.exit     ; No, skip update
0062                       ;-------------------------------------------------------
0063                       ; "one-time only" flag set?
0064                       ;-------------------------------------------------------
0065 7832 0284  22         ci    tmp0,tv.1timeonly
     7834 00FE     
0066 7836 1619  14         jne   pane.vdpdump.cmdb.draw.content
0067                                                   ; No, skip CMDB colorization
0068                       ;-------------------------------------------------------
0069                       ; Colorize the CMDB pane
0070                       ;-------------------------------------------------------
0071               pane.vdpdump.cmdb.draw.colorscheme:
0072 7838 0649  14         dect  stack
0073 783A C660  46         mov   @parm1,*stack         ; Push @parm1
     783C A000     
0074 783E 0649  14         dect  stack
0075 7840 C660  46         mov   @parm2,*stack         ; Push @parm2
     7842 A002     
0076 7844 0649  14         dect  stack
0077 7846 C660  46         mov   @parm3,*stack         ; Push @parm3
     7848 A004     
0078               
0079 784A 0720  34         seto  @parm1                ; Do not turn screen off
     784C A000     
0080 784E 0720  34         seto  @parm2                ; Skip colorzing marked lines
     7850 A002     
0081 7852 0720  34         seto  @parm3                ; Only colorize CMDB pane
     7854 A004     
0082               
0083 7856 06A0  32         bl    @pane.action.colorscheme.load
     7858 72AA     
0084                                                   ; Reload color scheme
0085                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0086                                                   ; | i  @parm2 = Skip colorizing marked lines
0087                                                   ; |             if >FFFF
0088                                                   ; | i  @parm3 = Only colorize CMDB pane
0089                                                   ; /             if >FFFF
0090               
0091 785A C839  50         mov   *stack+,@parm3        ; Pop @parm3
     785C A004     
0092 785E C839  50         mov   *stack+,@parm2        ; Pop @parm2
     7860 A002     
0093 7862 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7864 A000     
0094               
0095 7866 0720  34         seto  @cmdb.dirty           ; Remove special "one-time only" flag
     7868 A718     
0096                       ;-------------------------------------------------------
0097                       ; Show content in CMDB pane
0098                       ;-------------------------------------------------------
0099               pane.vdpdump.cmdb.draw.content:
0100 786A 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     786C 7A0C     
0101 786E 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     7870 A718     
0102 7872 1022  14         jmp   pane.vdpdump.exit     ; Exit early
0103                       ;-------------------------------------------------------
0104                       ; Check if frame buffer dirty
0105                       ;-------------------------------------------------------
0106 7874 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7876 A316     
0107 7878 130E  14         jeq   pane.vdpdump.statlines
0108                                                   ; No, skip update
0109 787A C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     787C A31A     
     787E A000     
0110               
0111               pane.vdpdump.dump:
0112 7880 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     7882 7AA4     
0113                                                   ; \ i  @parm1 = number of lines to dump
0114                                                   ; /
0115                       ;------------------------------------------------------
0116                       ; Color the lines in the framebuffer (TAT)
0117                       ;------------------------------------------------------
0118 7884 C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     7886 A310     
0119 7888 1302  14         jeq   pane.vdpdump.dumped   ; Skip if flag reset
0120               
0121 788A 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     788C 7A92     
0122                       ;-------------------------------------------------------
0123                       ; Finished with frame buffer
0124                       ;-------------------------------------------------------
0125               pane.vdpdump.dumped:
0126 788E 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     7890 A316     
0127 7892 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     7894 A318     
0128                       ;-------------------------------------------------------
0129                       ; Refresh top and bottom line
0130                       ;-------------------------------------------------------
0131               pane.vdpdump.statlines:
0132 7896 C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     7898 A318     
0133 789A 130E  14         jeq   pane.vdpdump.exit     ; No, skip update
0134               
0135 789C 06A0  32         bl    @pane.topline         ; Draw top line
     789E 753E     
0136 78A0 06A0  32         bl    @pane.botline         ; Draw bottom line
     78A2 76CA     
0137 78A4 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     78A6 A318     
0138                       ;------------------------------------------------------
0139                       ; Show ruler with tab positions
0140                       ;------------------------------------------------------
0141 78A8 C120  34         mov   @tv.ruler.visible,tmp0
     78AA A210     
0142                                                   ; Should ruler be visible?
0143 78AC 1305  14         jeq   pane.vdpdump.exit     ; No, so exit
0144               
0145 78AE 06A0  32         bl    @cpym2v
     78B0 249A     
0146 78B2 0050                   data vdp.fb.toprow.sit
0147 78B4 A31E                   data fb.ruler.sit
0148 78B6 0050                   data 80               ; Show ruler
0149                       ;------------------------------------------------------
0150                       ; Exit task
0151                       ;------------------------------------------------------
0152               pane.vdpdump.exit:
0153 78B8 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     78BA 832A     
0154 78BC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0155 78BE C2F9  30         mov   *stack+,r11           ; Pop r11
0156 78C0 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0142                       ;-----------------------------------------------------------------------
0143                       ; Stubs
0144                       ;-----------------------------------------------------------------------
0145                       copy  "rom.stubs.bank1.asm"         ; Bank specific stubs
     **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               ***************************************************************
0005               * Stub for "fm.loadfile"
0006               * bank2 vec.1
0007               ********|*****|*********************|**************************
0008               fm.loadfile:
0009 78C2 0649  14         dect  stack
0010 78C4 C64B  30         mov   r11,*stack            ; Save return address
0011 78C6 0649  14         dect  stack
0012 78C8 C644  30         mov   tmp0,*stack           ; Push tmp0
0013                       ;------------------------------------------------------
0014                       ; Call function in bank 2
0015                       ;------------------------------------------------------
0016 78CA 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     78CC 3098     
0017 78CE 6004                   data bank2.rom        ; | i  p0 = bank address
0018 78D0 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0019 78D2 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0020                       ;------------------------------------------------------
0021                       ; Show "Unsaved changes" dialog if editor buffer dirty
0022                       ;------------------------------------------------------
0023 78D4 C120  34         mov   @outparm1,tmp0
     78D6 A010     
0024 78D8 1304  14         jeq   fm.loadfile.exit
0025               
0026 78DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0027 78DC C2F9  30         mov   *stack+,r11           ; Pop r11
0028 78DE 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     78E0 7972     
0029                       ;------------------------------------------------------
0030                       ; Exit
0031                       ;------------------------------------------------------
0032               fm.loadfile.exit:
0033 78E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0034 78E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0035 78E6 045B  20         b     *r11                  ; Return to caller
0036               
0037               
0038               ***************************************************************
0039               * Stub for "fm.insertfile"
0040               * bank2 vec.2
0041               ********|*****|*********************|**************************
0042               fm.insertfile:
0043 78E8 0649  14         dect  stack
0044 78EA C64B  30         mov   r11,*stack            ; Save return address
0045 78EC 0649  14         dect  stack
0046 78EE C644  30         mov   tmp0,*stack           ; Push tmp0
0047                       ;------------------------------------------------------
0048                       ; Call function in bank 2
0049                       ;------------------------------------------------------
0050 78F0 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     78F2 3098     
0051 78F4 6004                   data bank2.rom        ; | i  p0 = bank address
0052 78F6 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0053 78F8 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0054                       ;------------------------------------------------------
0055                       ; Exit
0056                       ;------------------------------------------------------
0057               fm.insertfile.exit:
0058 78FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0059 78FC C2F9  30         mov   *stack+,r11           ; Pop r11
0060 78FE 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               **************************************************************
0064               * Stub for "fm.browse.fname.suffix"
0065               * bank2 vec.3
0066               ********|*****|*********************|**************************
0067               fm.browse.fname.suffix:
0068 7900 0649  14         dect  stack
0069 7902 C64B  30         mov   r11,*stack            ; Save return address
0070                       ;------------------------------------------------------
0071                       ; Call function in bank 2
0072                       ;------------------------------------------------------
0073 7904 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7906 3098     
0074 7908 6004                   data bank2.rom        ; | i  p0 = bank address
0075 790A 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0076 790C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080 790E C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7910 045B  20         b     *r11                  ; Return to caller
0082               
0083               
0084               ***************************************************************
0085               * Stub for "fm.savefile"
0086               * bank2 vec.4
0087               ********|*****|*********************|**************************
0088               fm.savefile:
0089 7912 0649  14         dect  stack
0090 7914 C64B  30         mov   r11,*stack            ; Save return address
0091                       ;------------------------------------------------------
0092                       ; Call function in bank 2
0093                       ;------------------------------------------------------
0094 7916 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7918 3098     
0095 791A 6004                   data bank2.rom        ; | i  p0 = bank address
0096 791C 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0097 791E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0098                       ;------------------------------------------------------
0099                       ; Exit
0100                       ;------------------------------------------------------
0101 7920 C2F9  30         mov   *stack+,r11           ; Pop r11
0102 7922 045B  20         b     *r11                  ; Return to caller
0103               
0104               
0105               ***************************************************************
0106               * Stub for "fm.newfile"
0107               * bank2 vec.5
0108               ********|*****|*********************|**************************
0109               fm.newfile:
0110 7924 0649  14         dect  stack
0111 7926 C64B  30         mov   r11,*stack            ; Save return address
0112                       ;------------------------------------------------------
0113                       ; Call function in bank 2
0114                       ;------------------------------------------------------
0115 7928 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     792A 3098     
0116 792C 6004                   data bank2.rom        ; | i  p0 = bank address
0117 792E 7FC8                   data vec.5            ; | i  p1 = Vector with target address
0118 7930 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122 7932 C2F9  30         mov   *stack+,r11           ; Pop r11
0123 7934 045B  20         b     *r11                  ; Return to caller
0124               
0125               
0126               ***************************************************************
0127               * Stub for dialog "Help"
0128               * bank3 vec.1
0129               ********|*****|*********************|**************************
0130               edkey.action.about:
0131 7936 C820  54         mov   @edkey.action.about.vector,@trmpvector
     7938 793E     
     793A A03A     
0132 793C 104A  14         jmp   _trampoline.bank3     ; Show dialog
0133               edkey.action.about.vector:
0134 793E 7FC0             data  vec.1
0135               
0136               
0137               ***************************************************************
0138               * Stub for dialog "Load file"
0139               * bank3 vec.2
0140               ********|*****|*********************|**************************
0141               dialog.load:
0142 7940 C820  54         mov   @dialog.load.vector,@trmpvector
     7942 7948     
     7944 A03A     
0143 7946 1045  14         jmp   _trampoline.bank3     ; Show dialog
0144               dialog.load.vector:
0145 7948 7FC2             data  vec.2
0146               
0147               
0148               ***************************************************************
0149               * Stub for dialog "Save file"
0150               * bank3 vec.3
0151               ********|*****|*********************|**************************
0152               dialog.save:
0153 794A C820  54         mov   @dialog.save.vector,@trmpvector
     794C 7952     
     794E A03A     
0154 7950 1040  14         jmp   _trampoline.bank3     ; Show dialog
0155               dialog.save.vector:
0156 7952 7FC4             data  vec.3
0157               
0158               
0159               ***************************************************************
0160               * Stub for dialog "Insert file at line"
0161               * bank3 vec.4
0162               ********|*****|*********************|**************************
0163               dialog.insert:
0164 7954 C820  54         mov   @dialog.insert.vector,@trmpvector
     7956 795C     
     7958 A03A     
0165 795A 103B  14         jmp   _trampoline.bank3     ; Show dialog
0166               dialog.insert.vector:
0167 795C 7FC6             data  vec.4
0168               
0169               
0170               ***************************************************************
0171               * Stub for dialog "Print file"
0172               * bank3 vec.5
0173               ********|*****|*********************|**************************
0174               dialog.print:
0175 795E C820  54         mov   @dialog.print.vector,@trmpvector
     7960 7966     
     7962 A03A     
0176 7964 1036  14         jmp   _trampoline.bank3    ; Show dialog
0177               dialog.print.vector:
0178 7966 7FC8             data  vec.5
0179               
0180               
0181               ***************************************************************
0182               * Stub for dialog "File"
0183               * bank3 vec.6
0184               ********|*****|*********************|**************************
0185               dialog.file:
0186 7968 C820  54         mov   @dialog.file.vector,@trmpvector
     796A 7970     
     796C A03A     
0187 796E 1031  14         jmp   _trampoline.bank3     ; Show dialog
0188               dialog.file.vector:
0189 7970 7FCA             data  vec.6
0190               
0191               
0192               ***************************************************************
0193               * Stub for dialog "Unsaved Changes"
0194               * bank3 vec.7
0195               ********|*****|*********************|**************************
0196               dialog.unsaved:
0197 7972 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     7974 A722     
0198 7976 C820  54         mov   @dialog.unsaved.vector,@trmpvector
     7978 797E     
     797A A03A     
0199 797C 102A  14         jmp   _trampoline.bank3     ; Show dialog
0200               dialog.unsaved.vector:
0201 797E 7FCC             data  vec.7
0202               
0203               
0204               ***************************************************************
0205               * Stub for dialog "Copy clipboard to line ..."
0206               * bank3 vec.8
0207               ********|*****|*********************|**************************
0208               dialog.clipboard:
0209 7980 C820  54         mov   @dialog.clipboard.vector,@trmpvector
     7982 7988     
     7984 A03A     
0210 7986 1025  14         jmp   _trampoline.bank3     ; Show dialog
0211               dialog.clipboard.vector:
0212 7988 7FCE             data  vec.8
0213               
0214               
0215               ***************************************************************
0216               * Stub for dialog "Configure clipboard device"
0217               * bank3 vec.9
0218               ********|*****|*********************|**************************
0219               dialog.clipdev:
0220 798A C820  54         mov   @dialog.clipdev.vector,@trmpvector
     798C 7992     
     798E A03A     
0221 7990 1020  14         jmp   _trampoline.bank3     ; Show dialog
0222               dialog.clipdev.vector:
0223 7992 7FD0             data  vec.9
0224               
0225               
0226               ***************************************************************
0227               * Stub for dialog "Configure"
0228               * bank3 vec.10
0229               ********|*****|*********************|**************************
0230               dialog.config:
0231 7994 C820  54         mov   @dialog.config.vector,@trmpvector
     7996 799C     
     7998 A03A     
0232 799A 101B  14         jmp   _trampoline.bank3     ; Show dialog
0233               dialog.config.vector:
0234 799C 7FD2             data  vec.10
0235               
0236               
0237               ***************************************************************
0238               * Stub for dialog "Append file"
0239               * bank3 vec.11
0240               ********|*****|*********************|**************************
0241               dialog.append:
0242 799E C820  54         mov   @dialog.append.vector,@trmpvector
     79A0 79A6     
     79A2 A03A     
0243 79A4 1016  14         jmp   _trampoline.bank3     ; Show dialog
0244               dialog.append.vector:
0245 79A6 7FD4             data  vec.11
0246               
0247               
0248               ***************************************************************
0249               * Stub for dialog "Cartridge"
0250               * bank3 vec.12
0251               ********|*****|*********************|**************************
0252               dialog.cartridge:
0253 79A8 C820  54         mov   @dialog.cartridge.vector,@trmpvector
     79AA 79B0     
     79AC A03A     
0254 79AE 1011  14         jmp   _trampoline.bank3     ; Show dialog
0255               dialog.cartridge.vector:
0256 79B0 7FD6             data  vec.12
0257               
0258               
0259               ***************************************************************
0260               * Stub for dialog "Basic"
0261               * bank3 vec.13
0262               ********|*****|*********************|**************************
0263               dialog.basic:
0264 79B2 C820  54         mov   @dialog.basic.vector,@trmpvector
     79B4 79BA     
     79B6 A03A     
0265 79B8 100C  14         jmp   _trampoline.bank3     ; Show dialog
0266               dialog.basic.vector:
0267 79BA 7FD8             data  vec.13
0268               
0269               
0270               ***************************************************************
0271               * Stub for dialog "Main Menu"
0272               * bank3 vec.30
0273               ********|*****|*********************|**************************
0274               dialog.menu:
0275                       ;------------------------------------------------------
0276                       ; Check if block mode is active
0277                       ;------------------------------------------------------
0278 79BC C120  34         mov   @edb.block.m2,tmp0    ; \
     79BE A50E     
0279 79C0 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0280                                                   ; /
0281 79C2 1302  14         jeq   !                     : Block mode inactive, show dialog
0282                       ;------------------------------------------------------
0283                       ; Special treatment for block mode
0284                       ;------------------------------------------------------
0285 79C4 0460  28         b     @edkey.action.block.reset
     79C6 67A2     
0286                                                   ; Reset block mode
0287                       ;------------------------------------------------------
0288                       ; Show dialog
0289                       ;------------------------------------------------------
0290 79C8 C820  54 !       mov   @dialog.menu.vector,@trmpvector
     79CA 79D0     
     79CC A03A     
0291 79CE 1001  14         jmp   _trampoline.bank3     ; Show dialog
0292               dialog.menu.vector:
0293 79D0 7FFA             data  vec.30
0294               
0295               
0296               
0297               ***************************************************************
0298               * Trampoline 1 (bank 3, dialog)
0299               ********|*****|*********************|**************************
0300               _trampoline.bank3:
0301 79D2 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     79D4 74B6     
0302                       ;------------------------------------------------------
0303                       ; Call routine in specified bank
0304                       ;------------------------------------------------------
0305 79D6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     79D8 3098     
0306 79DA 6006                   data bank3.rom        ; | i  p0 = bank address
0307 79DC FFFF                   data >ffff            ; | i  p1 = Vector with target address
0308                                                   ; |         (deref @trmpvector)
0309 79DE 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0310                       ;------------------------------------------------------
0311                       ; Exit
0312                       ;------------------------------------------------------
0313 79E0 0460  28         b     @edkey.action.cmdb.show
     79E2 693E     
0314                                                   ; Show dialog in CMDB pane
0315               
0316               
0317               ***************************************************************
0318               * Stub for "error.display"
0319               * bank3 vec.18
0320               ********|*****|*********************|**************************
0321               error.display:
0322 79E4 C820  54         mov   @error.display.vector,@trmpvector
     79E6 79EC     
     79E8 A03A     
0323 79EA 1038  14         jmp   _trampoline.bank3.ret ; Longjump
0324               error.display.vector:
0325 79EC 7FE2             data  vec.18
0326               
0327               
0328               ***************************************************************
0329               * Stub for "pane.show_hintx"
0330               * bank3 vec.19
0331               ********|*****|*********************|**************************
0332               pane.show_hintx:
0333 79EE C820  54         mov   @pane.show_hintx.vector,@trmpvector
     79F0 79F6     
     79F2 A03A     
0334 79F4 1033  14         jmp   _trampoline.bank3.ret ; Longjump
0335               pane.show_hintx.vector:
0336 79F6 7FE4             data  vec.19
0337               
0338               
0339               ***************************************************************
0340               * Stub for "pane.cmdb.show"
0341               * bank3 vec.20
0342               ********|*****|*********************|**************************
0343               pane.cmdb.show:
0344 79F8 C820  54         mov   @pane.cmdb.show.vector,@trmpvector
     79FA 7A00     
     79FC A03A     
0345 79FE 102E  14         jmp   _trampoline.bank3.ret ; Longjump
0346               pane.cmdb.show.vector:
0347 7A00 7FE6             data  vec.20
0348               
0349               
0350               ***************************************************************
0351               * Stub for "pane.cmdb.hide"
0352               * bank3 vec.21
0353               ********|*****|*********************|**************************
0354               pane.cmdb.hide:
0355 7A02 C820  54         mov   @pane.cmdb.hide.vector,@trmpvector
     7A04 7A0A     
     7A06 A03A     
0356 7A08 1029  14         jmp   _trampoline.bank3.ret ; Longjump
0357               pane.cmdb.hide.vector:
0358 7A0A 7FE8             data  vec.21
0359               
0360               
0361               ***************************************************************
0362               * Stub for "pane.cmdb.draw"
0363               * bank3 vec.22
0364               ********|*****|*********************|**************************
0365               pane.cmdb.draw:
0366 7A0C C820  54         mov   @pane.cmdb.draw.vector,@trmpvector
     7A0E 7A14     
     7A10 A03A     
0367 7A12 1024  14         jmp   _trampoline.bank3.ret ; Longjump
0368               pane.cmdb.draw.vector:
0369 7A14 7FEA             data  vec.22
0370               
0371               
0372               ***************************************************************
0373               * Stub for "cmdb.refresh"
0374               * bank3 vec.24
0375               ********|*****|*********************|**************************
0376               cmdb.refresh:
0377 7A16 C820  54         mov   @cmdb.refresh.vector,@trmpvector
     7A18 7A1E     
     7A1A A03A     
0378 7A1C 101F  14         jmp   _trampoline.bank3.ret ; Longjump
0379               cmdb.refresh.vector:
0380 7A1E 7FEE             data  vec.24
0381               
0382               
0383               ***************************************************************
0384               * Stub for "cmdb.cmd.clear"
0385               * bank3 vec.25
0386               ********|*****|*********************|**************************
0387               cmdb.cmd.clear:
0388 7A20 C820  54         mov   @cmdb.cmd.clear.vector,@trmpvector
     7A22 7A28     
     7A24 A03A     
0389 7A26 101A  14         jmp   _trampoline.bank3.ret ; Longjump
0390               cmdb.cmd.clear.vector:
0391 7A28 7FF0             data  vec.25
0392               
0393               
0394               ***************************************************************
0395               * Stub for "cmdb.cmdb.getlength"
0396               * bank3 vec.26
0397               ********|*****|*********************|**************************
0398               cmdb.cmd.getlength:
0399 7A2A C820  54         mov   @cmdb.cmd.getlength.vector,@trmpvector
     7A2C 7A32     
     7A2E A03A     
0400 7A30 1015  14         jmp   _trampoline.bank3.ret ; Longjump
0401               cmdb.cmd.getlength.vector:
0402 7A32 7FF2             data  vec.26
0403               
0404               
0405               ***************************************************************
0406               * Stub for "cmdb.cmdb.preset"
0407               * bank3 vec.27
0408               ********|*****|*********************|**************************
0409               cmdb.cmd.preset:
0410 7A34 C820  54         mov   @cmdb.cmd.preset.vector,@trmpvector
     7A36 7A3C     
     7A38 A03A     
0411 7A3A 1010  14         jmp   _trampoline.bank3.ret ; Longjump
0412               cmdb.cmd.preset.vector:
0413 7A3C 7FF4             data  vec.27
0414               
0415               
0416               ***************************************************************
0417               * Stub for "cmdb.cmdb.set"
0418               * bank3 vec.28
0419               ********|*****|*********************|**************************
0420               cmdb.cmd.set:
0421 7A3E C820  54         mov   @cmdb.cmd.set.vector,@trmpvector
     7A40 7A46     
     7A42 A03A     
0422 7A44 100B  14         jmp   _trampoline.bank3.ret ; Longjump
0423               cmdb.cmd.set.vector:
0424 7A46 7FF6             data  vec.28
0425               
0426               
0427               **************************************************************
0428               * Stub for "tibasic.sid.toggle"
0429               * bank3 vec.32
0430               ********|*****|*********************|**************************
0431               tibasic.sid.toggle:
0432 7A48 C820  54         mov   @tibasic.sid.toggle.vector,@trmpvector
     7A4A 7A50     
     7A4C A03A     
0433 7A4E 1006  14         jmp   _trampoline.bank3.ret ; Longjump
0434               tibasic.sid.toggle.vector:
0435 7A50 7FFC             data  vec.31
0436               
0437               
0438               **************************************************************
0439               * Stub for "fm.fastmode"
0440               * bank3 vec.32
0441               ********|*****|*********************|**************************
0442               fm.fastmode:
0443 7A52 C820  54         mov   @fm.fastmode.vector,@trmpvector
     7A54 7A5A     
     7A56 A03A     
0444 7A58 1001  14         jmp   _trampoline.bank3.ret ; Longjump
0445               fm.fastmode.vector:
0446 7A5A 7FFE             data  vec.32
0447               
0448               
0449               
0450               
0451               ***************************************************************
0452               * Trampoline bank 3 with return
0453               ********|*****|*********************|**************************
0454               _trampoline.bank3.ret:
0455 7A5C 0649  14         dect  stack
0456 7A5E C64B  30         mov   r11,*stack            ; Save return address
0457                       ;------------------------------------------------------
0458                       ; Call routine in specified bank
0459                       ;------------------------------------------------------
0460 7A60 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7A62 3098     
0461 7A64 6006                   data bank3.rom        ; | i  p0 = bank address
0462 7A66 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0463                                                   ; |         (deref @trmpvector)
0464 7A68 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0465                       ;------------------------------------------------------
0466                       ; Exit
0467                       ;------------------------------------------------------
0468 7A6A C2F9  30         mov   *stack+,r11           ; Pop r11
0469 7A6C 045B  20         b     *r11                  ; Return to caller
0470               
0471               
0472               
0473               ***************************************************************
0474               * Stub for "fb.tab.next"
0475               * bank4 vec.1
0476               ********|*****|*********************|**************************
0477               fb.tab.next:
0478 7A6E 0649  14         dect  stack
0479 7A70 C64B  30         mov   r11,*stack            ; Save return address
0480                       ;------------------------------------------------------
0481                       ; Put cursor on next tab position
0482                       ;------------------------------------------------------
0483 7A72 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7A74 3098     
0484 7A76 6008                   data bank4.rom        ; | i  p0 = bank address
0485 7A78 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0486 7A7A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0487                       ;------------------------------------------------------
0488                       ; Exit
0489                       ;------------------------------------------------------
0490 7A7C C2F9  30         mov   *stack+,r11           ; Pop r11
0491 7A7E 045B  20         b     *r11                  ; Return to caller
0492               
0493               
0494               ***************************************************************
0495               * Stub for "fb.ruler.init"
0496               * bank4 vec.2
0497               ********|*****|*********************|**************************
0498               fb.ruler.init:
0499 7A80 0649  14         dect  stack
0500 7A82 C64B  30         mov   r11,*stack            ; Save return address
0501                       ;------------------------------------------------------
0502                       ; Setup ruler in memory
0503                       ;------------------------------------------------------
0504 7A84 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7A86 3098     
0505 7A88 6008                   data bank4.rom        ; | i  p0 = bank address
0506 7A8A 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0507 7A8C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0508                       ;------------------------------------------------------
0509                       ; Exit
0510                       ;------------------------------------------------------
0511 7A8E C2F9  30         mov   *stack+,r11           ; Pop r11
0512 7A90 045B  20         b     *r11                  ; Return to caller
0513               
0514               
0515               ***************************************************************
0516               * Stub for "fb.colorlines"
0517               * bank4 vec.3
0518               ********|*****|*********************|**************************
0519               fb.colorlines:
0520 7A92 0649  14         dect  stack
0521 7A94 C64B  30         mov   r11,*stack            ; Save return address
0522                       ;------------------------------------------------------
0523                       ; Colorize frame buffer content
0524                       ;------------------------------------------------------
0525 7A96 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7A98 3098     
0526 7A9A 6008                   data bank4.rom        ; | i  p0 = bank address
0527 7A9C 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0528 7A9E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0529                       ;------------------------------------------------------
0530                       ; Exit
0531                       ;------------------------------------------------------
0532 7AA0 C2F9  30         mov   *stack+,r11           ; Pop r11
0533 7AA2 045B  20         b     *r11                  ; Return to caller
0534               
0535               
0536               ***************************************************************
0537               * Stub for "fb.vdpdump"
0538               * bank4 vec.4
0539               ********|*****|*********************|**************************
0540               fb.vdpdump:
0541 7AA4 0649  14         dect  stack
0542 7AA6 C64B  30         mov   r11,*stack            ; Save return address
0543                       ;------------------------------------------------------
0544                       ; Colorize frame buffer content
0545                       ;------------------------------------------------------
0546 7AA8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7AAA 3098     
0547 7AAC 6008                   data bank4.rom        ; | i  p0 = bank address
0548 7AAE 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0549 7AB0 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0550                       ;------------------------------------------------------
0551                       ; Exit
0552                       ;------------------------------------------------------
0553 7AB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0554 7AB4 045B  20         b     *r11                  ; Return to caller
0555               
0556               
0557               
0558               **************************************************************
0559               * Stub for "edb.clear.sams"
0560               * bank5 vec.1
0561               ********|*****|*********************|**************************
0562               edb.clear.sams:
0563 7AB6 C820  54         mov   @edb.clear.sams.vector,@trmpvector
     7AB8 7ABE     
     7ABA A03A     
0564 7ABC 102E  14         jmp   _trampoline.bank5.ret ; Longjump
0565               edb.clear.sams.vector:
0566 7ABE 7FC0             data  vec.1
0567               
0568               
0569               **************************************************************
0570               * Stub for "edb.hipage.alloc"
0571               * bank5 vec.2
0572               ********|*****|*********************|**************************
0573               edb.hipage.alloc:
0574 7AC0 C820  54         mov   @edb.hipage.alloc.vector,@trmpvector
     7AC2 7AC8     
     7AC4 A03A     
0575 7AC6 1029  14         jmp   _trampoline.bank5.ret ; Longjump
0576               edb.hipage.alloc.vector:
0577 7AC8 7FC2             data  vec.2
0578               
0579               
0580               **************************************************************
0581               * Stub for "edb.block.mark"
0582               * bank5 vec.3
0583               ********|*****|*********************|**************************
0584               edb.block.mark:
0585 7ACA C820  54         mov   @edb.block.mark.vector,@trmpvector
     7ACC 7AD2     
     7ACE A03A     
0586 7AD0 1024  14         jmp   _trampoline.bank5.ret ; Longjump
0587               edb.block.mark.vector:
0588 7AD2 7FC4             data  vec.3
0589               
0590               
0591               **************************************************************
0592               * Stub for "edb.block.mark.m1"
0593               * bank5 vec.4
0594               ********|*****|*********************|**************************
0595               edb.block.mark.m1:
0596 7AD4 C820  54         mov   @edb.block.mark.m1.vector,@trmpvector
     7AD6 7ADC     
     7AD8 A03A     
0597 7ADA 101F  14         jmp   _trampoline.bank5.ret ; Longjump
0598               edb.block.mark.m1.vector:
0599 7ADC 7FC6             data  vec.4
0600               
0601               
0602               **************************************************************
0603               * Stub for "edb.block.mark.m2"
0604               * bank5 vec.5
0605               ********|*****|*********************|**************************
0606               edb.block.mark.m2:
0607 7ADE C820  54         mov   @edb.block.mark.m2.vector,@trmpvector
     7AE0 7AE6     
     7AE2 A03A     
0608 7AE4 101A  14         jmp   _trampoline.bank5.ret ; Longjump
0609               edb.block.mark.m2.vector:
0610 7AE6 7FC8             data  vec.5
0611               
0612               
0613               **************************************************************
0614               * Stub for "edb.block.clip"
0615               * bank5 vec.6
0616               ********|*****|*********************|**************************
0617               edb.block.clip:
0618 7AE8 C820  54         mov   @edb.block.clip.vector,@trmpvector
     7AEA 7AF0     
     7AEC A03A     
0619 7AEE 1015  14         jmp   _trampoline.bank5.ret ; Longjump
0620               edb.block.clip.vector:
0621 7AF0 7FCA             data  vec.6
0622               
0623               
0624               **************************************************************
0625               * Stub for "edb.block.reset"
0626               * bank5 vec.7
0627               ********|*****|*********************|**************************
0628               edb.block.reset:
0629 7AF2 C820  54         mov   @edb.block.reset.vector,@trmpvector
     7AF4 7AFA     
     7AF6 A03A     
0630 7AF8 1010  14         jmp   _trampoline.bank5.ret ; Longjump
0631               edb.block.reset.vector:
0632 7AFA 7FCC             data  vec.7
0633               
0634               
0635               **************************************************************
0636               * Stub for "edb.block.delete"
0637               * bank5 vec.8
0638               ********|*****|*********************|**************************
0639               edb.block.delete:
0640 7AFC C820  54         mov   @edb.block.delete.vector,@trmpvector
     7AFE 7B04     
     7B00 A03A     
0641 7B02 100B  14         jmp   _trampoline.bank5.ret ; Longjump
0642               edb.block.delete.vector:
0643 7B04 7FCE             data  vec.8
0644               
0645               
0646               **************************************************************
0647               * Stub for "edb.block.copy"
0648               * bank5 vec.9
0649               ********|*****|*********************|**************************
0650               edb.block.copy:
0651 7B06 C820  54         mov   @edb.block.copy.vector,@trmpvector
     7B08 7B0E     
     7B0A A03A     
0652 7B0C 1006  14         jmp   _trampoline.bank5.ret ; Longjump
0653               edb.block.copy.vector:
0654 7B0E 7FD0             data  vec.9
0655               
0656               
0657               **************************************************************
0658               * Stub for "edb.line.del"
0659               * bank5 vec.10
0660               ********|*****|*********************|**************************
0661               edb.line.del:
0662 7B10 C820  54         mov   @edb.line.del.vector,@trmpvector
     7B12 7B18     
     7B14 A03A     
0663 7B16 1001  14         jmp   _trampoline.bank5.ret ; Longjump
0664               edb.line.del.vector:
0665 7B18 7FD2             data  vec.10
0666               
0667               
0668               
0669               ***************************************************************
0670               * Trampoline bank 5 with return
0671               ********|*****|*********************|**************************
0672               _trampoline.bank5.ret:
0673 7B1A 0649  14         dect  stack
0674 7B1C C64B  30         mov   r11,*stack            ; Save return address
0675                       ;------------------------------------------------------
0676                       ; Call routine in specified bank
0677                       ;------------------------------------------------------
0678 7B1E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B20 3098     
0679 7B22 600A                   data bank5.rom        ; | i  p0 = bank address
0680 7B24 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0681                                                   ; |         (deref @trmpvector)
0682 7B26 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0683                       ;------------------------------------------------------
0684                       ; Exit
0685                       ;------------------------------------------------------
0686 7B28 C2F9  30         mov   *stack+,r11           ; Pop r11
0687 7B2A 045B  20         b     *r11                  ; Return to caller
0688               
0689               
0690               ***************************************************************
0691               * Stub for "vdp.patterns.dump"
0692               * bank6 vec.1
0693               ********|*****|*********************|**************************
0694               vdp.patterns.dump:
0695 7B2C 0649  14         dect  stack
0696 7B2E C64B  30         mov   r11,*stack            ; Save return address
0697                       ;------------------------------------------------------
0698                       ; Dump VDP patterns
0699                       ;------------------------------------------------------
0700 7B30 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B32 3098     
0701 7B34 600C                   data bank6.rom        ; | i  p0 = bank address
0702 7B36 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0703 7B38 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0704                       ;------------------------------------------------------
0705                       ; Exit
0706                       ;------------------------------------------------------
0707 7B3A C2F9  30         mov   *stack+,r11           ; Pop r11
0708 7B3C 045B  20         b     *r11                  ; Return to caller
0709               
0710               
0711               
0712               ***************************************************************
0713               * Stub for "tibasic"
0714               * bank7 vec.10
0715               ********|*****|*********************|**************************
0716               tibasic1:
0717 7B3E 0204  20         li    tmp0,1
     7B40 0001     
0718 7B42 C804  38         mov   tmp0,@tibasic.session
     7B44 A02E     
0719 7B46 1013  14         jmp   tibasic
0720               tibasic2:
0721 7B48 0204  20         li    tmp0,2
     7B4A 0002     
0722 7B4C C804  38         mov   tmp0,@tibasic.session
     7B4E A02E     
0723 7B50 100E  14         jmp   tibasic
0724               tibasic3:
0725 7B52 0204  20         li    tmp0,3
     7B54 0003     
0726 7B56 C804  38         mov   tmp0,@tibasic.session
     7B58 A02E     
0727 7B5A 1009  14         jmp   tibasic
0728               tibasic4:
0729 7B5C 0204  20         li    tmp0,4
     7B5E 0004     
0730 7B60 C804  38         mov   tmp0,@tibasic.session
     7B62 A02E     
0731 7B64 1004  14         jmp   tibasic
0732               tibasic5:
0733 7B66 0204  20         li    tmp0,5
     7B68 0005     
0734 7B6A C804  38         mov   tmp0,@tibasic.session
     7B6C A02E     
0735               tibasic:
0736 7B6E 0649  14         dect  stack
0737 7B70 C64B  30         mov   r11,*stack            ; Save return address
0738                       ;------------------------------------------------------
0739                       ; Dump VDP patterns
0740                       ;------------------------------------------------------
0741 7B72 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B74 3098     
0742 7B76 600E                   data bank7.rom        ; | i  p0 = bank address
0743 7B78 7FD2                   data vec.10           ; | i  p1 = Vector with target address
0744 7B7A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0745                       ;------------------------------------------------------
0746                       ; Exit
0747                       ;------------------------------------------------------
0748 7B7C C2F9  30         mov   *stack+,r11           ; Pop r11
0749 7B7E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.31063
0146                       copy  "rom.stubs.bankx.asm"         ; Stubs to include in all banks > 0
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
0029               
0030               
0031               ***************************************************************
0032               * Stub for "mem.sams.set.legacy"
0033               * bank7 vec.1
0034               ********|*****|*********************|**************************
0036               
0037               mem.sams.set.legacy:
0038 7B80 0649  14         dect  stack
0039 7B82 C64B  30         mov   r11,*stack            ; Save return address
0040                       ;------------------------------------------------------
0041                       ; Dump VDP patterns
0042                       ;------------------------------------------------------
0043 7B84 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B86 3098     
0044 7B88 600E                   data bank7.rom        ; | i  p0 = bank address
0045 7B8A 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0046 7B8C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 7B8E C2F9  30         mov   *stack+,r11           ; Pop r11
0051 7B90 045B  20         b     *r11                  ; Return to caller
0052               
0054               
0055               
0056               ***************************************************************
0057               * Stub for "mem.sams.set.boot"
0058               * bank7 vec.2
0059               ********|*****|*********************|**************************
0061               
0062               mem.sams.set.boot:
0063 7B92 0649  14         dect  stack
0064 7B94 C64B  30         mov   r11,*stack            ; Save return address
0065                       ;------------------------------------------------------
0066                       ; Dump VDP patterns
0067                       ;------------------------------------------------------
0068 7B96 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B98 3098     
0069 7B9A 600E                   data bank7.rom        ; | i  p0 = bank address
0070 7B9C 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0071 7B9E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0072                       ;------------------------------------------------------
0073                       ; Exit
0074                       ;------------------------------------------------------
0075 7BA0 C2F9  30         mov   *stack+,r11           ; Pop r11
0076 7BA2 045B  20         b     *r11                  ; Return to caller
0077               
0079               
0080               
0081               ***************************************************************
0082               * Stub for "mem.sams.set.stevie"
0083               * bank7 vec.3
0084               ********|*****|*********************|**************************
0086               
0087               mem.sams.set.stevie:
0088 7BA4 0649  14         dect  stack
0089 7BA6 C64B  30         mov   r11,*stack            ; Save return address
0090                       ;------------------------------------------------------
0091                       ; Dump VDP patterns
0092                       ;------------------------------------------------------
0093 7BA8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7BAA 3098     
0094 7BAC 600E                   data bank7.rom        ; | i  p0 = bank address
0095 7BAE 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0096 7BB0 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0097                       ;------------------------------------------------------
0098                       ; Exit
0099                       ;------------------------------------------------------
0100 7BB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0101 7BB4 045B  20         b     *r11                  ; Return to caller
0102               
0104               
0105               
0106               
                   < stevie_b1.asm.31063
0147                       ;-----------------------------------------------------------------------
0148                       ; Program data
0149                       ;-----------------------------------------------------------------------
0150                       copy  "data.keymap.actions.asm"     ; Keyboard actions
     **** ****     > data.keymap.actions.asm
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
0011 7BB6 0D00             byte  key.enter, pane.focus.fb
0012 7BB8 65FA             data  edkey.action.enter
0013               
0014 7BBA 0800             byte  key.fctn.s, pane.focus.fb
0015 7BBC 61BC             data  edkey.action.left
0016               
0017 7BBE 0900             byte  key.fctn.d, pane.focus.fb
0018 7BC0 61D6             data  edkey.action.right
0019               
0020 7BC2 0B00             byte  key.fctn.e, pane.focus.fb
0021 7BC4 62CE             data  edkey.action.up
0022               
0023 7BC6 0A00             byte  key.fctn.x, pane.focus.fb
0024 7BC8 62D6             data  edkey.action.down
0025               
0026 7BCA BF00             byte  key.fctn.h, pane.focus.fb
0027 7BCC 61F2             data  edkey.action.home
0028               
0029 7BCE C000             byte  key.fctn.j, pane.focus.fb
0030 7BD0 621C             data  edkey.action.pword
0031               
0032 7BD2 C100             byte  key.fctn.k, pane.focus.fb
0033 7BD4 626E             data  edkey.action.nword
0034               
0035 7BD6 C200             byte  key.fctn.l, pane.focus.fb
0036 7BD8 61FA             data  edkey.action.end
0037               
0038 7BDA 0C00             byte  key.fctn.6, pane.focus.fb
0039 7BDC 62DE             data  edkey.action.ppage
0040               
0041 7BDE 0200             byte  key.fctn.4, pane.focus.fb
0042 7BE0 631A             data  edkey.action.npage
0043               
0044 7BE2 8500             byte  key.ctrl.e, pane.focus.fb
0045 7BE4 62DE             data  edkey.action.ppage
0046               
0047 7BE6 9800             byte  key.ctrl.x, pane.focus.fb
0048 7BE8 631A             data  edkey.action.npage
0049               
0050 7BEA 7F00             byte  key.fctn.v, pane.focus.fb
0051 7BEC 6370             data  edkey.action.topscr
0052               
0053 7BEE BE00             byte  key.fctn.b, pane.focus.fb
0054 7BF0 63BA             data  edkey.action.botscr
0055               
0056 7BF2 9600             byte  key.ctrl.v, pane.focus.fb
0057 7BF4 6354             data  edkey.action.top
0058               
0059 7BF6 8200             byte  key.ctrl.b, pane.focus.fb
0060 7BF8 638A             data  edkey.action.bot
0061                       ;-------------------------------------------------------
0062                       ; Modifier keys - Delete
0063                       ;-------------------------------------------------------
0064 7BFA 0300             byte  key.fctn.1, pane.focus.fb
0065 7BFC 6448             data  edkey.action.del_char
0066               
0067 7BFE 0700             byte  key.fctn.3, pane.focus.fb
0068 7C00 64FA             data  edkey.action.del_line
0069               
0070 7C02 8C00             byte  key.ctrl.l, pane.focus.fb
0071 7C04 64C6             data  edkey.action.del_eol
0072                       ;-------------------------------------------------------
0073                       ; Modifier keys - Insert
0074                       ;-------------------------------------------------------
0075 7C06 0400             byte  key.fctn.2, pane.focus.fb
0076 7C08 655C             data  edkey.action.ins_char.ws
0077               
0078 7C0A B900             byte  key.fctn.dot, pane.focus.fb
0079 7C0C 6672             data  edkey.action.ins_onoff
0080               
0081 7C0E 0100             byte  key.fctn.7, pane.focus.fb
0082 7C10 6860             data  edkey.action.fb.tab.next
0083               
0084 7C12 9400             byte  key.ctrl.t, pane.focus.fb
0085 7C14 6860             data  edkey.action.fb.tab.next
0086               
0087 7C16 0600             byte  key.fctn.8, pane.focus.fb
0088 7C18 65F2             data  edkey.action.ins_line
0089                       ;-------------------------------------------------------
0090                       ; Block marking/modifier
0091                       ;-------------------------------------------------------
0092 7C1A F000             byte  key.ctrl.space, pane.focus.fb
0093 7C1C 679A             data  edkey.action.block.mark
0094               
0095 7C1E 8300             byte  key.ctrl.c, pane.focus.fb
0096 7C20 673A             data  edkey.action.copyblock_or_clipboard
0097               
0098 7C22 8400             byte  key.ctrl.d, pane.focus.fb
0099 7C24 67EA             data  edkey.action.block.delete
0100               
0101 7C26 8D00             byte  key.ctrl.m, pane.focus.fb
0102 7C28 6814             data  edkey.action.block.move
0103               
0104 7C2A 8700             byte  key.ctrl.g, pane.focus.fb
0105 7C2C 6846             data  edkey.action.block.goto.m1
0106                       ;-------------------------------------------------------
0107                       ; Clipboards
0108                       ;-------------------------------------------------------
0109 7C2E B100             byte  key.ctrl.1, pane.focus.fb
0110 7C30 686E             data  edkey.action.fb.clip.save.1
0111               
0112 7C32 B200             byte  key.ctrl.2, pane.focus.fb
0113 7C34 6874             data  edkey.action.fb.clip.save.2
0114               
0115 7C36 B300             byte  key.ctrl.3, pane.focus.fb
0116 7C38 687A             data  edkey.action.fb.clip.save.3
0117               
0118 7C3A B400             byte  key.ctrl.4, pane.focus.fb
0119 7C3C 6880             data  edkey.action.fb.clip.save.4
0120               
0121 7C3E B500             byte  key.ctrl.5, pane.focus.fb
0122 7C40 6886             data  edkey.action.fb.clip.save.5
0123                       ;-------------------------------------------------------
0124                       ; Other action keys
0125                       ;-------------------------------------------------------
0126 7C42 0500             byte  key.fctn.plus, pane.focus.fb
0127 7C44 672C             data  edkey.action.quit
0128               
0129 7C46 9100             byte  key.ctrl.q, pane.focus.fb
0130 7C48 672C             data  edkey.action.quit
0131               
0132 7C4A 9500             byte  key.ctrl.u, pane.focus.fb
0133 7C4C 66EC             data  edkey.action.toggle.ruler
0134               
0135 7C4E 9A00             byte  key.ctrl.z, pane.focus.fb
0136 7C50 724C             data  pane.action.colorscheme.cycle
0137               
0138 7C52 8000             byte  key.ctrl.comma, pane.focus.fb
0139 7C54 674A             data  edkey.action.fb.fname.dec.load
0140               
0141 7C56 9B00             byte  key.ctrl.dot, pane.focus.fb
0142 7C58 675C             data  edkey.action.fb.fname.inc.load
0143               
0144 7C5A BB00             byte  key.ctrl.slash, pane.focus.fb
0145 7C5C 79B2             data  dialog.basic
0146                       ;-------------------------------------------------------
0147                       ; Dialog keys
0148                       ;-------------------------------------------------------
0149 7C5E 8100             byte  key.ctrl.a, pane.focus.fb
0150 7C60 799E             data  dialog.append
0151               
0152 7C62 8800             byte  key.ctrl.h, pane.focus.fb
0153 7C64 7936             data  edkey.action.about
0154               
0155 7C66 8600             byte  key.ctrl.f, pane.focus.fb
0156 7C68 7968             data  dialog.file
0157               
0158 7C6A 8900             byte  key.ctrl.i, pane.focus.fb
0159 7C6C 7954             data  dialog.insert
0160               
0161 7C6E 9300             byte  key.ctrl.s, pane.focus.fb
0162 7C70 794A             data  dialog.save
0163               
0164 7C72 8F00             byte  key.ctrl.o, pane.focus.fb
0165 7C74 7940             data  dialog.load
0166               
0167 7C76 9000             byte  key.ctrl.p, pane.focus.fb
0168 7C78 795E             data  dialog.print
0169               
0170                       ;
0171                       ; FCTN-9 has multiple purposes, if block mode is on it
0172                       ; resets the block, otherwise show dialog "Main Menu".
0173                       ;
0174 7C7A 0F00             byte  key.fctn.9, pane.focus.fb
0175 7C7C 79BC             data  dialog.menu
0176                       ;-------------------------------------------------------
0177                       ; End of list
0178                       ;-------------------------------------------------------
0179 7C7E FFFF             data  EOL                           ; EOL
0180               
0181               
0182               
0183               *---------------------------------------------------------------
0184               * Action keys mapping table: Command Buffer (CMDB)
0185               *---------------------------------------------------------------
0186               keymap_actions.cmdb:
0187                       ;-------------------------------------------------------
0188                       ; Dialog: Main Menu
0189                       ;-------------------------------------------------------
0190 7C80 4664             byte  key.uc.f, id.dialog.menu
0191 7C82 7968             data  dialog.file
0192               
0193 7C84 4364             byte  key.uc.c, id.dialog.menu
0194 7C86 79A8             data  dialog.cartridge
0195               
0196 7C88 4864             byte  key.uc.h, id.dialog.menu
0197 7C8A 7936             data  edkey.action.about
0198               
0199 7C8C 5164             byte  key.uc.q, id.dialog.menu
0200 7C8E 672C             data  edkey.action.quit
0201                       ;-------------------------------------------------------
0202                       ; Dialog: File
0203                       ;-------------------------------------------------------
0204 7C90 4E69             byte  key.uc.n, id.dialog.file
0205 7C92 6950             data  edkey.action.cmdb.file.new
0206               
0207 7C94 5369             byte  key.uc.s, id.dialog.file
0208 7C96 794A             data  dialog.save
0209               
0210 7C98 4F69             byte  key.uc.o, id.dialog.file
0211 7C9A 7940             data  dialog.load
0212               
0213 7C9C 5069             byte  key.uc.p, id.dialog.file
0214 7C9E 795E             data  dialog.print
0215               
0216 7CA0 4369             byte  key.uc.c, id.dialog.file
0217 7CA2 7994             data  dialog.config
0218                       ;-------------------------------------------------------
0219                       ; Dialog: Open file
0220                       ;-------------------------------------------------------
0221 7CA4 0E0A             byte  key.fctn.5, id.dialog.load
0222 7CA6 6C6C             data  edkey.action.cmdb.fastmode.toggle
0223               
0224 7CA8 0D0A             byte  key.enter, id.dialog.load
0225 7CAA 6974             data  edkey.action.cmdb.load
0226                       ;-------------------------------------------------------
0227                       ; Dialog: Insert file at line ...
0228                       ;-------------------------------------------------------
0229 7CAC 0E0D             byte  key.fctn.5, id.dialog.insert
0230 7CAE 6C6C             data  edkey.action.cmdb.fastmode.toggle
0231               
0232 7CB0 0D0D             byte  key.enter, id.dialog.insert
0233 7CB2 69B8             data  edkey.action.cmdb.insert
0234                       ;-------------------------------------------------------
0235                       ; Dialog: Append file
0236                       ;-------------------------------------------------------
0237 7CB4 0E0E             byte  key.fctn.5, id.dialog.append
0238 7CB6 6C6C             data  edkey.action.cmdb.fastmode.toggle
0239               
0240 7CB8 0D0E             byte  key.enter, id.dialog.append
0241 7CBA 6A3A             data  edkey.action.cmdb.append
0242                       ;-------------------------------------------------------
0243                       ; Dialog: Copy clipboard to line ...
0244                       ;-------------------------------------------------------
0245 7CBC 0E67             byte  key.fctn.5, id.dialog.clipboard
0246 7CBE 6C6C             data  edkey.action.cmdb.fastmode.toggle
0247               
0248 7CC0 0167             byte  key.fctn.7, id.dialog.clipboard
0249 7CC2 798A             data  dialog.clipdev
0250               
0251 7CC4 3167             byte  key.num.1, id.dialog.clipboard
0252 7CC6 6AAE             data  edkey.action.cmdb.clip.1
0253               
0254 7CC8 3267             byte  key.num.2, id.dialog.clipboard
0255 7CCA 6AB4             data  edkey.action.cmdb.clip.2
0256               
0257 7CCC 3367             byte  key.num.3, id.dialog.clipboard
0258 7CCE 6ABA             data  edkey.action.cmdb.clip.3
0259               
0260 7CD0 3467             byte  key.num.4, id.dialog.clipboard
0261 7CD2 6AC0             data  edkey.action.cmdb.clip.4
0262               
0263 7CD4 3567             byte  key.num.5, id.dialog.clipboard
0264 7CD6 6AC6             data  edkey.action.cmdb.clip.5
0265                       ;-------------------------------------------------------
0266                       ; Dialog: Configure clipboard device
0267                       ;-------------------------------------------------------
0268 7CD8 0D11             byte  key.enter, id.dialog.clipdev
0269 7CDA 6AFA             data  edkey.action.cmdb.clipdev.configure
0270                       ;-------------------------------------------------------
0271                       ; Dialog: Configure
0272                       ;-------------------------------------------------------
0273 7CDC 436C             byte  key.uc.c, id.dialog.config
0274 7CDE 798A             data  dialog.clipdev
0275                       ;-------------------------------------------------------
0276                       ; Dialog: Save file
0277                       ;-------------------------------------------------------
0278 7CE0 0D0B             byte  key.enter, id.dialog.save
0279 7CE2 6B4A             data  edkey.action.cmdb.save
0280               
0281 7CE4 0D0C             byte  key.enter, id.dialog.saveblock
0282 7CE6 6B4A             data  edkey.action.cmdb.save
0283                       ;-------------------------------------------------------
0284                       ; Dialog: Print file
0285                       ;-------------------------------------------------------
0286 7CE8 0D0F             byte  key.enter, id.dialog.print
0287 7CEA 6BC6             data  edkey.action.cmdb.print
0288               
0289 7CEC 0D10             byte  key.enter, id.dialog.printblock
0290 7CEE 6BC6             data  edkey.action.cmdb.print
0291                       ;-------------------------------------------------------
0292                       ; Dialog: Unsaved changes
0293                       ;-------------------------------------------------------
0294 7CF0 0C65             byte  key.fctn.6, id.dialog.unsaved
0295 7CF2 6C42             data  edkey.action.cmdb.proceed
0296               
0297 7CF4 2065             byte  key.space, id.dialog.unsaved
0298 7CF6 6C42             data  edkey.action.cmdb.proceed
0299               
0300 7CF8 0D65             byte  key.enter, id.dialog.unsaved
0301 7CFA 794A             data  dialog.save
0302                       ;-------------------------------------------------------
0303                       ; Dialog: Cartridge
0304                       ;-------------------------------------------------------
0305 7CFC 426A             byte  key.uc.b, id.dialog.cartridge
0306 7CFE 79B2             data  dialog.basic
0307                       ;-------------------------------------------------------
0308                       ; Dialog: Basic
0309                       ;-------------------------------------------------------
0310 7D00 316B             byte  key.num.1, id.dialog.basic
0311 7D02 7B3E             data  tibasic1
0312 7D04 326B             byte  key.num.2, id.dialog.basic
0313 7D06 7B48             data  tibasic2
0314 7D08 336B             byte  key.num.3, id.dialog.basic
0315 7D0A 7B52             data  tibasic3
0316 7D0C 346B             byte  key.num.4, id.dialog.basic
0317 7D0E 7B5C             data  tibasic4
0318 7D10 356B             byte  key.num.5, id.dialog.basic
0319 7D12 7B66             data  tibasic5
0320 7D14 0E6B             byte  key.fctn.5, id.dialog.basic
0321 7D16 6C78             data  edkey.action.cmdb.sid.toggle
0322                       ;-------------------------------------------------------
0323                       ; Dialog: Help
0324                       ;-------------------------------------------------------
0325 7D18 0F68             byte  key.fctn.9, id.dialog.help
0326 7D1A 6C8C             data  edkey.action.cmdb.close.about
0327               
0328 7D1C 0D68             byte  key.enter, id.dialog.help
0329 7D1E 6C8C             data  edkey.action.cmdb.close.about
0330                       ;-------------------------------------------------------
0331                       ; Movement keys
0332                       ;-------------------------------------------------------
0333 7D20 0801             byte  key.fctn.s, pane.focus.cmdb
0334 7D22 689E             data  edkey.action.cmdb.left
0335               
0336 7D24 0901             byte  key.fctn.d, pane.focus.cmdb
0337 7D26 68B0             data  edkey.action.cmdb.right
0338               
0339 7D28 BF01             byte  key.fctn.h, pane.focus.cmdb
0340 7D2A 68C8             data  edkey.action.cmdb.home
0341               
0342 7D2C C201             byte  key.fctn.l, pane.focus.cmdb
0343 7D2E 68DC             data  edkey.action.cmdb.end
0344                       ;-------------------------------------------------------
0345                       ; Modifier keys
0346                       ;-------------------------------------------------------
0347 7D30 0701             byte  key.fctn.3, pane.focus.cmdb
0348 7D32 68F4             data  edkey.action.cmdb.clear
0349                       ;-------------------------------------------------------
0350                       ; Other action keys
0351                       ;-------------------------------------------------------
0352 7D34 0F01             byte  key.fctn.9, pane.focus.cmdb
0353 7D36 6C98             data  edkey.action.cmdb.close.dialog
0354               
0355 7D38 0501             byte  key.fctn.plus, pane.focus.cmdb
0356 7D3A 672C             data  edkey.action.quit
0357               
0358 7D3C 8101             byte  key.ctrl.a, pane.focus.cmdb
0359 7D3E 6C84             data  edkey.action.cmdb.preset
0360               
0361 7D40 8201             byte  key.ctrl.b, pane.focus.cmdb
0362 7D42 6C84             data  edkey.action.cmdb.preset
0363               
0364 7D44 8301             byte  key.ctrl.c, pane.focus.cmdb
0365 7D46 6C84             data  edkey.action.cmdb.preset
0366               
0367 7D48 9A01             byte  key.ctrl.z, pane.focus.cmdb
0368 7D4A 724C             data  pane.action.colorscheme.cycle
0369                       ;------------------------------------------------------
0370                       ; End of list
0371                       ;-------------------------------------------------------
0372 7D4C FFFF             data  EOL                           ; EOL
                   < stevie_b1.asm.31063
0151                       ;-----------------------------------------------------------------------
0152                       ; Bank full check
0153                       ;-----------------------------------------------------------------------
0157                       ;-----------------------------------------------------------------------
0158                       ; Show ROM bank in CPU crash screen
0159                       ;-----------------------------------------------------------------------
0160               cpu.crash.showbank:
0161                       aorg  >7fb0
0162 7FB0 06A0  32         bl    @putat
     7FB2 2456     
0163 7FB4 0314                   byte 3,20
0164 7FB6 7FBA                   data cpu.crash.showbank.bankstr
0165 7FB8 10FF  14         jmp   $
0166               cpu.crash.showbank.bankstr:
0167               
0168 7FBA 05               byte  5
0169 7FBB   52             text  'ROM#1'
     7FBC 4F4D     
     7FBE 2331     
0170                       even
0171               
0172                       ;-----------------------------------------------------------------------
0173                       ; Vector table
0174                       ;-----------------------------------------------------------------------
0175                       aorg  bankx.vectab
0176                       copy  "rom.vectors.bank1.asm"
     **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 60F2     vec.1   data  mem.sams.setup.stevie ;
0008 7FC2 2026     vec.2   data  cpu.crash             ;
0009 7FC4 2026     vec.3   data  cpu.crash             ;
0010 7FC6 2026     vec.4   data  cpu.crash             ;
0011 7FC8 2026     vec.5   data  cpu.crash             ;
0012 7FCA 2026     vec.6   data  cpu.crash             ;
0013 7FCC 2026     vec.7   data  cpu.crash             ;
0014 7FCE 2026     vec.8   data  cpu.crash             ;
0015 7FD0 2026     vec.9   data  cpu.crash             ;
0016 7FD2 6F62     vec.10  data  edb.line.pack.fb      ;
0017 7FD4 705A     vec.11  data  edb.line.unpack.fb    ;
0018 7FD6 7AB6     vec.12  data  edb.clear.sams        ;
0019 7FD8 2026     vec.13  data  cpu.crash             ;
0020 7FDA 2026     vec.14  data  cpu.crash             ;
0021 7FDC 693E     vec.15  data  edkey.action.cmdb.show
0022 7FDE 2026     vec.16  data  cpu.crash             ;
0023 7FE0 2026     vec.17  data  cpu.crash             ;
0024 7FE2 2026     vec.18  data  cpu.crash             ;
0025 7FE4 7A20     vec.19  data  cmdb.cmd.clear        ;
0026 7FE6 6EB6     vec.20  data  fb.refresh            ;
0027 7FE8 7AA4     vec.21  data  fb.vdpdump            ;
0028 7FEA 6CAC     vec.22  data  fb.row2line           ;
0029 7FEC 2026     vec.23  data  cpu.crash             ;
0030 7FEE 2026     vec.24  data  cpu.crash             ;
0031 7FF0 2026     vec.25  data  cpu.crash             ;
0032 7FF2 2026     vec.26  data  cpu.crash             ;
0033 7FF4 7694     vec.27  data  pane.errline.hide     ;
0034 7FF6 74D4     vec.28  data  pane.cursor.blink     ;
0035 7FF8 74B6     vec.29  data  pane.cursor.hide      ;
0036 7FFA 7632     vec.30  data  pane.errline.show     ;
0037 7FFC 72AA     vec.31  data  pane.action.colorscheme.load
0038 7FFE 749C     vec.32  data  pane.action.colorscheme.statlines
                   < stevie_b1.asm.31063
0177                                                   ; Vector table bank 1
0178               *--------------------------------------------------------------
0179               * Video mode configuration
0180               *--------------------------------------------------------------
0181      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0182      0004     spfbck  equ   >04                   ; Screen background color.
0183      36E4     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0184      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0185      0050     colrow  equ   80                    ; Columns per row
0186      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0187      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0188      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0189      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

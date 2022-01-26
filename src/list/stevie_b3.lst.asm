XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b3.asm.68345
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2022 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b3.asm               ; Version 220126-2148540
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
0033      6038     kickstart.resume          equ  >6038   ; Resume Stevie session
0034      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0035      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0036      0001     rom0_kscan_on             equ  1       ; Use KSCAN in console ROM#0
0037               
0038               
0039               
0040               *--------------------------------------------------------------
0041               * classic99 and JS99er emulators are mutually exclusive.
0042               * At the time of writing JS99er has full F18a compatibility.
0043               *
0044               * If build target is the JS99er emulator or an F18a equiped TI-99/4a
0045               * then set the 'full_f18a_support' equate to 1.
0046               *
0047               * When targetting the classic99 emulator then set the
0048               * 'full_f18a_support' equate to 0.
0049               * This will build the trimmed down version with 24x80 resolution.
0050               *--------------------------------------------------------------
0051      0000     debug                     equ  0       ; Turn on debugging mode
0052      0000     full_f18a_support         equ  0       ; 30 rows mode with sprites
0053               
0054               
0055               *--------------------------------------------------------------
0056               * JS99er F18a 30x80, no FG99 advanced mode
0057               *--------------------------------------------------------------
0063               
0064               
0065               
0066               *--------------------------------------------------------------
0067               * Classic99 F18a 24x80, no FG99 advanced mode
0068               *--------------------------------------------------------------
0070      0000     device.f18a               equ  0       ; F18a GPU
0071      0001     device.9938               equ  1       ; 9938 GPU
0072      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode off
0073      0001     skip_vdp_f18a_support     equ  1       ; Turn off f18a GPU check
0075               
0076               
0077               
0078               *--------------------------------------------------------------
0079               * ROM layout
0080               *--------------------------------------------------------------
0081      7F00     bankx.crash.showbank      equ  >7f00   ; Show ROM bank in CPU crash screen
0082      7FC0     bankx.vectab              equ  >7fc0   ; Start address of vector table
                   < stevie_b3.asm.68345
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
                   < stevie_b3.asm.68345
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
0071               
0072      0017     pane.botrow               equ  23      ; Bottom row on screen
0073               
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
0113               * Keyboard flags in Stevie
0114               *--------------------------------------------------------------
0115      0001     kbf.kbclear               equ  >0001   ;  Keyboard buffer cleared / @w$0001
0116               
0117               *--------------------------------------------------------------
0118               * File work mode
0119               *--------------------------------------------------------------
0120      0001     id.file.loadfile          equ  1       ; Load file
0121      0002     id.file.insertfile        equ  2       ; Insert file
0122      0003     id.file.appendfile        equ  3       ; Append file
0123      0004     id.file.savefile          equ  4       ; Save file
0124      0005     id.file.saveblock         equ  5       ; Save block to file
0125      0006     id.file.clipblock         equ  6       ; Save block to clipboard
0126      0007     id.file.printfile         equ  7       ; Print file
0127      0008     id.file.printblock        equ  8       ; Print block
0128               *--------------------------------------------------------------
0129               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0130               *--------------------------------------------------------------
0131      A000     core1.top         equ  >a000           ; Structure begin
0132      A000     magic.str.w1      equ  core1.top + 0   ; Magic string word 1
0133      A002     magic.str.w2      equ  core1.top + 2   ; Magic string word 2
0134      A004     magic.str.w3      equ  core1.top + 4   ; Magic string word 3
0135      A006     parm1             equ  core1.top + 6   ; Function parameter 1
0136      A008     parm2             equ  core1.top + 8   ; Function parameter 2
0137      A00A     parm3             equ  core1.top + 10  ; Function parameter 3
0138      A00C     parm4             equ  core1.top + 12  ; Function parameter 4
0139      A00E     parm5             equ  core1.top + 14  ; Function parameter 5
0140      A010     parm6             equ  core1.top + 16  ; Function parameter 6
0141      A012     parm7             equ  core1.top + 18  ; Function parameter 7
0142      A014     parm8             equ  core1.top + 20  ; Function parameter 8
0143      A016     outparm1          equ  core1.top + 22  ; Function output parameter 1
0144      A018     outparm2          equ  core1.top + 24  ; Function output parameter 2
0145      A01A     outparm3          equ  core1.top + 26  ; Function output parameter 3
0146      A01C     outparm4          equ  core1.top + 28  ; Function output parameter 4
0147      A01E     outparm5          equ  core1.top + 30  ; Function output parameter 5
0148      A020     outparm6          equ  core1.top + 32  ; Function output parameter 6
0149      A022     outparm7          equ  core1.top + 34  ; Function output parameter 7
0150      A024     outparm8          equ  core1.top + 36  ; Function output parameter 8
0151      A026     kbflags           equ  core1.top + 38  ; Keyboard control flags
0152      A028     keycode1          equ  core1.top + 40  ; Current key scanned
0153      A02A     keycode2          equ  core1.top + 42  ; Previous key scanned
0154      A02C     unpacked.string   equ  core1.top + 44  ; 6 char string with unpacked uin16
0155      A032     tibasic.hidesid   equ  core1.top + 50  ; Hide TI-Basic session ID
0156      A034     tibasic.session   equ  core1.top + 52  ; Active TI-Basic session (1-5)
0157      A036     tibasic1.status   equ  core1.top + 54  ; TI Basic session 1
0158      A038     tibasic2.status   equ  core1.top + 56  ; TI Basic session 2
0159      A03A     tibasic3.status   equ  core1.top + 58  ; TI Basic session 3
0160      A03C     tibasic4.status   equ  core1.top + 60  ; TI Basic session 4
0161      A03E     tibasic5.status   equ  core1.top + 62  ; TI Basic session 5
0162      A040     trmpvector        equ  core1.top + 64  ; Vector trampoline (if p1|tmp1 = >ffff)
0163      A042     ramsat            equ  core1.top + 66  ; Sprite Attr. Table in RAM (14 bytes)
0164      A050     timers            equ  core1.top + 80  ; Timers (80 bytes)
0165      A0A0     core1.free        equ  core1.top + 160 ; End of structure
0166               *--------------------------------------------------------------
0167               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0168               *--------------------------------------------------------------
0169      A100     core2.top         equ  >a100           ; Structure begin
0170      A100     rambuf            equ  core2.top       ; RAM workbuffer
0171      A200     core2.free        equ  core2.top + 256 ; End of structure
0172               *--------------------------------------------------------------
0173               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0174               *--------------------------------------------------------------
0175      A200     tv.top            equ  >a200           ; Structure begin
0176      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0177      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0178      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0179      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0180      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0181      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0182      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0183      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0184      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0185      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0186      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0187      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0188      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0189      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0190      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0191      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0192      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0193      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0194      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0195      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0196      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0197      A22A     tv.error.rows     equ  tv.top + 42     ; Number of rows in error pane
0198      A22C     tv.sp2.conf       equ  tv.top + 44     ; Backup of SP2 config register
0199      A22E     tv.error.msg      equ  tv.top + 46     ; Error message (max. 160 characters)
0200      A2CE     tv.free           equ  tv.top + 206    ; End of structure
0201               *--------------------------------------------------------------
0202               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0203               *--------------------------------------------------------------
0204      A300     fb.struct         equ  >a300           ; Structure begin
0205      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0206      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0207      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0208                                                      ; line X in editor buffer).
0209      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0210                                                      ; (offset 0 .. @fb.scrrows)
0211      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0212      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0213      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0214      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0215      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0216      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0217      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0218      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0219      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0220      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0221      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0222      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0223      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0224      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0225               *--------------------------------------------------------------
0226               * File handle structure               @>a400-a4ff   (256 bytes)
0227               *--------------------------------------------------------------
0228      A400     fh.struct         equ  >a400           ; stevie file handling structures
0229               ;***********************************************************************
0230               ; ATTENTION
0231               ; The dsrlnk variables must form a continuous memory block and keep
0232               ; their order!
0233               ;***********************************************************************
0234      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0235      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0236      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0237      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0238      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0239      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0240      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0241      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0242      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0243      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0244      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0245      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0246      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0247      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0248      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0249      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0250      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0251      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0252      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0253      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0254      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0255      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0256      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0257      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0258      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0259      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0260      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0261      A45A     fh.workmode       equ  fh.struct + 90  ; Working mode (used in callbacks)
0262      A45C     fh.kilobytes.prev equ  fh.struct + 92  ; Kilobytes processed (previous)
0263      A45E     fh.line           equ  fh.struct + 94  ; Editor buffer line currently processing
0264      A460     fh.temp1          equ  fh.struct + 96  ; Temporary variable 1
0265      A462     fh.temp2          equ  fh.struct + 98  ; Temporary variable 2
0266      A464     fh.temp3          equ  fh.struct +100  ; Temporary variable 3
0267      A466     fh.membuffer      equ  fh.struct +102  ; 80 bytes file memory buffer
0268      A4B6     fh.free           equ  fh.struct +182  ; End of structure
0269      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0270      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0271               *--------------------------------------------------------------
0272               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0273               *--------------------------------------------------------------
0274      A500     edb.struct        equ  >a500           ; Begin structure
0275      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0276      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0277      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0278      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0279      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0280      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0281      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0282      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0283      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0284      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0285                                                      ; with current filename.
0286      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0287                                                      ; with current file type.
0288      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0289      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0290      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0291                                                      ; for filename, but not always used.
0292      A56A     edb.free          equ  edb.struct + 106; End of structure
0293               *--------------------------------------------------------------
0294               * Index structure                     @>a600-a6ff   (256 bytes)
0295               *--------------------------------------------------------------
0296      A600     idx.struct        equ  >a600           ; stevie index structure
0297      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0298      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0299      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0300      A606     idx.free          equ  idx.struct + 6  ; End of structure
0301               *--------------------------------------------------------------
0302               * Command buffer structure            @>a700-a7ff   (256 bytes)
0303               *--------------------------------------------------------------
0304      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0305      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0306      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0307      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0308      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0309      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0310      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0311      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0312      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0313      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0314      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0315      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0316      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0317      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0318      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0319      A71C     cmdb.dialog.var   equ  cmdb.struct + 28; Dialog private variable or pointer
0320      A71E     cmdb.panhead      equ  cmdb.struct + 30; Pointer to string pane header
0321      A720     cmdb.paninfo      equ  cmdb.struct + 32; Pointer to string pane info (1st line)
0322      A722     cmdb.panhint      equ  cmdb.struct + 34; Pointer to string pane hint (2nd line)
0323      A724     cmdb.panmarkers   equ  cmdb.struct + 36; Pointer to key marker list  (3rd line)
0324      A726     cmdb.pankeys      equ  cmdb.struct + 38; Pointer to string pane keys (stat line)
0325      A728     cmdb.action.ptr   equ  cmdb.struct + 40; Pointer to function to execute
0326      A72A     cmdb.cmdall       equ  cmdb.struct + 42; Current command including length-byte
0327      A72A     cmdb.cmdlen       equ  cmdb.struct + 42; Length of current command (MSB byte!)
0328      A72B     cmdb.cmd          equ  cmdb.struct + 43; Current command (80 bytes max.)
0329      A77C     cmdb.panhead.buf  equ  cmdb.struct +124; String buffer for pane header
0330      A7AE     cmdb.dflt.fname   equ  cmdb.struct +174; Default for filename
0331      A800     cmdb.free         equ  cmdb.struct +256; End of structure
0332               *--------------------------------------------------------------
0333               * Stevie value stack                  @>a800-a8ff   (256 bytes)
0334               *--------------------------------------------------------------
0335      A900     sp2.stktop        equ  >a900           ; \ SP2 stack >a800 - >a8ff
0336                                                      ; | The stack grows from high memory
0337                                                      ; / to low memory.
0338               *--------------------------------------------------------------
0339               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0340               *--------------------------------------------------------------
0341      7E00     cpu.scrpad.src    equ  >7e00           ; \ Dump of OS monitor scratchpad
0342                                                      ; / stored in cartridge ROM bank7.asm
0343               
0344      F960     cpu.scrpad.tgt    equ  >f960           ; \ Target copy of OS monitor scratchpad
0345                                                      ; | in high-memory.
0346                                                      ; /
0347               
0348      AD00     cpu.scrpad.moved  equ  >ad00           ; Stevie scratchpad memory when paged-out
0349                                                      ; because of TI Basic/External program
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
0381               
0382               
0383               *--------------------------------------------------------------
0384               * Stevie specific equates
0385               *--------------------------------------------------------------
0386      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0387      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0388      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0389      A028     rom0_kscan_out            equ  keycode1; Where to store value of key pressed
0390               
0391      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0392      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0393      1DF0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0394                                                      ; VDP TAT address of 1st CMDB row
0395      0000     vdp.sit.base              equ  >0000   ; VDP SIT base address
0396      0780     vdp.sit.size              equ  (pane.botrow + 1) * 80
0397                                                      ; VDP SIT size 80 columns, 24/30 rows
0398      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0399      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0400      00FE     tv.1timeonly              equ  254     ; One-time only flag indicator
                   < stevie_b3.asm.68345
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
                   < stevie_b3.asm.68345
0018               
0019               ***************************************************************
0020               * BANK 3
0021               ********|*****|*********************|**************************
0022      6006     bankid  equ   bank3.rom             ; Set bank identifier to current bank
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
0009 6002 02               byte  >02                   ; 2  Number of programs (optional)     >6002
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
0031 600E 6038             data  kickstart.resume      ; 14 \ Program address                 >600e
0032                                                   ; 15 /
0033               
0051               
0059               
0060 6010 13               byte  19
0061 6011   53             text  'STEVIE 1.3A (24X80)'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3341     
     601C 2028     
     601E 3234     
     6020 5838     
     6022 3029     
0062                       even
0063               
0065               
                   < stevie_b3.asm.68345
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
     2084 2EE4     
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
     20B2 29B0     
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
     20C6 29B0     
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
     2116 29BA     
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
     214A 29BA     
0186 214C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0187 214E A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0188 2150 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0189                                                   ; /         LSB offset for ASCII digit 0-9
0190                       ;------------------------------------------------------
0191                       ; Display crash register content
0192                       ;------------------------------------------------------
0193               cpu.crash.showreg.content:
0194 2152 06A0  32         bl    @mkhex                ; Convert hex word to string
     2154 292C     
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
     2190 7F00     
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
0270 21ED   42             text  'Build-ID  220126-2148540'
     21EE 7569     
     21F0 6C64     
     21F2 2D49     
     21F4 4420     
     21F6 2032     
     21F8 3230     
     21FA 3132     
     21FC 362D     
     21FE 3231     
     2200 3438     
     2202 3534     
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
0045                                                   ; (alpha lock off)
0046               
0047                       ; See CRU interface and keyboard sections for details
0048                       ; http://www.nouspikel.com/ti99/titechpages.htm
0049               
0050 28D6 04CC  14         clr   r12                   ; Set base address (to bit 0) so
0051                                                   ; following offsets correspond
0052               
0053 28D8 1E15  20         sbz   21                    ; \ Set bit 21 (PIN 5 attached to alpha
0054                                                   ; / lock column) to 0.
0055               
0056 28DA 0BEC  56         src   r12,14                ; Burn some time (r12=0 no problem shifting)
0057               
0058 28DC 1F07  20         tb    7                     ; \ Copy CRU bit 7 into EQ bit
0059                                                   ; | That is CRU INT7*/P15 pin (keyboard row
0060                                                   ; | with keys FCTN, 2,3,4,5,1,
0061                                                   ; / [joy1-up,joy2-up, Alpha Lock])
0062               
0063 28DE 1302  14         jeq   !                     ; No, alpha lock is off
0064               
0065 28E0 E0A0  34         soc   @wbit10,config        ; \ Yes, alpha lock is on.
     28E2 200C     
0066                                                   ; / Set CONFIG register bit 10=1
0067               
0068 28E4 1D15  20 !       sbo   21                    ; \ Reset bit 21 (Pin 5 attached to alpha
0069                                                   ; / lock column) to 1.
0070                       ;------------------------------------------------------
0071                       ; (2) Prepare for OS monitor kscan
0072                       ;------------------------------------------------------
0073 28E6 C820  54         mov   @scrpad.83c6,@>83c6   ; Required for lowercase support
     28E8 2926     
     28EA 83C6     
0074 28EC C820  54         mov   @scrpad.83fa,@>83fa   ; Load GPLWS R13
     28EE 2928     
     28F0 83FA     
0075 28F2 C820  54         mov   @scrpad.83fe,@>83fe   ; Load GPLWS R15
     28F4 292A     
     28F6 83FE     
0076               
0077 28F8 04C4  14         clr   tmp0                  ; \ Keyboard mode in MSB
0078                                                   ; / 00=Scan all of keyboard
0079               
0080 28FA D804  38         movb  tmp0,@>8374           ; Set keyboard mode at @>8374
     28FC 8374     
0081                                                   ; (scan entire keyboard)
0082               
0083 28FE 02E0  18         lwpi  >83e0                 ; Activate GPL workspace
     2900 83E0     
0084               
0085 2902 06A0  32         bl    @kscan                ; Call KSCAN
     2904 000E     
0086 2906 02E0  18         lwpi  ws1                   ; Activate user workspace
     2908 8300     
0087                       ;------------------------------------------------------
0088                       ; (3) Check if key pressed
0089                       ;------------------------------------------------------
0090 290A D120  34         movb  @>837c,tmp0           ; Get flag
     290C 837C     
0091 290E 0A34  56         sla   tmp0,3                ; Flag value is >20
0092 2910 1707  14         jnc   rkscan.exit           ; No key pressed, exit early
0093                       ;------------------------------------------------------
0094                       ; (4) Key detected, store in memory
0095                       ;------------------------------------------------------
0096 2912 D120  34         movb  @>8375,tmp0           ; \ Key pressed is at @>8375
     2914 8375     
0097 2916 0984  56         srl   tmp0,8                ; / Move to LSB
0099 2918 C804  38         mov   tmp0,@rom0_kscan_out  ; Store ASCII value in user location
     291A A028     
0103 291C E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     291E 200A     
0104                       ;------------------------------------------------------
0105                       ; Exit
0106                       ;------------------------------------------------------
0107               rkscan.exit:
0108 2920 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0109 2922 C2F9  30         mov   *stack+,r11           ; Pop r11
0110 2924 045B  20         b     *r11                  ; Return to caller
0111               
0112               
0113 2926 0200     scrpad.83c6   data >0200            ; Required for KSCAN to support lowercase
0114 2928 9800     scrpad.83fa   data >9800
0115               
0116               ; Dummy value for GPLWS R15 (instead of VDP write address port 8c02)
0117               ; We do not want console KSCAN to fiddle with VDP registers while Stevie
0118               ; is running
0119               
0120 292A 83A0     scrpad.83fe   data >83a0            ; 8c02
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
0023 292C C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 292E C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2930 8340     
0025 2932 04E0  34         clr   @waux1
     2934 833C     
0026 2936 04E0  34         clr   @waux2
     2938 833E     
0027 293A 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     293C 833C     
0028 293E C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2940 0205  20         li    tmp1,4                ; 4 nibbles
     2942 0004     
0033 2944 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2946 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2948 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 294A 0286  22         ci    tmp2,>000a
     294C 000A     
0039 294E 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2950 C21B  26         mov   *r11,tmp4
0045 2952 0988  56         srl   tmp4,8                ; Right justify
0046 2954 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2956 FFF6     
0047 2958 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 295A C21B  26         mov   *r11,tmp4
0054 295C 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     295E 00FF     
0055               
0056 2960 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2962 06C6  14         swpb  tmp2
0058 2964 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2966 0944  56         srl   tmp0,4                ; Next nibble
0060 2968 0605  14         dec   tmp1
0061 296A 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 296C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     296E BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2970 C160  34         mov   @waux3,tmp1           ; Get pointer
     2972 8340     
0067 2974 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2976 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2978 C120  34         mov   @waux2,tmp0
     297A 833E     
0070 297C 06C4  14         swpb  tmp0
0071 297E DD44  32         movb  tmp0,*tmp1+
0072 2980 06C4  14         swpb  tmp0
0073 2982 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2984 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2986 8340     
0078 2988 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     298A 2016     
0079 298C 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 298E C120  34         mov   @waux1,tmp0
     2990 833C     
0084 2992 06C4  14         swpb  tmp0
0085 2994 DD44  32         movb  tmp0,*tmp1+
0086 2996 06C4  14         swpb  tmp0
0087 2998 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 299A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     299C 2020     
0092 299E 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29A0 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29A2 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29A4 7FFF     
0098 29A6 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29A8 8340     
0099 29AA 0460  28         b     @xutst0               ; Display string
     29AC 2434     
0100 29AE 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29B0 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29B2 832A     
0122 29B4 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29B6 8000     
0123 29B8 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29BA 0207  20 mknum   li    tmp3,5                ; Digit counter
     29BC 0005     
0020 29BE C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29C0 C155  26         mov   *tmp1,tmp1            ; /
0022 29C2 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29C4 0228  22         ai    tmp4,4                ; Get end of buffer
     29C6 0004     
0024 29C8 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29CA 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29CC 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29CE 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29D0 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29D2 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29D4 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29D6 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29D8 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29DA 0607  14         dec   tmp3                  ; Decrease counter
0036 29DC 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29DE 0207  20         li    tmp3,4                ; Check first 4 digits
     29E0 0004     
0041 29E2 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29E4 C11B  26         mov   *r11,tmp0
0043 29E6 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29E8 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29EA 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29EC 05CB  14 mknum3  inct  r11
0047 29EE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29F0 2020     
0048 29F2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29F4 045B  20         b     *r11                  ; Exit
0050 29F6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29F8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29FA 13F8  14         jeq   mknum3                ; Yes, exit
0053 29FC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29FE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A00 7FFF     
0058 2A02 C10B  18         mov   r11,tmp0
0059 2A04 0224  22         ai    tmp0,-4
     2A06 FFFC     
0060 2A08 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A0A 0206  20         li    tmp2,>0500            ; String length = 5
     2A0C 0500     
0062 2A0E 0460  28         b     @xutstr               ; Display string
     2A10 2436     
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
0093 2A12 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A14 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A16 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A18 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A1A 0207  20         li    tmp3,5                ; Set counter
     2A1C 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A1E 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A20 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A22 0584  14         inc   tmp0                  ; Next character
0105 2A24 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A26 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A28 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A2A 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A2C DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A2E 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A30 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A32 0607  14         dec   tmp3                  ; Last character ?
0121 2A34 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A36 045B  20         b     *r11                  ; Return
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
0139 2A38 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A3A 832A     
0140 2A3C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A3E 8000     
0141 2A40 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A42 0649  14         dect  stack
0023 2A44 C64B  30         mov   r11,*stack            ; Save return address
0024 2A46 0649  14         dect  stack
0025 2A48 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A4A 0649  14         dect  stack
0027 2A4C C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A4E 0649  14         dect  stack
0029 2A50 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A52 0649  14         dect  stack
0031 2A54 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A56 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A58 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A5A C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A5C 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A5E 0649  14         dect  stack
0044 2A60 C64B  30         mov   r11,*stack            ; Save return address
0045 2A62 0649  14         dect  stack
0046 2A64 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A66 0649  14         dect  stack
0048 2A68 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A6A 0649  14         dect  stack
0050 2A6C C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A6E 0649  14         dect  stack
0052 2A70 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A72 C1D4  26 !       mov   *tmp0,tmp3
0057 2A74 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A76 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A78 00FF     
0059 2A7A 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A7C 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A7E 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A80 0584  14         inc   tmp0                  ; Next byte
0067 2A82 0607  14         dec   tmp3                  ; Shorten string length
0068 2A84 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A86 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A88 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A8A C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A8C 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A8E C187  18         mov   tmp3,tmp2
0078 2A90 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A92 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A94 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A96 24F4     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A98 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A9A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A9C FFCE     
0090 2A9E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AA0 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2AA2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AA4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2AA6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2AA8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2AAA C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2AAC 045B  20         b     *r11                  ; Return to caller
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
0123 2AAE 0649  14         dect  stack
0124 2AB0 C64B  30         mov   r11,*stack            ; Save return address
0125 2AB2 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AB4 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AB6 0649  14         dect  stack
0128 2AB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2ABA 0649  14         dect  stack
0130 2ABC C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2ABE 0649  14         dect  stack
0132 2AC0 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AC2 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AC4 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AC6 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AC8 0649  14         dect  stack
0144 2ACA C64B  30         mov   r11,*stack            ; Save return address
0145 2ACC 0649  14         dect  stack
0146 2ACE C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AD0 0649  14         dect  stack
0148 2AD2 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AD4 0649  14         dect  stack
0150 2AD6 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AD8 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2ADA 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2ADC 0586  14         inc   tmp2
0161 2ADE 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2AE0 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2AE2 0286  22         ci    tmp2,255
     2AE4 00FF     
0167 2AE6 1505  14         jgt   string.getlenc.panic
0168 2AE8 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2AEA 0606  14         dec   tmp2                  ; One time adjustment
0174 2AEC C806  38         mov   tmp2,@waux1           ; Store length
     2AEE 833C     
0175 2AF0 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2AF2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AF4 FFCE     
0181 2AF6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AF8 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2AFA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2AFC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AFE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2B00 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2B02 045B  20         b     *r11                  ; Return to caller
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
0023 2B04 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2B06 F960     
0024 2B08 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2B0A F962     
0025 2B0C C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2B0E F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 2B10 0200  20         li    r0,>8306              ; Scratchpad source address
     2B12 8306     
0030 2B14 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2B16 F966     
0031 2B18 0202  20         li    r2,62                 ; Loop counter
     2B1A 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 2B1C CC70  46         mov   *r0+,*r1+
0037 2B1E CC70  46         mov   *r0+,*r1+
0038 2B20 0642  14         dect  r2
0039 2B22 16FC  14         jne   cpu.scrpad.backup.copy
0040 2B24 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2B26 83FE     
     2B28 FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 2B2A C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2B2C F960     
0046 2B2E C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2B30 F962     
0047 2B32 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2B34 F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 2B36 045B  20         b     *r11                  ; Return to caller
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
0074 2B38 0200  20         li    r0,cpu.scrpad.tgt
     2B3A F960     
0075 2B3C 0201  20         li    r1,>8300
     2B3E 8300     
0076                       ;------------------------------------------------------
0077                       ; Copy 256 bytes from @cpu.scrpad.tgt to >8300
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 2B40 CC70  46         mov   *r0+,*r1+
0081 2B42 CC70  46         mov   *r0+,*r1+
0082 2B44 0281  22         ci    r1,>8400
     2B46 8400     
0083 2B48 11FB  14         jlt   cpu.scrpad.restore.copy
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               cpu.scrpad.restore.exit:
0088 2B4A 045B  20         b     *r11                  ; Return to caller
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
0038 2B4C C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 2B4E CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 2B50 CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 2B52 CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 2B54 CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 2B56 CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 2B58 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 2B5A CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 2B5C CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 2B5E 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     2B60 8310     
0055                                                   ;        as of register r8
0056 2B62 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     2B64 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 2B66 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 2B68 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 2B6A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 2B6C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 2B6E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 2B70 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 2B72 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 2B74 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 2B76 0606  14         dec   tmp2
0069 2B78 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 2B7A C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 2B7C 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2B7E 2B84     
0075                                                   ; R14=PC
0076 2B80 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 2B82 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 2B84 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     2B86 2B38     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 2B88 045B  20         b     *r11                  ; Return to caller
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
0120 2B8A C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0121                       ;------------------------------------------------------
0122                       ; Copy scratchpad memory to destination
0123                       ;------------------------------------------------------
0124               xcpu.scrpad.pgin:
0125 2B8C 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2B8E 8300     
0126 2B90 0206  20         li    tmp2,16               ; tmp2 = 256/16
     2B92 0010     
0127                       ;------------------------------------------------------
0128                       ; Copy memory
0129                       ;------------------------------------------------------
0130 2B94 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0131 2B96 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0132 2B98 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0133 2B9A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0134 2B9C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0135 2B9E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0136 2BA0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0137 2BA2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0138 2BA4 0606  14         dec   tmp2
0139 2BA6 16F6  14         jne   -!                    ; Loop until done
0140                       ;------------------------------------------------------
0141                       ; Switch workspace to scratchpad memory
0142                       ;------------------------------------------------------
0143 2BA8 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2BAA 8300     
0144                       ;------------------------------------------------------
0145                       ; Exit
0146                       ;------------------------------------------------------
0147               cpu.scrpad.pgin.exit:
0148 2BAC 045B  20         b     *r11                  ; Return to caller
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
0056 2BAE A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2BB0 2BB2             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2BB2 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2BB4 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2BB6 A428     
0064 2BB8 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2BBA 201C     
0065 2BBC C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2BBE 8356     
0066 2BC0 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2BC2 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2BC4 FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2BC6 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2BC8 A434     
0073                       ;---------------------------; Inline VSBR start
0074 2BCA 06C0  14         swpb  r0                    ;
0075 2BCC D800  38         movb  r0,@vdpa              ; Send low byte
     2BCE 8C02     
0076 2BD0 06C0  14         swpb  r0                    ;
0077 2BD2 D800  38         movb  r0,@vdpa              ; Send high byte
     2BD4 8C02     
0078 2BD6 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2BD8 8800     
0079                       ;---------------------------; Inline VSBR end
0080 2BDA 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2BDC 0704  14         seto  r4                    ; Init counter
0086 2BDE 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BE0 A420     
0087 2BE2 0580  14 !       inc   r0                    ; Point to next char of name
0088 2BE4 0584  14         inc   r4                    ; Increment char counter
0089 2BE6 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2BE8 0007     
0090 2BEA 1573  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2BEC 80C4  18         c     r4,r3                 ; End of name?
0093 2BEE 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2BF0 06C0  14         swpb  r0                    ;
0098 2BF2 D800  38         movb  r0,@vdpa              ; Send low byte
     2BF4 8C02     
0099 2BF6 06C0  14         swpb  r0                    ;
0100 2BF8 D800  38         movb  r0,@vdpa              ; Send high byte
     2BFA 8C02     
0101 2BFC D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2BFE 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2C00 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2C02 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2C04 2D1E     
0109 2C06 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2C08 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2C0A 1363  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2C0C 04E0  34         clr   @>83d0
     2C0E 83D0     
0118 2C10 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2C12 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2C14 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2C16 A432     
0121               
0122 2C18 0584  14         inc   r4                    ; Adjust for dot
0123 2C1A A804  38         a     r4,@>8356             ; Point to position after name
     2C1C 8356     
0124 2C1E C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2C20 8356     
     2C22 A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2C24 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C26 83E0     
0130 2C28 04C1  14         clr   r1                    ; Version found of dsr
0131 2C2A 020C  20         li    r12,>0f00             ; Init cru address
     2C2C 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2C2E C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2C30 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2C32 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2C34 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2C36 0100     
0145 2C38 04E0  34         clr   @>83d0                ; Clear in case we are done
     2C3A 83D0     
0146 2C3C 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2C3E 2000     
0147 2C40 1346  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2C42 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2C44 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2C46 1D00  20         sbo   0                     ; Turn on ROM
0154 2C48 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2C4A 4000     
0155 2C4C 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2C4E 2D1A     
0156 2C50 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2C52 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2C54 A40A     
0166 2C56 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2C58 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2C5A 83D2     
0172                                                   ; subprogram
0173               
0174 2C5C 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2C5E C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2C60 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2C62 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2C64 83D2     
0183                                                   ; subprogram
0184               
0185 2C66 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2C68 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2C6A 04C5  14         clr   r5                    ; Remove any old stuff
0194 2C6C D160  34         movb  @>8355,r5             ; Get length as counter
     2C6E 8355     
0195 2C70 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2C72 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2C74 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2C76 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2C78 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2C7A A420     
0206 2C7C 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2C7E 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2C80 0605  14         dec   r5                    ; Update loop counter
0211 2C82 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2C84 0581  14         inc   r1                    ; Next version found
0217 2C86 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2C88 A42A     
0218 2C8A C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C8C A42C     
0219 2C8E C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C90 A430     
0220               
0221 2C92 020D  20         li    r13,>9800             ; Set GROM base to >9800 to prevent
     2C94 9800     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C96 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C98 8C02     
0225                                                   ; lockup of TI Disk Controller DSR.
0226               
0227 2C9A 0699  24         bl    *r9                   ; Execute DSR
0228                       ;
0229                       ; Depending on IO result the DSR in card ROM does RET
0230                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0231                       ;
0232 2C9C 10DD  14         jmp   dsrlnk.dsrscan.nextentry
0233                                                   ; (1) error return
0234 2C9E 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0235 2CA0 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2CA2 A400     
0236 2CA4 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0237                       ;------------------------------------------------------
0238                       ; Returned from DSR
0239                       ;------------------------------------------------------
0240               dsrlnk.dsrscan.return_dsr:
0241 2CA6 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2CA8 A428     
0242                                                   ; (8 or >a)
0243 2CAA 0281  22         ci    r1,8                  ; was it 8?
     2CAC 0008     
0244 2CAE 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0245 2CB0 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2CB2 8350     
0246                                                   ; Get error byte from @>8350
0247 2CB4 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0248               
0249                       ;------------------------------------------------------
0250                       ; Read VDP PAB byte 1 after DSR call completed (status)
0251                       ;------------------------------------------------------
0252               dsrlnk.dsrscan.dsr.8:
0253                       ;---------------------------; Inline VSBR start
0254 2CB6 06C0  14         swpb  r0                    ;
0255 2CB8 D800  38         movb  r0,@vdpa              ; send low byte
     2CBA 8C02     
0256 2CBC 06C0  14         swpb  r0                    ;
0257 2CBE D800  38         movb  r0,@vdpa              ; send high byte
     2CC0 8C02     
0258 2CC2 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2CC4 8800     
0259                       ;---------------------------; Inline VSBR end
0260               
0261                       ;------------------------------------------------------
0262                       ; Return DSR error to caller
0263                       ;------------------------------------------------------
0264               dsrlnk.dsrscan.dsr.a:
0265 2CC6 09D1  56         srl   r1,13                 ; just keep error bits
0266 2CC8 1605  14         jne   dsrlnk.error.io_error
0267                                                   ; handle IO error
0268 2CCA 0380  18         rtwp                        ; Return from DSR workspace to caller
0269                                                   ; workspace
0270               
0271                       ;------------------------------------------------------
0272                       ; IO-error handler
0273                       ;------------------------------------------------------
0274               dsrlnk.error.nodsr_found_off:
0275 2CCC 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0276               dsrlnk.error.nodsr_found:
0277 2CCE 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2CD0 A400     
0278               dsrlnk.error.devicename_invalid:
0279 2CD2 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0280               dsrlnk.error.io_error:
0281 2CD4 06C1  14         swpb  r1                    ; put error in hi byte
0282 2CD6 D741  30         movb  r1,*r13               ; store error flags in callers r0
0283 2CD8 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2CDA 201C     
0284                                                   ; / to indicate error
0285 2CDC 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0312 2CDE A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0313 2CE0 2CE2             data  dsrlnk.reuse.init     ; entry point
0314                       ;------------------------------------------------------
0315                       ; DSRLNK entry point
0316                       ;------------------------------------------------------
0317               dsrlnk.reuse.init:
0318 2CE2 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2CE4 83E0     
0319               
0320 2CE6 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2CE8 201C     
0321                       ;------------------------------------------------------
0322                       ; Restore dsrlnk variables of previous DSR call
0323                       ;------------------------------------------------------
0324 2CEA 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2CEC A42A     
0325 2CEE C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0326 2CF0 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0327 2CF2 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2CF4 8356     
0328                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0329 2CF6 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0330 2CF8 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2CFA 8354     
0331                       ;------------------------------------------------------
0332                       ; Call DSR program in card/device
0333                       ;------------------------------------------------------
0334 2CFC 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2CFE 8C02     
0335                                                   ; lockup of TI Disk Controller DSR.
0336               
0337 2D00 1D00  20         sbo   >00                   ; Open card/device ROM
0338               
0339 2D02 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2D04 4000     
     2D06 2D1A     
0340 2D08 16E2  14         jne   dsrlnk.error.nodsr_found
0341                                                   ; No, error code 0 = Bad Device name
0342                                                   ; The above jump may happen only in case of
0343                                                   ; either card hardware malfunction or if
0344                                                   ; there are 2 cards opened at the same time.
0345               
0346 2D0A 0699  24         bl    *r9                   ; Execute DSR
0347                       ;
0348                       ; Depending on IO result the DSR in card ROM does RET
0349                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0350                       ;
0351 2D0C 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0352                                                   ; (1) error return
0353 2D0E 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0354                       ;------------------------------------------------------
0355                       ; Now check if any DSR error occured
0356                       ;------------------------------------------------------
0357 2D10 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2D12 A400     
0358 2D14 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2D16 A434     
0359               
0360 2D18 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0361                                                   ; Rest is the same as with normal DSRLNK
0362               
0363               
0364               ********************************************************************************
0365               
0366 2D1A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0367 2D1C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0368                                                   ; a @blwp @dsrlnk
0369 2D1E 2E       dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2D20 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2D22 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2D24 0649  14         dect  stack
0052 2D26 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2D28 0204  20         li    tmp0,dsrlnk.savcru
     2D2A A42A     
0057 2D2C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2D2E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2D30 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2D32 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2D34 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2D36 37D7     
0065 2D38 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2D3A 8370     
0066                                                   ; / location
0067 2D3C C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2D3E A44C     
0068 2D40 04C5  14         clr   tmp1                  ; io.op.open
0069 2D42 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2D44 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2D46 0649  14         dect  stack
0097 2D48 C64B  30         mov   r11,*stack            ; Save return address
0098 2D4A 0205  20         li    tmp1,io.op.close      ; io.op.close
     2D4C 0001     
0099 2D4E 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2D50 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2D52 0649  14         dect  stack
0125 2D54 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2D56 0205  20         li    tmp1,io.op.read       ; io.op.read
     2D58 0002     
0128 2D5A 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2D5C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2D5E 0649  14         dect  stack
0155 2D60 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2D62 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2D64 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2D66 0005     
0159               
0160 2D68 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2D6A A43E     
0161               
0162 2D6C 06A0  32         bl    @xvputb               ; Write character count to PAB
     2D6E 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2D70 0205  20         li    tmp1,io.op.write      ; io.op.write
     2D72 0003     
0167 2D74 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2D76 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2D78 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2D7A 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2D7C 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2D7E 1000  14         nop
0189               
0190               
0191               file.status:
0192 2D80 1000  14         nop
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
0227 2D82 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2D84 A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2D86 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2D88 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2D8A A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2D8C 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2D8E 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D90 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D92 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D94 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D96 A44C     
0246               
0247 2D98 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D9A 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D9C 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D9E 0009     
0254 2DA0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2DA2 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2DA4 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2DA6 8322     
     2DA8 833C     
0259               
0260 2DAA C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2DAC A42A     
0261 2DAE 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2DB0 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2DB2 2BAE     
0268 2DB4 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2DB6 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2DB8 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2DBA 2CDE     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2DBC 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2DBE C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2DC0 833C     
     2DC2 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2DC4 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2DC6 A436     
0292 2DC8 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2DCA 0005     
0293 2DCC 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2DCE 22F8     
0294 2DD0 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2DD2 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2DD4 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2DD6 045B  20         b     *r11                  ; Return to caller
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
0020 2DD8 0300  24 tmgr    limi  0                     ; No interrupt processing
     2DDA 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2DDC D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2DDE 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2DE0 2360  38         coc   @wbit2,r13            ; C flag on ?
     2DE2 201C     
0029 2DE4 1602  14         jne   tmgr1a                ; No, so move on
0030 2DE6 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2DE8 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2DEA 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2DEC 2020     
0035 2DEE 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2DF0 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2DF2 2010     
0048 2DF4 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2DF6 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2DF8 200E     
0050 2DFA 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2DFC 0460  28         b     @kthread              ; Run kernel thread
     2DFE 2E76     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2E00 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2E02 2014     
0056 2E04 13EB  14         jeq   tmgr1
0057 2E06 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2E08 2012     
0058 2E0A 16E8  14         jne   tmgr1
0059 2E0C C120  34         mov   @wtiusr,tmp0
     2E0E 832E     
0060 2E10 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2E12 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2E14 2E74     
0065 2E16 C10A  18         mov   r10,tmp0
0066 2E18 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2E1A 00FF     
0067 2E1C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2E1E 201C     
0068 2E20 1303  14         jeq   tmgr5
0069 2E22 0284  22         ci    tmp0,60               ; 1 second reached ?
     2E24 003C     
0070 2E26 1002  14         jmp   tmgr6
0071 2E28 0284  22 tmgr5   ci    tmp0,50
     2E2A 0032     
0072 2E2C 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2E2E 1001  14         jmp   tmgr8
0074 2E30 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2E32 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2E34 832C     
0079 2E36 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2E38 FF00     
0080 2E3A C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2E3C 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2E3E 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2E40 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2E42 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2E44 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2E46 830C     
     2E48 830D     
0089 2E4A 1608  14         jne   tmgr10                ; No, get next slot
0090 2E4C 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2E4E FF00     
0091 2E50 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2E52 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2E54 8330     
0096 2E56 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2E58 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2E5A 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2E5C 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2E5E 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2E60 8315     
     2E62 8314     
0103 2E64 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2E66 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2E68 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2E6A 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2E6C 10F7  14         jmp   tmgr10                ; Process next slot
0108 2E6E 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2E70 FF00     
0109 2E72 10B4  14         jmp   tmgr1
0110 2E74 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2E76 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2E78 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 2E7A 20A0  38         coc   @wbit13,config        ; Sound player on ?
     2E7C 2006     
0023 2E7E 1602  14         jne   kthread_kb
0024 2E80 06A0  32         bl    @sdpla1               ; Run sound player
     2E82 284A     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0042 2E84 06A0  32         bl    @rkscan               ; Scan full keyboard with ROM#0 KSCAN
     2E86 28CA     
0047               *--------------------------------------------------------------
0048               kthread_exit
0049 2E88 0460  28         b     @tmgr3                ; Exit
     2E8A 2E00     
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
0017 2E8C C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2E8E 832E     
0018 2E90 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2E92 2012     
0019 2E94 045B  20 mkhoo1  b     *r11                  ; Return
0020      2DDC     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2E96 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2E98 832E     
0029 2E9A 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E9C FEFF     
0030 2E9E 045B  20         b     *r11                  ; Return
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
0017 2EA0 C13B  30 mkslot  mov   *r11+,tmp0
0018 2EA2 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2EA4 C184  18         mov   tmp0,tmp2
0023 2EA6 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2EA8 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2EAA 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2EAC CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2EAE 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2EB0 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2EB2 881B  46         c     *r11,@w$ffff          ; End of list ?
     2EB4 2022     
0035 2EB6 1301  14         jeq   mkslo1                ; Yes, exit
0036 2EB8 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2EBA 05CB  14 mkslo1  inct  r11
0041 2EBC 045B  20         b     *r11                  ; Exit
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
0052 2EBE C13B  30 clslot  mov   *r11+,tmp0
0053 2EC0 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2EC2 A120  34         a     @wtitab,tmp0          ; Add table base
     2EC4 832C     
0055 2EC6 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2EC8 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2ECA 045B  20         b     *r11                  ; Exit
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
0068 2ECC C13B  30 rsslot  mov   *r11+,tmp0
0069 2ECE 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2ED0 A120  34         a     @wtitab,tmp0          ; Add table base
     2ED2 832C     
0071 2ED4 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2ED6 C154  26         mov   *tmp0,tmp1
0073 2ED8 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2EDA FF00     
0074 2EDC C505  30         mov   tmp1,*tmp0
0075 2EDE 045B  20         b     *r11                  ; Exit
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
0271 2EE0 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2EE2 8302     
0273               *--------------------------------------------------------------
0274               * Alternative entry point
0275               *--------------------------------------------------------------
0276 2EE4 0300  24 runli1  limi  0                     ; Turn off interrupts
     2EE6 0000     
0277 2EE8 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2EEA 8300     
0278 2EEC C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2EEE 83C0     
0279               *--------------------------------------------------------------
0280               * Clear scratch-pad memory from R4 upwards
0281               *--------------------------------------------------------------
0282 2EF0 0202  20 runli2  li    r2,>8308
     2EF2 8308     
0283 2EF4 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0284 2EF6 0282  22         ci    r2,>8400
     2EF8 8400     
0285 2EFA 16FC  14         jne   runli3
0286               *--------------------------------------------------------------
0287               * Exit to TI-99/4A title screen ?
0288               *--------------------------------------------------------------
0289 2EFC 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2EFE FFFF     
0290 2F00 1602  14         jne   runli4                ; No, continue
0291 2F02 0420  54         blwp  @0                    ; Yes, bye bye
     2F04 0000     
0292               *--------------------------------------------------------------
0293               * Determine if VDP is PAL or NTSC
0294               *--------------------------------------------------------------
0295 2F06 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2F08 833C     
0296 2F0A 04C1  14         clr   r1                    ; Reset counter
0297 2F0C 0202  20         li    r2,10                 ; We test 10 times
     2F0E 000A     
0298 2F10 C0E0  34 runli5  mov   @vdps,r3
     2F12 8802     
0299 2F14 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2F16 2020     
0300 2F18 1302  14         jeq   runli6
0301 2F1A 0581  14         inc   r1                    ; Increase counter
0302 2F1C 10F9  14         jmp   runli5
0303 2F1E 0602  14 runli6  dec   r2                    ; Next test
0304 2F20 16F7  14         jne   runli5
0305 2F22 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2F24 1250     
0306 2F26 1202  14         jle   runli7                ; No, so it must be NTSC
0307 2F28 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2F2A 201C     
0308               *--------------------------------------------------------------
0309               * Copy machine code to scratchpad (prepare tight loop)
0310               *--------------------------------------------------------------
0311 2F2C 06A0  32 runli7  bl    @loadmc
     2F2E 222E     
0312               *--------------------------------------------------------------
0313               * Initialize registers, memory, ...
0314               *--------------------------------------------------------------
0315 2F30 04C1  14 runli9  clr   r1
0316 2F32 04C2  14         clr   r2
0317 2F34 04C3  14         clr   r3
0318 2F36 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2F38 A900     
0319 2F3A 020F  20         li    r15,vdpw              ; Set VDP write address
     2F3C 8C00     
0321 2F3E 06A0  32         bl    @mute                 ; Mute sound generators
     2F40 280E     
0323               *--------------------------------------------------------------
0324               * Setup video memory
0325               *--------------------------------------------------------------
0327 2F42 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2F44 4A4A     
0328 2F46 1605  14         jne   runlia
0329 2F48 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2F4A 22A2     
0330 2F4C 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2F4E 0000     
     2F50 3000     
0335 2F52 06A0  32 runlia  bl    @filv
     2F54 22A2     
0336 2F56 0FC0             data  pctadr,spfclr,16      ; Load color table
     2F58 00F4     
     2F5A 0010     
0337               *--------------------------------------------------------------
0338               * Check if there is a F18A present
0339               *--------------------------------------------------------------
0341               *       <<skipped>>
0352               *--------------------------------------------------------------
0353               * Check if there is a speech synthesizer attached
0354               *--------------------------------------------------------------
0356               *       <<skipped>>
0360               *--------------------------------------------------------------
0361               * Load video mode table & font
0362               *--------------------------------------------------------------
0363 2F5C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2F5E 230C     
0364 2F60 35CC             data  spvmod                ; Equate selected video mode table
0365 2F62 0204  20         li    tmp0,spfont           ; Get font option
     2F64 000C     
0366 2F66 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0367 2F68 1304  14         jeq   runlid                ; Yes, skip it
0368 2F6A 06A0  32         bl    @ldfnt
     2F6C 2374     
0369 2F6E 1100             data  fntadr,spfont         ; Load specified font
     2F70 000C     
0370               *--------------------------------------------------------------
0371               * Did a system crash occur before runlib was called?
0372               *--------------------------------------------------------------
0373 2F72 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2F74 4A4A     
0374 2F76 1602  14         jne   runlie                ; No, continue
0375 2F78 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2F7A 2086     
0376               *--------------------------------------------------------------
0377               * Branch to main program
0378               *--------------------------------------------------------------
0379 2F7C 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2F7E 0040     
0380 2F80 0460  28         b     @main                 ; Give control to main program
     2F82 6046     
                   < stevie_b3.asm.68345
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
0021 2F84 C13B  30         mov   *r11+,tmp0            ; P0
0022 2F86 C17B  30         mov   *r11+,tmp1            ; P1
0023 2F88 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 2F8A 0649  14         dect  stack
0029 2F8C C644  30         mov   tmp0,*stack           ; Push tmp0
0030 2F8E 0649  14         dect  stack
0031 2F90 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 2F92 0649  14         dect  stack
0033 2F94 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 2F96 0649  14         dect  stack
0035 2F98 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 2F9A 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     2F9C 6000     
0040 2F9E 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 2FA0 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     2FA2 A226     
0044 2FA4 0647  14         dect  tmp3
0045 2FA6 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 2FA8 0647  14         dect  tmp3
0047 2FAA C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 2FAC C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     2FAE A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 2FB0 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 2FB2 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 2FB4 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 2FB6 0224  22         ai    tmp0,>0800
     2FB8 0800     
0066 2FBA 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 2FBC 0285  22         ci    tmp1,>ffff
     2FBE FFFF     
0075 2FC0 1602  14         jne   !
0076 2FC2 C160  34         mov   @trmpvector,tmp1
     2FC4 A040     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 2FC6 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 2FC8 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 2FCA 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 2FCC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2FCE FFCE     
0091 2FD0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2FD2 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 2FD4 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 2FD6 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     2FD8 A226     
0102 2FDA C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 2FDC 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 2FDE 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 2FE0 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 2FE2 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 2FE4 028B  22         ci    r11,>6000
     2FE6 6000     
0115 2FE8 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 2FEA 028B  22         ci    r11,>7fff
     2FEC 7FFF     
0117 2FEE 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 2FF0 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     2FF2 A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 2FF4 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 2FF6 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 2FF8 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 2FFA 0225  22         ai    tmp1,>0800
     2FFC 0800     
0137 2FFE 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 3000 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 3002 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3004 FFCE     
0144 3006 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3008 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 300A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 300C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 300E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 3010 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 3012 045B  20         b     *r11                  ; Return to caller
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
0020 3014 0649  14         dect  stack
0021 3016 C64B  30         mov   r11,*stack            ; Save return address
0022 3018 0649  14         dect  stack
0023 301A C644  30         mov   tmp0,*stack           ; Push tmp0
0024 301C 0649  14         dect  stack
0025 301E C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3020 0204  20         li    tmp0,fb.top
     3022 D000     
0030 3024 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3026 A300     
0031 3028 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     302A A304     
0032 302C 04E0  34         clr   @fb.row               ; Current row=0
     302E A306     
0033 3030 04E0  34         clr   @fb.column            ; Current column=0
     3032 A30C     
0034               
0035 3034 0204  20         li    tmp0,colrow
     3036 0050     
0036 3038 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     303A A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 303C C160  34         mov   @tv.ruler.visible,tmp1
     303E A210     
0041 3040 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 3042 0204  20         li    tmp0,pane.botrow-2
     3044 0015     
0043 3046 1002  14         jmp   fb.init.cont
0044 3048 0204  20 !       li    tmp0,pane.botrow-1
     304A 0016     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 304C C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     304E A31A     
0050 3050 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3052 A31C     
0051               
0052 3054 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     3056 A222     
0053 3058 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     305A A310     
0054 305C 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     305E A316     
0055 3060 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     3062 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 3064 06A0  32         bl    @film
     3066 224A     
0060 3068 D000             data  fb.top,>00,fb.size    ; Clear it all the way
     306A 0000     
     306C 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 306E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 3070 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 3072 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 3074 045B  20         b     *r11                  ; Return to caller
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
0051 3076 0649  14         dect  stack
0052 3078 C64B  30         mov   r11,*stack            ; Save return address
0053 307A 0649  14         dect  stack
0054 307C C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 307E 0204  20         li    tmp0,idx.top
     3080 B000     
0059 3082 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     3084 A502     
0060               
0061 3086 C120  34         mov   @tv.sams.b000,tmp0
     3088 A206     
0062 308A C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     308C A600     
0063 308E C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     3090 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 3092 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     3094 0004     
0068 3096 C804  38         mov   tmp0,@idx.sams.hipage ; /
     3098 A604     
0069               
0070 309A 06A0  32         bl    @_idx.sams.mapcolumn.on
     309C 30B8     
0071                                                   ; Index in continuous memory region
0072               
0073 309E 06A0  32         bl    @film
     30A0 224A     
0074 30A2 B000                   data idx.top,>00,idx.size * 5
     30A4 0000     
     30A6 5000     
0075                                                   ; Clear index
0076               
0077 30A8 06A0  32         bl    @_idx.sams.mapcolumn.off
     30AA 30EC     
0078                                                   ; Restore memory window layout
0079               
0080 30AC C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     30AE A602     
     30B0 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 30B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 30B4 C2F9  30         mov   *stack+,r11           ; Pop r11
0088 30B6 045B  20         b     *r11                  ; Return to caller
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
0101 30B8 0649  14         dect  stack
0102 30BA C64B  30         mov   r11,*stack            ; Push return address
0103 30BC 0649  14         dect  stack
0104 30BE C644  30         mov   tmp0,*stack           ; Push tmp0
0105 30C0 0649  14         dect  stack
0106 30C2 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 30C4 0649  14         dect  stack
0108 30C6 C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 30C8 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     30CA A602     
0113 30CC 0205  20         li    tmp1,idx.top
     30CE B000     
0114 30D0 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     30D2 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 30D4 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     30D6 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 30D8 0584  14         inc   tmp0                  ; Next SAMS index page
0123 30DA 0225  22         ai    tmp1,>1000            ; Next memory region
     30DC 1000     
0124 30DE 0606  14         dec   tmp2                  ; Update loop counter
0125 30E0 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 30E2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 30E4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 30E6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 30E8 C2F9  30         mov   *stack+,r11           ; Pop return address
0134 30EA 045B  20         b     *r11                  ; Return to caller
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
0150 30EC 0649  14         dect  stack
0151 30EE C64B  30         mov   r11,*stack            ; Push return address
0152 30F0 0649  14         dect  stack
0153 30F2 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 30F4 0649  14         dect  stack
0155 30F6 C645  30         mov   tmp1,*stack           ; Push tmp1
0156 30F8 0649  14         dect  stack
0157 30FA C646  30         mov   tmp2,*stack           ; Push tmp2
0158 30FC 0649  14         dect  stack
0159 30FE C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 3100 0205  20         li    tmp1,idx.top
     3102 B000     
0164 3104 0206  20         li    tmp2,5                ; Always 5 pages
     3106 0005     
0165 3108 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     310A A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 310C C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 310E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3110 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 3112 0225  22         ai    tmp1,>1000            ; Next memory region
     3114 1000     
0176 3116 0606  14         dec   tmp2                  ; Update loop counter
0177 3118 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 311A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 311C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 311E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 3120 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 3122 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 3124 045B  20         b     *r11                  ; Return to caller
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
0211 3126 0649  14         dect  stack
0212 3128 C64B  30         mov   r11,*stack            ; Save return address
0213 312A 0649  14         dect  stack
0214 312C C644  30         mov   tmp0,*stack           ; Push tmp0
0215 312E 0649  14         dect  stack
0216 3130 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 3132 0649  14         dect  stack
0218 3134 C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 3136 C184  18         mov   tmp0,tmp2             ; Line number
0223 3138 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 313A 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     313C 0800     
0225               
0226 313E 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 3140 0A16  56         sla   tmp2,1                ; line number * 2
0231 3142 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     3144 A016     
0232               
0233 3146 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     3148 A602     
0234 314A 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     314C A600     
0235               
0236 314E 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 3150 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     3152 A600     
0242 3154 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     3156 A206     
0243 3158 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 315A 0205  20         li    tmp1,>b000            ; Memory window for index page
     315C B000     
0246               
0247 315E 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     3160 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 3162 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     3164 A604     
0254 3166 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 3168 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     316A A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 316C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 316E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 3170 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 3172 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 3174 045B  20         b     *r11                  ; Return to caller
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
0022 3176 0649  14         dect  stack
0023 3178 C64B  30         mov   r11,*stack            ; Save return address
0024 317A 0649  14         dect  stack
0025 317C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 317E 0204  20         li    tmp0,edb.top          ; \
     3180 C000     
0030 3182 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     3184 A500     
0031 3186 C804  38         mov   tmp0,@edb.next_free.ptr
     3188 A508     
0032                                                   ; Set pointer to next free line
0033               
0034 318A 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     318C A50A     
0035               
0036 318E 0204  20         li    tmp0,1
     3190 0001     
0037 3192 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     3194 A504     
0038               
0039 3196 0720  34         seto  @edb.block.m1         ; Reset block start line
     3198 A50C     
0040 319A 0720  34         seto  @edb.block.m2         ; Reset block end line
     319C A50E     
0041               
0042 319E 0204  20         li    tmp0,txt.newfile      ; "New file"
     31A0 37D6     
0043 31A2 C804  38         mov   tmp0,@edb.filename.ptr
     31A4 A512     
0044               
0045 31A6 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     31A8 A440     
0046 31AA 04E0  34         clr   @fh.kilobytes.prev    ; /
     31AC A45C     
0047               
0048 31AE 0204  20         li    tmp0,txt.filetype.none
     31B0 3892     
0049 31B2 C804  38         mov   tmp0,@edb.filetype.ptr
     31B4 A514     
0050               
0051               edb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 31B6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 31B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 31BA 045B  20         b     *r11                  ; Return to caller
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
0022 31BC 0649  14         dect  stack
0023 31BE C64B  30         mov   r11,*stack            ; Save return address
0024 31C0 0649  14         dect  stack
0025 31C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31C4 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     31C6 E000     
0030 31C8 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     31CA A700     
0031               
0032 31CC 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     31CE A702     
0033 31D0 0204  20         li    tmp0,4
     31D2 0004     
0034 31D4 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     31D6 A706     
0035 31D8 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     31DA A708     
0036               
0037 31DC 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     31DE A716     
0038 31E0 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     31E2 A718     
0039 31E4 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     31E6 A728     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 31E8 06A0  32         bl    @film
     31EA 224A     
0044 31EC E000             data  cmdb.top,>00,cmdb.size
     31EE 0000     
     31F0 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 31F2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 31F4 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 31F6 045B  20         b     *r11                  ; Return to caller
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
0022 31F8 0649  14         dect  stack
0023 31FA C64B  30         mov   r11,*stack            ; Save return address
0024 31FC 0649  14         dect  stack
0025 31FE C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3200 0649  14         dect  stack
0027 3202 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3204 0649  14         dect  stack
0029 3206 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 3208 04E0  34         clr   @tv.error.visible     ; Set to hidden
     320A A228     
0034 320C 0204  20         li    tmp0,3
     320E 0003     
0035 3210 C804  38         mov   tmp0,@tv.error.rows   ; Number of rows in error pane
     3212 A22A     
0036               
0037 3214 06A0  32         bl    @film
     3216 224A     
0038 3218 A22E                   data tv.error.msg,0,160
     321A 0000     
     321C 00A0     
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               errpane.exit:
0043 321E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 3220 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 3222 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 3224 C2F9  30         mov   *stack+,r11           ; Pop R11
0047 3226 045B  20         b     *r11                  ; Return to caller
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
0022 3228 0649  14         dect  stack
0023 322A C64B  30         mov   r11,*stack            ; Save return address
0024 322C 0649  14         dect  stack
0025 322E C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3230 0649  14         dect  stack
0027 3232 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3234 0649  14         dect  stack
0029 3236 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 3238 0204  20         li    tmp0,1                ; \ Set default color scheme
     323A 0001     
0034 323C C804  38         mov   tmp0,@tv.colorscheme  ; /
     323E A212     
0035               
0036 3240 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3242 A224     
0037 3244 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     3246 200C     
0038               
0039 3248 0204  20         li    tmp0,fj.bottom
     324A B000     
0040 324C C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     324E A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 3250 06A0  32         bl    @cpym2m
     3252 24EE     
0045 3254 396A                   data def.printer.fname,tv.printer.fname,7
     3256 D960     
     3258 0007     
0046               
0047 325A 06A0  32         bl    @cpym2m
     325C 24EE     
0048 325E 3972                   data def.clip.fname,tv.clip.fname,10
     3260 D9B0     
     3262 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 3264 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 3266 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 3268 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 326A C2F9  30         mov   *stack+,r11           ; Pop R11
0057 326C 045B  20         b     *r11                  ; Return to caller
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
0023 326E 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     3270 27BA     
0024                       ;-------------------------------------------------------
0025                       ; Load legacy SAMS page layout and exit to monitor
0026                       ;-------------------------------------------------------
0027 3272 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     3274 2F84     
0028 3276 600E                   data bank7.rom        ; | i  p0 = bank address
0029 3278 7FC0                   data bankx.vectab     ; | i  p1 = Vector with target address
0030 327A 6006                   data bankid           ; / i  p2 = Source ROM bank for return
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
0021               ********|*****|*********************|**************************
0022               tv.reset:
0023 327C 0649  14         dect  stack
0024 327E C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Reset editor
0027                       ;------------------------------------------------------
0028 3280 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3282 31BC     
0029 3284 06A0  32         bl    @edb.init             ; Initialize editor buffer
     3286 3176     
0030 3288 06A0  32         bl    @idx.init             ; Initialize index
     328A 3076     
0031 328C 06A0  32         bl    @fb.init              ; Initialize framebuffer
     328E 3014     
0032 3290 06A0  32         bl    @errpane.init         ; Initialize error pane
     3292 31F8     
0033                       ;------------------------------------------------------
0034                       ; Remove markers and shortcuts
0035                       ;------------------------------------------------------
0036 3294 06A0  32         bl    @hchar
     3296 27E6     
0037 3298 0034                   byte 0,52,32,18       ; Remove markers
     329A 2012     
0038 329C 1700                   byte pane.botrow,0,32,51
     329E 2033     
0039 32A0 FFFF                   data eol              ; Remove block shortcuts
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               tv.reset.exit:
0044 32A2 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 32A4 045B  20         b     *r11                  ; Return to caller
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
0020 32A6 0649  14         dect  stack
0021 32A8 C64B  30         mov   r11,*stack            ; Save return address
0022 32AA 0649  14         dect  stack
0023 32AC C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32AE 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32B0 29BA     
0028 32B2 A006                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32B4 A100                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32B6 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 32B7   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32B8 0204  20         li    tmp0,unpacked.string
     32BA A02C     
0034 32BC 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32BE 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32C0 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32C2 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32C4 2A12     
0039 32C6 A100                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32C8 A02C                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32CA 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 32CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 32CE C2F9  30         mov   *stack+,r11           ; Pop r11
0048 32D0 045B  20         b     *r11                  ; Return to caller
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
0024 32D2 0649  14         dect  stack
0025 32D4 C64B  30         mov   r11,*stack            ; Push return address
0026 32D6 0649  14         dect  stack
0027 32D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0028 32DA 0649  14         dect  stack
0029 32DC C645  30         mov   tmp1,*stack           ; Push tmp1
0030 32DE 0649  14         dect  stack
0031 32E0 C646  30         mov   tmp2,*stack           ; Push tmp2
0032 32E2 0649  14         dect  stack
0033 32E4 C647  30         mov   tmp3,*stack           ; Push tmp3
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 32E6 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     32E8 A006     
0038 32EA D194  26         movb  *tmp0,tmp2            ; /
0039 32EC 0986  56         srl   tmp2,8                ; Right align
0040 32EE C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0041               
0042 32F0 8806  38         c     tmp2,@parm2           ; String length > requested length?
     32F2 A008     
0043 32F4 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0044                       ;------------------------------------------------------
0045                       ; Copy string to buffer
0046                       ;------------------------------------------------------
0047 32F6 C120  34         mov   @parm1,tmp0           ; Get source address
     32F8 A006     
0048 32FA C160  34         mov   @parm4,tmp1           ; Get destination address
     32FC A00C     
0049 32FE 0586  14         inc   tmp2                  ; Also include length-byte in copy
0050               
0051 3300 0649  14         dect  stack
0052 3302 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0053               
0054 3304 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     3306 24F4     
0055                                                   ; \ i  tmp0 = Source CPU memory address
0056                                                   ; | i  tmp1 = Target CPU memory address
0057                                                   ; / i  tmp2 = Number of bytes to copy
0058               
0059 3308 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0060                       ;------------------------------------------------------
0061                       ; Set length of new string
0062                       ;------------------------------------------------------
0063 330A C120  34         mov   @parm2,tmp0           ; Get requested length
     330C A008     
0064 330E 0A84  56         sla   tmp0,8                ; Left align
0065 3310 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3312 A00C     
0066 3314 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0067 3316 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0068 3318 0585  14         inc   tmp1                  ; /
0069                       ;------------------------------------------------------
0070                       ; Prepare for padding string
0071                       ;------------------------------------------------------
0072 331A C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     331C A008     
0073 331E 6187  18         s     tmp3,tmp2             ; |
0074 3320 0586  14         inc   tmp2                  ; /
0075               
0076 3322 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3324 A00A     
0077 3326 0A84  56         sla   tmp0,8                ; Left align
0078                       ;------------------------------------------------------
0079                       ; Right-pad string to destination length
0080                       ;------------------------------------------------------
0081               tv.pad.string.loop:
0082 3328 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0083 332A 0606  14         dec   tmp2                  ; Update loop counter
0084 332C 15FD  14         jgt   tv.pad.string.loop    ; Next character
0085               
0086 332E C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3330 A00C     
     3332 A016     
0087 3334 1004  14         jmp   tv.pad.string.exit    ; Exit
0088                       ;-----------------------------------------------------------------------
0089                       ; CPU crash
0090                       ;-----------------------------------------------------------------------
0091               tv.pad.string.panic:
0092 3336 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3338 FFCE     
0093 333A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     333C 2026     
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               tv.pad.string.exit:
0098 333E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0099 3340 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 3342 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 3344 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 3346 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 3348 045B  20         b     *r11                  ; Return to caller
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
0022 334A 0649  14         dect  stack
0023 334C C64B  30         mov   r11,*stack            ; Save return address
0024 334E 0649  14         dect  stack
0025 3350 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3352 0649  14         dect  stack
0027 3354 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 3356 C120  34         mov   @parm1,tmp0           ; Get line number
     3358 A006     
0032 335A C160  34         mov   @parm2,tmp1           ; Get pointer
     335C A008     
0033 335E 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 3360 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     3362 0FFF     
0039 3364 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 3366 06E0  34         swpb  @parm3
     3368 A00A     
0044 336A D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     336C A00A     
0045 336E 06E0  34         swpb  @parm3                ; \ Restore original order again,
     3370 A00A     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 3372 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3374 3126     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 3376 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     3378 A016     
0056 337A C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     337C B000     
0057 337E C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     3380 A016     
0058 3382 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 3384 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3386 3126     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 3388 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     338A A016     
0068 338C 04E4  34         clr   @idx.top(tmp0)        ; /
     338E B000     
0069 3390 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     3392 A016     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 3394 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 3396 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 3398 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 339A 045B  20         b     *r11                  ; Return to caller
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
0021 339C 0649  14         dect  stack
0022 339E C64B  30         mov   r11,*stack            ; Save return address
0023 33A0 0649  14         dect  stack
0024 33A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 33A4 0649  14         dect  stack
0026 33A6 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 33A8 0649  14         dect  stack
0028 33AA C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 33AC C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     33AE A006     
0033               
0034 33B0 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     33B2 3126     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 33B4 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     33B6 A016     
0039 33B8 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     33BA B000     
0040               
0041 33BC 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 33BE C185  18         mov   tmp1,tmp2             ; \
0047 33C0 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 33C2 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     33C4 00FF     
0052 33C6 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 33C8 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     33CA C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 33CC C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     33CE A016     
0059 33D0 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     33D2 A018     
0060 33D4 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 33D6 04E0  34         clr   @outparm1
     33D8 A016     
0066 33DA 04E0  34         clr   @outparm2
     33DC A018     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 33DE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 33E0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 33E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 33E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 33E6 045B  20         b     *r11                  ; Return to caller
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
0017 33E8 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     33EA B000     
0018 33EC C144  18         mov   tmp0,tmp1             ; a = current slot
0019 33EE 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 33F0 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 33F2 0606  14         dec   tmp2                  ; tmp2--
0026 33F4 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 33F6 045B  20         b     *r11                  ; Return to caller
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
0046 33F8 0649  14         dect  stack
0047 33FA C64B  30         mov   r11,*stack            ; Save return address
0048 33FC 0649  14         dect  stack
0049 33FE C644  30         mov   tmp0,*stack           ; Push tmp0
0050 3400 0649  14         dect  stack
0051 3402 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 3404 0649  14         dect  stack
0053 3406 C646  30         mov   tmp2,*stack           ; Push tmp2
0054 3408 0649  14         dect  stack
0055 340A C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 340C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     340E A006     
0060               
0061 3410 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3412 3126     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 3414 C120  34         mov   @outparm1,tmp0        ; Index offset
     3416 A016     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 3418 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     341A A008     
0070 341C 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 341E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3420 A006     
0074 3422 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 3424 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     3426 B000     
0081 3428 04D4  26         clr   *tmp0                 ; Clear index entry
0082 342A 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 342C C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     342E A008     
0088 3430 0287  22         ci    tmp3,2048
     3432 0800     
0089 3434 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 3436 06A0  32         bl    @_idx.sams.mapcolumn.on
     3438 30B8     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 343A C120  34         mov   @parm1,tmp0           ; Restore line number
     343C A006     
0103 343E 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 3440 06A0  32         bl    @_idx.entry.delete.reorg
     3442 33E8     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 3444 06A0  32         bl    @_idx.sams.mapcolumn.off
     3446 30EC     
0111                                                   ; Restore memory window layout
0112               
0113 3448 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 344A 06A0  32         bl    @_idx.entry.delete.reorg
     344C 33E8     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 344E 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 3450 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 3452 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 3454 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 3456 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 3458 C2F9  30         mov   *stack+,r11           ; Pop r11
0132 345A 045B  20         b     *r11                  ; Return to caller
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
0017 345C 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     345E 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 3460 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 3462 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3464 FFCE     
0027 3466 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3468 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 346A 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     346C B000     
0032 346E C144  18         mov   tmp0,tmp1             ; a = current slot
0033 3470 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 3472 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 3474 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 3476 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 3478 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 347A A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 347C 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     347E AFFC     
0043 3480 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 3482 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3484 FFCE     
0049 3486 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3488 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 348A C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 348C 0644  14         dect  tmp0                  ; Move pointer up
0056 348E 0645  14         dect  tmp1                  ; Move pointer up
0057 3490 0606  14         dec   tmp2                  ; Next index entry
0058 3492 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 3494 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 3496 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 3498 045B  20         b     *r11                  ; Return to caller
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
0088 349A 0649  14         dect  stack
0089 349C C64B  30         mov   r11,*stack            ; Save return address
0090 349E 0649  14         dect  stack
0091 34A0 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 34A2 0649  14         dect  stack
0093 34A4 C645  30         mov   tmp1,*stack           ; Push tmp1
0094 34A6 0649  14         dect  stack
0095 34A8 C646  30         mov   tmp2,*stack           ; Push tmp2
0096 34AA 0649  14         dect  stack
0097 34AC C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 34AE C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     34B0 A008     
0102 34B2 61A0  34         s     @parm1,tmp2           ; Calculate loop
     34B4 A006     
0103 34B6 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 34B8 C1E0  34         mov   @parm2,tmp3
     34BA A008     
0110 34BC 0287  22         ci    tmp3,2048
     34BE 0800     
0111 34C0 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 34C2 06A0  32         bl    @_idx.sams.mapcolumn.on
     34C4 30B8     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 34C6 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     34C8 A008     
0123 34CA 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 34CC 06A0  32         bl    @_idx.entry.insert.reorg
     34CE 345C     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 34D0 06A0  32         bl    @_idx.sams.mapcolumn.off
     34D2 30EC     
0131                                                   ; Restore memory window layout
0132               
0133 34D4 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 34D6 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     34D8 A008     
0139               
0140 34DA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     34DC 3126     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 34DE C120  34         mov   @outparm1,tmp0        ; Index offset
     34E0 A016     
0145               
0146 34E2 06A0  32         bl    @_idx.entry.insert.reorg
     34E4 345C     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 34E6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 34E8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 34EA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 34EC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 34EE C2F9  30         mov   *stack+,r11           ; Pop r11
0160 34F0 045B  20         b     *r11                  ; Return to caller
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
0021 34F2 0649  14         dect  stack
0022 34F4 C64B  30         mov   r11,*stack            ; Push return address
0023 34F6 0649  14         dect  stack
0024 34F8 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 34FA 0649  14         dect  stack
0026 34FC C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 34FE 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     3500 A504     
0031 3502 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 3504 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3506 FFCE     
0037 3508 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     350A 2026     
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 350C C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     350E A006     
0043               
0044 3510 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     3512 339C     
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 3514 C120  34         mov   @outparm2,tmp0        ; SAMS page
     3516 A018     
0050 3518 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     351A A016     
0051 351C 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 351E 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     3520 A208     
0057 3522 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 3524 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     3526 258A     
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 3528 C820  54         mov   @outparm2,@tv.sams.c000
     352A A018     
     352C A208     
0066                                                   ; Set page in shadow registers
0067               
0068 352E C820  54         mov   @outparm2,@edb.sams.page
     3530 A018     
     3532 A516     
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 3534 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 3536 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 3538 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 353A 045B  20         b     *r11                  ; Return to caller
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
0021 353C 0649  14         dect  stack
0022 353E C64B  30         mov   r11,*stack            ; Push return address
0023 3540 0649  14         dect  stack
0024 3542 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 3544 0649  14         dect  stack
0026 3546 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 3548 04E0  34         clr   @outparm1             ; Reset length
     354A A016     
0031 354C 04E0  34         clr   @outparm2             ; Reset SAMS bank
     354E A018     
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 3550 C120  34         mov   @parm1,tmp0           ; \
     3552 A006     
0036 3554 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 3556 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     3558 A504     
0039 355A 1101  14         jlt   !                     ; No, continue processing
0040 355C 100F  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 355E C120  34 !       mov   @parm1,tmp0           ; Get line
     3560 A006     
0046               
0047 3562 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     3564 34F2     
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 3566 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     3568 A016     
0053 356A 1308  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 356C C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 356E C805  38         mov   tmp1,@outparm1        ; Save length
     3570 A016     
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 3572 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     3574 0050     
0064 3576 1204  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system or limit length to 80
0068                       ;------------------------------------------------------
0073 3578 0205  20         li    tmp1,80               ; Only process first 80 characters
     357A 0050     
0075                       ;------------------------------------------------------
0076                       ; Set length to 0 if null-pointer
0077                       ;------------------------------------------------------
0078               edb.line.getlength.null:
0079 357C 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     357E A016     
0080                       ;------------------------------------------------------
0081                       ; Exit
0082                       ;------------------------------------------------------
0083               edb.line.getlength.exit:
0084 3580 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0085 3582 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0086 3584 C2F9  30         mov   *stack+,r11           ; Pop r11
0087 3586 045B  20         b     *r11                  ; Return to caller
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
0107 3588 0649  14         dect  stack
0108 358A C64B  30         mov   r11,*stack            ; Save return address
0109 358C 0649  14         dect  stack
0110 358E C644  30         mov   tmp0,*stack           ; Push tmp0
0111                       ;------------------------------------------------------
0112                       ; Calculate line in editor buffer
0113                       ;------------------------------------------------------
0114 3590 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     3592 A304     
0115 3594 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     3596 A306     
0116                       ;------------------------------------------------------
0117                       ; Get length
0118                       ;------------------------------------------------------
0119 3598 C804  38         mov   tmp0,@parm1
     359A A006     
0120 359C 06A0  32         bl    @edb.line.getlength
     359E 353C     
0121 35A0 C820  54         mov   @outparm1,@fb.row.length
     35A2 A016     
     35A4 A308     
0122                                                   ; Save row length
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               edb.line.getlength2.exit:
0127 35A6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 35A8 C2F9  30         mov   *stack+,r11           ; Pop R11
0129 35AA 045B  20         b     *r11                  ; Return to caller
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
0021 35AC 0649  14         dect  stack
0022 35AE C64B  30         mov   r11,*stack            ; Push return address
0023 35B0 0649  14         dect  stack
0024 35B2 C660  46         mov   @wyx,*stack           ; Push cursor position
     35B4 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 35B6 06A0  32         bl    @hchar
     35B8 27E6     
0029 35BA 0034                   byte 0,52,32,18
     35BC 2012     
0030 35BE FFFF                   data EOL              ; Clear message
0031               
0032 35C0 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     35C2 A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 35C4 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     35C6 832A     
0038 35C8 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 35CA 045B  20         b     *r11                  ; Return to task
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
0033 35CC 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     35CE 003F     
     35D0 0243     
     35D2 05F4     
     35D4 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 35D6 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     35D8 000C     
     35DA 0006     
     35DC 0007     
     35DE 0020     
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
0067 35E0 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     35E2 000C     
     35E4 0006     
     35E6 0007     
     35E8 0020     
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
0098 35EA 0000             data  >0000,>0001           ; Cursor
     35EC 0001     
0099 35EE 0000             data  >0000,>0101           ; Current line indicator     <
     35F0 0101     
0100 35F2 0820             data  >0820,>0201           ; Current column indicator   v
     35F4 0201     
0101               nosprite:
0102 35F6 D000             data  >d000                 ; End-of-Sprites list
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
0157 35F8 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     35FA F171     
     35FC 1B1F     
     35FE 71B1     
0158 3600 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     3602 F0FF     
     3604 1F1A     
     3606 F1FF     
0159 3608 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     360A F0FF     
     360C 1F12     
     360E F1F6     
0160 3610 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     3612 1E11     
     3614 1A17     
     3616 1E11     
0161 3618 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     361A E1FF     
     361C 1F1E     
     361E E1FF     
0162 3620 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     3622 1016     
     3624 1B71     
     3626 1711     
0163 3628 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     362A 1011     
     362C F1F1     
     362E 1F11     
0164 3630 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     3632 A1FF     
     3634 1F1F     
     3636 F11F     
0165 3638 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     363A 12FF     
     363C 1B12     
     363E 12FF     
0166 3640 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     3642 E1FF     
     3644 1B1F     
     3646 F131     
0167                       even
0168               
0169               tv.tabs.table:
0170 3648 0007             byte  0,7,12,25               ; \   Default tab positions as used
     364A 0C19     
0171 364C 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     364E 3B4F     
0172 3650 FF00             byte  >ff,0,0,0               ; |
     3652 0000     
0173 3654 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     3656 0000     
0174 3658 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     365A 0000     
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
0009 365C 01               byte  1
0010 365D   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 365E 05               byte  5
0015 365F   20             text  '  BOT'
     3660 2042     
     3662 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 3664 03               byte  3
0020 3665   4F             text  'OVR'
     3666 5652     
0021                       even
0022               
0023               txt.insert
0024 3668 03               byte  3
0025 3669   49             text  'INS'
     366A 4E53     
0026                       even
0027               
0028               txt.star
0029 366C 01               byte  1
0030 366D   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 366E 0A               byte  10
0035 366F   4C             text  'Loading...'
     3670 6F61     
     3672 6469     
     3674 6E67     
     3676 2E2E     
     3678 2E       
0036                       even
0037               
0038               txt.saving
0039 367A 0A               byte  10
0040 367B   53             text  'Saving....'
     367C 6176     
     367E 696E     
     3680 672E     
     3682 2E2E     
     3684 2E       
0041                       even
0042               
0043               txt.printing
0044 3686 12               byte  18
0045 3687   50             text  'Printing file.....'
     3688 7269     
     368A 6E74     
     368C 696E     
     368E 6720     
     3690 6669     
     3692 6C65     
     3694 2E2E     
     3696 2E2E     
     3698 2E       
0046                       even
0047               
0048               txt.block.del
0049 369A 12               byte  18
0050 369B   44             text  'Deleting block....'
     369C 656C     
     369E 6574     
     36A0 696E     
     36A2 6720     
     36A4 626C     
     36A6 6F63     
     36A8 6B2E     
     36AA 2E2E     
     36AC 2E       
0051                       even
0052               
0053               txt.block.copy
0054 36AE 11               byte  17
0055 36AF   43             text  'Copying block....'
     36B0 6F70     
     36B2 7969     
     36B4 6E67     
     36B6 2062     
     36B8 6C6F     
     36BA 636B     
     36BC 2E2E     
     36BE 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 36C0 10               byte  16
0060 36C1   4D             text  'Moving block....'
     36C2 6F76     
     36C4 696E     
     36C6 6720     
     36C8 626C     
     36CA 6F63     
     36CC 6B2E     
     36CE 2E2E     
     36D0 2E       
0061                       even
0062               
0063               txt.block.save
0064 36D2 18               byte  24
0065 36D3   53             text  'Saving block to file....'
     36D4 6176     
     36D6 696E     
     36D8 6720     
     36DA 626C     
     36DC 6F63     
     36DE 6B20     
     36E0 746F     
     36E2 2066     
     36E4 696C     
     36E6 652E     
     36E8 2E2E     
     36EA 2E       
0066                       even
0067               
0068               txt.block.clip
0069 36EC 18               byte  24
0070 36ED   43             text  'Copying to clipboard....'
     36EE 6F70     
     36F0 7969     
     36F2 6E67     
     36F4 2074     
     36F6 6F20     
     36F8 636C     
     36FA 6970     
     36FC 626F     
     36FE 6172     
     3700 642E     
     3702 2E2E     
     3704 2E       
0071                       even
0072               
0073               txt.block.print
0074 3706 12               byte  18
0075 3707   50             text  'Printing block....'
     3708 7269     
     370A 6E74     
     370C 696E     
     370E 6720     
     3710 626C     
     3712 6F63     
     3714 6B2E     
     3716 2E2E     
     3718 2E       
0076                       even
0077               
0078               txt.clearmem
0079 371A 13               byte  19
0080 371B   43             text  'Clearing memory....'
     371C 6C65     
     371E 6172     
     3720 696E     
     3722 6720     
     3724 6D65     
     3726 6D6F     
     3728 7279     
     372A 2E2E     
     372C 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 372E 0E               byte  14
0085 372F   4C             text  'Load completed'
     3730 6F61     
     3732 6420     
     3734 636F     
     3736 6D70     
     3738 6C65     
     373A 7465     
     373C 64       
0086                       even
0087               
0088               txt.done.insert
0089 373E 10               byte  16
0090 373F   49             text  'Insert completed'
     3740 6E73     
     3742 6572     
     3744 7420     
     3746 636F     
     3748 6D70     
     374A 6C65     
     374C 7465     
     374E 64       
0091                       even
0092               
0093               txt.done.append
0094 3750 10               byte  16
0095 3751   41             text  'Append completed'
     3752 7070     
     3754 656E     
     3756 6420     
     3758 636F     
     375A 6D70     
     375C 6C65     
     375E 7465     
     3760 64       
0096                       even
0097               
0098               txt.done.save
0099 3762 0E               byte  14
0100 3763   53             text  'Save completed'
     3764 6176     
     3766 6520     
     3768 636F     
     376A 6D70     
     376C 6C65     
     376E 7465     
     3770 64       
0101                       even
0102               
0103               txt.done.copy
0104 3772 0E               byte  14
0105 3773   43             text  'Copy completed'
     3774 6F70     
     3776 7920     
     3778 636F     
     377A 6D70     
     377C 6C65     
     377E 7465     
     3780 64       
0106                       even
0107               
0108               txt.done.print
0109 3782 0F               byte  15
0110 3783   50             text  'Print completed'
     3784 7269     
     3786 6E74     
     3788 2063     
     378A 6F6D     
     378C 706C     
     378E 6574     
     3790 6564     
0111                       even
0112               
0113               txt.done.delete
0114 3792 10               byte  16
0115 3793   44             text  'Delete completed'
     3794 656C     
     3796 6574     
     3798 6520     
     379A 636F     
     379C 6D70     
     379E 6C65     
     37A0 7465     
     37A2 64       
0116                       even
0117               
0118               txt.done.clipboard
0119 37A4 0F               byte  15
0120 37A5   43             text  'Clipboard saved'
     37A6 6C69     
     37A8 7062     
     37AA 6F61     
     37AC 7264     
     37AE 2073     
     37B0 6176     
     37B2 6564     
0121                       even
0122               
0123               txt.done.clipdev
0124 37B4 0D               byte  13
0125 37B5   43             text  'Clipboard set'
     37B6 6C69     
     37B8 7062     
     37BA 6F61     
     37BC 7264     
     37BE 2073     
     37C0 6574     
0126                       even
0127               
0128               txt.fastmode
0129 37C2 08               byte  8
0130 37C3   46             text  'Fastmode'
     37C4 6173     
     37C6 746D     
     37C8 6F64     
     37CA 65       
0131                       even
0132               
0133               txt.kb
0134 37CC 02               byte  2
0135 37CD   6B             text  'kb'
     37CE 62       
0136                       even
0137               
0138               txt.lines
0139 37D0 05               byte  5
0140 37D1   4C             text  'Lines'
     37D2 696E     
     37D4 6573     
0141                       even
0142               
0143               txt.newfile
0144 37D6 0A               byte  10
0145 37D7   5B             text  '[New file]'
     37D8 4E65     
     37DA 7720     
     37DC 6669     
     37DE 6C65     
     37E0 5D       
0146                       even
0147               
0148               txt.filetype.dv80
0149 37E2 04               byte  4
0150 37E3   44             text  'DV80'
     37E4 5638     
     37E6 30       
0151                       even
0152               
0153               txt.m1
0154 37E8 03               byte  3
0155 37E9   4D             text  'M1='
     37EA 313D     
0156                       even
0157               
0158               txt.m2
0159 37EC 03               byte  3
0160 37ED   4D             text  'M2='
     37EE 323D     
0161                       even
0162               
0163               txt.keys.default
0164 37F0 07               byte  7
0165 37F1   46             text  'F9-Menu'
     37F2 392D     
     37F4 4D65     
     37F6 6E75     
0166                       even
0167               
0168               txt.keys.block
0169 37F8 36               byte  54
0170 37F9   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     37FA 392D     
     37FC 4261     
     37FE 636B     
     3800 2020     
     3802 5E43     
     3804 6F70     
     3806 7920     
     3808 205E     
     380A 4D6F     
     380C 7665     
     380E 2020     
     3810 5E44     
     3812 656C     
     3814 2020     
     3816 5E53     
     3818 6176     
     381A 6520     
     381C 205E     
     381E 5072     
     3820 696E     
     3822 7420     
     3824 205E     
     3826 5B31     
     3828 2D35     
     382A 5D43     
     382C 6C69     
     382E 70       
0171                       even
0172               
0173 3830 2E2E     txt.ruler          text    '.........'
     3832 2E2E     
     3834 2E2E     
     3836 2E2E     
     3838 2E       
0174 3839   12                        byte    18
0175 383A 2E2E                        text    '.........'
     383C 2E2E     
     383E 2E2E     
     3840 2E2E     
     3842 2E       
0176 3843   13                        byte    19
0177 3844 2E2E                        text    '.........'
     3846 2E2E     
     3848 2E2E     
     384A 2E2E     
     384C 2E       
0178 384D   14                        byte    20
0179 384E 2E2E                        text    '.........'
     3850 2E2E     
     3852 2E2E     
     3854 2E2E     
     3856 2E       
0180 3857   15                        byte    21
0181 3858 2E2E                        text    '.........'
     385A 2E2E     
     385C 2E2E     
     385E 2E2E     
     3860 2E       
0182 3861   16                        byte    22
0183 3862 2E2E                        text    '.........'
     3864 2E2E     
     3866 2E2E     
     3868 2E2E     
     386A 2E       
0184 386B   17                        byte    23
0185 386C 2E2E                        text    '.........'
     386E 2E2E     
     3870 2E2E     
     3872 2E2E     
     3874 2E       
0186 3875   18                        byte    24
0187 3876 2E2E                        text    '.........'
     3878 2E2E     
     387A 2E2E     
     387C 2E2E     
     387E 2E       
0188 387F   19                        byte    25
0189                                  even
0190 3880 020E     txt.alpha.down     data >020e,>0f00
     3882 0F00     
0191 3884 0110     txt.vertline       data >0110
0192 3886 011C     txt.keymarker      byte 1,28
0193               
0194               txt.ws1
0195 3888 01               byte  1
0196 3889   20             text  ' '
0197                       even
0198               
0199               txt.ws2
0200 388A 02               byte  2
0201 388B   20             text  '  '
     388C 20       
0202                       even
0203               
0204               txt.ws3
0205 388E 03               byte  3
0206 388F   20             text  '   '
     3890 2020     
0207                       even
0208               
0209               txt.ws4
0210 3892 04               byte  4
0211 3893   20             text  '    '
     3894 2020     
     3896 20       
0212                       even
0213               
0214               txt.ws5
0215 3898 05               byte  5
0216 3899   20             text  '     '
     389A 2020     
     389C 2020     
0217                       even
0218               
0219      3892     txt.filetype.none  equ txt.ws4
0220               
0221               
0222               ;--------------------------------------------------------------
0223               ; Strings for error line pane
0224               ;--------------------------------------------------------------
0225               txt.ioerr.load
0226 389E 15               byte  21
0227 389F   46             text  'Failed loading file: '
     38A0 6169     
     38A2 6C65     
     38A4 6420     
     38A6 6C6F     
     38A8 6164     
     38AA 696E     
     38AC 6720     
     38AE 6669     
     38B0 6C65     
     38B2 3A20     
0228                       even
0229               
0230               txt.ioerr.save
0231 38B4 14               byte  20
0232 38B5   46             text  'Failed saving file: '
     38B6 6169     
     38B8 6C65     
     38BA 6420     
     38BC 7361     
     38BE 7669     
     38C0 6E67     
     38C2 2066     
     38C4 696C     
     38C6 653A     
     38C8 20       
0233                       even
0234               
0235               txt.ioerr.print
0236 38CA 1B               byte  27
0237 38CB   46             text  'Failed printing to device: '
     38CC 6169     
     38CE 6C65     
     38D0 6420     
     38D2 7072     
     38D4 696E     
     38D6 7469     
     38D8 6E67     
     38DA 2074     
     38DC 6F20     
     38DE 6465     
     38E0 7669     
     38E2 6365     
     38E4 3A20     
0238                       even
0239               
0240               txt.io.nofile
0241 38E6 16               byte  22
0242 38E7   4E             text  'No filename specified.'
     38E8 6F20     
     38EA 6669     
     38EC 6C65     
     38EE 6E61     
     38F0 6D65     
     38F2 2073     
     38F4 7065     
     38F6 6369     
     38F8 6669     
     38FA 6564     
     38FC 2E       
0243                       even
0244               
0245               txt.memfull.load
0246 38FE 2D               byte  45
0247 38FF   49             text  'Index full. File too large for editor buffer.'
     3900 6E64     
     3902 6578     
     3904 2066     
     3906 756C     
     3908 6C2E     
     390A 2046     
     390C 696C     
     390E 6520     
     3910 746F     
     3912 6F20     
     3914 6C61     
     3916 7267     
     3918 6520     
     391A 666F     
     391C 7220     
     391E 6564     
     3920 6974     
     3922 6F72     
     3924 2062     
     3926 7566     
     3928 6665     
     392A 722E     
0248                       even
0249               
0250               txt.block.inside
0251 392C 2D               byte  45
0252 392D   43             text  'Copy/Move target must be outside M1-M2 range.'
     392E 6F70     
     3930 792F     
     3932 4D6F     
     3934 7665     
     3936 2074     
     3938 6172     
     393A 6765     
     393C 7420     
     393E 6D75     
     3940 7374     
     3942 2062     
     3944 6520     
     3946 6F75     
     3948 7473     
     394A 6964     
     394C 6520     
     394E 4D31     
     3950 2D4D     
     3952 3220     
     3954 7261     
     3956 6E67     
     3958 652E     
0253                       even
0254               
0255               
0256               ;--------------------------------------------------------------
0257               ; Strings for command buffer
0258               ;--------------------------------------------------------------
0259               txt.cmdb.prompt
0260 395A 01               byte  1
0261 395B   3E             text  '>'
0262                       even
0263               
0264               txt.colorscheme
0265 395C 0D               byte  13
0266 395D   43             text  'Color scheme:'
     395E 6F6C     
     3960 6F72     
     3962 2073     
     3964 6368     
     3966 656D     
     3968 653A     
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
0008 396A 06               byte  6
0009 396B   50             text  'PI.PIO'
     396C 492E     
     396E 5049     
     3970 4F       
0010                       even
0011               
0012               def.clip.fname
0013 3972 09               byte  9
0014 3973   44             text  'DSK1.CLIP'
     3974 534B     
     3976 312E     
     3978 434C     
     397A 4950     
0015                       even
0016               
0017               def.clip.fname.b
0018 397C 09               byte  9
0019 397D   44             text  'DSK2.CLIP'
     397E 534B     
     3980 322E     
     3982 434C     
     3984 4950     
0020                       even
0021               
0022               def.clip.fname.c
0023 3986 09               byte  9
0024 3987   54             text  'TIPI.CLIP'
     3988 4950     
     398A 492E     
     398C 434C     
     398E 4950     
0025                       even
0026               
0027               def.devices
0028 3990 2F               byte  47
0029 3991   2C             text  ',DSK,HDX,IDE,PI.,PIO,TIPI.,RD,SCS,SDD,WDS,RS232'
     3992 4453     
     3994 4B2C     
     3996 4844     
     3998 582C     
     399A 4944     
     399C 452C     
     399E 5049     
     39A0 2E2C     
     39A2 5049     
     39A4 4F2C     
     39A6 5449     
     39A8 5049     
     39AA 2E2C     
     39AC 5244     
     39AE 2C53     
     39B0 4353     
     39B2 2C53     
     39B4 4444     
     39B6 2C57     
     39B8 4453     
     39BA 2C52     
     39BC 5332     
     39BE 3332     
0030                       even
0031               
                   < ram.resident.asm
                   < stevie_b3.asm.68345
0038                       ;------------------------------------------------------
0039                       ; Activate bank 1 and branch to  >6036
0040                       ;------------------------------------------------------
0041 39C0 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     39C2 6002     
0042               
0046               
0047 39C4 0460  28         b     @kickstart.code2      ; Jump to entry routine
     39C6 6046     
0048               ***************************************************************
0049               * Step 3: Include main editor modules
0050               ********|*****|*********************|**************************
0051               main:
0052                       aorg  kickstart.code2       ; >6046
0053 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 2026     
0054                       ;-----------------------------------------------------------------------
0055                       ; Include files - Shared code
0056                       ;-----------------------------------------------------------------------
0057               
0058                       ;-----------------------------------------------------------------------
0059                       ; Include files - Dialogs
0060                       ;-----------------------------------------------------------------------
0061                       copy  "dialog.menu.asm"      ; Dialog "Stevie Menu"
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
     605C 7590     
0033 605E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6060 A71E     
0034               
0035 6062 0204  20         li    tmp0,txt.info.menu
     6064 759F     
0036 6066 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6068 A720     
0037               
0038 606A 0204  20         li    tmp0,pos.info.menu
     606C 75BE     
0039 606E C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     6070 A724     
0040               
0041 6072 0204  20         li    tmp0,txt.hint.menu
     6074 75C3     
0042 6076 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6078 A722     
0043               
0044 607A 0204  20         li    tmp0,txt.keys.menu
     607C 75C6     
0045 607E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6080 A726     
0046               
0047 6082 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6084 7086     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.menu.exit:
0052 6086 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6088 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 608A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0062                       copy  "dialog.help.asm"      ; Dialog "Help"
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
     6092 269A     
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
     60A2 74EA     
0021 60A4 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     60A6 A71E     
0022               
0023 60A8 0204  20         li    tmp0,txt.about.build
     60AA 7542     
0024 60AC C804  38         mov   tmp0,@cmdb.paninfo    ; Info line
     60AE A720     
0025 60B0 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     60B2 A724     
0026               
0027 60B4 0204  20         li    tmp0,txt.hint.about
     60B6 74F6     
0028 60B8 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     60BA A722     
0029               
0030 60BC 0204  20         li    tmp0,txt.keys.about
     60BE 751E     
0031 60C0 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     60C2 A726     
0032               
0033 60C4 06A0  32         bl    @scron                ; Turn screen on
     60C6 26A2     
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
0065 60DE C647  30         mov   tmp3,*stack           ; Push tmp3
0066 60E0 0649  14         dect  stack
0067 60E2 C660  46         mov   @wyx,*stack           ; Push cursor position
     60E4 832A     
0068                       ;------------------------------------------------------
0069                       ; Clear screen and set colors
0070                       ;------------------------------------------------------
0071 60E6 06A0  32         bl    @filv
     60E8 22A2     
0072 60EA 0050                   data vdp.fb.toprow.sit,32,vdp.sit.size - 480
     60EC 0020     
     60EE 05A0     
0073                                                   ; Clear screen
0074               
0075                       ;
0076                       ; Colours are also set in pane.action.colorscheme.load
0077                       ; but we also set them here to avoid flickering due to
0078                       ; timing delay before function is called.
0079                       ;
0080               
0081 60F0 0204  20         li    tmp0,vdp.fb.toprow.tat
     60F2 1850     
0082 60F4 C160  34         mov   @tv.color,tmp1        ; Get color for framebuffer
     60F6 A218     
0083 60F8 0985  56         srl   tmp1,8                ; Right justify
0084 60FA 0206  20         li    tmp2,vdp.sit.size - 480
     60FC 05A0     
0085                                                   ; Prepare for loading color attributes
0086               
0087 60FE 06A0  32         bl    @xfilv                ; \ Fill VDP memory
     6100 22A8     
0088                                                   ; | i  tmp0 = Memory start address
0089                                                   ; | i  tmp1 = Byte to fill
0090                                                   ; / i  tmp2 = Number of bytes to fill
0091               
0092 6102 06A0  32         bl    @filv
     6104 22A2     
0093 6106 2180                   data sprsat,>d0,32    ; Turn off sprites
     6108 00D0     
     610A 0020     
0094                       ;------------------------------------------------------
0095                       ; Display help page (left column)
0096                       ;------------------------------------------------------
0097 610C 06A0  32         bl    @at                   ; Set cursor position
     610E 26DA     
0098 6110 0100                   byte 1,0              ; Y=1, X=0
0099               
0100 6112 C1E0  34         mov   @cmdb.dialog.var,tmp3 ; Get Page index
     6114 A71C     
0101               
0102 6116 C167  34         mov   @dialog.help.data.pages(tmp3),tmp1
     6118 6148     
0103                                                   ; Pointer to list of strings
0104 611A C1A7  34         mov   @dialog.help.data.pages+2(tmp3),tmp2
     611C 614A     
0105                                                   ; Number of strings to display
0106               
0107 611E 06A0  32         bl    @putlst               ; Loop over string list and display
     6120 245E     
0108                                                   ; \ i  @wyx = Cursor position
0109                                                   ; | i  tmp1 = Pointer to first length-
0110                                                   ; |           prefixed string in list
0111                                                   ; / i  tmp2 = Number of strings to display
0112               
0113                       ;------------------------------------------------------
0114                       ; Display keyboard shortcuts (right column)
0115                       ;------------------------------------------------------
0116 6122 06A0  32         bl    @at                   ; Set cursor position
     6124 26DA     
0117 6126 002A                   byte 0,42             ; Y=0, X=42
0118               
0119 6128 C1E0  34         mov   @cmdb.dialog.var,tmp3 ; Get Page index
     612A A71C     
0120               
0121 612C C167  34         mov   @dialog.help.data.pages+4(tmp3),tmp1
     612E 614C     
0122                                                   ; Pointer to list of strings
0123 6130 C1A7  34         mov   @dialog.help.data.pages+6(tmp3),tmp2
     6132 614E     
0124                                                   ; Number of strings to display
0125               
0126 6134 06A0  32         bl    @putlst               ; Loop over string list and display
     6136 245E     
0127                                                   ; \ i  @wyx = Cursor position
0128                                                   ; | i  tmp1 = Pointer to first length-
0129                                                   ; |           prefixed string in list
0130                                                   ; / i  tmp2 = Number of strings to display
0131               
0132                       ;------------------------------------------------------
0133                       ; Exit
0134                       ;------------------------------------------------------
0135               dialog.help.content.exit:
0136 6138 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     613A 832A     
0137 613C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0138 613E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0139 6140 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0140 6142 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0141 6144 C2F9  30         mov   *stack+,r11           ; Pop r11
0142 6146 045B  20         b     *r11                  ; Return
0143               
0144               
0145               
0146               dialog.help.data.pages:
0147 6148 6158             data  dialog.help.data.page1.left,17
     614A 0011     
0148 614C 62D0             data  dialog.help.data.page1.right,18
     614E 0012     
0149 6150 64B4             data  dialog.help.data.page2.left,8
     6152 0008     
0150 6154 6590             data  dialog.help.data.page2.right,10
     6156 000A     
0151               
0152               
0153               dialog.help.data.page1.left:
0154               
0155 6158 01               byte  1
0156 6159   20             text  ' '
0157                       even
0158               
0159               
0160 615A 23               byte  35
0161 615B   2D             text  '------------- Cursor --------------'
     615C 2D2D     
     615E 2D2D     
     6160 2D2D     
     6162 2D2D     
     6164 2D2D     
     6166 2D2D     
     6168 2043     
     616A 7572     
     616C 736F     
     616E 7220     
     6170 2D2D     
     6172 2D2D     
     6174 2D2D     
     6176 2D2D     
     6178 2D2D     
     617A 2D2D     
     617C 2D2D     
0162                       even
0163               
0164               
0165 617E 12               byte  18
0166 617F   46             text  'Fctn s        Left'
     6180 6374     
     6182 6E20     
     6184 7320     
     6186 2020     
     6188 2020     
     618A 2020     
     618C 204C     
     618E 6566     
     6190 74       
0167                       even
0168               
0169               
0170 6192 13               byte  19
0171 6193   46             text  'Fctn d        Right'
     6194 6374     
     6196 6E20     
     6198 6420     
     619A 2020     
     619C 2020     
     619E 2020     
     61A0 2052     
     61A2 6967     
     61A4 6874     
0172                       even
0173               
0174               
0175 61A6 10               byte  16
0176 61A7   46             text  'Fctn e        Up'
     61A8 6374     
     61AA 6E20     
     61AC 6520     
     61AE 2020     
     61B0 2020     
     61B2 2020     
     61B4 2055     
     61B6 70       
0177                       even
0178               
0179               
0180 61B8 12               byte  18
0181 61B9   46             text  'Fctn x        Down'
     61BA 6374     
     61BC 6E20     
     61BE 7820     
     61C0 2020     
     61C2 2020     
     61C4 2020     
     61C6 2044     
     61C8 6F77     
     61CA 6E       
0182                       even
0183               
0184               
0185 61CC 12               byte  18
0186 61CD   46             text  'Fctn h        Home'
     61CE 6374     
     61D0 6E20     
     61D2 6820     
     61D4 2020     
     61D6 2020     
     61D8 2020     
     61DA 2048     
     61DC 6F6D     
     61DE 65       
0187                       even
0188               
0189               
0190 61E0 11               byte  17
0191 61E1   46             text  'Fctn l        End'
     61E2 6374     
     61E4 6E20     
     61E6 6C20     
     61E8 2020     
     61EA 2020     
     61EC 2020     
     61EE 2045     
     61F0 6E64     
0192                       even
0193               
0194               
0195 61F2 17               byte  23
0196 61F3   46             text  'Fctn j        Prev word'
     61F4 6374     
     61F6 6E20     
     61F8 6A20     
     61FA 2020     
     61FC 2020     
     61FE 2020     
     6200 2050     
     6202 7265     
     6204 7620     
     6206 776F     
     6208 7264     
0197                       even
0198               
0199               
0200 620A 17               byte  23
0201 620B   46             text  'Fctn k        Next word'
     620C 6374     
     620E 6E20     
     6210 6B20     
     6212 2020     
     6214 2020     
     6216 2020     
     6218 204E     
     621A 6578     
     621C 7420     
     621E 776F     
     6220 7264     
0202                       even
0203               
0204               
0205 6222 16               byte  22
0206 6223   46             text  'Fctn 7   ^t   Next tab'
     6224 6374     
     6226 6E20     
     6228 3720     
     622A 2020     
     622C 5E74     
     622E 2020     
     6230 204E     
     6232 6578     
     6234 7420     
     6236 7461     
     6238 62       
0207                       even
0208               
0209               
0210 623A 15               byte  21
0211 623B   46             text  'Fctn 6   ^e   Page up'
     623C 6374     
     623E 6E20     
     6240 3620     
     6242 2020     
     6244 5E65     
     6246 2020     
     6248 2050     
     624A 6167     
     624C 6520     
     624E 7570     
0212                       even
0213               
0214               
0215 6250 17               byte  23
0216 6251   46             text  'Fctn 4   ^x   Page down'
     6252 6374     
     6254 6E20     
     6256 3420     
     6258 2020     
     625A 5E78     
     625C 2020     
     625E 2050     
     6260 6167     
     6262 6520     
     6264 646F     
     6266 776E     
0217                       even
0218               
0219               
0220 6268 18               byte  24
0221 6269   46             text  'Fctn v        Screen top'
     626A 6374     
     626C 6E20     
     626E 7620     
     6270 2020     
     6272 2020     
     6274 2020     
     6276 2053     
     6278 6372     
     627A 6565     
     627C 6E20     
     627E 746F     
     6280 70       
0222                       even
0223               
0224               
0225 6282 1B               byte  27
0226 6283   46             text  'Fctn b        Screen bottom'
     6284 6374     
     6286 6E20     
     6288 6220     
     628A 2020     
     628C 2020     
     628E 2020     
     6290 2053     
     6292 6372     
     6294 6565     
     6296 6E20     
     6298 626F     
     629A 7474     
     629C 6F6D     
0227                       even
0228               
0229               
0230 629E 16               byte  22
0231 629F   43             text  'Ctrl v   ^v   File top'
     62A0 7472     
     62A2 6C20     
     62A4 7620     
     62A6 2020     
     62A8 5E76     
     62AA 2020     
     62AC 2046     
     62AE 696C     
     62B0 6520     
     62B2 746F     
     62B4 70       
0232                       even
0233               
0234               
0235 62B6 19               byte  25
0236 62B7   43             text  'Ctrl b   ^b   File bottom'
     62B8 7472     
     62BA 6C20     
     62BC 6220     
     62BE 2020     
     62C0 5E62     
     62C2 2020     
     62C4 2046     
     62C6 696C     
     62C8 6520     
     62CA 626F     
     62CC 7474     
     62CE 6F6D     
0237                       even
0238               
0239               
0240               dialog.help.data.page1.right:
0241               
0242 62D0 26               byte  38
0243 62D1   20             text  '                                 (1/2)'
     62D2 2020     
     62D4 2020     
     62D6 2020     
     62D8 2020     
     62DA 2020     
     62DC 2020     
     62DE 2020     
     62E0 2020     
     62E2 2020     
     62E4 2020     
     62E6 2020     
     62E8 2020     
     62EA 2020     
     62EC 2020     
     62EE 2020     
     62F0 2020     
     62F2 2831     
     62F4 2F32     
     62F6 29       
0244                       even
0245               
0246               
0247 62F8 01               byte  1
0248 62F9   20             text  ' '
0249                       even
0250               
0251               
0252 62FA 23               byte  35
0253 62FB   2D             text  '------------- File ----------------'
     62FC 2D2D     
     62FE 2D2D     
     6300 2D2D     
     6302 2D2D     
     6304 2D2D     
     6306 2D2D     
     6308 2046     
     630A 696C     
     630C 6520     
     630E 2D2D     
     6310 2D2D     
     6312 2D2D     
     6314 2D2D     
     6316 2D2D     
     6318 2D2D     
     631A 2D2D     
     631C 2D2D     
0254                       even
0255               
0256               
0257 631E 19               byte  25
0258 631F   43             text  'Ctrl a   ^a   Append file'
     6320 7472     
     6322 6C20     
     6324 6120     
     6326 2020     
     6328 5E61     
     632A 2020     
     632C 2041     
     632E 7070     
     6330 656E     
     6332 6420     
     6334 6669     
     6336 6C65     
0259                       even
0260               
0261               
0262 6338 21               byte  33
0263 6339   43             text  'Ctrl i   ^i   Insert file at line'
     633A 7472     
     633C 6C20     
     633E 6920     
     6340 2020     
     6342 5E69     
     6344 2020     
     6346 2049     
     6348 6E73     
     634A 6572     
     634C 7420     
     634E 6669     
     6350 6C65     
     6352 2061     
     6354 7420     
     6356 6C69     
     6358 6E65     
0264                       even
0265               
0266               
0267 635A 24               byte  36
0268 635B   43             text  'Ctrl c   ^c   Copy clipboard to line'
     635C 7472     
     635E 6C20     
     6360 6320     
     6362 2020     
     6364 5E63     
     6366 2020     
     6368 2043     
     636A 6F70     
     636C 7920     
     636E 636C     
     6370 6970     
     6372 626F     
     6374 6172     
     6376 6420     
     6378 746F     
     637A 206C     
     637C 696E     
     637E 65       
0269                       even
0270               
0271               
0272 6380 17               byte  23
0273 6381   43             text  'Ctrl o   ^o   Open file'
     6382 7472     
     6384 6C20     
     6386 6F20     
     6388 2020     
     638A 5E6F     
     638C 2020     
     638E 204F     
     6390 7065     
     6392 6E20     
     6394 6669     
     6396 6C65     
0274                       even
0275               
0276               
0277 6398 18               byte  24
0278 6399   43             text  'Ctrl p   ^p   Print file'
     639A 7472     
     639C 6C20     
     639E 7020     
     63A0 2020     
     63A2 5E70     
     63A4 2020     
     63A6 2050     
     63A8 7269     
     63AA 6E74     
     63AC 2066     
     63AE 696C     
     63B0 65       
0279                       even
0280               
0281               
0282 63B2 17               byte  23
0283 63B3   43             text  'Ctrl s   ^s   Save file'
     63B4 7472     
     63B6 6C20     
     63B8 7320     
     63BA 2020     
     63BC 5E73     
     63BE 2020     
     63C0 2053     
     63C2 6176     
     63C4 6520     
     63C6 6669     
     63C8 6C65     
0284                       even
0285               
0286               
0287 63CA 1C               byte  28
0288 63CB   43             text  'Ctrl ,   ^,   Load prev file'
     63CC 7472     
     63CE 6C20     
     63D0 2C20     
     63D2 2020     
     63D4 5E2C     
     63D6 2020     
     63D8 204C     
     63DA 6F61     
     63DC 6420     
     63DE 7072     
     63E0 6576     
     63E2 2066     
     63E4 696C     
     63E6 65       
0289                       even
0290               
0291               
0292 63E8 1C               byte  28
0293 63E9   43             text  'Ctrl .   ^.   Load next file'
     63EA 7472     
     63EC 6C20     
     63EE 2E20     
     63F0 2020     
     63F2 5E2E     
     63F4 2020     
     63F6 204C     
     63F8 6F61     
     63FA 6420     
     63FC 6E65     
     63FE 7874     
     6400 2066     
     6402 696C     
     6404 65       
0294                       even
0295               
0296               
0297 6406 01               byte  1
0298 6407   20             text  ' '
0299                       even
0300               
0301               
0302 6408 23               byte  35
0303 6409   2D             text  '------------- Others --------------'
     640A 2D2D     
     640C 2D2D     
     640E 2D2D     
     6410 2D2D     
     6412 2D2D     
     6414 2D2D     
     6416 204F     
     6418 7468     
     641A 6572     
     641C 7320     
     641E 2D2D     
     6420 2D2D     
     6422 2D2D     
     6424 2D2D     
     6426 2D2D     
     6428 2D2D     
     642A 2D2D     
0304                       even
0305               
0306               
0307 642C 12               byte  18
0308 642D   46             text  'Fctn +   ^q   Quit'
     642E 6374     
     6430 6E20     
     6432 2B20     
     6434 2020     
     6436 5E71     
     6438 2020     
     643A 2051     
     643C 7569     
     643E 74       
0309                       even
0310               
0311               
0312 6440 12               byte  18
0313 6441   43             text  'Ctrl h   ^h   Help'
     6442 7472     
     6444 6C20     
     6446 6820     
     6448 2020     
     644A 5E68     
     644C 2020     
     644E 2048     
     6450 656C     
     6452 70       
0314                       even
0315               
0316               
0317 6454 1A               byte  26
0318 6455   63             text  'ctrl u   ^u   Toggle ruler'
     6456 7472     
     6458 6C20     
     645A 7520     
     645C 2020     
     645E 5E75     
     6460 2020     
     6462 2054     
     6464 6F67     
     6466 676C     
     6468 6520     
     646A 7275     
     646C 6C65     
     646E 72       
0319                       even
0320               
0321               
0322 6470 21               byte  33
0323 6471   43             text  'Ctrl z   ^z   Cycle color schemes'
     6472 7472     
     6474 6C20     
     6476 7A20     
     6478 2020     
     647A 5E7A     
     647C 2020     
     647E 2043     
     6480 7963     
     6482 6C65     
     6484 2063     
     6486 6F6C     
     6488 6F72     
     648A 2073     
     648C 6368     
     648E 656D     
     6490 6573     
0324                       even
0325               
0326               
0327 6492 20               byte  32
0328 6493   63             text  'ctrl /   ^/   TI Basic (F9=exit)'
     6494 7472     
     6496 6C20     
     6498 2F20     
     649A 2020     
     649C 5E2F     
     649E 2020     
     64A0 2054     
     64A2 4920     
     64A4 4261     
     64A6 7369     
     64A8 6320     
     64AA 2846     
     64AC 393D     
     64AE 6578     
     64B0 6974     
     64B2 29       
0329                       even
0330               
0331               
0332               dialog.help.data.page2.left:
0333               
0334 64B4 01               byte  1
0335 64B5   20             text  ' '
0336                       even
0337               
0338               
0339 64B6 23               byte  35
0340 64B7   2D             text  '------------- Modifiers -----------'
     64B8 2D2D     
     64BA 2D2D     
     64BC 2D2D     
     64BE 2D2D     
     64C0 2D2D     
     64C2 2D2D     
     64C4 204D     
     64C6 6F64     
     64C8 6966     
     64CA 6965     
     64CC 7273     
     64CE 202D     
     64D0 2D2D     
     64D2 2D2D     
     64D4 2D2D     
     64D6 2D2D     
     64D8 2D2D     
0341                       even
0342               
0343               
0344 64DA 1E               byte  30
0345 64DB   46             text  'Fctn 1        Delete character'
     64DC 6374     
     64DE 6E20     
     64E0 3120     
     64E2 2020     
     64E4 2020     
     64E6 2020     
     64E8 2044     
     64EA 656C     
     64EC 6574     
     64EE 6520     
     64F0 6368     
     64F2 6172     
     64F4 6163     
     64F6 7465     
     64F8 72       
0346                       even
0347               
0348               
0349 64FA 1E               byte  30
0350 64FB   46             text  'Fctn 2        Insert character'
     64FC 6374     
     64FE 6E20     
     6500 3220     
     6502 2020     
     6504 2020     
     6506 2020     
     6508 2049     
     650A 6E73     
     650C 6572     
     650E 7420     
     6510 6368     
     6512 6172     
     6514 6163     
     6516 7465     
     6518 72       
0351                       even
0352               
0353               
0354 651A 19               byte  25
0355 651B   46             text  'Fctn 3        Delete line'
     651C 6374     
     651E 6E20     
     6520 3320     
     6522 2020     
     6524 2020     
     6526 2020     
     6528 2044     
     652A 656C     
     652C 6574     
     652E 6520     
     6530 6C69     
     6532 6E65     
0356                       even
0357               
0358               
0359 6534 20               byte  32
0360 6535   43             text  'Ctrl l   ^l   Delete end of line'
     6536 7472     
     6538 6C20     
     653A 6C20     
     653C 2020     
     653E 5E6C     
     6540 2020     
     6542 2044     
     6544 656C     
     6546 6574     
     6548 6520     
     654A 656E     
     654C 6420     
     654E 6F66     
     6550 206C     
     6552 696E     
     6554 65       
0361                       even
0362               
0363               
0364 6556 19               byte  25
0365 6557   46             text  'Fctn 8        Insert line'
     6558 6374     
     655A 6E20     
     655C 3820     
     655E 2020     
     6560 2020     
     6562 2020     
     6564 2049     
     6566 6E73     
     6568 6572     
     656A 7420     
     656C 6C69     
     656E 6E65     
0366                       even
0367               
0368               
0369 6570 1E               byte  30
0370 6571   46             text  'Fctn .        Insert/Overwrite'
     6572 6374     
     6574 6E20     
     6576 2E20     
     6578 2020     
     657A 2020     
     657C 2020     
     657E 2049     
     6580 6E73     
     6582 6572     
     6584 742F     
     6586 4F76     
     6588 6572     
     658A 7772     
     658C 6974     
     658E 65       
0371                       even
0372               
0373               
0374               dialog.help.data.page2.right:
0375               
0376 6590 26               byte  38
0377 6591   20             text  '                                 (2/2)'
     6592 2020     
     6594 2020     
     6596 2020     
     6598 2020     
     659A 2020     
     659C 2020     
     659E 2020     
     65A0 2020     
     65A2 2020     
     65A4 2020     
     65A6 2020     
     65A8 2020     
     65AA 2020     
     65AC 2020     
     65AE 2020     
     65B0 2020     
     65B2 2832     
     65B4 2F32     
     65B6 29       
0378                       even
0379               
0380               
0381 65B8 01               byte  1
0382 65B9   20             text  ' '
0383                       even
0384               
0385               
0386 65BA 23               byte  35
0387 65BB   2D             text  '------------- Block mode ----------'
     65BC 2D2D     
     65BE 2D2D     
     65C0 2D2D     
     65C2 2D2D     
     65C4 2D2D     
     65C6 2D2D     
     65C8 2042     
     65CA 6C6F     
     65CC 636B     
     65CE 206D     
     65D0 6F64     
     65D2 6520     
     65D4 2D2D     
     65D6 2D2D     
     65D8 2D2D     
     65DA 2D2D     
     65DC 2D2D     
0388                       even
0389               
0390               
0391 65DE 1E               byte  30
0392 65DF   43             text  'Ctrl SPACE    Set M1/M2 marker'
     65E0 7472     
     65E2 6C20     
     65E4 5350     
     65E6 4143     
     65E8 4520     
     65EA 2020     
     65EC 2053     
     65EE 6574     
     65F0 204D     
     65F2 312F     
     65F4 4D32     
     65F6 206D     
     65F8 6172     
     65FA 6B65     
     65FC 72       
0393                       even
0394               
0395               
0396 65FE 1A               byte  26
0397 65FF   43             text  'Ctrl d   ^d   Delete block'
     6600 7472     
     6602 6C20     
     6604 6420     
     6606 2020     
     6608 5E64     
     660A 2020     
     660C 2044     
     660E 656C     
     6610 6574     
     6612 6520     
     6614 626C     
     6616 6F63     
     6618 6B       
0398                       even
0399               
0400               
0401 661A 18               byte  24
0402 661B   43             text  'Ctrl c   ^c   Copy block'
     661C 7472     
     661E 6C20     
     6620 6320     
     6622 2020     
     6624 5E63     
     6626 2020     
     6628 2043     
     662A 6F70     
     662C 7920     
     662E 626C     
     6630 6F63     
     6632 6B       
0403                       even
0404               
0405               
0406 6634 1C               byte  28
0407 6635   43             text  'Ctrl g   ^g   Goto marker M1'
     6636 7472     
     6638 6C20     
     663A 6720     
     663C 2020     
     663E 5E67     
     6640 2020     
     6642 2047     
     6644 6F74     
     6646 6F20     
     6648 6D61     
     664A 726B     
     664C 6572     
     664E 204D     
     6650 31       
0408                       even
0409               
0410               
0411 6652 18               byte  24
0412 6653   43             text  'Ctrl m   ^m   Move block'
     6654 7472     
     6656 6C20     
     6658 6D20     
     665A 2020     
     665C 5E6D     
     665E 2020     
     6660 204D     
     6662 6F76     
     6664 6520     
     6666 626C     
     6668 6F63     
     666A 6B       
0413                       even
0414               
0415               
0416 666C 20               byte  32
0417 666D   43             text  'Ctrl s   ^s   Save block to file'
     666E 7472     
     6670 6C20     
     6672 7320     
     6674 2020     
     6676 5E73     
     6678 2020     
     667A 2053     
     667C 6176     
     667E 6520     
     6680 626C     
     6682 6F63     
     6684 6B20     
     6686 746F     
     6688 2066     
     668A 696C     
     668C 65       
0418                       even
0419               
0420               
0421 668E 23               byte  35
0422 668F   43             text  'Ctrl ^1..^5   Copy to clipboard 1-5'
     6690 7472     
     6692 6C20     
     6694 5E31     
     6696 2E2E     
     6698 5E35     
     669A 2020     
     669C 2043     
     669E 6F70     
     66A0 7920     
     66A2 746F     
     66A4 2063     
     66A6 6C69     
     66A8 7062     
     66AA 6F61     
     66AC 7264     
     66AE 2031     
     66B0 2D35     
0423                       even
0424               
                   < stevie_b3.asm.68345
0063                       copy  "dialog.file.asm"      ; Dialog "File"
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
0022 66B2 0649  14         dect  stack
0023 66B4 C64B  30         mov   r11,*stack            ; Save return address
0024 66B6 0649  14         dect  stack
0025 66B8 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 66BA 0204  20         li    tmp0,id.dialog.file
     66BC 0069     
0030 66BE C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     66C0 A71A     
0031               
0032 66C2 0204  20         li    tmp0,txt.head.file
     66C4 75CE     
0033 66C6 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     66C8 A71E     
0034               
0035 66CA 0204  20         li    tmp0,txt.info.file
     66CC 75D8     
0036 66CE C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     66D0 A720     
0037               
0038 66D2 0204  20         li    tmp0,pos.info.file
     66D4 75FE     
0039 66D6 C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     66D8 A724     
0040               
0041 66DA 0204  20         li    tmp0,txt.hint.file
     66DC 7604     
0042 66DE C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     66E0 A722     
0043               
0044 66E2 0204  20         li    tmp0,txt.keys.file
     66E4 7606     
0045 66E6 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     66E8 A726     
0046               
0047 66EA 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     66EC 7086     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.file.exit:
0052 66EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 66F0 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 66F2 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0064                       copy  "dialog.cartridge.asm" ; Dialog "Cartridge"
     **** ****     > dialog.cartridge.asm
0001               * basic......: dialog.cartridge.asm
0002               * Purpose....: Dialog "Cartridge"
0003               
0004               ***************************************************************
0005               * dialog.cartridge
0006               * Open Dialog "Cartridge"
0007               ***************************************************************
0008               * b @dialog.cartridge
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
0021               dialog.cartridge:
0022 66F4 0649  14         dect  stack
0023 66F6 C64B  30         mov   r11,*stack            ; Save return address
0024 66F8 0649  14         dect  stack
0025 66FA C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 66FC 0204  20         li    tmp0,id.dialog.cartridge
     66FE 006A     
0030 6700 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6702 A71A     
0031               
0032 6704 0204  20         li    tmp0,txt.head.cartridge
     6706 760E     
0033 6708 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     670A A71E     
0034               
0035 670C 0204  20         li    tmp0,txt.info.cartridge
     670E 761D     
0036 6710 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6712 A720     
0037               
0038 6714 0204  20         li    tmp0,pos.info.cartridge
     6716 7626     
0039 6718 C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     671A A724     
0040               
0041 671C 0204  20         li    tmp0,txt.hint.cartridge
     671E 7628     
0042 6720 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6722 A722     
0043               
0044 6724 0204  20         li    tmp0,txt.keys.cartridge
     6726 7642     
0045 6728 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     672A A726     
0046               
0047 672C 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     672E 7086     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.cartridge.exit:
0052 6730 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6732 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 6734 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0065                       copy  "dialog.load.asm"      ; Dialog "Load file"
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
0017               * tmp0, tmp1
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               dialog.load:
0022 6736 0649  14         dect  stack
0023 6738 C64B  30         mov   r11,*stack            ; Save return address
0024 673A 0649  14         dect  stack
0025 673C C644  30         mov   tmp0,*stack           ; Push tmp0
0026 673E 0649  14         dect  stack
0027 6740 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Show dialog "Unsaved changes" if editor buffer dirty
0030                       ;-------------------------------------------------------
0031 6742 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     6744 A506     
0032 6746 1303  14         jeq   dialog.load.setup     ; No, skip "Unsaved changes"
0033               
0034 6748 06A0  32         bl    @dialog.unsaved       ; Show dialog
     674A 6AB8     
0035 674C 1029  14         jmp   dialog.load.exit      ; Exit early
0036                       ;-------------------------------------------------------
0037                       ; Setup dialog
0038                       ;-------------------------------------------------------
0039               dialog.load.setup:
0040 674E 06A0  32         bl    @fb.scan.fname        ; Get possible device/filename
     6750 70BC     
0041               
0042 6752 0204  20         li    tmp0,id.dialog.load
     6754 000A     
0043 6756 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6758 A71A     
0044               
0045 675A 0204  20         li    tmp0,txt.head.load
     675C 719A     
0046 675E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6760 A71E     
0047               
0048 6762 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     6764 A720     
0049 6766 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6768 A724     
0050               
0051 676A 0204  20         li    tmp0,txt.hint.load
     676C 71A9     
0052 676E C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6770 A722     
0053               
0054 6772 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6774 A44E     
0055 6776 1303  14         jeq   !
0056                       ;-------------------------------------------------------
0057                       ; Show that FastMode is on
0058                       ;-------------------------------------------------------
0059 6778 0204  20         li    tmp0,txt.keys.load2   ; Highlight FastMode
     677A 717A     
0060 677C 1002  14         jmp   dialog.load.keylist
0061                       ;-------------------------------------------------------
0062                       ; Show that FastMode is off
0063                       ;-------------------------------------------------------
0064 677E 0204  20 !       li    tmp0,txt.keys.load
     6780 715A     
0065                       ;-------------------------------------------------------
0066                       ; Show dialog
0067                       ;-------------------------------------------------------
0068               dialog.load.keylist:
0069 6782 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6784 A726     
0070                       ;-------------------------------------------------------
0071                       ; Set command line
0072                       ;-------------------------------------------------------
0073 6786 0204  20         li    tmp0,cmdb.dflt.fname  ; Get pointer to default filename
     6788 A7AE     
0074 678A C154  26         mov   *tmp0,tmp1            ; Anything set?
0075 678C 1304  14         jeq   dialog.load.cursor    ; No default filename, skip
0076               
0077 678E C804  38         mov   tmp0,@parm1           ; Get pointer to string
     6790 A006     
0078 6792 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6794 6E68     
0079                                                   ; \ i  @parm1 = Pointer to string w. preset
0080                                                   ; /
0081                       ;-------------------------------------------------------
0082                       ; Set cursor shape
0083                       ;-------------------------------------------------------
0084               dialog.load.cursor:
0085 6796 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6798 7074     
0086 679A C820  54         mov   @tv.curshape,@ramsat+2
     679C A214     
     679E A044     
0087                                                   ; Get cursor shape and color
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               dialog.load.exit:
0092 67A0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0093 67A2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0094 67A4 C2F9  30         mov   *stack+,r11           ; Pop R11
0095 67A6 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0066                       copy  "dialog.save.asm"      ; Dialog "Save file"
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
0022 67A8 0649  14         dect  stack
0023 67AA C64B  30         mov   r11,*stack            ; Save return address
0024 67AC 0649  14         dect  stack
0025 67AE C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029 67B0 8820  54         c     @fb.row.dirty,@w$ffff
     67B2 A30A     
     67B4 2022     
0030 67B6 1604  14         jne   !                     ; Skip crunching if clean
0031 67B8 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     67BA 701A     
0032 67BC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     67BE A30A     
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036 67C0 8820  54 !       c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67C2 A50E     
     67C4 2022     
0037 67C6 130B  14         jeq   dialog.save.default   ; Yes, so show default dialog
0038                       ;-------------------------------------------------------
0039                       ; Setup dialog title
0040                       ;-------------------------------------------------------
0041 67C8 06A0  32         bl    @cmdb.cmd.clear       ; Clear current CMDB command
     67CA 6E20     
0042               
0043 67CC 0204  20         li    tmp0,id.dialog.saveblock
     67CE 000C     
0044 67D0 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     67D2 A71A     
0045 67D4 0204  20         li    tmp0,txt.head.save2   ; Title "Save block to file"
     67D6 71D7     
0046 67D8 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     67DA A71E     
0047 67DC 100E  14         jmp   dialog.save.header
0048                       ;-------------------------------------------------------
0049                       ; Default dialog
0050                       ;-------------------------------------------------------
0051               dialog.save.default:
0052 67DE 0204  20         li    tmp0,id.dialog.save
     67E0 000B     
0053 67E2 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     67E4 A71A     
0054 67E6 0204  20         li    tmp0,txt.head.save    ; Title "Save file"
     67E8 71C8     
0055 67EA C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     67EC A71E     
0056                       ;-------------------------------------------------------
0057                       ; Set command line
0058                       ;-------------------------------------------------------
0059 67EE 0204  20         li    tmp0,edb.filename     ; Set filename
     67F0 A51A     
0060 67F2 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     67F4 A006     
0061               
0062 67F6 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     67F8 6E68     
0063                                                   ; \ i  @parm1 = Pointer to string w. preset
0064                                                   ; /
0065                       ;-------------------------------------------------------
0066                       ; Setup header
0067                       ;-------------------------------------------------------
0068               dialog.save.header:
0069               
0070 67FA 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     67FC A720     
0071 67FE 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6800 A724     
0072               
0073 6802 0204  20         li    tmp0,txt.hint.save
     6804 71EF     
0074 6806 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6808 A722     
0075               
0076 680A 0204  20         li    tmp0,txt.keys.save
     680C 720E     
0077 680E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6810 A726     
0078               
0079 6812 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     6814 A44E     
0080                       ;-------------------------------------------------------
0081                       ; Set cursor shape
0082                       ;-------------------------------------------------------
0083 6816 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6818 7074     
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               dialog.save.exit:
0088 681A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 681C C2F9  30         mov   *stack+,r11           ; Pop R11
0090 681E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0067                       copy  "dialog.print.asm"     ; Dialog "Print file"
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
0022 6820 0649  14         dect  stack
0023 6822 C64B  30         mov   r11,*stack            ; Save return address
0024 6824 0649  14         dect  stack
0025 6826 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029 6828 8820  54         c     @fb.row.dirty,@w$ffff
     682A A30A     
     682C 2022     
0030 682E 1604  14         jne   !                     ; Skip crunching if clean
0031 6830 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6832 701A     
0032 6834 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6836 A30A     
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036 6838 8820  54 !       c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     683A A50E     
     683C 2022     
0037 683E 1307  14         jeq   dialog.print.default  ; Yes, so show default dialog
0038                       ;-------------------------------------------------------
0039                       ; Setup dialog title
0040                       ;-------------------------------------------------------
0041 6840 0204  20         li    tmp0,id.dialog.printblock
     6842 0010     
0042 6844 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6846 A71A     
0043 6848 0204  20         li    tmp0,txt.head.print2  ; Title "Print block to file"
     684A 7404     
0044               
0045 684C 1006  14         jmp   dialog.print.header
0046                       ;-------------------------------------------------------
0047                       ; Default dialog
0048                       ;-------------------------------------------------------
0049               dialog.print.default:
0050 684E 0204  20         li    tmp0,id.dialog.print
     6850 000F     
0051 6852 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6854 A71A     
0052 6856 0204  20         li    tmp0,txt.head.print   ; Title "Print file"
     6858 73F4     
0053                       ;-------------------------------------------------------
0054                       ; Setup header
0055                       ;-------------------------------------------------------
0056               dialog.print.header:
0057 685A C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     685C A71E     
0058               
0059 685E 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     6860 A720     
0060 6862 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6864 A724     
0061               
0062 6866 0204  20         li    tmp0,txt.hint.print
     6868 7415     
0063 686A C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     686C A722     
0064               
0065 686E 0204  20         li    tmp0,txt.keys.save
     6870 720E     
0066 6872 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6874 A726     
0067               
0068 6876 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     6878 A44E     
0069                       ;-------------------------------------------------------
0070                       ; Set command line
0071                       ;-------------------------------------------------------
0072 687A 0204  20         li    tmp0,tv.printer.fname ; Set printer name
     687C D960     
0073 687E C804  38         mov   tmp0,@parm1           ; Get pointer to string
     6880 A006     
0074               
0075 6882 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6884 6E68     
0076                                                   ; \ i  @parm1 = Pointer to string w. preset
0077                                                   ; /
0078                       ;-------------------------------------------------------
0079                       ; Set cursor shape
0080                       ;-------------------------------------------------------
0081 6886 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6888 7074     
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               dialog.print.exit:
0086 688A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 688C C2F9  30         mov   *stack+,r11           ; Pop R11
0088 688E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0068                       copy  "dialog.append.asm"    ; Dialog "Append file"
     **** ****     > dialog.append.asm
0001               * FILE......: dialog.append.asm
0002               * Purpose...: Dialog "Append DV80 file"
0003               
0004               ***************************************************************
0005               * dialog.append
0006               * Open Dialog for inserting DV 80 file
0007               ***************************************************************
0008               * b @dialog.append
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0, tmp1
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               dialog.append:
0022 6890 0649  14         dect  stack
0023 6892 C64B  30         mov   r11,*stack            ; Save return address
0024 6894 0649  14         dect  stack
0025 6896 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6898 0649  14         dect  stack
0027 689A C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Setup dialog
0030                       ;-------------------------------------------------------
0031               dialog.append.setup:
0032 689C 06A0  32         bl    @fb.scan.fname        ; Get possible device/filename
     689E 70BC     
0033               
0034 68A0 0204  20         li    tmp0,id.dialog.append
     68A2 000E     
0035 68A4 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     68A6 A71A     
0036               
0037 68A8 0204  20         li    tmp0,txt.head.append
     68AA 7220     
0038 68AC C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     68AE A71E     
0039               
0040 68B0 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     68B2 A720     
0041 68B4 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     68B6 A724     
0042               
0043 68B8 0204  20         li    tmp0,txt.hint.append
     68BA 7231     
0044 68BC C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     68BE A722     
0045               
0046 68C0 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     68C2 A44E     
0047 68C4 1303  14         jeq   !
0048                       ;-------------------------------------------------------
0049                       ; Show that FastMode is on
0050                       ;-------------------------------------------------------
0051 68C6 0204  20         li    tmp0,txt.keys.insert  ; Highlight FastMode
     68C8 715A     
0052 68CA 1002  14         jmp   dialog.append.keylist
0053                       ;-------------------------------------------------------
0054                       ; Show that FastMode is off
0055                       ;-------------------------------------------------------
0056 68CC 0204  20 !       li    tmp0,txt.keys.insert
     68CE 715A     
0057                       ;-------------------------------------------------------
0058                       ; Show dialog
0059                       ;-------------------------------------------------------
0060               dialog.append.keylist:
0061 68D0 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     68D2 A726     
0062                       ;-------------------------------------------------------
0063                       ; Set command line
0064                       ;-------------------------------------------------------
0065 68D4 0204  20         li    tmp0,cmdb.dflt.fname  ; Get pointer to default filename
     68D6 A7AE     
0066 68D8 C154  26         mov   *tmp0,tmp1            ; Anything set?
0067 68DA 1304  14         jeq   dialog.append.cursor  ; No default filename, skip
0068               
0069 68DC C804  38         mov   tmp0,@parm1           ; Get pointer to string
     68DE A006     
0070 68E0 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     68E2 6E68     
0071                                                   ; \ i  @parm1 = Pointer to string w. preset
0072                                                   ; /
0073                       ;-------------------------------------------------------
0074                       ; Set cursor shape
0075                       ;-------------------------------------------------------
0076               dialog.append.cursor:
0077 68E4 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     68E6 7074     
0078 68E8 C820  54         mov   @tv.curshape,@ramsat+2
     68EA A214     
     68EC A044     
0079                                                   ; Get cursor shape and color
0080                       ;-------------------------------------------------------
0081                       ; Exit
0082                       ;-------------------------------------------------------
0083               dialog.append.exit:
0084 68EE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0085 68F0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0086 68F2 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 68F4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0069                       copy  "dialog.insert.asm"    ; Dialog "Insert file at line"
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
0017               * tmp0, tmp1
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               dialog.insert:
0022 68F6 0649  14         dect  stack
0023 68F8 C64B  30         mov   r11,*stack            ; Save return address
0024 68FA 0649  14         dect  stack
0025 68FC C644  30         mov   tmp0,*stack           ; Push tmp0
0026 68FE 0649  14         dect  stack
0027 6900 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Setup dialog
0030                       ;-------------------------------------------------------
0031               dialog.insert.setup:
0032 6902 06A0  32         bl    @fb.scan.fname        ; Get possible device/filename
     6904 70BC     
0033               
0034 6906 0204  20         li    tmp0,id.dialog.insert
     6908 000D     
0035 690A C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     690C A71A     
0036                       ;------------------------------------------------------
0037                       ; Include line number in pane header
0038                       ;------------------------------------------------------
0039 690E 06A0  32         bl    @film
     6910 224A     
0040 6912 A77C                   data cmdb.panhead.buf,>00,50
     6914 0000     
     6916 0032     
0041                                                   ; Clear pane header buffer
0042               
0043 6918 06A0  32         bl    @cpym2m
     691A 24EE     
0044 691C 7272                   data txt.head.insert,cmdb.panhead.buf,25
     691E A77C     
     6920 0019     
0045               
0046 6922 C820  54         mov   @fb.row,@parm1        ; Get row at cursor
     6924 A306     
     6926 A006     
0047 6928 06A0  32         bl    @fb.row2line          ; Row to editor line
     692A 7050     
0048                                                   ; \ i @fb.topline = Top line in frame buffer
0049                                                   ; | i @parm1      = Row in frame buffer
0050                                                   ; / o @outparm1   = Matching line in EB
0051               
0052 692C 05E0  34         inct  @outparm1             ; \ Add base 1 and insert at line
     692E A016     
0053                                                   ; / following cursor, not line at cursor.
0054               
0055 6930 06A0  32         bl    @mknum                ; Convert integer to string
     6932 29BA     
0056 6934 A016                   data  outparm1        ; \ i  p0 = Pointer to 16 bit unsigned int
0057 6936 A100                   data  rambuf          ; | i  p1 = Pointer to 5 byte string buffer
0058 6938 30                     byte  48              ; | i  p2 = MSB offset for ASCII digit
0059 6939   30                   byte  48              ; / i  p2 = LSB char for replacing leading 0
0060               
0061 693A 06A0  32         bl    @cpym2m
     693C 24EE     
0062 693E A100                   data rambuf,cmdb.panhead.buf + 24,5
     6940 A794     
     6942 0005     
0063                                                   ; Add line number to buffer
0064               
0065 6944 0204  20         li    tmp0,29
     6946 001D     
0066 6948 0A84  56         sla   tmp0,8
0067 694A D804  38         movb  tmp0,@cmdb.panhead.buf ; Set length byte
     694C A77C     
0068               
0069 694E 0204  20         li    tmp0,cmdb.panhead.buf
     6950 A77C     
0070 6952 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6954 A71E     
0071                       ;------------------------------------------------------
0072                       ; Other panel strings
0073                       ;------------------------------------------------------
0074 6956 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     6958 A720     
0075 695A 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     695C A724     
0076               
0077 695E 0204  20         li    tmp0,txt.hint.insert
     6960 728B     
0078 6962 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6964 A722     
0079               
0080 6966 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6968 A44E     
0081 696A 1303  14         jeq   !
0082                       ;-------------------------------------------------------
0083                       ; Show that FastMode is on
0084                       ;-------------------------------------------------------
0085 696C 0204  20         li    tmp0,txt.keys.insert  ; Highlight FastMode
     696E 715A     
0086 6970 1002  14         jmp   dialog.insert.keylist
0087                       ;-------------------------------------------------------
0088                       ; Show that FastMode is off
0089                       ;-------------------------------------------------------
0090 6972 0204  20 !       li    tmp0,txt.keys.insert
     6974 715A     
0091                       ;-------------------------------------------------------
0092                       ; Show dialog
0093                       ;-------------------------------------------------------
0094               dialog.insert.keylist:
0095 6976 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6978 A726     
0096                       ;-------------------------------------------------------
0097                       ; Set command line
0098                       ;-------------------------------------------------------
0099 697A 0204  20         li    tmp0,cmdb.dflt.fname  ; Get pointer to default filename
     697C A7AE     
0100 697E C154  26         mov   *tmp0,tmp1            ; Anything set?
0101 6980 1304  14         jeq   dialog.insert.cursor  ; No default filename, skip
0102               
0103 6982 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     6984 A006     
0104 6986 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6988 6E68     
0105                                                   ; \ i  @parm1 = Pointer to string w. preset
0106                                                   ; /
0107                       ;-------------------------------------------------------
0108                       ; Set cursor shape
0109                       ;-------------------------------------------------------
0110               dialog.insert.cursor:
0111 698A 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     698C 7074     
0112 698E C820  54         mov   @tv.curshape,@ramsat+2
     6990 A214     
     6992 A044     
0113                                                   ; Get cursor shape and color
0114                       ;-------------------------------------------------------
0115                       ; Exit
0116                       ;-------------------------------------------------------
0117               dialog.insert.exit:
0118 6994 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0119 6996 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0120 6998 C2F9  30         mov   *stack+,r11           ; Pop R11
0121 699A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
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
0022 699C 0649  14         dect  stack
0023 699E C64B  30         mov   r11,*stack            ; Save return address
0024 69A0 0649  14         dect  stack
0025 69A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 69A4 0204  20         li    tmp0,id.dialog.config
     69A6 006C     
0030 69A8 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     69AA A71A     
0031               
0032 69AC 0204  20         li    tmp0,txt.head.config
     69AE 76E8     
0033 69B0 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     69B2 A71E     
0034               
0035 69B4 0204  20         li    tmp0,txt.info.config
     69B6 76F7     
0036 69B8 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     69BA A720     
0037               
0038 69BC 0204  20         li    tmp0,pos.info.config
     69BE 7702     
0039 69C0 C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     69C2 A724     
0040               
0041 69C4 0204  20         li    tmp0,txt.hint.config
     69C6 7704     
0042 69C8 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     69CA A722     
0043               
0044 69CC 0204  20         li    tmp0,txt.keys.config
     69CE 7706     
0045 69D0 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     69D2 A726     
0046               
0047 69D4 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     69D6 7086     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.config.exit:
0052 69D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 69DA C2F9  30         mov   *stack+,r11           ; Pop R11
0054 69DC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0071                       copy  "dialog.clipdev.asm"   ; Dialog "Configure clipboard device"
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
0022 69DE 0649  14         dect  stack
0023 69E0 C64B  30         mov   r11,*stack            ; Save return address
0024 69E2 0649  14         dect  stack
0025 69E4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 69E6 0204  20         li    tmp0,id.dialog.clipdev
     69E8 0011     
0030 69EA C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     69EC A71A     
0031               
0032 69EE 0204  20         li    tmp0,txt.head.clipdev
     69F0 72AC     
0033 69F2 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     69F4 A71E     
0034               
0035 69F6 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     69F8 A720     
0036 69FA 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     69FC A724     
0037               
0038 69FE 0204  20         li    tmp0,txt.hint.clipdev
     6A00 72CC     
0039 6A02 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6A04 A722     
0040               
0041 6A06 0204  20         li    tmp0,txt.keys.clipdev
     6A08 72FA     
0042 6A0A C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6A0C A726     
0043                       ;-------------------------------------------------------
0044                       ; Set command line
0045                       ;-------------------------------------------------------
0046 6A0E 0204  20         li    tmp0,tv.clip.fname    ; Set clipboard
     6A10 D9B0     
0047 6A12 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     6A14 A006     
0048               
0049 6A16 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6A18 6E68     
0050                                                   ; \ i  @parm1 = Pointer to string w. preset
0051                                                   ; /
0052                       ;-------------------------------------------------------
0053                       ; Set cursor shape
0054                       ;-------------------------------------------------------
0055 6A1A 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6A1C 7074     
0056 6A1E C820  54         mov   @tv.curshape,@ramsat+2
     6A20 A214     
     6A22 A044     
0057                                                   ; Get cursor shape and color
0058                       ;-------------------------------------------------------
0059                       ; Exit
0060                       ;-------------------------------------------------------
0061               dialog.clipdevice.exit:
0062 6A24 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0063 6A26 C2F9  30         mov   *stack+,r11           ; Pop R11
0064 6A28 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0072                       copy  "dialog.clipboard.asm" ; Dialog "Copy from clipboard"
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
0022 6A2A 0649  14         dect  stack
0023 6A2C C64B  30         mov   r11,*stack            ; Save return address
0024 6A2E 0649  14         dect  stack
0025 6A30 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029               dialog.clipboard.setup:
0030 6A32 0204  20         li    tmp0,id.dialog.clipboard
     6A34 0067     
0031 6A36 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6A38 A71A     
0032                       ;------------------------------------------------------
0033                       ; Include line number in pane header
0034                       ;------------------------------------------------------
0035 6A3A 06A0  32         bl    @film
     6A3C 224A     
0036 6A3E A77C                   data cmdb.panhead.buf,>00,50
     6A40 0000     
     6A42 0032     
0037                                                   ; Clear pane header buffer
0038               
0039 6A44 06A0  32         bl    @cpym2m
     6A46 24EE     
0040 6A48 7336                   data txt.head.clipboard,cmdb.panhead.buf,27
     6A4A A77C     
     6A4C 001B     
0041               
0042 6A4E C820  54         mov   @fb.row,@parm1
     6A50 A306     
     6A52 A006     
0043 6A54 06A0  32         bl    @fb.row2line          ; Row to editor line
     6A56 7050     
0044                                                   ; \ i @fb.topline = Top line in frame buffer
0045                                                   ; | i @parm1      = Row in frame buffer
0046                                                   ; / o @outparm1   = Matching line in EB
0047               
0048 6A58 05A0  34         inc   @outparm1             ; Add base 1
     6A5A A016     
0049               
0050 6A5C 06A0  32         bl    @mknum                ; Convert integer to string
     6A5E 29BA     
0051 6A60 A016                   data  outparm1        ; \ i  p0 = Pointer to 16 bit unsigned int
0052 6A62 A100                   data  rambuf          ; | i  p1 = Pointer to 5 byte string buffer
0053 6A64 30                     byte  48              ; | i  p2 = MSB offset for ASCII digit
0054 6A65   30                   byte  48              ; / i  p2 = LSB char for replacing leading 0
0055               
0056 6A66 06A0  32         bl    @cpym2m
     6A68 24EE     
0057 6A6A A100                   data rambuf,cmdb.panhead.buf + 27,5
     6A6C A797     
     6A6E 0005     
0058                                                   ; Add line number to buffer
0059               
0060 6A70 0204  20         li    tmp0,32
     6A72 0020     
0061 6A74 0A84  56         sla   tmp0,8
0062 6A76 D804  38         movb  tmp0,@cmdb.panhead.buf
     6A78 A77C     
0063                                                   ; Set length byte
0064               
0065 6A7A 0204  20         li    tmp0,cmdb.panhead.buf
     6A7C A77C     
0066 6A7E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6A80 A71E     
0067                       ;------------------------------------------------------
0068                       ; Other panel strings
0069                       ;------------------------------------------------------
0070 6A82 0204  20         li    tmp0,txt.hint.clipboard
     6A84 7364     
0071 6A86 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6A88 A722     
0072               
0073 6A8A 0204  20         li    tmp0,txt.info.clipboard
     6A8C 7352     
0074 6A8E C804  38         mov   tmp0,@cmdb.paninfo    ; Show info message
     6A90 A720     
0075               
0076 6A92 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6A94 A724     
0077               
0078 6A96 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6A98 6E20     
0079               
0080 6A9A 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6A9C A44E     
0081 6A9E 1303  14         jeq   !
0082                       ;-------------------------------------------------------
0083                       ; Show that FastMode is on
0084                       ;-------------------------------------------------------
0085 6AA0 0204  20         li    tmp0,txt.keys.clipboard ; Highlight FastMode
     6AA2 73AC     
0086 6AA4 1002  14         jmp   dialog.clipboard.keylist
0087                       ;-------------------------------------------------------
0088                       ; Show that FastMode is off
0089                       ;-------------------------------------------------------
0090 6AA6 0204  20 !       li    tmp0,txt.keys.clipboard
     6AA8 73AC     
0091                       ;-------------------------------------------------------
0092                       ; Show dialog
0093                       ;-------------------------------------------------------
0094               dialog.clipboard.keylist:
0095 6AAA C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6AAC A726     
0096               
0097 6AAE 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6AB0 7086     
0098                       ;-------------------------------------------------------
0099                       ; Exit
0100                       ;-------------------------------------------------------
0101               dialog.clipboard.exit:
0102 6AB2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0103 6AB4 C2F9  30         mov   *stack+,r11           ; Pop R11
0104 6AB6 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0073                       copy  "dialog.unsaved.asm"   ; Dialog "Unsaved changes"
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
0022 6AB8 0649  14         dect  stack
0023 6ABA C64B  30         mov   r11,*stack            ; Save return address
0024 6ABC 0649  14         dect  stack
0025 6ABE C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6AC0 0204  20         li    tmp0,id.dialog.unsaved
     6AC2 0065     
0030 6AC4 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6AC6 A71A     
0031               
0032 6AC8 0204  20         li    tmp0,txt.head.unsaved
     6ACA 7454     
0033 6ACC C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6ACE A71E     
0034               
0035 6AD0 0204  20         li    tmp0,txt.info.unsaved
     6AD2 7469     
0036 6AD4 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6AD6 A720     
0037 6AD8 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6ADA A724     
0038               
0039 6ADC 0204  20         li    tmp0,txt.hint.unsaved
     6ADE 748C     
0040 6AE0 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6AE2 A722     
0041               
0042 6AE4 0204  20         li    tmp0,txt.keys.unsaved
     6AE6 74C4     
0043 6AE8 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6AEA A726     
0044               
0045 6AEC 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6AEE 7086     
0046                       ;-------------------------------------------------------
0047                       ; Exit
0048                       ;-------------------------------------------------------
0049               dialog.unsaved.exit:
0050 6AF0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 6AF2 C2F9  30         mov   *stack+,r11           ; Pop R11
0052 6AF4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0074                       copy  "dialog.basic.asm"     ; Dialog "Basic"
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
0022 6AF6 0649  14         dect  stack
0023 6AF8 C64B  30         mov   r11,*stack            ; Save return address
0024 6AFA 0649  14         dect  stack
0025 6AFC C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6AFE 0204  20         li    tmp0,id.dialog.basic
     6B00 006B     
0030 6B02 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6B04 A71A     
0031               
0032 6B06 0204  20         li    tmp0,txt.head.basic
     6B08 764A     
0033 6B0A C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6B0C A71E     
0034               
0035 6B0E 0204  20         li    tmp0,pos.info.basic
     6B10 7676     
0036 6B12 C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     6B14 A724     
0037               
0038 6B16 0204  20         li    tmp0,txt.hint.basic
     6B18 767C     
0039 6B1A C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6B1C A722     
0040               
0041 6B1E C120  34         mov   @tibasic.hidesid,tmp0 ; Get 'Hide SID' flag
     6B20 A032     
0042 6B22 1303  14         jeq   !
0043                       ;-------------------------------------------------------
0044                       ; Flag is on
0045                       ;-------------------------------------------------------
0046 6B24 0204  20         li    tmp0,txt.keys.basic2
     6B26 76D2     
0047 6B28 1002  14         jmp   dialog.basic.done
0048                       ;-------------------------------------------------------
0049                       ; Flag is off
0050                       ;-------------------------------------------------------
0051 6B2A 0204  20 !       li    tmp0,txt.keys.basic
     6B2C 76BC     
0052                       ;-------------------------------------------------------
0053                       ; Show dialog
0054                       ;-------------------------------------------------------
0055               dialog.basic.done:
0056 6B2E C804  38         mov   tmp0,@cmdb.pankeys    ; First save Keylist in status line
     6B30 A726     
0057 6B32 06A0  32         bl    @tibasic.buildstr     ; Build session selection string
     6B34 6FC8     
0058 6B36 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6B38 7086     
0059                       ;-------------------------------------------------------
0060                       ; Exit
0061                       ;-------------------------------------------------------
0062               dialog.basic.exit:
0063 6B3A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 6B3C C2F9  30         mov   *stack+,r11           ; Pop R11
0065 6B3E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0075                       ;-----------------------------------------------------------------------
0076                       ; Command buffer handling
0077                       ;-----------------------------------------------------------------------
0078                       copy  "pane.utils.hint.asm" ; Show hint in pane
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
0021 6B40 0649  14         dect  stack
0022 6B42 C64B  30         mov   r11,*stack            ; Save return address
0023 6B44 0649  14         dect  stack
0024 6B46 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6B48 0649  14         dect  stack
0026 6B4A C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6B4C 0649  14         dect  stack
0028 6B4E C646  30         mov   tmp2,*stack           ; Push tmp2
0029 6B50 0649  14         dect  stack
0030 6B52 C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 6B54 C820  54         mov   @parm1,@wyx           ; Set cursor
     6B56 A006     
     6B58 832A     
0035 6B5A C160  34         mov   @parm2,tmp1           ; Get string to display
     6B5C A008     
0036 6B5E 06A0  32         bl    @xutst0               ; Display string
     6B60 2434     
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 6B62 C120  34         mov   @parm2,tmp0
     6B64 A008     
0041 6B66 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 6B68 0984  56         srl   tmp0,8                ; Right justify
0043 6B6A C184  18         mov   tmp0,tmp2
0044 6B6C C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 6B6E 0506  16         neg   tmp2
0046 6B70 0226  22         ai    tmp2,80               ; Number of bytes to fill
     6B72 0050     
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 6B74 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     6B76 A006     
0051 6B78 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 6B7A C804  38         mov   tmp0,@wyx             ; / Set cursor
     6B7C 832A     
0053               
0054 6B7E 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6B80 240E     
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 6B82 0205  20         li    tmp1,32               ; Byte to fill
     6B84 0020     
0059               
0060 6B86 06A0  32         bl    @xfilv                ; Clear line
     6B88 22A8     
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 6B8A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 6B8C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 6B8E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 6B90 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 6B92 C2F9  30         mov   *stack+,r11           ; Pop R11
0073 6B94 045B  20         b     *r11                  ; Return to caller
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
0095 6B96 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     6B98 A006     
0096 6B9A C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     6B9C A008     
0097 6B9E 0649  14         dect  stack
0098 6BA0 C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 6BA2 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6BA4 6B40     
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 6BA6 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 6BA8 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0079                       copy  "pane.cmdb.show.asm"  ; Show command buffer pane
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
0022 6BAA 0649  14         dect  stack
0023 6BAC C64B  30         mov   r11,*stack            ; Save return address
0024 6BAE 0649  14         dect  stack
0025 6BB0 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6BB2 0649  14         dect  stack
0027 6BB4 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6BB6 0649  14         dect  stack
0029 6BB8 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Hide character cursor
0032                       ;------------------------------------------------------
0033 6BBA C820  54         mov   @wyx,@cmdb.fb.yxsave  ; Save YX position in frame buffer
     6BBC 832A     
     6BBE A704     
0034               
0036                       ; Only do this if cursor is a character.
0037                       ; Skip when help dialog is displayed.
0038               
0039 6BC0 C120  34         mov   @cmdb.dialog,tmp0     ; Get dialog ID
     6BC2 A71A     
0040 6BC4 0284  22         ci    tmp0,id.dialog.help
     6BC6 0068     
0041 6BC8 130E  14         jeq   pane.cmdb.show.hidechar.done
0042               
0043 6BCA 06A0  32         bl    @yx2pnt               ; Calculate VDP address from @WYX
     6BCC 240E     
0044                                                   ; \ i  @wyx = Cursor position
0045                                                   ; / o  tmp0 = VDP write address
0046               
0047 6BCE D164  34         movb  @fb.top(tmp0),tmp1    ; Get character underneath cursor
     6BD0 D000     
0048 6BD2 0985  56         srl   tmp1,8                ; Right justify
0049               
0050 6BD4 C1A0  34         mov   @tv.ruler.visible,tmp2
     6BD6 A210     
0051 6BD8 1302  14         jeq   !                     ; Ruler hidden, skip additional offset
0052 6BDA 0224  22         ai    tmp0,80               ; Offset because of ruler
     6BDC 0050     
0053 6BDE 0224  22 !       ai    tmp0,80               ; Offset because of topline
     6BE0 0050     
0054               
0055 6BE2 06A0  32         bl    @xvputb               ; Dump character to VDP
     6BE4 22E0     
0056                                                   ; \ i  tmp0 = VDP write address
0057                                                   ; / i  tmp1 = Byte to write (LSB)
0058               
0059               pane.cmdb.show.hidechar.done:
0060 6BE6 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Restore YX position
     6BE8 A704     
     6BEA 832A     
0062                       ;------------------------------------------------------
0063                       ; Show command buffer pane
0064                       ;------------------------------------------------------
0065 6BEC 0204  20         li    tmp0,pane.botrow
     6BEE 0017     
0066 6BF0 6120  34         s     @cmdb.scrrows,tmp0
     6BF2 A706     
0067 6BF4 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     6BF6 A31A     
0068               
0069 6BF8 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0070 6BFA C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     6BFC A70E     
0071               
0072 6BFE 0224  22         ai    tmp0,>0100
     6C00 0100     
0073 6C02 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     6C04 A710     
0074 6C06 0584  14         inc   tmp0
0075 6C08 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     6C0A A70A     
0076               
0077 6C0C 0720  34         seto  @cmdb.visible         ; Show pane
     6C0E A702     
0078               
0079 6C10 0204  20         li    tmp0,tv.1timeonly     ; \ Set CMDB dirty flag (trigger redraw),
     6C12 00FE     
0080 6C14 C804  38         mov   tmp0,@cmdb.dirty      ; / but colorize CMDB pane only once.
     6C16 A718     
0081               
0082               
0083               
0084 6C18 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     6C1A 0001     
0085 6C1C C804  38         mov   tmp0,@tv.pane.focus   ; /
     6C1E A222     
0086               
0087 6C20 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     6C22 7062     
0088                       ;------------------------------------------------------
0089                       ; Exit
0090                       ;------------------------------------------------------
0091               pane.cmdb.show.exit:
0092 6C24 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0093 6C26 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0094 6C28 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0095 6C2A C2F9  30         mov   *stack+,r11           ; Pop r11
0096 6C2C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0080                       copy  "pane.cmdb.hide.asm"  ; Hide command buffer pane
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
0023 6C2E 0649  14         dect  stack
0024 6C30 C64B  30         mov   r11,*stack            ; Save return address
0025 6C32 0649  14         dect  stack
0026 6C34 C660  46         mov   @parm1,*stack         ; Push @parm1
     6C36 A006     
0027                       ;------------------------------------------------------
0028                       ; Hide command buffer pane
0029                       ;------------------------------------------------------
0030 6C38 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     6C3A A31C     
     6C3C A31A     
0031                       ;------------------------------------------------------
0032                       ; Adjust frame buffer size if error pane visible
0033                       ;------------------------------------------------------
0034 6C3E C820  54         mov   @tv.error.visible,@tv.error.visible
     6C40 A228     
     6C42 A228     
0035 6C44 1302  14         jeq   !
0036 6C46 0620  34         dec   @fb.scrrows
     6C48 A31A     
0037                       ;------------------------------------------------------
0038                       ; Clear error/hint & status line
0039                       ;------------------------------------------------------
0040 6C4A 06A0  32 !       bl    @hchar
     6C4C 27E6     
0041 6C4E 1300                   byte pane.botrow-4,0,32,80*3
     6C50 20F0     
0042 6C52 1600                   byte pane.botrow-1,0,32,80*2
     6C54 20A0     
0043 6C56 FFFF                   data EOL
0044                       ;------------------------------------------------------
0045                       ; Adjust frame buffer size if ruler visible
0046                       ;------------------------------------------------------
0047 6C58 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     6C5A A210     
     6C5C A210     
0048 6C5E 1302  14         jeq   pane.cmdb.hide.rest
0049 6C60 0620  34         dec   @fb.scrrows
     6C62 A31A     
0050                       ;------------------------------------------------------
0051                       ; Hide command buffer pane (rest)
0052                       ;------------------------------------------------------
0053               pane.cmdb.hide.rest:
0054 6C64 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     6C66 A704     
     6C68 832A     
0055 6C6A 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     6C6C A702     
0056 6C6E 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6C70 A316     
0057 6C72 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     6C74 A222     
0058                       ;------------------------------------------------------
0059                       ; Reload current color scheme
0060                       ;------------------------------------------------------
0061 6C76 0720  34         seto  @parm1                ; Do not turn screen off while
     6C78 A006     
0062                                                   ; reloading color scheme
0063 6C7A 04E0  34         clr   @parm2                ; Don't skip colorizing marked lines
     6C7C A008     
0064 6C7E 04E0  34         clr   @parm3                ; Colorize all panes
     6C80 A00A     
0065               
0066 6C82 06A0  32         bl    @pane.action.colorscheme.load
     6C84 70AA     
0067                                                   ; Reload color scheme
0068                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0069                                                   ; | i  @parm2 = Skip colorizing marked lines
0070                                                   ; |             if >FFFF
0071                                                   ; | i  @parm3 = Only colorize CMDB pane
0072                                                   ; /             if >FFFF
0073                       ;------------------------------------------------------
0074                       ; Show cursor again
0075                       ;------------------------------------------------------
0076 6C86 06A0  32         bl    @pane.cursor.blink
     6C88 7074     
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               pane.cmdb.hide.exit:
0081 6C8A C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6C8C A006     
0082 6C8E C2F9  30         mov   *stack+,r11           ; Pop r11
0083 6C90 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0081                       copy  "pane.cmdb.draw.asm"  ; Draw command buffer pane contents
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
0024 6C92 0649  14         dect  stack
0025 6C94 C64B  30         mov   r11,*stack            ; Save return address
0026 6C96 0649  14         dect  stack
0027 6C98 C644  30         mov   tmp0,*stack           ; Push tmp0
0028 6C9A 0649  14         dect  stack
0029 6C9C C645  30         mov   tmp1,*stack           ; Push tmp1
0030                       ;------------------------------------------------------
0031                       ; Command buffer header line
0032                       ;------------------------------------------------------
0033 6C9E C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     6CA0 A71E     
     6CA2 A006     
0034 6CA4 0204  20         li    tmp0,80
     6CA6 0050     
0035 6CA8 C804  38         mov   tmp0,@parm2           ; Set requested length
     6CAA A008     
0036 6CAC 0204  20         li    tmp0,1
     6CAE 0001     
0037 6CB0 C804  38         mov   tmp0,@parm3           ; Set character to fill
     6CB2 A00A     
0038 6CB4 0204  20         li    tmp0,rambuf
     6CB6 A100     
0039 6CB8 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     6CBA A00C     
0040               
0041 6CBC 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     6CBE 32D2     
0042                                                   ; \ i  @parm1 = Pointer to string
0043                                                   ; | i  @parm2 = Requested length
0044                                                   ; | i  @parm3 = Fill character
0045                                                   ; | i  @parm4 = Pointer to buffer with
0046                                                   ; /             output string
0047               
0048 6CC0 06A0  32         bl    @cpym2m
     6CC2 24EE     
0049 6CC4 714C                   data txt.stevie,rambuf+68,13
     6CC6 A144     
     6CC8 000D     
0050                                                   ;
0051                                                   ; Add Stevie banner
0052                                                   ;
0053               
0054 6CCA C820  54         mov   @cmdb.yxtop,@wyx      ; \
     6CCC A70E     
     6CCE 832A     
0055 6CD0 C160  34         mov   @outparm1,tmp1        ; | Display pane header
     6CD2 A016     
0056 6CD4 06A0  32         bl    @xutst0               ; /
     6CD6 2434     
0057                       ;------------------------------------------------------
0058                       ; Check dialog id
0059                       ;------------------------------------------------------
0060 6CD8 04E0  34         clr   @waux1                ; Default is show prompt
     6CDA 833C     
0061               
0062 6CDC C120  34         mov   @cmdb.dialog,tmp0
     6CDE A71A     
0063 6CE0 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     6CE2 0063     
0064 6CE4 121D  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0065 6CE6 0720  34         seto  @waux1                ; /
     6CE8 833C     
0066                       ;------------------------------------------------------
0067                       ; Show info message instead of prompt
0068                       ;------------------------------------------------------
0069 6CEA C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     6CEC A720     
0070 6CEE 1318  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0071               
0072 6CF0 C820  54         mov   @cmdb.paninfo,@parm1  ; Get string to display
     6CF2 A720     
     6CF4 A006     
0073 6CF6 0204  20         li    tmp0,80
     6CF8 0050     
0074 6CFA C804  38         mov   tmp0,@parm2           ; Set requested length
     6CFC A008     
0075 6CFE 0204  20         li    tmp0,32
     6D00 0020     
0076 6D02 C804  38         mov   tmp0,@parm3           ; Set character to fill
     6D04 A00A     
0077 6D06 0204  20         li    tmp0,rambuf
     6D08 A100     
0078 6D0A C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     6D0C A00C     
0079               
0080 6D0E 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     6D10 32D2     
0081                                                   ; \ i  @parm1 = Pointer to string
0082                                                   ; | i  @parm2 = Requested length
0083                                                   ; | i  @parm3 = Fill character
0084                                                   ; | i  @parm4 = Pointer to buffer with
0085                                                   ; /             output string
0086               
0087 6D12 06A0  32         bl    @at
     6D14 26DA     
0088 6D16 1400                   byte pane.botrow-3,0  ; Position cursor
0089               
0090 6D18 C160  34         mov   @outparm1,tmp1        ; \ Display pane header
     6D1A A016     
0091 6D1C 06A0  32         bl    @xutst0               ; /
     6D1E 2434     
0092                       ;------------------------------------------------------
0093                       ; Clear lines after prompt in command buffer
0094                       ;------------------------------------------------------
0095               pane.cmdb.draw.clear:
0096 6D20 06A0  32         bl    @hchar
     6D22 27E6     
0097 6D24 1500                   byte pane.botrow-2,0,32,80
     6D26 2050     
0098 6D28 FFFF                   data EOL              ; Remove key markers
0099                       ;------------------------------------------------------
0100                       ; Show key markers ?
0101                       ;------------------------------------------------------
0102 6D2A C120  34         mov   @cmdb.panmarkers,tmp0
     6D2C A724     
0103 6D2E 1310  14         jeq   pane.cmdb.draw.hint   ; no, skip key markers
0104                       ;------------------------------------------------------
0105                       ; Loop over key marker list
0106                       ;------------------------------------------------------
0107               pane.cmdb.draw.marker.loop:
0108 6D30 D174  28         movb  *tmp0+,tmp1           ; Get X position
0109 6D32 0985  56         srl   tmp1,8                ; Right align
0110 6D34 0285  22         ci    tmp1,>00ff            ; End of list reached?
     6D36 00FF     
0111 6D38 130B  14         jeq   pane.cmdb.draw.hint   ; Yes, exit loop
0112               
0113 6D3A 0265  22         ori   tmp1,(pane.botrow - 2) * 256
     6D3C 1500     
0114                                                   ; y=bottom row - 3, x=(key marker position)
0115 6D3E C805  38         mov   tmp1,@wyx             ; Set cursor position
     6D40 832A     
0116               
0117 6D42 0649  14         dect  stack
0118 6D44 C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 6D46 06A0  32         bl    @putstr
     6D48 2432     
0121 6D4A 3886                   data txt.keymarker    ; Show key marker
0122               
0123 6D4C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124                       ;------------------------------------------------------
0125                       ; Show marker
0126                       ;------------------------------------------------------
0127 6D4E 10F0  14         jmp   pane.cmdb.draw.marker.loop
0128                                                   ; Next iteration
0129                       ;------------------------------------------------------
0130                       ; Display pane hint in command buffer
0131                       ;------------------------------------------------------
0132               pane.cmdb.draw.hint:
0133 6D50 0204  20         li    tmp0,pane.botrow - 1  ; \
     6D52 0016     
0134 6D54 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0135 6D56 C804  38         mov   tmp0,@parm1           ; Set parameter
     6D58 A006     
0136 6D5A C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     6D5C A722     
     6D5E A008     
0137               
0138 6D60 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6D62 6B40     
0139                                                   ; \ i  parm1 = Pointer to string with hint
0140                                                   ; / i  parm2 = YX position
0141                       ;------------------------------------------------------
0142                       ; Display keys in status line
0143                       ;------------------------------------------------------
0144 6D64 0204  20         li    tmp0,pane.botrow      ; \
     6D66 0017     
0145 6D68 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0146 6D6A C804  38         mov   tmp0,@parm1           ; Set parameter
     6D6C A006     
0147 6D6E C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     6D70 A726     
     6D72 A008     
0148               
0149 6D74 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6D76 6B40     
0150                                                   ; \ i  parm1 = Pointer to string with hint
0151                                                   ; / i  parm2 = YX position
0152                       ;------------------------------------------------------
0153                       ; ALPHA-Lock key down?
0154                       ;------------------------------------------------------
0155 6D78 20A0  38         coc   @wbit10,config
     6D7A 200C     
0156 6D7C 1306  14         jeq   pane.cmdb.draw.alpha.down
0157                       ;------------------------------------------------------
0158                       ; AlPHA-Lock is up
0159                       ;------------------------------------------------------
0160 6D7E 06A0  32         bl    @hchar
     6D80 27E6     
0161 6D82 174E                   byte pane.botrow,78,32,2
     6D84 2002     
0162 6D86 FFFF                   data eol
0163               
0164 6D88 1004  14         jmp   pane.cmdb.draw.promptcmd
0165                       ;------------------------------------------------------
0166                       ; AlPHA-Lock is down
0167                       ;------------------------------------------------------
0168               pane.cmdb.draw.alpha.down:
0169 6D8A 06A0  32         bl    @putat
     6D8C 2456     
0170 6D8E 174E                   byte   pane.botrow,78
0171 6D90 3880                   data   txt.alpha.down
0172                       ;------------------------------------------------------
0173                       ; Command buffer content
0174                       ;------------------------------------------------------
0175               pane.cmdb.draw.promptcmd:
0176 6D92 C120  34         mov   @waux1,tmp0           ; Flag set?
     6D94 833C     
0177 6D96 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0178 6D98 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     6D9A 6DD6     
0179                       ;------------------------------------------------------
0180                       ; Exit
0181                       ;------------------------------------------------------
0182               pane.cmdb.draw.exit:
0183 6D9C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0184 6D9E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0185 6DA0 C2F9  30         mov   *stack+,r11           ; Pop r11
0186 6DA2 045B  20         b     *r11                  ; Return
                   < stevie_b3.asm.68345
0082                       copy  "error.display.asm"   ; Show error message
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
0018 6DA4 0649  14         dect  stack
0019 6DA6 C64B  30         mov   r11,*stack            ; Save return address
0020 6DA8 0649  14         dect  stack
0021 6DAA C644  30         mov   tmp0,*stack           ; Push tmp0
0022 6DAC 0649  14         dect  stack
0023 6DAE C645  30         mov   tmp1,*stack           ; Push tmp1
0024 6DB0 0649  14         dect  stack
0025 6DB2 C646  30         mov   tmp2,*stack           ; Push tmp2
0026                       ;------------------------------------------------------
0027                       ; Display error message
0028                       ;------------------------------------------------------
0029 6DB4 C120  34         mov   @parm1,tmp0           ; \ Get length of string
     6DB6 A006     
0030 6DB8 D194  26         movb  *tmp0,tmp2            ; |
0031 6DBA 0986  56         srl   tmp2,8                ; / Right align
0032               
0033 6DBC C120  34         mov   @parm1,tmp0           ; Get error message
     6DBE A006     
0034 6DC0 0205  20         li    tmp1,tv.error.msg     ; Set error message
     6DC2 A22E     
0035               
0036 6DC4 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     6DC6 24F4     
0037                                                   ; \ i  tmp0 = Source CPU memory address
0038                                                   ; | i  tmp1 = Target CPU memory address
0039                                                   ; / i  tmp2 = Number of bytes to copy
0040               
0041 6DC8 06A0  32         bl    @pane.errline.show    ; Display error message
     6DCA 7098     
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               error.display.exit:
0046 6DCC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 6DCE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 6DD0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 6DD2 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 6DD4 045B  20         b     *r11                  ; Return
                   < stevie_b3.asm.68345
0083                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
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
0022 6DD6 0649  14         dect  stack
0023 6DD8 C64B  30         mov   r11,*stack            ; Save return address
0024 6DDA 0649  14         dect  stack
0025 6DDC C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6DDE 0649  14         dect  stack
0027 6DE0 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6DE2 0649  14         dect  stack
0029 6DE4 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6DE6 0649  14         dect  stack
0031 6DE8 C660  46         mov   @wyx,*stack           ; Push cursor position
     6DEA 832A     
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 6DEC C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6DEE A710     
     6DF0 832A     
0036               
0037 6DF2 05A0  34         inc   @wyx                  ; X +1 for prompt
     6DF4 832A     
0038               
0039 6DF6 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6DF8 240E     
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 6DFA 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6DFC A72B     
0044 6DFE 0206  20         li    tmp2,1*79             ; Command length
     6E00 004F     
0045               
0046 6E02 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6E04 24A0     
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 6E06 C820  54         mov   @cmdb.yxprompt,@wyx
     6E08 A710     
     6E0A 832A     
0054 6E0C 06A0  32         bl    @putstr
     6E0E 2432     
0055 6E10 395A                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 6E12 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     6E14 832A     
0061 6E16 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 6E18 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 6E1A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 6E1C C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6E1E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0084                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0022 6E20 0649  14         dect  stack
0023 6E22 C64B  30         mov   r11,*stack            ; Save return address
0024 6E24 0649  14         dect  stack
0025 6E26 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6E28 0649  14         dect  stack
0027 6E2A C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6E2C 0649  14         dect  stack
0029 6E2E C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 6E30 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6E32 A72A     
0034 6E34 06A0  32         bl    @film                 ; Clear command
     6E36 224A     
0035 6E38 A72B                   data  cmdb.cmd,>00,80
     6E3A 0000     
     6E3C 0050     
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 6E3E C120  34         mov   @cmdb.yxprompt,tmp0
     6E40 A710     
0040 6E42 0584  14         inc   tmp0
0041 6E44 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6E46 A70A     
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 6E48 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 6E4A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 6E4C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 6E4E C2F9  30         mov   *stack+,r11           ; Pop r11
0050 6E50 045B  20         b     *r11                  ; Return to caller
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
0075 6E52 0649  14         dect  stack
0076 6E54 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 6E56 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6E58 2AAE     
0081 6E5A A72B                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6E5C 0000     
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 6E5E C820  54         mov   @waux1,@outparm1     ; Save length of string
     6E60 833C     
     6E62 A016     
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 6E64 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6E66 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0085                       copy  "cmdb.cmd.set.asm"    ; Set command line to preset value
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
0022 6E68 0649  14         dect  stack
0023 6E6A C64B  30         mov   r11,*stack            ; Save return address
0024 6E6C 0649  14         dect  stack
0025 6E6E C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6E70 0649  14         dect  stack
0027 6E72 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6E74 0649  14         dect  stack
0029 6E76 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 6E78 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6E7A A72A     
0034 6E7C 06A0  32         bl    @film                 ; Clear command
     6E7E 224A     
0035 6E80 A72B                   data  cmdb.cmd,>00,80
     6E82 0000     
     6E84 0050     
0036                       ;------------------------------------------------------
0037                       ; Get string length
0038                       ;------------------------------------------------------
0039 6E86 C120  34         mov   @parm1,tmp0
     6E88 A006     
0040 6E8A D1B4  28         movb  *tmp0+,tmp2           ; Get length byte
0041 6E8C 0986  56         srl   tmp2,8                ; Right align
0042 6E8E 1501  14         jgt   !
0043                       ;------------------------------------------------------
0044                       ; Assert: invalid length, we just exit here
0045                       ;------------------------------------------------------
0046 6E90 100B  14         jmp   cmdb.cmd.set.exit     ; No harm done
0047                       ;------------------------------------------------------
0048                       ; Copy string to command
0049                       ;------------------------------------------------------
0050 6E92 0205  20 !       li   tmp1,cmdb.cmd          ; Destination
     6E94 A72B     
0051 6E96 06A0  32         bl   @xpym2m                ; Copy string
     6E98 24F4     
0052                       ;------------------------------------------------------
0053                       ; Put cursor at beginning of line
0054                       ;------------------------------------------------------
0055 6E9A C120  34         mov   @cmdb.yxprompt,tmp0
     6E9C A710     
0056 6E9E 0584  14         inc   tmp0
0057 6EA0 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6EA2 A70A     
0058               
0059 6EA4 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     6EA6 A718     
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063               cmdb.cmd.set.exit:
0064 6EA8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0065 6EAA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 6EAC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 6EAE C2F9  30         mov   *stack+,r11           ; Pop r11
0068 6EB0 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0086                       copy  "cmdb.cmd.preset.asm" ; Preset shortcuts in dialogs
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
0018 6EB2 0649  14         dect  stack
0019 6EB4 C64B  30         mov   r11,*stack            ; Save return address
0020 6EB6 0649  14         dect  stack
0021 6EB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0022 6EBA 0649  14         dect  stack
0023 6EBC C645  30         mov   tmp1,*stack           ; Push tmp1
0024 6EBE 0649  14         dect  stack
0025 6EC0 C646  30         mov   tmp2,*stack           ; Push tmp2
0026               
0027 6EC2 0204  20         li    tmp0,cmdb.cmd.preset.data
     6EC4 770E     
0028                                                   ; Load table
0029 6EC6 C1A0  34         mov   @keycode1,tmp2        ; Get keyboard code
     6EC8 A028     
0030                       ;-------------------------------------------------------
0031                       ; Loop over table with presets
0032                       ;-------------------------------------------------------
0033               cmdb.cmd.preset.loop:
0034 6ECA 8834  50         c     *tmp0+,@cmdb.dialog   ; Dialog matches?
     6ECC A71A     
0035 6ECE 1607  14         jne   cmdb.cmd.preset.next  ; No, next entry
0036                       ;-------------------------------------------------------
0037                       ; Dialog matches, check if shortcut matches
0038                       ;-------------------------------------------------------
0039 6ED0 81B4  30         c     *tmp0+,tmp2           ; Compare with keyboard shortcut
0040 6ED2 1606  14         jne   !                     ; No match, next entry
0041                       ;-------------------------------------------------------
0042                       ; Entry in table matches, set preset
0043                       ;-------------------------------------------------------
0044 6ED4 C814  46         mov   *tmp0,@parm1          ; Get pointer to string
     6ED6 A006     
0045               
0046 6ED8 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6EDA 6E68     
0047                                                   ; \ i  @parm1 = Pointer to string w. preset
0048                                                   ; /
0049               
0050 6EDC 1006  14         jmp   cmdb.cmd.preset.exit  ; Exit
0051                       ;-------------------------------------------------------
0052                       ; Dialog does not match, prepare for next entry
0053                       ;-------------------------------------------------------
0054               cmdb.cmd.preset.next:
0055 6EDE 05C4  14         inct  tmp0                  ; Skip shortcut
0056 6EE0 05C4  14 !       inct  tmp0                  ; Skip pointer to string
0057                       ;-------------------------------------------------------
0058                       ; End of list reached?
0059                       ;-------------------------------------------------------
0060 6EE2 C154  26         mov   *tmp0,tmp1            ; Get entry
0061 6EE4 0285  22         ci    tmp1,EOL              ; EOL identifier found?
     6EE6 FFFF     
0062 6EE8 16F0  14         jne   cmdb.cmd.preset.loop  ; Not yet, next entry
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               cmdb.cmd.preset.exit:
0067 6EEA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0068 6EEC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0069 6EEE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 6EF0 C2F9  30         mov   *stack+,r11           ; Pop r11
0071 6EF2 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0087                       ;-----------------------------------------------------------------------
0088                       ; Dialog toggles
0089                       ;-----------------------------------------------------------------------
0090                       copy  "fm.fastmode.asm"     ; Toggle fastmode on/off for file operation
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
0020 6EF4 0649  14         dect  stack
0021 6EF6 C64B  30         mov   r11,*stack            ; Save return address
0022 6EF8 0649  14         dect  stack
0023 6EFA C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6EFC 0649  14         dect  stack
0025 6EFE C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6F00 0649  14         dect  stack
0027 6F02 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Toggle fastmode
0030                       ;------------------------------------------------------
0031 6F04 C160  34         mov   @cmdb.dialog,tmp1     ; Get ID of current dialog
     6F06 A71A     
0032 6F08 C120  34         mov   @fh.offsetopcode,tmp0 ; Get file opcode offset
     6F0A A44E     
0033 6F0C 1322  14         jeq   fm.fastmode.on        ; Toggle on if offset is 0
0034                       ;------------------------------------------------------
0035                       ; Turn fast mode off
0036                       ;------------------------------------------------------
0037               fm.fastmode.off:
0038 6F0E 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     6F10 A44E     
0039               
0040 6F12 0206  20         li    tmp2,id.dialog.load
     6F14 000A     
0041 6F16 8185  18         c     tmp1,tmp2
0042 6F18 1310  14         jeq   fm.fastmode.off.1
0043               
0044 6F1A 0206  20         li    tmp2,id.dialog.insert
     6F1C 000D     
0045 6F1E 8185  18         c     tmp1,tmp2
0046 6F20 130F  14         jeq   fm.fastmode.off.2
0047               
0048 6F22 0206  20         li    tmp2,id.dialog.clipboard
     6F24 0067     
0049 6F26 8185  18         c     tmp1,tmp2
0050 6F28 130E  14         jeq   fm.fastmode.off.3
0051               
0052 6F2A 0206  20         li    tmp2,id.dialog.append
     6F2C 000E     
0053 6F2E 8185  18         c     tmp1,tmp2
0054 6F30 130D  14         jeq   fm.fastmode.off.4
0055                       ;------------------------------------------------------
0056                       ; Assert
0057                       ;------------------------------------------------------
0058 6F32 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F34 FFCE     
0059 6F36 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F38 2026     
0060                       ;------------------------------------------------------
0061                       ; Keylist fastmode off
0062                       ;------------------------------------------------------
0063               fm.fastmode.off.1:
0064 6F3A 0204  20         li    tmp0,txt.keys.load
     6F3C 715A     
0065 6F3E 102C  14         jmp   fm.fastmode.keylist
0066               fm.fastmode.off.2:
0067 6F40 0204  20         li    tmp0,txt.keys.insert
     6F42 715A     
0068 6F44 1029  14         jmp   fm.fastmode.keylist
0069               fm.fastmode.off.3:
0070 6F46 0204  20         li    tmp0,txt.keys.clipboard
     6F48 73AC     
0071 6F4A 1026  14         jmp   fm.fastmode.keylist
0072               fm.fastmode.off.4:
0073 6F4C 0204  20         li    tmp0,txt.keys.append
     6F4E 715A     
0074 6F50 1023  14         jmp   fm.fastmode.keylist
0075                       ;------------------------------------------------------
0076                       ; Turn fast mode on
0077                       ;------------------------------------------------------
0078               fm.fastmode.on:
0079 6F52 0204  20         li    tmp0,>40              ; Data buffer in CPU RAM
     6F54 0040     
0080 6F56 C804  38         mov   tmp0,@fh.offsetopcode
     6F58 A44E     
0081               
0082 6F5A 0206  20         li    tmp2,id.dialog.load
     6F5C 000A     
0083 6F5E 8185  18         c     tmp1,tmp2
0084 6F60 1310  14         jeq   fm.fastmode.on.1
0085               
0086 6F62 0206  20         li    tmp2,id.dialog.insert
     6F64 000D     
0087 6F66 8185  18         c     tmp1,tmp2
0088 6F68 130F  14         jeq   fm.fastmode.on.2
0089               
0090 6F6A 0206  20         li    tmp2,id.dialog.clipboard
     6F6C 0067     
0091 6F6E 8185  18         c     tmp1,tmp2
0092 6F70 130E  14         jeq   fm.fastmode.on.3
0093               
0094 6F72 0206  20         li    tmp2,id.dialog.append
     6F74 000E     
0095 6F76 8185  18         c     tmp1,tmp2
0096 6F78 130D  14         jeq   fm.fastmode.on.4
0097                       ;------------------------------------------------------
0098                       ; Assert
0099                       ;------------------------------------------------------
0100 6F7A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F7C FFCE     
0101 6F7E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F80 2026     
0102                       ;------------------------------------------------------
0103                       ; Keylist fastmode on
0104                       ;------------------------------------------------------
0105               fm.fastmode.on.1:
0106 6F82 0204  20         li    tmp0,txt.keys.load2
     6F84 717A     
0107 6F86 1008  14         jmp   fm.fastmode.keylist
0108               fm.fastmode.on.2:
0109 6F88 0204  20         li    tmp0,txt.keys.insert2
     6F8A 717A     
0110 6F8C 1005  14         jmp   fm.fastmode.keylist
0111               fm.fastmode.on.3:
0112 6F8E 0204  20         li    tmp0,txt.keys.clipboard2
     6F90 73D0     
0113 6F92 1002  14         jmp   fm.fastmode.keylist
0114               fm.fastmode.on.4:
0115 6F94 0204  20         li    tmp0,txt.keys.append2
     6F96 717A     
0116                       ;------------------------------------------------------
0117                       ; Set keylist
0118                       ;------------------------------------------------------
0119               fm.fastmode.keylist:
0120 6F98 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6F9A A726     
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               fm.fastmode.exit:
0125 6F9C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 6F9E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 6FA0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 6FA2 C2F9  30         mov   *stack+,r11           ; Pop R11
0129 6FA4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0091                       copy  "tibasic.helper.asm"  ; Helper functions for TI Basic dialog
     **** ****     > tibasic.helper.asm
0001               * FILE......: tibasic.helper.asm
0002               * Purpose...: TI Basic dialog helper functions
0003               
0004               
0005               
0006               ***************************************************************
0007               * tibasic.sid
0008               * Toggle TI Basic SID display
0009               ***************************************************************
0010               * bl   @tibasic.sid.toggle
0011               *--------------------------------------------------------------
0012               * INPUT
0013               * none
0014               *
0015               * OUTPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0
0020               *--------------------------------------------------------------
0021               * Remarks
0022               * none
0023               ********|*****|*********************|**************************
0024               tibasic.sid.toggle:
0025 6FA6 0649  14         dect  stack
0026 6FA8 C64B  30         mov   r11,*stack            ; Save return address
0027 6FAA 0649  14         dect  stack
0028 6FAC C644  30         mov   tmp0,*stack           ; Push tmp0
0029                       ;------------------------------------------------------
0030                       ; Toggle SID display
0031                       ;------------------------------------------------------
0032 6FAE 0560  34         inv   @tibasic.hidesid      ; Toggle 'Hide SID'
     6FB0 A032     
0033 6FB2 1303  14         jeq   tibasic.sid.off
0034 6FB4 0204  20         li    tmp0,txt.keys.basic2
     6FB6 76D2     
0035 6FB8 1002  14         jmp   !
0036               tibasic.sid.off:
0037 6FBA 0204  20         li    tmp0,txt.keys.basic
     6FBC 76BC     
0038 6FBE C804  38 !       mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6FC0 A726     
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042               tibasic.sid.exit:
0043 6FC2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0044 6FC4 C2F9  30         mov   *stack+,r11           ; Pop r11
0045 6FC6 045B  20         b     *r11                  ; Return
0046               
0047               
0048               
0049               
0050               ***************************************************************
0051               * tibasic.buildstr
0052               * Build session picker string for TI Basic dialog
0053               ***************************************************************
0054               * bl   @tibasic.buildstr
0055               *--------------------------------------------------------------
0056               * INPUT
0057               * none
0058               *
0059               * OUTPUT
0060               * none
0061               *--------------------------------------------------------------
0062               * Register usage
0063               * tmp0
0064               *--------------------------------------------------------------
0065               * Remarks
0066               * none
0067               ********|*****|*********************|**************************
0068               tibasic.buildstr:
0069 6FC8 0649  14         dect  stack
0070 6FCA C64B  30         mov   r11,*stack            ; Save return address
0071 6FCC 0649  14         dect  stack
0072 6FCE C644  30         mov   tmp0,*stack           ; Push tmp0
0073 6FD0 0649  14         dect  stack
0074 6FD2 C645  30         mov   tmp1,*stack           ; Push tmp1
0075 6FD4 0649  14         dect  stack
0076 6FD6 C646  30         mov   tmp2,*stack           ; Push tmp2
0077 6FD8 0649  14         dect  stack
0078 6FDA C647  30         mov   tmp3,*stack           ; Push tmp3
0079                       ;-------------------------------------------------------
0080                       ; Build session selection string
0081                       ;-------------------------------------------------------
0082 6FDC 06A0  32         bl    @cpym2m
     6FDE 24EE     
0083 6FE0 7658                   data txt.info.basic,rambuf+200,28
     6FE2 A1C8     
     6FE4 001C     
0084                                                   ; Copy string from rom to ram buffer
0085               
0086 6FE6 0204  20         li    tmp0,rambuf + 200     ; \
     6FE8 A1C8     
0087 6FEA C804  38         mov   tmp0,@cmdb.paninfo    ; / Set pointer to session selection string
     6FEC A720     
0088               
0089 6FEE 0204  20         li    tmp0,tibasic1.status  ; First TI Basic session to check
     6FF0 A036     
0090 6FF2 0206  20         li    tmp2,tibasic5.status  ; Last TI Basic session to check
     6FF4 A03E     
0091 6FF6 0207  20         li    tmp3,rambuf + 212     ; Position in session selection string
     6FF8 A1D4     
0092                       ;-------------------------------------------------------
0093                       ; Loop over TI Basic sessions and check if active
0094                       ;-------------------------------------------------------
0095               tibasic.buildstr.loop:
0096 6FFA C174  30         mov   *tmp0+,tmp1           ; Session active?
0097 6FFC 1302  14         jeq   tibasic.buildstr.next
0098                                                   ; No, check next session
0099                       ;-------------------------------------------------------
0100                       ; Set Basic session active marker
0101                       ;-------------------------------------------------------
0102 6FFE D5E0  46         movb  @tibasic.buildstr.data.marker,*tmp3
     7000 7018     
0103                                                   ; Set marker
0104                       ;-------------------------------------------------------
0105                       ; Next entry
0106                       ;-------------------------------------------------------
0107               tibasic.buildstr.next:
0108 7002 0227  22         ai    tmp3,4                ; Next position
     7004 0004     
0109 7006 8184  18         c     tmp0,tmp2             ; All sessions checked?
0110 7008 1501  14         jgt   tibasic.buildstr.exit ; Yes, exit loop
0111 700A 10F7  14         jmp   tibasic.buildstr.loop ; No, next iteration
0112                       ;-------------------------------------------------------
0113                       ; Exit
0114                       ;-------------------------------------------------------
0115               tibasic.buildstr.exit:
0116 700C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0117 700E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0118 7010 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0119 7012 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0120 7014 C2F9  30         mov   *stack+,r11           ; Pop R11
0121 7016 045B  20         b     *r11                  ; Return to caller
0122               
0123               tibasic.buildstr.data.marker:
0124 7018 2A00            data   >2a00                 ; ASCII 42 (*)
                   < stevie_b3.asm.68345
0092                       ;-----------------------------------------------------------------------
0093                       ; Stubs
0094                       ;-----------------------------------------------------------------------
0095                       copy  "rom.stubs.bank3.asm" ; Bank specific stubs
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
0010 701A 0649  14         dect  stack
0011 701C C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Call function in bank 1
0014                       ;------------------------------------------------------
0015 701E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7020 2F84     
0016 7022 6002                   data bank1.rom        ; | i  p0 = bank address
0017 7024 7FD2                   data vec.10           ; | i  p1 = Vector with target address
0018 7026 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 7028 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 702A 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "edkey.action.cmdb.show"
0028               * bank1 vec.15
0029               ********|*****|*********************|**************************
0030               edkey.action.cmdb.show:
0031 702C 0649  14         dect  stack
0032 702E C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Call function in bank 1
0035                       ;------------------------------------------------------
0036 7030 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7032 2F84     
0037 7034 6002                   data bank1.rom        ; | i  p0 = bank address
0038 7036 7FDC                   data vec.15           ; | i  p1 = Vector with target address
0039 7038 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0040                       ;------------------------------------------------------
0041                       ; Exit
0042                       ;------------------------------------------------------
0043 703A C2F9  30         mov   *stack+,r11           ; Pop r11
0044 703C 045B  20         b     *r11                  ; Return to caller
0045               
0046               
0047               ***************************************************************
0048               * Stub for "fb.refresh"
0049               * bank1 vec.20
0050               ********|*****|*********************|**************************
0051               fb.refresh:
0052 703E 0649  14         dect  stack
0053 7040 C64B  30         mov   r11,*stack            ; Save return address
0054                       ;------------------------------------------------------
0055                       ; Call function in bank 1
0056                       ;------------------------------------------------------
0057 7042 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7044 2F84     
0058 7046 6002                   data bank1.rom        ; | i  p0 = bank address
0059 7048 7FE6                   data vec.20           ; | i  p1 = Vector with target address
0060 704A 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064 704C C2F9  30         mov   *stack+,r11           ; Pop r11
0065 704E 045B  20         b     *r11                  ; Return to caller
0066               
0067               
0068               ***************************************************************
0069               * Stub for "fb.row2line"
0070               * bank1 vec.22
0071               ********|*****|*********************|**************************
0072               fb.row2line:
0073 7050 0649  14         dect  stack
0074 7052 C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Call function in bank 1
0077                       ;------------------------------------------------------
0078 7054 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7056 2F84     
0079 7058 6002                   data bank1.rom        ; | i  p0 = bank address
0080 705A 7FEA                   data vec.22           ; | i  p1 = Vector with target address
0081 705C 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085 705E C2F9  30         mov   *stack+,r11           ; Pop r11
0086 7060 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               
0090               ***************************************************************
0091               * Stub for "pane.errline.hide"
0092               * bank1 vec.27
0093               ********|*****|*********************|**************************
0094               pane.errline.hide:
0095 7062 0649  14         dect  stack
0096 7064 C64B  30         mov   r11,*stack            ; Save return address
0097                       ;------------------------------------------------------
0098                       ; Call function in bank 1
0099                       ;------------------------------------------------------
0100 7066 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7068 2F84     
0101 706A 6002                   data bank1.rom        ; | i  p0 = bank address
0102 706C 7FF4                   data vec.27           ; | i  p1 = Vector with target address
0103 706E 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0104                       ;------------------------------------------------------
0105                       ; Exit
0106                       ;------------------------------------------------------
0107 7070 C2F9  30         mov   *stack+,r11           ; Pop r11
0108 7072 045B  20         b     *r11                  ; Return to caller
0109               
0110               
0111               
0112               ***************************************************************
0113               * Stub for "pane.cursor.blink"
0114               * bank1 vec.28
0115               ********|*****|*********************|**************************
0116               pane.cursor.blink:
0117 7074 0649  14         dect  stack
0118 7076 C64B  30         mov   r11,*stack            ; Save return address
0119                       ;------------------------------------------------------
0120                       ; Call function in bank 1
0121                       ;------------------------------------------------------
0122 7078 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     707A 2F84     
0123 707C 6002                   data bank1.rom        ; | i  p0 = bank address
0124 707E 7FF6                   data vec.28           ; | i  p1 = Vector with target address
0125 7080 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0126                       ;------------------------------------------------------
0127                       ; Exit
0128                       ;------------------------------------------------------
0129 7082 C2F9  30         mov   *stack+,r11           ; Pop r11
0130 7084 045B  20         b     *r11                  ; Return to caller
0131               
0132               
0133               ***************************************************************
0134               * Stub for "pane.cursor.hide"
0135               * bank1 vec.29
0136               ********|*****|*********************|**************************
0137               pane.cursor.hide:
0138 7086 0649  14         dect  stack
0139 7088 C64B  30         mov   r11,*stack            ; Save return address
0140                       ;------------------------------------------------------
0141                       ; Call function in bank 1
0142                       ;------------------------------------------------------
0143 708A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     708C 2F84     
0144 708E 6002                   data bank1.rom        ; | i  p0 = bank address
0145 7090 7FF8                   data vec.29           ; | i  p1 = Vector with target address
0146 7092 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150 7094 C2F9  30         mov   *stack+,r11           ; Pop r11
0151 7096 045B  20         b     *r11                  ; Return to caller
0152               
0153               
0154               ***************************************************************
0155               * Stub for "pane.errline.show"
0156               * bank1 vec.30
0157               ********|*****|*********************|**************************
0158               pane.errline.show:
0159 7098 0649  14         dect  stack
0160 709A C64B  30         mov   r11,*stack            ; Save return address
0161                       ;------------------------------------------------------
0162                       ; Call function in bank 1
0163                       ;------------------------------------------------------
0164 709C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     709E 2F84     
0165 70A0 6002                   data bank1.rom        ; | i  p0 = bank address
0166 70A2 7FFA                   data vec.30           ; | i  p1 = Vector with target address
0167 70A4 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171 70A6 C2F9  30         mov   *stack+,r11           ; Pop r11
0172 70A8 045B  20         b     *r11                  ; Return to caller
0173               
0174               
0175               ***************************************************************
0176               * Stub for "pane.action.colorscheme.load"
0177               * bank1 vec.31
0178               ********|*****|*********************|**************************
0179               pane.action.colorscheme.load:
0180 70AA 0649  14         dect  stack
0181 70AC C64B  30         mov   r11,*stack            ; Save return address
0182                       ;------------------------------------------------------
0183                       ; Call function in bank 1
0184                       ;------------------------------------------------------
0185 70AE 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     70B0 2F84     
0186 70B2 6002                   data bank1.rom        ; | i  p0 = bank address
0187 70B4 7FFC                   data vec.31           ; | i  p1 = Vector with target address
0188 70B6 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0189                       ;------------------------------------------------------
0190                       ; Exit
0191                       ;------------------------------------------------------
0192 70B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0193 70BA 045B  20         b     *r11                  ; Return to caller
0194               
0195               
0196               ***************************************************************
0197               * Stub for "fb.scan.fname"
0198               * bank4 vec.5
0199               ********|*****|*********************|**************************
0200               fb.scan.fname:
0201 70BC 0649  14         dect  stack
0202 70BE C64B  30         mov   r11,*stack            ; Save return address
0203                       ;------------------------------------------------------
0204                       ; Call function in bank 4
0205                       ;------------------------------------------------------
0206 70C0 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     70C2 2F84     
0207 70C4 6008                   data bank4.rom        ; | i  p0 = bank address
0208 70C6 7FC8                   data vec.5            ; | i  p1 = Vector with target address
0209 70C8 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0210                       ;------------------------------------------------------
0211                       ; Exit
0212                       ;------------------------------------------------------
0213 70CA C2F9  30         mov   *stack+,r11           ; Pop r11
0214 70CC 045B  20         b     *r11                  ; Return to caller
0215               
0216               
0217               ***************************************************************
0218               
0219               ; TODO Include _trampoline.bank1.ret
0220               ; TODO Refactor stubs for using _trampoline.bank1.ret
                   < stevie_b3.asm.68345
0096                       copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks > 0
     **** ****     > rom.stubs.bankx.asm
0001               * FILE......: rom.stubs.bankx.asm
0002               * Purpose...: Stubs to include in all banks > 0
0003               
0004               
0006               ***************************************************************
0007               * Stub for "mem.sams.setup.stevie"
0008               * bank1 vec.1
0009               ********|*****|*********************|**************************
0010               mem.sams.setup.stevie:
0011 70CE 0649  14         dect  stack
0012 70D0 C64B  30         mov   r11,*stack            ; Save return address
0013                       ;------------------------------------------------------
0014                       ; Call function in bank 1
0015                       ;------------------------------------------------------
0016 70D2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     70D4 2F84     
0017 70D6 6002                   data bank1.rom        ; | i  p0 = bank address
0018 70D8 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0019 70DA 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0020                       ;------------------------------------------------------
0021                       ; Exit
0022                       ;------------------------------------------------------
0023 70DC C2F9  30         mov   *stack+,r11           ; Pop r11
0024 70DE 045B  20         b     *r11                  ; Return to caller
0026               
0027               
0029               ***************************************************************
0030               * Stub for "mem.sams.set.legacy"
0031               * bank7 vec.1
0032               ********|*****|*********************|**************************
0033               mem.sams.set.legacy:
0034 70E0 0649  14         dect  stack
0035 70E2 C64B  30         mov   r11,*stack            ; Save return address
0036                       ;------------------------------------------------------
0037                       ; Dump VDP patterns
0038                       ;------------------------------------------------------
0039 70E4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     70E6 2F84     
0040 70E8 600E                   data bank7.rom        ; | i  p0 = bank address
0041 70EA 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0042 70EC 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0043                       ;------------------------------------------------------
0044                       ; Exit
0045                       ;------------------------------------------------------
0046 70EE C2F9  30         mov   *stack+,r11           ; Pop r11
0047 70F0 045B  20         b     *r11                  ; Return to caller
0049               
0050               
0052               ***************************************************************
0053               * Stub for "mem.sams.set.boot"
0054               * bank7 vec.2
0055               ********|*****|*********************|**************************
0056               mem.sams.set.boot:
0057 70F2 0649  14         dect  stack
0058 70F4 C64B  30         mov   r11,*stack            ; Save return address
0059                       ;------------------------------------------------------
0060                       ; Dump VDP patterns
0061                       ;------------------------------------------------------
0062 70F6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     70F8 2F84     
0063 70FA 600E                   data bank7.rom        ; | i  p0 = bank address
0064 70FC 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0065 70FE 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069 7100 C2F9  30         mov   *stack+,r11           ; Pop r11
0070 7102 045B  20         b     *r11                  ; Return to caller
0072               
0073               
0075               ***************************************************************
0076               * Stub for "mem.sams.set.stevie"
0077               * bank7 vec.3
0078               ********|*****|*********************|**************************
0079               mem.sams.set.stevie:
0080 7104 0649  14         dect  stack
0081 7106 C64B  30         mov   r11,*stack            ; Save return address
0082                       ;------------------------------------------------------
0083                       ; Dump VDP patterns
0084                       ;------------------------------------------------------
0085 7108 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     710A 2F84     
0086 710C 600E                   data bank7.rom        ; | i  p0 = bank address
0087 710E 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0088 7110 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092 7112 C2F9  30         mov   *stack+,r11           ; Pop r11
0093 7114 045B  20         b     *r11                  ; Return to caller
0095               
0096               
0098               ***************************************************************
0099               * Stub for "magic.set"
0100               * bank7 vec.20
0101               ********|*****|*********************|**************************
0102               magic.set:
0103 7116 0649  14         dect  stack
0104 7118 C64B  30         mov   r11,*stack            ; Save return address
0105                       ;------------------------------------------------------
0106                       ; Dump VDP patterns
0107                       ;------------------------------------------------------
0108 711A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     711C 2F84     
0109 711E 600E                   data bank7.rom        ; | i  p0 = bank address
0110 7120 7FE6                   data vec.20           ; | i  p1 = Vector with target address
0111 7122 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115 7124 C2F9  30         mov   *stack+,r11           ; Pop r11
0116 7126 045B  20         b     *r11                  ; Return to caller
0118               
0119               
0121               ***************************************************************
0122               * Stub for "magic.clear"
0123               * bank7 vec.21
0124               ********|*****|*********************|**************************
0125               magic.clear:
0126 7128 0649  14         dect  stack
0127 712A C64B  30         mov   r11,*stack            ; Save return address
0128                       ;------------------------------------------------------
0129                       ; Dump VDP patterns
0130                       ;------------------------------------------------------
0131 712C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     712E 2F84     
0132 7130 600E                   data bank7.rom        ; | i  p0 = bank address
0133 7132 7FE8                   data vec.21           ; | i  p1 = Vector with target address
0134 7134 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0135                       ;------------------------------------------------------
0136                       ; Exit
0137                       ;------------------------------------------------------
0138 7136 C2F9  30         mov   *stack+,r11           ; Pop r11
0139 7138 045B  20         b     *r11                  ; Return to caller
0141               
0142               
0144               ***************************************************************
0145               * Stub for "magic.check"
0146               * bank7 vec.22
0147               ********|*****|*********************|**************************
0148               magic.check:
0149 713A 0649  14         dect  stack
0150 713C C64B  30         mov   r11,*stack            ; Save return address
0151                       ;------------------------------------------------------
0152                       ; Dump VDP patterns
0153                       ;------------------------------------------------------
0154 713E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7140 2F84     
0155 7142 600E                   data bank7.rom        ; | i  p0 = bank address
0156 7144 7FEA                   data vec.22           ; | i  p1 = Vector with target address
0157 7146 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0158                       ;------------------------------------------------------
0159                       ; Exit
0160                       ;------------------------------------------------------
0161 7148 C2F9  30         mov   *stack+,r11           ; Pop r11
0162 714A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.68345
0097                       ;-----------------------------------------------------------------------
0098                       ; Program data
0099                       ;-----------------------------------------------------------------------
0100                       copy  "data.strings.bank3.asm"  ; Strings used in bank 3
     **** ****     > data.strings.bank3.asm
0001               * FILE......: data.strings.bank3.asm
0002               * Purpose...: Strings used in Stevie bank 3
0003               
0004               
0005               ***************************************************************
0006               *                       Strings
0007               ***************************************************************
0008               
0009 714C 2053     txt.stevie         text ' Stevie 1.3A '
     714E 7465     
     7150 7669     
     7152 6520     
     7154 312E     
     7156 3341     
     7158 20       
0010                                  even
0011               txt.keys.default1
0012 715A 1E               byte  30
0013 715B   46             text  'F9-Back  F3-Clear  F5-Fastmode'
     715C 392D     
     715E 4261     
     7160 636B     
     7162 2020     
     7164 4633     
     7166 2D43     
     7168 6C65     
     716A 6172     
     716C 2020     
     716E 4635     
     7170 2D46     
     7172 6173     
     7174 746D     
     7176 6F64     
     7178 65       
0014                       even
0015               
0016               txt.keys.default2
0017 717A 1F               byte  31
0018 717B   46             text  'F9-Back  F3-Clear  *F5-Fastmode'
     717C 392D     
     717E 4261     
     7180 636B     
     7182 2020     
     7184 4633     
     7186 2D43     
     7188 6C65     
     718A 6172     
     718C 2020     
     718E 2A46     
     7190 352D     
     7192 4661     
     7194 7374     
     7196 6D6F     
     7198 6465     
0019                       even
0020               
0021               
0022               ;--------------------------------------------------------------
0023               ; Dialog "Load file"
0024               ;--------------------------------------------------------------
0025 719A 0E01     txt.head.load      byte 14,1,1
     719C 01       
0026 719D   20                        text ' Open file '
     719E 4F70     
     71A0 656E     
     71A2 2066     
     71A4 696C     
     71A6 6520     
0027 71A8 01                          byte 1
0028               txt.hint.load
0029 71A9   1E             byte  30
0030 71AA 4769             text  'Give filename of file to open.'
     71AC 7665     
     71AE 2066     
     71B0 696C     
     71B2 656E     
     71B4 616D     
     71B6 6520     
     71B8 6F66     
     71BA 2066     
     71BC 696C     
     71BE 6520     
     71C0 746F     
     71C2 206F     
     71C4 7065     
     71C6 6E2E     
0031                       even
0032               
0033               
0034      715A     txt.keys.load      equ txt.keys.default1
0035      717A     txt.keys.load2     equ txt.keys.default2
0036               
0037               ;--------------------------------------------------------------
0038               ; Dialog "Save file"
0039               ;--------------------------------------------------------------
0040 71C8 0E01     txt.head.save      byte 14,1,1
     71CA 01       
0041 71CB   20                        text ' Save file '
     71CC 5361     
     71CE 7665     
     71D0 2066     
     71D2 696C     
     71D4 6520     
0042 71D6 01                          byte 1
0043 71D7   16     txt.head.save2     byte 22,1,1
     71D8 0101     
0044 71DA 2053                        text ' Save block to file '
     71DC 6176     
     71DE 6520     
     71E0 626C     
     71E2 6F63     
     71E4 6B20     
     71E6 746F     
     71E8 2066     
     71EA 696C     
     71EC 6520     
0045 71EE 01                          byte 1
0046               txt.hint.save
0047 71EF   1E             byte  30
0048 71F0 4769             text  'Give filename of file to save.'
     71F2 7665     
     71F4 2066     
     71F6 696C     
     71F8 656E     
     71FA 616D     
     71FC 6520     
     71FE 6F66     
     7200 2066     
     7202 696C     
     7204 6520     
     7206 746F     
     7208 2073     
     720A 6176     
     720C 652E     
0049                       even
0050               
0051               txt.keys.save
0052 720E 11               byte  17
0053 720F   46             text  'F9-Back  F3-Clear'
     7210 392D     
     7212 4261     
     7214 636B     
     7216 2020     
     7218 4633     
     721A 2D43     
     721C 6C65     
     721E 6172     
0054                       even
0055               
0056               
0057               
0058               ;--------------------------------------------------------------
0059               ; Dialog "Append file"
0060               ;--------------------------------------------------------------
0061 7220 1001     txt.head.append    byte 16,1,1
     7222 01       
0062 7223   20                        text ' Append file '
     7224 4170     
     7226 7065     
     7228 6E64     
     722A 2066     
     722C 696C     
     722E 6520     
0063 7230 01                          byte 1
0064               txt.hint.append
0065 7231   3F             byte  63
0066 7232 4769             text  'Give filename of file to append at the end of the current file.'
     7234 7665     
     7236 2066     
     7238 696C     
     723A 656E     
     723C 616D     
     723E 6520     
     7240 6F66     
     7242 2066     
     7244 696C     
     7246 6520     
     7248 746F     
     724A 2061     
     724C 7070     
     724E 656E     
     7250 6420     
     7252 6174     
     7254 2074     
     7256 6865     
     7258 2065     
     725A 6E64     
     725C 206F     
     725E 6620     
     7260 7468     
     7262 6520     
     7264 6375     
     7266 7272     
     7268 656E     
     726A 7420     
     726C 6669     
     726E 6C65     
     7270 2E       
0067                       even
0068               
0069               
0070      715A     txt.keys.append    equ txt.keys.default1
0071      717A     txt.keys.append2   equ txt.keys.default2
0072               
0073               
0074               ;--------------------------------------------------------------
0075               ; Dialog "Insert file"
0076               ;--------------------------------------------------------------
0077 7272 1801     txt.head.insert    byte 24,1,1
     7274 01       
0078 7275   20                        text ' Insert file at line '
     7276 496E     
     7278 7365     
     727A 7274     
     727C 2066     
     727E 696C     
     7280 6520     
     7282 6174     
     7284 206C     
     7286 696E     
     7288 6520     
0079 728A 01                          byte 1
0080               txt.hint.insert
0081 728B   20             byte  32
0082 728C 4769             text  'Give filename of file to insert.'
     728E 7665     
     7290 2066     
     7292 696C     
     7294 656E     
     7296 616D     
     7298 6520     
     729A 6F66     
     729C 2066     
     729E 696C     
     72A0 6520     
     72A2 746F     
     72A4 2069     
     72A6 6E73     
     72A8 6572     
     72AA 742E     
0083                       even
0084               
0085               
0086      715A     txt.keys.insert    equ txt.keys.default1
0087      717A     txt.keys.insert2   equ txt.keys.default2
0088               
0089               
0090               ;--------------------------------------------------------------
0091               ; Dialog "Configure clipboard device"
0092               ;--------------------------------------------------------------
0093 72AC 1F01     txt.head.clipdev   byte 31,1,1
     72AE 01       
0094 72AF   20                        text ' Configure clipboard device '
     72B0 436F     
     72B2 6E66     
     72B4 6967     
     72B6 7572     
     72B8 6520     
     72BA 636C     
     72BC 6970     
     72BE 626F     
     72C0 6172     
     72C2 6420     
     72C4 6465     
     72C6 7669     
     72C8 6365     
     72CA 20       
0095 72CB   01                        byte 1
0096               txt.hint.clipdev
0097 72CC 2D               byte  45
0098 72CD   47             text  'Give device and filename prefix of clipboard.'
     72CE 6976     
     72D0 6520     
     72D2 6465     
     72D4 7669     
     72D6 6365     
     72D8 2061     
     72DA 6E64     
     72DC 2066     
     72DE 696C     
     72E0 656E     
     72E2 616D     
     72E4 6520     
     72E6 7072     
     72E8 6566     
     72EA 6978     
     72EC 206F     
     72EE 6620     
     72F0 636C     
     72F2 6970     
     72F4 626F     
     72F6 6172     
     72F8 642E     
0099                       even
0100               
0101               txt.keys.clipdev
0102 72FA 3B               byte  59
0103 72FB   46             text  'F9-Back  F3-Clear  ^A=DSK1.CLIP  ^B=DSK2.CLIP  ^C=TIPI.CLIP'
     72FC 392D     
     72FE 4261     
     7300 636B     
     7302 2020     
     7304 4633     
     7306 2D43     
     7308 6C65     
     730A 6172     
     730C 2020     
     730E 5E41     
     7310 3D44     
     7312 534B     
     7314 312E     
     7316 434C     
     7318 4950     
     731A 2020     
     731C 5E42     
     731E 3D44     
     7320 534B     
     7322 322E     
     7324 434C     
     7326 4950     
     7328 2020     
     732A 5E43     
     732C 3D54     
     732E 4950     
     7330 492E     
     7332 434C     
     7334 4950     
0104                       even
0105               
0106               
0107               
0108               ;--------------------------------------------------------------
0109               ; Dialog "Copy clipboard"
0110               ;--------------------------------------------------------------
0111 7336 1B01     txt.head.clipboard byte 27,1,1
     7338 01       
0112 7339   20                        text ' Copy clipboard to line '
     733A 436F     
     733C 7079     
     733E 2063     
     7340 6C69     
     7342 7062     
     7344 6F61     
     7346 7264     
     7348 2074     
     734A 6F20     
     734C 6C69     
     734E 6E65     
     7350 20       
0113 7351   01                        byte 1
0114               txt.info.clipboard
0115 7352 10               byte  16
0116 7353   43             text  'Clipboard [1-5]?'
     7354 6C69     
     7356 7062     
     7358 6F61     
     735A 7264     
     735C 205B     
     735E 312D     
     7360 355D     
     7362 3F       
0117                       even
0118               
0119               txt.hint.clipboard
0120 7364 47               byte  71
0121 7365   50             text  'Press 1 to 5 to copy clipboard, press F7 to configure clipboard device.'
     7366 7265     
     7368 7373     
     736A 2031     
     736C 2074     
     736E 6F20     
     7370 3520     
     7372 746F     
     7374 2063     
     7376 6F70     
     7378 7920     
     737A 636C     
     737C 6970     
     737E 626F     
     7380 6172     
     7382 642C     
     7384 2070     
     7386 7265     
     7388 7373     
     738A 2046     
     738C 3720     
     738E 746F     
     7390 2063     
     7392 6F6E     
     7394 6669     
     7396 6775     
     7398 7265     
     739A 2063     
     739C 6C69     
     739E 7062     
     73A0 6F61     
     73A2 7264     
     73A4 2064     
     73A6 6576     
     73A8 6963     
     73AA 652E     
0122                       even
0123               
0124               
0125               txt.keys.clipboard
0126 73AC 22               byte  34
0127 73AD   46             text  'F9-Back  F5-Fastmode  F7-Configure'
     73AE 392D     
     73B0 4261     
     73B2 636B     
     73B4 2020     
     73B6 4635     
     73B8 2D46     
     73BA 6173     
     73BC 746D     
     73BE 6F64     
     73C0 6520     
     73C2 2046     
     73C4 372D     
     73C6 436F     
     73C8 6E66     
     73CA 6967     
     73CC 7572     
     73CE 65       
0128                       even
0129               
0130               txt.keys.clipboard2
0131 73D0 23               byte  35
0132 73D1   46             text  'F9-Back  *F5-Fastmode  F7-Configure'
     73D2 392D     
     73D4 4261     
     73D6 636B     
     73D8 2020     
     73DA 2A46     
     73DC 352D     
     73DE 4661     
     73E0 7374     
     73E2 6D6F     
     73E4 6465     
     73E6 2020     
     73E8 4637     
     73EA 2D43     
     73EC 6F6E     
     73EE 6669     
     73F0 6775     
     73F2 7265     
0133                       even
0134               
0135               
0136               
0137               ;--------------------------------------------------------------
0138               ; Dialog "Print file"
0139               ;--------------------------------------------------------------
0140 73F4 0F01     txt.head.print     byte 15,1,1
     73F6 01       
0141 73F7   20                        text ' Print file '
     73F8 5072     
     73FA 696E     
     73FC 7420     
     73FE 6669     
     7400 6C65     
     7402 20       
0142 7403   01                        byte 1
0143 7404 1001     txt.head.print2    byte 16,1,1
     7406 01       
0144 7407   20                        text ' Print block '
     7408 5072     
     740A 696E     
     740C 7420     
     740E 626C     
     7410 6F63     
     7412 6B20     
0145 7414 01                          byte 1
0146               txt.hint.print
0147 7415   2B             byte  43
0148 7416 4769             text  'Give printer device name (PIO, PI.PIO, ...)'
     7418 7665     
     741A 2070     
     741C 7269     
     741E 6E74     
     7420 6572     
     7422 2064     
     7424 6576     
     7426 6963     
     7428 6520     
     742A 6E61     
     742C 6D65     
     742E 2028     
     7430 5049     
     7432 4F2C     
     7434 2050     
     7436 492E     
     7438 5049     
     743A 4F2C     
     743C 202E     
     743E 2E2E     
     7440 29       
0149                       even
0150               
0151               txt.keys.print
0152 7442 11               byte  17
0153 7443   46             text  'F9-Back  F3-Clear'
     7444 392D     
     7446 4261     
     7448 636B     
     744A 2020     
     744C 4633     
     744E 2D43     
     7450 6C65     
     7452 6172     
0154                       even
0155               
0156               
0157               ;--------------------------------------------------------------
0158               ; Dialog "Unsaved changes"
0159               ;--------------------------------------------------------------
0160 7454 1401     txt.head.unsaved   byte 20,1,1
     7456 01       
0161 7457   20                        text ' Unsaved changes '
     7458 556E     
     745A 7361     
     745C 7665     
     745E 6420     
     7460 6368     
     7462 616E     
     7464 6765     
     7466 7320     
0162 7468 01                          byte 1
0163               txt.info.unsaved
0164 7469   21             byte  33
0165 746A 5761             text  'Warning! Unsaved changes in file.'
     746C 726E     
     746E 696E     
     7470 6721     
     7472 2055     
     7474 6E73     
     7476 6176     
     7478 6564     
     747A 2063     
     747C 6861     
     747E 6E67     
     7480 6573     
     7482 2069     
     7484 6E20     
     7486 6669     
     7488 6C65     
     748A 2E       
0166                       even
0167               
0168               txt.hint.unsaved
0169 748C 37               byte  55
0170 748D   50             text  'Press F6 or SPACE to proceed. Press ENTER to save file.'
     748E 7265     
     7490 7373     
     7492 2046     
     7494 3620     
     7496 6F72     
     7498 2053     
     749A 5041     
     749C 4345     
     749E 2074     
     74A0 6F20     
     74A2 7072     
     74A4 6F63     
     74A6 6565     
     74A8 642E     
     74AA 2050     
     74AC 7265     
     74AE 7373     
     74B0 2045     
     74B2 4E54     
     74B4 4552     
     74B6 2074     
     74B8 6F20     
     74BA 7361     
     74BC 7665     
     74BE 2066     
     74C0 696C     
     74C2 652E     
0171                       even
0172               
0173               txt.keys.unsaved
0174 74C4 25               byte  37
0175 74C5   46             text  'F9-Back  F6/SPACE-Proceed  ENTER-Save'
     74C6 392D     
     74C8 4261     
     74CA 636B     
     74CC 2020     
     74CE 4636     
     74D0 2F53     
     74D2 5041     
     74D4 4345     
     74D6 2D50     
     74D8 726F     
     74DA 6365     
     74DC 6564     
     74DE 2020     
     74E0 454E     
     74E2 5445     
     74E4 522D     
     74E6 5361     
     74E8 7665     
0176                       even
0177               
0178               
0179               ;--------------------------------------------------------------
0180               ; Dialog "Help"
0181               ;--------------------------------------------------------------
0182 74EA 0901     txt.head.about     byte 9,1,1
     74EC 01       
0183 74ED   20                        text ' Help '
     74EE 4865     
     74F0 6C70     
     74F2 20       
0184 74F3   01                        byte 1
0185               
0186               txt.info.about
0187 74F4 02               byte  2
0188 74F5   00             text  ''
0189                       even
0190               
0191               txt.hint.about
0192 74F6 26               byte  38
0193 74F7   50             text  'Press F9 or ENTER to return to editor.'
     74F8 7265     
     74FA 7373     
     74FC 2046     
     74FE 3920     
     7500 6F72     
     7502 2045     
     7504 4E54     
     7506 4552     
     7508 2074     
     750A 6F20     
     750C 7265     
     750E 7475     
     7510 726E     
     7512 2074     
     7514 6F20     
     7516 6564     
     7518 6974     
     751A 6F72     
     751C 2E       
0194                       even
0195               
0196               txt.keys.about
0197 751E 23               byte  35
0198 751F   46             text  'F9-Back  SPACE-NextPage  ENTER-Back'
     7520 392D     
     7522 4261     
     7524 636B     
     7526 2020     
     7528 5350     
     752A 4143     
     752C 452D     
     752E 4E65     
     7530 7874     
     7532 5061     
     7534 6765     
     7536 2020     
     7538 454E     
     753A 5445     
     753C 522D     
     753E 4261     
     7540 636B     
0199                       even
0200               
0201               txt.about.build
0202 7542 4C               byte  76
0203 7543   42             text  'Build: 220126-2148540 / 2018-2022 Filip Van Vooren / retroclouds on Atariage'
     7544 7569     
     7546 6C64     
     7548 3A20     
     754A 3232     
     754C 3031     
     754E 3236     
     7550 2D32     
     7552 3134     
     7554 3835     
     7556 3430     
     7558 202F     
     755A 2032     
     755C 3031     
     755E 382D     
     7560 3230     
     7562 3232     
     7564 2046     
     7566 696C     
     7568 6970     
     756A 2056     
     756C 616E     
     756E 2056     
     7570 6F6F     
     7572 7265     
     7574 6E20     
     7576 2F20     
     7578 7265     
     757A 7472     
     757C 6F63     
     757E 6C6F     
     7580 7564     
     7582 7320     
     7584 6F6E     
     7586 2041     
     7588 7461     
     758A 7269     
     758C 6167     
     758E 65       
0204                       even
0205               
0206               
0207               
0208               ;--------------------------------------------------------------
0209               ; Dialog "Main Menu"
0210               ;--------------------------------------------------------------
0211 7590 0E01     txt.head.menu      byte 14,1,1
     7592 01       
0212 7593   20                        text ' Main Menu '
     7594 4D61     
     7596 696E     
     7598 204D     
     759A 656E     
     759C 7520     
0213 759E 01                          byte 1
0214               
0215               txt.info.menu
0216 759F   1E             byte  30
0217 75A0 4669             text  'File   Cartridge   Help   Quit'
     75A2 6C65     
     75A4 2020     
     75A6 2043     
     75A8 6172     
     75AA 7472     
     75AC 6964     
     75AE 6765     
     75B0 2020     
     75B2 2048     
     75B4 656C     
     75B6 7020     
     75B8 2020     
     75BA 5175     
     75BC 6974     
0218                       even
0219               
0220 75BE 0007     pos.info.menu      byte 0,7,19,26,>ff
     75C0 131A     
     75C2 FF       
0221               txt.hint.menu
0222 75C3   01             byte  1
0223 75C4 20               text  ' '
0224                       even
0225               
0226               txt.keys.menu
0227 75C6 07               byte  7
0228 75C7   46             text  'F9-Back'
     75C8 392D     
     75CA 4261     
     75CC 636B     
0229                       even
0230               
0231               
0232               
0233               ;--------------------------------------------------------------
0234               ; Dialog "File"
0235               ;--------------------------------------------------------------
0236 75CE 0901     txt.head.file      byte 9,1,1
     75D0 01       
0237 75D1   20                        text ' File '
     75D2 4669     
     75D4 6C65     
     75D6 20       
0238 75D7   01                        byte 1
0239               
0240               txt.info.file
0241 75D8 25               byte  37
0242 75D9   4E             text  'New   Open   Save   Print   Configure'
     75DA 6577     
     75DC 2020     
     75DE 204F     
     75E0 7065     
     75E2 6E20     
     75E4 2020     
     75E6 5361     
     75E8 7665     
     75EA 2020     
     75EC 2050     
     75EE 7269     
     75F0 6E74     
     75F2 2020     
     75F4 2043     
     75F6 6F6E     
     75F8 6669     
     75FA 6775     
     75FC 7265     
0243                       even
0244               
0245 75FE 0006     pos.info.file      byte 0,6,13,20,28,>ff
     7600 0D14     
     7602 1CFF     
0246               txt.hint.file
0247 7604 01               byte  1
0248 7605   20             text  ' '
0249                       even
0250               
0251               txt.keys.file
0252 7606 07               byte  7
0253 7607   46             text  'F9-Back'
     7608 392D     
     760A 4261     
     760C 636B     
0254                       even
0255               
0256               
0257               
0258               ;--------------------------------------------------------------
0259               ; Dialog "Cartridge"
0260               ;--------------------------------------------------------------
0261 760E 0E01     txt.head.cartridge byte 14,1,1
     7610 01       
0262 7611   20                        text ' Cartridge '
     7612 4361     
     7614 7274     
     7616 7269     
     7618 6467     
     761A 6520     
0263 761C 01                          byte 1
0264               
0265               txt.info.cartridge
0266 761D   08             byte  8
0267 761E 5449             text  'TI Basic'
     7620 2042     
     7622 6173     
     7624 6963     
0268                       even
0269               
0270 7626 03FF     pos.info.cartridge byte 3,>ff
0271               txt.hint.cartridge
0272 7628 18               byte  24
0273 7629   53             text  'Select cartridge to run.'
     762A 656C     
     762C 6563     
     762E 7420     
     7630 6361     
     7632 7274     
     7634 7269     
     7636 6467     
     7638 6520     
     763A 746F     
     763C 2072     
     763E 756E     
     7640 2E       
0274                       even
0275               
0276               txt.keys.cartridge
0277 7642 07               byte  7
0278 7643   46             text  'F9-Back'
     7644 392D     
     7646 4261     
     7648 636B     
0279                       even
0280               
0281               
0282               
0283               ;--------------------------------------------------------------
0284               ; Dialog "TI Basic"
0285               ;--------------------------------------------------------------
0286 764A 0D01     txt.head.basic     byte 13,1,1
     764C 01       
0287 764D   20                        text ' TI Basic '
     764E 5449     
     7650 2042     
     7652 6173     
     7654 6963     
     7656 20       
0288 7657   01                        byte 1
0289               
0290               txt.info.basic
0291 7658 1C               byte  28
0292 7659   53             text  'Session:  1   2   3   4   5 '
     765A 6573     
     765C 7369     
     765E 6F6E     
     7660 3A20     
     7662 2031     
     7664 2020     
     7666 2032     
     7668 2020     
     766A 2033     
     766C 2020     
     766E 2034     
     7670 2020     
     7672 2035     
     7674 20       
0293                       even
0294               
0295 7676 0A0E     pos.info.basic     byte 10,14,18,22,26,>ff
     7678 1216     
     767A 1AFF     
0296               txt.hint.basic
0297 767C 3F               byte  63
0298 767D   50             text  'Pick session 1-5. Press F9 in TI Basic for returning to Stevie.'
     767E 6963     
     7680 6B20     
     7682 7365     
     7684 7373     
     7686 696F     
     7688 6E20     
     768A 312D     
     768C 352E     
     768E 2050     
     7690 7265     
     7692 7373     
     7694 2046     
     7696 3920     
     7698 696E     
     769A 2054     
     769C 4920     
     769E 4261     
     76A0 7369     
     76A2 6320     
     76A4 666F     
     76A6 7220     
     76A8 7265     
     76AA 7475     
     76AC 726E     
     76AE 696E     
     76B0 6720     
     76B2 746F     
     76B4 2053     
     76B6 7465     
     76B8 7669     
     76BA 652E     
0299                       even
0300               
0301               txt.keys.basic
0302 76BC 14               byte  20
0303 76BD   46             text  'F9-Back  F5-Hide SID'
     76BE 392D     
     76C0 4261     
     76C2 636B     
     76C4 2020     
     76C6 4635     
     76C8 2D48     
     76CA 6964     
     76CC 6520     
     76CE 5349     
     76D0 44       
0304                       even
0305               
0306               txt.keys.basic2
0307 76D2 15               byte  21
0308 76D3   46             text  'F9-Back  *F5-Hide SID'
     76D4 392D     
     76D6 4261     
     76D8 636B     
     76DA 2020     
     76DC 2A46     
     76DE 352D     
     76E0 4869     
     76E2 6465     
     76E4 2053     
     76E6 4944     
0309                       even
0310               
0311               
0312               
0313               ;--------------------------------------------------------------
0314               ; Dialog "Configure"
0315               ;--------------------------------------------------------------
0316 76E8 0E01     txt.head.config    byte 14,1,1
     76EA 01       
0317 76EB   20                        text ' Configure '
     76EC 436F     
     76EE 6E66     
     76F0 6967     
     76F2 7572     
     76F4 6520     
0318 76F6 01                          byte 1
0319               
0320               txt.info.config
0321 76F7   09             byte  9
0322 76F8 436C             text  'Clipboard'
     76FA 6970     
     76FC 626F     
     76FE 6172     
     7700 64       
0323                       even
0324               
0325 7702 00FF     pos.info.config    byte 0,>ff
0326               txt.hint.config
0327 7704 01               byte  1
0328 7705   20             text  ' '
0329                       even
0330               
0331               txt.keys.config
0332 7706 07               byte  7
0333 7707   46             text  'F9-Back'
     7708 392D     
     770A 4261     
     770C 636B     
0334                       even
0335               
                   < stevie_b3.asm.68345
0101                       copy  "data.keymap.presets.asm" ; Shortcut presets in dialogs
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
0011 770E 0011             data  id.dialog.clipdev,key.ctrl.a,def.clip.fname
     7710 0081     
     7712 3972     
0012 7714 0011             data  id.dialog.clipdev,key.ctrl.b,def.clip.fname.b
     7716 0082     
     7718 397C     
0013 771A 0011             data  id.dialog.clipdev,key.ctrl.c,def.clip.fname.C
     771C 0083     
     771E 3986     
0014                       ;------------------------------------------------------
0015                       ; End of list
0016                       ;-------------------------------------------------------
0017 7720 FFFF             data  EOL                   ; EOL
                   < stevie_b3.asm.68345
0102                       ;-----------------------------------------------------------------------
0103                       ; Bank full check
0104                       ;-----------------------------------------------------------------------
0108                       ;-----------------------------------------------------------------------
0109                       ; Show ROM bank in CPU crash screen
0110                       ;-----------------------------------------------------------------------
0111                       copy "rom.crash.asm"
     **** ****     > rom.crash.asm
0001               * FILE......: rom.crash.asm
0002               * Purpose...: Show ROM bank number on CPU crash
0003               
0004               ***************************************************************
0005               * Show ROM bank number on CPU crash
0006               ********|*****|*********************|**************************
0007               cpu.crash.showbank:
0008                       aorg  bankx.crash.showbank
0009 7F00 06A0  32         bl    @putat
     7F02 2456     
0010 7F04 0314                   byte 3,20
0011 7F06 7F0A                   data cpu.crash.showbank.bankstr
0012 7F08 10FF  14         jmp   $
                   < stevie_b3.asm.68345
0112                       ;-----------------------------------------------------------------------
0113                       ; Vector table
0114                       ;-----------------------------------------------------------------------
0115                       copy  "rom.vectors.bank3.asm"
     **** ****     > rom.vectors.bank3.asm
0001               * FILE......: rom.vectors.bank3.asm
0002               * Purpose...: Bank 3 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * ROM identification string for CPU crash
0006               *--------------------------------------------------------------
0007               cpu.crash.showbank.bankstr:
0008               
0009 7F0A 05               byte  5
0010 7F0B   52             text  'ROM#3'
     7F0C 4F4D     
     7F0E 2333     
0011                       even
0012               
0013               
0014               *--------------------------------------------------------------
0015               * Vector table for trampoline functions
0016               *--------------------------------------------------------------
0017                       aorg  bankx.vectab
0018               
0019 7FC0 608C     vec.1   data  dialog.help           ; Dialog "About"
0020 7FC2 6736     vec.2   data  dialog.load           ; Dialog "Load file"
0021 7FC4 67A8     vec.3   data  dialog.save           ; Dialog "Save file"
0022 7FC6 68F6     vec.4   data  dialog.insert         ; Dialog "Insert file at line ..."
0023 7FC8 6820     vec.5   data  dialog.print          ; Dialog "Print file"
0024 7FCA 66B2     vec.6   data  dialog.file           ; Dialog "File"
0025 7FCC 6AB8     vec.7   data  dialog.unsaved        ; Dialog "Unsaved changes"
0026 7FCE 6A2A     vec.8   data  dialog.clipboard      ; Dialog "Copy clipboard to line ..."
0027 7FD0 69DE     vec.9   data  dialog.clipdev        ; Dialog "Configure clipboard device"
0028 7FD2 699C     vec.10  data  dialog.config         ; Dialog "Configure"
0029 7FD4 6890     vec.11  data  dialog.append         ; Dialog "Append file"
0030 7FD6 66F4     vec.12  data  dialog.cartridge      ; Dialog "Cartridge"
0031 7FD8 6AF6     vec.13  data  dialog.basic          ; Dialog "Basic"
0032 7FDA 2026     vec.14  data  cpu.crash             ;
0033 7FDC 2026     vec.15  data  cpu.crash             ;
0034 7FDE 2026     vec.16  data  cpu.crash             ;
0035 7FE0 2026     vec.17  data  cpu.crash             ;
0036 7FE2 6DA4     vec.18  data  error.display         ; Show error message
0037 7FE4 6B40     vec.19  data  pane.show_hintx       ; Show or hide hint (register version)
0038 7FE6 6BAA     vec.20  data  pane.cmdb.show        ; Show command buffer pane (=dialog)
0039 7FE8 6C2E     vec.21  data  pane.cmdb.hide        ; Hide command buffer pane
0040 7FEA 6C92     vec.22  data  pane.cmdb.draw        ; Draw content in command
0041 7FEC 2026     vec.23  data  cpu.crash             ;
0042 7FEE 6DD6     vec.24  data  cmdb.refresh          ;
0043 7FF0 6E20     vec.25  data  cmdb.cmd.clear        ;
0044 7FF2 6E52     vec.26  data  cmdb.cmd.getlength    ;
0045 7FF4 6EB2     vec.27  data  cmdb.cmd.preset       ;
0046 7FF6 6E68     vec.28  data  cmdb.cmd.set          ;
0047 7FF8 2026     vec.29  data  cpu.crash             ;
0048 7FFA 604A     vec.30  data  dialog.menu           ; Dialog "Main Menu"
0049 7FFC 6FA6     vec.31  data  tibasic.sid.toggle    ; Toggle 'Show SID' in Run TI-Basic dialog
0050 7FFE 6EF4     vec.32  data  fm.fastmode           ; Toggle fastmode on/off in Load dialog
                   < stevie_b3.asm.68345
0116                                                   ; Vector table bank 3
0117               *--------------------------------------------------------------
0118               * Video mode configuration
0119               *--------------------------------------------------------------
0120      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0121      0004     spfbck  equ   >04                   ; Screen background color.
0122      35CC     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0123      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0124      0050     colrow  equ   80                    ; Columns per row
0125      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0126      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0127      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0128      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

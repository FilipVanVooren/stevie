XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b3.asm.76432
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b3.asm               ; Version 211229-2057130
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
0029               
0030               *--------------------------------------------------------------
0031               * Stack location
0032               *--------------------------------------------------------------
0033      83A0     sp2.stktop                 equ  >83a0  ; \ SP2 stack >8340 - >8398
0034                                                      ; | The stack grows from
0035                                                      ; / high to low memory.
0036               
0037               
0038               *--------------------------------------------------------------
0039               * classic99 and JS99er emulators are mutually exclusive.
0040               * At the time of writing JS99er has full F18a compatibility.
0041               *
0042               * When targetting the JS99er emulator or a real F18a + TI-99/4a
0043               * then set the 'full_f18a_support' equate to 1.
0044               *
0045               * When targetting the classic99 emulator then set the
0046               * 'full_f18a_support' equate to 0. This will activate the
0047               * trimmed down 9938 version, that only works in classic99, but
0048               * not on the real TI-99/4a yet.
0049               *--------------------------------------------------------------
0050      0001     full_f18a_support         equ  1       ; 30 rows mode with sprites
0051               
0052               
0053               *--------------------------------------------------------------
0054               * JS99er F18a 30x80, no FG99 advanced mode
0055               *--------------------------------------------------------------
0057      0001     device.f18a               equ  1       ; F18a GPU
0058      0000     device.9938               equ  0       ; 9938 GPU
0059      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode off
0061               
0062               
0063               
0064               *--------------------------------------------------------------
0065               * Classic99 F18a 24x80, no FG99 advanced mode
0066               *--------------------------------------------------------------
                   < stevie_b3.asm.76432
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
                   < stevie_b3.asm.76432
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
0170      A02C     tibasic.session   equ  core1.top + 44  ; Active TI-Basic session (1-5)
0171      A02E     tibasic1.status   equ  core1.top + 46  ; TI Basic session 1
0172      A030     tibasic2.status   equ  core1.top + 48  ; TI Basic session 2
0173      A032     tibasic3.status   equ  core1.top + 50  ; TI Basic session 3
0174      A034     tibasic4.status   equ  core1.top + 52  ; TI Basic session 4
0175      A036     tibasic5.status   equ  core1.top + 54  ; TI Basic session 5
0176      A038     trmpvector        equ  core1.top + 56  ; Vector trampoline (if p1|tmp1 = >ffff)
0177      A03A     ramsat            equ  core1.top + 58  ; Sprite Attr. Table in RAM (14 bytes)
0178      A048     timers            equ  core1.top + 72  ; Timers (80 bytes)
0179      A098     core1.free        equ  core1.top + 152 ; End of structure
0180               *--------------------------------------------------------------
0181               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0182               *--------------------------------------------------------------
0183      A100     core2.top         equ  >a100           ; Structure begin
0184      A100     rambuf            equ  core2.top       ; RAM workbuffer
0185      A200     core2.free        equ  core2.top + 256 ; End of structure
0186               *--------------------------------------------------------------
0187               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0188               *--------------------------------------------------------------
0189      A200     tv.top            equ  >a200           ; Structure begin
0190      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0191      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0192      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0193      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0194      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0195      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0196      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0197      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0198      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0199      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0200      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0201      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0202      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0203      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0204      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0205      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0206      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0207      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0208      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0209      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0210      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0211      A22A     tv.error.rows     equ  tv.top + 42     ; Number of rows in error pane
0212      A22C     tv.sp2.conf       equ  tv.top + 44     ; Backup of SP2 config register
0213      A22E     tv.error.msg      equ  tv.top + 46     ; Error message (max. 160 characters)
0214      A2CE     tv.free           equ  tv.top + 206    ; End of structure
0215               *--------------------------------------------------------------
0216               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0217               *--------------------------------------------------------------
0218      A300     fb.struct         equ  >a300           ; Structure begin
0219      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0220      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0221      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0222                                                      ; line X in editor buffer).
0223      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0224                                                      ; (offset 0 .. @fb.scrrows)
0225      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0226      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0227      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0228      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0229      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0230      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0231      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0232      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0233      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0234      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0235      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0236      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0237      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0238      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0239               *--------------------------------------------------------------
0240               * File handle structure               @>a400-a4ff   (256 bytes)
0241               *--------------------------------------------------------------
0242      A400     fh.struct         equ  >a400           ; stevie file handling structures
0243               ;***********************************************************************
0244               ; ATTENTION
0245               ; The dsrlnk variables must form a continuous memory block and keep
0246               ; their order!
0247               ;***********************************************************************
0248      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0249      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0250      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0251      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0252      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0253      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0254      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0255      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0256      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0257      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0258      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0259      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0260      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0261      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0262      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0263      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0264      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0265      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0266      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0267      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0268      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0269      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0270      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0271      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0272      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0273      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0274      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0275      A45A     fh.workmode       equ  fh.struct + 90  ; Working mode (used in callbacks)
0276      A45C     fh.kilobytes.prev equ  fh.struct + 92  ; Kilobytes processed (previous)
0277      A45E     fh.line           equ  fh.struct + 94  ; Editor buffer line currently processing
0278      A460     fh.temp1          equ  fh.struct + 96  ; Temporary variable 1
0279      A462     fh.temp2          equ  fh.struct + 98  ; Temporary variable 2
0280      A464     fh.temp3          equ  fh.struct +100  ; Temporary variable 3
0281      A466     fh.membuffer      equ  fh.struct +102  ; 80 bytes file memory buffer
0282      A4B6     fh.free           equ  fh.struct +182  ; End of structure
0283      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0284      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0285               *--------------------------------------------------------------
0286               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0287               *--------------------------------------------------------------
0288      A500     edb.struct        equ  >a500           ; Begin structure
0289      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0290      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0291      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0292      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0293      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0294      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0295      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0296      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0297      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0298      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0299                                                      ; with current filename.
0300      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0301                                                      ; with current file type.
0302      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0303      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0304      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0305                                                      ; for filename, but not always used.
0306      A56A     edb.free          equ  edb.struct + 106; End of structure
0307               *--------------------------------------------------------------
0308               * Index structure                     @>a600-a6ff   (256 bytes)
0309               *--------------------------------------------------------------
0310      A600     idx.struct        equ  >a600           ; stevie index structure
0311      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0312      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0313      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0314      A606     idx.free          equ  idx.struct + 6  ; End of structure
0315               *--------------------------------------------------------------
0316               * Command buffer structure            @>a700-a7ff   (256 bytes)
0317               *--------------------------------------------------------------
0318      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0319      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0320      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0321      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0322      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0323      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0324      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0325      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0326      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0327      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0328      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0329      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0330      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0331      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0332      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0333      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0334      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0335      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0336      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0337      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0338      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0339      A728     cmdb.cmdall       equ  cmdb.struct + 40; Current command including length-byte
0340      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0341      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0342      A77A     cmdb.panhead.buf  equ  cmdb.struct +122; String buffer for pane header
0343      A7AC     cmdb.dflt.fname   equ  cmdb.struct +172; Default for filename
0344      A800     cmdb.free         equ  cmdb.struct +256; End of structure
0345               *--------------------------------------------------------------
0346               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0347               *--------------------------------------------------------------
0348      7E00     cpu.scrpad.src    equ  >7e00           ; \ Dump of OS monitor scratchpad
0349                                                      ; / stored in cartridge ROM bank7.asm
0350               
0351      F960     cpu.scrpad.tgt    equ  >f960           ; \ Target copy of OS monitor scratchpad
0352                                                      ; | in high-memory.
0353                                                      ; /
0354               
0355      AD00     cpu.scrpad.moved  equ  >ad00           ; Stevie scratchpad memory when paged-out
0356                                                      ; because of TI Basic/External program
0357               *--------------------------------------------------------------
0358               * Farjump return stack                @>af00-afff   (256 bytes)
0359               *--------------------------------------------------------------
0360      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0361                                                      ; Grows downwards from high to low.
0362               *--------------------------------------------------------------
0363               * Index                               @>b000-bfff  (4096 bytes)
0364               *--------------------------------------------------------------
0365      B000     idx.top           equ  >b000           ; Top of index
0366      1000     idx.size          equ  4096            ; Index size
0367               *--------------------------------------------------------------
0368               * Editor buffer                       @>c000-cfff  (4096 bytes)
0369               *--------------------------------------------------------------
0370      C000     edb.top           equ  >c000           ; Editor buffer high memory
0371      1000     edb.size          equ  4096            ; Editor buffer size
0372               *--------------------------------------------------------------
0373               * Frame buffer & Default devices      @>d000-dfff  (4096 bytes)
0374               *--------------------------------------------------------------
0375      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0376      0960     fb.size           equ  80*30           ; Frame buffer size
0377      D960     tv.printer.fname  equ  >d960           ; Default printer   (80 char)
0378      D9B0     tv.clip.fname     equ  >d9b0           ; Default clipboard (80 char)
0379               *--------------------------------------------------------------
0380               * Command buffer history              @>e000-efff  (4096 bytes)
0381               *--------------------------------------------------------------
0382      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0383      1000     cmdb.size         equ  4096            ; Command buffer size
0384               *--------------------------------------------------------------
0385               * Heap                                @>f000-ffff  (4096 bytes)
0386               *--------------------------------------------------------------
0387      F000     heap.top          equ  >f000           ; Top of heap
                   < stevie_b3.asm.76432
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
                   < stevie_b3.asm.76432
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
0045 6011   53             text  'STEVIE 1.2M'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 324D     
0046                       even
0047               
0049               
                   < stevie_b3.asm.76432
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
     2084 2FDA     
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
0270 21ED   42             text  'Build-ID  211229-2057130'
     21EE 7569     
     21F0 6C64     
     21F2 2D49     
     21F4 4420     
     21F6 2032     
     21F8 3131     
     21FA 3232     
     21FC 392D     
     21FE 3230     
     2200 3537     
     2202 3133     
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
0090 2CE4 1571  14         jgt   dsrlnk.error.devicename_invalid
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
     2CFE 2E14     
0109 2D00 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2D02 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2D04 1361  14         jeq   dsrlnk.error.devicename_invalid
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
0147 2D3A 1344  14         jeq   dsrlnk.error.nodsr_found
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
     2D48 2E10     
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
0221 2D8C 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2D8E 8C02     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2D90 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2D92 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2D94 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2D96 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2D98 A400     
0233 2D9A C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2D9C C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2D9E A428     
0239                                                   ; (8 or >a)
0240 2DA0 0281  22         ci    r1,8                  ; was it 8?
     2DA2 0008     
0241 2DA4 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2DA6 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2DA8 8350     
0243                                                   ; Get error byte from @>8350
0244 2DAA 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2DAC 06C0  14         swpb  r0                    ;
0252 2DAE D800  38         movb  r0,@vdpa              ; send low byte
     2DB0 8C02     
0253 2DB2 06C0  14         swpb  r0                    ;
0254 2DB4 D800  38         movb  r0,@vdpa              ; send high byte
     2DB6 8C02     
0255 2DB8 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2DBA 8800     
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2DBC 09D1  56         srl   r1,13                 ; just keep error bits
0263 2DBE 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2DC0 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2DC2 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2DC4 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2DC6 A400     
0275               dsrlnk.error.devicename_invalid:
0276 2DC8 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2DCA 06C1  14         swpb  r1                    ; put error in hi byte
0279 2DCC D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2DCE F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2DD0 201C     
0281                                                   ; / to indicate error
0282 2DD2 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2DD4 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2DD6 2DD8             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2DD8 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2DDA 83E0     
0316               
0317 2DDC 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2DDE 201C     
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2DE0 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2DE2 A42A     
0322 2DE4 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2DE6 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2DE8 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2DEA 8356     
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2DEC C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2DEE C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2DF0 8354     
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2DF2 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2DF4 8C02     
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2DF6 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2DF8 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2DFA 4000     
     2DFC 2E10     
0337 2DFE 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2E00 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2E02 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2E04 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2E06 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2E08 A400     
0355 2E0A C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2E0C A434     
0356               
0357 2E0E 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2E10 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2E12 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2E14 2E       dsrlnk.period     text  '.'         ; For finding end of device name
0367               
0368                       even
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
0045 2E16 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2E18 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2E1A 0649  14         dect  stack
0052 2E1C C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2E1E 0204  20         li    tmp0,dsrlnk.savcru
     2E20 A42A     
0057 2E22 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2E24 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2E26 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2E28 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2E2A 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2E2C 37D7     
0065 2E2E C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2E30 8370     
0066                                                   ; / location
0067 2E32 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2E34 A44C     
0068 2E36 04C5  14         clr   tmp1                  ; io.op.open
0069 2E38 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2E3A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2E3C 0649  14         dect  stack
0097 2E3E C64B  30         mov   r11,*stack            ; Save return address
0098 2E40 0205  20         li    tmp1,io.op.close      ; io.op.close
     2E42 0001     
0099 2E44 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2E46 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2E48 0649  14         dect  stack
0125 2E4A C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2E4C 0205  20         li    tmp1,io.op.read       ; io.op.read
     2E4E 0002     
0128 2E50 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2E52 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2E54 0649  14         dect  stack
0155 2E56 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2E58 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2E5A 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2E5C 0005     
0159               
0160 2E5E C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2E60 A43E     
0161               
0162 2E62 06A0  32         bl    @xvputb               ; Write character count to PAB
     2E64 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2E66 0205  20         li    tmp1,io.op.write      ; io.op.write
     2E68 0003     
0167 2E6A 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2E6C 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2E6E 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2E70 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2E72 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2E74 1000  14         nop
0189               
0190               
0191               file.status:
0192 2E76 1000  14         nop
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
0227 2E78 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2E7A A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2E7C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2E7E A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2E80 A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2E82 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2E84 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2E86 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2E88 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2E8A C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2E8C A44C     
0246               
0247 2E8E 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2E90 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2E92 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2E94 0009     
0254 2E96 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2E98 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2E9A C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2E9C 8322     
     2E9E 833C     
0259               
0260 2EA0 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2EA2 A42A     
0261 2EA4 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2EA6 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2EA8 2CA8     
0268 2EAA 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2EAC 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2EAE 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2EB0 2DD4     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2EB2 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2EB4 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2EB6 833C     
     2EB8 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2EBA C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2EBC A436     
0292 2EBE 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2EC0 0005     
0293 2EC2 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2EC4 22F8     
0294 2EC6 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2EC8 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2ECA C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2ECC 045B  20         b     *r11                  ; Return to caller
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
0020 2ECE 0300  24 tmgr    limi  0                     ; No interrupt processing
     2ED0 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2ED2 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2ED4 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2ED6 2360  38         coc   @wbit2,r13            ; C flag on ?
     2ED8 201C     
0029 2EDA 1602  14         jne   tmgr1a                ; No, so move on
0030 2EDC E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2EDE 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2EE0 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2EE2 2020     
0035 2EE4 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2EE6 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2EE8 2010     
0048 2EEA 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2EEC 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2EEE 200E     
0050 2EF0 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2EF2 0460  28         b     @kthread              ; Run kernel thread
     2EF4 2F6C     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2EF6 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2EF8 2014     
0056 2EFA 13EB  14         jeq   tmgr1
0057 2EFC 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2EFE 2012     
0058 2F00 16E8  14         jne   tmgr1
0059 2F02 C120  34         mov   @wtiusr,tmp0
     2F04 832E     
0060 2F06 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2F08 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2F0A 2F6A     
0065 2F0C C10A  18         mov   r10,tmp0
0066 2F0E 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2F10 00FF     
0067 2F12 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2F14 201C     
0068 2F16 1303  14         jeq   tmgr5
0069 2F18 0284  22         ci    tmp0,60               ; 1 second reached ?
     2F1A 003C     
0070 2F1C 1002  14         jmp   tmgr6
0071 2F1E 0284  22 tmgr5   ci    tmp0,50
     2F20 0032     
0072 2F22 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2F24 1001  14         jmp   tmgr8
0074 2F26 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2F28 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2F2A 832C     
0079 2F2C 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2F2E FF00     
0080 2F30 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2F32 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2F34 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2F36 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2F38 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2F3A 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2F3C 830C     
     2F3E 830D     
0089 2F40 1608  14         jne   tmgr10                ; No, get next slot
0090 2F42 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2F44 FF00     
0091 2F46 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2F48 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2F4A 8330     
0096 2F4C 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2F4E C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2F50 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2F52 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2F54 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2F56 8315     
     2F58 8314     
0103 2F5A 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2F5C 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2F5E 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2F60 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2F62 10F7  14         jmp   tmgr10                ; Process next slot
0108 2F64 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2F66 FF00     
0109 2F68 10B4  14         jmp   tmgr1
0110 2F6A 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2F6C E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2F6E 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 2F70 20A0  38         coc   @wbit13,config        ; Sound player on ?
     2F72 2006     
0023 2F74 1602  14         jne   kthread_kb
0024 2F76 06A0  32         bl    @sdpla1               ; Run sound player
     2F78 284A     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 2F7A 06A0  32         bl    @realkb               ; Scan full keyboard
     2F7C 28CA     
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2F7E 0460  28         b     @tmgr3                ; Exit
     2F80 2EF6     
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
0017 2F82 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2F84 832E     
0018 2F86 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2F88 2012     
0019 2F8A 045B  20 mkhoo1  b     *r11                  ; Return
0020      2ED2     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2F8C 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2F8E 832E     
0029 2F90 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2F92 FEFF     
0030 2F94 045B  20         b     *r11                  ; Return
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
0017 2F96 C13B  30 mkslot  mov   *r11+,tmp0
0018 2F98 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2F9A C184  18         mov   tmp0,tmp2
0023 2F9C 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2F9E A1A0  34         a     @wtitab,tmp2          ; Add table base
     2FA0 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2FA2 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2FA4 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2FA6 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2FA8 881B  46         c     *r11,@w$ffff          ; End of list ?
     2FAA 2022     
0035 2FAC 1301  14         jeq   mkslo1                ; Yes, exit
0036 2FAE 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2FB0 05CB  14 mkslo1  inct  r11
0041 2FB2 045B  20         b     *r11                  ; Exit
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
0052 2FB4 C13B  30 clslot  mov   *r11+,tmp0
0053 2FB6 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2FB8 A120  34         a     @wtitab,tmp0          ; Add table base
     2FBA 832C     
0055 2FBC 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2FBE 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2FC0 045B  20         b     *r11                  ; Exit
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
0068 2FC2 C13B  30 rsslot  mov   *r11+,tmp0
0069 2FC4 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2FC6 A120  34         a     @wtitab,tmp0          ; Add table base
     2FC8 832C     
0071 2FCA 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2FCC C154  26         mov   *tmp0,tmp1
0073 2FCE 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2FD0 FF00     
0074 2FD2 C505  30         mov   tmp1,*tmp0
0075 2FD4 045B  20         b     *r11                  ; Exit
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
0266 2FD6 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2FD8 8302     
0268               *--------------------------------------------------------------
0269               * Alternative entry point
0270               *--------------------------------------------------------------
0271 2FDA 0300  24 runli1  limi  0                     ; Turn off interrupts
     2FDC 0000     
0272 2FDE 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2FE0 8300     
0273 2FE2 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2FE4 83C0     
0274               *--------------------------------------------------------------
0275               * Clear scratch-pad memory from R4 upwards
0276               *--------------------------------------------------------------
0277 2FE6 0202  20 runli2  li    r2,>8308
     2FE8 8308     
0278 2FEA 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0279 2FEC 0282  22         ci    r2,>8400
     2FEE 8400     
0280 2FF0 16FC  14         jne   runli3
0281               *--------------------------------------------------------------
0282               * Exit to TI-99/4A title screen ?
0283               *--------------------------------------------------------------
0284 2FF2 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2FF4 FFFF     
0285 2FF6 1602  14         jne   runli4                ; No, continue
0286 2FF8 0420  54         blwp  @0                    ; Yes, bye bye
     2FFA 0000     
0287               *--------------------------------------------------------------
0288               * Determine if VDP is PAL or NTSC
0289               *--------------------------------------------------------------
0290 2FFC C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2FFE 833C     
0291 3000 04C1  14         clr   r1                    ; Reset counter
0292 3002 0202  20         li    r2,10                 ; We test 10 times
     3004 000A     
0293 3006 C0E0  34 runli5  mov   @vdps,r3
     3008 8802     
0294 300A 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     300C 2020     
0295 300E 1302  14         jeq   runli6
0296 3010 0581  14         inc   r1                    ; Increase counter
0297 3012 10F9  14         jmp   runli5
0298 3014 0602  14 runli6  dec   r2                    ; Next test
0299 3016 16F7  14         jne   runli5
0300 3018 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     301A 1250     
0301 301C 1202  14         jle   runli7                ; No, so it must be NTSC
0302 301E 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     3020 201C     
0303               *--------------------------------------------------------------
0304               * Copy machine code to scratchpad (prepare tight loop)
0305               *--------------------------------------------------------------
0306 3022 06A0  32 runli7  bl    @loadmc
     3024 222E     
0307               *--------------------------------------------------------------
0308               * Initialize registers, memory, ...
0309               *--------------------------------------------------------------
0310 3026 04C1  14 runli9  clr   r1
0311 3028 04C2  14         clr   r2
0312 302A 04C3  14         clr   r3
0313 302C 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     302E 83A0     
0314 3030 020F  20         li    r15,vdpw              ; Set VDP write address
     3032 8C00     
0316 3034 06A0  32         bl    @mute                 ; Mute sound generators
     3036 280E     
0318               *--------------------------------------------------------------
0319               * Setup video memory
0320               *--------------------------------------------------------------
0322 3038 0280  22         ci    r0,>4a4a              ; Crash flag set?
     303A 4A4A     
0323 303C 1605  14         jne   runlia
0324 303E 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     3040 22A2     
0325 3042 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     3044 0000     
     3046 3000     
0330 3048 06A0  32 runlia  bl    @filv
     304A 22A2     
0331 304C 0FC0             data  pctadr,spfclr,16      ; Load color table
     304E 00F4     
     3050 0010     
0332               *--------------------------------------------------------------
0333               * Check if there is a F18A present
0334               *--------------------------------------------------------------
0338 3052 06A0  32         bl    @f18unl               ; Unlock the F18A
     3054 273E     
0339 3056 06A0  32         bl    @f18chk               ; Check if F18A is there \
     3058 2768     
0340 305A 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     305C 2768     
0341 305E 06A0  32         bl    @f18chk               ; Check if F18A is there /
     3060 2768     
0342 3062 06A0  32         bl    @f18lck               ; Lock the F18A again
     3064 2754     
0343               
0344 3066 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     3068 2346     
0345 306A 3201                   data >3201            ; F18a VR50 (>32), bit 1
0347               *--------------------------------------------------------------
0348               * Check if there is a speech synthesizer attached
0349               *--------------------------------------------------------------
0351               *       <<skipped>>
0355               *--------------------------------------------------------------
0356               * Load video mode table & font
0357               *--------------------------------------------------------------
0358 306C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     306E 230C     
0359 3070 3622             data  spvmod                ; Equate selected video mode table
0360 3072 0204  20         li    tmp0,spfont           ; Get font option
     3074 000C     
0361 3076 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0362 3078 1304  14         jeq   runlid                ; Yes, skip it
0363 307A 06A0  32         bl    @ldfnt
     307C 2374     
0364 307E 1100             data  fntadr,spfont         ; Load specified font
     3080 000C     
0365               *--------------------------------------------------------------
0366               * Did a system crash occur before runlib was called?
0367               *--------------------------------------------------------------
0368 3082 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     3084 4A4A     
0369 3086 1602  14         jne   runlie                ; No, continue
0370 3088 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     308A 2086     
0371               *--------------------------------------------------------------
0372               * Branch to main program
0373               *--------------------------------------------------------------
0374 308C 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     308E 0040     
0375 3090 0460  28         b     @main                 ; Give control to main program
     3092 6046     
                   < stevie_b3.asm.76432
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
0021 3094 C13B  30         mov   *r11+,tmp0            ; P0
0022 3096 C17B  30         mov   *r11+,tmp1            ; P1
0023 3098 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 309A 0649  14         dect  stack
0029 309C C644  30         mov   tmp0,*stack           ; Push tmp0
0030 309E 0649  14         dect  stack
0031 30A0 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 30A2 0649  14         dect  stack
0033 30A4 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 30A6 0649  14         dect  stack
0035 30A8 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 30AA 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     30AC 6000     
0040 30AE 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 30B0 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     30B2 A226     
0044 30B4 0647  14         dect  tmp3
0045 30B6 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 30B8 0647  14         dect  tmp3
0047 30BA C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 30BC C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     30BE A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 30C0 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 30C2 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 30C4 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 30C6 0224  22         ai    tmp0,>0800
     30C8 0800     
0066 30CA 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 30CC 0285  22         ci    tmp1,>ffff
     30CE FFFF     
0075 30D0 1602  14         jne   !
0076 30D2 C160  34         mov   @trmpvector,tmp1
     30D4 A038     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 30D6 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 30D8 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 30DA 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 30DC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     30DE FFCE     
0091 30E0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     30E2 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 30E4 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 30E6 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     30E8 A226     
0102 30EA C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 30EC 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 30EE 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 30F0 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 30F2 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 30F4 028B  22         ci    r11,>6000
     30F6 6000     
0115 30F8 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 30FA 028B  22         ci    r11,>7fff
     30FC 7FFF     
0117 30FE 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 3100 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     3102 A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 3104 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 3106 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 3108 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 310A 0225  22         ai    tmp1,>0800
     310C 0800     
0137 310E 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 3110 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 3112 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3114 FFCE     
0144 3116 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3118 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 311A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 311C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 311E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 3120 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 3122 045B  20         b     *r11                  ; Return to caller
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
0020 3124 0649  14         dect  stack
0021 3126 C64B  30         mov   r11,*stack            ; Save return address
0022 3128 0649  14         dect  stack
0023 312A C644  30         mov   tmp0,*stack           ; Push tmp0
0024 312C 0649  14         dect  stack
0025 312E C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3130 0204  20         li    tmp0,fb.top
     3132 D000     
0030 3134 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3136 A300     
0031 3138 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     313A A304     
0032 313C 04E0  34         clr   @fb.row               ; Current row=0
     313E A306     
0033 3140 04E0  34         clr   @fb.column            ; Current column=0
     3142 A30C     
0034               
0035 3144 0204  20         li    tmp0,colrow
     3146 0050     
0036 3148 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     314A A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 314C C160  34         mov   @tv.ruler.visible,tmp1
     314E A210     
0041 3150 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 3152 0204  20         li    tmp0,pane.botrow-2
     3154 001B     
0043 3156 1002  14         jmp   fb.init.cont
0044 3158 0204  20 !       li    tmp0,pane.botrow-1
     315A 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 315C C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     315E A31A     
0050 3160 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3162 A31C     
0051               
0052 3164 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     3166 A222     
0053 3168 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     316A A310     
0054 316C 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     316E A316     
0055 3170 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     3172 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 3174 06A0  32         bl    @film
     3176 224A     
0060 3178 D000             data  fb.top,>00,fb.size    ; Clear it all the way
     317A 0000     
     317C 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 317E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 3180 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 3182 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 3184 045B  20         b     *r11                  ; Return to caller
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
0051 3186 0649  14         dect  stack
0052 3188 C64B  30         mov   r11,*stack            ; Save return address
0053 318A 0649  14         dect  stack
0054 318C C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 318E 0204  20         li    tmp0,idx.top
     3190 B000     
0059 3192 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     3194 A502     
0060               
0061 3196 C120  34         mov   @tv.sams.b000,tmp0
     3198 A206     
0062 319A C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     319C A600     
0063 319E C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     31A0 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 31A2 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     31A4 0004     
0068 31A6 C804  38         mov   tmp0,@idx.sams.hipage ; /
     31A8 A604     
0069               
0070 31AA 06A0  32         bl    @_idx.sams.mapcolumn.on
     31AC 31C8     
0071                                                   ; Index in continuous memory region
0072               
0073 31AE 06A0  32         bl    @film
     31B0 224A     
0074 31B2 B000                   data idx.top,>00,idx.size * 5
     31B4 0000     
     31B6 5000     
0075                                                   ; Clear index
0076               
0077 31B8 06A0  32         bl    @_idx.sams.mapcolumn.off
     31BA 31FC     
0078                                                   ; Restore memory window layout
0079               
0080 31BC C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     31BE A602     
     31C0 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 31C2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 31C4 C2F9  30         mov   *stack+,r11           ; Pop r11
0088 31C6 045B  20         b     *r11                  ; Return to caller
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
0101 31C8 0649  14         dect  stack
0102 31CA C64B  30         mov   r11,*stack            ; Push return address
0103 31CC 0649  14         dect  stack
0104 31CE C644  30         mov   tmp0,*stack           ; Push tmp0
0105 31D0 0649  14         dect  stack
0106 31D2 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 31D4 0649  14         dect  stack
0108 31D6 C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 31D8 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     31DA A602     
0113 31DC 0205  20         li    tmp1,idx.top
     31DE B000     
0114 31E0 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     31E2 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 31E4 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     31E6 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 31E8 0584  14         inc   tmp0                  ; Next SAMS index page
0123 31EA 0225  22         ai    tmp1,>1000            ; Next memory region
     31EC 1000     
0124 31EE 0606  14         dec   tmp2                  ; Update loop counter
0125 31F0 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 31F2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 31F4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 31F6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 31F8 C2F9  30         mov   *stack+,r11           ; Pop return address
0134 31FA 045B  20         b     *r11                  ; Return to caller
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
0150 31FC 0649  14         dect  stack
0151 31FE C64B  30         mov   r11,*stack            ; Push return address
0152 3200 0649  14         dect  stack
0153 3202 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 3204 0649  14         dect  stack
0155 3206 C645  30         mov   tmp1,*stack           ; Push tmp1
0156 3208 0649  14         dect  stack
0157 320A C646  30         mov   tmp2,*stack           ; Push tmp2
0158 320C 0649  14         dect  stack
0159 320E C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 3210 0205  20         li    tmp1,idx.top
     3212 B000     
0164 3214 0206  20         li    tmp2,5                ; Always 5 pages
     3216 0005     
0165 3218 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     321A A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 321C C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 321E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3220 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 3222 0225  22         ai    tmp1,>1000            ; Next memory region
     3224 1000     
0176 3226 0606  14         dec   tmp2                  ; Update loop counter
0177 3228 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 322A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 322C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 322E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 3230 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 3232 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 3234 045B  20         b     *r11                  ; Return to caller
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
0211 3236 0649  14         dect  stack
0212 3238 C64B  30         mov   r11,*stack            ; Save return address
0213 323A 0649  14         dect  stack
0214 323C C644  30         mov   tmp0,*stack           ; Push tmp0
0215 323E 0649  14         dect  stack
0216 3240 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 3242 0649  14         dect  stack
0218 3244 C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 3246 C184  18         mov   tmp0,tmp2             ; Line number
0223 3248 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 324A 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     324C 0800     
0225               
0226 324E 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 3250 0A16  56         sla   tmp2,1                ; line number * 2
0231 3252 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     3254 A010     
0232               
0233 3256 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     3258 A602     
0234 325A 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     325C A600     
0235               
0236 325E 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 3260 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     3262 A600     
0242 3264 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     3266 A206     
0243 3268 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 326A 0205  20         li    tmp1,>b000            ; Memory window for index page
     326C B000     
0246               
0247 326E 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     3270 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 3272 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     3274 A604     
0254 3276 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 3278 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     327A A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 327C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 327E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 3280 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 3282 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 3284 045B  20         b     *r11                  ; Return to caller
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
0022 3286 0649  14         dect  stack
0023 3288 C64B  30         mov   r11,*stack            ; Save return address
0024 328A 0649  14         dect  stack
0025 328C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 328E 0204  20         li    tmp0,edb.top          ; \
     3290 C000     
0030 3292 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     3294 A500     
0031 3296 C804  38         mov   tmp0,@edb.next_free.ptr
     3298 A508     
0032                                                   ; Set pointer to next free line
0033               
0034 329A 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     329C A50A     
0035               
0036 329E 0204  20         li    tmp0,1
     32A0 0001     
0037 32A2 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     32A4 A504     
0038               
0039 32A6 0720  34         seto  @edb.block.m1         ; Reset block start line
     32A8 A50C     
0040 32AA 0720  34         seto  @edb.block.m2         ; Reset block end line
     32AC A50E     
0041               
0042 32AE 0204  20         li    tmp0,txt.newfile      ; "New file"
     32B0 382C     
0043 32B2 C804  38         mov   tmp0,@edb.filename.ptr
     32B4 A512     
0044               
0045 32B6 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     32B8 A440     
0046 32BA 04E0  34         clr   @fh.kilobytes.prev    ; /
     32BC A45C     
0047               
0048 32BE 0204  20         li    tmp0,txt.filetype.none
     32C0 38E8     
0049 32C2 C804  38         mov   tmp0,@edb.filetype.ptr
     32C4 A514     
0050               
0051               edb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 32C6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 32C8 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 32CA 045B  20         b     *r11                  ; Return to caller
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
0022 32CC 0649  14         dect  stack
0023 32CE C64B  30         mov   r11,*stack            ; Save return address
0024 32D0 0649  14         dect  stack
0025 32D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 32D4 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     32D6 E000     
0030 32D8 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     32DA A700     
0031               
0032 32DC 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     32DE A702     
0033 32E0 0204  20         li    tmp0,4
     32E2 0004     
0034 32E4 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     32E6 A706     
0035 32E8 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     32EA A708     
0036               
0037 32EC 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     32EE A716     
0038 32F0 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     32F2 A718     
0039 32F4 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     32F6 A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 32F8 06A0  32         bl    @film
     32FA 224A     
0044 32FC E000             data  cmdb.top,>00,cmdb.size
     32FE 0000     
     3300 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3302 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3304 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 3306 045B  20         b     *r11                  ; Return to caller
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
0022 3308 0649  14         dect  stack
0023 330A C64B  30         mov   r11,*stack            ; Save return address
0024 330C 0649  14         dect  stack
0025 330E C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3310 0649  14         dect  stack
0027 3312 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3314 0649  14         dect  stack
0029 3316 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 3318 04E0  34         clr   @tv.error.visible     ; Set to hidden
     331A A228     
0034 331C 0204  20         li    tmp0,3
     331E 0003     
0035 3320 C804  38         mov   tmp0,@tv.error.rows   ; Number of rows in error pane
     3322 A22A     
0036               
0037 3324 06A0  32         bl    @film
     3326 224A     
0038 3328 A22E                   data tv.error.msg,0,160
     332A 0000     
     332C 00A0     
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               errpane.exit:
0043 332E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 3330 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 3332 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 3334 C2F9  30         mov   *stack+,r11           ; Pop R11
0047 3336 045B  20         b     *r11                  ; Return to caller
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
0022 3338 0649  14         dect  stack
0023 333A C64B  30         mov   r11,*stack            ; Save return address
0024 333C 0649  14         dect  stack
0025 333E C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3340 0649  14         dect  stack
0027 3342 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3344 0649  14         dect  stack
0029 3346 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 3348 0204  20         li    tmp0,1                ; \ Set default color scheme
     334A 0001     
0034 334C C804  38         mov   tmp0,@tv.colorscheme  ; /
     334E A212     
0035               
0036 3350 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3352 A224     
0037 3354 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     3356 200C     
0038               
0039 3358 0204  20         li    tmp0,fj.bottom
     335A B000     
0040 335C C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     335E A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 3360 06A0  32         bl    @cpym2m
     3362 24EE     
0045 3364 39C0                   data def.printer.fname,tv.printer.fname,7
     3366 D960     
     3368 0007     
0046               
0047 336A 06A0  32         bl    @cpym2m
     336C 24EE     
0048 336E 39C8                   data def.clip.fname,tv.clip.fname,10
     3370 D9B0     
     3372 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 3374 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 3376 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 3378 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 337A C2F9  30         mov   *stack+,r11           ; Pop R11
0057 337C 045B  20         b     *r11                  ; Return to caller
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
0023 337E 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     3380 27BA     
0024                       ;-------------------------------------------------------
0025                       ; Load legacy SAMS page layout and exit to monitor
0026                       ;-------------------------------------------------------
0027 3382 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     3384 3094     
0028 3386 600E                   data bank7.rom        ; | i  p0 = bank address
0029 3388 7FC0                   data bankx.vectab     ; | i  p1 = Vector with target address
0030 338A 6006                   data bankid           ; / i  p2 = Source ROM bank for return
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
0023 338C 0649  14         dect  stack
0024 338E C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Reset editor
0027                       ;------------------------------------------------------
0028 3390 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3392 32CC     
0029 3394 06A0  32         bl    @edb.init             ; Initialize editor buffer
     3396 3286     
0030 3398 06A0  32         bl    @idx.init             ; Initialize index
     339A 3186     
0031 339C 06A0  32         bl    @fb.init              ; Initialize framebuffer
     339E 3124     
0032 33A0 06A0  32         bl    @errpane.init         ; Initialize error pane
     33A2 3308     
0033                       ;------------------------------------------------------
0034                       ; Remove markers and shortcuts
0035                       ;------------------------------------------------------
0036 33A4 06A0  32         bl    @hchar
     33A6 27E6     
0037 33A8 0034                   byte 0,52,32,18           ; Remove markers
     33AA 2012     
0038 33AC 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     33AE 2033     
0039 33B0 FFFF                   data eol
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               tv.reset.exit:
0044 33B2 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 33B4 045B  20         b     *r11                  ; Return to caller
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
0020 33B6 0649  14         dect  stack
0021 33B8 C64B  30         mov   r11,*stack            ; Save return address
0022 33BA 0649  14         dect  stack
0023 33BC C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 33BE 06A0  32         bl    @mknum                ; Convert unsigned number to string
     33C0 2AB4     
0028 33C2 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 33C4 A100                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 33C6 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 33C7   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 33C8 0204  20         li    tmp0,unpacked.string
     33CA A026     
0034 33CC 04F4  30         clr   *tmp0+                ; Clear string 01
0035 33CE 04F4  30         clr   *tmp0+                ; Clear string 23
0036 33D0 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 33D2 06A0  32         bl    @trimnum              ; Trim unsigned number string
     33D4 2B0C     
0039 33D6 A100                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 33D8 A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 33DA 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 33DC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 33DE C2F9  30         mov   *stack+,r11           ; Pop r11
0048 33E0 045B  20         b     *r11                  ; Return to caller
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
0024 33E2 0649  14         dect  stack
0025 33E4 C64B  30         mov   r11,*stack            ; Push return address
0026 33E6 0649  14         dect  stack
0027 33E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0028 33EA 0649  14         dect  stack
0029 33EC C645  30         mov   tmp1,*stack           ; Push tmp1
0030 33EE 0649  14         dect  stack
0031 33F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0032 33F2 0649  14         dect  stack
0033 33F4 C647  30         mov   tmp3,*stack           ; Push tmp3
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 33F6 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     33F8 A000     
0038 33FA D194  26         movb  *tmp0,tmp2            ; /
0039 33FC 0986  56         srl   tmp2,8                ; Right align
0040 33FE C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0041               
0042 3400 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3402 A002     
0043 3404 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0044                       ;------------------------------------------------------
0045                       ; Copy string to buffer
0046                       ;------------------------------------------------------
0047 3406 C120  34         mov   @parm1,tmp0           ; Get source address
     3408 A000     
0048 340A C160  34         mov   @parm4,tmp1           ; Get destination address
     340C A006     
0049 340E 0586  14         inc   tmp2                  ; Also include length-byte in copy
0050               
0051 3410 0649  14         dect  stack
0052 3412 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0053               
0054 3414 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     3416 24F4     
0055                                                   ; \ i  tmp0 = Source CPU memory address
0056                                                   ; | i  tmp1 = Target CPU memory address
0057                                                   ; / i  tmp2 = Number of bytes to copy
0058               
0059 3418 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0060                       ;------------------------------------------------------
0061                       ; Set length of new string
0062                       ;------------------------------------------------------
0063 341A C120  34         mov   @parm2,tmp0           ; Get requested length
     341C A002     
0064 341E 0A84  56         sla   tmp0,8                ; Left align
0065 3420 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3422 A006     
0066 3424 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0067 3426 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0068 3428 0585  14         inc   tmp1                  ; /
0069                       ;------------------------------------------------------
0070                       ; Prepare for padding string
0071                       ;------------------------------------------------------
0072 342A C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     342C A002     
0073 342E 6187  18         s     tmp3,tmp2             ; |
0074 3430 0586  14         inc   tmp2                  ; /
0075               
0076 3432 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3434 A004     
0077 3436 0A84  56         sla   tmp0,8                ; Left align
0078                       ;------------------------------------------------------
0079                       ; Right-pad string to destination length
0080                       ;------------------------------------------------------
0081               tv.pad.string.loop:
0082 3438 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0083 343A 0606  14         dec   tmp2                  ; Update loop counter
0084 343C 15FD  14         jgt   tv.pad.string.loop    ; Next character
0085               
0086 343E C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3440 A006     
     3442 A010     
0087 3444 1004  14         jmp   tv.pad.string.exit    ; Exit
0088                       ;-----------------------------------------------------------------------
0089                       ; CPU crash
0090                       ;-----------------------------------------------------------------------
0091               tv.pad.string.panic:
0092 3446 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3448 FFCE     
0093 344A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     344C 2026     
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               tv.pad.string.exit:
0098 344E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0099 3450 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 3452 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 3454 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 3456 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 3458 045B  20         b     *r11                  ; Return to caller
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
0022 345A 0649  14         dect  stack
0023 345C C64B  30         mov   r11,*stack            ; Save return address
0024 345E 0649  14         dect  stack
0025 3460 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3462 0649  14         dect  stack
0027 3464 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 3466 C120  34         mov   @parm1,tmp0           ; Get line number
     3468 A000     
0032 346A C160  34         mov   @parm2,tmp1           ; Get pointer
     346C A002     
0033 346E 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 3470 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     3472 0FFF     
0039 3474 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 3476 06E0  34         swpb  @parm3
     3478 A004     
0044 347A D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     347C A004     
0045 347E 06E0  34         swpb  @parm3                ; \ Restore original order again,
     3480 A004     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 3482 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3484 3236     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 3486 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     3488 A010     
0056 348A C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     348C B000     
0057 348E C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     3490 A010     
0058 3492 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 3494 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3496 3236     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 3498 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     349A A010     
0068 349C 04E4  34         clr   @idx.top(tmp0)        ; /
     349E B000     
0069 34A0 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     34A2 A010     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 34A4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 34A6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 34A8 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 34AA 045B  20         b     *r11                  ; Return to caller
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
0021 34AC 0649  14         dect  stack
0022 34AE C64B  30         mov   r11,*stack            ; Save return address
0023 34B0 0649  14         dect  stack
0024 34B2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 34B4 0649  14         dect  stack
0026 34B6 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 34B8 0649  14         dect  stack
0028 34BA C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 34BC C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     34BE A000     
0033               
0034 34C0 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     34C2 3236     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 34C4 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     34C6 A010     
0039 34C8 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     34CA B000     
0040               
0041 34CC 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 34CE C185  18         mov   tmp1,tmp2             ; \
0047 34D0 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 34D2 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     34D4 00FF     
0052 34D6 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 34D8 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     34DA C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 34DC C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     34DE A010     
0059 34E0 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     34E2 A012     
0060 34E4 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 34E6 04E0  34         clr   @outparm1
     34E8 A010     
0066 34EA 04E0  34         clr   @outparm2
     34EC A012     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 34EE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 34F0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 34F2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 34F4 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 34F6 045B  20         b     *r11                  ; Return to caller
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
0017 34F8 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     34FA B000     
0018 34FC C144  18         mov   tmp0,tmp1             ; a = current slot
0019 34FE 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 3500 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 3502 0606  14         dec   tmp2                  ; tmp2--
0026 3504 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 3506 045B  20         b     *r11                  ; Return to caller
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
0046 3508 0649  14         dect  stack
0047 350A C64B  30         mov   r11,*stack            ; Save return address
0048 350C 0649  14         dect  stack
0049 350E C644  30         mov   tmp0,*stack           ; Push tmp0
0050 3510 0649  14         dect  stack
0051 3512 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 3514 0649  14         dect  stack
0053 3516 C646  30         mov   tmp2,*stack           ; Push tmp2
0054 3518 0649  14         dect  stack
0055 351A C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 351C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     351E A000     
0060               
0061 3520 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3522 3236     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 3524 C120  34         mov   @outparm1,tmp0        ; Index offset
     3526 A010     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 3528 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     352A A002     
0070 352C 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 352E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3530 A000     
0074 3532 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 3534 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     3536 B000     
0081 3538 04D4  26         clr   *tmp0                 ; Clear index entry
0082 353A 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 353C C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     353E A002     
0088 3540 0287  22         ci    tmp3,2048
     3542 0800     
0089 3544 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 3546 06A0  32         bl    @_idx.sams.mapcolumn.on
     3548 31C8     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 354A C120  34         mov   @parm1,tmp0           ; Restore line number
     354C A000     
0103 354E 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 3550 06A0  32         bl    @_idx.entry.delete.reorg
     3552 34F8     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 3554 06A0  32         bl    @_idx.sams.mapcolumn.off
     3556 31FC     
0111                                                   ; Restore memory window layout
0112               
0113 3558 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 355A 06A0  32         bl    @_idx.entry.delete.reorg
     355C 34F8     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 355E 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 3560 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 3562 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 3564 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 3566 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 3568 C2F9  30         mov   *stack+,r11           ; Pop r11
0132 356A 045B  20         b     *r11                  ; Return to caller
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
0017 356C 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     356E 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 3570 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 3572 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3574 FFCE     
0027 3576 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3578 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 357A 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     357C B000     
0032 357E C144  18         mov   tmp0,tmp1             ; a = current slot
0033 3580 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 3582 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 3584 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 3586 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 3588 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 358A A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 358C 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     358E AFFC     
0043 3590 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 3592 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3594 FFCE     
0049 3596 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3598 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 359A C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 359C 0644  14         dect  tmp0                  ; Move pointer up
0056 359E 0645  14         dect  tmp1                  ; Move pointer up
0057 35A0 0606  14         dec   tmp2                  ; Next index entry
0058 35A2 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 35A4 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 35A6 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 35A8 045B  20         b     *r11                  ; Return to caller
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
0088 35AA 0649  14         dect  stack
0089 35AC C64B  30         mov   r11,*stack            ; Save return address
0090 35AE 0649  14         dect  stack
0091 35B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 35B2 0649  14         dect  stack
0093 35B4 C645  30         mov   tmp1,*stack           ; Push tmp1
0094 35B6 0649  14         dect  stack
0095 35B8 C646  30         mov   tmp2,*stack           ; Push tmp2
0096 35BA 0649  14         dect  stack
0097 35BC C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 35BE C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     35C0 A002     
0102 35C2 61A0  34         s     @parm1,tmp2           ; Calculate loop
     35C4 A000     
0103 35C6 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 35C8 C1E0  34         mov   @parm2,tmp3
     35CA A002     
0110 35CC 0287  22         ci    tmp3,2048
     35CE 0800     
0111 35D0 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 35D2 06A0  32         bl    @_idx.sams.mapcolumn.on
     35D4 31C8     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 35D6 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     35D8 A002     
0123 35DA 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 35DC 06A0  32         bl    @_idx.entry.insert.reorg
     35DE 356C     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 35E0 06A0  32         bl    @_idx.sams.mapcolumn.off
     35E2 31FC     
0131                                                   ; Restore memory window layout
0132               
0133 35E4 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 35E6 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     35E8 A002     
0139               
0140 35EA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     35EC 3236     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 35EE C120  34         mov   @outparm1,tmp0        ; Index offset
     35F0 A010     
0145               
0146 35F2 06A0  32         bl    @_idx.entry.insert.reorg
     35F4 356C     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 35F6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 35F8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 35FA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 35FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 35FE C2F9  30         mov   *stack+,r11           ; Pop r11
0160 3600 045B  20         b     *r11                  ; Return to caller
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
0021 3602 0649  14         dect  stack
0022 3604 C64B  30         mov   r11,*stack            ; Push return address
0023 3606 0649  14         dect  stack
0024 3608 C660  46         mov   @wyx,*stack           ; Push cursor position
     360A 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 360C 06A0  32         bl    @hchar
     360E 27E6     
0029 3610 0034                   byte 0,52,32,18
     3612 2012     
0030 3614 FFFF                   data EOL              ; Clear message
0031               
0032 3616 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     3618 A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 361A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     361C 832A     
0038 361E C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3620 045B  20         b     *r11                  ; Return to task
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
0033 3622 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     3624 003F     
     3626 0243     
     3628 05F4     
     362A 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 362C 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     362E 000C     
     3630 0006     
     3632 0007     
     3634 0020     
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
0067 3636 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     3638 000C     
     363A 0006     
     363C 0007     
     363E 0020     
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
0098 3640 0000             data  >0000,>0001           ; Cursor
     3642 0001     
0099 3644 0000             data  >0000,>0101           ; Current line indicator     <
     3646 0101     
0100 3648 0820             data  >0820,>0201           ; Current column indicator   v
     364A 0201     
0101               nosprite:
0102 364C D000             data  >d000                 ; End-of-Sprites list
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
0157 364E F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     3650 F171     
     3652 1B1F     
     3654 71B1     
0158 3656 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     3658 F0FF     
     365A 1F1A     
     365C F1FF     
0159 365E 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     3660 F0FF     
     3662 1F12     
     3664 F1F6     
0160 3666 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     3668 1E11     
     366A 1A17     
     366C 1E11     
0161 366E E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     3670 E1FF     
     3672 1F1E     
     3674 E1FF     
0162 3676 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     3678 1016     
     367A 1B71     
     367C 1711     
0163 367E 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3680 1011     
     3682 F1F1     
     3684 1F11     
0164 3686 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     3688 A1FF     
     368A 1F1F     
     368C F11F     
0165 368E 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     3690 12FF     
     3692 1B12     
     3694 12FF     
0166 3696 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     3698 E1FF     
     369A 1B1F     
     369C F131     
0167                       even
0168               
0169               tv.tabs.table:
0170 369E 0007             byte  0,7,12,25               ; \   Default tab positions as used
     36A0 0C19     
0171 36A2 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     36A4 3B4F     
0172 36A6 FF00             byte  >ff,0,0,0               ; |
     36A8 0000     
0173 36AA 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     36AC 0000     
0174 36AE 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     36B0 0000     
0175                       even
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
0009 36B2 01               byte  1
0010 36B3   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 36B4 05               byte  5
0015 36B5   20             text  '  BOT'
     36B6 2042     
     36B8 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 36BA 03               byte  3
0020 36BB   4F             text  'OVR'
     36BC 5652     
0021                       even
0022               
0023               txt.insert
0024 36BE 03               byte  3
0025 36BF   49             text  'INS'
     36C0 4E53     
0026                       even
0027               
0028               txt.star
0029 36C2 01               byte  1
0030 36C3   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 36C4 0A               byte  10
0035 36C5   4C             text  'Loading...'
     36C6 6F61     
     36C8 6469     
     36CA 6E67     
     36CC 2E2E     
     36CE 2E       
0036                       even
0037               
0038               txt.saving
0039 36D0 0A               byte  10
0040 36D1   53             text  'Saving....'
     36D2 6176     
     36D4 696E     
     36D6 672E     
     36D8 2E2E     
     36DA 2E       
0041                       even
0042               
0043               txt.printing
0044 36DC 12               byte  18
0045 36DD   50             text  'Printing file.....'
     36DE 7269     
     36E0 6E74     
     36E2 696E     
     36E4 6720     
     36E6 6669     
     36E8 6C65     
     36EA 2E2E     
     36EC 2E2E     
     36EE 2E       
0046                       even
0047               
0048               txt.block.del
0049 36F0 12               byte  18
0050 36F1   44             text  'Deleting block....'
     36F2 656C     
     36F4 6574     
     36F6 696E     
     36F8 6720     
     36FA 626C     
     36FC 6F63     
     36FE 6B2E     
     3700 2E2E     
     3702 2E       
0051                       even
0052               
0053               txt.block.copy
0054 3704 11               byte  17
0055 3705   43             text  'Copying block....'
     3706 6F70     
     3708 7969     
     370A 6E67     
     370C 2062     
     370E 6C6F     
     3710 636B     
     3712 2E2E     
     3714 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 3716 10               byte  16
0060 3717   4D             text  'Moving block....'
     3718 6F76     
     371A 696E     
     371C 6720     
     371E 626C     
     3720 6F63     
     3722 6B2E     
     3724 2E2E     
     3726 2E       
0061                       even
0062               
0063               txt.block.save
0064 3728 18               byte  24
0065 3729   53             text  'Saving block to file....'
     372A 6176     
     372C 696E     
     372E 6720     
     3730 626C     
     3732 6F63     
     3734 6B20     
     3736 746F     
     3738 2066     
     373A 696C     
     373C 652E     
     373E 2E2E     
     3740 2E       
0066                       even
0067               
0068               txt.block.clip
0069 3742 18               byte  24
0070 3743   43             text  'Copying to clipboard....'
     3744 6F70     
     3746 7969     
     3748 6E67     
     374A 2074     
     374C 6F20     
     374E 636C     
     3750 6970     
     3752 626F     
     3754 6172     
     3756 642E     
     3758 2E2E     
     375A 2E       
0071                       even
0072               
0073               txt.block.print
0074 375C 12               byte  18
0075 375D   50             text  'Printing block....'
     375E 7269     
     3760 6E74     
     3762 696E     
     3764 6720     
     3766 626C     
     3768 6F63     
     376A 6B2E     
     376C 2E2E     
     376E 2E       
0076                       even
0077               
0078               txt.clearmem
0079 3770 13               byte  19
0080 3771   43             text  'Clearing memory....'
     3772 6C65     
     3774 6172     
     3776 696E     
     3778 6720     
     377A 6D65     
     377C 6D6F     
     377E 7279     
     3780 2E2E     
     3782 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 3784 0E               byte  14
0085 3785   4C             text  'Load completed'
     3786 6F61     
     3788 6420     
     378A 636F     
     378C 6D70     
     378E 6C65     
     3790 7465     
     3792 64       
0086                       even
0087               
0088               txt.done.insert
0089 3794 10               byte  16
0090 3795   49             text  'Insert completed'
     3796 6E73     
     3798 6572     
     379A 7420     
     379C 636F     
     379E 6D70     
     37A0 6C65     
     37A2 7465     
     37A4 64       
0091                       even
0092               
0093               txt.done.append
0094 37A6 10               byte  16
0095 37A7   41             text  'Append completed'
     37A8 7070     
     37AA 656E     
     37AC 6420     
     37AE 636F     
     37B0 6D70     
     37B2 6C65     
     37B4 7465     
     37B6 64       
0096                       even
0097               
0098               txt.done.save
0099 37B8 0E               byte  14
0100 37B9   53             text  'Save completed'
     37BA 6176     
     37BC 6520     
     37BE 636F     
     37C0 6D70     
     37C2 6C65     
     37C4 7465     
     37C6 64       
0101                       even
0102               
0103               txt.done.copy
0104 37C8 0E               byte  14
0105 37C9   43             text  'Copy completed'
     37CA 6F70     
     37CC 7920     
     37CE 636F     
     37D0 6D70     
     37D2 6C65     
     37D4 7465     
     37D6 64       
0106                       even
0107               
0108               txt.done.print
0109 37D8 0F               byte  15
0110 37D9   50             text  'Print completed'
     37DA 7269     
     37DC 6E74     
     37DE 2063     
     37E0 6F6D     
     37E2 706C     
     37E4 6574     
     37E6 6564     
0111                       even
0112               
0113               txt.done.delete
0114 37E8 10               byte  16
0115 37E9   44             text  'Delete completed'
     37EA 656C     
     37EC 6574     
     37EE 6520     
     37F0 636F     
     37F2 6D70     
     37F4 6C65     
     37F6 7465     
     37F8 64       
0116                       even
0117               
0118               txt.done.clipboard
0119 37FA 0F               byte  15
0120 37FB   43             text  'Clipboard saved'
     37FC 6C69     
     37FE 7062     
     3800 6F61     
     3802 7264     
     3804 2073     
     3806 6176     
     3808 6564     
0121                       even
0122               
0123               txt.done.clipdev
0124 380A 0D               byte  13
0125 380B   43             text  'Clipboard set'
     380C 6C69     
     380E 7062     
     3810 6F61     
     3812 7264     
     3814 2073     
     3816 6574     
0126                       even
0127               
0128               txt.fastmode
0129 3818 08               byte  8
0130 3819   46             text  'Fastmode'
     381A 6173     
     381C 746D     
     381E 6F64     
     3820 65       
0131                       even
0132               
0133               txt.kb
0134 3822 02               byte  2
0135 3823   6B             text  'kb'
     3824 62       
0136                       even
0137               
0138               txt.lines
0139 3826 05               byte  5
0140 3827   4C             text  'Lines'
     3828 696E     
     382A 6573     
0141                       even
0142               
0143               txt.newfile
0144 382C 0A               byte  10
0145 382D   5B             text  '[New file]'
     382E 4E65     
     3830 7720     
     3832 6669     
     3834 6C65     
     3836 5D       
0146                       even
0147               
0148               txt.filetype.dv80
0149 3838 04               byte  4
0150 3839   44             text  'DV80'
     383A 5638     
     383C 30       
0151                       even
0152               
0153               txt.m1
0154 383E 03               byte  3
0155 383F   4D             text  'M1='
     3840 313D     
0156                       even
0157               
0158               txt.m2
0159 3842 03               byte  3
0160 3843   4D             text  'M2='
     3844 323D     
0161                       even
0162               
0163               txt.keys.default
0164 3846 07               byte  7
0165 3847   46             text  'F9-Menu'
     3848 392D     
     384A 4D65     
     384C 6E75     
0166                       even
0167               
0168               txt.keys.block
0169 384E 36               byte  54
0170 384F   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     3850 392D     
     3852 4261     
     3854 636B     
     3856 2020     
     3858 5E43     
     385A 6F70     
     385C 7920     
     385E 205E     
     3860 4D6F     
     3862 7665     
     3864 2020     
     3866 5E44     
     3868 656C     
     386A 2020     
     386C 5E53     
     386E 6176     
     3870 6520     
     3872 205E     
     3874 5072     
     3876 696E     
     3878 7420     
     387A 205E     
     387C 5B31     
     387E 2D35     
     3880 5D43     
     3882 6C69     
     3884 70       
0171                       even
0172               
0173 3886 2E2E     txt.ruler          text    '.........'
     3888 2E2E     
     388A 2E2E     
     388C 2E2E     
     388E 2E       
0174 388F   12                        byte    18
0175 3890 2E2E                        text    '.........'
     3892 2E2E     
     3894 2E2E     
     3896 2E2E     
     3898 2E       
0176 3899   13                        byte    19
0177 389A 2E2E                        text    '.........'
     389C 2E2E     
     389E 2E2E     
     38A0 2E2E     
     38A2 2E       
0178 38A3   14                        byte    20
0179 38A4 2E2E                        text    '.........'
     38A6 2E2E     
     38A8 2E2E     
     38AA 2E2E     
     38AC 2E       
0180 38AD   15                        byte    21
0181 38AE 2E2E                        text    '.........'
     38B0 2E2E     
     38B2 2E2E     
     38B4 2E2E     
     38B6 2E       
0182 38B7   16                        byte    22
0183 38B8 2E2E                        text    '.........'
     38BA 2E2E     
     38BC 2E2E     
     38BE 2E2E     
     38C0 2E       
0184 38C1   17                        byte    23
0185 38C2 2E2E                        text    '.........'
     38C4 2E2E     
     38C6 2E2E     
     38C8 2E2E     
     38CA 2E       
0186 38CB   18                        byte    24
0187 38CC 2E2E                        text    '.........'
     38CE 2E2E     
     38D0 2E2E     
     38D2 2E2E     
     38D4 2E       
0188 38D5   19                        byte    25
0189                                  even
0190 38D6 020E     txt.alpha.down     data >020e,>0f00
     38D8 0F00     
0191 38DA 0110     txt.vertline       data >0110
0192 38DC 011C     txt.keymarker      byte 1,28
0193               
0194               txt.ws1
0195 38DE 01               byte  1
0196 38DF   20             text  ' '
0197                       even
0198               
0199               txt.ws2
0200 38E0 02               byte  2
0201 38E1   20             text  '  '
     38E2 20       
0202                       even
0203               
0204               txt.ws3
0205 38E4 03               byte  3
0206 38E5   20             text  '   '
     38E6 2020     
0207                       even
0208               
0209               txt.ws4
0210 38E8 04               byte  4
0211 38E9   20             text  '    '
     38EA 2020     
     38EC 20       
0212                       even
0213               
0214               txt.ws5
0215 38EE 05               byte  5
0216 38EF   20             text  '     '
     38F0 2020     
     38F2 2020     
0217                       even
0218               
0219      38E8     txt.filetype.none  equ txt.ws4
0220               
0221               
0222               ;--------------------------------------------------------------
0223               ; Strings for error line pane
0224               ;--------------------------------------------------------------
0225               txt.ioerr.load
0226 38F4 15               byte  21
0227 38F5   46             text  'Failed loading file: '
     38F6 6169     
     38F8 6C65     
     38FA 6420     
     38FC 6C6F     
     38FE 6164     
     3900 696E     
     3902 6720     
     3904 6669     
     3906 6C65     
     3908 3A20     
0228                       even
0229               
0230               txt.ioerr.save
0231 390A 14               byte  20
0232 390B   46             text  'Failed saving file: '
     390C 6169     
     390E 6C65     
     3910 6420     
     3912 7361     
     3914 7669     
     3916 6E67     
     3918 2066     
     391A 696C     
     391C 653A     
     391E 20       
0233                       even
0234               
0235               txt.ioerr.print
0236 3920 1B               byte  27
0237 3921   46             text  'Failed printing to device: '
     3922 6169     
     3924 6C65     
     3926 6420     
     3928 7072     
     392A 696E     
     392C 7469     
     392E 6E67     
     3930 2074     
     3932 6F20     
     3934 6465     
     3936 7669     
     3938 6365     
     393A 3A20     
0238                       even
0239               
0240               txt.io.nofile
0241 393C 16               byte  22
0242 393D   4E             text  'No filename specified.'
     393E 6F20     
     3940 6669     
     3942 6C65     
     3944 6E61     
     3946 6D65     
     3948 2073     
     394A 7065     
     394C 6369     
     394E 6669     
     3950 6564     
     3952 2E       
0243                       even
0244               
0245               txt.memfull.load
0246 3954 2D               byte  45
0247 3955   49             text  'Index full. File too large for editor buffer.'
     3956 6E64     
     3958 6578     
     395A 2066     
     395C 756C     
     395E 6C2E     
     3960 2046     
     3962 696C     
     3964 6520     
     3966 746F     
     3968 6F20     
     396A 6C61     
     396C 7267     
     396E 6520     
     3970 666F     
     3972 7220     
     3974 6564     
     3976 6974     
     3978 6F72     
     397A 2062     
     397C 7566     
     397E 6665     
     3980 722E     
0248                       even
0249               
0250               txt.block.inside
0251 3982 2D               byte  45
0252 3983   43             text  'Copy/Move target must be outside M1-M2 range.'
     3984 6F70     
     3986 792F     
     3988 4D6F     
     398A 7665     
     398C 2074     
     398E 6172     
     3990 6765     
     3992 7420     
     3994 6D75     
     3996 7374     
     3998 2062     
     399A 6520     
     399C 6F75     
     399E 7473     
     39A0 6964     
     39A2 6520     
     39A4 4D31     
     39A6 2D4D     
     39A8 3220     
     39AA 7261     
     39AC 6E67     
     39AE 652E     
0253                       even
0254               
0255               
0256               ;--------------------------------------------------------------
0257               ; Strings for command buffer
0258               ;--------------------------------------------------------------
0259               txt.cmdb.prompt
0260 39B0 01               byte  1
0261 39B1   3E             text  '>'
0262                       even
0263               
0264               txt.colorscheme
0265 39B2 0D               byte  13
0266 39B3   43             text  'Color scheme:'
     39B4 6F6C     
     39B6 6F72     
     39B8 2073     
     39BA 6368     
     39BC 656D     
     39BE 653A     
0267                       even
0268               
                   < ram.resident.asm
0035                       copy  "data.defaults.asm"      ; Default values (devices, ...)
     **** ****     > data.defaults.asm
0001               * FILE......: data.defaults.asm
0002               * Purpose...: Default values for Stevie
0003               
0004               ***************************************************************
0005               *                     Default values
0006               ********|*****|*********************|**************************
0007               def.printer.fname
0008 39C0 06               byte  6
0009 39C1   50             text  'PI.PIO'
     39C2 492E     
     39C4 5049     
     39C6 4F       
0010                       even
0011               
0012               def.clip.fname
0013 39C8 09               byte  9
0014 39C9   44             text  'DSK1.CLIP'
     39CA 534B     
     39CC 312E     
     39CE 434C     
     39D0 4950     
0015                       even
0016               
0017               def.clip.fname.b
0018 39D2 09               byte  9
0019 39D3   44             text  'DSK8.CLIP'
     39D4 534B     
     39D6 382E     
     39D8 434C     
     39DA 4950     
0020                       even
0021               
0022               def.clip.fname.c
0023 39DC 10               byte  16
0024 39DD   54             text  'TIPI.STEVIE.CLIP'
     39DE 4950     
     39E0 492E     
     39E2 5354     
     39E4 4556     
     39E6 4945     
     39E8 2E43     
     39EA 4C49     
     39EC 50       
0025                       even
0026               
0027               def.devices
0028 39EE 2F               byte  47
0029 39EF   2C             text  ',DSK,HDX,IDE,PI.,PIO,TIPI.,RD,SCS,SDD,WDS,RS232'
     39F0 4453     
     39F2 4B2C     
     39F4 4844     
     39F6 582C     
     39F8 4944     
     39FA 452C     
     39FC 5049     
     39FE 2E2C     
     3A00 5049     
     3A02 4F2C     
     3A04 5449     
     3A06 5049     
     3A08 2E2C     
     3A0A 5244     
     3A0C 2C53     
     3A0E 4353     
     3A10 2C53     
     3A12 4444     
     3A14 2C57     
     3A16 4453     
     3A18 2C52     
     3A1A 5332     
     3A1C 3332     
0030                       even
0031               
                   < ram.resident.asm
                   < stevie_b3.asm.76432
0038                       ;------------------------------------------------------
0039                       ; Activate bank 1 and branch to  >6036
0040                       ;------------------------------------------------------
0041 3A1E 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3A20 6002     
0042               
0046               
0047 3A22 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3A24 6046     
0048               ***************************************************************
0049               * Step 3: Include main editor modules
0050               ********|*****|*********************|**************************
0051               main:
0052               
0053                       aorg  kickstart.code2       ; >6046
0054 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 2026     
0055                       ;-----------------------------------------------------------------------
0056                       ; Include files - Shared code
0057                       ;-----------------------------------------------------------------------
0058               
0059                       ;-----------------------------------------------------------------------
0060                       ; Include files - Dialogs
0061                       ;-----------------------------------------------------------------------
0062                       copy  "dialog.menu.asm"      ; Dialog "Stevie Menu"
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
     605C 742E     
0033 605E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6060 A71C     
0034               
0035 6062 0204  20         li    tmp0,txt.info.menu
     6064 743D     
0036 6066 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6068 A71E     
0037               
0038 606A 0204  20         li    tmp0,pos.info.menu
     606C 745C     
0039 606E C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     6070 A722     
0040               
0041 6072 0204  20         li    tmp0,txt.hint.menu
     6074 7461     
0042 6076 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6078 A720     
0043               
0044 607A 0204  20         li    tmp0,txt.keys.menu
     607C 7464     
0045 607E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6080 A724     
0046               
0047 6082 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6084 6F62     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.menu.exit:
0052 6086 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6088 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 608A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0063                       copy  "dialog.help.asm"      ; Dialog "Help"
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
     60A2 7398     
0021 60A4 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     60A6 A71C     
0022               
0023 60A8 0204  20         li    tmp0,txt.about.build
     60AA 73E0     
0024 60AC C804  38         mov   tmp0,@cmdb.paninfo    ; Info line
     60AE A71E     
0025 60B0 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     60B2 A722     
0026               
0027 60B4 0204  20         li    tmp0,txt.hint.about
     60B6 73A4     
0028 60B8 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     60BA A720     
0029               
0030 60BC 0204  20         li    tmp0,txt.keys.about
     60BE 73CC     
0031 60C0 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     60C2 A724     
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
0260 6386 19               byte  25
0261 6387   43             text  'Ctrl a   ^a   Append file'
     6388 7472     
     638A 6C20     
     638C 6120     
     638E 2020     
     6390 5E61     
     6392 2020     
     6394 2041     
     6396 7070     
     6398 656E     
     639A 6420     
     639C 6669     
     639E 6C65     
0262                       even
0263               
0264               
0265 63A0 21               byte  33
0266 63A1   43             text  'Ctrl i   ^i   Insert file at line'
     63A2 7472     
     63A4 6C20     
     63A6 6920     
     63A8 2020     
     63AA 5E69     
     63AC 2020     
     63AE 2049     
     63B0 6E73     
     63B2 6572     
     63B4 7420     
     63B6 6669     
     63B8 6C65     
     63BA 2061     
     63BC 7420     
     63BE 6C69     
     63C0 6E65     
0267                       even
0268               
0269               
0270 63C2 24               byte  36
0271 63C3   43             text  'Ctrl c   ^c   Copy clipboard to line'
     63C4 7472     
     63C6 6C20     
     63C8 6320     
     63CA 2020     
     63CC 5E63     
     63CE 2020     
     63D0 2043     
     63D2 6F70     
     63D4 7920     
     63D6 636C     
     63D8 6970     
     63DA 626F     
     63DC 6172     
     63DE 6420     
     63E0 746F     
     63E2 206C     
     63E4 696E     
     63E6 65       
0272                       even
0273               
0274               
0275 63E8 17               byte  23
0276 63E9   43             text  'Ctrl o   ^o   Open file'
     63EA 7472     
     63EC 6C20     
     63EE 6F20     
     63F0 2020     
     63F2 5E6F     
     63F4 2020     
     63F6 204F     
     63F8 7065     
     63FA 6E20     
     63FC 6669     
     63FE 6C65     
0277                       even
0278               
0279               
0280 6400 18               byte  24
0281 6401   43             text  'Ctrl p   ^p   Print file'
     6402 7472     
     6404 6C20     
     6406 7020     
     6408 2020     
     640A 5E70     
     640C 2020     
     640E 2050     
     6410 7269     
     6412 6E74     
     6414 2066     
     6416 696C     
     6418 65       
0282                       even
0283               
0284               
0285 641A 17               byte  23
0286 641B   43             text  'Ctrl s   ^s   Save file'
     641C 7472     
     641E 6C20     
     6420 7320     
     6422 2020     
     6424 5E73     
     6426 2020     
     6428 2053     
     642A 6176     
     642C 6520     
     642E 6669     
     6430 6C65     
0287                       even
0288               
0289               
0290 6432 1C               byte  28
0291 6433   43             text  'Ctrl ,   ^,   Load prev file'
     6434 7472     
     6436 6C20     
     6438 2C20     
     643A 2020     
     643C 5E2C     
     643E 2020     
     6440 204C     
     6442 6F61     
     6444 6420     
     6446 7072     
     6448 6576     
     644A 2066     
     644C 696C     
     644E 65       
0292                       even
0293               
0294               
0295 6450 1C               byte  28
0296 6451   43             text  'Ctrl .   ^.   Load next file'
     6452 7472     
     6454 6C20     
     6456 2E20     
     6458 2020     
     645A 5E2E     
     645C 2020     
     645E 204C     
     6460 6F61     
     6462 6420     
     6464 6E65     
     6466 7874     
     6468 2066     
     646A 696C     
     646C 65       
0297                       even
0298               
0299               
0300 646E 23               byte  35
0301 646F   2D             text  '------------- Block mode ----------'
     6470 2D2D     
     6472 2D2D     
     6474 2D2D     
     6476 2D2D     
     6478 2D2D     
     647A 2D2D     
     647C 2042     
     647E 6C6F     
     6480 636B     
     6482 206D     
     6484 6F64     
     6486 6520     
     6488 2D2D     
     648A 2D2D     
     648C 2D2D     
     648E 2D2D     
     6490 2D2D     
0302                       even
0303               
0304               
0305 6492 1E               byte  30
0306 6493   43             text  'Ctrl SPACE    Set M1/M2 marker'
     6494 7472     
     6496 6C20     
     6498 5350     
     649A 4143     
     649C 4520     
     649E 2020     
     64A0 2053     
     64A2 6574     
     64A4 204D     
     64A6 312F     
     64A8 4D32     
     64AA 206D     
     64AC 6172     
     64AE 6B65     
     64B0 72       
0307                       even
0308               
0309               
0310 64B2 1A               byte  26
0311 64B3   43             text  'Ctrl d   ^d   Delete block'
     64B4 7472     
     64B6 6C20     
     64B8 6420     
     64BA 2020     
     64BC 5E64     
     64BE 2020     
     64C0 2044     
     64C2 656C     
     64C4 6574     
     64C6 6520     
     64C8 626C     
     64CA 6F63     
     64CC 6B       
0312                       even
0313               
0314               
0315 64CE 18               byte  24
0316 64CF   43             text  'Ctrl c   ^c   Copy block'
     64D0 7472     
     64D2 6C20     
     64D4 6320     
     64D6 2020     
     64D8 5E63     
     64DA 2020     
     64DC 2043     
     64DE 6F70     
     64E0 7920     
     64E2 626C     
     64E4 6F63     
     64E6 6B       
0317                       even
0318               
0319               
0320 64E8 1C               byte  28
0321 64E9   43             text  'Ctrl g   ^g   Goto marker M1'
     64EA 7472     
     64EC 6C20     
     64EE 6720     
     64F0 2020     
     64F2 5E67     
     64F4 2020     
     64F6 2047     
     64F8 6F74     
     64FA 6F20     
     64FC 6D61     
     64FE 726B     
     6500 6572     
     6502 204D     
     6504 31       
0322                       even
0323               
0324               
0325 6506 18               byte  24
0326 6507   43             text  'Ctrl m   ^m   Move block'
     6508 7472     
     650A 6C20     
     650C 6D20     
     650E 2020     
     6510 5E6D     
     6512 2020     
     6514 204D     
     6516 6F76     
     6518 6520     
     651A 626C     
     651C 6F63     
     651E 6B       
0327                       even
0328               
0329               
0330 6520 20               byte  32
0331 6521   43             text  'Ctrl s   ^s   Save block to file'
     6522 7472     
     6524 6C20     
     6526 7320     
     6528 2020     
     652A 5E73     
     652C 2020     
     652E 2053     
     6530 6176     
     6532 6520     
     6534 626C     
     6536 6F63     
     6538 6B20     
     653A 746F     
     653C 2066     
     653E 696C     
     6540 65       
0332                       even
0333               
0334               
0335 6542 23               byte  35
0336 6543   43             text  'Ctrl ^1..^5   Copy to clipboard 1-5'
     6544 7472     
     6546 6C20     
     6548 5E31     
     654A 2E2E     
     654C 5E35     
     654E 2020     
     6550 2043     
     6552 6F70     
     6554 7920     
     6556 746F     
     6558 2063     
     655A 6C69     
     655C 7062     
     655E 6F61     
     6560 7264     
     6562 2031     
     6564 2D35     
0337                       even
0338               
0339               
0340 6566 23               byte  35
0341 6567   2D             text  '------------- Modifiers -----------'
     6568 2D2D     
     656A 2D2D     
     656C 2D2D     
     656E 2D2D     
     6570 2D2D     
     6572 2D2D     
     6574 204D     
     6576 6F64     
     6578 6966     
     657A 6965     
     657C 7273     
     657E 202D     
     6580 2D2D     
     6582 2D2D     
     6584 2D2D     
     6586 2D2D     
     6588 2D2D     
0342                       even
0343               
0344               
0345 658A 1E               byte  30
0346 658B   46             text  'Fctn 1        Delete character'
     658C 6374     
     658E 6E20     
     6590 3120     
     6592 2020     
     6594 2020     
     6596 2020     
     6598 2044     
     659A 656C     
     659C 6574     
     659E 6520     
     65A0 6368     
     65A2 6172     
     65A4 6163     
     65A6 7465     
     65A8 72       
0347                       even
0348               
0349               
0350 65AA 1E               byte  30
0351 65AB   46             text  'Fctn 2        Insert character'
     65AC 6374     
     65AE 6E20     
     65B0 3220     
     65B2 2020     
     65B4 2020     
     65B6 2020     
     65B8 2049     
     65BA 6E73     
     65BC 6572     
     65BE 7420     
     65C0 6368     
     65C2 6172     
     65C4 6163     
     65C6 7465     
     65C8 72       
0352                       even
0353               
0354               
0355 65CA 19               byte  25
0356 65CB   46             text  'Fctn 3        Delete line'
     65CC 6374     
     65CE 6E20     
     65D0 3320     
     65D2 2020     
     65D4 2020     
     65D6 2020     
     65D8 2044     
     65DA 656C     
     65DC 6574     
     65DE 6520     
     65E0 6C69     
     65E2 6E65     
0357                       even
0358               
0359               
0360 65E4 20               byte  32
0361 65E5   43             text  'Ctrl l   ^l   Delete end of line'
     65E6 7472     
     65E8 6C20     
     65EA 6C20     
     65EC 2020     
     65EE 5E6C     
     65F0 2020     
     65F2 2044     
     65F4 656C     
     65F6 6574     
     65F8 6520     
     65FA 656E     
     65FC 6420     
     65FE 6F66     
     6600 206C     
     6602 696E     
     6604 65       
0362                       even
0363               
0364               
0365 6606 19               byte  25
0366 6607   46             text  'Fctn 8        Insert line'
     6608 6374     
     660A 6E20     
     660C 3820     
     660E 2020     
     6610 2020     
     6612 2020     
     6614 2049     
     6616 6E73     
     6618 6572     
     661A 7420     
     661C 6C69     
     661E 6E65     
0367                       even
0368               
0369               
0370 6620 1E               byte  30
0371 6621   46             text  'Fctn .        Insert/Overwrite'
     6622 6374     
     6624 6E20     
     6626 2E20     
     6628 2020     
     662A 2020     
     662C 2020     
     662E 2049     
     6630 6E73     
     6632 6572     
     6634 742F     
     6636 4F76     
     6638 6572     
     663A 7772     
     663C 6974     
     663E 65       
0372                       even
0373               
                   < stevie_b3.asm.76432
0064                       copy  "dialog.file.asm"      ; Dialog "File"
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
0022 6640 0649  14         dect  stack
0023 6642 C64B  30         mov   r11,*stack            ; Save return address
0024 6644 0649  14         dect  stack
0025 6646 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6648 0204  20         li    tmp0,id.dialog.file
     664A 0069     
0030 664C C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     664E A71A     
0031               
0032 6650 0204  20         li    tmp0,txt.head.file
     6652 746C     
0033 6654 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6656 A71C     
0034               
0035 6658 0204  20         li    tmp0,txt.info.file
     665A 7476     
0036 665C C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     665E A71E     
0037               
0038 6660 0204  20         li    tmp0,pos.info.file
     6662 749C     
0039 6664 C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     6666 A722     
0040               
0041 6668 0204  20         li    tmp0,txt.hint.file
     666A 74A2     
0042 666C C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     666E A720     
0043               
0044 6670 0204  20         li    tmp0,txt.keys.file
     6672 74A4     
0045 6674 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6676 A724     
0046               
0047 6678 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     667A 6F62     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.file.exit:
0052 667C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 667E C2F9  30         mov   *stack+,r11           ; Pop R11
0054 6680 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0065                       copy  "dialog.cartridge.asm" ; Dialog "Cartridge"
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
0022 6682 0649  14         dect  stack
0023 6684 C64B  30         mov   r11,*stack            ; Save return address
0024 6686 0649  14         dect  stack
0025 6688 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 668A 0204  20         li    tmp0,id.dialog.cartridge
     668C 006A     
0030 668E C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6690 A71A     
0031               
0032 6692 0204  20         li    tmp0,txt.head.cartridge
     6694 74AC     
0033 6696 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6698 A71C     
0034               
0035 669A 0204  20         li    tmp0,txt.info.cartridge
     669C 74BB     
0036 669E C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     66A0 A71E     
0037               
0038 66A2 0204  20         li    tmp0,pos.info.cartridge
     66A4 74D2     
0039 66A6 C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     66A8 A722     
0040               
0041 66AA 0204  20         li    tmp0,txt.hint.cartridge
     66AC 74D5     
0042 66AE C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     66B0 A720     
0043               
0044 66B2 0204  20         li    tmp0,txt.keys.cartridge
     66B4 74EE     
0045 66B6 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     66B8 A724     
0046               
0047 66BA 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     66BC 6F62     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.cartridge.exit:
0052 66BE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 66C0 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 66C2 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0066                       copy  "dialog.load.asm"      ; Dialog "Load file"
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
0022 66C4 0649  14         dect  stack
0023 66C6 C64B  30         mov   r11,*stack            ; Save return address
0024 66C8 0649  14         dect  stack
0025 66CA C644  30         mov   tmp0,*stack           ; Push tmp0
0026 66CC 0649  14         dect  stack
0027 66CE C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Show dialog "Unsaved changes" if editor buffer dirty
0030                       ;-------------------------------------------------------
0031 66D0 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     66D2 A506     
0032 66D4 1303  14         jeq   dialog.load.setup     ; No, skip "Unsaved changes"
0033               
0034 66D6 06A0  32         bl    @dialog.unsaved       ; Show dialog
     66D8 6A46     
0035 66DA 1029  14         jmp   dialog.load.exit      ; Exit early
0036                       ;-------------------------------------------------------
0037                       ; Setup dialog
0038                       ;-------------------------------------------------------
0039               dialog.load.setup:
0040 66DC 06A0  32         bl    @fb.scan.fname        ; Get possible device/filename
     66DE 6F98     
0041               
0042 66E0 0204  20         li    tmp0,id.dialog.load
     66E2 000A     
0043 66E4 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     66E6 A71A     
0044               
0045 66E8 0204  20         li    tmp0,txt.head.load
     66EA 7040     
0046 66EC C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     66EE A71C     
0047               
0048 66F0 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     66F2 A71E     
0049 66F4 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     66F6 A722     
0050               
0051 66F8 0204  20         li    tmp0,txt.hint.load
     66FA 704F     
0052 66FC C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     66FE A720     
0053               
0054 6700 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6702 A44E     
0055 6704 1303  14         jeq   !
0056                       ;-------------------------------------------------------
0057                       ; Show that FastMode is on
0058                       ;-------------------------------------------------------
0059 6706 0204  20         li    tmp0,txt.keys.load2   ; Highlight FastMode
     6708 7020     
0060 670A 1002  14         jmp   dialog.load.keylist
0061                       ;-------------------------------------------------------
0062                       ; Show that FastMode is off
0063                       ;-------------------------------------------------------
0064 670C 0204  20 !       li    tmp0,txt.keys.load
     670E 7000     
0065                       ;-------------------------------------------------------
0066                       ; Show dialog
0067                       ;-------------------------------------------------------
0068               dialog.load.keylist:
0069 6710 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6712 A724     
0070                       ;-------------------------------------------------------
0071                       ; Set command line
0072                       ;-------------------------------------------------------
0073 6714 0204  20         li    tmp0,cmdb.dflt.fname  ; Get pointer to default filename
     6716 A7AC     
0074 6718 C154  26         mov   *tmp0,tmp1            ; Anything set?
0075 671A 1304  14         jeq   dialog.load.cursor    ; No default filename, skip
0076               
0077 671C C804  38         mov   tmp0,@parm1           ; Get pointer to string
     671E A000     
0078 6720 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6722 6DB6     
0079                                                   ; \ i  @parm1 = Pointer to string w. preset
0080                                                   ; /
0081                       ;-------------------------------------------------------
0082                       ; Set cursor shape
0083                       ;-------------------------------------------------------
0084               dialog.load.cursor:
0085 6724 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6726 6F50     
0086 6728 C820  54         mov   @tv.curshape,@ramsat+2
     672A A214     
     672C A03C     
0087                                                   ; Get cursor shape and color
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               dialog.load.exit:
0092 672E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0093 6730 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0094 6732 C2F9  30         mov   *stack+,r11           ; Pop R11
0095 6734 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0067                       copy  "dialog.save.asm"      ; Dialog "Save file"
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
0022 6736 0649  14         dect  stack
0023 6738 C64B  30         mov   r11,*stack            ; Save return address
0024 673A 0649  14         dect  stack
0025 673C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029 673E 8820  54         c     @fb.row.dirty,@w$ffff
     6740 A30A     
     6742 2022     
0030 6744 1604  14         jne   !                     ; Skip crunching if clean
0031 6746 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6748 6EF6     
0032 674A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     674C A30A     
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036 674E 8820  54 !       c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6750 A50E     
     6752 2022     
0037 6754 130B  14         jeq   dialog.save.default   ; Yes, so show default dialog
0038                       ;-------------------------------------------------------
0039                       ; Setup dialog title
0040                       ;-------------------------------------------------------
0041 6756 06A0  32         bl    @cmdb.cmd.clear       ; Clear current CMDB command
     6758 6D6E     
0042               
0043 675A 0204  20         li    tmp0,id.dialog.saveblock
     675C 000C     
0044 675E C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6760 A71A     
0045 6762 0204  20         li    tmp0,txt.head.save2   ; Title "Save block to file"
     6764 707D     
0046 6766 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6768 A71C     
0047 676A 100E  14         jmp   dialog.save.header
0048                       ;-------------------------------------------------------
0049                       ; Default dialog
0050                       ;-------------------------------------------------------
0051               dialog.save.default:
0052 676C 0204  20         li    tmp0,id.dialog.save
     676E 000B     
0053 6770 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6772 A71A     
0054 6774 0204  20         li    tmp0,txt.head.save    ; Title "Save file"
     6776 706E     
0055 6778 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     677A A71C     
0056                       ;-------------------------------------------------------
0057                       ; Set command line
0058                       ;-------------------------------------------------------
0059 677C 0204  20         li    tmp0,edb.filename     ; Set filename
     677E A51A     
0060 6780 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     6782 A000     
0061               
0062 6784 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6786 6DB6     
0063                                                   ; \ i  @parm1 = Pointer to string w. preset
0064                                                   ; /
0065                       ;-------------------------------------------------------
0066                       ; Setup header
0067                       ;-------------------------------------------------------
0068               dialog.save.header:
0069               
0070 6788 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     678A A71E     
0071 678C 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     678E A722     
0072               
0073 6790 0204  20         li    tmp0,txt.hint.save
     6792 7095     
0074 6794 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6796 A720     
0075               
0076 6798 0204  20         li    tmp0,txt.keys.save
     679A 70B4     
0077 679C C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     679E A724     
0078               
0079 67A0 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     67A2 A44E     
0080                       ;-------------------------------------------------------
0081                       ; Set cursor shape
0082                       ;-------------------------------------------------------
0083 67A4 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     67A6 6F50     
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               dialog.save.exit:
0088 67A8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 67AA C2F9  30         mov   *stack+,r11           ; Pop R11
0090 67AC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0068                       copy  "dialog.print.asm"     ; Dialog "Print file"
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
0022 67AE 0649  14         dect  stack
0023 67B0 C64B  30         mov   r11,*stack            ; Save return address
0024 67B2 0649  14         dect  stack
0025 67B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029 67B6 8820  54         c     @fb.row.dirty,@w$ffff
     67B8 A30A     
     67BA 2022     
0030 67BC 1604  14         jne   !                     ; Skip crunching if clean
0031 67BE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     67C0 6EF6     
0032 67C2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     67C4 A30A     
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036 67C6 8820  54 !       c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67C8 A50E     
     67CA 2022     
0037 67CC 1307  14         jeq   dialog.print.default  ; Yes, so show default dialog
0038                       ;-------------------------------------------------------
0039                       ; Setup dialog title
0040                       ;-------------------------------------------------------
0041 67CE 0204  20         li    tmp0,id.dialog.printblock
     67D0 0010     
0042 67D2 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     67D4 A71A     
0043 67D6 0204  20         li    tmp0,txt.head.print2  ; Title "Print block to file"
     67D8 72B2     
0044               
0045 67DA 1006  14         jmp   dialog.print.header
0046                       ;-------------------------------------------------------
0047                       ; Default dialog
0048                       ;-------------------------------------------------------
0049               dialog.print.default:
0050 67DC 0204  20         li    tmp0,id.dialog.print
     67DE 000F     
0051 67E0 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     67E2 A71A     
0052 67E4 0204  20         li    tmp0,txt.head.print   ; Title "Print file"
     67E6 72A2     
0053                       ;-------------------------------------------------------
0054                       ; Setup header
0055                       ;-------------------------------------------------------
0056               dialog.print.header:
0057 67E8 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     67EA A71C     
0058               
0059 67EC 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     67EE A71E     
0060 67F0 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     67F2 A722     
0061               
0062 67F4 0204  20         li    tmp0,txt.hint.print
     67F6 72C3     
0063 67F8 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     67FA A720     
0064               
0065 67FC 0204  20         li    tmp0,txt.keys.save
     67FE 70B4     
0066 6800 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6802 A724     
0067               
0068 6804 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     6806 A44E     
0069                       ;-------------------------------------------------------
0070                       ; Set command line
0071                       ;-------------------------------------------------------
0072 6808 0204  20         li    tmp0,tv.printer.fname ; Set printer name
     680A D960     
0073 680C C804  38         mov   tmp0,@parm1           ; Get pointer to string
     680E A000     
0074               
0075 6810 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6812 6DB6     
0076                                                   ; \ i  @parm1 = Pointer to string w. preset
0077                                                   ; /
0078                       ;-------------------------------------------------------
0079                       ; Set cursor shape
0080                       ;-------------------------------------------------------
0081 6814 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6816 6F50     
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               dialog.print.exit:
0086 6818 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 681A C2F9  30         mov   *stack+,r11           ; Pop R11
0088 681C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0069                       copy  "dialog.append.asm"    ; Dialog "Append file"
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
0022 681E 0649  14         dect  stack
0023 6820 C64B  30         mov   r11,*stack            ; Save return address
0024 6822 0649  14         dect  stack
0025 6824 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6826 0649  14         dect  stack
0027 6828 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Setup dialog
0030                       ;-------------------------------------------------------
0031               dialog.append.setup:
0032 682A 06A0  32         bl    @fb.scan.fname        ; Get possible device/filename
     682C 6F98     
0033               
0034 682E 0204  20         li    tmp0,id.dialog.append
     6830 000E     
0035 6832 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6834 A71A     
0036               
0037 6836 0204  20         li    tmp0,txt.head.append
     6838 70C6     
0038 683A C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     683C A71C     
0039               
0040 683E 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     6840 A71E     
0041 6842 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6844 A722     
0042               
0043 6846 0204  20         li    tmp0,txt.hint.append
     6848 70D7     
0044 684A C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     684C A720     
0045               
0046 684E 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6850 A44E     
0047 6852 1303  14         jeq   !
0048                       ;-------------------------------------------------------
0049                       ; Show that FastMode is on
0050                       ;-------------------------------------------------------
0051 6854 0204  20         li    tmp0,txt.keys.insert  ; Highlight FastMode
     6856 7000     
0052 6858 1002  14         jmp   dialog.append.keylist
0053                       ;-------------------------------------------------------
0054                       ; Show that FastMode is off
0055                       ;-------------------------------------------------------
0056 685A 0204  20 !       li    tmp0,txt.keys.insert
     685C 7000     
0057                       ;-------------------------------------------------------
0058                       ; Show dialog
0059                       ;-------------------------------------------------------
0060               dialog.append.keylist:
0061 685E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6860 A724     
0062                       ;-------------------------------------------------------
0063                       ; Set command line
0064                       ;-------------------------------------------------------
0065 6862 0204  20         li    tmp0,cmdb.dflt.fname  ; Get pointer to default filename
     6864 A7AC     
0066 6866 C154  26         mov   *tmp0,tmp1            ; Anything set?
0067 6868 1304  14         jeq   dialog.append.cursor  ; No default filename, skip
0068               
0069 686A C804  38         mov   tmp0,@parm1           ; Get pointer to string
     686C A000     
0070 686E 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6870 6DB6     
0071                                                   ; \ i  @parm1 = Pointer to string w. preset
0072                                                   ; /
0073                       ;-------------------------------------------------------
0074                       ; Set cursor shape
0075                       ;-------------------------------------------------------
0076               dialog.append.cursor:
0077 6872 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6874 6F50     
0078 6876 C820  54         mov   @tv.curshape,@ramsat+2
     6878 A214     
     687A A03C     
0079                                                   ; Get cursor shape and color
0080                       ;-------------------------------------------------------
0081                       ; Exit
0082                       ;-------------------------------------------------------
0083               dialog.append.exit:
0084 687C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0085 687E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0086 6880 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 6882 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0070                       copy  "dialog.insert.asm"    ; Dialog "Insert file at line"
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
0022 6884 0649  14         dect  stack
0023 6886 C64B  30         mov   r11,*stack            ; Save return address
0024 6888 0649  14         dect  stack
0025 688A C644  30         mov   tmp0,*stack           ; Push tmp0
0026 688C 0649  14         dect  stack
0027 688E C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Setup dialog
0030                       ;-------------------------------------------------------
0031               dialog.insert.setup:
0032 6890 06A0  32         bl    @fb.scan.fname        ; Get possible device/filename
     6892 6F98     
0033               
0034 6894 0204  20         li    tmp0,id.dialog.insert
     6896 000D     
0035 6898 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     689A A71A     
0036                       ;------------------------------------------------------
0037                       ; Include line number in pane header
0038                       ;------------------------------------------------------
0039 689C 06A0  32         bl    @film
     689E 224A     
0040 68A0 A77A                   data cmdb.panhead.buf,>00,50
     68A2 0000     
     68A4 0032     
0041                                                   ; Clear pane header buffer
0042               
0043 68A6 06A0  32         bl    @cpym2m
     68A8 24EE     
0044 68AA 7118                   data txt.head.insert,cmdb.panhead.buf,25
     68AC A77A     
     68AE 0019     
0045               
0046 68B0 C820  54         mov   @fb.row,@parm1        ; Get row at cursor
     68B2 A306     
     68B4 A000     
0047 68B6 06A0  32         bl    @fb.row2line          ; Row to editor line
     68B8 6F2C     
0048                                                   ; \ i @fb.topline = Top line in frame buffer
0049                                                   ; | i @parm1      = Row in frame buffer
0050                                                   ; / o @outparm1   = Matching line in EB
0051               
0052 68BA 05E0  34         inct  @outparm1             ; \ Add base 1 and insert at line
     68BC A010     
0053                                                   ; / following cursor, not line at cursor.
0054               
0055 68BE 06A0  32         bl    @mknum                ; Convert integer to string
     68C0 2AB4     
0056 68C2 A010                   data  outparm1        ; \ i  p0 = Pointer to 16 bit unsigned int
0057 68C4 A100                   data  rambuf          ; | i  p1 = Pointer to 5 byte string buffer
0058 68C6 30                     byte  48              ; | i  p2 = MSB offset for ASCII digit
0059 68C7   30                   byte  48              ; / i  p2 = LSB char for replacing leading 0
0060               
0061 68C8 06A0  32         bl    @cpym2m
     68CA 24EE     
0062 68CC A100                   data rambuf,cmdb.panhead.buf + 24,5
     68CE A792     
     68D0 0005     
0063                                                   ; Add line number to buffer
0064               
0065 68D2 0204  20         li    tmp0,29
     68D4 001D     
0066 68D6 0A84  56         sla   tmp0,8
0067 68D8 D804  38         movb  tmp0,@cmdb.panhead.buf ; Set length byte
     68DA A77A     
0068               
0069 68DC 0204  20         li    tmp0,cmdb.panhead.buf
     68DE A77A     
0070 68E0 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     68E2 A71C     
0071                       ;------------------------------------------------------
0072                       ; Other panel strings
0073                       ;------------------------------------------------------
0074 68E4 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     68E6 A71E     
0075 68E8 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     68EA A722     
0076               
0077 68EC 0204  20         li    tmp0,txt.hint.insert
     68EE 7131     
0078 68F0 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     68F2 A720     
0079               
0080 68F4 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     68F6 A44E     
0081 68F8 1303  14         jeq   !
0082                       ;-------------------------------------------------------
0083                       ; Show that FastMode is on
0084                       ;-------------------------------------------------------
0085 68FA 0204  20         li    tmp0,txt.keys.insert  ; Highlight FastMode
     68FC 7000     
0086 68FE 1002  14         jmp   dialog.insert.keylist
0087                       ;-------------------------------------------------------
0088                       ; Show that FastMode is off
0089                       ;-------------------------------------------------------
0090 6900 0204  20 !       li    tmp0,txt.keys.insert
     6902 7000     
0091                       ;-------------------------------------------------------
0092                       ; Show dialog
0093                       ;-------------------------------------------------------
0094               dialog.insert.keylist:
0095 6904 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6906 A724     
0096                       ;-------------------------------------------------------
0097                       ; Set command line
0098                       ;-------------------------------------------------------
0099 6908 0204  20         li    tmp0,cmdb.dflt.fname  ; Get pointer to default filename
     690A A7AC     
0100 690C C154  26         mov   *tmp0,tmp1            ; Anything set?
0101 690E 1304  14         jeq   dialog.insert.cursor  ; No default filename, skip
0102               
0103 6910 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     6912 A000     
0104 6914 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6916 6DB6     
0105                                                   ; \ i  @parm1 = Pointer to string w. preset
0106                                                   ; /
0107                       ;-------------------------------------------------------
0108                       ; Set cursor shape
0109                       ;-------------------------------------------------------
0110               dialog.insert.cursor:
0111 6918 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     691A 6F50     
0112 691C C820  54         mov   @tv.curshape,@ramsat+2
     691E A214     
     6920 A03C     
0113                                                   ; Get cursor shape and color
0114                       ;-------------------------------------------------------
0115                       ; Exit
0116                       ;-------------------------------------------------------
0117               dialog.insert.exit:
0118 6922 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0119 6924 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0120 6926 C2F9  30         mov   *stack+,r11           ; Pop R11
0121 6928 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0071                       copy  "dialog.config.asm"    ; Dialog "Configure"
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
0022 692A 0649  14         dect  stack
0023 692C C64B  30         mov   r11,*stack            ; Save return address
0024 692E 0649  14         dect  stack
0025 6930 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6932 0204  20         li    tmp0,id.dialog.config
     6934 006C     
0030 6936 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6938 A71A     
0031               
0032 693A 0204  20         li    tmp0,txt.head.config
     693C 7564     
0033 693E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6940 A71C     
0034               
0035 6942 0204  20         li    tmp0,txt.info.config
     6944 7573     
0036 6946 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6948 A71E     
0037               
0038 694A 0204  20         li    tmp0,pos.info.config
     694C 757E     
0039 694E C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     6950 A722     
0040               
0041 6952 0204  20         li    tmp0,txt.hint.config
     6954 7580     
0042 6956 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6958 A720     
0043               
0044 695A 0204  20         li    tmp0,txt.keys.config
     695C 7582     
0045 695E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6960 A724     
0046               
0047 6962 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6964 6F62     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.config.exit:
0052 6966 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6968 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 696A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0072                       copy  "dialog.clipdev.asm"   ; Dialog "Configure clipboard device"
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
0022 696C 0649  14         dect  stack
0023 696E C64B  30         mov   r11,*stack            ; Save return address
0024 6970 0649  14         dect  stack
0025 6972 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6974 0204  20         li    tmp0,id.dialog.clipdev
     6976 0011     
0030 6978 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     697A A71A     
0031               
0032 697C 0204  20         li    tmp0,txt.head.clipdev
     697E 7152     
0033 6980 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6982 A71C     
0034               
0035 6984 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     6986 A71E     
0036 6988 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     698A A722     
0037               
0038 698C 0204  20         li    tmp0,txt.hint.clipdev
     698E 7172     
0039 6990 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6992 A720     
0040               
0041 6994 0204  20         li    tmp0,txt.keys.clipdev
     6996 71A0     
0042 6998 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     699A A724     
0043                       ;-------------------------------------------------------
0044                       ; Set command line
0045                       ;-------------------------------------------------------
0046 699C 0204  20         li    tmp0,tv.clip.fname    ; Set clipboard
     699E D9B0     
0047 69A0 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     69A2 A000     
0048               
0049 69A4 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     69A6 6DB6     
0050                                                   ; \ i  @parm1 = Pointer to string w. preset
0051                                                   ; /
0052                       ;-------------------------------------------------------
0053                       ; Set cursor shape
0054                       ;-------------------------------------------------------
0055 69A8 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     69AA 6F50     
0056 69AC C820  54         mov   @tv.curshape,@ramsat+2
     69AE A214     
     69B0 A03C     
0057                                                   ; Get cursor shape and color
0058                       ;-------------------------------------------------------
0059                       ; Exit
0060                       ;-------------------------------------------------------
0061               dialog.clipdevice.exit:
0062 69B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0063 69B4 C2F9  30         mov   *stack+,r11           ; Pop R11
0064 69B6 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0073                       copy  "dialog.clipboard.asm" ; Dialog "Copy from clipboard"
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
0022 69B8 0649  14         dect  stack
0023 69BA C64B  30         mov   r11,*stack            ; Save return address
0024 69BC 0649  14         dect  stack
0025 69BE C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029               dialog.clipboard.setup:
0030 69C0 0204  20         li    tmp0,id.dialog.clipboard
     69C2 0067     
0031 69C4 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     69C6 A71A     
0032                       ;------------------------------------------------------
0033                       ; Include line number in pane header
0034                       ;------------------------------------------------------
0035 69C8 06A0  32         bl    @film
     69CA 224A     
0036 69CC A77A                   data cmdb.panhead.buf,>00,50
     69CE 0000     
     69D0 0032     
0037                                                   ; Clear pane header buffer
0038               
0039 69D2 06A0  32         bl    @cpym2m
     69D4 24EE     
0040 69D6 71E4                   data txt.head.clipboard,cmdb.panhead.buf,27
     69D8 A77A     
     69DA 001B     
0041               
0042 69DC C820  54         mov   @fb.row,@parm1
     69DE A306     
     69E0 A000     
0043 69E2 06A0  32         bl    @fb.row2line          ; Row to editor line
     69E4 6F2C     
0044                                                   ; \ i @fb.topline = Top line in frame buffer
0045                                                   ; | i @parm1      = Row in frame buffer
0046                                                   ; / o @outparm1   = Matching line in EB
0047               
0048 69E6 05A0  34         inc   @outparm1             ; Add base 1
     69E8 A010     
0049               
0050 69EA 06A0  32         bl    @mknum                ; Convert integer to string
     69EC 2AB4     
0051 69EE A010                   data  outparm1        ; \ i  p0 = Pointer to 16 bit unsigned int
0052 69F0 A100                   data  rambuf          ; | i  p1 = Pointer to 5 byte string buffer
0053 69F2 30                     byte  48              ; | i  p2 = MSB offset for ASCII digit
0054 69F3   30                   byte  48              ; / i  p2 = LSB char for replacing leading 0
0055               
0056 69F4 06A0  32         bl    @cpym2m
     69F6 24EE     
0057 69F8 A100                   data rambuf,cmdb.panhead.buf + 27,5
     69FA A795     
     69FC 0005     
0058                                                   ; Add line number to buffer
0059               
0060 69FE 0204  20         li    tmp0,32
     6A00 0020     
0061 6A02 0A84  56         sla   tmp0,8
0062 6A04 D804  38         movb  tmp0,@cmdb.panhead.buf
     6A06 A77A     
0063                                                   ; Set length byte
0064               
0065 6A08 0204  20         li    tmp0,cmdb.panhead.buf
     6A0A A77A     
0066 6A0C C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6A0E A71C     
0067                       ;------------------------------------------------------
0068                       ; Other panel strings
0069                       ;------------------------------------------------------
0070 6A10 0204  20         li    tmp0,txt.hint.clipboard
     6A12 7212     
0071 6A14 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6A16 A720     
0072               
0073 6A18 0204  20         li    tmp0,txt.info.clipboard
     6A1A 7200     
0074 6A1C C804  38         mov   tmp0,@cmdb.paninfo    ; Show info message
     6A1E A71E     
0075               
0076 6A20 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6A22 A722     
0077               
0078 6A24 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6A26 6D6E     
0079               
0080 6A28 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6A2A A44E     
0081 6A2C 1303  14         jeq   !
0082                       ;-------------------------------------------------------
0083                       ; Show that FastMode is on
0084                       ;-------------------------------------------------------
0085 6A2E 0204  20         li    tmp0,txt.keys.clipboard ; Highlight FastMode
     6A30 725A     
0086 6A32 1002  14         jmp   dialog.clipboard.keylist
0087                       ;-------------------------------------------------------
0088                       ; Show that FastMode is off
0089                       ;-------------------------------------------------------
0090 6A34 0204  20 !       li    tmp0,txt.keys.clipboard
     6A36 725A     
0091                       ;-------------------------------------------------------
0092                       ; Show dialog
0093                       ;-------------------------------------------------------
0094               dialog.clipboard.keylist:
0095 6A38 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6A3A A724     
0096               
0097 6A3C 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6A3E 6F62     
0098                       ;-------------------------------------------------------
0099                       ; Exit
0100                       ;-------------------------------------------------------
0101               dialog.clipboard.exit:
0102 6A40 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0103 6A42 C2F9  30         mov   *stack+,r11           ; Pop R11
0104 6A44 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0074                       copy  "dialog.unsaved.asm"   ; Dialog "Unsaved changes"
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
0022 6A46 0649  14         dect  stack
0023 6A48 C64B  30         mov   r11,*stack            ; Save return address
0024 6A4A 0649  14         dect  stack
0025 6A4C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6A4E 0204  20         li    tmp0,id.dialog.unsaved
     6A50 0065     
0030 6A52 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6A54 A71A     
0031               
0032 6A56 0204  20         li    tmp0,txt.head.unsaved
     6A58 7302     
0033 6A5A C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6A5C A71C     
0034               
0035 6A5E 0204  20         li    tmp0,txt.info.unsaved
     6A60 7317     
0036 6A62 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6A64 A71E     
0037 6A66 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6A68 A722     
0038               
0039 6A6A 0204  20         li    tmp0,txt.hint.unsaved
     6A6C 733A     
0040 6A6E C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6A70 A720     
0041               
0042 6A72 0204  20         li    tmp0,txt.keys.unsaved
     6A74 7372     
0043 6A76 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6A78 A724     
0044               
0045 6A7A 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6A7C 6F62     
0046                       ;-------------------------------------------------------
0047                       ; Exit
0048                       ;-------------------------------------------------------
0049               dialog.unsaved.exit:
0050 6A7E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 6A80 C2F9  30         mov   *stack+,r11           ; Pop R11
0052 6A82 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0075                       copy  "dialog.basic.asm"     ; Dialog "Basic"
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
0022 6A84 0649  14         dect  stack
0023 6A86 C64B  30         mov   r11,*stack            ; Save return address
0024 6A88 0649  14         dect  stack
0025 6A8A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6A8C 0204  20         li    tmp0,id.dialog.basic
     6A8E 006B     
0030 6A90 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6A92 A71A     
0031               
0032 6A94 0204  20         li    tmp0,txt.head.basic
     6A96 74F6     
0033 6A98 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6A9A A71C     
0034               
0035 6A9C 0204  20         li    tmp0,txt.info.basic
     6A9E 7505     
0036 6AA0 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6AA2 A71E     
0037               
0038 6AA4 0204  20         li    tmp0,pos.info.basic
     6AA6 7516     
0039 6AA8 C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     6AAA A722     
0040               
0041 6AAC 0204  20         li    tmp0,txt.hint.basic
     6AAE 7518     
0042 6AB0 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6AB2 A720     
0043               
0044 6AB4 0204  20         li    tmp0,txt.keys.basic
     6AB6 7554     
0045 6AB8 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6ABA A724     
0046               
0047 6ABC 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6ABE 6F62     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.basic.exit:
0052 6AC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6AC2 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 6AC4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0076                       ;-----------------------------------------------------------------------
0077                       ; Command buffer handling
0078                       ;-----------------------------------------------------------------------
0079                       copy  "pane.utils.hint.asm" ; Show hint in pane
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
0021 6AC6 0649  14         dect  stack
0022 6AC8 C64B  30         mov   r11,*stack            ; Save return address
0023 6ACA 0649  14         dect  stack
0024 6ACC C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6ACE 0649  14         dect  stack
0026 6AD0 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6AD2 0649  14         dect  stack
0028 6AD4 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 6AD6 0649  14         dect  stack
0030 6AD8 C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 6ADA C820  54         mov   @parm1,@wyx           ; Set cursor
     6ADC A000     
     6ADE 832A     
0035 6AE0 C160  34         mov   @parm2,tmp1           ; Get string to display
     6AE2 A002     
0036 6AE4 06A0  32         bl    @xutst0               ; Display string
     6AE6 2434     
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 6AE8 C120  34         mov   @parm2,tmp0
     6AEA A002     
0041 6AEC D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 6AEE 0984  56         srl   tmp0,8                ; Right justify
0043 6AF0 C184  18         mov   tmp0,tmp2
0044 6AF2 C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 6AF4 0506  16         neg   tmp2
0046 6AF6 0226  22         ai    tmp2,80               ; Number of bytes to fill
     6AF8 0050     
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 6AFA C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     6AFC A000     
0051 6AFE A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 6B00 C804  38         mov   tmp0,@wyx             ; / Set cursor
     6B02 832A     
0053               
0054 6B04 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6B06 240E     
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 6B08 0205  20         li    tmp1,32               ; Byte to fill
     6B0A 0020     
0059               
0060 6B0C 06A0  32         bl    @xfilv                ; Clear line
     6B0E 22A8     
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 6B10 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 6B12 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 6B14 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 6B16 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 6B18 C2F9  30         mov   *stack+,r11           ; Pop R11
0073 6B1A 045B  20         b     *r11                  ; Return to caller
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
0095 6B1C C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     6B1E A000     
0096 6B20 C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     6B22 A002     
0097 6B24 0649  14         dect  stack
0098 6B26 C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 6B28 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6B2A 6AC6     
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 6B2C C2F9  30         mov   *stack+,r11           ; Pop R11
0108 6B2E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0080                       copy  "pane.cmdb.show.asm"  ; Show command buffer pane
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
0022 6B30 0649  14         dect  stack
0023 6B32 C64B  30         mov   r11,*stack            ; Save return address
0024 6B34 0649  14         dect  stack
0025 6B36 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 6B38 C820  54         mov   @wyx,@cmdb.fb.yxsave
     6B3A 832A     
     6B3C A704     
0030                                                   ; Save YX position in frame buffer
0031               
0032 6B3E 0204  20         li    tmp0,pane.botrow
     6B40 001D     
0033 6B42 6120  34         s     @cmdb.scrrows,tmp0
     6B44 A706     
0034 6B46 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     6B48 A31A     
0035               
0036 6B4A 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 6B4C C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     6B4E A70E     
0038               
0039 6B50 0224  22         ai    tmp0,>0100
     6B52 0100     
0040 6B54 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     6B56 A710     
0041 6B58 0584  14         inc   tmp0
0042 6B5A C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     6B5C A70A     
0043               
0044 6B5E 0720  34         seto  @cmdb.visible         ; Show pane
     6B60 A702     
0045               
0046 6B62 0204  20         li    tmp0,tv.1timeonly     ; \ Set CMDB dirty flag (trigger redraw),
     6B64 00FE     
0047 6B66 C804  38         mov   tmp0,@cmdb.dirty      ; / but colorize CMDB pane only once.
     6B68 A718     
0048               
0049 6B6A 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     6B6C 0001     
0050 6B6E C804  38         mov   tmp0,@tv.pane.focus   ; /
     6B70 A222     
0051               
0052 6B72 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     6B74 6F3E     
0053               
0054               
0055               pane.cmdb.show.exit:
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059 6B76 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0060 6B78 C2F9  30         mov   *stack+,r11           ; Pop r11
0061 6B7A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0081                       copy  "pane.cmdb.hide.asm"  ; Hide command buffer pane
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
0023 6B7C 0649  14         dect  stack
0024 6B7E C64B  30         mov   r11,*stack            ; Save return address
0025 6B80 0649  14         dect  stack
0026 6B82 C660  46         mov   @parm1,*stack         ; Push @parm1
     6B84 A000     
0027                       ;------------------------------------------------------
0028                       ; Hide command buffer pane
0029                       ;------------------------------------------------------
0030 6B86 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     6B88 A31C     
     6B8A A31A     
0031                       ;------------------------------------------------------
0032                       ; Adjust frame buffer size if error pane visible
0033                       ;------------------------------------------------------
0034 6B8C C820  54         mov   @tv.error.visible,@tv.error.visible
     6B8E A228     
     6B90 A228     
0035 6B92 1302  14         jeq   !
0036 6B94 0620  34         dec   @fb.scrrows
     6B96 A31A     
0037                       ;------------------------------------------------------
0038                       ; Clear error/hint & status line
0039                       ;------------------------------------------------------
0040 6B98 06A0  32 !       bl    @hchar
     6B9A 27E6     
0041 6B9C 1900                   byte pane.botrow-4,0,32,80*3
     6B9E 20F0     
0042 6BA0 1C00                   byte pane.botrow-1,0,32,80*2
     6BA2 20A0     
0043 6BA4 FFFF                   data EOL
0044                       ;------------------------------------------------------
0045                       ; Adjust frame buffer size if ruler visible
0046                       ;------------------------------------------------------
0047 6BA6 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     6BA8 A210     
     6BAA A210     
0048 6BAC 1302  14         jeq   pane.cmdb.hide.rest
0049 6BAE 0620  34         dec   @fb.scrrows
     6BB0 A31A     
0050                       ;------------------------------------------------------
0051                       ; Hide command buffer pane (rest)
0052                       ;------------------------------------------------------
0053               pane.cmdb.hide.rest:
0054 6BB2 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     6BB4 A704     
     6BB6 832A     
0055 6BB8 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     6BBA A702     
0056 6BBC 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6BBE A316     
0057 6BC0 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     6BC2 A222     
0058                       ;------------------------------------------------------
0059                       ; Reload current color scheme
0060                       ;------------------------------------------------------
0061 6BC4 0720  34         seto  @parm1                ; Do not turn screen off while
     6BC6 A000     
0062                                                   ; reloading color scheme
0063 6BC8 04E0  34         clr   @parm2                ; Don't skip colorizing marked lines
     6BCA A002     
0064 6BCC 04E0  34         clr   @parm3                ; Colorize all panes
     6BCE A004     
0065               
0066 6BD0 06A0  32         bl    @pane.action.colorscheme.load
     6BD2 6F86     
0067                                                   ; Reload color scheme
0068                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0069                                                   ; | i  @parm2 = Skip colorizing marked lines
0070                                                   ; |             if >FFFF
0071                                                   ; | i  @parm3 = Only colorize CMDB pane
0072                                                   ; /             if >FFFF
0073                       ;------------------------------------------------------
0074                       ; Show cursor again
0075                       ;------------------------------------------------------
0076 6BD4 06A0  32         bl    @pane.cursor.blink
     6BD6 6F50     
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               pane.cmdb.hide.exit:
0081 6BD8 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6BDA A000     
0082 6BDC C2F9  30         mov   *stack+,r11           ; Pop r11
0083 6BDE 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0082                       copy  "pane.cmdb.draw.asm"  ; Draw command buffer pane contents
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
0024 6BE0 0649  14         dect  stack
0025 6BE2 C64B  30         mov   r11,*stack            ; Save return address
0026 6BE4 0649  14         dect  stack
0027 6BE6 C644  30         mov   tmp0,*stack           ; Push tmp0
0028 6BE8 0649  14         dect  stack
0029 6BEA C645  30         mov   tmp1,*stack           ; Push tmp1
0030                       ;------------------------------------------------------
0031                       ; Command buffer header line
0032                       ;------------------------------------------------------
0033 6BEC C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     6BEE A71C     
     6BF0 A000     
0034 6BF2 0204  20         li    tmp0,80
     6BF4 0050     
0035 6BF6 C804  38         mov   tmp0,@parm2           ; Set requested length
     6BF8 A002     
0036 6BFA 0204  20         li    tmp0,1
     6BFC 0001     
0037 6BFE C804  38         mov   tmp0,@parm3           ; Set character to fill
     6C00 A004     
0038 6C02 0204  20         li    tmp0,rambuf
     6C04 A100     
0039 6C06 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     6C08 A006     
0040               
0041 6C0A 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     6C0C 33E2     
0042                                                   ; \ i  @parm1 = Pointer to string
0043                                                   ; | i  @parm2 = Requested length
0044                                                   ; | i  @parm3 = Fill character
0045                                                   ; | i  @parm4 = Pointer to buffer with
0046                                                   ; /             output string
0047               
0048 6C0E 06A0  32         bl    @cpym2m
     6C10 24EE     
0049 6C12 6FF2                   data txt.stevie,rambuf+68,13
     6C14 A144     
     6C16 000D     
0050                                                   ;
0051                                                   ; Add Stevie banner
0052                                                   ;
0053               
0054 6C18 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     6C1A A70E     
     6C1C 832A     
0055 6C1E C160  34         mov   @outparm1,tmp1        ; | Display pane header
     6C20 A010     
0056 6C22 06A0  32         bl    @xutst0               ; /
     6C24 2434     
0057                       ;------------------------------------------------------
0058                       ; Check dialog id
0059                       ;------------------------------------------------------
0060 6C26 04E0  34         clr   @waux1                ; Default is show prompt
     6C28 833C     
0061               
0062 6C2A C120  34         mov   @cmdb.dialog,tmp0
     6C2C A71A     
0063 6C2E 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     6C30 0063     
0064 6C32 121D  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0065 6C34 0720  34         seto  @waux1                ; /
     6C36 833C     
0066                       ;------------------------------------------------------
0067                       ; Show info message instead of prompt
0068                       ;------------------------------------------------------
0069 6C38 C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     6C3A A71E     
0070 6C3C 1318  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0071               
0072 6C3E C820  54         mov   @cmdb.paninfo,@parm1  ; Get string to display
     6C40 A71E     
     6C42 A000     
0073 6C44 0204  20         li    tmp0,80
     6C46 0050     
0074 6C48 C804  38         mov   tmp0,@parm2           ; Set requested length
     6C4A A002     
0075 6C4C 0204  20         li    tmp0,32
     6C4E 0020     
0076 6C50 C804  38         mov   tmp0,@parm3           ; Set character to fill
     6C52 A004     
0077 6C54 0204  20         li    tmp0,rambuf
     6C56 A100     
0078 6C58 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     6C5A A006     
0079               
0080 6C5C 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     6C5E 33E2     
0081                                                   ; \ i  @parm1 = Pointer to string
0082                                                   ; | i  @parm2 = Requested length
0083                                                   ; | i  @parm3 = Fill character
0084                                                   ; | i  @parm4 = Pointer to buffer with
0085                                                   ; /             output string
0086               
0087 6C60 06A0  32         bl    @at
     6C62 26DA     
0088 6C64 1A00                   byte pane.botrow-3,0  ; Position cursor
0089               
0090 6C66 C160  34         mov   @outparm1,tmp1        ; \ Display pane header
     6C68 A010     
0091 6C6A 06A0  32         bl    @xutst0               ; /
     6C6C 2434     
0092                       ;------------------------------------------------------
0093                       ; Clear lines after prompt in command buffer
0094                       ;------------------------------------------------------
0095               pane.cmdb.draw.clear:
0096 6C6E 06A0  32         bl    @hchar
     6C70 27E6     
0097 6C72 1B00                   byte pane.botrow-2,0,32,80
     6C74 2050     
0098 6C76 FFFF                   data EOL              ; Remove key markers
0099                       ;------------------------------------------------------
0100                       ; Show key markers ?
0101                       ;------------------------------------------------------
0102 6C78 C120  34         mov   @cmdb.panmarkers,tmp0
     6C7A A722     
0103 6C7C 1310  14         jeq   pane.cmdb.draw.hint   ; no, skip key markers
0104                       ;------------------------------------------------------
0105                       ; Loop over key marker list
0106                       ;------------------------------------------------------
0107               pane.cmdb.draw.marker.loop:
0108 6C7E D174  28         movb  *tmp0+,tmp1           ; Get X position
0109 6C80 0985  56         srl   tmp1,8                ; Right align
0110 6C82 0285  22         ci    tmp1,>00ff            ; End of list reached?
     6C84 00FF     
0111 6C86 130B  14         jeq   pane.cmdb.draw.hint   ; Yes, exit loop
0112               
0113 6C88 0265  22         ori   tmp1,(pane.botrow - 2) * 256
     6C8A 1B00     
0114                                                   ; y=bottom row - 3, x=(key marker position)
0115 6C8C C805  38         mov   tmp1,@wyx             ; Set cursor position
     6C8E 832A     
0116               
0117 6C90 0649  14         dect  stack
0118 6C92 C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 6C94 06A0  32         bl    @putstr
     6C96 2432     
0121 6C98 38DC                   data txt.keymarker    ; Show key marker
0122               
0123 6C9A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124                       ;------------------------------------------------------
0125                       ; Show marker
0126                       ;------------------------------------------------------
0127 6C9C 10F0  14         jmp   pane.cmdb.draw.marker.loop
0128                                                   ; Next iteration
0129                       ;------------------------------------------------------
0130                       ; Display pane hint in command buffer
0131                       ;------------------------------------------------------
0132               pane.cmdb.draw.hint:
0133 6C9E 0204  20         li    tmp0,pane.botrow - 1  ; \
     6CA0 001C     
0134 6CA2 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0135 6CA4 C804  38         mov   tmp0,@parm1           ; Set parameter
     6CA6 A000     
0136 6CA8 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     6CAA A720     
     6CAC A002     
0137               
0138 6CAE 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6CB0 6AC6     
0139                                                   ; \ i  parm1 = Pointer to string with hint
0140                                                   ; / i  parm2 = YX position
0141                       ;------------------------------------------------------
0142                       ; Display keys in status line
0143                       ;------------------------------------------------------
0144 6CB2 0204  20         li    tmp0,pane.botrow      ; \
     6CB4 001D     
0145 6CB6 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0146 6CB8 C804  38         mov   tmp0,@parm1           ; Set parameter
     6CBA A000     
0147 6CBC C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     6CBE A724     
     6CC0 A002     
0148               
0149 6CC2 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6CC4 6AC6     
0150                                                   ; \ i  parm1 = Pointer to string with hint
0151                                                   ; / i  parm2 = YX position
0152                       ;------------------------------------------------------
0153                       ; ALPHA-Lock key down?
0154                       ;------------------------------------------------------
0155 6CC6 20A0  38         coc   @wbit10,config
     6CC8 200C     
0156 6CCA 1306  14         jeq   pane.cmdb.draw.alpha.down
0157                       ;------------------------------------------------------
0158                       ; AlPHA-Lock is up
0159                       ;------------------------------------------------------
0160 6CCC 06A0  32         bl    @hchar
     6CCE 27E6     
0161 6CD0 1D4E                   byte pane.botrow,78,32,2
     6CD2 2002     
0162 6CD4 FFFF                   data eol
0163               
0164 6CD6 1004  14         jmp   pane.cmdb.draw.promptcmd
0165                       ;------------------------------------------------------
0166                       ; AlPHA-Lock is down
0167                       ;------------------------------------------------------
0168               pane.cmdb.draw.alpha.down:
0169 6CD8 06A0  32         bl    @putat
     6CDA 2456     
0170 6CDC 1D4E                   byte   pane.botrow,78
0171 6CDE 38D6                   data   txt.alpha.down
0172                       ;------------------------------------------------------
0173                       ; Command buffer content
0174                       ;------------------------------------------------------
0175               pane.cmdb.draw.promptcmd:
0176 6CE0 C120  34         mov   @waux1,tmp0           ; Flag set?
     6CE2 833C     
0177 6CE4 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0178 6CE6 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     6CE8 6D24     
0179                       ;------------------------------------------------------
0180                       ; Exit
0181                       ;------------------------------------------------------
0182               pane.cmdb.draw.exit:
0183 6CEA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0184 6CEC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0185 6CEE C2F9  30         mov   *stack+,r11           ; Pop r11
0186 6CF0 045B  20         b     *r11                  ; Return
                   < stevie_b3.asm.76432
0083                       copy  "error.display.asm"   ; Show error message
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
0018 6CF2 0649  14         dect  stack
0019 6CF4 C64B  30         mov   r11,*stack            ; Save return address
0020 6CF6 0649  14         dect  stack
0021 6CF8 C644  30         mov   tmp0,*stack           ; Push tmp0
0022 6CFA 0649  14         dect  stack
0023 6CFC C645  30         mov   tmp1,*stack           ; Push tmp1
0024 6CFE 0649  14         dect  stack
0025 6D00 C646  30         mov   tmp2,*stack           ; Push tmp2
0026                       ;------------------------------------------------------
0027                       ; Display error message
0028                       ;------------------------------------------------------
0029 6D02 C120  34         mov   @parm1,tmp0           ; \ Get length of string
     6D04 A000     
0030 6D06 D194  26         movb  *tmp0,tmp2            ; |
0031 6D08 0986  56         srl   tmp2,8                ; / Right align
0032               
0033 6D0A C120  34         mov   @parm1,tmp0           ; Get error message
     6D0C A000     
0034 6D0E 0205  20         li    tmp1,tv.error.msg     ; Set error message
     6D10 A22E     
0035               
0036 6D12 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     6D14 24F4     
0037                                                   ; \ i  tmp0 = Source CPU memory address
0038                                                   ; | i  tmp1 = Target CPU memory address
0039                                                   ; / i  tmp2 = Number of bytes to copy
0040               
0041 6D16 06A0  32         bl    @pane.errline.show    ; Display error message
     6D18 6F74     
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               error.display.exit:
0046 6D1A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 6D1C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 6D1E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 6D20 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 6D22 045B  20         b     *r11                  ; Return
                   < stevie_b3.asm.76432
0084                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
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
0022 6D24 0649  14         dect  stack
0023 6D26 C64B  30         mov   r11,*stack            ; Save return address
0024 6D28 0649  14         dect  stack
0025 6D2A C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6D2C 0649  14         dect  stack
0027 6D2E C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6D30 0649  14         dect  stack
0029 6D32 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6D34 0649  14         dect  stack
0031 6D36 C660  46         mov   @wyx,*stack           ; Push cursor position
     6D38 832A     
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 6D3A C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6D3C A710     
     6D3E 832A     
0036               
0037 6D40 05A0  34         inc   @wyx                  ; X +1 for prompt
     6D42 832A     
0038               
0039 6D44 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6D46 240E     
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 6D48 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6D4A A729     
0044 6D4C 0206  20         li    tmp2,1*79             ; Command length
     6D4E 004F     
0045               
0046 6D50 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6D52 24A0     
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 6D54 C820  54         mov   @cmdb.yxprompt,@wyx
     6D56 A710     
     6D58 832A     
0054 6D5A 06A0  32         bl    @putstr
     6D5C 2432     
0055 6D5E 39B0                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 6D60 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     6D62 832A     
0061 6D64 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 6D66 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 6D68 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 6D6A C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6D6C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0085                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0022 6D6E 0649  14         dect  stack
0023 6D70 C64B  30         mov   r11,*stack            ; Save return address
0024 6D72 0649  14         dect  stack
0025 6D74 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6D76 0649  14         dect  stack
0027 6D78 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6D7A 0649  14         dect  stack
0029 6D7C C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 6D7E 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6D80 A728     
0034 6D82 06A0  32         bl    @film                 ; Clear command
     6D84 224A     
0035 6D86 A729                   data  cmdb.cmd,>00,80
     6D88 0000     
     6D8A 0050     
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 6D8C C120  34         mov   @cmdb.yxprompt,tmp0
     6D8E A710     
0040 6D90 0584  14         inc   tmp0
0041 6D92 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6D94 A70A     
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 6D96 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 6D98 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 6D9A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 6D9C C2F9  30         mov   *stack+,r11           ; Pop r11
0050 6D9E 045B  20         b     *r11                  ; Return to caller
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
0075 6DA0 0649  14         dect  stack
0076 6DA2 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 6DA4 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6DA6 2BA8     
0081 6DA8 A729                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6DAA 0000     
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 6DAC C820  54         mov   @waux1,@outparm1     ; Save length of string
     6DAE 833C     
     6DB0 A010     
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 6DB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6DB4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0086                       copy  "cmdb.cmd.set.asm"    ; Set command line to preset value
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
0022 6DB6 0649  14         dect  stack
0023 6DB8 C64B  30         mov   r11,*stack            ; Save return address
0024 6DBA 0649  14         dect  stack
0025 6DBC C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6DBE 0649  14         dect  stack
0027 6DC0 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6DC2 0649  14         dect  stack
0029 6DC4 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 6DC6 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6DC8 A728     
0034 6DCA 06A0  32         bl    @film                 ; Clear command
     6DCC 224A     
0035 6DCE A729                   data  cmdb.cmd,>00,80
     6DD0 0000     
     6DD2 0050     
0036                       ;------------------------------------------------------
0037                       ; Get string length
0038                       ;------------------------------------------------------
0039 6DD4 C120  34         mov   @parm1,tmp0
     6DD6 A000     
0040 6DD8 D1B4  28         movb  *tmp0+,tmp2           ; Get length byte
0041 6DDA 0986  56         srl   tmp2,8                ; Right align
0042 6DDC 1501  14         jgt   !
0043                       ;------------------------------------------------------
0044                       ; Assert: invalid length, we just exit here
0045                       ;------------------------------------------------------
0046 6DDE 100B  14         jmp   cmdb.cmd.set.exit     ; No harm done
0047                       ;------------------------------------------------------
0048                       ; Copy string to command
0049                       ;------------------------------------------------------
0050 6DE0 0205  20 !       li   tmp1,cmdb.cmd          ; Destination
     6DE2 A729     
0051 6DE4 06A0  32         bl   @xpym2m                ; Copy string
     6DE6 24F4     
0052                       ;------------------------------------------------------
0053                       ; Put cursor at beginning of line
0054                       ;------------------------------------------------------
0055 6DE8 C120  34         mov   @cmdb.yxprompt,tmp0
     6DEA A710     
0056 6DEC 0584  14         inc   tmp0
0057 6DEE C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6DF0 A70A     
0058               
0059 6DF2 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     6DF4 A718     
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063               cmdb.cmd.set.exit:
0064 6DF6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0065 6DF8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 6DFA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 6DFC C2F9  30         mov   *stack+,r11           ; Pop r11
0068 6DFE 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0087                       copy  "cmdb.cmd.preset.asm" ; Preset shortcuts in dialogs
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
0018 6E00 0649  14         dect  stack
0019 6E02 C64B  30         mov   r11,*stack            ; Save return address
0020 6E04 0649  14         dect  stack
0021 6E06 C644  30         mov   tmp0,*stack           ; Push tmp0
0022 6E08 0649  14         dect  stack
0023 6E0A C645  30         mov   tmp1,*stack           ; Push tmp1
0024 6E0C 0649  14         dect  stack
0025 6E0E C646  30         mov   tmp2,*stack           ; Push tmp2
0026               
0027 6E10 0204  20         li    tmp0,cmdb.cmd.preset.data
     6E12 758A     
0028                                                   ; Load table
0029               
0030 6E14 C1A0  34         mov   @waux1,tmp2           ; \ Get keyboard code
     6E16 833C     
0031 6E18 0986  56         srl   tmp2,8                ; / Right align
0032                       ;-------------------------------------------------------
0033                       ; Loop over table with presets
0034                       ;-------------------------------------------------------
0035               cmdb.cmd.preset.loop:
0036 6E1A 8834  50         c     *tmp0+,@cmdb.dialog   ; Dialog matches?
     6E1C A71A     
0037 6E1E 1607  14         jne   cmdb.cmd.preset.next  ; No, next entry
0038                       ;-------------------------------------------------------
0039                       ; Dialog matches, check if shortcut matches
0040                       ;-------------------------------------------------------
0041 6E20 81B4  30         c     *tmp0+,tmp2           ; Compare with keyboard shortcut
0042 6E22 1606  14         jne   !                     ; No match, next entry
0043                       ;-------------------------------------------------------
0044                       ; Entry in table matches, set preset
0045                       ;-------------------------------------------------------
0046 6E24 C814  46         mov   *tmp0,@parm1          ; Get pointer to string
     6E26 A000     
0047               
0048 6E28 06A0  32         bl    @cmdb.cmd.set         ; Set command value
     6E2A 6DB6     
0049                                                   ; \ i  @parm1 = Pointer to string w. preset
0050                                                   ; /
0051               
0052 6E2C 1006  14         jmp   cmdb.cmd.preset.exit  ; Exit
0053                       ;-------------------------------------------------------
0054                       ; Dialog does not match, prepare for next entry
0055                       ;-------------------------------------------------------
0056               cmdb.cmd.preset.next:
0057 6E2E 05C4  14         inct  tmp0                  ; Skip shortcut
0058 6E30 05C4  14 !       inct  tmp0                  ; Skip pointer to string
0059                       ;-------------------------------------------------------
0060                       ; End of list reached?
0061                       ;-------------------------------------------------------
0062 6E32 C154  26         mov   *tmp0,tmp1            ; Get entry
0063 6E34 0285  22         ci    tmp1,EOL              ; EOL identifier found?
     6E36 FFFF     
0064 6E38 16F0  14         jne   cmdb.cmd.preset.loop  ; Not yet, next entry
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               cmdb.cmd.preset.exit:
0069 6E3A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 6E3C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 6E3E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 6E40 C2F9  30         mov   *stack+,r11           ; Pop r11
0073 6E42 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
0088                       ;-----------------------------------------------------------------------
0089                       ; Toggle fastmode in Load/Save DV80 dialogs
0090                       ;-----------------------------------------------------------------------
0091                       copy  "fm.fastmode.asm"     ; Turn fastmode on/off for file operation
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
0020 6E44 0649  14         dect  stack
0021 6E46 C64B  30         mov   r11,*stack            ; Save return address
0022 6E48 0649  14         dect  stack
0023 6E4A C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6E4C 0649  14         dect  stack
0025 6E4E C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6E50 0649  14         dect  stack
0027 6E52 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Toggle fastmode
0030                       ;------------------------------------------------------
0031 6E54 C160  34         mov   @cmdb.dialog,tmp1     ; Get ID of current dialog
     6E56 A71A     
0032 6E58 C120  34         mov   @fh.offsetopcode,tmp0 ; Get file opcode offset
     6E5A A44E     
0033 6E5C 1322  14         jeq   fm.fastmode.on        ; Toggle on if offset is 0
0034                       ;------------------------------------------------------
0035                       ; Turn fast mode off
0036                       ;------------------------------------------------------
0037               fm.fastmode.off:
0038 6E5E 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     6E60 A44E     
0039               
0040 6E62 0206  20         li    tmp2,id.dialog.load
     6E64 000A     
0041 6E66 8185  18         c     tmp1,tmp2
0042 6E68 1310  14         jeq   fm.fastmode.off.1
0043               
0044 6E6A 0206  20         li    tmp2,id.dialog.insert
     6E6C 000D     
0045 6E6E 8185  18         c     tmp1,tmp2
0046 6E70 130F  14         jeq   fm.fastmode.off.2
0047               
0048 6E72 0206  20         li    tmp2,id.dialog.clipboard
     6E74 0067     
0049 6E76 8185  18         c     tmp1,tmp2
0050 6E78 130E  14         jeq   fm.fastmode.off.3
0051               
0052 6E7A 0206  20         li    tmp2,id.dialog.append
     6E7C 000E     
0053 6E7E 8185  18         c     tmp1,tmp2
0054 6E80 130D  14         jeq   fm.fastmode.off.4
0055                       ;------------------------------------------------------
0056                       ; Assert
0057                       ;------------------------------------------------------
0058 6E82 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E84 FFCE     
0059 6E86 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E88 2026     
0060                       ;------------------------------------------------------
0061                       ; Keylist fastmode off
0062                       ;------------------------------------------------------
0063               fm.fastmode.off.1:
0064 6E8A 0204  20         li    tmp0,txt.keys.load
     6E8C 7000     
0065 6E8E 102C  14         jmp   fm.fastmode.keylist
0066               fm.fastmode.off.2:
0067 6E90 0204  20         li    tmp0,txt.keys.insert
     6E92 7000     
0068 6E94 1029  14         jmp   fm.fastmode.keylist
0069               fm.fastmode.off.3:
0070 6E96 0204  20         li    tmp0,txt.keys.clipboard
     6E98 725A     
0071 6E9A 1026  14         jmp   fm.fastmode.keylist
0072               fm.fastmode.off.4:
0073 6E9C 0204  20         li    tmp0,txt.keys.append
     6E9E 7000     
0074 6EA0 1023  14         jmp   fm.fastmode.keylist
0075                       ;------------------------------------------------------
0076                       ; Turn fast mode on
0077                       ;------------------------------------------------------
0078               fm.fastmode.on:
0079 6EA2 0204  20         li    tmp0,>40              ; Data buffer in CPU RAM
     6EA4 0040     
0080 6EA6 C804  38         mov   tmp0,@fh.offsetopcode
     6EA8 A44E     
0081               
0082 6EAA 0206  20         li    tmp2,id.dialog.load
     6EAC 000A     
0083 6EAE 8185  18         c     tmp1,tmp2
0084 6EB0 1310  14         jeq   fm.fastmode.on.1
0085               
0086 6EB2 0206  20         li    tmp2,id.dialog.insert
     6EB4 000D     
0087 6EB6 8185  18         c     tmp1,tmp2
0088 6EB8 130F  14         jeq   fm.fastmode.on.2
0089               
0090 6EBA 0206  20         li    tmp2,id.dialog.clipboard
     6EBC 0067     
0091 6EBE 8185  18         c     tmp1,tmp2
0092 6EC0 130E  14         jeq   fm.fastmode.on.3
0093               
0094 6EC2 0206  20         li    tmp2,id.dialog.append
     6EC4 000E     
0095 6EC6 8185  18         c     tmp1,tmp2
0096 6EC8 130D  14         jeq   fm.fastmode.on.4
0097                       ;------------------------------------------------------
0098                       ; Assert
0099                       ;------------------------------------------------------
0100 6ECA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6ECC FFCE     
0101 6ECE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6ED0 2026     
0102                       ;------------------------------------------------------
0103                       ; Keylist fastmode on
0104                       ;------------------------------------------------------
0105               fm.fastmode.on.1:
0106 6ED2 0204  20         li    tmp0,txt.keys.load2
     6ED4 7020     
0107 6ED6 1008  14         jmp   fm.fastmode.keylist
0108               fm.fastmode.on.2:
0109 6ED8 0204  20         li    tmp0,txt.keys.insert2
     6EDA 7020     
0110 6EDC 1005  14         jmp   fm.fastmode.keylist
0111               fm.fastmode.on.3:
0112 6EDE 0204  20         li    tmp0,txt.keys.clipboard2
     6EE0 727E     
0113 6EE2 1002  14         jmp   fm.fastmode.keylist
0114               fm.fastmode.on.4:
0115 6EE4 0204  20         li    tmp0,txt.keys.append2
     6EE6 7020     
0116                       ;------------------------------------------------------
0117                       ; Set keylist
0118                       ;------------------------------------------------------
0119               fm.fastmode.keylist:
0120 6EE8 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6EEA A724     
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               fm.fastmode.exit:
0125 6EEC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 6EEE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 6EF0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 6EF2 C2F9  30         mov   *stack+,r11           ; Pop R11
0129 6EF4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.76432
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
0010 6EF6 0649  14         dect  stack
0011 6EF8 C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Call function in bank 1
0014                       ;------------------------------------------------------
0015 6EFA 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6EFC 3094     
0016 6EFE 6002                   data bank1.rom        ; | i  p0 = bank address
0017 6F00 7FD2                   data vec.10           ; | i  p1 = Vector with target address
0018 6F02 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 6F04 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 6F06 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "edkey.action.cmdb.show"
0028               * bank1 vec.15
0029               ********|*****|*********************|**************************
0030               edkey.action.cmdb.show:
0031 6F08 0649  14         dect  stack
0032 6F0A C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Call function in bank 1
0035                       ;------------------------------------------------------
0036 6F0C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6F0E 3094     
0037 6F10 6002                   data bank1.rom        ; | i  p0 = bank address
0038 6F12 7FDC                   data vec.15           ; | i  p1 = Vector with target address
0039 6F14 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0040                       ;------------------------------------------------------
0041                       ; Exit
0042                       ;------------------------------------------------------
0043 6F16 C2F9  30         mov   *stack+,r11           ; Pop r11
0044 6F18 045B  20         b     *r11                  ; Return to caller
0045               
0046               
0047               ***************************************************************
0048               * Stub for "fb.refresh"
0049               * bank1 vec.20
0050               ********|*****|*********************|**************************
0051               fb.refresh:
0052 6F1A 0649  14         dect  stack
0053 6F1C C64B  30         mov   r11,*stack            ; Save return address
0054                       ;------------------------------------------------------
0055                       ; Call function in bank 1
0056                       ;------------------------------------------------------
0057 6F1E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6F20 3094     
0058 6F22 6002                   data bank1.rom        ; | i  p0 = bank address
0059 6F24 7FE6                   data vec.20           ; | i  p1 = Vector with target address
0060 6F26 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064 6F28 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6F2A 045B  20         b     *r11                  ; Return to caller
0066               
0067               
0068               ***************************************************************
0069               * Stub for "fb.row2line"
0070               * bank1 vec.22
0071               ********|*****|*********************|**************************
0072               fb.row2line:
0073 6F2C 0649  14         dect  stack
0074 6F2E C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Call function in bank 1
0077                       ;------------------------------------------------------
0078 6F30 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6F32 3094     
0079 6F34 6002                   data bank1.rom        ; | i  p0 = bank address
0080 6F36 7FEA                   data vec.22           ; | i  p1 = Vector with target address
0081 6F38 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085 6F3A C2F9  30         mov   *stack+,r11           ; Pop r11
0086 6F3C 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               
0090               ***************************************************************
0091               * Stub for "pane.errline.hide"
0092               * bank1 vec.27
0093               ********|*****|*********************|**************************
0094               pane.errline.hide:
0095 6F3E 0649  14         dect  stack
0096 6F40 C64B  30         mov   r11,*stack            ; Save return address
0097                       ;------------------------------------------------------
0098                       ; Call function in bank 1
0099                       ;------------------------------------------------------
0100 6F42 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6F44 3094     
0101 6F46 6002                   data bank1.rom        ; | i  p0 = bank address
0102 6F48 7FF4                   data vec.27           ; | i  p1 = Vector with target address
0103 6F4A 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0104                       ;------------------------------------------------------
0105                       ; Exit
0106                       ;------------------------------------------------------
0107 6F4C C2F9  30         mov   *stack+,r11           ; Pop r11
0108 6F4E 045B  20         b     *r11                  ; Return to caller
0109               
0110               
0111               
0112               ***************************************************************
0113               * Stub for "pane.cursor.blink"
0114               * bank1 vec.28
0115               ********|*****|*********************|**************************
0116               pane.cursor.blink:
0117 6F50 0649  14         dect  stack
0118 6F52 C64B  30         mov   r11,*stack            ; Save return address
0119                       ;------------------------------------------------------
0120                       ; Call function in bank 1
0121                       ;------------------------------------------------------
0122 6F54 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6F56 3094     
0123 6F58 6002                   data bank1.rom        ; | i  p0 = bank address
0124 6F5A 7FF6                   data vec.28           ; | i  p1 = Vector with target address
0125 6F5C 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0126                       ;------------------------------------------------------
0127                       ; Exit
0128                       ;------------------------------------------------------
0129 6F5E C2F9  30         mov   *stack+,r11           ; Pop r11
0130 6F60 045B  20         b     *r11                  ; Return to caller
0131               
0132               
0133               ***************************************************************
0134               * Stub for "pane.cursor.hide"
0135               * bank1 vec.29
0136               ********|*****|*********************|**************************
0137               pane.cursor.hide:
0138 6F62 0649  14         dect  stack
0139 6F64 C64B  30         mov   r11,*stack            ; Save return address
0140                       ;------------------------------------------------------
0141                       ; Call function in bank 1
0142                       ;------------------------------------------------------
0143 6F66 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6F68 3094     
0144 6F6A 6002                   data bank1.rom        ; | i  p0 = bank address
0145 6F6C 7FF8                   data vec.29           ; | i  p1 = Vector with target address
0146 6F6E 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150 6F70 C2F9  30         mov   *stack+,r11           ; Pop r11
0151 6F72 045B  20         b     *r11                  ; Return to caller
0152               
0153               
0154               ***************************************************************
0155               * Stub for "pane.errline.show"
0156               * bank1 vec.30
0157               ********|*****|*********************|**************************
0158               pane.errline.show:
0159 6F74 0649  14         dect  stack
0160 6F76 C64B  30         mov   r11,*stack            ; Save return address
0161                       ;------------------------------------------------------
0162                       ; Call function in bank 1
0163                       ;------------------------------------------------------
0164 6F78 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6F7A 3094     
0165 6F7C 6002                   data bank1.rom        ; | i  p0 = bank address
0166 6F7E 7FFA                   data vec.30           ; | i  p1 = Vector with target address
0167 6F80 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171 6F82 C2F9  30         mov   *stack+,r11           ; Pop r11
0172 6F84 045B  20         b     *r11                  ; Return to caller
0173               
0174               
0175               ***************************************************************
0176               * Stub for "pane.action.colorscheme.load"
0177               * bank1 vec.31
0178               ********|*****|*********************|**************************
0179               pane.action.colorscheme.load:
0180 6F86 0649  14         dect  stack
0181 6F88 C64B  30         mov   r11,*stack            ; Save return address
0182                       ;------------------------------------------------------
0183                       ; Call function in bank 1
0184                       ;------------------------------------------------------
0185 6F8A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6F8C 3094     
0186 6F8E 6002                   data bank1.rom        ; | i  p0 = bank address
0187 6F90 7FFC                   data vec.31           ; | i  p1 = Vector with target address
0188 6F92 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0189                       ;------------------------------------------------------
0190                       ; Exit
0191                       ;------------------------------------------------------
0192 6F94 C2F9  30         mov   *stack+,r11           ; Pop r11
0193 6F96 045B  20         b     *r11                  ; Return to caller
0194               
0195               
0196               ***************************************************************
0197               * Stub for "fb.scan.fname"
0198               * bank4 vec.5
0199               ********|*****|*********************|**************************
0200               fb.scan.fname:
0201 6F98 0649  14         dect  stack
0202 6F9A C64B  30         mov   r11,*stack            ; Save return address
0203                       ;------------------------------------------------------
0204                       ; Call function in bank 4
0205                       ;------------------------------------------------------
0206 6F9C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6F9E 3094     
0207 6FA0 6008                   data bank4.rom        ; | i  p0 = bank address
0208 6FA2 7FC8                   data vec.5            ; | i  p1 = Vector with target address
0209 6FA4 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0210                       ;------------------------------------------------------
0211                       ; Exit
0212                       ;------------------------------------------------------
0213 6FA6 C2F9  30         mov   *stack+,r11           ; Pop r11
0214 6FA8 045B  20         b     *r11                  ; Return to caller
0215               
0216               
0217               ***************************************************************
0218               
0219               ; TODO Include _trampoline.bank1.ret
0220               ; TODO Refactor stubs for using _trampoline.bank1.ret
                   < stevie_b3.asm.76432
0096                       copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks > 0
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
0013 6FAA 0649  14         dect  stack
0014 6FAC C64B  30         mov   r11,*stack            ; Save return address
0015                       ;------------------------------------------------------
0016                       ; Call function in bank 1
0017                       ;------------------------------------------------------
0018 6FAE 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6FB0 3094     
0019 6FB2 6002                   data bank1.rom        ; | i  p0 = bank address
0020 6FB4 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0021 6FB6 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0022                       ;------------------------------------------------------
0023                       ; Exit
0024                       ;------------------------------------------------------
0025 6FB8 C2F9  30         mov   *stack+,r11           ; Pop r11
0026 6FBA 045B  20         b     *r11                  ; Return to caller
0027               
0029               
0030               
0031               ***************************************************************
0032               * Stub for "mem.sams.set.legacy"
0033               * bank7 vec.1
0034               ********|*****|*********************|**************************
0036               
0037               mem.sams.set.legacy:
0038 6FBC 0649  14         dect  stack
0039 6FBE C64B  30         mov   r11,*stack            ; Save return address
0040                       ;------------------------------------------------------
0041                       ; Dump VDP patterns
0042                       ;------------------------------------------------------
0043 6FC0 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6FC2 3094     
0044 6FC4 600E                   data bank7.rom        ; | i  p0 = bank address
0045 6FC6 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0046 6FC8 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 6FCA C2F9  30         mov   *stack+,r11           ; Pop r11
0051 6FCC 045B  20         b     *r11                  ; Return to caller
0052               
0054               
0055               
0056               ***************************************************************
0057               * Stub for "mem.sams.set.boot"
0058               * bank7 vec.2
0059               ********|*****|*********************|**************************
0061               
0062               mem.sams.set.boot:
0063 6FCE 0649  14         dect  stack
0064 6FD0 C64B  30         mov   r11,*stack            ; Save return address
0065                       ;------------------------------------------------------
0066                       ; Dump VDP patterns
0067                       ;------------------------------------------------------
0068 6FD2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6FD4 3094     
0069 6FD6 600E                   data bank7.rom        ; | i  p0 = bank address
0070 6FD8 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0071 6FDA 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0072                       ;------------------------------------------------------
0073                       ; Exit
0074                       ;------------------------------------------------------
0075 6FDC C2F9  30         mov   *stack+,r11           ; Pop r11
0076 6FDE 045B  20         b     *r11                  ; Return to caller
0077               
0079               
0080               
0081               ***************************************************************
0082               * Stub for "mem.sams.set.stevie"
0083               * bank7 vec.3
0084               ********|*****|*********************|**************************
0086               
0087               mem.sams.set.stevie:
0088 6FE0 0649  14         dect  stack
0089 6FE2 C64B  30         mov   r11,*stack            ; Save return address
0090                       ;------------------------------------------------------
0091                       ; Dump VDP patterns
0092                       ;------------------------------------------------------
0093 6FE4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6FE6 3094     
0094 6FE8 600E                   data bank7.rom        ; | i  p0 = bank address
0095 6FEA 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0096 6FEC 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0097                       ;------------------------------------------------------
0098                       ; Exit
0099                       ;------------------------------------------------------
0100 6FEE C2F9  30         mov   *stack+,r11           ; Pop r11
0101 6FF0 045B  20         b     *r11                  ; Return to caller
0102               
0104               
0105               
0106               
                   < stevie_b3.asm.76432
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
0009 6FF2 2053     txt.stevie         text ' Stevie 1.2M '
     6FF4 7465     
     6FF6 7669     
     6FF8 6520     
     6FFA 312E     
     6FFC 324D     
     6FFE 20       
0010                                  even
0011               txt.keys.default1
0012 7000 1E               byte  30
0013 7001   46             text  'F9-Back  F3-Clear  F5-Fastmode'
     7002 392D     
     7004 4261     
     7006 636B     
     7008 2020     
     700A 4633     
     700C 2D43     
     700E 6C65     
     7010 6172     
     7012 2020     
     7014 4635     
     7016 2D46     
     7018 6173     
     701A 746D     
     701C 6F64     
     701E 65       
0014                       even
0015               
0016               txt.keys.default2
0017 7020 1F               byte  31
0018 7021   46             text  'F9-Back  F3-Clear  *F5-Fastmode'
     7022 392D     
     7024 4261     
     7026 636B     
     7028 2020     
     702A 4633     
     702C 2D43     
     702E 6C65     
     7030 6172     
     7032 2020     
     7034 2A46     
     7036 352D     
     7038 4661     
     703A 7374     
     703C 6D6F     
     703E 6465     
0019                       even
0020               
0021               
0022               ;--------------------------------------------------------------
0023               ; Dialog "Load file"
0024               ;--------------------------------------------------------------
0025 7040 0E01     txt.head.load      byte 14,1,1
     7042 01       
0026 7043   20                        text ' Open file '
     7044 4F70     
     7046 656E     
     7048 2066     
     704A 696C     
     704C 6520     
0027 704E 01                          byte 1
0028               txt.hint.load
0029 704F   1E             byte  30
0030 7050 4769             text  'Give filename of file to open.'
     7052 7665     
     7054 2066     
     7056 696C     
     7058 656E     
     705A 616D     
     705C 6520     
     705E 6F66     
     7060 2066     
     7062 696C     
     7064 6520     
     7066 746F     
     7068 206F     
     706A 7065     
     706C 6E2E     
0031                       even
0032               
0033               
0034      7000     txt.keys.load      equ txt.keys.default1
0035      7020     txt.keys.load2     equ txt.keys.default2
0036               
0037               ;--------------------------------------------------------------
0038               ; Dialog "Save file"
0039               ;--------------------------------------------------------------
0040 706E 0E01     txt.head.save      byte 14,1,1
     7070 01       
0041 7071   20                        text ' Save file '
     7072 5361     
     7074 7665     
     7076 2066     
     7078 696C     
     707A 6520     
0042 707C 01                          byte 1
0043 707D   16     txt.head.save2     byte 22,1,1
     707E 0101     
0044 7080 2053                        text ' Save block to file '
     7082 6176     
     7084 6520     
     7086 626C     
     7088 6F63     
     708A 6B20     
     708C 746F     
     708E 2066     
     7090 696C     
     7092 6520     
0045 7094 01                          byte 1
0046               txt.hint.save
0047 7095   1E             byte  30
0048 7096 4769             text  'Give filename of file to save.'
     7098 7665     
     709A 2066     
     709C 696C     
     709E 656E     
     70A0 616D     
     70A2 6520     
     70A4 6F66     
     70A6 2066     
     70A8 696C     
     70AA 6520     
     70AC 746F     
     70AE 2073     
     70B0 6176     
     70B2 652E     
0049                       even
0050               
0051               txt.keys.save
0052 70B4 11               byte  17
0053 70B5   46             text  'F9-Back  F3-Clear'
     70B6 392D     
     70B8 4261     
     70BA 636B     
     70BC 2020     
     70BE 4633     
     70C0 2D43     
     70C2 6C65     
     70C4 6172     
0054                       even
0055               
0056               
0057               
0058               ;--------------------------------------------------------------
0059               ; Dialog "Append file"
0060               ;--------------------------------------------------------------
0061 70C6 1001     txt.head.append    byte 16,1,1
     70C8 01       
0062 70C9   20                        text ' Append file '
     70CA 4170     
     70CC 7065     
     70CE 6E64     
     70D0 2066     
     70D2 696C     
     70D4 6520     
0063 70D6 01                          byte 1
0064               txt.hint.append
0065 70D7   3F             byte  63
0066 70D8 4769             text  'Give filename of file to append at the end of the current file.'
     70DA 7665     
     70DC 2066     
     70DE 696C     
     70E0 656E     
     70E2 616D     
     70E4 6520     
     70E6 6F66     
     70E8 2066     
     70EA 696C     
     70EC 6520     
     70EE 746F     
     70F0 2061     
     70F2 7070     
     70F4 656E     
     70F6 6420     
     70F8 6174     
     70FA 2074     
     70FC 6865     
     70FE 2065     
     7100 6E64     
     7102 206F     
     7104 6620     
     7106 7468     
     7108 6520     
     710A 6375     
     710C 7272     
     710E 656E     
     7110 7420     
     7112 6669     
     7114 6C65     
     7116 2E       
0067                       even
0068               
0069               
0070      7000     txt.keys.append    equ txt.keys.default1
0071      7020     txt.keys.append2   equ txt.keys.default2
0072               
0073               
0074               ;--------------------------------------------------------------
0075               ; Dialog "Insert file"
0076               ;--------------------------------------------------------------
0077 7118 1801     txt.head.insert    byte 24,1,1
     711A 01       
0078 711B   20                        text ' Insert file at line '
     711C 496E     
     711E 7365     
     7120 7274     
     7122 2066     
     7124 696C     
     7126 6520     
     7128 6174     
     712A 206C     
     712C 696E     
     712E 6520     
0079 7130 01                          byte 1
0080               txt.hint.insert
0081 7131   20             byte  32
0082 7132 4769             text  'Give filename of file to insert.'
     7134 7665     
     7136 2066     
     7138 696C     
     713A 656E     
     713C 616D     
     713E 6520     
     7140 6F66     
     7142 2066     
     7144 696C     
     7146 6520     
     7148 746F     
     714A 2069     
     714C 6E73     
     714E 6572     
     7150 742E     
0083                       even
0084               
0085               
0086      7000     txt.keys.insert    equ txt.keys.default1
0087      7020     txt.keys.insert2   equ txt.keys.default2
0088               
0089               
0090               ;--------------------------------------------------------------
0091               ; Dialog "Configure clipboard device"
0092               ;--------------------------------------------------------------
0093 7152 1F01     txt.head.clipdev   byte 31,1,1
     7154 01       
0094 7155   20                        text ' Configure clipboard device '
     7156 436F     
     7158 6E66     
     715A 6967     
     715C 7572     
     715E 6520     
     7160 636C     
     7162 6970     
     7164 626F     
     7166 6172     
     7168 6420     
     716A 6465     
     716C 7669     
     716E 6365     
     7170 20       
0095 7171   01                        byte 1
0096               txt.hint.clipdev
0097 7172 2D               byte  45
0098 7173   47             text  'Give device and filename prefix of clipboard.'
     7174 6976     
     7176 6520     
     7178 6465     
     717A 7669     
     717C 6365     
     717E 2061     
     7180 6E64     
     7182 2066     
     7184 696C     
     7186 656E     
     7188 616D     
     718A 6520     
     718C 7072     
     718E 6566     
     7190 6978     
     7192 206F     
     7194 6620     
     7196 636C     
     7198 6970     
     719A 626F     
     719C 6172     
     719E 642E     
0099                       even
0100               
0101               txt.keys.clipdev
0102 71A0 42               byte  66
0103 71A1   46             text  'F9-Back  F3-Clear  ^A=DSK1.CLIP  ^B=DSK8.CLIP  ^C=TIPI.STEVIE.CLIP'
     71A2 392D     
     71A4 4261     
     71A6 636B     
     71A8 2020     
     71AA 4633     
     71AC 2D43     
     71AE 6C65     
     71B0 6172     
     71B2 2020     
     71B4 5E41     
     71B6 3D44     
     71B8 534B     
     71BA 312E     
     71BC 434C     
     71BE 4950     
     71C0 2020     
     71C2 5E42     
     71C4 3D44     
     71C6 534B     
     71C8 382E     
     71CA 434C     
     71CC 4950     
     71CE 2020     
     71D0 5E43     
     71D2 3D54     
     71D4 4950     
     71D6 492E     
     71D8 5354     
     71DA 4556     
     71DC 4945     
     71DE 2E43     
     71E0 4C49     
     71E2 50       
0104                       even
0105               
0106               
0107               
0108               ;--------------------------------------------------------------
0109               ; Dialog "Copy clipboard"
0110               ;--------------------------------------------------------------
0111 71E4 1B01     txt.head.clipboard byte 27,1,1
     71E6 01       
0112 71E7   20                        text ' Copy clipboard to line '
     71E8 436F     
     71EA 7079     
     71EC 2063     
     71EE 6C69     
     71F0 7062     
     71F2 6F61     
     71F4 7264     
     71F6 2074     
     71F8 6F20     
     71FA 6C69     
     71FC 6E65     
     71FE 20       
0113 71FF   01                        byte 1
0114               txt.info.clipboard
0115 7200 10               byte  16
0116 7201   43             text  'Clipboard [1-5]?'
     7202 6C69     
     7204 7062     
     7206 6F61     
     7208 7264     
     720A 205B     
     720C 312D     
     720E 355D     
     7210 3F       
0117                       even
0118               
0119               txt.hint.clipboard
0120 7212 47               byte  71
0121 7213   50             text  'Press 1 to 5 to copy clipboard, press F7 to configure clipboard device.'
     7214 7265     
     7216 7373     
     7218 2031     
     721A 2074     
     721C 6F20     
     721E 3520     
     7220 746F     
     7222 2063     
     7224 6F70     
     7226 7920     
     7228 636C     
     722A 6970     
     722C 626F     
     722E 6172     
     7230 642C     
     7232 2070     
     7234 7265     
     7236 7373     
     7238 2046     
     723A 3720     
     723C 746F     
     723E 2063     
     7240 6F6E     
     7242 6669     
     7244 6775     
     7246 7265     
     7248 2063     
     724A 6C69     
     724C 7062     
     724E 6F61     
     7250 7264     
     7252 2064     
     7254 6576     
     7256 6963     
     7258 652E     
0122                       even
0123               
0124               
0125               txt.keys.clipboard
0126 725A 22               byte  34
0127 725B   46             text  'F9-Back  F5-Fastmode  F7-Configure'
     725C 392D     
     725E 4261     
     7260 636B     
     7262 2020     
     7264 4635     
     7266 2D46     
     7268 6173     
     726A 746D     
     726C 6F64     
     726E 6520     
     7270 2046     
     7272 372D     
     7274 436F     
     7276 6E66     
     7278 6967     
     727A 7572     
     727C 65       
0128                       even
0129               
0130               txt.keys.clipboard2
0131 727E 23               byte  35
0132 727F   46             text  'F9-Back  *F5-Fastmode  F7-Configure'
     7280 392D     
     7282 4261     
     7284 636B     
     7286 2020     
     7288 2A46     
     728A 352D     
     728C 4661     
     728E 7374     
     7290 6D6F     
     7292 6465     
     7294 2020     
     7296 4637     
     7298 2D43     
     729A 6F6E     
     729C 6669     
     729E 6775     
     72A0 7265     
0133                       even
0134               
0135               
0136               
0137               ;--------------------------------------------------------------
0138               ; Dialog "Print file"
0139               ;--------------------------------------------------------------
0140 72A2 0F01     txt.head.print     byte 15,1,1
     72A4 01       
0141 72A5   20                        text ' Print file '
     72A6 5072     
     72A8 696E     
     72AA 7420     
     72AC 6669     
     72AE 6C65     
     72B0 20       
0142 72B1   01                        byte 1
0143 72B2 1001     txt.head.print2    byte 16,1,1
     72B4 01       
0144 72B5   20                        text ' Print block '
     72B6 5072     
     72B8 696E     
     72BA 7420     
     72BC 626C     
     72BE 6F63     
     72C0 6B20     
0145 72C2 01                          byte 1
0146               txt.hint.print
0147 72C3   2B             byte  43
0148 72C4 4769             text  'Give printer device name (PIO, PI.PIO, ...)'
     72C6 7665     
     72C8 2070     
     72CA 7269     
     72CC 6E74     
     72CE 6572     
     72D0 2064     
     72D2 6576     
     72D4 6963     
     72D6 6520     
     72D8 6E61     
     72DA 6D65     
     72DC 2028     
     72DE 5049     
     72E0 4F2C     
     72E2 2050     
     72E4 492E     
     72E6 5049     
     72E8 4F2C     
     72EA 202E     
     72EC 2E2E     
     72EE 29       
0149                       even
0150               
0151               txt.keys.print
0152 72F0 11               byte  17
0153 72F1   46             text  'F9-Back  F3-Clear'
     72F2 392D     
     72F4 4261     
     72F6 636B     
     72F8 2020     
     72FA 4633     
     72FC 2D43     
     72FE 6C65     
     7300 6172     
0154                       even
0155               
0156               
0157               ;--------------------------------------------------------------
0158               ; Dialog "Unsaved changes"
0159               ;--------------------------------------------------------------
0160 7302 1401     txt.head.unsaved   byte 20,1,1
     7304 01       
0161 7305   20                        text ' Unsaved changes '
     7306 556E     
     7308 7361     
     730A 7665     
     730C 6420     
     730E 6368     
     7310 616E     
     7312 6765     
     7314 7320     
0162 7316 01                          byte 1
0163               txt.info.unsaved
0164 7317   21             byte  33
0165 7318 5761             text  'Warning! Unsaved changes in file.'
     731A 726E     
     731C 696E     
     731E 6721     
     7320 2055     
     7322 6E73     
     7324 6176     
     7326 6564     
     7328 2063     
     732A 6861     
     732C 6E67     
     732E 6573     
     7330 2069     
     7332 6E20     
     7334 6669     
     7336 6C65     
     7338 2E       
0166                       even
0167               
0168               txt.hint.unsaved
0169 733A 37               byte  55
0170 733B   50             text  'Press F6 or SPACE to proceed. Press ENTER to save file.'
     733C 7265     
     733E 7373     
     7340 2046     
     7342 3620     
     7344 6F72     
     7346 2053     
     7348 5041     
     734A 4345     
     734C 2074     
     734E 6F20     
     7350 7072     
     7352 6F63     
     7354 6565     
     7356 642E     
     7358 2050     
     735A 7265     
     735C 7373     
     735E 2045     
     7360 4E54     
     7362 4552     
     7364 2074     
     7366 6F20     
     7368 7361     
     736A 7665     
     736C 2066     
     736E 696C     
     7370 652E     
0171                       even
0172               
0173               txt.keys.unsaved
0174 7372 25               byte  37
0175 7373   46             text  'F9-Back  F6/SPACE-Proceed  ENTER-Save'
     7374 392D     
     7376 4261     
     7378 636B     
     737A 2020     
     737C 4636     
     737E 2F53     
     7380 5041     
     7382 4345     
     7384 2D50     
     7386 726F     
     7388 6365     
     738A 6564     
     738C 2020     
     738E 454E     
     7390 5445     
     7392 522D     
     7394 5361     
     7396 7665     
0176                       even
0177               
0178               
0179               ;--------------------------------------------------------------
0180               ; Dialog "Help"
0181               ;--------------------------------------------------------------
0182 7398 0901     txt.head.about     byte 9,1,1
     739A 01       
0183 739B   20                        text ' Help '
     739C 4865     
     739E 6C70     
     73A0 20       
0184 73A1   01                        byte 1
0185               
0186               txt.info.about
0187 73A2 02               byte  2
0188 73A3   00             text  ''
0189                       even
0190               
0191               txt.hint.about
0192 73A4 26               byte  38
0193 73A5   50             text  'Press F9 or ENTER to return to editor.'
     73A6 7265     
     73A8 7373     
     73AA 2046     
     73AC 3920     
     73AE 6F72     
     73B0 2045     
     73B2 4E54     
     73B4 4552     
     73B6 2074     
     73B8 6F20     
     73BA 7265     
     73BC 7475     
     73BE 726E     
     73C0 2074     
     73C2 6F20     
     73C4 6564     
     73C6 6974     
     73C8 6F72     
     73CA 2E       
0194                       even
0195               
0196               txt.keys.about
0197 73CC 13               byte  19
0198 73CD   46             text  'F9-Back  ENTER-Back'
     73CE 392D     
     73D0 4261     
     73D2 636B     
     73D4 2020     
     73D6 454E     
     73D8 5445     
     73DA 522D     
     73DC 4261     
     73DE 636B     
0199                       even
0200               
0201               txt.about.build
0202 73E0 4C               byte  76
0203 73E1   42             text  'Build: 211229-2057130 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
     73E2 7569     
     73E4 6C64     
     73E6 3A20     
     73E8 3231     
     73EA 3132     
     73EC 3239     
     73EE 2D32     
     73F0 3035     
     73F2 3731     
     73F4 3330     
     73F6 202F     
     73F8 2032     
     73FA 3031     
     73FC 382D     
     73FE 3230     
     7400 3231     
     7402 2046     
     7404 696C     
     7406 6970     
     7408 2056     
     740A 616E     
     740C 2056     
     740E 6F6F     
     7410 7265     
     7412 6E20     
     7414 2F20     
     7416 7265     
     7418 7472     
     741A 6F63     
     741C 6C6F     
     741E 7564     
     7420 7320     
     7422 6F6E     
     7424 2041     
     7426 7461     
     7428 7269     
     742A 6167     
     742C 65       
0204                       even
0205               
0206               
0207               
0208               ;--------------------------------------------------------------
0209               ; Dialog "Main Menu"
0210               ;--------------------------------------------------------------
0211 742E 0E01     txt.head.menu      byte 14,1,1
     7430 01       
0212 7431   20                        text ' Main Menu '
     7432 4D61     
     7434 696E     
     7436 204D     
     7438 656E     
     743A 7520     
0213 743C 01                          byte 1
0214               
0215               txt.info.menu
0216 743D   1E             byte  30
0217 743E 4669             text  'File   Cartridge   Help   Quit'
     7440 6C65     
     7442 2020     
     7444 2043     
     7446 6172     
     7448 7472     
     744A 6964     
     744C 6765     
     744E 2020     
     7450 2048     
     7452 656C     
     7454 7020     
     7456 2020     
     7458 5175     
     745A 6974     
0218                       even
0219               
0220 745C 0007     pos.info.menu      byte 0,7,19,26,>ff
     745E 131A     
     7460 FF       
0221               txt.hint.menu
0222 7461   01             byte  1
0223 7462 20               text  ' '
0224                       even
0225               
0226               txt.keys.menu
0227 7464 07               byte  7
0228 7465   46             text  'F9-Back'
     7466 392D     
     7468 4261     
     746A 636B     
0229                       even
0230               
0231               
0232               
0233               ;--------------------------------------------------------------
0234               ; Dialog "File"
0235               ;--------------------------------------------------------------
0236 746C 0901     txt.head.file      byte 9,1,1
     746E 01       
0237 746F   20                        text ' File '
     7470 4669     
     7472 6C65     
     7474 20       
0238 7475   01                        byte 1
0239               
0240               txt.info.file
0241 7476 25               byte  37
0242 7477   4E             text  'New   Open   Save   Print   Configure'
     7478 6577     
     747A 2020     
     747C 204F     
     747E 7065     
     7480 6E20     
     7482 2020     
     7484 5361     
     7486 7665     
     7488 2020     
     748A 2050     
     748C 7269     
     748E 6E74     
     7490 2020     
     7492 2043     
     7494 6F6E     
     7496 6669     
     7498 6775     
     749A 7265     
0243                       even
0244               
0245 749C 0006     pos.info.file      byte 0,6,13,20,28,>ff
     749E 0D14     
     74A0 1CFF     
0246               txt.hint.file
0247 74A2 01               byte  1
0248 74A3   20             text  ' '
0249                       even
0250               
0251               txt.keys.file
0252 74A4 07               byte  7
0253 74A5   46             text  'F9-Back'
     74A6 392D     
     74A8 4261     
     74AA 636B     
0254                       even
0255               
0256               
0257               
0258               ;--------------------------------------------------------------
0259               ; Dialog "Cartridge"
0260               ;--------------------------------------------------------------
0261 74AC 0E01     txt.head.cartridge byte 14,1,1
     74AE 01       
0262 74AF   20                        text ' Cartridge '
     74B0 4361     
     74B2 7274     
     74B4 7269     
     74B6 6467     
     74B8 6520     
0263 74BA 01                          byte 1
0264               
0265               txt.info.cartridge
0266 74BB   16             byte  22
0267 74BC 4261             text  'Basic   Extended Basic'
     74BE 7369     
     74C0 6320     
     74C2 2020     
     74C4 4578     
     74C6 7465     
     74C8 6E64     
     74CA 6564     
     74CC 2042     
     74CE 6173     
     74D0 6963     
0268                       even
0269               
0270 74D2 0008     pos.info.cartridge byte 0,8,>ff
     74D4 FF       
0271               txt.hint.cartridge
0272 74D5   18             byte  24
0273 74D6 5365             text  'Select cartridge to run.'
     74D8 6C65     
     74DA 6374     
     74DC 2063     
     74DE 6172     
     74E0 7472     
     74E2 6964     
     74E4 6765     
     74E6 2074     
     74E8 6F20     
     74EA 7275     
     74EC 6E2E     
0274                       even
0275               
0276               txt.keys.cartridge
0277 74EE 07               byte  7
0278 74EF   46             text  'F9-Back'
     74F0 392D     
     74F2 4261     
     74F4 636B     
0279                       even
0280               
0281               
0282               
0283               ;--------------------------------------------------------------
0284               ; Dialog "Basic"
0285               ;--------------------------------------------------------------
0286 74F6 0E01     txt.head.basic     byte 14,1,1
     74F8 01       
0287 74F9   20                        text ' Run Basic '
     74FA 5275     
     74FC 6E20     
     74FE 4261     
     7500 7369     
     7502 6320     
0288 7504 01                          byte 1
0289               
0290               txt.info.basic
0291 7505   10             byte  16
0292 7506 5365             text  'Session: 1 2 3 4'
     7508 7373     
     750A 696F     
     750C 6E3A     
     750E 2031     
     7510 2032     
     7512 2033     
     7514 2034     
0293                       even
0294               
0295 7516 09FF     pos.info.basic     byte 9,>ff
0296               txt.hint.basic
0297 7518 3A               byte  58
0298 7519   50             text  'Pick a session. Press F9 in Basic for returning to Stevie.'
     751A 6963     
     751C 6B20     
     751E 6120     
     7520 7365     
     7522 7373     
     7524 696F     
     7526 6E2E     
     7528 2050     
     752A 7265     
     752C 7373     
     752E 2046     
     7530 3920     
     7532 696E     
     7534 2042     
     7536 6173     
     7538 6963     
     753A 2066     
     753C 6F72     
     753E 2072     
     7540 6574     
     7542 7572     
     7544 6E69     
     7546 6E67     
     7548 2074     
     754A 6F20     
     754C 5374     
     754E 6576     
     7550 6965     
     7552 2E       
0299                       even
0300               
0301               txt.keys.basic
0302 7554 07               byte  7
0303 7555   46             text  'F9-Back'
     7556 392D     
     7558 4261     
     755A 636B     
0304                       even
0305               
0306               txt.keys.basic2
0307 755C 07               byte  7
0308 755D   46             text  'F9-Back'
     755E 392D     
     7560 4261     
     7562 636B     
0309                       even
0310               
0311               
0312               
0313               ;--------------------------------------------------------------
0314               ; Dialog "Configure"
0315               ;--------------------------------------------------------------
0316 7564 0E01     txt.head.config    byte 14,1,1
     7566 01       
0317 7567   20                        text ' Configure '
     7568 436F     
     756A 6E66     
     756C 6967     
     756E 7572     
     7570 6520     
0318 7572 01                          byte 1
0319               
0320               txt.info.config
0321 7573   09             byte  9
0322 7574 436C             text  'Clipboard'
     7576 6970     
     7578 626F     
     757A 6172     
     757C 64       
0323                       even
0324               
0325 757E 00FF     pos.info.config    byte 0,>ff
0326               txt.hint.config
0327 7580 01               byte  1
0328 7581   20             text  ' '
0329                       even
0330               
0331               txt.keys.config
0332 7582 07               byte  7
0333 7583   46             text  'F9-Back'
     7584 392D     
     7586 4261     
     7588 636B     
0334                       even
0335               
                   < stevie_b3.asm.76432
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
0011 758A 0011             data  id.dialog.clipdev,key.ctrl.a,def.clip.fname
     758C 0081     
     758E 39C8     
0012 7590 0011             data  id.dialog.clipdev,key.ctrl.b,def.clip.fname.b
     7592 0082     
     7594 39D2     
0013 7596 0011             data  id.dialog.clipdev,key.ctrl.c,def.clip.fname.C
     7598 0083     
     759A 39DC     
0014                       ;------------------------------------------------------
0015                       ; End of list
0016                       ;-------------------------------------------------------
0017 759C FFFF             data  EOL                   ; EOL
                   < stevie_b3.asm.76432
0102                       ;-----------------------------------------------------------------------
0103                       ; Bank full check
0104                       ;-----------------------------------------------------------------------
0108                       ;-----------------------------------------------------------------------
0109                       ; Show ROM bank in CPU crash screen
0110                       ;-----------------------------------------------------------------------
0111               cpu.crash.showbank:
0112                       aorg >7fb0
0113 7FB0 06A0  32         bl    @putat
     7FB2 2456     
0114 7FB4 0314                   byte 3,20
0115 7FB6 7FBA                   data cpu.crash.showbank.bankstr
0116 7FB8 10FF  14         jmp   $
0117               cpu.crash.showbank.bankstr:
0118               
0119 7FBA 0D               byte  13
0120 7FBB   52             text  'ROM#3'
     7FBC 4F4D     
     7FBE 2333     
0121                       even
0122               
0123                       ;-----------------------------------------------------------------------
0124                       ; Vector table
0125                       ;-----------------------------------------------------------------------
0126                       aorg  bankx.vectab
0127                       copy  "rom.vectors.bank3.asm"
     **** ****     > rom.vectors.bank3.asm
0001               * FILE......: rom.vectors.bank3.asm
0002               * Purpose...: Bank 3 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 608C     vec.1   data  dialog.help           ; Dialog "About"
0008 7FC2 66C4     vec.2   data  dialog.load           ; Dialog "Load file"
0009 7FC4 6736     vec.3   data  dialog.save           ; Dialog "Save file"
0010 7FC6 6884     vec.4   data  dialog.insert         ; Dialog "Insert file at line ..."
0011 7FC8 67AE     vec.5   data  dialog.print          ; Dialog "Print file"
0012 7FCA 6640     vec.6   data  dialog.file           ; Dialog "File"
0013 7FCC 6A46     vec.7   data  dialog.unsaved        ; Dialog "Unsaved changes"
0014 7FCE 69B8     vec.8   data  dialog.clipboard      ; Dialog "Copy clipboard to line ..."
0015 7FD0 696C     vec.9   data  dialog.clipdev        ; Dialog "Configure clipboard device"
0016 7FD2 692A     vec.10  data  dialog.config         ; Dialog "Configure"
0017 7FD4 681E     vec.11  data  dialog.append         ; Dialog "Append file"
0018 7FD6 6682     vec.12  data  dialog.cartridge      ; Dialog "Cartridge"
0019 7FD8 6A84     vec.13  data  dialog.basic          ; Dialog "Basic"
0020 7FDA 2026     vec.14  data  cpu.crash             ;
0021 7FDC 2026     vec.15  data  cpu.crash             ;
0022 7FDE 2026     vec.16  data  cpu.crash             ;
0023 7FE0 2026     vec.17  data  cpu.crash             ;
0024 7FE2 6CF2     vec.18  data  error.display         ; Show error message
0025 7FE4 6AC6     vec.19  data  pane.show_hintx       ; Show or hide hint (register version)
0026 7FE6 6B30     vec.20  data  pane.cmdb.show        ; Show command buffer pane (=dialog)
0027 7FE8 6B7C     vec.21  data  pane.cmdb.hide        ; Hide command buffer pane
0028 7FEA 6BE0     vec.22  data  pane.cmdb.draw        ; Draw content in command
0029 7FEC 2026     vec.23  data  cpu.crash             ;
0030 7FEE 6D24     vec.24  data  cmdb.refresh          ;
0031 7FF0 6D6E     vec.25  data  cmdb.cmd.clear        ;
0032 7FF2 6DA0     vec.26  data  cmdb.cmd.getlength    ;
0033 7FF4 6E00     vec.27  data  cmdb.cmd.preset       ;
0034 7FF6 6DB6     vec.28  data  cmdb.cmd.set          ;
0035 7FF8 2026     vec.29  data  cpu.crash             ;
0036 7FFA 604A     vec.30  data  dialog.menu           ; Dialog "Main Menu"
0037 7FFC 2026     vec.31  data  cpu.crash             ;
0038 7FFE 6E44     vec.32  data  fm.fastmode           ; Toggle fastmode on/off in Load dialog
                   < stevie_b3.asm.76432
0128                                                   ; Vector table bank 3
0129               
0130               
0131               *--------------------------------------------------------------
0132               * Video mode configuration
0133               *--------------------------------------------------------------
0134      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0135      0004     spfbck  equ   >04                   ; Screen background color.
0136      3622     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0137      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0138      0050     colrow  equ   80                    ; Columns per row
0139      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0140      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0141      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0142      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
